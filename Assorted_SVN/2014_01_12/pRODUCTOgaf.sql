


DECLARE @MYtABLE  TABLE 
(
   MYVARIABLE  VARCHAR(11) 
)

--INSERT INTO @MYtABLE
SELECT   DISTINCT 
CASE WHEN  LEN(A.txtTV) < 4   THEN LTRIM(RTRIM(SUBSTRING(A.txtTV,0,4))) + CHAR(10) +CHAR(10) ELSE  LTRIM(RTRIM(A.txtTV)) END + ','+  --11
CASE WHEN LEN(txtEmisora) < 12 THEN  REPLICATE(CHAR(10),5)END + ','+ 
CASE WHEN LEN(txtSerie) < 12 THEN  REPLICATE(CHAR(10),10)END + ','+ 

CASE WHEN LEN(b.intCupId) =  3
THEN LTRIM(RTRIM(SUBSTRING(CONVERT(VARCHAR(100),b.intCupId),0,6))) + CHAR(10) + CHAR(10)+ CHAR(10)
WHEN LEN(b.intCupId) =  1
THEN LTRIM(RTRIM(SUBSTRING(CONVERT(VARCHAR(100),b.intCupId),0,6))) + CHAR(10) + CHAR(10)+ CHAR(10)+ CHAR(10)+ CHAR(10)
WHEN LEN(b.intCupId) =  2
THEN LTRIM(RTRIM(SUBSTRING(CONVERT(VARCHAR(100),b.intCupId),0,6))) + CHAR(10) + CHAR(10) + CHAR(10)+  CHAR(10)
ELSE LTRIM(RTRIM(CONVERT(VARCHAR(100),b.intCupId))) END + ','+ 


CONVERT(VARCHAR(8),B.dteBeg,112) + ','+ 
CONVERT(VARCHAR(8),b.dteEnd,112) + ','+ 
CASE WHEN LEN(CONVERT(VARCHAR(100),c.dblValue)) = 12 THEN CONVERT(VARCHAR(100),c.dblValue) + CHAR(10) 
ELSE CONVERT(VARCHAR(100),c.dblValue)END + ','+ 

CONVERT(VARCHAR(8),c.dteBeg,112)+ ','+ 
CONVERT(VARCHAR(8),c.dteEnd,112)+ ','+ 


 CASE WHEN LEN(d.txtCalendar) <7 THEN d.txtCalendar + CHAR(10) ELSE d.txtCalendar  END  + ','+ 
ISNULL( LTRIM(RTRIM(CONVERT(VARCHAR(100),e.dblFactor)+ REPLICATE(CHAR(10),8 - LEN(e.dblFactor))))  ,REPLICATE(CHAR(10),8)  ) + ','+ 
LTRIM(RTRIM(d.txtCurrency + REPLICATE(' ',3 - LEN(d.txtCurrency ))) 


+ REPLICATE(CHAR(10),12)),*

FROM tblIds AS A
INNER   JOIN Tblbondscupcalendar AS  B
ON A.txtid1 = b.txtid1
INNER  JOIN Tblbondsratecalendar AS C
ON a.txtID1 = C.txtId1 AND c.dteBeg = '20140701'
INNER  JOIN dbo.tblBonds AS D
ON a.txtID1 = D.txtId1 
INNER JOIN Tblamortizations AS E
ON a.txtID1 = e.txtId1
LEFT OUTER JOIN dbo.tblPrices AS F
ON E.txtId1 = F.txtID1 AND f.txtLiquidation = '24H' AND f.dteDate = '20140701' AND f.txtItem ='YTM'




