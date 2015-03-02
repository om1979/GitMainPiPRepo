  
  
--CREATE PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;2  
 @txtDate CHAR(8)  
/*   
 Autor:   CSOLORIO    
 Creacion:  20131120  
 Descripcion: Actualiza analitico de moneda  
  
 Modificado por:   
 Modificacion:   
 Descripcion:   
*/   
  
--AS  
--BEGIN  
  
 CREATE TABLE #tblCurrency(  
  txtId1 CHAR(11),   
  txtCurrency CHAR(7),  
  txtFullCurrency VARCHAR(50)  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblCurrencyDates(  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
     
 INSERT #tblCurrency(  
  txtId1,  
  txtCurrency)  
    
 SELECT DISTINCT   
  b.txtId1,  
  b.txtCurrency  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  p.txtId1 = b.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  b.txtId1 = i.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PRS'  
  AND p.txtLiquidation = '24H'  
  AND (  
   i.txtTv NOT LIKE '%SP'  
   AND i.txtTv != 'SP')  
     
 UNION  
  
 SELECT DISTINCT   
  e.txtId1,  
  e.txtCurrency  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblEquity e (NOLOCK)  
 ON  
  p.txtId1 = e.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  e.txtId1 = i.txtId1  
 INNER JOIN tblTvCatalog c (NOLOCK)  
 ON  
  i.txtTv = c.txtTv  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation = 'MP'  
  AND intCategory != 8  
  AND i.txtTv NOT LIKE '%SP'  
  
 UNION  
  
 SELECT DISTINCT   
  r.txtId1,  
  r.txtCurrency   
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblPrivate r (NOLOCK)  
 ON  
  p.txtId1 = r.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation = '24H'  
    
 UNION  
  
 SELECT DISTINCT   
  d.txtId1,  
  d.txtCurrency   
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblDerivatives d (NOLOCK)  
 ON  
  p.txtId1 = d.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation IN ('24H','MP')  
  
 -- Obtengo los ultimos registros para aquello que esta en tblidsadd  
  
 INSERT #tblCurrencyDates(  
  txtId1,  
  dteDate)  
    
 SELECT   
  a.txtId1,  
  MAX(a.dteDate)  
 FROM tblIdsAdd a (NOLOCK)  
 INNER JOIN vw_prices_notes p (NOLOCK)  
 ON  
  a.txtId1 = p.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  a.txtId1 = i.txtId1  
 LEFT OUTER JOIN #tblCurrency c  
 ON  
  a.txtId1 = c.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND c.txtId1 IS NULL  
  AND a.txtItem = 'CUR'  
  AND i.txtTv NOT LIKE '%SP'  
 GROUP BY  
  a.txtId1  
    
 INSERT #tblCurrency(  
  txtId1,  
  txtCurrency)  1
  
 SELECT   
  a.txtId1,  
  a.txtValue  
 FROM #tblCurrencyDates d  
 INNER JOIN tblIdsAdd a (NOLOCK)  
 ON  
  d.txtId1 = a.txtId1  
  AND d.dteDate = a.dteDate  
 WHERE  
  a.txtItem = 'CUR'  
    
 UPDATE c  
 SET   
  c.txtFullCurrency = '[' + RTRIM(i.txtIrc) + '] ' + RTRIM(i.txtIrcName)  
 FROM #tblCurrency c  
 INNER JOIN tblIrcCatalog i (NOLOCK)  
 ON  
  c.txtCurrency = i.txtIrc  
  
 -- Validamos tblDailyAnalytics  
  
 -- Inserto los que no estan  
  
 INSERT tblDailyAnalytics(  
  txtId1,  
  txtLiquidation,  
  txtItem,  
  txtValue)  
    
 SELECT   
  c.txtId1,  
  'MD',  
  'CUR',  
  c.txtFullCurrency  
 FROM #tblCurrency c  
 LEFT OUTER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'CUR'  
  AND a.txtLiquidation = 'MD'  
 WHERE  
  a.txtId1 IS NULL  
    
 -- Actualizo los diferentes  
  
 UPDATE a  
 SET   
  a.txtValue = c.txtFullCurrency  
 FROM #tblCurrency c  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'CUR'  
  AND a.txtLiquidation = 'MD'  
  AND c.txtFullCurrency != a.txtValue   
    
 -- Valido tmp_tblActualAnalytics_1  
  
 UPDATE t  
 SET  
  t.txtCur = a.txtValue  
 FROM tmp_tblActualAnalytics_1 t (NOLOCK)  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  t.txtId1 = a.txtId1  
  AND t.txtLiquidation = a.txtLiquidation  
  AND t.txtCur != a.txtValue  
 INNER JOIN #tblCurrency c  
 ON  
  t.txtId1 = c.txtId1  
 WHERE  
  a.txtItem = 'CUR'  
  AND a.txtLiquidation = 'MD'  
  
