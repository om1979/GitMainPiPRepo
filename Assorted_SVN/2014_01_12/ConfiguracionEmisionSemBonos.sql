
SELECT * FROM dbo.tblProcesos
WHERE txtProducto = 'VBIDASK_EXCEL'

SELECT * FROM dbo.tblActiveX
WHERE txtProceso =  'VBIDASK_EXCEL'




SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'BOFA_EmisionSemBonos_XLS'




INSERT INTO mxprocesses.dbo.tblProcessDurations VALUES ('BOFA_EmisionSemBonos_XLS','1900-01-01 00:00:00.000','1900-01-01 00:01:00.000')





INSERT mxprocesses.dbo.tblproductgeneratormap VALUES ('BOFA_EmisionSemBonos_XLS','PRECIOS','INACTIVO','6','STD02','1')



INSERT INTO mxprocesses.dbo.tblProcessCatalog VALUES ('BOFA_EmisionSemBonos_XLS','PIP_Products','clsGeneric','Execute','Vector BOFA_EmisionSemBonos_XLS',1,NULL)


UPDATE dbo.tblActiveX
SET txtValor = 'EMISIONESBONOScls.Log'
WHERE  txtProceso = 'BOFA_EmisionSemBonos_XLS'
AND txtPropiedad = 'LogFile'


FileName		PreciosPiP_PRL_PIPP[DATE|YYYYMMDD].XLS
--BOFA_EmisionSemBonos[DATE|YYYYMMDD].xls