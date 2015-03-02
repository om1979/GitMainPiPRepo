USE [MxFixIncome]
GO

/****** Object:  StoredProcedure [dbo].[usp_productos_PiPGenericos]    Script Date: 10/27/2014 14:10:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	Autor:			Lic. René López Salinas
--	Creacion:		11:29 p.m. 2011-03-23
--	Descripcion:    Procedimiento que genera producto: VectorBrokersPrivadosYYYYMMDD.xls
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos]
 	@txtDate AS DATETIME,
	@txtFlag AS CHAR(1) = '0'

AS 

BEGIN

	SET NOCOUNT ON 

	DECLARE	@txtDate1 AS VARCHAR(10)
	SET @txtDate1 = CONVERT(VARCHAR(10),@txtDate,111)

	-- Tabla de Sobre Tasas LDR
	DECLARE @tblPricesLDR TABLE (
		[txtId1][CHAR](11),
		[dblLDR][FLOAT]
	PRIMARY KEY CLUSTERED (
			txtId1
			)
	)

	-- Tabla de Analiticos 1
	DECLARE @tmp_tblActualAnalytics_1 TABLE (
		[txtId1][CHAR](11),
		[txtCTY][VARCHAR](13),
		[txtSPQ][VARCHAR](10),
		[txtFIQ][VARCHAR](10),
		[txtDPQ][VARCHAR](10),
		[txtDCR][VARCHAR](25)  
	PRIMARY KEY CLUSTERED (
			txtId1
			)
	)

	-- Tabla de Analiticos 2
	DECLARE @tmp_tblActualAnalytics_2 TABLE (
		[txtId1][CHAR](11),
		[txtHRQ][VARCHAR](10)
	PRIMARY KEY CLUSTERED (
			txtId1
			)
	)

	-- Tabla temporal de Keys REF_PRICES ó REFRATE
	DECLARE @tmp_tblBondsAddREFs TABLE (
		txtId1  CHAR(11),
		txtItem CHAR(10),
		dteDate DATETIME,
		txtIRC CHAR(30),
		txtValor CHAR(30)
		PRIMARY KEY(txtId1,txtItem,dteDate)
	)

	-- Tabla para cargar las operaciones de los brokers del día 
	DECLARE @tmp_itblmarketpositionsprivates TABLE (
			[dteDate] [datetime] NOT NULL,
			[intIdBroker] [int] NOT NULL,
			[intLine] [int] NOT NULL,
			[intPlazo] [int] NOT NULL,
			[txtTv] [varchar](5) NOT NULL,
			[txtEmisora] [varchar](50) NOT NULL,
			[txtSerie] [varchar](50) NOT NULL,
			[txtOperation] [varchar](10) NOT NULL,
			[dblRate] [float] NOT NULL,
			[dblAmount] [float] NOT NULL,
			[dteBeginHour] [datetime] NOT NULL,
			[dteEndHour] [datetime] NOT NULL,
			[txtLiquidation] [varchar](3) NOT NULL,
		PRIMARY KEY CLUSTERED (
			dteDate, intIdBroker, intLine, intPlazo, txtTv, txtEmisora, txtSerie, txtOperation, dblRate, dblAmount, dteBeginHour, dteEndHour, txtLiquidation
			)
	)

	-- Creo tabla de resultados
	DECLARE @tmp_tblResults TABLE (
		[txtSortbeginhour][DATETIME],
		[txtId1][CHAR](11),
		[dtedate][DATETIME],
		[txtTv][CHAR](4),
		[txtEmisora][CHAR](7),
		[txtSerie][CHAR](6),
		[txtDTM][VARCHAR](5),
		[txtCTY][VARCHAR](13),
		[txtOperation][VARCHAR](6),
		[txtamount][VARCHAR](12),
		[txtRate][VARCHAR](30),
		[txtBaseCotizacion][VARCHAR](6),
		[txtbeginhour][VARCHAR](13),
		[txtendhour][VARCHAR](13),
		[txtLiquidation][VARCHAR](3),
		[txtDCR][VARCHAR](25),
		[txtYTM_IRC][VARCHAR](30),
		[txtLDR][VARCHAR](30),
		[txtFlag][CHAR](1),
		[txtSPQ][VARCHAR](10),
		[txtFIQ][VARCHAR](10),
		[txtDPQ][VARCHAR](10),
		[txtHRQ][VARCHAR](10)
		PRIMARY KEY CLUSTERED (
			txtbeginhour, txtTV, txtEmisora, txtSerie, txtOperation, txtRate, txtAmount, txtEndHour
			)
	)

	-- Carga informacion de Operaciones de Brokers
	INSERT @tmp_itblmarketpositionsprivates (dteDate,intIdBroker,intLine,intPlazo,txtTv,txtEmisora,txtSerie,
												txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)
	SELECT 
		dteDate,
		intIdBroker,
		intLine,
		intPlazo,
		txtTv,
		txtEmisora,
		txtSerie,
		txtOperation,
		dblRate,
		dblAmount,
		dteBeginHour,
		dteEndHour,
		txtLiquidation
	FROM itblmarketpositionsprivates (NOLOCK)
	WHERE
		dteDate = @txtDate


	-- Cargo Info en tabla consolidada
	INSERT @tmp_tblResults (
								txtSortbeginhour, txtId1, dtedate, txtTv, txtEmisora, txtSerie, txtDTM, 
								txtOperation, txtamount, txtRate, txtBaseCotizacion, txtbeginhour, 
								txtendhour, txtLiquidation, txtFlag)
	SELECT 
			mpp.dteBeginHour,i.txtId1,mpp.dteDate,mpp.txtTv,mpp.txtEmisora,mpp.txtSerie,LTRIM(STR(intPlazo)),
			txtOperation,LTRIM(STR(dblAmount)),LTRIM(STR(ROUND(dblRate,6),19,6)),
			'',
			SUBSTRING(CONVERT(CHAR(30),dteBeginHour,131),12,8) + ' ' + SUBSTRING(CONVERT(CHAR(30),dteBeginHour,131),24,1) + '.' + SUBSTRING(CONVERT(CHAR(30),dteBeginHour,131),25,1) + '.',
			SUBSTRING(CONVERT(CHAR(30),dteEndHour,131),12,8) + ' ' + SUBSTRING(CONVERT(CHAR(30),dteEndHour,131),24,1) + '.' + SUBSTRING(CONVERT(CHAR(30),dteEndHour,131),25,1) + '.',txtLiquidation, @txtFlag
	FROM @tmp_itblmarketpositionsprivates AS mpp
		INNER JOIN dbo.tblIds AS i (NOLOCK)
				ON mpp.txtTv = i.txtTv
					AND mpp.txtEmisora = i.txtEmisora
					AND mpp.txtSerie = i.txtSerie

	UPDATE tmp
	SET txtBaseCotizacion = (CASE WHEN (CAST(tmp.txtRate AS FLOAT) > 40) 
								THEN 'Precio' -- tasas muy altas para ser ytm o ldr
								ELSE
									 CASE u.intFixFloat
										 WHEN 0 THEN 'Spread'
										 WHEN 1 THEN 'YTM'
									 END
								END)
	FROM @tmp_tblResults AS tmp
              INNER JOIN dbo.tblBonds AS u -- fun_blender_uni_prv(@txtDate1, 0) AS u  -- 
	              ON tmp.txtId1 = u.txtId1         

	IF @txtFlag = '1'
	BEGIN 

		-- Cargo información de SobreTasas
		INSERT @tblPricesLDR (txtId1, dblLDR)
		SELECT 
				txtId1,dblValue
		FROM dbo.tblPrices (NOLOCK)
		WHERE 
			dteDate = @txtDate
			AND txtLiquidation = 'MD'
			AND txtItem = 'LDR'

		UPDATE tmp
		SET txtLDR = LTRIM(STR(ROUND(p.dblLDR,6),19,6))
		FROM @tmp_tblResults AS tmp
			INNER JOIN @tblPricesLDR AS p
				ON p.txtId1 = tmp.txtId1
		

		-- Cargo información de Analiticos
		INSERT @tmp_tblActualAnalytics_1 (txtId1, txtCTY, txtSPQ, txtFIQ, txtDPQ, txtDCR)
		SELECT 
				txtId1,
				SUBSTRING(RTRIM(txtCTY),1,13),
				SUBSTRING(RTRIM(txtSPQ),1,10),
				SUBSTRING(RTRIM(txtFIQ),1,10),
				SUBSTRING(RTRIM(txtDPQ),1,10),
				SUBSTRING(RTRIM(txtDCR),1,25)
		FROM dbo.tmp_tblActualAnalytics_1 (NOLOCK)
		WHERE 
			txtLiquidation = 'MD'

		UPDATE tmp
		SET tmp.txtCTY =  a.txtCTY, 
			tmp.txtSPQ =  a.txtSPQ, 
			tmp.txtFIQ =  a.txtFIQ, 
			tmp.txtDPQ =  a.txtDPQ, 
			tmp.txtDCR =  a.txtDCR
		FROM @tmp_tblResults AS tmp
			INNER JOIN @tmp_tblActualAnalytics_1 AS a
				ON a.txtId1 = tmp.txtId1
 
		INSERT @tmp_tblActualAnalytics_2 (txtId1, txtHRQ)
		SELECT 
				txtId1,
				SUBSTRING(RTRIM(txtHRQ),1,10)
		FROM tmp_tblActualAnalytics_2 (NOLOCK)
		WHERE 
			txtLiquidation = 'MD'

		UPDATE tmp
		SET tmp.txtHRQ =  a.txtHRQ
		FROM @tmp_tblResults AS tmp
			INNER JOIN @tmp_tblActualAnalytics_2 AS a
				ON a.txtId1 = tmp.txtId1

		-- Cargo información de los keys de los REFs
		INSERT @tmp_tblBondsAddREFs 
		SELECT tadd.txtId1,MAX(tadd.txtItem),MAX(tadd.dteDate),MAX(''),MAX('')
		FROM @tmp_tblResults AS tac
			INNER JOIN MxFixIncome.dbo.tblBondsAdd tadd (NOLOCK)
				ON tac.txtId1 = tadd.txtId1
					AND tadd.txtItem IN ('REF_PRICES','REF_IRC')
					AND tadd.txtValue <> '0'
		GROUP BY tadd.txtId1

		-- Obtengo las Referencias (REF_PRICES, REF_IRC)
		UPDATE tkc
			SET tkc.txtIRC = RTRIM(i.txtValue)
		FROM 
			@tmp_tblResults AS tac
			INNER JOIN @tmp_tblBondsAddREFs AS tkc
				ON tac.txtId1 = tkc.txtId1
			INNER JOIN MxFixIncome.dbo.tblBondsAdd AS i (NOLOCK) 
				ON i.txtId1 = tkc.txtId1
					AND i.dteDate = tkc.dteDate
					AND i.txtItem = tkc.txtItem

		-- Reemplazo referencias ('W091','W182','W028') por ('G091','G182','G028')
		UPDATE tkc 	
				SET txtIRC = REPLACE(tkc.txtIRC,'W','G')
		FROM 
			@tmp_tblBondsAddREFs AS tkc
		WHERE 
				tkc.txtItem IN ('REF_IRC')
				AND tkc.txtIRC IN ('W091','W182','W028')

		-- Obtengo los valores de las Referencias (REF_IRC)
		UPDATE tkc 	
			SET txtValor = LTRIM(STR(ROUND(irc.dblValue,6),16,6)) 
		FROM 
			@tmp_tblBondsAddREFs AS tkc
				INNER JOIN MxFixIncome.dbo.tblIRC AS irc (NOLOCK)
					ON tkc.txtIRC = irc.txtIRC 
		WHERE 
				irc.dteDate = @txtDate 
				AND tkc.txtItem = 'REF_IRC'

		-- Obtengo los valores de las Referencias (REF_PRICES)
		UPDATE tkc 	
			SET txtValor = LTRIM(STR(ROUND(p.dblValue,6),16,6))
		FROM 
			@tmp_tblBondsAddREFs AS tkc
				INNER JOIN MxFixIncome.dbo.tblPrices AS p (NOLOCK)
					ON tkc.txtIRC = p.txtId1 
				INNER JOIN MxFixIncome.dbo.tblIds AS i (NOLOCK)
					ON i.txtId1 = p.txtId1 
		WHERE 
				p.dteDate = @txtDate 
				AND p.txtLiquidation = 'MD'
				AND p.txtItem = 'YTM'
				AND tkc.txtItem = 'REF_PRICES'

		-- Consolido los valores de las Tasas de Referencias
		UPDATE tmp
		SET txtYTM_IRC = p.txtValor
		FROM @tmp_tblResults AS tmp
			INNER JOIN @tmp_tblBondsAddREFs AS p
				ON p.txtId1 = tmp.txtId1

	END

	-- Valida que la información este completa
	IF ((SELECT count(*) FROM @tmp_tblResults) <= 0)

		BEGIN
			RAISERROR ('ERROR: Falta Informacion', 16, 1)
		END

	ELSE

			-- Reporto Información
			SELECT 
				CONVERT(CHAR(10),dteDate,103) AS [Fecha],
				RTRIM(txtTv) AS [Tv],
				RTRIM(txtEmisora) AS [Emisora],
				RTRIM(txtSerie) AS [Serie],
				RTRIM(txtDTM) AS [Plazo],
				RTRIM(txtCTY) AS [Tipo de Tasa],
				RTRIM(txtOperation) AS [Operacion],
				RTRIM(txtAmount) AS [Monto],
				RTRIM(txtRate) AS [Tasa],
				RTRIM(txtBaseCotizacion) AS [Base de Cotizacion],
				RTRIM(txtbeginhour) AS [Hora Inicio],
				RTRIM(txtendhour) AS [Hora Fin],
				RTRIM(txtLiquidation) AS [Liquidacion],
				RTRIM(txtDCR) AS [Referencia],
				RTRIM(txtYTM_IRC) AS [Tasa Referencia],
				RTRIM(txtLDR) AS [Spread Final],
				RTRIM(txtFlag) AS [Flag de Envio],
				RTRIM(txtSPQ) AS [Calificacion S&P],
				RTRIM(txtFIQ) AS [Calificacion Fitch],
				RTRIM(txtDPQ) AS [Calificacion Moodys],
				RTRIM(txtHRQ) AS [Calificacion HR Ratings]
			FROM @tmp_tblResults
			ORDER BY txtSortbeginhour

	SET NOCOUNT OFF 

END
RETURN 0

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];2    Script Date: 10/27/2014 14:10:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Autor:		Mike Ramírez
-- Descripcion:		Procedimiento que genera el producto Reporte_Diario[YYYYMMDD].xls
-- Fecha Creacion  :	13:27 p.m.	2011-07-15
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];2
 	@txtDate AS VARCHAR(10)

AS 
BEGIN

	SET NOCOUNT ON 

	DECLARE @txtFechaFn AS VARCHAR(10)

	SET @txtFechaFn = @txtDate
	
	-- Declaro tabla de resultados
	DECLARE @tblVector TABLE (
		[txtId1][VARCHAR](11),
		[txtTv][VARCHAR](4),
		[txtEmisora][VARCHAR](7),
		[txtSerie][VARCHAR](6),
		[txtDesc][VARCHAR](5),
		[dteBeg][CHAR](8),
		[dteMaturity][CHAR](8),
		[dblPlazo][FLOAT],
		[dblVNA][FLOAT]
	)

	/* INFORMACION DE NUEVO CUPON*/
	INSERT @tblVector 
	SELECT 
		a.txtId1,
		a.txtTV AS TV,
		a.txtEmisora AS EMISORA, 
		a.txtSerie AS SERIE, 
		CONVERT(VARCHAR,b.intCupId) AS 'DESCR(CUPON)',
		CONVERT(CHAR(8),b.dteBeg,112) AS 'FECHA_INICIO',
		CONVERT(CHAR(8),b.dteEnd,112) AS 'FECHA_VENC',
		CONVERT(DECIMAL(10),c.dteMaturity - b.dteBeg) AS PLAZO,
		STR(c.dblFaceValue,18,6) AS [VNA/TA(AMORT)]
	FROM MxFixincome.dbo.tblIds AS a (NOLOCK)
		INNER JOIN MxFixincome.dbo.tblBondsCupCalendar AS b (NOLOCK)
		ON 	a.txtId1 = b.txtId1
		INNER JOIN MxFixincome.dbo.tblBonds AS c (NOLOCK)
		ON a.txtId1 = c.txtId1
		LEFT OUTER JOIN MxFixincome.dbo.tblDailyAnalytics AS ANA1 (NOLOCK)
		ON a.txtId1 = ANA1.txtId1
		AND ANA1.txtItem = 'DTC'
		AND ANA1.txtLiquidation = 'MD'
	WHERE b.dteBeg >= @txtDate
		AND	b.dteBeg <= @txtFechaFn
		AND	a.txtTV NOT IN ('G')
		AND a.txtTV NOT LIKE ('%SP')
		AND a.txtEmisora NOT IN ('HCA','FCA')
		AND c.dteMaturity - b.dteBeg > 0

	/*INFORMACION DE NACIMIENTOS DE PAPELES*/
	INSERT @tblVector 
	SELECT 
		a.txtId1,
		a.txtTV, 
		a.txtEmisora, 
		a.txtSerie, 
		'Venc',
		CONVERT(CHAR(8),b.dteIssued,112) AS FECHA_INICIO,
		CONVERT(CHAR(8),b.dteMaturity,112) AS FVento,
		'0', /*Este es el plazo*/
		STR(b.dblFaceValue,18,6)
	FROM MxFixincome.dbo.tblIds AS a (NOLOCK)
		INNER JOIN MxFixincome.dbo.tblBonds AS b (NOLOCK)
		ON 	a.txtId1 = b.txtId1
		LEFT OUTER JOIN MxFixincome.dbo.tblDailyAnalytics AS ANA1 (NOLOCK)
		ON a.txtId1 = ANA1.txtId1
		AND ANA1.txtItem = 'DTC'
		AND ANA1.txtLiquidation = 'MD'
	WHERE	b.dteMaturity >= @txtDate
		AND	b.dteMaturity <= @txtFechaFn
		AND	a.txtTV NOT IN ('G')
		AND a.txtTV NOT LIKE ('%SP')
		AND a.txtEmisora NOT IN ('HCA','FCA')

	/* INFORMACION DE AMORTIZACIONES*/
	INSERT @tblVector 
	SELECT 
		a.txtId1,
		a.txtTV, 
		a.txtEmisora, 
		a.txtSerie, 
		'Amort',
		CONVERT(CHAR(8),b.dteAmortization,112) AS FInicioCup,
		CONVERT(CHAR(8),b.dteAmortization,112) AS FVentoCup,
		CONVERT(DECIMAL(10),c.dteMaturity - b.dteAmortization) AS Plazo,
		STR(b.dblFactor,18,6)
	FROM MxFixincome.dbo.tblIds AS a (NOLOCK)
		INNER JOIN MxFixincome.dbo.tblAmortizations AS b (NOLOCK)
	ON 	a.txtId1 = b.txtId1
		INNER JOIN MxFixincome.dbo.tblBonds AS c (NOLOCK)
		ON a.txtId1 = c.txtId1
		LEFT OUTER JOIN MxFixincome.dbo.tblDailyAnalytics AS ANA1 (NOLOCK)
		ON a.txtId1 = ANA1.txtId1
		AND ANA1.txtItem = 'DTC'
		AND ANA1.txtLiquidation = 'MD'
	WHERE b.dteAmortization >= @txtDate
		AND	b.dteAmortization <= @txtFechaFn
		AND	a.txtTV NOT IN ('G')
		AND a.txtTV NOT LIKE ('%SP')
		AND a.txtEmisora NOT IN ('HCA','FCA')
		AND c.dteMaturity - b.dteAmortization > 0
	 
		SELECT 	
			txtTv,
			txtEmisora,
			txtSerie,
			txtDesc,
			dteBeg,
			dteMaturity,
			dblPlazo,
			dblVNA
		FROM @tblVector
		WHERE txtId1 NOT IN (
							SELECT DISTINCT i.txtId1
							FROM
								tblIds AS i (NOLOCK)
								INNER JOIN tblPricesSN AS p (NOLOCK)
								ON i.txtId1 = p.txtId1
 							WHERE
								p.dteDate = @txtDate)
		ORDER BY txtDesc,dteBeg,txtTv,txtEmisora,txtSerie ASC 

	SET NOCOUNT OFF

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];3    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Autor:		Mike Ramírez
-- Descripcion:		Procedimiento que genera el producto Reporte_Semanal[YYYYMMDD].xls
-- Fecha Creacion  :	10:35 p.m.	2011-07-27
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];3
 	@txtDate AS VARCHAR(10)

AS 
BEGIN

	SET NOCOUNT ON 

	DECLARE @IntDHabil AS INT
	DECLARE @intIsLunes AS INT
	DECLARE @fFlag AS INT
	DECLARE @txtFechaIn AS VARCHAR(10)
	DECLARE @txtFechaFn AS VARCHAR(10)

	-- Declaro tabla de resultados
	DECLARE @tblVector TABLE (
		[txtId1][VARCHAR](11),
		[txtTv][VARCHAR](4),
		[txtEmisora][VARCHAR](7),
		[txtSerie][VARCHAR](6),
		[txtDesc][VARCHAR](5),
		[dteBeg][CHAR](8),
		[dteMaturity][CHAR](8),
		[dblPlazo][FLOAT],
		[dblVNA][FLOAT]
	)

	SET @IntDHabil = dbo.fun_IsTradingDate(@txtDate,'MX')
	SET @intIsLunes = dbo.fun_IsTradingDate(dbo.fun_NextTradingDate (@txtDate,-1,'MX'),'MX')
		 
	IF DATEPART(dw,@txtDate) = 2 or DATEPART(dw,@txtDate) = 3
	BEGIN
		   IF DATEPART(dw,@txtDate) = 2 AND @IntDHabil = 1
		   BEGIN
	 			SET @fFlag = 1
		   END
				   IF DATEPART(dw,@txtDate) = 3 AND @IntDHabil = 1 AND @intIsLunes = 0
				   BEGIN
						SET @fFlag = 1
				   END
					   IF DATEPART(dw,@txtDate) = 3 AND @IntDHabil = 1 AND @intIsLunes = 1
		
			   BEGIN
							SET @fFlag = 0
					   END
						   IF @fFlag = 0
						   BEGIN
									RAISERROR ('ERROR: Generacion del Producto no calendarizada', 16, 1)
						   END
						   ELSE
								BEGIN	
									SET @txtFechaIn = @txtDate
									SET @txtFechaFn = CONVERT(CHAR(8),dbo.fun_NextTradingDate (@txtDate,+5,'MX'),112) 
									
									/* INFORMACION DE NUEVO CUPON*/
									INSERT @tblVector 
									SELECT 
										a.txtId1,
										a.txtTV AS TV,
										a.txtEmisora AS EMISORA, 
	
									a.txtSerie AS SERIE, 
										CONVERT(VARCHAR,b.intCupId) AS 'DESCR(CUPON)',
										CONVERT(CHAR(8),b.dteBeg,112) AS 'FECHA_INICIO',
										CONVERT(CHAR(8),b.dteEnd,112) AS 'FECHA_VENC',
										CONVERT(DECIMAL(10),c.dteMaturity - b.dteBeg) AS PLAZO,
										STR(c.dblFaceValue,18,6) AS [VNA/TA(AMORT)]
									FROM MxFixincome.dbo.tblIds AS a (NOLOCK)
										INNER JOIN MxFixincome.dbo.tblBondsCupCalendar AS b (NOLOCK)
										ON a.txtId1 = b.txtId1
										INNER JOIN MxFixincome.dbo.tblBonds AS c (NOLOCK)
										ON a.txtId1 = c.txtId1
										LEFT OUTER JOIN MxFixincome.dbo.tblDailyAnalytics AS ANA1 (NOLOCK)
										ON a.txtId1 = ANA1.txtId1
										AND ANA1.txtItem = 'DTC'
										AND ANA1.txtLiquidation = 'MD'
				
					WHERE b.dteBeg >= @txtFechaIn
										AND	b.dteBeg <= @txtFechaFn
										AND	a.txtTV NOT IN ('G')
										AND a.txtTV NOT LIKE ('%SP')
										AND a.txtEmisora NOT IN ('HCA','FCA')
										AND c.dteMaturity - b.dteBeg > 0

									/*INFORMACION DE NACIMIENTOS DE PAPELES*/
									INSERT @tblVector 
									SELECT 
										a.txtId1,
										a.txtTV, 
										a.txtEmisora, 
										a.txtSerie, 
										'Venc',
										CONVERT(CHAR(8),b.dteIssued,112) AS FECHA_INICIO,
									
									CONVERT(CHAR(8),b.dteMaturity,112) AS FVento,
										'0', /*Este es el plazo*/
										STR(b.dblFaceValue,18,6)
									FROM MxFixincome.dbo.tblIds AS a (NOLOCK)
										INNER JOIN MxFixincome.dbo.tblBonds AS b (NOLOCK)
										ON a.txtId1 = b.txtId1
										LEFT OUTER JOIN MxFixincome.dbo.tblDailyAnalytics AS ANA1 (NOLOCK)
										ON a.txtId1 = ANA1.txtId1
										AND ANA1.txtItem = 'DTC'
										AND ANA1.txtLiquidation = 'MD'
									WHERE b.dteMaturity >= @txtFechaIn
										AND	b.dteMaturity <= @txtFechaFn
										AND	a.txtTV NOT IN ('G')
										AND a.txtTV NOT LIKE ('%SP')
										AND a.txtEmisora NOT IN ('HCA','FCA')

									/* INFORMACION DE AMORTIZACIONES*/
									INSERT @tblVector 
									SELECT 
										a.txtId1,
										a.txtTV, 
										a.txtEmisora, 
										a.txtSerie, 
										'Amort',
										CONVERT(CHAR(8),b.dteAmortization,112) AS FInicioCup,
										CONVERT(CHAR(8),b.dteAmortization,112) AS FVentoCup,
										CONVERT(DECIMAL(10),c.dteMaturity - b.dteAmortization) AS Plazo,
										STR(b.dblFactor,18,6)
									FROM MxFixincome.dbo.tblIds AS a (NOLOCK)
										INNER JOIN MxFixincome.dbo.tblAmortizations AS b (NOLOCK)
									ON 	a.txtId1 = b.txtId1
										INNER JOIN MxFixincome.dbo.tblBonds AS c (NOLOCK)
										ON a.txtId1 = c.txtId1
										LEFT OUTER JOIN MxFixincome.dbo.tblDailyAnalytics AS ANA1 (NOLOCK)
										ON a.txtId1 = ANA1.txtId1
										AND ANA1.txtItem = 'DTC'
										AND ANA1.txtLiquidation = 'MD'
					
				WHERE b.dteAmortization >= @txtFechaIn
										AND	b.dteAmortization <= @txtFechaFn
										AND	a.txtTV NOT IN ('G')
										AND a.txtTV NOT LIKE ('%SP')
										AND a.txtEmisora NOT IN ('HCA','FCA')
										AND c.dteMaturity - b.dteAmortization > 0
									 
										SELECT 	
											txtTv,
											txtEmisora,
											txtSerie,
											txtDesc,
											dteBeg,
											dteMaturity,
											dblPlazo,
											dblVNA
										FROM @tblVector
										WHERE txtId1 NOT IN (
															SELECT DISTINCT i.txtId1
															FROM
																tblIds AS i (NOLOCK)
																INNER JOIN tblPricesSN AS p (NOLOCK)
																ON i.txtId1 = p.txtId1
 															WHERE
																p.dteDate = @txtDate)
										ORDER BY txtDesc,dteBeg,txtTv,txtEmisora,txtSerie ASC 
								END	
	END 
	ELSE
		RAISERROR ('ERROR: Generacion del Producto no calendarizada', 16, 1)

SET NOCOUNT OFF 

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];4    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Autor: Mike Ramirez
-- Creacion: 10:48 a.m. 2011-10-25
-- Descripcion: Modulo 4: Genera producto VectordeOperacionesGuber[yyyymmdd].xls
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];4
  @txtDate AS DATETIME  
  
AS     
BEGIN    
  
 SET NOCOUNT ON 

	-- Tabla temporal para cargar el universo
	DECLARE @tmp_tblVector TABLE (
		dteDate DATETIME,
		txtTv VARCHAR(10),
		txtEmisora VARCHAR(10),
		txtSerie VARCHAR(10),
		intPlazo INT,
		txtOperation VARCHAR(10),
		dblRate FLOAT,
		dblAmount FLOAT,
		dteBeginHour DATETIME,
		dteEndHour DATETIME,
		txtLiquidation CHAR(3) )

	-- Carga de Informacion Universo
	INSERT @tmp_tblVector (dteDate,txtTv,txtEmisora,txtSerie,intPlazo,txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)
	SELECT 
		m.dtedate,
		u.txttv,
		u.txtemisora,
		u.txtserie,
		m.intPlazo,
		CASE WHEN m.txtOperation IN ('HECHO_C','HECHO_V') THEN 'HECHO' ELSE m.txtOperation END,
		m.dblRate,
		m.dblAmount,
		m.dteBeginHour,
		m.dteEndHour,
		m.txtLiquidation
	FROM MxFixincome.dbo.itblMarketPositions AS m (NOLOCK)
		INNER JOIN MxFixincome.dbo.tmp_tblUnifiedPricesReport AS u (NOLOCK)
			ON m.intplazo = u.dblDTM
			AND m.txttv = u.txttv
	WHERE u.txtliquidation = 'MD'
			AND m.dtedate = @txtDate

	-- Valida la información 
	IF ((SELECT count(*) FROM @tmp_tblVector) <= 1)

		BEGIN
			RAISERROR ('ERROR: Falta Informacion', 16, 1)
		END

	ELSE
		-- Reporto Informacion
		SELECT
			convert(varchar(10),dteDate,103),
			txttv,
			txtemisora,
			txtserie,
			intPlazo,
			txtOperation,
			dblRate,
			dblAmount,
			dteBeginHour,
			dteEndHour,
			txtLiquidation
		FROM @tmp_tblVector
		ORDER BY txttv,txtemisora,txtserie

	SET NOCOUNT OFF 

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];5    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--   Modificado por: Mike Ramírez  
--   Modificacion:  10:00 a.m. 2011-12-06  
--   Descripcion: Se modifico el calculo para el calendario 30/360A y ACT/ACT
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];5
 	@txtDate AS VARCHAR(10)

