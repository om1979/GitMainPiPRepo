  
--CREATE PROCEDURE dbo.spi_ENCUESTAS;1  '20141009','REPS'
 DECLARE @txtDate AS VARCHAR(10) =  '20141008'
 declare @txtCategory AS VARCHAR(5) ='CET'
/*   
 Autor:   JUNIOR     
 Creacion:  2004-03-18  
 Descripcion: Para contener todas las operaciones relativas a las subastas via IG  
  
 Modificado por: Abraham Alamilla  
 Modificacion: 20140213  
 Descripcion: Redondeo de niveles para FWD nodos mayores a 720  
*/  
--AS  
--BEGIN  
  
 --SET NOCOUNT ON  
  
 -- Drop table para pruebas  
 IF OBJECT_ID('tempdb..#tblResults') IS NOT NULL  
     DROP TABLE #tblResults  
 CREATE TABLE #tblResults(  
  intSerial INT,  
  txtType CHAR(4),  
  dteDate DATETIME,  
  txtTerm VARCHAR(10),  
  dblValue FLOAT,  
  txtTV CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10)  
   PRIMARY KEY(intSerial,dteDate))  
     
 -- Drop table para pruebas  
 IF OBJECT_ID('tempdb..#tblDatesNodes') IS NOT NULL  
     DROP TABLE #tblDatesNodes  
 CREATE TABLE #tblDatesNodes(  
  dteDate DATETIME,  
  intSerial INT,  
  txtType CHAR(4),  
  txtTerm VARCHAR(10),  
  txtTV CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10)  
   PRIMARY KEY(intSerial,dteDate))  
     
     
      	DECLARE @getmaxDate DATETIME =(
	SELECT MAX(dteDate)FROM  itblNodesZeroLevels AS A
	INNER JOIN itblNodesZeroCatalog AS B
	ON A.intSerialZero = B.intSerialZero
	WHERE b.txtCategory = @txtCategory)
 -- Oculto nodos 1 no fijos  
  
 --UPDATE dbo.itblNodesZeroCatalog  
 --SET   
 -- fStatus = 0  
 --WHERE   
 -- fStatus = 1  
 -- AND fFix = 0  
 -- AND intBeg - DATEDIFF(d,dteBeg,@txtDate) <= 1  
 -- AND txtCategory = @txtCategory  
  
 --UPDATE c  
 --SET   
 -- c.fStatus = 0  
 --FROM dbo.itblNodesYtmCatalog c  
 --INNER JOIN dbo.tblBonds b (NOLOCK)  
 --ON  
 -- c.txtId1 = b.txtId1  
 --WHERE   
 -- c.fStatus = 1  
 -- AND c.txtCategory = @txtCategory  
 -- AND DATEDIFF(d,@txtDate,b.dteMaturity) <= 1  
    
 -- genero buffer con datos   
 DECLARE @itblNodesYTMLevels TABLE (  
  dteDate DATETIME,  
  intSerialYTM INTEGER,  
  dteTime DATETIME  
   PRIMARY KEY(dteDate, intSerialYTM)  
 )  
 INSERT INTO @itblNodesYTMLevels (  
  dteDate,  
  intSerialYTM,  
  dteTime  
 )  
 SELECT   
  dteDate,  
  intSerialYTM,  
  MAX(dteTime)   
 FROM itblNodesYTMLevels (NOLOCK)  
 GROUP BY   
  dteDate,  
  intSerialYTM  
  
 DECLARE @itblNodesZeroLevels TABLE (  
  dteDate DATETIME,  
  intSerialZero INTEGER,  
  dteTime DATETIME  
   PRIMARY KEY(dteDate, intSerialZero)  
 )  
 INSERT INTO @itblNodesZeroLevels (  
  dteDate,  
  intSerialZero,  
  dteTime  
 )  
 SELECT   
  dteDate,  
  intSerialZero,  
  MAX(dteTime)   
 FROM itblNodesZeroLevels (NOLOCK)  
 GROUP BY   
  dteDate,  
  intSerialZero  
  
 --SET NOCOUNT OFF  
  
 -- reporte: instrumentos  
  
 INSERT #tblResults(  
  intSerial,  
  txtType,  
  dteDate,  
  txtTerm,  
  dblValue,  
  txtTV,  
  txtEmisora,  
  txtSerie)  
    
 SELECT  
  buff.intSerialYTM,  
  'YTM',  
  b.dteDate AS [Fecha],  
  CAST(DATEDIFF(DAY,@txtDate,c.dteMaturity) AS CHAR(5)) AS [Nodo],  
  b.dblValue AS [Valor],  
  d.txtTV,  
  d.txtEmisora,  
  d.txtSerie  
 FROM    
  tblBonds AS c (NOLOCK)  
  INNER JOIN itblNodesYTMCatalog AS a (NOLOCK)  
  ON c.txtId1 = a.txtId1   
  INNER JOIN tblIds AS d (NOLOCK)  
  ON c.txtId1 = d.txtId1  
  INNER JOIN @itblNodesYTMLevels AS buff   
  ON a.intSerialYTM = buff.intSerialYTM  
  INNER JOIN itblNodesYTMLevels AS b (NOLOCK)  
  ON   
   a.intSerialYTM = b.intSerialYTM  
   AND buff.dteDate = b.dteDate  
   AND buff.dteTime = b.dteTime    
 WHERE a.intSerialYTM = b.intSerialYTM  
 AND  b.dteDate <= @txtDate  
 AND a.txtCategory = @txtCategory  
 AND     a.fStatus = 1  
 AND  c.dteMaturity >= @txtDate  
 /*  //////////////////////////////////////////  */
  
  
