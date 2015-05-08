  
 

	/*
	AUTOR:		OMAR ADRIAN ACEVES GUTIERREZ
	FECHA:		2015-05-05 11:15:40.947
	OBJETIVO:	CARGAR ARCHIVOS INSUMOS EN TABLA FINAL 
	*/  
	ALTER   PROCEDURE  sp_inputs_LarrainVial;1  
		@dtedate varchar(20)  
			AS  
	BEGIN  
		/*INSERTAMOS DATOS DE TABLA DE CARGA A TABLA FINAL */
		INSERT INTO  dbo.tblLarrainVial_instruments
			--SELECT DISTINCT  txtid1 from tmp_tblInputsLarrainVial_instruments
	select 'hola'
			--TRUNCATE TABLE tmp_tblInputsLarrainVial_instruments
	
	END 


select * from tblLarrainVial_instruments
select * from tmp_tblInputsLarrainVial_instruments