AS 
BEGIN

	SET NOCOUNT ON

	DECLARE @IntDHabil AS INT
	DECLARE @txtFechaFn AS VARCHAR(10)
	DECLARE @txtFechaIn AS VARCHAR(10)
	DECLARE @fFlag AS INT
	DECLARE @IntDays AS INT

	-- Declaro tabla de resultados
	DECLARE @tblVector TABLE (
		[txtId1][VARCHAR](11),
		[dteDate][VARCHAR](10),
		[txtTv][VARCHAR](4),
		[txtEmisora][VARCHAR](7),
		[txtSerie][VARCHAR](6),
		[dblCPA][FLOAT],
		[txtId2][VARCHAR](12),
		[dteDateTm1][VARCHAR](10),
		[dteDateFPgo][VARCHAR](10),
		[intCupId][INT],
		[txtMTD][VARCHAR](10),
		[dteBeg][VARCHAR](10),
		[dteEnd][VARCHAR](10),
		[txtVNA][VARCHAR](50),
		[dblCPD][FLOAT],
		[dblYTM][FLOAT],
		[txtPlzPeriodo][VARCHAR](50),
		[txtCUR][VARCHAR](50),
		[dblPRL][FLOAT],
		[dblPRS][FLOAT],
		[txtFactor][VARCHAR](50),
		[txtCURm][CHAR](3),
		[txtCalendar][VARCHAR](50)
		PRIMARY KEY (txtId1) )

	SET @IntDHabil = dbo.fun_IsTradingDate(@txtDate,'MX')

	SET @IntDays = (CASE WHEN ISDATE(LTRIM(STR(YEAR(@txtDate)))+'0229')= 1 THEN 366 ELSE 365 END) 

	IF DATEPART(dw,@txtDate) = 2 or DATEPART(dw,@txtDate) = 3 or DATEPART(dw,@txtDate) = 4 or DATEPART(dw,@txtDate) = 5 or DATEPART(dw,@txtDate) = 6
	BEGIN
		   IF @IntDHabil = 1
		   BEGIN
	 			SET @fFlag = 1
		   END
				   IF @IntDHabil = 0
				   BEGIN
						SET @fFlag = 0
				   END
					    IF @fFlag = 0
					    BEGIN
								RAISERROR ('ERROR: Generacion del Producto no calendarizada', 16, 1)
					    END
						    ELSE
								BEGIN	
									SET @txtFechaIn = @txtDate
									SET @txtFechaFn = CONVERT(CHAR(8),dbo.fun_NextTradingDate (@txtDate,1,'MX'),112) 

								INSERT @tblVector (txtId1,dteDate,txtTv,txtEmisora,txtSerie,dblCPA,txtId2,dteDateTm1,dteDateFPgo,intCupId,txtMTD,dteBeg,dteEnd,txtVNA,dblCPD,dblYTM,txtPlzPeriodo,txtCUR,dblPRL,dblPRS,txtFactor,txtCURm,txtCalendar)
									SELECT 
										i.txtid1,
										CONVERT(CHAR(10),p.dtedate,103),
										i.txttv,
										i.txtemisora,
										i.txtserie,
										t.dblCPA,
										t.txtid2,
										CONVERT(CHAR(10),p.dtedate-1,103),
										CONVERT(CHAR(10),p.dtedate,103),
										bc.intCupId,
										CASE WHEN t.txtMTD = 'NA' OR t.txtMTD = '-' THEN '' ELSE CONVERT(CHAR(10),CAST(t.txtMTD AS DATETIME),103) END,
										CONVERT(CHAR(10),bc.dteBeg,103),
										CONVERT(CHAR(10),bc.dteEnd,103),
										t.txtVNA,
										t.dblCPD,
										t.dblYTM,

										CASE 
											WHEN b.txtCalendar IN ('30/360','30/360A') THEN dbo.fun_get_RoundMultiplo ((ABS(DATEDIFF(DAY,bc.dteEnd,bc.dteBeg))),30) --ROUND((bc.dteEnd - bc.dteBeg),-1)
											WHEN b.txtCalendar IN ('ACT/360','ACT/365','ACT/ACT') THEN ABS(DATEDIFF(DAY,bc.dteEnd,bc.dteBeg))
										ELSE '' END AS [txtPlzPeriodo],

										t.txtCUR,
										t.dblPRL,
										t.dblPRS,

										CASE
											WHEN b.txtCalendar LIKE '%-999%' THEN '0'
											WHEN b.txtCalendar = '0' THEN '0'
											WHEN b.txtCalendar = '30/360' THEN dbo.fun_get_RoundMultiplo ((ABS(DATEDIFF(DAY,bc.dteEnd,bc.dteBeg))),30)/CAST(360 AS FLOAT)
											WHEN b.txtCalendar = '30/360A' THEN dbo.fun_get_RoundMultiplo ((ABS(DATEDIFF(DAY,bc.dteEnd,bc.dteBeg))),30)/CAST(@IntDays AS FLOAT)
											WHEN b.txtCalendar = 'ACT/360' THEN ABS(DATEDIFF(DAY,bc.dteEnd,bc.dteBeg))/CAST(360 AS FLOAT)
											WHEN b.txtCalendar = 'ACT/365' THEN ABS(DATEDIFF(DAY,bc.dteEnd,bc.dteBeg))/CAST(365 AS FLOAT)
											WHEN  b.txtCalendar = 'ACT/ACT' THEN ABS(DATEDIFF(DAY,bc.dteEnd,bc.dteBeg))/CAST(@IntDays AS FLOAT)
										ELSE '0' END AS [txtFactor], 
										SUBSTRING(t.txtCUR,2,3),
										b.txtCalendar
									FROM MxFixincome.dbo.tblBondsCupCalendar AS bc (NOLOCK)
										INNER JOIN MxFixincome.dbo.tblids AS i (NOLOCK)
										ON i.txtid1 = bc.txtid1
										INNER JOIN MxFixincome.dbo.tblPrices AS p (NOLOCK)
										ON i.txtid1 = p.txtid1
										INNER JOIN MxFixincome.dbo.tblbonds AS b (NOLOCK)
										ON i.txtid1 = b.txtid1
										INNER JOIN MxFixincome.dbo.tmp_tblUnifiedPricesReport AS t (NOLOCK)
										ON i.txtid1 = t.txtid1
									WHERE bc.dteEnd BETWEEN (SELECT 
																	CASE WHEN DATEPART(dw,@txtDate) IN (2,3,4,5,6) THEN CONVERT(VARCHAR(10),CAST(@txtDate AS DATETIME)+1,112)
																	ELSE @txtFechaFn END) 
									AND @txtFechaFn
									AND p.txtitem = 'CPA'
									AND p.txtliquidation = 'MD'
									AND p.dtedate= @txtFechaIn
									AND t.txtliquidation = 'MD'
									ORDER BY 
										i.txttv,
										i.txtemisora,
										i.txtserie
								END
	END 
	ELSE
		RAISERROR ('ERROR: Generacion del Producto no calendarizada', 16, 1)

		SELECT
				dteDate,
				txtTv,
				txtEmisora,
				txtSerie,
				dblCPA,
				txtId2,
				dteDateTm1,
				dteDateFPgo,
				intCupId,
				txtMTD,
				dteBeg,
				dteEnd,
				txtVNA,
				dblCPD,
				dblYTM,
				txtPlzPeriodo,
				txtCUR,
				dblPRL,
				dblPRS,
				CAST(txtVNA AS FLOAT) * CAST(txtFactor AS FLOAT) * (dblCPA/100) AS [Factor],
				CASE 
					WHEN CAST(txtVNA AS FLOAT) <= 0 THEN ''
				ELSE RTRIM(CAST(txtVNA AS FLOAT) * (txtFactor) * (dblCPA/100)) * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),txtCURm)) END,
				txtCalendar,
				CASE 
					WHEN RTRIM(CAST(MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),txtCURm) AS VARCHAR(400))) = '1' THEN '' 
				ELSE RTRIM(CAST(MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),txtCURm) AS VARCHAR(400))) END
		FROM @tblVector
		ORDER BY txtTv,
				txtEmisora,
				txtSerie

	SET NOCOUNT OFF 

END
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];6    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ---------------------------------------------------------------------------
--  Autor:			Mike Ramírez
--  Fecha Creacion:	10:58 a.m.	2011-12-09
--  Descripcion:	Procedimiento que genera el Vector con Notas Estructuradas
--  Modificado por:	JATO
--  Modificacion:	03:43 p.m. 2011-12-15	
--  Descripcion:    optimizaciones menores
-- ---------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];6
 	@txtDate AS DATETIME,
	@txtLiquidation AS VARCHAR(3),
	@txtOwner AS VARCHAR(5)

AS 
BEGIN

	SET NOCOUNT ON

	DECLARE @tblVector TABLE (
		[dtedate][VARCHAR](10),
		[txtTv][CHAR](4),
		[txtEmisora][CHAR](7),
		[txtSerie][CHAR](6),
		[txtLiquidation][CHAR](3),
		[dblPRL][VARCHAR](30),
		[dblPRS][VARCHAR](30),
		[dblCPD][VARCHAR](30),
		PRIMARY KEY CLUSTERED (
			txtTV,txtEmisora,txtSerie
			)
	)

	-- Info: Notas Estructuradas
	INSERT @tblVector (dtedate,txtTv,txtEmisora,txtSerie,txtLiquidation,dblPRL,dblPRS,dblCPD)
		SELECT 
				CONVERT(VARCHAR(10),i.dtedate,112) AS [dtedate],
				i.txtTv AS [txtTv], 
				i.txtEmisora AS [txtEmisora],
				i.txtSerie AS [txtSerie],
				i.txtLiquidation AS [txtLiquidation],
				LTRIM(STR(i.dblPRL,16,6)) AS [dblPRL],
				LTRIM(STR(i.dblPRS,16,6)) AS [dblPRS],
				LTRIM(STR(i.dblCPD,16,6)) AS [dblCPD]
		FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS i (NOLOCK)
			INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS p (NOLOCK)
				ON i.txtId1 = p.txtDir  
		WHERE i.txtLiquidation IN (@txtLiquidation,'MP')   
			 AND i.dtedate = @txtDate
			 AND p.txtOwnerId = @txtOwner  
			 AND p.txtProductid = 'SNOTES'
		ORDER BY 
				i.txtTV, 
				i.txtEmisora, 
				i.txtSerie  

	-- Valida la información 
	IF EXISTS(
		SELECT TOP 1 dteDate
		FROM @tblVector
	)
		SELECT 
			[dtedate],
			[txtTv],
			[txtEmisora],
			[txtSerie],
			[txtLiquidation],
			[dblPRL],
			[dblPRS],
			[dblCPD]
		FROM @tblVector
		ORDER BY txtTV, txtEmisora, txtSerie

	ELSE
			RAISERROR ('ERROR: Falta Informacion', 16, 1)


	SET NOCOUNT OFF 

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];7    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ---------------------------------------------------------------------------
--  Modifico:       	Mike Ramírez
--  Creacion:		04:41 p.m.	2012-01-23
--  Descripcion: Modulo:7   Incluir 6 Nuevos Índices (EWH,EWJ,EWZ,NDX,SPX,EWA)
-- ---------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];7
  @txtDate AS DATETIME    
    
AS       
BEGIN       

 SET NOCOUNT ON

 -- genera tabla temporal de resultados    
	DECLARE @tblResult TABLE (    
		[intSection][INTEGER],    
		[txtData][VARCHAR](8000)    
	)    
       
	DECLARE @dblMEXBOL AS FLOAT    
	DECLARE @dblDAX AS FLOAT    
	DECLARE @dblINDU AS FLOAT    
	DECLARE @dblUKX AS FLOAT 
	DECLARE @dblEWH AS FLOAT    
	DECLARE @dblEWJ AS FLOAT    
	DECLARE @dblEWZ AS FLOAT    
	DECLARE @dblNDX AS FLOAT 
	DECLARE @dblSPX AS FLOAT    
	DECLARE @dblEWA AS FLOAT     
   
 -- Tasas de Referencia    
	SET @dblMEXBOL = (SELECT dblvalue 
					  FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
					  WHERE txtIrc = 'MEXBOL'
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'MEXBOL'))
	SET @dblDAX = (SELECT dblvalue 
				   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
				   WHERE txtIrc = 'DAX'
							 AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'DAX'))
	SET @dblINDU = (SELECT dblvalue 
					FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
					WHERE txtIrc = 'INDU'
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'INDU'))
	SET @dblUKX = (SELECT dblvalue 
				   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
				   WHERE txtIrc = 'UKX' 
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'UKX'))
	SET @dblEWH = (SELECT dblvalue 
					  FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
					  WHERE txtIrc = 'EWH' 
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'EWH'))
	SET @dblEWJ = (SELECT dblvalue 
				   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
				   WHERE txtIrc = 'EWJ' 
							 AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'EWJ'))
	SET @dblEWZ = (SELECT dblvalue 
					FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
					WHERE txtIrc = 'EWZ' 
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'EWZ'))
	SET @dblNDX = (SELECT dblvalue 
				   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
				   WHERE txtIrc = 'NDX' 
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'NDX'))

	SET @dblSPX = (SELECT dblvalue 
					FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
					WHERE txtIrc = 'SPX' 
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'SPX'))
	SET @dblEWA = (SELECT dblvalue 
				   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
				   WHERE txtIrc = 'EWA' 
							AND dteDate = (SELECT MAX(dtedate)
										   FROM MxFixIncome.dbo.tblIRC (NOLOCK) 
									       WHERE txtIrc = 'EWA'))


 -- Obtengo los valores de los FRPiP    
	INSERT @tblResult  (intSection, txtData)
		SELECT 001,'DAX' + CHAR(9) + LTRIM(@dblDAX)  UNION    
		SELECT 002,'DJX' + CHAR(9) + LTRIM(@dblINDU/100)  UNION    
		SELECT 003,'UKX' + CHAR(9) + LTRIM(@dblUKX)  UNION    
		SELECT 004,'MEXBOL' + CHAR(9) + LTRIM(@dblMEXBOL) UNION
		SELECT 005,'EWH' + CHAR(9) + LTRIM(@dblEWH) UNION
		SELECT 006,'EWJ' + CHAR(9) + LTRIM(@dblEWJ) UNION
		SELECT 007,'EWZ' + CHAR(9) + LTRIM(@dblEWZ) UNION
		SELECT 008,'NDX' + CHAR(9) + LTRIM(@dblNDX) UNION
		SELECT 009,'SPX' + CHAR(9) + LTRIM(@dblSPX) UNION
		SELECT 010,'EWA' + CHAR(9) + LTRIM(@dblEWA)
 
-- Valida que la información este completa   
	IF EXISTS ( 
			SELECT intSection 
			FROM @tblResult 
			WHERE txtData IS NULL
			)
	BEGIN    
		   RAISERROR ('ERROR: Falta Informacion', 16, 1)    
	END     
		ELSE 

 -- Reporto los datos    
		SELECT RTRIM(txtData)    
		FROM @tblResult    
		ORDER BY intSection    
    
 SET NOCOUNT OFF 

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];8    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------------
--  Autor:			Mike Ramirez
--  Creacion:		02:16 p.m. 2012-01-04  
--  Descripcion:	Modulo 8: Para generar producto Impacto_Privados_Indeval.htm
------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];8
	@txtDate AS DATETIME,
	@txtFlag AS CHAR(1)	

AS 
BEGIN

	SET NOCOUNT ON 

		-- creo tabla universo
		DECLARE @tblUniverse TABLE(
			txtId1 CHAR(11)
				  PRIMARY KEY(txtId1))

		-- creo tabla templaral para cargar los tiempos indeval
		DECLARE @tblPricesINVTimes TABLE(
			txtId1 CHAR(11),
			dteTime DATETIME,
			txtItem CHAR(3)
				  PRIMARY KEY (txtId1,txtItem))

		-- creo tabla templaral para consolidar los datos
		DECLARE @tblData TABLE(
			intSection INT,
			dteDate DATETIME,
			dteTime DATETIME,
			txtId1 CHAR(11),
			dblPrice FLOAT,
			dblLDR FLOAT
				  PRIMARY KEY (txtId1))			

		-- creo tabla templaral para reporta los datos
		DECLARE @tblResult TABLE(
			intSection INT,
			txtInstrumento VARCHAR(100),
			txtPrecio VARCHAR(100),
			txtPrecioIndeval VARCHAR(100),
			txtDiferenciaPrecio VARCHAR(100),
			txtOAS VARCHAR(100),
			txtOASIndeval VARCHAR(100),
			txtDiferenciaOAS VARCHAR(100))

		-- creo tabla templaral para reporta los datos definitivos
		DECLARE @tblResultDef TABLE(
			intSection INT,
			txtInstrumento VARCHAR(100),
			txtPrecio VARCHAR(100),
			txtPrecioIndeval VARCHAR(100),
			txtDiferenciaPrecio VARCHAR(100),
			txtOAS VARCHAR(100),
			txtOASIndeval VARCHAR(100),
			txtDiferenciaOAS VARCHAR(100))

		-- Cargo el universo de instrumentos a procesar
		INSERT @tblUniverse(txtId1)
			  SELECT DISTINCT
					txtId1 
			  FROM MxFixincome.inv.itblSyntPositionsPrivates (NOLOCK)
			  WHERE 
					intIdBroker = 11
					AND dteDate = @txtDate
   
		-- Cargo la horas de los definitivos
		INSERT @tblPricesINVTimes(txtId1,dteTime,txtItem)
			SELECT 
				p.txtId1,
				MAX(p.dteDate) AS dteTime,
				p.txtItem
			FROM MxFixincome.dbo.tblPricesINV AS p (NOLOCK)
				INNER JOIN @tblUniverse AS u
					ON p.txtId1 = u.txtId1
			WHERE 
				CONVERT(DATETIME,CONVERT(CHAR(8),p.dteDate,112)) = @txtDate
				AND p.txtLiquidation = 'MD'
			GROUP BY
				p.txtId1,
				p.txtItem
			ORDER BY p.txtid1

IF @txtFlag = 'P'
BEGIN	

	IF  EXISTS (SELECT * FROM DBSQLDump.dbo.tmp_Indeval_Derechos)
	BEGIN

			DROP TABLE DBSQLDump.dbo.tmp_Indeval_Derechos

			--Tabla temporal para cargar informacion previa de Indeval Derechos
			CREATE TABLE DBSQLDump.dbo.tmp_Indeval_Derechos(
						intSection INT,
						txtInstrumento VARCHAR(100),
						txtPrecio VARCHAR(100),
						txtPrecioIndeval VARCHAR(100),
						txtDiferenciaPrecio VARCHAR(100),
						txtOAS VARCHAR(100),
						txtOASIndeval VARCHAR(100),
						txtDiferenciaOAS VARCHAR(100))
	END

			-- Consolido la información para Previo
			INSERT @tblData(intsection,dteDate,dteTime,txtId1,dblPrice,dblLDR)
				SELECT
					04,
					@txtDate,
					CASE
						  WHEN CONVERT(DATETIME,CONVERT(CHAR(8),t.dteTime,108)) < '1900-01-01 18:00:00.00' THEN '1900-01-01 15:00:00.00'
						  ELSE '1900-01-01 18:00:00.00'
					END,  
					u.txtId1,
					p.dblValue,
					pldr.dblValue
				FROM @tblUniverse AS u
				INNER JOIN @tblPricesINVTimes AS t 
				ON
					u.txtId1 = t.txtId1
				INNER JOIN MxFixincome.dbo.tblPricesINV AS p (NOLOCK)
				ON
					p.txtId1 = t.txtId1
					AND p.dteDate = t.dteTime
					AND p.txtItem = t.txtItem
				INNER JOIN @tblPricesINVTimes AS tldr 
				ON
					u.txtId1 = tldr.txtId1
				INNER JOIN MxFixincome.dbo.tblPricesINV AS pldr (NOLOCK)
				ON
					pldr.txtId1 = tldr.txtId1
					AND pldr.dteDate = tldr.dteTime
					AND pldr.txtItem = tldr.txtItem
				WHERE 
					p.txtItem = 'PRS'
					AND pldr.txtItem = 'LDR'
					AND p.txtLiquidation = 'MD'
					AND pldr.txtLiquidation = 'MD'

			-- Reporto los encabezados previos
			INSERT @tblResult (intSection,txtInstrumento,txtPrecio,txtPrecioIndeval,txtDiferenciaPrecio,txtOAS,txtOASIndeval,txtDiferenciaOAS)
				SELECT 01,'','','','','','',REPLACE(CONVERT(CHAR(10),@txtDate,102),'.','-') UNION
				SELECT 02,'','','','Archivo Previo','','','' UNION
				SELECT 03,'Instrumento','Precio Vector','Precio Indeval','Diferencia Precio','Sobretasa','Sobretasa Indeval','Diferencia Sobretasas'
	
			-- Reporto la informacion previa
			INSERT @tblResult (intSection,txtInstrumento,txtPrecio,txtPrecioIndeval,txtDiferenciaPrecio,txtOAS,txtOASIndeval,txtDiferenciaOAS)
				SELECT DISTINCT 
					data.intSection, 
					' (' + RTRIM(LTRIM(IDs.txtTv)) + '_' + RTRIM(LTRIM(IDs.txtEmisora)) + '_' + RTRIM(LTRIM(IDs.txtSerie)) + ')' AS txtInstrumento,
					prcprs.dblValue AS txtPrecio,
					data.dblPrice AS txtPrecioIndeval,
					STR(ABS(((prcprs.dblValue/data.dblPrice)-1)*100),10,4) + '%' AS txtDiferenciaPrecio,
					STR(prcldr.dblValue,10,4) AS txtOAS,
					STR(data.dblldr,10,4) AS txtOASIndeval,
					STR(ABS((prcldr.dblValue-data.dblldr)*100),10,4) AS txtDiferenciaOAS 
				FROM @tblData AS data
					INNER JOIN MxFixincome.dbo.tblIDs AS IDs (NOLOCK)
						ON data.txtID1 = IDs.txtID1
					INNER JOIN MxFixincome.dbo.tblPrices AS prcprs (NOLOCK)
						ON prcprs.txtID1 = data.txtID1
						AND prcprs.dteDate = data.dteDate
						AND prcprs.txtItem = 'PRS'
						AND prcprs.txtLiquidation = 'MD'
					INNER JOIN MxFixincome.dbo.tblPrices AS prcldr (NOLOCK)
						ON prcldr.txtID1 = data.txtID1
						AND prcldr.dteDate = data.dteDate
						AND prcldr.txtItem = 'LDR'
						AND prcldr.txtLiquidation = 'MD'
				WHERE
					data.dteDate = @txtDate

			--Cargo tabla temporal para informacion previa de Indeval Derechos
			INSERT DBSQLDump.dbo.tmp_Indeval_Derechos (intSection,txtInstrumento,txtPrecio,txtPrecioIndeval,txtDiferenciaPrecio,txtOAS,txtOASIndeval,txtDiferenciaOAS)
				SELECT 
					intSection,
					txtInstrumento,
					txtPrecio,
					txtPrecioIndeval,
					txtDiferenciaPrecio,
					txtOAS,
					txtOASIndeval,
					txtDiferenciaOAS 
				FROM @tblResult
				ORDER BY intsection

			--Reporto Informacion	
			SELECT
				txtInstrumento,
				txtPrecio,
				txtPrecioIndeval,
				txtDiferenciaPrecio,
				txtOAS,
				txtOASIndeval,
				txtDiferenciaOAS
			FROM @tblResult

END

	IF @txtFlag = 'D'
	BEGIN

				INSERT @tblResult  (intSection,txtInstrumento,txtPrecio,txtPrecioIndeval,txtDiferenciaPrecio,txtOAS,txtOASIndeval,txtDiferenciaOAS)
					SELECT 05,'','','','','','','' UNION
					SELECT 06,'','','','Archivo Cierre','','','' UNION
					SELECT 07,'Instrumento','Precio Vector','Precio Indeval','Diferencia Precio','Sobretasa','Sobretasa Indeval','Diferencia Sobretasas'


			-- Consolido la información para Definitivo
				INSERT @tblData(intsection,dteDate,dteTime,txtId1,dblPrice,dblLDR)
					SELECT
						08,
						@txtDate,
						CASE
							  WHEN CONVERT(DATETIME,CONVERT(CHAR(8),t.dteTime,108)) < '1900-01-01 18:00:00.00' THEN '1900-01-01 15:00:00.00'
							  ELSE '1900-01-01 18:00:00.00'
						END,  
						u.txtId1,
						p.dblValue,
						pldr.dblValue
					FROM @tblUniverse AS u
					INNER JOIN @tblPricesINVTimes AS t 
					ON
						u.txtId1 = t.txtId1
					INNER JOIN MxFixincome.dbo.tblPricesINV AS p (NOLOCK)
					ON
						p.txtId1 = t.txtId1
						AND p.dteDate = t.dteTime
						AND p.txtItem = t.txtItem
					INNER JOIN @tblPricesINVTimes AS tldr 
					ON
						u.txtId1 = tldr.txtId1
					INNER JOIN MxFixincome.dbo.tblPricesINV AS pldr (NOLOCK)
					ON
						pldr.txtId1 = tldr.txtId1
						AND pldr.dteDate = tldr.dteTime
						AND pldr.txtItem = tldr.txtItem
					WHERE 
						p.txtItem = 'PRS'
						AND pldr.txtItem = 'LDR'
						AND p.txtLiquidation = 'MD'
						AND pldr.txtLiquidation = 'MD'

				-- Reporto la informacion Definitiva
				INSERT @tblResult (intSection,txtInstrumento,txtPrecio,txtPrecioIndeval,txtDiferenciaPrecio,txtOAS,txtOASIndeval,txtDiferenciaOAS)
					SELECT DISTINCT 
						data.intSection, 
						' (' + RTRIM(LTRIM(IDS.txtTv)) + '_' + RTRIM(LTRIM(IDS.txtEmisora)) + '_' + RTRIM(LTRIM(IDS.txtSerie)) + ')' AS txtInstrumento,
						prcprs.dblValue AS txtPrecio,
						data.dblPrice AS txtPrecioIndeval,
						STR(ABS(((prcprs.dblValue/data.dblPrice)-1)*100),10,4) + '%' AS txtDiferenciaPrecio,
						STR(prcldr.dblValue,10,4) AS txtOAS,
						STR(data.dblldr,10,4) AS txtOASIndeval,
						STR(ABS((prcldr.dblValue-data.dblldr)*100),10,4) AS txtDiferenciaOAS 
					FROM @tblData AS data
						INNER JOIN MxFixincome.dbo.tblIDs AS IDs (NOLOCK)
							ON data.txtID1 = IDs.txtID1
						INNER JOIN MxFixincome.dbo.tblPrices AS prcprs (NOLOCK)
							ON prcprs.txtID1 = data.txtID1
							AND prcprs.dteDate = data.dteDate
							AND prcprs.txtItem = 'PRS'
							AND prcprs.txtLiquidation = 'MD'
						INNER JOIN MxFixincome.dbo.tblPrices AS prcldr (NOLOCK)
							ON prcldr.txtID1 = data.txtID1
							AND prcldr.dteDate = data.dteDate
							AND prcldr.txtItem = 'LDR'
							AND prcldr.txtLiquidation = 'MD'
					WHERE
						data.dteDate = @txtDate

				-- consolido información previa y definitiva
				INSERT @tblResultDef  (intSection,txtInstrumento,txtPrecio,txtPrecioIndeval,txtDiferenciaPrecio,txtOAS,txtOASIndeval,txtDiferenciaOAS)
					SELECT *
					FROM DBSQLDump.dbo.tmp_Indeval_Derechos
	
					UNION
				
					SELECT * 
					FROM @tblResult

				-- Reporto la informacion Definitiva					
				SELECT 
					txtInstrumento,
					txtPrecio,
					txtPrecioIndeval,
					txtDiferenciaPrecio,
					txtOAS,
					txtOASIndeval,
					txtDiferenciaOAS
				FROM @tblResultDef
 
	END

	SET NOCOUNT OFF 

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];9    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------------
-- Autor:	Mike Ramírez
-- Fecha Creacion:	05:09 p.m.	2012-01-12
-- Descripcion:	Procedimiento que genera el Archivo Vector_Emisoras[yyyymmdd].xls
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];9
	@txtDate AS DATETIME	   
    
