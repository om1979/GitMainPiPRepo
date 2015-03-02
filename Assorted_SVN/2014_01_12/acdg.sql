



SELECT * FROM  MxProcesses..tblProcessCatalog


SELECT * FROM  MxProcesses..tblProcessParameters
WHERE txtProcess LIKE '%REP_OMEGA_FIX_1000%'





SELECT * FROM  MxProcesses..tblProcessParameters
WHERE txtProcess IN (
SELECT txtProcess FROM  MxProcesses..tblProcessCatalog
WHERE txtClass = 'clsbanamex')


--BMX01_FIX_1000
--BMX01_1000
