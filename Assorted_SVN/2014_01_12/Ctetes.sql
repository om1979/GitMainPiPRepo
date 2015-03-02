


  
  
--CREATE PROCEDURE dbo.spi_licuadofinal;13  
 DECLARE @dteDate AS DATETIME = '20140815'  
--AS  
/*   
 Autor:   Carlos Solorio   
 Creacion:  20131004  
 Descripcion: Ajusta cetes sin operaciones de mercado relevantes   
     en base a nodos adyacentes  
  
 Modificado por: Carlos Solorio  
 Modificacion: 20140721  
 Descripcion: Rollback  
*/  
--BEGIN  
  
 --SET NOCOUNT ON   
 --SET ANSI_WARNINGS OFF  
   
 --DECLARE @dteDate AS DATETIME  
   
 --SET @dteDate = '20131002'  
  
  DROP TABLE #tblPonderado  
  
 CREATE TABLE #tblPonderado(  
  intPlazo INT  
   PRIMARY KEY(intPlazo))  
  
 DROP TABLE #tblNodesLevelsTimes  
  
 CREATE TABLE #tblNodesLevelsTimes(  
  dteDate DATETIME,  
  intSerial INT,  
  dteTime DATETIME  
   PRIMARY KEY(dteDate, intSerial))  
     
   
 DROP TABLE #itblNodesLevels  
   
 CREATE TABLE #itblNodesLevels(  
  dteDate DATETIME,  
  intSerialYTM INT,  
  intTerm INT,  
  dblValue FLOAT  
   PRIMARY KEY(dteDate, intTerm))  
  
  
  DROP TABLE #tblUniverse  
  
 CREATE TABLE #tblUniverse(  
  intId INT IDENTITY(1,1),  
  intSerialYTM INT,  
  intTerm INT,  
  txtId1 CHAR(11),  
  dblLastLevel FLOAT,  
  dblLevel FLOAT,  
  dblDiff FLOAT  
   PRIMARY KEY(intId,intSerialYTM))  
  
  DROP TABLE #tblNodesLogistic  
  
 CREATE TABLE #tblNodesLogistic(  
  intSerialYTM INT,  
  intTerm INT,  
  intId INT,  
  dblLastLevel FLOAT,  
  dblLevel FLOAT,   
  dblDiff FLOAT,  
  dblAjust FLOAT,  
  intBeforeTerm INT,  
  intAfterTerm INT,  
  txtPosture CHAR(1),  
  intNodesDiff INT  
   PRIMARY KEY(intSerialYTM))  
     
  
  DROP TABLE #tblBestPostures  
  
 CREATE TABLE #tblBestPostures(  
  intPlazo INT,  
  dblCompra FLOAT,  
  dblVenta FLOAT  
   PRIMARY KEY(intPlazo))  
  
 DROP TABLE #tblYTMTimes  
   
 CREATE TABLE #tblYTMTimes(  
  intSerialYTM INT,  
  dteTime DATETIME  
   PRIMARY KEY(intSerialYTM))   
  
 -- Obtengo las posturas que movieron los niveles  
   
 DECLARE @dteLastDate DATETIME  
   
 SELECT @dteLastDate = dbo.fun_NextTradingDate(@dteDate,-1,'MX')  
  
  --SELECT   @dteLastDate
  
  
 INSERT #tblPonderado(  
  intPlazo)  
    
 SELECT DISTINCT  
  intPlazo  
 FROM itblPonderado (NOLOCK)  
 WHERE  
  txtTv = 'BI'  
  AND dteDate = @dteDate  
  
 INSERT #tblNodesLevelsTimes(  
  dteDate,  
  intSerial,  
  dteTime)  
    
 SELECT   
  l.dteDate,  
  c.intSerialYTM,  
  MAX(dteTime)  
 FROM itblNodesYTMCatalog c (NOLOCK)  
 INNER JOIN itblNodesYTMLevels l (NOLOCK)  
 ON  
  c.intSerialYTM = l.intSerialYTM  
 WHERE  
  c.txtCategory = 'CET'  
  AND l.dteDate IN (@dteDate, @dteLastDate)  
  AND c.fStatus = 1  
 GROUP BY  
  c.intSerialYTM,  
  l.dteDate  
     
 INSERT #itblNodesLevels(  
  dteDate,  
  intSerialYTM,  
  intTerm,  
  dblValue)  
    
 SELECT   
  l.dteDate,  
  l.intSerialYTM,  
  DATEDIFF(DAY,@dteDate,b.dteMaturity),  
  l.dblValue  
 FROM #tblNodesLevelsTimes t  
 INNER JOIN itblNodesYTMCatalog c  
 ON  
  t.intSerial = c.intSerialYTM  
 INNER JOIN itblNodesYTMLevels l  
 ON  
  t.intSerial = l.intSerialYTM  
  AND t.dteDate = l.dteDate  
  AND t.dteTime = l.dteTime   
 INNER JOIN tblBonds b  
 ON  
  c.txtId1 = b.txtId1   
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  c.txtId1 = i.txtId1  
 WHERE  
  i.txtTV = 'BI'  
  AND b.dteEfective < @dteDate  
   
  
 -- Determino el universo de posibles instrumentos a ajustar  
  
 INSERT #tblUniverse(  
  intSerialYTM,  
  intTerm,  
  txtId1,  
  dblLastLevel,  
  dblLevel)  
    
 SELECT DISTINCT  
  c.intSerialYTM,  
  DATEDIFF(DAY,@dteDate,b.dteMaturity),  
  c.txtId1,  
  ISNULL(ll.dblValue,-999),  
  CASE  
   WHEN b.dteEfective >= @dteDate THEN -999  
   WHEN DATEDIFF(DAY,@dteDate,b.dteMaturity) <= 6 THEN -999  
   WHEN ps.intPlazo IS NULL AND p1.txtTv IS NULL AND p2.txtTv IS NULL THEN -999 -- Aqui valido que existieron posturas que realmente afectaron en nivel  
   ELSE ISNULL(l.dblValue,-999)  
  END   
 FROM itblNodesYTMCatalog c (NOLOCK)  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  c.txtId1 = i.txtId1  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
 LEFT OUTER JOIN #itblNodesLevels ll  
 ON  
  c.intSerialYTM = ll.intSerialYTM  
  AND ll.dteDate = @dteLastDate  
 LEFT OUTER JOIN #itblNodesLevels l (NOLOCK)  
 ON  
  c.intSerialYTM = l.intSerialYTM  
  AND l.dteDate = @dteDate  
 LEFT OUTER JOIN itblPonderadoFinal p2 (NOLOCK)  
 ON  
  i.txtTV = p2.txtTv  
  AND p2.intPlazo = DATEDIFF(DAY,@dteDate,b.dteMaturity)  
  AND p2.dteDate = @dteDate  
  AND p2.fStatus = 1  
 LEFT OUTER JOIN itblPonderadoFinal p1 (NOLOCK)  
 ON  
  i.txtTV = p1.txtTv  
  AND p1.intPlazo = DATEDIFF(DAY,@dteDate,b.dteMaturity)  
  AND p1.dteDate = @dteDate  
  AND p1.fStatus = 0    
 LEFT OUTER JOIN #tblPonderado ps  
 ON  
  DATEDIFF(DAY,@dteDate,b.dteMaturity) = ps.intPlazo  
 WHERE  
  i.txtTV = 'BI'  
  AND c.txtCategory = 'CET'  
  AND c.fStatus = 1  
  AND c.dteBeg < @dteDate  
  AND b.dteEfective < @dteDate  
 ORDER BY   
  2  
  
 
 -- Actualizo las diferencias  
  
 UPDATE #tblUniverse  
 SET dblDiff = dblLevel - dblLastLevel  
 WHERE  
  dblLevel != -999  
  AND dblLastLevel != -999 -- No nuevos  
    
  
 -- Considero que aquello que no tenga nivel actual no presento posturas que muevan el nivel  
  
 INSERT #tblNodesLogistic(  
  intSerialYTM,  
  intTerm,  
  intId,  
  dblLastLevel,  
  intBeforeTerm,  
  intAfterTerm)  
    
 SELECT   
  u.intSerialYTM,  
  u.intTerm,  
  u.intId,  
  u.dblLastLevel,  
  MAX(a.intTerm),  
  MIN(d.intTerm)  
 FROM #tblUniverse u  
 LEFT OUTER JOIN #tblUniverse a  
 ON  
  a.intTerm < u.intTerm  
  AND a.dblLevel != -999  
 LEFT OUTER JOIN #tblUniverse d  
 ON  
  d.intTerm > u.intTerm  
  AND d.dblLevel != -999  
 WHERE  
  u.dblLevel = -999  
  AND u.intTerm > 6  
 GROUP BY  
  u.intSerialYTM,  
  u.intTerm,  
  u.intId,  
  u.dblLastLevel  
 ORDER BY  
  u.intTerm   
  
  
 -- Aplico las diferencias a los plazos que no operaron  
  
 UPDATE l  
 SET   
  l.dblDiff = ISNULL(bu.dblDiff,-999), -- Por default tomo la diferencia del primer nodo  
  l.intNodesDiff = ISNULL((au.intId - bu.intId) - 1,-999),  
  l.dblAjust =   
   CASE  
    WHEN au.intTerm IS NULL THEN  bu.dblDiff  
    WHEN bu.intTerm IS NULL THEN  au.dblDiff  
    WHEN au.intId - bu.intId = 2 THEN (au.dblDiff + bu.dblDiff)/2  
    ELSE (au.dblDiff - bu.dblDiff) / (au.intId - bu.intId)  
   END  
 FROM #tblNodesLogistic l  
 LEFT OUTER JOIN #tblUniverse bu  
 ON  
  l.intBeforeTerm = bu.intTerm  
 LEFT OUTER JOIN #tblUniverse au  
 ON  
  l.intAfterTerm = au.intTerm  
 WHERE  
  bu.intTerm IS NOT NULL    
  OR au.intTerm IS NOT NULL  
  
  
  

  
 -- Aqui obtengo las diferencias en multiples nodos entre postes se actualiza por capas   
  
 DECLARE @intMinId AS INT  
 DECLARE @intMaxId AS INT  
 DECLARE @intId  AS INT  
   
 SELECT   
  @intMinId = MIN(l.intId),  
  @intMaxId = MAX(l.intId)  
 FROM #tblNodesLogistic l  
 WHERE  
  l.intNodesDiff > 1 -- Solo aplica a los que tienen mas de un nodo entre postes  
   
 SET @intId = @intMinId  
   
 WHILE @intId <= @intMaxId  
 BEGIN  
   
  UPDATE l  
  SET   
   l.dblDiff =    
    CASE  
     WHEN n.dblDiff IS NULL THEN l.dblDiff -- Si no tengo nodo a la izquierda tomo la diferencia por defaul  
     ELSE n.dblDiff  
    END + l.dblAjust   
  FROM #tblNodesLogistic l  
  LEFT OUTER JOIN #tblNodesLogistic n  
  ON  
   l.intid = n.intid + 1  
   AND l.intBeforeTerm = n.intBeforeTerm  
   AND l.intAfterTerm = n.intAfterTerm  
  WHERE  
   l.intId = @intId  
   AND l.intNodesDiff > 1  
    
  SET @intId = @intId + 1  
      
 END  
  

 -- Actualizo los niveles  
   
 UPDATE #tblNodesLogistic  
 SET   
  dblLevel =   
   CASE  
    WHEN intNodesDiff > 1 THEN dblLastLevel + dblDiff  
    ELSE dblLastLevel + dblAjust  
   END  
   --correcto oaceves
   
   
   

 -- Valido vs las operaciones del dia  
   
 DECLARE @dteCloseRandom DATETIME  
   
 SELECT   
  @dteCloseRandom = dteCloseHour   
 FROM itblClosesRandom  
 WHERE  
  dteDate = @dteDate  
     
 DECLARE @dblMinRate FLOAT  
 DECLARE @dblMinAmount FLOAT  
 DECLARE @intMinTime INT  
 DECLARE @txtLiquidations CHAR(50)  
   
 SELECT   
  @intMinTime = txtValue   
 FROM itblBlenderParams  
 WHERE  
  txtBlender = 'CET'  
  AND txtItem = 'STO'  
  
 SELECT   
  @dblMinAmount = txtValue  
 FROM itblBlenderParams  
 WHERE  
  txtBlender = 'CET'  
  AND txtItem = 'AMM'  
  
 SELECT  
  @dblMinRate = txtValue  
 FROM itblBlenderParams  
 WHERE  
  txtBlender = 'CET'  
  AND txtItem = 'AMT'  
  
 SELECT  
  @txtLiquidations = txtValue  
 FROM itblBlenderParams  
 WHERE  
  txtBlender = 'CET'  
  AND txtItem = 'ACL'         
  
  

 INSERT #tblBestPostures(  
  intPlazo,  
  dblCompra,  
  dblVenta)  
  
 SELECT   
  l.intTerm,  
  ISNULL(MIN(c.dblRate),-999),   
  ISNULL(MAX(v.dblRate),-999)  
 FROM #tblNodesLogistic l  
 LEFT OUTER JOIN itblMarketPositions c (NOLOCK)  
 ON  
  l.intTerm = c.intPlazo  
  AND c.txtTV = 'BI'  
  AND c.txtOperation = 'COMPRA'  
  AND c.dteDate = @dteDate  
  AND c.dblRate > @dblMinRate  
  AND DATEDIFF(s,c.dteBeginHour,c.dteEndHour) > @intMinTime  
  AND c.txtLiquidation = @txtLiquidations  
  AND DATEADD(SECOND,@intMinTime,c.dteBeginHour) < @dteCloseRandom  
 LEFT OUTER JOIN itblMarketPositions v (NOLOCK)  
 ON  
  l.intTerm = v.intPlazo  
  AND v.txtTv = 'BI'  
  AND v.txtOperation = 'VENTA'  
  AND v.dteDate = @dteDate  
  AND v.dblRate > @dblMinRate  
  AND DATEDIFF(s,v.dteBeginHour,v.dteEndHour) > @intMinTime  
  AND v.txtLiquidation = @txtLiquidations  
  AND DATEADD(SECOND,@intMinTime,v.dteBeginHour) < @dteCloseRandom  
 GROUP BY  
  l.intTerm  
  
  
 
 -- SELECT * INTO #tblNodesLogisticOaceves FROM   #tblNodesLogistic
  --WHERE intterm = 73
