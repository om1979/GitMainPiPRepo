
--si tiene MIRC0000490
--no tiene MIRC0024025

SELECT * FROM  dbo.tblBonds AS TB
WHERE txtId1 = 'UIRC0006145'


SELECT * FROM  dbo.tblBondsAdd  AS TB
WHERE txtId1 = 'CO19500000B'

SELECT * FROM  dbo.tblEquity AS TE 
WHERE txtId1 = 'UIRC0006145'

SELECT * FROM  dbo.tblEquityAdd AS TEA
WHERE txtId1 = 'UIRC0006145'

SELECT * FROM  tblDerivatives
WHERE txtId1 = 'UIRC0006145'

SELECT * FROM  dbo.tblDerivativesAdd AS TDA
WHERE txtId1 = 'UIRC0006145'

SELECT * FROM tblPrivate
WHERE txtId1 = 'UIRC0006145'



SELECT * FROM  tblDailyAnalytics
WHERE txtId1 = 'UIRC0006145'


SELECT txtCUR,* FROM  dbo.tmp_tblActualAnalytics_1 AS TTAA
WHERE txtId1 = 'UIRC0006145'

SELECT * FROM  dbo.tmp_tblActualAnalytics_2 AS TTAA
WHERE txtId1 = 'UIRC0006145'








--SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
--WHERE txtProcess = 'ANA_MISSING'


--SELECT * FROM  MxProcesses..tblProcessBinnacle AS TPB
--WHERE txtProcess LIKE '%missing%'

--SELECT * FROM  MxProcesses..tblProcessBinnacle AS TPB
--WHERE txtProcess LIKE '%ana%'

