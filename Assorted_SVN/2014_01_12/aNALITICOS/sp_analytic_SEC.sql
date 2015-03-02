







/*ELIMINA DE tblResults
  DONDE EL TCTITEM = @txtAnalytic
*/

   /*INSERTA EN tblResults*/
   
 SELECT DISTINCT  
   @txtDate,  -- VARIABLE DE PARAMETRO FECHA 
   tblUni.txtId1,  
   @txtAnalytic,  --VARIABLE DE PARAMETRO ANALITICO
   UPPER(tblBMVSectorCatalog.txtDescription)  --A MAYUSCULAS
 DE_TABLAS: tblUni,tblIssuersCatalog,tblBMVSectorCatalog
   INNER JOIN tblIssuersCatalog  
   ON  
    tblIssuersCatalog.txtIssuer = uni.txtEmisora  
   INNER JOIN tblBMVSectorCatalog
   EN:  
    tblBMVSectorCatalog.intSector = tblIssuersCatalog.intSector  
 DONDE: txtAnalytic = @txtAnalytic  --DONDE EL VALOR SEA = AL VALOR DE PARAMETRO
 