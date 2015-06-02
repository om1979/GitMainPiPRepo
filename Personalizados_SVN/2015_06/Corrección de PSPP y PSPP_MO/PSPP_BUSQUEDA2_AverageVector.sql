
  
CREATE PROCEDURE [dbo].[tmp_sp_load_vpromedio];2  
  
 @txtDate as varchar(10)  
  
AS   
  
BEGIN  
  
 SET NOCOUNT ON  
   
 -- Creamos variables tipo tabla  
 CREATE TABLE #tblAuxPricesAverage_PricesPiP   
 (  
  dteDate datetime,  
  txtTv varchar(20),  
  txtEmisora varchar(20),  
  txtSerie varchar(20),  
  txtLiquidation varchar(20),  
  dblValue float,  
  txtISIN varchar(20)  
  PRIMARY KEY (txtTv,txtEmisora,txtSerie,txtLiquidation)  
 )  
   
   
   

 ---- Obtiene precios PiP que no hicieron match con txtTv txtEmisora y txtSerie  
 ----INSERT  #tblAuxPricesAverage_PricesPiP  
 --SELECT DISTINCT  
 -- pp.dteDate ,  
 -- ids.txtTv,  
 -- ids.txtEmisora,  
 -- ids.txtSerie,  
 -- pp.txtLiquidation,  
 -- pp.dblValue,  
 -- ids.txtID2  
 --FROM vw_prices_notes AS pp (NOLOCK) INNER JOIN tblIDs AS ids (NOLOCK)  
 -- ON ids.txtID1 = pp.txtID1  
 -- LEFT OUTER JOIN tmp_tblAverageVector AS av  
 -- ON ids.txtTv = av.txtTv  
 -- AND ids.txtEmisora = av.txtEmisora  
 -- AND ids.txtSerie = av.txtSerie  
 -- AND av.dteDate = '20150601'  
 --WHERE pp.dteDate = '20150601'    
 --AND pp.txtItem = 'PRS'  
 --AND pp.txtLiquidation IN ('MD','24H','481')  
 --AND pp.dblValue <> 0  
 --AND ids.txtTv NOT IN ('TR','*C','*CSP','1ASP','1ESP','1ISP','56SP','93SP','D1SP','D2SP','D3SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JSP','QSP','R3SP','WESP','YYSP','OA','OC','OD','OI')  
 --AND av.txtTV IS NULL  
   
 --UNION ALL  
   
 ----PARA TOMAR EN CUENTA ACCIONES  
 --SELECT DISTINCT  
 -- pp.dteDate ,  
 -- ids.txtTv,  
 -- ids.txtEmisora,  
 -- ids.txtSerie,  
 -- 'MD',  
 -- pp.dblValue,  
 -- ids.txtID2  
 --FROM vw_prices_notes AS pp (NOLOCK) INNER JOIN tblIDs AS ids (NOLOCK)  
 -- ON ids.txtID1 = pp.txtID1  
 -- LEFT OUTER JOIN tmp_tblAverageVector AS av  
 -- ON ids.txtTv = av.txtTv  
 -- AND ids.txtEmisora = av.txtEmisora  
 -- AND ids.txtSerie = av.txtSerie  
 -- AND av.dteDate =  '20150601'    
 --WHERE pp.dteDate =  '20150601'    
 --AND pp.txtItem = 'PAV'  
 --AND pp.txtLiquidation = 'MP'  
 --AND pp.dblValue <> 0  
 --AND ids.txtTv NOT IN ('TR','*C','*CSP','1ASP','1ESP','1ISP','56SP','93SP','D1SP','D2SP','D3SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JSP','QSP','R3SP','WESP','YYSP','OA','OC','OD','OI')  
 --AND av.txtTV IS NULL  
   
 --UNION ALL  
   
 --SELECT DISTINCT  
 -- pp.dteDate ,  
 -- ids.txtTv,  
 -- ids.txtEmisora,  
 -- ids.txtSerie,  
 -- '24H',  
 -- pp.dblValue,  
 -- ids.txtID2  
 --FROM vw_prices_notes AS pp (NOLOCK) INNER JOIN tblIDs AS ids (NOLOCK)  
 -- ON ids.txtID1 = pp.txtID1  
 -- LEFT OUTER JOIN tmp_tblAverageVector AS av  
 -- ON ids.txtTv = av.txtTv  
 -- AND ids.txtEmisora = av.txtEmisora  
 -- AND ids.txtSerie = av.txtSerie  
 -- AND av.dteDate = @txtDate  
 --WHERE pp.dteDate = @txtDate  
 --AND pp.txtItem = 'PAV'  
 --AND pp.txtLiquidation = 'MP'  
 --AND pp.dblValue <> 0  
 --AND ids.txtTv NOT IN ('TR','*C','*CSP','1ASP','1ESP','1ISP','56SP','93SP','D1SP','D2SP','D3SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JSP','QSP','R3SP','WESP','YYSP','OA','OC','OD','OI')  
 --AND av.txtTV IS NULL  
   
 --UNION ALL  
   
 --SELECT DISTINCT  
 -- pp.dteDate ,  
 -- ids.txtTv,  
 -- ids.txtEmisora,  
 -- ids.txtSerie,  
 -- '481',  
 -- pp.dblValue,  
 -- ids.txtID2  
 --FROM vw_prices_notes AS pp (NOLOCK) INNER JOIN tblIDs AS ids (NOLOCK)  
 -- ON ids.txtID1 = pp.txtID1  
 -- LEFT OUTER JOIN tmp_tblAverageVector AS av  
 -- ON ids.txtTv = av.txtTv  
 -- AND ids.txtEmisora = av.txtEmisora  
 -- AND ids.txtSerie = av.txtSerie  
 -- AND av.dteDate = @txtDate  
 --WHERE pp.dteDate = @txtDate  
 --AND pp.txtItem = 'PAV'  
 --AND pp.txtLiquidation = 'MP'  
 --AND pp.dblValue <> 0  
 --AND ids.txtTv NOT IN ('TR','*C','*CSP','1ASP','1ESP','1ISP','56SP','93SP','D1SP','D2SP','D3SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JSP','QSP','R3SP','WESP','YYSP','OA','OC','OD','OI')  
 --AND av.txtTV IS NULL   
   
 --CREATE TABLE #tblAuxPricesAverage_PricesValmer   
 --(  
 -- dteDate datetime,  
 -- txtTv varchar(20),  
 -- txtEmisora varchar(20),  
 -- txtSerie varchar(20),  
 -- txtLiquidation varchar(20),  
 -- dblValue float,  
 -- txtISIN varchar(20)  
 -- PRIMARY KEY (txtTv,txtEmisora,txtSerie,txtLiquidation)  
 --)  
   
 ---- Obtiene precios Valmer que no hicieron match con txtTv txtEmisora y txtSerie MD  
 --INSERT  #tblAuxPricesAverage_PricesValmer  



   declare  @txtDate as varchar(10)   = '20150601'
    
 SELECT DISTINCT  
  CAST(p.txtFechaEmision as DATETIME),  
  p.txtTv,  
  p.txtEmisora,  
  p.txtSerie,  
  'MD',  
  CAST(p.txtPPMD as float),  
  p.txtISIN  
 FROM tmp_tblPricesPromedio AS p LEFT OUTER JOIN tmp_tblAverageVector AS av  
   ON p.txtTv = av.txtTv  
   AND p.txtEmisora = av.txtEmisora   
   AND p.txtSerie = av.txtSerie  
   AND av.dteDate = @txtDate  
 WHERE CAST(p.txtPPMD as float) <> 0  
 AND av.txtTv IS NULL  
 AND p.txtTv NOT IN ('TR')  

 
 UNION ALL  
 -- Obtiene precios Valmer que no hicieron match con txtTv txtEmisora y txtSerie (24)  
 SELECT DISTINCT  
  CAST(p.txtFechaEmision as DATETIME),  
  p.txtTv,  
  p.txtEmisora,  
  p.txtSerie,  
  '24H',  
  CAST(p.txtPPMD as float),  
  p.txtISIN  
 FROM tmp_tblPricesPromedio AS p LEFT OUTER JOIN tmp_tblAverageVector AS av  
   ON p.txtTv = av.txtTv  
   AND p.txtEmisora = av.txtEmisora   
   AND p.txtSerie = av.txtSerie  
   AND av.dteDate = @txtDate  
 WHERE CAST(p.txtPPMD as float) <> 0  
   AND av.txtTv IS NULL  
   AND p.txtTv NOT IN ('TR')  
   and p.txtTv = '1R'
   
   
 UNION ALL   
 -- Obtiene precios Valmer que no hicieron match con txtTv txtEmisora y txtSerie (48)  
 SELECT DISTINCT  
  CAST(p.txtFechaEmision as DATETIME),  
  p.txtTv,  
  p.txtEmisora,  
  p.txtSerie,  
  '481',  
  CAST(p.txtPPMD as float),  
  p.txtISIN  
 FROM tmp_tblPricesPromedio AS p LEFT OUTER JOIN tmp_tblAverageVector AS av  
   ON p.txtTv = av.txtTv  
   AND p.txtEmisora = av.txtEmisora   
   AND p.txtSerie = av.txtSerie  
   AND av.dteDate = @txtDate  
 WHERE av.txtTv IS NULL  
   AND p.txtTv NOT IN ('TR') 
      and p.txtTv = '1R'
   
 -- OInsertamos los que hacen match con isin  
 SELECT DISTINCT  
  p.dteDate,  
  p.txtTv,  
  p.txtEmisora,  
  p.txtSerie,  
  p.txtLiquidation,  
  p.dblValue AS dblPiP,  
  v.dblValue AS dblValmer,  
  p.txtISIN  
 INTO #tblIsinsMatchPiP  
 FROM #tblAuxPricesAverage_PricesPiP AS p INNER JOIN #tblAuxPricesAverage_PricesValmer AS v  
  ON  p.txtISIN = v.txtISIN  
  AND p.txtLiquidation = v.txtLiquidation  
  LEFT OUTER JOIN tmp_tblAverageVector AS a (NOLOCK)  
  ON  p.txtTv = a.txtTv  
  AND p.txtEmisora = a.txtEmisora  
  AND p.txtSerie = a.txtSerie  
  AND p.txtLiquidation = a.txtLiquidation  
 ORDER BY  
  p.txtTv,  
  p.txtEmisora,  
  p.txtSerie,  
  p.txtLiquidation  
   
   
 DECLARE @dteDate AS DATETIME  
 DECLARE @txtTv AS VARCHAR(10)  
 DECLARE @txtEmisora AS VARCHAR(15)  
 DECLARE @txtSerie AS VARCHAR(15)  
 DECLARE @txtLiquidation AS VARCHAR(5)  
 DECLARE @dblValue AS FLOAT  
 DECLARE @txtISIN AS VARCHAR(12)  
 DECLARE @txtLlave AS VARCHAR(45)  
   
   
 DECLARE MATCH_PIP CURSOR FOR   
   
  SELECT DISTINCT  
   m1.dteDate,  
   m1.txtTv AS txtTv,  
   m1.txtEmisora AS txtEmisora,  
   m1.txtSerie AS txtSerie,  
   m1.txtLiquidation AS txtLiquidation,  
   (m1.dblPiP + m1.dblValmer) / 2 AS dblValue,  
   m1.txtISIN  
  FROM #tblIsinsMatchPiP AS m1 INNER JOIN #tblIsinsMatchPiP AS m2  
   ON  m1.txtTv = m2.txtTv  
   AND m1.txtEmisora = m2.txtEmisora  
   AND m1.txtSerie = m2.txtSerie  
  WHERE m1.txtLiquidation = 'MD'  
  UNION  
  SELECT DISTINCT  
   m1.dteDate,  
   m1.txtTv AS txtTv,  
   m1.txtEmisora AS txtEmisora,  
   m1.txtSerie AS txtSerie,  
   m1.txtLiquidation AS txtLiquidation,  
   (m1.dblPiP + m1.dblValmer) / 2 AS dblValue,  
   m1.txtISIN  
  FROM #tblIsinsMatchPiP AS m1 INNER JOIN #tblIsinsMatchPiP AS m2  
   ON  m1.txtTv = m2.txtTv  
   AND m1.txtEmisora = m2.txtEmisora  
   AND m1.txtSerie = m2.txtSerie  
  WHERE m1.txtLiquidation = '24H'  
  UNION  
  SELECT DISTINCT  
   m1.dteDate,  
   m1.txtTv AS txtTv,  
   m1.txtEmisora AS txtEmisora,  
   m1.txtSerie AS txtSerie,  
   m1.txtLiquidation AS txtLiquidation,  
   (m1.dblPiP + m1.dblValmer) / 2 AS dblValue,  
   m1.txtISIN  
  FROM #tblIsinsMatchPiP AS m1 INNER JOIN #tblIsinsMatchPiP AS m2  
   ON  m1.txtTv = m2.txtTv  
   AND m1.txtEmisora = m2.txtEmisora  
   AND m1.txtSerie = m2.txtSerie  
  WHERE m1.txtLiquidation = '481'  
  ORDER BY  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation  
   
 OPEN MATCH_PIP  
   
 FETCH NEXT FROM MATCH_PIP   
 INTO  @dteDate,   
  @txtTv,   
  @txtEmisora,  
  @txtSerie,  
  @txtLiquidation,  
  @dblValue,  
  @txtISIN  
   
 SET @txtLlave = ''  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
   
  -- si esta repetido  
  IF (@txtTv + @txtEmisora + @txtSerie + @txtLiquidation) = @txtLlave   
  BEGIN  
   DELETE  
   FROM tmp_tblAverageVector  
   WHERE txtTv = @txtTv  
   AND  txtEmisora = @txtEmisora  
   AND  txtSerie = @txtSerie  
   AND txtLiquidation = @txtLiquidation  
   AND  dteDate = @txtDate  
  END  
  ELSE  
  BEGIN  
   INSERT tmp_tblAverageVector  
   SELECT @dteDate,   
    @txtTv,   
    @txtEmisora,  
    @txtSerie,  
    @txtLiquidation,  
    @dblValue,  
    @txtISIN  
  END  
   
  SET @txtLlave = @txtTv + @txtEmisora + @txtSerie + @txtLiquidation  
   
   
  FETCH NEXT FROM MATCH_PIP   
  INTO  @dteDate,   
   @txtTv,   
   @txtEmisora,  
   @txtSerie,  
   @txtLiquidation,  
   @dblValue,  
   @txtISIN  
   
 END  
   
 CLOSE MATCH_PIP  
 DEALLOCATE MATCH_PIP  
   
   
 SELECT DISTINCT  
  v.dteDate,  
  v.txtTv,  
  v.txtEmisora,  
  v.txtSerie,  
  v.txtLiquidation,  
  p.dblValue AS dblPiP,  
  v.dblValue AS dblValmer,  
  v.txtISIN  
 INTO #tblIsinsMatchValmer  
 FROM #tblAuxPricesAverage_PricesPiP AS p INNER JOIN #tblAuxPricesAverage_PricesValmer AS v  
  ON  p.txtISIN = v.txtISIN  
  AND p.txtLiquidation = v.txtLiquidation  
  LEFT OUTER JOIN tmp_tblAverageVector AS a (NOLOCK)  
  ON  p.txtTv = a.txtTv  
  AND p.txtEmisora = a.txtEmisora  
  AND p.txtSerie = a.txtSerie  
 ORDER BY  
  v.txtTv,  
  v.txtEmisora,  
  v.txtSerie,  
  v.txtLiquidation  
   
 INSERT tmp_tblAverageVector  
 SELECT DISTINCT  
  dteDate,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtLiquidation,  
  (dblPiP + dblValmer) / 2 AS dblValue,  
  txtISIN  
 FROM #tblIsinsMatchValmer   
 WHERE txtLiquidation = 'MD'  
   
 UNION  
   
 SELECT DISTINCT  
  dteDate,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtLiquidation,  
  (dblPiP + dblValmer) / 2 AS dblValue,  
  txtISIN  
 FROM #tblIsinsMatchValmer  
 WHERE txtLiquidation = '24H'  
   
 UNION  
   
 SELECT DISTINCT  
  dteDate,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtLiquidation,  
  (dblPiP + dblValmer) / 2 AS dblValue,  
  txtISIN  
 FROM #tblIsinsMatchValmer  
 WHERE txtLiquidation = '481'  
 ORDER BY  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtLiquidation  
   
   
 -- Insertamos solo los que estan en PiP  
 INSERT  tmp_tblAverageVector  
 SELECT DISTINCT  
  dteDate,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtLiquidation,  
  dblValue,  
  txtISIN  
 FROM #tblAuxPricesAverage_PricesPiP  
 WHERE NOT txtISIN IN (  
   SELECT txtISIN  
   FROM tmp_tblAverageVector (NOLOCK)  
   WHERE dteDate = @txtDate  
    )  
   
 UNION ALL  
   
 -- Insertamos solo los que estan en valmer  
 SELECT DISTINCT  
  dteDate,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtLiquidation,  
  dblValue,  
  txtISIN  
 FROM #tblAuxPricesAverage_PricesValmer  
 WHERE NOT txtISIN IN (  
   SELECT txtISIN  
   FROM tmp_tblAverageVector (NOLOCK)  
   WHERE dteDate = @txtDate  
    )  
  
 SET NOCOUNT OFF  
  
