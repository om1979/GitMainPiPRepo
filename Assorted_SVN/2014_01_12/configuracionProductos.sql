



SELECT DISTINCT txtNEM,REPLACE(txtNEM,',','') FROM  dbo.tmp_tblUnifiedPricesReport
WHERE CHARINDEX(',',txtNEM,0)>0


  SELECT DISTINCT 
  REPLACE( replace( replace( replace( replace( replace( RTRIM(LTRIM(txtNEM)), 'á', 'A' ), 'é', 'E' ), 'í', 'I' ), 'ó', 'O' ), 'ú', 'U' ),',','') 
 FROM  dbo.tmp_tblUnifiedPricesReport
WHERE CHARINDEX(',',txtNEM,0)>0



--txtnem 
sp_helptext usp_productos_GoldmanSachs;4





GS_VectorAnalítico_24H_XLS


--GS_VectorAnalítico_MD_XLS


SELECT * INTO #tblActiveX20140819  FROM  dbo.tblActiveX



--DELETE  FROM    dbo.tblActiveX
--WHERE txtProceso = 'GS_VectorAnalítico_MD_XLS'



SELECT TOP 10 * FROM  dbo.tblActiveX
INSERT INTO dbo.tblActiveX

SELECT 
'GS_FullUniverseCSV',
txtPropiedad,
txtTipo,
txtValor,
txtDescripcion
FROM  dbo.tblActiveX
WHERE txtProceso = 'GS_VectorAnalítico_24H_XLS'


SELECT * FROM  dbo.itblQASon
WHERE txtSonName LIKE '%%'





SELECT * FROM  dbo.tmp_tblUnifiedPricesReport

SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'GS_FullUniverseCSV'


SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'GS_VectorAnalítico_24h_XLS'



UPDATE dbo.tblActiveX
SET txtValor = 'Full_Universe_[DATE|YYYYMMDD].txt'
--SET txtValor = 'usp_productos_GoldmanSachs;5' + CHAR(39)+ '[DATE|YYYYMMDD]'+CHAR(39)
WHERE txtProceso = 'GS_FullUniverseCSV'
AND txtPropiedad = 'FileName'






UPDATE dbo.tblActiveX
SET txtValor = '\\pipmxsql\Produccion\MxVprecios\PRODUCTOS\DEFINITIVO\GoldmanSachs\'
WHERE txtProceso IN ('GS_FullUniverseCSV','GS_VectorAnalítico_24h_XLS','GS_VectorAnalítico_MD_XLS','GOLDMAN_SACHS_TC_CSV')
AND txtPropiedad = 'FilePath'

UPDATE MxProcesses..tblProductGeneratorMap
SET txtPack = 'DEFINITIVO_2'
WHERE txtProduct IN ('GS_VectorAnalítico_24h_XLS','GS_VectorAnalítico_MD_XLS')





GOLDMAN_SACHS_TC_CSV
--	GOLDMAN_SACHS_TC_CSV	PRECIOS	OPERATIVO	1	generic   	1


SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct IN ('GS_VectorAnalítico_24h_XLS','GS_VectorAnalítico_MD_XLS')



UPDATE MxProcesses..tblProductGeneratorMap
SET txtPack = 'DEFINITIVO_2'
WHERE txtProduct IN ('GS_VectorAnalítico_24h_XLS','GS_VectorAnalítico_MD_XLS')






SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'GS_FullUniverseCSV'
--

SELECT * FROM  dbo.tblActiveX
WHERE txtProceso IN ('GS_VectorAnalítico_24h_XLS','GS_VectorAnalítico_MD_XLS')
AND txtPropiedad = 'FilePath'

--\\pipmxsql\Produccion\MxVprecios\temp\

UPDATE  dbo.tblActiveX
SET txtValor = '\\pipmxsql\Produccion\MxVprecios\PRODUCTOS\DEFINITIVO\GoldmanSachs\'
WHERE txtProceso IN ('GS_VectorAnalítico_24h_XLS','GS_VectorAnalítico_MD_XLS')
AND txtPropiedad = 'FilePath'












SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct IN ('GS_VectorAnalítico_24h_XLS','GS_VectorAnalítico_MD_XLS')










UPDATE MxProcesses..tblProductGeneratorMap
SET FLOAD =1
WHERE txtProduct = 'PIP_MARKET_REF_DEF_HTM'


SELECT DISTINCT intPriority FROM  MxProcesses..tblProductGeneratorMap
WHERE  txtPack = 'DEFINITIVO'


WHERE txtProduct = 'GS_FullUniverseCSV'


SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE  txtPack = 'OPERATIVO_2'
