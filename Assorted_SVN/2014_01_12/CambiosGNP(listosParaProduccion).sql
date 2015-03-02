


--GNP_VECTOR_FF_XLS
--usp_productos_GNP;2 '[DATE|YYYYMMDD]','1','ALL'

--GNP_VECTOR_FF_PIP
--usp_productos_GNP;1 '[DATE|YYYYMMDD]','1','ALL'






SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'GNP_VECTOR_FF_PIP'

SELECT * FROM  dbo.tblActiveX
WHERE txtProceso = 'GNP_VECTOR_FF_XLS'



SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct = 'GNP_VECTOR_FF_PIP'


SELECT * FROM  MxProcesses..tblProductGeneratorMap
WHERE txtProduct = 'GNP_VECTOR_FF_XLS'


--SELECT * INTO tmp_tblActiveX_20141008 FROM tblActiveX


UPDATE   dbo.tblActiveX
SET txtValor = '\\pipmxsql\Produccion\MxVprecios\PRODUCTOS\DEFINITIVO\GNP\'
WHERE txtProceso IN ('GNP_VECTOR_FF_XLS','GNP_VECTOR_FF_PIP')
AND txtPropiedad = 'FilePath'



UPDATE  MxProcesses..tblProductGeneratorMap
SET txtPack  = 'ffall'
WHERE txtProduct IN ('GNP_VECTOR_FF_XLS','GNP_VECTOR_FF_PIP')


UPDATE  MxProcesses..tblProductGeneratorMap
SET FLOAD   = 1
WHERE txtProduct = 'PIP_MARKET_REF_DEF_HTM'




--PACK ORIGINAL = ffall
--FilePath		= \\pipmxsql\Produccion\MxVprecios\PRODUCTOS\DEFINITIVO\GNP\





/*----------------------------------------------------------------------------------------------------------------------------
--   Autor:					Mike Ramirez
--   Fecha Creacion:		11:39 2013-11-28
--   Descripcion: Modulo 1: SP que genera el producto para GNP que consolida fondos y precios de cierre GNP_VFF[yyyymmdd].XLS


--   Modifica:					Mike Ramirez
--   Fecha :		11:39 2013-11-28
--   Descripcion: Modificar liquidacion de ('MD','MP') a '24H' para precios y notas 

-----------------------------------------------------------------------------------------------------------------------------
--*/
--usp_productos_GNP;1 '20140924','1','all'
--usp_productos_GNP;2 '20140924','1','all'


ALTER  PROCEDURE dbo.usp_productos_GNP;2
	 @txtDate AS CHAR(8),--='20141007'
	 @txtFlag AS CHAR(1),--= '1'
	 @txtOwnerId AS CHAR(10)--= 'all'
