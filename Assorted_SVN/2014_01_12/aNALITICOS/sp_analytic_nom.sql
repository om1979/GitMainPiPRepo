
  /*INSERTA EN tblResults*/
  /*SELECCIEN:A POR CADA  TXTID1 DISTINTO*/   
   @txtDate, --VALOR  DE PARAMATRO 
   tblUNI.txtId1,  
   @txtAnalytic,  --VALOR DE PARAMATRO 
   RTRIM(LTRIM(STR(tblbonds.dblFaceValue, 11, 6))) --valor con 6 decimales
	DE_TABLAS: tblUNI,tblbonds,tblAmortizations
		INNER JOIN tblbonds  
		EN:   
		tblUNI.txtId1 = tblbonds.txtId1  
		Y: tblUNI.txtAnalytic = @txtAnalytic  --VALOR DE PARAMATRO 
			LEFT JOIN tblAmortizations 
			EN:   
			tblUNI.txtId1 = tblAmortizations.txtId1  
			DONDE:  
			tblAmortizations.txtId1 IS NULL  
  

  --+ UNION: 
  /*SELECCIEN:A POR CADA  TXTID1 DISTINTO*/    
   @txtDate,  --VALOR DE PARAMATRO 
   tblUNI.txtId1,  
   @txtAnalytic,  --VALOR DE PARAMATRO 
   RTRIM(LTRIM(STR(tblAmortizations.dblFactor, 11, 6)))  --valor con 6 decimales
		DE_TABLAS: tblUNI ,tblbonds ,tblAmortizations
		INNER JOIN tblbonds  
		EN:tblUNI.txtId1 = tblbonds.txtId1  
		Y: tblUNI.txtAnalytic = @txtAnalytic  --VALOR DE PARAMATRO 
			INNER JOIN tblAmortizations  
			 EN: tblUNI.txtId1 = tblAmortizations.txtId1  
		DONDE:  
		tblAmortizations.dteAmortization = --SUBQUERY QUE BUSCA EL MINIMO VALOR DE AMORTIZACION POR ID'1
		(  
		SELECT MIN(dteAmortization)  
		FROM tblAmortizations (NOLOCK)  
		DONDE:  
		txtId1 = tblAmortizations.txtId1
		)  
		
   --+ UNION:  
  /*SELECCIEN:A POR CADA  TXTID1 DISTINTO*/      
   @txtDate,  --VALOR DE PARAMATRO 
   tblUNI.txtId1,  
   @txtAnalytic,  --VALOR DE PARAMATRO 
   tblPrivateAdd.txtValue  
  DE_TABLAS: tblUNI,tblPrivateAdd
  INNER JOIN tblPrivateAdd AS 
  EN:   
   tblUNI.txtId1 = tblPrivateAdd.txtId1  
   Y: tblUNI.txtAnalytic = @txtAnalytic  --VALOR DE PARAMATRO 
  DONDE:  
   tblPrivateAdd.txtItem = 'NOM'  
   Y: tblPrivateAdd.dteDate = --SUBQUERY QUE BUSCA EL MINIMA FECHA DE tblPrivateAdd POR ID'1 Y ITEM
   (  
    SELECT   
     MIN(dteDate)  
    FROM tblPrivateAdd  
    DONDE:   
     txtId1 = tblPrivateAdd.txtId1  
     Y: txtItem = tblPrivateAdd.txtItem
     )  
