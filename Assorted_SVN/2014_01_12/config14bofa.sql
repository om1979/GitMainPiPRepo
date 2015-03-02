




SELECT * FROM  dbo.tblCurves 
WHERE dteDate = '20071111'







SELECT * FROM  dbo.tblHolidays
WHERE txtCountry = 'MX' ORDER BY 2





SELECT * FROM  dbo.tblActiveX
WHERE txtProceso =
'BOFA_EmisionSemBonos_XLS'




UPDATE  dbo.tblActiveX
SET txtValor = '\\Pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\BOFA\ACTUAL\'
WHERE txtProceso = 'BOFA_EmisionSemBonos_XLS'
AND  txtPropiedad = 'FilePath'


--\\pipmxsql\pruebas\MxVprecios\Productos\Definitivo\Bloomberg\Actual\
--\\Pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\BOFA\ACTUAL\

SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct = 'BOFA_EmisionSemBonos_XLS'


SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtPack = 'OPERATIVO_2'


UPDATE MxProcesses..tblProductGeneratorMap
SET FLOAD = 1
WHERE txtProduct = 'PIP_MARKET_REF_DEF_HTM'    


--txtPack = 'OPERATIVO_2'



UPDATE MxProcesses..tblProductGeneratorMap
SET txtPack = 'DEFINITIVO_2'
WHERE txtProduct = 'BOFA_EmisionSemBonos_XLS'


sp_helptext sp_productos_BOFA