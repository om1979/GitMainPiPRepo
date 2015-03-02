      
/*         
 Autor:   JUNIOR        
 Creacion:  2005-10-24        
 Descripcion: Muestra con fines de Auditoria los Mejores Corros        
     y los Hechos por instrumento en el d�a que le manden.        
        
 Modificado por: Csolorio        
 Modificacion: 20120809        
 Descripcion: Agrego Auditoria de UMS        
        
        
 Modificado por: Omar Adrian Aceves Gutierrez        
 Modificacion: 20140826        
 Descripcio
 
 n: se agrega nuevo campo a consulta para txtNote       
*/      


	
	dbo.spi_Auditoria_Licuadora;1  '20141205','1049','LD' ,1
	
	
	
	
	
		dbo.spi_Auditoria_Licuadora;1  '20141205','1049','s' ,1
		
		
		
		
		
  
CREATE     PROCEDURE dbo.spi_Auditoria_Licuadora;1  '20141205','2925','2U' ,1
 @txtDate AS CHAR(10),        
 @intPlazo AS INT,        
 @txtTv AS CHAR(11),        
 @intBanda AS INTEGER = 2        
       
 DECLARE @txtDate AS CHAR(10) = '20141205'        
 DECLARE @intPlazo AS INT  = 1105      
 DECLARE @txtTv AS CHAR(11) =     
 DECLARE @intBanda AS INTEGER = 2       
      
      
 AS       
 BEGIN        
 SET NOCOUNT ON         
         
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
  @txtTv as txtTv,        
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
    END)        
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
        
   SELECT @txtDate AS txtDate,        
    'PIP' AS txtBroker,        
    i.txtTv,        
    DATEDIFF(DAY,@txtDate,b.dteMaturity) AS intTerm,        
    'DATO_ANTERIOR' AS txtOperation,        
    l.dblValue,        
    0 AS dblAmount,        
    '00:00:00' AS dteBeginHour,        
    '00:00:00' AS dteEndHour,        
    0 AS intMinutes,        
    '---' AS txtLiquidation,      
    '' AS txtNote        
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
   ORDER BY         
    dteBeginHour        
        
         
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
END       
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;2    
AS    
/*     
 Autor:   ???    
 Creacion:  ???    
 Descripcion: Esquema Audita Nodo    
    
 Modificado por: Csolorio    
 Modificacion: 20120814    
 Descripcion: Convierto plazo a flotante    
*/     
BEGIN    
    
 SELECT TOP 0    
  '20060208' AS txtDate,    
  'txtBroker' AS txtBroker,    
  'txttv' AS txtTv,    
  1 AS dblTerm,    
  'txtOperation' AS txtOperation,    
  '1.1' AS dblRate,    
  1.1 AS dblAmount,    
  '20051025' AS dteBeginHour,    
  '20051025' AS dteEndHour,    
  -999 AS intMinutes,    
  '24H' AS txtLiquidation,   
  'txtNote' AS txtNote   
    
    
END    
    
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;3    
 @txtDate AS CHAR(10),    
 @txtType AS CHAR(3)    
AS     
/*     
 Autor:   ???    
 Creacion:  ???    
 Descripcion:    Para mostrar archivos de brokers y sus horas de deteccion y carga    
    
 Modificado por: Ivan Aguilar S    
 Modificacion: 20130912  
 Descripcion: Se Incluye Licuadora Intradia IRS (IIR)    
*/    
BEGIN    
 SET ANSI_WARNINGS OFF    
 SET NOCOUNT ON    
    
 --DROP TABLE #tblProcesses  
 --DROP TABLE #tblData  
 --DROP TABLE #tmpRegLoad   
 --DROP TABLE #tmpRegLoadOld  
 --DROP TABLE #tmpMAX  
 --DROP TABLE #tmpMAXOLD  
    
 --DECLARE @txtDate AS CHAR(10)    
 --DECLARE @txtType AS CHAR(3)    
   
 --SET @txtDate = '20130522'  
 --SET @txtType = 'GUB'  
     
 DECLARE @dteCloseHour AS DATETIME    
 DECLARE @dteTime AS DATETIME  
    
 SELECT @dteTime = CONVERT(VARCHAR(8),GETDATE(),108)    
 SELECT @dteCloseHour = dteCloseHour + '00:15:00.000' FROM mxFixIncome..itblClosesRandomParameters    
      
 CREATE TABLE #tblProcesses (    
  txtName VARCHAR(50),    
  txtDevil VARCHAR(30),    
  txtProcess VARCHAR(30),  
  intIdBroker INT    
  PRIMARY KEY (txtName,txtDevil,txtProcess))  
  
 CREATE TABLE #tmpRegLoad (  
  intIdBroker INT,  
  intCount INT,  
  dteDate DATETIME  
  PRIMARY KEY (intIdBroker))  
  
 CREATE TABLE #tmpRegLoadOld (  
  intIdBroker INT,  
  intCount INT,  
  dteDate DATETIME  
  PRIMARY KEY (intIdBroker))     
     
  CREATE TABLE #tmpMAX (  
  txtProcess VARCHAR(30),  
  dteDate DATETIME  
  PRIMARY KEY(txtProcess)  
  )  
    
  CREATE TABLE #tmpMAXOLD (  
  txtProcess VARCHAR(30),  
  dteDate DATETIME  
  PRIMARY KEY(txtProcess)  
  )   
     
 IF @txtType = 'GUB'    
 BEGIN    
  INSERT INTO #tblProcesses VALUES('Operaciones Enlace','FILE_INPUT_ENLACE_CORROS','ENLACE_O',1)    
  INSERT INTO #tblProcesses VALUES('Camas Enlace','NOTIFY_INPUT_ENLACE_CAMAS','ENLACE_CA',1)    
  INSERT INTO #tblProcesses VALUES('Posturas Remate','NOTIFY_INPUT_REMATE_POSTURAS','REMATE_P',3)    
  INSERT INTO #tblProcesses VALUES('Hechos Remate','NOTIFY_INPUT_REMATE_HECHOS','REMATE_H',3)    
  INSERT INTO #tblProcesses VALUES('Operaciones Eurobrokers','FILE_INPUT_EUROB_POSTURES','EUROB_O',2)    
  INSERT INTO #tblProcesses VALUES('Posturas Sif','FILE_INPUT_SIF_POSTURE','SIF_P',4)    
  INSERT INTO #tblProcesses VALUES('Hechos Sif','FILE_INPUT_SIF_FACT','SIF_H',4)    
  INSERT INTO #tblProcesses VALUES('Posturas MEI','FILE_INPUT_MEI_POSTURES','MEI_P',5)    
  INSERT INTO #tblProcesses VALUES('Hechos MEI','FILE_INPUT_MEI_FACTS','MEI_H',5)    
  INSERT INTO #tblProcesses VALUES('Posturas Var','NOTIFY_INPUT_VAR_POSTURAS','VAR_P',7)    
  INSERT INTO #tblProcesses VALUES('Hechos Var','NOTIFY_INPUT_VAR_HECHOS','VAR_H',7)    
  INSERT INTO #tblProcesses VALUES('Hechos Tradition','FILE_INPUT_TRADITION_FACTS','TRADITION_H',6)    
  INSERT INTO #tblProcesses VALUES('Posturas Tradition','FILE_INPUT_TRADITION_POSTURES','TRADITION_P',6)  
  INSERT INTO #tblProcesses VALUES('Posturas MEI SNAFIN','FILE_INPUT_MEI_NEW','MEI_PS',8)  
  INSERT INTO #tblProcesses VALUES('Hechos MEI SNAFIN','FILE_INPUT_MEI_NEW_2','MEI_HS',8)  
   
  INSERT INTO #tmpRegLoad  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate),  
 MAX(m.dteDate)  
  FROM itblMarketPositions m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = @txtDate  
  GROUP BY  
 c.intIdBroker  
  
  INSERT INTO #tmpRegLoadOld  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate),  
 MAX(m.dteDate)  
  FROM itblMarketPositions m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
  GROUP BY  
 c.intIdBroker  
      
 END    
     
 IF @txtType = 'IRS'    
 BEGIN    
  INSERT INTO #tblProcesses VALUES('Operaciones Enlace IRS','FILE_INPUT_ENLACE_CORROS','ENLACE_O_IRS',1)    
  INSERT INTO #tblProcesses VALUES('Operaciones Eurobrokers IRS','FILE_INPUT_EUROB_POSTURES','EUROB_O_IRS',2)    
  INSERT INTO #tblProcesses VALUES('Posturas ICAP IRS','FILE_INPUT_ICAP_POSTURES','ICAP_P_IRS',8)    
  INSERT INTO #tblProcesses VALUES('Hechos ICAP IRS','FILE_INPUT_ICAP_FACTS','ICAP_H_IRS',8)    
  INSERT INTO #tblProcesses VALUES('Posturas Tullet IRS','FILE_INPUT_TULLET_POSTURES','TULLET_P_IRS',10)   
 INSERT INTO #tblProcesses VALUES('Hechos Tullet IRS','FILE_INPUT_TULLET_FACTS','TULLET_H_IRS',10)    
  INSERT INTO #tblProcesses VALUES('Posturas Remate IRS','NOTIFY_INPUT_REMATE_POSTURAS','REMATE_P_IRS',3)    
  INSERT INTO #tblProcesses VALUES('Hechos Remate IRS','NOTIFY_INPUT_REMATE_HECHOS','REMATE_H_IRS',3)    
  INSERT INTO #tblProcesses VALUES('Posturas Tradition IRS','FILE_INPUT_TRADITION_IRS_POST','TRADITION_P_IRS',6)    
  INSERT INTO #tblProcesses VALUES('Hechos Tradition IRS','FILE_INPUT_TRADITION_IRS_FACTS','TRADITION_H_IRS',6)    
  INSERT INTO #tblProcesses VALUES('Posturas VAR IRS','NOTIFY_INPUT_VAR_POSTURAS','VAR_P_IRS',7)    
  INSERT INTO #tblProcesses VALUES('Hechos VAR IRS','NOTIFY_INPUT_VAR_HECHOS','VAR_H_IRS',7)   
  INSERT INTO #tblProcesses VALUES('Hechos TradNS IRS','FILE_INPUT_TRAD_NS_IRS_FACTS','TRAD_NS_H_IRS',6)  
  INSERT INTO #tblProcesses VALUES('Posturas TradNS IRS','FILE_INPUT_TRAD_NS_IRS_POST','TRAD_NS_P_IRS',6)   
   
  INSERT INTO #tmpRegLoad  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsDerivatives m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = @txtDate  
  GROUP BY  
 c.intIdBroker  
  
  INSERT INTO #tmpRegLoadOld  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsDerivatives m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
  GROUP BY  
 c.intIdBroker  
   
 END    
    
 IF @txtType = 'REV'    
 BEGIN    
  INSERT INTO #tblProcesses VALUES('Operaciones Enlace Revisables','FILE_INPUT_ENLACE_CORROS','ENLACE_O_REV',1)    
  INSERT INTO #tblProcesses VALUES('Operaciones Eurobrokers Revisables','FILE_INPUT_EUROB_POSTURES','EUROB_O_REV',2)    
  INSERT INTO #tblProcesses VALUES('Posturas Sif Revisables','FILE_INPUT_SIF_POSTURE','SIF_P_REV',4)    
  INSERT INTO #tblProcesses VALUES('Hechos Sif Revisables','FILE_INPUT_SIF_FACT','SIF_H_REV',4)    
  INSERT INTO #tblProcesses VALUES('Posturas MEI Revisables','FILE_INPUT_MEI_POSTURES','MEI_P_REV',5)    
  INSERT INTO #tblProcesses VALUES('Hechos MEI Revisables','FILE_INPUT_MEI_FACTS','MEI_H_REV',5)    
  INSERT INTO #tblProcesses VALUES('Posturas Var Revisables','NOTIFY_INPUT_VAR_POSTURAS','VAR_P_REV',7)    
  INSERT INTO #tblProcesses VALUES('Hechos Var Revisables','NOTIFY_INPUT_VAR_HECHOS','VAR_H_REV',7)    
  INSERT INTO #tblProcesses VALUES('Posturas Remate Revisables','NOTIFY_INPUT_REMATE_POSTURAS','REMATE_P_REV',3)    
  INSERT INTO #tblProcesses VALUES('Hechos Remate Revisables','NOTIFY_INPUT_REMATE_HECHOS','REMATE_H_REV',3)    
  INSERT INTO #tblProcesses VALUES('Posturas Tradition Revisables','FILE_INPUT_TRADITION_POSTURES','TRADITION_P_REV',6)    
  INSERT INTO #tblProcesses VALUES('Hechos Tradition Revisables','FILE_INPUT_TRADITION_FACTS','TRADITION_H_REV',6)    
  
  INSERT INTO #tmpRegLoad  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsRevi m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = @txtDate  
  GROUP BY  
 c.intIdBroker  
  
  INSERT INTO #tmpRegLoadOld  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsRevi m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
  GROUP BY  
 c.intIdBroker  
  
 END    
    
 IF @txtType = 'PRV'    
 BEGIN    
  INSERT INTO #tblProcesses VALUES('Operaciones Enlace Privados','FILE_INPUT_ENLACE_CORROS','ENLACE_O_PRV',1)    
  INSERT INTO #tblProcesses VALUES('Operaciones Eurobrokers Privados','FILE_INPUT_EUROB_POSTURES','EUROB_O_PRV',2)    
  INSERT INTO #tblProcesses VALUES('Posturas Sif Privados','FILE_INPUT_SIF_P_PRV','SIF_P_PRV',4)    
  INSERT INTO #tblProcesses VALUES('Hechos Sif Privados','FILE_INPUT_SIF_H_PRV','SIF_H_PRV',4)    
  INSERT INTO #tblProcesses VALUES('Posturas MEI Privados','FILE_INPUT_MEI_POSTURES','MEI_P_PRV',5)    
  INSERT INTO #tblProcesses VALUES('Hechos MEI Privados','FILE_INPUT_MEI_FACTS','MEI_H_PRV',5)    
  INSERT INTO #tblProcesses VALUES('Posturas Var Privados','NOTIFY_INPUT_VAR_POSTURAS','VAR_P_PRV',7)    
  INSERT INTO #tblProcesses VALUES('Hechos Var Privados','NOTIFY_INPUT_VAR_HECHOS','VAR_H_PRV',7)    
  INSERT INTO #tblProcesses VALUES('Posturas Tradition Privados','FILE_INPUT_TRADITION_POST_PRV','TRADITION_P_PRV',6)    
  INSERT INTO #tblProcesses VALUES('Hechos Tradition Privados','FILE_INPUT_TRADITION_FACTS_PRV','TRADITION_H_PRV',6)    
  INSERT INTO #tblProcesses VALUES('Posturas Remate Privados','NOTIFY_INPUT_REMATE_POSTURAS','REMATE_P_PRV',3)    
  INSERT INTO #tblProcesses VALUES('Hechos Remate Privados','NOTIFY_INPUT_REMATE_HECHOS','REMATE_H_PRV',3)    
   
  INSERT INTO #tmpRegLoad  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate),  
 MAX(m.dteDate)  
  FROM itblMarketPositionsPrivates m  
   INNER JOIN itblBrokerCatalog c  
   ON  
 m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = @txtDate  
  GROUP BY  
 c.intIdBroker  
  
  INSERT INTO #tmpRegLoadOld  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate),  
 MAX(m.dteDate)  
  FROM itblMarketPositionsPrivates m  
   INNER JOIN itblBrokerCatalog c  
   ON  
 m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
  GROUP BY  
 c.intIdBroker  
   
 END    
    
 IF @txtType = 'INT'    
 BEGIN    
   
  INSERT INTO #tblProcesses VALUES('Operaciones Enlace','FILE_INPUT_ENLACE_CORROS','ENLACE_O',1)    
  INSERT INTO #tblProcesses VALUES('Posturas Remate','NOTIFY_INPUT_REMATE_POSTURAS','REMATE_P',3)    
  INSERT INTO #tblProcesses VALUES('Hechos Remate','NOTIFY_INPUT_REMATE_HECHOS','REMATE_H',3)    
  --INSERT INTO #tblProcesses VALUES('Operaciones Eurobrokers','FILE_INPUT_EUROB_POSTURES','EUROB_O',2)    
  INSERT INTO #tblProcesses VALUES('Posturas MEI','FILE_INPUT_MEI_POSTURES','MEI_P',5)    
  INSERT INTO #tblProcesses VALUES('Hechos MEI','FILE_INPUT_MEI_FACTS','MEI_H',5)   
  INSERT INTO #tblProcesses VALUES('Posturas Sif','FILE_INPUT_SIF_POSTURE','SIF_P',4)    
  INSERT INTO #tblProcesses VALUES('Hechos Sif','FILE_INPUT_SIF_FACT','SIF_H',4)    
  INSERT INTO #tblProcesses VALUES('Posturas Var','NOTIFY_INPUT_VAR_POSTURAS','VAR_P',7)    
  INSERT INTO #tblProcesses VALUES('Hechos Var','NOTIFY_INPUT_VAR_HECHOS','VAR_H',7)    
  
  
   
   
  INSERT INTO #tmpRegLoad  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositions m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = @txtDate  
  GROUP BY  
 c.intIdBroker  
  
  INSERT INTO #tmpRegLoadOld  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositions m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
  GROUP BY  
 c.intIdBroker  
   
 END    
   
 IF @txtType = 'IIR'    
 BEGIN    
  INSERT INTO #tblProcesses VALUES('Operaciones Enlace IRS','FILE_INPUT_ENLACE_CORROS','ENLACE_O_IRS',1)    
  --INSERT INTO #tblProcesses VALUES('Operaciones Eurobrokers IRS','FILE_INPUT_EUROB_POSTURES','EUROB_O_IRS',2)    
  INSERT INTO #tblProcesses VALUES('Posturas ICAP IRS','FILE_INPUT_ICAP_POST_1','ICAP_P_IRS',8)    
  INSERT INTO #tblProcesses VALUES('Hechos ICAP IRS','FILE_INPUT_ICAP_HECHOS_1','ICAP_H_IRS',8)    
  INSERT INTO #tblProcesses VALUES('Posturas Tullet IRS','FILE_INPUT_TULLET_POSTURES','TULLET_P_IRS',10)    
  INSERT INTO #tblProcesses VALUES('Hechos Tullet IRS','FILE_INPUT_TULLET_FACTS','TULLET_H_IRS',10)    
  INSERT INTO #tblProcesses VALUES('Posturas Remate IRS','NOTIFY_INPUT_REMATE_POSTURAS','REMATE_P_IRS',3)    
  INSERT INTO #tblProcesses VALUES('Hechos Remate IRS','NOTIFY_INPUT_REMATE_HECHOS','REMATE_H_IRS',3)    
  INSERT INTO #tblProcesses VALUES('Posturas Tradition IRS','FILE_INPUT_TRADITION_IRS_POST','TRADITION_P_IRS',6)    
  INSERT INTO #tblProcesses VALUES('Hechos Tradition IRS','FILE_INPUT_TRADITION_IRS_FACTS','TRADITION_H_IRS',6)    
  INSERT INTO #tblProcesses VALUES('Posturas VAR IRS','NOTIFY_INPUT_VAR_POSTURAS','VAR_P_IRS',7)    
  INSERT INTO #tblProcesses VALUES('Hechos VAR IRS','NOTIFY_INPUT_VAR_HECHOS','VAR_H_IRS',7)    
   
  INSERT INTO #tmpRegLoad  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsDerivatives m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = @txtDate  
  GROUP BY  
 c.intIdBroker  
  
  INSERT INTO #tmpRegLoadOld  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsDerivatives m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
  GROUP BY  
 c.intIdBroker  
   
 END  
    
 IF @txtType = 'IRE'    
 BEGIN    
  INSERT INTO #tblProcesses VALUES('Operaciones Enlace Revisables','FILE_INPUT_ENLACE_CORROS','ENLACE_O_REV',1)    
  --INSERT INTO #tblProcesses VALUES('Operaciones Eurobrokers Revisables','FILE_INPUT_EUROB_POSTURES','EUROB_O_REV',2)    
  INSERT INTO #tblProcesses VALUES('Posturas Sif Revisables','FILE_INPUT_SIF_POSTURE','SIF_P_REV',4)    
  INSERT INTO #tblProcesses VALUES('Hechos Sif Revisables','FILE_INPUT_SIF_FACT','SIF_H_REV',4)    
  INSERT INTO #tblProcesses VALUES('Posturas MEI Revisables','FILE_INPUT_MEI_POSTURES','MEI_P_REV',5)    
  INSERT INTO #tblProcesses VALUES('Hechos MEI Revisables','FILE_INPUT_MEI_FACTS','MEI_H_REV',5)    
  INSERT INTO #tblProcesses VALUES('Posturas Var Revisables','NOTIFY_INPUT_VAR_POSTURAS','VAR_P_REV',7)    
  INSERT INTO #tblProcesses VALUES('Hechos Var Revisables','NOTIFY_INPUT_VAR_HECHOS','VAR_H_REV',7)    
  INSERT INTO #tblProcesses VALUES('Posturas Remate Revisables','NOTIFY_INPUT_REMATE_POSTURAS','REMATE_P_REV',3)    
  INSERT INTO #tblProcesses VALUES('Hechos Remate Revisables','NOTIFY_INPUT_REMATE_HECHOS','REMATE_H_REV',3)  
  INSERT INTO #tblProcesses VALUES('Posturas Tradition Privados','FILE_INPUT_TRADITION_POSTURES','TRADITION_P_REV',6)    
  INSERT INTO #tblProcesses VALUES('Hechos Tradition Privados','FILE_INPUT_TRADITION_POSTURES','TRADITION_H_REV',6)      
  
  
  INSERT INTO #tmpRegLoad  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsRevi m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = @txtDate  
  GROUP BY  
 c.intIdBroker  
  
  INSERT INTO #tmpRegLoadOld  
  SELECT   
 c.intIdBroker,  
 COUNT(m.dblRate) AS intCount,  
 MAX(m.dteDate)  
  FROM itblMarketPositionsRevi m  
   INNER JOIN itblBrokerCatalog c  
   ON m.intIdBroker = c.intIdBroker  
  WHERE  
 dteDate = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
  GROUP BY  
 c.intIdBroker  
  
 END    
    
 SELECT    
  p.txtName,    
  p.txtDevil,    
  MAX(bd.dteEndTime) AS dteTimeDevil,    
  p.txtProcess,    
  MAX(bp.dteEndTime)AS dteTimeProcess,  
  p.intIdBroker,    
  CASE    
   WHEN cda.txtValue IS NOT NULL THEN  cdr.txtValue + REPLACE(cda.txtValue,'[FORMAT(TODAY, YYYYMMDD)]',@txtDate)    
   ELSE cr.txtValue + REPLACE(ca.txtValue,'[FORMAT(TODAY, YYYYMMDD)]',@txtDate)    
  END AS txtFile    
 INTO #tblData    
 FROM #tblProcesses p    
 INNER JOIN mxProcesses..tblDevilProcessCatalog cat (NOLOCK)    
 ON     
  p.txtDevil = cat.txtProcessName    
  AND cat.bitSts = 1    
  AND cat.txtIdDevil = 'DEVIL_FILE'    
 INNER JOIN mxProcesses..tblDevilConfiguration cr (NOLOCK)    
 ON    
  cat.intIdProcess = cr.intIdProcess    
  AND cat.txtHostname = cr.txtHostname    
  AND cr.txtIdParam = 'SPATH'    
 INNER JOIN mxProcesses..tblDevilConfiguration ca (NOLOCK)    
 ON    
  cat.intIdProcess = ca.intIdProcess    
  AND cat.txtHostname = ca.txtHostname    
  AND ca.txtIdParam = 'SFILE'    
