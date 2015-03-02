





insert into mxfixincome..tblprocesos values 
('ALL_CONSAR_NEW_DEF_24HINTRADIA','PIP_Products','clsGeneric','Execute','ALL_CONSAR_NEW_DEF_24H_INTRADIA')

























INSERT mxfixincome..tblactivex
SELECT
	'ALL_CONSAR_NEW_DEF_24HINTRADIA',
	txtPropiedad,
	txtTipo,
	txtValor,
	txtDescripcion
FROM mxfixincome.dbo.tblactivex
WHERE 
	txtproceso = 'ALL_CONSAR_NEW_DEF_24H'
	
	

SELECT * FROM mxfixincome..tblactivex 
WHERE txtProceso = 'ALL_CONSAR_NEW_DEF_24HINTRADIA'


UPDATE mxfixincome..tblactivex 
SET txtValor = '\\Pipmxsql\produccion\MxVprecios\PRODUCTOS\Intradia\NuevoConsar\'
WHERE txtProceso = 'ALL_CONSAR_NEW_DEF_24HINTRADIA'
AND txtPropiedad = 'FilePath'






INSERT INTO mxprocesses.dbo.tblProcessCatalog 
VALUES ('ALL_CONSAR_NEW_DEF_24HINTRADIA','PIP_Products','clsGeneric','Execute','NEW_DEF_INTRADIA',1,NULL)



INSERT INTO mxprocesses.dbo.tblProcessDurations VALUES ('ALL_CONSAR_NEW_DEF_24HINTRADIA','1900-01-01 00:00:00.000','1900-01-01 00:01:00.000')



INSERT mxprocesses.dbo.tblproductgeneratormap VALUES ('ALL_CONSAR_NEW_DEF_24HINTRADIA','PRECIOS','cns01','6','INTRADIA','1')


INSERT mxprocesses.dbo.tblproductgeneratormap VALUES ('ALL_CONSAR_NEW_DEF_24HINTRADIA','PRECIOS','INTRADIA','6','cns01','1')




SELECT * FROM  mxprocesses.dbo.tblproductgeneratormap 
WHERE txtProduct = 'ALL_CONSAR_NEW_DEF_24HINTRADIA'



SELECT DISTINCT txtPack FROM  MxProcesses.dbo.tblProductGeneratorMap

