

/*
se agregan dos left joins para sacar valores de PRLask y PRLBID (ultimas dos columnas)
de las tablas tblbidprices y tblaskprices sin embargo no todos los intrumentos cuentan con valores
por esta razon en el estored productivo se obtienen por las formulas 
    --ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,  
    --ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk  
    sin embargo los resultados son erroneos 
*/



 --ALTER PROCEDURE dbo.sp_createVectorFile;6  
 --	@txtDate AS VARCHAR(10),
	--@txtLiquidation AS VARCHAR(10),
	--@txtOwner AS VARCHAR(50) = 'all', -- Todos los instrumentos son por default
	--@txtVectorInfo AS VARCHAR(10) = 'all' -- Toda tipo de información es por default
						

	   DECLARE  @txtDate AS VARCHAR(10)= '20140707'
	   DECLARE  @txtLiquidation AS VARCHAR(10)='MD'
	   DECLARE @txtOwner AS VARCHAR(50) = 'all' -- Todos los instrumentos son por default
	   DECLARE @txtVectorInfo AS VARCHAR(10) = 'all' -- Toda tipo de información es por default --  puede ser 'all', 'sn', 'trad'

 --AS   
 --BEGIN  
 --SET NOCOUNT ON  
  
 DECLARE @fLiq AS BIT  
  
 -- verifico si la liquidacion requerida  
 -- efectivamente esta activada  
 SET @fLiq = (   
  
  SELECT fBALoad  
  FROM tblLiquidationCAtalog  
  WHERE  
   txtLiquidation = @txtLiquidation  
 )  
  
  -- creamos tabla deposito  
 
    IF OBJECT_ID('tempdb..#tblTemp')IS NOT NULL
  DROP TABLE  #tblTemp
   
  CREATE TABLE #tblTemp( 
   [txtId1][VARCHAR](20),  
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
   [dblLDRAsk][FLOAT] 
  )  
   CREATE INDEX IDX_223
