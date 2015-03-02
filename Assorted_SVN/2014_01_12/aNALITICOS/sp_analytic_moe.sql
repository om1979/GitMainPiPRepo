--SP_HELPTEXT sp_analytic_moe


 --------------------------------------------------  
 -- obtengo los nominales originales  
 --------------------------------------------------  
  
 -- SE generA buffer de datos minimos  
  /*SELECCIONA*/   
  tblUni.txtId1,  
  MIN(tblAmortizations.dteAmortization)  
  DE_TABLAs:tblUni,tblAmortizations
  INNER JOIN tblAmortizations
  EN:   
  tblUni.txtId1 = tblAmortizations.txtId1  
  DONDE:  
  tblUni.txtAnalytic = @txtAnalytic  
  GROUP BY   --AGRUPADO POR ID1'S
  tblUni.txtId1  
  
 -- Pequity  
/*SELECCIONA*/      
  tblUni.txtId1,  
  MIN(tblPrivateAdd.dteDate) --MINIVO VALOR PO 
 DE_TABLAs:tblUni,tblPrivateAdd
 INNER JOIN tblPrivateAdd  
 EN:  
  tblUni.txtId1 = tblPrivateAdd.txtId1  
  Y: txtItem = 'NOM'  
  GROUP BY   --AGRUPADO POR ID1'S
  tblUni.txtId1  

 -- generA buffer de valores nominales  INSERTA EN TABLA TEMP. @tblNom
  -- instrumentos sin amortizaciones  

 /*SELECCIONA DISTINTO*/   
  tblUni.txtId1,  
  tblBonds.dblFaceValue  
 DE_TABLAS:tblUni,tblBonds,tblAmortizations
  INNER JOIN tblBonds  
  EN: tblUni.txtId1 = tblBonds.txtId1    
  LEFT JOIN tblAmortizations 
  EN: tblUni.txtId1 = tblAmortizations.txtId1  
 DONDE:  
  tblUni.txtAnalytic = @txtAnalytic  
   Y: tblAmortizations.txtId1 ES_NULO: 
  
   
   /*+UNION*/
 -- instrumentos con amortizaciones
   
 /*SELECCIONA DISTINTO*/    
  @tblAmortizations.txtId1,  
  tblAmortizations.dblFactor  
 DE_TABLAS:@tblAmortizations,tblAmortizations
  @tblAmortizations AS buff  
  INNER JOIN tblBonds AS b (NOLOCK)  
  EN: @tblAmortizations.txtId1 = tblBonds.txtId1    
  INNER JOIN tblAmortizations AS a (NOLOCK)  
  EN:   
   tblAmortizations.txtId1 = @tblAmortizations.txtId1  
   Y: tblAmortizations.dteAmortization = @tblAmortizations.dteDate  
  
  
  /*+UNION*/
 -- Pequity  
 /*SELECCIONA DISTINTO*/  
  @tblAmortizations.txtId1,  
  CAST (tblPrivateAdd.txtValue AS FLOAT) AS dblNom  --lo convierte a flotante
 DE_TABLAS:   @tblAmortizations,tblPrivateAdd
  @tblAmortizations    
  INNER JOIN tblPrivateAdd A
  DONDE:    
   @tblAmortizations.txtId1 = tblPrivateAdd.txtId1  
   Y: @tblAmortizations.dteDate = tblPrivateAdd.dteDate  
   Y: tblPrivateAdd.txtItem = 'NOM'  
 
 --------------------------------------------------  
 -- obtengo los titulos emitidos  
 --------------------------------------------------  
  
 -- genero buffer de datos minimos  
 /*INSERTAR EN TABLA TEMP @tblOutstanding */

/*SELECCIONA*/
  tblUni.txtId1,  
  MIN(tblOutStanding.dteDate)--SELECCIONA FECHA MINIMA POR CADA ID1  
 DE_TABLAS:tblUni,tblOutStanding
  tblUni  
  INNER JOIN tblOutStanding 
  EN:    
   tblUni.txtId1 = tblOutStanding.txtId1  
 WHERE  
  tblUni.txtAnalytic = @txtAnalytic  
  Y: dblOutstanding >  0   
  Y: dteDate <= @txtDate  
  GROUP BY   --AGRUPADO POR ID1'S
  tblUni.txtId1  
  
  
  
 /*INSERTA EN @tblTit*/
 /*SELECCIONA*/
 SELECT   
  @tblOutstanding.txtId1,  
  tblOutStanding.dblOutstanding  
 DE_TABLAS:@tblOutstanding,tblOutStanding 
 INNER JOIN tblOutStanding   
  EN:   
   @tblOutstanding.txtId1 = tblOutStanding.txtId1  
   Y: @tblOutstanding.dteDate = tblOutStanding.dteDate  
 
  
 --------------------------------------------------  
 -- reporto los montos emitidos  
 --------------------------------------------------  

 --INSERTA EN TBLRESULTS
  /*SELECCIONA*/   
  @txtDate,--VARIABLE DE PARAMETRO  
  @tblNom.txtId1,  
  @txtAnalytic,  --VARIABLE DE PARAMETRO  
  LTRIM(STR(@tblNom.dblNom * @tblTit.dblOutstanding, 19, 6))  
 DE_TABLAS:   @tblNom,@tblTit
  INNER JOIN @tblTit AS t  
  EN: @tblNom.txtId1 = @tblTit.txtId1 
  
  
   