
--CREATE PROCEDURE [dbo].[usp_productos_INGAFORE];3 --'20140528','1'
--@txtDate AS VARCHAR(10),
--@txtFlag AS VARCHAR(1)
--AS 
--BEGIN

--SET NOCOUNT ON

DECLARE @txtFlag AS VARCHAR(1) 
DECLARE  @txtDate AS VARCHAR(10)
SET @txtDate = '20141113' 
SET @txtFlag = 1

	DECLARE @txtProcDate AS DATETIME
	DECLARE @txtLiquidation AS VARCHAR(10)
	DECLARE @txtOwner AS CHAR(5)

	SET @txtProcDate = (SELECT MxFixIncome.dbo.fun_NextTradingDate(CONVERT(CHAR(8),@txtDate,112),1,'MX'))
	SET @txtLiquidation = '24H'
	SET @txtOwner = 'ING01'

------------------------------------------------------------------------------------------------
	-- genero buffers temporales
	DECLARE @tbl_tmpData TABLE (
		[txtId1] [char] (11) NOT NULL,
		[txtTv] [char] (10) NOT NULL,
		[txtIssuer] [char] (10) NOT NULL,
		[txtSeries] [char] (10) NOT NULL,
		[txtSerial] [char] (10) NOT NULL,
		[txtLiquidation] [char] (3) NOT NULL
			PRIMARY KEY CLUSTERED 
				([txtId1],[txtLiquidation]),
		[intDTM] [int] NOT NULL,
		[dblPav] [float] NOT NULL,
		[dblMarketPrice] [float] NOT NULL,
		[dblFRR] [float] NOT NULL,
		[dblDelta] [float] NOT NULL,
		[dblLAR] [float] NOT NULL,
		[dblSHO] [float] NOT NULL,
		[dblLARPRL] [float] NOT NULL,
		[dblSHOPRL] [float] NOT NULL,
		[dblDIVIDEN] [float],
		[txtSWP1FIJ] [VARCHAR](MAX),
		[txtSWP2FIJ] [VARCHAR](MAX)
		 
	)

	-- genero buffers temporales MARKET PRICES
	DECLARE @tbl_tmpActualMarketPrices TABLE (
		[txtId1] [char] (11) NOT NULL 
			PRIMARY KEY CLUSTERED ( [txtId1] ),
		[dblMarketPrice] [float] NOT NULL
	)

	-- genero buffers temporales IDS vs OWNERS
	DECLARE @tbl_tmpIdsVsOwners TABLE (
		[txtId1] [char] (11) NOT NULL 
			PRIMARY KEY CLUSTERED ( [txtId1] )
	)
	
	-- genero buffers temporales IDS vs OWNERS
	DECLARE @tbl_tmp_addderivative TABLE (
		[txtId1] [char] (11) NOT NULL 
			PRIMARY KEY CLUSTERED ( [txtId1] )
	)
	------------------------------------------------------------------------------------------------
	-- *******************************************
	-- HECHOS DE MERCADO
	-- *******************************************
	-- JATO (01:47 p.m. 2007-07-17)
	-- identifico los instrumentos 
	-- que pertenecen al cliente actual

	INSERT INTO @tbl_tmpIdsVsOwners (txtId1)
	SELECT txtId1
	FROM MxDerivatives.dbo.tblDerivativesOwners (NOLOCK)
	WHERE
		txtOwnerId = @txtOwner
		AND dteBeg <= @txtDate
		AND dteEnd >= @txtDate
	UNION
	SELECT d.txtId1
	FROM 
		MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)
		LEFT OUTER JOIN MxDerivatives.dbo.tblDerivativesOwners AS o (NOLOCK)
			ON d.txtId1 = o.txtId1
	WHERE
		o.txtId1 IS NULL
	 
	-- obtengo los hechos de mercado 
	-- FUTUROS
	INSERT @tbl_tmpActualMarketPrices
	SELECT 
		i.txtId1, 
		dblPrice
	FROM 
		@tbl_tmpIdsVsOwners AS u
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON u.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)
		ON i.txtId1 = d.txtId1
	WHERE
		d.dteDate = (
					SELECT MAX(dteDate)
					FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
					WHERE
						txtId1 = d.txtId1
						AND dteDate <= @txtDate
					)
		AND d.dteTime = (
					SELECT MAX(dteTime)
					FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
					WHERE
						txtId1 = d.txtId1
						AND dteDate = d.dteDate
					)
		AND (
			i.txtTv IN ('FA', 'FD', 'FU', 'FS')
			OR (
				i.txtTv IN ('FI', 'FB')
				AND i.txtIssuer IN ('IPC', 'CE91','M10','M3','TE28')
			)
		)
		AND i.txtSerial LIKE 'P%'
	UNION
	SELECT 
		i.txtId1, 
		100 / dblPrice AS dblPrice
	FROM 
		@tbl_tmpIdsVsOwners AS u
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON u.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)
		ON i.txtId1 = d.txtId1
	WHERE
		d.dteDate = (
				SELECT MAX(dteDate)
				FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
				WHERE
					txtId1 = d.txtId1
					AND dteDate <= @txtDate
					)
		AND d.dteTime = (
				SELECT MAX(dteTime)
				FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
				WHERE
					txtId1 = d.txtId1
					AND dteDate = d.dteDate
					)
		AND i.txtTv IN ('FC')
		AND i.txtIssuer = 'CEUA'
		AND i.txtSerial LIKE 'P%'
	UNION
	SELECT 
		i.txtId1, 
		dblPrice * (
	CASE 
		WHEN ir.dblVAlue IS NULL THEN 1
	ELSE ir.dblVAlue
	END 
	) AS dblPrice
	FROM 
		@tbl_tmpIdsVsOwners AS u
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON u.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivatives AS de (NOLOCK)
		ON i.txtId1 = de.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)
		ON i.txtId1 = d.txtId1
		LEFT OUTER JOIN MxFixIncome..tblIrc AS ir (NOLOCK)
		ON 
			ir.txtIrc = (
					CASE de.txtCurrency
					WHEN 'USD' THEN 'UFXU'
					WHEN 'DLL' THEN 'UFXU'
					ELSE de.txtCurrency
					END 
						) 
			AND ir.dteDate = @txtDate
	WHERE
		d.dteDate = (
				SELECT MAX(dteDate)
				FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
				WHERE
		txtId1 = d.txtId1
		AND dteDate <= @txtDate
					)
		AND d.dteTime = (
				SELECT MAX(dteTime)
				FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
				WHERE
					txtId1 = d.txtId1
					AND dteDate = d.dteDate
			)
		AND i.txtTv IN ('FC', 'FI', 'FB')
		AND NOT i.txtIssuer IN ('CEUA', 'IPC', 'CE91','M10','M3','TE28', 'JY')
		AND i.txtSerial LIKE 'P%'
	UNION
	SELECT 
		i.txtId1, 
		dblPrice * (
	CASE 
		WHEN ir.dblVAlue IS NULL THEN 1
	ELSE ir.dblVAlue
	END 
		) /10000 AS dblPrice
	FROM 
		@tbl_tmpIdsVsOwners AS u
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON u.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivatives AS de (NOLOCK)
		ON i.txtId1 = de.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)
		ON i.txtId1 = d.txtId1
		LEFT OUTER JOIN MxFixIncome..tblIrc AS ir (NOLOCK)
		ON 
		ir.txtIrc = (
					CASE de.txtCurrency
					WHEN 'USD' THEN 'UFXU'
					WHEN 'DLL' THEN 'UFXU'
					ELSE de.txtCurrency
					END 
					) 
		AND ir.dteDate = @txtDate
	WHERE
		d.dteDate = (
					SELECT MAX(dteDate)
					FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
					WHERE
						txtId1 = d.txtId1
						AND dteDate <= @txtDate
					)
		AND d.dteTime = (
					SELECT MAX(dteTime)
					FROM MxDerivatives.dbo.tblDerivativesPrices (NOLOCK)
					WHERE
						txtId1 = d.txtId1
						AND dteDate = d.dteDate
					)
		AND i.txtTv IN ('FC')
		AND i.txtIssuer IN ('JY')
		AND i.txtSerial LIKE 'P%'
	 
	-- MEXDER de 1 dia
	INSERT @tbl_tmpActualMarketPrices
	SELECT 
		i2.txtId1,
		t.dblMarketPrice
	FROM 
		@tbl_tmpActualMarketPrices AS t
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON t.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblIds AS i2 (NOLOCK)
		ON 
			i.txtTv = i2.txtTv
			AND i.txtIssuer = i2.txtIssuer
			AND i.txtSeries = i2.txtSeries
	WHERE
		i.txtSerial LIKE 'P%'
		AND NOT i2.txtSerial LIKE 'P%'
		AND i2.txtId1 NOT IN ('XGPP0000037',
							'XGPP0000038',
							'XGPP0000039',
							'XGPP0000040',
							'XGPP0000041',
							'XGPP0000042',
							'XGPP0000043',
							'XGPP0000046',
							'XGPP0000047',
							'XGPP0000048',
							'XGPP0000049',
							'XGPP0000050',
							'XGPP0000051',
							'XGPP0000052',
							'XGPP0000053',
							'XHFK0000212',
							'XHFK0000214',
							'XHFK0000215',
							'XHFK0000216')

	 
	-- obtengo los F0 para los demas instrumentos
	-- que esten en el vector de precios
	INSERT @tbl_tmpActualMarketPrices
	SELECT
		i.txtId1,
		CASE d.intFamily
		WHEN 13 THEN p.dblValue * 100
		ELSE p.dblValue
		END AS dblMarketPrice
	 
	FROM
		@tbl_tmpIdsVsOwners AS u
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON u.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblPrices AS p (NOLOCK)
		ON p.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)
		ON p.txtId1 = d.txtId1
	WHERE
		p.dteDate = @txtDate
		AND p.txtLiquidation = @txtLiquidation
		AND p.txtItem = 'F0'
		AND i.txtTv IN ('FWD', 'CALL', 'PUT')

	-- ************************************************
	-- obtengo el consolidado
	-- ************************************************
	INSERT @tbl_tmpData (
			txtId1,
			txtTv,
			txtIssuer,
			txtSeries,
			txtSerial,
			txtLiquidation,
			intDTM,
			dblPav,
			dblMarketPrice,
			dblFRR,
			dblDelta,
			dblLAR,
			dblSHO,
			dblLARPRL,
			dblSHOPRL
			)
		SELECT 
			i.txtId1, 
			i.txtTv,
			i.txtIssuer,
			i.txtSeries,
			i.txtSerial,
			p.txtLiquidation,
			CASE 
				WHEN DATEDIFF(d, @txtProcDate, d.dteMaturity) < 0 THEN 0
			ELSE DATEDIFF(d, @txtProcDate, d.dteMaturity)
			END AS intDTM,
			MAX(CASE p.txtItem WHEN 'PAV' THEN p.dblValue ELSE -999999999 END) AS dblPav,
			CASE 
				WHEN mp.dblMarketPrice IS NULL THEN 0
			ELSE mp.dblMarketPrice
			END AS dblMarketPrice,
			MAX(CASE p.txtItem WHEN 'FRR' THEN p.dblValue ELSE 0 END) AS dblFRR,
			MAX(CASE p.txtItem WHEN 'DELTA' THEN p.dblValue ELSE -999 END) AS dblDelta,
			MAX(CASE p.txtItem WHEN 'LAR' THEN p.dblValue ELSE 0 END) AS dblLar,
			MAX(CASE p.txtItem WHEN 'SHO' THEN p.dblValue ELSE 0 END) AS dblSho,
			MAX(CASE p.txtItem WHEN 'LARPRL' THEN p.dblValue ELSE 0 END) AS dblLarPrl,
			MAX(CASE p.txtItem WHEN 'SHOPRL' THEN p.dblValue ELSE 0 END) AS dblShoPrl
		FROM 
			@tbl_tmpIdsVsOwners AS u
			INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
			ON u.txtId1 = i.txtId1
			INNER JOIN MxDerivatives.dbo.tblPrices AS p (NOLOCK)
			ON u.txtId1 = p.txtId1
			INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)
			ON u.txtId1 = d.txtId1
			LEFT OUTER JOIN @tbl_tmpActualMarketPrices AS mp
			ON u.txtId1 = mp.txtId1
		WHERE
			p.dteDate = @txtDate
		GROUP BY 
			i.txtId1,
			i.txtTv,
			i.txtIssuer,
			i.txtSeries,
			i.txtSerial,
			p.txtLiquidation,
			d.dteMaturity,
			mp.dblMarketPrice

	-- Agrego tblDerivativesPrices.dblPrice del conjunto de los TV = {OA,OI,OD}
	UPDATE u
		SET dblMarketPrice = dp.dblPrice
	FROM
		@tbl_tmpData AS u
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON u.txtId1 = i.txtId1
		INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS dp (NOLOCK)
		ON i.txtId1 = dp.txtId1
	WHERE
		dp.dteDate = @txtDate
		AND i.txtTv IN ('OA','OI','OD')

	-- Agrego tblDerivativesPrices.dblPrice del conjunto de los TV = {OA,OI,OD}
	UPDATE u
		SET dblDIVIDEN = dp.txtValue
	FROM
		@tbl_tmpData AS u
		INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)
		ON u.txtId1 = i.txtId1
		INNER JOIN MxFixIncome.dbo.tblircadd AS dp (NOLOCK)
		ON i.txtIssuer = dp.txtIRC
	WHERE
		dp.dteDate = @txtDate
		AND dp.txtItem = 'DIVIDEN'
		AND i.txtTv = 'FWD'

	-- correccion de deltas 
	UPDATE @tbl_tmpData 
		SET dblDelta = 0
	WHERE
		dblDelta = -999
		
		--UPDATE u 
		--SET txtSWP2FIJ = b.txtValue
		--FROM @tbl_tmpData AS u
		--LEFT   JOIN  MxDerivatives.dbo.tblDerivativesAdd AS B
		--		ON u.txtId1 = b.txtId1
		--		WHERE b.txtId1 IS  NOT NULL 
		--		AND b.dteDate = @txtDate AND txtItem IN ('SWP2FIJ')   
				
		--		UPDATE u 
		--SET txtSWP1FIJ = b.txtValue
		--FROM @tbl_tmpData AS u
		--LEFT   JOIN MxDerivatives.dbo.tblDerivativesAdd AS B
		--		ON u.txtId1 = b.txtId1
		--		WHERE b.txtId1 IS  NOT NULL 
		--		AND b.dteDate = @txtDate  AND txtItem IN ('SWP1FIJ')  
			/*FIND E ORIGINAL*/	
			
			
			
		DECLARE    @latestPricesAdd TABLE
		(
		txtId1 varchar(12),
		dteDate varchar(10),
		txtValue VARCHAR(50),
		txtitem VARCHAR(50)
				PRIMARY KEY CLUSTERED 
				([txtId1],[txtitem])
		)
		
		
			INSERT @latestPricesAdd
			SELECT
			  txtId1,
			  dteDate,
			 txtValue,
			txtitem
			 
			
			FROM (
			  SELECT
				*, 
				max_date = MAX(dteDate) OVER (PARTITION BY txtId1)
			  FROM MxDerivatives.dbo.tblDerivativesAdd WHERE txtItem IN ( 'SWP1FIJ' ,'SWP2FIJ')
			) AS s
			WHERE dteDate = max_date
			
			
			
				UPDATE u 
		SET txtSWP2FIJ =  b.txtValue 
		FROM @tbl_tmpData AS u
		LEFT   JOIN   @latestPricesAdd AS B
				ON u.txtId1 = b.txtId1
				WHERE  b.txtItem IN ('SWP2FIJ')   
				
				
					UPDATE u 
		SET txtSWP1FIJ =  b.txtValue
		FROM @tbl_tmpData AS u
		LEFT OUTER JOIN   @latestPricesAdd AS B
				ON u.txtId1 = b.txtId1
				WHERE  b.txtItem IN ('SWP1FIJ')   
			
			
			

