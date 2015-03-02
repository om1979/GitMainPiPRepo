




SELECT DISTINCT * FROM  dbo.tblPrices AS A
 INNER JOIN MxFixIncome.dbo.tblIds AS b 
 ON A.txtID1 = b.txtID1 
 WHERE A.dteDate = '20140718'
 AND B.txtTv IN ('D1','D2','D4','D5','D6','D7','D8')
 AND txtLiquidation IN ('MD','MP')
 AND txtEmisora ='BLTN6N4'
 


 
 
 SELECT txtCUR FROM  dbo.tmp_tblUnifiedPricesReport
 WHERE txtId1 = 'UUAAA000485'


SELECT txtId1,dblPRS,txtVNA,txtLiquidation,dblPRS*100 aaa,txtVNA*irc FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtTv IN ('D1','D2','D4','D5','D6','D7','D8')
 AND txtLiquidation IN ('MD','MP')
 
 
 [PRS * 100] / [VNA * IRC]
 
 
 SELECT txtId1,dblPRS,txtVNA,txtLiquidation,dblPRS*100 aaa,txtVNA*irc FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtTv IN ('D1','D2','D4','D5','D6','D7','D8')
 AND txtLiquidation IN ('MD','MP')
 
 SELECT * FROM  dbo.tblIrc
 WHERE txtIRC IN (
'BRL',
'CHF',
'EUR',
'GBP',
'ITL',
'JPY',
'1',
'SMG',
'UDI',
'UFXU'
)






txtid1 = 'UUAAA000485'

prs select CONVERT(DECIMAL(20,8),77436.195436)

vna 0







SELECT 0/CONVERT(DECIMAL(20,14),5814.77160549224000000000)



[PRS * 100] / [VNA * IRC]







SELECT DISTINCT * FROM  dbo.tblPrices AS A
 INNER JOIN MxFixIncome.dbo.tblIds AS b 
 ON A.txtID1 = b.txtID1 
 WHERE A.dteDate = '20140722'
 --AND B.txtTv IN ('D1','D2','D4','D5','D6','D7','D8')
AND txtLiquidation IN ('MD','MP')
AND A.txtID1 = 'UIRC0002785'
 
 
 
SELECT dblPRL,txtTv,txtVNA,txtcur,dblPRS,* FROM  dbo.tmp_tblUnifiedPricesReport
WHERE txtId1 = 'UIRC0002782'


prl
77441.5819274155
prs
77441.5819274155
zar irc
1.22450080439103
