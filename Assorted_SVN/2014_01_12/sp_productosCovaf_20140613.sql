
--CREATE PROCEDURE [dbo].[sp_productos_COVAF];29
DECLARE @txtDate AS VARCHAR(10) = '20140613'
--AS
--BEGIN

	SET NOCOUNT ON


IF OBJECT_ID('tempdb..#tblProhibidos') IS NOT NULL
DROP TABLE #tblProhibidos





		
DECLARE  @getLatestISD TABLE 
(
[txtId1] [char] (11),
[dteDate] [datetime],
[txtItem] [char] (10),
[txtValue] DATETIME
)
INSERT  INTO @getLatestISD
SELECT  * FROM  dbo.tblEquityAdd AS A
WHERE   CONVERT(VARCHAR(10),dteDate,112) in ( SELECT CONVERT(VARCHAR(10),MAX(dteDate),112) FROM tblEquityAdd AS b WHERE  a.txtId1 = b.txtId1)
AND A.txtItem = 'ISD'


DECLARE  @getLatestCUR TABLE 
(
[txtId1] [char] (11),
[dteDate] [datetime],
[txtItem] [char] (10),
[txtValueCUR] [varchar] (50) 
)
INSERT  INTO @getLatestCUR
SELECT * FROM  dbo.tblEquityAdd AS A
WHERE   CONVERT(VARCHAR(10),dteDate,112) in ( SELECT CONVERT(VARCHAR(10),MAX(dteDate),112) FROM tblEquityAdd AS b WHERE  a.txtId1 = b.txtId1)
AND A.txtItem = 'CUR'




	-- buffer para instrumentos prohibidos
	CREATE TABLE #tblProhibidos  (
		txtId1 CHAR (11)
		PRIMARY KEY(txtId1)
	)

	INSERT #tblProhibidos (txtId1)
	SELECT txtId1
	FROM fun_covaf_universo_prohibido(@txtDate, 'EMI') AS ne

	SET NOCOUNT OFF

	-- creo el reporte
	SELECT 

		RTRIM(u1.txtTv) + REPLICATE(' ', 7 - LEN(u1.txtTv)) + 
		RTRIM(u1.txtEmisora) + REPLICATE(' ', 10 - LEN(u1.txtEmisora)) +
		RTRIM(u1.txtSerie) + REPLICATE(' ', 10 - LEN(u1.txtSerie)) + 

		CASE 
		WHEN u1.txtISD IN ('-', 'NA') OR u1.txtISD IS NULL THEN RTRIM(CONVERT(VARCHAR(10),isd.txtvalue))
		ELSE RTRIM(REPLACE(REPLACE(u1.txtISD, '/', ''), '-', ''))
		END +

		CASE 
		WHEN u1.txtMTD IN ('-', 'NA') OR u1.txtMTD IS NULL THEN '20501103'
		ELSE RTRIM(REPLACE(REPLACE(u1.txtMTD, '/', ''), '-', ''))
		END +

		CASE 
		WHEN u1.txtDEA IN ('-', 'NA') OR u1.txtDEA IS NULL THEN '0'
		WHEN LEN(u1.txtDEA) > 1 THEN '8'
		ELSE u1.txtDEA
		END +

		CASE 
		WHEN u1.txtTCR IN ('-', 'NA') OR u1.txtTCR IS NULL THEN REPLICATE('0', 4)
		ELSE REPLICATE('0',4 - LEN(u1.txtTCR)) + RTRIM(u1.txtTCR) 
		END +

		CASE 
		WHEN u1.txtId2 IN ('-', 'NA') OR u1.txtId2 IS NULL THEN '               '
		ELSE RTRIM(u1.txtId2) + REPLICATE(' ',15 - LEN(u1.txtId2))
		END +

		CASE 
		WHEN LTRIM(RTRIM(u1.txtCur)) IN ('-', 'NA') OR u1.txtCur IS NULL THEN '     '--cur.txtValueCUR 
		ELSE 
			CASE
			WHEN LEFT(u1.txtCur, 1) = '[' THEN 
				CASE SUBSTRING(u1.txtCur, 2, 3)
				WHEN 'MPS' THEN 'MXN'
				ELSE SUBSTRING(u1.txtCur, 2, 3)
				END 
			ELSE '   '
			END
		END +
		
		CASE
		WHEN vm.txtCalculator IS NULL THEN '0000' 
		ELSE 
			CASE vm.txtCalculator
			WHEN 'ZERO_BOND' THEN '0001'
			ELSE '0002'
			END 
		END +

		CASE
		WHEN vm.txtCalculator IS NULL THEN '      '
		ELSE 
			CASE vm.txtCalculator
			WHEN  'ZERO_BOND' THEN '      '
			ELSE RTRIM(ISNULL(b.txtRefRateReset,'')) + REPLICATE(' ', 6 - LEN(ISNULL(b.txtRefRateReset,''))) 
			END 
		END +

		CASE
		WHEN vm.txtCalculator IS NULL THEN '      '
		ELSE 
			CASE vm.txtCalculator
			WHEN 'ZERO_BOND' THEN '      '
			ELSE RTRIM(ISNULL(b.txtCouponPayFreq,'')) + REPLICATE(' ',6 - LEN(ISNULL(b.txtCouponPayFreq,''))) 
			END 
		END +

		CASE
		WHEN vm.txtCalculator IS NULL THEN '0'
		ELSE 
			CASE 
			WHEN vm.txtCalculator LIKE 'AMOR%' THEN '1'
			ELSE '0'
			END 
		END +

		CASE 
		WHEN u1.txtNOM IN ('-', 'NA') OR u1.txtNOM IS NULL THEN REPLICATE('0', 22)
		ELSE REPLACE(REPLACE(STR(u1.txtNOM, 23, 10), '.', ''),' ', '0')
		END +

		CASE 
		WHEN u1.txtSMKT IN ('-', 'NA') OR u1.txtSMKT IS NULL THEN '000'
		ELSE 
			CASE UPPER(u1.txtSMKT)
			WHEN 'GUBERNAMENTAL' THEN '001'
			WHEN 'BANCARIO' THEN '002'
			WHEN 'PRIVADO' THEN '003'
			ELSE '000'
			END 
		END +

		CASE 
		WHEN u1.txtTv LIKE '5%' THEN 'ISI'
		WHEN u1.txtTv IS NULL THEN 'XXX'
		ELSE
			CASE 
			WHEN tv.intMarket = 0 THEN 'IRF'
			WHEN tv.intMarket = 1 THEN 'IRV'
			WHEN tv.intMarket = 2 THEN 'IFD'
			WHEN tv.intMarket IS NULL THEN 'XXX'
			ELSE 'XXX'
			END
		END +

		CASE 
		WHEN b.txtCouponRefRate IS NULL THEN '     '
		WHEN LTRIM(RTRIM(b.txtCouponRefRate)) = 'NULL' THEN '     '
		ELSE 
			RTRIM(SUBSTRING(b.txtCouponRefRate, 1, 5))  +
			REPLICATE(' ',5 - LEN(SUBSTRING(b.txtCouponRefRate, 1, 5)))
		END +
		
		CASE
		WHEN sc.intSector IS NULL THEN '00'
		ELSE 
			REPLICATE('0', 2 - LEN(LTRIM(STR(sc.intSector, 2, 0))))  + 
				LTRIM(STR(sc.intSector, 2, 0))
		END +

		CASE
		WHEN ss.intSubSector IS NULL THEN '000'
		ELSE 
			REPLICATE('0', 3 - LEN(LTRIM(STR(ss.intSubSector, 3, 0))))  + 
				LTRIM(STR(ss.intSubSector, 3, 0))
		END +

		CASE 
		WHEN u1.txtTIE IN ('-', 'NA') OR u1.txtTIE IS NULL THEN REPLICATE('0', 18)
		ELSE		
			CASE
			WHEN CAST(u1.txtTIE AS FLOAT) > 0 THEN 
				REPLACE(REPLACE(STR(u1.txtTIE, 18, 0), '.', ''),' ', '0')
			ELSE REPLICATE('0', 18)
			END 

		END +

		CASE
		WHEN u1.txtMOE IS NULL THEN REPLICATE('0', 30)
		WHEN PATINDEX('%.%',u1.txtMOE) > 0 THEN 
			REPLACE(REPLACE(STR(u1.txtMOE, 31, 10), '.', ''),' ', '0')
		ELSE REPLICATE('0', 30)
		END +

		CASE 
		WHEN LTRIM(RTRIM(u1.txtCur)) IN ('-', 'NA') OR u1.txtCur IS NULL THEN '   '
		ELSE 
			CASE
			WHEN LEFT(u1.txtCur, 1) = '[' THEN 
				CASE SUBSTRING(u1.txtCur, 2, 3)
				WHEN 'MPS' THEN 'MXN'
				ELSE SUBSTRING(u1.txtCur, 2, 3)
				END 
			ELSE '   '
			END
		END AS txtReporte

	FROM 
		tmp_tblAnalyticsUni AS u (NOLOCK) 			-- universo que cuenta con analiticos
		INNER JOIN tmp_tblActualAnalytics_1 AS u1 (NOLOCK)	-- tabla con analiticos
		ON u.txtId1 = u1.txtId1
		LEFT OUTER JOIN tblBonds AS b (NOLOCK)
		ON u1.txtId1 = b.txtId1
		LEFT OUTER JOIN tblValuationMap AS vm (NOLOCK)
		ON 
			b.txtType = vm.txtType
			AND b.txtSubType = vm.txtSubType
		LEFT OUTER JOIN tblTvCatalog AS tv (NOLOCK)
		ON u1.txtTv = tv.txtTv
		LEFT OUTER JOIN tblSectorCatalog AS sc (NOLOCK)
		ON sc.txtName = u1.txtSEC
		LEFT OUTER JOIN tblSubSectorCatalog AS ss (NOLOCK)
		ON ss.txtName = u1.txtRAM
		LEFT OUTER JOIN #tblProhibidos AS ne
		ON u1.txtId1 = ne.txtId1 --17180
		
		
	   LEFT OUTER  JOIN @getLatestISD AS ISD--17200
	   ON u1.txtId1 = ISD.txtId1
 