AS       
BEGIN       

	SET NOCOUNT ON	

		-- creo tabla de Resultados
		DECLARE @tmpLayoutxlPIP TABLE (
				[Orden]	INT,
				[SheetName]	VARCHAR(50),
				[FirstCol]	FLOAT,
				[FirstRow]	FLOAT, 
				[Label01]	VARCHAR(500),
				[Label02]	VARCHAR(500),
				[Label03]	VARCHAR(500),
				[Label04]	VARCHAR(500),
				[Label05]	VARCHAR(500),
				[Label06]	VARCHAR(500),
				[Label07]	VARCHAR(500),
				[Label08]	VARCHAR(500),
				[Label09]	VARCHAR(500),
				[Label10]	VARCHAR(500),
				[Label11]	VARCHAR(500),
				[Label12]	VARCHAR(500),
				[Label13]	VARCHAR(500),
				[Label14]	VARCHAR(500),
				[Label15]	VARCHAR(500),
				[Label16]	VARCHAR(500),
				[Label17]	VARCHAR(500),
				[Label18]	VARCHAR(500),
				[Label19]	VARCHAR(500),
				[Label20]	VARCHAR(500),
				[Label21]	VARCHAR(500),
				[Label22]	VARCHAR(500),
				[Label23]	VARCHAR(500),
				[Label24]	VARCHAR(500),
				[Label25]	VARCHAR(500),
				[Label26]	VARCHAR(500),
				[Label27]	VARCHAR(500),
				[Label28]	VARCHAR(500),
				[Label29]	VARCHAR(500),
				[Label30]	VARCHAR(500),
				[Label31]	VARCHAR(500),
				[Label32]	VARCHAR(500),
				[Label33]	VARCHAR(500),
				[Label34]	VARCHAR(500),
				[Label35]	VARCHAR(500),
				[Label36]	VARCHAR(500),
				[Label37]	VARCHAR(500),
				[Label38]	VARCHAR(500),
				[Label39]	VARCHAR(500),
				[Label40]	VARCHAR(500),
				[Label41]	VARCHAR(500),
				[Label42]	VARCHAR(500),
				[Label43]	VARCHAR(500),
				[Label44]	VARCHAR(500),
				[Label45]	VARCHAR(500),
				[Label46]	VARCHAR(500),
				[Label47]	VARCHAR(500),
				[Label48]	VARCHAR(500),
				[Label49]	VARCHAR(500)
			)

		DECLARE @tmp_tblRattingsIssuers TABLE (
				dteDateAdd	datetime,
				txtIssuerName	varchar(400),
				txtDate	varchar(10),
				txtRate	varchar(50),
				txtVEEItem	varchar(10),
				txtVectorType varchar(3)
				PRIMARY KEY (dteDateAdd,txtIssuerName,txtDate,txtRate,txtVEEItem,txtVectorType)
			)

		DECLARE @tmp_tblKEYRattingsIssuers_1 TABLE	(
				txtIssuerName	varchar(400),
				txtVEEItem	varchar(10),
				txtDate	varchar(10)
				PRIMARY KEY (txtIssuerName, txtVEEItem, txtDate)
			)

		DECLARE @tmp_tblKEYRattingsIssuers_2 TABLE (
				txtIssuerName	varchar(400),
				txtDate	varchar(10),
				txtVEEItem	varchar(10),
				dteDateAdd	datetime
				PRIMARY KEY (txtIssuerName,txtDate,txtVEEItem,dteDateAdd)
			)

		-- Obtengo universo a procesar
		INSERT @tmp_tblRattingsIssuers (dteDateAdd,txtIssuerName,txtDate,txtRate,txtVEEItem,txtVectorType)
			SELECT 
				dteDateAdd,
				RTRIM(txtIssuerName),
				CONVERT(CHAR(8),CAST(txtDate AS DATETIME),112),
				RTRIM(txtRate),
				RTRIM(txtVEEItem),
				RTRIM(txtVectorType)
			FROM MxFixincome.dbo.tblRattingsIssuers (NOLOCK)

		DELETE FROM @tmp_tblRattingsIssuers 
		WHERE txtVEEItem NOT IN ('SPQ_LN','SPQ_SN','SPQ_LGL','SPQ_SGL','SPQ_LGE','SPQ_SGE','DPQ_LN','DPQ_SN','DPQ_LGL','DPQ_SGL','DPQ_LGE','DPQ_SGE','FIQ_LN','FIQ_SN','FIQ_LGL','FIQ_SGL','FIQ_LGE','FIQ_SGE','HRQ_LN','HRQ_SN') OR txtVectorType = 'N/A'

		-- Optimizacion del proceso
		-- Obtengo las LLAVES
		INSERT @tmp_tblKEYRattingsIssuers_1 (txtIssuerName,txtVEEItem,txtDate)
			SELECT 
				txtIssuerName,
				txtVEEItem,
				MAX(txtDate) 
			FROM @tmp_tblRattingsIssuers
			GROUP BY 
				txtIssuerName,
				txtVEEItem

		INSERT @tmp_tblKEYRattingsIssuers_2 (txtIssuerName,txtDate,txtVEEItem,dteDateAdd)
			SELECT 
				r.txtIssuerName,
				r.txtDate,
				r.txtVEEItem,
				MAX(dteDateAdd)
			FROM @tmp_tblRattingsIssuers AS r 
				 INNER JOIN @tmp_tblKEYRattingsIssuers_1 AS k
					ON r.txtIssuerName = k.txtIssuerName 
						AND r.txtDate = k.txtDate 
						AND r.txtVEEItem = k.txtVEEItem
			GROUP BY
				r.txtIssuerName,
				r.txtDate,
				r.txtVEEItem

		--Genero los encabezados para el Sheet 1 EEN
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			001,
			'Vector De Empresas Emisoras',
			1,
			1,
			'RAZON SOCIAL','S&P LP ESC NAC','Fecha de ultimo cambio S&P LP ESC NAC','S&P CP ESC NAC','Fecha de ultimo cambio S&P CP ESC NAC','S&P LP ESC GLOB M LOC','Fecha de ultimo cambio S&P LP ESC GLOB M LOC','S&P CP ESC GLOB M LOC','Fecha de ultimo cambio S&P CP ESC GLOB M LOC','S&P LP ESC GLOB M EXT','Fecha de ultimo cambio S&P LP ESC GLOB M EXT','S&P CP ESC GLOB M EXT','Fecha de ultimo cambio S&P CP ESC GLOB M EXT','MOODY S LP ESC NAC','Fecha de ultimo cambio MOODY S LP ESC NAC','MOODY S CP ESC NAC','Fecha de ultimo cambio MOODY S CP ESC NAC','MOODY S LP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S LP ESC GLOB M LOC','MOODY S CP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S CP ESC GLOB M LOC','MOODY S LP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S LP ESC GLOB M EXT','MOODY S CP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S CP ESC GLOB M EXT','FITCH LP ESC NAC','Fecha de ultimo cambio FITCH LP ESC NAC','FITCH CP ESC NAC','Fecha de ultimo cambio FITCH CP ESC NAC','FITCH LP ESC GLOB M LOC','Fecha de ultimo cambio FITCH LP ESC GLOB M LOC','FITCH CP ESC GLOB M LOC','Fecha de ultimo cambio FITCH CP ESC GLOB M LOC','FITCH LP ESC GLOB M EXT','Fecha de ultimo cambio FITCH LP ESC GLOB M EXT','FITCH CP ESC GLOB M EXT','Fecha de ultimo cambio FITCH CP ESC GLOB M EXT','HR RATINGS LP ESC NAC','Fecha de ultimo cambio HR RATINGS LP ESC NAC','HR RATINGS CP ESC NAC','Fecha de ultimo cambio HR RATINGS CP ESC NAC','HR RATINGS LP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M LOC','HR RATINGS CP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M LOC','HR RATINGS LP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M EXT','HR RATINGS CP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M EXT'	

	--Genero el reporte para el Sheet 1 EEN
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			002,
			'Vector De Empresas Emisoras',
			NULL,
			NULL,
			UPPER(r.txtIssuerName) AS [RAZON SOCIAL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtRate ELSE ' ' END) AS [SPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtDate ELSE ' ' END) AS [SPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtRate ELSE ' ' END) AS [SPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtDate ELSE ' ' END) AS [SPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtRate ELSE ' ' END) AS [DPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtDate ELSE ' ' END) AS [DPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtRate ELSE ' ' END) AS [DPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtDate ELSE ' ' END) AS [DPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtRate ELSE ' ' END) AS [FIQ_LN], 
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtDate ELSE ' ' END) AS [FIQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtRate ELSE ' ' END) AS [FIQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtDate ELSE ' ' END) AS [FIQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtRate ELSE ' ' END) AS [HRQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtDate ELSE ' ' END) AS [HRQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtRate ELSE ' ' END) AS [HRQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtDate ELSE ' ' END) AS [HRQ_SN_DATE],
			' ' AS [HR_LP_GLOB_LOC],
			' ' AS [HR_LP_GLOB_LOC_DATE],
			' ' AS [HR_CP_GLOB_LOC],
			' ' AS [HR_CP_GLOB_LOC_DATE],
			' ' AS [HR_LP_GLOB_EXT],
			' ' AS [HR_LP_GLOB_EXT_DATE],
			' ' AS [HR_CP_GLOB_EXT],
			' ' AS [HR_CP_GLOB_EXT_DATE]
		FROM @tmp_tblRattingsIssuers AS r 
			 INNER JOIN @tmp_tblKEYRattingsIssuers_2 AS k
				ON r.txtIssuerName = k.txtIssuerName 
				AND r.txtDate = k.txtDate 
				AND r.txtVEEItem = k.txtVEEItem 
				AND r.dteDateAdd = k.dteDateAdd
		WHERE txtVectorType = 'EEN'
		GROUP BY r.txtIssuerName

		--Genero los encabezados para el Sheet 1 EEN
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			003,
			'Vector De Empresas Extranjeras',
			1,
			1,
			'RAZON SOCIAL','S&P LP ESC NAC','Fecha de ultimo cambio S&P LP ESC NAC','S&P CP ESC NAC','Fecha de ultimo cambio S&P CP ESC NAC','S&P LP ESC GLOB M LOC','Fecha de ultimo cambio S&P LP ESC GLOB M LOC','S&P CP ESC GLOB M LOC','Fecha de ultimo cambio S&P CP ESC GLOB M LOC','S&P LP ESC GLOB M EXT','Fecha de ultimo cambio S&P LP ESC GLOB M EXT','S&P CP ESC GLOB M EXT','Fecha de ultimo cambio S&P CP ESC GLOB M EXT','MOODY S LP ESC NAC','Fecha de ultimo cambio MOODY S LP ESC NAC','MOODY S CP ESC NAC','Fecha de ultimo cambio MOODY S CP ESC NAC','MOODY S LP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S LP ESC GLOB M LOC','MOODY S CP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S CP ESC GLOB M LOC','MOODY S LP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S LP ESC GLOB M EXT','MOODY S CP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S CP ESC GLOB M EXT','FITCH LP ESC NAC','Fecha de ultimo cambio FITCH LP ESC NAC','FITCH CP ESC NAC','Fecha de ultimo cambio FITCH CP ESC NAC','FITCH LP ESC GLOB M LOC','Fecha de ultimo cambio FITCH LP ESC GLOB M LOC','FITCH CP ESC GLOB M LOC','Fecha de ultimo cambio FITCH CP ESC GLOB M LOC','FITCH LP ESC GLOB M EXT','Fecha de ultimo cambio FITCH LP ESC GLOB M EXT','FITCH CP ESC GLOB M EXT','Fecha de ultimo cambio FITCH CP ESC GLOB M EXT','HR RATINGS LP ESC NAC','Fecha de ultimo cambio HR RATINGS LP ESC NAC','HR RATINGS CP ESC NAC','Fecha de ultimo cambio HR RATINGS CP ESC NAC','HR RATINGS LP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M LOC','HR RATINGS CP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M LOC','HR RATINGS LP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M EXT','HR RATINGS CP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M EXT'

		--Genero el reporte para el Sheet 2 EEE
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			004,
			'Vector De Empresas Extranjeras',
			NULL,
			NULL,
		RTRIM(LTRIM(UPPER(txtISN))) as 'RAZON SOCIAL DE LA EMPRESA',
		CASE WHEN RTRIM(LTRIM(txtSPQ_LN)) = 'RETIRADA' THEN 
			''
		ELSE
			RTRIM(LTRIM(txtSPQ_LN))
		END AS 'SPQ_LN',
		CASE WHEN RTRIM(LTRIM(txtSPQ_LN)) = 'RETIRADA' THEN
			''
		ELSE
		 	RTRIM(LTRIM(txtSPQD_LN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtSPQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQ_SN))
		END as 'SPQ_SN',
		CASE WHEN RTRIM(LTRIM(txtSPQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQD_SN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtSPQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE 
			RTRIM(LTRIM(txtSPQ_LGL))
		END as 'SPQ_LGL',
		CASE WHEN RTRIM(LTRIM(txtSPQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQD_LGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtSPQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQ_SGL))
		END as 'SPQ_SGL',
		CASE WHEN RTRIM(LTRIM(txtSPQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQD_SGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtSPQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQ_LGE))
		END as 'SPQ_LGE',
		CASE WHEN RTRIM(LTRIM(txtSPQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQD_LGE))
		END as 'Fecha',    
		CASE WHEN RTRIM(LTRIM(txtSPQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQ_SGE))
		END as 'SPQ_SGE',
		CASE WHEN RTRIM(LTRIM(txtSPQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtSPQD_SGE))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtDPQ_LN)) = 'RETIRADA' THEN 
			''
		ELSE
			RTRIM(LTRIM(txtDPQ_LN))
		END AS 'DPQ_LN',
		CASE WHEN RTRIM(LTRIM(txtDPQ_LN)) = 'RETIRADA' THEN
			''
		ELSE
		 	RTRIM(LTRIM(txtDPQD_LN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtDPQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQ_SN))
		END as 'DPQ_SN',
		CASE WHEN RTRIM(LTRIM(txtDPQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQD_SN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtDPQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE 
			RTRIM(LTRIM(txtDPQ_LGL))
		END as 'DPQ_LGL',
		CASE WHEN RTRIM(LTRIM(txtDPQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQD_LGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtDPQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQ_SGL))
		END as 'DPQ_SGL',
		CASE WHEN RTRIM(LTRIM(txtDPQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQD_SGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtDPQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQ_LGE))
		END as 'DPQ_LGE',
		CASE WHEN RTRIM(LTRIM(txtDPQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQD_LGE))
		END as 'Fecha',    
		CASE WHEN RTRIM(LTRIM(txtDPQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQ_SGE))
		END as 'DPQ_SGE',
		CASE WHEN RTRIM(LTRIM(txtDPQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtDPQD_SGE))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtFIQ_LN)) = 'RETIRADA' THEN 
			''
		ELSE
			RTRIM(LTRIM(txtFIQ_LN))
		END AS 'FIQ_LN',
		CASE WHEN RTRIM(LTRIM(txtFIQ_LN)) = 'RETIRADA' THEN
			''
		ELSE
		 	RTRIM(LTRIM(txtFIQD_LN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtFIQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQ_SN))
		END as 'FIQ_SN',
		CASE WHEN RTRIM(LTRIM(txtFIQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQD_SN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtFIQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE 
			RTRIM(LTRIM(txtFIQ_LGL))
		END as 'FIQ_LGL',
		CASE WHEN RTRIM(LTRIM(txtFIQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQD_LGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtFIQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQ_SGL))
		END as 'FIQ_SGL',
		CASE WHEN RTRIM(LTRIM(txtFIQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQD_SGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtFIQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQ_LGE))
		END as 'FIQ_LGE',
		CASE WHEN RTRIM(LTRIM(txtFIQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQD_LGE))
		END as 'Fecha',    
		CASE WHEN RTRIM(LTRIM(txtFIQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQ_SGE))
		END as 'FIQ_SGE',
		CASE WHEN RTRIM(LTRIM(txtFIQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtFIQD_SGE))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtHRQ_LN)) = 'RETIRADA' THEN 
			''
		ELSE
			RTRIM(LTRIM(txtHRQ_LN))
		END AS 'HRQ_LN',
		CASE WHEN RTRIM(LTRIM(txtHRQ_LN)) = 'RETIRADA' THEN
			''
		ELSE
		 	RTRIM(LTRIM(txtHRQD_LN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtHRQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQ_SN))
		END as 'HRQ_SN',
		CASE WHEN RTRIM(LTRIM(txtHRQ_SN)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQD_SN))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtHRQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE 
			RTRIM(LTRIM(txtHRQ_LGL))
		END as 'HRQ_LGL',
		CASE WHEN RTRIM(LTRIM(txtHRQ_LGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQD_LGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtHRQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQ_SGL))
		END as 'HRQ_SGL',
		CASE WHEN RTRIM(LTRIM(txtHRQ_SGL)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQD_SGL))
		END as 'Fecha',
		CASE WHEN RTRIM(LTRIM(txtHRQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQ_LGE))
		END as 'HRQ_LGE',
		CASE WHEN RTRIM(LTRIM(txtHRQ_LGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQD_LGE))
		END as 'Fecha',    
		CASE WHEN RTRIM(LTRIM(txtHRQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQ_SGE))
		END as 'HRQ_SGE',
		CASE WHEN RTRIM(LTRIM(txtHRQ_SGE)) = 'RETIRADA' THEN
			''
		ELSE
			RTRIM(LTRIM(txtHRQD_SGE))
		END as 'Fecha'		
	FROM MxFixincome.dbo.tblVectorEmpresasEmisorasNew (NOLOCK)
	WHERE txtVectorType = 'EEE'
	ORDER BY txtISN
/*		--Genero los encabezados para el Sheet 1 EEN
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,La



b
el25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			003,
			'Vector De Empresas Extranjeras',
			1,
			1,
			'RAZON SOCIAL','S&P LP ESC NAC','Fecha de ultimo cambio S&P LP ESC NAC','S&P CP ESC NAC','Fecha de ultimo cambio S&P CP ESC NAC','S&P LP ESC GLOB M LOC','Fecha de ultimo cambio S&P LP ESC GLOB M LOC','S&P CP ESC GLOB M LOC','Fecha de ultimo cambio S&P 


CP ESC GLOB M LOC','S&P LP ESC GLOB M EXT','Fecha de ultimo cambio S&P LP ESC GLOB M EXT','S&P CP ESC GLOB M EXT','Fecha de ultimo cambio S&P CP ESC GLOB M EXT','MOODY S LP ESC NAC','Fecha de ultimo cambio MOODY S LP ESC NAC','MOODY S CP ESC NAC','Fecha d


e ultimo cambio MOODY S CP ESC NAC','MOODY S LP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S LP ESC GLOB M LOC','MOODY S CP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S CP ESC GLOB M LOC','MOODY S LP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S L


P ESC GLOB M EXT','MOODY S CP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S CP ESC GLOB M EXT','FITCH LP ESC NAC','Fecha de ultimo cambio FITCH LP ESC NAC','FITCH CP ESC NAC','Fecha de ultimo cambio FITCH CP ESC NAC','FITCH LP ESC GLOB M LOC','Fecha de 


ultimo cambio FITCH LP ESC GLOB M LOC','FITCH CP ESC GLOB M LOC','Fecha de ultimo cambio FITCH CP ESC GLOB M LOC','FITCH LP ESC GLOB M EXT','Fecha de ultimo cambio FITCH LP ESC GLOB M EXT','FITCH CP ESC GLOB M EXT','Fecha de ultimo cambio FITCH CP ESC GLO


B M EXT','HR RATINGS LP ESC NAC','Fecha de ultimo cambio HR RATINGS LP ESC NAC','HR RATINGS CP ESC NAC','Fecha de ultimo cambio HR RATINGS CP ESC NAC','HR RATINGS LP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M LOC','HR RATINGS CP ESC 


GLOB M LOC','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M LOC','HR RATINGS LP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M EXT','HR RATINGS CP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M EXT'

		--Genero el reporte para el Sheet 2 EEE
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Lab


el25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			004,
			'Vector De Empresas Extranjeras',
			NULL,
			NULL,
			UPPER(r.txtIssuerName) AS [RAZON SOCIAL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtRate ELSE ' ' END) AS [SPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtDate ELSE ' ' END) AS [SPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtRate ELSE ' ' END) AS [SPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtDate ELSE ' ' END) AS [SPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtRate ELSE ' ' END) AS [DPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtDate ELSE ' ' END) AS [DPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtRate ELSE ' ' END) AS [DPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtDate ELSE ' ' END) AS [DPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtRate ELSE ' ' END) AS [FIQ_LN], 
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtDate ELSE ' ' END) AS [FIQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtRate ELSE ' ' END) AS [FIQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtDate ELSE ' ' END) AS [FIQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtRate ELSE ' ' END) AS [HRQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtDate ELSE ' ' END) AS [HRQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtRate ELSE ' ' END) AS [HRQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtDate ELSE ' ' END) AS [HRQ_SN_DATE],
			' ' AS [HR_LP_GLOB_LOC],
			' ' AS [HR_LP_GLOB_LOC_DATE],
			' ' AS [HR_CP_GLOB_LOC],
			' ' AS [HR_CP_GLOB_LOC_DATE],
			' ' AS [HR_LP_GLOB_EXT],
			' ' AS [HR_LP_GLOB_EXT_DATE],
			' ' AS [HR_CP_GLOB_EXT],
			' ' AS [HR_CP_GLOB_EXT_DATE]
		FROM @tmp_tblRattingsIssuers AS r 
			 INNER JOIN @tmp_tblKEYRattingsIssuers_2 AS k
				ON r.txtIssuerName = k.txtIssuerName 
				AND r.txtDate = k.txtDate 
				AND r.txtVEEItem = k.txtVEEItem 
				AND r.dteDateAdd = k.dteDateAdd
		WHERE txtVectorType = 'EEE'
		GROUP BY r.txtIssuerName*/

	-- Reporte de Vector de Variaciones
	SELECT 
				[Orden],
				[SheetName],
				[FirstCol],
				[FirstRow], 
				REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Label01,'Á','A'),'É','E'),'Í','I'),'Ó','O'),'Ú','U') AS [Label01],
				Label02 AS [Label02],
				Label03 AS [Label03],
				Label04 AS [Label04],
				Label05 AS [Label05],
				Label06 AS [Label06],
				Label07 AS [Label07],
				Label08 AS [Label08],
				Label09 AS [Label09],
				Label10 AS [Label10],
				Label11 AS [Label11],
				Label12 AS [Label12],
				Label13 AS [Label13],
				Label14 AS [Label14],
				Label15 AS [Label15],
				Label16 AS [Label16],
				Label17 AS [Label17],
				Label18 AS [Label18],
				Label19 AS [Label19],
				Label20 AS [Label20],
				Label21 AS [Label21],
				Label22 AS [Label22],
				Label23 AS [Label23],
				Label24 AS [Label24],
				Label25 AS [Label25],
				Label26 AS [Label26],
				Label27 AS [Label27],
				Label28 AS [Label28],
				Label29 AS [Label29],
				Label30 AS [Label30],
				Label31 AS [Label31],
				Label32 AS [Label32],
				Label33 AS [Label33],
				Label34 AS [Label34],
				Label35 AS [Label35],
				Label36 AS [Label36],
				Label37 AS [Label37],
				Label38 AS [Label38],
				Label39 AS [Label39],
				Label40 AS [Label40],
				Label41 AS [Label41],
				Label42 AS [Label42],
				Label43 AS [Label43],
				Label44 AS [Label44],
				Label45 AS [Label45],
				Label46 AS [Label46],
				Label47 AS [Label47],
				Label48 AS [Label48],
				Label49 AS [Label49]
	FROM @tmpLayoutxlPIP
	ORDER BY ORDEN,SHEETNAME,LABEL01

	SET NOCOUNT OFF
END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];10    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------- 
-- Autor:	Mike Ramírez
-- Fecha Creacion:	09:50 a.m.	2012-02-02
-- Descripcion:	Procedimiento que genera el Archivo Vector_Emisoras_Nacionales[yyyymmdd].txt
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];10
	@txtDate AS DATETIME	   
    
AS       
BEGIN       

 	SET NOCOUNT ON

		-- Genera tabla temporal de resultados  
		 DECLARE @tblResult TABLE (  
		  [intSection][INTEGER],  
		  [txtData][VARCHAR](8000)  
		 )  

		DECLARE @tmp_tblRattingsIssuers TABLE (
				dteDateAdd	datetime,
				txtIssuerName	varchar(400),
				txtDate	varchar(10),
				txtRate	varchar(50),
				txtVEEItem	varchar(10),
				txtVectorType varchar(3)
				PRIMARY KEY (dteDateAdd,txtIssuerName,txtDate,txtRate,txtVEEItem,txtVectorType)
			)

		DECLARE @tmp_tblKEYRattingsIssuers_1 TABLE	(
				txtIssuerName	varchar(400),
				txtVEEItem	varchar(10),
				txtDate	varchar(10)
				PRIMARY KEY (txtIssuerName, txtVEEItem, txtDate)
			)

		DECLARE @tmp_tblKEYRattingsIssuers_2 TABLE (
				txtIssuerName	varchar(400),
				txtDate	varchar(10),
				txtVEEItem	varchar(10),
				dteDateAdd	datetime
				PRIMARY KEY (txtIssuerName,txtDate,txtVEEItem,dteDateAdd)
			)

		-- Obtengo universo a procesar
		INSERT @tmp_tblRattingsIssuers (dteDateAdd,txtIssuerName,txtDate,txtRate,txtVEEItem,txtVectorType)
			SELECT 
				dteDateAdd,
				txtIssuerName,
				CONVERT(CHAR(8),CAST(txtDate AS DATETIME),112),
				txtRate,
				txtVEEItem,
				txtVectorType
			FROM MxFixincome.dbo.tblRattingsIssuers (NOLOCK)

		DELETE FROM @tmp_tblRattingsIssuers 
		WHERE txtVEEItem NOT IN ('SPQ_LN','SPQ_SN','SPQ_LGL','SPQ_SGL','SPQ_LGE','SPQ_SGE','DPQ_LN','DPQ_SN','DPQ_LGL','DPQ_SGL',
			'DPQ_LGE','DPQ_SGE','FIQ_LN','FIQ_SN','FIQ_LGL','FIQ_SGL','FIQ_LGE','FIQ_SGE','HRQ_LN','HRQ_SN') OR txtVectorType = 'N/A'

		-- Optimizacion del proceso
		-- Obtengo las LLAVES
		INSERT @tmp_tblKEYRattingsIssuers_1 (txtIssuerName,txtVEEItem,txtDate)
			SELECT 
				txtIssuerName,
				txtVEEItem,
				MAX(txtDate) 
			FROM @tmp_tblRattingsIssuers
			GROUP BY 
				txtIssuerName,
				txtVEEItem

		INSERT @tmp_tblKEYRattingsIssuers_2 (txtIssuerName,txtDate,txtVEEItem,dteDateAdd)
			SELECT 
				r.txtIssuerName,
				r.txtDate,
				r.txtVEEItem,
				MAX(dteDateAdd)
			FROM @tmp_tblRattingsIssuers AS r 
				 INNER JOIN @tmp_tblKEYRattingsIssuers_1 AS k
					ON r.txtIssuerName = k.txtIssuerName 
						AND r.txtDate = k.txtDate 
						AND r.txtVEEItem = k.txtVEEItem
			GROUP BY 
				r.txtIssuerName,
				r.txtDate,
				r.txtVEEItem
  
		-- Genero los encabezados para el reporte
	INSERT @tblResult (intSection,txtData)
		SELECT
			001,
			'RAZON SOCIAL|S&P LP ESC NAC|Fecha de ultimo cambio S&P LP ESC NAC|S&P CP ESC NAC|Fecha de ultimo cambio S&P CP ESC NAC|S&P LP ESC GLOB M LOC|Fecha de ultimo cambio S&P LP ESC GLOB M LOC|S&P CP ESC GLOB M LOC|Fecha de ultimo cambio S&P CP ESC GLOB M LOC|S&P LP ESC GLOB M EXT|Fecha de ultimo cambio S&P LP ESC GLOB M EXT|S&P CP ESC GLOB M EXT|Fecha de ultimo cambio S&P CP ESC GLOB M EXT|MOODY S LP ESC NAC|Fecha de ultimo cambio MOODY S LP ESC NAC|MOODY S CP ESC NAC|Fecha de ultimo cambio MOODY S CP ESC NAC|MOODY S LP ESC GLOB M LOC|Fecha de ultimo cambio MOODY S LP ESC GLOB M LOC|MOODY S CP ESC GLOB M LOC|Fecha de ultimo cambio MOODY S CP ESC GLOB M LOC|MOODY S LP ESC GLOB M EXT|Fecha de ultimo cambio MOODY S LP ESC GLOB M EXT|MOODY S CP ESC GLOB M EXT|Fecha de ultimo cambio MOODY S CP ESC GLOB M EXT|FITCH LP ESC NAC|Fecha de ultimo cambio FITCH LP ESC NAC|FITCH CP ESC NAC|Fecha de ultimo cambio FITCH CP ESC NAC|FITCH LP ESC GLOB M LOC|Fecha de ultimo cambio FITCH LP ESC GLOB M LOC|FITCH CP ESC GLOB M LOC|Fecha de ultimo cambio FITCH CP ESC GLOB M LOC|FITCH LP ESC GLOB M EXT|Fecha de ultimo cambio FITCH LP ESC GLOB M EXT|FITCH CP ESC GLOB M EXT|Fecha de ultimo cambio FITCH CP ESC GLOB M EXT|HR RATINGS LP ESC NAC|Fecha de ultimo cambio HR RATINGS LP ESC NAC|HR RATINGS CP ESC NAC|Fecha de ultimo cambio HR RATINGS CP ESC NAC|HR RATINGS LP ESC GLOB M LOC|Fecha de ultimo cambio HR RATINGS LP ESC GLOB M LOC|HR RATINGS CP ESC GLOB M LOC|Fecha de ultimo cambio HR RATINGS CP ESC GLOB M LOC|HR RATINGS LP ESC GLOB M EXT|Fecha de ultimo cambio HR RATINGS LP ESC GLOB M EXT|HR RATINGS CP ESC GLOB M EXT|Fecha de ultimo cambio HR RATINGS CP ESC GLOB M EXT'

		-- Consolido el Vector
	INSERT @tblResult (intSection,txtData)
		SELECT
			002,
			RTRIM(UPPER(r.txtIssuerName)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtRate ELSE '' END)) + '|' +
			RTRIM(MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtDate ELSE '' END)) + '|' +
			RTRIM('') + '|' +
			RTRIM('') + '|' +
			RTRIM('') + '|' +
			RTRIM('') + '|' +
			RTRIM('') + '|' +
			RTRIM('') + '|' +
			RTRIM('') + '|' +
			RTRIM('') 
		FROM @tmp_tblRattingsIssuers AS r 
			 INNER JOIN @tmp_tblKEYRattingsIssuers_2 AS k
				ON r.txtIssuerName = k.txtIssuerName 
				AND r.txtDate = k.txtDate 
				AND r.txtVEEItem = k.txtVEEItem 
				AND r.dteDateAdd = k.dteDateAdd
		WHERE r.txtVectorType = 'EEN'
		GROUP BY r.txtIssuerName
 
		-- Genero el reporte
		SELECT txtData
		FROM @tblResult

 	SET NOCOUNT OFF
END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];11    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------------------------------ 
-- Autor:	Mike Ramírez
-- Fecha Creacion:	08:59 a.m.	2012-03-01
-- Descripcion:	Producto que contiene información sobre curvas de dividendos Curvas_Dividendos[yyyymmdd].xls 
------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];11
 	@txtDate AS DATETIME

