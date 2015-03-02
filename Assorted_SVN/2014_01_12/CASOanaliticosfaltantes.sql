SELECT * FROM  dbo.tblDailyAnalytics
WHERE txtItem = 'vna'
AND txtId1 IN (
'MIRC0009913',
'MIRC0027932'
)

SELECT * FROM  MxProcesses.dbo.tblProcessBinnacle
WHERE txtProcess = 'ana_tacs'

SELECT * FROM  dbo.tblIds
WHERE  txtId1 IN (
'MIRC0009913',
'MIRC0027932'
)

SELECT * FROM  dbo.tblBonds
WHERE txtId1 IN ('MIRC0009913')


SELECT * FROM  dbo.tblAmortizations
WHERE txtId1 IN ('MIRC0009913')




SELECT * FROM sys.objects WHERE name LIKE '%CREATE%'


sp_analytic_vna



SELECT * FROM tmp_tblAnalyticsUni
WHERE txtId1 IN ('MIRC0009913')


