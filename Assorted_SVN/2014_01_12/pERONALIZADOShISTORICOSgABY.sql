




SELECT * FROM  dbo.tblProcesos AS TP
WHERE txtProducto = 'JPMORGAN_VOL_SURFACES'

SELECT * FROM  MxProcesses..tblProductGeneratorMap AS TPP
WHERE txtProduct = 'JPMORGAN_VOL_SURFACES'

SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'JPMORGAN_VOL_SURFACES'

SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
WHERE txtProcess = 'JPMORGAN_VOL_SURFACES'

SELECT * FROM  MxProcesses..tblProcessConfiguration AS TPC
WHERE txtProcess = 'JPMORGAN_VOL_SURFACES'



sp_productos_JPMORGAN;37 ''

SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'JPMORGAN_VOL_SURFACES'


UPDATE dbo.tblActiveX
SET txtValor = '\\vic-testsql\PRODUCCION\MxVprecios\PRODUCTOS\DEFINITIVO\JPMORGAN\ACTUAL\'
WHERE txtProceso = 'JPMORGAN_VOLAT_MXNVOL'
AND txtPropiedad = 'FilePath'


sp_productos_JPMORGAN;17



 SELECT * FROM  MxProcesses..tblProductGeneratorMap AS TPGM
WHERE txtProduct = 'JPMORGAN_VOLAT_MXNVOL'

 
 
 
 
UPDATE MxProcesses..tblProductGeneratorMap 
SET txtPack = 'operativo_2'
WHERE txtProduct = 'JPMORGAN_VOLAT_MXNVOL'



SELECT * FROM  MxProcesses..tblProductGeneratorMap AS TPGM
WHERE txtPack = 'operativo_2'













SELECT * FROM  MXN/VOL





sp_productos_JPMORGAN;34 '20150129'



SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtValor LIKE '%JPM_VOL_SURFACES%'




----SE PUEDE GENERAR CON FUNCION HISTORICA   --listo
--JPMORGAN_CURVES_YIELD
--YIELD_CURVES_[YYYYMMDD].CSV
----SE PUEDE GENERAR CON FUNCION HISTORICA   --listo
--Borrow_Rates_[DATE|YYYYMMDD].csv
--JPMORGAN_CURVES_BORROW



--POR DIRECTIVAS QUZA HAYA PROBLEMA
JPMorgan_MXNVOL[DATE|YYYYMMDD].xls
JPMORGAN_VOLAT_MXNVOL


--POR DIRECTIVAS QUZA HAYA PROBLEMA
JPM_VOL_SURFACES[DATE|YYYYMMDD].CSV
JPMORGAN_VOL_SURFACES


----REQUIERE DATOS DE UNIFICADA   --listo
--JPMORGAN_FRPIP_SPOTPRICES
--Spot_Prices_[DATE|YYYYMMDD].csv






------------------------------------------------------------------------------------  
--   Modificado por: Mike Ramirez  
--   Modificacion:  09:46 a.m. 2012-03-16  
--   Descripcion:     Modificacion Modulo 36: Modificar las curvas que se reportan,   
--      se elminina (TSN/YLD), se agrega (LIB/LB) y (LUS/SWP)  
-------------------------------------------------------------------------------------    
--CREATE PROCEDURE dbo.sp_productos_JPMORGAN;36  
DECLARE @txtDate AS DATETIME = '20140612'  
   
--AS   
--BEGIN   
   