----SELECT * FROM #tblResults
------SELECT * FROM  #tmpBus

--SELECT   DISTINCT 
--  --buff.intSerialYTM,  
--  --'YTM',  
--  --d.Fecha AS [Fecha],  
--  --d.Nodo
--    d.Valor--,  
--  --d.TV,  
--  --d.Emisora,  
--  --d.Serie  
-- FROM   itblNodesYTMCatalog AS a (NOLOCK)  
 
--  RIGHT OUTER  JOIN  #tmpBus AS d (NOLOCK)  
--  ON A.intSerialYTM = d.Nodo 
  
  --LEFT    JOIN @itblNodesYTMLevels AS buff   
  --ON a.intSerialYTM = buff.intSerialYTM  
  
  --RIGHT     JOIN itblNodesYTMLevels AS b (NOLOCK)  
  --ON   
  -- a.intSerialYTM = b.intSerialYTM  
  -- AND buff.dteDate = b.dteDate  
  -- AND buff.dteTime = b.dteTime    
 --WHERE a.intSerialYTM = b.intSerialYTM  
 --AND  b.dteDate = @txtDate  
 --AND a.txtCategory = @txtCategory  
 --AND     a.fStatus = 1  
 --AND  c.dteMaturity >= @txtDate  




--SELECT  * FROM  #tblResults
----SELECT  *  FROM  #tmpBus
----SELECT  * FROM @itblNodesYTMLevels



/**/
/**/
/**/
/**/
 /*CODIGO PRUEBAS */
 IF OBJECT_ID('tempdb..#tmpBus')IS NOT NULL 
	DROP TABLE #tmpBus
	
	CREATE TABLE #tmpBus
	(
		dtedate DATETIME,
		txtterm INT,
		dbValue FLOAT,
		txtTV VARCHAR(10),
		txtEmisora VARCHAR(20),
		txtSerie VARCHAR(30),
		txtId1 VARCHAR(11),
		txtCategory varchar(50)
	)
	INSERT INTO #tmpBus
	Exec spi_encuestas_intradia;15  '20141008','CET'
	
