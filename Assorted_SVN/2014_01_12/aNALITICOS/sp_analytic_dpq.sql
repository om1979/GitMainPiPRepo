--sp_analytic_dpq





 /* obtenemos la calificacion mas reciente Y SE INSERTAN EN   tmp_tblDPQ  */
 /*SELECCIONA*/      
  tblRattings.txtId1,  
  tblRattings.txtRate  
 DET_TABLAS:tblUni ,tblRattings
  INNER JOIN tblRattings AS r  
  ON tblUni.txtId1 = tblRattings.txtId1  
 DONDE:  
  tblRattings.txtRaterId CONTENIDOS_EN: ('D&P', 'MOO')  
  Y: dteDate = --SUBQUERY QUE OBTIENE LA MAXIMA FECHA DE tblRattings DONDE LA CLAIFICADORA SEA ('D&P', 'MOO') 
  (			   --POR IDI'1 Y LA FECHA SEA MENOR A LA FECHA DE CONSULTA
   SELECT MAX(dteDate)  
   FROM tblRattings  
   DONDE:  
    txtRaterId CONTENIDOS_EN: ('D&P', 'MOO')  
    Y: txtId1 = tblRattings.txtId1  
    Y: dteDate <= @txtDate  
  )  


         /*INSERTA EN tblResults*/  
        /*SELECCIONA*/  
            @txtDate,  --PARAMETRO DE FECHA
            txtId1,  
            @txtAnalytic,  --PARAMETRO DE DE ANALITICO
            txtRate  
        FROM tmp_tblDPQ  --DE TALA TEMP

  