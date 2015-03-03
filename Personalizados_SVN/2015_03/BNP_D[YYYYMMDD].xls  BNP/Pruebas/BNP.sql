

/*
Modifica:  Omar Adrian Aceves Guttierez
Fecha de Modificación:  2015-03-03 11:45:54
Descripcion  :   SP para crear producto BNP_D
*/


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
					
/*Agregamos encabezados*/					
					INSERT INTO @tblReport 
						SELECT 
						'FECHA','TIPO VALOR','EMISORA','SERIE','DURACION MD','DURACION 24H'  		
						
						
/*el if solo esta para que no truene tabla CTE*/							
IF (1>3)
BEGIN 
SELECT 1
END 

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
			
 	INSERT INTO @tblReport  (dteDate,txtTv,txtEmisora,txtSerie ,txtDMF_MD ,txtDMF_24H )
 	
		SELECT CONVERT(VARCHAR(10),A1.dtedate,112),A1.txttv,A1.txtEmisora,A1.txtSerie,A1.txtDMF_MD,A2.txtDMF_24H FROM  TBL1 AS A1
					INNER JOIN TBL2 AS A2
				ON A1.txtId1 = A2.txtId1
					ORDER  BY  A1.txtTv,A1.txtEmisora,A1.txtSerie
					
SELECT * FROM  @tblReport