END  
  
CREATE PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;3  
 @txtDate CHAR(8)  
/*   
 Autor:   CSOLORIO BY PONATE  
 Creacion:  20131120  
 Descripcion: Actualiza analitico de Isin  
  
 Modificado por:   
 Modificacion:   
 Descripcion:   
*/   
AS  
BEGIN  
  
 CREATE TABLE #tblISIN(  
  txtid1 VARCHAR(11),  
  txtid2 varchar(12)  
   primary key(txtid1)  
 )  
  
 CREATE TABLE #tblMaxISIN(  
  txtid1 VARCHAR(11),  
  dtedate DATETIME  
   primary key(txtid1)  
 )  
  
 INSERT  
  #tblISIN  
 SELECT distinct  
  ids.txtID1, ids.txtid2  
 FROM  
  vw_prices_notes pri  
  INNER JOIN tblids ids (NOLOCK)  
   ON pri.txtid1 = ids.txtid1  
 WHERE  
  pri.dteDate = @txtDate  
  AND ids.txtId2 != '0'  
  
 INSERT  
  #tblMaxISIN  
 SELECT  
  ids.txtID1, Max(ids.dteDate)  
 FROM  
  vw_prices_notes pri  
  INNER JOIN tblidsadd ids (NOLOCK)  
   ON pri.txtid1 = ids.txtid1  
 WHERE  
  pri.dteDate = @txtDate  
  AND ids.txtValue != '0'  
 GROUP BY ids.txtId1  
  
 ---Actualizo idsadd  
 UPDATE adds  
  SET adds.txtValue = isin.txtID2  
 FROM  
  #tblISIN isin  
  INNER JOIN #tblMaxISIN maxisin  
   ON isin.txtID1 = maxisin.txtid1  
  INNER JOIN tblidsadd adds (NOLOCK)  
   ON isin.txtid1 = adds.txtid1  
   AND maxisin.dtedate = adds.dteDate  
   AND adds.txtitem = 'ID2'  
 WHERE  
  isin.txtid2 != adds.txtValue  
  
  
 ---Para tblDailyAnalytics  
 UPDATE da  
  SET da.txtValue = isin.txtID2  
 FROM  
  #tblISIN isin  
  INNER JOIN tblDailyAnalytics da (NOLOCK)  
   ON isin.txtID1 = da.txtId1  
  AND da.txtItem = 'ID2'  
  AND da.txtLiquidation = 'MD'  
 WHERE  
  isin.txtid2 != da.txtValue  
  
 --Para insertar los que no existan en tblDailyAnalytics  
 INSERT tblDailyAnalytics  
 SELECT  
  isin.txtid1, 'MD', 'ID2', isin.txtid2  
 FROM  
  #tblISIN isin  
  LEFT JOIN tblDailyAnalytics da (NOLOCK)  
   ON isin.txtID1 = da.txtID1  
  AND da.txtItem = 'ID2'  
  AND da.txtLiquidation = 'MD'  
 WHERE  
  da.txtId1 is null  
  AND isin.txtid2 != '0'  
  
 ---Para tmp_tblActualAnalytics_1  
  UPDATE t  
  SET  
   t.txtID2 = a.txtValue  
  FROM tmp_tblActualAnalytics_1 t (NOLOCK)  
  INNER JOIN tblDailyAnalytics a (NOLOCK)  
  ON  
   t.txtId1 = a.txtId1  
   AND t.txtLiquidation = a.txtLiquidation  
   AND t.txtCur != a.txtValue  
  INNER JOIN #tblISIN isin  
  ON  
   t.txtId1 = isin.txtId1  
  WHERE  
   a.txtItem = 'ID2'  
   AND a.txtLiquidation = 'MD'  
   AND isin.txtid2 != t.txtID2  
  
