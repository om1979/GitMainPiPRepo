      
/*         
 Autor:   JUNIOR        
 Creacion:  2005-10-24        
 Descripcion: Muestra con fines de Auditoria los Mejores Corros        
     y los Hechos por instrumento en el día que le manden.        
        
 Modificado por: Csolorio        
 Modificacion: 20120809        
 Descripcion: Agrego Auditoria de UMS        
        
        
 Modificado por: Omar Adrian Aceves Gutierrez        
 Modificacion: 20140826        
 Descripcion: se agrega nuevo campo a consulta para txtNote       
*/        
--CREATE     PROCEDURE dbo.spi_Auditoria_Licuadora;1      
 DECLARE 
 @txtDate AS CHAR(10)= '20150126',        
 @intPlazo AS INT =45,        
 @txtTv AS CHAR(11)= 'BI',        
 @intBanda AS INTEGER = 2        
       
 --DECLARE @txtDate AS CHAR(10) = '20141001'        
 --DECLARE @intPlazo AS INT  = 9542      
 --DECLARE @txtTv AS CHAR(11) ='S'      
 --DECLARE @intBanda AS INTEGER = 2       
      
      
 --AS       
 --BEGIN        
 --SET NOCOUNT ON         
         
 DECLARE @dteHoraCierre AS DATETIME        
 DECLARE @dteHoraBanda1 AS DATETIME        
 DECLARE @txtHoraBanda1 AS CHAR(8)        
        
 DECLARE @NomOfDates INT           
