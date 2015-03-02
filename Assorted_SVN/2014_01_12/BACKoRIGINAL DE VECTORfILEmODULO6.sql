

/*

ARCHIVO DE PRODUCCION BACKUP
*/

/****** Object:  NumberedStoredProcedure [dbo].[sp_createVectorFile];6    Script Date: 06/06/2014 20:15:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[sp_createVectorFile];6 
 	@txtDate AS VARCHAR(10),
	@txtLiquidation AS VARCHAR(10),
	@txtOwner AS VARCHAR(50) = 'all', -- Todos los instrumentos son por default
	@txtVectorInfo AS VARCHAR(10) = 'all' -- Toda tipo de información es por default
										  --  puede ser 'all', 'sn', 'trad'
 AS 
 BEGIN

	SET NOCOUNT ON

	DECLARE @fLiq AS BIT

	-- verifico si la liquidacion requerida
	-- efectivamente esta activada
	SET @fLiq = (	

		SELECT fBALoad
		FROM tblLiquidationCAtalog
		WHERE
			txtLiquidation = @txtLiquidation
	)

	IF @fLiq = 1
	BEGIN

		-- creamos tabla deposito
		DECLARE @tblTemp TABLE (
			[txtTv][VARCHAR](11),
			[txtEmisora][VARCHAR](10),
			[txtSerie][VARCHAR](10),
			[txtID2][VARCHAR](50),
			[dblDTM][FLOAT],
			[dblPRS][FLOAT],
			[dblCPD][FLOAT],
			[dblPRL][FLOAT],
			[dblPRLBid][FLOAT],
			[dblPRLAsk][FLOAT],
			[dblYTM][FLOAT],
			[dblYTMBid][FLOAT],
			[dblYTMAsk][FLOAT],
			[dblLDR][FLOAT],
			[dblLDRBid][FLOAT],
			[dblLDRAsk][FLOAT],
			PRIMARY KEY CLUSTERED (
				txtTV, txtEmisora, txtSerie
				)
		)

		-- PARTE TRADICIONAL
		 -- bonos guber y privados
		IF @txtVectorInfo IN ('all','trad')
			INSERT @tblTemp
			SELECT DISTINCT
				i.txtTv,
				i.txtEmisora,
				i.txtSerie,
				a1.txtId2,
				a.dblDTM,
		
				a.dblPRS,
				a.dblCPD,
			
				a.dblPRL,
				bp.dblValue AS dblPRLBid,
				ap.dblValue AS dblPRLAsk,
			
				a.dblYTM,
				bp2.dblValue AS dblYTMBid,
				ap2.dblValue AS dblYTMAsk,
			
				ROUND(a.dblLDR, 6) AS dblLDR,
				ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,
				ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk
			
			 FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tblTvCatalog AS tv (NOLOCK)
				ON i.txtTv = tv.txtTv
				INNER JOIN tblBonds AS b (NOLOCK)
				ON i.txtId1 = b.txtId1
				INNER JOIN tmp_tblActualPrices AS a (NOLOCK)
				ON i.txtId1 = a.txtId1
				INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)
				ON a1.txtId1 = a.txtId1
				AND a1.txtLiquidation = (
					CASE a.txtLiquidation  
					WHEN 'MP' THEN 'MD'  
					ELSE a.txtLiquidation  
					END
				)
				INNER JOIN tblBidPrices AS bp (NOLOCK)
				ON 
					i.txtId1 = bp.txtId1
					AND bp.dteDate = @txtDate
					AND bp.txtItem = 'PRL'
					AND bp.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap
				ON 
					i.txtId1 = ap.txtId1
					AND ap.dteDate = @txtDate
					AND ap.txtItem = 'PRL'
					AND ap.txtLiquidation = a.txtLiquidation
				INNER JOIN tblBidPrices AS bp2 (NOLOCK)
				ON 
					i.txtId1 = bp2.txtId1
					AND bp2.dteDate = @txtDate
					AND bp2.txtItem = 'YTM'
					AND bp2.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap2 (NOLOCK)
				ON 
					i.txtId1 = ap2.txtId1
					AND ap2.dteDate = @txtDate
					AND ap2.txtItem = 'YTM'
					AND ap2.txtLiquidation = a.txtLiquidation
				LEFT OUTER JOIN tblFixedPrices AS fp (NOLOCK)
				ON i.txtId1 = fp.txtId1
			 WHERE
				a.txtLiquidation IN (@txtLiquidation, 'MP')
				AND fp.txtId1 IS NULL
				AND tv.intCategory IN (0, 2)
			 UNION
			
			 -- bonos bancarios que cuentan
			 -- con informacion valida (ytmbid > ytm and ytmask < ytm) para ser reportados
			
			 SELECT 
				i.txtTv,
				i.txtEmisora,
				i.txtSerie,
				a1.txtId2,
				a.dblDTM,
		
				a.dblPRS,
				a.dblCPD,
			
				a.dblPRL,
				bp.dblValue AS dblPRLBid,
				ap.dblValue AS dblPRLAsk,
			
				a.dblYTM,
				bp2.dblValue AS dblYTMBid,
				ap2.dblValue AS dblYTMAsk,
		
				ROUND(a.dblLDR, 6) AS dblLDR,
				ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,
				ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk
			
			 FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tblTvCatalog AS tv (NOLOCK)
				ON i.txtTv = tv.txtTv
				INNER JOIN tblBonds AS b (NOLOCK)
				ON i.txtId1 = b.txtId1
				INNER JOIN tmp_tblActualPrices AS a (NOLOCK)
				ON i.txtId1 = a.txtId1
				INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)
				ON a1.txtId1 = a.txtId1
				AND a1.txtLiquidation = (
					CASE a.txtLiquidation  
					WHEN 'MP' THEN 'MD'  
					ELSE a.txtLiquidation  
					END
				)
				INNER JOIN tblBidPrices AS bp (NOLOCK)
				ON 
					i.txtId1 = bp.txtId1
					AND bp.dteDate = @txtDate
					AND bp.txtItem = 'PRL'
					AND bp.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap (NOLOCK)
				ON 
					i.txtId1 = ap.txtId1
					AND ap.dteDate = @txtDate
					AND ap.txtItem = 'PRL'
					AND ap.txtLiquidation = a.txtLiquidation
				INNER JOIN tblBidPrices AS bp2 (NOLOCK)
				ON 
					i.txtId1 = bp2.txtId1
					AND bp2.dteDate = @txtDate
					AND bp2.txtItem = 'YTM'
					AND bp2.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap2 (NOLOCK)
				ON 
					i.txtId1 = ap2.txtId1
					AND ap2.dteDate = @txtDate
					AND ap2.txtItem = 'YTM'
					AND ap2.txtLiquidation = a.txtLiquidation
				LEFT OUTER JOIN tblFixedPrices AS fp (NOLOCK)
				ON i.txtId1 = fp.txtId1
			
			 WHERE
				a.txtLiquidation = @txtLiquidation
				AND fp.txtId1 IS NULL
				AND NOT tv.intCategory IN (0, 2)
				AND a.dblYTM < bp2.dblValue
				AND a.dblYTM > ap2.dblValue

		IF @txtVectorInfo IN ('all','sn')
			INSERT @tblTemp
			SELECT DISTINCT
				i.txtTv,
				i.txtEmisora,
				i.txtSerie,
				a1.txtId2,
				a.dblDTM,
		
				a.dblPRS,
				a.dblCPD,
			
				a.dblPRL,
				bp.dblValue AS dblPRLBid,
				ap.dblValue AS dblPRLAsk,
			
				a.dblYTM,
				bp2.dblValue AS dblYTMBid,
				ap2.dblValue AS dblYTMAsk,
			
				ROUND(a.dblLDR, 6) AS dblLDR,
				ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,
				ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk
			
			 FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tblTvCatalog AS tv (NOLOCK)
				ON i.txtTv = tv.txtTv
				INNER JOIN tblBonds AS b (NOLOCK)
				ON i.txtId1 = b.txtId1
				INNER JOIN tmp_tblActualPricesSN AS a (NOLOCK)
				ON i.txtId1 = a.txtId1
				INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)
				ON a1.txtId1 = a.txtId1
				AND a1.txtLiquidation = (
					CASE a.txtLiquidation  
					WHEN 'MP' THEN 'MD'  
					ELSE a.txtLiquidation  
					END
				)
				INNER JOIN tblBidPrices AS bp (NOLOCK)
				ON 
					i.txtId1 = bp.txtId1
					AND bp.dteDate = @txtDate
					AND bp.txtItem = 'PRL'
					AND bp.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap (NOLOCK)
				ON 
					i.txtId1 = ap.txtId1
					AND ap.dteDate = @txtDate
					AND ap.txtItem = 'PRL'
					AND ap.txtLiquidation = a.txtLiquidation
				INNER JOIN tblBidPrices AS bp2 (NOLOCK)
				ON 
					i.txtId1 = bp2.txtId1
					AND bp2.dteDate = @txtDate
					AND bp2.txtItem = 'YTM'
					AND bp2.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap2 (NOLOCK)
				ON 
					i.txtId1 = ap2.txtId1
					AND ap2.dteDate = @txtDate
					AND ap2.txtItem = 'YTM'
					AND ap2.txtLiquidation = a.txtLiquidation
				INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)
				ON 
					a.txtId1 = op.txtDir
				LEFT OUTER JOIN tblFixedPrices AS fp (NOLOCK)
				ON i.txtId1 = fp.txtId1
			 WHERE
				a.txtLiquidation IN (@txtLiquidation, 'MP')
				AND op.txtOwnerId IN (
					SELECT * FROM fun_select_owners (@txtOwner)
				)
				AND op.txtProductId IN ('SNOTES', 'PEQUITY')
				AND op.dteBeg <= @txtDate
				AND op.dteEnd >= @txtDate
				AND fp.txtId1 IS NULL
				AND tv.intCategory IN (0, 2)
			 UNION
			
			 -- bonos bancarios que cuentan
			 -- con informacion valida (ytmbid > ytm and ytmask < ytm) para ser reportados
			
			 SELECT 
				i.txtTv,
				i.txtEmisora,
				i.txtSerie,
				a1.txtId2,
				a.dblDTM,
		
				a.dblPRS,
				a.dblCPD,
			
				a.dblPRL,
				bp.dblValue AS dblPRLBid,
				ap.dblValue AS dblPRLAsk,
			
				a.dblYTM,
				bp2.dblValue AS dblYTMBid,
				ap2.dblValue AS dblYTMAsk,
		
				ROUND(a.dblLDR, 6) AS dblLDR,
				ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,
				ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk
			
			 FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tblTvCatalog AS tv (NOLOCK)
				ON i.txtTv = tv.txtTv
				INNER JOIN tblBonds AS b (NOLOCK)
				ON i.txtId1 = b.txtId1
				INNER JOIN tmp_tblActualPricesSN AS a (NOLOCK)
				ON i.txtId1 = a.txtId1
				INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)
				ON a1.txtId1 = a.txtId1
				AND a1.txtLiquidation = (
					CASE a.txtLiquidation  
					WHEN 'MP' THEN 'MD'  
					ELSE a.txtLiquidation  
					END
				)
				INNER JOIN tblBidPrices AS bp (NOLOCK)
				ON 
					i.txtId1 = bp.txtId1
					AND bp.dteDate = @txtDate
					AND bp.txtItem = 'PRL'
					AND bp.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap (NOLOCK)
				ON 
					i.txtId1 = ap.txtId1
					AND ap.dteDate = @txtDate
					AND ap.txtItem = 'PRL'
					AND ap.txtLiquidation = a.txtLiquidation
				INNER JOIN tblBidPrices AS bp2 (NOLOCK)
				ON 
					i.txtId1 = bp2.txtId1
					AND bp2.dteDate = @txtDate
					AND bp2.txtItem = 'YTM'
					AND bp2.txtLiquidation = a.txtLiquidation
				INNER JOIN tblAskPrices AS ap2 (NOLOCK)
				ON 
					i.txtId1 = ap2.txtId1
					AND ap2.dteDate = @txtDate
					AND ap2.txtItem = 'YTM'
					AND ap2.txtLiquidation = a.txtLiquidation
				INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)
				ON 
					a.txtId1 = op.txtDir
				LEFT OUTER JOIN tblFixedPrices AS fp (NOLOCK)
				ON i.txtId1 = fp.txtId1
			
			 WHERE
				a.txtLiquidation IN (@txtLiquidation, 'MP')
				AND op.txtOwnerId IN (
					SELECT * FROM fun_select_owners (@txtOwner)
				)
				AND op.txtProductId IN ('SNOTES', 'PEQUITY')
				AND op.dteBeg <= @txtDate
				AND op.dteEnd >= @txtDate
				AND fp.txtId1 IS NULL
				AND NOT tv.intCategory IN (0, 2)
				AND a.dblYTM < bp2.dblValue
				AND a.dblYTM > ap2.dblValue

	SET NOCOUNT OFF

		SELECT *
		FROM @tblTemp
		ORDER BY
			txtTv,
			txtEmisora,
			txtSerie

	END -- (IF)

	ELSE IF @fLiq = 0

		 SELECT 
			'NO EXISTE INFORMACION'

 END
 
 