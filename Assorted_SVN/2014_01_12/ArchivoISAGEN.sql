


----SELECT * FROM  dbo.tblDevilBinnacle AS TDB

----SELECT * FROM  dbo.tblDevilCatalog AS TDC

SELECT * FROM  dbo.tblDevilProcessCatalog AS TDPC
WHERE txtDescription LIKE '%ISAGEN%'

SELECT * FROM  dbo.tblDevilProcessConfiguration AS TDPC
WHERE txtValue LIKE '%ISAGEN%'


SELECT * FROM  dbo.tblProcessBinnacle AS TPB
WHERE txtMessage LIKE '%ISAGEN%'