--SELECT txtValue FROM  #latestPricesAdd




			SET NOCOUNT OFF

--	---- creo el vector

	
	SELECT 
		'H ' +
		'DR' +
		CONVERT( VARCHAR(10),@txtDate,112) +
		RTRIM(txtTv) + REPLICATE(' ',4 - LEN(txtTv)) +
		RTRIM(txtIssuer) + REPLICATE(' ',7 - LEN(txtIssuer)) +
		RTRIM(txtSeries) + REPLICATE(' ',6 - LEN(txtSeries)) +
		CASE WHEN dblPAV < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblPAV,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6) 
		END +
		CASE WHEN dblPAV < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblPAV,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6) 
		END +
		'000000000000' +
		'025009' +
		@txtFlag +
		SUBSTRING(REPLACE(STR(ROUND(intDTM,0),6,0), ' ', '0'), 1, 6) +
		'00000000' + 
		'0           ' + 
		RTRIM(txtSerial) + REPLICATE(' ',10 - LEN(txtSerial)) +   --		RTRIM(txtSerial) + REPLICATE(' ',10 - LEN(txtSerial)) +
		CASE WHEN dblMarketPrice < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), ' ', '0'), 11, 6) 
		END +
		CASE WHEN dblFRR < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblFRR,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6), ' ', '0'), 11, 6) 
		END +
		CASE WHEN dblDelta < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblDelta,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6), ' ', '0'), 11, 6) 
		END +
		CASE
			WHEN i.dblValue IS NULL THEN '000001000000'
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(i.dblValue,6),13,6), ' ', '0'), 1, 6) +
				SUBSTRING(REPLACE(STR(ROUND(i.dblValue,6),13,6), ' ', '0'), 8, 6) 
		END +
		CASE WHEN a.dblLar < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblLar,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6), ' ', '0'), 11, 6) 
		END +
		CASE WHEN a.dblSho < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblSho,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6), ' ', '0'), 11, 6) 
		END + 
		CASE WHEN a.dblLarPrl < 0 THEN  
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblLarPrl,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(a.dblLarPrl,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(a.dblLarPrl,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(a.dblLarPrl,6),16,6), ' ', '0'), 11, 6) 
		END +
		CASE WHEN a.dblShoPrl < 0 THEN 
			'-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblShoPrl,6),16,6), '-', '0'),' ','0'), 2, 8) + 
				SUBSTRING(REPLACE(STR(ROUND(a.dblShoPrl,6),16,6), ' ', '0'), 11, 6) 
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(a.dblShoPrl,6),16,6), ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(a.dblShoPrl,6),16,6), ' ', '0'), 11, 6) 
		END + 
		CASE
			WHEN a.dblDIVIDEN IS NULL THEN '000000000'
		ELSE 
			SUBSTRING(REPLACE(STR(ROUND(a.dblDIVIDEN,6),10,6), ' ', '0'), 1, 3) +
				SUBSTRING(REPLACE(STR(ROUND(a.dblDIVIDEN,6),10,6), ' ', '0'), 5, 7) 
		END	+


	/*		CASE WHEN a.txtSWP1FIJ = '-' OR a.txtSWP1FIJ = '' THEN '000000000' ELSE 
		CASE
			WHEN a.txtSWP1FIJ IS NULL THEN '000000000' ELSE
			CASE ISNUMERIC(a.txtSWP1FIJ) WHEN 1 THEN
			SUBSTRING(REPLACE(STR(ROUND(a.txtSWP1FIJ,6),10,6), ' ', '0'), 1, 3) +
				SUBSTRING(REPLACE(STR(ROUND(a.txtSWP1FIJ,6),10,6), ' ', '0'), 5, 7) ELSE '000000000' END END
		END  +
				
			CASE WHEN a.txtSWP2FIJ = '-' OR a.txtSWP2FIJ = '' THEN '000000000' ELSE 
	CASE
			WHEN a.txtSWP2FIJ IS NULL THEN '000000000' ELSE
			CASE ISNUMERIC(a.txtSWP2FIJ) WHEN 1 THEN
			SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ,6),10,6), ' ', '0'), 1, 3) +
				SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ,6),10,6), ' ', '0'), 5, 7) ELSE '000000000' END END 
				END 
				*/
				
			
				
				
	         --CASE WHEN a.txtSWP1FIJ  < '0' AND CHARINDEX('.',a.txtSWP1FIJ ,0)< 5 THEN 
          --'-'+ SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.txtSWP1FIJ ,6),10,6),  '-', '0'),' ','0'), 2, 2) + 
          --  SUBSTRING(REPLACE(STR(ROUND(a.txtSWP1FIJ ,6),16,6),  ' ', '0'), 11, 5) 
             
          --  ELSE 
          --  CASE WHEN a.txtSWP1FIJ  < '0' AND CHARINDEX('.',a.txtSWP1FIJ ,0)> 4
          --  THEN 
          --  '*********'
          --  END  END +
           
           
           
          --    CASE WHEN  a.txtSWP2FIJ < '0' AND CHARINDEX('.',a.txtSWP2FIJ,0)< 5 THEN 
          --'-'+ SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.txtSWP2FIJ ,6),10,6),  '-', '0'),' ','0'), 2, 2) + 
          --  SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ ,6),16,6),  ' ', '0'), 11, 5) 
             
          --  ELSE 
          --  CASE WHEN a.txtSWP2FIJ < '0' AND CHARINDEX('.',a.txtSWP2FIJ,0)> 4
          --  THEN 
          --  '*********'
 
				
				CASE WHEN a.txtSWP1FIJ = '-' OR a.txtSWP1FIJ = '' THEN '000000000' ELSE 
			   
			   CASE WHEN a.txtSWP1FIJ  < '0' AND CHARINDEX('.',a.txtSWP1FIJ ,0)< 5 THEN 
          '-'+ SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.txtSWP1FIJ ,6),10,6),  '-', '0'),' ','0'), 2, 2) + 
            SUBSTRING(REPLACE(STR(ROUND(a.txtSWP1FIJ ,6),16,6),  ' ', '0'), 11, 6) 
             
            ELSE 
            CASE WHEN a.txtSWP1FIJ  < '0' AND CHARINDEX('.',a.txtSWP1FIJ ,0)> 4
            THEN 
            '*********'
           ELSE 
			case WHEN a.txtSWP1FIJ IS NULL THEN '000000000' ELSE
			CASE ISNUMERIC(a.txtSWP1FIJ) WHEN 1 THEN
			SUBSTRING(REPLACE(STR(ROUND(a.txtSWP1FIJ,6),10,6), ' ', '0'), 1, 3) +
				SUBSTRING(REPLACE(STR(ROUND(a.txtSWP1FIJ,6),10,6), ' ', '0'), 5, 7) ELSE '000000000' END END 
				END END  END +
		
		--/*txtSWP2FIJ*/
		
		
		
			
				CASE WHEN a.txtSWP2FIJ = '-' OR a.txtSWP2FIJ = '' THEN '000000000' ELSE 
			   
			   CASE WHEN a.txtSWP2FIJ  < '0' AND CHARINDEX('.',a.txtSWP2FIJ ,0)< 5 THEN 
          '-'+ SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.txtSWP2FIJ ,6),10,6),  '-', '0'),' ','0'), 2, 2) + 
            SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ ,6),16,6),  ' ', '0'), 11, 6) 
             
            ELSE 
