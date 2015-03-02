CREATE PROCEDURE dbo.sp_productos_BANAMEX;14
     @txtDate AS DATETIME,
      @txtLiquidation AS VARCHAR(3)
 
AS
/*   
      Autor:                  Mike Ramirez     
      Creacion:         03:31 p.m. 2012-08-27
      Descripcion:      Modulo 14: Se incluyen las 4 ultimas columnas
 
      Modificado por: Csolorio
      Modificacion:     20121109
      Descripcion:      Agrego validaciones al analitico IRT
*/
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
            [txtSPQ][CHAR](8),
            [txtFIQ][CHAR](9),
            [txtDPQ][CHAR](8),
            [txtHRQ][CHAR](8),
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
            [txtRPC][VARCHAR](55),
            [txtAGC][VARCHAR](55),
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
                  dtedate AS [dteDate],
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
                  CASE WHEN txtHRQ = 'NA' OR txtHRQ = '-' OR txtHRQ IS NULL THEN ' ' ELSE      txtHRQ END AS [txtHRQ],
                  CASE WHEN txtILIQ = 'NA' OR txtILIQ = '-' OR txtILIQ IS NULL THEN ' ' ELSE txtILIQ END AS [txtILIQ],
                  CASE WHEN txtFIFR = '1' THEN 'SI' ELSE 'NO' END  AS [txtFIFR],
                  CASE WHEN txtIRT = 'NA' OR txtIRT = '-' OR txtIRT IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRT,6),9,6)) END AS [txtIRT],
                  CASE WHEN txtIRTM = 'NA' OR txtIRTM = '-' OR txtIRTM IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRTM,6),9,6)) END AS [txtIRTM],
                  CASE WHEN txtIRTA = 'NA' OR txtIRTA = '-' OR txtIRTA IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRTA,6),9,6)) END AS [txtIRTA],
                  CASE WHEN txtIRTC = 'NA' OR txtIRTC = '-' OR txtIRTC IS NULL THEN ' ' ELSE LTRIM(STR(ROUND(txtIRTC,6),9,6)) END AS [txtIRTC],
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
                   AND txtTv IN ('2','2P','3P','4P','71','73','75','90','91','91SP','92','93','94','95','96','97','98','F','FSP','G','J','JI','JISP','JSP','Q','QSP','PI','R1')
            ORDER BY txtTV, txtEmisora, txtSerie 
 
            -- Cargo información de los keys de las Referencia
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
                        txtRPC AS [txtRPC],
                        txtAGC AS [txtAGC],
                        txtQUIR AS [txtQUIR],
                        txtCALL AS [txtCALL],
                        txtDMF AS [txtDMF],
                        txtDurRef AS [txtDurRef]
            FROM @tblVector
            ORDER BY txtTV, txtEmisora, txtSerie
 
            ELSE
                        RAISERROR ('ERROR: Falta Informacion', 16, 1)
 
      SET NOCOUNT OFF
 
END
GO
 