--/*YTM'S*  completamente funcional */
	SELECT DISTINCT  
	Buff.intSerialYTM, 'YTM' AS txtType,b.dtedate ,b.txtterm,b.dbValue,b.txtTV,b.txtEmisora,b.txtSerie
	FROM  dbo.itblNodesYTMCatalog  AS A
		RIGHT JOIN #tmpBus AS B
		ON A.txtid1 = b.txtid1
		LEFT JOIN @itblNodesYTMLevels AS Buff
		ON a.intSerialYTM = buff.intSerialYTM  
		
		




 
 --SELECT * FROM @itblNodesZeroLevels
  --SELECT * FROM  itblNodesZeroCatalog
 /*ZERO´S*/
-- SELECT DISTINCT  Buff.intSerialZero AS intSerial, 'ZERO' AS txtType,
--  b.fecha AS dtedate 
--  ,b.Nodo AS txtterm ,b.valor AS dbValue,b.tv AS txtTV,b.emisora AS txtEmisora,b.Serie AS txtSerie
--FROM  dbo.itblNodesZeroCatalog  AS A
--right       JOIN #tmpBus AS B
--ON A.txtid1 = b.txtid1
--left   JOIN @itblNodesZeroLevels AS Buff
-- ON a.intSerialZero = buff.intSerialZero  
  
  
 
  
  
  
  
 --UNION  
  
 ---- reporte: nodos rangos  
 --SELECT  
 -- buff.intSerialZero,  
 -- 'ZERO',  
 -- b.dteDate AS [Fecha],  
 -- CASE WHEN fFix = 1 THEN  
 --  RTRIM(CAST(intBeg AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5)))  
 -- ELSE  
 --  CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5))),1,1) = '-' THEN  
 --   ''  
 --  ELSE  
 --   RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5)))  
 --  END  
 -- END AS [Nodo],  
 -- -- Si es FWD Redondeo si el nodo es mayor o igual a 720 (2 Años)  
 -- CASE WHEN @txtCategory = 'FWD' THEN  
 --  CASE WHEN  
 --   CASE WHEN fFix = 1 THEN  
 --    RTRIM(CAST(intBeg AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5)))  
 --   ELSE  
 --    CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5))),1,1) = '-' THEN  
 --     ''  
 --    ELSE  
 --     RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5)))  
 --    END  
 --   END >= 720 THEN ROUND(b.dblValue,3)  
 --   -- No redondeo si es menor a 720  
 --   ELSE b.dblValue  
 --  END  
 -- -- Sin redondeo si no es FWD  
 -- ELSE b.dblValue   
 -- END AS [Valor],  
 -- '' AS txtTV,  
 -- txtSubCategory AS txtEmisora,  
 -- '' AS txtSerie  
 --FROM    
 -- itblNodesZeroCatalog AS a (NOLOCK)  
 -- INNER JOIN @itblNodesZeroLevels AS buff   
 -- ON a.intSerialZero = buff.intSerialZero  
 -- INNER JOIN itblNodesZeroLevels AS b (NOLOCK)  
 -- ON   
 --  a.intSerialZero = b.intSerialZero  
 --  AND buff.dteDate = b.dteDate  
 --  AND buff.dteTime = b.dteTime  
 --WHERE b.dteDate <= @txtDate  
 --AND a.txtCategory = @txtCategory  
 --AND     a.fStatus = 1  
 --AND (  
 -- CASE WHEN fFix = 0 THEN  
 --  CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5))),1,1) = '-' THEN  
 --   0  
 --  ELSE  
 --   1  
 --  END  
 -- ELSE  
 --  1  
 -- END  
 -- ) = 1  
 --AND a.intPlazo = 2  
  
  

  
--UNION  
  