--------------------------------
 -- Begin  
    
 UPDATE l  
 SET   
  l.dblLevel =    
  CASE  
   WHEN b.dblVenta != -999 AND  l.dblLevel <= b.dblVenta  THEN b.dblVenta + .01  
   WHEN b.dblCompra != -999 AND  l.dblLevel >= b.dblCompra THEN b.dblCompra - .01  
   ELSE l.dblLevel  
  END,  
  l.txtPosture =  
  CASE  
   WHEN b.dblVenta != -999 AND  l.dblLevel <= b.dblVenta  THEN 'V'  
   WHEN b.dblCompra != -999 AND  l.dblLevel >= b.dblCompra THEN 'C'  
  END  
 FROM #tblNodesLogistic l  
 INNER JOIN #tblBestPostures b  
 ON  
  l.intTerm = b.intPlazo  
 WHERE  
  b.dblCompra != -999  
  OR b.dblVenta != -999  
  
  ------------------------
   SELECT * FROM  #tblUniverse  
  --WHERE  intSerialYTM = 1059
  
  --SELECT * FROM  #tblNodesLogistic
  --WHERE intterm = 73
  
  
  --SELECT * FROM  #tblNodesLogisticOaceves
  
  --SELECT * FROM  #tblBestPostures
  --WHERE intplazo = 73
  
  
 -- SELECT 
 --   CASE  
 --  WHEN b.dblVenta != -999 AND  l.dblLevel <= b.dblVenta  THEN b.dblVenta + .01  
 --  WHEN b.dblCompra != -999 AND  l.dblLevel >= b.dblCompra THEN b.dblCompra - .01  
 --  ELSE l.dblLevel  
 -- END AS newdblLevel,  
   
 -- CASE  
 --  WHEN b.dblVenta != -999 AND  l.dblLevel <= b.dblVenta  THEN 'V'  
 --  WHEN b.dblCompra != -999 AND  l.dblLevel >= b.dblCompra THEN 'C'  
 -- END  AS Posture
 --FROM #tblNodesLogisticOaceves l  
 --INNER JOIN #tblBestPostures b  
 --ON  
 -- l.intTerm = b.intPlazo  
 --WHERE  
 -- b.dblCompra != -999  
 -- OR b.dblVenta != -999  
  
  
  --SELECT * FROM  #tblBestPostures
  
  
  
  
  -----------------------------
 -- Valido vs la postura no considerada  
 UPDATE l  
 SET  
  l.dblLevel =   
  CASE  
   WHEN l.txtPosture = 'C' AND  ROUND(l.dblLevel,3) <= ROUND(b.dblVenta,3)  THEN b.dblVenta + .01  
   WHEN l.txtPosture = 'V' AND  ROUND(l.dblLevel,3) >= ROUND(b.dblCompra,3) THEN b.dblCompra - .01  
   ELSE l.dblLevel  
  END  
 FROM #tblNodesLogistic l  
 INNER JOIN #tblBestPostures b  
 ON  
  l.intTerm = b.intPlazo  
 WHERE  
  (  
   l.txtPosture = 'V'  
   AND b.dblCompra != -999)  
  OR(  
   l.txtPosture = 'C'  
   AND b.dblVenta != -999)  
 ---END  
   
   
   
 -- Reviso la tendincia de los nodos que estan solos entre postes  
 UPDATE #tblNodesLogistic  
 SET   
  dblLevel =   
   CASE  
    WHEN dblLastLevel > dblLevel AND dblAjust > 0 THEN dblLastLevel  
    WHEN dblLastLevel < dblLevel AND dblAjust < 0 THEN dblLastLevel  
    ELSE dblLevel  
   END  
 WHERE  
  intNodesDiff = 1  
    
 UPDATE u  
 SET   
  u.dblLevel = l.dblLevel  
 FROM #tblNodesLogistic l  
 INNER JOIN #tblUniverse u  
 ON  
  l.intSerialYTM = u.intSerialYTM  
  
  
  
 -- Obtengo la hora maxima del dia para tomar el spread  
   
 INSERT #tblYTMTimes(  
  intSerialYTM,  
  dteTime)  
   
 SELECT   
  l.intSerialYTM,  
  MAX(dteTime)  
 FROM itblNodesYTMLevels l (NOLOCK)  
 INNER JOIN #tblUniverse u  
 ON  
  l.intSerialYTM = u.intSerialYTM  
 WHERE  
  l.dteDate = @dteDate  
 GROUP BY  
  l.intSerialYTM  

   
