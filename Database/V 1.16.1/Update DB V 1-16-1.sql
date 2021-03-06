/* 
	Updates de the KPIDB database to version 1.16.1 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.16.1'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 16) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.16 This program only applies to version 1.16',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

--===================================================================================================


USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectListForUser]    Script Date: 07/05/2016 11:22:42 ******/
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
	select [p].[projectID], 'ORG OWN (1)', [p].[organizationID] 
	from [dbo].[tbl_Project] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of PROJs all of these that are directly associated 
	--   to the organization

	insert into @projList
	select [projectID], 'ORG MAN_KPI (2)', [p].[organizationID] 
	from [dbo].[tbl_Project] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[organizationID] in (
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
	select [projectID], 'ORG MAN_PROJECT (3)', [p].[organizationID] 
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
	--   MAN_ACTITIVIES and search for PROJ that are associated to these ORGs then add to the 
	--   PROJ list all of the PROJs.
	
	insert into @projList
	select [projectID], 'ORG MAN_ACTIVITY (4)', [p].[organizationID] 
	from [dbo].[tbl_Project] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [p].[organizationID] in (
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
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [o].[deleted] = 0
	  and [p].[deleted] = 0
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
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [a].[deleted] = 0
	  and [o].[deleted] = 0
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
	from [dbo].[tbl_Project] [p] 
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [o].[deleted] = 0
	  and [projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @projList
	select [projectID], 'PROJ-MAN_KPI (6)', [projectID] 
	FROM [dbo].[tbl_Project] [p] 
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [o].[deleted] = 0
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
	from [dbo].[tbl_Project] [p] 
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	 and  [o].[deleted] = 0
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
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	 and  [k].[deleted] = 0
	 and  [o].[deleted] = 0
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
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	 and  [k].[deleted] = 0
	 and  [o].[deleted] = 0
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

	select distinct projectID, sourceObjectType from @projList 


END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetAllActivities]    Script Date: 06/28/2016 17:07:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 22 2016
-- Description:	List all activities in the system
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetAllActivities]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[g].[name] [organizationName]
		  ,[a].[areaID]
		  ,[r].[name] [areaName]
		  ,[a].[projectID]
		  ,ISNULL([p].[name],'') as [projectName]
		  ,0 as isOwner
		  ,0 as [numberKPIs]
	FROM [dbo].[tbl_Activity] [a]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	
END
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]    Script Date: 07/06/2016 11:05:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get activities for autocomplete
-- =============================================
ALTER PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@intProjectId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_Activity
		(activityId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT(0))
	
	INSERT INTO #tbl_Activity (activityId, sourceObjectType)
	EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUsername
	
    SELECT DISTINCT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[g].[name] [organizationName]
		  ,[a].[areaID]
		  ,ISNULL([r].[name],'') [areaName]
		  ,[a].[projectID]
		  ,ISNULL([p].[name],'') as [projectName]
		  ,0 as isOwner
		  ,0 as [numberKPIs]
	FROM [dbo].[tbl_Activity] [a] 
	INNER JOIN #tbl_Activity [d] ON [a].[activityID] = [d].[activityID]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	WHERE [a].[name] LIKE CASE @varFilter WHEN '' THEN [a].[name] ELSE '%' + @varFilter + '%' END 
	AND [a].[deleted] = 0
	AND [g].[deleted] = 0
	AND CASE WHEN [a].[projectID] IS NOT NULL THEN
	         CASE WHEN [p].[deleted] = 0 THEN 1 ELSE 0 END
	         ELSE 1
	    END = 1
	AND [a].[organizationID] = @intOrganizationId 
	AND ISNULL([a].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([a].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	AND ISNULL([a].[projectID],0) = CASE WHEN ISNULL(@intProjectId,0) = 0 THEN ISNULL([a].[projectID],0) ELSE ISNULL(@intProjectId,0) END 
	ORDER BY [a].[name]
    
    DROP TABLE #tbl_Activity
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectPermissionsByUser]    Script Date: 07/06/2016 12:55:19 ******/
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
	DECLARE @activityID INT

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
		
		INSERT @tblPermissions
		SELECT [objectID]
		      ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op]
		WHERE [objectTypeID] = 'ORGANIZATION' 
		and   [objectID] = @organizationID
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
		
		INSERT @tblPermissions
		SELECT [objectID]
		      ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op]
		WHERE [objectTypeID] = 'ORGANIZATION' 
		and   [objectID] = @organizationID
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
		SELECT [objectID]
		      ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op]
		WHERE [objectTypeID] = 'ORGANIZATION' 
		and   [objectID] = @organizationID
		
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
		
		INSERT @tblPermissions
		SELECT [objectID]
		      ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op]
		WHERE [objectTypeID] = 'PROJECT' 
		and   [objectID] = @projectID
	END
	
	IF (@varObjectTypeId = 'KPI')
	BEGIN
		SELECT @organizationID = organizationID,
		       @projectID = projectID,
		       @activityID = activityID
		FROM [dbo].[tbl_KPI]
		WHERE [kpiID] = @intObjectId
		
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
		SELECT [objectID]
		      ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op]
		WHERE [objectTypeID] = 'ORGANIZATION' 
		and   [objectID] = @organizationID
		
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
		
		INSERT @tblPermissions
		SELECT [objectID]
		      ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op]
		WHERE [objectTypeID] = 'PROJECT' 
		and   [objectID] = @projectID
		
		INSERT @tblPermissions
		SELECT [op].[objectID]
			  ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,[op].[username]
			  ,[us].[fullname]
			  ,[us].[email]
		FROM [dbo].[tbl_SEG_ObjectPermissions] [op] 
		INNER JOIN [dbo].[tbl_SEG_User] [us] ON [op].[username] = [us].[username] 
		WHERE [op].[objectTypeID] = 'ACTIVITY'  
		AND [op].[objectID] = @activityID 
		AND [op].[username] = @varUserName
		
		INSERT @tblPermissions
		SELECT [objectID]
		      ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op]
		WHERE [objectTypeID] = 'ACTIVITY' 
		and   [objectID] = @activityID
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

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TRASH_GetTrashByObjectType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TRASH_GetTrashByObjectType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 06/07/2016
-- Description:	Get Trash By object type
-- =============================================
CREATE PROCEDURE [dbo].[usp_TRASH_GetTrashByObjectType]
	@objectType VARCHAR(25),
	@whereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @whereClause IS NULL
		SET @whereClause = ''

	IF (@objectType = 'ORGANIZATION')
		SELECT [organizationID] as objectId
			  ,[name]
			  ,[dateDeleted]
			  ,[usernameDeleted]
			  ,[u].[fullname]
		FROM [dbo].[tbl_Organization] [o]
		INNER JOIN [dbo].[tbl_SEG_User] [u] ON [o].[usernameDeleted] = [u].[username]
		WHERE [deleted] = 1
		AND name like '%' + @whereClause + '%'
		ORDER BY [dateDeleted] DESC

	IF (@objectType = 'PROJECT')
		SELECT [projectID] as objectId
			  ,[name]
			  ,[dateDeleted]
			  ,[usernameDeleted]
			  ,[u].[fullname]
		FROM [dbo].[tbl_Project] [p]
		INNER JOIN [dbo].[tbl_SEG_User] [u] ON [p].[usernameDeleted] = [u].[username]
		WHERE [deleted] = 1
		AND name like '%' + @whereClause + '%'
		ORDER BY [dateDeleted] DESC

	IF (@objectType = 'PERSON')
		SELECT [personID] as objectId
			  ,[name]
			  ,[dateDeleted]
			  ,[usernameDeleted]
			  ,[u].[fullname]
		FROM [dbo].[tbl_People] [p]
		INNER JOIN [dbo].[tbl_SEG_User] [u] ON [p].[usernameDeleted] = [u].[username]
		WHERE [deleted] = 1
		AND name like '%' + @whereClause + '%'
		ORDER BY [dateDeleted] DESC
		
	IF (@objectType = 'ACTIVITY')
		SELECT [activityID] as objectId
			  ,[name]
			  ,[dateDeleted]
			  ,[usernameDeleted]
			  ,[u].[fullname]
		FROM [dbo].[tbl_Activity] [p]
		INNER JOIN [dbo].[tbl_SEG_User] [u] ON [p].[usernameDeleted] = [u].[username]
		WHERE [deleted] = 1
		AND name like '%' + @whereClause + '%'
		ORDER BY [dateDeleted] DESC

	IF (@objectType = 'KPI')
		SELECT [kpiID] as objectId
			  ,[name]
			  ,[dateDeleted]
			  ,[usernameDeleted]
			  ,[u].[fullname]
		FROM [dbo].[tbl_KPI] [p]
		INNER JOIN [dbo].[tbl_SEG_User] [u] ON [p].[usernameDeleted] = [u].[username]
		WHERE [deleted] = 1
		AND name like '%' + @whereClause + '%'
		ORDER BY [dateDeleted] DESC
		
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_TRASH_RestoreTrashObject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_TRASH_RestoreTrashObject]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 06/07/2016
-- Description:	Restore object from Trash
-- =============================================
CREATE PROCEDURE [dbo].[usp_TRASH_RestoreTrashObject]
	@objectType VARCHAR(25),
	@objectId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF (@objectType = 'ORGANIZATION')
		UPDATE [dbo].[tbl_Organization] 
		SET [deleted] = 0
		WHERE [organizationID] = @objectId
			  

	IF (@objectType = 'PROJECT')
		UPDATE [dbo].[tbl_Project] 
		SET [deleted] = 0
		WHERE [projectID] = @objectId

	IF (@objectType = 'PERSON')
		UPDATE [dbo].[tbl_People] 
		SET [deleted] = 0
		WHERE [personID] = @objectId
		
	IF (@objectType = 'ACTIVITY')
		UPDATE [dbo].[tbl_Activity]
		SET [deleted] = 0
		WHERE [activityID] = @objectId

	IF (@objectType = 'KPI')
		UPDATE [dbo].[tbl_KPI]
		SET [deleted] = 0
		WHERE [kpiID] = @objectId
		
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_DeletePermanentlyPerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_DeletePermanentlyPerson]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: July 8, 2016
-- Description:	Delete a peolple and all of the 
-- related objects
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_DeletePermanentlyPerson]
	@personID int
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
		SAVE TRANSACTION DeletePerson;     
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
		where [personID] = @personID

		-- Delete all measurements for the KPIs selected

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		-- Now lets delete all activities for the project
		-- Get the IDs of all the activities we will delete
		-- Delete all the permissios for these activities
		-- Delete the activities

		-- Now lets delete the permissions for the project

		-- And finally lets delete the project

		-- =============================================================
		-- INSERT THE SQL STATEMENTS HERE
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PERSON'
		AND   [objectID] = @personID
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories]
		WHERE [measurementID] IN (SELECT [measurementID]
		                          FROM [dbo].[tbl_KPIMeasurements]
		                          WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] IN (select kpiID from @KPITable)
		
		DELETE FROM [dbo].[tbl_KPITargetCategories]
		WHERE [targetID] IN (SELECT targetID 
		                     FROM [dbo].[tbl_KPITarget]
							 WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPITarget]
		WHERE [kpiID] IN (select kpiID from @KPITable)
		
		DELETE FROM [dbo].[tbl_KPI]
	    WHERE [personID] = @personID
	    
		DELETE FROM [dbo].[tbl_People]
	    WHERE [personID] = @personID
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
				ROLLBACK TRANSACTION DeletePerson;

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


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_DeletePermanentlyKPI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_DeletePermanentlyKPI]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: July 8, 2016
-- Description:	Delete a kpi and all of the 
-- related objects
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_DeletePermanentlyKPI]
	@kpiID int
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
		SAVE TRANSACTION DeleteKpi;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		-- =============================================================
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] = @kpiID
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories]
		WHERE [measurementID] IN (SELECT [measurementID]
		                          FROM [dbo].[tbl_KPIMeasurements]
		                          WHERE [kpiID] = @kpiID)
		
		DELETE FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] = @kpiID
		
		DELETE FROM [dbo].[tbl_KPITargetCategories]
		WHERE [targetID] IN (SELECT targetID 
		                     FROM [dbo].[tbl_KPITarget]
							 WHERE [kpiID] = @kpiID)
		
		DELETE FROM [dbo].[tbl_KPITarget]
		WHERE [kpiID] = @kpiID
		
		DELETE FROM [dbo].[tbl_KPI]
	    WHERE [kpiID] = @kpiID
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
				ROLLBACK TRANSACTION DeleteKpi;

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