LEFT OUTER JOIN mxProcesses..tblDevilConfiguration cdr (NOLOCK)    
 ON    
  cat.intIdProcess = cdr.intIdProcess    
  AND cat.txtHostname = cdr.txtHostname    
  AND cdr.txtIdParam = 'DPATH'    
 LEFT OUTER JOIN mxProcesses..tblDevilConfiguration cda (NOLOCK)    
 ON    
  cat.intIdProcess = cda.intIdProcess    
  AND cat.txtHostname = cda.txtHostname    
  AND cda.txtIdParam = 'DFILE'    
 LEFT OUTER JOIN mxProcesses..tblProcessBinnacle bd (NOLOCK)    
 ON    
  p.txtDevil = bd.txtProcess    
  AND bd.dteDate = @txtDate    
 LEFT OUTER JOIN mxProcesses..tblProcessBinnacle bp (NOLOCK)    
 ON    
  p.txtProcess = bp.txtProcess    
  AND bp.dteDate = @txtDate    
 GROUP BY     
  p.txtName,    
  p.txtDevil,    
  P.txtProcess,    
  cr.txtValue,    
  ca.txtValue,    
  cdr.txtValue,    
  cda.txtValue,  
  p.intIdBroker  
    
 -- Reporte Final    
  
 INSERT INTO #tmpMAX  
 SELECT txtProcess,MAX(dteDateTime)   
 FROM MxProcesses.dbo.tblInputsLoadControl  
 WHERE CONVERT(CHAR(8), dteDateTime,112) = @txtDate  
 GROUP BY txtProcess  
 ORDER BY txtProcess  
  
 INSERT INTO #tmpMAXOLD  
 SELECT txtProcess,MAX (dteDateTime)   
 FROM MxProcesses.dbo.tblInputsLoadControl  
 WHERE CONVERT(CHAR(8), dteDateTime,112) = dbo.fun_nextTradingDate(@txtDate,-1,'MX')  
 GROUP BY txtProcess  
 ORDER BY txtProcess  
    
 SELECT    
 d.txtName,    
 CASE    
  WHEN d.dteTimeDevil IS NULL THEN '-'    
  ELSE CONVERT(VARCHAR(8),d.dteTimeDevil,108)    
 END AS txtTimeDevil,    
 d.txtProcess,    
CASE    
  WHEN d.dteTimeProcess IS NULL THEN '-'    
  ELSE CONVERT(VARCHAR(8),d.dteTimeProcess,108)    
 END AS txtTimeProcess,    
 CASE    
  WHEN @dteTime > @dteCloseHour THEN     
   CASE    
    WHEN d.dteTimeDevil < @dteCloseHour OR d.dteTimeDevil IS NULL THEN 'Sin archivo de cierre'    
    WHEN d.dteTimeProcess < d.dteTimeDevil OR d.dteTimeProcess IS NULL THEN 'Insumo de cierre no cargado'    
    WHEN bp.txtStatus != 'END' THEN 'ERROR: ' + bp.txtMessage    
    ELSE 'OK'    
   END    
  ELSE    
   CASE    
    WHEN d.dteTimeDevil IS NULL THEN 'No se ha detectado insumo'    
    WHEN d.dteTimeProcess < d.dteTimeDevil OR d.dteTimeProcess IS NULL THEN 'Ultimo insumo no cargado'    
    WHEN bp.txtStatus != 'END' THEN 'ERROR: ' + bp.txtMessage    
    ELSE 'OK'    
   END    
 END AS txtMessage,  
 ' Ayer: ' + ISNULL(CAST(ilc2.intCount AS VARCHAR(5)),'0') +   
 ' Hoy: ' + ISNULL(CAST(ilc.intCount AS VARCHAR(5)),'0') +  
 ' Diff: ' + CAST(ABS(ISNULL(ilc2.intCount,0) - ISNULL(ilc.intCount,0)) AS CHAR(5))   
 AS txtResumArch,  
 ' Ayer: ' + ISNULL(CAST(lo.intCount AS VARCHAR(5)),'0') +   
 ' Hoy: ' + ISNULL(CAST(l.intCount AS VARCHAR(5)),'0') +  
 ' Diff: ' + CAST(ABS(ISNULL(lo.intCount,0) - ISNULL(l.intCount,0)) AS CHAR(5))   
 AS txtResumCarg,  
 d.txtFile   
 FROM #tblData d    
 LEFT OUTER JOIN mxProcesses..tblProcessBinnacle bp (NOLOCK)    
 ON    
  d.txtProcess = bp.txtProcess    
  AND d.dteTimeProcess = bp.dteEndTime    
  AND bp.dteDate = @txtDate  
  LEFT OUTER JOIN #tmpMAX tm (NOLOCK)  
  ON  
 tm.txtProcess = d.txtProcess  
  LEFT OUTER JOIN MxProcesses.dbo.tblInputsLoadControl ilc (NOLOCK)  
  ON  
   ilc.txtProcess = d.txtProcess  
   AND ilc.dteDateTime = tm.dteDate  
   AND ilc.txtProcess = tm.txtProcess  
   LEFT OUTER JOIN #tmpMAXOLD tmo  
   ON  
 tmo.txtProcess = d.txtProcess  
   LEFT OUTER JOIN MxProcesses.dbo.tblInputsLoadControl ilc2 (NOLOCK)  
  ON  
   ilc2.txtProcess = d.txtProcess  
   AND ilc2.dteDateTime = tmo.dteDate  
   --AND ilc2.txtProcess = tmo.txtProcess  
   LEFT OUTER JOIN #tmpRegLoad l  
   ON  
    l.intIdBroker = d.intIdBroker  
    LEFT OUTER JOIN #tmpRegLoadOld lo  
    ON  
    lo.intIdBroker = d.intIdBroker  
 ORDER BY     
  d.txtProcess    
    
 SET NOCOUNT OFF    
 SET ANSI_WARNINGS ON    
