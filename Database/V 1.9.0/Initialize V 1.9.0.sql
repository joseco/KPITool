USE [KPIDB]
GO

UPDATE [dbo].[tbl_KPITypes] SET unitID = 'DECIMAL' WHERE kpiTypeID = 'GENDEC'
UPDATE [dbo].[tbl_KPITypes] SET unitID = 'INT' WHERE kpiTypeID = 'GENINT'
UPDATE [dbo].[tbl_KPITypes] SET unitID = 'MONEY' WHERE kpiTypeID = 'GENMON'
UPDATE [dbo].[tbl_KPITypes] SET unitID = 'PERCENT' WHERE kpiTypeID = 'GENPER'
UPDATE [dbo].[tbl_KPITypes] SET unitID = 'TIME' WHERE kpiTypeID = 'GENTIME'
GO

DELETE FROM tbl_KPITargetCategories WHERE targetID IN (SELECT targetID FROM tbl_KPITarget WHERE kpiID IN (SELECT kpiID FROM tbl_KPI WHERE unitID = 'NA'))
DELETE FROM tbl_KPITarget WHERE kpiID IN (SELECT kpiID FROM tbl_KPI WHERE unitID = 'NA')
DELETE FROM tbl_KPIMeasurementCategories WHERE measurementID IN (SELECT measurementID FROM tbl_KPIMeasurements WHERE kpiID IN (SELECT kpiID FROM tbl_KPI WHERE unitID = 'NA'))
DELETE FROM tbl_KPIMeasurements WHERE kpiID IN (SELECT kpiID FROM tbl_KPI WHERE unitID = 'NA')
DELETE FROM tbl_KPI WHERE unitID = 'NA'
GO

DELETE FROM dbo.tbl_UnitLabels WHERE unitID = 'NA'
DELETE FROM dbo.tbl_Unit WHERE unitID = 'NA'
GO
