  
ALTER  PROCEDURE dbo.sp_ENCUESTAS_WEB;1  
 @txtDate AS VARCHAR(8),  
 @txtPlazo AS VARCHAR(10),  
 @dblValue AS FLOAT,  
 @txtTv AS VARCHAR(5),  
 @txtEmisora AS VARCHAR(12),  
 @txtSerie AS VARCHAR(10),  
 @txtCategory AS VARCHAR(5),  
 @dteTime AS DATETIME  
 /*   
 DESCRIPCION: Procedimiento que ingresa los datos de  
        la encuesta a la BD de la WEB  
 CREADOR:  Sergio García  
 FECHA:  25 de Mayo del 2004  
   
 MODIFICA:  PONATE  
 FECHA:   20121224  
 MODIFICACION: Modifico para enviar los datos a preazure y Azure, ademas de funcionalidad para actualizar datos  
   
 */  
AS  
BEGIN  
   
 -- Captamos la hora  
 DECLARE @dteDateTime AS DATETIME   
 SELECT  @dteDateTime = GETDATE()  
 SELECT  @dteDateTime = DATEADD(DAY,DATEDIFF(DAY,@dteDateTime,'1900-01-01 00:00:00.000'),@dteDateTime)  
 SELECT  @dteDateTime = DATEADD(MILLISECOND,1000-DATEPART(MILLISECOND,@dteDateTime),@dteDateTime)  
   
 ---Para actualizar la informacion en azure  
 --EXEC SQLAZURE_BK.LaWeb_BK.dbo.usp_input_poll @txtDate, @txtPlazo, @dblValue, @txtTv, @txtEmisora, @txtSerie, @txtCategory, @dteDateTime  
 EXEC LAWEBNEW.LaWebNew.dbo.usp_input_poll  @txtDate, @txtPlazo, @dblValue, @txtTv, @txtEmisora, @txtSerie, @txtCategory, @dteDateTime  
END  



SELECT * FROM  OPENROWSET() AS O2 AS O

SELECT * 
FROM OPENROWSET('SQLNCLI10', 'Server=LAWEBNEW;Trusted_Connection=yes;','SELECT * FROM  sys.servers') AS a;



sp_linkedservers

SELECT * FROM  sys.servers AS S

sp_helptext sp_ENCUESTAS_WEB


  
--CREATE PROCEDURE dbo.sp_ENCUESTAS_WEB;1  
-- @txtDate AS VARCHAR(8),  
-- @txtPlazo AS VARCHAR(10),  
-- @dblValue AS FLOAT,  
-- @txtTv AS VARCHAR(5),  
-- @txtEmisora AS VARCHAR(12),  
-- @txtSerie AS VARCHAR(10),  
-- @txtCategory AS VARCHAR(5),  
-- @dteTime AS DATETIME  
-- /*   
-- DESCRIPCION: Procedimiento que ingresa los datos de  
--        la encuesta a la BD de la WEB  
-- CREADOR:  Sergio García  
-- FECHA:  25 de Mayo del 2004  
   
-- MODIFICA:  PONATE  
-- FECHA:   20121224  
-- MODIFICACION: Modifico para enviar los datos a preazure y Azure, ademas de funcionalidad para actualizar datos  
   
-- */  
--AS  
--BEGIN  
   
-- -- Captamos la hora  
-- DECLARE @dteDateTime AS DATETIME   
-- SELECT  @dteDateTime = GETDATE()  
-- SELECT  @dteDateTime = DATEADD(DAY,DATEDIFF(DAY,@dteDateTime,'1900-01-01 00:00:00.000'),@dteDateTime)  
-- SELECT  @dteDateTime = DATEADD(MILLISECOND,1000-DATEPART(MILLISECOND,@dteDateTime),@dteDateTime)  
   
-- ---Para actualizar la informacion en azure  
-- --EXEC SQLAZURE_BK.LaWeb_BK.dbo.usp_input_poll @txtDate, @txtPlazo, @dblValue, @txtTv, @txtEmisora, @txtSerie, @txtCategory, @dteDateTime  
-- EXEC LAWEBNEW.LaWebNew.dbo.usp_input_poll @txtDate, @txtPlazo, @dblValue, @txtTv, @txtEmisora, @txtSerie, @txtCategory, @dteDateTime  
--END  
  
  
  
  
   EXEC LAWEBNEW.LaWebNew.dbo.ups_getCategory 'co'
   

  
 EXEC  LAWEBNEW.LaWebNew.dbo.usp_input_poll '77','ll','jj'
 
 
  
  
SELECT * FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR
SELECT * FROM  LAWEBNEW.LaWebNew.sys.procedures




LAWEBNEW.LaWebNew.dbo.usp_input_poll

  
  sp_linkedservers
  
  
  SELECT * FROM  LAWEBNEW.LaWebNew.sys.procedures 
  
  
  SELECT * FROM   LAWEBNEW.LaWebNew.sys.procedures AS P
  INNER JOIN  LAWEBNEW.LaWebNew.sys.syscomments AS S
  ON p.object_id = s.id
  WHERE  p.name = 'usp_input_poll'
  
  
  WHERE s.text LIKE '%LAWEBNEW%'
  
  
  
  
  
  
  
  
  SELECT * FROM  LAWEBNEW.laweb.dbo,