CASE WHEN a.txtSWP2FIJ  < '0' AND CHARINDEX('.',a.txtSWP2FIJ ,0)> 4
            THEN 
            '*********'
           ELSE 
			case WHEN a.txtSWP2FIJ IS NULL THEN '000000000' ELSE
			CASE ISNUMERIC(a.txtSWP2FIJ) WHEN 1 THEN
			SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ,6),10,6), ' ', '0'), 1, 3) +
				SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ,6),10,6), ' ', '0'), 5, 7) ELSE '000000000' END END 
				END END  END 
		
		
		
		
		SELECT CASE WHEN LEN(ISNULL( RTRIM(LTRIM(txtTV))+RTRIM(LTRIM(txtEmisora))+txtSerie,REPLICATE('0',19)) )<19 
		THEN RTRIM(ISNULL( RTRIM(LTRIM(txtTV))+RTRIM(LTRIM(txtEmisora))+txtSerie,REPLICATE('0',19)) )
		+ REPLICATE('0',19-LEN(ISNULL( RTRIM(LTRIM(txtTV))+RTRIM(LTRIM(txtEmisora))+txtSerie,REPLICATE('0',19))))
		ELSE REPLICATE('0',19) 
		END 
		 
		 
		 
		 
		 
		 SELECT *   
		 FROM  dbo.tblDerivativesAdd AS TDA
		INNER JOIN dbo.tblIds AS TI 
		ON TDA.txtId1 = TI.txtID1
		WHERE txtItem = 'CTD'
		AND dteDate = (SELECT MAX(dteDate) FROM   dbo.tblDerivativesAdd AS TDA WHERE txtId1 = 'MIRC0011525' AND txtItem = 'CTD')
		
		
		
		
		SELECT  TDA.txtId1  ,MAX(tda.dteDate),Uni.txtId1 FROM  tblDerivativesAdd AS TDA
		INNER JOIN tblIds AS TI
		ON TDA.txtId1 = TI.txtID1
		LEFT OUTER  JOIN tmp_tblUnifiedPricesReport AS Uni
		ON TDA.txtId1 = Uni.txtId1
		WHERE txtItem = 'CTD'
		GROUP BY TDA.txtId1,tda.dteDate,Uni.txtId1
	
	SELECT dblPRS FROM  tmp_tblUnifiedPricesReport
		
		
				
		--	CASE WHEN a.txtSWP2FIJ = '-' OR a.txtSWP2FIJ = '' THEN '000000000' ELSE 
		--	CASE WHEN a.txtSWP2FIJ < '0' THEN  
		--		 '-' + 
		--		SUBSTRING(REPLACE(STR(ROUND( a.txtSWP2FIJ,6),16,6), ' ', '0'), 11, 6) 
		--		+ REPLICATE ('0',8 - LEN( SUBSTRING(REPLACE(STR(ROUND( a.txtSWP2FIJ,6),16,6), ' ', '0'), 11, 6)))
		-- ELSE 
	
		--	case WHEN a.txtSWP2FIJ IS NULL THEN '000000000' ELSE
		--	CASE ISNUMERIC(a.txtSWP2FIJ) WHEN 1 THEN
		--	SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ,6),10,6), ' ', '0'), 1, 3) +
		--		SUBSTRING(REPLACE(STR(ROUND(a.txtSWP2FIJ,6),10,6), ' ', '0'), 5, 7) ELSE '000000000' END END 
		--		END END  
				
	

	FROM 
	
		@tbl_tmpData AS a
		INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)
		ON a.txtId1 = d.txtId1
		LEFT OUTER JOIN MxFixIncome..tblIrc AS i (NOLOCK)
		ON 
			i.txtIrc = (
					CASE 
						WHEN d.txtCurrency IN ('USD', 'DLL') THEN 'UFXU'
						WHEN d.txtCurrency IN ('MUD') THEN 'UDI'
					ELSE
						d.txtCurrency
					END 
					)
		AND i.dteDate = @txtDate
	WHERE 
		txtLiquidation IN (@txtLiquidation, 'MP')
		ORDER BY
			txtTv,
			txtIssuer,
			txtSeries,
			txtSerial
--END

----GO