 
 
 










sp_analytic_wpc

/*
CONSIGUE FECHA DE -5 DIAS HABILES A PARTE DEL PARAMETRO FECHA
Y SE ASIGNA A @dteLastDate
*/

/*CONSIGUE PRECIOS ANTERIORES Y LSO INSERTA EN #tblLastValues*/
/*SELECCIONA*/ 
  tblUni.txtId1,  
  tblPrices.txtLiquidation,  
  tblPrices.dblValue  
 DE_TABLAS:tblPrices,tblUni
  INNER JOIN tblUni AS u
  EN: tblPrices.txtId1 = u.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:  
  tblPrices.dteDate = @dteLastDate  
   Y: tblPrices.txtItem ESTE_CONTENIDO_EN: ('PAV', 'PRL')  
   Y: tblPrices.txtLiquidation ESTE_CONTENIDO_EN: ('24H', 'MP')  
  /* + UNION*/
  /*SELECCIONA*/    
  tblUni.txtId1,  
  tblHistoricPrices.txtLiquidation,  
  tblHistoricPrices.dblValue  
 DE_TABLAS: MxFixIncomeHist..tblHistoricPrices,tblUni
  INNER JOIN tblUni 
  EN: tblHistoricPrices.txtId1 = tblUni.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:   
  tblHistoricPrices.dteDate = @dteLastDate  
  Y: tblHistoricPrices.txtItem ESTE_CONTENIDO_EN: ('PAV', 'PRL')  
  Y: tblHistoricPrices.txtLiquidation ESTE_CONTENIDO_EN: ('24H', 'MP')  
  
  
  
  /*CONSIGUE PRECIOS ACUALES Y LOS INSERTA EN #tblCurValues*/
  /*SELECCIONA*/    
  
  tblUni.txtId1,  
  tblPrices.txtLiquidation,  
  tblPrices.dblValue  

  DE_TABLAS: tblPrices  ,tblUni
  INNER JOIN tblUni AS u (NOLOCK)  
  EN: tblPrices.txtId1 = tblUni.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:  
  tblPrices.dteDate = @txtDate  
  Y: tblPrices.txtItem ESTE_CONTENIDO_EN: ('PAV', 'PRL')  
  Y: tblPrices.txtLiquidation ESTE_CONTENIDO_EN: ('24H', 'MP') 
  
    /* + UNION*/
  /*SELECCIONA*/     
  tblUni.txtId1,  
  tblHistoricPrices.txtLiquidation,  
  tblHistoricPrices.dblValue  
 DE_TABLAS:MxFixIncomeHist..tblHistoricPrices,tblUni
  INNER JOIN tblUni 
   EN: tblHistoricPrices.txtId1 = tblUni.txtId1  
   Y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:   
  tblHistoricPrices.dteDate = @txtDate  
  Y: tblHistoricPrices.txtItem ESTE_CONTENIDO_EN: ('PAV', 'PRL')  
  Y: tblHistoricPrices.txtLiquidation ESTE_CONTENIDO_EN: ('24H', 'MP')  
  
  
  /*SE CARGAN RESULTADOS EN #tblResults*/
  /*SELECCIONA*/  
  #tblCurValues.txtId1, 
  CASO: 
   CUANDO: #tblLastValues.dblValue ES_NULO: ENTONCES: 100  
   CUANDO: #tblCurValues.dblValue = #tblLastValues.dblValue THEN 0  
	CUALQUIER_OTRO: CASE_ENNIDADO:  
		CASE #tblLastValues.dblValue  
		CUANDO: 0 ENTONCES: 100  
		CUALQUIER_OTRO: ((#tblCurValues.dblValue - #tblLastValues.dblValue) /#tblLastValues.dblValue) * 100  
    END         
		END COMO: dblValue 
 DE_TABLAS: #tblCurValues ,#tblLastValues
  LEFT OUTER JOIN #tblLastValues AS l  
  EN: #tblCurValues.txtId1 = #tblLastValues.txtId1  
   Y: #tblCurValues.txtLiquidation = #tblLastValues.txtLiquidation  
   
   
 -- INSERTA RESULTADOS EN tblResults  
 /*SELECCIONA*/    
  @txtDate, --CONSTANTE A PARTIR DE PARAMETRO 
  #tblResults.txtId1,  
  @txtAnalytic,  --CONSTANTE A PARTIR DE PARAMETRO 
  LTRIM(RTRIM(STR(dblValue, 10, 6))) + '%'  
 DE_TABLA: #tblResults   
  
  