END  
  
CREATE PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;4  
 @txtDate CHAR(8)  
/*   
 Autor:   CSOLORIO  
 Creacion:  20131120  
 Descripcion: Actualiza analitico de fecha de emision  
  
 Modificado por:   
 Modificacion:   
 Descripcion:   
*/   
AS  
BEGIN  
   
 CREATE TABLE #tblISD(  
  txtId1 CHAR(11),   
  dteIssued DATETIME  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblISDDates(  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
     
 INSERT #tblISD(  
  txtId1,  
  dteIssued)  
    
 SELECT DISTINCT   
  b.txtId1,  
  b.dteIssued  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  p.txtId1 = b.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  b.txtId1 = i.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PRS'  
  AND p.txtLiquidation = '24H'  
  AND (  
   i.txtTv NOT LIKE '%SP'  
   AND i.txtTv != 'SP')  
     
 UNION  
  
 SELECT DISTINCT   
  e.txtId1,  
  e.dteIssued  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblEquity e (NOLOCK)  
 ON  
  p.txtId1 = e.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  e.txtId1 = i.txtId1  
 INNER JOIN tblTvCatalog c (NOLOCK)  
 ON  
  i.txtTv = c.txtTv  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation = 'MP'  
  AND intCategory != 8  
  AND i.txtTv NOT LIKE '%SP'  
  
 UNION  
  
 SELECT DISTINCT   
  r.txtId1,  
  r.dteIssued   
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblPrivate r (NOLOCK)  
 ON  
  p.txtId1 = r.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation = '24H'  
    
 UNION  
  
 SELECT DISTINCT   
  d.txtId1,  
  d.dteIssued  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblDerivatives d (NOLOCK)  
 ON  
  p.txtId1 = d.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation IN ('24H','MP')  
  
 -- Obtengo los ultimos registros para aquello que esta en tblidsadd  
  
 INSERT #tblISDDates(  
  txtId1,  
  dteDate)  
    
 SELECT   
  a.txtId1,  
  MAX(a.dteDate)  
 FROM tblIdsAdd a (NOLOCK)  
 INNER JOIN vw_prices_notes p (NOLOCK)  
 ON  
  a.txtId1 = p.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  a.txtId1 = i.txtId1  
 LEFT OUTER JOIN #tblISD c  
 ON  
  a.txtId1 = c.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND c.txtId1 IS NULL  
  AND a.txtItem = 'ISD'  
  AND i.txtTv NOT LIKE '%SP'  
 GROUP BY  
  a.txtId1  
    
 INSERT #tblISD(  
  txtId1,  
  dteIssued)  
  
 SELECT   
  a.txtId1,  
  a.txtValue  
 FROM #tblISDDates d  
 INNER JOIN tblIdsAdd a (NOLOCK)  
 ON  
  d.txtId1 = a.txtId1  
  AND d.dteDate = a.dteDate  
 WHERE  
  a.txtItem = 'ISD'  
    
 -- Validamos tblDailyAnalytics  
  
 -- Inserto los que no estan  
  
 INSERT tblDailyAnalytics(  
  txtId1,  
  txtLiquidation,  
  txtItem,  
  txtValue)  
    
 SELECT   
  c.txtId1,  
  'MD',  
  'ISD',  
  CONVERT(CHAR(10),c.dteIssued,120)  
 FROM #tblISD c  
 LEFT OUTER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'ISD'  
  AND a.txtLiquidation = 'MD'  
 WHERE  
  a.txtId1 IS NULL  
      
 -- Actualizo los diferentes  
  
 UPDATE a  
 SET   
  a.txtValue = CONVERT(CHAR(10),c.dteIssued,120)  
 FROM #tblISD c  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'ISD'  
  AND a.txtLiquidation = 'MD'  
  AND CONVERT(CHAR(10),c.dteIssued,120) != a.txtValue   
  
    
 -- Valido tmp_tblActualAnalytics_1  
  
 UPDATE t  
 SET  
  t.txtISD = a.txtValue  
 FROM tmp_tblActualAnalytics_1 t (NOLOCK)  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  t.txtId1 = a.txtId1  
  AND t.txtLiquidation = a.txtLiquidation  
  AND t.txtISD != a.txtValue  
 INNER JOIN #tblISD c  
 ON  
  t.txtId1 = c.txtId1  
 WHERE  
  a.txtItem = 'ISD'  
  AND a.txtLiquidation = 'MD'  
  
