




CONSIGUE BONOS 
	--bonos bullet 
	--bonos amortizables
	--bonos amortizables POR SERIE
	--bonos amortizables con calendario de amor recortado 
	--PEquity  
--Y LOS INSERTA EN tblResults 
---
--bonos bullet 
TOMAR VALOR DISTINTO:
@txtDate,  
tblUni.txtId1,  
@txtAnalytic,  
tblbonds.dblFaceValue
DE:tblUni,tblbonds
DONDE:
tblUni.txtId1 = tblbonds.txtId1  
tblUni.txtId1 = tblAmortizations.txtId1
tblUni.txtAnalytic = @txtAnalytic   
tblAmortizations.txtId1 IS NULL  
--CONSIGUE  bonos amortizables  
@txtDate,tblUni.txtId1,@txtAnalytic,tblAmortizations.dblFactor
DONDE tblUni.txtId1 = tblbonds.txtId1  
, tblUni.txtAnalytic = @txtAnalytic  
, tblbonds.txtSubtype NO ESTE CONTENIDO EN ('CR2','FX2','TR2')  
, tblUni.txtId1 = tblAmortizations.txtId1  
y donde: tblAmortizations.dteAmortization = 
(a la dteAmortization MAXIMA DE tblAmortizations DONDE:  txtId1 = tblAmortizations.txtId1  AND dteAmortization <= @txtDate)

-- bonos amortizables POR SERIE  
TOMAR VALOR DISTINTO:
@txtDate,  
tblUni.txtId1,  
@txtAnalytic,  
tblbonds.dblFaceValue
DE TABLAS: tblbonds,tblUni
DONDE:
  tblUni.txtId1 = tblbonds.txtId1  
, tblUni.txtAnalytic = @txtAnalytic  
, tblbonds.txtSubtype ESTE DENTRO DE ('CR2','FX2','TR2')  
Y DONDE:
tblUni.txtId1 = tblAmortizations.txtId1 
   tblAmortizations.dteAmortization = (SELECCIONAR tblAmortizations.dteAmortization FECHA MAXIMA DONDE txtId1 = tblAmortizations.txtId1   AND tblAmortizations.dteAmortization <= @txtDate   )
   

-- bonos amortizables con calendario de amor recortado  
TOMAR VALOR DISTINTO:
  @txtDate,
  tblUni.txtId1,
  @txtAnalytic,  
  tblbonds.dblFaceValue
  DE TABLAS tblUni,tblbonds,tblAmortizations
  DONDE:
  tblUni.txtId1 = tblbonds.txtId1  
  ,tblUni.txtAnalytic = @txtAnalytic  
  ,tblUni.txtId1 = tblAmortizations.txtId1
  ,tblUni.txtId1 = tblAmortizations.txtId1
  ,tblAmortizations.txtId1 IS NULL   
  Y DONDE  tblAmortizations.dteAmortization = (SELECT MAX(dteAmortization)FROM tblAmortizations  WHERE  
								 txtId1 = tblAmortizations.txtId1  AND dteAmortization <= @txtDate)   
                                  
--PEquity
TOMAR VALOR DISTINTO:
  @txtDate,  
  tblUNI.txtId1,  
  @txtAnalytic,  
  tblPrivateAdd.txtValue  
  DE TABLAS  tblUNI,tblPrivateAdd   
  DONDE:
  tblUNI.txtId1 = tblPrivateAdd.txtId1    
  AND tblUNI.txtAnalytic = @txtAnalytic         
  Y DONDE: 
  tblPrivateAdd.txtItem = 'NOM'  
  , tblPrivateAdd.dteDate = (  
   TOMAR  MAXIMA(tblPrivateAdd.dteDate) DE tblPrivateAdd  
   DONDE    
    tblPrivateAdd.txtId1 = tblPrivateAdd.txtId1  
    AND tblPrivateAdd.txtItem = tblPrivateAdd.txtItem)            
       
       