/****** Object:  StoredProcedure [dbo].[usp_ORG_DeletePermanentlyOrganization]    Script Date: 07/08/2016 17:31:06 ******/
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
ALTER PROCEDURE [dbo].[usp_ORG_DeletePermanentlyOrganization]
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
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories]
		WHERE [measurementID] IN (SELECT [measurementID]
		                          FROM [dbo].[tbl_KPIMeasurements]
		                          WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] IN (select kpiID from @KPITable)
		
		DELETE FROM [dbo].[tbl_KPITargetCategories]
		WHERE [targetID] IN (SELECT targetID 
		                     FROM [dbo].[tbl_KPITarget]
							 WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPITarget]
		WHERE [kpiID] IN (select kpiID from @KPITable)
		
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

/****** Object:  StoredProcedure [dbo].[usp_ACT_DeletePermanentlyActivity]    Script Date: 07/08/2016 17:44:27 ******/
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
ALTER PROCEDURE [dbo].[usp_ACT_DeletePermanentlyActivity]
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
		
		-- Start with KPIs. 
		-- Get the IDs of all the KPIs we will delete
		DECLARE @KPITable as TABLE (kpiID int)
		
		INSERT INTO @KPITable
		SELECT [kpiID] from [dbo].[tbl_KPI]
		where [activityID] = @activityID

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ACTIVITY'
		AND   [objectID] = @activityID
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories]
		WHERE [measurementID] IN (SELECT [measurementID]
		                          FROM [dbo].[tbl_KPIMeasurements]
		                          WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] IN (select kpiID from @KPITable)
		
		DELETE FROM [dbo].[tbl_KPITargetCategories]
		WHERE [targetID] IN (SELECT targetID 
		                     FROM [dbo].[tbl_KPITarget]
							 WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPITarget]
		WHERE [kpiID] IN (select kpiID from @KPITable)
		
		DELETE FROM [dbo].[tbl_KPI]
	    WHERE [activityID] = @activityID
		
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

/****** Object:  StoredProcedure [dbo].[usp_PROJ_DeletePermanentlyProject]    Script Date: 07/08/2016 18:06:56 ******/
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
ALTER PROCEDURE [dbo].[usp_PROJ_DeletePermanentlyProject]
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

		-- Delete all permissions for the KPIs selected
		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and [objectID] in (select kpiID from @KPITable)

		DELETE FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'PROJECT'
		AND   [objectID] = @projectID

		DELETE FROM [dbo].[tbl_KPIMeasurementCategories]
		WHERE [measurementID] IN (SELECT [measurementID]
		                          FROM [dbo].[tbl_KPIMeasurements]
		                          WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPIMeasurements]
		WHERE [kpiID] IN (select kpiID from @KPITable)
		
		DELETE FROM [dbo].[tbl_KPITargetCategories]
		WHERE [targetID] IN (SELECT targetID 
		                     FROM [dbo].[tbl_KPITarget]
							 WHERE [kpiID] IN (select kpiID from @KPITable))
		
		DELETE FROM [dbo].[tbl_KPITarget]
		WHERE [kpiID] IN (select kpiID from @KPITable)
				
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

--=================================================================================================

/*
 * We are done, mark the database as a 1.16.1 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,16,1)
GO