END   
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;4      
AS       
/*       
 Autor:   ???      
 Creacion:  ???      
 Descripcion:    Esquema QA de archivos licuadoras      
      
 Modificado por: Fernando M. Suzuri Rios      
 Modificacion: 20130521      
 Descripcion:    modifico campos    
*/      
BEGIN      
      
       
 SELECT      
  'txtDescripcion' AS txtDescripcion,      
  'txtHoraInsumo' AS [txtHora Insumo],      
  'txtProcesoCarga' AS [txtProceso Carga],      
  'txtHoraProceso' AS [txtHora Proceso],      
  'txtMensaje' AS txtMensaje,    
  'txtResumenCargaArchivo' AS [Resumen carga archivo],    
  'txtResumenCargaFinal' AS [Resumen carga final],    
  'txtArchivoInsumo' AS [txtArchivo Insumo]      
END      
          
  
  
  
  
spi_Auditoria_Licuadora;5 '20141205',13,'s',2
  
CREATE    PROCEDURE dbo.spi_Auditoria_Licuadora;5        
 @txtDate AS CHAR(10),        
 @intPlazo AS INT,        
 @txtTv AS CHAR(11),        
 @intBanda AS INTEGER = 2        
AS        
/*         
 Autor:   ???        
 Creacion:  ???        
 Descripcion: Muestra auditoria de nodos de derivados        
        
 Modificado por: CSOLORIO        
 Modificacion: 20120208        
 Descripcion: Amplio a 4 decimales las conversion de tasas        
*/        
BEGIN        
        
        
 SET NOCOUNT ON         
        
 DECLARE @txtHoraCierre AS CHAR(8)        
 DECLARE @dteHoraBanda1 AS DATETIME        
 DECLARE @txtHoraBanda1 AS CHAR(8)        
        
 IF @intBanda = 1        
 BEGIN        
  SELECT @dteHoraBanda1 = DATEADD(second,1,dteHoraIniDia)        
  FROM itblParametrosLicuadora        
          
  SELECT @txtHoraBanda1 = CONVERT(CHAR(8),@dteHoraBanda1,108)        
        
  SET @txtHoraCierre = '14:00:00'        
        
 END        
 ELSE        
 BEGIN        
        
  SELECT @dteHoraBanda1 = DATEADD(second,1,dteHoraMatutino)        
  FROM itblParametrosLicuadora        
          
  SELECT @txtHoraBanda1 = CONVERT(CHAR(8),@dteHoraBanda1,108)        
          
  SELECT @txtHoraCierre = CONVERT(CHAR(8),dteCloseHour,108)        
  FROM itblClosesRandom        
  WHERE dteDate = @txtDate        
        
 END        
        
 SELECT 'PONDERADO' AS txtBroker,        
  txtTv,        
  intPlazo AS intTerm,        
  'BANDA_1' AS txtOperation,        
  dblTasaFinal AS dblRate,        
  CASE WHEN dblAmount IS NULL THEN        
   0.0        
  ELSE        
   dblAmount        
  END AS dblAmount,        
  '05:00:00' AS dteBeginHour,        
  @txtHoraBanda1 AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation,    
   '' AS txtNote            
 INTO #tblOperacion        
 FROM itblTasasIRSLicuadasIG        
 WHERE  fStatus = 0        
 AND intPlazo = @intPlazo        
 AND txtTv = @txtTv        
        
 UNION        
        
 SELECT         
  'PONDERADO' AS txtBroker,    txtTv,        
  intPlazo AS intTerm,        
  txtOperation,        
  dblTasaFinal AS dblRate,        
  CASE WHEN dblAmount IS NULL THEN        
   0.0        
  ELSE        
   dblAmount        
  END AS dblAmount,        
  CASE        
   WHEN fStatus = 0 THEN '05:00:00'        
   ELSE @txtHoraBanda1        
  END AS dteBeginHour,        
  CASE        
   WHEN fStatus = 0 THEN @txtHoraBanda1        
   ELSE @txtHoraCierre        
  END AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation,    
   '' AS txtNote            
 FROM itblTasasLicuadasDerivativesIG        
 WHERE        
  intPlazo = @intPlazo        
  AND txtTv = @txtTv        
  AND dteDate = @txtDate        
         
 UNION        
         
 SELECT  c.txtBroker,        
  b.txtTv,        
  CASE        
   WHEN @txtTv = 'IRS' THEN b.intPlazo * 28         
   ELSE b.intPlazo        
  END AS intTerm,        
  b.txtOperation,        
  b.dblRate,        
  b.dblAmount,        
  CONVERT(Char(8), b.dteBeginhour, 108) AS dteBeginHour,        
  CONVERT(Char(8), b.dteEndHour, 108) AS dteEndHour,        
  DATEDIFF(MINUTE,b.dteBeginHour,b.dteEndHour) AS intMinutes,        
  '---' AS txtLiquidation,    
   '' AS txtNote            
 FROM  itblMarketPositionsDerivatives AS b INNER JOIN itblBrokercatalog AS c        
  ON b.intIdBroker = c.intIdBroker        
 WHERE  b.dteDate = @txtDate        
 AND b.dteEndHour >= @txtHoraBanda1        
 AND         
  CASE        
   WHEN @txtTv = 'IRS' THEN b.intPlazo * 28         
   ELSE b.intPlazo        
  END = @intPlazo        
 AND b.txtTv = @txtTv        
 AND b.dteBeginHour <= @txtHoraCierre        
         
 UNION        
         
 SELECT b.txtBroker,        
  i.txtTv,        
  CASE        
   WHEN @txtTv = 'IRS' THEN i.intPlazo * 28         
   ELSE i.intPlazo        
  END AS intTerm,        
  i.txtOperation,        
  i.dblRate,        
  i.dblAmount,        
  CONVERT(Char(8), i.dteBeginhour, 108) AS dteBeginHour,        
  CONVERT(Char(8), i.dteEndHour, 108) AS dteEndHour,        
  0 AS intMinutes,        
  '---' AS txtLiquidation,    
   '' AS txtNote            
 FROM  itblMarketPositionsDerivatives AS i INNER JOIN itblBrokerCatalog AS b        
  ON i.intIdBroker = b.intIdBroker        
 WHERE  dteDate = @txtDate        
 AND i.txtOperation NOT IN ('COMPRA','VENTA')        
 AND dteBeginHour >= @txtHoraBanda1        
 AND dteEndHour <= @txtHoraCierre        
 AND        
  CASE      
   WHEN @txtTv = 'IRS' THEN i.intPlazo * 28         
   ELSE i.intPlazo        
  END = @intPlazo        
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
  '---' AS txtLiquidation,    
   '' AS txtNote            
 FROM  itblChoiceDerivatives AS i INNER JOIN itblBrokerCatalog AS b        
  ON i.intIdBroker = b.intIdBroker        
WHERE  dteDate = @txtDate        
 AND i.txtOperation NOT IN ('COMPRA','VENTA')        
 AND dteEndHour >= @txtHoraBanda1        
 AND dteEndHour <= @txtHoraCierre        
 AND intPlazo = @intPlazo        
 AND txtTv = @txtTv        
 ORDER BY         
  intTerm,         
  dteBeginHour        
              
 SET NOCOUNT ON        
         
 IF (SELECT COUNT(intTerm)        
     FROM   #tblOperacion) = 0        
 BEGIN        
          
          
  SET NOCOUNT ON        
         
  SELECT  c.txtBroker,        
   b.txtTv,        
   CASE        
    WHEN @txtTv = 'IRS' THEN b.intPlazo * 28         
    ELSE b.intPlazo        
   END AS intTerm,        
   b.txtOperation,        
   b.dblRate,        
   b.dblAmount,        
   CONVERT(Char(8), b.dteBeginHour, 108) AS dteBeginHour,     CONVERT(Char(8), b.dteEndHour, 108) AS dteEndHour,        
   DATEDIFF(MINUTE,b.dteBeginHour,b.dteEndHour) AS intMinutes,        
   '---' AS txtLiquidation,    
   '' AS txtNote            
  INTO #tblOperacionMatutina        
  FROM  itblMarketPositionsDerivatives AS b INNER JOIN itblBrokercatalog AS c        
   ON b.intIdBroker = c.intIdBroker        
  WHERE  b.dteDate = @txtDate        
  AND         
   CASE        
  WHEN @txtTv = 'IRS' THEN b.intPlazo * 28         
    ELSE b.intPlazo        
   END = @intPlazo        
  AND b.txtTv = @txtTv        
  AND b.dteEndHour >= @txtHoraBanda1        
          
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
   '---' AS txtLiquidation ,    
   '' AS txtNote           
  FROM  itblMarketPositionsDerivatives AS i INNER JOIN itblBrokerCatalog AS b        
   ON i.intIdBroker = b.intIdBroker        
  WHERE  dteDate = @txtDate        
  AND i.txtOperation NOT IN ('COMPRA','VENTA')        
  AND         
   CASE        
    WHEN @txtTv = 'IRS' THEN i.intPlazo * 28         
    ELSE i.intPlazo        
   END = @intPlazo        
  AND txtTv = @txtTv        
          
  UNION        
  -- AGREGAMOS SUBASTA        
  SELECT  'SUBASTA' AS txtBroker,        
   @txtTv as txtTv,        
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
  AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
  AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
  AND I.txtTv=@txtTv        
  AND  @intPlazo <= DATEDIFF(DAY, b.dteIssued, b.dteMaturity)        
  AND  @intPlazo >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)        
  AND R.txtType = (CASE WHEN @txtTv = 'XA' THEN 'XA'         
       WHEN @txtTv = 'LS' THEN 'BDI'         
        END)        
         
  UNION        
          
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
         
         
  SET NOCOUNT OFF        
         
  IF (SELECT COUNT(intTerm)        
      FROM   #tblOperacionMatutina) = 0        
  BEGIN        
           
   SET NOCOUNT ON        
         
   SELECT @txtDate AS txtDate,        
    'PIP' AS txtBroker,        
    n.txtCategory,        
    n.intBeg AS intTerm,        
    'DATO_ANTERIOR' AS txtOperation,        
    l.dblValue,        
    0 AS dblAmount,        
    '00:00:00' AS dteBeginHour,        
    '00:00:00' AS dteEndHour,        
    0 AS intMinutes,        
    '---' AS txtLiquidation ,    
   '' AS txtNote           
   FROM itblNodesZeroCatalog AS n INNER JOIN itblNodesZeroLevels AS l        
    ON n.intSerialZero = l.intSerialZero        
   WHERE  n.intBeg = @intPlazo        
   AND n.txtCategory = @txtTv        
   AND l.dteDate = @txtDate        
   AND l.dteTime =  (        
     SELECT         
      MAX(dteTime)        
     FROM itblNodesZeroLevels        
     WHERE         
      intSerialZero = l.intSerialZero        
      AND dteDate = l.dteDate        
     )        
  UNION        
   --cambio para agregar subasta ultimo nodo d        
   SELECT DISTINCT        
    @txtDate AS txtDate,        
    'SUBASTA' AS txtBroker,        
    @txtTv as txttv,        
    @intPlazo AS intTerm,        
    'SUBASTA' AS txtOperation,        
    r.dblPrice AS dblRate,        
    r.dblAmount AS dblAmount,        
    CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,        
    CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,        
    0 AS intMinutes,        
    '---' AS txtLiquidation ,    
   '' AS txtNote           
   FROM tblBondsPricesRange AS r,        
    itblNodesZeroCatalog AS n INNER JOIN itblNodesZeroLevels AS l        
    ON n.intSerialZero = l.intSerialZero        
   WHERE  n.intBeg = @intPlazo        
   AND @intPlazo = 1820        
   AND n.txtCategory = @txtTv        
   AND n.txtCategory = 'BND'        
   AND R.intBeg > 1798        
   AND R.dteDate= @txtDate        
   AND R.txtTYPE = 'BDE'        
   AND l.dteDate =  (        
      SELECT MAX(l.dteDate)        
      FROM itblNodesZeroLevels AS l INNER JOIN itblNodesZeroCatalog AS n        
       ON l.intSerialZero = n.intSerialZero        
      WHERE n.txtCategory = @txtTv        
      )        
   ORDER BY         
    dteBeginHour        
         
         
   SET NOCOUNT OFF        
           
  END        
  ELSE        
  BEGIN        
   SELECT @txtDate AS txtDate,        
    txtBroker,        
    txtTv,        
    intTerm,        
    txtOperation,        
    --dblRate,        
  STR(dblRate,10,4) AS dblRate,        
    dblAmount/1000000 as dblAmount,        
    dteBeginHour,        
    dteEndHour,        
    intMinutes,        
    txtLiquidation ,    
   '' AS txtNote           
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
   --dblRate,        
   STR(dblRate,10,4) AS dblRate,        
   dblAmount/1000000 as dblAmount,        
   dteBeginHour,        
   dteEndHour,        
   intMinutes,        
   txtLiquidation,    
   '' AS txtNote      
         
  FROM #tblOperacion        
  ORDER BY         
   dteBeginHour        
 END        
END        
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;6  
 /*  
 Genera el Schema del SP 7  
 */  
AS   
BEGIN  
  
 SELECT TOP 0  
  '20060208' AS txtDate,  
  'txtBroker' AS txtBroker,  
  'txttv' AS txtTv,  
  1 AS intPlazoIni,  
  1 AS intPlazoFin,  
  'txtOperation' AS txtOperation,  
  '1.1' AS dblRate,  
  1.1 AS dblAmount,  
  '20051025' AS dteBeginHour,  
  '20051025' AS dteEndHour,  
  -999 AS intMinutes,  
  '24H' AS txtLiquidation  
  
  
END  



    spi_Auditoria_Licuadora '20141205',13,'s',2
CREATE  PROCEDURE dbo.spi_Auditoria_Licuadora;7    
 @txtDate AS CHAR(10),    
 @txtPlazo AS VARCHAR(20),    
 @txtTv AS CHAR(11),    
 @intBanda AS INTEGER = 2    
AS     
BEGIN    
    
    
 SET NOCOUNT ON     
    
    
 DECLARE @intTvs AS INT    
 DECLARE @intPlazoIni AS INT    
 DECLARE @intPlazoFin AS INT    
    
 DECLARE @dteHoraCierre AS DATETIME    
 DECLARE @dteHoraBanda1 AS DATETIME    
 DECLARE @txtHoraBanda1 AS CHAR(8)    
    
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
    
     
 IF CHARINDEX('-',@txtPlazo) > 0     
 BEGIN    
  SET @intPlazoIni = SUBSTRING(@txtPlazo,1,CHARINDEX('-',@txtPlazo)-1)    
  SET @intPlazoFin = SUBSTRING(@txtPlazo,CHARINDEX('-',@txtPlazo)+1,LEN(@txtPlazo)-CHARINDEX('-',@txtPlazo))    
 END    
     
 SELECT  @intTvs = COUNT(txtTv)    
 FROM  itblCategoryTvs    
 WHERE txtSubCategory = @txtTv    
    
     
 IF @intTvs = 1     
 BEGIN    
  SET @txtTv = ( SELECT  txtTv    
    FROM  itblCategoryTvs    
    WHERE txtSubCategory = @txtTv)    
 END    
    
    
    
 SELECT @txtDate AS txtDate,    
  'PONDERADO' AS txtBroker,    
  txtTv,    
  intPlazoIni,    
  intPlazoFin,    
  'BANDA_1' AS txtOperation,    
  dblTasaFinal AS dblRate,    
  dblAmount,    
  '07:00:00' AS dteBeginHour,    
  @txtHoraBanda1 AS dteEndHour,    
  0 AS intMinutes,    
  '---' AS txtLiquidation    
 FROM itblTasasRevLicuadasIG    
 WHERE  fStatus = 0    
 AND intPlazoIni = @intPlazoIni    
 AND intPlazoFin = @intPlazoFin    
 AND txtTv = @txtTv    
 AND  CONVERT(VARCHAR(10),getdate(),112) = @txtDate    
    
     
    
 UNION    
     
     
 SELECT  @txtDate AS txtDate,    
  c.txtBroker,    
  b.txtTv,    
  b.intPlazoIni,    
  b.intPlazoFin,    
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
  b.txtLiquidation    
 FROM  itblMarketPositionsRevi AS b INNER JOIN itblBrokercatalog AS c    
  ON b.intIdBroker = c.intIdBroker    
 WHERE  b.dteDate = @txtDate    
 AND b.dteEndHour >= @txtHoraBanda1    
 AND b.intPlazoIni < @intPlazoFin    
 AND b.intPlazoFin > @intPlazoIni    
 AND b.txtTv = @txtTv    
 AND b.dteBeginHour <= @dteHoraCierre    
 union    
 SELECT  @txtDate AS txtDate,    
  'SUBASTA' AS txtBroker,    
  @txtTv as txtTv,    
  @intPlazoIni AS intPlazoIni,    
  @intPlazoFin AS intPlazoFin,    
  'SUBASTA' AS txtOperation,    
  r.dblPrice AS dblRate,    
  r.dblAmount AS dblAmount,    
  CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,    
  CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,    
  0 AS intMinutes,    
  '---' AS txtLiquidation    
 FROM tblBondsPricesRange AS r,    
  tblIds AS i INNER JOIN tblBonds AS b    
  ON i.txtId1 = b.txtId1    
 WHERE r.dteDate  = @txtDate    
 AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)    
 AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)    
 AND I.txtTv=@txtTv    
 AND  @intPlazoFin <= DATEDIFF(DAY, b.dteIssued, b.dteMaturity)    
 AND  @intPlazoIni >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)    
 AND R.txtType = (CASE WHEN @txtTv = 'XA' THEN 'XA'     
      WHEN @txtTv = 'LD' THEN 'BDE'     
      WHEN @txtTv = 'LS' THEN 'BDI'     
       END)    
 UNION    
 --REVISABLES bps bpa bpt    
     
 SELECT @txtDate AS txtDate,    
  'SUBASTA' AS txtBroker,    
  @txtTv as txtTv,    
  @intPlazoIni AS intPlazoIni,    
  @intPlazoFin AS intPlazoFin,    
  'SUBASTA' AS txtOperation,    
  r.dblPrice AS dblRate,    
  r.dblAmount AS dblAmount,    
  CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,    
  CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,    
  0 AS intMinutes,    
  '---' AS txtLiquidation    
 FROM tblBondsPricesRange AS r,    
  itblNodesZeroCatalog as c    
 WHERE r.dteDate  =@txtdate    
 AND R.txtType = (CASE WHEN @txtTv = 'IS' THEN 'BPS'    
     WHEN @txtTv = 'IT' THEN 'BPT'    
     WHEN @txtTv = 'IP' THEN 'BPA'    
     END)    
 AND C.txtsubcategory = (CASE WHEN @txtTv = 'IS' THEN 'BPS'    
       WHEN @txtTv = 'IT' THEN 'BPT'    
       WHEN @txtTv = 'IP' THEN 'IPB'     
       END)    
 AND c.intBeg<=r.intBeg    
 AND c.intEnd>=r.intEnd    
 AND @intPlazoIni <=r.intBeg    
 AND @intPlazoFin >=r.intEnd    
 AND c.fstatus = '1'    
 ORDER by     
  dteBeginHour,    
  dteEndHour    
    
 SET NOCOUNT OFF    
    
