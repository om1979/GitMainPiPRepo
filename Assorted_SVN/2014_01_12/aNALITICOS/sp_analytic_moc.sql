SP_HELPTEXT sp_analytic_moc

 
 /*inserta en @tblOutstanding*/
 /*SELECCIONA*/   
  tblUni.txtId1,  
  MAX(dteDate) -- FECHA MAXIMA  
 DE_TABLAS: tblUni,tblOutstanding
  INNER JOIN tblOutstanding  
  EN:tblUni.txtId1 = tblOutstanding.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:    
  tblOutstanding.dteDate <= @txtDate  
  Y: tblOutstanding.dblOutstanding >  0  
 GROUP BY tblUni.txtId1  
  

 -- OBTIENE la fecha mas reciente de amortizacion  
 -- para todos los instrumentos del universo   
 /*ISNERTA EN @tblAmortizations*/
 /*SELECCIONA*/
  tblUni.txtId1,  
  MAX(dteAmortization)--valor maximo para cada id1
 DE_TABLAS:tblUni,tblAmortizations
  INNER JOIN tblAmortizations 
  EN: tblUni.txtId1 = tblAmortizations.txtId1  
   Y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:  
  tblAmortizations.dteAmortization <= @txtDate   
 GROUP BY  --AGRUPADO POR 
  tblUni.txtId1  
   /*+ UNION*/ 
   /*SELECCIONA*/
  tblUni.txtId1,  
  MAX(dteDate)  --valor maximo para cada id1
 DE_TABLAS: tblUni,tblPrivateAdd   
  EN:   
  tblUni.txtId1 = tblPrivateAdd.txtId1  
  AND tblUni.txtAnalytic = @txtAnalytic  
 DONDE:   
  tblPrivateAdd.dteDate <= @txtDate   
  AND tblPrivateAdd.txtItem = 'NOM'  
 GROUP BY  --AGRUPADO POR 
  tblUni.txtId1  
  
  
  /*
  OBTIENE BONOS BULLET, AMORTIZABLES Y CALENDARIO INCOMPLETO Y LOS INSERTA EN tblResults
  */
  /*INSERTA BONOS BULLET*/
  /*SELECCIONA DISTINTO */
  @txtDate,-- FECHA CONSTANTE VARIABLE        
  tblBonds.txtId1,  
  @txtAnalytic,  -- VALOR ANALITICO VARIABLE
  LTRIM(STR(tblBonds.dblFaceValue * tblOutStanding.dblOutstanding, 19, 6))  --MULTIPLICA Y REDONDEA A 6 DECIMALES 
  DE_TABLAS:@tblOutstanding ,  tblBonds,tblOutStanding,@tblAmortizations,tblAmortizations
  INNER JOIN tblBonds
  EN: @tblOutstanding.txtId1 = b.txtId1   
  INNER JOIN tblOutStanding 
  EN:   
   @tblOutstanding.txtId1 = tblOutStanding.txtId1  
   Y: tblOutStanding.dteDate = buff.dteDate  
  LEFT OUTER JOIN @tblAmortizations  
  EN: @tblOutstanding.txtId1 = @tblAmortizations.txtId1  
  LEFT OUTER JOIN  tblAmortizations  
  EN:   
  tblBonds.txtId1 = tblAmortizations.txtId1  
   Y: tblAmortizations.dteAmortization = @tblAmortizations.dteDate  
 DONDE:   
  tblAmortizations.txtId1 SEA_NULO:
  
 
 --INSERTA VALORES  bonos :: amortizables  
 /*SELECCIONA DISTINTO */
  @txtDate,    -- FECHA CONSTANTE VARIABLE        
  tblBonds.txtId1,  
  @txtAnalytic, -- VALOR ANALITICO VARIABLE
  LTRIM(STR(tblAmortizations.dblFactor * tblOutStanding.dblOutstanding, 19, 6))  --MULTIPLICA Y REDONDEA A 6 DECIMALES 
 DE_TABLAS:   @tblOutstanding,tblBonds,tblOutStanding,@tblAmortizations,tblAmortizations,@tblOutstanding
  INNER JOIN tblBonds   
  EN: @tblOutstanding.txtId1 = tblBonds.txtId1   
  INNER JOIN tblOutStanding  
  EN:   
   @tblOutstanding.txtId1 = tblOutStanding.txtId1  
    Y: tblOutStanding.dteDate = @tblOutstanding.dteDate  
  INNER JOIN @tblAmortizations  
  EN: @tblOutstanding.txtId1 = @tblAmortizations.txtId1  
  INNER JOIN tblAmortizations  
  EN:   
   tblBonds.txtId1 = tblAmortizations.txtId1  
    Y: tblAmortizations.dteAmortization = @tblAmortizations.dteDate  
   
  
 -- INSERTA VALORES equity 
