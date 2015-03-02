 /*  
  Version: 2.0  
  
  Procedimiento para generar el analitico MDY  
  dentro del tren de procesos denominado  
  'sp_createAndReportAnalytics'  
  
  NOTA: El control de depuracion de tablas  
  esta controlado por 'sp_createAndReportAnalytics'    
    
  Creador: Sergio García  
  
  v2.0 CHAN-CHAN (08:26 p.m. 17/05/2007)  
  Ajuste para que analiticos se puedan correr en paralelo  
  
 */  
  
-- para obtener los resultados  
ALTER  PROCEDURE dbo.sp_analytic_mdy;1  
 @txtDate AS VARCHAR (10),  
 @txtAnalytic AS VARCHAR(5)  
AS  
BEGIN  
     
     
     SELECT * INTO dbo.tblUni20141202 FROM tblUni
     

  SELECT   
  ep.txtId1,  
  ep.dblPrice  
  INTO #tblMDY  
  FROM   
  tmp_tblExtremePricesYear AS ep (NOLOCK)  
  INNER JOIN  dbo.tblUni20141202 AS u (NOLOCK)  
  ON ep.txtId1 = u.txtId1  
  AND u.txtAnalytic = @txtAnalytic  
  WHERE  
  ep.txtItem = 'MDY'  
  
  DROP  TABLE dbo.tblUni20141202

   
  INSERT #tblMDY  
  SELECT   
  p.txtId1,  
  p.dblValue  
  FROM   
  tblPrices AS p (NOLOCK)  
  INNER JOIN dbo.tblUni20141202 AS u (NOLOCK)  
  ON p.txtId1 = u.txtId1  
  AND u.txtAnalytic = @txtAnalytic  
  WHERE  
  p.dteDate = @txtDate  
  AND p.txtItem IN ('PRL', 'PAV')  
  AND p.txtLiquidation IN ('MD', 'MP')  
  
  -- agrego los analiticos a la tabla de resultados  
  --INSERT tblResults   
  
  
     DECLARE  @txtDate AS VARCHAR (10)='20141202'
 DECLARE  @txtAnalytic AS VARCHAR(5)   ='MDY'
 
  SELECT   
  @txtDate,  
  txtId1,  
  @txtAnalytic,  
  LTRIM(STR(MAX(dblPrice), 11, 6))  
  FROM #tblMDY (NOLOCK)  
  WHERE txtId1 ='MIRC0015507'
  GROUP BY   
  txtId1  
  
  
  

  
select 
dtedate,
txtid1,
txttv,
txtemisora,
txtserie,
txtmdy,
txtmip
from mxfixincome..tmp_tblunifiedpricesreport
where txttv in ('SWT','1R','WC')
order by txttv





  SELECT * FROM  dbo.tblUni20141202
  WHERE txtId1 ='MIRC0015508'
  


SELECT * FROM  dbo.tblIds AS TI 
WHERE txtId1 ='MIRC0015508'
  

SELECT * FROM  dbo.tblDailyAnalytics AS TDA
WHERE txtId1 ='MIRC0028500'
  AND txtItem = 'MDY'  



SELECT txtMDY FROM  dbo.tmp_tblActualAnalytics_1 AS TDA
WHERE txtId1 ='MIRC0015507'
  AND txtItem = 'MDY'  





select 
dtedate,
txtid1,
txttv,
txtemisora,
txtserie,
txtmdy,
txtmip
from mxfixincome..tmp_tblunifiedpricesreport
where txttv in ('SWT','1R','WC')
order by txttv