--INNER  JOIN @getLatestCUR AS CUR
-- ON ISD.txtId1 = CUR.txtId1			
		
		
		
	WHERE	
		u1.txtLiquidation IN ('MD', 'MP')
		AND (	
				u1.txtMTD IN ('-', 'NA') 
				OR u1.txtMTD IS NULL
				OR b.dteMaturity >= @txtDate
		)
		AND ne.txtId1 IS NULL
		
		--AND u1.txtTv ='1E'
		--AND u1.txtEmisora ='REX'
		--AND u1.txtSerie = 'gb'
		
		
	ORDER BY
		u1.txtTv,
		u1.txtEmisora,
		u1.txtSerie
		
		
	
	
	
	
	
	


		
--DECLARE  @getLatestISD TABLE 
--(
--[txtId1] [char] (11),
--[dteDate] [datetime],
--[txtItem] [char] (10),
--[txtValue] [varchar] (50) 
--)
--INSERT  INTO @getLatestISD
--SELECT * FROM  dbo.tblEquityAdd AS A
--WHERE   CONVERT(VARCHAR(10),dteDate,112) in ( SELECT CONVERT(VARCHAR(10),MAX(dteDate),112) FROM tblEquityAdd AS b WHERE  a.txtId1 = b.txtId1)
--AND A.txtItem = 'ISD'


