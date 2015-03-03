







WITH TBL1 (txtId1,dteDate,txtTv,txtEmisora,txtDMF_MD)
AS  
(
SELECT
txtId1,
dteDate,
txtTv,
txtEmisora,
CASE WHEN  txtDMF NOT IN ('',NULL,'-') THEN  STR(txtDMF,20,12) ELSE '-' END  AS txtDMF_MD
 FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtLiquidation ='MD' 
),
  TBL2 (txtId1,dteDate,txtTv,txtEmisora,txtDMF_MD)
AS  
(
SELECT
txtId1,
dteDate,
txtTv,
txtEmisora,
CASE WHEN  txtDMF NOT IN ('',NULL,'-') THEN  STR(txtDMF,20,12) ELSE '-' END  AS txtDMF_MD
 FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtLiquidation ='24H' )

SELECT * FROM  TBL2




SELECT * FROM  sys.procedures WHERE name LIKE '%usp_transferInfoToAzure%'








 SELECT DISTINCT  txtDMF  FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtLiquidation ='MD' 


SELECT * FROM  dbo.tblItemsCatalog
WHERE txtDescription LIKE '%dura%'



SELECT * FROM  MxProcesses..tblProcessCatalog
WHERE txtProcess LIKE '%dts%'

sp_helptext 
usp_transferInfoToAzure