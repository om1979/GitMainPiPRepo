




SP_HELPTEXT sp_analytic_dpc

  /*Inserta Precios Historicos en tabla Temporal  #tblLastValues*/
  /*selecciona*/
  tblUni.txtId1,  
  tblPrices.txtLiquidation,  
  tblPrices.dblValue  
  DE_TABLAS: tblPrices,tblUni
  INNER  JOIN tblUni
  EN: tblPrices.txtId1 = tblUni.txtId1 Y: tblUni.txtAnalytic = 'DPC'  
  DONDE: tblPrices.dteDate = @dteLastDate  
  Y: tblPrices.txtItem ESTE_EN: ('PAV', 'PRL')  
  Y: tblPrices.txtLiquidation ESTE_EN: ('24H', 'MP')  



/*UNION*/
/*SELECCIONA*/
  tblUni.txtId1,  
  tblHistoricPrices.txtLiquidation,  
  tblHistoricPrices.dblValue  
  DE_TABLAS:MxFixIncomeHist..tblHistoricPrices,tblUni  
  INNER JOIN tblUni
  EN: tblHistoricPrices.txtId1 = tblUni.txtId1  Y: tblUni.txtAnalytic = 'DPC'
  dONDE: 
  tblHistoricPrices.dteDate = @dteLastDate  
  Y: tblHistoricPrices.txtItem ESTE_EN: ('PAV', 'PRL')  
  Y: tblHistoricPrices.txtLiquidation ESTE_EN: ('24H', 'MP')   
  
  /*Inserta precios actuales  en tabla Temporal  #tblCurValues*/
  /*Selecciona*/
  
  tblUni.txtId1,  
  tblPrices.txtLiquidation,  
  tblPrices.dblValue  
 INTO #tblCurValues  
 DE_TABLAS:tblPrices,tblUni     
  INNER JOIN tblUni 
  EN: tblPrices.txtId1 = u.txtId1  
  y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:  
  tblPrices.dteDate = @txtDate  
  Y: tblPrices.txtItem ESTE_EN: ('PAV', 'PRL')  
  Y: tblPrices.txtLiquidation ESTE_EN: ('24H', 'MP')  
  
  /*UNION*/
/*SELECCIONA*/
   
  tblUni.txtId1,  
  tblHistoricPrices.txtLiquidation,  
  tblHistoricPrices.dblValue  
  DE_TABLAS:MxFixIncomeHist..tblHistoricPrices
  INNER JOIN tblUni 
  EN: tblHistoricPrices.txtId1 = tblUni.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
 WHERE  
  tblHistoricPrices.dteDate = @txtDate  
  Y: tblHistoricPrices.txtItem ESTE_EN: ('PAV', 'PRL')  
  Y: tblHistoricPrices.txtLiquidation ESTE_EN: ('24H', 'MP')  
  
  
  /*PROCESA RESULTADOS Y SE INSERTAN EN #tblResults */
  /*SELECCIONA*/
   c.txtId1,
   CASO:
		SI: #tblLastValues.dblValue ES_NULO: ENTONCES:  100  
		SI: #tblCurValues.dblValue = #tblLastValues.dblValue ENTONCES:  0  
		CULAQUIER_OTRO:CASO_ENIDADO:
		 CASE #tblLastValues.dblValue  
			SI: 0 ENTONCES: 100  
			CULAQUIER_OTRO: ((#tblCurValues.dblValue - #tblLastValues.dblValue) /#tblLastValues.dblValue) * 100  
			 END VALOR_COMO: dblValue  
			 DE_TABLAS: #tblCurValues,#tblLastValues
			  LEFT OUTER JOIN #tblLastValues
			  EN: #tblCurValues.txtId1 = #tblLastValues.txtId1  
			  Y:  #tblCurValues.txtLiquidation = #tblLastValues.txtLiquidation  
			 
			 
   --INSERTO EN tblResults 
   /*SELECCIONA*/   
	  @txtDate,--FECHA DE VARIABLE  
	  txtId1,  
	  @txtAnalytic,  --'DPC'
	  LTRIM(RTRIM(STR(dblValue, 10, 6))) + '%'  
	  DE_TABLA:  #tblResults   
	   
   