AS 
BEGIN

	SET NOCOUNT ON

	DECLARE @tmpLayoutxlCurve TABLE (
		SheetName CHAR(50),
		Col INT,
		Header CHAR(50),
        Source CHAR(20),
        Type CHAR(3),
		SubType CHAR(3),
		Range CHAR(15),
		Factor CHAR(5),
		DataType CHAR(3), 
		DataFormat CHAR(20),
		fLoad CHAR(1),
	PRIMARY KEY (Col)
	)	

	-- <Sheet1> = Sheet1
	INSERT @tmpLayoutxlCurve 
		SELECT 'Sheet1' AS [SheetName], 1  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYY/MM/DD' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 3 AS [Col],'Dividendos en efectivo de ALFA A'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'ALF'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 4 AS [Col],'Dividendos en efectivo de Walmex V'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'WLM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 5 AS [Col],'Dividendos en efectivo de TELEVISA CPO'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'TLV'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 6 AS [Col],'Dividendos en efectivo de MEXCHEM *'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'MXC'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 7 AS [Col],'Dividendos en efectivo de MEXBOL'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'MBL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 8 AS [Col],'Dividendos en efectivo de GMEXICO B'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'GMX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 9 AS [Col],'Dividendos en efectivo de FEMSA UBD'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'FMS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 10 AS [Col],'Dividendos en efectivo de AMX L'  AS [Header],'CURVES' AS [Source],'DIV'    AS [Type],'AMX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.00000000' AS [DataFormat],'1' AS [fLoad]

	SELECT
		RTRIM(SheetName) AS [SheetName],
		Col AS [Col],
		RTRIM(Header) AS [Header],
        RTRIM(Source) AS [Source],
        RTRIM(Type) AS [Type],
		RTRIM(SubType) AS [SubType],
		RTRIM(Range) AS [Range],
		RTRIM(Factor) AS [Factor],
		RTRIM(DataType) AS [DataType], 
		RTRIM(DataFormat) AS [DataFormat],
		RTRIM(fLoad) AS [fLoad]
	FROM @tmpLayoutxlCurve 
	WHERE Col > 0
	ORDER BY Col

	SET NOCOUNT OFF

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];12    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------    
-- Autor: Mike Ramírez  
-- Fecha Modificacion: 13:54 p.m 16/11/2012  
-- Descripcion Modulo 12: Se incluyen los TC  
-------------------------------------------------   
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];12  -- '20140804','MSCI'
  @txtDate AS DATETIME,  
 @txtIndex AS CHAR(4)  
  
AS   
BEGIN  
  
  SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](10),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][VARCHAR](150),  
    [txtSubSector][VARCHAR](150),  
    [txtRamo][VARCHAR](150),  
    [txtSubRamo][VARCHAR](150),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80)  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  DECLARE @tmp_tblKeyIssuerSubRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (txtIndex,txtId1,dblCount)  
   SELECT  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = @txtIndex   
      AND dtedate = @txtDate  
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerSubRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubRamo  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intRamo  
   
  INSERT @tmp_tblKeyIssuerSector (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSectorCatalog AS i (NOLOCK)  
        ON o.intSector = i.intSector  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Subsector  
  INSERT @tmp_tblKeyIssuerSubSector_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubSector AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubSectorCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubSector  
   
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
  
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
  
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    NULL AS [POR],  
    pr.txtID2 AS [ID2],  
    o.txtDescription AS [Sector],  
    os.txtDescription AS [SubSector],  
    ra.txtDescription AS [Ramo],  
    sra.txtDescription AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(ic.txtName,0,80) AS [Razon Social]  
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON ip.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector_1 AS os  
          ON pr.txtId1 = os.txtId1  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo_1 AS ra  
           ON pr.txtId1 = ra.txtId1  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo_1 AS sra  
            ON pr.txtId1 = sra.txtId1  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer   
   
  -- Obtenemos el campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = @txtDate   
   AND l.txtIndex = @txtIndex  
  GROUP BY l.txtIndex  
  
  -- Para el calculo de Porcentaje  
  UPDATE u  
   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
  FROM  
   @tmp_tblResultsVector AS u  
    INNER JOIN @tmp_tblUniversoIndex AS ui  
     ON u.txtId1 = ui.txtId1  
      INNER JOIN @tmp_tblPond AS p  
       ON ui.txtIndex = p.txtIndex  
  WHERE ui.txtIndex = @txtIndex  
   
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
  
  -- Agregamos TC  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
    RTRIM(txtIRC) AS [ID1],  
    '*C' AS [TV],  
    'MXP' + CASE WHEN txtIRC = 'UFXU' THEN 'USD' ELSE RTRIM(txtIRC) END AS [Emisora],  
    CASE WHEN txtIRC = 'UFXU' THEN 'FIX' ELSE RTRIM(txtIRC) END AS [Serie],  
    dblValue AS [Precio MO],  
    dblValue AS [Precio MO Peso],  
    '' AS [MO],  
    '' AS [Country],  
    '' AS [Indexes],  
    '' AS [POR],  
    '' AS [ID2],  
    '' AS [Sector],  
    '' AS [SubSector],  
    '' AS [Ramo],  
    '' AS [SubRamo],  
    '' AS [Bolsa Cotizacion],  
    '' AS [Valores en Cartera],  
    '' AS [Bloomberg],  
    '' AS [Reuters],  
    '' AS [CUSIP],  
    '' AS [SEDOL],  
    '' AS [Razon Social]  
  FROM @tmp_tblTC  
  ORDER BY ID1  
  
 -- Valida que la información este completa  
 IF EXISTS (  
   SELECT TOP 1 *   
   FROM @tmp_tblResultsVector  
    )  
  
  BEGIN  
  
   -- Reporto Informacion  
   SELECT   
    CONVERT(CHAR(8),@txtDate,112),  
    RTRIM(txtTv),  
    RTRIM(txtEmisora),  
    RTRIM(txtSerie),  
    CASE WHEN dblPMO IS NULL THEN '0' ELSE ROUND(dblPMO,6) END,  
    CASE WHEN dblPMOP IS NULL THEN '0' ELSE ROUND(dblPMOP,6) END,  
    CASE WHEN txtCurrency IS NULL THEN '*******' ELSE RTRIM(txtCurrency) END AS [Currency],  
    CASE WHEN txtCountry IS NULL THEN ' ' ELSE RTRIM(txtCountry) END AS [Country],  
    CASE WHEN txtIndex IS NULL THEN ' ' ELSE RTRIM(txtIndex) END AS [Index],  
    CASE WHEN dblPOR IS NULL THEN '0' ELSE ROUND(dblPOR,6) END,  
    CASE WHEN txtID2 IS NULL THEN ' ' ELSE RTRIM(txtID2) END AS [ID2],  
    CASE WHEN txtSector IS NULL THEN ' ' ELSE RTRIM(txtSector) END AS [Sector],  
    CASE WHEN txtSubSector IS NULL THEN ' ' ELSE RTRIM(txtSubSector) END AS [SubSector],  
    CASE WHEN txtRamo IS NULL THEN ' ' ELSE RTRIM(txtRamo) END AS [Ramo],  
    CASE WHEN txtSubRamo IS NULL THEN ' ' ELSE RTRIM(txtSubRamo) END AS [SubRamo],  
    CASE WHEN txtBCT IS NULL THEN ' ' ELSE RTRIM(txtBCT) END,  
    CASE WHEN txtVCT IS NULL THEN ' ' ELSE RTRIM(txtVCT) END,  
    CASE WHEN txtID7 IS NULL THEN ' ' ELSE RTRIM(txtID7) END,  
    CASE WHEN txtID6 IS NULL THEN ' ' ELSE RTRIM(txtID6) END,  
    CASE WHEN txtID3 IS NULL THEN ' ' ELSE RTRIM(txtID3) END,  
    CASE WHEN txtID4 IS NULL THEN ' ' ELSE RTRIM(txtID4) END,  
    CASE WHEN txtRZ IS NULL THEN ' ' ELSE RTRIM(txtRZ) END  
   FROM @tmp_tblResultsVector  
   ORDER BY txtTv,txtEmisora,txtSerie  
  
  END  
  
 ELSE  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
END  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];13    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------
-- Autor:	Mike Ramírez
-- Fecha Modificacion:	05:35 p.m.	2012-08-23
-- Descripcion:	Producto PIP::Se modifica la seccion 3 curva SWP - TI
---------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];13
	@txtDate AS DATETIME

AS
BEGIN

	SET NOCOUNT ON

	DECLARE @dblUDI AS FLOAT
	DECLARE @dblT028 AS FLOAT
	DECLARE @dblUSD2 AS FLOAT
	DECLARE @intCont AS INTEGER
	DECLARE @intTerm AS INTEGER
	DECLARE @dblBid AS FLOAT
	DECLARE @dblAsk AS FLOAT
	DECLARE @dblLevel AS FLOAT
	DECLARE @dblRate AS FLOAT
	DECLARE @dblVar AS FLOAT
	DECLARE @dblMid AS FLOAT
	DECLARE @dblMid1 AS FLOAT
	DECLARE @dblSpreadBase AS FLOAT
	DECLARE @dblSpread12 AS FLOAT
	DECLARE @dblSpread15 AS FLOAT
	DECLARE @dblSpread20 AS FLOAT
	DECLARE @dblSpread30 AS FLOAT
	DECLARE @Serie AS FLOAT
	DECLARE	@dblValue AS FLOAT
	DECLARE	@dblValue1 AS FLOAT

	DECLARE @tblDirectives TABLE (
			intSection INT,
			txtSource CHAR(20),
			txtCode CHAR(50),
			intCol INT,
			intRow INT,
			txtValue VARCHAR(100),
			[Type] CHAR(3),
			SubType  CHAR(3),
			Node INT,
			intStrike INT
	PRIMARY KEY (intCol,intRow)
		)

	-- Tablas temporales para agilizar calculo
	DECLARE @tmp_tblKeysNodeZeroLevelsMAXdate TABLE (
			[intSerialZero]INT,
			[dteDate][DATETIME]
		PRIMARY KEY(intSerialZero)
	)

	DECLARE @tmp_tblKeysNodeZeroLevelsMAXtime TABLE (
			[intSerialZero]INT,
			[dteTime][DATETIME]
		PRIMARY KEY(intSerialZero)
	)

	DECLARE @tmp_tblNodeZeroLevels TABLE (
			[intSerialZero]INT,
			[dteDate][DATETIME],
			[dteTime][DATETIME],
			[dblValue][FLOAT]
		PRIMARY KEY(intSerialZero,dteDate,dteTime)
	)

	-- Tablas temporales para agilizar calculo T-1
	DECLARE @tmp_tblKeysNodeZeroLevelsMAXdateT1 TABLE (
			[intSerialZero]INT,
			[dteDate][DATETIME]
		PRIMARY KEY(intSerialZero)
	)

	DECLARE @tmp_tblKeysNodeZeroLevelsMAXtimeT1 TABLE (
			[intSerialZero]INT,
			[dteTime][DATETIME]
		PRIMARY KEY(intSerialZero)
	)

	DECLARE @tmp_tblNodeZeroLevelsT1 TABLE (
			[intSerialZero]INT,
			[dteDate][DATETIME],
			[dteTime][DATETIME],
			[dblValue][FLOAT]
		PRIMARY KEY(intSerialZero,dteDate,dteTime)
	)

	DECLARE @tmp_tblCurve_MSGYLD TABLE (
			intTerm INT,
			dteDate DATETIME,
			txtType CHAR(3),
			txtSubType CHAR(3),
			dblRate FLOAT
	PRIMARY KEY (intTerm)
	)

		DECLARE @txtLastDate AS DATETIME
		SET @txtLastDate = (SELECT MxFixIncome.dbo.fun_NextTradingDate(CONVERT(CHAR(8),@txtDate,112),-1,'MX'))

		-- Cargo la Curva interpolada
		-- Cargo curva MSG/YLD interpolada
		INSERT @tmp_tblCurve_MSGYLD (intTerm,dteDate,txtType,txtSubtype,dblRate)
			SELECT intTerm,dteDate,txtType,txtSubtype,dblRate
			FROM MxFixIncome.dbo.fun_get_curve_complete(@txtDate,'MSG','YLD') AS c

		INSERT @tmp_tblKeysNodeZeroLevelsMAXdate (intSerialZero,dteDate)
			SELECT 
				intSerialZero,
				MAX(dteDate)
			FROM MxFixIncome.dbo.itblNodesZeroLevels (NOLOCK)
			WHERE
				dteDate = @txtDate
				AND intSerialZero IN (1450,967,1145,968,969,1126,970,971,972,1096,1451,973,1146,974,975,1127,976,977,978,1144)
			GROUP BY intSerialZero

		INSERT @tmp_tblKeysNodeZeroLevelsMAXtime (intSerialZero,dteTime)
			SELECT 
				intSerialZero,
				MAX(dteTime)
			FROM MxFixIncome.dbo.itblNodesZeroLevels (NOLOCK)
			WHERE
				dteDate = @txtDate
				AND intSerialZero IN (1450,967,1145,968,969,1126,970,971,972,1096,1451,973,1146,974,975,1127,976,977,978,1144)
			GROUP BY intSerialZero

		INSERT @tmp_tblNodeZeroLevels (intSerialZero,dteDate,dteTime,dblValue)
			SELECT
				ed.intSerialZero,
				ed.dteDate,
				et.dteTime,
				ep.dblValue
			FROM @tmp_tblKeysNodeZeroLevelsMAXdate AS ed
				INNER JOIN @tmp_tblKeysNodeZeroLevelsMAXtime AS et
					ON ed.intSerialZero = et.intSerialZero
					INNER JOIN MxFixIncome.dbo.itblNodesZeroLevels AS ep
						ON ep.intSerialZero = ed.intSerialZero
						AND ep.dtedate = ed.dtedate
						AND ep.dteTime = et.dteTime
			WHERE ep.dteDate = @txtDate

		INSERT @tmp_tblKeysNodeZeroLevelsMAXdateT1 (intSerialZero,dteDate)
			SELECT 
				intSerialZero,
				MAX(dteDate)
			FROM MxFixIncome.dbo.itblNodesZeroLevels (NOLOCK)
			WHERE
				dteDate = @txtLastDate
				AND intSerialZero IN (1450,967,1145,968,969,1126,970,971,972,1096,1451,973,1146,974,975,1127,976,977,978,1144)
			GROUP BY intSerialZero

		INSERT @tmp_tblKeysNodeZeroLevelsMAXtimeT1 (intSerialZero,dteTime)
			SELECT 
				intSerialZero,
				MAX(dteTime)
			FROM MxFixIncome.dbo.itblNodesZeroLevels (NOLOCK)
			WHERE
				dteDate = @txtLastDate
				AND intSerialZero IN (1450,967,1145,968,969,1126,970,971,972,1096,1451,973,1146,974,975,1127,976,977,978,1144)
			GROUP BY intSerialZero

		INSERT @tmp_tblNodeZeroLevelsT1 (intSerialZero,dteDate,dteTime,dblValue)
			SELECT
				ed.intSerialZero,
				ed.dteDate,
				et.dteTime,
				ep.dblValue
			FROM @tmp_tblKeysNodeZeroLevelsMAXdateT1 AS ed
				INNER JOIN @tmp_tblKeysNodeZeroLevelsMAXtimeT1 AS et
					ON ed.intSerialZero = et.intSerialZero
					INNER JOIN MxFixIncome.dbo.itblNodesZeroLevels AS ep
						ON ep.intSerialZero = ed.intSerialZero
						AND ep.dtedate = ed.dtedate
						AND ep.dteTime = et.dteTime
			WHERE ep.dteDate = @txtLastDate
 
		-- Creación de Directivas para obtener información  (No olvidar el factor,item,tvs)
		-- <SECCION 1> Tasas de Referencia
		SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'UDI')
		SET @dblT028 = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'T028')
		SET @dblUSD2 = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'USD2')

		-- <SECCION 1> Tasas de Referencia
		INSERT @tblDirectives
		 	--SELECT 1,'DATE','YYYY/MM/DD',2,5,'',NULL,NULL,NULL,NULL UNION
			SELECT 1,'IRC','IRC|UDI',4,5,'UDI:','','',NULL,NULL UNION
			SELECT 1,'IRC','IRC|UDI',5,5,@dblUDI,'','',NULL,NULL UNION
			SELECT 1,'IRC','IRC|T028',8,5,'TIIE 28:','','',NULL,NULL UNION
	 		SELECT 1,'IRC','IRC|T028',9,5,@dblT028,'','',NULL,NULL UNION
			SELECT 1,'IRC','IRC|USD2',12,5,'Dolar Spot:','','',NULL,NULL UNION
	 		SELECT 1,'IRC','IRC|USD2',13,5,@dblUSD2,'','',NULL,NULL 

		-- <SECCION 2>  Puntos Forward
		SET @intCont = 0

		DECLARE csr_Info_FWDs CURSOR FOR
			SELECT 
				LTRIM(STR(m.intTerm,5)),
				m.dblLevelBid,
				m.dblLevelAsk,
				m.dblLevel,
				c.dblRate*100,
				(c.dblRate*100) - (c1.dblRate*100)
			FROM MxFixIncome.dbo.tblMarkets AS m
				LEFT OUTER JOIN MxFixIncome.dbo.tblCurves AS c
					ON c.intterm = m.intTerm
					AND c.dteDate = m.dteDate
					AND c.txtType = 'FWD' 
					AND c.txtSubtype = 'CUX'
				LEFT OUTER JOIN MxFixIncome.dbo.tblCurves AS c1
					ON c1.intterm = m.intTerm
					AND c1.dteDate = @txtLastDate
					AND c1.txtType = 'FWD' 
					AND c1.txtSubtype = 'CUX'
           		WHERE m.dtedate = @txtDate 
						AND m.txtCode = 'PtosFWD'
           		ORDER BY m.intTerm
  
		OPEN csr_Info_FWDs
		FETCH NEXT FROM csr_Info_FWDs
		INTO
			@intTerm,
			@dblBid,
			@dblAsk,
			@dblLevel,
			@dblRate,
			@dblVar

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
	 	
			INSERT @tblDirectives
				SELECT 2,'MARKETS','PtosFWD|intTerm',1,(9 + @intCont),@intTerm,'','',NULL,NULL
	 
			INSERT @tblDirectives
				SELECT 2,'MARKETS','PtosFWD|Bid|',2,(9 + @intCont),@dblBid,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 2,'MARKETS','PtosFWD|Ask|',3,(9 + @intCont),@dblAsk,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 2,'MARKETS','PtosFWD|Level|',4,(9 + @intCont),@dblLevel,'','',NULL,NULL
	 
			INSERT @tblDirectives
				SELECT 2,'MARKETS','PtosFWD|Rate|',5,(9 + @intCont),@dblRate,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 2,'MARKETS','PtosFWD|Var|',6,(9 + @intCont),@dblVar,'','',NULL,NULL
	 
			SET @intCont = @intCont + 1
	 
			FETCH NEXT FROM csr_Info_FWDs
			INTO
				@intTerm,
				@dblBid,
				@dblAsk,
				@dblLevel,
				@dblRate,
				@dblVar

		END
	 
		CLOSE csr_Info_FWDs
		DEALLOCATE csr_Info_FWDs

		-- <SECCION 3>  IRS
		SET @intCont = 0

		DECLARE csr_Info_IRS CURSOR FOR
			SELECT 
				m.dblLevelBid,
				m.dblLevelAsk,
				c.dblRate*100,
				m.dblLevelMid,
				m1.dblLevelMid
			FROM MxFixIncome.dbo.tblMarkets AS m (NOLOCK)
				LEFT OUTER JOIN MxFixIncome.dbo.tblMarkets AS m1 (NOLOCK)
					ON m.txtCode = m1.txtCode
					AND m.intTerm = m1.intTerm
				LEFT OUTER JOIN MxFixIncome.dbo.tblCurves AS c
					ON c.intterm = m.intTerm
					AND c.dteDate = m.dteDate
					AND c.txtType = 'SWP' 
					AND c.txtSubtype = 'TI'
				LEFT OUTER JOIN MxFixIncome.dbo.tblCurves AS c1
					ON c1.intterm = m.intTerm
					AND c1.dteDate = @txtLastDate
					AND c1.txtType = 'SWP' 
					AND c1.txtSubtype = 'TI'
			WHERE m.dtedate = @txtDate 
					AND m1.dteDate = @txtLastDate
					AND m.txtCode = 'IRS'
			ORDER BY m.intterm

		OPEN csr_Info_IRS
		FETCH NEXT FROM csr_Info_IRS
		INTO
			@dblBid,
			@dblAsk,
			@dblRate, 
			@dblMid,
			@dblMid1		

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
			INSERT @tblDirectives
				SELECT 3,'MARKETS','IRS|Bid|',10,(9 + @intCont),@dblBid,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 3,'MARKETS','IRS|Ask|',11,(9 + @intCont),@dblAsk,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 3,'MARKETS','IRS|Rate|',12,(9 + @intCont),@dblRate,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 3,'MARKETS','IRS|Mid|',13,(9 + @intCont),@dblMid,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 3,'MARKETS','IRS|Mid1|',14,(9 + @intCont),@dblMid1,'','',NULL,NULL

			SET @intCont = @intCont + 1

			FETCH NEXT FROM csr_Info_IRS
			INTO
				@dblBid,
				@dblAsk,
				@dblRate, 
				@dblMid,
				@dblMid1
		END

		CLOSE csr_Info_IRS
		DEALLOCATE csr_Info_IRS

		-- <SECCION 4>  IRS Mid
		SET @dblSpreadBase = (SELECT dblLevelMid FROM MxFixIncome.dbo.tblMarkets WHERE txtCode = 'IRS' AND dteDate = @txtDate AND intTerm = 3640)

		SET @dblSpread12 = ((SELECT dblLevelMid FROM MxFixIncome.dbo.tblMarkets WHERE txtCode = 'IRS' AND dteDate = @txtDate AND intTerm = 4368) - 
							(@dblSpreadBase))

		SET @dblSpread15 = ((SELECT dblLevelMid FROM MxFixIncome.dbo.tblMarkets WHERE txtCode = 'IRS' AND dteDate = @txtDate AND intTerm = 5460) - 
							(@dblSpreadBase))

		SET @dblSpread20 = ((SELECT dblLevelMid FROM MxFixIncome.dbo.tblMarkets WHERE txtCode = 'IRS' AND dteDate = @txtDate AND intTerm = 7280) - 
							(@dblSpreadBase))

		SET @dblSpread30 = ((SELECT dblLevelMid FROM MxFixIncome.dbo.tblMarkets WHERE txtCode = 'IRS' AND dteDate = @txtDate AND intTerm = 10920) - 
							(@dblSpreadBase))

		-- <SECCION 4> Spreads
		INSERT @tblDirectives
			SELECT 4,'MARKETS','10Y - 12Y',11,27,@dblSpread12,NULL,NULL,NULL,NULL UNION
			SELECT 4,'MARKETS','10Y - 15Y',12,27,@dblSpread15,'','',NULL,NULL UNION
	 		SELECT 4,'MARKETS','10Y - 20Y',13,27,@dblSpread20,'','',NULL,NULL UNION
	 		SELECT 4,'MARKETS','10Y - 30Y',14,27,@dblSpread30,'','',NULL,NULL 

		-- <SECCION 5>  
		SET @intCont = 0

		DECLARE csr_Info_MSGYLD CURSOR FOR
			SELECT c.dblRate
			FROM MxFixIncome.dbo.tblMarkets AS m
				LEFT OUTER JOIN @tmp_tblCurve_MSGYLD AS c
				ON c.intterm = m.intTerm
				AND c.dteDate = m.dteDate
				AND c.txtType = 'MSG' 
				AND c.txtSubtype = 'YLD'
			WHERE m.txtCode = 'IRS' 
				AND m.dtedate = @txtDate

		OPEN csr_Info_MSGYLD
		FETCH NEXT FROM csr_Info_MSGYLD
		INTO
			@dblRate

		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			INSERT @tblDirectives
				SELECT 5,'MARKETS','IRS|Rate|',9,(32 + @intCont),ROUND(@dblRate*100,2),'','',NULL,NULL

			SET @intCont = @intCont + 1

			FETCH NEXT FROM csr_Info_MSGYLD
			INTO
				@dblRate
		END

		CLOSE csr_Info_MSGYLD
		DEALLOCATE csr_Info_MSGYLD

		-- <SECCION 6> CrossCUR
		SET @intCont = 0

		DECLARE csr_Info_Cross CURSOR FOR
			SELECT 
				m.dblLevelBid,
				m.dblLevelAsk,
				m.dblLevelMid,
				(m.dblLevelMid - m1.dblLevelMid)
			FROM MxFixIncome.dbo.tblMarkets AS m (NOLOCK)
				LEFT OUTER JOIN MxFixIncome.dbo.tblMarkets AS m1 (NOLOCK)
					ON m.txtCode = m1.txtCode
					AND m.intTerm = m1.intTerm
			WHERE m.dteDate = @txtDate
				  AND m1.dteDate = @txtLastDate
				  AND m.txtCode = 'CrossCUR'
			ORDER BY m.intterm

		OPEN csr_Info_Cross
		FETCH NEXT FROM csr_Info_Cross
		INTO
			@dblBid,
			@dblAsk,
			@dblMid,
			@dblMid1		

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
			INSERT @tblDirectives
				SELECT 6,'MARKETS','CrossCUR|Bid|',12,(32 + @intCont),@dblBid,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 6,'MARKETS','CrossCUR|Ask|',13,(32 + @intCont),@dblAsk,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 6,'MARKETS','CrossCUR|Mid|',14,(32 + @intCont),@dblMid,'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 6,'MARKETS','CrossCUR|Mid1|',15,(32 + @intCont),ROUND(@dblMid1,2),'','',NULL,NULL

			SET @intCont = @intCont + 1

			FETCH NEXT FROM csr_Info_Cross
			INTO
				@dblBid,
				@dblAsk,
				@dblMid,
				@dblMid1

		END

		CLOSE csr_Info_Cross
		DEALLOCATE csr_Info_Cross

		-- <SECCION 7>  Swaps Tasa Libor USD (IRSLUS)
		SET @intCont = 0

		DECLARE csr_Info_IRSLUS CURSOR FOR
			SELECT 
				i.txtSerie,
				p.dblValue,
				p1.dblValue
			FROM MxFixIncome.dbo.tblPrices AS p (NOLOCK)
				INNER JOIN MxFixIncome.dbo.tblIds AS i  (NOLOCK)
					ON p.txtId1 = i.txtId1
				INNER JOIN MxFixIncome.dbo.tblPrices AS p1 (NOLOCK)
					ON p.txtId1 = p1.txtId1
			WHERE p.dteDate = @txtDate
				AND i.txtEmisora = 'IRSLUS'
				AND p.txtLiquidation = 'MP'
				AND p.txtItem = 'PAV'
				AND p1.dteDate = @txtLastDate 
			ORDER BY CONVERT(INT,i.txtSerie)

		OPEN csr_Info_IRSLUS
		FETCH NEXT FROM csr_Info_IRSLUS
		INTO
			@Serie,
			@dblValue,
			@dblValue1
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

			INSERT @tblDirectives
				SELECT 7,'PRICES_EMISORA','IRSLUS|MP|Value',2,(49 + @intCont),ROUND(@dblValue,4),'','',NULL,NULL

			INSERT @tblDirectives
				SELECT 7,'PRICES_EMISORA','IRSLUS|MP|Value1',3,(49 + @intCont),ROUND(@dblValue1,4),'','',NULL,NULL

			SET @intCont = @intCont + 1

			FETCH NEXT FROM csr_Info_IRSLUS
			INTO
				@Serie,
				@dblValue,
				@dblValue1
		END

		CLOSE csr_Info_IRSLUS
		DEALLOCATE csr_Info_IRSLUS

	-- <SECCION 8>  UDI LIBOR
		INSERT @tblDirectives
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,49,NULL,'','',1450,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,50,NULL,'','',967,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,51,NULL,'','',1145,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,52,NULL,'','',968,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,53,NULL,'','',969,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,54,NULL,'','',1126,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,55,NULL,'','',970,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,56,NULL,'','',971,NULL UNION
			SELECT 8,'NodesZeroLevels','UDITIIE|Value',9,57,NULL,'','',972,NULL UNION 
			--SELECT 8,'NodesZeroLevels','IRSLUS|MP|Value',9,58,NULL,'','',1096,NULL

			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,49,NULL,'','',1451,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,50,NULL,'','',973,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,51,NULL,'','',1146,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,52,NULL,'','',974,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,53,NULL,'','',975,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,54,NULL,'','',1127,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,55,NULL,'','',976,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,56,NULL,'','',977,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,57,NULL,'','',978,NULL UNION
			SELECT 9,'NodesZeroLevels','UDILIBOR|Value',13,58,NULL,'','',1144,NULL

		-- T - 1
		INSERT @tblDirectives
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,49,NULL,'','',1450,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,50,NULL,'','',967,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,51,NULL,'','',1145,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,52,NULL,'','',968,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,53,NULL,'','',969,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,54,NULL,'','',1126,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,55,NULL,'','',970,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,56,NULL,'','',971,NULL UNION
			SELECT 8,'NodesZeroLevels1','UDITIIE|Value',10,57,NULL,'','',972,NULL UNION 
			--SELECT 8,'NodesZeroLevels','IRSLUS|MP|Value',9,58,NULL,'','',1096,NULL

			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,49,NULL,'','',1451,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,50,NULL,'','',973,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,51,NULL,'','',1146,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,52,NULL,'','',974,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,53,NULL,'','',975,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,54,NULL,'','',1127,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,55,NULL,'','',976,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,56,NULL,'','',977,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,57,NULL,'','',978,NULL UNION
			SELECT 9,'NodesZeroLevels1','UDILIBOR|Value',14,58,NULL,'','',1144,NULL

		UPDATE @tblDirectives SET 
				txtValue = (CASE
								WHEN node = 1450 THEN nz.dblValue 
							    WHEN node = 967 THEN nz.dblValue
							    WHEN node = 1145 THEN nz.dblValue
							    WHEN node = 968 THEN nz.dblValue
							    WHEN node = 969 THEN nz.dblValue
							    WHEN node = 1126 THEN nz.dblValue
							    WHEN node = 970 THEN nz.dblValue
							    WHEN node = 971 THEN nz.dblValue
							    WHEN node = 972 THEN nz.dblValue
							    WHEN node = 1096 THEN nz.dblValue

								WHEN node = 1451 THEN nz.dblValue 
							    WHEN node = 973 THEN nz.dblValue
							    WHEN node = 1146 THEN nz.dblValue
							    WHEN node = 974 THEN nz.dblValue
							    WHEN node = 975 THEN nz.dblValue
							    WHEN node = 1127 THEN nz.dblValue
							    WHEN node = 976 THEN nz.dblValue
							    WHEN node = 977 THEN nz.dblValue
							    WHEN node = 978 THEN nz.dblValue
							    WHEN node = 1144 THEN nz.dblValue
							ELSE 0 END)

		FROM @tblDirectives AS d
			INNER JOIN @tmp_tblNodeZeroLevels AS nz 
				ON d.node = nz.intSerialZero
		WHERE 
			d.txtSource = 'NodesZeroLevels'

		-- T - 1
		UPDATE @tblDirectives SET 
				txtValue = (CASE 
								WHEN node = 1450 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 967 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 1145 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 968 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 969 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 1126 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 970 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 971 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 972 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 1096 THEN ROUND((nz.dblValue - nz1.dblValue),2)

								WHEN node = 1451 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 973 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 1146 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 974 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 975 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 1127 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 976 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 977 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 978 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							    WHEN node = 1144 THEN ROUND((nz.dblValue - nz1.dblValue),2)
							ELSE 0 END)

		FROM @tblDirectives AS d
			INNER JOIN @tmp_tblNodeZeroLevels AS nz 
				ON d.node = nz.intSerialZero
				INNER JOIN @tmp_tblNodeZeroLevelsT1 AS nz1
					ON d.node = nz1.intSerialZero
		WHERE 
			d.txtSource = 'NodesZeroLevels1'

	SET NOCOUNT OFF

		-- Valida la información 
		IF ((SELECT count(*) FROM @tblDirectives WHERE txtValue IS NULL) > 0)

		BEGIN
			RAISERROR ('ERROR: Falta Informacion', 16, 1)
		END

		ELSE
			IF ((SELECT count(*) FROM @tblDirectives WHERE txtValue LIKE '%-999%') > 0)

			BEGIN
				RAISERROR ('ERROR: Falta Informacion', 16, 1)
			END

			ELSE
			BEGIN

				 -- regreso los limites
				 SELECT
					intSection,
					MIN(intCol) AS intMinCol,
					MAX(intCol) AS intMaxCol,
					MIN(intRow) AS intMinRow,
					MAX(intRow) AS intMaxRow
				 FROM @tblDirectives
				 GROUP BY 
					intSection
				 ORDER BY 
					intSection
		
				 -- regreso las directivas
				 SELECT
					LTRIM(STR(intSection)) AS txtSection,
					txtSource,
					txtCode,
					intCol,
					intRow,
					txtValue
				 FROM @tblDirectives
				 ORDER BY 
					intSection,
					intCol,
					intRow

		END
 END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];14    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----------------------------------------------    