END   
-- licuadora IRS (archivos)  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;8  
 @txtDate AS CHAR(10),  
 @txtLastDate AS CHAR(10)  
 /*  
 Muestra los archivos que han sido depositados   
 por los Brokers Junior 20060426  
 */  
AS   
BEGIN  
    
  SELECT   
   
  CONVERT(CHAR(10), CAST(@txtDate AS DATETIME), 111) AS txtDate,  
   
  CASE c.txtProcess  
  WHEN 'FILE_INPUT_REMATE_POSTURES' THEN 'REMATE_POSTURAS'  
  WHEN 'FILE_INPUT_REMATE_FACTS' THEN 'REMATE_HECHOS'  
  WHEN 'FILE_INPUT_REMATE_IRS_FACTS' THEN 'REMATE_HECHOS_IRS'  
  WHEN 'FILE_INPUT_EUROB_POSTURES' THEN 'EUROB_POSTURAS'  
  WHEN 'FILE_INPUT_EUROB_FACTS' THEN 'EUROB_HECHOS'  
  WHEN 'FILE_INPUT_EUROB_IRS_FACTS' THEN 'EUROB_HECHOS_IRS'  
  WHEN 'FILE_INPUT_MEI_POSTURES' THEN 'MEI_POSTURAS'  
  WHEN 'FILE_INPUT_MEI_FACTS' THEN 'MEI_HECHOS'  
  WHEN 'FILE_INPUT_VAR_POSTURES' THEN 'VAR_POSTURAS'  
  WHEN 'FILE_INPUT_VAR_FACTS' THEN 'VAR_HECHOS'  
  WHEN 'FILE_INPUT_ICAP_POSTURES' THEN 'ICAP_POSTURAS'  
  WHEN 'FILE_INPUT_ICAP_FACTS' THEN 'ICAP_HECHOS'  
  WHEN 'FILE_INPUT_TRADITION_POSTURES' THEN 'TRADITION_POSTURAS'  
  WHEN 'FILE_INPUT_TRADITION_FACTS' THEN 'TRADITION_HECHOS'  
  WHEN 'FILE_INPUT_TRADITION_IRS_FACTS' THEN 'TRADITION_IRS_HECHOS'  
  WHEN 'FILE_INPUT_TRADITION_IRS_POST' THEN 'TRADITION_IRS_POSTURAS'  
  WHEN 'FILE_INPUT_ENLACE_CORROS_RES' THEN 'ENLACE_OPERACIONES_BKP'  
  WHEN 'FILE_INPUT_SIF_POSTURE' THEN 'SIF_POSTURAS'  
  WHEN 'FILE_INPUT_SIF_FACT' THEN 'SIF_HECHOS'   
  END AS txtProcess,    
   
  CASE   
  WHEN MAX(b2.dteEndTime) IS NULL THEN '-'  
  ELSE CONVERT(CHAR(8), MAX(b2.dteEndTime), 108)  
  END AS dteLastTime,  
  
  CASE   
  WHEN MAX(b2.dteEndTime)IS NULL THEN 'No hay archivo'  
  ELSE  
   
   CASE  
   WHEN cr.dteCloseHour IS NULL THEN 'No se conoce hora de cierre'  
   ELSE  
    CASE  
    WHEN MAX(b2.dteEndTime) IS NULL THEN 'Pendiente'  
    ElSE  
     CASE  
     WHEN MAX(b2.dteEndTime) > cr.dteCloseHour THEN 'OK'   
     ELSE 'Pendiente archivo de cierre'  
     END   
    END   
   END   
  END AS txtEvaluacion  
    
  FROM   
  MxProcesses..tblProcessCatalog AS c (NOLOCK)  
   
  LEFT OUTER JOIN MxProcesses..tblProcessBinnacle AS b2 (NOLOCK)  
  ON   
   c.txtProcess = b2.txtProcess  
   AND b2.dteDate = @txtDate  
  LEFT OUTER JOIN MxFixIncome..itblClosesRandom AS cr (NOLOCK)  
  ON cr.dteDate = @txtDate  
   
  WHERE  
  c.txtProcess IN(  
   'FILE_INPUT_ENLACE_CORROS_RES',  
   'FILE_INPUT_EUROB_POSTURES',  
   'FILE_INPUT_EUROB_IRS_FACTS',  
   'FILE_INPUT_REMATE_POSTURES',  
   'FILE_INPUT_REMATE_FACTS',  
   'FILE_INPUT_ICAP_POSTURES',  
   'FILE_INPUT_ICAP_FACTS',  
   'FILE_INPUT_TRADITION_IRS_FACTS',  
   'FILE_INPUT_TRADITION_IRS_POST'  
  )  
  GROUP BY   
  c.txtProcess,  
  cr.dteCloseHour  
  ORDER BY   
  txtEvaluacion,  
  dteLastTime DESC   
  
END  
  
-- licuadora IRS (schema)  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;9  
AS   
BEGIN  
  
   
 SELECT TOP 0  
  '20060426' AS txtFecha,  
  'txtProceso' AS txtArchivo,  
  '14:00:00' AS txtHoy,  
  'OK' AS txtEstado  
  
END  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;10  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Reporte de privados (schema)  
 Modificado por: CSOLORIO  
 Modificacion: 20120124   
 Descripcion: Agrego el campo flag de integracion  
*/  
  
BEGIN  
  
   
 SELECT TOP 0  
  'txtFecha' AS txtFecha,  
  'txtBroker' AS txtBroker,  
  -999 AS intPlazo,  
  'txtId1' AS txtId1,  
  'txtTv' AS txtTv,  
  'txtEmisora' AS txtEmisora,  
  'txtSerie' AS txtSerie,  
  'txtMetodologia' AS txtMetodologia,  
  'txtOperacion' AS txtOperacion,  
  'txtTasa' AS txtTasa,  
  'txtMonto' AS txtMonto,  
  'txtInicio' AS txtInicio,  
  'txtFin' AS txtFin  
  
END  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;11  
 @txtDate CHAR(10),  
 @txtSchema CHAR(3) = 'dbo'  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Reporte de privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20120213  
 Descripcion: Agrego esquema para Indeval  
*/  
  
BEGIN  
  
 DECLARE @txtSQL AS VARCHAR(1000)  
  
 SET @txtSQL =  
 'SELECT        
  CONVERT(CHAR(10), m.dteDate,111) AS txtFecha,  
  b.txtBroker,  
  m.intPlazo,  
  i.txtId1,  
  m.txtTv,  
  m.txtEmisora,  
  m.txtSerie,  
  CASE  
   WHEN u.txtId1 IS NOT NULL THEN ''SI''  
   ELSE ''NO''  
  END AS txtMetodologia,  
  m.txtOperation AS txtOperacion,  
  STR(m.dblRate, 10, 6)  + ''%'' AS txtTasa,  
  STR(m.dblAmount / 1000000, 16, 0) AS txtMonto,  
  CONVERT(CHAR(8), m.dteBeginHour, 108) AS txtInicio,  
  CONVERT(CHAR(8), m.dteEndHour, 108) AS txtFin   
 FROM ' +    
  RTRIM(LTRIM(@txtSchema)) + '.itblMarketPositionsPrivates AS m  (NOLOCK)  
  INNER JOIN tblIds i  
  ON   
   m.txtTv = i.txtTv  
   AND m.txtEmisora = i.txtEmisora  
   AND m.txtSerie = i.txtSerie  
  INNER JOIN itblBrokerCatalog AS b (NOLOCK)  
  ON   
   m.intIdBroker = b.intIdBroker  
  LEFT OUTER JOIN dbo.fun_blender_uni_prv(' + '''' + @txtDate + '''' + ',0) u  
  ON  
   i.txtId1 = u.txtId1  
 WHERE             
  m.dteDate = ' + '''' + @txtDate + '''' +  
 ' ORDER BY   
  m.txtTv,  
  m.txtEmisora,  
  m.txtSerie'  
  
 EXEC(@txtSQL)  
  
END  
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;12  
 @txtDate AS CHAR(10),  
 @txtPlazo AS VARCHAR(20),  
 @txtTv AS CHAR(11),  
 @intBanda AS INTEGER = 2  
