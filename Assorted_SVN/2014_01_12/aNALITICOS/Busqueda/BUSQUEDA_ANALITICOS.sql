SELECT * FROM sys.procedures WHERE name LIKE '%NEM%' 


SELECT * FROM   dbo.tblItemsCatalog AS TIC
WHERE txtDescription LIKE '%limpio%'





















SELECT   txtTv,COUNT(txtTv) AS A

FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtWPC IN ('-','NA')
GROUP BY txtTv,txtId1




SELECT   DISTINCT txtTv  ,COUNT( txtTv)
FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtWPC IN ('-','NA')
GROUP BY txtTv






 SELECT * FROM  dbo.tblItemsCatalog AS TIC
 
 --WHERE txtDescription LIKE '%SUS%'
 WHERE txtItem LIKE '%SEC%'


--SPREAD COMPRA

SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC2 
WHERE  txtProcess LIKE '%ANA%'



SELECT * FROM  MxProcesses..tblProcessBinnacle AS BTPB
INNER JOIN MxProcesses..tblProcessCatalog AS B
ON BTPB.txtProcess = B.txtProcess
WHERE BTPB.txtProcess  LIKE '%ANA_BIDASK%'
AND txtLibrary NOT IN ('PiP_Products')


SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC
WHERE txtProcess LIKE '%LIMPIO%'


SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC
WHERE txtProcess LIKE '%ANA_BMV_BOL%'


ANA_BMV_BOL
ANA_TEST_PRICES



SELECT * FROM   MxProcesses..tblProcessParameters
WHERE txtProcess = 'ANA_TEST_PRICES'



WHERE  txtParameter = 'Pack'
AND txtValue IN( '11','6')

procesa impact 


SELECT * FROM 



6,11
SELECT * FROM  MxProcesses..tblProcessParameters
 WHERE txtProcess = 'AFO_SPR_UN'
 
 
 
 --ANA_TACS
 
 ANARISK
 ANA_PERF
 
 7:24pm y 11:13PM
 5:40PM - 6:54PM
 
 
 
 
 
 
 SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC
 WHERE txtClass = 'clsAnalytics'AND txtMethod = 'Execute'
 
 
WHERE txtProcess LIKE '%ANARISK%'


 ANA_PERF
 ANARISK
 
PIP_ANALYTICS	
PIP_ANALYTICS	

clsAnalytics	
clsAnalytics		
 
EXECUTE
EXECUTE 
 




