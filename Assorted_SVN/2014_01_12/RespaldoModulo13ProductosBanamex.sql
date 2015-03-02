  
-- Autor:   Mike Ramírez  
-- Descripcion:  Procedimiento que genera los productos: BMX02_VectorAnaliticoyyyymmddMD.txt  
-- Fecha Creacion: 12:02 a.m. 2012-02-15  
CREATE PROCEDURE dbo.sp_productos_BANAMEX;13  
  @txtDate AS DATETIME,  
 @txtLiquidation AS VARCHAR(3)  
  
AS   
BEGIN  
  
  SET NOCOUNT ON  
  
 DECLARE @tblVector TABLE (  
  [txtSortTv][VARCHAR](10),  
  [txtSortEmisora][VARCHAR](10),  
  [txtSortSerie][VARCHAR](10),  
  [dtedate][VARCHAR](10),  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [dblPRS][VARCHAR](30),  
  [dblPRL][VARCHAR](30),  
  [dblCPD][VARCHAR](30),  
  [dblCuponCPA][VARCHAR](30),  
  [dblLDR][VARCHAR](30),  
  [txtNEM][VARCHAR](400),  
  [txtSEC][VARCHAR](400),  
  [txtMOE][VARCHAR](400),  
  [txtMOC][VARCHAR](400),  
  [txtISD][VARCHAR](400),  
  [txtTTM][VARCHAR](400),  
  [txtMTD][VARCHAR](400),  
  [txtNOM][VARCHAR](400),  
  [txtCUR][VARCHAR](400),  
  [txtIRCSUBY][VARCHAR](400),  
  [txtCYT][VARCHAR](400),  
  [txtOSP][VARCHAR](400),  
  [txtCPF][VARCHAR](400),  
  [dblTasaCPA][VARCHAR](30),  
  [txtDTC][VARCHAR](400),  
  [txtCRL][VARCHAR](400),  
  [txtTCR][VARCHAR](400),  
  [txtFCR][VARCHAR](400),  
  [txtLPV][VARCHAR](400),  
  [txtLPD][VARCHAR](400),  
  [txtTHP][VARCHAR](400),  
  [txtLCA][VARCHAR](400),  
  [txtLPU][VARCHAR](400),  
  [txtBYT][VARCHAR](400),  
  [txtOYT][VARCHAR](400),  
  [txtBSP][VARCHAR](400),  
  [txtPSP][VARCHAR](400),  
  [txtDPQ][VARCHAR](400),  
  [txtSPQ][VARCHAR](400),  
  [txtBUR][VARCHAR](400),  
  [txtLIQ][VARCHAR](400),  
  [txtDPC][VARCHAR](400),  
  [txtWPC][VARCHAR](400),  
  [txtMHP][VARCHAR](400),  
  [txtIHP][VARCHAR](400),  
  [txtSUS][VARCHAR](400),  
  [txtVOL][VARCHAR](400),  
  [txtVO2][VARCHAR](400),  
  [txtDMF][VARCHAR](400),  
  [txtDMT][VARCHAR](400),  
  [txtCMT][VARCHAR](400),  
  [txtVAR][VARCHAR](400),  
  [txtSTD][VARCHAR](400),  
  [txtVNA][VARCHAR](400),  
  [txtFIQ][VARCHAR](400),  
  [txtDMH][VARCHAR](400),  
  [txtDIH][VARCHAR](400),  
  [txtSTP][VARCHAR](400),  
  [txtDMC][VARCHAR](400),  
  [dblYTM][VARCHAR](30),  
  [txtHRQ][VARCHAR](400),  
  [txtDEF][VARCHAR](400),  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  
  
 DECLARE @tblResult TABLE (  
  [txtSortTv][VARCHAR](10),  
  [txtSortEmisora][VARCHAR](10),  
  [txtSortSerie][VARCHAR](10),  
  [txtData][VARCHAR](8000)  
  PRIMARY KEY CLUSTERED (  
   txtSortTv, txtSortEmisora, txtSortSerie  
   )  
 )  
  
 INSERT @tblVector (txtSortTv,txtSortEmisora,txtSortSerie,dtedate,txtTv,txtEmisora,txtSerie,dblPRS,dblPRL,dblCPD,dblCuponCPA,dblLDR,txtNEM,txtSEC,txtMOE,txtMOC,txtISD,txtTTM,txtMTD,txtNOM,txtCUR,txtIRCSUBY,txtCYT,txtOSP,txtCPF,dblTasaCPA,txtDTC,txtCRL,tx
tTCR,txtFCR,txtLPV,txtLPD,txtTHP,txtLCA,txtLPU,txtBYT,txtOYT,txtBSP,txtPSP,txtDPQ,txtSPQ,txtBUR,txtLIQ,txtDPC,txtWPC,txtMHP,txtIHP,txtSUS,txtVOL,txtVO2,txtDMF,txtDMT,txtCMT,txtVAR,txtSTD,txtVNA,txtFIQ,txtDMH,txtDIH,txtSTP,txtDMC,dblYTM,txtHRQ,txtDEF)  
  SELECT   
    txtTV AS [txtSortTv],  
    txtEmisora AS [txtSortEmisora],  
    txtSerie AS [txtSortSerie],  
    CONVERT(CHAR(8), dteDate,112) AS [dteDate],   
    txtTv AS [txtTv],   
    txtEmisora AS [txtEmisora],  
    txtSerie AS [txtSerie],  
    LTRIM(STR(ROUND(dblPRS,6),16,6)) AS [dblPRS],  
    LTRIM(STR(ROUND(dblPRL,6),16,6)) AS [dblPRL],  
    LTRIM(STR(ROUND(dblCPD,6),16,6)) AS [dblCPD],  
    LTRIM(STR(dblCPA,11,6)) AS [dblCuponCPA],  
    LTRIM(STR(dblLDR,11,6)) AS [dblLDR],  
    LTRIM(RTRIM(REPLACE(txtNEM,CHAR(9),' '))) AS [txtNEM],  
    txtSEC AS [txtSEC],  
    txtMOE AS [txtMOE],  
    txtMOC AS [txtMOC],  
    txtISD AS [txtISD],  
    txtTTM AS [txtTTM],  
    txtMTD AS [txtMTD],  
    txtNOM AS [txtNOM],  
    txtCUR AS [txtCUR],  
    txtIRCSUBY AS [txtIRCSUBY],  
    txtCYT AS [txtCYT],  
    txtOSP AS [txtOSP],  
    txtCPF AS [txtCPF],  
    CASE WHEN dblCPA = 0 THEN '0' ELSE LTRIM(STR(dblCPA,11,6)) END AS [dblTasaCPA],  
    txtDTC AS [txtDTC],  
    RTRIM(txtCRL) AS [txtCRL],  
    txtTCR AS [txtTCR],  
    txtFCR AS [txtFCR],  
    txtLPV AS [txtLPV],  
    txtLPD AS [txtLPD],  
    txtTHP AS [txtTHP],  
    txtLCA AS [txtLCA],  
    txtLPU AS [txtLPU],  
    txtBYT AS [txtBYT],  
    txtOYT AS [txtOYT],  
    txtBSP AS [txtBSP],  
    txtPSP AS [txtPSP],  
    txtDPQ AS [txtDPQ],  
    txtSPQ AS [txtSPQ],  
    txtBUR AS [txtBUR],  
    txtLIQ AS [txtLIQ],  
    txtDPC AS [txtDPC],  
    txtWPC AS [txtWPC],  
    txtMHP AS [txtMHP],  
    txtIHP AS [txtIHP],  
    txtSUS AS [txtSUS],  
    txtVOL AS [txtVOL],  
    txtVO2 AS [txtVO2],  
    [txtDMF] AS [txtDMF],  
    [txtDMT] AS [txtDMT],  
    [txtCMT] AS [txtCMT],  
    txtVAR AS [txtVAR],  
    txtSTD AS [txtSTD],  
    txtVNA AS [txtVNA],  
    txtFIQ AS [txtFIQ],  
    txtDMH AS [txtDMH],  
    txtDIH  AS [txtDIH],  
    [txtSTP] AS [txtSTP],  
    [txtDMC] AS [txtDMC],  
    LTRIM(STR(dblYTM,11,6)) AS [dblYTM],  
    [txtHRQ] AS [txtHRQ],  
    [txtDEF] AS [txtDEF]  
  FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)   
  WHERE txtLiquidation IN (@txtLiquidation,'MP')     
    AND dtedate = @txtDate    
  ORDER BY txtTV, txtEmisora, txtSerie    
  
 -- Info: Notas Estructuradas  
 INSERT @tblVector (txtSortTv,txtSortEmisora,txtSortSerie,dtedate,txtTv,txtEmisora,txtSerie,dblPRS,dblPRL,dblCPD,dblCuponCPA,dblLDR,txtNEM,txtSEC,txtMOE,txtMOC,txtISD,txtTTM,txtMTD,txtNOM,txtCUR,txtIRCSUBY,txtCYT,txtOSP,txtCPF,dblTasaCPA,txtDTC,txtCRL,txt
TCR,txtFCR,txtLPV,txtLPD,txtTHP,txtLCA,txtLPU,txtBYT,txtOYT,txtBSP,txtPSP,txtDPQ,txtSPQ,txtBUR,txtLIQ,txtDPC,txtWPC,txtMHP,txtIHP,txtSUS,txtVOL,txtVO2,txtDMF,txtDMT,txtCMT,txtVAR,txtSTD,txtVNA,txtFIQ,txtDMH,txtDIH,txtSTP,txtDMC,dblYTM,txtHRQ,txtDEF)  
  SELECT   
    txtTV AS [txtSortTv],  
    txtEmisora AS [txtSortEmisora],  
    txtSerie AS [txtSortSerie],  
    CONVERT(CHAR(8), dteDate,112) AS [dteDate],   
    txtTv AS [txtTv],   
    txtEmisora AS [txtEmisora],  
    txtSerie AS [txtSerie],  
    LTRIM(STR(ROUND(dblPRS,6),16,6)) AS [dblPRS],  
    LTRIM(STR(ROUND(dblPRL,6),16,6)) AS [dblPRL],  
    LTRIM(STR(ROUND(dblCPD,6),16,6)) AS [dblCPD],  
    LTRIM(STR(dblCPA,11,6)) AS [dblCuponCPA],  
    LTRIM(STR(dblLDR,11,6)) AS [dblLDR],  
    LTRIM(RTRIM(REPLACE(txtNEM,CHAR(9),' '))) AS [txtNEM],  
    txtSEC AS [txtSEC],  
    txtMOE AS [txtMOE],  
    txtMOC AS [txtMOC],  
    txtISD AS [txtISD],  
    txtTTM AS [txtTTM],  
    txtMTD AS [txtMTD],  
    txtNOM AS [txtNOM],  
    txtCUR AS [txtCUR],  
    txtIRCSUBY AS [txtIRCSUBY],  
    txtCYT AS [txtCYT],  
    txtOSP AS [txtOSP],  
    txtCPF AS [txtCPF],  
    CASE WHEN dblCPA = 0 THEN '0' ELSE LTRIM(STR(dblCPA,11,6)) END AS [dblTasaCPA],  
    txtDTC AS [txtDTC],  
    RTRIM(txtCRL) AS [txtCRL],  
    txtTCR AS [txtTCR],  
    txtFCR AS [txtFCR],  
    txtLPV AS [txtLPV],  
    txtLPD AS [txtLPD],  
    txtTHP AS [txtTHP],  
    txtLCA AS [txtLCA],  
    txtLPU AS [txtLPU],  
    txtBYT AS [txtBYT],  
    txtOYT AS [txtOYT],  
    txtBSP AS [txtBSP],  
    txtPSP AS [txtPSP],  
    txtDPQ AS [txtDPQ],  
    txtSPQ AS [txtSPQ],  
    txtBUR AS [txtBUR],  
    txtLIQ AS [txtLIQ],  
    txtDPC AS [txtDPC],  
    txtWPC AS [txtWPC],  
    txtMHP AS [txtMHP],  
    txtIHP AS [txtIHP],  
    txtSUS AS [txtSUS],  
    txtVOL AS [txtVOL],  
    txtVO2 AS [txtVO2],  
    [txtDMF] AS [txtDMF],  
    [txtDMT] AS [txtDMT],  
    [txtCMT] AS [txtCMT],  
    txtVAR AS [txtVAR],  
    txtSTD AS [txtSTD],  
    txtVNA AS [txtVNA],  
    txtFIQ AS [txtFIQ],  
    txtDMH AS [txtDMH],  
    txtDIH  AS [txtDIH],  
    [txtSTP] AS [txtSTP],  
    [txtDMC] AS [txtDMC],  
    LTRIM(STR(dblYTM,11,6)) AS [dblYTM],  
    [txtHRQ] AS [txtHRQ],  
    [txtDEF] AS [txtDEF]  
  FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS i (NOLOCK)  
   INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS p (NOLOCK)  
    ON i.txtId1 = p.txtDir    
  WHERE txtLiquidation IN (@txtLiquidation,'MP')     
    AND dtedate = @txtDate  
    AND p.txtOwnerId = 'BMX02'    
    AND p.txtProductid = 'SNOTES'  
  ORDER BY txtTV, txtEmisora, txtSerie    
  
 -- Le damos formato al vector  
 INSERT @tblResult (txtSortTv,txtSortEmisora,txtSortSerie,txtData)  
  SELECT   
   [txtSortTv],  
   [txtSortEmisora],  
   [txtSortSerie],  
   [dtedate] + CHAR(9) +  
   [txtTv] + CHAR(9) +  
   [txtEmisora] + CHAR(9) +  
   [txtSerie] + CHAR(9) +  
   [dblPRL] + CHAR(9) +  
   [dblPRS] + CHAR(9) +  
   [dblCPD] + CHAR(9) +  
   [dblCuponCPA] + CHAR(9) +  
   [dblLDR] + CHAR(9) +  
   RTRIM(LTRIM([txtNEM])) + CHAR(9) +  
   RTRIM(LTRIM([txtSEC])) + CHAR(9) +  
   RTRIM(LTRIM([txtMOE])) + CHAR(9) +  
   RTRIM(LTRIM([txtMOC])) + CHAR(9) +  
   RTRIM(LTRIM([txtISD])) + CHAR(9) +  
   RTRIM(LTRIM([txtTTM])) + CHAR(9) +  
   RTRIM(LTRIM([txtMTD])) + CHAR(9) +  
   RTRIM(LTRIM([txtNOM])) + CHAR(9) +  
   RTRIM(LTRIM([txtCUR])) + CHAR(9) +  
   RTRIM(LTRIM([txtIRCSUBY])) + CHAR(9) +  
   RTRIM(LTRIM([txtCYT])) + CHAR(9) +  
   RTRIM(LTRIM([txtOSP])) + CHAR(9) +  
   RTRIM(LTRIM([txtCPF])) + CHAR(9) +  
   [dblTasaCPA] + CHAR(9) +  
   RTRIM(LTRIM([txtDTC])) + CHAR(9) +  
   RTRIM(LTRIM([txtCRL])) + CHAR(9) +  
   RTRIM(LTRIM([txtTCR])) + CHAR(9) +  
   RTRIM(LTRIM([txtFCR])) + CHAR(9) +  
   RTRIM(LTRIM([txtLPV])) + CHAR(9) +  
   RTRIM(LTRIM([txtLPD])) + CHAR(9) +  
   RTRIM(LTRIM([txtTHP])) + CHAR(9) +  
   RTRIM(LTRIM([txtLCA])) + CHAR(9) +  
   RTRIM(LTRIM([txtLPU])) + CHAR(9) +  
   RTRIM(LTRIM([txtBYT])) + CHAR(9) +  
   RTRIM(LTRIM([txtOYT])) + CHAR(9) +  
   RTRIM(LTRIM([txtBSP])) + CHAR(9) +  
   RTRIM(LTRIM([txtPSP])) + CHAR(9) +  
   RTRIM(LTRIM([txtDPQ])) + CHAR(9) +  
   RTRIM(LTRIM([txtSPQ])) + CHAR(9) +  
   RTRIM(LTRIM([txtBUR])) + CHAR(9) +  
   RTRIM(LTRIM([txtLIQ])) + CHAR(9) +  
   RTRIM(LTRIM([txtDPC])) + CHAR(9) +  
   RTRIM(LTRIM([txtWPC])) + CHAR(9) +  
   RTRIM(LTRIM([txtMHP])) + CHAR(9) +  
   RTRIM(LTRIM([txtIHP])) + CHAR(9) +  
   RTRIM(LTRIM([txtSUS])) + CHAR(9) +  
   RTRIM(LTRIM([txtVOL])) + CHAR(9) +  
   RTRIM(LTRIM([txtVO2])) + CHAR(9) +  
   RTRIM(LTRIM([txtDMF])) + CHAR(9) +  
   RTRIM(LTRIM([txtDMT])) + CHAR(9) +  
   RTRIM(LTRIM([txtCMT])) + CHAR(9) +  
   RTRIM(LTRIM([txtVAR])) + CHAR(9) +  
   RTRIM(LTRIM([txtSTD])) + CHAR(9) +  
   RTRIM(LTRIM([txtVNA])) + CHAR(9) +  
   RTRIM(LTRIM([txtFIQ])) + CHAR(9) +  
   RTRIM(LTRIM([txtDMH])) + CHAR(9) +  
   RTRIM(LTRIM([txtDIH])) + CHAR(9) +  
   RTRIM(LTRIM([txtSTP])) + CHAR(9) +  
   RTRIM(LTRIM([txtDMC])) + CHAR(9) +  
   [dblYTM] + CHAR(9) +  
   RTRIM(LTRIM([txtHRQ])) + CHAR(9) +  
   RTRIM(LTRIM([txtDEF]))  
  FROM @tblVector  
  ORDER BY txtSortTV, txtSortEmisora, txtSortSerie  
  
  -- Reportamos el vector  
  SELECT   
   txtData   
  FROM @tblResult  
  
 SET NOCOUNT OFF   
  
END  
     