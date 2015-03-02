
 
----------------------------------------------------------------------------------------  
--   Crea: Omar Aceves   
--   Fecha:   2014-09-24 15:03:55.127   
--   Descripcion:  nuevo producto a base de sp_productos_JPMORGAN;20
----------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;56  
   @txtDate AS DATETIME ,
   @txtLiquidation AS VARCHAR(3)  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 DECLARE @dblUFXU AS FLOAT  
 DECLARE @dblEUR AS FLOAT  
 DECLARE @dblUDI AS FLOAT  
 DECLARE @dblJPY AS FLOAT  
 DECLARE @dblAUD AS FLOAT  
 DECLARE @dblCAD AS FLOAT  
 DECLARE @dblCHF AS FLOAT  
 DECLARE @dblGBP AS FLOAT  
 DECLARE @dblITL AS FLOAT  
 DECLARE @dblBRL AS FLOAT  
 DECLARE @dblInt AS FLOAT    
 DECLARE @dblCLP AS FLOAT  
 DECLARE @dblCOP AS FLOAT  
 DECLARE @dblDKK AS FLOAT  
 DECLARE @dblHKD AS FLOAT  
 DECLARE @dblIDR AS FLOAT  
 DECLARE @dblNOK AS FLOAT  
 DECLARE @dblPEN AS FLOAT  
 DECLARE @dblSEK AS FLOAT  
 DECLARE @dblSGD AS FLOAT  
 DECLARE @dblSMG AS FLOAT  
 DECLARE @dblTWD AS FLOAT  
 DECLARE @dblZAR AS FLOAT  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  [dtedate][VARCHAR](10),  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtCUR][VARCHAR](400),  
  [dblPRL][FLOAT],  
  [dblPRS][FLOAT],  
  [txtPRL_MO][VARCHAR](400),  
  [txtPRS_MO][VARCHAR](400),  
  [txtCPD_MO][VARCHAR](400),  
  [dblCPD][FLOAT],  
  [dblCPA][FLOAT],  
  [dblRate][FLOAT],
  [txtID2][varchar](12)  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  
  
 SET @dblUFXU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UFXU' AND dteDate = @txtDate)  
 SET @dblEUR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'EUR' AND dteDate = @txtDate)  
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UDI' AND dteDate = @txtDate)  
 SET @dblJPY = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'JPY' AND dteDate = @txtDate)  
 SET @dblAUD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'AUD' AND dteDate = @txtDate)  
 SET @dblCAD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CAD' AND dteDate = @txtDate)  
 SET @dblCHF = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CHF' AND dteDate = @txtDate)  
 SET @dblGBP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'GBP' AND dteDate = @txtDate)  
 SET @dblITL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ITL' AND dteDate = @txtDate)  
 SET @dblBRL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'BRL' AND dteDate = @txtDate)  
 SET @dblInt = 1  
 SET @dblCLP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CLP' AND dteDate = @txtDate)  
 SET @dblCOP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'COP' AND dteDate = @txtDate)  
 SET @dblDKK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'DKK' AND dteDate = @txtDate)  
 SET @dblHKD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'HKD' AND dteDate = @txtDate)  
 SET @dblIDR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'IDR' AND dteDate = @txtDate)  
 SET @dblNOK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'NOK' AND dteDate = @txtDate)  
 SET @dblPEN = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'PEN' AND dteDate = @txtDate)  
 SET @dblSEK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SEK' AND dteDate = @txtDate)  
 SET @dblSGD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SGD' AND dteDate = @txtDate)  
 SET @dblSMG = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SMG' AND dteDate = @txtDate)  
 SET @dblTWD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'TWD' AND dteDate = @txtDate)  
 SET @dblZAR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ZAR' AND dteDate = @txtDate)  
  
 -- Reporto Info:  Vector Moneda de Origen (VPrecios)  
 INSERT @tmp_tblResults   
 SELECT DISTINCT  
   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],   
   RTRIM(ap.txtTv) AS [txtTv],  
   RTRIM(ap.txtEmisora) AS [txtEmisora],  
   RTRIM(ap.txtSerie) AS [txtSerie],  
   RTRIM(ap.txtCUR) AS [txtCUR],  
   RTRIM(STR(ROUND(CAST(ap.dblPRL AS FLOAT),6),19,6)),  
   RTRIM(STR(ROUND(CAST(ap.dblPRS AS FLOAT),6),19,6)),  
  --PRL  
   NULL,    
  --PRS  
   NULL,  
   NULL,  
   RTRIM(ap.dblCPD) AS [dblCPD],  
   RTRIM(ap.dblCPA) AS [dblCPA],  
  
   CASE  
   WHEN ap.txtTv IN (  
    'IP',  
    'IT',  
    'L',  
    'LD',  
    'LP',  
    'LS',  
    'LT',  
    'XA',  
    'IS',  
    'IQ',  
    'IM'   
   ) THEN ROUND(ap.dblLDR,6)      
   WHEN ap.txtTv IN (  
    'D',  
    'D3',  
    'G',  
    'I'  
   ) THEN ROUND(ap.dblUDR,6)  
    
   ELSE ROUND(ap.dblYTM,6)   
   
   END AS dblRate, 
   txtID2 
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap (NOLOCK)  
 WHERE ap.dteDate = @txtDate  
  AND ap.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND ap.txtTV NOT IN ('1R','1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP')  
  
 -- Reporto Info:  Vector Moneda de Origen (VNotas)  
 INSERT @tmp_tblResults   
 SELECT DISTINCT  
   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],   
   RTRIM(ap.txtTv) AS [txtTv],  
   RTRIM(ap.txtEmisora) AS [txtEmisora],  
   RTRIM(ap.txtSerie) AS [txtSerie],  
   RTRIM(ap.txtCUR) AS [txtCUR],  
   RTRIM(ap.dblPRL),  
   RTRIM(ap.dblPRS),  
  --PRL  
   NULL,  
   --PRS  
   NULL,  
    NULL,  
   RTRIM(ap.dblCPD) AS [dblCPD],  
   RTRIM(ap.dblCPA) AS [dblCPA],  
  
   CASE  
   WHEN ap.txtTv IN (  
    'IP',  
    'IT',  
    'L',  
    'LD',  
    'LP',  
    'LS',  
    'LT',  
    'XA',  
    'IS',  
    'IQ',  
    'IM'   
   ) THEN ROUND(ap.dblLDR,6)  
    
   WHEN ap.txtTv IN (  
    'D',  
    'D3',  
    'G',  
    'I'  
   ) THEN ROUND(ap.dblUDR,6)  
    
   ELSE ROUND(ap.dblYTM,6)   
   
   END AS dblRate , 
   txtID2  
 FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS ap (NOLOCK)  
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)  
    ON ap.txtId1 = op.txtDir  
 WHERE ap.dteDate = @txtDate  
  AND ap.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND op.txtOwnerId = 'JPM02'  
  AND op.txtProductId = 'SNOTES'  
  
 -- Calculo Precio Limpio MO  
 UPDATE r  
 SET txtPRL_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUFXU),16,9))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRL]/@dblEUR),16,9))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUDI),16,9))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRL]/@dblJPY),16,9))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblAUD),16,9))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCAD),16,9))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCHF),16,9))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblGBP),16,9))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRL]/@dblITL),16,9))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblBRL),16,9))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRL/@dblInt),16,6))  
        
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRL]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRL]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRL]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblPEN),16,9))  
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRL]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR((dblPRL/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR((dblPRL/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST(dblPRL AS FLOAT),6),19,6))   
     END)  
 FROM @tmp_tblResults AS r  
  
 -- Calculo Precio Sucio MO  
 UPDATE r  
 SET txtPRS_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUFXU),16,9))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRS]/@dblEUR),16,9))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUDI),16,9))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRS]/@dblJPY),16,9))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblAUD),16,9))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCAD),16,9))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCHF),16,9))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblGBP),16,9))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRS]/@dblITL),16,9))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblBRL),16,9))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRS/@dblInt),16,6))   
  
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRS]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRS]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRS]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblPEN),16,9))  
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRS]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRS] AS FLOAT),6),19,6))  
     END)  
 FROM @tmp_tblResults AS r    
    
 -- Calculo Interes  
 UPDATE r  
 SET txtCPD_MO =   
     (CASE   
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN STR(ROUND(dblCPD,6),13,6)  
      ELSE ROUND(CAST(txtPRS_MO AS FLOAT),6) - ROUND(CAST(txtPRL_MO AS FLOAT),6)  
      END)   
 FROM @tmp_tblResults AS r  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResults) = 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  -- Reporta información   
  SELECT   
    [dtedate],  
    [txtTv],  
    [txtEmisora],  
    [txtSerie],  
  --PRL MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')   
    THEN STR(ROUND(dblPRL,6),16,6)  
    ELSE   
      (CASE WHEN (txtPRL_MO<>'NA' AND txtPRL_MO<>'-' AND txtPRL_MO<>'')   
       THEN STR(ROUND(CAST(txtPRL_MO AS FLOAT),6),16,6)  
       ELSE '0'  
       END)  
  END,  
  --PRS MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')   
    THEN STR(ROUND(dblPRS,6),16,6)  
    ELSE   
      (CASE WHEN (txtPRS_MO<>'NA' AND txtPRS_MO<>'-' AND txtPRS_MO<>'')   
       THEN STR(ROUND(CAST(txtPRS_MO AS FLOAT),6),16,6)  
       ELSE '0'  
       END)  
  END,  
  -- INTERES CPD  
  CASE   
   WHEN txtCPD_MO = 'NA' OR txtCPD_MO = '-' OR txtCPD_MO = '' THEN 0  
   WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN ROUND(dblCPD,6)  
   ELSE ROUND(CAST(txtCPD_MO AS FLOAT),6)  
  END,  
    [dblCPA],  
    [dblRate],
    CASE WHEN txtID2 IN  ('-','0') THEN 'NA' ELSE txtID2 END 
  FROM @tmp_tblResults  
  
  ORDER BY  
   txtTv,  
   txtEmisora,  
   txtSerie  
     
  
 SET NOCOUNT OFF  
  
END  