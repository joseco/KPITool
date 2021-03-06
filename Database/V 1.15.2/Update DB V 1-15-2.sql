/* 
	Updates de the KPIDB database to version 1.15.2
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.15.2'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 15) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.15 This program only applies to version 1.15',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 06/28/2016 13:00:10 ******/
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
	
	CREATE TABLE #tblKPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tblKPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID]
	WHERE [k].[organizationID] = @intOrganizationId
    AND [o].[deleted] = 0
    AND CASE WHEN [k].[projectID] IS NOT NULL THEN
             CASE WHEN [p].[deleted] = 0 THEN 1 ELSE 0 END
             ELSE 1
        END = 1
    AND CASE WHEN [k].[activityID] IS NOT NULL THEN
             CASE WHEN [ac].[deleted] = 0 THEN 1 ELSE 0 END
             ELSE 1
        END = 1
    AND CASE WHEN [k].[personID] IS NOT NULL THEN
             CASE WHEN [pe].[deleted] = 0 THEN 1 ELSE 0 END
             ELSE 1
        END = 1
    
    DROP TABLE #tbl_KPI
	
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAreasByOrganization]    Script Date: 06/28/2016 13:06:18 ******/
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
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
						 
	SELECT [a].[areaID]
		  ,[a].[organizationID]
		  ,[a].[name]
		  ,[o].[name] [organizationName]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Area] [a] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN (SELECT areaID, COUNT(1)  [numberKPIs]
					 FROM (
						 SELECT DISTINCT [k].[kpiID],[k].[areaID]
						 FROM [dbo].[tbl_KPI] [k] 
						 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId])x
					 GROUP By areaID) [kpi] ON [a].[areaID] = [kpi].[areaID] 
	WHERE [a].[organizationID] = @intOrganizationId
	AND   [o].[deleted] = 0
	
    DROP TABLE #tbl_KPI
	
END
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 06/28/2016 13:18:13 ******/
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
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[organizationID] = @intOrganizationId
	  AND [o].[deleted] = 0
	  AND CASE WHEN [k].[projectID] IS NOT NULL THEN
				CASE WHEN [p].[deleted] = 0 THEN 1 ELSE 0 END
			   ELSE 1
		  END = 1
	  AND CASE WHEN [k].[activityID] IS NOT NULL THEN
				CASE WHEN [ac].[deleted] = 0 THEN 1 ELSE 0 END
			   ELSE 1
		  END = 1
      AND CASE WHEN [k].[personID] IS NOT NULL THEN
				CASE WHEN [pe].[deleted] = 0 THEN 1 ELSE 0 END
			   ELSE 1
		  END = 1
    
    DROP TABLE #tbl_KPI
    
