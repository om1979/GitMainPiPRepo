

KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
  /*  
  Version: 1.0  
  
  Procedimiento para generar el analitico cur  
  dentro del tren de procesos decurinado  
  'sp_createAndReportAnalytics'  
  
  NOTA: El control de depuracion de tablas  
  esta controlado por 'sp_createAndReportAnalytics'    
    
  Creador: JATO    
 */  
  
-- para obtener los insumos  
CREATE PROCEDURE dbo.sp_analytic_cur;1  
 @txtDate AS VARCHAR (10),  
 @txtAnalytic AS VARCHAR(5)  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
 -- obtengo las monedas de bonos, acciones y derivados  
 SELECT   
  u.txtId1,  
  CASE   
  WHEN b.txtCurrency IS NULL THEN 'MPS'  
  WHEN b.txtCurrency IN ('USD', 'DLL', 'UFXU') THEN 'USD'  
  WHEN b.txtCurrency IN ('MUD', 'UDI') THEN 'UDI'  
  ELSE b.txtCurrency  
  END AS txtCurrency    
 INTO #tblCurrency  
 FROM   
  tblUni AS u  
  INNER JOIN tblBonds AS b  
  ON u.txtId1 = b.txtId1  
 UNION  
 
 SELECT   
  u.txtId1,  
  CASE   
  WHEN d.txtCurrency IS NULL THEN 'MPS'  
  WHEN d.txtCurrency IN ('USD', 'DLL', 'UFXU') THEN 'USD'  
  WHEN d.txtCurrency IN ('MUD', 'UDI') THEN 'UDI'  
  ELSE d.txtCurrency  
  END AS txtCurrency    
 FROM   
  tblUni AS u  
  INNER JOIN tblDerivatives AS d  
  ON u.txtId1 = d.txtId1  
 UNION  
 SELECT   
  u.txtId1,  
  CASE   
  WHEN e.txtCurrency IS NULL THEN 'MPS'  
  WHEN e.txtCurrency IN ('USD', 'DLL', 'UFXU') THEN 'USD'  
  WHEN e.txtCurrency IN ('MUD', 'UDI') THEN 'UDI'  
  ELSE e.txtCurrency  
  END AS txtCurrency    
 FROM   
  tblUni AS u  
  INNER JOIN tblEquity AS e  
  ON u.txtId1 = e.txtId1  
  
 -- busco errores  
 IF EXISTS(   
  
  SELECT txtId1  
  FROM #tblCurrency  
  WHERE  
   txtCurrency IS NULL  
    )  
   RAISERROR ('Codigos de Moneda Erroneos', 16, 1)  
  
 ELSE  
 BEGIN  
  SELECT * FROM  tblResults
  WHERE txtId1 = 'MIRC0004099'
  
  
  SELECT * FROM  tblIrcCatalog AS A
  INNER JOIN   dbo.tblIrc AS B
  ON A.txtIrc = B.txtIRC
  WHERE txtId1 = 'MIRC0004099'
  
  
  
  
  
  INSERT tblResults    
  SELECT DISTINCT   
   @txtDate,  
   d.txtId1,    
   @txtAnalytic,  
   '[' + RTRIM(d.txtCurrency) + '] '  +  
   RTRIM(c.txtIrcName)  
  FROM   
   #tblCurrency AS d  
   INNER JOIN tblIrcCatalog AS c  
   ON d.txtCurrency = c.txtIrc  
  
 END   
  
 SET NOCOUNT OFF  
  
END   
  

  SELECT * FROM  dbo.tblBonds 
  WHERE txtId1 IN
  (
'MIRC0024025',
'MIRC0024026',
'MIRC0021953',
'MIRC0024027'
  )
  
 SELECT * FROM  tblDerivatives
   WHERE txtId1 IN
  (
'MIRC0024025',
'MIRC0024026',
'MIRC0021953',
'MIRC0024027'
  )
  
  
  SELECT * FROM  dbo.tblEquity 
    WHERE txtId1 IN
  (
'MIRC0024025',
'MIRC0024026',
'MIRC0021953',
'MIRC0024027'
  )
  
   
   SELECT * FROM  dbo.tblIds 
   WHERE 
    txtTv = '*C'
  AND txtEmisora IN 
  ('CNHUSD',
'MXPCNH',
'USDCHF',
'USDCNH')
   
   
   
   
   
  SELECT TXTCUR,* FROM  tmp_tblUnifiedPricesReport
  WHERE txtTv = '*C'
  AND txtEmisora IN 
  ('CNHUSD',
'MXPCNH',
'USDCHF',
'USDCNH')
  
  
  
  
  
  
  
  
--  SELECT * FROM  tblResults
--  WHERE txtItem LIKE  '%CUR%'
  
  
--  SELECT * FROM  #tblCurrency
  
  
  
--  SELECT * FROM  dbo.tmp_tblUnifiedPricesReport 
--  WHERE TXT
  
  
  
--  SELECT TXTCUR,* FROM  tmp_tblUnifiedPricesReport
--  WHERE txtTv = '*C'
--  AND txtEmisora IN 
--  ('CNHUSD',
--'MXPCNH',
--'USDCHF',
--'USDCNH')
  
  
--*C	CNHUSD	CNH
--*C	MXPCNH	CNH
--*C	USDCHF	CHF
--*C	USDCNH	CNH


--SELECT * FROM  MxProcesses..tblProcessConfiguration  AS TPC
--WHERE 



--SELECT * FROM   MxProcesses..tblProcessParameters
--WHERE  txtParameter = 'Pack'
--AND txtValue = '15'




--SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
--WHERE txtProcess = 'ANA_PERF'


SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC
WHERE txtProcess = 'ANA_PERF'

sp_CreateAndReportAnalytics
sp_currencies