


SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso IN 
(
'COVAF_MANDATOS_MSCI_EURO_PIP',
'COVAF_MANDATOS_MSCI_EURO_XLS',
'COVAF_MANDATOS_MSCI_WORLD_PIP',
'COVAF_MANDATOS_MSCI_WORLD_XLS'
)AND txtPropiedad IN ('SPDataName')

txtProceso
COVAF_MANDATOS_MSCI_EURO_PIP
COVAF_MANDATOS_MSCI_EURO_XLS
COVAF_MANDATOS_MSCI_WORLD_PIP
COVAF_MANDATOS_MSCI_WORLD_XLS

txtValor
--usp_productos_PIPGenericos;24 '[DATE|YYYYMMDD]'--OK
usp_productos_PIPGenericos;23 '[DATE|YYYYMMDD]'--OK
--usp_productos_PIPGenericos;21 '[DATE|YYYYMMDD]'
usp_productos_PIPGenericos;22 '[DATE|YYYYMMDD]'--OK





SELECT * FROM  dbo.tblActiveX  WHERE txtProceso 
='COVAF_MANDATOS_MSCI_EURO_XLS'



SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtProduct = 'COVAF_MANDATOS_MSCI_EURO_XLS'



SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtProduct = 'COVAF_MANDATOS_MSCI_WORLD_XLS'



-------------------------------------------------------------
-------------------------------------------------------------
-------------------------------------------------------------

SELECT * FROM  dbo.tblActiveX 
WHERE txtProceso = 'COVAF_MANDATOS_MSCI_EURO_XLS'


SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtProduct = 'COVAF_MANDATOS_MSCI_WORLD_XLS'





--txtPack
--MANDATOS



 UPDATE MxProcesses..tblProductGeneratorMap 
 SET  txtPack = 'MANDATOS'
WHERE txtProduct = 'COVAF_MANDATOS_MSCI_WORLD_XLS'




UPDATE   MxProcesses..tblProductGeneratorMap 
 SET  txtPack = 'MANDATOS'
WHERE txtProduct = 'COVAF_MANDATOS_MSCI_EURO_XLS'




-----------------------------------------------------------------------

UPDATE  dbo.tblActiveX 
SET TXTVALOR  = '\\pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\COVAF\'
WHERE txtProceso = 'COVAF_MANDATOS_MSCI_WORLD_XLS'
AND txtPropiedad = 'FilePath'



UPDATE  dbo.tblActiveX 
SET TXTVALOR  = '\\pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\COVAF\'
WHERE txtProceso = 'COVAF_MANDATOS_MSCI_EURO_XLS'
AND txtPropiedad = 'FilePath'





SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtPack = 'operativo_2'





UPDATE MxProcesses..tblProductGeneratorMap
SET fload = 1
WHERE txtProduct = 'PIP_MARKET_REF_DEF_HTM'


\\pipmxsql\Produccion\MxVprecios\temp\


--\\pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\COVAF\
--\\pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\COVAF\