END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ORG_GetQuantitiesByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ORG_GetQuantitiesByOrganization]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: 28/06/2016
-- Description:	Get quantities by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetQuantitiesByOrganization]
	@organizationID INT,
	@varUserName VARCHAR(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @nroAreas AS INT
	DECLARE @nroProjects AS INT
	DECLARE @nroPeople AS INT
	DECLARE @nroActivities AS INT
	DECLARE @nroKpis AS INT

	--Areas
	SELECT @nroAreas = COUNT(1)
	FROM [dbo].[tbl_Area] [a] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	WHERE [o].[organizationID] = @organizationID

	--Proyectos
	CREATE TABLE #tbl_Project
	([projectID] INT, 
	 [sourceObjectType] VARCHAR(100))
	
	INSERT INTO #tbl_Project (projectId, sourceObjectType)
	EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUsername

	SELECT @nroProjects = COUNT(1) 
	FROM (
	SELECT DISTINCT p.projectID
	FROM [dbo].[tbl_Project] [p] 
	INNER JOIN #tbl_Project [d] ON [p].[projectID] = [d].[projectID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
	WHERE [o].[organizationID] = @organizationID) x

	--Personas
	CREATE TABLE #tbl_People
		(personId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_People (personId, sourceObjectType)
	EXEC [usp_PEOPLE_GetPersonListForUser] @varUsername


	SELECT @nroPeople = COUNT(1)
	FROM (
	SELECT DISTINCT p.personID
	FROM [dbo].[tbl_People] [p] 
	INNER JOIN #tbl_People [d] ON [p].[personID] = [d].[personID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
	WHERE [o].[organizationID] = @organizationID) X

	--Actividades
	CREATE TABLE #tbl_Activity
		(activityId INT,
		 sourceObjectType VARCHAR(100))
		
	INSERT INTO #tbl_Activity (activityId, sourceObjectType)
	EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUsername
		
	SELECT @nroActivities = COUNT(1)
	FROM (SELECT DISTINCT [a].[activityID]
	FROM [dbo].[tbl_Activity] [a] 
	INNER JOIN #tbl_Activity [d] ON [a].[activityID] = [d].[activityID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	WHERE [o].[organizationID] = @organizationID) X

	--KPIs
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername

	SELECT @nroKpis = COUNT(1)
	FROM (
	SELECT DISTINCT k.kpiID
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID]
	WHERE [o].[organizationID] = @organizationID) X

	SELECT @nroAreas as Areas,
		   @nroProjects as Projects,
		   @nroPeople as People,
		   @nroActivities as Activities,
		   @nroKpis as Kpis
	       
	DROP TABLE #tbl_Project
	DROP TABLE #tbl_People
	DROP TABLE #tbl_Activity
	DROP TABLE #tbl_KPI

END
GO


/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectListForUser]    Script Date: 06/28/2016 15:35:47 ******/
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
	select [projectID], 'ORG MAN_ORG (2)', [p].[organizationID] 
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

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsBySearch]    Script Date: 06/28/2016 15:32:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
ALTER PROCEDURE [dbo].[usp_PROJ_GetProjectsBySearch]
	@varUsername VARCHAR(50),
	@varWhereClause VARCHAR(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tblProject
		(projectId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT (0))
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
		
	INSERT INTO #tblProject (projectId, sourceObjectType)
	EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUsername

	UPDATE #tblProject
	SET isOwner = 1
	WHERE sourceObjectType IN ('ORG OWN (1)','ORG MAN_ORG (2)','ORG MAN_PROJECT (3)','PROJ OWN (6)')

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT DISTINCT [p].[projectID]
						,[p].[name]
						,[p].[organizationID]
						,[o].[name] as [organizationName]
						,[p].[areaID]
						,[a].[name] as [areaName]
						,[kpi].[numberKPIs]
						,CASE WHEN [t].[isOwner] > 0 THEN 1 ELSE 0 END isOwner
						,'''' as [owner]
					FROM [dbo].[tbl_Project] [p]
					INNER JOIN (SELECT projectId, SUM(isOwner) isOwner
								FROM #tblProject
								GROUP BY projectId) [t] ON [p].[projectID] = [t].[projectId]
					INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationId] = [o].[organizationId]
					LEFT JOIN [dbo].[tbl_Area] [a] ON [a].[areaID] = [p].[areaID]
					LEFT OUTER JOIN (SELECT COUNT(DISTINCT [k].[kpiID]) [numberKPIs],[k].[projectID]
					                 FROM [dbo].[tbl_KPI] [k] 
					                 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					                 GROUP BY [k].[projectID]) [kpi] ON [p].[projectID] = [kpi].[projectID] 
					WHERE ' + @varWhereClause + '
					ORDER BY [p].[name]'
	
	EXEC (@varSQL)

	DROP TABLE #tblProject

END
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectById]    Script Date: 06/28/2016 15:45:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get Project by id
-- =============================================
ALTER PROCEDURE [dbo].[usp_PROJ_GetProjectById]
	@intProjectId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[o].[name] as [organizationName]
		  ,[p].[areaID]
		  ,[a].[name] as [areaName]
		  ,0 as [numberKPIs]
		  ,0 as [isOwner]
		  ,(SELECT TOP 1 username
		    FROM dbo.tbl_SEG_ObjectPermissions
		    WHERE [objectTypeID] = 'PROJECT'
		    AND   [objectID] = @intProjectId
		    AND   [objectActionID] = 'OWN') as [owner]
	FROM [dbo].[tbl_Project][p]
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationId] = [o].[organizationId]
	LEFT JOIN [dbo].[tbl_Area] [a] ON [a].[areaID] = [p].[areaID]
	WHERE [projectID] = @intProjectId
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsByOrganization]    Script Date: 06/28/2016 15:48:54 ******/
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
	
	CREATE TABLE #tbl_Project
	([projectID] INT, 
	 [sourceObjectType] VARCHAR(100), 
	 [isOwner] INT DEFAULT(0))
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
	INSERT INTO #tbl_Project (projectId, sourceObjectType)
	EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUsername

	UPDATE #tbl_Project
	SET isOwner = 1
	WHERE sourceObjectType IN ('ORG OWN (1)','ORG MAN_ORG (2)','ORG MAN_PROJECT (3)','PROJ OWN (6)')
	
	SELECT [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,[kpi].[numberKPIs]
		  ,CASE WHEN [d].[isOwner] > 0 THEN 1 ELSE 0 END isOwner
		  ,'' as [owner]
	FROM [dbo].[tbl_Project] [p] 
	INNER JOIN (SELECT projectId, SUM(isOwner) isOwner
				FROM #tbl_Project
				GROUP BY projectId)[d] ON [p].[projectID] = [d].[projectID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [p].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN (SELECT COUNT(DISTINCT[k].[kpiID]) [numberKPIs]
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

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchProjects]    Script Date: 06/28/2016 15:55:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get projects for autocomplete
-- =============================================
ALTER PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchProjects]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@varFilter IS NULL)
		SELECT @varFilter = ''
	
	CREATE TABLE #tbl_Project
	([projectID] INT, 
	 [sourceObjectType] VARCHAR(100))
	
	INSERT INTO #tbl_Project (projectId, sourceObjectType)
	EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUsername
	
	SELECT DISTINCT 
	       [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,0 as [numberKPIs]
		  ,0 as [isOwner]
		  ,'' as [owner]
	FROM [dbo].[tbl_Project] [p] 
	INNER JOIN #tbl_Project [d] ON [p].[projectID] = [d].[projectID]
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [p].[areaID] = [a].[areaID] 
	WHERE [p].[name] LIKE CASE @varFilter WHEN '' THEN [p].[name] ELSE '%' + @varFilter + '%' END 
	AND [p].[organizationID] = @intOrganizationId 
	AND ISNULL([p].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([p].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	ORDER BY [p].[name]
    
    DROP TABLE #tbl_Project
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByProject]    Script Date: 06/28/2016 16:14:48 ******/
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

	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID]
	WHERE [k].[projectID] = @intProjectId
	AND [o].[deleted] = 0
	AND CASE WHEN [k].[projectID] IS NOT NULL THEN 
	         CASE WHEN [p].[deleted] = 0 THEN 1 ELSE 0 END
	         ELSE 1
	    END = 1
	AND CASE WHEN [k].[activityID] IS NOT NULL THEN 
	         CASE WHEN [ac].[deleted] = 0 THEN 1 ELSE 0 END
	         ELSE 1
	    END = 1
	AND CASE WHEN [k].[personID] IS NOT NULL THEN 
	         CASE WHEN [pe].[deleted] = 0 THEN 1 ELSE 0 END
	         ELSE 1
	    END = 1
    
    DROP TABLE #tbl_KPI
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityListForUser]    Script Date: 06/28/2016 16:46:32 ******/
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
	select [activityID], 'ORG OWN (1)', [a].[organizationID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID Is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  AND [a].[organizationID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
			and username = @userName
	)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of ACTs all of these that are directly associated 
	--   to the organization

	insert into @actList
	select [activityID], 'ORG MAN_KPI (2)', [a].[organizationID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID Is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  and [a].[organizationID] in (
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
	select [activityID], 'ORG MAN_PROJECT (3)', [a].[organizationID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  and [a].[organizationID] in (
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
	select [activityID], 'ORG MAN_ACTIVITY (4)', [a].[organizationID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  and [a].[organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_ACTIVITY'
	)  and [a].[projectID] is null

	--5. Search for all ACT where the user has OWN or MAN_KPI permissions or the ACT is public 
	--   MAN_KPI and add to the ACT list all of the ACTs.

	insert into @actList
	select [activityID], 'ACT OWN (5)', [activityID]
	from  [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  and [activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	) 

	insert into @actList
	select [activityID], 'ACT-MAN_KPI (5)', [activityID] 
	FROM [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
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
	select [activityID], 'PROJ OWN (6)', [a].[projectID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  and [a].[projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @actList
	select [activityID], 'PROJ-MAN_KPI (6)', [a].[projectID] 
	FROM [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  and [a].[projectID] in (
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
	select [activityID], 'PROJ-MAN_ACTIVITY (7)', [a].[projectID] 
	from [dbo].[tbl_Activity] [a]
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [a].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [a].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
	  and [a].[projectID] in (
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
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [a].[deleted] = 0
	  and [k].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [k].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
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
	inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID]
	where [a].[deleted] = 0
	  and [k].[deleted] = 0
	  AND [o].[deleted] = 0
	  AND case when [k].projectID is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
		  end = 1
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

	select distinct [activityID],[sourceObjectType] from @actList 


END
GO


/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivitiesByProject]    Script Date: 06/28/2016 16:58:48 ******/
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

    	CREATE TABLE #tbl_Activity
		(activityId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT(0))
	
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
	INSERT INTO #tbl_Activity (activityId, sourceObjectType)
	EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUsername
    
    SELECT DISTINCT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[o].[name] [organizationName]
		  ,[a].[areaID]
		  ,[ar].[name] [areaName]
		  ,[a].[projectID]
		  ,ISNULL([p].[name],'''') as [projectName]
		  ,0 as isOwner
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_Activity] [a] 
	INNER JOIN #tbl_Activity [d] ON [a].[activityID] = [d].[activityID]
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [ar] ON [a].[areaID] = [ar].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [a].[projectID] = [p].[projectID] 
    LEFT OUTER JOIN (SELECT COUNT( DISTINCT[k].[kpiID]) [numberKPIs]
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

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityById]    Script Date: 06/28/2016 16:57:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get persona by id
-- =============================================
ALTER PROCEDURE [dbo].[usp_ACT_GetActivityById]
	@intActivityId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[g].[name] [organizationName]
		  ,[a].[areaID]
		  ,[r].[name] [areaName]
		  ,[a].[projectID]
		  ,ISNULL([p].[name],'''') as [projectName]
		  ,0 as isOwner
		  ,0 as [numberKPIs]
	FROM [dbo].[tbl_Activity] [a]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	WHERE [activityID] = @intActivityId
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivitiesBySearch]    Script Date: 06/28/2016 16:44:30 ******/
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
		(activityId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT(0))
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
	INSERT INTO #tblActivity (activityId, sourceObjectType)
	EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUsername

	UPDATE #tblActivity
	SET [isOwner] = 1
	WHERE [sourceObjectType] IN ('ORG OWN (1)','ORG MAN_PROJECT (3)','ORG MAN_ACTIVITY (4)',
	'ACT OWN (5)','PROJ OWN (6)','PROJ-MAN_ACTIVITY (7)')

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [a].[activityID]
		  ,[a].[name]
		  ,[a].[organizationID]
		  ,[g].[name] [organizationName]
		  ,[a].[areaID]
		  ,[r].[name] [areaName]
		  ,[a].[projectID]
		  ,ISNULL([p].[name],'''') as [projectName]
		  ,CASE WHEN ISNULL([t].[isOwner],0) > 0 THEN 1 ELSE 0 END as isOwner
		  ,[kpi].[numberKPIs]
	  FROM [dbo].[tbl_Activity] [a]
	  INNER JOIN (
		    SELECT activityId, SUM(isOwner) as isOwner
			FROM #tblActivity
			GROUP BY activityId) [t] ON [a].[activityID] = [t].[activityId]
	  INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	  LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	  LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	  LEFT OUTER JOIN (SELECT COUNT(DISTINCT [k].[kpiID]) [numberKPIs]
							   ,[k].[activityID]
						 FROM [dbo].[tbl_KPI] [k] 
						 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
						 GROUP BY [k].[activityID]) [kpi] ON [a].[activityID] = [kpi].[activityID] 
	  WHERE [g].[deleted] = 0
	  AND CASE WHEN [a].[projectID] IS NOT NULL THEN
	           CASE WHEN [p].[deleted] = 0 THEN 1 ELSE 0 END
	           ELSE 1
	      END = 1
	  AND ' + @varWhereClause + '
	  ORDER BY [g].[name], [p].[name],[a].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblActivity
	 
END
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByOrganization]    Script Date: 06/28/2016 17:05:30 ******/
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
	
	CREATE TABLE #tbl_Activity
		(activityId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT(0))
	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername

	INSERT INTO #tbl_Activity (activityId, sourceObjectType)
	EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUsername
	
    SELECT DISTINCT [a].[activityID]
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
	LEFT OUTER JOIN (SELECT COUNT(DISTINCT [k].[kpiID]) [numberKPIs]
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

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByProject]    Script Date: 06/28/2016 17:06:53 ******/
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
		  ,[g].[name] [organizationName]
		  ,[a].[areaID]
		  ,[r].[name] [areaName]
		  ,[a].[projectID]
		  ,ISNULL([p].[name],'''') as [projectName]
		  ,0 as isOwner
		  ,0 as [numberKPIs]
	FROM [dbo].[tbl_Activity] [a]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	WHERE [activityID] = @intProjectId
    
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
		  ,ISNULL([p].[name],'''') as [projectName]
		  ,0 as isOwner
		  ,0 as [numberKPIs]
	FROM [dbo].[tbl_Activity] [a]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [a].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [a].[areaID] = [r].[areaID]
	LEFT JOIN [dbo].[tbl_Project] [p] ON [p].[projectID] = [a].[projectID]
	
END
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]    Script Date: 06/28/2016 17:43:15 ******/
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
		  ,[a].[areaID]
		  ,[a].[projectID]
	FROM [dbo].[tbl_Activity] [a] 
	INNER JOIN #tbl_Activity [d] ON [a].[activityID] = [d].[activityID]
	WHERE [a].[name] LIKE CASE @varFilter WHEN '' THEN [a].[name] ELSE '%' + @varFilter + '%' END 
	AND [a].[organizationID] = @intOrganizationId 
	AND ISNULL([a].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([a].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	AND ISNULL([a].[projectID],0) = CASE WHEN ISNULL(@intProjectId,0) = 0 THEN ISNULL([a].[projectID],0) ELSE ISNULL(@intProjectId,0) END 
	ORDER BY [a].[name]
    
    DROP TABLE #tbl_Activity
    
END
GO


/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonListForUser]    Script Date: 06/28/2016 17:46:45 ******/
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
	select [personID], 'ORG OWN (1)', [p].[organizationID] 
	from [dbo].[tbl_People] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [o].[deleted] = 0
	  and [p].[organizationID] in (
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
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [k].[deleted] = 0
	  and [o].[deleted] = 0
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
	select [personID], 'ORG MAN_PEOPLE (3)', [p].[organizationID] 
	from [dbo].[tbl_People] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [o].[deleted] = 0
	  and [p].[organizationID] in (
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
	from [dbo].[tbl_People] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [o].[deleted] = 0
	  and [personID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
	)

	insert into @pplList
	select [personID], 'PPL-MAN_KPI (4)', [personID] 
	FROM [dbo].[tbl_People] [p]
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [o].[deleted] = 0
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
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [k].[deleted] = 0
	  and [o].[deleted] = 0
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
	inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID]
	where [p].[deleted] = 0
	  and [k].[deleted] = 0
	  and [o].[deleted] = 0
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

	select distinct personID, sourceObjectType from @pplList 


END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPeopleBySearch]    Script Date: 06/28/2016 17:46:16 ******/
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
		(personId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT(0))

	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
		
	INSERT INTO #tblPeople (personId, sourceObjectType)
	EXEC [usp_PEOPLE_GetPersonListForUser] @varUsername

	UPDATE #tblPeople
	SET isOwner = 1
	WHERE sourceObjectType IN ('ORG OWN (1)','ORG MAN_PEOPLE (3)','PPL OWN (4)')

	DECLARE @varSQL AS VARCHAR(MAX)

	SET @varSQL = 'SELECT [p].[personID]
				  ,[p].[id]
				  ,[p].[name]
				  ,[p].[organizationID]
				  ,[g].[name] [organizationName]
				  ,[p].[areaID]
				  ,[r].[name] [areaName]
				  ,CASE WHEN ISNULL([t].[isOwner],0) > 0 THEN 1 ELSE 0 END isOwner
				  ,[kpi].[numberKPIs]
			FROM [dbo].[tbl_People] [p]
			INNER JOIN (SELECT personId, SUM(isOwner) isOwner
						FROM #tblPeople
						GROUP BY personId) [t] ON [p].[personID] = [t].[personId]
			INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID]
			LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]
			LEFT OUTER JOIN (SELECT COUNT(DISTINCT [k].[kpiID]) [numberKPIs]
								   ,[k].[personID]
							 FROM [dbo].[tbl_KPI] [k] 
							 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
							 GROUP BY [k].[personID]) [kpi] ON [p].[personID] = [kpi].[personID] 
	        WHERE [g].[deleted] = 0 and ' + @varWhereClause + '
	        ORDER BY [g].[name],[r].[name], [p].[name]'
	  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblPeople
	 
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetAllPeople]    Script Date: 06/28/2016 17:54:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Get the full lists of people
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetAllPeople]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[g].[name] [organizationName]
		  ,[p].[areaID]
		  ,[r].[name] [areaName]
		  ,0 [isOwner]
		  ,0 [numberKPIs]
	FROM [dbo].[tbl_People] [p]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]						 

