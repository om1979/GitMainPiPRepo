

USE mxFixincome
GO


-- Obtenemos el archivo desde el fullbackup

-- Creamos estructuras

SELECT TOP 0  
	*
INTO dbo.bkp_tmp_tblBondsCupcalendar_20130408
FROM tblBondsCupcalendar

SELECT TOP 0  
	*
INTO dbo.bkp_tmp_tblBondsRateCalendar_20130408
FROM tblBondsRateCalendar


CREATE TABLE dbo.bkp_tmp_tblBondsAdd_20130408  (
	txtId1 VARCHAR(50),
	dteDate DATETIME,
	txtItem VARCHAR(50),
	txtValue VARCHAR(400))


SELECT TOP 0  
	*
INTO dbo.bkp_tmp_activeX20141107
FROM dbo.tblActiveX AS TAX


SELECT
	COUNT(*)
FROM bkp_tmp_tblUnifiedPricesReport_20140926

SELECT
	COUNT(*)
FROM bkp_tmp_tblUnifiedPricesReport_20140829_V


TMP_TBLUNIFIEDPRICESREPORT20140926.txt


SELECT TOP 0  
	*
INTO dbo.bkp_tblAverageVector_20140926
FROM tblAverageVector

TBLAVERAGEVECTOR20140926.txt

SELECT
	*
FROM bkp_tmp_tblUnifiedPricesReport_17

--DROP TABLE bkp_tmp_tblBondsAdd_20130408

-- Cargamos


SELECT TOP 0 * INTO dbo.bkp_tmp_tblActualPricesSN_20141128
FROM  dbo.tmp_tblActualPricesSN AS TTAPS





EXEC dbo.usp_upload_data 'bkp_tmp_tblActualPricesSN_20141128','\\vic-testsql\PRODUCCION\MxVprecios\Temp\TMP_TBLACTUALPRICESSN20141128.txt'


EXEC dbo.usp_upload_data 'bkp_tmp_tblUnifiedPricesReport_20141128','\\vic-testsql\PRODUCCION\MxVprecios\Temp\TMP_TBLUNIFIEDPRICESREPORT20141128.txt'



SELECT TOP 0 *  INTO  dbo.bkp_tmp_tblUnifiedPricesReport_20141128 FROM  dbo.tmp_tblUnifiedPricesReport 







SELECT * FROM  bkp_tmp_tblActualPricesSN_20141128


SELECT * FROM bkp_tmp_activeX20141107

EXEC dbo.usp_upload_data 'bkp_tblAverageVector_20140926','\\PIPMXSQL\TEMP\TBLAVERAGEVECTOR20140926.txt'

EXEC dbo.usp_upload_data 'bkp_tmp_tblBondsAdd_20130408','\\PIPMXSQL\TEMP\TBLBONDSADD20130408.txt'

