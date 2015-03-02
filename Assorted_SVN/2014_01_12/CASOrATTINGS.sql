



SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC
WHERE txtProcess = 'ana_spe'


SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
WHERE txtProcess = 'ana_spe'



SELECT * FROM  tmp_tblAnalyticsTransition


SELECT * FROM tblDailyAnalytics
 WHERE txtId1 = 'MCFO9550068'
 AND txtItem = 'DPQ'
 
 
 
 SELECT txtDPQ,* FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR
  WHERE txtId1 = 'MCFO9550068'
  
  

    
 
 --TRUNCATE TABLE tblDailyAnalytics
 
 SELECT * FROM  dbo.tblDailyAnalytics AS TDA
  WHERE txtId1 = 'MCFO9550068'
   AND txtItem = 'dpq'
  
  
  
  
  
  --INSERT INTO tblDailyAnalytics
  -- SELECT * FROM  [VIA-MXSQL].MxFixIncome.dbo.tblDailyAnalytics AS TDA
  --WHERE txtId1 = 'MCFO9550068'
  -- AND txtItem = 'dpq'
   
   
   
   
  
  
SELECT * FROM  sys.procedures AS P
INNER JOIN sys.syscomments AS S
ON p.object_id = s.id 
WHERE s.text LIKE '%Baa1%'
  
  
  
  
  
dtm -- no se puedn modifcar precios para fechas anteriores
2-ana_spe  --corriendo
3-ana_mirror---ok
4-irctoprices--ok
5-man_buffer_ids--ok



ana_prices_liq
ana_prices
ana_prices_sn


ana_buffer_md--ingresa valores '-' en tmp_tblActualAnalytics_1
ana_buffer_tv --nada
ana_buffer_sp--nada
ana_buffer_uni --nada
ana_buffer_notes_uni


--TRUNCATE  TABLE  dbo.tblDailyAnalytics AS TDA
--SELECT * FROM  dbo.tblDailyAnalytics AS TDA


--SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
--WHERE txtProcess LIKE '%wr%'







--SELECT TR.* FROM  
--dbo.tblRattings AS TR
--INNER JOIN dbo.tblRattings AS B2
--ON 
--TR.txtID1 = B2.txtID1
--AND TR.txtRaterId = B2.txtRaterId
--AND TR.dteDate = B2.dteDate







--DECLARE @detedate DATETIME
--	DECLARE   C_for_date CURSOR FOR 
--		SELECT DISTINCT dtedate 
--		FROM tblRattings

--OPEN C_for_date
-- FETCH NEXT FROM C_for_date INTO @detedate
	
--	WHILE (@@FETCH_STATUS = 0 )



--SELECT 1

			
			
--			FETCH C_for_date INTO @detedate
--	END 
--CLOSE C_for_date
--DEALLOCATE  C_for_date





DECLARE @detedate DATETIME

/*Cursor para ingresar Plazos en tabla de trabajo*/
	DECLARE CGetPlazos CURSOR  FOR 
	SELECT  DISTINCT dtedate 
		FROM tblRattings
		
	OPEN  CGetPlazos
		FETCH NEXT FROM CGetPlazos INTO @detedate
		WHILE (@@FETCH_STATUS = 0 )
		BEGIN 
		
				UPDATE  TR
			SET TR.txtRate = B2.txtRate
			FROM 
			dbo.tblRattings AS TR
			INNER JOIN dbo.tblRattings AS B2
			ON 
			TR.txtID1 = B2.txtID1
			AND TR.txtRaterId = B2.txtRaterId
			AND TR.dteDate = B2.dteDate
			INNER JOIN tblRatingsCatalog  AS RC
			ON B2.txtRate = RC.txtRate 
			AND B2.txtRaterId = RC.txtRaterId
			AND tr.dteDate = @detedate
			 AND tr.txtRaterId <> 'D&P'
			 
	FETCH CGetPlazos INTO @detedate
	 END 
	CLOSE CGetPlazos
	DEALLOCATE CGetPlazos
	
	
		
		/*RESPALDOS   VIA-MXSQL*/
		--SELECT * INTO DBO.tmp_tblActualAnalytics_1_20150204 FROM  tmp_tblActualAnalytics_1
		--SELECT * INTO dbo.tmp_tblRattings_20150205 FROM dbo.tblRattings
		--SELECT * INTO DBO.tblDailyAnalytic_OACEVES_20150205 FROM DBO.tblDailyAnalytics  
        --SELECT * INTO BKP_tmp_tblUnifiedPricesReport_OACEVES FROM   dbo.tmp_tblUnifiedPricesReport AS TTUPR

		/**/