AS   
BEGIN  
 /*  
  Creador:   Salvador Sosa  
  Fecha:    20100507  
  Modificaci�n:  Se modifica para que relize la busqueda de corros  
       invertidos siempre y cuando el tv que se le pasa no este vacio  
  Fecha Modificacion: 20140320  
  Autor Modificacion: CSOLORIO  
  Descripci�n:  Modifico los horarios de inicio de los registros en banda 2  
 */  
   
 SET NOCOUNT ON  
  
 DECLARE @tmp_tblDirtyValues TABLE  
 (  
  txtBroker VARCHAR(250),  
  txtTv VARCHAR(15),  
  intTerm INT,  
  txtOperation VARCHAR(20),  
  dteBeginHour DATETIME,  
  dteENdHour DATETIME,  
  txtColor VARCHAR(100)  
 )  
  
 DECLARE @dteHoraCierre AS DATETIME  
 DECLARE @dteHoraBanda1 AS DATETIME  
 DECLARE @txtHoraBanda1 AS CHAR(8)  
  
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
    
 IF @txtTv IN ('IP','IS','IT','IM','IQ')  
 BEGIN  
  
  INSERT @tmp_tblDirtyValues  
  SELECT DISTINCT  
    c.txtBroker,  
    nod.txtTv,  
    nod.intTerm,  
    nod.txtOperation,  
    CASE   
     WHEN nod.dteBeginhour < @txtHoraBanda1 THEN @txtHoraBanda1  
     ELSE CONVERT(Char(8), nod.dteBeginhour, 108)   
    END AS dteBeginHour,  
    CONVERT(Char(8), nod.dteEndHour, 108) AS dteEndHour,  
    '&H0000FFFF' -- amarillo: nodos que cambian de rango  
  FROM itblMarketReviRangeNodes AS nod (NOLOCK)  
    INNER JOIN itblBrokercatalog AS c (NOLOCK)  
    ON   
     nod.intIdBroker = c.intIdBroker  
  WHERE dteDate = @txtDate  
    AND RTRIM(LTRIM(STR(intTerm))) = RTRIM(LTRIM(@txtPlazo))  
    AND RTRIM(LTRIM(txtTv)) =  RTRIM(LTRIM(@txtTv))  
  
 END  
  
 IF @txtTv = ''  
 BEGIN  
   
  -- buscamos datos "sucios" para corros invertidos  
  DECLARE @tmp_tblOperaciones TABLE  
  (  
   txtDate VARCHAR(10),  
   txtBroker VARCHAR(100),  
   txtTv VARCHAR(20),  
   intTerm INT,  
   txtOperation VARCHAR(100),  
   dblRate FLOAT,  
   dteBeginHour DATETIME,  
   dteEndHour DATETIME    
  )  
  
  SELECT 'PONDERADO' AS txtBroker,  
   txtTv,  
   intPlazo AS intTerm,  
   'BANDA_1' AS txtOperation,  
   dblTasaFinal AS dblRate,  
   dblAmount,  
   '07:00:00' AS dteBeginHour,  
   @txtHoraBanda1 AS dteEndHour,  
   0 AS intMinutes,  
   '---' AS txtLiquidation  
  INTO #tblOperacion  
  FROM itblTasasRealesLicuadasIG  
  WHERE  fStatus = 0  
  AND intPlazo = @txtPlazo  
  AND txtTv = @txtTv  
  
  UNION  
  
  SELECT 'PONDERADO' AS txtBroker,  
   txtTv,  
   intPlazo AS intTerm,  
   'BANDA_1' AS txtOperation,  
   dblTasaFinal AS dblRate,  
   dblAmount,  
   '07:00:00' AS dteBeginHour,  
   @txtHoraBanda1 AS dteEndHour,  
   0 AS intMinutes,  
   '---' AS txtLiquidation  
  FROM itblTasasLicuadasInterfaz  
  WHERE  fStatus = 0  
  AND intPlazo = @txtPlazo  
  AND txtTv = @txtTv  
  
  UNION  
  
  SELECT 'PONDERADO' AS txtBroker,  
   txtTv,  
   intPlazoIni AS intPlazo,  
   'BANDA_1' AS txtOperation,  
   dblTasaFinal AS dblRate,  
   dblAmount,  
   '07:00:00' AS dteBeginHour,  
   @txtHoraBanda1 AS dteEndHour,  
   0 AS intMinutes,  
   '---' AS txtLiquidation  
  FROM itblTasasRevLicuadasIG  
  WHERE  fStatus = 0  
  AND intPlazoIni = @txtPlazo  
  AND txtTv = @txtTv  
  
  UNION  
  
  SELECT  c.txtBroker,  
   b.txtTv,  
   b.intPlazo AS intTerm,  
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
   b.txtLiquidation  
  FROM  itblMarketPositions AS b INNER JOIN itblBrokercatalog AS c  
   ON b.intIdBroker = c.intIdBroker  
  WHERE  b.dteDate = @txtDate  
  AND b.dteEndHour >= @txtHoraBanda1  
  AND b.intPlazo = @txtPlazo  
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
   i.txtLiquidation  
  FROM  itblMarketPositions AS i INNER JOIN itblBrokerCatalog AS b  
   ON i.intIdBroker = b.intIdBroker  
  WHERE  dteDate = @txtDate  
  AND i.txtOperation NOT IN ('COMPRA','VENTA')  
  AND dteBeginHour >= @txtHoraBanda1  
  AND dteEndHour <= @dteHoraCierre  
  AND intPlazo = @txtPlazo  
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
   '---' AS txtLiquidation  
  FROM  itblChoice AS i INNER JOIN itblBrokerCatalog AS b  
   ON i.intIdBroker = b.intIdBroker  
  WHERE  dteDate = @txtDate  
  AND i.txtOperation NOT IN ('COMPRA','VENTA')  
  AND dteEndHour >= @txtHoraBanda1  
  AND dteEndHour <= @dteHoraCierre  
  AND intPlazo = @txtPlazo  
  AND txtTv = @txtTv  
  
  UNION    
  --se agregan subastas ;1 solo para cetes y bonos  
  -- TIPOS DE VALOR M BI  
  SELECT  'SUBASTA' AS txtBroker,  
   @txtTv as txtTv,  
   DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intTerm,  
   'SUBASTA' AS txtOperation,  
   r.dblPrice AS dblRate,  
   r.dblAmount AS dblAmount,  
   CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,  
   CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,  
   0 AS intMinutes,  
   '---' AS txtLiquidation  
  FROM tblBondsPricesRange AS r,  
   tblIds AS i INNER JOIN tblBonds AS b  
   ON i.txtId1 = b.txtId1  
  WHERE r.dteDate  = @txtDate  
  AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)+2  
  AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)-2  
  AND  @txtPlazo <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)+2  
  AND  @txtPlazo >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)-2  
  AND i.txtTv = @txtTv  
  AND R.txtType = (CASE WHEN @txtTv = 'BI' THEN 'WET'   
     WHEN @txtTv IN ('M','M3','M5','M7','M0') THEN 'CET'  
     END)  
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
   '---' AS txtLiquidation  
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
  AND  @txtPlazo <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)+4  
  AND  @txtPlazo >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)-4  
  AND  i.txtTv IN ('S','S0','PI','2U')  
    
  UNION  
  --SE AGERGA SUBASTA PARA LD  
  SELECT DISTINCT  
   'SUBASTA' AS txtBroker,  
   @txtTv as txttv,  
   @txtPlazo AS intTerm,  
   'SUBASTA' AS txtOperation,  
   r.dblPrice AS dblRate,  
   r.dblAmount AS dblAmount,  
   CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,  
   CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,  
   0 AS intMinutes,  
   '---' AS txtLiquidation  
  FROM tblBondsPricesRange AS r,  
   tblIds AS i INNER JOIN tblBonds AS b  
   ON i.txtId1 = b.txtId1  
  WHERE r.dteDate  = @txtDate  
  AND r.txtType = 'BDE'  
  AND r.txtSubType Like 'XA'  
  AND  i.txtTv IN ('LD')  
  AND i.txtTv = @txtTv  
  AND @txtPlazo <= DATEDIFF(DAY, @txtDate, b.dteMaturity)  
  AND @txtPlazo >= DATEDIFF(DAY, @txtDate, b.dteMaturity)  
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
    @txtPlazo,  
    'BANDA_1' AS txtOperation,  
    dblTasaFinal AS dblRate,  
    dblAmount,  
    '07:00:00' AS dteBeginHour,  
    @txtHoraBanda1 AS dteEndHour,  
    0 AS intMinutes,  
    '---' AS txtLiquidation  
   FROM itblTasasRevLicuadasIG  
   WHERE  fStatus = 0  
   AND intPlazoIni = @txtPlazo  
   AND intPlazoFin = @txtPlazo  
   AND txtTv = @txtTv  
   AND  CONVERT(VARCHAR(10),getdate(),112) = @txtDate  
   UNION  
   SELECT  c.txtBroker,  
    b.txtTv,  
    @txtPlazo,  
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
    b.txtLiquidation  
   FROM  itblMarketPositionsRevi AS b INNER JOIN itblBrokercatalog AS c  
    ON b.intIdBroker = c.intIdBroker  
   WHERE  b.dteDate = @txtDate  
   AND b.dteEndHour >= @txtHoraBanda1  
   AND b.intPlazoIni <= @txtPlazo  
   AND b.intPlazoFin >= @txtPlazo  
   AND b.txtTv = @txtTv  
   AND b.dteBeginHour <= @dteHoraCierre  
   UNION  
   SELECT  'SUBASTA' AS txtBroker,  
    @txtTv as txtTv,  
    @txtPlazo AS intPlazo,  
    'SUBASTA' AS txtOperation,  
    r.dblPrice AS dblRate,  
    r.dblAmount AS dblAmount,  
    CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,  
    CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,  
    0 AS intMinutes,  
    '---' AS txtLiquidation  
   FROM tblBondsPricesRange AS r,  
    tblIds AS i INNER JOIN tblBonds AS b  
    ON i.txtId1 = b.txtId1  
   WHERE r.dteDate  = @txtDate  
   AND  r.intBeg <= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)  
   AND  r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)  
   AND I.txtTv=@txtTv  
   AND  @txtPlazo <= DATEDIFF(DAY, b.dteIssued, b.dteMaturity)  
   AND  @txtPlazo >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)  
   AND R.txtType = (CASE WHEN @txtTv = 'XA' THEN 'XA'   
        WHEN @txtTv = 'LD' THEN 'BDE'   
        WHEN @txtTv = 'LS' THEN 'BDI'   
      END)  
   UNION  
   --REVISABLES bps bpa bpt  
   SELECT 'SUBASTA' AS txtBroker,  
    @txtTv as txtTv,  
    @txtPlazo AS intPlazoIni,  
    'SUBASTA' AS txtOperation,  
    r.dblPrice AS dblRate,  
    r.dblAmount AS dblAmount,  
    CONVERT(Char(8), r.dteTime, 108) AS dteBeginHour,  
    CONVERT(Char(8), r.dteTime, 108) AS dteEndHour,  
    0 AS intMinutes,  
    '---' AS txtLiquidation  
   FROM tblBondsPricesRange AS r,  
    itblNodesZeroCatalog as c  
   WHERE r.dteDate  =@txtdate  
   AND R.txtType = (CASE WHEN @txtTv = 'IS' THEN 'BPS'  
        WHEN @txtTv = 'IT' THEN 'BPT'  
        WHEN @txtTv = 'IP' THEN 'BPA'  
      END)  
   AND C.txtsubcategory = (CASE WHEN @txtTv = 'IS' THEN 'BPS'  
        WHEN @txtTv = 'IT' THEN 'BPT'  
        WHEN @txtTv = 'IP' THEN 'IPB'  
      END)  
   AND c.intBeg<=r.intBeg  
   AND c.intEnd>=r.intEnd  
   AND @txtPlazo <=r.intBeg  
   AND @txtPlazo >=r.intEnd  
   AND c.fstatus = '1'  
   ORDER by   
    dteBeginHour,  
    dteEndHour  
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
    b.txtLiquidation  
   INTO #tblOperacionMatutina  
   FROM  itblMarketPositions AS b INNER JOIN itblBrokercatalog AS c  
    ON b.intIdBroker = c.intIdBroker  
   WHERE  b.dteDate = @txtDate  
   AND b.intPlazo = @txtPlazo  
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
    i.txtLiquidation  
   FROM  itblMarketPositions AS i INNER JOIN itblBrokerCatalog AS b  
    ON i.intIdBroker = b.intIdBroker  
   WHERE  dteDate = @txtDate  
   AND i.txtOperation NOT IN ('COMPRA','VENTA')  
   AND intPlazo = @txtPlazo  
   AND txtTv = @txtTv  
   ORDER BY   
    intTerm,   
    dteBeginHour  
  
    
   SET NOCOUNT OFF  
  
   IF (SELECT COUNT(intTerm)  
    FROM   #tblOperacionMatutina) = 0  
   BEGIN  
      
    SET NOCOUNT ON  
  
    INSERT @tmp_tblOperaciones  
    SELECT @txtDate AS txtDate,  
     'PIP' AS txtBroker,  
     i.txtTv,  
     DATEDIFF(DAY,@txtDate,b.dteMaturity) AS intTerm,  
     'DATO_ANTERIOR' AS txtOperation,  
     STR(l.dblValue,10,4),  
     '00:00:00' AS dteBeginHour,  
     '00:00:00' AS dteEndHour  
    FROM itblNodesYTMCatalog AS n INNER JOIN itblNodesYTMLevels AS l  
     ON n.intSerialYTM = l.intSerialYTM  
     INNER JOIN tblBonds AS b  
     ON n.txtId1 = b.txtId1  
     INNER JOIN tblIds AS i  
     ON b.txtId1 = i.txtId1  
    WHERE  DATEDIFF(DAY,@txtDate,b.dteMaturity) = @txtPlazo  
    AND i.txtTv = @txtTv  
    AND l.dteDate =  (  
       SELECT MAX(l.dteDate)  
       FROM itblNodesYTMLevels AS l INNER JOIN itblNodesYTMCatalog AS n  
        ON  l.intSerialYTM = n.intSerialYTM  
        INNER JOIN tblIds AS i  
        ON n.txtId1 = i.txtId1  
       WHERE i.txtTv = @txtTv  
       )  
    ORDER BY   
     dteBeginHour  
  
    
    SET NOCOUNT OFF  
      
   END  
   ELSE  
   BEGIN  
  
    INSERT @tmp_tblOperaciones  
    SELECT @txtDate AS txtDate,  
      txtBroker,  
      txtTv,  
      intTerm,  
      txtOperation,  
      STR(dblRate,10,4),  
      dteBeginHour,  
      dteEndHour  
    FROM #tblOperacionMatutina  
    ORDER BY   
     dteBeginHour  
  
   END  
  END  
  ELSE  
  BEGIN  
  
   INSERT @tmp_tblOperaciones  
   SELECT @txtDate AS txtDate,  
     txtBroker,  
     txtTv,  
     intTerm,  
     txtOperation,  
     STR(dblRate,10,4),  
     dteBeginHour,  
     dteEndHour  
   FROM #tblOperacion  
   ORDER BY   
    dteBeginHour  
  END   
  
  /*  
  -- enga�ando a la vida  
    
  IF @txtDate = '20100409'  
   AND @txtPlazo = '1448'  
   AND @txtTv = 'IS'  
   AND @intBanda = 2  
  BEGIN  
    
   UPDATE @tmp_tblOperaciones  
   SET  dteBeginHour = '1900-01-01 13:05:00.000'  
  
   UPDATE @tmp_tblOperaciones  
   SET  dteBeginHour = '1900-01-01 13:00:00.000',  
     dteEndHour = '1900-01-01 13:04:59.000'  
   WHERE (  
      txtBroker = 'REMATE'  
      AND txtOperation = 'COMPRA'  
     )  
     OR  
     (  
      txtBroker = 'VAR'  
      AND txtOperation = 'VENTA'  
     )  
  
   UPDATE @tmp_tblOperaciones  
   SET  dblRate = 0.31  
   WHERE (  
      txtBroker = 'REMATE'  
      AND txtOperation = 'COMPRA'  
     )  
  
  END  
  */  
  
  -- Detecto nodos con corros invertidos  
  UPDATE dir  
  SET  dir.txtColor = '&H000080FF' -- naranja: nodos con corro invertido y cambio de rango al mismo tiempo  
  FROM @tmp_tblOperaciones AS compra  
    INNER JOIN @tmp_tblOperaciones AS venta  
    ON  
     venta.txtTv = compra.txtTv  
     AND venta.intTerm = compra.intTerm  
    INNER JOIN @tmp_tblDirtyValues AS dir  
    ON  
     dir.txtBroker = compra.txtBroker  
     AND dir.txtTv = compra.txtTv  
     AND dir.intTerm = compra.intTerm  
     AND dir.txtOperation = compra.txtOperation  
     AND dir.dteBeginHour = compra.dteBeginHour  
     AND dir.dteEndHour = compra.dteEndHour  
  WHERE compra.txtOperation = 'COMPRA'  
    AND venta.txtOperation = 'VENTA'  
    AND compra.dblRate < venta.dblRate  
    AND   
    (  
     (  
      compra.dteBeginHour >= venta.dteBeginHour  
      AND compra.dteBeginHour < venta.dteEndHour  
     )  
     OR  
     (  
      venta.dteBeginHour >= compra.dteBeginHour  
      AND venta.dteBeginHour < compra.dteEndHour  
     )  
    )  
    
  UPDATE dir  
  SET  dir.txtColor = '&H000080FF' -- naranja: nodos con corro invertido y cambio de rango al mismo tiempo  
  FROM @tmp_tblOperaciones AS compra  
    INNER JOIN @tmp_tblOperaciones AS venta  
    ON  
     venta.txtTv = compra.txtTv  
     AND venta.intTerm = compra.intTerm  
    INNER JOIN @tmp_tblDirtyValues AS dir  
    ON  
     dir.txtBroker = venta.txtBroker  
     AND dir.txtTv = venta.txtTv  
     AND dir.intTerm = venta.intTerm  
     AND dir.txtOperation = venta.txtOperation  
     AND dir.dteBeginHour = venta.dteBeginHour  
     AND dir.dteEndHour = venta.dteEndHour  
  WHERE compra.txtOperation = 'COMPRA'  
    AND venta.txtOperation = 'VENTA'  
    AND compra.dblRate < venta.dblRate  
    AND   
    (  
     (  
      compra.dteBeginHour >= venta.dteBeginHour  
      AND compra.dteBeginHour < venta.dteEndHour  
     )  
     OR  
     (  
      venta.dteBeginHour >= compra.dteBeginHour  
      AND venta.dteBeginHour < compra.dteEndHour  
     )  
    )  
  
  INSERT @tmp_tblDirtyValues  
  SELECT compra.txtBroker,  
    compra.txtTv,  
    compra.intTerm,  
    compra.txtOperation,  
    compra.dteBeginHour AS dteBeginHourCompra,  
    compra.dteEndHour AS dteEndHourCompra,  
    '&H000000FF' -- rojo: nodos con corro invertido  
  FROM @tmp_tblOperaciones AS compra  
    INNER JOIN @tmp_tblOperaciones AS venta  
    ON  
     venta.txtTv = compra.txtTv  
     AND venta.intTerm = compra.intTerm  
    LEFT OUTER JOIN @tmp_tblDirtyValues AS dir  
    ON  
     dir.txtBroker = compra.txtBroker  
     AND dir.txtTv = compra.txtTv  
     AND dir.intTerm = compra.intTerm  
     AND dir.txtOperation = compra.txtOperation  
     AND dir.dteBeginHour = compra.dteBeginHour  
     AND dir.dteEndHour = compra.dteEndHour  
  WHERE compra.txtOperation = 'COMPRA'  
    AND venta.txtOperation = 'VENTA'  
    AND compra.dblRate < venta.dblRate  
    AND   
    (  
     (  
      compra.dteBeginHour >= venta.dteBeginHour  
      AND compra.dteBeginHour < venta.dteEndHour  
     )  
     OR  
     (  
      venta.dteBeginHour >= compra.dteBeginHour  
      AND venta.dteBeginHour < compra.dteEndHour  
     )  
    )  
    AND dir.intTerm IS NULL  
  UNION  
  SELECT venta.txtBroker,  
    venta.txtTv,  
    venta.intTerm,  
    venta.txtOperation,  
    venta.dteBeginHour AS dteBeginHourCompra,  
    venta.dteEndHour AS dteEndHourCompra,  
    '&H000000FF' -- rojo: nodos con corro invertido  
  FROM @tmp_tblOperaciones AS compra  
    INNER JOIN @tmp_tblOperaciones AS venta  
    ON  
     venta.txtTv = compra.txtTv  
     AND venta.intTerm = compra.intTerm  
    LEFT OUTER JOIN @tmp_tblDirtyValues AS dir  
    ON  
     dir.txtBroker = venta.txtBroker  
     AND dir.txtTv = venta.txtTv  
     AND dir.intTerm = venta.intTerm  
     AND dir.txtOperation = venta.txtOperation  
     AND dir.dteBeginHour = venta.dteBeginHour  
     AND dir.dteEndHour = venta.dteEndHour  
  WHERE compra.txtOperation = 'COMPRA'  
    AND venta.txtOperation = 'VENTA'  
    AND compra.dblRate < venta.dblRate  
    AND   
    (  
     (  
      compra.dteBeginHour >= venta.dteBeginHour  
      AND compra.dteBeginHour < venta.dteEndHour  
     )  
     OR  
     (  
      venta.dteBeginHour >= compra.dteBeginHour  
      AND venta.dteBeginHour < compra.dteEndHour  
     )  
    )  
    AND dir.intTerm IS NULL  
 END  
   
  
 SELECT txtBroker,  
   txtTv,  
   intTerm,  
   txtOperation,  
   CONVERT(VARCHAR(10),dteBeginHour,108),  
   CONVERT(VARCHAR(10),dteEndHour,108),  
   txtColor  
 FROM @tmp_tblDirtyValues  
   
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;13  
AS   
  
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100820  
 Descripcion:    Reporte de instrumentos privados (Schema)  
  
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
BEGIN  
  
   
 SELECT TOP 0  
  'txtFecha' AS txtFecha,  
  'txtTv' AS txtTv,  
  'txtEmisora' AS txtEmisora,  
  'txtSerie' AS txtSerie,    
  'txtPlazo' AS txtPlazo,  
  'txtInstrumento' AS txtInstrumento,  
  'txtBroker' AS txtBroker  
  
END  
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;14  
 @txtDate  AS CHAR(10)  
AS   
  
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100820  
 Descripcion:    Reporte de instrumentos privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20100824  
 Descripcion:    Quito los nullos  
*/  
  
BEGIN  
  
 SELECT  
  CONVERT(VARCHAR(8),i.dteDate,112),  
  CASE  
   WHEN i.txtTv IS NULL THEN '-'  
   ELSE i.txtTv  
  END AS txtTv,  
  CASE  
   WHEN i.txtEmisora IS NULL THEN '-'  
   ELSE i.txtEmisora   
  END AS txtEmisora,  
  CASE  
   WHEN i.txtSerie IS NULL THEN '-'  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.intPlazo IS NULL THEN '-'  
   ELSE STR(i.intPlazo,10,0)  
  END AS txtPlazo,  
  i.txtInstrumento,  
  c.txtBroker  
 FROM  tmp_tblInstrumentosPRV i  
 INNER JOIN itblBrokerCatalog c  
 ON   
  i.intIdBroker = c.intIdBroker  
 WHERE   
  i.dtedate = @txtDate  
 ORDER BY  
  c.txtBroker,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  i.intPlazo,  
  i.txtInstrumento  
    
END  
  
  
CREATE  PROCEDURE dbo.spi_Auditoria_Licuadora;15  
 @txtDate AS CHAR(10)  
AS   
  
/*   
 Autor:   CSOLORIO  
 Creacion:  20101006  
 Descripcion: Muestra los archivos que han sido depositados  
     por los Brokers Privados  
   
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
BEGIN  
    
  SELECT   
   
  CONVERT(CHAR(10), CAST(@txtDate AS DATETIME), 111) AS txtDate,  
   
  CASE c.txtProcess  
  WHEN 'FILE_INPUT_ENLACE_CORROS' THEN 'ENLACE OPERACIONES'  
  WHEN 'FILE_INPUT_EUROB_POSTURES' THEN 'EUROBROKERS OPERACIONES'  
  WHEN 'FILE_INPUT_MEI_FACTS' THEN 'MEI HECHOS'  
  WHEN 'FILE_INPUT_MEI_POSTURES' THEN 'MEI POSTURAS'  
  WHEN 'FILE_INPUT_SIF_H_PRV' THEN 'SIF HECHOS'  
  WHEN 'FILE_INPUT_SIF_P_PRV' THEN 'SIF POSTURAS'  
  WHEN 'FILE_INPUT_TRADITION_FACTS_PRV' THEN 'TRADITION HECHOS'  
  WHEN 'FILE_INPUT_TRADITION_POST_PRV' THEN 'TRADITION POSTURAS'  
  WHEN 'NOTIFY_INPUT_REMATE_HECHOS' THEN 'REMATE HECHOS'  
  WHEN 'NOTIFY_INPUT_REMATE_POSTURAS' THEN 'REMATE POSTURAS'  
  WHEN 'NOTIFY_INPUT_VAR_HECHOS' THEN 'VAR HECHOS'  
  WHEN 'NOTIFY_INPUT_VAR_POSTURAS' THEN 'VAR POSTURAS'  
  
  END AS txtProcess,    
   
  CASE   
  WHEN MAX(b2.dteEndTime) IS NULL THEN '-'  
  ELSE CONVERT(CHAR(8), MAX(b2.dteEndTime), 108)  
  END AS dteLastTime,  
  
  CASE   
  WHEN MAX(b2.dteEndTime)IS NULL THEN 'No hay archivo'  
  ELSE  
   
   CASE  
   WHEN cr.dteCloseHour IS NULL THEN 'No se conoce hora de cierre'  
   ELSE  
    CASE  
    WHEN MAX(b2.dteEndTime) IS NULL THEN 'Pendiente'  
    ElSE  
     CASE  
     WHEN MAX(b2.dteEndTime) > cr.dteCloseHour THEN 'OK'   
     ELSE 'Pendiente archivo de cierre'  
     END   
    END   
   END   
  END AS txtEvaluacion  
    
  FROM   
  MxProcesses..tblProcessCatalog AS c (NOLOCK)  
   
  LEFT OUTER JOIN MxProcesses..tblProcessBinnacle AS b2 (NOLOCK)  
  ON   
   c.txtProcess = b2.txtProcess  
   AND b2.dteDate = @txtDate  
  LEFT OUTER JOIN MxFixIncome..itblClosesRandom AS cr (NOLOCK)  
  ON cr.dteDate = @txtDate  
   
  WHERE  
  c.txtProcess IN(  
  'FILE_INPUT_ENLACE_CORROS',  
  'FILE_INPUT_EUROB_POSTURES',  
  'FILE_INPUT_MEI_FACTS',  
  'FILE_INPUT_MEI_POSTURES',  
  'FILE_INPUT_SIF_H_PRV',  
  'FILE_INPUT_SIF_P_PRV',  
  'FILE_INPUT_TRADITION_FACTS_PRV',  
  'FILE_INPUT_TRADITION_POST_PRV',  
  'NOTIFY_INPUT_REMATE_HECHOS',  
  'NOTIFY_INPUT_REMATE_POSTURAS',  
  'NOTIFY_INPUT_VAR_HECHOS',  
  'NOTIFY_INPUT_VAR_POSTURAS'  
  )  
  GROUP BY   
  c.txtProcess,  
  cr.dteCloseHour  
  ORDER BY   
  txtEvaluacion,  
  dteLastTime DESC   
  
END  
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;16  
 @txtDate AS CHAR(10),  
 @txtProcess AS VARCHAR(30)  
AS   
  
/*   
 Autor:   CSOLORIO  
 Creacion:  2010222  
 Descripcion: Verifica que se haya ejecutado el proceso PROD_INTRA  
   
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
BEGIN  
  
 SET NOCOUNT ON   
   
 DECLARE @intHora AS INT  
 DECLARE @intMedia AS INT  
  
 SET @intHora = DATEPART(HH,GETDATE())  
  
 IF DATEPART(MI,GETDATE()) < 30  
  SET @intMedia = 1  
 ELSE  
  SET @intMedia = 2  
  
 IF NOT EXISTS(  
  SELECT dteEndTime  
  FROM mxProcesses..tblProcessBinnacle  
  WHERE   
   txtProcess = @txtProcess  
   AND DATEPART(HH,dteEndTime) = @intHora  
   AND dteDate = @txtDate  
   AND txtStatus = 'END'  
   AND   
    CASE  
     WHEN DATEPART(MI,dteEndTime)< 30 THEN 1  
     ELSE 2  
    END = @intMedia)  
 BEGIN  
  
  DECLARE @txtCreationDate AS VARCHAR(25)  
  DECLARE @dteNotificationDate AS DATETIME  
  
  SET @dteNotificationDate = GETDATE()  
  SET @txtCreationDate = STR(DATEPART(yyyy,GETDATE()),4)+  
     CASE WHEN LEN(LTRIM(RTRIM(STR(DATEPART(mm,GETDATE()),2)))) = 1 THEN   
      '0'+LTRIM(RTRIM(STR(DATEPART(mm,GETDATE()),2)))  
     ELSE  
      STR(DATEPART(mm,GETDATE()),2)  
     END+  
     CASE WHEN LEN(LTRIM(RTRIM(STR(DATEPART(dd,GETDATE()),2)))) = 1 THEN   
      '0'+LTRIM(RTRIM(STR(DATEPART(dd,GETDATE()),2)))  
     ELSE  
      STR(DATEPART(dd,GETDATE()),2)  
     END+  
     CASE WHEN LEN(LTRIM(RTRIM(STR(DATEPART(hh,GETDATE()),2)))) = 1 THEN   
      '0'+LTRIM(RTRIM(STR(DATEPART(hh,GETDATE()),2)))  
     ELSE  
      STR(DATEPART(hh,GETDATE()),2)  
     END+  
     CASE WHEN LEN(LTRIM(RTRIM(STR(DATEPART(mi,GETDATE()),2)))) = 1 THEN   
      '0'+LTRIM(RTRIM(STR(DATEPART(mi,GETDATE()),2)))  
     ELSE  
      STR(DATEPART(mi,GETDATE()),2)  
     END+  
     CASE WHEN LEN(LTRIM(RTRIM(STR(DATEPART(ss,GETDATE()),2)))) = 1 THEN   
      '0'+LTRIM(RTRIM(STR(DATEPART(ss,GETDATE()),2)))  
     ELSE  
      STR(DATEPART(ss,GETDATE()),2)  
     END  
  
  SET @txtCreationDate = LTRIM(RTRIM(@txtCreationDate))+ '.000000-360'  
    
  EXEC mxProcesses.dbo.SP_Processes_Control;7 'NOTIFY_INTRA_BLENDER_ERROR', 'PIPCOM11', 'mespinosa', 1234, 9999, @txtCreationDate, @dteNotificationDate  
  
    
 END  
  
 SET NOCOUNT OFF  
END  
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;17  
 @txtDate AS CHAR(10)  
AS   
/*   
 Autor:   CSOLORIO  
 Creacion:  20111021  
 Descripcion: QA INDEVAL (Licuadora de privados)   
 Modificado por: CSOLORIO  
 Modificacion: 20120220  
 Descripcion:    Agrego caso para liquidaciones mayores a 96H  
 Modificado por: Mramirez  
 Modificacion: 20130704  
 Descripcion:    Agrego al universo Tv 2P  
  
*/  
BEGIN  
 SET NOCOUNT ON   
  
 CREATE TABLE #tblData (  
  txtId1 CHAR(11),  
  txtINVTV CHAR(10),  
  txtTv CHAR(10),  
  txtINVEmisora CHAR(10),  
  txtEmisora CHAR(10),  
  txtINVSerie CHAR(10),  
  txtSerie CHAR(10),  
  txtIsin CHAR(12),  
  txtId2 CHAR(12),  
  dblPrice FLOAT,  
  dblAmount FLOAT,  
  dteLiquidationDate DATETIME,  
  txtId1Mirror CHAR(11))  
  
 CREATE TABLE #tblOutstandingDates (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblAmortizationsDates (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblFaceValue (  
  txtId1 CHAR(11),  
  txtCurrency CHAR(5),  
  dblFaceValue FLOAT  
   PRIMARY KEY (txtId1))  
  
 INSERT #tblData (  
  txtId1,  
  txtINVTv,  
  txtTv,  
  txtINVEmisora,  
  txtEmisora,  
  txtINVSerie,  
  txtSerie,  
  txtIsin,  
  txtId2,  
  dblPrice,  
  dblAmount,  
  dteLiquidationDate,  
  txtId1Mirror)  
  
 SELECT DISTINCT  
  i.txtId1,  
  r.txtTv,  
  i.txtTv,  
  r.txtEmisora,  
  i.txtEmisora,  
  r.txtSerie,  
  i.txtSerie,  
  r.txtIsin,  
  i.txtId2,  
  CONVERT(FLOAT,txtPrice) AS dblPrice,  
  CONVERT(FLOAT,txtAmount) AS dblAmount,  
  CONVERT(DATETIME,txtLiquidation) AS dteLiquidationDate,  
  m.txtid1Mirror   
 FROM tmp_tblIndevalReference r  
 LEFT OUTER JOIN tblIds i (NOLOCK)  
 ON  
  r.txtIsin = i.txtId2  
  AND i.txtTv NOT LIKE '%SP'  
 LEFT OUTER JOIN fun_get_mirror_bonds_map(@txtDate) m  
 ON  
  i.txtId1 = m.txtId1  
 WHERE   
  r.txtMatch = 'CON_MATCH'  
  AND r.txtTv IN (  
    '90','91','92','93','94',  
    '95','97','98','D2','D7',  
    'D8','F','J','JI','JE','Q','2P')  
  AND (  
   r.txtOrigin = 'CUENTA_PROPIA'  
   OR r.txtDestiny = 'CUENTA_PROPIA')  
  AND CONVERT(DATETIME,r.txtDate) = @txtDate  
  AND i.txtID1 not in ('MIRC0002017')  
  
  
 -- Obtengo las ultimas fechas de titulos  
  
 INSERT #tblOutstandingDates(  
  txtId1,  
  dteDate)  
  
 SELECT   
  d.txtId1,  
  MAX(o.dteDate)   
 FROM #tblData d  
 INNER JOIN tblOutstanding o (NOLOCK)  
 ON  
  d.txtId1 = o.txtid1  
  AND o.dteDate <= @txtDate  
 GROUP BY  
  d.txtId1  
  
 -- Obtengo las ultimas amortizaciones  
  
 INSERT #tblAmortizationsDates(  
  txtId1,  
  dteDate)  
  
 SELECT   
  d.txtId1,  
  MAX(a.dteAmortization)   
 FROM #tblData d  
 INNER JOIN tblAmortizations a (NOLOCK)  
 ON  
  d.txtId1 = a.txtid1  
  AND a.dteAmortization <= @txtDate  
 GROUP BY  
  d.txtId1  
  
 -- Obtengo el valor nominal  
  
 INSERT #tblFaceValue(  
  txtId1,  
  txtCurrency,  
  dblFaceValue)  
  
 SELECT  
  o.txtId1,  
  b.txtCurrency,  
  CASE  
   WHEN a.dblFactor IS NULL THEN b.dblFaceValue  
   ELSE a.dblFactor  
  END as dblFaceValue  
 FROM #tblOutstandingDates o  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  o.txtId1 = b.txtId1  
 LEFT OUTER JOIN #tblAmortizationsDates ad (NOLOCK)  
 ON  
  o.txtId1 = ad.txtId1  
 LEFT OUTER JOIN tblAmortizations a (NOLOCK)  
 ON  
  o.txtId1 = a.txtId1  
  AND ad.dteDate = a.dteAmortization  
  
  
 SELECT DISTINCT  
  RTRIM(LTRIM(CASE  
   WHEN d.txtId1 IS NULL THEN 'Isin no registrado'  
   WHEN d.dteLiquidationDate > dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN 'Liquidacion mayor a 72H'  
   WHEN d.txtId1Mirror IS NOT NULL THEN   
    CASE  
     WHEN d.txtInvTv != d.txtTv OR d.txtInvEmisora != d.txtEmisora OR d.txtInvEmisora != d.txtEmisora AND (d.txtInvTv != i.txtTv OR d.txtInvEmisora != i.txtEmisora OR d.txtInvEmisora != i.txtEmisora) THEN 'Identificadores diferentes'  
     ELSE '-'  
    END   
   WHEN d.txtId1 IS NOT NULL AND o.dblOutstanding IS NULL THEN 'Sin Titulos'   
   ELSE '-'  
  END)) AS txtMessage,  
  CASE  
   WHEN d.txtTv IS NULL THEN '-'  
   ELSE d.txtTv   
  END AS txtTv,  
  CASE  
   WHEN d.txtEmisora IS NULL THEN '-'  
   ELSE d.txtEmisora   
  END AS txtEmisora,  
  CASE  
   WHEN d.txtSerie IS NULL THEN '-'  
   ELSE d.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN d.txtId2 IS NULL THEN '-'  
   ELSE d.txtId2  
  END AS txtIsin,  
  CASE  
   WHEN d.txtId1 IS NULL THEN '-'  
   ELSE d.txtId1  
  END AS txtId1,  
  CASE  
   WHEN d.txtId1 IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(d.dblPrice,10,8)))   
  END AS txtPrecioIndeval,  
  CASE  
   WHEN p.dblValue IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(p.dblValue,10,8)))  
  END AS txtPrecioPiP,  
  CASE  
   WHEN p.dblValue IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(ABS((p.dblValue /d.dblPrice -1) * 100),10,8)))+'%'  
  END AS txtPrecioDiff,  
  CASE  
   WHEN d.txtId1 IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(d.dblAmount,15,8)))  
  END AS txtMontoIndeval,  
  CASE  
   WHEN o.txtId1 IS NULL THEN '-'  
   ELSE   
    CASE  
     WHEN f.txtCurrency = 'UDI' THEN RTRIM(LTRIM(STR(o.dblOutstanding * irc.dblValue * f.dblFaceValue,15,8)))  
     ELSE RTRIM(LTRIM(STR(o.dblOutstanding * f.dblFaceValue,15,8)))  
    END  
  END txtMontoPiP,  
  CASE  
   WHEN o.dblOutstanding IS NULL THEN '-'  
   ELSE   
    RTRIM(LTRIM(STR(ABS((100 * d.dblAmount /  
    CASE  
     WHEN f.txtCurrency = 'UDI' THEN o.dblOutstanding * irc.dblValue * f.dblFaceValue  
     ELSE o.dblOutstanding * f.dblFaceValue  
    END)),10,8)))+'%'  
  END AS txtMontoDiff,  
  RTRIM(LTRIM(CASE  
   WHEN d.txtId1 IS NULL THEN  'Isin: ' + d.txtIsin + ' Identificadores: ' + RTRIM(d.txtINVTv) + '|' + RTRIM(d.txtINVEmisora) + '|' + RTRIM(d.txtINVSerie)  
   WHEN d.dteLiquidationDate > dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN 'Liquidacion: ' + RTRIM(LTRIM(STR(dbo.fun_count_trading_dates(@txtDate,dteLiquidationDate,'MX') * 24,3,0))) + 'H'  
   WHEN d.txtId1Mirror IS NOT NULL THEN   
    CASE  
     WHEN d.txtInvTv != d.txtTv OR d.txtInvEmisora != d.txtEmisora OR d.txtInvEmisora != d.txtEmisora AND (d.txtInvTv != i.txtTv OR d.txtInvEmisora != i.txtEmisora OR d.txtInvEmisora != i.txtEmisora) THEN 'INV: ' + RTRIM(d.txtINVTv) + '|' + RTRIM(d.txtIN
VEmisora) + '|' + RTRIM(d.txtINVSerie) + ' Espejo: ' + RTRIM(i.txtTv) + '|' + RTRIM(i.txtEmisora) + '|' + RTRIM(i.txtSerie)  
     ELSE '-'  
    END    
   ELSE '-'  
  END)) AS txtAdicInfo  
 FROM #tblData d  
 LEFT OUTER JOIN tblPrices p (NOLOCK)  
 ON  
  d.txtId1 = p.txtId1  
  AND p.dteDate = dbo.fun_NextTradingDate(@txtDate,-1,'MX')  
  AND p.txtitem = 'PRS'  
  AND p.txtLiquidation = 'MD'  
 LEFT OUTER JOIN tblIds i (NOLOCK)  
 ON  
  d.txtId1Mirror = i.txtId1  
 LEFT OUTER JOIN #tblOutstandingDates od  
 ON  
  d.txtId1 = od.txtId1  
 LEFT OUTER JOIN tblOutstanding o (NOLOCK)  
 ON  
  d.txtId1 = o.txtId1  
  AND od.dteDate = o.dteDate  
  AND o.dblOutstanding > 0  
 LEFT OUTER JOIN #tblFaceValue f  
 ON  
  d.txtId1 = f.txtId1  
 LEFT OUTER JOIN tblIrc irc (NOLOCK)  
 ON  
  f.txtCurrency = irc.txtirc  
  AND d.dteLiquidationDate = irc.dteDate    
  
 SET NOCOUNT OFF  