AS
BEGIN

	SET NOCOUNT ON

	DECLARE @dblUSD2 AS FLOAT

	SET @dblUSD2 = (SELECT dblValue FROM tblIRC WHERE dteDate = @txtDate AND txtIRC = 'USD2')

	DECLARE @txtResult AS VARCHAR(8000)
	DECLARE @txtSecurity AS VARCHAR(8000)

	-- JATO (11:01 a.m. 2008-07-22)
	-- obtengo las horas mas recientes
	DECLARE @tblEquityPrices TABLE (
		txtId1 CHAR(11),
		dteTime DATETIME
			PRIMARY KEY(txtId1)
	)
	
	--Tabla para consolidar el vector Fondos,Prices y Notes
	DECLARE @tmp_tblUnivGNPVector TABLE (
		dteDate DATETIME,
		txtTV CHAR(4),
		txtEmisora CHAR(7), 
		txtSerie CHAR(10),
		dblPRS FLOAT,
		dblPRL FLOAT,
		dblCPD FLOAT,
		dblDTM FLOAT,
		dblUDR FLOAT,
		txtID2 CHAR(12) 
			PRIMARY KEY(txtTv,txtEmisora,txtSerie)
	)

	-- verifico si es un formato especifico
	--IF @txtOwnerId <> 'ALL' 
	--BEGIN

		-- verifico contar con todos los precios
		--SET @txtSecurity = (
	
		--	SELECT TOP 1 
		--		RTRIM(i.txtTv) + '_' +
		--		RTRIM(i.txtEmisora) + '_' +
		--		RTRIM(i.txtSerie) + ' (' + 
		--		RTRIM(i.txtId1)+ ')' AS txtSecurity
		--	FROM 
		--		tblIds AS i
		--		INNER JOIN tblEquity AS e (NOLOCK)
		--		ON i.txtId1 = e.txtId1
		--		INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)
		--		ON 
		--			opd.txtProductId = 'VFF'
		--			AND opd.txtOwnerId = @txtOwnerId
		--			AND opd.txtDir = i.txtId1
		--			AND opd.dteBeg <= @txtDate
		--			AND opd.dteEnd >= @txtDate
		--		LEFT OUTER JOIN tblEquityPrices AS ep (NOLOCK)
		--		ON 
		--			i.txtId1 = ep.txtId1
		--			AND ep.dteDate = @txtDate
		--			AND ep.txtSource IN ('COV', 'LX', 'GAF')
		--	WHERE
		--		i.txtTv IN ('51','52','54','56')
		--		AND ep.txtId1 IS NULL
	
		--)

		--IF @txtSecurity IS NULL 	
		--BEGIN	

			INSERT INTO @tblEquityPrices (
				txtId1,
				dteTime
			)
			SELECT 
				i.txtId1,
				MAX(ep.dteTime)
			FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)
				ON 
					opd.txtProductId = 'VFF'
					AND opd.txtOwnerId = @txtOwnerId
					AND opd.txtDir = i.txtId1
					AND opd.dteBeg <= @txtDate
					AND opd.dteEnd >= @txtDate
				INNER JOIN tblEquityPrices AS ep (NOLOCK)
				ON 
					i.txtId1 = ep.txtId1
					AND ep.dteDate = @txtDate
					AND ep.txtSource IN ('COV', 'LX', 'GAF')
			WHERE
				i.txtTv IN ('51','52','54','56')
			GROUP BY 
				i.txtId1	

	--		SET NOCOUNT OFF
		
	--		SELECT 
	--			SUBSTRING (
	--			'H ' +
	--			'MC' +
	--			@txtDate +
	--			RTRIM(txtTv) + REPLICATE(' ',4 - LEN(txtTv)) +
	--			RTRIM(txtEmisora) + REPLICATE(' ',7 - LEN(txtEmisora)) +
	--			RTRIM(txtSerie) + REPLICATE(' ',6 - LEN(txtSerie)) +

	--			SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE 
	--														WHEN ir.dblValue IS NULL THEN 1 
	--														WHEN i.txtTv = '56SP' THEN @dblUSD2		
	--													ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +
	--				SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE 
	--															WHEN ir.dblValue IS NULL THEN 1 
	--															WHEN i.txtTv = '56SP' THEN @dblUSD2		
	--														ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) + 	
			
	--			SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE 
	--														WHEN ir.dblValue IS NULL THEN 1 
	--														WHEN i.txtTv = '56SP' THEN @dblUSD2		
	--													ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +
	--				SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE 
	--															WHEN ir.dblValue IS NULL THEN 1 
	--															WHEN i.txtTv = '56SP' THEN @dblUSD2		
	--														ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +
			
	--			SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 1, 6) +
	--				SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 8, 6) +
	--			'025009' +
	--			@txtFlag +
	--			SUBSTRING(REPLACE(STR(ROUND(0,0),6,0),  ' ', '0'), 1, 6) +
			
	--			SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 1, 4) +
	--				SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 6, 4) +
	--		        CASE
	--		            WHEN i.txtId2 IS NULL THEN REPLICATE(' ', 12) +''''
	--		            ELSE REPLACE(SUBSTRING(LTRIM(i.txtId2), 1, 12),' ', ' ')
	--		        END , 1, 104)
				
	--		FROM 
	--			tblIds AS i (NOLOCK)
	--			INNER JOIN tblEquity AS e (NOLOCK)
	--			ON i.txtId1 = e.txtId1
	--			INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)
	--			ON 
	--				opd.txtProductId = 'VFF'
	--				AND opd.txtOwnerId = @txtOwnerId
	--				AND opd.txtDir = i.txtId1
	--				AND opd.dteBeg <= @txtDate
	--				AND opd.dteEnd >= @txtDate
	--			INNER JOIN tblEquityPrices AS ep (NOLOCK)
	--			ON 
	--				i.txtId1 = ep.txtId1
	--				AND ep.dteDate = @txtDate
	--				AND ep.txtSource IN ('COV', 'LX', 'GAF')
	--			LEFT OUTER JOIN tblIrc AS ir (NOLOCK)
	--			ON 
	--				ir.txtIrc = (
	--					CASE e.txtCurrency
	--					WHEN 'USD' THEN 'UFXU'
	--					ELSE e.txtCurrency
	--					END
	--				)
	--				AND ir.dteDate = @txtDate
	--		WHERE
	--			i.txtTv IN ('51','52','54','56')
	--		ORDER BY
	--			txtTv,
	--			txtEmisora,
	--			txtSerie

	--	END	
		
	--	ELSE
	--	BEGIN
	
	--		SET @txtResult = 'No hay precio para: ' + @txtSecurity
	--		RAISERROR (@txtResult, 16, 1)
	
	--	END

	----END
	--ELSE
	--BEGIN

		-- verifico contar con todos los precios
		-- para todos los clientes
		--SET @txtSecurity = (
	
		--	SELECT TOP 1 
		--		RTRIM(i.txtTv) + '_' +
		--		RTRIM(i.txtEmisora) + '_' +
		--		RTRIM(i.txtSerie) + ' (' + 
		--		RTRIM(i.txtId1)+ ')' AS txtSecurity
		--	FROM 
		--		tblIds AS i (NOLOCK)
		--		INNER JOIN tblEquity AS e (NOLOCK)
		--		ON i.txtId1 = e.txtId1
		--		INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)
		--		ON 
		--			opd.txtProductId = 'VFF'
		--			AND opd.txtDir = i.txtId1
		--			AND opd.dteBeg <= @txtDate
		--			AND opd.dteEnd >= @txtDate
		--		LEFT OUTER JOIN tblEquityPrices AS ep (NOLOCK)
		--		ON 
		--			i.txtId1 = ep.txtId1
		--			AND ep.dteDate = @txtDate
		--			AND ep.txtSource IN ('COV', 'LX', 'GAF')
		--	WHERE
		--		i.txtTv IN ('51','52','54','56')
		--		AND ep.txtId1 IS NULL	
		--)

		--IF @txtSecurity IS NULL 	
		--BEGIN
			INSERT INTO @tblEquityPrices (
				txtId1,
				dteTime
			)
			SELECT 
				i.txtId1,
				MAX(ep.dteTime)
			FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tblEquityPrices AS ep (NOLOCK)
				ON 
					i.txtId1 = ep.txtId1
					AND ep.dteDate = @txtDate
					AND ep.txtSource IN ('COV', 'LX', 'GAF')
			WHERE
				i.txtTv IN ('51','52','54','56')
			GROUP BY 
				i.txtId1	

			--SET NOCOUNT OFF

			--SET NOCOUNT ON
	
		-- Insertamos los Fondos
		INSERT @tmp_tblUnivGNPVector (dteDate,txtTV,txtEmisora,txtSerie,dblPRS,dblPRL,dblCPD,dblDTM,dblUDR,txtID2)
			SELECT 
				@txtDate,
				RTRIM(txtTv),
				RTRIM(txtEmisora),
				RTRIM(txtSerie),
			
				STR(ROUND(dblPrice * (CASE 
										WHEN ir.dblValue IS NULL THEN 1 
										WHEN i.txtTv = '56SP' THEN @dblUSD2	
									ELSE ir.dblValue END),6),16,6),	
			
				STR(ROUND(dblPrice * (CASE 
										WHEN ir.dblValue IS NULL THEN 1 
										WHEN i.txtTv = '56SP' THEN @dblUSD2	
									ELSE ir.dblValue END),6),16,6),
																							
				STR(ROUND(0,6),13,6),

				STR(ROUND(0,0),6,0),
			
				STR(ROUND(0,4),9,4),
				
			        CASE
			            WHEN i.txtId2 IS NULL THEN ''
			            ELSE LTRIM(i.txtId2)
			   END
			        
			FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tblEquity AS e (NOLOCK)
				ON i.txtId1 = e.txtId1
				INNER JOIN @tblEquityPrices AS buff
				ON i.txtId1 = buff.txtId1
				INNER JOIN tblEquityPrices AS ep (NOLOCK)
				ON
					i.txtId1 = ep.txtId1
					AND ep.dteDate = @txtDate
					AND ep.dteTime = buff.dteTime
					AND ep.txtSource IN ('COV','LX','GAF')
				LEFT OUTER JOIN tblIrc AS ir (NOLOCK)
				ON 
					ir.txtIrc = (
						CASE e.txtCurrency
						WHEN 'USD' THEN 'UFXU'
						ELSE e.txtCurrency
						END
					)
					AND ir.dteDate = @txtDate
			WHERE
				i.txtTv IN ('51','52','54','56')
			ORDER BY
				txtTv,
				txtEmisora,
				txtSerie

		-- Insertamos de tmp_tblUnifiedPricesReport
		INSERT @tmp_tblUnivGNPVector (dteDate,txtTV,txtEmisora,txtSerie,dblPRS,dblPRL,dblCPD,dblDTM,dblUDR,txtID2)
			SELECT 
				@txtDate,
				RTRIM(i.txtTv),
				RTRIM(i.txtEmisora),
				RTRIM(i.txtSerie),
			
				STR(ROUND(dblPRS * (CASE 
										WHEN ir.dblValue IS NULL THEN 1 
										WHEN i.txtTv = '56SP' THEN @dblUSD2	
									ELSE ir.dblValue END),6),16,6),
			
				STR(ROUND(dblPRL * (CASE 
										WHEN ir.dblValue IS NULL THEN 1 
										WHEN i.txtTv = '56SP' THEN @dblUSD2	
									ELSE ir.dblValue END),6),16,6),

				STR(ROUND(dblCPD,6),13,6),

				STR(ROUND(dblDTM,0),6,0),
			
				STR(ROUND(dblUDR,4),9,4),

		        CASE
		            WHEN i.txtId2 IS NULL THEN ''
		            ELSE LTRIM(i.txtId2)
		        END
				
			FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tmp_tblUnifiedPricesReport AS e (NOLOCK)
				ON i.txtId1 = e.txtId1
				LEFT OUTER JOIN tblIrc AS ir (NOLOCK)
				ON 
					ir.txtIrc = (
						CASE e.txtCur
						WHEN 'USD' THEN 'UFXU'
						ELSE e.txtCur
						END
					)
					AND ir.dteDate = @txtDate
			WHERE
				i.txtTv NOT IN ('51','52','54','56')
				AND e.txtLiquidation IN ('24H','MP')--('MD','MP')
			ORDER BY
				i.txtTv,
				i.txtEmisora,
				i.txtSerie

		-- Insertamos de tmp_tblUnifiedNotesReport
		INSERT @tmp_tblUnivGNPVector (dteDate,txtTV,txtEmisora,txtSerie,dblPRS,dblPRL,dblCPD,dblDTM,dblUDR,txtID2)
			SELECT 
				@txtDate,
				RTRIM(i.txtTv),
				RTRIM(i.txtEmisora),
				RTRIM(i.txtSerie),
			
				STR(ROUND(dblPRS * (CASE 
										WHEN ir.dblValue IS NULL THEN 1 
										WHEN i.txtTv = '56SP' THEN @dblUSD2	
									ELSE ir.dblValue END),6),16,6),
			
				STR(ROUND(dblPRL * (CASE 
										WHEN ir.dblValue IS NULL THEN 1 
										WHEN i.txtTv = '56SP' THEN @dblUSD2	
									ELSE ir.dblValue END),6),16,6),

				STR(ROUND(dblCPD,6),13,6),

				STR(ROUND(dblDTM,0),6,0),
			
				STR(ROUND(dblUDR,4),9,4),

		        CASE
		            WHEN i.txtId2 IS NULL THEN ''
		            ELSE LTRIM(i.txtId2)
		        END
				
			FROM 
				tblIds AS i (NOLOCK)
				INNER JOIN tmp_tblUnifiedNotesReport AS e (NOLOCK)
				ON 
					i.txtId1 = e.txtId1
				INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS o (NOLOCK)
				ON
					i.txtId1 = o.txtDir
				LEFT OUTER JOIN tblIrc AS ir (NOLOCK)
				ON 
					ir.txtIrc = (
						CASE e.txtCur
						WHEN 'USD' THEN 'UFXU'
						ELSE e.txtCur
						END
					)
					AND ir.dteDate = @txtDate
			WHERE
				i.txtTv NOT IN ('51','52','54','56')
				AND e.txtLiquidation IN ('24H','MP')--('MD','MP')
				AND o.txtOwnerId = 'PGN01'
				AND o.txtProductId = 'SNOTES'
			ORDER BY
				i.txtTv,
				i.txtEmisora,
				i.txtSerie

		--END
		--ELSE
		--BEGIN
	
		--	SET @txtResult = 'No hay precio para: ' + @txtSecurity
		--	RAISERROR (@txtResult, 16, 1)
	
		--END

		--Reporto los datos
		SELECT
			CONVERT(CHAR(10),dteDate,103),
			txtTV,
			txtEmisora,
			txtSerie,
			STR(ROUND(dblPRS,6),16,6),
			STR(ROUND(dblPRL,6),16,6),
			STR(ROUND(dblCPD,6),13,6),
			dblDTM,
			STR(ROUND(dblUDR,4),9,4),
			txtID2
		FROM @tmp_tblUnivGNPVector
		ORDER BY 2,3,4

	SET NOCOUNT OFF

	END



/*
----------------------------------------------------------------------------------------------------------MODULO 1
*/

 /* 
-----------------------------------------------------------------------------------------------------------------------------  
--   Autor:     Mike Ramirez  
--   Fecha Creacion:  11:28 2013-11-28  
--   Descripcion: Modulo 1: SP que genera el producto para GNP que consolida fondos y precios de cierre GNP_VFF[yyyymmdd].PIP  
-----------------------------------------------------------------------------------------------------------------------------  
--   Autor:			  Omar Adrian Aceves Guttierrez 
--   Fecha Creacion:  2014-10-08 09:45:31.883
--   Descripcion: Modulo 2: Se cambia liquidacion a 24H
*/
ALTER   PROCEDURE dbo.usp_productos_GNP;1  
 @txtDate AS CHAR(8),  
 @txtFlag AS CHAR(1),  
 @txtOwnerId AS CHAR(10)  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @dblUSD2 AS FLOAT  
  
 SET @dblUSD2 = (SELECT dblValue FROM tblIRC WHERE dteDate = @txtDate AND txtIRC = 'USD2')  
  
 DECLARE @txtResult AS VARCHAR(8000)  
 DECLARE @txtSecurity AS VARCHAR(8000)  
  
 -- JATO (11:01 a.m. 2008-07-22)  
 -- obtengo las horas mas recientes  
 DECLARE @tblEquityPrices TABLE (  
  txtId1 CHAR(11),  
  dteTime DATETIME  
   PRIMARY KEY(txtId1)  
 )  
   
 --Tabla para consolidar el vector Fondos,Prices y Notes  
 DECLARE @tmp_tblUnivGNPVector TABLE (  
  txtData VARCHAR(8000)  
 )  
  
 -- verifico si es un formato especifico  
 IF @txtOwnerId <> 'ALL'   
 BEGIN  
  
  -- verifico contar con todos los precios  
  SET @txtSecurity = (  
   
   SELECT TOP 1   
    RTRIM(i.txtTv) + '_' +  
    RTRIM(i.txtEmisora) + '_' +  
    RTRIM(i.txtSerie) + ' (' +   
    RTRIM(i.txtId1)+ ')' AS txtSecurity  
   FROM   
    tblIds AS i  
    INNER JOIN tblEquity AS e (NOLOCK)  
    ON i.txtId1 = e.txtId1  
    INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)  
    ON   
     opd.txtProductId = 'VFF'  
     AND opd.txtOwnerId = @txtOwnerId  
     AND opd.txtDir = i.txtId1  
     AND opd.dteBeg <= @txtDate  
     AND opd.dteEnd >= @txtDate  
    LEFT OUTER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     i.txtId1 = ep.txtId1  
     AND ep.dteDate = @txtDate  
     AND ep.txtSource IN ('COV', 'LX', 'GAF')  
   WHERE  
    i.txtTv IN ('51','52','54','56')  
    AND ep.txtId1 IS NULL  
   
  )  
  
  IF @txtSecurity IS NULL    
  BEGIN   
  
   INSERT INTO @tblEquityPrices (  
    txtId1,  
    dteTime  
   )  
   SELECT   
    i.txtId1,  
    MAX(ep.dteTime)  
   FROM   
    tblIds AS i (NOLOCK)  
    INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)  
    ON   
     opd.txtProductId = 'VFF'  
     AND opd.txtOwnerId = @txtOwnerId  
     AND opd.txtDir = i.txtId1  
     AND opd.dteBeg <= @txtDate  
     AND opd.dteEnd >= @txtDate  
    INNER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     i.txtId1 = ep.txtId1  
     AND ep.dteDate = @txtDate  
     AND ep.txtSource IN ('COV', 'LX', 'GAF')  
   WHERE  
    i.txtTv IN ('51','52','54','56')  
   GROUP BY   
    i.txtId1   
  
   SET NOCOUNT OFF  
    
   SELECT   
    SUBSTRING (  
    'H ' +  
    'MC' +  
    @txtDate +  
    RTRIM(txtTv) + REPLICATE(' ',4 - LEN(txtTv)) +  
    RTRIM(txtEmisora) + REPLICATE(' ',7 - LEN(txtEmisora)) +  
    RTRIM(txtSerie) + REPLICATE(' ',6 - LEN(txtSerie)) +  
  
    SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2    
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2    
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +    
     
    SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2    
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2    
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +  
     
    SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 1, 6) +  
     SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 8, 6) +  
    '025009' +  
    @txtFlag +  
    SUBSTRING(REPLACE(STR(ROUND(0,0),6,0),  ' ', '0'), 1, 6) +  
     
    SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 1, 4) +  
     SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 6, 4) +  
           CASE  
               WHEN i.txtId2 IS NULL THEN REPLICATE(' ', 12) +''''  
               ELSE REPLACE(SUBSTRING(LTRIM(i.txtId2), 1, 12),' ', ' ')  
           END , 1, 104)  
      
   FROM   
    tblIds AS i (NOLOCK)  
    INNER JOIN tblEquity AS e (NOLOCK)  
    ON i.txtId1 = e.txtId1  
    INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)  
    ON   
     opd.txtProductId = 'VFF'  
     AND opd.txtOwnerId = @txtOwnerId  
     AND opd.txtDir = i.txtId1  
     AND opd.dteBeg <= @txtDate  
     AND opd.dteEnd >= @txtDate  
    INNER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     i.txtId1 = ep.txtId1  
     AND ep.dteDate = @txtDate  
     AND ep.txtSource IN ('COV', 'LX', 'GAF')  
    LEFT OUTER JOIN tblIrc AS ir (NOLOCK)  
    ON   
     ir.txtIrc = (  
      CASE e.txtCurrency  
      WHEN 'USD' THEN 'UFXU'  
      ELSE e.txtCurrency  
      END  
     )  
     AND ir.dteDate = @txtDate  
   WHERE  
    i.txtTv IN ('51','52','54','56')  
   ORDER BY  
    txtTv,  
    txtEmisora,  
    txtSerie  
  
  END   
    
  ELSE  
  BEGIN  
   
   SET @txtResult = 'No hay precio para: ' + @txtSecurity  
   RAISERROR (@txtResult, 16, 1)  
   
  END  
  
 END  
 ELSE  
 BEGIN  
  
  -- verifico contar con todos los precios  
  -- para todos los clientes  
  SET @txtSecurity = (  
   
   SELECT TOP 1   
    RTRIM(i.txtTv) + '_' +  
    RTRIM(i.txtEmisora) + '_' +  
    RTRIM(i.txtSerie) + ' (' +   
    RTRIM(i.txtId1)+ ')' AS txtSecurity  
   FROM   
    tblIds AS i (NOLOCK)  
    INNER JOIN tblEquity AS e (NOLOCK)  
    ON i.txtId1 = e.txtId1  
    INNER JOIN  MxProcesses.dbo.tblOwnersVsProductsDirectives AS opd (NOLOCK)  
    ON   
     opd.txtProductId = 'VFF'  
     AND opd.txtDir = i.txtId1  
     AND opd.dteBeg <= @txtDate  
     AND opd.dteEnd >= @txtDate  
    LEFT OUTER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     i.txtId1 = ep.txtId1  
     AND ep.dteDate = @txtDate  
     AND ep.txtSource IN ('COV', 'LX', 'GAF')  
   WHERE  
    i.txtTv IN ('51','52','54','56')  
    AND ep.txtId1 IS NULL   
  )  
  
  IF @txtSecurity IS NULL    
  BEGIN  
   INSERT INTO @tblEquityPrices (  
    txtId1,  
    dteTime  
   )  
   SELECT   
    i.txtId1,  
    MAX(ep.dteTime)  
   FROM   
    tblIds AS i (NOLOCK)  
    INNER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     i.txtId1 = ep.txtId1  
     AND ep.dteDate = @txtDate  
     AND ep.txtSource IN ('COV', 'LX', 'GAF')  
   WHERE  
    i.txtTv IN ('51','52','54','56')  
   GROUP BY   
    i.txtId1   
  
   SET NOCOUNT OFF  
  
   SET NOCOUNT ON  
   
  -- Insertamos los Fondos  
  INSERT @tmp_tblUnivGNPVector (txtData)  
   SELECT   
    SUBSTRING (  
    'H ' +  
    'MC' +  
    @txtDate +  
    RTRIM(txtTv) + REPLICATE(' ',4 - LEN(txtTv)) +  
    RTRIM(txtEmisora) + REPLICATE(' ',7 - LEN(txtEmisora)) +  
    RTRIM(txtSerie) + REPLICATE(' ',6 - LEN(txtSerie)) +  
     
    SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2   
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2   
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +    
     
    SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2   
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPrice * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2   
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +  
    
    SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 1, 6) +  
     SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 8, 6) +  
    '025009' +  
    @txtFlag +  
    SUBSTRING(REPLACE(STR(ROUND(0,0),6,0),  ' ', '0'), 1, 6) +  
     
    SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 1, 4) +  
     SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 6, 4) +  
           CASE  
               WHEN i.txtId2 IS NULL THEN REPLICATE(' ', 12) +''''  
               ELSE REPLACE(SUBSTRING(LTRIM(i.txtId2), 1, 12),' ', ' ')  
           END , 1, 104)  
      
   FROM   
    tblIds AS i (NOLOCK)  
    INNER JOIN tblEquity AS e (NOLOCK)  
    ON i.txtId1 = e.txtId1  
    INNER JOIN @tblEquityPrices AS buff  
    ON i.txtId1 = buff.txtId1  
    INNER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     i.txtId1 = ep.txtId1  
     AND ep.dteDate = @txtDate  
     AND ep.dteTime = buff.dteTime  
     AND ep.txtSource IN ('COV', 'LX', 'GAF')  
    LEFT OUTER JOIN tblIrc AS ir (NOLOCK)  
    ON   
     ir.txtIrc = (  
      CASE e.txtCurrency  
      WHEN 'USD' THEN 'UFXU'  
      ELSE e.txtCurrency  
      END  
     )  
     AND ir.dteDate = @txtDate  
   WHERE  
    i.txtTv IN ('51','52','54','56')  
   ORDER BY  
    txtTv,  
    txtEmisora,  
    txtSerie  
  
  -- Insertamos de tmp_tblUnifiedPricesReport  
  INSERT @tmp_tblUnivGNPVector (txtData)  
   SELECT   
    SUBSTRING (  
    'H ' +  
    'MC' +  
    @txtDate +  
    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +  
    RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +  
    RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
     
    SUBSTRING(REPLACE(STR(ROUND(dblPRS * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2   
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPRS * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2   
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +    
     
    SUBSTRING(REPLACE(STR(ROUND(dblPRL * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2   
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPRL * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2   
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +  
    
    SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 1, 6) +  
     SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 8, 6) +  
    '025009' +  
    @txtFlag +  
    SUBSTRING(REPLACE(STR(ROUND(0,0),6,0),  ' ', '0'), 1, 6) +  
     
    SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 1, 4) +  
     SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 6, 4) +  
           CASE  
               WHEN i.txtId2 IS NULL THEN REPLICATE(' ', 12) +''''  
               ELSE REPLACE(SUBSTRING(LTRIM(i.txtId2), 1, 12),' ', ' ')  
           END , 1, 104)  
      
   FROM   
    tblIds AS i (NOLOCK)  
    INNER JOIN tmp_tblUnifiedPricesReport AS e (NOLOCK)  
    ON i.txtId1 = e.txtId1  
    LEFT OUTER JOIN tblIrc AS ir (NOLOCK)  
    ON   
     ir.txtIrc = (  
      CASE e.txtCur  
      WHEN 'USD' THEN 'UFXU'  
      ELSE e.txtCur  
      END  
     )  
     AND ir.dteDate = @txtDate  
   WHERE  
    i.txtTv NOT IN ('51','52','54','56')  
    AND e.txtLiquidation IN ('24H','MP')--('MD','MP')  
   ORDER BY  
    i.txtTv,  
    i.txtEmisora,  
    i.txtSerie  
  
  -- Insertamos de tmp_tblUnifiedNotesReport  
  INSERT @tmp_tblUnivGNPVector (txtData)  
   SELECT  
    SUBSTRING (  
    'H ' +  
    'MC' +  
    @txtDate +  
    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +  
    RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +  
    RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
     
    SUBSTRING(REPLACE(STR(ROUND(dblPRS * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2   
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +       SUBSTRING(REPLACE(STR(ROUND(dblPRS * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2   
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +    
     
    SUBSTRING(REPLACE(STR(ROUND(dblPRL * (CASE   
               WHEN ir.dblValue IS NULL THEN 1   
               WHEN i.txtTv = '56SP' THEN @dblUSD2   
              ELSE ir.dblValue END),6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPRL * (CASE   
                WHEN ir.dblValue IS NULL THEN 1   
                WHEN i.txtTv = '56SP' THEN @dblUSD2   
               ELSE ir.dblValue END),6),16,6),  ' ', '0'), 11, 6) +  
    
    SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 1, 6) +  
     SUBSTRING(REPLACE(STR(ROUND(0,6),13,6),  ' ', '0'), 8, 6) +  
    '025009' +  
    @txtFlag +  
    SUBSTRING(REPLACE(STR(ROUND(0,0),6,0),  ' ', '0'), 1, 6) +  
     
    SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 1, 4) +  
     SUBSTRING(REPLACE(STR(ROUND(0,4),9,4),  ' ', '0'), 6, 4) +  
           CASE  
               WHEN i.txtId2 IS NULL THEN REPLICATE(' ', 12) +''''  
               ELSE REPLACE(SUBSTRING(LTRIM(i.txtId2), 1, 12),' ', ' ')  
           END , 1, 104)  
      
   FROM   
    tblIds AS i (NOLOCK)  
    INNER JOIN tmp_tblUnifiedNotesReport AS e (NOLOCK)  
    ON   
     i.txtId1 = e.txtId1  
    INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS o (NOLOCK)  
    ON  
     i.txtId1 = o.txtDir  
    LEFT OUTER JOIN tblIrc AS ir (NOLOCK)  
    ON   
     ir.txtIrc = (  
      CASE e.txtCur  
      WHEN 'USD' THEN 'UFXU'  
      ELSE e.txtCur  
      END  
     )  
     AND ir.dteDate = @txtDate  
   WHERE  
    i.txtTv NOT IN ('51','52','54','56')  
    AND e.txtLiquidation IN ('24H','MP')  
    AND o.txtOwnerId = 'PGN01'  
    AND o.txtProductId = 'SNOTES'  
   ORDER BY  
    i.txtTv,  
    i.txtEmisora,  
    i.txtSerie  
  
  END  
  ELSE  
  BEGIN  
   
   SET @txtResult = 'No hay precio para: ' + @txtSecurity  
   RAISERROR (@txtResult, 16, 1)  
   
  END  
  
  --Reporto los datos  
  SELECT  
   txtData  
  FROM @tmp_tblUnivGNPVector  
  
 SET NOCOUNT OFF  
  
 END  
  
END  
  