SELECT TXTID1,TXTDPQ FROM  tmp_tblUnifiedPricesReport

		
--DELETE  FROM  DBO.tblDailyAnalytics  
--WHERE txtItem = 'DPQ'
		
		
		  SELECT DISTINCT txtValue,COUNT(txtValue) FROM  tblDailyAnalytics
  WHERE txtItem = 'DPQ'
  
  GROUP BY txtValue
  ORDER BY 1


		  SELECT DISTINCT txtValue,COUNT(txtValue) FROM  tblDailyAnalytic_OACEVES_20150205
  WHERE txtItem = 'DPQ'
  GROUP BY txtValue
ORDER BY 1


		
		
		
		
		SELECT TR.txtRate,txtDPQ,* FROM  tmp_tblActualAnalytics_1 AS Ur
		INNER JOIN dbo.tblRattings AS TR
		ON Ur.txtId1 = TR.txtID1
		WHERE  UR.txtID1 = 'CO19500000B'
		AND TR.dteDate IN (SELECT MAX(DTEDATE ) FROM tblRattings WHERE txtID1 = 'CO19500000B')
		AND TR.txtRaterId  IN ('D&P', 'MOO')  
		
	
		
		SELECT * FROM  dbo.tblRattings AS TR
		WHERE txtID1 = 'CO19500000B'
		
		SELECT * FROM  
		
		
		
		
		SELECT * FROM  dbo.tblDailyAnalytics AS TDA
		WHERE txtID1 = 'MIRC0017432'
		
		
		
		
		
		
		
		SELECT txtId1,txtDPQ FROM  BKP_tmp_tblUnifiedPricesReport_OACEVES
		WHERE txtid1 = 'MIRC0000045'
		SELECT txtId1,txtDPQ FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR
		WHERE txtid1 = 'MIRC0000045'
		
		
		
		
		SELECT  *  FROM tmp_tblUnifiedPricesReport  AS mine
		INNER JOIN   BKP_tmp_tblUnifiedPricesReport_OACEVES AS uniac
		ON mine.txtid1 = uniac.txtId1
		--AND mine.txtDPQ<>uniac.txtDPQ
		
	
	SELECT   * from tmp_tblUnifiedPricesReport 
	SELECT * FROM  BKP_tmp_tblUnifiedPricesReport_OACEVES
	
	
		--SELECT DISTINCT txtId1 FROM  tmp_tblUnifiedPricesReport
		
		
		
		--SELECT * FROM  tmp_tblActualAnalytics_1 AS ORIGINAL
		--LEFT JOIN tmp_tblActualAnalytics_1_20150204 AS BACK
		--ON ORIGINAL.txtId1 = BACK.TXTID1
		
		
		
		
		
		
		
		
		SELECT * FROM  tmp_tblActualAnalytics_1_20150204
		
		
		
	SELECT txtDPQ FROM  tmp_tblActualAnalytics_1
	WHERE txtID1 = 'CO19500000B'
	SELECT txtDPQ FROM  tmp_tblActualAnalytics_1_20150204
	WHERE txtID1 = 'CO19500000B'
	
	
	
	
	
	
	
	
	
	SELECT * FROM  dbo.tblRattings AS TR
	WHERE txtID1 = 'MCFO9550068'
	SELECT * FROM  [VIA-MXSQL].MxFixIncome.dbo.tblRattings AS TR
	WHERE txtID1 = 'MCFO9550068'
	
	
	
	
	
	
	
		SELECT txtDPQ FROM    dbo.tmp_tblActualAnalytics_1 AS TTAA
		
		
		
		
		
	
		
		
		--DELETE  FROM tmp_tblActualAnalytics_1
		--WHERE txtDPQ IS NOT NULL
		
		
		
		
		
	--WHERE txtID1 = 'MCFO9550068'
	
	
	
	SELECT txtDPQ FROM  [VIA-MXSQL].MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS TTAA
	WHERE txtID1 = 'MCFO9550068'
	
	
	
	SELECT * FROM  dbo.tblDailyAnalytics AS TDA
	WHERE txtID1 = 'MCFO9550068'
	AND txtItem = 'DPQ'
	
	SELECT * FROM  [VIA-MXSQL].MxFixIncome.dbo.tblDailyAnalytics AS TDA
	WHERE txtID1 = 'MCFO9550068'
	AND txtItem = 'DPQ'
	
	
	--ERROR EN CALIFICACIONES D&P