-- Autor: Mike Ramírez  
-- Fecha Modificacion: 16:57 p.m 16/11/2012  
-- Descripcion Modulo 14: Se incluyen los TC  
----------------------------------------------  
CREATE  PROCEDURE [dbo].[usp_productos_PiPGenericos];14  
   @txtDate AS DATETIME ,
   @txtIndex AS CHAR(4) 
  
AS   
BEGIN  
  
    SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](8),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][CHAR](6),  
    [txtSubSector][CHAR](6),  
    [txtRamo][CHAR](6),  
    [txtSubRamo][CHAR](6),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80)  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [intSector][CHAR](6)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (txtIndex,txtId1,dblCount)  
   SELECT  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = @txtIndex   
      AND dtedate = @txtDate  
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeyIssuerSector (txtId1,intSector)  
   SELECT  
    p.txtId1,  
    o.intSector  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
   
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
   
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    NULL AS [POR],  
    pr.txtID2 AS [ID2],  
    o.intSector AS [Sector],  
    os.txtValue AS [SubSector],  
    ra.txtValue AS [Ramo],  
    sra.txtValue AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING( ic.txtName,0,80) AS [Razon Social]  
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON pr.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector AS os  
          ON pr.txtEmisora = os.txtIssuer  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo AS ra  
           ON pr.txtEmisora = ra.txtIssuer  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo AS sra  
            ON pr.txtEmisora = sra.txtIssuer  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer  
   ORDER BY pr.txtTv,pr.txtEmisora,pr.txtSerie     
  
  -- En campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = @txtDate   
   AND l.txtIndex = @txtIndex  
  GROUP BY l.txtIndex  
  
  -- Para el calculo de Porcentaje  
  UPDATE u  
   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
  FROM  
   @tmp_tblResultsVector AS u  
    INNER JOIN @tmp_tblUniversoIndex AS ui  
     ON u.txtId1 = ui.txtId1  
      INNER JOIN @tmp_tblPond AS p  
       ON ui.txtIndex = p.txtIndex  
  WHERE ui.txtIndex = @txtIndex  
  
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
  
   -- Valida que la información este completa  
   IF EXISTS (  
     SELECT TOP 1 *   
     FROM @tmp_tblResultsVector  
      )  
  
    BEGIN  
  
     -- Reporto Informacion  
     SELECT   
      CONVERT(CHAR(8),@txtDate,112) +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtTv))) < 4 THEN  
        RTRIM(LTRIM(txtTv)) + SUBSTRING('    ',1,4-LEN(RTRIM(LTRIM(txtTv))))  
       ELSE  
        RTRIM(LTRIM(txtTv))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtEmisora))) < 7 THEN  
        RTRIM(LTRIM(txtEmisora)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtEmisora))))  
       ELSE  
        RTRIM(LTRIM(txtEmisora))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtSerie))) < 6 THEN  
        RTRIM(LTRIM(txtSerie)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtSerie))))  
       ELSE  
        RTRIM(LTRIM(txtSerie))  
      END +  
  
      CASE   
       WHEN dblPMO IS NULL  
        THEN '000000000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMO,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMO,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN dblPMOP IS NULL  
        THEN '000000000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMOP,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMOP,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCurrency))) < 3 THEN  
        '*******'  
       ELSE  
        RTRIM(LTRIM(txtCurrency))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCountry))) < 2 THEN  
        RTRIM(LTRIM(txtCountry)) + SUBSTRING('  ',1,2-LEN(RTRIM(LTRIM(txtCountry))))  
       ELSE  
        RTRIM(LTRIM(txtCountry))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIndex))) < 7 THEN  
        RTRIM(LTRIM(txtIndex)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtIndex))))  
       ELSE  
        RTRIM(LTRIM(txtIndex))  
      END +  
  
      CASE   
       WHEN dblPOR IS NULL  
        THEN '0000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPOR,6),11,6),' ','0'),1,4) + SUBSTRING(STR(ROUND(dblPOR,6),11,6),6,11)  
      END +  
  
      RTRIM(txtID2) +  
  
      CASE   
       WHEN txtSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtBCT IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtBCT)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtBCT))))  
      END +  
  
      CASE   
       WHEN txtVCT IS NULL  
        THEN '0000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(txtVCT,2),11,2),' ','0'),1,8) + SUBSTRING(STR(ROUND(txtVCT,2),11,2),10,11)  
      END +  
  
      CASE   
       WHEN txtID7 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID7)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID7))))  
      END +  
  
      CASE   
       WHEN txtID6 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID6)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID6))))  
      END +  
  
      CASE   
       WHEN txtID3 IS NULL THEN '         '  
       ELSE  
        RTRIM(LTRIM(txtID3)) + SUBSTRING('         ',1,9-LEN(RTRIM(LTRIM(txtID3))))  
      END +  
  
      CASE   
       WHEN txtID4 IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtID4)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtID4))))  
      END +   
  
      CASE   
       WHEN txtRZ IS NULL  
        THEN '                                                                                '  
       ELSE  
        RTRIM(LTRIM(txtRZ)) + SUBSTRING('                                                                                ',1,80-LEN(RTRIM(LTRIM(txtRZ))))  
      END  
  
     FROM @tmp_tblResultsVector  
  
     UNION  
  
     -- Agregamos TC  
     SELECT  
      CONVERT(CHAR(8),@txtDate,112)+  
   
      '*C  ' +    
      'MXP' +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 4 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('       ',1,4-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 6 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
    
      '00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'   
  
    FROM @tmp_tblTC      
  
    END  
  
  
   ELSE  
     RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
 SET NOCOUNT OFF  
  
END  
  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];15    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------
-- Autor:	Mike Ramírez
-- Fecha Creacion:	16:55 p.m.	2012-07-20
-- Descripcion:	Procedimiento que genera el Archivo Vector_Emisoras_Paralelo[yyyymmdd].xls
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];15
	@txtDate AS DATETIME	   
    
AS       
BEGIN       

	SET NOCOUNT ON	

		-- creo tabla de Resultados
		DECLARE @tmpLayoutxlPIP TABLE (
				[Orden]	INT,
				[SheetName]	VARCHAR(50),
				[FirstCol]	FLOAT,
				[FirstRow]	FLOAT, 
				[Label01]	VARCHAR(500),
				[Label02]	VARCHAR(500),
				[Label03]	VARCHAR(500),
				[Label04]	VARCHAR(500),
				[Label05]	VARCHAR(500),
				[Label06]	VARCHAR(500),
				[Label07]	VARCHAR(500),
				[Label08]	VARCHAR(500),
				[Label09]	VARCHAR(500),
				[Label10]	VARCHAR(500),
				[Label11]	VARCHAR(500),
				[Label12]	VARCHAR(500),
				[Label13]	VARCHAR(500),
				[Label14]	VARCHAR(500),
				[Label15]	VARCHAR(500),
				[Label16]	VARCHAR(500),
				[Label17]	VARCHAR(500),
				[Label18]	VARCHAR(500),
				[Label19]	VARCHAR(500),
				[Label20]	VARCHAR(500),
				[Label21]	VARCHAR(500),
				[Label22]	VARCHAR(500),
				[Label23]	VARCHAR(500),
				[Label24]	VARCHAR(500),
				[Label25]	VARCHAR(500),
				[Label26]	VARCHAR(500),
				[Label27]	VARCHAR(500),
				[Label28]	VARCHAR(500),
				[Label29]	VARCHAR(500),
				[Label30]	VARCHAR(500),
				[Label31]	VARCHAR(500),
				[Label32]	VARCHAR(500),
				[Label33]	VARCHAR(500),
				[Label34]	VARCHAR(500),
				[Label35]	VARCHAR(500),
				[Label36]	VARCHAR(500),
				[Label37]	VARCHAR(500),
				[Label38]	VARCHAR(500),
				[Label39]	VARCHAR(500),
				[Label40]	VARCHAR(500),
				[Label41]	VARCHAR(500),
				[Label42]	VARCHAR(500),
				[Label43]	VARCHAR(500),
				[Label44]	VARCHAR(500),
				[Label45]	VARCHAR(500),
				[Label46]	VARCHAR(500),
				[Label47]	VARCHAR(500),
				[Label48]	VARCHAR(500),
				[Label49]	VARCHAR(500)
			)

		DECLARE @tmp_tblRattingsIssuers TABLE (
				dteDateAdd	datetime,
				txtIssuerName	varchar(400),
				txtDate	varchar(10),
				txtRate	varchar(50),
				txtVEEItem	varchar(10),
				txtVectorType varchar(3)
				PRIMARY KEY (dteDateAdd,txtIssuerName,txtDate,txtRate,txtVEEItem,txtVectorType)
			)

		DECLARE @tmp_tblKEYRattingsIssuers_1 TABLE	(
				txtIssuerName	varchar(400),
				txtVEEItem	varchar(10),
				txtDate	varchar(10)
				PRIMARY KEY (txtIssuerName, txtVEEItem, txtDate)
			)

		DECLARE @tmp_tblKEYRattingsIssuers_2 TABLE (
				txtIssuerName	varchar(400),
				txtDate	varchar(10),
				txtVEEItem	varchar(10),
				dteDateAdd	datetime
				PRIMARY KEY (txtIssuerName,txtDate,txtVEEItem,dteDateAdd)
			)

		-- Obtengo universo a procesar
		INSERT @tmp_tblRattingsIssuers (dteDateAdd,txtIssuerName,txtDate,txtRate,txtVEEItem,txtVectorType)
			SELECT 
				dteDateAdd,
				RTRIM(txtIssuerName),
				CONVERT(CHAR(8),CAST(txtDate AS DATETIME),112),
				RTRIM(txtRate),
				RTRIM(txtVEEItem),
				RTRIM(txtVectorType)
			FROM MxFixincome.dbo.tblRattingsIssuers (NOLOCK)

		DELETE FROM @tmp_tblRattingsIssuers 
		WHERE txtVEEItem NOT IN ('SPQ_LN','SPQ_SN','SPQ_LGL','SPQ_SGL','SPQ_LGE','SPQ_SGE','DPQ_LN','DPQ_SN','DPQ_LGL','DPQ_SGL','DPQ_LGE','DPQ_SGE','FIQ_LN','FIQ_SN','FIQ_LGL','FIQ_SGL','FIQ_LGE','FIQ_SGE','HRQ_LN','HRQ_SN') OR txtVectorType = 'N/A'

		-- Optimizacion del proceso
		-- Obtengo las LLAVES
		INSERT @tmp_tblKEYRattingsIssuers_1 (txtIssuerName,txtVEEItem,txtDate)
			SELECT 
				txtIssuerName,
				txtVEEItem,
				MAX(txtDate) 
			FROM @tmp_tblRattingsIssuers
			GROUP BY 
				txtIssuerName,
				txtVEEItem

		INSERT @tmp_tblKEYRattingsIssuers_2 (txtIssuerName,txtDate,txtVEEItem,dteDateAdd)
			SELECT 
				r.txtIssuerName,
				r.txtDate,
				r.txtVEEItem,
				MAX(dteDateAdd)
			FROM @tmp_tblRattingsIssuers AS r 
				 INNER JOIN @tmp_tblKEYRattingsIssuers_1 AS k
					ON r.txtIssuerName = k.txtIssuerName 
						AND r.txtDate = k.txtDate 
						AND r.txtVEEItem = k.txtVEEItem
			GROUP BY
				r.txtIssuerName,
				r.txtDate,
				r.txtVEEItem

		--Genero los encabezados para el Sheet 1 EEN
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			001,
			'Vector De Empresas Emisoras',
			1,
			1,
			'RAZON SOCIAL','S&P LP ESC NAC','Fecha de ultimo cambio S&P LP ESC NAC','S&P CP ESC NAC','Fecha de ultimo cambio S&P CP ESC NAC','S&P LP ESC GLOB M LOC','Fecha de ultimo cambio S&P LP ESC GLOB M LOC','S&P CP ESC GLOB M LOC','Fecha de ultimo cambio S&P CP ESC GLOB M LOC','S&P LP ESC GLOB M EXT','Fecha de ultimo cambio S&P LP ESC GLOB M EXT','S&P CP ESC GLOB M EXT','Fecha de ultimo cambio S&P CP ESC GLOB M EXT','MOODY S LP ESC NAC','Fecha de ultimo cambio MOODY S LP ESC NAC','MOODY S CP ESC NAC','Fecha de ultimo cambio MOODY S CP ESC NAC','MOODY S LP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S LP ESC GLOB M LOC','MOODY S CP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S CP ESC GLOB M LOC','MOODY S LP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S LP ESC GLOB M EXT','MOODY S CP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S CP ESC GLOB M EXT','FITCH LP ESC NAC','Fecha de ultimo cambio FITCH LP ESC NAC','FITCH CP ESC NAC','Fecha de ultimo cambio FITCH CP ESC NAC','FITCH LP ESC GLOB M LOC','Fecha de ultimo cambio FITCH LP ESC GLOB M LOC','FITCH CP ESC GLOB M LOC','Fecha de ultimo cambio FITCH CP ESC GLOB M LOC','FITCH LP ESC GLOB M EXT','Fecha de ultimo cambio FITCH LP ESC GLOB M EXT','FITCH CP ESC GLOB M EXT','Fecha de ultimo cambio FITCH CP ESC GLOB M EXT','HR RATINGS LP ESC NAC','Fecha de ultimo cambio HR RATINGS LP ESC NAC','HR RATINGS CP ESC NAC','Fecha de ultimo cambio HR RATINGS CP ESC NAC','HR RATINGS LP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M LOC','HR RATINGS CP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M LOC','HR RATINGS LP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M EXT','HR RATINGS CP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M EXT'	

	--Genero el reporte para el Sheet 1 EEN
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			002,
			'Vector De Empresas Emisoras',
			NULL,
			NULL,
			UPPER(r.txtIssuerName) AS [RAZON SOCIAL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtRate ELSE ' ' END) AS [SPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtDate ELSE ' ' END) AS [SPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtRate ELSE ' ' END) AS [SPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtDate ELSE ' ' END) AS [SPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtRate ELSE ' ' END) AS [DPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtDate ELSE ' ' END) AS [DPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtRate ELSE ' ' END) AS [DPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtDate ELSE ' ' END) AS [DPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtRate ELSE ' ' END) AS [FIQ_LN], 
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtDate ELSE ' ' END) AS [FIQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtRate ELSE ' ' END) AS [FIQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtDate ELSE ' ' END) AS [FIQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtRate ELSE ' ' END) AS [HRQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtDate ELSE ' ' END) AS [HRQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtRate ELSE ' ' END) AS [HRQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtDate ELSE ' ' END) AS [HRQ_SN_DATE],
			' ' AS [HR_LP_GLOB_LOC],
			' ' AS [HR_LP_GLOB_LOC_DATE],
			' ' AS [HR_CP_GLOB_LOC],
			' ' AS [HR_CP_GLOB_LOC_DATE],
			' ' AS [HR_LP_GLOB_EXT],
			' ' AS [HR_LP_GLOB_EXT_DATE],
			' ' AS [HR_CP_GLOB_EXT],
			' ' AS [HR_CP_GLOB_EXT_DATE]
		FROM @tmp_tblRattingsIssuers AS r 
			 INNER JOIN @tmp_tblKEYRattingsIssuers_2 AS k
				ON r.txtIssuerName = k.txtIssuerName 
				AND r.txtDate = k.txtDate 
				AND r.txtVEEItem = k.txtVEEItem 
				AND r.dteDateAdd = k.dteDateAdd
		WHERE txtVectorType = 'EEN'
		GROUP BY r.txtIssuerName

		--Genero los encabezados para el Sheet 1 EEE
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			003,
			'Vector De Empresas Extranjeras',
			1,
			1,
			'RAZON SOCIAL','S&P LP ESC NAC','Fecha de ultimo cambio S&P LP ESC NAC','S&P CP ESC NAC','Fecha de ultimo cambio S&P CP ESC NAC','S&P LP ESC GLOB M LOC','Fecha de ultimo cambio S&P LP ESC GLOB M LOC','S&P CP ESC GLOB M LOC','Fecha de ultimo cambio S&P CP ESC GLOB M LOC','S&P LP ESC GLOB M EXT','Fecha de ultimo cambio S&P LP ESC GLOB M EXT','S&P CP ESC GLOB M EXT','Fecha de ultimo cambio S&P CP ESC GLOB M EXT','MOODY S LP ESC NAC','Fecha de ultimo cambio MOODY S LP ESC NAC','MOODY S CP ESC NAC','Fecha de ultimo cambio MOODY S CP ESC NAC','MOODY S LP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S LP ESC GLOB M LOC','MOODY S CP ESC GLOB M LOC','Fecha de ultimo cambio MOODY S CP ESC GLOB M LOC','MOODY S LP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S LP ESC GLOB M EXT','MOODY S CP ESC GLOB M EXT','Fecha de ultimo cambio MOODY S CP ESC GLOB M EXT','FITCH LP ESC NAC','Fecha de ultimo cambio FITCH LP ESC NAC','FITCH CP ESC NAC','Fecha de ultimo cambio FITCH CP ESC NAC','FITCH LP ESC GLOB M LOC','Fecha de ultimo cambio FITCH LP ESC GLOB M LOC','FITCH CP ESC GLOB M LOC','Fecha de ultimo cambio FITCH CP ESC GLOB M LOC','FITCH LP ESC GLOB M EXT','Fecha de ultimo cambio FITCH LP ESC GLOB M EXT','FITCH CP ESC GLOB M EXT','Fecha de ultimo cambio FITCH CP ESC GLOB M EXT','HR RATINGS LP ESC NAC','Fecha de ultimo cambio HR RATINGS LP ESC NAC','HR RATINGS CP ESC NAC','Fecha de ultimo cambio HR RATINGS CP ESC NAC','HR RATINGS LP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M LOC','HR RATINGS CP ESC GLOB M LOC','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M LOC','HR RATINGS LP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS LP ESC GLOB M EXT','HR RATINGS CP ESC GLOB M EXT','Fecha de ultimo cambio HR RATINGS CP ESC GLOB M EXT'

		--Genero el reporte para el Sheet 2 EEE
	INSERT @tmpLayoutxlPIP (Orden,SheetName,FirstCol,FirstRow,Label01,Label02,Label03,Label04,Label05,Label06,Label07,Label08,Label09,Label10	,Label11,Label12,Label13,Label14,Label15,Label16,Label17,Label18,Label19,Label20,Label21,Label22,Label23,Label24,Label25,Label26,Label27,Label28,Label29,Label30,Label31,Label32,Label33,Label34,Label35,Label36,Label37,Label38,Label39,Label40,Label41,Label42,Label43,Label44,Label45,Label46,Label47,Label48,Label49)
		SELECT
			004,
			'Vector De Empresas Extranjeras',
			NULL,
			NULL,
			UPPER(r.txtIssuerName) AS [RAZON SOCIAL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtRate ELSE ' ' END) AS [SPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LN' THEN r.txtDate ELSE ' ' END) AS [SPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtRate ELSE ' ' END) AS [SPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SN' THEN r.txtDate ELSE ' ' END) AS [SPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [SPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'SPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [SPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtRate ELSE ' ' END) AS [DPQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LN' THEN r.txtDate ELSE ' ' END) AS [DPQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtRate ELSE ' ' END) AS [DPQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SN' THEN r.txtDate ELSE ' ' END) AS [DPQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGL' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_LGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtRate ELSE ' ' END) AS [DPQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'DPQ_SGE' THEN r.txtDate ELSE ' ' END) AS [DPQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtRate ELSE ' ' END) AS [FIQ_LN], 
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LN' THEN r.txtDate ELSE ' ' END) AS [FIQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtRate ELSE ' ' END) AS [FIQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SN' THEN r.txtDate ELSE ' ' END) AS [FIQ_SN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGL],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGL' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGL_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_LGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_LGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_LGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtRate ELSE ' ' END) AS [FIQ_SGE],
			MAX(CASE WHEN r.txtVEEItem = 'FIQ_SGE' THEN r.txtDate ELSE ' ' END) AS [FIQ_SGE_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtRate ELSE ' ' END) AS [HRQ_LN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_LN' THEN r.txtDate ELSE ' ' END) AS [HRQ_LN_DATE],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtRate ELSE ' ' END) AS [HRQ_SN],
			MAX(CASE WHEN r.txtVEEItem = 'HRQ_SN' THEN r.txtDate ELSE ' ' END) AS [HRQ_SN_DATE],
			' ' AS [HR_LP_GLOB_LOC],
			' ' AS [HR_LP_GLOB_LOC_DATE],
			' ' AS [HR_CP_GLOB_LOC],
			' ' AS [HR_CP_GLOB_LOC_DATE],
			' ' AS [HR_LP_GLOB_EXT],
			' ' AS [HR_LP_GLOB_EXT_DATE],
			' ' AS [HR_CP_GLOB_EXT],
			' ' AS [HR_CP_GLOB_EXT_DATE]
		FROM @tmp_tblRattingsIssuers AS r 
			 INNER JOIN @tmp_tblKEYRattingsIssuers_2 AS k
				ON r.txtIssuerName = k.txtIssuerName 
				AND r.txtDate = k.txtDate 
				AND r.txtVEEItem = k.txtVEEItem 
				AND r.dteDateAdd = k.dteDateAdd
		WHERE txtVectorType = 'EEE'
		GROUP BY r.txtIssuerName

	-- Reporte de Vector de Variaciones
	SELECT 
				[Orden],
				[SheetName],
				[FirstCol],
				[FirstRow], 
				Label01 AS [Label01],
				Label02 AS [Label02],
				Label03 AS [Label03],
				Label04 AS [Label04],
				Label05 AS [Label05],
				Label06 AS [Label06],
				Label07 AS [Label07],
				Label08 AS [Label08],
				Label09 AS [Label09],
				Label10 AS [Label10],
				Label11 AS [Label11],
				Label12 AS [Label12],
				Label13 AS [Label13],
				Label14 AS [Label14],
				Label15 AS [Label15],
				Label16 AS [Label16],
				Label17 AS [Label17],
				Label18 AS [Label18],
				Label19 AS [Label19],
				Label20 AS [Label20],
				Label21 AS [Label21],
				Label22 AS [Label22],
				Label23 AS [Label23],
				Label24 AS [Label24],
				Label25 AS [Label25],
				Label26 AS [Label26],
				Label27 AS [Label27],
				Label28 AS [Label28],
				Label29 AS [Label29],
				Label30 AS [Label30],
				Label31 AS [Label31],
				Label32 AS [Label32],
				Label33 AS [Label33],
				Label34 AS [Label34],
				Label35 AS [Label35],
				Label36 AS [Label36],
				Label37 AS [Label37],
				Label38 AS [Label38],
				Label39 AS [Label39],
				Label40 AS [Label40],
				Label41 AS [Label41],
				Label42 AS [Label42],
				Label43 AS [Label43],
				Label44 AS [Label44],
				Label45 AS [Label45],
				Label46 AS [Label46],
				Label47 AS [Label47],
				Label48 AS [Label48],
				Label49 AS [Label49]
	FROM @tmpLayoutxlPIP
	ORDER BY ORDEN,SHEETNAME,LABEL01

	SET NOCOUNT OFF
END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];16    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- --------------------------------------------------------------------------------------------
--  Modifico:       		Mike Ramírez
--  Fecha Modificacion:		15:52 p.m.	2012-11-22
--  Descripcion Modulo 16:  Incluir los tipos de valor BI, M, M0, S, S0, IP, IT, IS, IM, IQ, LD
-- --------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_productos_PiPGenericos];16
 	@txtDate AS DATETIME,
	@txtLiquidation AS VARCHAR(3)

