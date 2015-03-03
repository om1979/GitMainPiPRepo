
  /* 
	Fecha:   2015-02-26 19:24:42.033
	Autor: Aceves Gutierrez omar adrian 
	Objetivo: truncar tabla de trabajo , para la carga del dia
 */   
 
 ALTER  PROCEDURE dbo.sp_inputs_LarrainVial ;1  
	 AS  
	 BEGIN  
 
			IF OBJECT_ID('MxFixIncome..tmp_LarrainVialIntruments') IS NULL
				CREATE TABLE tmp_LarrainVialIntruments
				(
				txtid1 varchar(12) NOT NULL ,
				txtType VARCHAR(2),
				dtedate datetime 
				)
			TRUNCATE TABLE  tmp_LarrainVialIntruments

	 END  
	
	
	 
/* 
	Fecha:    2015-02-26 19:24:42.033
	Autor:     Aceves Gutierrez omar adrian 
	Objetivo: Cargar Informacion 
 */   
	 ALTER  PROCEDURE dbo.sp_inputs_LarrainVial;2  
	 @txtDate AS VARCHAR(10)  
		 AS  
		 BEGIN  
			SET NOCOUNT ON  
			
				 INSERT INTO dbo.tblLarrainVialIntruments
					  SELECT 
							txtid1,
							txtType,
							CONVERT(VARCHAR(10),@txtDate,112)
					  FROM tmp_LarrainVialIntruments
					   
			 SET NOCOUNT OFF   
		 END  
		
		 