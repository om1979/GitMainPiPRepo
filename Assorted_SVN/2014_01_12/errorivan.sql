  
-- Autor:   Mike Ramírez   
-- Creacion:  09:48 a.m. 2011-10-04  
-- Descripcion: Modulo 31: Procedimiento que genera producto JPMorganCCYBasis_[yyyymmdd].xls   
ALTER  PROCEDURE dbo.sp_productos_JPMORGAN;31  '20140722' 
  @txtDate AS DATETIME   --= '20140722'
AS      
BEGIN      
  
SET NOCOUNT ON  
  
 -- creo tabla temporal de Directivas  
 DECLARE @tblDirectives TABLE (  
   indSheet INT,  
   SheetName CHAR(50),  
   intSection INT,  
   txtSource CHAR(50),  
   txtCode CHAR(250),  
   intCol INT,  
   intRow INT,  
   txtValue CHAR(50),  
   Node INT  
  PRIMARY KEY (indSheet, intCol, intRow)  
  )   
  
 -- Creación de Directivas para obtener información  
 -- <Sheet1> Date  
  
 INSERT @tblDirectives          
  SELECT 01,'Sheet1',1,'DATE','YYYYMMDD',2,1,CONVERT(CHAR(10),@txtDate,103),0  
  
 -- <Sheet1> SWPLIBTIIE  
 INSERT @tblDirectives  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1',4,6,NULL,1 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|28',4,7,NULL,28 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|56',4,8,NULL,56 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|84',4,9,NULL,84 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|168',4,10,NULL,168 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|252',4,11,NULL,252 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|364',4,12,NULL,364 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|728',4,13,NULL,728 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1092',4,14,NULL,1092 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1456',4,15,NULL,1456 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1820',4,16,NULL,1820 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|2548',4,17,NULL,2548 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|3640',4,18,NULL,3640 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|4368',4,19,NULL,4368 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|5460',4,20,NULL,5460 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|7280',4,21,NULL,7280 UNION  
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|10920',4,22,NULL,10920  
  
 -- Obtengo los valores de los SWPLIBTIIE  
  UPDATE td   
   SET txtValue = LTRIM(STR(ROUND(dblLevel*100,8),12,8))  
  FROM @tblDirectives AS td  
  INNER JOIN tblMarkets AS m (NOLOCK)  
  ON td.node = m.intTerm  
  WHERE dteDate = @txtDate   
    AND m.txtCode = 'SWPLIBTIIE'  
    AND m.intTerm IN ('1','28','56','84','168','252','364','728','1092','1456','1820','2548','3640','4368','5460','7280','10920')  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tblDirectives WHERE txtValue IS NULL) > 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
 BEGIN  
  
    -- regreso los limites  
   SELECT  
    intSection,  
    MIN(intCol) AS intMinCol,  
    MAX(intCol) AS intMaxCol,  
    MIN(intRow) AS intMinRow,  
    MAX(intRow) AS intMaxRow  
    FROM @tblDirectives  
    GROUP BY   
    intSection  
    ORDER BY   
    intSection  
  
   -- regreso las directivas  
   SELECT   
    LTRIM(STR(intSection)) AS [intSection],  
    txtSource,  
    txtCode,  
    intCol AS [intCol],  
    intRow AS [intRow],  
    RTRIM(txtValue) AS [txtValue]  
   FROM @tblDirectives  
   ORDER BY   
    intSection,  
    intCol,  
    intRow  
  
 END   
  
 SET NOCOUNT OFF  
  
END  
  
    