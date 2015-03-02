

----SELECT * FROM  MxProcesses..tblProcessCatalog
----WHERE txtProcess LIKE '%mercado%'


--SELECT * FROM  MxProcesses..tblProcessParameters
----WHERE txtParameter = 'filename'
--WHERE txtProcess IN (
--'INV_H_PRV_CIERRE')



--SELECT * FROM  tmp_tblIndevalReferenceCierre
--WHERE txtIsin = 'MX95PE1X00F3'



--SELECT * FROM  inv.itblMarketPositionsPrivates
--WHERE dteDate = '20140923'
--AND txtTv = '95'
--AND txtEmisora = 'PEMEX'
--AND txtSerie = '12'
--AND intIdBroker = 11

--   helptextXmodulo 'dbo.sp_inputs_brokers_privados',25  
  
    
  
ALTER  PROCEDURE dbo.sp_inputs_brokers_privados;25  
 @txtDate AS CHAR(8)  
AS  
/*   
 Autor:   CSOLORIO   
 Creacion:  20111221  
 Descripcion: Carga la informacion de hechos de Indeval  
  
 Modificado por: Csolorio  
 Modificacion: 20130405  
 Descripcion: Agrego TV JE  
  
 Modificado por: Mike Ramirez  
 Modificacion: 20131127  
 Descripcion: Agrego TV CD  
 
 
  Modificado por: Omar Aceves Gutierrez 
 Modificacion: 2014-09-24 13:02:56.290  
 Descripcion: se comenta distinct de insert a #tblData
  
*/     
BEGIN    
  
 SET NOCOUNT ON  
  
  
 CREATE TABLE #tblData (  
  txtId1 CHAR(11),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10),  
  intPlazo INT,  
  dblRate FLOAT,  
  dblAmount  FLOAT,  
  dteLiquidationDate DATETIME,  
  txtLiquidation CHAR(3),  
  dteHour DATETIME)  
  
 INSERT #tblData(  
  txtId1,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  dblRate,  
  dblAmount,  
  dteLiquidationDate,  
  txtLiquidation,  
  dteHour)  
  
 SELECT --DISTINCT  
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  DATEDIFF(d,CONVERT(DATETIME,r.txtLiquidation),b.dteMaturity),  
  CONVERT(FLOAT,r.txtPrice) AS dblRate,  
  CONVERT(FLOAT,r.txtAmount) AS dblAmount,  
  CONVERT(DATETIME,r.txtLiquidation) AS dteLiquidationDate,  
  CASE  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = @txtDate THEN 'MD'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,1,'MX') THEN '24'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,2,'MX') THEN '48'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,3,'MX') THEN '72'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN '96'  
  END AS txtLiquidation,  
  CONVERT(DATETIME,txtDTM) AS dteDateTime   
 FROM tmp_tblIndevalReferenceCierre r  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  r.txtIsin = i.txtId2  
  AND i.txtTv NOT LIKE '%SP'  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
 WHERE  
  i.txtTv IN (  
   '2','2U','2P','90','91','92',   
   '93','94','95','97','98','D2',   
   'D7','D8','F','J','JI','Q','JE','CD')  
  AND r.txtMatch = 'CON_MATCH'  
  AND (  
   r.txtOrigin = 'CUENTA_PROPIA'  
   OR r.txtDestiny = 'CUENTA_PROPIA')  
  AND CONVERT(DATETIME,r.txtDate) = @txtDate  
  AND CONVERT(DATETIME,r.txtLiquidation) <= dbo.fun_NextTradingDate(@txtDate,4,'MX')  
  
 DELETE  
 FROM inv.itblMarketPositionsPrivates  
 WHERE   
  dteDate = @txtDate  
  
 INSERT inv.itblMarketPositionsPrivates(  
  dteDate,  
  intIdBroker,  
  intLine,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtOperation,  
  dblRate,  
  dblAmount,  
  dteBeginHour,  
  dteEndHour,  
  txtLiquidation)  
  
 SELECT DISTINCT  
  @txtDate,  
  11,  
  -999,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  'HECHO',  
  dblRate,      
  SUM(dblAmount),  
  dteHour,  
  dteHour,  
  txtLiquidation  
 FROM #tblData  
 GROUP BY  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  dblRate,      
  dteHour,  
  txtLiquidation  
  
 UNION  
  
 SELECT   
  dteDate,  
  intIdBroker,  
  intLine,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtOperation,  
  dblRate,  
  dblAmount,  
  dteBeginHour,  
  dteEndHour,  
  txtLiquidation  
 FROM dbo.itblMarketPositionsPrivates (NOLOCK)  
 WHERE   
  dteDate = @txtDate  
  
 SET NOCOUNT OFF  
  
END  