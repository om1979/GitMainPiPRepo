    
--IF OBJECT_ID('tempdb..#tblOperacion')IS NOT NULL    
--DROP TABLE #tblOperacion    
    
--IF OBJECT_ID('tempdb..#tblOperacionMatutina')IS NOT NULL    
--DROP TABLE #tblOperacionMatutina    
    
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
   
  Modificado por: Omar Adrian Aceves Gutierrez      
 Modificacion:    2014-09-15 16:04:16.977   
 Descripcion:  se agrega variable @NomOfDates para obtenener 2 dias habiles en subastas   
   
*/      
  
--ALTER      PROCEDURE dbo.spi_Auditoria_Licuadora;1    
 DECLARE @txtDate AS CHAR(10) = '20140918'      
 declare @intPlazo AS INT = '195'      
 declare @txtTv AS CHAR(11)= 'BI'      
 declare @intBanda AS INTEGER = 1      
  
   
-- AS     
-- BEGIN      
-- SET NOCOUNT ON       
       
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
 --AND CONVERT(VARCHAR(10),dteBeginHour) >= @txtHoraBanda1     
 AND dteEndHour <= @dteHoraCierre      
 AND intPlazo = @intPlazo      
 AND txtTv = @txtTv   
 
 SELECT @txtHoraBanda1
 
 