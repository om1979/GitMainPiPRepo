SELECT * FROM  dbo.tblBonds AS TB
WHERE txtId1 = 'MIRC0024466'


SELECT * FROM  dbo.tblBondsAdd  AS TB
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM  dbo.tblEquity AS TE 
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM  dbo.tblEquityAdd AS TEA
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM  tblDerivatives
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM  dbo.tblDerivativesAdd AS TDA
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM tblPrivate
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM dbo.tblPrivateAdd AS TPA
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM  tblDailyAnalytics
WHERE txtId1 = 'MIRC0024466'

SELECT txtSEC,* FROM  dbo.tmp_tblActualAnalytics_1 AS TTAA
WHERE txtId1 = 'MIRC0024466'

SELECT * FROM  dbo.tmp_tblActualAnalytics_2 AS TTAA
WHERE txtId1 = 'MIRC0024466'


SELECT * FROM  dbo.tblPrices AS TP
WHERE txtId1 = 'MIRC0024466'



SELECT * FROM  dbo.tblResults AS TR
WHERE txtItem = 'SEC'

SELECT * FROM  dbo.tblSectorCatalog AS TSC





SELECT TXTSEC,txtId1 FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR
WHERE txtId1 = 'MIRC0024466'


WHERE txtTv IN ('1R')


WHERE txtSEC IN('-','NA')


--SELECT * FROM  tblIssuersCatalog
--WHERE txtIssuer = 'WSMXCK'


--SELECT * FROM  tblBMVSectorCatalog
--WHERE intSector = 7000


