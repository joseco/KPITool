/* 
	Updates de the KPIDB database to version 1.14.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.14.0'

Use [KPIDB]
GO
PRINT 'Verifying database version'

/*
 * Verify that we are using the right database version
 */

IF  NOT ((EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetVersionMajor]') AND type in (N'P', N'PC'))) 
	AND 
	(EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetVersionMinor]') AND type in (N'P', N'PC'))))
		RAISERROR('KPIDB database has not been initialized.  Cant find version stored procedures',16,127)


declare @smiMajor smallint 
declare @smiMinor smallint

exec [dbo].[usp_GetVersionMajor] @smiMajor output
exec [dbo].[usp_GetVersionMinor] @smiMinor output

IF NOT (@smiMajor = 1 AND @smiMinor = 13) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.13 This program only applies to version 1.13',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

--===================================================================================================

USE [KPIDB]
GO

ALTER TABLE [dbo].[tbl_Organization] ADD
	deleted bit NOT NULL CONSTRAINT DF_tbl_Organization_deleted DEFAULT 0,
	dateDeleted datetime NULL,
	usernameDeleted varchar(50) NULL
GO

ALTER TABLE [dbo].[tbl_Project] ADD
	deleted bit NOT NULL CONSTRAINT DF_tbl_Project_deleted DEFAULT 0,
	dateDeleted datetime NULL,
	usernameDeleted varchar(50) NULL
GO

ALTER TABLE [dbo].[tbl_People] ADD
	deleted bit NOT NULL CONSTRAINT DF_tbl_People_deleted DEFAULT 0,
	dateDeleted datetime NULL,
	usernameDeleted varchar(50) NULL
GO

ALTER TABLE [dbo].[tbl_Activity] ADD
	deleted bit NOT NULL CONSTRAINT DF_tbl_Activity_deleted DEFAULT 0,
	dateDeleted datetime NULL,
	usernameDeleted varchar(50) NULL
GO

ALTER TABLE [dbo].[tbl_Kpi] ADD
	deleted bit NOT NULL CONSTRAINT DF_tbl_Kpi_deleted DEFAULT 0,
	dateDeleted datetime NULL,
	usernameDeleted varchar(50) NULL
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetOrganizationsByUser]    Script Date: 06/14/2016 13:15:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 27 2016
-- Description:	List organizations by user
-- =============================================
ALTER PROCEDURE [dbo].[usp_ORG_GetOrganizationsByUser] 
	@varUsername VARCHAR(50),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblOrganization
		(organizationId INT)

	INSERT INTO #tblOrganization
	EXEC [dbo].[usp_ORG_GetOrganizationListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = '	SELECT DISTINCT [o].[organizationID], [o].[name],
	                       CASE WHEN ISNULL([p].[objectActionID],'''') = ''OWN'' THEN 1 ELSE 0 END isOwner
					FROM [dbo].[tbl_Organization] [o]
					INNER JOIN #tblOrganization [t] ON [o].[organizationID] = [t].[organizationId]
					LEFT JOIN [dbo].[tbl_SEG_ObjectPermissions] [p] ON [o].[organizationID] = [p].[objectID] 
					      AND [p].[objectTypeID] = ''ORGANIZATION''
					      AND [p].[username] = ''' + @varUsername + '''
					WHERE ' + @varWhereClause + '
					ORDER BY [o].[name]'
	
	EXEC (@varSQL)
	
	DROP TABLE #tblOrganization

END
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_DeleteOrganization]    Script Date: 06/17/2016 11:24:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Delete an organization, an all of the related objects
--				
-- =============================================
ALTER PROCEDURE [dbo].[usp_ORG_DeleteOrganization]
	@organizationID int,
	@username varchar(50)
AS
BEGIN
	
	UPDATE [dbo].[tbl_Organization]
	   SET [deleted] = 1
		  ,[dateDeleted] = GETDATE()
		  ,[usernameDeleted] = @username
	 WHERE [organizationID] = @organizationID
	
END
GO

--=====================================================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Delete an organization, an all of the related objects
--				
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_DeletePermanentlyOrganization]
	@organizationID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION DeleteOrganization;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- We basically have to delete everything related to that organization.
		
		-- Start with KPIs. 
		-- Get the IDs of all the KPIs we will delete
		DECLARE @KPITable as TABLE (kpiID int)
		INSERT INTO @KPITable
		SELECT [kpiID] from [dbo].[tbl_KPI]
		where [organizationID] = @organizationID

		-- Delete all measurements for the KPIs selected

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		-- Delete the KPIs selected
		-- Now lets delete all people for the organization
		-- Get the IDs of all the people we will delete
		-- Delete all the permissios for these persons
		-- Delete the people

		-- Now lets delete all activities for the organization
		-- Get the IDs of all the activities we will delete
		-- Delete all the permissios for these activities
		-- Delete the activities

		-- Now lets delete all projects for the organization
		-- Get the IDs of all the projects we will delete
		-- Delete all the projects for these activities
		-- Delete the projects

		-- Now lets delete all areas for the organization

		-- Now lets delete the permissions for the organization

		-- And finally lets delete the organization

		-- =============================================================
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION'
		AND   [objectID] = @organizationID
		
		DELETE FROM [dbo].[tbl_KPI]
		WHERE [organizationID] = @organizationID
		
		DELETE FROM [dbo].[tbl_Activity]
		WHERE [organizationID] = @organizationID
		
		DELETE FROM [dbo].[tbl_Project]
		WHERE [organizationID] = @organizationID
		
		DELETE FROM [dbo].[tbl_People]
		WHERE [organizationID] = @organizationID
		
		DELETE FROM [dbo].[tbl_Area]
		WHERE [organizationID] = @organizationID
		
		DELETE FROM dbo.tbl_Organization
		WHERE organizationID = @organizationID
		-- =============================================================

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION DeleteOrganization;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END
GO

--======================================================================================================

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetOrganizationListForUser]    Script Date: 06/17/2016 11:29:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of Organizations that user has view rights to
-- =============================================================
ALTER PROCEDURE [dbo].[usp_ORG_GetOrganizationListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @orgList as TABLE(organizationID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of organizations to those ORGs.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ORGs all of these that are directly associated 
	--   to the organization
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the ORG list all of the ORGs 
	--   that are associated to these PROJs.
	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ORG list all of the ORGs that are 
	--   associated to these ACT.
	--5. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the ORG list all of the ORGs that are associated to those 
	--   PPL.
	--6. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ORG list all of the ORGs that are associated to the ACT.
	--7. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ORG list all of the ORGs that are associated to those
	--   PROJ.
	--8. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the ORG list the ORGs that are associated to these ACT.
	--9. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the ORG list all of the ORGs that are associated to these PPL.
	--10. Add to the ORG list all of the KPIs that are public VIEW_KPI
	--11.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of organizations to those ORGs.

	insert into @orgList
	select [organizationID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_Organization]
	where [deleted] = 0
	  and [organizationID] in (
								select [objectID]
								from [dbo].[tbl_SEG_ObjectPermissions]
								where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
								and username = @userName
							)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ORGs all of these that are directly associated 
	--   to the organization

	insert into @orgList
	select [organizationID], 'ORG MAN_ORG (2)', [organizationID] 
	from [dbo].[tbl_Organization]
	where [deleted] = 0
	  and [organizationID] in (
							SELECT [objectID] 
							FROM [dbo].[tbl_SEG_ObjectPermissions]
							WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
							UNION
							SELECT [objectID]
							FROM [dbo].[tbl_SEG_ObjectPublic]
							WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
						) 

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the ORG list all of the ORGs 
	--   that are associated to these PROJs.

	insert into @orgList
	select [p].[organizationID], 'ORG MAN_PROJECT (3)', [p].[organizationID] 
	from [dbo].[tbl_Project] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
	) 

	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ORG list all of the ORGs that are 
	--   associated to these ACT.
	
	insert into @orgList
	select [a].[organizationID], 'ORG MAN_ACTIVITY (4)', [a].[organizationID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [a].[deleted] = 0
	  and [a].[organizationID] in (
							SELECT [objectID] 
							FROM [dbo].[tbl_SEG_ObjectPermissions]
							WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
							UNION
							SELECT [objectID]
							FROM [dbo].[tbl_SEG_ObjectPublic]
							WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
						)  
      and [a].[projectID] is null

	--5. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the ORG list all of the ORGs that are associated to those 
	--   PPL.

	insert into @orgList
	select [p].[organizationID], 'ORG MAN_PEOPLE (5)', [p].[organizationID] 
	from [dbo].[tbl_People][p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[organizationID] in (
									SELECT [objectID] 
									FROM [dbo].[tbl_SEG_ObjectPermissions]
									WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE' AND username = @userName
									UNION
									SELECT [objectID]
									FROM [dbo].[tbl_SEG_ObjectPublic]
									WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE'
								) 

	--6. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ORG list all of the ORGs that are associated to the ACT.

	insert into @orgList
	select [a].[organizationID], 'ACT OWN (6)', [a].[activityID]
	from [dbo].[tbl_Activity][a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [a].[deleted] = 0
	  and [a].[activityID] in (
							select [objectID]
							from [dbo].[tbl_SEG_ObjectPermissions]
							where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
						) 

	insert into @orgList
	select [a].[organizationID], 'ACT-MAN_KPI (6)', [activityID] 
	FROM [dbo].[tbl_Activity][a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [a].[deleted] = 0
	  and [a].[activityID] in (
							SELECT [objectID] 
							FROM [dbo].[tbl_SEG_ObjectPermissions]
							WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
							UNION
							SELECT [objectID]
							FROM [dbo].[tbl_SEG_ObjectPublic]
							WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
						)

	--7. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ORG list all of the ORGs that are associated to those
	--   PROJ.

	insert into @orgList
	select [p].[organizationID], 'PROJ OWN (7)', [projectID] 
	from [dbo].[tbl_Project] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[projectID] in (
							select [objectID]
							from [dbo].[tbl_SEG_ObjectPermissions]
							where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
						)

	insert into @orgList
	select [p].[organizationID], 'PROJ-MAN_KPI (7)', [projectID] 
	FROM [dbo].[tbl_Project] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[projectID] in (
							SELECT [objectID] 
							FROM [dbo].[tbl_SEG_ObjectPermissions]
							WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
							UNION
							SELECT [objectID]
							FROM [dbo].[tbl_SEG_ObjectPublic]
							WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
						)

	--8. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the ORG list the ORGs that are associated to these ACT.

	insert into @orgList
	select [a].[organizationID], 'PROJ-MAN_ACTIVITY (8)', [projectID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [a].[deleted] = 0
	  and [a].[projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
	)

	--9. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the ORG list all of the ORGs that are associated to these PPL.

	insert into @orgList
	select [p].[organizationID], 'PPL OWN (9)', [personID]
	from [dbo].[tbl_People] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[personID] in (
							select [objectID]
							from [dbo].[tbl_SEG_ObjectPermissions]
							where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
						)

	insert into @orgList
	select [p].[organizationID], 'PPL-MAN_KPI (9)', [personID] 
	FROM [dbo].[tbl_People] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[personID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI'
	)

	--10. Add to the ORG list all of the KPIs that are public VIEW_KPI

	insert into @orgList
	select [k].[organizationID], 'KPI-PUB VIEW (10)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [k].[deleted] = 0
	  and [k].[kpiID] in (
						SELECT [objectID]
						FROM [dbo].[tbl_SEG_ObjectPublic]
						WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
					)

	--11.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @orgList
	select [k].[organizationID], 'KPI-VIEW-OWN-ENTER (11)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [k].[deleted] = 0
	  and [k].[kpiID] in (
					SELECT [objectID] 
					FROM [dbo].[tbl_SEG_ObjectPermissions]
					WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
					union
					SELECT [objectID] 
					FROM [dbo].[tbl_SEG_ObjectPermissions]
					WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
					union
					SELECT [objectID] 
					FROM [dbo].[tbl_SEG_ObjectPermissions]
					WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
				)

	select distinct organizationID from @orgList 


END
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetOrganizationsByName]    Script Date: 06/17/2016 11:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 27 2016
-- Description:	List organizations by name
-- =============================================
ALTER PROCEDURE [dbo].[usp_ORG_GetOrganizationsByName] 
	@varUsername VARCHAR(50),
	@varName VARCHAR(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT DISTINCT [o].[organizationID], [o].[name]
	FROM [dbo].[tbl_Organization] [o]
	INNER JOIN [dbo].[tbl_SEG_ObjectPermissions] [p] ON [o].[organizationID] = [p].[objectID]
	WHERE [p].[objectTypeID] = 'ORGANIZATION'
	AND   [p].[username] = @varUsername 
	AND   [o].[name] = @varName
	AND   [o].[deleted] = 0

END
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_DeleteProject]    Script Date: 06/17/2016 12:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Mark as delete a project and all of the 
-- related objects
-- =============================================
ALTER PROCEDURE [dbo].[usp_PROJ_DeleteProject]
	@projectID int,
	@username varchar(50)
AS
BEGIN
	
	UPDATE [dbo].[tbl_Project]
	   SET [deleted] = 1
		  ,[dateDeleted] = GETDATE()
		  ,[usernameDeleted] = @username
	 WHERE [projectID] = @projectID


END
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_DeleteProject]    Script Date: 06/17/2016 12:39:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Delete a project and all of the 
-- related objects
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_DeletePermanentlyProject]
	@projectID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION DeleteOrganization;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- We basically have to delete everything related to that project.
		
		-- Start with KPIs. 
		-- Get the IDs of all the KPIs we will delete
		DECLARE @KPITable as TABLE (kpiID int)
		INSERT INTO @KPITable
		SELECT [kpiID] from [dbo].[tbl_KPI]
		where [projectID] = @projectID

		-- Delete all measurements for the KPIs selected

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		-- Delete the KPIs selected
		DELETE FROM [dbo].[tbl_KPI]
		where [kpiID] in (select kpiID from @KPITable)

		-- Now lets delete all activities for the project
		-- Get the IDs of all the activities we will delete
		-- Delete all the permissios for these activities
		-- Delete the activities

		-- Now lets delete the permissions for the project

		-- And finally lets delete the project

		-- =============================================================
		-- INSERT THE SQL STATEMENTS HERE
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT'
		AND   [objectID] = @projectID
		
		DELETE FROM [dbo].[tbl_KPI]
	    WHERE [projectID] = @projectID
		
		DELETE FROM [dbo].[tbl_Activity]
	    WHERE [projectID] = @projectID
	    
		DELETE FROM [dbo].[tbl_Project]
	    WHERE [projectID] = @projectID
		-- =============================================================

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION DeleteOrganization;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectListForUser]    Script Date: 06/17/2016 12:42:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of Projects that user has view rights to
-- =============================================================
ALTER PROCEDURE [dbo].[usp_PROJ_GetProjectListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @projList as TABLE(projectID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PROJ the PROJs of this ORG.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PROJs all of these that are directly associated 
	--   to the organization
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the PROJ list all of the PROJs 
	--   that are associated to these ORGs.
	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for PROJ that are associated to these ORGs then add to the 
	--   PROJ list all of the PROJs.
	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the PROJ list all of the PROJs that are associated to the ACT.
	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the PROJ list all of the PROJ.
	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the PROJs and finally add to the PROJ list.
	--8. Add to the PROJ list all of the PROJs that are public VIEW_KPI
	--9. Add to the PROJ list all of the PROJs where the user has OWN or VIEW_KPI or ENTER_DATA
	--   permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PROJ the PROJs of this ORG.

	insert into @projList
	select [projectID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_Project]
	where [deleted] = 0
	  and [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PROJs all of these that are directly associated 
	--   to the organization

	insert into @projList
	select [projectID], 'ORG MAN_ORG (2)', [organizationID] 
	from [dbo].[tbl_Project]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs then add to the PROJ list all of the PROJs 
	--   that are associated to these ORGs.

	insert into @projList
	select [projectID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_Project]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
	) 

	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for PROJ that are associated to these ORGs then add to the 
	--   PROJ list all of the PROJs.
	
	insert into @projList
	select [projectID], 'ORG MAN_ACTIVITY (4)', [organizationID] 
	from [dbo].[tbl_Project]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
	)  

	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the PROJ list all of the PROJs that are associated to the ACT.

	insert into @projList
	select [a].[projectID], 'ACT OWN (5)', [activityID]
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [p].[deleted] = 0
	  and [a].[deleted] = 0
	  and [activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	) 

	insert into @projList
	select [a].[projectID], 'ACT-MAN_KPI (5)', [activityID] 
	FROM [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [p].[deleted] = 0
	  and [a].[deleted] = 0
	  and [activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the PROJ list all of the PROJ.

	insert into @projList
	select [projectID], 'PROJ OWN (6)', [projectID] 
	from [dbo].[tbl_Project]
	where [deleted] = 0
	  and [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @projList
	select [projectID], 'PROJ-MAN_KPI (6)', [projectID] 
	FROM [dbo].[tbl_Project]
	where [deleted] = 0
	  and [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the PROJs and finally add to the PROJ list.

	insert into @projList
	select [projectID], 'PROJ-MAN_ACTIVITY (7)', [projectID] 
	from [dbo].[tbl_Project]
	where [deleted] = 0
	 and  [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
	)


	--8. Add to the PROJ list all of the PROJs that are public VIEW_KPI

	insert into @projList
	select [k].[projectID], 'KPI-PUB VIEW (8)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Project] [p] on [k].[projectID] = [p].[projectID]
	where [p].[deleted] = 0
	 and  [k].[deleted] = 0
	 and  [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--9.	Add to the PROJ list all of the PROJs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @projList
	select [k].[projectID], 'KPI-VIEW-OWN-ENTER (9)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Project] [p] on [k].[projectID] = [p].[projectID]
	where [p].[deleted] = 0
	 and  [k].[deleted] = 0
	 and  [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct [projectID] from @projList 


END
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsByOrganization]    Script Date: 06/17/2016 12:47:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_PROJ_GetProjectsByOrganization]
	@intOrganizationId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_KPI([kpiId] INT)
	CREATE TABLE #tbl_Project([projectID] INT)
	
	INSERT INTO #tbl_KPI
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
	INSERT INTO #tbl_Project
		EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUserName
	
	SELECT [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Project] [p] 
	INNER JOIN #tbl_Project [d] ON [p].[projectID] = [d].[projectID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [p].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[projectID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[projectID]) [kpi] ON [p].[projectID] = [kpi].[projectID] 
	WHERE [p].[organizationID] = @intOrganizationId
	AND   [p].[deleted] = 0
	
	DROP TABLE #tbl_Project
    DROP TABLE #tbl_KPI
	
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_InsertProject]    Script Date: 06/17/2016 12:48:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new project
-- =============================================
ALTER PROCEDURE [dbo].[usp_PROJ_InsertProject]
	@userName varchar(50),
	@organizationID int,
	@areaID int,
	@projectName nvarchar(250),
	@projectID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION InsertProjectPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		IF(@areaID = 0)
			SELECT @areaID = null

		INSERT INTO [dbo].[tbl_Project]
           ([name]
           ,[organizationID]
           ,[areaID]
           ,[deleted])
		VALUES
           (@projectName
           ,@organizationID
           ,@areaID
           ,0)

		SELECT @projectID = SCOPE_IDENTITY()

		-- Ensure that the owner can manage this object
		INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
           ([objectTypeID]
           ,[objectID]
           ,[username]
           ,[objectActionID])
		VALUES
           ('PROJECT'
           ,@projectID
           ,@userName
           ,'OWN')

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION InsertProjectPS;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_InsertOrganization]    Script Date: 06/17/2016 12:49:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Cerate a new organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_ORG_InsertOrganization]
	@userName varchar(50),
	@organizationName nvarchar(250),
	@organizationID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION InsertOrganiPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		INSERT INTO [dbo].[tbl_Organization]
			   ([name]
			   ,[deleted])
		VALUES
			   (@organizationName
			   ,0)

		SELECT @organizationID = SCOPE_IDENTITY()

		-- Ensure that the owner can manage this object
		INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
           ([objectTypeID]
           ,[objectID]
           ,[username]
           ,[objectActionID])
		VALUES
           ('ORGANIZATION'
           ,@organizationID
           ,@userName
           ,'OWN')	

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION InsertOrganiPS;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_DeletePerson]    Script Date: 06/17/2016 16:42:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 7, 2016
-- Description:	Delete a person
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_DeletePerson]
	@personID int,
	@username VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_People]
	   SET [deleted] = 1
		  ,[dateDeleted] = GETDATE()
		  ,[usernameDeleted] = @username
	 WHERE [personID] = @personID
      

END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonListForUser]    Script Date: 06/17/2016 16:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of People that user has view rights to
-- =============================================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetPersonListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @pplList as TABLE(personID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PPL all the people related to the ORG.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PPLs all of the people that are directly associated 
	--   to the ORG
	--3. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the PLL list all of the people.
	--4. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the PPL list all the people that are associated.
	--5. Add to the ORG list all of the KPIs that are public VIEW_KPI
	--6.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of PPL all the people related to the ORG.

	insert into @pplList
	select [personID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_People]
	where [deleted] = 0
	  and [organizationID] in (
					select [objectID]
					from [dbo].[tbl_SEG_ObjectPermissions]
					where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
						and username = @userName
				)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PPLs all of the people that are directly associated 
	--   to the ORG

	insert into @pplList
	select [k].[personID], 'ORG MAN_ORG (2)', [k].[organizationID] 
	from [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_People] [p] ON [k].[personID] = [p].[personID]
	where [p].[deleted] = 0
	  and [k].[deleted] = 0
	  and [k].[organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the PLL list all of the people.

	insert into @pplList
	select [personID], 'ORG MAN_PEOPLE (3)', [organizationID] 
	from [dbo].[tbl_People] 
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE'
	)  

	--4. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the PPL list all the people that are associated.

	insert into @pplList
	select [personID], 'PPL OWN (4)', [personID]
	from [dbo].[tbl_People]
	where [deleted] = 0
	  and [personID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
	)

	insert into @pplList
	select [personID], 'PPL-MAN_KPI (4)', [personID] 
	FROM [dbo].[tbl_People]
	where [deleted] = 0
	  and [personID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI'
	)

	--5. Add to the ORG list all of the KPIs that are public VIEW_KPI

	insert into @pplList
	select [k].[personID], 'KPI-PUB VIEW (5)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_People] [p] ON [k].[personID] = [p].[personID]
	where [p].[deleted] = 0
	  and [k].[deleted] = 0
	  and [k].[kpiID] in (
						SELECT [objectID]
						FROM [dbo].[tbl_SEG_ObjectPublic]
						WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
					)

	--6.	Add to the ORG list all of the ORGs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @pplList
	select [k].[personID], 'KPI-VIEW-OWN-ENTER (6)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_People] [p] ON [k].[personID] = [p].[personID]
	where [p].[deleted] = 0
	  and [k].[deleted] = 0
	  and [k]. [kpiID] in (
					SELECT [objectID] 
					FROM [dbo].[tbl_SEG_ObjectPermissions]
					WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
					union
					SELECT [objectID] 
					FROM [dbo].[tbl_SEG_ObjectPermissions]
					WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
					union
					SELECT [objectID] 
					FROM [dbo].[tbl_SEG_ObjectPermissions]
					WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
				)

	select distinct personID from @pplList 


END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonByOrganization]    Script Date: 06/17/2016 16:51:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marcela Martinez
-- Create date: 18/05/2016
-- Description:	Get people by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetPersonByOrganization]
	@intOrganizationId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
    CREATE TABLE #tbl_KPI([kpiId] INT)
	CREATE TABLE #tbl_People([personID] INT)
	
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
		
	INSERT INTO #tbl_People
		EXEC [dbo].[usp_PEOPLE_GetPersonListForUser] @varUserName
	
	SELECT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_People] [p] 
	INNER JOIN #tbl_People [d] ON [p].[personID] = [d].[personID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [p].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[personID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[personID]) [kpi] ON [p].[personID] = [kpi].[personID] 
	WHERE [p].[organizationID] = @intOrganizationId
	AND [p].[deleted] = 0
	AND [o].[deleted] = 0
    
    DROP TABLE #tbl_People
    DROP TABLE #tbl_KPI
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPeopleBySearch]    Script Date: 06/17/2016 16:52:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 2, 2016
-- Description:	Get the lists of people for search
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetPeopleBySearch]
	@varUsername VARCHAR(25),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblPeople
		(personId INT)

	INSERT INTO #tblPeople
	EXEC [usp_PEOPLE_GetPersonListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [p].[personID]
				  ,[p].[id]
				  ,[p].[name]
				  ,[p].[organizationID]
				  ,[p].[areaID]
			FROM [dbo].[tbl_People] [p]
			INNER JOIN #tblPeople [t] ON [p].[personID] = [t].[personId]
			INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID]
			LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]
	        WHERE [g].[deleted] = 0 and ' + @varWhereClause + '
	        ORDER BY [p].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblPeople
	 
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_DeleteActivity]    Script Date: 06/17/2016 17:03:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: May 5, 2016
-- Description:	Marck an activity as deleted
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_DeleteActivity]
	@activityID int,
	@username varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE [dbo].[tbl_Activity]
	   SET [deleted] = 1
		  ,[dateDeleted] = GETDATE()
		  ,[usernameDeleted] = @username
	 WHERE [activityID] = @activityID

END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: May 5, 2016
-- Description:	Delete an activity and all of the 
-- related objects
-- =============================================
CREATE PROCEDURE [dbo].[usp_ACT_DeletePermanentlyActivity]
	@activityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- We detect if the SP was called from an active transation and 
	-- we save it to use it later.  In the SP, @TranCounter = 0
	-- means that there are no active transations and that this SP
	-- started one. @TranCounter > 0 means that a transation was started
	-- before we started this SP
	DECLARE @TranCounter INT;
	SET @TranCounter = @@TRANCOUNT;
	IF @TranCounter > 0
		-- We called this SP when an active transaction already exists.
		-- We create a savepoint to be able to only roll back this 
		-- transaction if there is some error.
		-- ===============================================
		---  MAKE SURE THAT THIS NAME IS COPIED BELOW 
		---  AND IS UNIQUE IN THE SYSTEM!!!!!!
		-- ===============================================
		SAVE TRANSACTION DeleteActivity;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- We basically have to delete everything related to that project.
		
		-- Start with KPIs. 
		-- Get the IDs of all the KPIs we will delete
		DECLARE @KPITable as TABLE (kpiID int)
		INSERT INTO @KPITable
		SELECT [kpiID] from [dbo].[tbl_KPI]
		where [activityID] = @activityID

		-- Delete all measurements for the KPIs selected

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		-- Delete the KPIs selected
		DELETE FROM [dbo].[tbl_KPI]
		where [kpiID] in (select kpiID from @KPITable)

		-- Now lets delete all activities for the project
		-- Get the IDs of all the activities we will delete
		-- Delete all the permissios for these activities
		-- Delete the activities

		-- Now lets delete the permissions for the project

		-- And finally lets delete the project

		-- =============================================================
		-- INSERT THE SQL STATEMENTS HERE
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY'
		AND   [objectID] = @activityID
		
		DELETE FROM [dbo].[tbl_Activity]
	    WHERE [activityID] = @activityID
		-- =============================================================

		-- We arrived here without errors; we should commit the transation we started
		-- but we should not commit if there was a previous transaction started
		IF @TranCounter = 0
			-- @TranCounter = 0 means that no other transaction was started before this transaction 
			-- and that we shouold hence commit this transaction
			COMMIT TRANSACTION;
		
	END TRY
	BEGIN CATCH

		-- There was an error.  We need to determine what type of rollback we must perform

		DECLARE @ErrorMessage NVARCHAR(4000);
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;

		SELECT @ErrorMessage = ERROR_MESSAGE();
		SELECT @ErrorSeverity = ERROR_SEVERITY();
		SELECT @ErrorState = ERROR_STATE();

		IF @TranCounter = 0
			-- We have only the transaction that we started in this SP.  Rollback
			-- all the tranaction.
			ROLLBACK TRANSACTION;
		ELSE
			-- A transaction was started before this SP was called.  We must
			-- rollback only the changes we made in this SP.

			-- We see XACT_STATE and the possible results are 0, 1, or -1.
			-- If it is 1, the transaction is valid and we can do a commit. But since we are in the 
			-- CATCH we don't do the commit. We need to rollback to the savepoint
			-- If it is -1 the transaction is not valid and we must do a full rollback... we can't
			-- do a rollback to a savepoint
			-- XACT_STATE = 0 means that there is no transaciton and a rollback would cause an error
			-- See http://msdn.microsoft.com/en-us/library/ms189797(SQL.90).aspx
			IF XACT_STATE() = 1
				-- If the transaction is still valid then we rollback to the restore point defined before
				-- ===============================================
				---  MAKE SURE THAT THIS NAME IS EXACTLY AS ABOVE 
				-- ===============================================
				ROLLBACK TRANSACTION DeleteActivity;

				-- If the transaction is not valid we cannot do a commit or a rollback to a savepoint
				-- because a rollback is not allowed. Hence, we must simply return to the caller and 
				-- they will be respnsible to rollback the transaction

				-- If there is no tranaction then there is nothing left to do

		-- After doing the correpsonding rollback, we must propagate the error information to the SP that called us 
		-- See http://msdn.microsoft.com/en-us/library/ms175976(SQL.90).aspx

		-- The database can return values from 0 to 256 but raise error
		-- will only allow us to use values from 1 to 127
		IF(@ErrorState < 1 OR @ErrorState > 127)
			SELECT @ErrorState = 1
			
		RAISERROR (@ErrorMessage, -- Message text.
				   @ErrorSeverity, -- Severity.
				   @ErrorState -- State.
				   );
	END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivitiesByProject]    Script Date: 06/17/2016 17:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	List all activities by project
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivitiesByProject]
	@intProjectId AS INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_KPI([kpiId] INT)
	CREATE TABLE #tbl_Activity([activityID] INT)
	
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
	INSERT INTO #tbl_Activity
		EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUserName
    
    SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
		  ,[o].[name] [organizationName]
		  ,[ar].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Activity] [a] 
	INNER JOIN #tbl_Activity [d] ON [a].[activityID] = [d].[activityID]
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [ar] ON [a].[areaID] = [ar].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
    LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[activityID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[activityID]) [kpi] ON [a].[activityID] = [kpi].[activityID] 
	WHERE [a].[projectID] = @intProjectId
	AND [o].[deleted] = 0
	AND [p].[deleted] = 0
    
	DROP TABLE #tbl_Activity
	DROP TABLE #tbl_KPI
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivitiesBySearch]    Script Date: 06/17/2016 17:07:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: May 4 2016
-- Description:	List all activities by search
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivitiesBySearch]
	@varUsername VARCHAR(25),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblActivity
		(activityId INT)

	INSERT INTO #tblActivity
	EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
	  FROM [dbo].[tbl_Activity] [a]
	  INNER JOIN #tblActivity [t] ON [a].[activityID] = [t].[activityId]
	  INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	  LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	  LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	  WHERE [g].[deleted] = 0
	  AND [p].[deleted] = 0 
	  AND ' + @varWhereClause + '
	  ORDER BY [a].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblActivity
	 
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByOrganization]    Script Date: 06/17/2016 17:08:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 02/05/2016
-- Description:	List all activities by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivityByOrganization]
	@intOrganizationId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_KPI([kpiId] INT)
	CREATE TABLE #tbl_Activity([activityID] INT)
	
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
	INSERT INTO #tbl_Activity
		EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUserName
	
    SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
		  ,[o].[name] [organizationName]
		  ,[ar].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Activity] [a] 
	INNER JOIN #tbl_Activity [d] ON [a].[activityID] = [d].[activityID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [ar] ON [a].[areaID] = [ar].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[activityID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[activityID]) [kpi] ON [a].[activityID] = [kpi].[activityID] 
	WHERE [a].[organizationID] = @intOrganizationId
	AND [o].[deleted] = 0
	AND [p].[deleted] = 0
    
    DROP TABLE #tbl_Activity
    DROP TABLE #tbl_KPI
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByProject]    Script Date: 06/17/2016 17:09:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez 
-- Create date: 10/05/2016
-- Description:	get activities by project
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivityByProject]
	@intProjectId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Activity] [a] 
	LEFT OUTER JOIN (SELECT COUNT([kpiID]) [numberKPIs]
						   ,[organizationID]
						   ,[activityID]
					 FROM [dbo].[tbl_KPI] 
					 GROUP BY [organizationID], [activityID]) [kpi] 
	ON [a].[organizationID] = [kpi].[organizationID] AND [a].[activityID] = [kpi].[activityID] 
	WHERE [a].[projectID] = @intProjectId
	AND [a].[deleted] = 0
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityListForUser]    Script Date: 06/17/2016 17:15:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of Activities that user has view rights to
-- =============================================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivityListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @actList as TABLE(activityID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of ACT to those ORGs.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ACTs all of these that are directly associated 
	--   to the organization
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all ACTs then add to the ACT list all of the ACTs 
	--   that are associated to these ORGs.
	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ACT list all of the ACTs that are 
	--   associated.
	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ACT list all of the ACTs.
	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ACT list all of the ACTs that are associated to those
	--   PROJ.
	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT and finally add to the ACT list 
	--   the ACTs.
	--8. Add to the ACT list all of the ACTs that are public VIEW_KPI
	--9. Add to the ACT list all of the ACTs where the user has OWN or VIEW_KPI or ENTER_DATA
	--   permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of ACT to those ORGs.

	insert into @actList
	select [activityID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ACTs all of these that are directly associated 
	--   to the organization

	insert into @actList
	select [activityID], 'ORG MAN_KPI (2)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all ACTs then add to the ACT list all of the ACTs 
	--   that are associated to these ORGs.

	insert into @actList
	select [activityID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
	) 

	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ACT list all of the ACTs that are 
	--   associated.
	
	insert into @actList
	select [activityID], 'ORG MAN_ACTIVITY (4)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
	)  and [projectID] is null

	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ACT list all of the ACTs.

	insert into @actList
	select [activityID], 'ACT OWN (5)', [activityID]
	from  [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	) 

	insert into @actList
	select [activityID], 'ACT-MAN_KPI (5)', [activityID] 
	FROM [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ACT list all of the ACTs that are associated to those
	--   PROJ.

	insert into @actList
	select [activityID], 'PROJ OWN (6)', [projectID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @actList
	select [activityID], 'PROJ-MAN_KPI (6)', [projectID] 
	FROM [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT and finally add to the ACT list 
	--   the ACTs.

	insert into @actList
	select [activityID], 'PROJ-MAN_ACTIVITY (7)', [projectID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
	)

	--8. Add to the ACT list all of the ACTs that are public VIEW_KPI

	insert into @actList
	select [k].[activityID], 'KPI-PUB VIEW (8)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID]
	where [a].[deleted] = 0
	  and [k].[deleted] = 0
	  and [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--9.	Add to the ACT list all of the ACTs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @actList
	select [k].[activityID], 'KPI-VIEW-OWN-ENTER (11)', [kpiID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID]
	where [a].[deleted] = 0
	  and [k].[deleted] = 0
	  and [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct [activityID] from @actList 


END
GO


/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectPermissionsByUser]    Script Date: 06/16/2016 14:56:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 11/05/2016
-- Description:	Get objectPermissions by user
-- =============================================
ALTER PROCEDURE [dbo].[usp_SEG_GetObjectPermissionsByUser]
	@varObjectTypeId AS VARCHAR(20),
	@intObjectId AS INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @organizationID INT
	DECLARE @projectID INT

	DECLARE @tblPermissions AS TABLE
	([objectID] [int] NOT NULL,
	 [objectTypeID] [varchar](20) NOT NULL,
	 [objectActionID] [varchar](20) NOT NULL,
	 [username] [varchar](50) NOT NULL,
	 [fullname] [varchar](500) NOT NULL,
	 [email] [varchar](100) NOT NULL)
	
	INSERT @tblPermissions
    SELECT [op].[objectID]
		  ,[op].[objectTypeID]
		  ,[op].[objectActionID]
		  ,[op].[username]
		  ,[us].[fullname]
		  ,[us].[email]
	FROM [dbo].[tbl_SEG_ObjectPermissions] [op] 
	INNER JOIN [dbo].[tbl_SEG_User] [us] ON [op].[username] = [us].[username] 
	WHERE [op].[objectTypeID] = @varObjectTypeId  
	AND [op].[objectID] = @intObjectId 
	AND [op].[username] = @varUserName
    
    IF (@varObjectTypeId = 'PROJECT')
	BEGIN
		SELECT @organizationID = organizationID
		FROM [dbo].[tbl_Project]
		WHERE [projectID] = @intObjectId
		
		INSERT @tblPermissions
		SELECT [op].[objectID]
			  ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,[op].[username]
			  ,[us].[fullname]
			  ,[us].[email]
		FROM [dbo].[tbl_SEG_ObjectPermissions] [op] 
		INNER JOIN [dbo].[tbl_SEG_User] [us] ON [op].[username] = [us].[username] 
		WHERE [op].[objectTypeID] = 'ORGANIZATION'  
		AND [op].[objectID] = @organizationID 
		AND [op].[username] = @varUserName
	END
    
    IF (@varObjectTypeId = 'PERSON')
	BEGIN
		SELECT @organizationID = organizationID
		FROM [dbo].[tbl_People]
		WHERE [personID] = @intObjectId
		
		INSERT @tblPermissions
		SELECT [op].[objectID]
			  ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,[op].[username]
			  ,[us].[fullname]
			  ,[us].[email]
		FROM [dbo].[tbl_SEG_ObjectPermissions] [op] 
		INNER JOIN [dbo].[tbl_SEG_User] [us] ON [op].[username] = [us].[username] 
		WHERE [op].[objectTypeID] = 'ORGANIZATION'  
		AND [op].[objectID] = @organizationID 
		AND [op].[username] = @varUserName
	END
	
	 IF (@varObjectTypeId = 'ACTIVITY')
	BEGIN
		SELECT @organizationID = organizationID,
		       @projectID = projectID
		FROM [dbo].[tbl_Activity]
		WHERE [activityID] = @intObjectId
		
		INSERT @tblPermissions
		SELECT [op].[objectID]
			  ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,[op].[username]
			  ,[us].[fullname]
			  ,[us].[email]
		FROM [dbo].[tbl_SEG_ObjectPermissions] [op] 
		INNER JOIN [dbo].[tbl_SEG_User] [us] ON [op].[username] = [us].[username] 
		WHERE [op].[objectTypeID] = 'ORGANIZATION'  
		AND [op].[objectID] = @organizationID 
		AND [op].[username] = @varUserName
		
		INSERT @tblPermissions
		SELECT [op].[objectID]
			  ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,[op].[username]
			  ,[us].[fullname]
			  ,[us].[email]
		FROM [dbo].[tbl_SEG_ObjectPermissions] [op] 
		INNER JOIN [dbo].[tbl_SEG_User] [us] ON [op].[username] = [us].[username] 
		WHERE [op].[objectTypeID] = 'PROJECT'  
		AND [op].[objectID] = @projectID 
		AND [op].[username] = @varUserName
	END
	
	SELECT [objectID]
		  ,[objectTypeID]
		  ,[objectActionID]
		  ,[username]
		  ,[fullname]
		  ,[email]
    FROM @tblPermissions
END
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteAllKPITarget]    Script Date: 06/22/2016 13:00:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gabriela Sanchez 
-- Create date: May 23, 2016
-- Description:	Delete all targets from KPI
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_DeleteAllKPITarget]
	@kpiID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE FROM [dbo].[tbl_KPITargetCategories]
	WHERE [targetID] IN (SELECT [targetID] FROM [dbo].[tbl_KPITarget]
	                     WHERE [kpiID] = @kpiID)
	
	DELETE FROM [dbo].[tbl_KPITarget]
	WHERE [kpiID] = @kpiID
	
	DELETE FROM [dbo].[tbl_KPICategories]
	WHERE [kpiID] = @kpiID
	
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 01/06/2016
-- Description:	Update KPI Target Category
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_UpdateKPITargetCategory]
	@kpiId INT,
	@targetID INT,
	@items VARCHAR(1000),
	@categories VARCHAR(1000),
	@target DECIMAL(21,9)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@categories IS NULL)
		SET @categories = ''

    CREATE TABLE #tbl_Items 
	(itemId INT IDENTITY,
	 itemText VARCHAR(20))
	 
	CREATE TABLE #tbl_CategoryItems 
	(categoryId INT IDENTITY,
	 categoryText VARCHAR(20))
	 
	IF (@targetID > 0)
	BEGIN 
		UPDATE [dbo].[tbl_KPITarget]
		SET [target] = @target
		WHERE [targetID] = @targetID
		AND   [kpiID] = @kpiId
	END
	ELSE
	BEGIN
		DECLARE @newTargetID INT
		
		INSERT INTO [dbo].[tbl_KPITarget]
			   ([kpiID]
			   ,[target])
		 VALUES
			   (@kpiId
			   ,@target)
	           
		SET @newTargetID = @@IDENTITY

		INSERT #tbl_Items
		SELECT splitvalue
		FROM dbo.tvf_SplitStringInVarCharTable(@items,',')
		
		INSERT #tbl_CategoryItems
		SELECT splitvalue
		FROM dbo.tvf_SplitStringInVarCharTable(@categories,',')
		
		INSERT INTO [dbo].[tbl_KPITargetCategories]
		   ([targetID],[categoryItemID],[categoryID])
		SELECT @newTargetID, itemText, categoryText
		FROM #tbl_Items a, #tbl_CategoryItems b
		WHERE a.itemId = b.categoryId

	END	

	INSERT INTO [dbo].[tbl_KPICategories]
	SELECT DISTINCT @kpiId, categoryText
	FROM #tbl_CategoryItems
	WHERE categoryText NOT IN (SELECT categoryId FROM [dbo].[tbl_KPICategories] WHERE kpiID = @kpiId)

	DROP TABLE #tbl_Items
	DROP TABLE #tbl_CategoryItems

END
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_UpdateKPITargetNoCategories]    Script Date: 06/22/2016 13:13:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Gabriela Sanchez 
-- Create date: May 23, 2016
-- Description:	Update a Target for a KPI that does not have Categories
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_UpdateKPITargetNoCategories]
	@kpiID int,
	@target decimal(21,3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @targetID INT = 0
	
	SELECT TOP 1 @targetID =  [targetID]
	FROM [dbo].[tbl_KPITarget]
	WHERE [kpiID] = @kpiID
	
	DELETE FROM [dbo].[tbl_KPITargetCategories]
	WHERE [targetID] = @targetID
	
	IF (SELECT COUNT(*) 
	    FROM [dbo].[tbl_KPITarget]
	    WHERE [kpiID] = @kpiID ) > 1
	BEGIN 
		DELETE FROM [dbo].[tbl_KPITargetCategories]
		WHERE [targetID] IN (SELECT [targetID]
		                     FROM [dbo].[tbl_KPITarget]
							 WHERE [kpiID] = @kpiID
							 AND [targetID] <> @targetID)
		
		DELETE FROM [dbo].[tbl_KPITarget]
		WHERE [kpiID] = @kpiID
		AND [targetID] <> @targetID
	END
	
	
	
	DELETE FROM [dbo].[tbl_KPICategories]
	WHERE [kpiID] = @kpiID
	
	IF ISNULL(@targetID,0) > 0
		UPDATE [dbo].[tbl_KPITarget]
		SET [target] = @target
		WHERE [kpiID] = @kpiID
		AND   [targetID] = @targetID
	ELSE
		INSERT INTO [dbo].[tbl_KPITarget]
			   ([kpiID]
			   ,[target])
		 VALUES
			   (@kpiID
			   ,@target)

	
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Gabriela Sanchez 
-- Create date: Jun 22, 2016
-- Description:	Mark KPI as deleted
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_DeleteKPI]
	@kpiID int,
	@username varchar(50)
AS
BEGIN
	
	UPDATE [dbo].[tbl_KPI]
	   SET [deleted] = 1
		  ,[dateDeleted] = GETDATE()
		  ,[usernameDeleted] = @username
	WHERE [kpiID] = @kpiID

END
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIListForUser]    Script Date: 06/22/2016 13:34:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author:		Ivan Krsul
-- Create date: May 12 2016
-- Description:	Get List of KPIs that user has view rights to
-- =============================================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @kpiList as TABLE(kpiID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of KPIs all of those KPIs associated to those ORGs.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of KPIs all of these that are directly associated 
	--   to the organization and ARE NOT associated to a PROJ, ACT or PPL.  
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs associated to these ORGs and then add to 
	--   the KPI list all of the KPIs that are associated to these PROJs.
	--4. For the list of projects obtained above, search for all the ACT that are associated
	--   to these PROJ and then add to the KPI list all of the KPIs that are associated to 
	--   these ACT.
	--5. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the KPI list all of the KPIs that are 
	--   associated to these ACT.
	--6. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the KPI list all of the KPIs that are associated to those 
	--   PPL.
	--7. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the KPI list all of the KPIs that are associated to the ACT.
	--8. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the ORG 
	--   is public MAN_KPI and add to the KPI list all of the PKIs that are associated to those
	--   PROJ.
	--9. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the KPI list the KPIs that are associated to these ACT.
	--10. Search for all PPL where the user user has MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the KPI list all of the KIPs that are associated to these PPL.
	--11.	Add to the KPI list all of the KPIs that are public VIEW
	--12.	Add to the KPI list all of the KPIs where the user has OWN or VIEW or ENTER_DATA
	--      permissions.
	--
	--At the end of this, we should have a list of all of the KPIs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of KPIs all of those KPIs associated to those ORGs.

	insert into @kpiList
	select [kpiID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of KPIs all of these that are directly associated 
	--   to the organization and ARE NOT associated to a PROJ, ACT or PPL.  

	insert into @kpiList
	select [kpiID], 'ORG MAN_KPI (2)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) and [projectID] is null and [activityID] is null and [personID] is null

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs associated to these ORGs and then add to 
	--   the KPI list all of the KPIs that are associated to these PROJs.

	insert into @kpiList
	select [kpiID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [projectID] in (
		select [projectID]
		from [dbo].[tbl_Project] 
		where [deleted] = 0
	      and [organizationID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
		) 
	)

	--4. For the list of projects obtained above, search for all the ACT that are associated
	--   to these PROJ and then add to the KPI list all of the KPIs that are associated to 
	--   these ACT.

	insert into @kpiList
	select [kpiID], 'ORG MAN_PROJECT_ACT (4)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [activityID] in (
		select [activityID] 
		from [dbo].[tbl_Activity]
		where [deleted] = 0
	      and [projectID] in (
			select [projectID]
			from [dbo].[tbl_Project] 
			where [deleted] = 0
	          and [organizationID] in (
				SELECT [objectID] 
				FROM [dbo].[tbl_SEG_ObjectPermissions]
				WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
				UNION
				SELECT [objectID]
				FROM [dbo].[tbl_SEG_ObjectPublic]
				WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
			) 
		)
	)

	--5. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the KPI list all of the KPIs that are 
	--   associated to these ACT.
	
	insert into @kpiList
	select [kpiID], 'ORG MAN_ACTIVITY (5)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [activityID] in (
		select [activityID] 
		from [dbo].[tbl_Activity]
		where [deleted] = 0
	      and [organizationID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
		)  and [projectID] is null
	)

	--6. Search for all ORGs where the user has MAN_PEOPLE permissions or where the ORG has 
	--   public MAN_PEOPLE, then search for all of the PPL that are associated to those 
	--   ORGs and finally add to the KPI list all of the KPIs that are associated to those 
	--   PPL.

	insert into @kpiList
	select [kpiID], 'ORG MAN_PEOPLE (6)', [organizationID] 
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [personID] in (
		select [personID]
		from [dbo].[tbl_People] 
		where [deleted] = 0
	      and [organizationID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PEOPLE'
		) 
	)

	--7. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the KPI list all of the KPIs that are associated to the ACT.

	insert into @kpiList
	select [kpiID], 'ACT OWN (7)', [activityID]
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'ACT-MAN_KPI (7)', [activityID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--8. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the ORG 
	--   is public MAN_KPI and add to the KPI list all of the PKIs that are associated to those
	--   PROJ.

	insert into @kpiList
	select [kpiID], 'PROJ OWN (8)', [projectID] 
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'PROJ-MAN_KPI (8)', [projectID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--9. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT that are associated to these 
	--   PROJs and finally add to the KPI list the KPIs that are associated to these ACT.

	insert into @kpiList
	select [kpiID], 'PROJ-MAN_ACTIVITY (9)', [projectID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [activityID] in (
		select [activityID]
		from [dbo].[tbl_Activity]
		where [deleted] = 0
	      and [projectID] in (
			SELECT [objectID] 
			FROM [dbo].[tbl_SEG_ObjectPermissions]
			WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
			UNION
			SELECT [objectID]
			FROM [dbo].[tbl_SEG_ObjectPublic]
			WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
		)
	)

	--10. Search for all PPL where the user has OWN or MAN_KPI permissions or where the PPL is 
	--    public MAN_KPI and add to the KPI list all of the KIPs that are associated to these PPL.

	insert into @kpiList
	select [kpiID], 'PPL OWN (10)', [personID]
	from [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [personID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'PPL-MAN_KPI (10)', [personID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [personID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PERSON' and objectActionID = 'MAN_KPI'
	)

	--11. Add to the KPI list all of the KPIs that are public VIEW_KPI

	insert into @kpiList
	select [kpiID], 'KPI-PUB VIEW (11)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--12.	Add to the KPI list all of the KPIs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @kpiList
	select [kpiID], 'KPI-VIEW-OWN-ENTER (12)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct kpiID from @kpiList 


END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by activity
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIsByActivity]
	 @intActivityId INT,
	 @varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID]) [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] AND [o].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] AND [p].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] AND [ac].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] AND [pe].[deleted] = 0
	WHERE [k].[activityID] = @intActivityId
	
	DROP TABLE #tbl_KPI
    
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 02/04/2016
-- Description:	Get KPIs by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIsByOrganization]
	 @intOrganizationId INT,
	 @varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID]) [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] AND [o].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] AND [p].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] AND [ac].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] AND [pe].[deleted] = 0
	WHERE [k].[organizationID] = @intOrganizationId
    
    DROP TABLE #tbl_KPI
    
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by person
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
	 @intPersonId INT,
	 @varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID]) [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] AND [o].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] AND [p].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] AND [ac].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] AND [pe].[deleted] = 0
	WHERE [k].[personID] = @intPersonId   
	
    DROP TABLE #tbl_KPI
    
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by project
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIsByProject]
	@intProjectId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_KPI([kpiId] INT)
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
    SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[k].[areaID]
		  ,[k].[projectID]
		  ,[k].[activityID]
		  ,[k].[personID]
		  ,[k].[unitID]
		  ,[k].[directionID]
		  ,[k].[strategyID]
		  ,[k].[startDate]
		  ,[k].[reportingUnitID]
		  ,[k].[targetPeriod]
		  ,[k].[allowsCategories]
		  ,[k].[currency]
		  ,[k].[currencyUnitID]
		  ,[k].[kpiTypeID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[p].[name] [projectName]
		  ,[ac].[name] [activityName]
		  ,[pe].name [personName]
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID]) [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] AND [o].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] AND [p].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] AND [ac].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] AND [pe].[deleted] = 0
	WHERE [k].[projectID] = @intProjectId
    
    DROP TABLE #tbl_KPI
    
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Jose Carlos Gutiérrez
-- Create date: 2016/05/13
-- Description:	Insert a KPI to Dashboard
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKpisFromDashboard]
	@intDashboardId	INT,
	@intUserId		INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @intDashboardId = 0 
	BEGIN
		SELECT [kpiDashboardId]
			  ,[dashboardId]
			  ,d.[kpiId]
			  ,[ownerUserId]
			  ,k.[name]
		FROM [dbo].[tbl_KPIDashboard] d
		INNER JOIN [dbo].[tbl_KPI] k ON k.[kpiID] = d.[kpiId]
		WHERE [dashboardId] IS NULL
			AND [ownerUserId] = @intUserId
			AND [deleted] = 0
	END 
	ELSE
	BEGIN
		SELECT [kpiDashboardId]
			  ,[dashboardId]
			  ,d.[kpiId]
			  ,[ownerUserId]
			  ,k.[name]
		FROM [dbo].[tbl_KPIDashboard] d
		INNER JOIN [dbo].[tbl_KPI] k ON k.[kpiID] = d.[kpiId]
		WHERE [dashboardId] = @intDashboardId 
			AND [ownerUserId] = @intUserId
			AND [deleted] = 0
	END
    
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ORG_GetActivityListForUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ORG_GetActivityListForUser]
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetActivityListForUser]    Script Date: 06/22/2016 13:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================
-- Author:		Gabriela Sanchez V.
-- Create date: Jun 2 2016
-- Description:	Get List of Activities that user has view rights to
-- =============================================================
CREATE PROCEDURE [dbo].[usp_ORG_GetActivityListForUser]
	-- Add the parameters for the stored procedure here
	@userName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--- Get list of KPIS where user has acccess.  In the sourceObjectType
	-- column we will record where we got this from, and the objectID will
	-- tell us the ID of the object where this KPI came from.
	DECLARE @actList as TABLE(activityID int, sourceObjectType varchar(100), objectID int)

	-- For the following description ORG = ORGANIZATION, ACT = ACTIVITY, PPL = PEOPLE, PROF = PROJECT. 
	--If we need to determine the list of KPIs that a specific user can see 
	--we need to follow the following steps:
	--
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of ACT to those ORGs.
	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ACTs all of these that are directly associated 
	--   to the organization
	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all ACTs then add to the ACT list all of the ACTs 
	--   that are associated to these ORGs.
	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ACT list all of the ACTs that are 
	--   associated.
	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ACT list all of the ACTs.
	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ACT list all of the ACTs that are associated to those
	--   PROJ.
	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT and finally add to the ACT list 
	--   the ACTs.
	--8. Add to the ACT list all of the ACTs that are public VIEW_KPI
	--9. Add to the ACT list all of the ACTs where the user has OWN or VIEW_KPI or ENTER_DATA
	--   permissions.
	--
	--At the end of this, we should have a list of all of the ORGs that the user can see.

	-- So lets start with step 1.
 
	--1. Search for all ORGs where the user has OWN permissions and add to the list 
	--   of ACT to those ORGs.

	insert into @actList
	select [activityID], 'ORG OWN (1)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ACTs all of these that are directly associated 
	--   to the organization

	insert into @actList
	select [activityID], 'ORG MAN_KPI (2)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) 

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all ACTs then add to the ACT list all of the ACTs 
	--   that are associated to these ORGs.

	insert into @actList
	select [activityID], 'ORG MAN_PROJECT (3)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_PROJECT'
	) 

	--4. Search for all ORGs where the user has MAN_ACTITIVIES permissions or ORG has public 
	--   MAN_ACTITIVIES and search for ACT that are associated to these ORGs and ARE NOT 
	--   associated to any PROJ, then add to the ACT list all of the ACTs that are 
	--   associated.
	
	insert into @actList
	select [activityID], 'ORG MAN_ACTIVITY (4)', [organizationID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
	)  and [projectID] is null

	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ACT list all of the ACTs.

	insert into @actList
	select [activityID], 'ACT OWN (5)', [activityID]
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	) 

	insert into @actList
	select [activityID], 'ACT-MAN_KPI (5)', [activityID] 
	FROM [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [activityID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ACTIVITY' and objectActionID = 'MAN_KPI'
	)

	--6. Search for all PROJ where the user has OWN or MAN_KPI permissions, or where the PROJ 
	--   is public MAN_KPI and add to the ACT list all of the ACTs that are associated to those
	--   PROJ.

	insert into @actList
	select [activityID], 'PROJ OWN (6)', [projectID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @actList
	select [activityID], 'PROJ-MAN_KPI (6)', [projectID] 
	FROM [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_KPI'
	)

	--7. Search for all PROJ where the user has MAN_ACTIVITIES permissions or where the PROJ is 
	--   public MAN_ACTIVITIES, then search for all of the ACT and finally add to the ACT list 
	--   the ACTs.

	insert into @actList
	select [activityID], 'PROJ-MAN_ACTIVITY (7)', [projectID] 
	from [dbo].[tbl_Activity]
	where [deleted] = 0
	  and [projectID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'PROJECT' and objectActionID = 'MAN_ACTIVITY'
	)

	--8. Add to the ACT list all of the ACTs that are public VIEW_KPI

	insert into @actList
	select [activityID], 'KPI-PUB VIEW (8)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--9.	Add to the ACT list all of the ACTs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @actList
	select [activityID], 'KPI-VIEW-OWN-ENTER (11)', [kpiID] 
	FROM [dbo].[tbl_KPI]
	where [deleted] = 0
	  and [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'OWN' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'ENTER_DATA' AND username = @userName
		union
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)

	select distinct [activityID] from @actList 


END
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetAllKPIs]    Script Date: 06/22/2016 13:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2014
-- Description:	List all KPIs in the system
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetAllKPIs]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [kpiID]
		  ,[name]
		  ,[organizationID]
		  ,[areaID]
		  ,[projectID]
		  ,[activityID]
		  ,[personID]
		  ,[unitID]
		  ,[directionID]
		  ,[strategyID]
		  ,[startDate]
		  ,[reportingUnitID]
		  ,[targetPeriod]
		  ,[allowsCategories]
		  ,[currency]
		  ,[currencyUnitID]
		  ,[kpiTypeID]
	  FROM [dbo].[tbl_KPI]
	  WHERE [deleted] = 0
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez 
-- Create date: 10/05/2016
-- Description:	get activities by project
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivityByProject]
	@intProjectId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[a].[areaID]
		  ,[a].[projectID]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Activity] [a] 
	LEFT OUTER JOIN (SELECT COUNT([kpiID]) [numberKPIs]
						   ,[organizationID]
						   ,[activityID]
					 FROM [dbo].[tbl_KPI] 
					 WHERE [deleted] = 0
					 GROUP BY [organizationID], [activityID]) [kpi] 
	ON [a].[organizationID] = [kpi].[organizationID] AND [a].[activityID] = [kpi].[activityID] 
	WHERE [a].[projectID] = @intProjectId
	AND [a].[deleted] = 0
    
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_PROJ_GetProjectsByOrganization]
	@intOrganizationId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_KPI([kpiId] INT)
	CREATE TABLE #tbl_Project([projectID] INT)
	
	INSERT INTO #tbl_KPI
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
	INSERT INTO #tbl_Project
		EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUserName
	
	SELECT [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Project] [p] 
	INNER JOIN #tbl_Project [d] ON [p].[projectID] = [d].[projectID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] AND [o].[deleted] = 0
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [p].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[projectID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[projectID]) [kpi] ON [p].[projectID] = [kpi].[projectID] 
	WHERE [p].[organizationID] = @intOrganizationId
	AND   [p].[deleted] = 0
	
	DROP TABLE #tbl_Project
    DROP TABLE #tbl_KPI
	
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marcela Martinez
-- Create date: 18/05/2016
-- Description:	Get people by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetPersonByOrganization]
	@intOrganizationId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
    CREATE TABLE #tbl_KPI([kpiId] INT)
	CREATE TABLE #tbl_People([personID] INT)
	
	INSERT INTO #tbl_KPI 
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
		
	INSERT INTO #tbl_People
		EXEC [dbo].[usp_PEOPLE_GetPersonListForUser] @varUserName
	
	SELECT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_People] [p] 
	INNER JOIN #tbl_People [d] ON [p].[personID] = [d].[personID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] AND [o].[deleted]= 0
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [p].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[personID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[personID]) [kpi] ON [p].[personID] = [kpi].[personID] 
	WHERE [p].[organizationID] = @intOrganizationId
	AND [p].[deleted] = 0
	AND [o].[deleted] = 0
    
    DROP TABLE #tbl_People
    DROP TABLE #tbl_KPI
    
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: June 2, 2016
-- Description:	Get the lists of people for search
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetPeopleBySearch]
	@varUsername VARCHAR(25),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblPeople
		(personId INT)

	INSERT INTO #tblPeople
	EXEC [usp_PEOPLE_GetPersonListForUser] @varUsername

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [p].[personID]
				  ,[p].[id]
				  ,[p].[name]
				  ,[p].[organizationID]
				  ,[p].[areaID]
			FROM [dbo].[tbl_People] [p]
			INNER JOIN #tblPeople [t] ON [p].[personID] = [t].[personId]
			INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID] AND [o].[deleted] = 0
			LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]
	        WHERE [g].[deleted] = 0 and ' + @varWhereClause + '
	        ORDER BY [p].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblPeople
	 
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 29 2016
-- Description:	Get areas by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_ORG_GetAreasByOrganization]
	@intOrganizationId INT,
	@varUserName AS VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_KPI([kpiId] INT)
	
	INSERT INTO #tbl_KPI
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	
	SELECT [a].[areaID]
		  ,[a].[organizationID]
		  ,[a].[name]
		  ,[o].[name] [organizationName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Area] [a] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] AND [o].[deleted] = 0
	LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[areaID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[areaID]) [kpi] ON [a].[areaID] = [kpi].[areaID] 
	WHERE [a].[organizationID] = @intOrganizationId
	
    DROP TABLE #tbl_KPI
	
END
GO

--=================================================================================================

/*
 * We are done, mark the database as a 1.14.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,14,0)
GO