ON [#tblTemp] ([txtId1], [txtEmisora])
 
 
 IF @fLiq = 1  
 BEGIN  
  
  -- PARTE TRADICIONAL  
   -- bonos guber y privados  
  IF @txtVectorInfo IN ('all','trad')  
   INSERT #tblTemp  
   SELECT DISTINCT 
    i.txtid1,
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
    
      LDRbp2.dblValue AS dblLDRBid,  
      LDRap2.dblValue  AS dblLDRAsk  
    --ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,  
    --ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk  
     
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
        AND i.txtTV NOT IN 
    (
    '2','3P','4P','6U','71','73','75','91SP','D1','D1SP','D2','D2SP','D4','D4SP',
    'D5','D5SP','D6','D6SP','D7SP','D8SP','FSP','G','I','IL','IM','IQ','JISP','JSP','QSP','R','R3','R3SP'
    )
   LEFT  JOIN tblBidPrices AS bp (NOLOCK)  
    ON   
    i.txtId1 = bp.txtId1 
    AND   bp.dteDate = @txtDate  
    AND bp.txtItem = 'PRL'  
    AND bp.txtLiquidation = @txtLiquidation 
   
    LEFT  JOIN tblAskPrices AS ap  
    ON   
     i.txtId1 = ap.txtId1  
      AND ap.dteDate = @txtDate  
     AND ap.txtItem = 'PRL'  
     AND ap.txtLiquidation =@txtLiquidation
    
  
    LEFT  JOIN  tblBidPrices AS bp2 (NOLOCK)  
    ON   
     i.txtId1 = bp2.txtId1  
      and bp2.dteDate = @txtDate  
     AND bp2.txtItem = 'YTM'  
     AND bp2.txtLiquidation = @txtLiquidation
     
     

    LEFT JOIN tblAskPrices AS ap2 (NOLOCK)  
    ON   
     i.txtId1 = ap2.txtId1  
     AND ap2.dteDate = @txtDate  
     AND ap2.txtItem = 'YTM'  
     AND ap2.txtLiquidation = @txtLiquidation
     
     /*se agrega para consegui 'LDR'  apareceb nulos ya que faltan valores para campos LDR por eso se calculaban de 
     forma manual con : 
     --ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,  
    --ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk  
    pero  la formula es erronea
     */
    LEFT    JOIN tblBidPrices AS LDRbp2 (NOLOCK)  
    ON   
     i.txtId1 = LDRbp2.txtId1  
     AND LDRbp2.dteDate = @txtDate  
     AND LDRbp2.txtItem = 'LDR'  
     AND LDRbp2.txtLiquidation = @txtLiquidation 
     
     LEFT   JOIN tblAskPrices AS LDRap2 (NOLOCK)  
    ON   
     i.txtId1 = LDRap2.txtId1  
     AND LDRap2.dteDate = @txtDate  
     AND LDRap2.txtItem = 'LDR'  
     AND LDRap2.txtLiquidation = @txtLiquidation
     

     
     
    LEFT JOIN tblFixedPrices AS fp (NOLOCK)  
    ON i.txtId1 = fp.txtId1  
    AND a.txtLiquidation IN (@txtLiquidation, 'MP')  
    AND fp.txtId1 IS NULL  
    AND tv.intCategory IN (0, 2)  

            WHERE a.txtLiquidation = @txtLiquidation
	 AND a1.txtLiquidation = @txtLiquidation
	 
	   
   UNION  
    -- bonos bancarios que cuentan  
    -- con informacion valida (ytmbid > ytm and ytmask < ytm) para ser reportados  
    SELECT   
    i.txtid1,
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
    LDRbp2.dblValue AS dblLDRBid,  
    LDRap2.dblValue  AS dblLDRAsk  
   -- ROUND(bp2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRBid,  
   -- ROUND(ap2.dblValue - a.dblYTM + a.dblLDR, 6) AS dblLDRAsk  
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
        AND i.txtTV NOT IN 
    (
    '2','3P','4P','6U','71','73','75','91SP','D1','D1SP','D2','D2SP','D4','D4SP',
    'D5','D5SP','D6','D6SP','D7SP','D8SP','FSP','G','I','IL','IM','IQ','JISP','JSP','QSP','R','R3','R3SP'
    )
   
    LEFT  JOIN tblBidPrices AS bp (NOLOCK)  
    ON   
     i.txtId1 = bp.txtId1  
     AND bp.dteDate = @txtDate  
     AND bp.txtItem = 'PRL'  
     AND bp.txtLiquidation = a.txtLiquidation  
    
     LEFT  JOIN tblAskPrices AS ap (NOLOCK)  
    ON   
     i.txtId1 = ap.txtId1  
     AND ap.dteDate = @txtDate  
     AND ap.txtItem = 'PRL'  
     AND ap.txtLiquidation = a.txtLiquidation  
 
 
     LEFT  JOIN tblBidPrices AS bp2 (NOLOCK)  
    ON   
     i.txtId1 = bp2.txtId1  
     AND bp2.dteDate = @txtDate  
     AND bp2.txtItem = 'YTM'  
     AND bp2.txtLiquidation = a.txtLiquidation  
     
     LEFT  JOIN tblAskPrices AS ap2 (NOLOCK)  
    ON   
     i.txtId1 = ap2.txtId1  
     AND ap2.dteDate = @txtDate  
     AND ap2.txtItem = 'YTM'  
     AND ap2.txtLiquidation = a.txtLiquidation  
    LEFT OUTER JOIN tblFixedPrices AS fp (NOLOCK)  
    ON i.txtId1 = fp.txtId1  
    
    /*se agrega para consegui 'LDR' */
     LEFT    JOIN tblBidPrices AS LDRbp2 (NOLOCK)  
    ON   
     i.txtId1 = LDRbp2.txtId1  
     AND LDRbp2.dteDate = @txtDate  
     AND LDRbp2.txtItem = 'LDR'  
     AND LDRbp2.txtLiquidation =  a.txtLiquidation 
     
     LEFT   JOIN tblAskPrices AS LDRap2 (NOLOCK)  
    ON   
     i.txtId1 = LDRap2.txtId1  
     AND LDRap2.dteDate = @txtDate  
     AND LDRap2.txtItem = 'LDR'  
     AND LDRap2.txtLiquidation =  a.txtLiquidation 
   
   
    WHERE  
    a.txtLiquidation = @txtLiquidation  
    AND fp.txtId1 IS NULL  
    AND NOT tv.intCategory IN (0, 2)  
    AND a.dblYTM < bp2.dblValue  
    AND a.dblYTM > ap2.dblValue  
	 AND a1.txtLiquidation = @txtLiquidation


	SET NOCOUNT OFF

		SELECT *
		FROM #tblTemp
--WHERE txtid1 IN 
--(

--'MBAN0000001',
--'MHRH0000001',
--'MINJ0000001'
--)
		ORDER BY
			txtTv,
			txtEmisora,
			txtSerie

	END -- (IF)

	ELSE IF @fLiq = 0

		 SELECT 
			'NO EXISTE INFORMACION'

--END
