/* 
	Updates de the KPIDB database to version 1.11.0 
*/

Use [Master]
GO 

IF  NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KPIDB')
	RAISERROR('KPIDB database Doesn´t exists. Create the database first',16,127)
GO

PRINT 'Updating KPIDB database to version 1.11.0'

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

IF NOT (@smiMajor = 1 AND @smiMinor = 10) 
BEGIN
	RAISERROR('KPIDB database is not in version 1.10 This program only applies to version 1.10',16,127)
	RETURN;
END

PRINT 'KPIDB Database version OK'
GO

--===================================================================================================

/****** Object:  Table [dbo].[tbl_PAR_Parameter]    Script Date: 06/09/2016 17:03:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tbl_PAR_Parameter]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tbl_PAR_Parameter](
	[parameterID] [int] NOT NULL,
	[description] [varchar](250) NOT NULL,
	[value] [varchar](10) NOT NULL,
 CONSTRAINT [PK_tbl_PAR_Parameter] PRIMARY KEY CLUSTERED 
(
	[parameterID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'order' AND Object_ID = Object_ID(N'[dbo].[tbl_SEG_ObjectActions]')) 
ALTER TABLE [dbo].[tbl_SEG_ObjectActions] ADD [order] INT NULL
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 06/09/2016 17:17:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiProgess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiProgess]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiTrend]    Script Date: 06/09/2016 17:17:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[svf_GetKpiTrend]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[svf_GetKpiTrend]
GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiProgess]    Script Date: 06/09/2016 17:17:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:  Jose Carlos Gutierrez
-- Create date: 2016/05/19
-- Description: Get KPI Progress
-- =============================================
CREATE FUNCTION [dbo].[svf_GetKpiProgess]
(
	@intKpiId INT
)
RETURNS DECIMAL(9,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @dcProgress DECIMAL(25,3)
	
	DECLARE @intParameterBase AS INT
	DECLARE @intParameterActual AS INT
	SELECT @intParameterBase = [value] FROM [dbo].[tbl_PAR_Parameter] WHERE [parameterID] = 1
	SELECT @intParameterActual = [value] FROM [dbo].[tbl_PAR_Parameter] WHERE [parameterID] = 2
	IF(@intParameterBase IS NULL)
		SET @intParameterBase = 0
	IF(@intParameterActual IS NULL)
		SET @intParameterActual = 0		
	
	-- verify if exists a target
	DECLARE @dcTarget AS DECIMAL(25,3)
	SELECT @dcTarget = SUM([target]) 
	FROM [dbo].[tbl_KPITarget] 
	WHERE [kpiID] = @intKpiId
	GROUP BY [kpiID]

	IF(ISNULL(@dcTarget,0) > 0)
		BEGIN
			
			DECLARE @varDirectionId AS CHAR(3)
			DECLARE @varStrategyId AS CHAR(3)
			DECLARE @dtStartDate AS DATE
			DECLARE @dcMeasurement AS DECIMAL(25,3)
			
			SELECT @varDirectionId = [directionID],
				   @varStrategyId = [strategyID],
				   @dtStartDate = [startDate]
			FROM [dbo].[tbl_KPI] 
			WHERE [kpiID] = @intKpiId
			
			IF(@varStrategyId = 'SUM')
				BEGIN
					-- SUM Measurements registered since startDate
					SELECT @dcMeasurement = SUM(CONVERT(DECIMAL(25,3),[measurement])) 
					FROM [dbo].[tbl_KPIMeasurements] 
					WHERE [kpiID] = @intKpiId 
					AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
							 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
						END = 1
					GROUP BY [kpiID]
					
					-- calculate progress
					IF(@dcMeasurement > @dcTarget)
						SET @dcProgress = 100
					ELSE
						SET @dcProgress = (CASE WHEN ISNULL(@dcMeasurement,0) = 0 THEN 0 ELSE ((CONVERT(DECIMAL(25,3),@dcMeasurement) * 100)/@dcTarget) END)
				END
				
			ELSE IF(@varStrategyId = 'AVG')
				BEGIN
					-- COUNT Measurements registered since startDate
					DECLARE @intCountMeasurement AS INT
					SELECT @intCountMeasurement = COUNT(*) 
					FROM [dbo].[tbl_KPIMeasurements] 
					WHERE [kpiID] = @intKpiId 
					AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
							 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
						END = 1
					
					IF(ISNULL(@intCountMeasurement,0) <= @intParameterActual)
						BEGIN
							-- AVG Measurements registered since startDate
							SELECT @dcMeasurement = AVG(CONVERT(DECIMAL(25,3),[measurement])) 
							FROM [dbo].[tbl_KPIMeasurements] 
							WHERE [kpiID] = @intKpiId 
							AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
									 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
								END = 1
							GROUP BY [kpiID]
						
							-- calculate progress
							IF(ISNULL(@dcMeasurement,0) = 0)
								SET @dcProgress = 0
							ELSE
								SET @dcProgress = ((CONVERT(DECIMAL(25,3),@dcMeasurement) * 100)/@dcTarget)
						END
					ELSE
						BEGIN
							IF(ISNULL(@intCountMeasurement,0) <= (@intParameterBase + @intParameterActual))
								SET @intParameterBase = ISNULL(@intCountMeasurement,0) - @intParameterActual
						
							DECLARE @dcMeasurementActual AS DECIMAL(25,3)
							DECLARE @dcMeasurementBase AS DECIMAL(25,3)
							DECLARE @tbl_MeasurementActual AS TABLE([date] DATE, [measurement] DECIMAL(21,3))
							DECLARE @tbl_MeasurementBase AS TABLE([date] DATE, [measurement] DECIMAL(21,3))
							
							-- AVG Measurements registered since startDate for Actual
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [date]
									  ,[measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
										 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
									END = 1
								ORDER BY [date] DESC
							
							-- AVG Measurements registered since startDate for base
							INSERT INTO @tbl_MeasurementBase
								SELECT TOP (@intParameterBase) [date]
									  ,[measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND CASE WHEN @dtStartDate IS NULL THEN 1 ELSE 
										 CASE WHEN [date] >= @dtStartDate THEN 1 ELSE 0 END 
									END = 1
								ORDER BY [date] ASC
							
							-- calculate progress
							SET @dcMeasurementActual = ABS((SELECT AVG(CONVERT(DECIMAL(25,3),[measurement])) FROM @tbl_MeasurementActual) - @dcTarget)
							SET @dcMeasurementBase = ABS((SELECT AVG(CONVERT(DECIMAL(25,3),[measurement])) FROM @tbl_MeasurementBase) - @dcTarget)
							SET @dcProgress = ABS(100 - ((CONVERT(DECIMAL(25,3),@dcMeasurementActual) * 100)/CONVERT(DECIMAL(25,3),@dcMeasurementBase)))
						END
				END
			ELSE
				BEGIN
					SET @dcProgress = 0
				END
		END
	ELSE 
		SET @dcProgress = 0
	
	IF(@dcProgress > 100)
		SET @dcProgress = 100
	
	-- Return the result of the function
	RETURN CONVERT(DECIMAL(9,2), @dcProgress)

END




GO

/****** Object:  UserDefinedFunction [dbo].[svf_GetKpiTrend]    Script Date: 06/09/2016 17:17:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 23/05/2016
-- Description:	Get KPI Trend
-- =============================================
CREATE FUNCTION [dbo].[svf_GetKpiTrend]
(
	@intKpiId INT
)
RETURNS DECIMAL(9,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @dcTrend DECIMAL(25,3)
	
	DECLARE @intParameterActual AS INT
	SELECT @intParameterActual = [value] FROM [dbo].[tbl_PAR_Parameter] WHERE [parameterID] = 2
	IF(@intParameterActual IS NULL)
		SET @intParameterActual = 0	

	-- verify if exists a target
	DECLARE @dcTarget AS DECIMAL(25,3)
	SELECT @dcTarget = SUM([target]) 
	FROM [dbo].[tbl_KPITarget] 
	WHERE [kpiID] = @intKpiId
	GROUP BY [kpiID]
	
	IF(ISNULL(@dcTarget,0) > 0)
		BEGIN
			DECLARE @varDirectionId AS CHAR(3)
			DECLARE @varStrategyId AS CHAR(3)
			DECLARE @varReportingUnitId AS CHAR(5)
			DECLARE @dcMeasurement AS DECIMAL(25,3)
			
			SELECT @varDirectionId = [directionID],
				   @varStrategyId = [strategyID],
				   @varReportingUnitId = [reportingUnitID]
			FROM [dbo].[tbl_KPI] 
			WHERE [kpiID] = @intKpiId
			
			DECLARE @dtToday AS DATE = GETDATE()
			DECLARE @dtYesterday AS DATE = DATEADD(DAY, -1, @dtToday)
			DECLARE @intActualData AS INT
			DECLARE @intPreviousData AS INT
			DECLARE @intActualYear AS INT = YEAR(GETDATE())
			DECLARE @intPreviousYear AS INT = @intActualYear -1
			
			DECLARE @dcMeasurementActual AS DECIMAL(25,3)
			DECLARE @dcMeasurementPrevious AS DECIMAL(25,3)
			
			IF(@varStrategyId = 'SUM')
				BEGIN
					IF(@varReportingUnitId = 'DAY')
						BEGIN
							-- calculate for today
							SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements] 
							WHERE [date] = @dtToday 
							AND [kpiID] = @intKpiId
							
							-- calculate for yesterday
							SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements] 
							WHERE [date] = @dtYesterday 
							AND [kpiID] = @intKpiId
						END
					
					IF(@varReportingUnitId = 'MONTH')
						BEGIN
							SET @intActualData = MONTH(GETDATE())
							SET @intPreviousData = MONTH(DATEADD(MONTH, -1, GETDATE()))
							SET @intPreviousYear = YEAR(DATEADD(MONTH, -1, GETDATE()))
							
							-- calculate for actual month
							SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE MONTH([date]) = @intActualData 
							AND YEAR([date]) = @intActualYear 
							AND [kpiID] = @intKpiId
							
							-- calculate for previous month
							SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE MONTH([date]) = @intPreviousData 
							AND YEAR([date]) = @intPreviousYear 
							AND [kpiID] = @intKpiId
						END
					
					IF(@varReportingUnitId = 'QUART')
						BEGIN
							SET @intActualData = DATEPART(QUARTER, GETDATE())
							SET @intPreviousData = CASE WHEN @intActualData = 4 THEN 1 ELSE @intActualData - 1 END
							SET @intPreviousYear = CASE WHEN @intActualData = 4 THEN @intActualYear - 1 ELSE @intActualYear END
							
							-- calculate for actual quart
							SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE DATEPART(QUARTER, [date]) = @intActualData 
							AND YEAR([date]) = @intActualYear 
							AND [kpiID] = @intKpiId
							
							-- calculate for previous quart
							SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE DATEPART(QUARTER, [date]) = @intPreviousData 
							AND YEAR([date]) = @intPreviousYear 
							AND [kpiID] = @intKpiId
						END
					
					IF(@varReportingUnitId = 'WEEK')
						BEGIN
							SET @intActualData = DATEPART(WEEK, GETDATE())
							SET @intPreviousData = DATEPART(WEEK,DATEADD(DAY,-7,GETDATE()))
							SET @intPreviousYear = YEAR(DATEADD(DAY,-7,GETDATE()))
							
							-- calculate for actual week
							SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE DATEPART(WEEK, [date]) = @intActualData 
							AND YEAR([date]) = @intActualYear 
							AND [kpiID] = @intKpiId
							
							-- calculate for previous week
							SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE DATEPART(WEEK, [date]) = @intPreviousData 
							AND YEAR([date]) = @intPreviousYear 
							AND [kpiID] = @intKpiId
						END
					
					IF(@varReportingUnitId = 'YEAR')
						BEGIN
							-- calculate for actual year
							SELECT @dcMeasurementActual = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE YEAR([date]) = @intActualYear 
							AND [kpiID] = @intKpiId
							
							-- calculate for previous year
							SELECT @dcMeasurementPrevious = SUM(CONVERT(DECIMAL(25,3),[measurement]))
							FROM [dbo].[tbl_KPIMeasurements]  
							WHERE YEAR([date]) = @intPreviousYear 
							AND [kpiID] = @intKpiId
						END
					
					IF(ISNULL(@dcMeasurementActual,0) > @dcTarget)
						SET @dcMeasurementActual = 100
					ELSE
						SET @dcMeasurementActual = (CASE WHEN ISNULL(@dcMeasurementActual,0) = 0 THEN 0 ELSE ((CONVERT(DECIMAL(25,3),@dcMeasurementActual) * 100)/@dcTarget) END)
					
					IF(ISNULL(@dcMeasurementPrevious,0) > @dcTarget)
						SET @dcMeasurementPrevious = 100
					ELSE
						SET @dcMeasurementPrevious = (CASE WHEN ISNULL(@dcMeasurementPrevious,0) = 0 THEN 0 ELSE ((CONVERT(DECIMAL(25,3),@dcMeasurementPrevious) * 100)/@dcTarget) END)			
					
					SET @dcTrend = ISNULL(@dcMeasurementActual,0) - ISNULL(@dcMeasurementPrevious,0)
				END
			
			ELSE IF(@varStrategyId = 'AVG')
				BEGIN
					DECLARE @tbl_MeasurementActual AS TABLE([measurement] DECIMAL(21,3)) 
					DECLARE @tbl_MeasurementPrevious AS TABLE([measurement] DECIMAL(21,3)) 
					
					IF(@varReportingUnitId = 'DAY')
						BEGIN
							SET @dtToday  = GETDATE()
							SET @dtYesterday = DATEADD(DAY, -1, @dtToday)
							
							-- calculate for today
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND [date] = @dtToday 
								ORDER BY [date] DESC
							
							-- calculate for yesterday
							INSERT INTO @tbl_MeasurementPrevious
								SELECT TOP(@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND [date] = @dtYesterday
								ORDER BY [date] DESC
						END
						
					IF(@varReportingUnitId = 'MONTH')
						BEGIN
							SET @intActualData = MONTH(GETDATE())
							SET @intPreviousData = MONTH(DATEADD(MONTH, -1, GETDATE()))
							SET @intPreviousYear = YEAR(DATEADD(MONTH, -1, GETDATE()))
							
							-- calculate for actual month
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND MONTH([date]) = @intActualData 
								AND YEAR([date]) = @intActualYear 
								ORDER BY [date] DESC
							
							-- calculate for previous month
							INSERT INTO @tbl_MeasurementPrevious
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND MONTH([date]) = @intPreviousData 
								AND YEAR([date]) = @intPreviousYear 
								ORDER BY [date] DESC
						END
					
					IF(@varReportingUnitId = 'QUART')
						BEGIN
							SET @intActualData = DATEPART(QUARTER, GETDATE())
							SET @intPreviousData = CASE WHEN @intActualData = 4 THEN 1 ELSE @intActualData - 1 END
							SET @intPreviousYear = CASE WHEN @intActualData = 4 THEN @intActualYear - 1 ELSE @intActualYear END
							
							-- calculate for actual quart
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND DATEPART(QUARTER, [date]) = @intActualData 
								AND YEAR([date]) = @intActualYear 
								ORDER BY [date] DESC
								
							-- calculate for previous quart
							INSERT INTO @tbl_MeasurementPrevious
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND DATEPART(QUARTER, [date]) = @intPreviousData 
								AND YEAR([date]) = @intPreviousYear 
								ORDER BY [date] DESC
						END
					
					IF(@varReportingUnitId = 'WEEK')
						BEGIN
							SET @intActualData = DATEPART(WEEK, GETDATE())
							SET @intPreviousData = DATEPART(WEEK,DATEADD(DAY,-7,GETDATE()))
							SET @intPreviousYear = YEAR(DATEADD(DAY,-7,GETDATE()))
							
							-- calculate for actual week
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND DATEPART(WEEK, [date]) = @intActualData 
								AND YEAR([date]) = @intActualYear 
								ORDER BY [date] DESC
							
							-- calculate for previous week
							INSERT INTO @tbl_MeasurementPrevious
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND DATEPART(WEEK, [date]) = @intPreviousData 
								AND YEAR([date]) = @intPreviousYear 
								ORDER BY [date] DESC
						END
					
					IF(@varReportingUnitId = 'YEAR')
						BEGIN
							SET @intActualYear = YEAR(GETDATE())
							SET @intPreviousYear = @intActualYear -1
							
							-- calculate for actual year
							INSERT INTO @tbl_MeasurementActual
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND YEAR([date]) = @intActualYear 
								ORDER BY [date] DESC
							
							-- calculate for previous year
							INSERT INTO @tbl_MeasurementPrevious
								SELECT TOP (@intParameterActual) [measurement]
								FROM [dbo].[tbl_KPIMeasurements] 
								WHERE [kpiID] = @intKpiId 
								AND YEAR([date]) = @intPreviousYear 
								ORDER BY [date] DESC
						END
					
					-- calculate for actual data
					SELECT @dcMeasurementActual = AVG(CONVERT(DECIMAL(25,3),[measurement]))
					FROM @tbl_MeasurementActual
					
					-- calculate for previous data
					SELECT @dcMeasurementPrevious = AVG(CONVERT(DECIMAL(25,3),[measurement]))
					FROM @tbl_MeasurementPrevious
					
					IF(ISNULL(@dcMeasurementActual,0) > @dcTarget)
						SET @dcMeasurementActual = 100
					ELSE
						SET @dcMeasurementActual = (CASE WHEN ISNULL(@dcMeasurementActual,0) = 0 THEN 0 ELSE ((CONVERT(DECIMAL(25,3),@dcMeasurementActual) * 100)/@dcTarget) END)
					
					IF(ISNULL(@dcMeasurementPrevious,0) > @dcTarget)
						SET @dcMeasurementPrevious = 100
					ELSE
						SET @dcMeasurementPrevious = (CASE WHEN ISNULL(@dcMeasurementPrevious,0) = 0 THEN 0 ELSE ((CONVERT(DECIMAL(25,3),@dcMeasurementPrevious) * 100)/@dcTarget) END)			
					
					SET @dcTrend = ISNULL(@dcMeasurementActual,0) - ISNULL(@dcMeasurementPrevious,0)
				END
			
			ELSE
				SET @dcTrend = 0
		END
	ELSE
		SET @dcTrend = 0

	-- Return the result of the function
	RETURN CONVERT(DECIMAL(9,2), @dcTrend)

END

GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivitiesByProject]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ACT_GetActivitiesByProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ACT_GetActivitiesByProject]
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByOrganization]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ACT_GetActivityByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ACT_GetActivityByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchActivitiess]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchAreas]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchAreas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchAreas]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchOrganizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchPeople]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchPeople]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchPeople]
GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchProjects]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_AUTOCOMPLETE_SearchProjects]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchProjects]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategory]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_DeleteCategory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_DeleteCategory]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategoryItem]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_DeleteCategoryItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_DeleteCategoryItem]
GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoriesByKpiId]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CATEGORY_GetCategoriesByKpiId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CATEGORY_GetCategoriesByKpiId]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteKpiMeasurement]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_DeleteKpiMeasurement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_DeleteKpiMeasurement]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteKpiMeasurementByListIds]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_DeleteKpiMeasurementByListIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_DeleteKpiMeasurementByListIds]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetCategoryItemsCombinatedByKpiId]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetCategoryItemsCombinatedByKpiId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetCategoryItemsCombinatedByKpiId]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIDataTimeFromValue]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIDataTimeFromValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIDataTimeFromValue]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByActivity]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByActivity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByActivity]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByPerson]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByPerson]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByProject]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_GetKPIsByProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_GetKPIsByProject]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertKpiMeasurement]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_InsertKpiMeasurement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_InsertKpiMeasurement]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertKpiMeasurementCategories]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_InsertKpiMeasurementCategories]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_InsertKpiMeasurementCategories]
GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_VerifyKpiMeasurements]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_KPI_VerifyKpiMeasurements]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_KPI_VerifyKpiMeasurements]
GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAreasByOrganization]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ORG_GetAreasByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ORG_GetAreasByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonByOrganization]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PEOPLE_GetPersonByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PEOPLE_GetPersonByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsByOrganization]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PROJ_GetProjectsByOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PROJ_GetProjectsByOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForActivity]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_GetObjectActionsForActivity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_GetObjectActionsForActivity]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForKPI]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_GetObjectActionsForKPI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_GetObjectActionsForKPI]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForOrganization]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_GetObjectActionsForOrganization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_GetObjectActionsForOrganization]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForPeople]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_GetObjectActionsForPeople]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_GetObjectActionsForPeople]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForProject]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_GetObjectActionsForProject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_GetObjectActionsForProject]
GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectPermissionsByObject]    Script Date: 06/09/2016 17:17:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SEG_GetObjectPermissionsByObject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SEG_GetObjectPermissionsByObject]
GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivitiesByProject]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	List all activities by project
-- =============================================
CREATE PROCEDURE [dbo].[usp_ACT_GetActivitiesByProject]
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
    
	DROP TABLE #tbl_Activity
	DROP TABLE #tbl_KPI
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_ACT_GetActivityByOrganization]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Marcela Martinez
-- Create date: 02/05/2016
-- Description:	List all activities by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ACT_GetActivityByOrganization]
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
    
    DROP TABLE #tbl_Activity
    DROP TABLE #tbl_KPI
    
END




GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get activities for autocomplete
-- =============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchActivitiess]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@intProjectId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_Activity([activityID] INT)
	INSERT INTO #tbl_Activity
		EXEC [dbo].[usp_ACT_GetActivityListForUser] @varUserName
	
    SELECT [a].[activityID]
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

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchAreas]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 25/04/2016
-- Description:	Get areas for autocomplete
-- ===============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchAreas]
	@intOrganizationId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@varFilter IS NULL)
		SELECT @varFilter = ''
	
	SELECT [areaID]
		  ,[organizationID]
		  ,[name]
	FROM [dbo].[tbl_Area] 
	WHERE [name] LIKE CASE @varFilter WHEN '' THEN [name] ELSE '%' + @varFilter + '%' END 
	AND [organizationID] = @intOrganizationId 
	ORDER BY [name]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ===============================================
-- Author:		Marcela Martinez
-- Create date: 25/04/2016
-- Description:	Get organizations for autocomplete
-- ===============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchOrganizations]
	@varUserName AS VARCHAR(50),
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@varFilter IS NULL)
		SELECT @varFilter = ''
		
	CREATE TABLE #tbl_Organization([organizationID] INT)
	INSERT INTO #tbl_Organization
		EXEC [dbo].[usp_ORG_GetOrganizationListForUser] @varUserName
	
	SELECT [o].[organizationID]
		  ,[o].[name]
	FROM [dbo].[tbl_Organization] [o] 
	INNER JOIN #tbl_Organization [d] ON [o].[organizationID] = [d].[organizationId]
	WHERE [o].[name] LIKE CASE @varFilter WHEN '' THEN [o].[name] ELSE '%' + @varFilter + '%' END 
	ORDER BY [o].[name]
	
	DROP TABLE #tbl_Organization
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchPeople]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Get people for autocomplete
-- =============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchPeople]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	CREATE TABLE #tbl_People([personID] INT)
	INSERT INTO #tbl_People
		EXEC [dbo].[usp_PEOPLE_GetPersonListForUser] @varUserName
	
    SELECT [p].[personID]
		  ,[p].[id]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
	FROM [dbo].[tbl_People] [p] 
	INNER JOIN #tbl_People [d] ON [p].[personID] = [d].[personID]
	WHERE [p].[name] LIKE CASE @varFilter WHEN '' THEN [p].[name] ELSE '%' + @varFilter + '%' END 
	AND [p].[organizationID] = @intOrganizationId 
	AND ISNULL([p].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([p].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	ORDER BY [p].[name]
    
    DROP TABLE #tbl_People
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_AUTOCOMPLETE_SearchProjects]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 29/04/2016
-- Description:	Get projects for autocomplete
-- =============================================
CREATE PROCEDURE [dbo].[usp_AUTOCOMPLETE_SearchProjects]
	@varUserName AS VARCHAR(50),
	@intOrganizationId AS INT,
	@intAreaId AS INT,
	@varFilter AS VARCHAR(250)
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@varFilter IS NULL)
		SELECT @varFilter = ''
	
	CREATE TABLE #tbl_Project([projectID] INT)
	INSERT INTO #tbl_Project
		EXEC [dbo].[usp_PROJ_GetProjectListForUser] @varUserName
	
	SELECT [p].[projectID]
		  ,[p].[name]
		  ,[p].[organizationID]
		  ,[p].[areaID]
	FROM [dbo].[tbl_Project] [p] 
	INNER JOIN #tbl_Project [d] ON [p].[projectID] = [d].[projectID]
	WHERE [p].[name] LIKE CASE @varFilter WHEN '' THEN [p].[name] ELSE '%' + @varFilter + '%' END 
	AND [p].[organizationID] = @intOrganizationId 
	AND ISNULL([p].[areaID],0) = CASE WHEN ISNULL(@intAreaId,0) = 0 THEN ISNULL([p].[areaID],0) ELSE ISNULL(@intAreaId,0) END 
	ORDER BY [p].[name]
    
    DROP TABLE #tbl_Project
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategory]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Delete category
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_DeleteCategory]
	@varCategoryId varchar(20)
AS
BEGIN
	
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
		SAVE TRANSACTION DeleteCategoryPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		--DELETE FROM [dbo].[tbl_KPITargetCategories] 
		--WHERE [categoryID] = @varCategoryId 
		
		--DELETE FROM [dbo].[tbl_KPIMeasurementCategories] 
		--WHERE [categoryID] = @varCategoryId
		
		--DELETE FROM [dbo].[tbl_KPICategories] 
		--WHERE [categoryID] = @varCategoryId
		
		DELETE FROM [dbo].[tbl_CategoryItem] 
		WHERE [categoryID] = @varCategoryId
		
		DELETE FROM [dbo].[tbl_Category] 
		WHERE [categoryID] = @varCategoryId 
	    
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
				ROLLBACK TRANSACTION DeleteCategoryPS;

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

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_DeleteCategoryItem]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 30/04/2016
-- Description:	Delete category item
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_DeleteCategoryItem]
	@varCategoryItemId VARCHAR(20),
	@varCategoryId AS VARCHAR(20)
AS
BEGIN
	
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
		SAVE TRANSACTION DeleteCategoryItemPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		--DELETE FROM [dbo].[tbl_KPITargetCategories] 
		--WHERE [categoryItemID] = @varCategoryItemId 
		
		--DELETE FROM [dbo].[tbl_KPIMeasurementCategories] 
		--WHERE [categoryItemID] = @varCategoryItemId
		
		DELETE FROM [dbo].[tbl_CategoryItem] 
		WHERE [categoryItemID] = @varCategoryItemId 
		AND [categoryID] = @varCategoryId
	    
	    
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
				ROLLBACK TRANSACTION DeleteCategoryItemPS;

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

/****** Object:  StoredProcedure [dbo].[usp_CATEGORY_GetCategoriesByKpiId]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 26/05/2016
-- Description:	Get Categories by kpiID
-- =============================================
CREATE PROCEDURE [dbo].[usp_CATEGORY_GetCategoriesByKpiId] 
	@intKpiId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [c].[categoryID]
		  ,[c].[name]
		  ,(SELECT ';' + [ci].[categoryItemID]
            FROM [dbo].[tbl_CategoryItem] [ci] 
            WHERE [ci].[categoryID] = [c].[categoryID]
            FOR XML PATH('')) [items]
	FROM [dbo].[tbl_Category] [c] 
	INNER JOIN [dbo].[tbl_KPICategories] [kc] ON [c].[categoryID] = [kc].[categoryID] 
	AND [kc].[kpiID] = @intKpiId 
	ORDER BY [c].[categoryID]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteKpiMeasurement]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =======================================================
-- Author:		Marcela Martinez
-- Create date: 01/06/2016
-- Description:	Delete a measurement and related categories 
-- ========================================================
CREATE PROCEDURE [dbo].[usp_KPI_DeleteKpiMeasurement] 
	@intMeasurementId INT
AS
BEGIN
	
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
		SAVE TRANSACTION DeleteKPIMeasurementPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories] 
		WHERE [measurementID] = @intMeasurementId
		
		DELETE FROM [dbo].[tbl_KPIMeasurements] 
		WHERE [measurmentID] = @intMeasurementId
		
		
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
				ROLLBACK TRANSACTION DeleteKPIMeasurementPS;

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

/****** Object:  StoredProcedure [dbo].[usp_KPI_DeleteKpiMeasurementByListIds]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =======================================================================================
-- Author:		Marcela Martinez
-- Create date: 07/06/2016
-- Description:	Delete a list of measurement separated by semi colon and related categories 
-- =======================================================================================
CREATE PROCEDURE [dbo].[usp_KPI_DeleteKpiMeasurementByListIds] 
	@varMeasurementIds VARCHAR(MAX)
AS
BEGIN
	
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
		SAVE TRANSACTION DeleteKPIMeasurementByListIDsPS;     
	ELSE
		-- This SP starts its own transaction and there was no previous transaction
		BEGIN TRANSACTION;

	BEGIN TRY
		
		DELETE FROM [dbo].[tbl_KPIMeasurementCategories] 
		WHERE [measurementID] IN (SELECT [m].[measurmentID] FROM [dbo].[tbl_KPIMeasurements] [m] 
								  INNER JOIN [dbo].[tvf_SplitStringInTable] (@varMeasurementIds,';') [d] 
								  ON [m].[measurmentID] = [d].[splitvalue])
		
		DELETE FROM [dbo].[tbl_KPIMeasurements] 
		WHERE [measurmentID] IN (SELECT [m].[measurmentID] FROM [dbo].[tbl_KPIMeasurements] [m] 
								 INNER JOIN [dbo].[tvf_SplitStringInTable] (@varMeasurementIds,';') [d] 
								 ON [m].[measurmentID] = [d].[splitvalue])
		
		
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
				ROLLBACK TRANSACTION DeleteKPIMeasurementByListIDsPS;

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

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetCategoryItemsCombinatedByKpiId]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ================================================================
-- Author:		Marcela Martinez
-- Create date: 03/06/2016
-- Description:	Get the combinations of category items by kpiID
-- ================================================================
CREATE PROCEDURE [dbo].[usp_KPI_GetCategoryItemsCombinatedByKpiId] 
	@intKpiID INT
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_CategoriesCombination([productoId] VARCHAR(MAX), [categoriesId] VARCHAR(MAX))
	
	CREATE TABLE #tbl_KPICategories([categoryID] VARCHAR(20))
		INSERT INTO #tbl_KPICategories
			SELECT [categoryID] 
			FROM [dbo].[tbl_KPICategories] 
			WHERE [kpiID] = @intKpiID 
			ORDER BY [categoryID]
	
	IF EXISTS(SELECT 1 FROM #tbl_KPICategories)
		BEGIN
			DECLARE @varCategoryId AS VARCHAR(20)
			DECLARE @intIndex AS INT = 1
			DECLARE @varItems AS VARCHAR(MAX) = ''
			DECLARE @varItemsDetalle AS VARCHAR(MAX) = ''
			DECLARE @varCategories AS VARCHAR(MAX) = ''
			
			DECLARE CURSORCATEGORY CURSOR FOR
				SELECT [categoryID] 
				FROM #tbl_KPICategories
				
			OPEN CURSORCATEGORY 

			FETCH NEXT FROM CURSORCATEGORY INTO @varCategoryId
			
			WHILE @@fetch_status = 0
				BEGIN
					
					SET @varItems = @varItems + CASE WHEN @varItems = '' 
													THEN ('[' + CONVERT(VARCHAR(10),@intIndex) + '].[categoryItemID]') 
													ELSE (' + '', '' + [' + CONVERT(VARCHAR(10),@intIndex) + '].[categoryItemID]') END
					
					SET @varItemsDetalle = @varItemsDetalle + CASE WHEN @varItemsDetalle = '' 
														THEN '(SELECT [ci].[categoryItemID]
															   FROM #tbl_KPICategories [c] 
															   INNER JOIN [dbo].[tbl_CategoryItem] [ci] ON [c].[categoryID] = [ci].[categoryID] 
															   AND [c].[categoryID] = ''' + @varCategoryId + ''') [' + CONVERT(VARCHAR(10),@intIndex) + ']' 
														ELSE ',(SELECT [ci].[categoryItemID]
															   FROM #tbl_KPICategories [c] 
															   INNER JOIN [dbo].[tbl_CategoryItem] [ci] ON [c].[categoryID] = [ci].[categoryID] 
															   AND [c].[categoryID] = ''' + @varCategoryId + ''') [' + CONVERT(VARCHAR(10),@intIndex) + ']' END
					
					SET @varCategories = @varCategories + CASE WHEN @varCategories = '' THEN @varCategoryId ELSE ', ' + @varCategoryId END
					SET @intIndex = @intIndex + 1
					
					FETCH NEXT FROM CURSORCATEGORY INTO @varCategoryId
					
				END
			
			CLOSE CURSORCATEGORY
			DEALLOCATE CURSORCATEGORY 
			
			INSERT INTO #tbl_CategoriesCombination([productoId])
				EXEC('SELECT ' + @varItems + ' 
					  FROM ' + @varItemsDetalle)
					  
			UPDATE #tbl_CategoriesCombination 
			SET [categoriesId] = @varCategories
		END
	
	SELECT [cc].[productoId]
		  ,[cc].[categoriesId] 
	FROM #tbl_CategoriesCombination [cc] 
	ORDER BY [cc].[productoId]
	
	DROP TABLE #tbl_KPICategories
	DROP TABLE #tbl_CategoriesCombination
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIDataTimeFromValue]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================
-- Author:		Marcela Martinez
-- Create date: 01/06/2016
-- Description:	Get KPI Data Time (year, month, day, hour, minute) from decimal value
-- ==================================================================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIDataTimeFromValue]
	@dcValue AS DECIMAL(21,3)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @intYear AS INT
	DECLARE @intMonth AS INT
	DECLARE @intDay AS INT
	DECLARE @intHour AS INT
	DECLARE @intMinute AS INT
    DECLARE @dtBaseDate AS DATETIME
	DECLARE @dtCalculatedDate DATETIME
	
	SET @dtBaseDate = '1900-01-01'	
	SET @dtCalculatedDate = CAST(@dcValue AS DATETIME)
	
	--REDONDEO AL SEGUNDO
	SET @dtCalculatedDate = DATEADD(SECOND, ROUND(DATEPART(SECOND,@dtCalculatedDate)*2,-1) / 2-DATEPART(SECOND,@dtCalculatedDate), @dtCalculatedDate)

	SET @intYear = DATEDIFF(YY,@dtBaseDate,@dtCalculatedDate)
	SET @dtCalculatedDate = DATEADD(YY,-@intYear,@dtCalculatedDate)

	SET @intMonth = DATEDIFF(MM,@dtBaseDate,@dtCalculatedDate) 
	SET @dtCalculatedDate = DATEADD(MM,-@intMonth,@dtCalculatedDate)

	SET @intDay = DATEDIFF(DD,@dtBaseDate,@dtCalculatedDate) 
	SET @dtCalculatedDate = DATEADD(DD,-@intDay,@dtCalculatedDate)

	SET @intHour = DATEDIFF(HH,@dtBaseDate,@dtCalculatedDate) 
	SET @dtCalculatedDate = DATEADD(HH,-@intHour,@dtCalculatedDate)

	SET @intMinute = DATEDIFF(MINUTE,@dtBaseDate,@dtCalculatedDate)
	
	SELECT @intYear as [year],
	       @intMonth as [month],
	       @intDay as [day],
	       @intHour as [hour],
	       @intMinute as [minute]
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =================================================
-- Author:		Marcela Martinez
-- Create date: 30/05/2016
-- Description:	Get MeasurementCategories by kpiId
-- =================================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKpiMeasurementCategoriesByKpiId]
	@intKpiId INT
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_Measurement([measurmentID] INT, [date] DATE, [measurement] DECIMAL(21,3), [detalle] VARCHAR(MAX), [categories] VARCHAR(MAX))
    
    DECLARE @intMeasurementId AS INT
    DECLARE @dtDate AS DATE
	DECLARE @dcMeasurement AS DECIMAL(21,3)
    DECLARE @varDetalle AS VARCHAR(MAX)
    DECLARE @varCategories AS VARCHAR(MAX)
    
    DECLARE MEASUREMENT_CURSOR CURSOR FOR
		SELECT [measurmentID]
		FROM [dbo].[tbl_KPIMeasurements] 
		WHERE [kpiID] = @intKpiID
		ORDER BY [date] DESC
	
	OPEN MEASUREMENT_CURSOR
	
	FETCH NEXT FROM MEASUREMENT_CURSOR INTO @intMeasurementId
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @varDetalle = COALESCE(COALESCE(CASE WHEN @varDetalle = '' THEN '' ELSE @varDetalle + ', ' END, '') + [i].[categoryItemID], @varDetalle),
				   @varCategories = COALESCE(COALESCE(CASE WHEN @varCategories = '' THEN '' ELSE @varCategories + ', ' END, '') + [i].[categoryID], @varCategories),
				   @dtDate = [m].[date],
				   @dcMeasurement = [m].[measurement]
			FROM [dbo].[tbl_KPIMeasurements] [m]  
			LEFT OUTER JOIN [dbo].[tbl_KPIMeasurementCategories] [c] ON [m].[measurmentID] = [c].[measurementID] 
			LEFT OUTER JOIN [dbo].[tbl_CategoryItem] [i] ON [c].[categoryItemID] = [i].[categoryItemID] 
				AND [c].[categoryID] = [i].[categoryID]
			WHERE [m].[measurmentID] = @intMeasurementId 
			ORDER BY [i].[categoryID]
			
			INSERT INTO #tbl_Measurement VALUES(@intMeasurementId, @dtDate, @dcMeasurement, @varDetalle, @varCategories)
			
			SET @varDetalle = ''
			SET @varCategories = ''
			SET @dtDate = NULL
			SET @dcMeasurement = NULL
			
			FETCH NEXT FROM MEASUREMENT_CURSOR INTO @intMeasurementId
		END
	
	CLOSE MEASUREMENT_CURSOR;
	DEALLOCATE MEASUREMENT_CURSOR;
    
    SELECT [measurmentID]
		  ,@intKpiID [kpiID]
		  ,[date]
		  ,[measurement]
		  ,[detalle]
		  ,[categories]
	FROM #tbl_Measurement
	
	DROP TABLE #tbl_Measurement
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByActivity]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by activity
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByActivity]
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
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[activityID] = @intActivityId
	
	DROP TABLE #tbl_KPI
    
END



GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByOrganization]    Script Date: 06/09/2016 17:17:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Marcela Martinez
-- Create date: 02/04/2016
-- Description:	Get KPIs by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByOrganization]
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
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[organizationID] = @intOrganizationId
    
    DROP TABLE #tbl_KPI
    
END




GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByPerson]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by person
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByPerson]
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
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[personID] = @intPersonId
    
    DROP TABLE #tbl_KPI
    
END



GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_GetKPIsByProject]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Marcela Martinez
-- Create date: 19/05/2016
-- Description:	Get KPIs by project
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_GetKPIsByProject]
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
	INNER JOIN [dbo].[tbl_Organization] [o] ON [k].[organizationID] = [o].[organizationID] 
	LEFT OUTER JOIN [dbo].[tbl_Area] [a] ON [k].[areaID] = [a].[areaID] 
	LEFT OUTER JOIN [dbo].[tbl_Project] [p] ON [k].[projectID] = [p].[projectID] 
	LEFT OUTER JOIN [dbo].[tbl_Activity] [ac] ON [k].[activityID] = [ac].[activityID] 
	LEFT OUTER JOIN [dbo].[tbl_People] [pe] ON [k].[personID] = [pe].[personID] 
	WHERE [k].[projectID] = @intProjectId
    
    DROP TABLE #tbl_KPI
    
END



GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertKpiMeasurement]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 31/05/2016
-- Description:	Insert Measurement for a KPI
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_InsertKpiMeasurement] 
	@intMeasurementId INT OUTPUT,
	@intKpiId INT,
	@dtDate DATE,
	@dcMeasurement DECIMAL(21,3)
AS
BEGIN
	
	SET NOCOUNT ON;

    INSERT INTO [dbo].[tbl_KPIMeasurements]
           ([kpiID]
           ,[date]
           ,[measurement])
     VALUES
           (@intKpiId
           ,@dtDate
           ,@dcMeasurement)
    
    SELECT @intMeasurementId = SCOPE_IDENTITY()
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_InsertKpiMeasurementCategories]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ================================================
-- Author:		Marcela Martinez
-- Create date: 31/05/2016
-- Description:	Insert Categories for a Measurement
-- ================================================
CREATE PROCEDURE [dbo].[usp_KPI_InsertKpiMeasurementCategories]  
	@intMeasurementId INT,
	@varCategoryItemId VARCHAR(20),
	@varCategoryId VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

    INSERT INTO [dbo].[tbl_KPIMeasurementCategories]
           ([measurementID]
           ,[categoryItemID]
           ,[categoryID])
	VALUES
           (@intMeasurementId
           ,@varCategoryItemId
           ,@varCategoryId)
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_KPI_VerifyKpiMeasurements]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 07/06/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_KPI_VerifyKpiMeasurements] 
	@intKpiId AS INT,
	@dtDate AS DATE,
	@varDetalle AS VARCHAR(MAX),
	@varCategory AS VARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;

    CREATE TABLE #tbl_Measurement([measurmentID] INT, [date] DATE, [measurement] DECIMAL(21,3), [detalle] VARCHAR(MAX), [categories] VARCHAR(MAX))
	
	DECLARE @intMeasurementId AS INT
	DECLARE @dcMeasurement AS DECIMAL(21,3)
    DECLARE @varItemsDetalle AS VARCHAR(MAX)
    DECLARE @varCategoriesDetalle AS VARCHAR(MAX)
	
	DECLARE MEASUREMENT_CURSOR CURSOR FOR
		SELECT [measurmentID]
		FROM [dbo].[tbl_KPIMeasurements] 
		WHERE [kpiID] = @intKpiId 
		AND [date] = @dtDate 
	
	OPEN MEASUREMENT_CURSOR
	
	FETCH NEXT FROM MEASUREMENT_CURSOR INTO @intMeasurementId
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			SELECT @varItemsDetalle = COALESCE(COALESCE(CASE WHEN @varItemsDetalle = '' THEN '' ELSE @varItemsDetalle + ', ' END, '') + [i].[categoryItemID], @varItemsDetalle),
				   @varCategoriesDetalle = COALESCE(COALESCE(CASE WHEN @varCategoriesDetalle = '' THEN '' ELSE @varCategoriesDetalle + ', ' END, '') + [i].[categoryID], @varCategoriesDetalle),
				   @dcMeasurement = [m].[measurement]
			FROM [dbo].[tbl_KPIMeasurements] [m]  
			LEFT OUTER JOIN [dbo].[tbl_KPIMeasurementCategories] [c] ON [m].[measurmentID] = [c].[measurementID] 
			LEFT OUTER JOIN [dbo].[tbl_CategoryItem] [i] ON [c].[categoryItemID] = [i].[categoryItemID] 
				AND [c].[categoryID] = [i].[categoryID]
			WHERE [m].[measurmentID] = @intMeasurementId 
			ORDER BY [i].[categoryID]
			
			INSERT INTO #tbl_Measurement VALUES(@intMeasurementId, @dtDate, @dcMeasurement, @varItemsDetalle, @varCategoriesDetalle)
			
			SET @varItemsDetalle = ''
			SET @varCategoriesDetalle = ''
			SET @dcMeasurement = NULL
			
			FETCH NEXT FROM MEASUREMENT_CURSOR INTO @intMeasurementId
		END
	
	CLOSE MEASUREMENT_CURSOR;
	DEALLOCATE MEASUREMENT_CURSOR;
	
	SELECT [measurmentID]
		  ,@intKpiID [kpiID]
		  ,[date]
		  ,[measurement]
		  ,[detalle]
	FROM #tbl_Measurement 
	WHERE ISNULL([detalle],'') = @varDetalle 
	AND ISNULL([categories],'') = @varCategory
	
	DROP TABLE #tbl_Measurement
    
END

GO

/****** Object:  StoredProcedure [dbo].[usp_ORG_GetAreasByOrganization]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Gabriela Sanchez
-- Create date: April 29 2016
-- Description:	Get areas by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_ORG_GetAreasByOrganization]
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
	INNER JOIN [dbo].[tbl_Organization] [o] ON [a].[organizationID] = [o].[organizationID]
	LEFT OUTER JOIN (SELECT COUNT([k].[kpiID]) [numberKPIs]
					       ,[k].[areaID]
					 FROM [dbo].[tbl_KPI] [k] 
					 INNER JOIN #tbl_KPI [d] ON [k].[kpiID] = [d].[kpiId] 
					 GROUP BY [k].[areaID]) [kpi] ON [a].[areaID] = [kpi].[areaID] 
	WHERE [a].[organizationID] = @intOrganizationId
	
    DROP TABLE #tbl_KPI
	
END




GO

/****** Object:  StoredProcedure [dbo].[usp_PEOPLE_GetPersonByOrganization]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Marcela Martinez
-- Create date: 18/05/2016
-- Description:	Get people by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_PEOPLE_GetPersonByOrganization]
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
    
    DROP TABLE #tbl_People
    DROP TABLE #tbl_KPI
    
END



GO

/****** Object:  StoredProcedure [dbo].[usp_PROJ_GetProjectsByOrganization]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Gabriela Sanchez V.
-- Create date: April 29 2016
-- Description:	List all projects by organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_PROJ_GetProjectsByOrganization]
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
	
	DROP TABLE #tbl_Project
    DROP TABLE #tbl_KPI
	
END




GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForActivity]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 06/05/2016
-- Description:	Get objectActions by activityId
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEG_GetObjectActionsForActivity]
	@intActivityId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [objectActionID]
	FROM [dbo].[tbl_SEG_ObjectActions] 
	WHERE [objectActionID] IN ('OWN', 'MAN_KPI') 
	AND [objectActionID] NOT IN (SELECT [objectActionID] 
								 FROM [dbo].[tbl_SEG_ObjectPublic] 
								 WHERE [objectID] = @intActivityId 
								 AND [objectTypeID] = 'ACTIVITY') 
	ORDER BY [order]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForKPI]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 06/05/2016
-- Description:	Get objectActions by KPIId
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEG_GetObjectActionsForKPI]
	@intKPIId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [objectActionID]
	FROM [dbo].[tbl_SEG_ObjectActions] 
	WHERE [objectActionID] IN ('OWN', 'VIEW_KPI', 'ENTER_DATA') 
	AND [objectActionID] NOT IN (SELECT [objectActionID] 
								 FROM [dbo].[tbl_SEG_ObjectPublic] 
								 WHERE [objectID] = @intKPIId 
								 AND [objectTypeID] = 'KPI') 
	ORDER BY [order]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForOrganization]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ================================================
-- Author:		Marcela Martinez
-- Create date: 06/05/2016
-- Description:	Get objectActions by organizationId
-- ================================================
CREATE PROCEDURE [dbo].[usp_SEG_GetObjectActionsForOrganization]
	@intOrganizationId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [objectActionID]
	FROM [dbo].[tbl_SEG_ObjectActions] 
	WHERE [objectActionID] IN ('OWN', 'MAN_PROJECT', 'MAN_ACTIVITY', 'MAN_PEOPLE', 'MAN_KPI') 
	AND [objectActionID] NOT IN (SELECT [objectActionID] 
								 FROM [dbo].[tbl_SEG_ObjectPublic] 
								 WHERE [objectID] = @intOrganizationId 
								 AND [objectTypeID] = 'ORGANIZATION')
	ORDER BY [order]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForPeople]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 06/05/2016
-- Description:	Get objectActions by personId
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEG_GetObjectActionsForPeople]
	@intPersonId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [objectActionID]
	FROM [dbo].[tbl_SEG_ObjectActions] 
	WHERE [objectActionID] IN ('OWN', 'MAN_KPI') 
	AND [objectActionID] NOT IN (SELECT [objectActionID] 
								 FROM [dbo].[tbl_SEG_ObjectPublic] 
								 WHERE [objectID] = @intPersonId 
								 AND [objectTypeID] = 'PERSON') 
	ORDER BY [order]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectActionsForProject]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Marcela Martinez
-- Create date: 06/05/2016
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEG_GetObjectActionsForProject]
	@intProjectId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;

    SELECT [objectActionID]
	FROM [dbo].[tbl_SEG_ObjectActions] 
	WHERE [objectActionID] IN ('OWN', 'MAN_ACTIVITY', 'MAN_KPI') 
	AND [objectActionID] NOT IN (SELECT [objectActionID] 
								 FROM [dbo].[tbl_SEG_ObjectPublic] 
								 WHERE [objectID] = @intProjectId 
								 AND [objectTypeID] = 'PROJECT') 
    ORDER BY [order]
    
END


GO

/****** Object:  StoredProcedure [dbo].[usp_SEG_GetObjectPermissionsByObject]    Script Date: 06/09/2016 17:17:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Marcela Martinez
-- Create date: 06/05/2015
-- Description:	Get actions for the organization
-- =============================================
CREATE PROCEDURE [dbo].[usp_SEG_GetObjectPermissionsByObject]
	@varObjectTypeId AS VARCHAR(20),
	@intObjectId AS INT
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT [objectID]
		  ,[objectTypeID]
		  ,[objectActionID]
		  ,[username]
		  ,[fullname]
		  ,[email] 
	FROM 
	(
		SELECT [op].[objectID]
			  ,[op].[objectTypeID]
			  ,[op].[objectActionID]
			  ,'' [username]
			  ,'' [fullname]
			  ,'' [email]
		FROM [dbo].[tbl_SEG_ObjectPublic] [op] 
		WHERE [op].[objectTypeID] = @varObjectTypeId 
		AND [op].[objectID] = @intObjectId
		
		UNION
		
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
	) [op] 
	ORDER BY [username]
    
END

GO

--=================================================================================================

/*
 * We are done, mark the database as a 1.11.0 database.
 */
DELETE FROM [dbo].[tbl_DatabaseInfo] 
INSERT INTO [dbo].[tbl_DatabaseInfo] 
	([majorversion], [minorversion], [releaseversion])
	VALUES (1,11,0)
GO