AS
BEGIN

 	SET NOCOUNT ON 

	-- Tabla temporal de Keys REF_PRICES ó REFRATE
	DECLARE @tmp_tblBondsAddREFs TABLE (
		[txtId1][CHAR](11),
		[txtItem][CHAR](10),
		[dteDate][DATETIME],
		[txtIRC][CHAR](30),
		[txtValor][CHAR](30),
		[txtDur][VARCHAR](30)
		PRIMARY KEY(txtId1,txtItem,dteDate)
	)

	DECLARE @tblVector TABLE (
		[dtedate][DATETIME],
		[txtID1][VARCHAR](11),
		[txtID2][VARCHAR](12),
		[txtTV][CHAR](4),
		[txtEmisora][CHAR](7),
		[txtSerie][CHAR](6),
		[dblDTM][CHAR](5),
		[dblYTM][VARCHAR](30),
		[dblLDR][VARCHAR](30),
		[txtCTY][VARCHAR](13),
		[txtDCR][VARCHAR](50),
		[txtTIRef][VARCHAR](30),
		[txtSPQ][CHAR](12),
		[txtFIQ][CHAR](12),
		[txtDPQ][CHAR](12),
		[txtHRQ][CHAR](12),
		[txtILIQ][CHAR](2),
		[txtFIFR][CHAR](2),
		[txtIRT][VARCHAR](30),
		[txtIRTM][VARCHAR](30),
		[txtIRTA][VARCHAR](30),
		[txtIRTC][VARCHAR](30),
		[txtPSPP][VARCHAR](30),
		[txtMOC][VARCHAR](30),
		[txtSEC][VARCHAR](50),
		[txtNEM][VARCHAR](400),
		[txtRPC][VARCHAR](150),
		[txtAGC][VARCHAR](150),
		[txtQUIR][VARCHAR](15),
		[txtCALL][CHAR](2),
		[txtDMF][VARCHAR](15),
		[txtDurRef][VARCHAR](15) 
		PRIMARY KEY CLUSTERED (
			txtTV, txtEmisora, txtSerie
			)
	)

	-- Se carga el universo
	INSERT @tblVector (dteDate,txtID1,txtID2,txtTV,txtEmisora,txtSerie,dblDTM,dblYTM,dblLDR,txtCTY,txtDCR,txtTIRef,txtSPQ,txtFIQ,txtDPQ,txtHRQ,txtILIQ,txtFIFR,txtIRT,txtIRTM,txtIRTA,txtIRTC,txtPSPP,txtMOC,txtSEC,txtNEM,txtRPC,txtAGC,txtQUIR,txtCALL,txtDMF,txtDurRef)
		SELECT
			dtedate AS [dtedate],
			txtID1 AS [txtID1],
			txtID2 AS [txtID2],
			txtTV AS [txtTV],
			txtEmisora AS [txtEmisora],
			txtSerie AS [txtSerie],
			dblDTM AS [dblDTM],
			LTRIM(STR(ROUND(dblYTM,6),13,6)) AS [dblYTM],
			LTRIM(STR(ROUND(dblLDR,6),13,6)) AS [dblLDR],
			txtCTY AS [txtCTY],
			txtDCR AS [txtDCR],
			NULL,
			CASE WHEN txtSPQ = 'NA' OR txtSPQ = '-' OR txtSPQ IS NULL THEN ' ' ELSE txtSPQ END AS [txtSPQ],
			CASE WHEN txtFIQ = 'NA' OR txtFIQ = '-' OR txtFIQ IS NULL THEN ' ' ELSE txtFIQ END AS [txtFIQ],
			CASE WHEN txtDPQ = 'NA' OR txtDPQ = '-' OR txtDPQ IS NULL THEN ' ' ELSE txtDPQ END AS [txtDPQ],
			CASE WHEN txtHRQ = 'NA' OR txtHRQ = '-' OR txtHRQ IS NULL THEN ' ' ELSE	txtHRQ END AS [txtHRQ],
			CASE WHEN txtILIQ = 'NA' OR txtILIQ = '-' OR txtILIQ IS NULL THEN '0' ELSE txtILIQ END AS [txtILIQ],
			CASE WHEN txtFIFR = '1' THEN 'SI' ELSE 'NO' END  AS [txtFIFR],
			CASE WHEN txtIRT = 'NA' OR txtIRT = '-' OR txtIRT IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRT,10),13,10)) END AS [txtIRT],
			CASE WHEN txtIRTM = 'NA' OR txtIRTM = '-' OR txtIRTM IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRTM,10),13,10)) END AS [txtIRTM],
			CASE WHEN txtIRTA = 'NA' OR txtIRTA = '-' OR txtIRTA IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRTA,10),13,10)) END AS [txtIRTA],
			CASE WHEN txtIRTC = 'NA' OR txtIRTC = '-' OR txtIRTC IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRTC,10),13,10)) END AS [txtIRTC],
			CASE WHEN txtPSPP = 'NA' OR txtPSPP = '-' OR txtPSPP IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtPSPP,6),16,6)) END AS [txtPSPP],
			txtMOC AS [txtMOC],
			txtSEC AS [txtSEC],
			txtNEM AS [txtNEM],
			txtRPC AS [txtRPC],
			txtAGC AS [txtAGC],
			txtQUIR AS [txtQUIR],
			txtCALL AS [txtCALL],
			txtDMF AS [txtDMF],
			NULL
		FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) 
		WHERE txtLiquidation IN (@txtLiquidation,'MP')   
			 AND dtedate = @txtDate  
			 AND txtTv IN ('2','2P','3P','4P','71','73','75','90','91','91SP','92','93','94','95','96','97','98','F','FSP','G','BI','M','M0','S','S0','IP','IT','IS','IM','IQ','LD','J','JI','JISP','JSP','Q','QSP','PI','R1')
		ORDER BY txtTV, txtEmisora, txtSerie

		-- Cargo información de los keys de los REFs
		INSERT @tmp_tblBondsAddREFs (txtId1,txtItem,dteDate,txtIRC,txtValor,txtDur)
			SELECT 
				tadd.txtId1,
				MAX(tadd.txtItem),
				MAX(tadd.dteDate),
				MAX(''),
				MAX(''),
				MAX('')
			FROM @tblVector AS tac
				INNER JOIN MxFixIncome.dbo.tblBondsAdd tadd (NOLOCK)
					ON tac.txtId1 = tadd.txtId1
						AND tadd.txtItem IN ('REF_PRICES','REF_IRC')
						AND tadd.txtValue <> '0'
			GROUP BY tadd.txtId1

		-- Obtengo las Referencias (REF_PRICES, REF_IRC)
		UPDATE tkc
			SET tkc.txtIRC = RTRIM(i.txtValue)
		FROM 
			@tblVector AS tac
			INNER JOIN @tmp_tblBondsAddREFs AS tkc
				ON tac.txtId1 = tkc.txtId1
			INNER JOIN MxFixIncome.dbo.tblBondsAdd AS i (NOLOCK) 
				ON i.txtId1 = tkc.txtId1
					AND i.dteDate = tkc.dteDate
					AND i.txtItem = tkc.txtItem

		-- Obtengo los valores de las Referencias (REF_IRC)
		UPDATE tkc 	
			SET txtValor = LTRIM(STR(ROUND(irc.dblValue,6),16,6)) 
		FROM 
			@tmp_tblBondsAddREFs AS tkc
				INNER JOIN MxFixIncome.dbo.tblIRC AS irc (NOLOCK)
					ON tkc.txtIRC = irc.txtIRC 
		WHERE 
				irc.dteDate = @txtDate 
				AND tkc.txtItem = 'REF_IRC'

		-- Obtengo los valores de las Referencias (REF_PRICES)
		UPDATE tkc 	
			SET txtValor = LTRIM(STR(ROUND(p.dblValue,6),16,6))
		FROM 
			@tmp_tblBondsAddREFs AS tkc
				INNER JOIN MxFixIncome.dbo.tblPrices AS p (NOLOCK)
					ON tkc.txtIRC = p.txtId1 
				INNER JOIN MxFixIncome.dbo.tblIds AS i (NOLOCK)
					ON i.txtId1 = p.txtId1 
		WHERE 
				p.dteDate = @txtDate 
				AND p.txtLiquidation = 'MD'
				AND p.txtItem = 'YTM'
				AND tkc.txtItem = 'REF_PRICES'
 
		-- Consolido los valores de las Tasas de Referencias
		UPDATE tmp
			SET txtTIRef = p.txtValor
		FROM @tblVector AS tmp
			INNER JOIN @tmp_tblBondsAddREFs AS p
				ON p.txtId1 = tmp.txtId1

		-- Consolido los valores de las Duraciones
		UPDATE tmp
			SET txtDurRef = p.txtDMF
		FROM @tblVector AS tmp
			INNER JOIN @tmp_tblBondsAddREFs AS ar
				ON ar.txtId1 = tmp.txtId1
			INNER JOIN tmp_tblUnifiedPricesReport AS p
				ON ar.txtIRC = p.txtId1
		 WHERE ar.txtItem = 'REF_PRICES'
			   AND p.txtLiquidation = 'MD'	

	   -- Eliminamos valores nulos
	   UPDATE @tblVector
	   SET txtDurRef = 'NA'
	   WHERE txtDurRef IS NULL

		-- Valida la información 
		IF EXISTS(
			SELECT TOP 1 dteDate
			FROM @tblVector
		)
		SELECT 
				CONVERT(CHAR(10), dteDate,103) AS [dteDate],
				txtID2 AS [txtID2],
				txtTV AS [txtTV],
				txtEmisora AS [txtEmisora],
				txtSerie AS [txtSerie],
				dblDTM AS [dblDTM],
				dblYTM AS [dblYTM],
				dblLDR AS [dblLDR],
				txtCTY AS [txtCTY],
				txtDCR AS [txtDCR],
				CASE WHEN txtTIRef IS NULL THEN '-' ELSE txtTIRef END AS [txtTIRef], 
				txtSPQ AS [txtSPQ],
				txtFIQ AS [txtFIQ],
				txtDPQ AS [txtDPQ],
				txtHRQ AS [txtHRQ],
				txtILIQ AS [txtILIQ],
				txtFIFR AS [txtFIFR],
				txtIRT AS [txtIRT],
				txtIRTM AS [txtIRTM],
				txtIRTA AS [txtIRTA],
				txtIRTC AS [txtIRTC],
				txtPSPP AS [txtPSPP],
				txtMOC AS [txtMOC],
				txtSEC AS [txtSEC],
				txtNEM AS [txtNEM],
				CASE WHEN txtRPC IS NULL OR txtRPC = 'NA' THEN 'No Aplica' ELSE txtRPC END AS [txtRPC],
				CASE WHEN txtAGC IS NULL OR txtAGC = 'NA' THEN 'No Aplica' ELSE txtAGC END AS [txtAGC],
				CASE WHEN txtQUIR IS NULL OR txtQUIR = 'NA' THEN 'No Aplica' ELSE txtQUIR END AS [txtQUIR],
				CASE WHEN txtCALL IS NULL OR txtCALL = 'NA' THEN 'No Aplica' ELSE txtCALL END AS [txtCALL],
				CASE WHEN txtDMF IS NULL OR txtDMF = 'NA' THEN 'No Aplica' ELSE txtDMF END AS [txtDMF],
				CASE WHEN txtDurRef IS NULL OR txtDurRef = 'NA' THEN 'No Aplica' ELSE txtDurRef END AS [txtDurRef]
		FROM @tblVector
		ORDER BY txtTV, txtEmisora, txtSerie

		ELSE
				RAISERROR ('ERROR: Falta Informacion', 16, 1)

	SET NOCOUNT OFF 

END

GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];17    Script Date: 10/27/2014 14:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-----------------------------------------------------------------------     
-- Autor:     Mike Ramírez    
-- Fecha Creacion:   11:53 2013/03/07    
-- Descripcion Modulo 17: Se modifica el càlculo del campo porcentaje    
-----------------------------------------------------------------------     
CREATE    PROCEDURE [dbo].[usp_productos_PiPGenericos];17    
    --DECLARE
     @txtDate AS DATETIME  
    --= '20140804'  
    
AS     
BEGIN    
 SET NOCOUNT ON    
    
  -- Tabla de Resultados    
  DECLARE @tmp_tblResultsVector TABLE (    
    [dteDate][CHAR](10),    
     [txtId1][CHAR](11),    
    [txtTv][CHAR](4),    
    [txtEmisora][CHAR](7),    
    [txtSerie][CHAR](6),    
    [dblPMO][FLOAT],    
    [dblPMOP][FLOAT],    
    [txtCurrency][CHAR](7),    
    [txtCountry][CHAR](2),    
    [txtIndex][CHAR](7),    
    [dblPOR][FLOAT],    
    [txtID2][CHAR](12),    
    [txtSector][VARCHAR](150),    
    [txtSubSector][VARCHAR](150),    
    [txtRamo][VARCHAR](150),    
    [txtSubRamo][VARCHAR](150),    
    [txtBCT][VARCHAR](25),    
    [txtVCT][VARCHAR](25),    
    [txtID7][VARCHAR](25),    
    [txtID6][VARCHAR](25),    
    [txtID3][VARCHAR](9),    
    [txtID4][VARCHAR](7),    
    [txtRZ][VARCHAR](80),
    [txtMEmision][VARCHAR](3),
    [txtCHQ] [VARCHAR](2),    
   PRIMARY KEY(txtId1)    
   )    
    
  -- Tabla universo portafolio    
  DECLARE @tmp_tblUniversoIndex TABLE (    
    [dteDate][DATETIME],        
    [txtIndex][CHAR](7),       
    [txtId1][CHAR](11),    
    [dblCount][FLOAT]    
   PRIMARY KEY(txtId1)    
  )    
    
  -- Tablas temporales para agilizar calculo    
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (    
    [txtId1][CHAR](11),    
    [dteDate][DATETIME]    
   PRIMARY KEY(txtId1)    
  )    
    
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (    
    [txtId1][CHAR](11),    
    [dteTime][DATETIME]    
   PRIMARY KEY(txtId1)    
  )    
    
  DECLARE @tmp_tblEquityPrices TABLE (    
    [txtId1][CHAR](11),    
    [dlbPrice][FLOAT]    
   PRIMARY KEY(txtId1)    
  )    
    
  DECLARE @tmp_tblEquityPricesInd TABLE (    
    [txtId1][CHAR](11),    
    [dteTime][DATETIME],    
    [dteDate][DATETIME],    
    [dblPrice][FLOAT]    
   PRIMARY KEY(txtId1,dteTime,dteDate)    
  )    
    
  DECLARE @tmp_tblKEYsCurrency TABLE (    
    [txtId1][CHAR](11),    
    [txtCurrency][CHAR](6)    
   PRIMARY KEY(txtId1)    
  )    
    
  -- creo tabla temporal de Keys Countries    
  DECLARE @tmp_tblKEYsCountries TABLE (    
    [txtId1][CHAR](11),    
    [dteDate][DATETIME]    
   PRIMARY KEY(txtId1)    
  )    
    
  -- creo tabla temporal de Keys Bloomberg    
  DECLARE @tmp_tblKEYsBloomberg TABLE (    
    [txtId1][CHAR](11),    
    [dteDate][DATETIME]    
   PRIMARY KEY(txtId1)    
  )    
    
  -- creo tabla temporal de Keys Reuters    
  DECLARE @tmp_tblKEYsReuters TABLE (    
    [txtId1][CHAR](11),    
    [dteDate][DATETIME]    
   PRIMARY KEY(txtId1)    
  )    
    
  -- creo tabla temporal de Keys CUSIP    
  DECLARE @tmp_tblKEYsCUSIP TABLE (    
    [txtId1][CHAR](11),    
    [dteDate][DATETIME]    
   PRIMARY KEY(txtId1)    
  )    
    
  -- creo tabla temporal de Keys SEDOL    
  DECLARE @tmp_tblKEYsSEDOL TABLE (    
    [txtId1][CHAR](11),    
    [dteDate][DATETIME]    
   PRIMARY KEY(txtId1)    
  )    
    
  -- creo tabla para la ponderacion de los indices    
  DECLARE @tmp_tblPond TABLE (      
   txtIndex CHAR(10),    
   dblPond FLOAT    
   PRIMARY KEY (txtIndex)    
  )    
    
  -- Tablas llave para obtener y consolidar maximos del item subRamo    
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10)     
   PRIMARY KEY (dteDate,txtIssuer)    
   )    
    
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10),    
    [txtValue][VARCHAR](50)     
   PRIMARY KEY (dteDate,txtIssuer)    
   )    
    
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10),    
    [txtValue][VARCHAR](50)    
   PRIMARY KEY (txtIssuer,dteDate,txtValue)    
   )    
     
  DECLARE @tmp_tblKeyIssuerSubRamo_1 TABLE (    
    [txtID1][VARCHAR](11),    
    [txtDescription][VARCHAR](150)        
   PRIMARY KEY (txtID1)    
   )    
    
  -- Tablas llave para obtener y consolidar maximos del item Ramo    
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10)     
   PRIMARY KEY (dteDate,txtIssuer)    
   )    
    
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10),    
    [txtValue][VARCHAR](50)     
   PRIMARY KEY (dteDate,txtIssuer)    
   )    
    
  DECLARE @tmp_tblKeyIssuerRamo TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10),    
    [txtValue][VARCHAR](50)    
   PRIMARY KEY (txtIssuer,dteDate,txtValue)    
   )    
    
  DECLARE @tmp_tblKeyIssuerRamo_1 TABLE (    
    [txtID1][VARCHAR](11),    
    [txtDescription][VARCHAR](150)        
   PRIMARY KEY (txtID1)    
   )    
    
  DECLARE @tmp_tblKeyIssuerSector TABLE (    
    [txtID1][VARCHAR](11),    
    [txtDescription][VARCHAR](150)        
   PRIMARY KEY (txtID1)    
   )    
    
  -- Tablas llave para obtener y consolidar maximos del item SubSector    
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10)     
   PRIMARY KEY (dteDate,txtIssuer)    
   )    
    
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10),    
    [txtValue][VARCHAR](50)     
   PRIMARY KEY (dteDate,txtIssuer)    
   )    
    
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (    
    [dteDate][DATETIME],    
    [txtIssuer][VARCHAR](10),    
    [txtValue][VARCHAR](50)    
   PRIMARY KEY (txtIssuer,dteDate,txtValue)    
   )    
    
  DECLARE @tmp_tblKeyIssuerSubSector_1 TABLE (    
    [txtID1][VARCHAR](11),    
    [txtDescription][VARCHAR](150)        
   PRIMARY KEY (txtID1)    
   )    
    
  -- Tablas llave para consolidar los máximos para txtBCT    
  DECLARE @tmp_tblKeyItemMDO TABLE (    
    [txtID1][VARCHAR](11),    
    [dteDate][DATETIME],    
    [txtValue][VARCHAR](50)              
   PRIMARY KEY (txtID1)    
   )    
    
  -- Tablas llave para consolidar los máximos Date    
  DECLARE @tmp_tblKeyItemMDODate TABLE (    
    [txtID1][VARCHAR](11),    
    [dteDate][DATETIME]         
   PRIMARY KEY (txtID1)    
   )    
    
  -- Creo tabla para obtener los maximos de los IRC    
  DECLARE @tmp_tblTCMax TABLE (    
    [txtIRC][CHAR](7),    
    [dteDate][DATETIME]    
   PRIMARY KEY (txtIRC)    
    )    
  -- Creo tabla para consolidar los IRC    
  DECLARE @tmp_tblTC TABLE (    
    [txtIRC][CHAR](7),    
    [dteDate][DATETIME],    
    [dblValue][FLOAT]      
   PRIMARY KEY (txtIRC,dteDate)    
    )    
    
  -- Obtenemos las fechas maximas de los IRC    
  INSERT @tmp_tblTCMax (txtIRC,dteDate)    
   SELECT     
    txtIRC,    
    MAX(dteDate)     
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)    
    WHERE txtIRC IN ('AUD',        
        'CAD',        
        'CHF',        
        'DKK',        
        'EUR',        
        'GBP',        
        'HKD',        
        'ILS',        
        'JPY',        
        'NOK',        
        'NZD',        
        'SEK',        
        'SGD',    
        'UFXU')       
    GROUP BY txtIRC     
    
  -- Consolidamos los TC    
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)    
   SELECT     
     m.txtIRC,    
     m.dteDate,    
     i.dblValue    
   FROM @tmp_tblTCMax AS m    
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)    
     ON m.txtIRC = i.txtIRC    
     AND m.dteDate = i.dteDate    
    
  -- Construir universo    
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)    
   SELECT    
    dteDate,    
    txtIndex,     
    txtid1,    
    dblCount    
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)    
   WHERE txtIndex = 'MSCI'     
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI' AND dteDate <= @txtDate)     
    
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)    
   SELECT    
    dteDate,    
    txtIndex,     
    txtid1,    
    dblCount       FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)    
   WHERE txtIndex = 'MSCIPIP'    
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP' AND dteDate <= @txtDate)     
    
  -- Obtenego y consolido maximos del item subRamo    
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)    
   SELECT     
    MAX(dteDate),    
    txtIssuer     
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)    
   WHERE txtItem = 'SubRamo'    
   GROUP BY txtIssuer    
    
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)    
   SELECT    
    dteDate,     
    txtIssuer,    
    txtValue    
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)    
   WHERE txtItem = 'SubRamo'    
    
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)    
   SELECT     
    p.dteDate,    
    p.txtIssuer,    
    o.txtValue     
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p    
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o    
     ON p.dtedate = o.dtedate    
     AND p.txtIssuer = o.txtIssuer    
    
  -- Ramo    
  INSERT @tmp_tblKeyIssuerSubRamo_1 (txtId1,txtDescription)    
   SELECT    
    p.txtId1,    
    i.txtDescription    
   FROM @tmp_tblUniversoIndex AS ui    
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)    
      ON ui.txtId1 = p.txtId1    
     INNER JOIN @tmp_tblKeyIssuerSubRamo AS o    
      ON p.txtEmisora = o.txtIssuer    
       INNER JOIN MxFixIncome.dbo.tblBMVSubRamoCatalog AS i (NOLOCK)    
        ON o.txtValue = i.intSubRamo    
    
  -- Obtenego y consolido maximos del item Ramo    
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)    
   SELECT     
    MAX(dteDate),    
    txtIssuer     
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)    
   WHERE txtItem = 'Ramo'    
   GROUP BY txtIssuer    
    
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)    
   SELECT    
    dteDate,     
    txtIssuer,    
    txtValue    
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)    
   WHERE txtItem = 'Ramo'    
     
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)    
   SELECT     
    p.dteDate,    
    p.txtIssuer,    
    o.txtValue    
   FROM @tmp_tblKeyIssuerMaxRamo AS p    
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o    
     ON p.dtedate = o.dtedate    
     AND p.txtIssuer = o.txtIssuer    
    
  -- Ramo    
  INSERT @tmp_tblKeyIssuerRamo_1 (txtId1,txtDescription)    
   SELECT    
    p.txtId1,    
    i.txtDescription    
   FROM @tmp_tblUniversoIndex AS ui    
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)    
      ON ui.txtId1 = p.txtId1    
     INNER JOIN @tmp_tblKeyIssuerRamo AS o    
      ON p.txtEmisora = o.txtIssuer    
       INNER JOIN MxFixIncome.dbo.tblBMVRamoCatalog AS i (NOLOCK)    
        ON o.txtValue = i.intRamo    
     
  INSERT @tmp_tblKeyIssuerSector (txtId1,txtDescription)    
   SELECT    
    p.txtId1,    
    i.txtDescription    
   FROM @tmp_tblUniversoIndex AS ui    
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)    
      ON ui.txtId1 = p.txtId1    
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)    
      ON p.txtEmisora = o.txtIssuer    
       INNER JOIN MxFixIncome.dbo.tblBMVSectorCatalog AS i (NOLOCK)    
        ON o.intSector = i.intSector    
    
  -- Obtenego y consolido maximos del item SubSector    
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)    
   SELECT     
    MAX(dteDate),    
    txtIssuer     
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)    
   WHERE txtItem = 'SubSector'    
   GROUP BY txtIssuer    
    
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)    
   SELECT    
    dteDate,     
    txtIssuer,    
    txtValue    
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)    
   WHERE txtItem = 'SubSector'    
    
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)    
   SELECT     
    p.dteDate,    
    p.txtIssuer,    
    o.txtValue    
   FROM @tmp_tblKeyIssuerMaxSubSector AS p    
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o    
     ON p.dtedate = o.dtedate    
     AND p.txtIssuer = o.txtIssuer    
    
  -- Subsector    
  INSERT @tmp_tblKeyIssuerSubSector_1 (txtId1,txtDescription)    
   SELECT    
    p.txtId1,    
    i.txtDescription    
   FROM @tmp_tblUniversoIndex AS ui    
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)    
      ON ui.txtId1 = p.txtId1    
     INNER JOIN @tmp_tblKeyIssuerSubSector AS o    
      ON p.txtEmisora = o.txtIssuer    
       INNER JOIN MxFixIncome.dbo.tblBMVSubSectorCatalog AS i (NOLOCK)    
        ON o.txtValue = i.intSubSector    
     
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)    
   SELECT     
    e.txtId1,    
    MAX(e.dteDate)    
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE    
    e.txtOperationCode = 'S01'    
    AND e.txtSource NOT IN ('GAF','COVAF')    
   GROUP BY e.txtId1    
    
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)    
   SELECT     
    e.txtId1,    
    MAX(e.dteTime)    
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE    
    txtOperationCode = 'S01'    
    AND txtSource NOT IN ('GAF','COVAF')    
   GROUP BY e.txtId1    
    
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)    
   SELECT    
    ed.txtId1,    
    et.dteTime,    
    ed.dteDate,    
    ep.dblprice    
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed    
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et    
     ON ed.txtId1 = et.txtId1    
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)    
      ON ed.txtId1 = ep.txtId1    
      AND et.dteTime = ep.dteTime    
      AND ed.dtedate = ep.dtedate    
    
  -- Llaves para obtener los tipos de cambio    
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)    
   SELECT     
    txtid1,    
    txtCurrency    
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)    
    
  -- Llaves para obtener los maximos MDO    
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)    
   SELECT    
    txtId1,    
    MAX(dteDate)    
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)    
   WHERE txtItem = 'MDO'     
   GROUP BY txtId1    
    
  -- Llaves para obtener los maximos MDO    
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)    
   SELECT    
    i.txtId1,    
    i.dteDate,    
    e.txtValue    
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)    
    INNER JOIN @tmp_tblKeyItemMDODate AS i    
     ON e.txtId1 = i.txtId1    
     AND e.dteDate = i.dteDate    
   WHERE e.txtItem = 'MDO'    
    
  -- Consolido la informacion    
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ,txtMEmision,txtCHQ)    
   SELECT    
    @txtDate AS [dteDate],    
     pr.txtId1 AS [ID1],    
    pr.txtTv AS [TV],    
    pr.txtEmisora AS [Emisora],    
    pr.txtSerie AS [Serie],    
    e.dblPrice AS [Precio MO],    
    NULL AS [Precio MO Peso],    
    ep.txtCurrency AS [MO],    
    NULL AS [Country],    
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],    
    ip.dblCount AS [POR],    
    pr.txtID2 AS [ID2],    
    o.txtDescription AS [Sector],    
    os.txtDescription AS [SubSector],    
    ra.txtDescription AS [Ramo],    
    sra.txtDescription AS [SubRamo],    
    NULL AS [Bolsa Cotizacion],    
    ip.dblCount AS [Valores en Cartera],    
    NULL AS [Bloomberg],    
    NULL AS [Reuters],    
    NULL AS [CUSIP],    
    NULL AS [SEDOL],    
    SUBSTRING(ic.txtName ,0,80) AS [Razon Social]  ,
    ISNULL(B.CurCountry,' ') AS[txtMEmision],
    ISNULL(B.CountryHQ,' ')  AS [txtCHQ] 
   FROM @tmp_tblUniversoIndex AS ip    
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)    
      ON ip.txtId1 = pr.txtId1    
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e    
       ON ip.txtId1 = e.txtId1    
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep    
        ON ip.txtId1 = ep.txtId1    
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o    
         ON ip.txtId1 = o.txtId1    
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector_1 AS os    
          ON pr.txtId1 = os.txtId1    
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo_1 AS ra    
           ON pr.txtId1 = ra.txtId1    
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo_1 AS sra    
            ON pr.txtId1 = sra.txtId1    
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic    
             ON pr.txtEmisora = ic.txtIssuer  
               LEFT OUTER JOIN  tblMandate  as B
				ON IP.txtid1 = b.txtid1   
     
    
  -- Obtenemos el campo dblPMOP multiplico por su TC    
  UPDATE u    
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))    
  FROM    
   @tmp_tblResultsVector AS u    
    
  UPDATE rv SET dblPMOP = 0     
  FROM @tmp_tblResultsVector AS rv    
  WHERE rv.dblPMOP IS NULL     
    
  -- Cargo la ponderacion del indice a calcular    
  INSERT @tmp_tblPond (txtIndex,dblPond)    
  SELECT     
   DISTINCT(l.txtIndex),    
   SUM(l.dblcount*r.dblPMOP)    
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)    
   INNER JOIN @tmp_tblResultsVector AS r    
    ON l.txtId1 = r.txtId1    
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI')     
   AND l.txtIndex = 'MSCI'--,'MSCIPIP')    
  GROUP BY l.txtIndex    
    
  INSERT @tmp_tblPond (txtIndex,dblPond)    
  SELECT     
   DISTINCT(l.txtIndex),    
   SUM(l.dblcount*r.dblPMOP)    
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)    
   INNER JOIN @tmp_tblResultsVector AS r    
    ON l.txtId1 = r.txtId1    
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP')     
   AND l.txtIndex = 'MSCIPIP'--,'MSCIPIP')    
  GROUP BY l.txtIndex    
    
--  -- Para el calculo de Porcentaje    
--  UPDATE u    
--   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)    
--  FROM    
--   @tmp_tblResultsVector AS u    
--    INNER JOIN @tmp_tblUniversoIndex AS ui    
--     ON u.txtId1 = ui.txtId1    
--      INNER JOIN @tmp_tblPond AS p    
--       ON ui.txtIndex = p.txtIndex    
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')--= @txtIndex    
     
  -- BEG: Optimización Query: Info COUNTRY    
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)    
   SELECT     
    tadd.txtId1,    
    MAX(tadd.dteDate)    
  FROM @tmp_tblResultsVector AS tac    
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)    
    ON tac.txtId1 = tadd.txtId1    
     AND txtItem = 'COUNTRY'    
  GROUP BY tadd.txtId1    
    
  -- Obtengo el codigo del campo    
  UPDATE tac     
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)    
  FROM     
   @tmp_tblResultsVector AS tac    
   INNER JOIN @tmp_tblKEYsCountries AS tkc    
    ON tac.txtId1 = tkc.txtId1    
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)     
    ON i.txtId1 = tkc.txtId1     
     AND i.dteDate = tkc.dteDate    
     AND i.txtItem = 'COUNTRY'    
  -- END: Optimización Query: Info COUNTRY    
    
  -- BEG: Optimización Query: Info Bloomberg    
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)    
   SELECT     
    tadd.txtId1,    
    MAX(tadd.dteDate)    
   FROM @tmp_tblResultsVector AS tac    
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)    
     ON tac.txtId1 = tadd.txtId1    
      AND txtItem = 'ID7'    
   GROUP BY tadd.txtId1    
    
  -- Obtengo el codigo del Item    
  UPDATE tac     
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)    
  FROM     
   @tmp_tblResultsVector AS tac    
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc    
    ON tac.txtId1 = tkc.txtId1    
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)     
    ON i.txtId1 = tkc.txtId1     
     AND i.dteDate = tkc.dteDate    
     AND i.txtItem = 'ID7'    
  -- END: Optimización Query: Info Bloomberg    
    
  -- BEG: Optimización Query: Info Reuters    
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)    
   SELECT     
    tadd.txtId1,    
    MAX(tadd.dteDate)    
   FROM @tmp_tblResultsVector AS tac    
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)    
     ON tac.txtId1 = tadd.txtId1    
     AND txtItem = 'ID6'       GROUP BY tadd.txtId1    
    
  -- Obtengo el codigo del Item    
  UPDATE tac     
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)    
  FROM     
   @tmp_tblResultsVector AS tac    
   INNER JOIN @tmp_tblKEYsReuters AS tkc    
    ON tac.txtId1 = tkc.txtId1    
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)     
    ON i.txtId1 = tkc.txtId1     
     AND i.dteDate = tkc.dteDate    
     AND i.txtItem = 'ID6'    
  -- END: Optimización Query: Info Reuters    
    
  -- BEG: Optimización Query: Info CUSIP    
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)    
   SELECT     
    tadd.txtId1,    
    MAX(tadd.dteDate)    
   FROM @tmp_tblResultsVector AS tac    
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)    
     ON tac.txtId1 = tadd.txtId1    
     AND txtItem = 'ID3'    
  GROUP BY tadd.txtId1    
    
  -- Obtengo el codigo del Item    
  UPDATE tac     
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)    
  FROM     
   @tmp_tblResultsVector AS tac    
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc    
    ON tac.txtId1 = tkc.txtId1    
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)     
    ON i.txtId1 = tkc.txtId1     
     AND i.dteDate = tkc.dteDate    
     AND i.txtItem = 'ID3'    
  -- END: Optimización Query: Info CUSIP    
    
  -- BEG: Optimización Query: Info SEDOL    
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)    
   SELECT     
    tadd.txtId1,    
    MAX(tadd.dteDate)    
   FROM @tmp_tblResultsVector AS tac    
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)    
     ON tac.txtId1 = tadd.txtId1    
     AND txtItem = 'ID4'    
   GROUP BY tadd.txtId1    
    
  -- Obtengo el codigo del Item    
  UPDATE tac     
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)    
  FROM     
   @tmp_tblResultsVector AS tac    
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc    
    ON tac.txtId1 = tkc.txtId1    
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)     
    ON i.txtId1 = tkc.txtId1     
     AND i.dteDate = tkc.dteDate    
     AND i.txtItem = 'ID4'    
  -- END: Optimización Query: Info SEDOL    
    
  -- Obtengo el codigo del Item MDO    
  UPDATE rv     
   SET txtBCT = tkm.txtValue    
  FROM     
   @tmp_tblResultsVector AS rv    
   INNER JOIN @tmp_tblKeyItemMDO AS tkm    
    ON rv.txtId1 = tkm.txtId1    
    
  -- Agregamos TC    
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ,txtMEmision,txtCHQ)    
   SELECT    
    @txtDate AS [dteDate],    
    RTRIM(txtIRC) AS [ID1],    
    '*C' AS [TV],    
    'MXP' + CASE WHEN txtIRC = 'UFXU' THEN 'USD' ELSE RTRIM(txtIRC) END AS [Emisora],    
    CASE WHEN txtIRC = 'UFXU' THEN 'FIX' ELSE RTRIM(txtIRC) END AS [Serie],    
    dblValue AS [Precio MO],    
    dblValue AS [Precio MO Peso],    
    '' AS [MO],    
    '' AS [Country],    
    '' AS [Indexes],    
    '' AS [POR],    
    '' AS [ID2],    
    '' AS [Sector],    
    '' AS [SubSector],    
    '' AS [Ramo],    
    '' AS [SubRamo],    
    '' AS [Bolsa Cotizacion],    
    '' AS [Valores en Cartera],    
    '' AS [Bloomberg],    
    '' AS [Reuters],    
    '' AS [CUSIP],    
    '' AS [SEDOL],    
    '' AS [Razon Social],
    '' AS [txtMEmision],    
    '' AS [txtCHQ]        
  FROM @tmp_tblTC    
  ORDER BY ID1    
    
 -- Valida que la información este completa    
 IF EXISTS (    
   SELECT TOP 1 *     
   FROM @tmp_tblResultsVector    
    )    
    
  BEGIN    
    
   -- Reporto Informacion    
   SELECT     
    CONVERT(CHAR(8),@txtDate,112),    
    RTRIM(txtTv),    
    RTRIM(txtEmisora),    
    RTRIM(txtSerie),    
    CASE WHEN dblPMO IS NULL THEN '0' ELSE ROUND(dblPMO,6) END,    
    CASE WHEN dblPMOP IS NULL THEN '0' ELSE ROUND(dblPMOP,6) END,    
    CASE WHEN txtCurrency IS NULL THEN '*******' ELSE RTRIM(txtCurrency) END AS [Currency],    
    CASE WHEN txtCountry IS NULL THEN ' ' ELSE RTRIM(txtCountry) END AS [Country],    
    CASE WHEN txtIndex IS NULL THEN ' ' ELSE RTRIM(txtIndex) END AS [Index],    
    CASE WHEN dblPOR IS NULL THEN '0' ELSE ROUND(dblPOR,6) END,    
    CASE WHEN txtID2 IS NULL THEN ' ' ELSE RTRIM(txtID2) END AS [ID2],    
    CASE WHEN txtSector IS NULL THEN ' ' ELSE RTRIM(txtSector) END AS [Sector],    
    CASE WHEN txtSubSector IS NULL THEN ' ' ELSE RTRIM(txtSubSector) END AS [SubSector],    
    CASE WHEN txtRamo IS NULL THEN ' ' ELSE RTRIM(txtRamo) END AS [Ramo],    
    CASE WHEN txtSubRamo IS NULL THEN ' ' ELSE RTRIM(txtSubRamo) END AS [SubRamo],    
    CASE WHEN txtBCT IS NULL THEN ' ' ELSE RTRIM(txtBCT) END,    
    CASE WHEN txtVCT IS NULL THEN ' ' ELSE RTRIM(txtVCT) END,    
    CASE WHEN txtID7 IS NULL THEN ' ' ELSE RTRIM(txtID7) END,    
    CASE WHEN txtID6 IS NULL THEN ' ' ELSE RTRIM(txtID6) END,    
    CASE WHEN txtID3 IS NULL THEN ' ' ELSE RTRIM(txtID3) END,    
    CASE WHEN txtID4 IS NULL THEN ' ' ELSE RTRIM(txtID4) END,    
    CASE WHEN txtRZ IS NULL THEN ' ' ELSE RTRIM(txtRZ) END,
    CASE WHEN txtMEmision IS NULL THEN ' ' ELSE RTRIM(txtMEmision) END,    
    CASE WHEN txtCHQ IS NULL THEN ' ' ELSE RTRIM(txtCHQ) END    
   
   FROM @tmp_tblResultsVector    
   ORDER BY txtTv,txtEmisora,txtSerie    
    
  END    
    
 ELSE    
   RAISERROR ('ERROR: Falta Informacion', 16, 1)    
     
     
    
