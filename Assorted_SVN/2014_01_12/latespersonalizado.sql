


SELECT 
--CONVERT(VARCHAR(10),dteDate,112),
--txtTv,
--txtEmisora,
--txtSerie,
--ROUND(dblYTM,6),dblYTM,
STR(ROUND(dblLDR,6),10,6),dblLDR
--dblPRL,
--dblCPD,
--txtVNA,
--txtDMF 

FROM 
 dbo.tmp_tblUnifiedPricesReport AS TTUPR