END  
  
CREATE PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;5  
 @txtDate CHAR(8)  
/*   
 Autor:   CSOLORIO  
 Creacion:  20131120  
 Descripcion: Actualiza analitico de fecha vencimiento  
  
 Modificado por: CSOLORIO  
 Modificacion: 20131126  
 Descripcion: Elimino actualizacion para instrumentos Equity  
*/   
AS  
BEGIN  
   
 CREATE TABLE #tblMTD(  
  txtId1 CHAR(11),   
  dteMaturity DATETIME  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblMTDDates(  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
     
 INSERT #tblMTD(  
  txtId1,  
  dteMaturity)  
    
 SELECT DISTINCT   
  b.txtId1,  
  b.dteMaturity  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  p.txtId1 = b.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  b.txtId1 = i.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PRS'  
  AND p.txtLiquidation = '24H'  
  AND (  
   i.txtTv NOT LIKE '%SP'  
   AND i.txtTv != 'SP')  
     
 UNION  
   
 SELECT DISTINCT   
  r.txtId1,  
  r.dteMaturity  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblPrivate r (NOLOCK)  
 ON  
  p.txtId1 = r.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation = '24H'  
    
 UNION  
  
 SELECT DISTINCT   
  d.txtId1,  
  d.dteMaturity  
 FROM vw_prices_notes p (NOLOCK)  
 INNER JOIN tblDerivatives d (NOLOCK)  
 ON  
  p.txtId1 = d.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
  AND p.txtLiquidation IN ('24H','MP')  
    
 -- Validamos tblDailyAnalytics  
  
 -- Inserto los que no estan  
  
 INSERT tblDailyAnalytics(  
  txtId1,  
  txtLiquidation,  
  txtItem,  
  txtValue)  
    
 SELECT DISTINCT  
  c.txtId1,  
  'MD',  
  'MTD',  
  CONVERT(CHAR(10),c.dteMaturity,120)  
 FROM #tblMTD c  
 INNER JOIN tblIds i  
 ON  
  c.txtId1 = i.txtID1  
 LEFT OUTER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'MTD'  
  AND a.txtLiquidation = 'MD'  
 WHERE  
  a.txtId1 IS NULL  
  AND c.dteMaturity IS NOT NULL  
      
 -- Actualizo los diferentes  
  
 UPDATE a  
 SET   
  a.txtValue = CONVERT(CHAR(10),c.dteMaturity,120)  
 FROM #tblMTD c  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'MTD'  
  AND a.txtLiquidation = 'MD'  
  AND CONVERT(CHAR(10),c.dteMaturity,120) != a.txtValue   
  
    
 -- Valido tmp_tblActualAnalytics_1  
  
 UPDATE t  
 SET  
  t.txtMTD = a.txtValue  
 FROM tmp_tblActualAnalytics_1 t (NOLOCK)  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  t.txtId1 = a.txtId1  
  AND t.txtLiquidation = a.txtLiquidation  
  AND t.txtMTD != a.txtValue  
 INNER JOIN #tblMTD c  
 ON  
  t.txtId1 = c.txtId1  
 WHERE  
  a.txtItem = 'MTD'  
  AND a.txtLiquidation = 'MD'  
  
END  
  
  
  
CREATE PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;6  
 @txtDate CHAR(8)  
