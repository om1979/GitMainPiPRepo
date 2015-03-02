
  --sp_analytic_nem

 /*INSERTA EN  tblResults*/
/*SELECCIONA*/
 SELECT   
  @txtDate,--valor de parametro fecha  
  tblIds.txtId1,  
  @txtAnalytic, --valor de parametro analitico
  UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(tblIssuersCatalog.txtName, 1, 150),'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U')) AS txtName  --REMPLAZA VOCALES CON ACENTO
 DE_TABLAS: tblUni,tblIds,tblIssuersCatalog  
  INNER JOIN tblIds  
  EN: tblUni.txtId1 = tblIds.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic   
  INNER JOIN tblIssuersCatalog   
  EN: tblIds.txtEmisora = tblIssuersCatalog.txtIssuer  
  DONDE:  
  tblIssuersCatalog.txtName <> ''  
  Y_DONDE: tblIssuersCatalog.txtName NO_SEA_NULO:  
  



