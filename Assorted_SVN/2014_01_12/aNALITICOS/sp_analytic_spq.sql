SP_HELPTEXT sp_analytic_spq  



/*SE EJECUTA PARA OBTENER INSUMO*/
	--dbo.sp_analytic_spq;1
		/*EXPLICADO A CONTINUACIÓN*/
		-- obtenemos la calificacion mas reciente 
 /*INSERTA A TABLA TEMP tmp_tblspq*/ 

	 /*SELECCIONA*/      
	  tblRattings.txtId1,  
	  tblRattings.txtRate  
	 DE_TABLAS: tblUni,tblRattings
	  INNER JOIN tblRattings   
	  EN: tblUni.txtId1 = tblRattings.txtId1  
	  Y: tblUni.txtAnalytic = 'spq'  
	 DONDE:  
	  tblRattings.txtRaterId = 'S&P'  
	  AND dteDate = (  
	   SELECT MAX(dteDate)  
	   FROM tblRattings (NOLOCK)  
	   WHERE  
		tblRattings.txtRaterId = 'S&P'  
		AND tblUni.txtId1txtId1 = tblRattings.txtId1  
		AND tblRattings.dteDate <= @txtDate   )  
		
	/*CUANDO SE TIENE LOS RESULTADOS EN LA TABLA TEMP tmp_tblspq */
		/*SE EJECUTA dbo.sp_analytic_spq;2 */
			/*EXPLICADO A CONTINUACIÓN*/





 /* SE REPORTAN RESULTADOS DE TABLA TEMP HACIA   tmp_tblspq */  
 
        /*INSERTA EN tblResults*/ 
			/*SELECCIONA*/    
				@txtDate,  
				tmp_tblspq.txtId1,  
				@txtAnalytic,  
				tmp_tblspq.txtRate  
			DE_TABLA: tmp_tblspq 