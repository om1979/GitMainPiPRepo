



SELECT * FROM  dbo.tblActiveX AS TAX 
WHERE txtProceso LIKE '%PIP_NIVELESDEMERCADO_XLS%'




SELECT * FROM  dbo.tblActiveX AS TAX 
WHERE txtProceso LIKE '%PIP_NIVELESDEMERCADO_XLS%'
AND txtPropiedad = 'FilePath'





UPDATE   dbo.tblActiveX 
SET txtvalor = '\\pipmxsql\PRODUCCION\MXVPRECIOS\Productos\Definitivo\FRPIP\'
WHERE txtProceso LIKE '%PIP_NIVELESDEMERCADO_XLS%'
AND txtPropiedad = 'FilePath'


\\pipmxsql\PRODUCCION\MXVPRECIOS\Productos\Definitivo\FRPIP\
\\pipmxsql\PRODUCCION\MxVprecios\temp\


SELECT * FROM  MxProcesses..tblProductGeneratorMap AS TPGM
WHERE txtProduct LIKE '%PIP_NIVELESDEMERCADO_XLS%'
AND txtPack = 'DEF_CUR'



UPDATE MxProcesses..tblProductGeneratorMap 
SET txtPack = 'DEF_CUR'--DEF_CUR
WHERE txtProduct LIKE '%PIP_NIVELESDEMERCADO_XLS%'
AND txtPack = 'OPERATIVO_2'--OPERATIVO_2



SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtPack = 'OPERATIVO_2'


UPDATE MxProcesses..tblProductGeneratorMap 
SET FLOAD = 1
WHERE txtProduct = 'PIP_MARKET_REF_DEF_HTM'