--END CREATE PROCEDURE [dbo].[tmp_sp_load_vpromedio];3  
--  @txtDate AS VARCHAR(10),  
-- @txtDateFW AS VARCHAR(10)  
  
--AS   
--BEGIN  
-- -- JUNIOR (09:02 a.m. 2008-05-26)  
-- -- calculo el spread a sumarle a la tiie 91  
-- -- para igualar su valor al de la ultima tiie 91 reportada  
-- -- por banxico en ese dia...   
  
-- SET NOCOUNT ON  
  
-- DECLARE @dblLastTIIE AS FLOAT  
-- DECLARE @dteLastTIIE AS DATETIME  
-- DECLARE @dteMaxDate AS DATETIME  
-- DECLARE @dblCurve AS FLOAT  
-- DECLARE @dblSpread AS FLOAT  
  
-- DECLARE @tbl_tmpVectorPiP TABLE  
-- (  
--  dteDate DATETIME,  
--  txtTv VARCHAR(10),  
--  txtEmisora VARCHAR(15),  
--  txtSerie VARCHAR(12),  
--  dblPriceMD FLOAT,  
--  dblPrice24 FLOAT,  
--  dblPrice48 FLOAT,  
--  txtIsin VARCHAR(12)  
-- )  
  
-- -- Eliminamos datos de la tabla destino (promedio)  
-- DELETE  
-- FROM tmp_tblAverageVector  
-- WHERE  dteDate = @txtDate  
-- AND txtTv IN ('TR')  
  
