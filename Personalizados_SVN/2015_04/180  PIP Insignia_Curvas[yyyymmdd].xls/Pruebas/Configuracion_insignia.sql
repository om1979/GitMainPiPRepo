

----INSERT tblProcesos
----select 
----'INSIGNIA_CURVAS_XLS'
----,txtLibreria
----,txtClase
----,txtMetodo
----,'Archivo  INSIGNIA_CURVAS_XLS '
---- from tblProcesos
----where txtproducto = 'CURVAS_DEUTSCHEBANK_XLS'



--INSERT INTO tblactivex
--select 
--'INSIGNIA_CURVAS_XLS'
--,txtPropiedad
--,txtTipo
--,txtValor
--,txtDescripcion
-- from tblactivex
--where txtProceso = 'BITAL_TC_XLS'



SELECT *FROM tblProcesos
WHERE txtProducto = 'BITAL_TC_XLS'

SELECT *FROM tblProcesos
WHERE txtProducto = 'INSIGNIA_CURVAS_XLS'


SELECT * FROM  tblactivex
WHERE txtPropiedad = 'Layout'
AND txtProceso LIKE '%XLS%'


SELECT * FROM  tblactivex 
where txtProceso  like '%CNSF_VEC_CLASIFICACIONES_XLS%'

bcpQuickQuery


SELECT * FROM  tblactivex 
where txtProceso  like '%INSIGNIA_CURVAS_XLS%'



UPDATE  tblactivex 
SET txtValor = 'xlQuickQuery'
where txtProceso = 'INSIGNIA_CURVAS_XLS'
AND txtPropiedad = 'Layout'





sp_productos_IXE;8 '20150427','MD'
----insert MxProcesses.dbo.tblprocesscatalog
----select 
----'INSIGNIA_CURVAS_XLS '
----,txtLibrary
----,txtClass
----,txtMethod
----,'Archivo  INSIGNIA_CURVAS_XLS '
----,bitStatus
----,fWebTransfer
---- from MxProcesses.dbo.tblprocesscatalog
----where txtprocess = 'CURVAS_DEUTSCHEBANK_XLS'


----insert MxProcesses.dbo.tblProcessDurations
----select 
----'INSIGNIA_CURVAS_XLS '
----,dteAverageDuration
----,dteAllowedDuration
---- from MxProcesses.dbo.tblProcessDurations
----where txtprocess = 'CURVAS_DEUTSCHEBANK_XLS'



--insert MxProcesses.dbo.tblProductGeneratorMap
--select 
--'INSIGNIA_CURVAS_XLS '
--,txtFamily
--,'OPERATIVO_2'
--,intPriority
--,'Insig'
--,fload
-- from MxProcesses.dbo.tblProductGeneratorMap
--where txtproduct = 'CURVAS_DEUTSCHEBANK_XLS'



select * from MxProcesses.dbo.tblProductGeneratorMap 
where txtPack = 'OPERATIVO_2'


update MxProcesses.dbo.tblProductGeneratorMap 
set fload = 1, txtPack = 'INACTIVO'--OPERATIVO_2
WHERE txtProduct = 'INSIGNIA_CURVAS_XLS'



update MxProcesses.dbo.tblProductGeneratorMap 
set fload = 1
WHERE txtProduct <> 'INSIGNIA_CURVAS_XLS'
AND txtPack = 'OPERATIVO_2'




ING_CUR_HIST_UDB_STP
--select * from sys.tables where name like '%owners%'



--insert tblOwnersCatalog
--select 'Insig','corporativo Insignia'

--select * from tblOwnersCatalog
--where txtdescription  like '%Insignia%'