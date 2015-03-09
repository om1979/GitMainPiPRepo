  DECLARE @txtDate AS CHAR(8)  = '20150203' 
--CREATE PROCEDURE dbo.sp_inputs_brokers_privados;24  
-- @txtDate AS CHAR(8)  
--AS  
--/*   
-- Autor:   CSOLORIO   
-- Creacion:  20111221  
-- Descripcion: Carga la informacion de hechos de Indeval  
  
-- Modificado por: Csolorio  
-- Modificacion: 20130405  
-- Descripcion: Agrego TV JE  
   
-- Modificado por: Mike Ramirez  
-- Modificacion: 20131127  
-- Descripcion: Agrego TV CD  
--*/     
--BEGIN    
  
-- SET NOCOUNT ON  
  
  --DROP TABLE #tblData
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
  
-- CREATE TABLE #tblAmortizationsDates (  
--  txtId1 CHAR(11),  
--  dteDate DATETIME  
--   PRIMARY KEY (txtId1))  
--  
-- CREATE TABLE #tblFaceValue (  
--  txtId1 CHAR(11),  
--  txtCurrency CHAR(5),  
--  dblFaceValue FLOAT  
--   PRIMARY KEY (txtId1))  
--  
-- -- Obtengo las ultimas amortizaciones  
--  
-- INSERT #tblAmortizationsDates(  
--  txtId1,  
--  dteDate)  
--  
-- SELECT   
--  d.txtId1,  
--  MAX(a.dteAmortization)   
-- FROM #tblData d  
-- INNER JOIN tblAmortizations a (NOLOCK)  
-- ON  
--  d.txtId1 = a.txtid1  
--  AND a.dteAmortization <= '20111214'  
-- GROUP BY  
--  d.txtId1  
--  
-- -- Obtengo el valor nominal  
--  
-- INSERT #tblFaceValue(  
--  txtId1,  
--  txtCurrency,  
--  dblFaceValue)  
--  
-- SELECT DISTINCT  
--  d.txtId1,  
--  b.txtCurrency,  
--  CASE  
--   WHEN a.dblFactor IS NULL THEN b.dblFaceValue  
--   ELSE a.dblFactor  
--  END as dblFaceValue  
-- FROM #tblData d  
-- INNER JOIN tblBonds b (NOLOCK)  
-- ON  
--  d.txtId1 = b.txtId1  
-- LEFT OUTER JOIN #tblAmortizationsDates ad (NOLOCK)  
-- ON  
--  d.txtId1 = ad.txtId1  
-- LEFT OUTER JOIN tblAmortizations a (NOLOCK)  
-- ON  
--  d.txtId1 = a.txtId1  
--  AND ad.dteDate = a.dteAmortization  
--  
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

 SELECT     
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  DATEDIFF(d,CONVERT(DATETIME,r.txtLiquidation),b.dteMaturity),  
  CONVERT(FLOAT,r.txtPrice) AS dblRate,  
  CONVERT(FLOAT,r.txtAmount) AS dblAmount,  
  CONVERT(DATETIME,r.txtLiquidation) AS dteLiquidationDate,  
-- r.txtOrigin,  r.txtDestiny,
  CASE  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = @txtDate THEN 'MD'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,1,'MX') THEN '24'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,2,'MX') THEN '48'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,3,'MX') THEN '72'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN '96'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,5,'MX') THEN '120'  
     
  END AS txtLiquidation,  
  CONVERT(DATETIME,txtDTM) AS dteDateTime   
 FROM tmp_tblIndevalReference r  
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
   AND CONVERT(DATETIME,r.txtDate) = @txtDate  
  AND CONVERT(DATETIME,r.txtLiquidation) <= dbo.fun_NextTradingDate(@txtDate,4,'MX')  
--AND i.txtEmisora = 'Pemex'
  
  AND (  
   r.txtOrigin = 'CUENTA_PROPIA'  
   OR r.txtDestiny = 'CUENTA_PROPIA')  

 
  --SELECT * FROM  #tblData
  
 --DELETE  
 --FROM itblMarketPositionsPrivates  
 --WHERE   
 -- dteDate = @txtDate  
 -- AND intIdBroker = 11   
  
 --INSERT itblMarketPositionsPrivates(  
 -- dteDate,  
 -- intIdBroker,  
 -- intLine,  
 -- intPlazo,  
 -- txtTv,  
 -- txtEmisora,  
 -- txtSerie,  
 -- txtOperation,  
 -- dblRate,  
 -- dblAmount,  
 -- dteBeginHour,  
 -- dteEndHour,  
-- -- txtLiquidation)  
  
 SELECT   DISTINCT 
 -- @txtDate,  
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
  
---- SET NOCOUNT OFF  
  
----END  


----SELECT * FROM  tmp_tblIndevalReference  
----WHERE txtEmisora = 'Pemex'
----AND txtSerie = '13-2'
----AND txtMatch = 'CON_MATCH'