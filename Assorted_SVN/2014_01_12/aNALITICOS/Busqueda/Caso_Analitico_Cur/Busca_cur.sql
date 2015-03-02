

SELECT * FROM  MxProcesses..tblProcessBinnacle AS TPB
WHERE txtProcess LIKE  '%ana%'




sp_helptrigger tblEquity
go
sp_helptrigger tblEquityAdd 
go
sp_helptrigger tblDailyAnalytics
GO


SELECT * FROM  MxProcesseshist..tblProcessBinnacle AS TPB
WHERE txtProcess IN
(
--FOTO
'dtm',
'ana_spe',
'ana_mirror',
'irctoprices',
'man_buffer_ids',
'ana_prices_liq',
'ana_prices',
'ana_prices_sn',
'ana_buffer_md',
'ana_buffer_tv',
'ana_buffer_sp',
'ana_buffer_uni',
'ana_buffer_notes_uni',
--PROCESO MISSING
'ANA_MISSING'
)
AND dteDate = '20141028'





SELECT * FROM  MxProcesseshist..tblProcessBinnacle AS TPB
WHERE txtProcess LIKE  '%ana%'
AND dteDate = '20141028'





SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
WHERE txtProcess LIKE '%missing%'


sp_helptext usp_ValidateAndUpdateAnalytics 


SELECT txtcur,* FROM  dbo.tmp_tblActualAnalytics_1 
WHERE txtId1 = 'MIRC0000490'

SELECT * FROM  dbo.tmp_tblActualAnalytics_2 
WHERE txtId1 = 'UFFT0000001'


SELECT txtCUR,* FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR
WHERE txtId1 = 'MIRC0000490'






SELECT * FROM  dbo.tblEquityAdd AS TEA
WHERE  txtId1 = 'UFFT0000001'


SELECT * FROM  dbo.tblEquity AS TE
WHERE  txtId1 = 'UFFT0000001'

SELECT * FROM  dbo.tblIdsAdd AS TIA
WHERE  txtId1 = 'UFFT0000001'




