







SELECT * FROM  dbo.tblProcesos
WHERE txtProducto IN 
(
'JPMORGAN_VMD_MO'
)





--INSERT INTO dbo.tblProcesos
--SELECT 
--'JPMORGAN_VMD_MO',
--txtLibreria,
--txtClase,
--txtMetodo,
--'Producto: JPMVMD_MO[yyyymmdd].xls'
-- FROM  dbo.tblProcesos
--WHERE txtProducto IN 
--(
--'JPMORGAN_VEC_MD_MO'
--)

-----------------------------------------------------------

SELECT * FROM  dbo.tblActiveX
WHERE txtProceso IN 
(
'JPMORGAN_VMD_MO'
)




--INSERT INTO dbo.tblActiveX
--SELECT 
--'JPMORGAN_VMD_MO',
--txtPropiedad,
--txtTipo,
--txtValor,
--txtDescripcion
--FROM  dbo.tblActiveX
--WHERE txtProceso IN 
--(
--'JPMORGAN_VEC_MD_MO'
--)



SELECT * FROM  dbo.tblActiveX

--UPDATE dbo.tblActiveX
--SET txtValor = 'sp_productos_JPMORGAN;56 '  + CHAR(39) + '[DATE|YYYYMMDD]' + CHAR(39) + ','+CHAR(39) +'MD' + CHAR(39)
--WHERE txtProceso IN 
--(
--'JPMORGAN_VMD_MO'
--)
--AND txtPropiedad = 'SPDataName'



--JPMVMD_MO[yyyymmdd].xls




UPDATE dbo.tblActiveX
SET txtValor = 'JPMVMD_MO[DATE|YYYYMMDD].xls'
WHERE txtProceso IN 
(
'JPMORGAN_VMD_MO'
)
AND txtPropiedad = 'FileName'


--7Bc[DATE|YYYYMMDD].csv



-------------------------------------------------------------




SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct IN 
(
'JPMORGAN_VEC_MD_MO'
)


INSERT INTO MxProcesses..tblProductGeneratorMap
SELECT 'JPMORGAN_VMD_MO',txtFamily,txtPack,intPriority,txtOwnerId,fload FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct IN 
(
'JPMORGAN_VEC_MD_MO'
)


-----------------------------------------------------------------------

SELECT * FROM  MxProcesses..tblProcessCatalog
WHERE txtProcess = 'JPMORGAN_VEC_MD_MO'




INSERT INTO  MxProcesses..tblProcessCatalog
SELECT 'JPMORGAN_VMD_MO',txtLibrary,txtClass,txtMethod,'Producto: JPMVMD_MO[yyyymmdd].xls',bitStatus,fWebTransfer
 FROM  MxProcesses..tblProcessCatalog
WHERE txtProcess = 'JPMORGAN_VEC_MD_MO'


------------------------------------------------------------------

SELECT * FROM  MxProcesses..tblProcessDurations
WHERE txtProcess = 'JPMORGAN_VEC_MD_MO'


INSERT INTO MxProcesses..tblProcessDurations
SELECT 'JPMORGAN_VMD_MO',dteAverageDuration,dteAllowedDuration FROM  MxProcesses..tblProcessDurations
WHERE txtProcess = 'JPMORGAN_VEC_MD_MO'