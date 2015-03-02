

SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'PIP_NIVELESDEMERCADO_XLS'


UPDATE  dbo.tblActiveX
SET txtValor = '\\PIPMXSQL\PRODUCCION\MXVPRECIOS\Productos\Definitivo\FRPIP\'
WHERE txtProceso = 'PIP_NIVELESDEMERCADO_XLS'
AND txtPropiedad = 'FilePath'



SELECT * FROM  MxProcesses.dbo.tblProductGeneratorMap
WHERE txtProduct = 'PIP_NIVELESDEMERCADO_XLS'
AND txtPack = 'DEF_CUR'--


UPDATE MxProcesses.dbo.tblProductGeneratorMap
SET txtPack = 'DEF_CUR'-- --DEFINITIVO
WHERE txtProduct = 'PIP_NIVELESDEMERCADO_XLS'
AND txtPack = 'OPERATIVO_2'--DEFINITIVO






SELECT * FROM  MxProcesses.dbo.tblProductGeneratorMap
WHERE txtPack = 'OPERATIVO_2'


--\\pipmxsql\pruebas\MxVprecios\Productos\Definitivo\Bloomberg\Actual\
--\\PIPMXSQL\PRODUCCION\MXVPRECIOS\Productos\Definitivo\FRPIP\