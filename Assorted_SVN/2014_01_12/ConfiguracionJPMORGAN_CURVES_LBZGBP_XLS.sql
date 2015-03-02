


SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'JPMORGAN_CURVES_LBZGBP_XLS'


SELECT * FROM  MxProcesses..tblProductGeneratorMap AS TPGM
WHERE txtProduct = 'JPMORGAN_CURVES_LBZGBP_XLS'






UPDATE MxProcesses..tblProductGeneratorMap 
SET txtPack = 'INACTIVO'
WHERE txtProduct = 'JPMORGAN_CURVES_LBZGBP_XLS'

SELECT * FROM  MxProcesses..tblProductGeneratorMap AS TPGM
WHERE txtPack = 'OPERATIVO_2'


--INACTIVO



UPDATE  MxProcesses..tblProductGeneratorMap 
SET fload  = 1
WHERE txtProduct = 'PIP_MARKET_REF_DEF_HTM'



--JPMORGAN_CURVES_LBZGBP_XLS	FilePath	STR                 	
--\\pipmxsql\PRODUCCION\MXVPRECIOS\PRODUCTOS\DEFINITIVO\JPMORGAN\ACTUAL\

--\\pipmxsql\produccion\MxVprecios\temp\


UPDATE    dbo.tblActiveX 
SET txtValor = '\\pipmxsql\PRODUCCION\MXVPRECIOS\PRODUCTOS\DEFINITIVO\JPMORGAN\ACTUAL\'
WHERE txtProceso = 'JPMORGAN_CURVES_LBZGBP_XLS'
AND txtPropiedad = 'FilePath'











--JPMORGAN_CURVES_LBZGBP_XLS-- FORMATO XLS
------------------------------------------------------------------------------------  
-- Autor:   Mike Ramirez  
-- Fecha Creacion: 11:15 a.m. 2012-08-14  
-- Descripcion:  Modulo 41: Genera el producto JPM_CURVA_LIBOR-GBP_[yyyymmdd].XLS  
------------------------------------------------------------------------------------  
ALTER  PROCEDURE dbo.sp_productos_JPMORGAN;41  '20141006'
  @txtDate AS VARCHAR(10)  
AS   
BEGIN  
  
  
 SET NOCOUNT ON  
  
 DECLARE @tmpLayoutxlCurve TABLE (  
  SheetName CHAR(50),  
  Col INT,  
  Header CHAR(50),  
        Source CHAR(20),  
        Type CHAR(3),  
  SubType CHAR(3),  
  Range CHAR(15),  
  Factor CHAR(5),  
  DataType CHAR(3),   
  DataFormat CHAR(20),  
  fLoad CHAR(1),  
 PRIMARY KEY (Col)  
 )   
  
 -- <Sheet1> = Sheet1  
 INSERT @tmpLayoutxlCurve   
  SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION   
  --SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'LIBOR GBP'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [DataFormat],'1' AS [fLoad]  
  SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'LIBOR GBP'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [DataFormat],'1' AS [fLoad]  
 
 SELECT  
  RTRIM(SheetName) AS [SheetName],  
  Col AS [Col],  
  RTRIM(Header) AS [Header],  
        RTRIM(Source) AS [Source],  
        RTRIM(Type) AS [Type],  
  RTRIM(SubType) AS [SubType],  
  RTRIM(Range) AS [Range],  
  RTRIM(Factor) AS [Factor],  
  RTRIM(DataType) AS [DataType],   
  RTRIM(DataFormat) AS [DataFormat],  
  RTRIM(fLoad) AS [fLoad]  
 FROM @tmpLayoutxlCurve  
 ORDER BY Col  
  
 SET NOCOUNT OFF  
  
END  











/*TXT*/
--------------------------------------------------------------------------------------  
---- Autor:   Mike Ramirez  
---- Fecha Creacion: 11:15 a.m. 2012-08-14  
---- Descripcion:  Modulo 41: Genera el producto JPM_CURVA_LIBOR-GBP_[yyyymmdd].XLS  
--------------------------------------------------------------------------------------  
----CREATE PROCEDURE dbo.sp_productos_JPMORGAN;41  
----  @txtDate AS VARCHAR(10)  
----AS   
----BEGIN  
--  DECLARE @txtDate AS VARCHAR(10)  = '20141003'
  
-- SET NOCOUNT ON  
  
-- DECLARE @tmpLayoutxlCurve TABLE (  
--  SheetName CHAR(50),  
--  Col INT,  
--  Header CHAR(50),  
--        Source CHAR(20),  
--        Type CHAR(3),  
--  SubType CHAR(3),  
--  Range CHAR(15),  
--  Factor CHAR(5),  
--  DataType CHAR(3),   
--  DataFormat CHAR(20),  
--  fLoad CHAR(1),  
-- PRIMARY KEY (Col)  
-- )   
  
-- -- <Sheet1> = Sheet1  
-- INSERT @tmpLayoutxlCurve   
--  SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION   
--  SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION   
--  SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'LIBOR GBP'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [DataFormat],'1' AS [fLoad]  
   
-- SELECT  
--  RTRIM(SheetName) AS [SheetName],  
--  Col AS [Col],  
--  RTRIM(Header) AS [Header],  
--        RTRIM(Source) AS [Source],  
--        RTRIM(Type) AS [Type],  
--  RTRIM(SubType) AS [SubType],  
--  RTRIM(Range) AS [Range],  
--  RTRIM(Factor) AS [Factor],  
--  RTRIM(DataType) AS [DataType],   
--  RTRIM(DataFormat) AS [DataFormat],  
--  RTRIM(fLoad) AS [fLoad]  
-- FROM @tmpLayoutxlCurve  
-- ORDER BY Col  
  
---- SET NOCOUNT OFF  
  
----END  