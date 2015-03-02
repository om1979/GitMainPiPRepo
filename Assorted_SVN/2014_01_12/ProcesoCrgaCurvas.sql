  
  
  
  

ALTER   PROCEDURE dbo.sp_Productos_Demo;5 '20081101' ,'UDB','STP'  
 @txtDate AS DATETIME,  
 @txtType AS VARCHAR(5),  
 @txtSubType AS VARCHAR(5)  
   
AS  
 BEGIN  
   
  SET NOCOUNT ON  
    
    
 -- DECLARE   
 --  @txtDate AS DATETIME,  
 --@txtType AS VARCHAR(5),  
 --@txtSubType AS VARCHAR(5)  
 --SET @txtDate = '2008-12-02 00:00:00.000'   
 --SET @txtType = 'MSG'   
 --SET @txtSubType = 'YLD'  
    
      
  DECLARE @tmpLayoutxlCurve TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmpLayoutxlCurve  
   SELECT  
    1,   
    'term' + ',' + 'rate' + ',' + CONVERT(CHAR(10),@txtDate,103)  
  
  INSERT @tmpLayoutxlCurve  
  SELECT  
   2,   
   LTRIM(intplazo) + ',' +  
   LTRIM(STR(dblValue,19,10))    
	FROM  dbo.tmp_specific_nodeCurves
	 WHERE detdate = @txtDate
	 AND txtType = @txtType
	 AND txtsubType = @txtSubType
  ORDER BY intplazo  
  
  
  SELECT txtData  
  FROM @tmpLayoutxlCurve  
  
  SET NOCOUNT OFF  
  
END  


--/*Back Originañ

  
ALTER   PROCEDURE dbo.sp_Productos_Demo;5 --'20131012' ,'UDB','STP'  
 @txtDate AS DATETIME,  
 @txtType AS VARCHAR(5),  
 @txtSubType AS VARCHAR(5)  
   
AS  
 BEGIN  
   
  SET NOCOUNT ON  
    
    
 -- DECLARE   
 --  @txtDate AS DATETIME,  
 --@txtType AS VARCHAR(5),  
 --@txtSubType AS VARCHAR(5)  
 --SET @txtDate = '20131001'   
 --SET @txtType = 'UDB'   
 --SET @txtSubType = 'STP'  
    
      
  DECLARE @tmpLayoutxlCurve TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmpLayoutxlCurve  
   SELECT  
    1,   
    'term' + ',' + 'rate' + ',' + CONVERT(CHAR(10),@txtDate,103)  
  
  INSERT @tmpLayoutxlCurve  
  SELECT  
   2,   
   LTRIM(intTerm) + ',' +  
   LTRIM(STR(dblRate,19,10))    
  FROM MxFixIncome.dbo.fun_get_curve_historic_complete (@txtDate,@txtType,@txtSubType)   
  WHERE intTerm IN (2520,3600,5400,7200,9000,10800)  
  ORDER BY intTerm  
  
  SELECT txtData  
  FROM @tmpLayoutxlCurve  
  
  SET NOCOUNT OFF  
  
END  

--*/