-- INSERT itblNodesYTMlevels(  
--  dteDate,  
--  intSerialYTM,  
--  dblValue,  
--  dblSpread,  
--  dteTime)  
    
 SELECT   
  @dteDate,  
  u.intSerialYTM,  
  ROUND(CONVERT(DECIMAL(22,7),u.dblLevel),3),  
  l.dblSpread,  
  CONVERT(CHAR(8),GETDATE(),108)  
 FROM #tblYTMTimes t  
 INNER JOIN itblNodesYTMLevels l (NOLOCK)  
 ON  
  t.intSerialYTM = l.intSerialYTM  
  AND t.dteTime = l.dteTime  
 INNER JOIN #tblUniverse u  
 ON  
  l.intSerialYTM = u.intSerialYTM  
 INNER JOIN #tblNodesLogistic n  
 ON  
  u.intSerialYTM = n.intSerialYTM  
 WHERE  
  l.dteDate = @dteDate     
    
 SELECT   
  l.intTerm AS Plazo,  
  l.dblLastLevel AS [Nivel Anterior],  
  l.dblLevel AS Nivel,  
  CASE  
   WHEN intNodesDiff > 1 THEN STR(dblDiff,20,7)  
   ELSE   
    CASE  
     WHEN dblAjust IS NULL THEN ''  
     ELSE STR(dblAjust,20,7)  
    END   
  END AS Ajuste,  
  CASE  
   WHEN l.intBeforeTerm IS NULL THEN ''  
   ELSE RTRIM(LTRIM(STR(l.intBeforeTerm,10,0)))  
  END AS [Anterior],  
  CASE  
   WHEN l.intAfterTerm IS NULL THEN ''  
   ELSE RTRIM(LTRIM(STR(l.intAfterTerm)))  
  END [Posterior],  
  CASE  
   WHEN p.dblCompra = -999 THEN ''  
   ELSE RTRIM(LTRIM(STR(p.dblCompra,10,3)))  
  END AS Compra,  
  CASE  
   WHEN p.dblVenta = -999 THEN ''  
   ELSE RTRIM(LTRIM(STR(p.dblVenta,10,3)))  
  END AS Venta  
 FROM #tblNodesLogistic l  
 LEFT OUTER JOIN #tblBestPostures p  
 ON  
  l.intTerm = p.intPlazo  
 ORDER BY   
  l.intTerm  
  
 --SET ANSI_WARNINGS ON  
 --SET NOCOUNT OFF  
  
----END  




-- --SELECT  ROUND(2.89+ (-0.041818182),3)    
  
  
-- --     -0.0418182
-- -- 2.8381818
  
-- -- SELECT ROUND(2.8381818,3)
  
  