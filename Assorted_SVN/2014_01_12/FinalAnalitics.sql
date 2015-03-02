



SELECT   FROM  tmp_tblActualAnalytics_1


SELECT  ctm FROM  tmp_tblActualAnalytics_2



SELECT DISTINCT txtItem FROM  dbo.tblPrices AS TP
WHERE txtItem IN 
(
'CPA',       
'CPD',       
'YTM'       
)


SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC
WHERE txtProcess IN ('ANA_PRICES')






SELECT * FROM  sys.procedures AS P
WHERE name LIKE '%cpd%'



SELECT * FROM  sys.procedures AS P
INNER JOIN sys.syscomments AS S
ON P.object_id = s.id
WHERE s.text LIKE '%CPA%'
AND p.name NOT LIKE '%productos%'




sp_helptrigger tblIdsAdd
sp_helptrigger dbo.tblEquityAdd
sp_helptrigger tblBondsAdd 
sp_helptrigger sp_trigger tblPrices

SELECT * FROM  tblPrices AS TP


sp_helptext tgr_tblBondsAdd_Analytics


SELECT * FROM  tblBondsAdd
WHERE txtItem IN 
(
'CMT'
,'CPA'      
,'CPD'       
,'DTC'       
,'YTM'       
,'STP'       
,'DEF'       
)




SELECT * FROM  tblBondsAdd
WHERE txtId1 = 'MAAE8594304'

SELECT * FROM  dbo.tblIdsAdd AS TIA
WHERE txtId1 = 'MAAE8594304'


SELECT * FROM  dbo.tblEquityAdd AS TEA
WHERE txtId1 = 'MAAE8594304'






SELECT DISTINCT txtItem FROM   tblIdsAdd
WHERE txtItem IN 
(
'CMT'
,'CPA'      
,'CPD'       
,'DTC'       
,'YTM'       
,'STP'       
,'DEF'       
)





SELECT * FROM  dbo.tblDailyAnalytics AS TDA 
WHERE txtItem IN 
(
'CMT'      
,'DTC'             
,'STP'       
,'DEF'       
)
AND txtId1 = 'MAAE8594304'
AND txtLiquidation = 'MD'


tblPrices
CPA       
CPD       
YTM  

 
 
 SELECT * FROM  dbo.tblIdsAdd AS TIA
 WHERE txtId1 = 'MAAE8594304'
 
 
sp_helptrigger tblPrices






    