END  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;18  
AS   
  
/*   
 Autor:   Carlos Solorio  
 Creacion:  20111021  
 Descripcion:    Hechos Indeval (Schema)  
  
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
BEGIN  
  
 SELECT TOP 0  
  'txtMessage' AS txtMessage,  
  'txtTv' AS txtTv,  
  'txtEmisora' AS txtEmisora,  
  'txtSerie' AS txtSerie,  
  'txtIsin' AS txtIsin,  
  'txtId1' AS txtId1,  
  'txtPrecioIndeval' AS [txtPrecio Indeval],  
  'txtPrecioPiP' AS [txtPrecio PiP],  
  'txtPrecioDiff' AS [txtPrecio Diff],  
  'txtMontoIndeval' AS [txtMonto Indeval],  
  'txtMontoPiP' AS [txtMontoPiP],  
  'txtPorcentajeMonto' AS [txtPorcentaje Monto],   
  'txtAdicInfo' AS [txtAdic Info]  
END  
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;19  
AS   
  
/*   
 Autor:   Carlos Solorio  
 Creacion:  20111205  
 Descripcion:    QA Nodos no identificados FWD Squema  
  
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
BEGIN  
   
 SELECT TOP 0  
  'txtBroker' AS txtBroker,  
  'intPlazo' AS intPlazo  
END  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;20  
 @txtDate AS CHAR(10),  
 @txtTv AS CHAR(3)  
AS   
/*   
 Autor:   CSOLORIO  
 Creacion:  20111205  
 Descripcion: QA Nodos no identificados FWD   
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 CREATE TABLE #tblNodes(  
  intPlazo INT  
   PRIMARY KEY(intPlazo))  
  
  
 INSERT #tblNodes(  
  intPlazo)  
  
 SELECT  
  CASE   
   WHEN c.fFix = 1 THEN  
    CASE  
     WHEN c.txtUnit IS NULL THEN RTRIM(CAST(c.intBeg AS CHAR(5)))  
     ELSE  
      CASE c.txtUnit  
       WHEN 'W' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, c.txtUnit, c.intBeg / 7) AS CHAR(5)))  
       WHEN 'M' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, c.txtUnit, c.intBeg / 30) AS CHAR(5)))  
       WHEN 'Y' THEN RTRIM(CAST(dbo.fun_term_to_spot(@txtDate, c.txtUnit, c.intBeg / 360) AS CHAR(5)))  
       ELSE RTRIM(CAST(c.intBeg AS CHAR(5)))  
      END   
    END    
   ELSE  
    CASE   
     WHEN SUBSTRING(RTRIM(CAST(c.intBeg - (DATEDIFF(DAY,c.dteBeg,@txtDate)) AS CHAR(5))),1,1) = '-' THEN ''  
     ELSE RTRIM(CAST(c.intBeg - (DATEDIFF(DAY,c.dteBeg,@txtDate)) AS CHAR(5)))   
    END   
  END AS intPlazo  
 FROM itblNodesZeroCatalog AS c (NOLOCK)  
 WHERE   
  c.txtCategory = @txtTv  
  AND c.fStatus = 1  
  AND c.fConfig = 1  
  AND (  
   CASE   
    WHEN fFix = 0 THEN  
     CASE   
      WHEN SUBSTRING(RTRIM(CAST(c.intBeg - (DATEDIFF(DAY,c.dteBeg,@txtDate)) AS CHAR(5))) ,1,1) = '-' THEN 0  
      ELSE 1  
     END  
    ELSE 1  
   END) = 1  
  AND c.intPlazo = 1  
  
 SELECT DISTINCT  
  c.txtBroker,  
  d.intPlazo  
 FROM itblMarketPositionsDerivatives d (NOLOCK)  
 INNER JOIN itblBrokerCatalog c (NOLOCK)  
 ON  
  d.intIdBroker = c.intIdbroker  
 LEFT OUTER JOIN #tblNodes n  
 ON  
  d.intPlazo = n.intPlazo  
 WHERE  
  d.dteDate = @txtDate  
  AND n.intPlazo IS NULL  
  AND d.txtTv = @txtTv  
  AND d.intPlazo != 0  
 ORDER BY   
  c.txtBroker  
  
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;21  
 @txtDate AS CHAR(10)  
AS   
/*   
 Autor:   CSOLORIO  
 Creacion:  20120220  
 Descripcion: QA INDEVAL CIERRE(Licuadora de privados)   
 Modificado por: CSOLORIO  
 Modificacion: 20120518   
 Descripcion:    Agrego restriccion para valor nominal en cero  
 Modificado por: Mike Ramirez  
 Modificacion: 20130704   
 Descripcion:    Agrego al universo tv 2p  
   
*/  
BEGIN  
 SET NOCOUNT ON   
  
 CREATE TABLE #tblData (  
  txtId1 CHAR(11),  
  txtINVTV CHAR(10),  
  txtTv CHAR(10),  
  txtINVEmisora CHAR(10),  
  txtEmisora CHAR(10),  
  txtINVSerie CHAR(10),  
  txtSerie CHAR(10),  
  txtIsin CHAR(12),  
  txtId2 CHAR(12),  
  dblPrice FLOAT,  
  dblAmount FLOAT,  
  dteLiquidationDate DATETIME,  
  txtId1Mirror CHAR(11))  
  
 CREATE TABLE #tblOutstandingDates (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblAmortizationsDates (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblFaceValue (  
  txtId1 CHAR(11),  
  txtCurrency CHAR(5),  
  dblFaceValue FLOAT  
   PRIMARY KEY (txtId1))  
  
 INSERT #tblData (  
  txtId1,  
  txtINVTv,  
  txtTv,  
  txtINVEmisora,  
  txtEmisora,  
  txtINVSerie,  
  txtSerie,  
  txtIsin,  
  txtId2,  
  dblPrice,  
  dblAmount,  
  dteLiquidationDate,  
  txtId1Mirror)  
  
 SELECT DISTINCT  
  i.txtId1,  
  r.txtTv,  
  i.txtTv,  
  r.txtEmisora,  
  i.txtEmisora,  
  r.txtSerie,  
  i.txtSerie,  
  r.txtIsin,  
  i.txtId2,  
  CONVERT(FLOAT,txtPrice) AS dblPrice,  
  CONVERT(FLOAT,txtAmount) AS dblAmount,  
  CONVERT(DATETIME,txtLiquidation) AS dteLiquidationDate,  
  m.txtid1Mirror   
 FROM tmp_tblIndevalReferenceCierre r  
 LEFT OUTER JOIN tblIds i (NOLOCK)  
 ON  
  r.txtIsin = i.txtId2  
  AND i.txtTv NOT LIKE '%SP'  
 LEFT OUTER JOIN fun_get_mirror_bonds_map(@txtDate) m  
 ON  
  i.txtId1 = m.txtId1  
 WHERE   
  r.txtMatch = 'CON_MATCH'  
  AND r.txtTv IN (  
    '90','91','92','93','94',  
    '95','97','98','D2','D7',  
    'D8','F','J','JI','JE','Q','2P','G')  
  AND (  
   r.txtOrigin = 'CUENTA_PROPIA'  
   OR r.txtDestiny = 'CUENTA_PROPIA')  
  AND CONVERT(DATETIME,r.txtDate) = @txtDate  
  AND i.txtID1 not in ('MIRC0002017')  
  
  
 -- Obtengo las ultimas fechas de titulos  
  
 INSERT #tblOutstandingDates(  
  txtId1,  
  dteDate)  
  
 SELECT   
  d.txtId1,  
  MAX(o.dteDate)   
 FROM #tblData d  
 INNER JOIN tblOutstanding o (NOLOCK)  
 ON  
  d.txtId1 = o.txtid1  
  AND o.dteDate <= @txtDate  
 GROUP BY  
  d.txtId1  
  
 -- Obtengo las ultimas amortizaciones  
  
 INSERT #tblAmortizationsDates(  
  txtId1,  
  dteDate)  
  
 SELECT   
  d.txtId1,  
  MAX(a.dteAmortization)   
 FROM #tblData d  
 INNER JOIN tblAmortizations a (NOLOCK)  
 ON  
  d.txtId1 = a.txtid1  
  AND a.dteAmortization <= @txtDate  
 GROUP BY  
  d.txtId1  
  
 -- Obtengo el valor nominal  
  
 INSERT #tblFaceValue(  
  txtId1,  
  txtCurrency,  
  dblFaceValue)  
  
 SELECT  
  o.txtId1,  
  b.txtCurrency,  
  CASE  
   WHEN a.dblFactor IS NULL THEN b.dblFaceValue  
   ELSE a.dblFactor  
  END as dblFaceValue  
 FROM #tblOutstandingDates o  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  o.txtId1 = b.txtId1  
 LEFT OUTER JOIN #tblAmortizationsDates ad (NOLOCK)  
 ON  
  o.txtId1 = ad.txtId1  
 LEFT OUTER JOIN tblAmortizations a (NOLOCK)  
 ON  
  o.txtId1 = a.txtId1  
  AND ad.dteDate = a.dteAmortization  
  
  
 SELECT DISTINCT  
  RTRIM(LTRIM(CASE  
   WHEN d.txtId1 IS NULL THEN 'Isin no registrado'  
   WHEN d.dteLiquidationDate > dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN 'Liquidacion mayor a 72H'  
   WHEN d.txtId1Mirror IS NOT NULL THEN   
    CASE  
     WHEN d.txtInvTv != d.txtTv OR d.txtInvEmisora != d.txtEmisora OR d.txtInvEmisora != d.txtEmisora AND (d.txtInvTv != i.txtTv OR d.txtInvEmisora != i.txtEmisora OR d.txtInvEmisora != i.txtEmisora) THEN 'Identificadores diferentes'  
     ELSE '-'  
    END   
   WHEN d.txtId1 IS NOT NULL AND o.dblOutstanding IS NULL THEN 'Sin Titulos'   
   ELSE '-'  
  END)) AS txtMessage,  
  CASE  
   WHEN d.txtTv IS NULL THEN '-'  
   ELSE d.txtTv   
  END AS txtTv,  
  CASE  
   WHEN d.txtEmisora IS NULL THEN '-'  
   ELSE d.txtEmisora   
  END AS txtEmisora,  
  CASE  
   WHEN d.txtSerie IS NULL THEN '-'  
   ELSE d.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN d.txtId2 IS NULL THEN '-'  
   ELSE d.txtId2  
  END AS txtIsin,  
  CASE  
   WHEN d.txtId1 IS NULL THEN '-'  
   ELSE d.txtId1  
  END AS txtId1,  
  CASE  
   WHEN d.txtId1 IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(d.dblPrice,10,8)))   
  END AS txtPrecioIndeval,  
  CASE  
   WHEN p.dblValue IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(p.dblValue,10,8)))  
  END AS txtPrecioPiP,  
  CASE  
   WHEN p.dblValue IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(ABS((p.dblValue /d.dblPrice -1) * 100),10,8)))+'%'  
  END AS txtPrecioDiff,  
  CASE  
   WHEN d.txtId1 IS NULL THEN '-'  
   ELSE RTRIM(LTRIM(STR(d.dblAmount,15,8)))  
  END AS txtMontoIndeval,  
  CASE  
   WHEN o.txtId1 IS NULL THEN '-'  
   ELSE   
    CASE  
     WHEN f.txtCurrency = 'UDI' THEN RTRIM(LTRIM(STR(o.dblOutstanding * irc.dblValue * f.dblFaceValue,15,8)))  
     ELSE RTRIM(LTRIM(STR(o.dblOutstanding * f.dblFaceValue,15,8)))  
    END  
  END txtMontoPiP,  
  CASE  
   WHEN o.dblOutstanding IS NULL OR f.dblFaceValue = 0 THEN '-'  
   ELSE   
    RTRIM(LTRIM(STR(ABS((100 * d.dblAmount /  
    CASE  
     WHEN f.txtCurrency = 'UDI' THEN o.dblOutstanding * irc.dblValue * f.dblFaceValue  
     ELSE o.dblOutstanding * f.dblFaceValue  
    END)),10,8)))+'%'  
  END AS txtMontoDiff,  
  RTRIM(LTRIM(CASE  
   WHEN d.txtId1 IS NULL THEN  'Isin: ' + d.txtIsin + ' Identificadores: ' + RTRIM(d.txtINVTv) + '|' + RTRIM(d.txtINVEmisora) + '|' + RTRIM(d.txtINVSerie)  
   WHEN d.dteLiquidationDate > dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN 'Liquidacion: ' + RTRIM(LTRIM(STR(dbo.fun_count_trading_dates(@txtDate,dteLiquidationDate,'MX') * 24,3,0))) + 'H'  
   WHEN d.txtId1Mirror IS NOT NULL THEN   
    CASE  
     WHEN d.txtInvTv != d.txtTv OR d.txtInvEmisora != d.txtEmisora OR d.txtInvEmisora != d.txtEmisora AND (d.txtInvTv != i.txtTv OR d.txtInvEmisora != i.txtEmisora OR d.txtInvEmisora != i.txtEmisora) THEN 'INV: ' + RTRIM(d.txtINVTv) + '|' + RTRIM(d.txtINV
Emisora) + '|' + RTRIM(d.txtINVSerie) + ' Espejo: ' + RTRIM(i.txtTv) + '|' + RTRIM(i.txtEmisora) + '|' + RTRIM(i.txtSerie)  
     ELSE '-'  
    END    
   ELSE '-'  
  END)) AS txtAdicInfo  
 FROM #tblData d  
 LEFT OUTER JOIN tblPrices p (NOLOCK)  
 ON  
  d.txtId1 = p.txtId1  
  AND p.dteDate = dbo.fun_NextTradingDate(@txtDate,-1,'MX')  
  AND p.txtitem = 'PRS'  
  AND p.txtLiquidation = 'MD'  
 LEFT OUTER JOIN tblIds i (NOLOCK)  
 ON  
  d.txtId1Mirror = i.txtId1  
 LEFT OUTER JOIN #tblOutstandingDates od  
 ON  
  d.txtId1 = od.txtId1  
 LEFT OUTER JOIN tblOutstanding o (NOLOCK)  
 ON  
  d.txtId1 = o.txtId1  
  AND od.dteDate = o.dteDate  
  AND o.dblOutstanding > 0  
 LEFT OUTER JOIN #tblFaceValue f  
 ON  
  d.txtId1 = f.txtId1  
 LEFT OUTER JOIN tblIrc irc (NOLOCK)  
 ON  
  f.txtCurrency = irc.txtirc  
  AND d.dteLiquidationDate = irc.dteDate    
  
 SET NOCOUNT OFF  
