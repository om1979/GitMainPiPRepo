
--CREATE PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;7  
-- @txtDate CHAR(8)  
--/*   
-- Autor:   Mike Ramirez  
-- Creacion:  20140610  
-- Descripcion: Actualiza analiticos de Pais  
  
-- Modificado por:   
-- Modificacion:   
-- Descripcion:   
--*/   
  
--AS  
--BEGIN  
  DECLARE  @txtDate CHAR(8)  = '20150216'
  
  
  
 CREATE TABLE #tblCountry (  
  txtId1 CHAR(11),   
  txtCountry CHAR(7),  
  txtFullCountry VARCHAR(50)  
   PRIMARY KEY (txtId1))  
  
 CREATE TABLE #tblCountryDates(  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1))  
   
 -- Obtengo los ultimos registros para aquello que esta en tblidsadd  
 INSERT #tblCountryDates(  
  txtId1,  
  dteDate)  
    
 SELECT   
  a.txtId1,  
a.dteDate
 FROM tblIdsAdd a (NOLOCK)  
 INNER JOIN vw_prices_notes p (NOLOCK)  
 ON  
  a.txtId1 = p.txtId1  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  a.txtId1 = i.txtId1  
 WHERE  
   a.txtItem = 'COUNTRY'  
  AND i.txtTv NOT LIKE '%SP' 
  
    AND a.txtId1 = 'UUAAA001214'
  
  
  SELECT * FROM  tblIdsAdd AS A
  INNER JOIN vw_prices_notes AS p
  ON  a.txtId1 = p.txtId1  
   WHERE  
  a.txtItem = 'COUNTRY'  
    AND a.txtId1 = 'UIRC0012867'
  
  
  SELECT * FROM  vw_prices_notes
  WHERE --txtID1 = 'UIRC0012867'
  --AND 
  txtItem = 'COUNTRY'  
  AND dteDate = '20110316' 
  
  
  
 GROUP BY  
  a.txtId1  
      
 INSERT #tblCountry (  
  txtId1,  
  txtCountry)  
  
 SELECT    *
 -- a.txtId1,  
 -- a.txtValue  ,d.dteDate
 FROM #tblCountryDates d  

 INNER JOIN tblIdsAdd a (NOLOCK)  
 ON  
  d.txtId1 = a.txtId1  
  AND CONVERT(VARCHAR(12),d.dteDate,112) =  CONVERT(VARCHAR(12),a.dteDate,112)   
 WHERE  
  a.txtItem = 'COUNTRY'  
  AND a.txtId1 = 'UUAAA001037'
  
  
  
  SELECT * FROM  #tblCountryDates
  WHERE txtId1 = 'UUAAA001214'
  
  
    SELECT * FROM  tblIdsAdd
  WHERE  txtId1 = 'UUAAA001214'
  
  
  
  
  SELECT * FROM  dbo.tblDailyAnalytics AS TDA
    WHERE  txtId1 = 'UUAAA001214'
    AND txtItem = 'COUNTRY'
   
   
    
    
    
    SELECT * FROM  dbo.tmp_tblActualAnalytics_1 AS TTAA
  
  
    SELECT txtCOUNTRY FROM  dbo.tmp_tblActualAnalytics_2 AS TTAA
      WHERE  txtId1 = 'UUAAA001214'

  
  
  SELECT * FROM  #tblCountry
  WHERE txtId1 = 'UIRC0012867'
  
  
  SELECT * FROM  tblIdsAdd
  WHERE  txtId1 = 'UIRC0012867'
  
  
  
  
  select txtid1, txtCOUNTRY
  from dbsqldump.dbo.tmp_tblUnifiedPricesReport_20150204
    WHERE txtId1 = 'UIRC0012867'
 -- Validamos tblDailyAnalytics  
  
 -- Inserto los que no estan  
 --INSERT tblDailyAnalytics(  
 -- txtId1,  
 -- txtLiquidation,  
 -- txtItem,  
 -- txtValue)  
    
 SELECT  
  c.txtId1,  
  'MD',  
  'COUNTRY',  
  c.txtcountry  
 FROM #tblCountry c  
 LEFT OUTER JOIN tblDailyAnalytics a (NOLOCK)  
 ON  
  c.txtId1 = a.txtId1  
  AND a.txtItem = 'COUNTRY'  
  AND a.txtLiquidation = 'MD'  
 WHERE  
  a.txtId1 IS NULL  
  
  
  
  
    
 -- Actualizo los diferentes  
 --UPDATE a  
 --SET   
 -- a.txtValue = c.txtCountry  
 --FROM #tblCountry c  
 --INNER JOIN tblDailyAnalytics a (NOLOCK)  
 --ON  
 -- c.txtId1 = a.txtId1  
 -- AND a.txtItem = 'COUNTRY'  
 -- AND a.txtLiquidation = 'MD'  
 -- AND c.txtCountry != a.txtValue   
    
 -- Valido tmp_tblActualAnalytics_2  