/*SELECCIONA DISTINTO */
  @txtDate,  -- FECHA CONSTANTE VARIABLE  
  @tblOutstanding.txtId1,  
  @txtAnalytic,  -- VALOR ANALITICO VARIABLE
  LTRIM(STR(vw_prices_notes.dblValue * tblOutStanding.dblOutstanding, 19, 6))  --MULTIPLICA Y REDONDEA A 6 DECIMALES 
  DE_TABLAS: @tblOutstanding,vw_prices_notes,tblOutStanding,tblIds,tblTvCatalog
  INNER JOIN vw_prices_notes 
  EN:   
   @tblOutstanding.txtId1 = p.txtId1   
  INNER JOIN tblOutStanding 
  EN:   
   @tblOutstanding.txtId1 = tblOutStanding.txtId1  
   AND tblOutStanding.dteDate = @tblOutstanding.dteDate  
  INNER JOIN tblIds  
  EN:   
   @tblOutstanding.txtId1 = tblIds.txtId1  
  INNER JOIN tblTvCatalog  
  EN:  
   tblIds.txtTv = tblTvCatalog.txtTv  
 DONDE:   
  vw_prices_notes.dteDate = @txtDate  
     Y: vw_prices_notes.txtLiquidation IN ('MP','MD')  
     Y: vw_prices_notes.txtItem = 'PAV'  
  Y: tblTvCatalog.intMarket = 1  
  Y: tblIds.txtTv != '1R'  
  
  
 --INSERTA VALORES Private Equity  
/*SELECCIONA DISTINTO */
        @txtDate,  -- FECHA CONSTANTE VARIABLE  
        @tblOutstanding.txtId1,  
        @txtAnalytic,  -- VALOR ANALITICO VARIABLE
        LTRIM(STR(tblPrivateAdd.txtValue * tblOutStanding.dblOutstanding, 19, 6))  --MULTIPLICA Y REDONDEA A 6 DECIMALES 
		 DE_TABLAS: @tblOutstanding,@tblAmortizations,tblPrivateAdd,tblOutStanding,tblIds
		  INNER JOIN @tblAmortizations   
		  EN:  
		   @tblOutstanding.txtId1 = @tblAmortizations.txtId1  
		  INNER JOIN tblPrivateAdd    
		  EN:  
		   @tblAmortizations.txtID1 = tblPrivateAdd.txtId1  
		   Y: @tblAmortizations.dteDate = tblPrivateAdd.dteDate  
		  INNER JOIN tblOutStanding  
		  EN:   
		   @tblOutstanding.txtId1 = tblOutStanding.txtId1  
		   Y: tblOutStanding.dteDate = @tblOutstanding.dteDate  
		  INNER JOIN tblIds  
		  EN:   
		   @tblOutstanding.txtId1 = tblIds.txtId1  
		 DONDE:    
			 tblPrivateAdd.txtItem = 'NOM'  
		  Y: tblIds.txtTv = '1R'  
  
  
  