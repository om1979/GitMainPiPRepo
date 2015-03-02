
/*  
  DESCRIPCIÓN: Procedimiento que trae los datos de la BD    
      hacia la grid para el modulo de encuestas     
*/  
  
  
  spi_encuestas_intradia;2
  go
  dbo.spi_encuestas_intradia;15  '20141002','CET'
 --CREATE PROCEDURE dbo.spi_encuestas_intradia;15  '20141002','CET'
  DECLARE @txtDate AS VARCHAR(10) = '20141002'    
  declare @txtCategory AS VARCHAR(5)= 'CET'    
  
AS    
BEGIN    
    
 SELECT  CONVERT(CHAR(8), b.dteTime,108) AS [Fecha],    
  CAST(DATEDIFF(DAY,@txtDate,c.dteMaturity) AS CHAR(5)) AS [Nodo],    
  b.dblValue AS [Valor],    
  d.txtTV,    
  d.txtEmisora,    
  d.txtSerie    
 FROM  tblBonds AS c INNER JOIN     
  itblNodesYTMCatalog AS a ON c.txtId1 = a.txtId1     
  INNER JOIN itblNodesYTMLevelsIntra AS b    
  ON a.intSerialYTM = b.intSerialYTM,    
  tblIds AS d    
 WHERE a.intSerialYTM = b.intSerialYTM    
 AND  b.dteDate = @txtDate    
 AND a.txtCategory = @txtCategory    
 AND     a.fStatus = 1    
 AND c.txtId1 = d.txtId1    
 AND (DATEDIFF(DAY,b.dteDate,@txtDate)) < 15    
 AND  c.dteMaturity >= @txtDate    
 AND  CONVERT(CHAR(8), b.dteTime,108)  = ( SELECT MAX(dteTime) FROM  itblNodesYTMLevelsIntra  
 WHERE dteDate >= @txtDate)  
  
 UNION    
      
 SELECT  CONVERT(CHAR(8), b.dteTime,108) AS [Fecha],    
  CASE WHEN fFix = 1 THEN    
   RTRIM(CAST(intBeg AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5)))    
  ELSE    
   CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5))),1,1) = '-' THEN    
    ''    
   ELSE    
    RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5)))    
   END    
  END AS [Nodo],    
  b.dblValue AS [Valor],    
  '' AS txtTV,    
  txtSubCategory AS txtEmisora,    
  '' AS txtSerie    
 FROM  itblNodesZeroCatalog AS a INNER JOIN    
  itblNodesZeroLevelsIntra AS b ON a.intSerialZero = b.intSerialZero    
 WHERE b.dteDate = @txtDate    
 AND a.txtCategory = @txtCategory    
 AND     a.fStatus = 1    
 AND (    
  CASE WHEN fFix = 0 THEN    
   CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) + '-' + RTRIM(CAST(intEnd AS CHAR(5))),1,1) = '-' THEN    
    0    
   ELSE    
    1    
   END    
  ELSE    
   1    
  END    
  ) = 1    
 AND  (DATEDIFF(DAY,b.dteDate,@txtDate)) < 15    
 AND a.intPlazo = 2    
    
    
 UNION    
    
 SELECT  CONVERT(CHAR(8), b.dteTime,108) AS [Fecha],    
  CASE WHEN fFix = 1 THEN    
   RTRIM(CAST(intBeg AS CHAR(5)))    
  ELSE    
   CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))),1,1) = '-' THEN    
    ''    
   ELSE    
    RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5)))     
   END     
  END AS [Nodo],    
  b.dblValue AS [Valor],    
  '' AS txtTV,    
  txtSubCategory AS txtEmisora,    
  '' AS txtSerie    
 FROM  itblNodesZeroCatalog AS a INNER JOIN    
  itblNodesZeroLevelsIntra AS b ON a.intSerialZero = b.intSerialZero    
 WHERE b.dteDate = @txtDate    
 AND a.txtCategory = @txtCategory    
 AND     a.fStatus = 1    
 AND (    
  CASE WHEN fFix = 0 THEN    
   CASE WHEN SUBSTRING(RTRIM(CAST(intBeg - (DATEDIFF(DAY,a.dteBeg,@txtDate)) AS CHAR(5))) ,1,1) = '-' THEN    
    0    
   ELSE    
    1    
   END    
  ELSE    
   1    
  END    
  ) = 1    
 AND  (DATEDIFF(DAY,b.dteDate,@txtDate)) < 15    
 AND a.intPlazo = 1    
 AND  CONVERT(CHAR(8), b.dteTime,108)  = ( SELECT MAX(dteTime) FROM  itblNodesYTMLevelsIntra  
 WHERE dteDate >= @txtDate)  
    
END     
  