--  SET @dblLastTIIE = (  
   
--   SELECT dblValue  
--   FROM tblIrc AS i  
--   WHERE  
--   txtIrc = 'T091'  
--   AND dteDate = (  
--    SELECT MAX(dteDate)  
--    FROM tblIrc  
--    WHERE      
--     txtIrc = i.txtIrc  
--     AND dteDate <= @txtDate  
--   )  
     
--  )  
   
--  -- obtengo la fecha anterior al cambio   
--  -- de valor de la tiie  
--  SET @dteMaxDate = (  
--  SELECT MAX(dteDate)  
--  FROM tblIrc   
--  WHERE  
--   txtIrc = 'T091'  
--   AND dblValue <> @dblLastTIIE  
--   AND dteDate < @txtDate  
--  )  
   
--  -- obtengo la fecha de la ultima tiie  
--  SET  @dteLastTIIE = (  
--   SELECT MIN(dteDate)  
--   FROM tblIrc AS i  
--   WHERE  
--    txtIrc = 'T091'  
--    AND dteDate > @dteMaxDate  
   
--  )  
   
--  -- obtengo el valor de la curva  
--  -- para esa fecha...  
--  SET @dblCurve = (  
--  SELECT dblRate * 100  
--  FROM tblCurves  
--  WHERE   
--   dteDate = @dteLastTIIE   
--   AND txtType = 'SWP'   
--   AND txtSubType = 'TI'  
--   AND intTerm = 91  
--  UNION  
--  SELECT dblRate * 100  
--  FROM MxFixIncomeHist..tblHistoricCurves  
--  WHERE   
--   dteDate = @dteLastTIIE   
--   AND txtType = 'SWP'   
--   AND txtSubType = 'TI'  
--   AND intTerm = 91  
--  )  
   
