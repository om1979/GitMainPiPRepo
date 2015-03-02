




--SP_HELPTEXT sp_analytic_DMD


  /*INSERTA EN TBLRESULTS*/
  /*SELECCIONA*/
  @txtDate,  --PARAMETRO DE VARIABLE
  tmp_tblExtremePricesYear.txtId1,  
  @txtAnalytic,  --PARAMETRO DE VARIABLE
  CASO:
	CUANDO:tblPrices.dblValue > tmp_tblExtremePricesYear.dblPrice ENTONCES:   
   SUBSTRING(CONVERT(VARCHAR, CAST(@txtDate AS DATETIME), 20),1,10)--SE TOMA PARAMETRO FECHA Y SE CAMBIO DE FORMATO , DE ESTE SE TOMAN LAS 10 PRIMERAS POSICIONES
  CUALQUIER_OTRO:   
   SUBSTRING(CONVERT(VARCHAR, tmp_tblExtremePricesDatesYear.dteDate, 20),1,10) --SE TOMA PARAMETRO FECHA Y SE CAMBIO DE FORMATO , DE ESTE SE TOMAN LAS 10 PRIMERAS POSICIONES DE tmp_tblExtremePricesDatesYear
  COMO:txtValue 

  DE_TABLAS:    tmp_tblExtremePricesYear,tblUni,tmp_tblExtremePricesDatesYear,tblPrices
  INNER JOIN tblUni 
  ON tmp_tblExtremePricesYear.txtId1 = tblUni.txtId1   
  AND tblUni.txtAnalytic = @txtAnalytic   
  INNER JOIN tmp_tblExtremePricesDatesYear 
  ON epd.txtId1 = tblUni.txtId1  
  INNER JOIN tblPrices 
  ON tblUni.txtId1 = tblPrices.txtId1   
  WHERE  
  tmp_tblExtremePricesYear.txtItem = 'MDY'  
  Y: tmp_tblExtremePricesDatesYear.txtItem = 'DMD'  
  Y: tblPrices.dteDate = @txtDate  
  Y: tblPrices.txtItem CONTENIDO_EN: ('PRL', 'PAV')  
  Y: tblPrices.txtLiquidation CONTENIDO_EN: ('MD', 'MP') 
  
  
   
  
