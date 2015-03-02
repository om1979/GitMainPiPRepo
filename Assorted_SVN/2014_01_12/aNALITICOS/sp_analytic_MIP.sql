--SP_HELPTEXT sp_analytic_MIP



  /*INSERTA EN TABLA TEMP #tblMIP*/
  /*SELECCIONA*/   
  tmp_tblExtremePricesYear.txtId1,  
  tmp_tblExtremePricesYear.dblPrice   
  DE_TABLAS: tmp_tblExtremePricesYear,tblUni
  INNER JOIN tblUni 
  EN: tmp_tblExtremePricesYear.txtId1 = tblUni.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  --VALOR PARAMETRO ANALITICO
  DONDE:  
  tmp_tblExtremePricesYear.txtItem = 'MIP'  
   
  /*INSERTA EN TABLA TEMP #tblMIP*/
  /*SELECCIONA*/    
  tblPrices.txtId1,  
  tblPrices.dblValue  
  DE_TABLAS:tblPrices,tblUni 
  INNER JOIN tblUni,tblUni
  EN: tblPrices.txtId1 = tblUni.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
  DONDE:  
  tblPrices.dteDate = @txtDate  --VALOR PARAMETRO FECHA
  Y: tblPrices.txtItem CONTENIDOS_EN:  ('PRL', 'PAV')  
  Y: tblPrices.txtLiquidation CONTENIDOS_EN:  ('MD', 'MP')  
  
  -- agrego los analiticos a la tabla de resultados 
    /*SELECCIONA*/   
  @txtDate,  --VALOR PARAMETRO FECHA
  txtId1,  
  @txtAnalytic,  --VALOR PARAMETRO ANALITICO
  LTRIM(STR(MIN(dblPrice), 11, 6))   --SELECCIONA MINIMO VALOR POR ID1 FORMATEADO A 6 DECIMALES
  FROM #tblMIP (NOLOCK)  
  GROUP BY   
  txtId1  
  