--  -- calculo el spread  
--  SET @dblSpread = @dblLastTIIE - @dblCurve  
  
-- -- Sacamos los niveles de curvas  
-- INSERT @tbl_tmpVectorPiP  
-- SELECT @txtDate AS [Fecha],'TR','CETES',intTerm,(dblRate*100),(dblRate*100),(dblRate*100),'NA' FROM tblCurves WHERE dteDate = @txtDate AND txtType = 'CET' AND txtSubType = 'CTI' AND intTerm = 28 UNION  
-- SELECT @txtDate AS [Fecha],'TR','CETES',intTerm,(dblRate*100),(dblRate*100),(dblRate*100),'NA' FROM tblCurves WHERE dteDate = @txtDate AND txtType = 'CET' AND txtSubType = 'CTI' AND intTerm = 91 UNION  
-- SELECT @txtDate AS [Fecha],'TR','CETES',intTerm,(dblRate*100),(dblRate*100),(dblRate*100),'NA' FROM tblCurves WHERE dteDate = @txtDate AND txtType = 'CET' AND txtSubType = 'CTI' AND intTerm = 182 UNION  
-- SELECT @txtDate AS [Fecha],'TR','CETES',intTerm,(dblRate*100),(dblRate*100),(dblRate*100),'NA' FROM tblCurves WHERE dteDate = @txtDate AND txtType = 'CET' AND txtSubType = 'CTI' AND intTerm = 364 UNION  
-- SELECT @txtDate AS [Fecha],'TR','TIIE' ,intTerm,(dblRate*100) + @dblSpread,(dblRate*100)+@dblSpread,(dblRate*100)+@dblSpread,'NA' FROM tblCurves WHERE dteDate = @txtDate AND txtType = 'SWP' AND txtSubType = 'TI'  AND intTerm = 91  
  