SET @NomOfDates = (select DATEDIFF(day,@txtDate,dbo.fun_NextTradingDate(@txtDate,2,'mx')))--fechas habiles           
 IF @intBanda = 1        
 BEGIN        
  SELECT @dteHoraBanda1 = DATEADD(second,1,dteHoraIniDia)        
  FROM itblParametrosLicuadora        
          
  SELECT @txtHoraBanda1 = CONVERT(CHAR(8),@dteHoraBanda1,108)        
        
  SET @dteHoraCierre = '14:00:00'        
        
 END        
 ELSE        
 BEGIN        
        
  SELECT @dteHoraBanda1 = DATEADD(second,1,dteHoraMatutino)        
  FROM itblParametrosLicuadora        
          
  SELECT @txtHoraBanda1 = CONVERT(CHAR(8),@dteHoraBanda1,108)        
          
  SELECT @dteHoraCierre = dteCloseHour        
  FROM itblClosesRandom        
  WHERE dteDate = @txtDate        
 END        
        
 ---Para cambiar de fuente la Banda_1        
 SELECT 'PONDERADO' AS txtBroker,        
  txtTv,        
  intPlazo AS intTerm,        
  'BANDA_1' AS txtOperation,        
  dblTasaFinal AS dblRate,        
  dblAmount,        
  '07:00:00' AS dteBeginHour,        
  @txtHoraBanda1 AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation ,      
  '' AS txtNote       
 INTO #tblOperacion        
 FROM itblPonderadoFinal        
 WHERE          
  dteDate = @txtDate        
  AND fStatus = 0        
  AND intPlazo = @intPlazo        
  AND txtTv = @txtTv        
 UNION        
         
 SELECT 'PONDERADO' AS txtBroker,        
  txtTv,        
  intPlazoIni AS intTerm,        
  'BANDA_1' AS txtOperation,        
  dblTasaFinal AS dblRate,        
  dblAmount,        
  '07:00:00' AS dteBeginHour,        
  @txtHoraBanda1 AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation ,      
  '' AS txtNote        
 FROM itblPonderadoFinalREV        
 WHERE          
  dteDate = @txtDate        
  AND fStatus = 0        
  AND intPlazoIni = @intPlazo        
  AND txtTv = @txtTv        
  --Hasta aqui busca BANDA_1        
        
 UNION        
       
      
 SELECT  c.txtBroker,        
  b.txtTv,        
  b.intPlazo AS intTerm,        
  b.txtOperation,        
  b.dblRate,        
  b.dblAmount,        
  CASE WHEN CONVERT(CHAR(8),b.dteBeginhour,108)  < @txtHoraBanda1 THEN    --oaceves  b.dteBeginhour  < @txtHoraBanda1     
   @txtHoraBanda1        
  ELSE        
   CONVERT(Char(8), b.dteBeginhour, 108)         
  END AS dteBeginHour,    
  CONVERT(Char(8), b.dteEndHour, 108) AS dteEndHour,     
      
  CASE WHEN CONVERT(CHAR(8),b.dteBeginhour,108)  < @txtHoraBanda1 THEN    --oaceves   dteBeginhour  < @txtHoraBanda1     
   DATEDIFF(MINUTE,@txtHoraBanda1,CONVERT(CHAR(8),dteEndHour,108))        
  ELSE        
   DATEDIFF(MINUTE,CONVERT(CHAR(8),b.dteBeginhour,108),CONVERT(CHAR(8),dteEndHour,108))        
  END AS intMinutes,        
  b.txtLiquidation ,      
  b.txtNote AS txtNote        
 FROM  itblMarketPositions AS b INNER JOIN itblBrokercatalog AS c        
  ON b.intIdBroker = c.intIdBroker        
 WHERE  b.dteDate = @txtDate        
  AND CONVERT(CHAR(8),dteEndHour,108) >= @dteHoraBanda1   --oaceves AND b.dteEndHour >= @txtHoraBanda1        
 AND b.intPlazo = @intPlazo        
 AND b.txtTv = @txtTv        
 AND b.dteBeginHour <= @dteHoraCierre       
     
  
     
 UNION        
 SELECT b.txtBroker,        
  i.txtTv,        
  i.intPlazo AS intTerm,        
  i.txtOperation,        
  i.dblRate,        
  i.dblAmount,        
  CASE WHEN i.dteBeginhour < @txtHoraBanda1 THEN        
   @txtHoraBanda1        
  ELSE        
   CONVERT(Char(8), i.dteBeginhour, 108)         
  END AS dteBeginHour,        
  CONVERT(Char(8), i.dteEndHour, 108) AS dteEndHour,        
  0 AS intMinutes,        
  i.txtLiquidation,      
  i.txtNote AS txtNote        
 FROM  itblMarketPositions AS i INNER JOIN itblBrokerCatalog AS b        
  ON i.intIdBroker = b.intIdBroker        
 WHERE  dteDate = @txtDate        
 AND i.txtOperation NOT IN ('COMPRA','VENTA')        
 AND dteBeginHour >= @txtHoraBanda1        
 AND dteEndHour <= @dteHoraCierre        
 AND intPlazo = @intPlazo        
 AND txtTv = @txtTv        
         
 UNION        
         
 SELECT b.txtBroker,        
  i.txtTv,        
  i.intPlazo AS intTerm,        
  i.txtOperation,        
  i.dblRate,        
  i.dblAmount,        
  CASE WHEN i.dteBeginhour < @txtHoraBanda1 THEN        
   @txtHoraBanda1        
  ELSE        
   CONVERT(Char(8), i.dteBeginhour, 108)         
  END AS dteBeginHour,        
  CONVERT(Char(8), i.dteEndHour, 108) AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation ,      
   '' AS txtNote      
 FROM  itblChoice AS i INNER JOIN itblBrokerCatalog AS b        
  ON i.intIdBroker = b.intIdBroker        
 WHERE  dteDate = @txtDate        
 AND i.txtOperation NOT IN ('COMPRA','VENTA')        
 AND dteEndHour >= @txtHoraBanda1        
 AND dteEndHour <= @dteHoraCierre        
 AND intPlazo = @intPlazo        
 AND txtTv = @txtTv        
        
 UNION          
 --se agregan subastas ;1 solo para cetes y bonos        
 -- TIPOS DE VALOR M BI        
 SELECT  'SUBASTA' AS txtBroker,        
  '' as txtTv,        
  DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intTerm,        
  'SUBASTA' AS txtOperation,        
  r.dblPrice AS dblRate,        
  r.dblAmount AS dblAmount,        
  CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,        
  CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation,      
  '' AS txtNote        
 FROM tblBondsPricesRange AS r,        
  tblIds AS i INNER JOIN tblBonds AS b        
  ON i.txtId1 = b.txtId1        
 WHERE r.dteDate  = @txtDate        
 AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)+   @NomOfDates             
 AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)-   @NomOfDates--fechas habiles           
 AND  @INTPLAZO <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)+  @NomOfDates--fechas habiles           
 AND  @INTPLAZO >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)-  @NomOfDates          
 AND i.txtTv = @txtTv        
 AND R.txtType = (CASE WHEN @txtTv = 'BI' THEN 'WET'         
    WHEN @txtTv IN ('M','M3','M5','M7','M0') THEN 'CET'        
    END
    
    
    )        
 UNION        
 -- para udis        
 SELECT  'SUBASTA' AS txtBroker,        
  i.txtTv,        
  DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intPlazo,        
  'SUBASTA' AS txtOperation,        
  r.dblPrice AS dblRate,        
  r.dblAmount * ir.dblValue AS dblAmount,        
  CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,        
  CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation,      
  '' AS txtNote        
 FROM tblBondsPricesRange AS r,        
  tblIds AS i INNER JOIN tblBonds AS b        
  ON i.txtId1 = b.txtId1,        
  tblIRC AS ir        
 WHERE r.dteDate  = @txtDate        
 AND  ir.dteDate = r.dteDate        
 AND  ir.txtIrc = 'UDI'        
 AND r.txtType = 'UDB'        
 AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
 AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
 AND  @INTPLAZO <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)+4        
 AND  @INTPLAZO >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)-4        
 AND  i.txtTv IN ('S','S0','PI','2U')        
         
 UNION        
 --SE AGERGA SUBASTA PARA LD        
 SELECT DISTINCT        
  'SUBASTA' AS txtBroker,        
  @txtTv as txttv,        
  @intPlazo AS intTerm,        
  'SUBASTA' AS txtOperation,        
  r.dblPrice AS dblRate,        
  r.dblAmount AS dblAmount,        
  CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,        
  CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation,      
  '' AS txtNote        
 FROM tblBondsPricesRange AS r,        
  tblIds AS i INNER JOIN tblBonds AS b        
  ON i.txtId1 = b.txtId1        
 WHERE r.dteDate  = @txtDate        
 AND r.txtType = 'BDE'        
 AND r.txtSubType Like 'XA'        
 AND  i.txtTv IN ('LD')        
 AND i.txtTv = @txtTv        
 AND @intPlazo <= DATEDIFF(DAY, @txtDate, b.dteMaturity)        
 AND @intPlazo >= DATEDIFF(DAY, @txtDate, b.dteMaturity)        
 AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
 AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)         
 ORDER BY         
  intTerm,         
  dteBeginHour        
         
 IF  @TXTTV  IN ('IT','IP','IS','IM','IQ')        
 BEGIN        
  INSERT INTO #tblOperacion        
  SELECT  'PONDERADO' AS txtBroker,        
   txtTv,        
   @intPlazo,        
   'BANDA_1' AS txtOperation,        
   dblTasaFinal AS dblRate,        
   dblAmount,        
   '07:00:00' AS dteBeginHour,        
   @txtHoraBanda1 AS dteEndHour,        
   0 AS intMinutes,        
   '---' AS txtLiquidation,      
   '' AS txtNote        
  FROM itblTasasRevLicuadasIG        
  WHERE  fStatus = 0        
  AND intPlazoIni = @intPlazo        
  AND intPlazoFin = @intPlazo        
  AND txtTv = @txtTv        
  AND  CONVERT(VARCHAR(10),getdate(),112) = @txtDate        
  UNION        
  SELECT  c.txtBroker,        
   b.txtTv,        
   @intPlazo,        
   b.txtOperation,        
   b.dblRate,        
   b.dblAmount,        
   CASE WHEN b.dteBeginhour < @txtHoraBanda1 THEN        
    @txtHoraBanda1        
   ELSE        
    CONVERT(Char(8), b.dteBeginhour, 108)         
   END AS dteBeginHour,        
   CONVERT(Char(8), b.dteEndHour, 108) AS dteEndHour,        
   CASE WHEN b.dteBeginhour < @txtHoraBanda1 THEN        
    DATEDIFF(MINUTE,@txtHoraBanda1,b.dteEndHour)        
   ELSE        
    DATEDIFF(MINUTE,b.dteBeginHour,b.dteEndHour)        
   END AS intMinutes,        
   b.txtLiquidation,       
   '' AS txtNote       
  FROM  itblMarketPositionsRevi AS b INNER JOIN itblBrokercatalog AS c        
   ON b.intIdBroker = c.intIdBroker        
  WHERE  b.dteDate = @txtDate        
  AND b.dteEndHour >= @txtHoraBanda1        
  AND b.intPlazoIni <= @intPlazo        
  AND b.intPlazoFin >= @intPlazo        
  AND b.txtTv = @txtTv        
  AND b.dteBeginHour <= @dteHoraCierre        
        
  UNION        
        
  SELECT  'SUBASTA' AS txtBroker,        
   @txtTv as txtTv,        
   @intPlazo AS intPlazo,        
   'SUBASTA' AS txtOperation,        
   r.dblPrice AS dblRate,        
   r.dblAmount AS dblAmount,        
   CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,        
   CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,        
   0 AS intMinutes,        
   '---' AS txtLiquidation,      
   '' AS txtNote        
  FROM tblBondsPricesRange AS r,        
   tblIds AS i INNER JOIN tblBonds AS b        
   ON i.txtId1 = b.txtId1        
  WHERE r.dteDate  = @txtDate        
  AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
  AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
  AND I.txtTv=@txtTv        
  AND  @intPlazo <= DATEDIFF(DAY, b.dteIssued, b.dteMaturity)        
  AND  @intPlazo >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
  AND R.txtType = (CASE WHEN @txtTv = 'XA' THEN 'XA'         
       WHEN @txtTv = 'LD' THEN 'BDE'         
       WHEN @txtTv = 'LS' THEN 'BDI'         
        END)        
  UNION        
  --REVISABLES bps bpa bpt        
  SELECT 'SUBASTA' AS txtBroker,        
   @txtTv as txtTv,        
   @intPlazo AS intPlazoIni,        
   'SUBASTA' AS txtOperation,        
   r.dblPrice AS dblRate,        
   r.dblAmount AS dblAmount,        
   CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,        
   CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,        
   0 AS intMinutes,        
   '---' AS txtLiquidation,      
   '' AS txtNote        
  FROM tblBondsPricesRange AS r,        
   itblNodesZeroCatalog as c        
  WHERE r.dteDate  =@txtdate        
  AND R.txtType = (CASE WHEN @txtTv = 'IS' THEN 'BPS'        
       WHEN @txtTv = 'IT' THEN 'BPT'        
       WHEN @txtTv = 'IP' THEN 'BPA'        
       WHEN @txtTv = 'IM' THEN 'BGA'        
       WHEN @txtTv = 'IQ' THEN 'BGT'        
        END)        
  AND C.txtsubcategory = (CASE WHEN @txtTv = 'IS' THEN 'BPS'        
       WHEN @txtTv = 'IT' THEN 'BPT'        
       WHEN @txtTv = 'IP' THEN 'IPB'        
       WHEN @txtTv = 'IM' THEN 'BGA'        
       WHEN @txtTv = 'IQ' THEN 'BGT'        
        END)        
  AND c.intBeg<=r.intBeg        
  AND c.intEnd>=r.intEnd        
  AND @intPlazo <=r.intBeg        
  AND @intPlazo >=r.intEnd        
  AND c.fstatus = '1'        
  ORDER by         
   dteBeginHour,        
   dteEndHour        
 END        
        
 IF @txtTV IN ('D1')        
        
 BEGIN        
          
  INSERT #tblOperacion        
  SELECT          
   e.txtSource,        
   @txtTv,        
   @intPlazo,        
   e.txtOperation,        
   e.dblPrice,        
   e.dblAmount,        
   CONVERT(Char(8), e.dteBeginhour, 108),         
   CONVERT(Char(8), e.dteEndHour, 108),        
   0 AS intMinutes,        
   'NA',      
   ''        
  FROM itblMarketPositionsEuros e (NOLOCK)        
  INNER JOIN tblIds i (NOLOCK)        
  ON        
   e.txtId1 = i.txtId1        
  INNER JOIN tblBonds b (NOLOCK)        
  ON        
   e.txtId1 = b.txtId1        
  WHERE        
   e.dteDate = @txtDate        
   AND DATEDIFF(d,@txtDate,b.dteMaturity) = @intPlazo        
   AND i.txtTv = @txtTv        
        
 END        
        
 SET NOCOUNT ON        
        
 IF (SELECT COUNT(intTerm)        
     FROM   #tblOperacion) = 0        
 BEGIN        
          
          
  SET NOCOUNT ON        
        
  SELECT  c.txtBroker,        
   b.txtTv,        
   b.intPlazo AS intTerm,        
   b.txtOperation,        
   b.dblRate,        
   b.dblAmount,        
   CASE WHEN b.dteBeginhour < @txtHoraBanda1 THEN        
    @txtHoraBanda1        
   ELSE        
    CONVERT(Char(8), b.dteBeginHour, 108)        
   END AS dteBeginHour,        
   CONVERT(Char(8), b.dteEndHour, 108) AS dteEndHour,        
   CASE WHEN b.dteBeginhour < @txtHoraBanda1 THEN        
    DATEDIFF(MINUTE,@txtHoraBanda1,b.dteEndHour)        
   ELSE        
    DATEDIFF(MINUTE,b.dteBeginHour,b.dteEndHour)        
   END AS intMinutes,        
   b.txtLiquidation,        
   b.txtNote AS txtNote      
  INTO #tblOperacionMatutina        
  FROM  itblMarketPositions AS b INNER JOIN itblBrokercatalog AS c        
   ON b.intIdBroker = c.intIdBroker        
  WHERE  b.dteDate = @txtDate        
  AND b.intPlazo = @intPlazo        
  AND b.txtTv = @txtTv        
  ANd b.dteEndHour <= @txtHoraBanda1        
          
  UNION        
          
  SELECT b.txtBroker,        
   i.txtTv,        
   i.intPlazo AS intTerm,        
   i.txtOperation,        
   i.dblRate,        
   i.dblAmount,        
   CONVERT(Char(8), i.dteBeginhour, 108) AS dteBeginHour,        
   CONVERT(Char(8), i.dteEndHour, 108) AS dteEndHour,        
   0 AS intMinutes,        
   i.txtLiquidation,      
   i.txtNote AS txtNote        
  FROM  itblMarketPositions AS i INNER JOIN itblBrokerCatalog AS b        
   ON i.intIdBroker = b.intIdBroker        
  WHERE  dteDate = @txtDate        
  AND i.txtOperation NOT IN ('COMPRA','VENTA')        
  AND intPlazo = @intPlazo        
  AND txtTv = @txtTv        
  ORDER BY         
   intTerm,         
   dteBeginHour        
        
  SET NOCOUNT OFF        
        
  IF (SELECT COUNT(intTerm)        
      FROM   #tblOperacionMatutina) = 0        
  BEGIN        
           
   SET NOCOUNT ON        
        
  SELECT *
   FROM itblNodesYTMCatalog AS n INNER JOIN itblNodesYTMLevels AS l        
    ON n.intSerialYTM = l.intSerialYTM        
    INNER JOIN tblBonds AS b        
    ON n.txtId1 = b.txtId1        
    INNER JOIN tblIds AS i        
    ON b.txtId1 = i.txtId1        
   WHERE  DATEDIFF(DAY,@txtDate,b.dteMaturity) = @intPlazo        
   AND i.txtTv = @txtTv        
   AND l.dteDate =  (        
      SELECT MAX(l.dteDate)        
      FROM itblNodesYTMLevels AS l INNER JOIN itblNodesYTMCatalog AS n        
       ON  l.intSerialYTM = n.intSerialYTM        
       INNER JOIN tblIds AS i        
       ON n.txtId1 = i.txtId1        
      WHERE i.txtTv = @txtTv        
      )        
   
   
   --sp_helptrigger itblNodesYTMLevels
   --sp_helptext tgr_YTMLevels_Binnacle
   --SELECT * FROM     itblMarketBinnacle  
   --WHERE txtProceso = 'CET/CETI'
   --AND dteDate = '20150126'
         
   SET NOCOUNT OFF        
           
  END        
  ELSE        
  BEGIN        
   SELECT @txtDate AS txtDate,        
    txtBroker,        
    txtTv,        
    intTerm,        
    txtOperation,        
    STR(dblRate,10,4) AS dblRate,        
    dblAmount/1000000 as dblAmount,        
    dteBeginHour,        
    dteEndHour,        
    intMinutes,        
    txtLiquidation,      
    txtNote        
   FROM #tblOperacionMatutina        
   ORDER BY         
    dteBeginHour        
        
  END        
 END        
 ELSE        
 BEGIN        
  SELECT @txtDate AS txtDate,        
   txtBroker,        
   txtTv,        
   intTerm,        
   txtOperation,        
   STR(dblRate,10,4) AS dblRate,        
   dblAmount/1000000 as dblAmount,        
   dteBeginHour,        
   dteEndHour,        
   intMinutes,        
   txtLiquidation,      
   ISNULL(txtnote,'')      
  FROM #tblOperacion        
  ORDER BY         
   dteBeginHour        
 END        
--END       
  
  
--  select *
--from ITBLMARKETPOSITIONS
--where txtTv='bi'
--and dteDate ='20150126'
--and txtOperation='hecho'
--and intPlazo='80'
    


  SELECT * FROM  dbo.itblMarketPositions AS IMP
  WHERE intIdBroker = 10
  AND dteDate = '20150126'
AND txtTv = 'BI'

    SELECT * FROM  dbo.itblPonderado AS IP
  WHERE 
   dteDate = '20150126'
   AND txtTv = 'BI'
   
   
   SELECT * FROM  dbo.itblPonderadoFinal AS IPF
     WHERE 
   dteDate = '20150126'
   AND txtTV = 'bi'

   
--     SELECT * FROM     itblMarketBinnacle  
--   WHERE txtProceso = 'CET/CETI'
--   AND dteDate = '20150126'
--   ORDER BY 3
   
   
   
   --SELECT * FROM  dbo.itblNodesYTMLevels AS INYL
   --INNER JOIN dbo.itblNodesYTMCatalog AS INYC
   --ON INYL.intSerialYTM = INYC.intSerialYTM
   --INNER JOIN dbo.tblIds AS TI
   --ON INYC.txtId1 = TI.txtID1
   --   WHERE dteDate = '20150126'
   --   AND txtCategory = 'CET'
   --   AND txtSubCategory = 'CETI'
   --   AND txtTV = 'bi'
   --   AND txtSerie = '150312'