/*   
 Autor:   CSOLORIO  
 Creacion:  20131204  
 Descripcion: Actualiza analiticos de TIT y TIE  
  
 Modificado por: Mike Ramirez   
 Modificacion: 20140616  
 Descripcion: Se modifica update que actualiza sobre temporales de analiticos  
*/   
AS  
BEGIN  
  
 SET NOCOUNT ON  
   
 CREATE TABLE #tblData(  
  txtId1 CHAR(11),  
  txtType CHAR(3),  
  dteDate DATE  
   PRIMARY KEY (txtId1,txtType))  
  
 CREATE TABLE #tblResults(  
  txtId1 CHAR(11),  
  txtItem CHAR(3),  
  txtValue VARCHAR(15)  
   PRIMARY KEY (txtId1,txtItem))  
  
 INSERT #tblData(  
  txtId1,  
  txtType,  
  dteDate)  
    
 SELECT   
  o.txtId1,  
  'MIN',  
  MIN(o.dteDate)  
 FROM tblOutstanding o (NOLOCK)  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  o.txtId1 = i.txtID1  
 INNER JOIN vw_prices_notes p  
 ON  
  o.txtId1 = p.txtID1  
 WHERE  
  o.dteDate <= @txtDate  
  AND p.dteDate = @txtDate  
  AND o.dblOutstanding > 0  
  AND (  
   i.txtTV NOT LIKE '%SP'  
   OR i.txtTV = 'SP')  
 GROUP BY  
  o.txtId1  
  
 UNION  
  
 SELECT   
  o.txtId1,  
  'MAX',  
  MAX(o.dteDate)  
 FROM tblOutstanding o (NOLOCK)  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  o.txtId1 = i.txtID1  
 INNER JOIN vw_prices_notes p  
 ON  
  o.txtId1 = p.txtID1  
 WHERE  
  o.dteDate <= @txtDate  
  AND p.dteDate = @txtDate  
  AND (  
   i.txtTV NOT LIKE '%SP'  
   OR i.txtTV = 'SP')  
 GROUP BY  
  o.txtId1   
  
 INSERT #tblResults(  
  txtId1,  
  txtItem,  
  txtValue)   
    
 SELECT   
  d.txtId1,  
  'TIE',  
  LTRIM(RTRIM(STR(o.dblOutstanding,20,0)))  
 FROM #tblData d  
 INNER JOIN tblOutStanding o (NOLOCK)  
 ON  
  d.txtId1 = o.txtId1  
  AND d.dteDate = o.dteDate  
 WHERE  
  d.txtType = 'MIN'  
  
 UNION  
  
 SELECT   
  d.txtId1,  
  'TIT',  
  LTRIM(RTRIM(STR(o.dblOutstanding,20,0)))  
 FROM #tblData d  
 INNER JOIN tblOutStanding o (NOLOCK)  
 ON  
  d.txtId1 = o.txtId1  
  AND d.dteDate = o.dteDate  
 WHERE  
  d.txtType = 'MAX'  
  
 -- Los que faltan  
  
 INSERT tblDailyAnalytics(  
  txtId1,  
  txtLiquidation,  
  txtItem,  
  txtValue)  
  
 SELECT  
  r.txtId1,  
  'MD',  
  r.txtItem,  
  r.txtValue  
 FROM #tblResults r  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  r.txtId1 = i.txtID1  
 LEFT OUTER JOIN tblDailyAnalytics a  
 ON  
  r.txtId1 = a.txtId1  
  AND r.txtItem = a.txtItem  
  AND a.txtLiquidation = 'MD'  
 WHERE  
  a.txtId1 IS NULL    
 ORDER BY  
  r.txtId1,  
  r.txtItem  
  
 UPDATE a  
 SET   
  a.txtValue = r.txtValue  
 FROM #tblResults r  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  r.txtId1 = a.txtId1  
  AND r.txtItem = a.txtItem  
  AND a.txtLiquidation = 'MD'  
  AND r.txtValue != a.txtValue   
  
 -- Actualizo TIE  
    
 UPDATE t  
 SET   
  t.txtTIE = r.txtValue  
 FROM tmp_tblActualAnalytics_1 t (NOLOCK)  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  t.txtId1 = a.txtId1  
  AND t.txtLiquidation = a.txtLiquidation  
  --AND t.txtTIE != a.txtValue  
 INNER JOIN #tblResults r  
 ON  
  t.txtId1 = r.txtId1  
  AND a.txtItem = r.txtItem  
 WHERE  
  a.txtItem = 'TIE'  
  AND a.txtLiquidation = 'MD'  
  
 UPDATE t  
 SET   
  t.txtTIT = r.txtValue  
 FROM tmp_tblActualAnalytics_1 t (NOLOCK)  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  t.txtId1 = a.txtId1  
  AND t.txtLiquidation = a.txtLiquidation  
  --AND t.txtTIT != a.txtValue  
 INNER JOIN #tblResults r  
 ON  
  t.txtId1 = r.txtId1  
  AND a.txtItem = r.txtItem  
 WHERE  
  a.txtItem = 'TIT'  
  AND a.txtLiquidation = 'MD'  
  
 SET NOCOUNT OFF  
   