--DECLARE  @getLatestCUR TABLE 
--(
--[txtId1] [char] (11),
--[dteDate] [datetime],
--[txtItem] [char] (10),
--[txtValueCUR] [varchar] (50) 
--)
--INSERT  INTO @getLatestCUR
--SELECT * FROM  dbo.tblEquityAdd AS A
--WHERE   CONVERT(VARCHAR(10),dteDate,112) in ( SELECT CONVERT(VARCHAR(10),MAX(dteDate),112) FROM tblEquityAdd AS b WHERE  a.txtId1 = b.txtId1)
--AND A.txtItem = 'CUR'

	
	
	
	
	

	

--SELECT TOP 10 	
--u1.txtTv,
--u1.txtEmisora,
--u1.txtSerie,
--u1.txtISD,
--CASE WHEN u1.txtISD = '-' THEN ISD.txtValue ELSE u1.txtISD END AS uslattest,
--u1.txtMTD,
--u1.txtDEA,
--u1.txtTCR,
--u1.txtId2,
--u1.TXTID1,
--u1.txtCur,
--CASE WHEN u1.txtCur = '-' THEN cur.txtValueCUR ELSE u1.txtCur END AS curlatest

-- FROM  tmp_tblActualAnalytics_1 AS U1
-- LEFT OUTER JOIN @getLatestISD AS ISD
-- ON U1.txtId1 = ISD.txtId1
-- LEFT OUTER JOIN @getLatestCUR AS CUR
-- ON ISD.txtId1 = CUR.txtId1
-- WHERE 	 u1.txtTv ='1E'
--		AND u1.txtEmisora ='REX'
		