-- UPDATE t  
-- SET  
--  t.txtCountry = a.txtValue  
-- FROM tmp_tblActualAnalytics_2 t (NOLOCK)  
-- INNER JOIN tblDailyAnalytics a (NOLOCK)  
-- ON  
--  t.txtId1 = a.txtId1  
--  AND t.txtLiquidation = a.txtLiquidation  
--  AND t.txtCountry != a.txtValue  
-- INNER JOIN #tblCountry c  
-- ON  
--  t.txtId1 = c.txtId1  
-- WHERE  
--  a.txtItem = 'COUNTRY'  
--  AND a.txtLiquidation = 'MD'  
  
--END  


SELECT * FROM  dbo.tblIdsAdd AS TIA
  where txtid1 in ('UIRC0000894',
'UIRC0006932',
'UIRC0008168',
'UIRC0012867',
'UUAAA000426',
'UUAAA000440',
'UUAAA000442',
'UUAAA000466',
'UUAAA000557',
'UUAAA000559',
'UUAAA000580',
'UUAAA000581',
'UUAAA000582',
'UUAAA000685',
'UUAAA000752',
'UUAAA000855',
'UUAAA000865',
'UUAAA000870',
'UUAAA000915',
'UUAAA000935',
'UUAAA000974',
'UUAAA001037',
'UUAAA001085',
'UUAAA001125',
'UUAAA001145',
'UUAAA001156',
'UUAAA001157',
'UUAAA001169',
'UUAAA001176',
'UUAAA001197',
'UUAAA001214',
'UUAAA001215',
'UUAAA001225',
'UUAAA001245',
'UUAAA001258',
'UUAAA001259',
'UUAAA001276',
'UUAAA001293',
'UUAAA001298',
'UUAAA001299',
'UUAAA001315',
'UUAAA001316',
'UUAAA001320',
'UUAAA001329',
'UUAAA001333',
'UUAAA001338',
'UUAAA001339',
'UUAAA001372',
'UUAAA001388',
'UUAAA001392',
'UUAAA001393',
'UUAAA001402',
'UUAAA001426')
AND txtItem = ''


SELECT * FROM  dbo.tblIdsAdd AS TIA
WHERE txtId1 = 'UUAAA001245'

sp_helptrigger tblIdsAdd

SELECT txtId1,txtCurrency FROM  dbo.tblBonds AS TB 
WHERE txtId1 = 'UUAAA001299'



SELECT txtCOUNTRY,* FROM  
 dbsqldump.dbo.tmp_tblUnifiedPricesReport_20150204
WHERE txtId1 = 'UUAAA001299'


SELECT * FROM  tblIdsAdd
WHERE txtId1 = 'UIRC0000335'

SELECT DISTINCT  A.txtId1,
COUNT(a.txtItem)  FROM  tblIdsAdd AS A
WHERE a.txtItem = 'COUNTRY   '
GROUP BY a.txtId1
ORDER BY  2 DESC 




CREATE TABLE #tblReportAnalitys
(
txtid1 VARCHAR(12),
txtcount INT
)

INSERT INTO #tblReportAnalitys
SELECT DISTINCT  A.txtId1,
COUNT(a.txtItem) AS txtCount FROM  tblIdsAdd AS A
INNER JOIN dbo.tblIds AS B
ON a.txtId1 = b.txtID1
WHERE a.txtItem = 'COUNTRY'
AND  txtTv IN ('d4','d5','d6')
GROUP BY a.txtId1
ORDER BY  2 DESC 


SELECT * FROM    #tblReportAnalitys AS A
INNER   JOIN   tblIdsAdd AS B
ON a.txtid1 = b.txtId1
WHERE txtcount >1
AND  b.txtItem = 'COUNTRY'
AND txtValue = 'MX'


SELECT * FROM  dbo.tblIds
WHERE txtTV IN ('d4','d5','d6')


SELECT DISTINCT txtTv,dteDate FROM  tmp_tblUnifiedPricesReport
WHERE txtTv IN ('d4','d5','d6')




SELECT * FROM  dbo.tblItemsCatalog
WHERE txtDescription LIKE '%pais%'


SELECT * FROM  dbo.tblPrices


SELECT * FROM  dbo.tblDailyAnalytics
WHERE txtId1 = 'UIRC0000894'
AND txtItem = 'country'
AND txtValue = 'MX'


select txtid1, txtCOUNTRY
  from tmp_tblUnifiedPricesReport
  where txtid1 = 'UIRC0000894'
 
SELECT txtid1, txtCOUNTRY FROM  tmp_tblUnifiedPricesReport 
WHERE txtTv IN ('d4','d5','d6')