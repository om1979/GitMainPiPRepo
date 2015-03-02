
  
  
  
  
  
-- para obtener calculadora y familia del security  
-- especificado  
/*  
 Modifica:  POA  
 Fecha:   20121227  
 Modificacion: Agrego funcionalidad para traer la familia de instrumentos 1R  
*/  


spi_agrega_instrumentos
--CREATE PROCEDURE [dbo].[spi_agrega_instrumentos];17  'MIRC0013554'
 @txtId1 AS CHAR (11)  
--AS  
--BEGIN  
   
  
 -- verifico si la familia del instrumento  
 -- esta tipificada y lista para valuar ...  
 IF EXISTS (  
  
  SELECT b.txtId1  
  FROM   
   tblBonds AS b  
   INNER JOiN tblValuationMap AS v  
   ON  
    b.txtType = v.txtType  
    AND b.txtSubType = v.txtSubType  
  WHERE  
   b.txtId1 = @txtId1  
  UNION  
  SELECT  e.txtId1  
  FROM   
   tblEquity AS e  
   INNER JOiN tblValuationMap AS v  
   ON   
    e.txtType = v.txtType  
    AND e.txtSubType = v.txtSubType  
   INNER JOIN tblCalculatorsCAtalog AS cc  
   ON   
    v.txtCalculator = cc.txtCalculator  
  WHERE  
   e.txtId1 = @txtId1  
  UNION  
  SELECT  e.txtId1  
  FROM   
   tblDerivatives AS e  
   INNER JOiN tblValuationMap AS v  
   ON   
    e.txtType = v.txtType  
    AND e.txtSubType = v.txtSubType  
   INNER JOIN tblCalculatorsCAtalog AS cc  
   ON   
    v.txtCalculator = cc.txtCalculator  
  WHERE  
   e.txtId1 = @txtId1  
  UNION  
  SELECT  e.txtId1  
  FROM   
   tblPrivate AS e  
   INNER JOiN tblValuationMap AS v  
   ON   
    e.txtType = v.txtType  
    AND e.txtSubType = v.txtSubType  
   INNER JOIN tblCalculatorsCAtalog AS cc  
   ON   
    v.txtCalculator = cc.txtCalculator  
  WHERE  
   e.txtId1 = @txtId1     
 )  
   
  -- regreso el mercado y la familia con base  
  -- en el Id1  
  SELECT    
   UPPER(RTRIM(b.txtId1)) AS txtId1,  
   cc.intMarket,  
   UPPER(RTRIM(b.txtType)) AS txtFamType,  
   UPPER(RTRIM(b.txtSubType)) AS txtFamSubType  
  FROM   
   tblBonds AS b  
   INNER JOiN tblValuationMap AS v  
   ON   
    b.txtType = v.txtType  
    AND b.txtSubType = v.txtSubType  
   INNER JOIN tblCalculatorsCAtalog AS cc  
   ON   
    v.txtCalculator = cc.txtCalculator  
  WHERE  
   b.txtId1 = @txtId1  
  UNION  
  SELECT    
   UPPER(RTRIM(e.txtId1)) AS txtId1,  
   cc.intMarket,  
   UPPER(RTRIM(e.txtType)) AS txtFamType,  
   UPPER(RTRIM(e.txtSubType)) AS txtFamSubType  
  FROM   
   tblEquity AS e  
   INNER JOiN tblValuationMap AS v  
   ON   
    e.txtType = v.txtType  
    AND e.txtSubType = v.txtSubType  
   INNER JOIN tblCalculatorsCAtalog AS cc  
   ON   
    v.txtCalculator = cc.txtCalculator  
  WHERE  
   e.txtId1 = @txtId1  
  UNION  
  SELECT    
   UPPER(RTRIM(e.txtId1)) AS txtId1,  
   cc.intMarket,  
   UPPER(RTRIM(e.txtType)) AS txtFamType,  
   UPPER(RTRIM(e.txtSubType)) AS txtFamSubType  
  FROM   
   tblDerivatives AS e  
   INNER JOiN tblValuationMap AS v  
   ON   
    e.txtType = v.txtType  
    AND e.txtSubType = v.txtSubType  
   INNER JOIN tblCalculatorsCAtalog AS cc  
   ON   
    v.txtCalculator = cc.txtCalculator  
  WHERE  
   e.txtId1 = @txtId1  
  UNION  
  SELECT    
   UPPER(RTRIM(e.txtId1)) AS txtId1,  
   1,  
   UPPER(RTRIM(e.txtType)) AS txtFamType,  
   UPPER(RTRIM(e.txtSubType)) AS txtFamSubType  
  FROM   
   tblPrivate AS e  
   INNER JOiN tblValuationMap AS v  
   ON   
    e.txtType = v.txtType  
    AND e.txtSubType = v.txtSubType  
   INNER JOIN tblCalculatorsCAtalog AS cc  
   ON   
    v.txtCalculator = cc.txtCalculator  
  WHERE  
   e.txtId1 = @txtId1  
  
 ELSE  
  
  -- regreso el mercado con base en el tipo de valor  
  -- regreso la familia con base en valores default  
  SELECT   
   @txtId1 AS txtId1,  
   intMarket,  
   'OUT' AS txtFamType,  
   'OUT' AS txtFamSubType  
  FROM   
   tblTvCatalog AS tvc  
   INNER JOIN tblIds AS i  
   ON tvc.txtTv = i.txtTv    
  WHERE  
   i.txtId1 = @txtId1   
  
--END  
  
  