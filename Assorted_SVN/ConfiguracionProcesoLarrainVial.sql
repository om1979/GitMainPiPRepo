



----SELECT * FROM  MxProcesses..tblDevilCatalog


--SELECT * FROM    MxProcesses..tblDevilProcessCatalog
--WHERE intIdProcess = 1013
----ORDER BY 3 DESC

--UPDATE MxProcesses..tblDevilProcessCatalog
--SET txtProcessName = 'NOTIFY_FILE_INPUT_LARRAINVIAL'
--WHERE intIdProcess = 1013


--SELECT * FROM   MxProcesses..tblDevilConfiguration
--WHERE intIdProcess = 245




--INSERT INTO   MxProcesses..tblDevilProcessCatalog
--SELECT
--txtIdDevil
--,txtHostName
--,1013
--,'NOTIFY_FILE_INPUT_LARRAINVIAL_TXT' 
--,'Archivo Precios Larrainvial txt',
--bitSts
-- FROM  MxProcesses..tblDevilProcessCatalog
--WHERE intIdProcess = 1012






--NOTIFY_INPUT_VAR_HECHOS




SELECT  * FROM tblProcessCatalog
WHERE txtProcess = 'NOTIFY_FILE_INPUT_LARRAINVIAL'

SELECT * FROM  dbo.tblProcessDurations
WHERE
	txtProcess = 'NOTIFY_FILE_INPUT_LARRAINVIAL'	
	


SELECT * FROM   MxProcesses..tblDevilConfiguration
WHERE intIdProcess = 1013

SELECT * FROM  MxProcesses..tblDevilProcessCatalog
WHERE intIdProcess = 1013




SELECT  * FROM tblProcessCatalog
WHERE txtProcess = 'LOAD_FILE_LARRAINVIAL'

SELECT * FROM  tblProcessConfiguration
WHERE txtProcess = 'LOAD_FILE_LARRAINVIAL'

SELECT * FROM  tblProcessParameters
WHERE txtProcess = 'LOAD_FILE_LARRAINVIAL'

SELECT * FROM dbo.tblProcessDurations
WHERE
	txtProcess = 'LOAD_FILE_LARRAINVIAL'
	
	




	
	UPDATE tblProcessParameters
SET txtValue = '\\VIA-LATIIS\ftproot\LocalUser\Larrainvial\Insumo\'
WHERE txtProcess = 'LOAD_FILE_LARRAINVIAL'
AND txtParameter = 'InputPath'

Header = "BARCLAYS_BGI"

--"sp_clsBarclaysIOPV;2 '[FORMAT(TODAY, YYYYMMDD)]', 0 "

SELECT * FROM  MxProcesses..tblProcessParameters
WHERE txtProcess = 'BARCLAYS_BGI_IOPV_LOADF'


SELECT 'sp_inputs_LarrainVial;2 '  +CHAR(39) +'[FORMAT(TODAY, YYYYMMDD)]' + CHAR(39)

SELECT * FROM  tblProcessParameters
WHERE txtProcess = 'LOAD_FILE_LARRAINVIAL'

\\vic-testsql\PRODUCCION\MxVprecios\Insumos\Larrainvial\


LOAD_FILE_LARRAINVIAL
NOTIFY_FILE_INPUT_LARRAINVIAL





SELECT
	*
FROM tblProcLineProcesses AS A
INNER JOIN  MxProcesses.dbo.tblProcLineCatalog  AS B
ON a.intProcLine = b.intProcLine


SELECT MAX(intProcLine) FROM tblProcLineProcesses


SELECT * FROM  tblProcLineCatalog

INSERT INTO tblProcLineCatalog
SELECT 148,1,'Insumo'





INSERT INTO  MxProcesses.dbo.tblProcLineProcesses 
SELECT  148,'NOTIFY_FILE_INPUT_LARRAINVIAL','Insumo',NULL





WHERE
	txtProcess IN ('BARCLAYS_BGI_IOPV_LOADF','NOTIFY_INPUT_IMC30_COMP')
	
	
	
	
SELECT * FROM   MxProcesses.dbo.tblProcLineCatalog 



SELECT * FROM  




