--sp_helptext sp_analytic_MIH


  /*INSERTA *analiticos en tabla tblResults*/
  -- agrego los analiticos a la tabla de resultados  
  
  /*SELECCIONA*/   
  @txtDate,  --FECHA PARAMETRO
  tmp_tblExtremePrices.txtId1,  
  @txtAnalytic,  --VALOR PARAMETRO DE ANALITICO
  
  CASO: SI: tblPrices.dblValue < tmp_tblExtremePrices.dblPrice 
   ENTONCES:SUBSTRING(CONVERT(VARCHAR, CAST(@txtDate AS DATETIME), 20),1,10) --SE TOMAN LOS PRIMEROS 10 CARACTERES DE FECHA FORMATEADA 
   OTRO:
    SUBSTRING(CONVERT(VARCHAR, tmp_tblExtremePricesDates.dteDate, 20),1,10)  -- SE TOMAN LOS PRIMEROS 10 CARACTERES DE FECHA FORMATEADA DE TABLA tmp_tblExtremePricesDates 
   --COMO txtValue
  
  
  DE_TABLAS:   tmp_tblExtremePrices,tblUni,tmp_tblExtremePricesDates,tblPrices
  INNER JOIN tblUni 
  EN: tmp_tblExtremePrices.txtId1 = tblUni.txtId1   
  AND tblUni.txtAnalytic = @txtAnalytic   
  INNER JOIN tmp_tblExtremePricesDates  
  EN: tmp_tblExtremePricesDates.txtId1 = tblUni.txtId1  
  INNER JOIN tblPrices   
  EN: tblUni.txtId1 = tblPrices.txtId1   
  DONDE:  tmp_tblExtremePrices.txtItem = 'DHP'  
  Y: epd.txtItem = 'MIH'  
  Y: tblPrices.dteDate = @txtDate  
  Y: tblPrices.txtItem ESTE_CONTENIDO_EN: ('PRL', 'PAV')  
  Y: tblPrices.txtLiquidation ESTE_CONTENIDO_EN: ('MD', 'MP')  
  
--END   