END  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;22  
AS  
---------------------------------------------------------------------------------------  
-- Autor:   CSOLORIO  
-- Fecha Creacion: 20120320  
-- Descripcion:  Schema auditoria mercado  
-- Autor Modif.:   
-- Fecha Modif.:   
-- Descripcion:    
---------------------------------------------------------------------------------------  
BEGIN  
  
 SELECT TOP 0  
  'ANY' AS txtId1,  
  'ANY' AS txtTv,  
  'ANY' AS txtEmisora,  
  'ANY' AS txtSerie,  
  'ANY' AS [txtFija/Flot],  
  'ANY' AS txtHora,  
  'ANY' AS txtBroker,  
  'ANY' AS txtNivel,  
  3.1415 AS [dblPiP Antes],  
  3.1415 AS [dblPiP Despues],  
  'ANY' AS txtComentario  
  
END  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;23  
 @txtDate VARCHAR(10)  
AS  
---------------------------------------------------------------------------------------  
-- Autor:   CSOLORIO BY JATO  
-- Fecha Creacion: 20120320  
-- Descripcion:  Tracking para licuadora de mercado INV  
-- Autor Modif.:   
-- Fecha Modif.:   
-- Descripcion:    
---------------------------------------------------------------------------------------  
BEGIN  
  
  
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  
  CASE t.intFixFloat  
  WHEN 1 THEN 'FIX'  
  ELSE 'FLOAT'  
  END AS txtFixFloat,  
    
  CONVERT(CHAR(8), t.dteTime, 108) AS txtTime,  
  bc.txtBroker,  
  RTRIM(t.txtOperation) + ': ' + LTRIM(STR(t.dblMarket, 10, 4)) AS txtMarket,  
  
  CAST(  
   CASE t.intFixFloat  
   WHEN 1 THEN t.dblLastYTM  
   ELSE t.dblLastLDR  
   END AS DECIMAL(10, 4))dblLast,  
  
  CAST(  
   CASE t.intFixFloat  
   WHEN 1 THEN t.dblCurrentYTM  
   ELSE dblCurrentLDR  
   END AS DECIMAL(10, 4))dblCurr,  
  
  CASE   
  CAST(  
   CASE t.intFixFloat  
   WHEN 1 THEN t.dblCurrentYTM  
   ELSE dblCurrentLDR  
   END -   
  
   CASE t.intFixFloat  
   WHEN 1 THEN t.dblLastYTM  
   ELSE t.dblLastLDR  
   END AS DECIMAL(10, 4))  
  WHEN 0 THEN ''  
  ELSE '<< cambio'  
  END AS txtFlag  
  
 FROM  
  inv.itblTrackingPositionsPrivates AS t  
  INNER JOIN tblIds AS i  
  ON t.txtId1 = i.txtId1  
  INNER JOIN itblBrokerCatalog AS bc  
  ON t.intIdBroker = bc.intIdBroker  
 WHERE  
  t.dteDate = @txtDate  
 ORDER BY   
  5,    
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  t.dteTime  
  
