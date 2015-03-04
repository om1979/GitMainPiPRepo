
SELECT * FROM  sys.procedures
WHERE name LIKE 'sp_productos_bnp'

sp_productos_bnp;1 '20150206'
/*
Modifica:  Omar Adrian Aceves Guttierez
Fecha de Modificación:  2015-03-03 11:45:54
Descripcion  :   SP para crear producto BNP_D_XLS
*/
	ALTER    PROCEDURE DBO.sp_productos_bnp 
	 @dtedate datetime 	
	AS 
	BEGIN
	 
	SET NOCOUNT OFF

				DECLARE  @tblReport TABLE 
						(
						intId INT IDENTITY(1,1),
						dteDate VARCHAR(15) ,
						txtTv varchar(15),
						txtEmisora varchar(15),
						txtSerie varchar(15),
						txtDMF_MD varchar(20) ,
						txtDMF_24H varchar(20)
						)
						
	--/*Agregamos encabezados*/					
						--INSERT INTO @tblReport 
						--	SELECT 
						--	'FECHA','TIPO VALOR','EMISORA','SERIE','DURACION MD','DURACION 24H'  		


	/*obtenemos DMF para MD y 24H*/
			WITH TBL1 (txtId1,dteDate,txtTv,txtEmisora,txtSerie,txtDMF_MD)
				AS  
					(
					SELECT
						txtId1,
						dteDate,
						txtTv,
						txtEmisora,
						txtSerie,
						CASE WHEN  txtDMF NOT IN ('-','NA') THEN  STR(txtDMF,20,12) ELSE '-' END  AS txtDMF_MD
					 FROM  dbo.tmp_tblUnifiedPricesReport
					WHERE txtLiquidation IN ('MD','MP') 
					),
				
				  TBL2 (txtId1,dteDate,txtTv,txtEmisora,txtSerie,txtDMF_24H) --para liquidacion 24H
				AS  
					(
					SELECT
						txtId1,
						dteDate,
						txtTv,
						txtEmisora,
						txtSerie,
						CASE WHEN  txtDMF NOT IN ('-','NA') THEN  STR(txtDMF,20,12) ELSE '-' END  AS txtDMF_24H
					 FROM  dbo.tmp_tblUnifiedPricesReport
					WHERE txtLiquidation  IN ('24H','MP')  
					)
				
	--	/*Contenemos consulta*/		
 		INSERT INTO @tblReport  (dteDate,txtTv,txtEmisora,txtSerie ,txtDMF_MD ,txtDMF_24H )
				SELECT CONVERT(VARCHAR(10),A1.dtedate,112),A1.txttv,A1.txtEmisora,A1.txtSerie,A1.txtDMF_MD,A2.txtDMF_24H FROM  TBL1 AS A1
						INNER JOIN TBL2 AS A2
						ON A1.txtId1 = A2.txtId1
							ORDER  BY  A1.txtTv,A1.txtEmisora,A1.txtSerie
			
			
			/*Regresamos Consulta*/			
			SELECT dteDate,txtTv,txtEmisora,txtSerie ,txtDMF_MD ,txtDMF_24H FROM  @tblReport
			ORDER BY intId asc
			
			
			
		SET NOCOUNT ON 
	END 





--/*CONFIGURANDO PRODUCTO*/


--SELECT * FROM  dbo.tblProcesos
--WHERE txtClase = 'CLSGENERIC'
--AND txtProducto LIKE '%JPMORGAN_CURVES_GBPMX_XLS%'




--INSERT tblProcesos 
--	SELECT
--	 'BNP_D_XLS'
--	,txtLibreria
--	,txtClase
--	,txtMetodo
--	,'Proceso para elaborar personalizado BNP' 
--		FROM  dbo.tblProcesos
--		WHERE txtProducto = 'SGENOVEVA_VEC_FR_XLS'


--INSERT dbo.tblActiveX
--	SELECT 
--	'BNP_D_XLS'
--	,txtPropiedad
--	,txtTipo
--	,txtValor
--	,txtDescripcion
--		 FROM  dbo.tblActiveX
--		WHERE txtProceso = 'BLACKROCK_VEC_ASK_XLS'
		
		
--		INSERT INTO  dbo.tblActiveX
--		SELECT * FROM  [VIA-MXSQL].MxFixIncome.dbo.tblActiveX  WHERE txtProceso = 'SGENOVEVA_VEC_FR_XLS'



--INSERT MxProcesses..tblProcessCatalog
--	SELECT 
--	'BNP_D_XLS'
--	,txtLibrary
--	,txtClass
--	,txtMethod
--	,'Proceso para elaborar personalizado BNP'
--	,bitStatus
--	,fWebTransfer 
--		FROM  MxProcesses..tblProcessCatalog
--		WHERE txtProcess = 'SGENOVEVA_VEC_FR_XLS'



--INSERT MxProcesses..tblProcessDurations
--	SELECT 
--	'BNP_D_XLS'
--	,dteAverageDuration
--	,dteAllowedDuration
--		 FROM  MxProcesses..tblProcessDurations
--		WHERE txtProcess = 'SGENOVEVA_VEC_FR_XLS'



--INSERT MxProcesses..tblProductGeneratorMap 
--	SELECT 
--	'BNP_D_XLS'
--	,txtFamily
--	,'OPERATIVO_2'
--	,intPriority
--	,txtOwnerId
--	,fload
--		 FROM  MxProcesses..tblProductGeneratorMap
--		WHERE txtProduct = 'SGENOVEVA_VEC_FR_XLS'

--dbo.sp_productos_bnp;1


--	SELECT 
--	'BNP_D_XLS'
--	,txtPropiedad
--	,txtTipo
--	,txtValor
--	,txtDescripcion
--		 FROM  dbo.tblActiveX
--		WHERE txtProceso = 'BNP_D_XLS'
	

--UPDATE  dbo.tblActiveX 
--SET txtValor = '\\Vic-testsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\Bnp\'
--		 FROM  dbo.tblActiveX
--		WHERE txtProceso = 'BNP_D_XLS'
--		AND txtPropiedad = 'FilePath'

--UPDATE  dbo.tblActiveX 
--SET txtValor = 'clsBNP_D.Log'
--		 FROM  dbo.tblActiveX
--		WHERE txtProceso = 'BNP_D_XLS'
--		AND txtPropiedad = 'LogFile'
		
		
		
--	UPDATE  dbo.tblActiveX 
--SET txtValor = 'sp_productos_bnp;1' + CHAR(39) +  '[DATE|YYYYMMDD]' + CHAR(39)
--		 FROM  dbo.tblActiveX
--		WHERE txtProceso = 'BNP_D_XLS'
--		AND txtPropiedad = 'SPDataName'


				
--	UPDATE  dbo.tblActiveX 
--SET txtValor = 'BNP_D[DATE|YYYYMMDD].xls'
--		 FROM  dbo.tblActiveX
--		WHERE txtProceso = 'BNP_D_XLS'
--		AND txtPropiedad = 'FileName'
		
--			UPDATE  dbo.tblActiveX 
--SET txtValor = 'Template_BNP_D.xls'
--		 FROM  dbo.tblActiveX
--		WHERE txtProceso = 'BNP_D_XLS'
--		AND txtPropiedad = 'TemplateFile'
		

	