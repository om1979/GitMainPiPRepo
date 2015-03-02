
CREATE  PROCEDURE [dbo].[sp_clsOfficialIndexFiles];9  
 @txtDate AS VARCHAR(10),  
  @txtOwnerId AS CHAR(5)  
AS  
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Para generar el vector de acciones CONSAR (cliente)  
  
 Modificado por: Csolorio  
 Modificacion: 20110223  
 Descripcion:    Se elimina la utilizacion de cursores  
*/  
BEGIN  
 SET NOCOUNT ON   
  
 -- Creo tablas temporales  
    
 CREATE TABLE #tblIndexValue(  
  txtIndex VARCHAR(8),  
  dblIndexValue FLOAT)  
  
 CREATE TABLE #tblIndexEquityPrices(  
  txtIndex VARCHAR(10),  
  dteDate DATETIME,  
  txtId1 CHAR(11),  
  dblCount FLOAT,  
  dblPrice FLOAT,  
  txtCurrency VARCHAR(5),  
  dblExchange FLOAT,      
  dblMXNPrice FLOAT,  
  dblPond FLOAT)  
  
 -- Obtengo el universo de indices  
  
 SELECT DISTINCT   
  ip.txtIndex  
 INTO #tblUniverse  
 FROM tblIndexesPortfolios AS ip (NOLOCK)  
 INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS o (NOLOCK)  
 ON   
  ip.txtIndex = o.txtDir  
 WHERE  
  o.txtOwnerId = 'ING01'  
  AND o.dteBeg <= @txtDate  
  AND o.dteEnd >= @txtDate   
 ORDER BY  
  ip.txtIndex   
  
 -- Obtengo la ultima fecha de la composicion por indice  
  
 SELECT   
  u.txtIndex,  
  CASE   
   WHEN MAX(dteDate) IS NULL THEN '19790324'  
   ELSE MAX(dteDate)  
  END AS dteDate  
 INTO #tblMaxDates  
 FROM tblIndexesPortfolios p(NOLOCK)  
 INNER JOIN #tblUniverse u  
 ON  
  p.txtIndex = u.txtIndex  
  AND p.dteDate <= @txtDate  
 GROUP BY   
  u.txtIndex  
  
 -- obtengo los precios de las acciones en pesos  
  
 INSERT #tblIndexEquityPrices  
 SELECT   
  ip.txtIndex,  
  ip.dteDate,  
  ip.txtId1,  
  ip.dblCount,  
  ep.dblPrice,  
  e.txtCurrency,  
    
  CASE  
  WHEN i.dblValue IS NULL THEN 1  
  ELSE i.dblValue  
  END AS dblExchange,  
  
  CASE  
  WHEN p.dblValue IS NULL THEN -999  
  ELSE p.dblValue  
  END AS dblMXNPrice,  
  
  1E-10 AS dblPond  
 FROM #tblUniverse u  
 INNER JOIN #tblMaxDates d  
 ON  
  u.txtIndex = d.txtIndex  
 INNER JOIN tblIndexesPortfolios AS ip (NOLOCK)  
 ON   
  d.txtIndex = ip.txtIndex  
  AND d.dteDate = ip.dteDate  
 INNER JOIN tblEquity AS e (NOLOCK)  
 ON  
  ip.txtId1 = e.txtId1  
 INNER JOIN tblEquityPrices AS ep  (NOLOCK)     
 ON e.txtId1 = ep.txtId1  
 LEFT OUTER JOIN tblIrc AS i (NOLOCK)  
 ON   
  i.txtIrc = (  
   CASE   
   WHEN e.txtCurrency IN ('USD') THEN 'UFXU'    
   ELSE e.txtCurrency  
   END  
  )  
  AND i.dteDate = @txtDate  
 LEFT OUTER JOIN tblPrices AS p (NOLOCK)  
 ON   
  e.txtId1 = p.txtId1   
  AND p.dteDate = @txtDate  
  AND p.txtItem = 'PAV'  
 WHERE  
  ep.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblEquityPrices  (NOLOCK)  
   WHERE  
    txtId1 = ep.txtId1  
    AND dteDate <= @txtDate  
    AND txtOperationCode = ep.txtOperationCode  
  )  
  AND ep.dteTime = (  
   SELECT MAX(dteTime)  
   FROM tblEquityPrices (NOLOCK)  
   WHERE  
    txtId1 = ep.txtId1  
    AND dteDate = ep.dteDate  
    AND txtOperationCode = ep.txtOperationCode  
  )  
  AND ep.txtOperationCode = 'S01'  
  
  
 -- obtengo los precios en pesos    
 UPDATE #tblIndexEquityPrices  
 SET dblMXNPrice = dblPrice * dblExchange  
 WHERE  
  dblMXNPrice = -999  
    
  
 -- obtengo el valor del indice en pesos  
  
 INSERT #tblIndexValue  
  
 SELECT    
  txtIndex,  
  SUM(dblCount * dblMXNPrice)    
 FROM #tblIndexEquityPrices  
 GROUP BY txtIndex  
  
  
 UPDATE p  
 SET p.dblPond = p.dblMXNPrice * p.dblCount / i.dblIndexValue  
 FROM #tblIndexEquityPrices p  
 INNER JOIN #tblIndexValue i  
 ON   
  p.txtIndex = i.txtIndex  
  
 -- obtengo codigos internacionales  
  
 SELECT DISTINCT   
  i.txtId1,  
  
  CASE  
  WHEN i.txtId2 IS NULL THEN ''  
  ELSE i.txtId2  
  END AS txtIsin,  
  
  CASE  
  WHEN a.txtValue IS NULL THEN ''  
  ELSE a.txtValue  
  END AS txtSedol,  
  
  CASE  
  WHEN a2.txtValue IS NULL THEN ''  
  ELSE a2.txtValue  
  END AS txtCusip  
 INTO #tblIds  
 FROM #tblIndexEquityPrices AS r  
 INNER JOIN tblIds AS i (NOLOCK)  
 ON r.txtId1 = i.txtId1  
 LEFT OUTER JOIN tblIdsAdd AS a (NOLOCK)  
 ON   
  r.txtId1 = a.txtId1  
  AND a.txtItem = 'ID4'  
  AND a.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblIdsAdd (NOLOCK)  
   WHERE  
    txtId1 = a.txtId1  
    AND txtItem = a.txtItem  
    AND dteDate < CAST(@txtDate AS DATETIME) + 1  
  )  
 LEFT OUTER JOIN tblIdsAdd AS a2 (NOLOCK)  
 ON   
  r.txtId1 = a2.txtId1  
  AND a2.txtItem IN ('ID3', 'ID5')  
  AND a2.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblIdsAdd (NOLOCK)  
   WHERE  
    txtId1 = a2.txtId1  
    AND txtItem = a2.txtItem  
    AND dteDate < CAST(@txtDate AS DATETIME) + 1  
  )  
  
 SET NOCOUNT OFF  
  
 -- resultado  
 SELECT    
  'H ' +   
  'MC' +  
  @txtDate +  
  RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +  
  RTRIM(SUBSTRING(i.txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(i.txtEmisora, 1, 7))) +  
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
  
  SUBSTRING(REPLACE(STR(ROUND(AVG(c.dblMXNPrice),6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(AVG(c.dblMXNPrice),6),16,6),  ' ', '0'), 11, 6) +  
  
  '000000000000000' +  
  '000000000000' +  
  '025009' +   
  '0' +   
  '000000' +   
  '00000000' +   
  
  RTRIM(i2.txtIsin) + REPLICATE(' ',12 - LEN(i2.txtIsin)) +  
  RTRIM(i2.txtCusip) + REPLICATE(' ',9 - LEN(i2.txtCusip)) +  
  RTRIM(i2.txtSedol) + REPLICATE(' ',7 - LEN(i2.txtSedol))  +  
  '0         ' AS txtVectorConsar  
    
  FROM #tblIndexEquityPrices AS c  
 INNER JOIN tblIds AS i (NOLOCK)  
 ON   
  c.txtId1 = i.txtId1  
 INNER JOIN #tblIds AS i2  
 ON   
  i.txtId1 = i2.txtId1  
  GROUP BY   
  i.txtTv,  
  i.txtEmisora,  
  SUBSTRING(i.txtEmisora, 1, 7),  
  i.txtSerie,  
  i2.txtIsin,  
  i2.txtCusip,  
  i2.txtSedol  
  ORDER BY  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie  
  
 SET NOCOUNT OFF  
END  
GO
