
-----------------------------------------------------------            
--Autor:     Mike Ramirez            
--Fecha Modificacion:  20140711            
--Descripción:   Se modifican dos colunmas            
-----------------------------------------------------------            
ALTER    procedure sp_productos_BOFA;14     
   @dtedate datetime  -- = '20140930'
           
AS                  
BEGIN                     
SET NOCOUNT ON               
            
            
  DECLARE @tmp_BondsDates TABLE             
  (          
  dteIssued DATETIME,            
  txtId1 VARCHAR(11),            
  txtcalendar VARCHAR(7),            
  intIsActive int             
  PRIMARY KEY (txtId1)            
  )       
  
              
  DECLARE @tmp_BondsToReport TABLE             
  (          
  txtTv VARCHAR(10),
  txtEmisora VARCHAR(15),
  txtSerie VARCHAR(20),
  txtId1 VARCHAR(12),
  intCupId INT ,
  txtFechaInicioCupon VARCHAR(10),
  txtFechaFinCupon VARCHAR(10),
  txtCur  VARCHAR(400),
  dblCPA FLOAT,
  txtCalendar VARCHAR(7),
  txtNOM VARCHAR(400),
  txtCPF VARCHAR(400),
  txtCountry VARCHAR(10),
  txtBenchmark_Freq  VARCHAR(400),
  txtFix_Frequency VARCHAR(400)
  )    
  
       
             
INSERT  @tmp_BondsDates            
 SELECT       
  dteIssued,            
  txtId1,          
  txtcalendar,            
  CASE WHEN dbo.fun_IsTradingDate(dteIssued,'mx') = 1 THEN 1 ELSE 0 END             
 from tblBonds             
 WHERE dteEfective > '20140101'            
 AND  DATEDIFF(DAY,@dtedate,dteIssued) >= -7            
            
            
INSERT INTO @tmp_BondsToReport          
SELECT             
  --c.dteIssued,            
  txtTv,            
  txtEmisora,            
  txtSerie,            
  CASE WHEN LEN(a.txtID2) <12 THEN 'NA' ELSE a.txtID2 END ,            
  b.intCupId,            
            
--Fecha Inicio Cupón        
 CONVERT(VARCHAR(10),B.dteBeg, 101) AS [MM/DD/YYYY],        
--Fecha Fin Cupón        
 CONVERT(VARCHAR(10),B.dteEnd, 101) AS [MM/DD/YYYY],           
           
   --MONEDA         
 CASE   
  WHEN txtcur = '[UDI] Unidades de Inversion (MXN)' THEN 'MXV (UDI)'            
  WHEN txtcur = '[MPS] Peso Mexicano (MXN)' THEN 'MXN'            
  ELSE txtCUR            
 END  AS txtcur ,            
              
  dblCPA,            
     c.txtCalendar,            
 --Par Amount            
  txtNOM,            
 --Fix Frequency            
CASE             
  WHEN txtCPF =    'Cada 28 dia(s)'  THEN 'Mensual'            
  WHEN txtCPF =    'Cada 91 dia(s)'  THEN 'Trimestral'            
  WHEN txtCPF =    'Cada 182 dia(s)' THEN 'Semestral'            
  WHEN txtCPF =    'Mes' THEN 'Mensual'            
  WHEN txtCPF LIKE '%semestre%'     THEN 'Semestral'            
  WHEN txtCPF LIKE '%mensual%'     THEN 'Mensual'            
  WHEN txtCPF LIKE '%trimestre%'  THEN 'Trimestral'            
  WHEN txtCPF LIKE '%del anio%'  THEN 'Anual'            
  WHEN txtCPF LIKE '%año%'  THEN 'Anual'            
  WHEN txtCPF LIKE '%anio%'  THEN 'Anual'            
  ELSE 'NA'            
 END ,            
             
 --Pay Calendars          
 txtcountry,          
 --CASE             
 -- WHEN txtcur = '[UDI] Unidades de Inversion (MXN)' THEN 'MXV (UDI)'            
-- WHEN txtcur = '[MPS] Peso Mexicano (MXN)' THEN 'MXN'            
 -- ELSE  SUBSTRING(txtCUR,CHARINDEX('[',txtCUR,0)+1,3)            
 --END ,            
             
 --Benchmark Freq            
--  txtCPF,            
              
              
 CASE             
  WHEN txtCPF =  'Cada 28 dia(s)'  THEN '28d'            
  WHEN txtCPF =  'Cada 91 dia(s)'  THEN '91d'           
  WHEN txtCPF =  'Cada 182 dia(s)' THEN '182d'            
  ELSE txtCPF            
 END,            
             
  --Fix Frequency            
CASE             
  WHEN txtCPF =    'Cada 28 dia(s)'  THEN 'Mensual'            
  WHEN txtCPF =    'Cada 91 dia(s)'  THEN 'Trimestral'            
  WHEN txtCPF =    'Cada 182 dia(s)' THEN 'Semestral'            
  WHEN txtCPF =    'Mes' THEN 'Mensual'            
  WHEN txtCPF LIKE '%semestre%'     THEN 'Semestral'            
  WHEN txtCPF LIKE '%mensual%'    THEN 'Mensual'            
  WHEN txtCPF LIKE '%trimestre%'     THEN 'Trimestral'            
  WHEN txtCPF LIKE '%del anio%'  THEN 'Anual'            
  WHEN txtCPF LIKE '%año%'  THEN 'Anual'            
  WHEN txtCPF LIKE '%anio%'  THEN 'Anual'   
  ELSE 'NA'            
 END            
            
   FROM dbo.tmp_tblUnifiedPricesReport AS A            
    INNER JOIN tblBondsCupCalendar AS B            
    ON A.txtId1 = B.txtId1            
    INNER  JOIN @tmp_BondsDates AS C            
    ON a.txtId1 = c.txtId1             
            
   WHERE txtTv             
   IN ('M','LD','IT', 'IP',            
   'IS','IM','IQ','S','D1',             
   'CC','CP','PI','2U','3U','4U')            
                   
   and txtLiquidation IN ('MD','MP')     
   AND C.intIsActive = 1             
       
   IF ( (select count(*) from @tmp_BondsDates) = 0)    
   RAISERROR (15600,-1,-1, 'No hay Informacion en @tmp_BondsDates');   
   
   
      IF ( (select count(*) from @tmp_BondsToReport WHERE  txtTv             
			   IN ('M','LD','IT', 'IP',            
			   'IS','IM','IQ','S','D1',             
			   'CC','CP','PI','2U','3U','4U')  ) = 0)    
BEGIN 
SELECT 'NO se reportan Bonos en esta semana para los siguiente tipos de Valor "M","LD","IT", "IP","IS","IM","IQ","S","D1","CC","CP","PI","2U","3U","4U" '
END 
               
 SET NOCOUNT OFF              
            
END 



\\pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\BOFA\ACTUAL\
\\pipmxsql\PRODUCCION\MxVprecios\temp\
SELECT * FROM dbo.tblActiveX
WHERE txtProceso = 'BOFA_EmisionSemBonos_XLS'


UPDATE dbo.tblActiveX
SET txtValor = '\\pipmxsql\produccion\MxVprecios\PRODUCTOS\DEFINITIVO\BOFA\ACTUAL\'
WHERE  txtProceso = 'BOFA_EmisionSemBonos_XLS'
and txtpropiedad = 'FILEPATH' 

UPDATE   MxProcesses..tblProductGeneratorMap
SET txtPack = 'Inactivo'
WHERE txtProduct = 'BOFA_EmisionSemBonos_XLS'

