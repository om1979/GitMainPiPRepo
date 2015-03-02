SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'HSBC_VALVID_XLS'


UPDATE  dbo.tblActiveX
SET txtValor = '\\pipmxsql\pruebas\MxVprecios\Productos\Definitivo\Bloomberg\Actual\'
WHERE txtProceso = 'HSBC_VALVID_XLS'
AND txtPropiedad = 'FilePath'


---\\PIPMXSQL\PRODUCCION\MXVPRECIOS\Productos\Definitivo\HSBC\Actual\



SELECT * FROM   MxProcesses.dbo.tblProductGeneratorMap
WHERE txtProduct = 'HSBC_VALVID_XLS'


UPDATE  MxProcesses.dbo.tblProductGeneratorMap
SET txtPack = 'OPERATIVO_2' 
WHERE txtProduct = 'HSBC_VALVID_XLS'




SELECT * FROM  MxProcesses.dbo.tblProductGeneratorMap
WHERE txtPack = 'OPERATIVO_2' 


UPDATE MxProcesses.dbo.tblProductGeneratorMap
SET FLOAD = 
WHERE txtProduct = 'PIP_MARKET_REF_DEF_HTM'

  







--pack original = 'P215'