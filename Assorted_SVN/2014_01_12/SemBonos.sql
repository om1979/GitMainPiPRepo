
SELECT GETDATE()


SELECT * FROM  dbo.tblActiveX
WHERE txtProceso LIKE '%BOFA_EmisionSemBonos_XLS%'


SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct = 'BOFA_EmisionSemBonos_XLS'



UPDATE MxProcesses..tblProductGeneratorMap
SET txtPack = 'DEFINITIVO_2'
WHERE txtProduct = 'BOFA_EmisionSemBonos_XLS'




--previo


SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct = 'HSBC_VALVID_Banxico_XLS'


UPDATE MxProcesses..tblProductGeneratorMap
SET txtPack = 'OPERATIVO_2'
WHERE txtProduct = 'HSBC_VALVID_Banxico_XLS'








SELECT * FROM  dbo.tblActiveX
WHERE txtProceso LIKE '%banxico%'



--HSBC_VALVID_Banxico_XLS va en operativo!!!!!!