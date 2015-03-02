

sp_analytic_mdy

/*INSERTA EN TABLA TEMP  #tblMDY */
  /*SELECCIONA*/     
  tmp_tblExtremePricesYear.txtId1,  
  tmp_tblExtremePricesYear.dblPrice  
 
  DE_TABLAS:   tmp_tblExtremePricesYear,tblUni
  INNER JOIN tblUni 
  EN: tmp_tblExtremePricesYear.txtId1 = tblUni.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
  DONDE:  
  tmp_tblExtremePricesYear.txtItem = 'MDY'  
   
   
/*INSERTA EN TABLA TEMP  #tblMDY */
   /*SELECCIONA*/     
  tblPrices.txtId1,  
  tblPrices.dblValue  
  DE_TABLAS:tblPrices,tblUni
  INNER JOIN tblUni AS u (NOLOCK)  
  EN: tblPrices.txtId1 = tblUni.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
  DONDE:  
  tblPrices.dteDate = @txtDate  
  Y: tblPrices.txtItem CONTENIDO_EN: ('PRL', 'PAV')  
  Y: tblPrices.txtLiquidation CONTENIDO_EN: ('MD', 'MP')  
  
  
  /*INSERTA A tblResults  CARGA ANALITICOS DE #tblMDY*/  
  /*SELECCIONA*/   
  @txtDate, --VALOR DE PARAMETRO FECHA 
  txtId1,  
  @txtAnalytic,  --VALOR DE PARAMETRO ANALITICO 
  LTRIM(STR(MAX(dblPrice), 11, 6)) --SELECCIONA VALOR MAXIMO Y FORMATEA A 6 DECIMALES POR ID1
  FROM #tblMDY (NOLOCK)  
  GROUP BY   
  txtId1  