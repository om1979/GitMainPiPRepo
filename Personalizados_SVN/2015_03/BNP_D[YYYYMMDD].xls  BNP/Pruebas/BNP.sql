

/*
Modifica:  Omar Adrian Aceves Guttierez
Fecha de Modificación:  2015-03-03 11:45:54
Descripcion  :   SP para crear producto BNP_D
*/

/*obtenemos DMF para MD y 24H*/
	WITH TBL1 (txtId1,dteDate,txtTv,txtEmisora,txtDMF_MD)
		AS  
			(
			SELECT
				txtId1,
				dteDate,
				txtTv,
				txtEmisora,
				CASE WHEN  txtDMF NOT IN ('-','NA') THEN  STR(txtDMF,20,12) ELSE '-' END  AS txtDMF_MD
			 FROM  dbo.tmp_tblUnifiedPricesReport
			WHERE txtLiquidation IN ('MD','MP') 
			),
		
		  TBL2 (txtId1,dteDate,txtTv,txtEmisora,txtDMF_24H)
		AS  
			(
			SELECT
				txtId1,
				dteDate,
				txtTv,
				txtEmisora,
				CASE WHEN  txtDMF NOT IN ('-','NA') THEN  STR(txtDMF,20,12) ELSE '-' END  AS txtDMF_24H
			 FROM  dbo.tmp_tblUnifiedPricesReport
			WHERE txtLiquidation  IN ('24H','MP')  
			)
			SELECT A1.*,A2.txtDMF_24H FROM  TBL1 AS A1
				INNER JOIN TBL2 AS A2
			ON A1.txtId1 = A2.txtId1
			--ORDER  BY  TBL1.txtTv