END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonByArea]    Script Date: 06/28/2016 17:56:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get persona by Area
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetPersonByArea]
	@intAreaId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[g].[name] [organizationName]
		  ,[p].[areaID]
		  ,[r].[name] [areaName]
		  ,0 [isOwner]
		  ,0 [numberKPIs]
	FROM [dbo].[tbl_People] [p]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]	 
	WHERE [p].[areaID] = @intAreaId
    
END
GO


/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonById]    Script Date: 06/28/2016 17:56:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get persona by id
-- =============================================
ALTER PROCEDURE [dbo].[usp_PEOPLE_GetPersonById]
	@intPersonId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

     SELECT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[g].[name] [organizationName]
		  ,[p].[areaID]
		  ,[r].[name] [areaName]
		  ,0 [isOwner]
		  ,0 [numberKPIs]
	FROM [dbo].[tbl_People] [p]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]	
	WHERE [p].[personID] = @intPersonId
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonByOrganization]    Script Date: 06/28/2016 17:57:13 ******/
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
	
    CREATE TABLE #tbl_People
		(personId INT,
		 sourceObjectType VARCHAR(100))

	CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
		
	INSERT INTO #tbl_People (personId, sourceObjectType)
	EXEC [usp_PEOPLE_GetPersonListForUser] @varUsername
	
	SELECT DISTINCT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
		  ,[o].[name] [organizationName]
		  ,[a].[name] [areaName]
		  ,0 [isOwner]
		  ,[kpi].[numberKPIs]
	FROM [dbo].[tbl_People] [p] 
	INNER JOIN #tbl_People [d] ON [p].[personID] = [d].[personID] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] AND [o].[deleted]= 0
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [p].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN (SELECT COUNT(DISTINCT [k].[kpiID]) [numberKPIs]
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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIListForUser]    Script Date: 06/28/2016 18:17:50 ******/
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
	select [kpiID], 'ORG OWN (1)', [k].[organizationID] 
	from [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] and [pj].[deleted] = 0
	left join [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] and [pe].[deleted] = 0
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID] and [a].[deleted] = 0
	where [k].[deleted] = 0
	    and [o].[deleted] = 0
		and case when k.projectID Is not null then
				 case when pj.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.personID Is not null then
				 case when pe.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and [k].[organizationID] in (
					select [objectID]
					from [dbo].[tbl_SEG_ObjectPermissions]
					where [objectTypeID] = 'ORGANIZATION' and objectActionID = 'OWN'
						and username = @userName
			)

	--2. Search for all ORGs where the user has MAN_KPI permissions or ORG has public 
	--   MAN_KPI and add to the list of KPIs all of these that are directly associated 
	--   to the organization and ARE NOT associated to a PROJ, ACT or PPL.  

	insert into @kpiList
	select [kpiID], 'ORG MAN_KPI (2)', [k].[organizationID] 
	from [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and [k].[organizationID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI' AND username = @userName
		UNION
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'ORGANIZATION' and objectActionID = 'MAN_KPI'
	) and [k].[projectID] is null and [k].[activityID] is null and [k].[personID] is null

	--3. Search for all ORGs where the user has MAN_PROJECT permissions or ORG has public 
	--   MAN_PROJECT, then search for all PROJs associated to these ORGs and then add to 
	--   the KPI list all of the KPIs that are associated to these PROJs.

	insert into @kpiList
	select [kpiID], 'ORG MAN_PROJECT (3)', [k].[organizationID] 
	from [dbo].[tbl_KPI] [k]
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID] 
	where [k].[deleted] = 0
	  and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	  and [k].[projectID] in (
			select [projectID]
			from [dbo].[tbl_Project] [p]
			inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
			where [p].[deleted] = 0
			  and [o].[deleted] = 0
			  and [p].[organizationID] in (
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
			from [dbo].[tbl_Project] [p]
			inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
			where [p].[deleted] = 0
			  and [o].[deleted] = 0
	          and [p].[organizationID] in (
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
		from [dbo].[tbl_Activity] [a]
		inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID]
		where [a].[deleted] = 0
		  and [o].[deleted] = 0
	      and [a].[organizationID] in (
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
		from [dbo].[tbl_People] [p]
		inner join [dbo].[tbl_Organization] [o] ON [p].[organizationID] = [o].[organizationID] 
		where [p].[deleted] = 0
		  and [o].[deleted] = 0
	      and [p].[organizationID] in (
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
	select [kpiID], 'ACT OWN (7)', [k].[activityID]
	from [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	inner join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] 
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID] 
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and [pj].[deleted] = 0
	  and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	  and [k].[activityID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'ACTIVITY' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'ACT-MAN_KPI (7)', [k].[activityID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	inner join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] 
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID] 
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and [pj].[deleted] = 0
	  and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	  and [k].[activityID] in (
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
	select [kpiID], 'PROJ OWN (8)', [k].[projectID] 
	from [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	inner join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] 
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID] 
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and [pj].[deleted] = 0
	  and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	  and [k].[projectID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PROJECT' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'PROJ-MAN_KPI (8)', [k].[projectID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	inner join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] 
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID] 
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and [pj].[deleted] = 0
	  and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	  and [k].[projectID] in (
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
		from [dbo].[tbl_Activity] [a]
		inner join [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID] 
	    inner join [dbo].[tbl_Project] [pj] ON [a].[projectID] = [pj].[projectID] 
		where [a].[deleted] = 0
		  and [o].[deleted] = 0
		  and [pj].[deleted] = 0
	      and [a].[projectID] in (
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
	select [kpiID], 'PPL OWN (10)', [k].[personID]
	from [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	inner join [dbo].[tbl_People] [p] ON [k].[personID] = [p].[personID] 
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [k].[personID] in (
		select [objectID]
		from [dbo].[tbl_SEG_ObjectPermissions]
		where [objectTypeID] = 'PERSON' and objectActionID = 'OWN' and username = @userName
	)

	insert into @kpiList
	select [kpiID], 'PPL-MAN_KPI (10)', [k].[personID] 
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	inner join [dbo].[tbl_People] [p] ON [k].[personID] = [p].[personID] 
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and [p].[deleted] = 0
	  and [k].[personID] in (
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
	FROM [dbo].[tbl_KPI] [k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] 
	left join [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID]
	where [k].[deleted] = 0
	  and [o].[deleted] = 0
	  and case when k.projectID Is not null then
				 case when pj.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.personID Is not null then
				 case when pe.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	  and [kpiID] in (
		SELECT [objectID]
		FROM [dbo].[tbl_SEG_ObjectPublic]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI'
	)

	--12.	Add to the KPI list all of the KPIs where the user has OWN or VIEW_KPI or ENTER_DATA
	--      permissions.
	insert into @kpiList
	select [kpiID], 'KPI-OWN-ENTER (12)', [kpiID] 
	FROM [dbo].[tbl_KPI][k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] 
	left join [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID]
	where [k].[deleted] = 0
	    and [o].[deleted] = 0
	    and case when k.projectID Is not null then
				 case when pj.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.personID Is not null then
				 case when pe.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
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
	
	insert into @kpiList
	select [kpiID], 'KPI-VIEW (12)', [kpiID] 
	FROM [dbo].[tbl_KPI][k]
	inner join [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	left join [dbo].[tbl_Project] [pj] ON [k].[projectID] = [pj].[projectID] 
	left join [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	left join [dbo].[tbl_Activity] [a] ON [k].[activityID] = [a].[activityID]
	where [k].[deleted] = 0
	    and [o].[deleted] = 0
	    and case when k.projectID Is not null then
				 case when pj.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.personID Is not null then
				 case when pe.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
		and case when k.activityID Is not null then
				 case when a.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	  and [kpiID] in (
		SELECT [objectID] 
		FROM [dbo].[tbl_SEG_ObjectPermissions]
		WHERE [objectTypeID] = 'KPI' and objectActionID = 'VIEW_KPI' AND username = @userName
	)


	select distinct kpiID, sourceObjectType from @kpiList 


END
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsBySearch]    Script Date: 06/28/2016 18:16:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---- =============================================
-- Author:		Ivan Krsul
-- Create date: May 5 2016
-- Description:	List all KPIs in the system by Search
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKPIsBySearch]
	@varUserName VARCHAR(50),
	@varWhereClause VARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	CREATE TABLE #tblKPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100),
		 isOwner INT DEFAULT(1))

	INSERT INTO #tblKPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
	UPDATE #tblKPI
	SET isOwner = 0
	WHERE sourceObjectType IN ('KPI-PUB VIEW (11)','KPI-VIEW (12)')
	
	DECLARE @varSQL VARCHAR(MAX)

	SET @varSQL = 'SELECT [k].[kpiID]
				  ,[k].[name]
				  ,[k].[organizationID]
				  ,[o].[name] organizationName
				  ,[k].[areaID]
				  ,[a].[name] areaName
				  ,[k].[projectID]
				  ,[p].[name] projectName
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
				  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'''','''') [progress]
				  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
				  ,CASE WHEN ISNULL([tk].[isOwner],0) > 0 THEN 1 ELSE 0 END isOwner
			  FROM [dbo].[tbl_KPI] [k]
			  INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID]
			  LEFT JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID]
			  LEFT JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID]
			  INNER JOIN (
						  SELECT kpiId, SUM(isOwner) as isOwner
						  FROM #tblKPI
						  GROUP BY kpiId) [tk] ON [k].[KPIId] = [tk].[KPIId]
			  WHERE ' + @varWhereClause
			  
	 EXEC (@varSQL)
	 
	 DROP TABLE #tblKPI
	 
END
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByActivity]    Script Date: 06/28/2016 18:40:19 ******/
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

    CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[activityID] = @intActivityId
	AND [o].[deleted] = 0
	and case when k.projectID Is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	and case when k.personID Is not null then
			 case when pe.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	and case when k.activityID Is not null then
			 case when ac.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	
	DROP TABLE #tbl_KPI
    
END
GO


/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByPerson]    Script Date: 06/28/2016 18:40:19 ******/
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

   CREATE TABLE #tbl_KPI
		(kpiId INT,
		 sourceObjectType VARCHAR(100))

	INSERT INTO #tbl_KPI (kpiId, sourceObjectType)
	EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUsername
	
    SELECT DISTINCT [k].[kpiID]
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
		  ,[dbo].[svf_GetKpiProgess]([k].[kpiID],'','') [progress]
		  ,[dbo].[svf_GetKpiTrend]([k].[kpiID]) [trend]
	FROM [dbo].[tbl_KPI] [k] 
	INNER JOIN #tbl_KPI [kpi] ON [k].[kpiID] = [kpi].[kpiId] 
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID]
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID]
	WHERE [k].[personID] = @intPersonId   
	AND [o].[deleted] = 0
	and case when k.projectID Is not null then
				 case when p.deleted = 0 then 1 else 0 end
				 else 1
			end = 1
	and case when k.personID Is not null then
			 case when pe.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	and case when k.activityID Is not null then
			 case when ac.deleted = 0 then 1 else 0 end
			 else 1
		end = 1
	
    DROP TABLE #tbl_KPI
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]    Script Date: 06/28/2016 18:40:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Jose Carlos Gutierrez
-- Create date: 04/05/2016
-- Description:	Gets all measurements of KPI
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementsByKpiOwner]
	@intOwnerId	INT,
	@varOwnerType VARCHAR(25),
	@varUserName	VARCHAR(50),
	@decMin	DECIMAL(21,3) OUTPUT,
	@decMax	DECIMAL(21,3) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @tbl_AuthorizedKPI AS TABLE([kpiId] INT,sourceObjectType VARCHAR(100))
 
	 INSERT INTO @tbl_AuthorizedKPI (kpiId, sourceObjectType)
		EXEC [dbo].[usp_KPI_GetKPIListForUser] @varUserName
	DECLARE @tblKpiIds AS TABLE ([kpiId] INT)
	
	IF @varOwnerType = 'KPI'
	BEGIN
		INSERT INTO @tblKpiIds ([kpiId]) VALUES (@intOwnerId)
	END
	
	IF @varOwnerType = 'ACTIVITY'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [activityID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'ORGANIZATION'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [organizationID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'AREA'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [areaID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'PROJECT'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [projectID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	IF @varOwnerType = 'PERSON'
	BEGIN
	
		INSERT INTO @tblKpiIds
		SELECT [kpiID]
		FROM [dbo].[tbl_KPI]
		WHERE [personID] = @intOwnerId
			AND [kpiID] IN (SELECT [kpiId] FROM @tbl_AuthorizedKPI)

	END
	
	SELECT @decMax = MAX([measurement]), @decMin = MIN([measurement])
	FROM [dbo].[tbl_KPIMeasurements]
	WHERE [kpiID] IN (SELECT [kpiID] FROM @tblKpiIds)

    SELECT [measurmentID]
      ,[kpiID]
      ,[date]
      ,[measurement]
	FROM [dbo].[tbl_KPIMeasurements]
	WHERE [kpiID] IN (SELECT [kpiID] FROM @tblKpiIds)
	ORDER BY [measurement] ASC


END
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetAllKPIs]    Script Date: 06/28/2016 18:45:43 ******/
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

	SELECT [k].[kpiID]
		  ,[k].[name]
		  ,[k].[organizationID]
		  ,[o].[name] organizationName
		  ,[k].[areaID]
		  ,[a].[name] areaName
		  ,[k].[projectID]
		  ,[p].[name] projectName
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
		  ,0 [progress]
		  ,0 [trend]
		  ,0 [isOwner]
	   FROM [dbo].[tbl_KPI] [k]
	   INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID]
	   LEFT JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID]
	   LEFT JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID]
				  
END
GO


--=================================================================================================

/*
 * We are done, mark the database as a 1.15.2 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,15,2)
GO