--VER --OK	
--HRT --OK 
--moo -OK 
--fIT -OK
--S&P --OK



--
SELECT DISTINCT txtID1,dteDate  FROM tblRattings
WHERE txtRaterId = 'D&P'




SELECT LEN(tr.txtID1),LEN(TR.dteDate),LEN(tr.txtRate),LEN(TR.txtRaterId) FROM   
dbo.tblRattings AS TR
INNER JOIN dbo.tblRattings AS B2
ON 
TR.txtID1 = B2.txtID1
AND TR.txtRaterId = B2.txtRaterId
AND TR.dteDate = B2.dteDate
INNER JOIN tblRatingsCatalog  AS RC
ON B2.txtRate = RC.txtRate 
AND B2.txtRaterId = RC.txtRaterId




--SELECT * INTO dbo.tmp_tblRattings_20150205 FROM dbo.tblRattings






SELECT * FROM  dbo.tblDailyAnalytics AS TDA
SELECT * FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR












SELECT LEN(txtRate),LEN(txtRaterId) FROM  tblRatingsCatalog
WHERE txtCountry = 'MX'



SELECT * FROM  dbo.tblDailyAnalytics AS TDA
WHERE txtitem = 'dpq'







SELECT * FROM  sys.procedures AS P
INNER JOIN sys.tables AS T
ON 











WITH stored_procedures AS 
(
SELECT 
o.name AS proc_name, oo.name AS table_name,
ROW_NUMBER() OVER(partition by o.name,oo.name ORDER BY o.name,oo.name) AS row
FROM sysdepends d 
INNER JOIN sysobjects o ON o.id=d.id
INNER JOIN sysobjects oo ON oo.id=d.depid
WHERE o.xtype = 'P'
AND o.name = 'sp_productos_accival'
)
SELECT proc_name, table_name FROM stored_procedures
WHERE row = 1
ORDER BY proc_name,table_name




sp_helptext sp_productos_ACCIVAL



SELECT * FROM  sys.procedures AS P




WHERE dbo.tblRattings.txtID1 = 'MAAA5110003'










SELECT * FROM  dbo.tblRattings AS TR
WHERE txtID1 = 'MAAA5110003'










SELECT * FROM  dbo.tblRattings AS TR
WHERE txtId1 = 'MCFO9550068'

UPDATE  dbo.tblRattings 
SET  txtRate = 'Aaa.mx'         
WHERE txtId1 = 'MCFO9550068'
AND txtRaterId = 'MOO'



  Aaa.mx    
 SELECT txtDPQ,* FROM  dbo.tmp_tblActualAnalytics_1 AS TTAA
  WHERE txtId1 = 'MCFO9550068'
  
   SELECT txtDPQ,* FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR
  WHERE txtId1 = 'MCFO9550068'
  
  
BUFFER_md


  
INSERT INTO   dbo.tblDailyAnalytics 
 SELECT * FROM  [VIA-MXSQL].MxFixIncome.dbo.tblDailyAnalytics AS TDA
 WHERE txtId1 = 'MCFO9550068'
  AND txtItem = 'dpq'
  
  
  
  TRUNCATE TABLE dbo.tmp_tblActualAnalytics_2 
  
 SELECT * FROM  dbo.tmp_tblActualAnalytics_2 AS TTAA
  WHERE txtId1 = 'MCFO9550068'
  
  
  SELECT * FROM  dbo.tblRattings AS TR
    WHERE txtId1 = 'MCFO9550068'
  
  
  SELECT * FROM  rattings
  
  
  
  sp_helptrigger tblDailyAnalytics
  
  
  tgr_tblRattings_Analytics_For_Update, Line 74
  --///////////////////////////////////////////////////////////////////////////////////////////////77777
  sp_helptext tgr_tblRattings_Analytics_For_Update
  
  
  
  	SELECT * FROM   
			dbo.tblRattings AS TR
			INNER JOIN dbo.tblRattings AS B2
			ON 
			TR.txtID1 = B2.txtID1
			AND TR.txtRaterId = B2.txtRaterId
			AND TR.dteDate = B2.dteDate
			INNER JOIN tblRatingsCatalog  AS RC
			ON B2.txtRate = RC.txtRate 
			AND B2.txtRaterId = RC.txtRaterId
			 AND tr.txtRaterId = 'FIT'
			 AND LEN(TR.txtRate) >10
  