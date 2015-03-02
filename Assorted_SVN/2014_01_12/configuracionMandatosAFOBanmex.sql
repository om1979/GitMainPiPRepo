



SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'PIP_VEC_MANDATOS_NW_PIP'





SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'PIP_VEC_MANDATOS_NW_XLS'






UPDATE dbo.tblActiveX 
SET  txtValor = '\\PIPMXSQL\PRODUCCION\MXVPRECIOS\PRODUCTOS\DEFINITIVO\Vector_Mandatos\'
WHERE txtProceso = 'PIP_VEC_MANDATOS_NW_PIP'
AND txtPropiedad = 'FilePath' 


UPDATE dbo.tblActiveX 
SET  txtValor = '\\PIPMXSQL\PRODUCCION\MXVPRECIOS\PRODUCTOS\DEFINITIVO\Vector_Mandatos\'
WHERE txtProceso = 'PIP_VEC_MANDATOS_NW_XLS'
AND txtPropiedad = 'FilePath' 




usp_productos_PIPGenericos;18 '[DATE|YYYYMMDD]'
--MANDATOS

SELECT * FROM  MxProcesses.dbo.tblProductGeneratorMap
WHERE txtProduct = 'PIP_VEC_MANDATOS_NW_PIP'


SELECT * FROM  MxProcesses.dbo.tblProductGeneratorMap
WHERE txtProduct = 'PIP_VEC_MANDATOS_NW_XLS'






UPDATE MxProcesses.dbo.tblProductGeneratorMap
SET txtPack = 'MANDATOS'
WHERE txtProduct = 'PIP_VEC_MANDATOS_NW_PIP'


UPDATE MxProcesses.dbo.tblProductGeneratorMap
SET txtPack = 'MANDATOS'
WHERE txtProduct = 'PIP_VEC_MANDATOS_NW_XLS'


SELECT * FROM  MxProcesses.dbo.tblProductGeneratorMap
WHERE txtPack = 'OPERATIVO_2'




UPDATE MxProcesses.dbo.tblProductGeneratorMap
set   fload = 1
WHERE txtProduct =
'PIP_MARKET_REF_DEF_HTM'


--\\PIPMXSQL\PRODUCCION\MXVPRECIOS\PRODUCTOS\DEFINITIVO\Vector_Mandatos\


