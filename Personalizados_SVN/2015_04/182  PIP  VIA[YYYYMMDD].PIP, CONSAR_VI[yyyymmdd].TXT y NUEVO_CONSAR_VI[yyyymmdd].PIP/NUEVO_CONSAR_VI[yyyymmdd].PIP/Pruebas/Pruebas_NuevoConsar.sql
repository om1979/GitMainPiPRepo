 

--select * from tblactivex
--where txtProceso = 'CONSAR_NEW_VI_PIP'

--helptextxmodulo sp_clsOfficialIndexFiles,14 '[DATE|YYYYMMDD]'



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--   Autor:			Mike Ram�rez    
--   Creacion:		12:43 p.m. 2012-07-11
--   Descripcion:   Procedimiento que genera el producto NUEVO_CONSAR_VI[yyyymmdd].PIP
--------------------------------------------------------------------------------------
ALTER  PROCEDURE dbo.sp_clsOfficialIndexFiles;14
  	@txtDate AS CHAR(8)  

AS 
BEGIN

	SET NOCOUNT ON

	DECLARE @tmp_tblUnifiedPricesReport TABLE (
		txtId1 CHAR (11),
		txtTv  CHAR (10),
		txtCUR CHAR (6)
			PRIMARY KEY (txtId1) 
	)

	INSERT @tmp_tblUnifiedPricesReport (txtId1,txtTv,txtCUR)
		SELECT 
			l.txtId1,
			l.txtTv,
			RTRIM(p.txtValue)
	FROM MxFixIncome.dbo.tblidsAdd AS p (NOLOCK)
	INNER JOIN MxFixIncome.dbo.tblids AS l (NOLOCK)
	ON p.txtId1 = l.txtId1
	WHERE l.txtTv = '*I' AND txtITEM = 'CUR'
		AND l.txtType = 'IND' AND l.txtSubType = 'EXT'
		UNION

	SELECT 
		txtId1,
		txtTv, 
		RTRIM(SUBSTRING(txtCUR,2,3))
	FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)
	WHERE txtTv IN ('RC','1I','1B')
	ORDER BY txtTV

		-- indices y trackers internacionales
		SELECT 
			'H ' + 
			'MC' +
			@txtDate + 

			RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +
			RTRIM(SUBSTRING(i.txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(i.txtEmisora, 1, 7))) +
			RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +

			CASE i.txtTv
			WHEN '1I' THEN 
				SUBSTRING(REPLACE(STR(ROUND(
				CASE
					WHEN ia1.txtValue IS NULL THEN ir.dblValue
					ELSE i3.dblValue
				END * i2.dblValue,6),16,6),  ' ', '0'), 1, 9) +
					SUBSTRING(REPLACE(STR(ROUND(			
					CASE
						WHEN ia1.txtValue IS NULL THEN ir.dblValue
						ELSE i3.dblValue
					END * i2.dblValue,6),16,6),  ' ', '0'), 11, 6) 
			ELSE
				SUBSTRING(REPLACE(STR(ROUND(			
				CASE

					WHEN ia1.txtValue IS NULL THEN ir.dblValue
					ELSE i3.dblValue
				END,6),16,6),  ' ', '0'), 1, 9) +
					SUBSTRING(REPLACE(STR(ROUND(			
					CASE
						WHEN ia1.txtValue IS NULL THEN ir.dblValue
						ELSE i3.dblValue
					END,6),16,6),  ' ', '0'), 11, 6) 
			END +

			'000000000000000' +	
			'000000000000' +

			CASE 
				WHEN m.txtCUR = 'NA' OR m.txtCUR = 'A' OR m.txtCUR = '' THEN '      ' 
				WHEN m.txtCUR = 'GBp' THEN UPPER(m.txtCUR)	
				ELSE m.txtCUR 
			END + 
	
			'025009' + 

			'000000' +
			'000000000' +	

			RTRIM(i.txtId2) + REPLICATE(' ',12 - LEN(RTRIM(i.txtId2))) +

			'0        ' +
			'0      ' +
			'0         ' AS txtRecord
		
		FROM 
			MxFixIncome.dbo.tblIrc AS ir (NOLOCK)
			INNER JOIN MxFixIncome.dbo.tblIds AS i (NOLOCK)
			ON ir.txtIrc = i.txtEmisora
			INNER JOIN @tmp_tblUnifiedPricesReport AS m
			ON 
				i.txtId1 = m.txtId1
			INNER JOIN MxFixIncome.dbo.tblIdsAdd AS ia (NOLOCK)
			ON 
				i.txtId1 = ia.txtId1
				AND ia.txtItem = 'CUR'
				AND ia.dteDate = (
					SELECT MAX(dteDate)
					FROM MxFixIncome.dbo.tblIdsAdd (NOLOCK)
					WHERE
						txtId1 = ia.txtId1
						AND dtedate < CAST(@txtDate AS DATETIME) + 1
						AND txtITem = ia.txtItem
				)
			LEFT OUTER JOIN MxFixIncome.dbo.tblIdsAdd ia1
			ON 
				i.txtId1 = ia1.txtId1
				AND ia1.txtItem = 'ALT_IRC'
				AND ia1.dteDate = (
					SELECT MAX(dteDate)
					FROM MxFixIncome.dbo.tblIdsAdd (NOLOCK)
					WHERE
						txtId1 = ia1.txtId1
						AND dtedate < CAST(@txtDate AS DATETIME) + 1
						AND txtITem = ia1.txtItem
				)
			LEFT OUTER JOIN MxFixIncome.dbo.tblIrc AS i2 (NOLOCK)
			ON 
				i2.txtIrc = (
					CASE ia.txtValue
					WHEN 'USD' THEN 'UFXU'
					WHEN 'DLL' THEN 'UFXU'
					ELSE ia.txtValue
					END				
				)
				AND i2.dteDate = @txtDate
			LEFT OUTER JOIN MxFixIncome.dbo.tblIrc AS i3 (NOLOCK)
			ON 
				ia1.txtValue = i3.txtIrc
				AND i3.dteDate = (
				SELECT MAX(dteDate)
				FROM MxFixIncome.dbo.tblIrc (NOLOCK)
				WHERE
					txtIrc = i3.txtIrc
					AND dteDate <= @txtDate
				)
		WHERE
			ir.dteDate = (
				SELECT MAX(dteDate)
				FROM MxFixIncome.dbo.tblIrc (NOLOCK)
				WHERE
					txtIrc = ir.txtIrc
					AND dteDate <= @txtDate
			)
			AND ((i.txtTv = ('*I') AND i.txtType = 'IND') 
				OR
				(i.txtTv = ('1I') AND i.txtType = 'TRA'))
			AND i.txtSubType = 'EXT'
			AND NOT i.txtEmisora IN ('SPINTPX')
			   --agregado por oaceves para excluir  el instrumento *I LIBEUR IND
			AND    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
		  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
		  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie))    not in ('*I  LIBEUR IND') 
    
   

		UNION
		
		-- indices y trackers nacionales
		SELECT 
			'H ' + 
			'MC' +
			@txtDate + 

			RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +
			RTRIM(SUBSTRING(i.txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(i.txtEmisora, 1, 7))) +
			RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +

			SUBSTRING(REPLACE(STR(ROUND(ir.dblValue,6),16,6),  ' ', '0'), 1, 9) +
				SUBSTRING(REPLACE(STR(ROUND(ir.dblValue,6),16,6),  ' ', '0'), 11, 6) +
			'000000000000000' +	
			'000000000000' + 

			CASE 
				WHEN m.txtCUR = 'NA' OR m.txtCUR = 'A' OR m.txtCUR = '' THEN '      ' 
				WHEN m.txtCUR = 'GBp' THEN UPPER(m.txtCUR)	
				ELSE m.txtCUR 
			END + 
	
			'025009' + 

			'000000'  +
			'000000000' +	

			RTRIM(i.txtId2) + REPLICATE(' ',12 - LEN(RTRIM(i.txtId2))) +

			'0        ' +
			'0      ' +
			'0         ' AS txtRecord

		FROM
			MxFixIncome.dbo.tblIds AS i (NOLOCK)
			INNER JOIN MxFixIncome.dbo.tblIrcCatalog AS ic (NOLOCK)
			ON i.txtEmisora = ic.txtIrc
			INNER JOIN @tmp_tblUnifiedPricesReport AS m
			ON 
				i.txtId1 = m.txtId1
			INNER JOIN MxFixIncome.dbo.tblIrc AS ir (NOLOCK)
			ON ic.txtIrc = ir.txtIrc	
		WHERE	
			ic.intIrcCategory IN (2, 6)
			AND i.txtTv IN ('RC', '1B')
			AND ir.dteDate = (
				SELECT MAX(dteDate)
				FROM MxFixIncome.dbo.tblIrc (NOLOCK)
				WHERE
					txtIrc = ir.txtIrc
					AND dteDate <= @txtDate
			)
			   --agregado por oaceves para excluir  el instrumento *I LIBEUR IND
			AND    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
		  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
		  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie))    not in ('*I  LIBEUR IND') 
    
   

	ORDER BY 
		txtRecord

END