-- -- reporte: nodos puntuales  
-- SELECT  
--  buff.intSerialZero,  
--  'ZERO',  
--  b.dteDate AS [Fecha],  
--  CASE WHEN fFix = 1 THEN  
--   CASE  
--   WHEN a.txtUnit IS NULL THEN RTRIM(CAST(intBeg AS CHAR(5)))  
--   ELSE  
--    CASE a.txtUnit  
--    WHEN 'W' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, a.txtUnit, intBeg / 7) AS CHAR(5)))  
--    WHEN 'M' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, a.txtUnit, intBeg / 30) AS CHAR(5)))  
--    WHEN 'Y' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, a.txtUnit, intBeg / 360) AS CHAR(5)))  
--    ELSE RTRIM(CAST(intBeg AS CHAR(5)))  
--    END   
--   END   
--  ELSE  
--   CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))),1,1) = '-' THEN  
--    ''  
--   ELSE  
--    RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5)))   
--   END   
--  END AS [Nodo],  
--  -- Redondeo si es FWD para nodos mayores a 720 (2años)  
--  CASE WHEN @txtCategory = 'FWD' THEN  
--   CASE WHEN  
--    CASE WHEN fFix = 1 THEN  
--     CASE  
--     WHEN a.txtUnit IS NULL THEN RTRIM(CAST(intBeg AS CHAR(5)))  
--     ELSE  
--      CASE a.txtUnit  
--      WHEN 'W' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, a.txtUnit, intBeg / 7) AS CHAR(5)))  
--      WHEN 'M' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, a.txtUnit, intBeg / 30) AS CHAR(5)))  
--      WHEN 'Y' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, a.txtUnit, intBeg / 360) AS CHAR(5)))  
--      ELSE RTRIM(CAST(intBeg AS CHAR(5)))  
--      END   
--     END   
--    ELSE  
--     CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))),1,1) = '-' THEN  
--      ''  
--     ELSE  
--      RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5)))   
--     END   
--    -- Redondeo si es mayor a 720  
--    END >= 720 THEN ROUND(b.dblValue,5)  
--   -- No redondeo  
--   ELSE b.dblValue  
--   END  
--  -- No redondeo si no es FWD  
--  ELSE b.dblValue   
--  END AS [Valor],  
--  '' AS txtTV,  
--  txtSubCategory AS txtEmisora,  
--  '' AS txtSerie  
-- FROM    
--  itblNodesZeroCatalog AS a (NOLOCK)  
--  INNER JOIN @itblNodesZeroLevels AS buff   
--  ON a.intSerialZero = buff.intSerialZero  
--  INNER JOIN itblNodesZeroLevels AS b (NOLOCK)  
--  ON   
--   a.intSerialZero = b.intSerialZero  
--   AND buff.dteDate = b.dteDate  
--   AND buff.dteTime = b.dteTime  
-- WHERE b.dteDate <= @txtDate  
-- AND a.txtCategory = @txtCategory  
-- AND     a.fStatus = 1  
-- AND (  
--  CASE WHEN fFix = 0 THEN  
--   CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) ,1,1) = '-' THEN  
--    0  
--   ELSE  
--    1  
--   END  
--  ELSE  
--   1  
--  END  
--  ) = 1  
-- AND a.intPlazo = 1  
  
 --ORDER BY  
 -- Fecha  
  
  
  --UNION 
 
 /*CODIGO PRUEBAS */
-- IF OBJECT_ID('tempdb..#tmpBus')IS NOT NULL 
--DROP TABLE #tmpBus

--CREATE TABLE #tmpBus
--(
--Fecha DATETIME,
--Nodo INT,
--valor FLOAT,
--tv VARCHAR(10),
--Emisora VARCHAR(20),
--Serie VARCHAR(30),
--txtId1 VARCHAR(11),
--txtCategory varchar(50)
--)


--INSERT INTO #tmpBus
--Exec spi_encuestas_intradia;15  '20141008','CET'
--  SELECT * FROM #tblResults
----SELECT * FROM  #tmpBus


--SELECT  buff.intSerialYTM,'YTM',  b.fecha,b.Nodo,b.valor,a.intSerialYTM FROM  dbo.itblNodesYTMCatalog  AS A
--INNER    JOIN #tmpBus AS B
--ON A.intSerialYTM = B.Nodo 
--INNER  JOIN @itblNodesYTMLevels AS Buff
-- ON a.intSerialYTM = buff.intSerialYTM  
 
 
 