-- SET NOCOUNT ON   
  
 -- genera tabla temporal de resultados   
 DECLARE @tblResult TABLE (   
 [intSection][INTEGER],   
 [txtData][VARCHAR](8000)   
 )   
    
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)   
 DECLARE @tmp_tblCurvesNodes TABLE (   
  [intSection][INTEGER],   
  [txtType] CHAR(3),   
  [txtSubType] CHAR(3),   
  [intNode] INT,   
  [txtid_ccy_std] CHAR(3),  
  [txtid_prd_mat] CHAR(3),  
  [dblrt_int] VARCHAR(50)  
 PRIMARY KEY(intSection,txtType,txtSubType,intNode)   
 )   
  
 -- Nodos de Curvas (FRPiP) Libor  
 INSERT @tmp_tblCurvesNodes  
  SELECT 001,'LIB','LB',1,'USD','ON',NULL UNION   
  SELECT 002,'LIB','LB',7,'USD','1W',NULL UNION   
  SELECT 003,'LIB','LB',14,'USD','2W',NULL UNION   
  SELECT 004,'LIB','LB',28,'USD','1M',NULL UNION   
  SELECT 005,'LIB','LB',60,'USD','2M',NULL UNION   
  SELECT 006,'LIB','LB',91,'USD','3M',NULL UNION   
  SELECT 007,'LIB','LB',120,'USD','4M',NULL UNION   
  SELECT 008,'LIB','LB',150,'USD','5M',NULL UNION   
  SELECT 009,'LIB','LB',180,'USD','6M',NULL UNION   
  SELECT 010,'LIB','LB',270,'USD','9M',NULL UNION   
  SELECT 011,'LIB','LB',365,'USD','1Y',NULL  
  
 -- Nodos de Curvas (FRPiP) Libor Swap  
 INSERT @tmp_tblCurvesNodes  
  SELECT 012,'LUS','SWP',546,'USD','18M',NULL UNION   
  SELECT 013,'LUS','SWP',728,'USD','2Y',NULL UNION   
  SELECT 014,'LUS','SWP',1092,'USD','3Y',NULL UNION   
  SELECT 015,'LUS','SWP',1456,'USD','4Y',NULL UNION   
  SELECT 016,'LUS','SWP',1820,'USD','5Y',NULL UNION   
  SELECT 017,'LUS','SWP',2184,'USD','6Y',NULL UNION   
  SELECT 018,'LUS','SWP',2548,'USD','7Y',NULL UNION   
  SELECT 019,'LUS','SWP',2912,'USD','8Y',NULL UNION   
  SELECT 020,'LUS','SWP',3276,'USD','9Y',NULL UNION   
  SELECT 021,'LUS','SWP',3640,'USD','10Y',NULL UNION  
  SELECT 022,'LUS','SWP',4368,'USD','12Y',NULL UNION   
  SELECT 023,'LUS','SWP',5460,'USD','15Y',NULL UNION   
  SELECT 024,'LUS','SWP',7280,'USD','20Y',NULL UNION  
  SELECT 025,'LUS','SWP',10920,'USD','30Y',NULL  
  
 INSERT @tmp_tblCurvesNodes  
  SELECT 026,'SWP','TI',1,'MXN','ON',NULL UNION   
  SELECT 027,'TIE','SWP',28,'MXN','1M',NULL UNION   
  SELECT 028,'TIE','SWP',56,'MXN','2M',NULL UNION   
  SELECT 029,'TIE','SWP',84,'MXN','3M',NULL UNION   
  SELECT 030,'TIE','SWP',168,'MXN','6M',NULL UNION   
  SELECT 031,'TIE','SWP',364,'MXN','1Y',NULL UNION   
  SELECT 032,'TIE','SWP',728,'MXN','2Y',NULL UNION   
  SELECT 033,'TIE','SWP',1092,'MXN','3Y',NULL UNION   
  SELECT 034,'TIE','SWP',1456,'MXN','4Y',NULL UNION   
  SELECT 035,'TIE','SWP',1820,'MXN','5Y',NULL UNION   
  SELECT 036,'TIE','SWP',2548,'MXN','7Y',NULL UNION   
  SELECT 037,'TIE','SWP',3640,'MXN','10Y',NULL UNION   
  SELECT 038,'TIE','SWP',7280,'MXN','20Y',NULL UNION   
  SELECT 039,'TIE','SWP',10920,'MXN','30Y',NULL  
  
  
 -- Obtengo los valores de los FRPiP   
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node_historic_complete_PiPRiesgos(CONVERT(CHAR(8),@txtDate,112),RTRIM(txtType),RTRIM(txtSubType),intNode)*100,9,6))   
 FROM @tmp_tblCurvesNodes   
  
 -- Repoto los encabezados  
 INSERT @tblResult  
  SELECT  
   000,  
   'id_ccy_std'  + ',' +  
   'id_prd_mat'  + ',' +  
   'rt_int'  
  
 -- Reporto el Vector  
 INSERT @tblResult  
  SELECT  
  intSection,  
  RTRIM(txtid_ccy_std) + ',' +  
  RTRIM(txtid_prd_mat) + ',' +  
  RTRIM(dblrt_int)  
 FROM @tmp_tblCurvesNodes  
      
 -- Valida que la informacin este completa  
    
    SELECT * FROM  @tblResult
-- IF EXISTS(  
--   SELECT TOP 1 *  
--   FROM @tblResult  
--   WHERE txtData LIKE '%-9990%'  
--   )  
    
--  BEGIN  
--   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
--  END  
    
-- ELSE  
--  -- Reporto los datos   
--  SELECT RTRIM(txtData)  
--  FROM @tblResult  
--  ORDER BY intSection  
    
-- SET NOCOUNT OFF  
   
--END  