END  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;24  
/*   
 Autor:   CSOLORIO  
 Creacion:  20131217  
 Descripcion: Para generar el esquema de la informacion de Spreads  
  
 Modificado por:   
 Modificacion:  
 Descripcion:  
*/  
AS   
BEGIN  
  
 SELECT TOP 0  
  '20060208' AS txtDate,  
  'txtBroker' AS txtBroker,  
  'txttv' AS txtTv,  
  1 AS intPlazoIni,  
  1 AS intPlazoFin,  
  'txtOperation' AS txtOperation,  
  '1.1' AS dblRate,  
  1.1 AS dblAmount,  
  '20051025' AS dteBeginHour,  
  '20051025' AS dteEndHour,  
  -999 AS intMinutes  
  
  
END  
  
CREATE PROCEDURE dbo.spi_Auditoria_Licuadora;25  
 @txtDate AS CHAR(10),  
 @txtPlazo AS VARCHAR(20),  
 @txtTv AS CHAR(11)  
AS   
/*   
 Autor:   CSOLORIO  
 Creacion:  20131217  
 Descripcion: Para obtener informacion de Spreads  
  
 Modificado por:   
 Modificacion:  
 Descripcion:  
*/  
BEGIN  
  
  
 SET NOCOUNT ON   
  
  
 DECLARE @intTvs AS INT  
 DECLARE @intPlazoIni AS INT  
 DECLARE @intPlazoFin AS INT  
  
  
   
 IF CHARINDEX('-',@txtPlazo) > 0   
 BEGIN  
  SET @intPlazoIni = SUBSTRING(@txtPlazo,1,CHARINDEX('-',@txtPlazo)-1)  
  SET @intPlazoFin = SUBSTRING(@txtPlazo,CHARINDEX('-',@txtPlazo)+1,LEN(@txtPlazo)-CHARINDEX('-',@txtPlazo))  
 END  
 ELSE  
 BEGIN  
  SET @intPlazoIni = @txtPlazo  
  SET @intPlazoFin = @txtPlazo  
 END  
    
 SELECT  @intTvs = COUNT(txtTv)  
 FROM  itblCategoryTvs  
 WHERE txtSubCategory = @txtTv  
  
   
 IF @intTvs = 1   
 BEGIN  
  SET @txtTv = ( SELECT  txtTv  
    FROM  itblCategoryTvs  
    WHERE txtSubCategory = @txtTv)  
 END  
  
   
   
 SELECT  @txtDate AS txtDate,  
  c.txtBroker,  
  b.txtTv,  
  b.intPlazoIni,  
  b.intPlazoFin,  
  b.txtOperation,  
  b.dblRate,  
  b.dblAmount,  
  CONVERT(Char(8), b.dteBeginhour, 108) AS dteBeginHour,  
  CONVERT(Char(8), b.dteEndHour, 108) AS dteEndHour,  
  DATEDIFF(MINUTE,b.dteBeginHour,b.dteEndHour) AS intMinutes  
 FROM  itblDerivativesSpreads AS b   
 INNER JOIN itblBrokercatalog AS c  
 ON b.intIdBroker = c.intIdBroker  
 WHERE  b.dteDate = @txtDate  
 AND b.intPlazoIni <= @intPlazoFin  
 AND b.intPlazoFin >= @intPlazoIni  
 AND b.txtTv = @txtTv  
  
 SET NOCOUNT OFF  
  
END  
  