END  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];18    Script Date: 10/27/2014 14:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-----------------------------------------------------------------------  
-- Autor:     Mike Ramírez  
-- Fecha Creacion:   12:00 07/03/2013  
-- Descripcion Modulo 18: Se modifica el calculo del campo Porcentaje  
-----------------------------------------------------------------------   
CREATE    PROCEDURE [dbo].[usp_productos_PiPGenericos];18  
  --DECLARE 
  @txtDate AS DATETIME --= '20140804' 
  
AS   
BEGIN  
  
    SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](8),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][CHAR](6),  
    [txtSubSector][CHAR](6),  
    [txtRamo][CHAR](6),  
    [txtSubRamo][CHAR](6),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80),
    [txtMEmision][VARCHAR](3),
    [txtCHQ] [VARCHAR](2),
      
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [dteDate][DATETIME],      
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )    
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [intSector][CHAR](6)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCI'   
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPIP'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP' AND dteDate <= @txtDate)  
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeyIssuerSector (txtId1,intSector)  
   SELECT  
    p.txtId1,  
    o.intSector  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
   
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
   
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ,txtMEmision,txtCHQ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    ip.dblCount AS [POR],  
    pr.txtID2 AS [ID2],  
    o.intSector AS [Sector],  
    os.txtValue AS [SubSector],  
    ra.txtValue AS [Ramo],  
    sra.txtValue AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(ic.txtName,0,80) AS [Razon Social] , 
    ISNULL(B.CurCountry,'000') AS[txtMEmision],
    ISNULL(B.CountryHQ,'00')  AS [txtCHQ]
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON pr.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector AS os  
          ON pr.txtEmisora = os.txtIssuer  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo AS ra  
           ON pr.txtEmisora = ra.txtIssuer  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo AS sra  
            ON pr.txtEmisora = sra.txtIssuer  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer  
             	LEFT OUTER JOIN  tblMandate  as B
				ON IP.txtid1 = b.txtid1
   ORDER BY pr.txtTv,pr.txtEmisora,pr.txtSerie  
  
  -- En campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI')   
   AND l.txtIndex = 'MSCI'   
  GROUP BY l.txtIndex  
  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP')   
   AND l.txtIndex = 'MSCIPIP'   
  GROUP BY l.txtIndex  
  
--  -- Para el calculo de Porcentaje  
--  UPDATE u  
--   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
--  FROM  
--   @tmp_tblResultsVector AS u  
--    INNER JOIN @tmp_tblUniversoIndex AS ui  
--     ON u.txtId1 = ui.txtId1  
--      INNER JOIN @tmp_tblPond AS p  
--       ON ui.txtIndex = p.txtIndex  
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')   
  
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
  
   -- Valida que la información este completa  
   IF EXISTS (  
     SELECT TOP 1 *   
     FROM @tmp_tblResultsVector  
      )  
  
    BEGIN  
  
     -- Reporto Informacion  
     SELECT   
      CONVERT(CHAR(8),@txtDate,112) +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtTv))) < 4 THEN  
        RTRIM(LTRIM(txtTv)) + SUBSTRING('    ',1,4-LEN(RTRIM(LTRIM(txtTv))))  
       ELSE  
        RTRIM(LTRIM(txtTv))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtEmisora))) < 7 THEN  
        RTRIM(LTRIM(txtEmisora)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtEmisora))))  
       ELSE  
        RTRIM(LTRIM(txtEmisora))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtSerie))) < 6 THEN  
        RTRIM(LTRIM(txtSerie)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtSerie))))  
       ELSE  
        RTRIM(LTRIM(txtSerie))  
      END +  
  
      CASE   
       WHEN dblPMO IS NULL  
        THEN '000000000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMO,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMO,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN dblPMOP IS NULL  
        THEN '000000000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMOP,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMOP,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCurrency))) < 3 THEN  
        '*******'  
       ELSE  
        RTRIM(LTRIM(txtCurrency))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCountry))) < 2 THEN  
        RTRIM(LTRIM(txtCountry)) + SUBSTRING('  ',1,2-LEN(RTRIM(LTRIM(txtCountry))))  
       ELSE  
        RTRIM(LTRIM(txtCountry))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIndex))) < 7 THEN  
        RTRIM(LTRIM(txtIndex)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtIndex))))  
       ELSE  
        RTRIM(LTRIM(txtIndex))  
      END +  
  
      CASE   
       WHEN dblPOR IS NULL  
        THEN '0000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPOR,6),11,6),' ','0'),1,4) + SUBSTRING(STR(ROUND(dblPOR,6),11,6),6,11)  
      END +  
  
      RTRIM(txtID2) +  
  
      CASE   
       WHEN txtSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtBCT IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtBCT)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtBCT))))  
      END +  
  
      CASE   
       WHEN txtVCT IS NULL  
        THEN '0000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(txtVCT,2),11,2),' ','0'),1,8) + SUBSTRING(STR(ROUND(txtVCT,2),11,2),10,11)  
      END +  
  
      CASE   
       WHEN txtID7 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID7)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID7))))  
      END +  
  
      CASE   
       WHEN txtID6 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID6)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID6))))  
      END +  
  
      CASE   
       WHEN txtID3 IS NULL THEN '         '  
       ELSE  
        RTRIM(LTRIM(txtID3)) + SUBSTRING('         ',1,9-LEN(RTRIM(LTRIM(txtID3))))  
      END +  
  
      CASE   
       WHEN txtID4 IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtID4)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtID4))))  
      END +   
  
      CASE   
       WHEN txtRZ IS NULL  
        THEN '                                                                                '  
       ELSE  
        RTRIM(LTRIM(txtRZ)) + SUBSTRING('                                                                                ',1,80-LEN(RTRIM(LTRIM(txtRZ))))  
      END  +
      txtMEmision + txtCHQ
      
      

      
  
     FROM @tmp_tblResultsVector  
  
     UNION  
  
     -- Agregamos TC  
     SELECT  
      CONVERT(CHAR(8),@txtDate,112)+  
   
      '*C  ' +    
      'MXP' +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 4 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('       ',1,4-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 6 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
    
      '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'   
  
    FROM @tmp_tblTC      
  
    END  
  
   ELSE  
     RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
 SET NOCOUNT OFF  
  
END  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];19    Script Date: 10/27/2014 14:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------  
-- Autor:     Mike Ramírez  
-- Fecha Modificacion:  10:00 a.m 05/12/2013  
-- Descripcion Modulo 19:  
--------------------------------------------------  
CREATE  PROCEDURE [dbo].[usp_productos_PiPGenericos];19  
  @txtDate AS DATETIME  
  
AS   
BEGIN  
    SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](8),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][CHAR](6),  
    [txtSubSector][CHAR](6),  
    [txtRamo][CHAR](6),  
    [txtSubRamo][CHAR](6),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80),
    [txtMEmision][VARCHAR](3),
    [txtCHQ] [VARCHAR](2),  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtIndex,txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [intSector][CHAR](6)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (txtIndex,txtId1,dblCount)  
   SELECT  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIEU'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (txtIndex,txtId1,dblCount)  
   SELECT  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPE'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE' AND dteDate <= @txtDate)   
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeyIssuerSector (txtId1,intSector)  
   SELECT  
    p.txtId1,  
    o.intSector  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
   
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
   
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ,txtMEmision,txtCHQ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    NULL AS [POR],  
    pr.txtID2 AS [ID2],  
    o.intSector AS [Sector],  
    os.txtValue AS [SubSector],  
    ra.txtValue AS [Ramo],  
    sra.txtValue AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(ic.txtName,0,80) AS [Razon Social] , 
    ISNULL(B.CurCountry,'000') AS[txtMEmision],
    ISNULL(B.CountryHQ,'00')  AS [txtCHQ]
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON pr.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector AS os  
          ON pr.txtEmisora = os.txtIssuer  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo AS ra  
           ON pr.txtEmisora = ra.txtIssuer  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo AS sra  
            ON pr.txtEmisora = sra.txtIssuer  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer  
               LEFT OUTER JOIN  tblMandate  as B
			    ON IP.txtid1 = b.txtid1
   ORDER BY pr.txtTv,pr.txtEmisora,pr.txtSerie     
  
  -- En campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU')   
   AND l.txtIndex = 'MSCIEU'  
  GROUP BY l.txtIndex  
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE')   
   AND l.txtIndex = 'MSCIPE'  
  GROUP BY l.txtIndex  
    
  ---- Para el calculo de Porcentaje  
  --UPDATE u  
  -- SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
  --FROM  
  -- @tmp_tblResultsVector AS u  
  --  INNER JOIN @tmp_tblUniversoIndex AS ui  
  --   ON u.txtId1 = ui.txtId1  
  --    INNER JOIN @tmp_tblPond AS p  
  --     ON ui.txtIndex = p.txtIndex  
  --WHERE ui.txtIndex = @txtIndex  
  
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
  
   -- Valida que la información este completa  
   IF EXISTS (  
     SELECT TOP 1 *   
     FROM @tmp_tblResultsVector  
      )  
  
    BEGIN  
  
     -- Reporto Informacion  
     SELECT   
      CONVERT(CHAR(8),@txtDate,112) +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtTv))) < 4 THEN  
        RTRIM(LTRIM(txtTv)) + SUBSTRING('    ',1,4-LEN(RTRIM(LTRIM(txtTv))))  
       ELSE  
        RTRIM(LTRIM(txtTv))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtEmisora))) < 7 THEN  
        RTRIM(LTRIM(txtEmisora)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtEmisora))))  
       ELSE  
        RTRIM(LTRIM(txtEmisora))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtSerie))) < 6 THEN  
        RTRIM(LTRIM(txtSerie)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtSerie))))  
       ELSE  
        RTRIM(LTRIM(txtSerie))  
      END +  
  
      CASE   
       WHEN dblPMO IS NULL  
        THEN '000000000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMO,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMO,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN dblPMOP IS NULL  
        THEN '000000000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMOP,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMOP,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCurrency))) < 3 THEN  
        '*******'  
       ELSE  
        RTRIM(LTRIM(txtCurrency))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCountry))) < 2 THEN  
        RTRIM(LTRIM(txtCountry)) + SUBSTRING('  ',1,2-LEN(RTRIM(LTRIM(txtCountry))))  
       ELSE  
        RTRIM(LTRIM(txtCountry))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIndex))) < 7 THEN  
        RTRIM(LTRIM(txtIndex)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtIndex))))  
       ELSE  
        RTRIM(LTRIM(txtIndex))  
      END +  
  
      CASE   
       WHEN dblPOR IS NULL  
        THEN '0000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPOR,6),11,6),' ','0'),1,4) + SUBSTRING(STR(ROUND(dblPOR,6),11,6),6,11)  
      END +  
  
      RTRIM(txtID2) +  
  
      CASE   
       WHEN txtSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtBCT IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtBCT)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtBCT))))  
      END +  
  
      CASE   
       WHEN txtVCT IS NULL  
        THEN '0000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(txtVCT,2),11,2),' ','0'),1,8) + SUBSTRING(STR(ROUND(txtVCT,2),11,2),10,11)  
      END +  
  
      CASE   
       WHEN txtID7 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID7)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID7))))  
      END +  
  
      CASE   
       WHEN txtID6 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID6)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID6))))  
      END +  
  
      CASE   
       WHEN txtID3 IS NULL THEN '         '  
       ELSE  
        RTRIM(LTRIM(txtID3)) + SUBSTRING('         ',1,9-LEN(RTRIM(LTRIM(txtID3))))  
      END +  
  
      CASE   
       WHEN txtID4 IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtID4)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtID4))))  
      END +   
  
      CASE   
       WHEN txtRZ IS NULL  
        THEN '                                                                                '  
       ELSE  
        RTRIM(LTRIM(txtRZ)) + SUBSTRING('                                                                                ',1,80-LEN(RTRIM(LTRIM(txtRZ))))  
      END  +
      txtMEmision + txtCHQ
  
     FROM @tmp_tblResultsVector  
  
     UNION  
  
     -- Agregamos TC  
     SELECT  
      CONVERT(CHAR(8),@txtDate,112)+  
   
      '*C  ' +    
      'MXP' +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 4 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('       ',1,4-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 6 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
    
      '0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'   
  
  
    FROM @tmp_tblTC      
  
    END  
  
   ELSE  
     RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
 SET NOCOUNT OFF  
  
END  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];20    Script Date: 10/27/2014 14:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-----------------------------------------------------------------------   
-- Autor:     Mike Ramírez  
-- Fecha Creacion:   10:05 2013/12/05  
-- Descripcion Modulo 20:   
-----------------------------------------------------------------------   
	CREATE  PROCEDURE [dbo].[usp_productos_PiPGenericos];20  
   @txtDate AS DATETIME   
  
AS   
BEGIN  
  SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](10),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][VARCHAR](150),  
    [txtSubSector][VARCHAR](150),  
    [txtRamo][VARCHAR](150),  
    [txtSubRamo][VARCHAR](150),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80) ,
    [txtMEmision][VARCHAR](3),
    [txtCHQ] [VARCHAR](2),   
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [dteDate][DATETIME],      
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  DECLARE @tmp_tblKeyIssuerSubRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIEU'   
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPE'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE' AND dteDate <= @txtDate)   
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerSubRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubRamo  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intRamo  
   
  INSERT @tmp_tblKeyIssuerSector (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSectorCatalog AS i (NOLOCK)  
        ON o.intSector = i.intSector  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Subsector  
  INSERT @tmp_tblKeyIssuerSubSector_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubSector AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubSectorCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubSector  
   
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
  
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
  
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ,txtMEmision,txtCHQ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    ip.dblCount AS [POR],  
    pr.txtID2 AS [ID2],  
    o.txtDescription AS [Sector],  
    os.txtDescription AS [SubSector],  
    ra.txtDescription AS [Ramo],  
    sra.txtDescription AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(ic.txtName ,0,80) AS [Razon Social]  ,
    ISNULL(B.CurCountry,' ') AS[txtMEmision],
    ISNULL(B.CountryHQ,' ')  AS [txtCHQ]   
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON ip.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector_1 AS os  
          ON pr.txtId1 = os.txtId1  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo_1 AS ra  
           ON pr.txtId1 = ra.txtId1  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo_1 AS sra  
            ON pr.txtId1 = sra.txtId1  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer   
              LEFT OUTER JOIN  tblMandate  as B
				ON IP.txtid1 = b.txtid1   
   
  
  -- Obtenemos el campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU')   
   AND l.txtIndex = 'MSCIEU'--,'MSCIPIP')  
  GROUP BY l.txtIndex  
  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE')   
   AND l.txtIndex = 'MSCIPE'--,'MSCIPIP')  
  GROUP BY l.txtIndex  
  
--  -- Para el calculo de Porcentaje  
--  UPDATE u  
--   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
--  FROM  
--   @tmp_tblResultsVector AS u  
--    INNER JOIN @tmp_tblUniversoIndex AS ui  
--     ON u.txtId1 = ui.txtId1  
--      INNER JOIN @tmp_tblPond AS p  
--       ON ui.txtIndex = p.txtIndex  
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')--= @txtIndex  
   
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
  
  -- Agregamos TC  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ,txtMEmision,txtCHQ)  
   SELECT  
    @txtDate AS [dteDate],  
    RTRIM(txtIRC) AS [ID1],  
    '*C' AS [TV],  
    'MXP' + CASE WHEN txtIRC = 'UFXU' THEN 'USD' ELSE RTRIM(txtIRC) END AS [Emisora],  
    CASE WHEN txtIRC = 'UFXU' THEN 'FIX' ELSE RTRIM(txtIRC) END AS [Serie],  
    dblValue AS [Precio MO],  
    dblValue AS [Precio MO Peso],  
    '' AS [MO],  
    '' AS [Country],  
    '' AS [Indexes],  
    '' AS [POR],  
    '' AS [ID2],  
    '' AS [Sector],  
    '' AS [SubSector],  
    '' AS [Ramo],  
    '' AS [SubRamo],  
    '' AS [Bolsa Cotizacion],  
    '' AS [Valores en Cartera],  
    '' AS [Bloomberg],  
    '' AS [Reuters],  
    '' AS [CUSIP],  
    '' AS [SEDOL],  
    '' AS [Razon Social] ,
    '' AS [txtMEmision],  
    '' AS [txtCHQ] 
  FROM @tmp_tblTC  
  ORDER BY ID1  
  
 -- Valida que la información este completa  
 IF EXISTS (  
   SELECT TOP 1 *   
   FROM @tmp_tblResultsVector  
    )  
  
  BEGIN  
  
   -- Reporto Informacion  
   SELECT   
    CONVERT(CHAR(8),@txtDate,112),  
    RTRIM(txtTv),  
    RTRIM(txtEmisora),  
    RTRIM(txtSerie),  
    CASE WHEN dblPMO IS NULL THEN '0' ELSE ROUND(dblPMO,6) END,  
    CASE WHEN dblPMOP IS NULL THEN '0' ELSE ROUND(dblPMOP,6) END,  
    CASE WHEN txtCurrency IS NULL THEN '*******' ELSE RTRIM(txtCurrency) END AS [Currency],  
    CASE WHEN txtCountry IS NULL THEN ' ' ELSE RTRIM(txtCountry) END AS [Country],  
    CASE WHEN txtIndex IS NULL THEN ' ' ELSE RTRIM(txtIndex) END AS [Index],  
    CASE WHEN dblPOR IS NULL THEN '0' ELSE ROUND(dblPOR,6) END,  
    CASE WHEN txtID2 IS NULL THEN ' ' ELSE RTRIM(txtID2) END AS [ID2],  
    CASE WHEN txtSector IS NULL THEN ' ' ELSE RTRIM(txtSector) END AS [Sector],  
    CASE WHEN txtSubSector IS NULL THEN ' ' ELSE RTRIM(txtSubSector) END AS [SubSector],  
    CASE WHEN txtRamo IS NULL THEN ' ' ELSE RTRIM(txtRamo) END AS [Ramo],  
    CASE WHEN txtSubRamo IS NULL THEN ' ' ELSE RTRIM(txtSubRamo) END AS [SubRamo],  
    CASE WHEN txtBCT IS NULL THEN ' ' ELSE RTRIM(txtBCT) END,  
    CASE WHEN txtVCT IS NULL THEN ' ' ELSE RTRIM(txtVCT) END,  
    CASE WHEN txtID7 IS NULL THEN ' ' ELSE RTRIM(txtID7) END,  
    CASE WHEN txtID6 IS NULL THEN ' ' ELSE RTRIM(txtID6) END,  
    CASE WHEN txtID3 IS NULL THEN ' ' ELSE RTRIM(txtID3) END,  
    CASE WHEN txtID4 IS NULL THEN ' ' ELSE RTRIM(txtID4) END,  
    CASE WHEN txtRZ IS NULL THEN ' ' ELSE RTRIM(txtRZ) END,
    CASE WHEN txtMEmision IS NULL THEN ' ' ELSE RTRIM(txtMEmision) END,    
    CASE WHEN txtCHQ IS NULL THEN ' ' ELSE RTRIM(txtCHQ) END      
   FROM @tmp_tblResultsVector  
   ORDER BY txtTv,txtEmisora,txtSerie  
  
  END  
  
 ELSE  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
   
  
END  
  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];21    Script Date: 10/27/2014 14:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


------------------------------------------------------------------------------  
/* Autor:  OMAR ADRIAN ACEVES GUTIERREZ  
 Fecha:  2014-06-18 14:06:35.657  
 Objetivo: GENERAR COVAF_MANDATOS_MSCI_WORLD_PIP  
  
 Autor:      Mike Ramirez  
 Fecha Modificiacion:  2014-07-14 11:06:35.657  
 Descripción:    Se agrega un nuevo caso para la columna región   
*/  
------------------------------------------------------------------------------   
CREATE    PROCEDURE [dbo].[usp_productos_PiPGenericos];21  --'20140804'
 --DECLARE    
 @txtDate AS DATETIME   
 --= '20140624'  
  
AS   
BEGIN  
  
  
SET NOCOUNT ON  
  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](8),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][CHAR](6),  
    [txtSubSector][CHAR](6),  
    [txtRamo][CHAR](6),  
    [txtSubRamo][CHAR](6),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80)  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [dteDate][DATETIME],      
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [intSector][CHAR](6)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCI'   
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPIP'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP' AND dteDate <= @txtDate)  
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeyIssuerSector (txtId1,intSector)  
   SELECT  
    p.txtId1,  
    o.intSector  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
   
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
   
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    ip.dblCount AS [POR],  
    pr.txtID2 AS [ID2],  
    o.intSector AS [Sector],  
    os.txtValue AS [SubSector],  
    ra.txtValue AS [Ramo],  
    sra.txtValue AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(ic.txtName,0,80) AS [Razon Social]  
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON pr.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector AS os  
          ON pr.txtEmisora = os.txtIssuer  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo AS ra  
           ON pr.txtEmisora = ra.txtIssuer  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo AS sra  
            ON pr.txtEmisora = sra.txtIssuer  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer  
   ORDER BY pr.txtTv,pr.txtEmisora,pr.txtSerie  
  
  -- En campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI')   
   AND l.txtIndex = 'MSCI'   
  GROUP BY l.txtIndex  
  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP')   
   AND l.txtIndex = 'MSCIPIP'   
  GROUP BY l.txtIndex  
  
--  -- Para el calculo de Porcentaje  
--  UPDATE u  
--   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
--  FROM  
--   @tmp_tblResultsVector AS u  
--    INNER JOIN @tmp_tblUniversoIndex AS ui  
--     ON u.txtId1 = ui.txtId1  
--      INNER JOIN @tmp_tblPond AS p  
--       ON ui.txtIndex = p.txtIndex  
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')   
  
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
      
      
      
    /*informacion para conseguir txtSuperIssuer de tblIssuerscatalog */  
     DECLARE @tblUnifiedIssuer TABLE  
  (  
  txtid1 varchar(11),  
  txtSuperIssuer varchar(15)  
  )  
  INSERT INTO @tblUnifiedIssuer  
   SELECT a.txtId1,c.txtSuperIssuer   
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblIssuerscatalog  AS C  
   ON a.txtEmisora = c.txtIssuer  
  
      
  
   -- Valida que la información este completa  
   IF EXISTS (  
     SELECT TOP 1 *   
     FROM @tmp_tblResultsVector  
      )  
  
    BEGIN  
  
     -- Reporto Informacion  
     SELECT   
      CONVERT(CHAR(8),@txtDate,112) +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtTv))) < 4 THEN  
        RTRIM(LTRIM(txtTv)) + SUBSTRING('    ',1,4-LEN(RTRIM(LTRIM(txtTv))))  
       ELSE  
        RTRIM(LTRIM(txtTv))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtEmisora))) < 7 THEN  
        RTRIM(LTRIM(txtEmisora)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtEmisora))))  
       ELSE  
        RTRIM(LTRIM(txtEmisora))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtSerie))) < 6 THEN  
        RTRIM(LTRIM(txtSerie)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtSerie))))  
       ELSE  
        RTRIM(LTRIM(txtSerie))  
      END +  
  
      CASE   
       WHEN dblPMO IS NULL  
        THEN '000000000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMO,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMO,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN dblPMOP IS NULL  
        THEN '000000000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMOP,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMOP,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCurrency))) < 3 THEN  
        '*******'  
       ELSE  
        RTRIM(LTRIM(txtCurrency))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCountry))) < 2 THEN  
        RTRIM(LTRIM(txtCountry)) + SUBSTRING('  ',1,2-LEN(RTRIM(LTRIM(txtCountry))))  
       ELSE  
        RTRIM(LTRIM(txtCountry))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIndex))) < 7 THEN  
        RTRIM(LTRIM(txtIndex)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtIndex))))  
       ELSE  
        RTRIM(LTRIM(txtIndex))  
      END +  
  
      CASE   
       WHEN dblPOR IS NULL  
        THEN '0000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPOR,6),11,6),' ','0'),1,4) + SUBSTRING(STR(ROUND(dblPOR,6),11,6),6,11)  
      END +  
  
      RTRIM(txtID2) +  
  
      CASE   
       WHEN txtSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtBCT IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtBCT)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtBCT))))  
      END +  
  
      CASE   
       WHEN txtVCT IS NULL  
        THEN '0000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(txtVCT,2),11,2),' ','0'),1,8) + SUBSTRING(STR(ROUND(txtVCT,2),11,2),10,11)  
      END +  
  
      CASE   
       WHEN txtID7 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID7)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID7))))  
      END +  
  
      CASE   
       WHEN txtID6 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID6)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID6))))  
      END +  
  
      CASE   
       WHEN txtID3 IS NULL THEN '         '  
       ELSE  
        RTRIM(LTRIM(txtID3)) + SUBSTRING('         ',1,9-LEN(RTRIM(LTRIM(txtID3))))  
      END +  
  
      CASE   
       WHEN txtID4 IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtID4)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtID4))))  
      END +   
  
      CASE   
       WHEN txtRZ IS NULL  
        THEN '                                                                                '  
       ELSE  
        RTRIM(LTRIM(txtRZ)) + SUBSTRING('                                                                               ',1,80-LEN(RTRIM(LTRIM(txtRZ))))  
      END +  
     
     
    CASE WHEN  LTRIM(LTRIM(B.CurCountry)) is NULL OR LTRIM(LTRIM(B.CurCountry)) = ''   THEN '000'   
    ELSE LTRIM(RTRIM(B.CurCountry)) END +  
    CASE WHEN  LTRIM(LTRIM(B.countryHQ)) is NULL  OR LTRIM(LTRIM(B.countryHQ)) = '' THEN '00' ELSE LTRIM(RTRIM(B.countryHQ))    
    END   
      
     
    +   
      
    RTRIM( LTRIM(  
   CASE WHEN B.CountryHQ IN ('GB','GG','JE') THEN '007'  
    WHEN B.CountryHQ IN ('BM','KY') THEN '011'  
    WHEN B.CountryHQ IN ('GR','HU','PL','CZ','RU','CZ','RU') THEN '004'  
    WHEN B.CountryHQ IN ('JP') THEN '008'  
    WHEN B.CountryHQ IN ('CA') THEN '009'  
    WHEN B.CountryHQ IN ('MX') THEN '001'  
    WHEN B.CountryHQ IN ('AL','GR','DE','HU',  
    'AD','IE','AM','IS','AT','IT','BE','LU',  
    'BY','LV','BA','MK','BG','MT','CY','MD',  
    'HR','MC','DK','ME','EE','NO','FI','NL',  
    'FR','PL','SK','PT','SI','CZ','ES','RO',  
    'GE','RU','GI','SM','RS','SE','CH','UA') THEN '002'  
    WHEN B.CountryHQ IN (  
    'AF','JO','AO','KE','SA','MG','DZ','ML',  
    'BJ','MA','BW','MU','CM','MZ','BF','NA',  
    'CG','PS','CD','QA','CI','RW','EG','EH',  
    'ET','SN','GA','ZA','GM','SD','AE','SS',  
    'GH','TN','IQ','UG','IR','ZM','IL','ZW')THEN '010'  
    WHEN B.CountryHQ IN (  
    'AU','SG','BD','BH','AZ','BN','KH',  
    'CN','KR','KP','PH','FJ','HK',  
    'IN','ID','KZ','KW','LA','MO',  
    'MY','MN','MM','NP','NE','NG',  
    'NZ','PK','WS','AS','LK','SR',  
    'TH','TW','TZ','TJ','TR','UZ') THEN '003'  
      
    WHEN B.CountryHQ IN ('US') THEN '005'  
      
    ELSE  '000'  
   END ))  
     
     
   +  LTRIM(ISNULL(c.txtSuperIssuer,''))  
     +   CONVERT(VARCHAR(100),REPLICATE(' ',( 50 - LEN(ISNULL(c.txtSuperIssuer,'')))))  
       
     
     
    
     
     FROM @tmp_tblResultsVector AS A  
    LEFT OUTER JOIN  tblMandate  as B  
    ON a.txtid1 = b.txtid1  
    LEFT OUTER JOIN @tblUnifiedIssuer AS C  
    ON a.txtid1 = c.txtid1  
   
    /*uniod irc´s*/  
      
     UNION  
  
     -- Agregamos TC  
     SELECT  
      CONVERT(CHAR(8),@txtDate,112)+  
   
      '*C  ' +    
      'MXP' +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 4 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('       ',1,4-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 6 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
    
      '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'   
  
--Medio Oriente - Norte de África + 15  
    FROM @tmp_tblTC   
  
    END  
  
   ELSE  
     RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
SET NOCOUNT OFF  
END  
  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];22    Script Date: 10/27/2014 14:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------------------   