END  
  
CREATE PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;7  
 @txtDate CHAR(8)  
/*   
 Autor:   Mike Ramirez  
 Creacion:  20140610  
 Descripcion: Actualiza analiticos de Pais  
  
 Modificado por:   
 Modificacion:   
 Descripcion:   
*/   
  
AS  
BEGIN  
  
 CREATE TABLE #tblCountry (  
  txtId1 CHAR(11),   
  txtCountry CHAR(7),  
  txtFullCountry VARCHAR(50)  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblCountryDates(  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
   
 -- Obtengo los ultimos registros para aquello que esta en tblidsadd  
 INSERT #tblCountryDates(  
  txtId1,  
  dteDate)  
    
 SELECT   
  a.txtId1,  
  MAX(a.dteDate)  
 FROM tblIdsAdd a (NOLOCK)  
 INNER JOIN vw_prices_notes p (NOLOCK)  
 ON  
  a.txtId1 = p.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  a.txtId1 = i.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND a.txtItem = 'COUNTRY'  
  AND i.txtTv NOT LIKE '%SP'  
 GROUP BY  
  a.txtId1  
      
 INSERT #tblCountry (  
  txtId1,  
  txtCountry)  
  
 SELECT   
  a.txtId1,  
  a.txtValue  
 FROM #tblCountryDates d  
 INNER JOIN tblIdsAdd a (NOLOCK)  
 ON  
  d.txtId1 = a.txtId1  
  AND d.dteDate = a.dteDate  
 WHERE  
  a.txtItem = 'COUNTRY'  
  
 -- Validamos tblDailyAnalytics  
  
 -- Inserto los que no estan  
 INSERT tblDailyAnalytics(  
  txtId1,  
  txtLiquidation,  
  txtItem,  
  txtValue)  
    
 SELECT  
  c.txtId1,  
  'MD',  
  'COUNTRY',  
  c.txtcountry  
 FROM #tblCountry c  
 LEFT OUTER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'COUNTRY'  
  AND a.txtLiquidation = 'MD'  
 WHERE  
  a.txtId1 IS NULL  
    
 -- Actualizo los diferentes  
 UPDATE a  
 SET   
  a.txtValue = c.txtCountry  
 FROM #tblCountry c  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'COUNTRY'  
  AND a.txtLiquidation = 'MD'  
  AND c.txtCountry != a.txtValue   
    
 -- Valido tmp_tblActualAnalytics_2  
 UPDATE t  
 SET  
  t.txtCountry = a.txtValue  
 FROM tmp_tblActualAnalytics_2 t (NOLOCK)  
 INNER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  t.txtId1 = a.txtId1  
  AND t.txtLiquidation = a.txtLiquidation  
  AND t.txtCountry != a.txtValue  
 INNER JOIN #tblCountry c  
 ON  
  t.txtId1 = c.txtId1  
 WHERE  
  a.txtItem = 'COUNTRY'  
  AND a.txtLiquidation = 'MD'  
  
END  



SELECT * FROM  tblIdsAdd WHERE txtId1 = 'MIRC0004099'