--SELECT * FROM  itblNodesYTMCatalog

--SELECT * FROM  #tmpBus







--WHERE txtCategory = 'cet' 

--SELECT TOP 10 * FROM  itblNodesZeroCatalog
--SELECT TOP 10 * FROM  itblNodesZeroLevels
 
 
 
/*FIN DE CODIGO DE PRUEBAS OACEVES*/
	
	
  
  --ORIGINAL 121
  
  

   --WHERE DTEDATE IN ('20141008','20141009')
   
   
  
  
  
-- INSERT #tblDatesNodes(  
--  dteDate,  
--  intSerial)  
    
-- SELECT DISTINCT  
--  d.dteDate,  
--  r.intSerial  
-- FROM #tblResults d, #tblResults r  
  
  
-- UPDATE d  
-- SET   
--  d.txtType = r.txtType,  
--  d.txtTerm = r.txtTerm,  
--  d.txtTv = r.txtTv,  
--  d.txtEmisora = r.txtEmisora,  
--  d.txtSerie = r.txtSerie  
-- FROM #tblDatesNodes d  
-- INNER JOIN #tblResults r  
-- ON  
--  d.intSerial = r.intSerial  
   
   
-- INSERT itblNodesYTMLevels(  
--  dteDate,  
--  intSerialYTM,  
--  dblValue,  
--  dblSpread,  
--  dblBid,  
--  dblAsk,  
--  dteTime)  
    
-- SELECT   
--  n.dteDate,  
--  n.intSerial,  
--  0,  
--  0,  
--  0,  
--  0,  
--  CONVERT(CHAR(8),GETDATE(),108)  
-- FROM #tblDatesNodes n  
-- LEFT OUTER JOIN #tblResults r  
-- ON  
--  n.intSerial = r.intSerial  
--  AND n.dteDate = r.dteDate  
-- WHERE  
--  r.intSerial IS NULL  
--  AND n.txtType = 'YTM'  
  
-- INSERT itblNodesZeroLevels(  
--  dteDate,  
--  intSerialZero,  
--  dblValue,  
--  dblSpread,  
--  dblBid,  
--  dblAsk,  
--  dteTime)  
    
-- SELECT   
--  n.dteDate,  
--  n.intSerial,  
--  0,  
--  0,  
--  0,  
--  0,  
--  CONVERT(CHAR(8),GETDATE(),108)  
-- FROM #tblDatesNodes n  
-- LEFT OUTER JOIN #tblResults r  
-- ON  
--  n.intSerial = r.intSerial  
--  AND n.dteDate = r.dteDate  
-- WHERE  
--  r.intSerial IS NULL  
--  AND n.txtType = 'ZERO'  
    
-- INSERT #tblResults(  
--  intSerial,  
--  txtType,  
--  dteDate,  
--  txtTerm,  
--  dblValue,  
--  txtTV,  
--  txtEmisora,  
--  txtSerie)  
  
-- SELECT   
--  n.intSerial,  
--  n.txtType,  
--  n.dteDate,  
--  n.txtTerm,  
--  0,  
--  n.txtTv,  
--  n.txtEmisora,  
--  n.txtSerie  
-- FROM #tblDatesNodes n  
-- LEFT OUTER JOIN #tblResults r  
-- ON  
--  n.intSerial = r.intSerial  
--  AND n.dteDate = r.dteDate  
-- WHERE  
--  r.intSerial IS NULL     
  
-- SET NOCOUNT OFF  
   
-- SELECT   
--  dteDate AS [Fecha],  
--  txtTerm AS [Nodo],  
--  dblValue AS [Valor],  
--  txtTV,  
--  txtEmisora,  
--  txtSerie  
-- FROM #tblResults  
-- ORDER BY  
--  dteDate   
----END  
  