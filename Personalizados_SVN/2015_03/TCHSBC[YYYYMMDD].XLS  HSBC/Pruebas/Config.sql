



SELECT * FROM  dbo.tblActiveX
WHERE txtValor LIKE '%sp_productos_BITAL;22 %'



SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'BITAL_TC_BIS_XLS'



UPDATE dbo.tblActiveX
SET txtValor = '\\VIA-FILES\MxVPrecios\PRODUCTOS\DEFINITIVO\Bital\Actual\'
WHERE txtProceso = 'BITAL_TC_BIS_XLS'
AND txtPropiedad = 'FilePath'




UPDATE dbo.tblActiveX
SET txtValor = 'Template_Bital_TC_XLS_test.xls'
WHERE txtProceso = 'BITAL_TC_BIS_XLS'
AND txtPropiedad = 'TemplateFile'







UPDATE dbo.tblActiveX
SET txtValor = '\\VIA-FILES\MxVPrecios\PRODUCTOS\DEFINITIVO\Bital\Actual\'
WHERE txtProceso = 'BITAL_TC_BIS_XLS'
AND txtPropiedad = 'FilePath'

UPDATE dbo.tblActiveX
SET txtValor = '\\Vic-testsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\Bital\Actual\'
WHERE txtProceso = 'BITAL_TC_BIS_XLS'
AND txtPropiedad = 'FilePath'



SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtPack = 'operativo_2'

SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct = 'BITAL_TC_BIS_XLS'

\\Vic-testsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\Bital\Actual
\\VIA-FILES\MxVPrecios\PRODUCTOS\DEFINITIVO\Bital\Actual\


UPDATE MxProcesses..tblProductGeneratorMap
SET txtPack = 'operativo_2'
WHERE txtProduct = 'BITAL_TC_BIS_XLS'


--UPDATE   MxProcesses..tblProductGeneratorMap
--SET fload = 0
--WHERE txtPack = 'operativo_2'


BITAL_TC
BITAL_TC
BITAL_TC_BIS_CSV
BITAL_TC_BIS_CSV
BITAL_TC_BIS_XLS
BITAL_TC_CSV
BITAL_TC_CSV
BITAL_TC_XLS

dbo.sp_productos_BITAL;22 