-- Autor:     OMAR ADRIAN ACEVES       
-- Fecha Creacion:   2014-06-18 14:13:32.437    
-- Descripcion Modulo 22:   CREAR PROCESO PARA COVAF_MANDATOS_MSCI_WORLD_XLS   
  
--Autor:     Mike Ramirez  
--Fecha Modificiacion:  2014-07-14 11:05:35.657  
--Descripción:    Se agrega un nuevo caso para la columna región   
--------------------------------------------------------------------------   
CREATE  PROCEDURE [dbo].[usp_productos_PiPGenericos];22  
  --DECLARE  
    @txtDate AS DATETIME  
   --= '20140618'  
AS   
BEGIN  
  
  SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](10),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][VARCHAR](150),  
    [txtSubSector][VARCHAR](150),  
    [txtRamo][VARCHAR](150),  
    [txtSubRamo][VARCHAR](150),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80)  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [dteDate][DATETIME],      
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  DECLARE @tmp_tblKeyIssuerSubRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCI'   
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPIP'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP' AND dteDate <= @txtDate)   
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerSubRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubRamo  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intRamo  
   
  INSERT @tmp_tblKeyIssuerSector (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSectorCatalog AS i (NOLOCK)  
        ON o.intSector = i.intSector  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Subsector  
  INSERT @tmp_tblKeyIssuerSubSector_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubSector AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubSectorCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubSector  
   
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
  
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
  
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    ip.dblCount AS [POR],  
    pr.txtID2 AS [ID2],  
    o.txtDescription AS [Sector],  
    os.txtDescription AS [SubSector],  
    ra.txtDescription AS [Ramo],  
    sra.txtDescription AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING( ic.txtName,0,80) AS [Razon Social]  
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON ip.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector_1 AS os  
          ON pr.txtId1 = os.txtId1  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo_1 AS ra  
           ON pr.txtId1 = ra.txtId1  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo_1 AS sra  
            ON pr.txtId1 = sra.txtId1  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer   
   
  
  -- Obtenemos el campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI')   
   AND l.txtIndex = 'MSCI'--,'MSCIPIP')  
  GROUP BY l.txtIndex  
  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP')   
   AND l.txtIndex = 'MSCIPIP'--,'MSCIPIP')  
  GROUP BY l.txtIndex  
  
--  -- Para el calculo de Porcentaje  
--  UPDATE u  
--   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
--  FROM  
--   @tmp_tblResultsVector AS u  
--    INNER JOIN @tmp_tblUniversoIndex AS ui  
--     ON u.txtId1 = ui.txtId1  
--      INNER JOIN @tmp_tblPond AS p  
--       ON ui.txtIndex = p.txtIndex  
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')--= @txtIndex  
   
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
  
  -- Agregamos TC  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
    RTRIM(txtIRC) AS [ID1],  
    '*C' AS [TV],  
    'MXP' + CASE WHEN txtIRC = 'UFXU' THEN 'USD' ELSE RTRIM(txtIRC) END AS [Emisora],  
    CASE WHEN txtIRC = 'UFXU' THEN 'FIX' ELSE RTRIM(txtIRC) END AS [Serie],  
    dblValue AS [Precio MO],  
    dblValue AS [Precio MO Peso],  
    '' AS [MO],  
    '' AS [Country],  
    '' AS [Indexes],  
    '' AS [POR],  
    '' AS [ID2],  
    '' AS [Sector],  
    '' AS [SubSector],  
    '' AS [Ramo],  
    '' AS [SubRamo],  
    '' AS [Bolsa Cotizacion],  
    '' AS [Valores en Cartera],  
    '' AS [Bloomberg],  
    '' AS [Reuters],  
    '' AS [CUSIP],  
    '' AS [SEDOL],  
    '' AS [Razon Social]  
  FROM @tmp_tblTC  
  ORDER BY ID1  
    
    
  /*informacion para conseguir txtSuperIssuer de tblIssuerscatalog */  
     DECLARE @tblUnifiedIssuer TABLE  
  (  
  txtid1 varchar(11),  
  txtSuperIssuer varchar(15)  
  )  
  INSERT INTO @tblUnifiedIssuer  
   SELECT a.txtId1,c.txtSuperIssuer   
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblIssuerscatalog  AS C  
   ON a.txtEmisora = c.txtIssuer  
  
  
 -- Valida que la información este completa  
 IF EXISTS (  
   SELECT TOP 1 *   
   FROM @tmp_tblResultsVector  
    )  
  
  
  
  BEGIN  
  
   -- Reporto Informacion  
   SELECT   
    CONVERT(CHAR(8),@txtDate,112),  
    RTRIM(txtTv),  
    RTRIM(txtEmisora),  
    RTRIM(txtSerie),  
    CASE WHEN dblPMO IS NULL THEN '0' ELSE ROUND(dblPMO,6) END,  
    CASE WHEN dblPMOP IS NULL THEN '0' ELSE ROUND(dblPMOP,6) END,  
    CASE WHEN txtCurrency IS NULL THEN '*******' ELSE RTRIM(txtCurrency) END AS [Currency],  
    CASE WHEN txtCountry IS NULL THEN ' ' ELSE RTRIM(txtCountry) END AS [Country],  
    CASE WHEN txtIndex IS NULL THEN ' ' ELSE RTRIM(txtIndex) END AS [Index],  
    CASE WHEN dblPOR IS NULL THEN '0' ELSE ROUND(dblPOR,6) END,  
    CASE WHEN txtID2 IS NULL THEN ' ' ELSE RTRIM(txtID2) END AS [ID2],  
    CASE WHEN txtSector IS NULL THEN ' ' ELSE RTRIM(txtSector) END AS [Sector],  
    CASE WHEN txtSubSector IS NULL THEN ' ' ELSE RTRIM(txtSubSector) END AS [SubSector],  
    CASE WHEN txtRamo IS NULL THEN ' ' ELSE RTRIM(txtRamo) END AS [Ramo],  
    CASE WHEN txtSubRamo IS NULL THEN ' ' ELSE RTRIM(txtSubRamo) END AS [SubRamo],  
    CASE WHEN txtBCT IS NULL THEN ' ' ELSE RTRIM(txtBCT) END,  
    CASE WHEN txtVCT IS NULL THEN ' ' ELSE RTRIM(txtVCT) END,  
    CASE WHEN txtID7 IS NULL THEN ' ' ELSE RTRIM(txtID7) END,  
    CASE WHEN txtID6 IS NULL THEN ' ' ELSE RTRIM(txtID6) END,  
    CASE WHEN txtID3 IS NULL THEN ' ' ELSE RTRIM(txtID3) END,  
    CASE WHEN txtID4 IS NULL THEN ' ' ELSE RTRIM(txtID4) END,  
    CASE WHEN txtRZ IS NULL THEN ' ' ELSE RTRIM(txtRZ) END,  
    CASE WHEN  B.CurCountry is NULL THEN ' ' ELSE B.CurCountry  END ,  
    CASE WHEN  B.countryHQ is NULL THEN ' ' ELSE B.countryHQ  END ,  
      
    CASE WHEN B.CountryHQ IN ('GB','GG','JE') THEN '7'  
    WHEN B.CountryHQ IN ('BM','KY') THEN '11'  
    WHEN B.CountryHQ IN ('JP') THEN '8'  
    WHEN B.CountryHQ IN ('CA') THEN '9'  
    WHEN B.CountryHQ IN ('GR','HU','PL','CZ','RU','CZ','RU') THEN '4'  
    WHEN B.CountryHQ IN ('MX') THEN '1'  
    WHEN B.CountryHQ IN ('AL','GR','DE','HU',  
    'AD','IE','AM','IS','AT','IT','BE','LU',  
    'BY','LV','BA','MK','BG','MT','CY','MD',  
    'HR','MC','DK','ME','EE','NO','FI','NL',  
    'FR','PL','SK','PT','SI','CZ','ES','RO',  
    'GE','RU','GI','SM','RS','SE','CH','UA') THEN '2'  
    WHEN B.CountryHQ IN (  
    'AF','JO','AO','KE','SA','MG','DZ','ML',  
    'BJ','MA','BW','MU','CM','MZ','BF','NA',  
    'CG','PS','CD','QA','CI','RW','EG','EH',  
    'ET','SN','GA','ZA','GM','SD','AE','SS',  
    'GH','TN','IQ','UG','IR','ZM','IL','ZW')THEN '10'  
    WHEN B.CountryHQ IN (  
    'AU','SG','BD','BH','AZ','BN','KH',  
    'CN','KR','KP','PH','FJ','HK',  
    'IN','ID','KZ','KW','LA','MO',  
    'MY','MN','MM','NP','NE','NG',  
    'NZ','PK','WS','AS','LK','SR',  
    'TH','TW','TZ','TJ','TR','UZ') THEN '3'  
      
    WHEN B.CountryHQ IN ('US') THEN '5'  
    ELSE LTRIM(ISNULL(B.CountryHQ,'   '))  
   END ,  
   LTRIM(ISNULL(c.txtSuperIssuer,'                         '))  
     
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblMandate AS B  
   ON a.txtid1 = B.txtid1  
   LEFT OUTER JOIN @tblUnifiedIssuer AS C  
   ON a.txtid1 = c.txtid1  
   ORDER BY txtTv,txtEmisora,txtSerie  
     
  
  END  
  
 ELSE  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
   
   
  
END  
  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];23    Script Date: 10/27/2014 14:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------------------  
-- Autor:     OMAR ADRIAN ACEVES   
-- Fecha Creacion:   2014-06-18 14:57:25.133  
-- Descripcion Modulo 23: GENERAR PRODUCTO BANAMEX_MANDATOS_EUR_XLS  
  
-- Autor:     Mike Ramirez  
-- Fecha Creacion:   2014-07-14 11:14:25.133  
-- Descripcion Modulo 23: Se agrega un nuevo caso para la columna región   
--------------------------------------------------------------------------   
CREATE  PROCEDURE [dbo].[usp_productos_PiPGenericos];23   
--DECLARE    
 @txtDate AS DATETIME   
 --= '20140616'   
  
AS   
BEGIN  
  
  SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](10),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][VARCHAR](150),  
    [txtSubSector][VARCHAR](150),  
    [txtRamo][VARCHAR](150),  
    [txtSubRamo][VARCHAR](150),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80)  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [dteDate][DATETIME],      
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  DECLARE @tmp_tblKeyIssuerSubRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIEU'   
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPE'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE' AND dteDate <= @txtDate)   
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerSubRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubRamo  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intRamo  
   
  INSERT @tmp_tblKeyIssuerSector (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSectorCatalog AS i (NOLOCK)  
        ON o.intSector = i.intSector  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Subsector  
  INSERT @tmp_tblKeyIssuerSubSector_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubSector AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubSectorCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubSector  
   
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
  
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
  
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    ip.dblCount AS [POR],  
    pr.txtID2 AS [ID2],  
    o.txtDescription AS [Sector],  
    os.txtDescription AS [SubSector],  
    ra.txtDescription AS [Ramo],  
    sra.txtDescription AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(ic.txtName,0,80) AS [Razon Social]  
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON ip.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector_1 AS os  
          ON pr.txtId1 = os.txtId1  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo_1 AS ra  
           ON pr.txtId1 = ra.txtId1  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo_1 AS sra  
            ON pr.txtId1 = sra.txtId1  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer   
   
  
  -- Obtenemos el campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU')   
   AND l.txtIndex = 'MSCIEU'--,'MSCIPIP')  
  GROUP BY l.txtIndex  
  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE')   
   AND l.txtIndex = 'MSCIPE'--,'MSCIPIP')  
  GROUP BY l.txtIndex  
  
--  -- Para el calculo de Porcentaje  
--  UPDATE u  
--   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
--  FROM  
--   @tmp_tblResultsVector AS u  
--    INNER JOIN @tmp_tblUniversoIndex AS ui  
--     ON u.txtId1 = ui.txtId1  
--      INNER JOIN @tmp_tblPond AS p  
--       ON ui.txtIndex = p.txtIndex  
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')--= @txtIndex  
   
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate       AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
  
  -- Agregamos TC  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
    RTRIM(txtIRC) AS [ID1],  
    '*C' AS [TV],  
    'MXP' + CASE WHEN txtIRC = 'UFXU' THEN 'USD' ELSE RTRIM(txtIRC) END AS [Emisora],  
    CASE WHEN txtIRC = 'UFXU' THEN 'FIX' ELSE RTRIM(txtIRC) END AS [Serie],  
    dblValue AS [Precio MO],  
    dblValue AS [Precio MO Peso],  
    '' AS [MO],  
    '' AS [Country],  
    '' AS [Indexes],  
    '' AS [POR],  
    '' AS [ID2],  
    '' AS [Sector],  
    '' AS [SubSector],  
    '' AS [Ramo],  
    '' AS [SubRamo],  
    '' AS [Bolsa Cotizacion],  
    '' AS [Valores en Cartera],  
    '' AS [Bloomberg],  
    '' AS [Reuters],  
    '' AS [CUSIP],  
    '' AS [SEDOL],  
    '' AS [Razon Social]  
  FROM @tmp_tblTC  
  ORDER BY ID1  
    
    
  /*informacion para conseguir txtSuperIssuer de tblIssuerscatalog */  
     DECLARE @tblUnifiedIssuer TABLE  
  (  
  txtid1 varchar(11),  
  txtSuperIssuer varchar(15)  
  )  
  INSERT INTO @tblUnifiedIssuer  
   SELECT a.txtId1,c.txtSuperIssuer   
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblIssuerscatalog  AS C  
   ON a.txtEmisora = c.txtIssuer  
    
  --SELECT * FROM  @tmp_tblResultsVector  
  
 -- Valida que la información este completa  
 IF EXISTS (  
   SELECT TOP 1 *   
   FROM @tmp_tblResultsVector  
    )  
  
  BEGIN  
  
   -- Reporto Informacion  
   SELECT   
    CONVERT(CHAR(8),@txtDate,112),  
    RTRIM(txtTv),  
    RTRIM(txtEmisora),  
    RTRIM(txtSerie),  
    CASE WHEN dblPMO IS NULL THEN '0' ELSE ROUND(dblPMO,6) END,  
    CASE WHEN dblPMOP IS NULL THEN '0' ELSE ROUND(dblPMOP,6) END,  
    CASE WHEN txtCurrency IS NULL THEN '*******' ELSE RTRIM(txtCurrency) END AS [Currency],  
    CASE WHEN txtCountry IS NULL THEN ' ' ELSE RTRIM(txtCountry) END AS [Country],  
    CASE WHEN txtIndex IS NULL THEN ' ' ELSE RTRIM(txtIndex) END AS [Index],  
    CASE WHEN dblPOR IS NULL THEN '0' ELSE ROUND(dblPOR,6) END,  
    CASE WHEN txtID2 IS NULL THEN ' ' ELSE RTRIM(txtID2) END AS [ID2],  
    CASE WHEN txtSector IS NULL THEN ' ' ELSE RTRIM(txtSector) END AS [Sector],  
    CASE WHEN txtSubSector IS NULL THEN ' ' ELSE RTRIM(txtSubSector) END AS [SubSector],  
    CASE WHEN txtRamo IS NULL THEN ' ' ELSE RTRIM(txtRamo) END AS [Ramo],  
    CASE WHEN txtSubRamo IS NULL THEN ' ' ELSE RTRIM(txtSubRamo) END AS [SubRamo],  
    CASE WHEN txtBCT IS NULL THEN ' ' ELSE RTRIM(txtBCT) END,  
    CASE WHEN txtVCT IS NULL THEN ' ' ELSE RTRIM(txtVCT) END,  
    CASE WHEN txtID7 IS NULL THEN ' ' ELSE RTRIM(txtID7) END,  
    CASE WHEN txtID6 IS NULL THEN ' ' ELSE RTRIM(txtID6) END,  
    CASE WHEN txtID3 IS NULL THEN ' ' ELSE RTRIM(txtID3) END,  
    CASE WHEN txtID4 IS NULL THEN ' ' ELSE RTRIM(txtID4) END,  
    CASE WHEN txtRZ IS NULL THEN ' ' ELSE RTRIM(txtRZ) END,  
    CASE WHEN  B.CurCountry is NULL THEN ' ' ELSE B.CurCountry  END ,  
    CASE WHEN  B.countryHQ is NULL THEN ' ' ELSE B.countryHQ  END,   
      
     CASE WHEN B.CountryHQ IN ('GB','GG','JE') THEN '7'  
    WHEN B.CountryHQ IN ('BM','KY') THEN '11'  
    WHEN B.CountryHQ IN ('JP') THEN '8'  
    WHEN B.CountryHQ IN ('CA') THEN '9'  
    WHEN B.CountryHQ IN ('GR','HU','PL','CZ','RU','CZ','RU') THEN '4'  
    WHEN B.CountryHQ IN ('MX') THEN '1'  
    WHEN B.CountryHQ IN ('AL','GR','DE','HU',  
    'AD','IE','AM','IS','AT','IT','BE','LU',  
    'BY','LV','BA','MK','BG','MT','CY','MD',  
    'HR','MC','DK','ME','EE','NO','FI','NL',  
    'FR','PL','SK','PT','SI','CZ','ES','RO',  
    'GE','RU','GI','SM','RS','SE','CH','UA') THEN '2'  
    WHEN B.CountryHQ IN (  
    'AF','JO','AO','KE','SA','MG','DZ','ML',  
    'BJ','MA','BW','MU','CM','MZ','BF','NA',  
    'CG','PS','CD','QA','CI','RW','EG','EH',  
    'ET','SN','GA','ZA','GM','SD','AE','SS',  
    'GH','TN','IQ','UG','IR','ZM','IL','ZW')THEN '10'  
    WHEN B.CountryHQ IN (  
    'AU','SG','BD','BH','AZ','BN','KH',  
    'CN','KR','KP','PH','FJ','HK',  
    'IN','ID','KZ','KW','LA','MO',  
    'MY','MN','MM','NP','NE','NG',  
    'NZ','PK','WS','AS','LK','SR',  
    'TH','TW','TZ','TJ','TR','UZ') THEN '3'  
      
    WHEN B.CountryHQ IN ('US') THEN '5'  
    ELSE LTRIM(ISNULL(B.CountryHQ,'   '))  
   END ,  
   LTRIM(ISNULL(c.txtSuperIssuer,'                         '))  
  
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblMandate AS B  
   ON a.txtid1 = B.txtid1  
   LEFT OUTER JOIN @tblUnifiedIssuer AS C  
   ON a.txtid1 = c.txtid1  
   ORDER BY txtTv,txtEmisora,txtSerie  
     
  
  END  
  
 ELSE  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
   
  
END  
  
GO

/****** Object:  NumberedStoredProcedure [dbo].[usp_productos_PiPGenericos];24    Script Date: 10/27/2014 14:10:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------------------   
-- Autor:     OMAR ADRIAN ACEVES   
-- Fecha Creacion:   2014-06-18 14:57:25.133  
-- Descripcion Modulo 23: GENERAR PRODUCTO BANAMEX_MANDATOS_EUR_PIP  
  
-- Autor:     Mike Ramirez  
-- Fecha Creacion:   2014-07-14 11:14:25.133  
-- Descripcion Modulo 23: Se agrega un nuevo caso para la columna región  
--------------------------------------------------------------------------   
CREATE  PROCEDURE [dbo].[usp_productos_PiPGenericos];24  
  --DECLARE   
  @txtDate AS DATETIME   
 -- = '20140624'  
  
AS   
BEGIN  
SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](8),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][CHAR](6),  
    [txtSubSector][CHAR](6),  
    [txtRamo][CHAR](6),  
    [txtSubRamo][CHAR](6),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80)  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtIndex,txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [intSector][CHAR](6)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (txtIndex,txtId1,dblCount)  
   SELECT  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIEU'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (txtIndex,txtId1,dblCount)  
   SELECT  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPE'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE' AND dteDate <= @txtDate)   
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeyIssuerSector (txtId1,intSector)  
   SELECT  
    p.txtId1,  
    o.intSector  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
   
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
   
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    NULL AS [POR],  
    pr.txtID2 AS [ID2],  
    o.intSector AS [Sector],  
    os.txtValue AS [SubSector],  
    ra.txtValue AS [Ramo],  
    sra.txtValue AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(ic.txtName,0,80) AS [Razon Social]  
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON pr.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector AS os  
          ON pr.txtEmisora = os.txtIssuer  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo AS ra  
           ON pr.txtEmisora = ra.txtIssuer  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo AS sra  
            ON pr.txtEmisora = sra.txtIssuer  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer  
   ORDER BY pr.txtTv,pr.txtEmisora,pr.txtSerie     
  
  -- En campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIEU')   
   AND l.txtIndex = 'MSCIEU'  
  GROUP BY l.txtIndex  
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPE')   
   AND l.txtIndex = 'MSCIPE'  
  GROUP BY l.txtIndex  
    
  ---- Para el calculo de Porcentaje  
  --UPDATE u  
  -- SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
  --FROM  
  -- @tmp_tblResultsVector AS u  
  --  INNER JOIN @tmp_tblUniversoIndex AS ui  
  --   ON u.txtId1 = ui.txtId1  
  --    INNER JOIN @tmp_tblPond AS p  
  --     ON ui.txtIndex = p.txtIndex  
  --WHERE ui.txtIndex = @txtIndex  
  
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
      
      
      
   DECLARE @tblUnifiedIssuer TABLE  
  (  
  txtid1 varchar(11),  
  txtSuperIssuer varchar(15)  
  )  
  INSERT INTO @tblUnifiedIssuer  
   SELECT a.txtId1,c.txtSuperIssuer   
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblIssuerscatalog  AS C  
   ON a.txtEmisora = c.txtIssuer  
  
  
   -- Valida que la información este completa  
   IF EXISTS (  
     SELECT TOP 1 *   
     FROM @tmp_tblResultsVector  
      )  
  
    BEGIN  
  
     -- Reporto Informacion  
      
     SELECT   
     --c.txtid1+  
      CONVERT(CHAR(8),@txtDate,112) +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtTv))) < 4 THEN  
        RTRIM(LTRIM(txtTv)) + SUBSTRING('    ',1,4-LEN(RTRIM(LTRIM(txtTv))))  
       ELSE  
        RTRIM(LTRIM(txtTv))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtEmisora))) < 7 THEN  
        RTRIM(LTRIM(txtEmisora)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtEmisora))))  
       ELSE  
        RTRIM(LTRIM(txtEmisora))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtSerie))) < 6 THEN  
        RTRIM(LTRIM(txtSerie)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtSerie))))  
       ELSE  
        RTRIM(LTRIM(txtSerie))  
      END +  
  
      CASE   
       WHEN dblPMO IS NULL  
        THEN '000000000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMO,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMO,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN dblPMOP IS NULL  
        THEN '000000000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMOP,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMOP,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCurrency))) < 3 THEN  
        '*******'  
       ELSE  
        RTRIM(LTRIM(txtCurrency))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCountry))) < 2 THEN  
        RTRIM(LTRIM(txtCountry)) + SUBSTRING('  ',1,2-LEN(RTRIM(LTRIM(txtCountry))))  
       ELSE  
        RTRIM(LTRIM(txtCountry))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIndex))) < 7 THEN  
        RTRIM(LTRIM(txtIndex)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtIndex))))  
       ELSE  
        RTRIM(LTRIM(txtIndex))  
      END +  
  
      CASE   
       WHEN dblPOR IS NULL  
        THEN '0000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPOR,6),11,6),' ','0'),1,4) + SUBSTRING(STR(ROUND(dblPOR,6),11,6),6,11)  
      END +  
  
      RTRIM(txtID2) +  
  
      CASE   
       WHEN txtSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtBCT IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtBCT)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtBCT))))  
      END +  
  
      CASE   
       WHEN txtVCT IS NULL  
        THEN '0000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(txtVCT,2),11,2),' ','0'),1,8) + SUBSTRING(STR(ROUND(txtVCT,2),11,2),10,11)  
      END +  
  
      CASE   
       WHEN txtID7 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID7)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID7))))  
      END +  
  
      CASE   
       WHEN txtID6 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID6)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID6))))  
      END +  
  
      CASE   
       WHEN txtID3 IS NULL THEN '         '  
       ELSE  
        RTRIM(LTRIM(txtID3)) + SUBSTRING('         ',1,9-LEN(RTRIM(LTRIM(txtID3))))  
      END +  
  
      CASE   
       WHEN txtID4 IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtID4)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtID4))))  
      END +   
  
      CASE   
       WHEN txtRZ IS NULL  
        THEN '                                                                                '  
       ELSE  
        RTRIM(LTRIM(txtRZ)) + SUBSTRING('                                                                               ',1,80-LEN(RTRIM(LTRIM(txtRZ))))  
      END+  
  
    CASE WHEN  LTRIM(LTRIM(B.CurCountry)) is NULL OR LTRIM(LTRIM(B.CurCountry)) = ''   THEN '   '   
    ELSE LTRIM(RTRIM(B.CurCountry)) END +  
    CASE WHEN  LTRIM(LTRIM(B.countryHQ)) is NULL  OR LTRIM(LTRIM(B.countryHQ)) = '' THEN '  ' ELSE LTRIM(RTRIM(B.countryHQ))    
    END +   
      
    RTRIM( LTRIM(  
   CASE WHEN B.CountryHQ IN ('GB','GG','JE') THEN '007'  
    WHEN B.CountryHQ IN ('BM','KY') THEN '011'  
    WHEN B.CountryHQ IN ('JP') THEN '008'  
    WHEN B.CountryHQ IN ('CA') THEN '009'  
    WHEN B.CountryHQ IN ('GR','HU','PL','CZ','RU','CZ','RU') THEN '004'      
    WHEN B.CountryHQ IN ('MX') THEN '001'  
    WHEN B.CountryHQ IN ('AL','GR','DE','HU',  
    'AD','IE','AM','IS','AT','IT','BE','LU',  
    'BY','LV','BA','MK','BG','MT','CY','MD',  
    'HR','MC','DK','ME','EE','NO','FI','NL',  
    'FR','PL','SK','PT','SI','CZ','ES','RO',  
    'GE','RU','GI','SM','RS','SE','CH','UA') THEN '002'  
    WHEN B.CountryHQ IN (  
    'AF','JO','AO','KE','SA','MG','DZ','ML',  
    'BJ','MA','BW','MU','CM','MZ','BF','NA',  
    'CG','PS','CD','QA','CI','RW','EG','EH',  
    'ET','SN','GA','ZA','GM','SD','AE','SS',  
    'GH','TN','IQ','UG','IR','ZM','IL','ZW')THEN '010'  
    WHEN B.CountryHQ IN (  
    'AU','SG','BD','BH','AZ','BN','KH',  
    'CN','KR','KP','PH','FJ','HK',  
    'IN','ID','KZ','KW','LA','MO',  
    'MY','MN','MM','NP','NE','NG',  
    'NZ','PK','WS','AS','LK','SR',  
    'TH','TW','TZ','TJ','TR','UZ') THEN '003'  
      
    WHEN B.CountryHQ IN ('US') THEN '005'  
    --WHEN B.CountryHQ IN ('US') THEN '   '  
    ELSE '000'  
   END ))  
     
     
   +  LTRIM(ISNULL(c.txtSuperIssuer,''))  
     +   CONVERT(VARCHAR(100),REPLICATE(' ',( 50 - LEN(ISNULL(c.txtSuperIssuer,'')))))  
   
        
  
     FROM @tmp_tblResultsVector AS A  
    LEFT OUTER JOIN  tblMandate  as B  
    ON a.txtid1 = b.txtid1  
    LEFT OUTER JOIN @tblUnifiedIssuer AS C  
    ON a.txtid1 = c.txtid1  
  
     UNION  
  
     -- Agregamos TC  
     SELECT  
      CONVERT(CHAR(8),@txtDate,112)+  
   
      '*C  ' +    
      'MXP' +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 4 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('       ',1,4-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 6 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
  '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'  
    FROM @tmp_tblTC      
  
    END  
  
   ELSE  
     RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
 SET NOCOUNT OFF  
  
END
GO