-- -- Promediamos e insertamos en la tabla destino  
-- INSERT  tmp_tblAverageVector  
-- SELECT p.dteDate,  
--  p.txtTv,  
--  p.txtEmisora,  
--  p.txtSerie,  
--  'MD' AS txtLiquidation,  
--  STR((p.dblPriceMD + CAST(v.txtPPMD AS FLOAT))/2,10,2) AS dblPrice,  
--  'NA' AS txtIsin  
-- FROM tmp_tblPricesPromedio AS v INNER JOIN @tbl_tmpVectorPiP AS p  
--  ON  v.txtTv = p.txtTv  
--  AND v.txtEmisora = p.txtEmisora  
--  AND v.txtSerie = p.txtSerie  
-- WHERE v.txtEmisora = 'CETES'  
-- UNION  
-- SELECT p.dteDate,  
--  p.txtTv,  
--  p.txtEmisora,  
--  p.txtSerie,  
--  '24H' AS txtLiquidation,  
--  STR((p.dblPrice24 + CAST(v.txtPP24 AS FLOAT))/2,10,2) AS dblPrice,  
--  'NA' AS txtIsin  
-- FROM tmp_tblPricesPromedio AS v INNER JOIN @tbl_tmpVectorPiP AS p  
--  ON  v.txtTv = p.txtTv  
--  AND v.txtEmisora = p.txtEmisora  
--  AND v.txtSerie = p.txtSerie  
-- WHERE v.txtEmisora = 'CETES'  
-- UNION  
-- SELECT p.dteDate,  
--  p.txtTv,  
--  p.txtEmisora,  
--  p.txtSerie,  
--  '481' AS txtLiquidation,  
--  STR((p.dblPrice48 + CAST(v.txtPP48 AS FLOAT))/2,10,2) AS dblPrice,  
--  'NA' AS txtIsin  
-- FROM tmp_tblPricesPromedio AS v INNER JOIN @tbl_tmpVectorPiP AS p  
--  ON  v.txtTv = p.txtTv  
--  AND v.txtEmisora = p.txtEmisora  
--  AND v.txtSerie = p.txtSerie  
-- WHERE v.txtEmisora = 'CETES'  
-- UNION  
-- SELECT p.dteDate,  
--  p.txtTv,  
--  p.txtEmisora,  
--  p.txtSerie,  
--  'MD' AS txtLiquidation,  
--  STR((p.dblPriceMD + CAST(v.txtPPMD AS FLOAT))/2,10,4) AS dblPrice,  
--  'NA' AS txtIsin  
-- FROM tmp_tblPricesPromedio AS v INNER JOIN @tbl_tmpVectorPiP AS p  
--  ON  v.txtTv = p.txtTv  
--  AND v.txtEmisora = p.txtEmisora  
--  AND v.txtSerie = p.txtSerie  
-- WHERE v.txtEmisora = 'TIIE'  
-- UNION  
-- SELECT p.dteDate,  
--  p.txtTv,  
--  p.txtEmisora,  
--  p.txtSerie,  
--  '24H' AS txtLiquidation,  
--  STR((p.dblPrice24 + CAST(v.txtPP24 AS FLOAT))/2,10,4) AS dblPrice,  
--  'NA' AS txtIsin  
-- FROM tmp_tblPricesPromedio AS v INNER JOIN @tbl_tmpVectorPiP AS p  
--  ON  v.txtTv = p.txtTv  
--  AND v.txtEmisora = p.txtEmisora  
--  AND v.txtSerie = p.txtSerie  
-- WHERE v.txtEmisora = 'TIIE'  
-- UNION  
-- SELECT p.dteDate,  
--  p.txtTv,  
--  p.txtEmisora,  
--  p.txtSerie,  
--  '481' AS txtLiquidation,  
--  STR((p.dblPrice48 + CAST(v.txtPP48 AS FLOAT))/2,10,4) AS dblPrice,  
--  'NA' AS txtIsin  
-- FROM tmp_tblPricesPromedio AS v INNER JOIN @tbl_tmpVectorPiP AS p  
--  ON  v.txtTv = p.txtTv  
--  AND v.txtEmisora = p.txtEmisora  
--  AND v.txtSerie = p.txtSerie  
-- WHERE v.txtEmisora = 'TIIE'  
  
-- SET NOCOUNT OFF  
--END  