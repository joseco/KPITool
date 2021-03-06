USE [KPIDB]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchPeople]    Script Date: 08/23/2016 18:24:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get people for autocomplete
-- =============================================
ALTER PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchPeople]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_People([personID] INT, [sourceObjectType] VARCHAR(20))
	INSERT INTO #tbl_People
		EXEC [dbo].[usp_PEOPLE_GetPersonListForUser] @varUserName
	
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
	INNER JOIN #tbl_People [d] ON [p].[personID] = [d].[personID]
	INNER JOIN [dbo].[tbl_Organization] [g] ON [p].[organizationID] = [g].[organizationID]
	LEFT JOIN [dbo].[tbl_Area] [r] ON [p].[areaID] = [r].[areaID]
	WHERE [p].[name] LIKE CASE @varFilter WHEN '' THEN [p].[name] ELSE '%' + @varFilter + '%' END 
	AND [p].[organizationID] = @intOrganizationId 
	AND ISNULL([p].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([p].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	ORDER BY [p].[name]
    
    DROP TABLE #tbl_People
    
END
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertKPI]    Script Date: 08/24/2016 11:52:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ivan Krsul
-- Create date: April 11, 2016
-- Description:	Create a new KPI
-- =============================================
ALTER PROCEDURE [dbo].[usp_KPI_InsertKPI]
	@userName varchar(50),
	@organizationID int,
	@areaID int,
	@projectID int,
	@activityID int,
	@personID int,
	@kpiName nvarchar(250),
	@unit varchar(10),
	@direction char(3),
	@strategy char(3),
	@startDate date,
	@reportingUnit char(15),
	@targetPeriod int,
	@allowsCategories bit,
	@currency char(3),
	@currencyUnit char(3),
	@kpiTypeID varchar(10),
	@kpiID int output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- ===============================================================================================
	-- ===============================================================================================
	-- This is very important! This stored procedure does not implement a transaction, even though
	-- it does multiple things.  We do this because it is assumed that the ASP.NET program that is 
	-- calling this procedure is handling the transaction, since this procedure must be called in 
	-- conjunction with others that crete the categories and targets.  
	-- Hence, YOU MUST create an ASP.NET tranaction to call this function!
	-- ===============================================================================================
	-- ===============================================================================================

	if(@kpiTypeID is null or @kpiTypeID = '')
			RAISERROR ('KPITypeID is null or empty', -- Message text.
			16, -- Severity.
			1 -- State.
			); 

	if(@kpiTypeID <> 'GENDEC' AND
	   @kpiTypeID <> 'GENINT' AND 
	   @kpiTypeID <> 'GENMON' AND 
	   @kpiTypeID <> 'GENPER' AND
	   @kpiTypeID <> 'GENTIME') 
	begin
		-- The KPI is a not generic, so we must fetch from the KPI type table
		-- the values for direction, strategy and unit
			
		select @direction = [directionID],
			@strategy = [strategyID],
			@unit = [unitID]
		from [dbo].[tbl_KPITypes]
		where [kpiTypeID] = @kpiTypeID
	end

	IF(@areaID = 0)
		SELECT @areaID = null
	IF(@projecTID = 0)
		SELECT @projectID = null
	IF(@activityID = 0)
		SELECT @activityID = null
	IF(@personID = 0)
		SELECT @personID = null

	INSERT INTO [dbo].[tbl_KPI]
		([name]
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
		,[kpiTypeID])
	VALUES
		(@kpiName
		,@organizationID
		,@areaID
		,@projectID
		,@activityID
		,@personID
		,@unit
		,@direction
		,@strategy
		,@startDate
		,@reportingUnit
		,@targetPeriod
		,@allowsCategories
		,@currency
		,@currencyUnit
		,@kpiTypeID)

	SELECT @kpiID = SCOPE_IDENTITY()

	-- Ensure that the owner can manage this object
	INSERT INTO [dbo].[tbl_SEG_ObjectPermissions]
		([objectTypeID]
		,[objectID]
		,[username]
		,[objectActionID])
	VALUES
		('KPI'
		,@kpiID
		,@userName
		,'OWN')
END
GO


--=================================================================================================

/*
 * We are done, mark the database as a 1.21.1 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,21,1)
GO

