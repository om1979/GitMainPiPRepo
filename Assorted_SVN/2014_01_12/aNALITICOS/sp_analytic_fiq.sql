--SP_HELPTEXT sp_analytic_fiq



 -- OBTIENE  la calificacion mas reciente   Y LAS INSERTA EN TABLA TEMP tmp_tblfiq
 /*INSERTA EN TABLA tmp_tblfiq*/

 /*SELECCIONA*/      
  tblRattings.txtId1,  
  tblRattings.txtRate  
 DE_TABLAS:  tblUni AS u  ,tblRattings 
 
  INNER JOIN tblRattings AS r  
  ON tblUni.txtId1 = tblRattings.txtId1  
 WHERE  
  tblRattings.txtRaterId = 'FIT'  
  AND tblRattings.dteDate = (  
  
   SELECT MAX(tblRattings.dteDate)  
   FROM tblRattings  
   WHERE  
    tblRattings.txtRaterId = 'FIT'  
    AND tblUni.txtId1 = tblRattings.txtId1  
    AND tblRattings.dteDate <= @txtDate  
  )  
  
/*EJECUTA dbo.sp_analytic_fiq;2  */
	/*INSERTA RESULTADOS EN tblResults*/
		
		/*SELECCIONA*/ 
            @txtDate,  
            tmp_tblfiq.txtId1,  
            @txtAnalytic,  
            tmp_tblfiq.txtRate  
        FROM tmp_tblfiq  

