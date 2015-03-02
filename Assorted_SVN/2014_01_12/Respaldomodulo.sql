--   Modificado por: Lic. René López Salinas  
--   Modificacion: 01:43 p.m. 2010-08-25  
--   Descripcion:     Modulo 1: Inclusion de columnas: ISIN, Mercado  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO]  
       @txtFecha AS VARCHAR(10),   
       @txtLiquidation AS VARCHAR(10)   
  
 AS     
 BEGIN  
  
  SELECT  'Fecha' AS [dteDate],  
   ' Tipo Valor' AS [txtTv],  
   'Emisora' AS [txtEmisora],  
   'Serie' AS [txtSerie],  
   'Precio Limpio' AS [dblPRL],  
   'Precio Sucio' AS [dblPRS],  
   'Intereses Acumulados (Devengados)' AS [dblCPD],  
   'Plazo a Vencimiento (Dias por Vencer)' AS [dblDTM],  
   'Moneda' AS [txtCur],  
   'Tasa Descuento' AS [dblUDR],  
   'Sobretasa' AS [dblLDR],  
          'Duracion' AS [txtDMC],  
   'Rendimiento' AS [dblYTM],  
                 'Fecha Inicio Cupon' AS [txtLCR],  
                 'Fecha Fin Cupon' AS [txtNCR],  
                 'Dias por Vencer del Cupon' AS [txtNCR],  
   'Tasa Cupon Vigente' AS [dblCPA],  
                 'Tipo de Tasa' AS [txtFVR],  
   'ISIN' AS [txtID2],  
   'Mercado' AS [txtMercado]  
  UNION  
  SELECT   
   CONVERT(CHAR(10),a.dteDate,126) AS [Fecha],  
   RTRIM(a.txtTv) AS [TipoValor],  
   RTRIM(a.txtEmisora) AS [Emisora],  
   RTRIM(a.txtSerie) AS [Serie],  
   
   CASE UPPER(a.txtLiquidation)  
    WHEN 'MP'THEN STR(ROUND(a.dblPAV,6),13,6)  
    ELSE STR(ROUND(a.dblPRL,6),13,6)  
   END AS [Precio Limpio],   
  
   CASE UPPER(a.txtLiquidation)  
    WHEN 'MP'THEN STR(ROUND(a.dblPAV,6),13,6)  
    ELSE STR(ROUND(a.dblPRS,6),13,6)  
    END AS [Precio Sucio],  
   
   STR(ROUND(a.dblCPD,6),13,6) AS [Intereses Acumulados (Devengados)],  
  
   STR(ROUND(a.dblDTM,6),13) AS [Plazo a Vencimiento (Dias por Vencer)],  
  
     CASE  WHEN (a.txtCUR<>'NA' AND a.txtCUR<>'-' AND a.txtCUR<>'') THEN   
         CASE WHEN (RTRIM(a.txtCUR)='MPS' OR RTRIM(a.txtCUR)='MXN' OR RTRIM(a.txtCUR)='[MPS] Peso Mexicano (MXN)') THEN 'MXN'  
            WHEN (RTRIM(a.txtCUR)='UFXU' OR RTRIM(a.txtCUR)='DLL' OR RTRIM(a.txtCUR)='USD' OR RTRIM(a.txtCUR)='[USD] Dolar Americano (MXN)') THEN 'USD'  
         WHEN (RTRIM(a.txtCUR)='UDI' OR RTRIM(a.txtCUR)='MUD' OR RTRIM(a.txtCUR)='[UDI] Unidades de Inversion (MXN)') THEN 'UDI'  
         WHEN (RTRIM(a.txtCUR)='EUR' OR RTRIM(a.txtCUR)='[EUR] Euro (MXN)') THEN 'EUR'   
         WHEN (RTRIM(a.txtCUR)='JPY' OR RTRIM(a.txtCUR)='[JPY] Yen Japones (MXN)') THEN 'JPY' ELSE ''  
           END   
                                ELSE '' -- a.txtCUR  
            END AS [Moneda],  
  
                 CASE  WHEN ABS(dblUDR) < 1E-6 THEN  '0.0'  
                        ELSE STR(ROUND(a.dblUDR,6),13,6)  
                 END AS [Tasa Descuento],  
  
    CASE  WHEN ABS(a.dblLDR) < 1E-6 THEN '0.0'  
               ELSE STR(ROUND(a.dblLDR,6),13,6)  
               END AS [Sobretasa],  
  
    CASE  WHEN (a.txtDMC<>'NA' AND a.txtDMC<>'-' AND a.txtDMC<>'' AND a.txtDMC IS NOT NULL) THEN a.txtDMC  
                ELSE ''  
                END AS [Duracion],  
  
                   CASE  WHEN ABS(a.dblYTM) < 1E-6 THEN '0.0'  
           ELSE STR(ROUND(a.dblYTM,6),13,6)  
           END AS [Rendimiento],  
  
                 CASE    WHEN (a.txtLCR = '-' OR RTRIM(a.txtLCR) = 'NA' OR a.txtLCR IS NULL ) THEN ''  
                      ELSE CONVERT(CHAR(10),CAST(a.txtLCR AS DATETIME),126)  
                  END  AS [Fecha Inicio Cupon],  
  
                 CASE    WHEN (a.txtNCR = '-' OR RTRIM(a.txtNCR) = 'NA' OR a.txtNCR IS NULL ) THEN ''  
                      ELSE CONVERT(CHAR(10),CAST(a.txtNCR AS DATETIME),126)  
                  END  AS [Fecha Fin Cupon],  
  
                 CASE WHEN (a.txtNCR = '-' OR RTRIM(a.txtNCR) = 'NA' OR a.txtNCR IS NULL ) THEN ''  
                      ELSE STR(ROUND(DATEDIFF(DAY,a.dteDate,CAST(a.txtNCR AS DATETIME )),6),13)  
                  END  AS [Dias por Vencer del Cupon],  
  
                   CASE  WHEN ABS(a.dblCPA) < 1E-6 THEN '0.0'  
           ELSE STR(ROUND(a.dblCPA,6),13,6)  
           END AS [Tasa Cupon Vigente],  
  
                 CASE WHEN (a.txtFVR = '-' OR RTRIM(a.txtFVR) = 'NA' OR a.txtFVR IS NULL ) THEN ''  
                      ELSE a.txtFVR  
                  END  AS [Tipo de Tasa],  
   CASE  
    WHEN (a.txtID2 IS NULL OR RTRIM(a.txtID2) = 'NA' OR LEN(a.txtID2) <> 12) THEN ''   
    ELSE CONVERT(CHAR(12),a.txtID2)  
            END AS [txtID2],  
   CASE  
    WHEN a.txtTV IN ('2U','3U','4U','6U','92','95','96','B','BI','CC','CP','D1','D1SP','IP','IS','IT','L',  
         'LD','LP','LS','LT','M','M0','M3','M5','M7','MC','MP','PI','S','S0','S3','S5','SC',  
         'SP','TR','XA') THEN 'G'   
    ELSE ''  
            END AS [txtMercado]  
  FROM  tmp_tblUnifiedPricesReport a   
   INNER JOIN tblTvCatalog b ON a.txtTv = b.txtTv  
  WHERE a.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND  a.txtTv NOT IN ('*D','*F','*R')  
  ORDER BY a.txtTv,a.txtEmisora,a.txtSerie  
  
END  
  
------------------------------------------------------------------------------------------------------------------------------------------------  
--   Modificado por:  Mike Ramírez    
--   Modificacion:   10:01 a.m. 2012-10-19    
--   Descripcion Modulo2: Se modificará la regla de nivel para que, en caso de no haber datos para una fecha, se tome el último valor conocido  
------------------------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];2  
 @txtDate AS VARCHAR(10)    
 AS     
 BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],'Fecha,Cetes 1,Cetes 7,Cetes 28,Cetes 91,Cetes 182,Cetes 278,Cetes 364,Cetes 720,Cetes 1092,Cetes 1830,Cetes 2548,Cetes 3630,Cetes 4368,Cetes 5096,Cetes 5460,Cetes 5824,Cetes 6552,Cetes 7280,Cetes 10950' AS [Lab
el],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET' AS [Type],'CT,CT,CT,CT,CT,CT,CT,CT,CT,CT,CT,CT,CT,CT,
CT,CT,CT,CT,CT' AS [SubType], '1,7,28,91,182,278,364,728,1092,1830,2540,3620,4370,5090,5450,5810,6560,7280,10950' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION   
    SELECT 3 AS [Row],'Header' AS [TypeColumn],'Fecha,Pagare 1,Pagare 7,Pagare 28,Pagare 91,Pagare 182,Pagare 278,Pagare 364,Pagare 728,Pagare 1092,Pagare 1830' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Fac
tor] UNION  
 SELECT 4 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'PLV,PLV,PLV,PLV,PLV,PLV,PLV,PLV,PLV,PLV' AS [Type],'3A,3A,3A,3A,3A,3A,3A,3A,3A,3A' AS [SubType], '1,7,28,91,182,278,364,728,1092,1
830' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 5 AS [Row],'Header' AS [TypeColumn],'Fecha,Real 1,Real 28,Real 91,Real 182,Real 364,Real 728,Real 109,Real 146,Real 183,Real 255,Real 363,Real 546,Real 729,Real 910,Real 1092' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos]
, '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 6 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB' AS [Type],'U%,U%,U%,U%,U%,U%,U%,U%,U%,U%,U%,U%,U%,U%,U%' AS [SubType]
, '1,28,91,182,364,728,1092,1460,1830,2540,3620,5470,7290,9110,10930' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 7 AS [Row],'Header' AS [TypeColumn],'Fecha,INMEX,IPC,FIX,UDI,TIIE 28,TIIE 91,IND.SOC.INV.,IND.SOC.DEUDA P,TIPO DE CAMBIO DEL YEN,TIPO DE CAMBIO DEL EUR,Índice de dividendos del ,IRT,Tipo de Cambio USD Spot,Tipo de Cambio DOLAR CAN,MSCI Daily TR
 Net World USD,MSCI AC WORLD DAILY' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 8 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'INM,IPC,UFXU,UDI,T028,T091,ISOC1,ISOC3,JPY,EUR,IDIPC,IRT,USD2,CAD,NDDUWI,NDUEACW' AS [Nodos], '' AS [H
LD], '1' AS [Factor] UNION  
 SELECT 9 AS [Row],'Header' AS [TypeColumn],'Fecha,Reporto Bancario 1,Reporto Bancario 7,Reporto Bancario 28,Reporto Bancario 91,Reporto Bancario 182,Reporto Bancario 360' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD],'
0' AS [Factor] UNION  
 SELECT 10 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'RB1,RB1,RB1,RB1,RB1,RB1' AS [Type],'B1,B1,B1,B1,B1,B1' AS [SubType], '1,7,28,91,182,360' AS [Nodos], '' AS [HLD], '1' AS [Factor]
 UNION  
    SELECT 11 AS [Row],'Header' AS [TypeColumn],'Fecha,Reporto Gubernamental 1,Reporto Gubernamental 7,Reporto Gubernamental 28,Reporto Gubernamental 91,Reporto Gubernamental 182,Reporto Gubernamental 360' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubT
ype], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 12 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'RG1,RG1,RG1,RG1,RG1,RG1' AS [Type],'G1,G1,G1,G1,G1,G1' AS [SubType], '1,7,28,91,182,360' AS [Nodos], '' AS [HLD], '1' AS [Factor]
 UNION  
    SELECT 13 AS [Row],'Header' AS [TypeColumn],'Fecha,BONDES28 28,BONDES28 364,BONDES28 728,BONDES91 364,BONDES91 728,BONDES91 1092,BONDES182 1092,IPABONO 1078,IPABONO 1792' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD
], '0' AS [Factor] UNION  
 SELECT 14 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'BDE,BDE,BDE,BDE,BDE,BDE,BDE,BPA,BPA' AS [Type],'OL,OL,OL,LT,LT,LT,SE,BP,BP' AS [SubType], '28,364,728,364,728,1092,1000,1078,1792
' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 15 AS [Row],'Header' AS [TypeColumn],'Fecha,M3 720,M3 1080,M5 1800' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 16 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType],'IM720,IM3YR,IM5YR' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION      
    SELECT 17 AS [Row],'Header' AS [TypeColumn],'Fecha,Primaria Cetes28,Primaria Cetes91,Primaria Cetes182,Primaria Cetes364' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 18 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType],'W028,W091,W182,W364' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 19 AS [Row],'Header' AS [TypeColumn],'Fecha,TFB (ANTERIOR),TFB (ACTUAL),TFG (ANTERIOR),TFG (ACTUAL)' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 20 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'TFB,TFB,TFG,TFG' AS [Nodos], '-1,0,-1,0' AS [HLD], '1' AS [Factor] UNION  
    SELECT 21 AS [Row],'Header' AS [TypeColumn],'Fecha,NAFTRAC' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 22 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'PRICES' AS [FRPIP],'' AS [Type],'' AS [SubType], 'MDOK9700001_PAV_MP' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 23 AS [Row],'Header' AS [TypeColumn],'Fecha,EUR,USD' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 24 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'EUR,UFXU' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 25 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
    SELECT 26 AS [Row],'Header' AS [TypeColumn],'Fecha,Libor Yen 1,Libor Yen 28,Libor Yen 91,Libor Yen 182,Libor Yen 364,Libor Yen 728,Libor Yen 1092,Libor Yen 1456,Libor Yen 1820,Libor Yen 2548,Libor Yen 3640,Libor Yen 5450,Libor Yen 7280,Libor Yen 9100,
Libor Yen 10800' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 27 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB' AS [Type],'JPY,JPY,JPY,JPY,JPY,JPY,JPY,JPY,JPY,JPY,JPY,JPY,JPY,JPY,J
PY' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2540,3620,5450,7280,9110,10800' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 28 AS [Row],'Header' AS [TypeColumn],'Fecha,Libor Euro 1,Libor Euro 28,Libor Euro 91,Libor Euro 182,Libor Euro 364,Libor Euro 728,Libor Euro 1092,Libor Euro 1456,Libor Euro 1820,Libor Euro 2548,Libor Euro 3640,Libor Euro 5450,Libor Euro 7280,Li
bor Euro 9100,Libor Euro 10800' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 29 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB' AS [Type],'EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,E
UR' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2540,3620,5450,7280,9110,10800' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 30 AS [Row],'Header' AS [TypeColumn],'Fecha,Libor CanD 1,Libor CanD 28,Libor CanD 91,Libor CanD 182,Libor CanD 364,Libor CanD 728,Libor CanD 1092,Libor CanD 1456,Libor CanD 1820,Libor CanD 2548,Libor CanD 3640,Libor CanD 5450,Libor CanD 7280,Li
bor CanD 9100,Libor CanD 10800' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 31 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB' AS [Type],'CAD,CAD,CAD,CAD,CAD,CAD,CAD,CAD,CAD,CAD,CAD,CAD,CAD,CAD,C
AD' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2540,3620,5450,7280,9110,10800' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 32 AS [Row],'Header' AS [TypeColumn],'Fecha,Libor USD 1,Libor USD 28,Libor USD 91,Libor USD 182,Libor USD 364,Libor USD 728,Libor USD 1092,Libor USD 1456,Libor USD 1820,Libor USD 2548,Libor USD 3640,Libor USD 5450,Libor USD 7280,Libor USD 9100,
Libor USD 10920' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 33 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB,LIB' AS [Type],'BL,BL,BL,BL,BL,BL,BL,BL,BL,BL,BL,BL,BL,BL,BL' AS [SubType
], '1,28,91,182,364,728,1092,1456,1820,2540,3620,5450,7280,9110,10910' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 34 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
    SELECT 35 AS [Row],'Header' AS [TypeColumn],'Fecha,Fras TIIE 1,Fras TIIE 28,Fras TIIE 91,Fras TIIE 182,Fras TIIE 364,Fras TIIE 728,Fras TIIE 1092,Fras TIIE 1456,Fras TIIE 1820,Fras TIIE 2548,Fras TIIE 3640,Fras TIIE 5450,Fras TIIE 7280,Fras TIIE 9100,
Fras TIIE 10920' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 36 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS,TDS' AS [Type],'T28,T28,T28,T28,T28,T28,T28,T28,T28,T28,T28,T28,T28,T28,T
28' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2548,3640,5450,7280,9100,10920' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 37 AS [Row],'Header' AS [TypeColumn],'Fecha,Descuento IRS 1,Descuento IRS 28,Descuento IRS 91 ,Descuento IRS 182,Descuento IRS 364,Descuento IRS 728,Descuento IRS 1092,Descuento IRS 1456,Descuento IRS 1820,Descuento IRS 2548,Descuento IRS 3640,
Descuento IRS 5450,Descuento IRS 7280,Descuento IRS 9100,Descuento IRS 10920' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 38 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP' AS [Type],'TI,TI,TI,TI,TI,TI,TI,TI,TI,TI,TI,TI,TI,TI,TI' AS [SubType
], '1,28,91,182,364,728,1092,1456,1820,2548,3640,5450,7280,9100,10920' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 39 AS [Row],'Header' AS [TypeColumn],'Fecha,Cross Currency ask 1,Cross Currency ask 28,Cross Currency ask 91,Cross Currency ask 182,Cross Currency ask 364,Cross Currency ask 728,Cross Currency ask 1092,Cross Currency ask 1456,Cross Currency ask
 1820,Cross Currency ask 2548,Cross Currency ask 3640,Cross Currency ask 5450,Cross Currency ask 7280,Cross Currency ask 9100,Cross Currency ask 10920' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNIO
N  
 SELECT 40 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS,LTS' AS [Type],'VTA,VTA,VTA,VTA,VTA,VTA,VTA,VTA,VTA,VTA,VTA,VTA,VTA,VTA,V
TA' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2548,3640,5450,7280,9100,10920' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 41 AS [Row],'Header' AS [TypeColumn],'Fecha,UMS 1,UMS 28,UMS 91,UMS 182,UMS 364,UMS 728,UMS 1092,UMS 1456,UMS 1820,UMS 2548,UMS 3640,UMS 5450,UMS 7280,UMS 9100,UMS 10920' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' 
AS [HLD], '0' AS [Factor] UNION  
 SELECT 42 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS,UMS' AS [Type],'YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,Y
LD' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2540,3620,5450,7280,9110,12000' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION    
    SELECT 43 AS [Row],'Header' AS [TypeColumn],'Fecha,Treasury 1,Treasury 28,Treasury 91,Treasury 182,Treasury 364,Treasury 728,Treasury 1092,Treasury 1456,Treasury 1820,Treasury 2548,Treasury 3640,Treasury 5450,Treasury 7280,Treasury 9100,Treasury 10920
' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 44 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN,TSN' AS [Type],'YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,YLD,Y
LD' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2540,3620,5450,7280,9110,10910' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 45 AS [Row],'Header' AS [TypeColumn],'Fecha,Cetes (+imp) 1,Cetes (+imp) 7,Cetes (+imp) 28,Cetes (+imp) 91,Cetes (+imp) 182,Cetes (+imp) 278,Cetes (+imp) 364,Cetes (+imp) 728,Cetes (+imp) 1092,Cetes (+imp) 1830,Cetes (+imp) 2548,Cetes (+imp) 363
0,Cetes (+imp) 4368,Cetes (+imp) 5096,Cetes (+imp) 5460,Cetes (+imp) 5824,Cetes (+imp) 6552,Cetes (+imp) 7280,Cetes (+imp) 10950' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 46 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET,CET' AS [Type],'CTI,CTI,CTI,CTI,CTI,CTI,CTI,CTI,CTI,CTI,C
TI,CTI,CTI,CTI,CTI,CTI,CTI,CTI,CTI' AS [SubType], '1,7,28,91,182,278,364,728,1092,1830,2540,3620,4370,5090,5450,5810,6560,7280,10950' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 47 AS [Row],'Header' AS [TypeColumn],'Fecha,Real (+imp) 1,Real (+imp) 28,Real (+imp) 91,Real (+imp) 182,Real (+imp) 364,Real (+imp) 728,Real (+imp) 1092,Real (+imp) 1460,Real (+imp) 1830,Real (+imp) 2550,Real (+imp) 3630,Real (+imp) 5460,Real (
+imp) 7290,Real (+imp) 9100,Real (+imp) 10920' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 48 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB,UDB' AS [Type],'UUI,UUI,UUI,UUI,UUI,UUI,UUI,UUI,UUI,UUI,UUI,UUI,UUI,UUI,U
UI' AS [SubType], '1,28,91,182,364,728,1092,1460,1830,2540,3620,5470,7290,9110,10930' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 49 AS [Row],'Header' AS [TypeColumn],'Fecha,BXPV28,BXPV91,BXPV182' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 50 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'BXPV28,BXPV91,BXPV182' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 51 AS [Row],'Header' AS [TypeColumn],'Fecha,NASDAQ COMPOSITE INDEX,DOW JONES INDUS.AVG,S&P 500 INDEX,Russel 3000' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 52 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'CCMP,INDU,SPX,RAY' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 53 AS [Row],'Header' AS [TypeColumn],'Fecha,MSCI Daily TR Net World USD Regional,MSCI AC Asia EX. Japan,S&P/Citigroup World Property Total Return Index,MSCI BRAZIL Index,LATIBE TOP,DAX,Nikkei,Topix,INDU,JPYUSD,MXPJPY,USDEUR,NDX,BFK,BRLUSD,CLPUS
D,MXLA,PEN,COP,Nasdaq 100 index tracking stock,EWZ,EWH,EWA,Vanguard Total World Stock ETF' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 54 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'NDDUWIF,NDUECAX,SPBMWDT,M1BR,LATIBE2,DAX,NKY,TPX,INDU,JPYX,JPY,EURU,NDX,NDUEBRI,BRLX,CLPX,MXLA,PENX,C
OPX,QQQ,EWZ,EWH,EWA,VT' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 55 AS [Row],'Header' AS [TypeColumn],'Fecha,BANAMEX UDIPAGARE,BANOBRA U06008 F' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 56 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'PRICES' AS [FRPIP],'' AS [Type],'' AS [SubType], 'MAAD8599552_PRS_24H,MBBA8200521_PRS_24H' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 57 AS [Row],'Header' AS [TypeColumn],'Fecha,Libor Euribor 1,Libor Euribor 28,Libor Euribor 91,Libor Euribor 182,Libor Euribor 364,Libor Euribor 728,Libor Euribor 1092,Libor Euribor 1456,Libor Euribor 1820,Libor Euribor 2548,Libor Euribor 3640,L
ibor Euribor 5450,Libor Euribor 7280,Libor Euribor 9100,Libor Euribor 10800' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 58 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'CURVES' AS [FRPIP],'EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR' AS [Type],'EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,EUR,E
UR' AS [SubType], '1,28,91,182,364,728,1092,1456,1820,2548,3640,5450,7280,9100,10800' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 59 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
    SELECT 60 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
    SELECT 61 AS [Row],'Header' AS [TypeColumn],'Fecha,IMC30' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 62 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'IMC30' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 63 AS [Row],'Header' AS [TypeColumn],'Fecha,IPCCOMP,IPCLARG,IPCMID,IPCSMAL' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 64 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'IPCCOMP,IPCLARG,IPCMID,IPCSMAL' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 65 AS [Row],'Header' AS [TypeColumn],'Fecha,IRTCOMP,IRTLARG,IRTMID,IRTSMAL' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 66 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'IRTCOMP,IRTLARG,IRTMID,IRTSMAL' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
    SELECT 67 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
    SELECT 68 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 69 AS [Row],'Header' AS [TypeColumn],'Fecha,IBOXIG,iShares S&P 500 (IVV),iShares S&P Europe 350 (IEV),iShares MSCI Japan (EWJ),MSCI Daily TR Net Emerging Markets,iShares S&P GSCI Commodity-Indexed Trust' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS
 [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 70 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),103) AS [Label],'IRCL' AS [FRPIP],'' AS [Type],'' AS [SubType], 'IBOXIG,IVV,IEV,EWJ,NDUEEGF,GSG' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
  
END  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];3  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS     
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para extraer los reportes mensuales de tasas :: ubibonos :: precios  
  
 Modificado por: Csolorio  
 Modificacion: 20110331  
 Descripcion:    Modifico para que solo considere fechas habiles de México  
*/  
BEGIN    
   
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'S%'  
   AND i.txtTv NOT IN ('SP', 'SC')  
  )  
  AND b.dteMaturity >= @txtEndDate  
 ORDER BY   
  i.txtTv,  
  b.dteMaturity  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END)/ir.dblValue, 20, 8)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
   
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 3) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate >= ''' + @txtBegDate + '''' +   
   ' AND hp.dteDate <= ''' + @txtEndDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+  
  ' UNION ' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 3) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist_2011..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate >= ''' + @txtBegDate + '''' +   
   ' AND hp.dteDate <= ''' + @txtEndDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
   ' AND dbo.fun_IsTradingDate(hp.dteDate,''MX'') = 1'+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+   
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  'MUDI' + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 3)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];4  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS  
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para extraer los reportes mensuales de tasas :: bonos M :: precios  
  
 Modificado por: Csolorio  
 Modificacion: 20110331  
 Descripcion:    Modifico para que solo considere fechas habiles de México  
*/     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity >= @txtEndDate  
 ORDER BY   
  i.txtTv,  
  b.dteMaturity  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END), 20, 8)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 3) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate >= ''' + @txtBegDate + '''' +   
   ' AND hp.dteDate <= ''' + @txtEndDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' UNION' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 3) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate >= ''' + @txtBegDate + '''' +   
   ' AND hp.dteDate <= ''' + @txtEndDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND dbo.fun_IsTradingDate(hp.dteDate,''MX'') = 1'+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  'MBONO' + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 3)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
  
-- para extraer los reportes mensuales de tasas :: interbancaria  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];5  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 -- creo tablas temporales para guardar directivas  
 -- de generacion del producto  
  
 DECLARE @tblDiasHabiles_INGBANKMEXICO TABLE (  
  dteDate DATETIME  
 PRIMARY KEY CLUSTERED (dteDate))  
  
 DECLARE @tblCurves_INGBANKMEXICO TABLE (  
  dteDate DATETIME,  
  intTerm INT,  
  dblRate FLOAT  
 PRIMARY KEY CLUSTERED (dteDate,intTerm))  
  
 INSERT @tblDiasHabiles_INGBANKMEXICO  
 SELECT DISTINCT dteDate FROM tblIRC WHERE dteDate >= @txtBegDate AND dteDate <= @txtEndDate AND txtIRC = 'UFXU'  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncome..tblCurves AS a --INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate  
  WHERE  
  a.txtType = 'SWP'  
  AND a.txtSubType = 'TI'   
  AND a.intTerm IN  ( 1, 28)  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncomeHist..tblHistoricCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate   
  WHERE  
  a.txtType = 'SWP'  
  AND a.txtSubType = 'TI'   
  AND a.intTerm IN  ( 1, 28)  
  
 SET NOCOUNT OFF  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 3) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate ELSE -999 END), 10, 4)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate ELSE -999 END), 10, 4)) AS [4W]  
  FROM @tblCurves_INGBANKMEXICO  
  GROUP BY   
  dteDate  
  
END  
  
-- para extraer los reportes mensuales de tasas :: cetes  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];6  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 -- creo tablas temporales para guardar directivas  
 -- de generacion del producto  
  
 DECLARE @tblDiasHabiles_INGBANKMEXICO TABLE (  
  dteDate DATETIME  
 PRIMARY KEY CLUSTERED (dteDate))  
  
 DECLARE @tblCurves_INGBANKMEXICO TABLE (  
  dteDate DATETIME,  
  intTerm INT,  
  dblRate FLOAT  
 PRIMARY KEY CLUSTERED (dteDate,intTerm))  
  
 INSERT @tblDiasHabiles_INGBANKMEXICO  
 SELECT DISTINCT dteDate FROM tblIRC WHERE dteDate >= @txtBegDate AND dteDate <= @txtEndDate AND txtIRC = 'UFXU'  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncome..tblCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate  
  WHERE  
  a.txtType = 'CET'  
  AND a.txtSubType = 'CT'   
  AND a.intTerm IN  (1,28,91,182,273,364)  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncomeHist..tblHistoricCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate   
  WHERE  
  a.txtType = 'CET'  
  AND a.txtSubType = 'CT'   
  AND a.intTerm IN  (1,28,91,182,273,364)  
  
 SET NOCOUNT OFF  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 3) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate ELSE -999 END), 10, 4)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate ELSE -999 END), 10, 4)) AS [4W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 91 THEN dblRate ELSE -999 END), 10, 4)) AS [13W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 182 THEN dblRate ELSE -999 END), 10, 4)) AS [26W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 273 THEN dblRate ELSE -999 END), 10, 4)) AS [39W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate ELSE -999 END), 10, 4)) AS [52W]  
  FROM @tblCurves_INGBANKMEXICO  
  GROUP BY   
  dteDate  
  
END  
  
  
-- para extraer los reportes mensuales de tasas :: cetes i  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];7  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 -- creo tablas temporales para guardar directivas  
 -- de generacion del producto  
  
 DECLARE @tblDiasHabiles_INGBANKMEXICO TABLE (  
  dteDate DATETIME  
 PRIMARY KEY CLUSTERED (dteDate))  
  
 DECLARE @tblCurves_INGBANKMEXICO TABLE (  
  dteDate DATETIME,  
  intTerm INT,  
  dblRate FLOAT  
 PRIMARY KEY CLUSTERED (dteDate,intTerm))  
  
 INSERT @tblDiasHabiles_INGBANKMEXICO  
 SELECT DISTINCT dteDate FROM tblIRC WHERE dteDate >= @txtBegDate AND dteDate <= @txtEndDate AND txtIRC = 'UFXU'  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncome..tblCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate  
  WHERE  
  a.txtType = 'CET'  
  AND a.txtSubType = 'CTI'   
  AND a.intTerm IN  (1,28,91,182,273,364)  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncomeHist..tblHistoricCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate   
  WHERE  
  a.txtType = 'CET'  
  AND a.txtSubType = 'CTI'   
  AND a.intTerm IN  (1,28,91,182,273,364)  
  
 SET NOCOUNT OFF  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 3) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate ELSE -999 END), 10, 4)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate ELSE -999 END), 10, 4)) AS [4W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 91 THEN dblRate ELSE -999 END), 10, 4)) AS [13W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 182 THEN dblRate ELSE -999 END), 10, 4)) AS [26W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 273 THEN dblRate ELSE -999 END), 10, 4)) AS [39W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate ELSE -999 END), 10, 4)) AS [52W]  
  FROM @tblCurves_INGBANKMEXICO  
  GROUP BY   
  dteDate  
  
END  
  
  
-- para extraer los reportes mensuales de tasas :: IRS  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];8  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 -- creo tablas temporales para guardar directivas  
 -- de generacion del producto  
  
 DECLARE @tblDiasHabiles_INGBANKMEXICO TABLE (  
  dteDate DATETIME  
 PRIMARY KEY CLUSTERED (dteDate))  
  
 DECLARE @tblCurves_INGBANKMEXICO TABLE (  
  dteDate DATETIME,  
  intTerm INT,  
  dblRate FLOAT  
 PRIMARY KEY CLUSTERED (dteDate,intTerm))  
  
 INSERT @tblDiasHabiles_INGBANKMEXICO  
 SELECT DISTINCT dteDate FROM tblIRC WHERE dteDate >= @txtBegDate AND dteDate <= @txtEndDate AND txtIRC = 'UFXU'  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncome..tblCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate  
  WHERE  
  a.txtType = 'TIE'  
  AND a.txtSubType = 'SWP'   
  AND a.intTerm IN  (84,168,252,364,728,1092,1456,1820,2548,3640,5460,7280)  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncomeHist..tblHistoricCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate   
  WHERE  
  a.txtType = 'TIE'  
  AND a.txtSubType = 'SWP'   
  AND a.intTerm IN  (84,168,252,364,728,1092,1456,1820,2548,3640,5460,7280)  
  
 SET NOCOUNT OFF  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 3) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 84 THEN dblRate ELSE -999 END), 10, 4)) AS [84],  
  LTRIM(STR(MAX(CASE intTerm WHEN 168 THEN dblRate ELSE -999 END), 10, 4)) AS [168],  
  LTRIM(STR(MAX(CASE intTerm WHEN 252 THEN dblRate ELSE -999 END), 10, 4)) AS [252],  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate ELSE -999 END), 10, 4)) AS [364],  
  LTRIM(STR(MAX(CASE intTerm WHEN 728 THEN dblRate ELSE -999 END), 10, 4)) AS [728],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1092 THEN dblRate ELSE -999 END), 10, 4)) AS [1092],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1456 THEN dblRate ELSE -999 END), 10, 4)) AS [1456],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1820 THEN dblRate ELSE -999 END), 10, 4)) AS [1820],  
  LTRIM(STR(MAX(CASE intTerm WHEN 2548 THEN dblRate ELSE -999 END), 10, 4)) AS [2548],  
  LTRIM(STR(MAX(CASE intTerm WHEN 3640 THEN dblRate ELSE -999 END), 10, 4)) AS [3640],  
  LTRIM(STR(MAX(CASE intTerm WHEN 5460 THEN dblRate ELSE -999 END), 10, 4)) AS [5460],  
  LTRIM(STR(MAX(CASE intTerm WHEN 7280 THEN dblRate ELSE -999 END), 10, 4)) AS [7280]  
  FROM @tblCurves_INGBANKMEXICO  
  GROUP BY   
  dteDate  
  
END  
  
-- para extraer los reportes mensuales de tasas :: Forward Implicita  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];9  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 -- creo tablas temporales para guardar directivas  
 -- de generacion del producto  
  
 DECLARE @tblDiasHabiles_INGBANKMEXICO TABLE (  
  dteDate DATETIME  
 PRIMARY KEY CLUSTERED (dteDate))  
  
 DECLARE @tblCurves_INGBANKMEXICO TABLE (  
  dteDate DATETIME,  
  intTerm INT,  
  dblRate FLOAT  
 PRIMARY KEY CLUSTERED (dteDate,intTerm))  
  
 INSERT @tblDiasHabiles_INGBANKMEXICO  
 SELECT DISTINCT dteDate FROM tblIRC WHERE dteDate >= @txtBegDate AND dteDate <= @txtEndDate AND txtIRC = 'UFXU'  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncome..tblCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate  
  WHERE  
  a.txtType = 'FWD'  
  AND a.txtSubType = 'CU'   
  AND a.intTerm IN  (1,30,60,90,180,270,360,540,728,1092,1456,1820)  
  
  INSERT @tblCurves_INGBANKMEXICO   
  SELECT   
  a.dteDate,  
  a.intTerm,  
  a.dblRate * 100  
  FROM MxFixIncomeHist..tblHistoricCurves AS a INNER JOIN @tblDiasHabiles_INGBANKMEXICO AS b ON a.dteDate = b.dteDate   
  WHERE  
  a.txtType = 'FWD'  
  AND a.txtSubType = 'CU'   
  AND a.intTerm IN  (1,30,60,90,180,270,360,540,728,1092,1456,1820)  
  
 SET NOCOUNT OFF  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 3) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate ELSE -999 END), 10, 4)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 30 THEN dblRate ELSE -999 END), 10, 4)) AS [1M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 60 THEN dblRate ELSE -999 END), 10, 4)) AS [2M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 90 THEN dblRate ELSE -999 END), 10, 4)) AS [3M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 180 THEN dblRate ELSE -999 END), 10, 4)) AS [6M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 270 THEN dblRate ELSE -999 END), 10, 4)) AS [9M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 360 THEN dblRate ELSE -999 END), 10, 4)) AS [12M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 540 THEN dblRate ELSE -999 END), 10, 4)) AS [18M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 728 THEN dblRate ELSE -999 END), 10, 4)) AS [2Y],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1092 THEN dblRate ELSE -999 END), 10, 4)) AS [3Y],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1456 THEN dblRate ELSE -999 END), 10, 4)) AS [4Y],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1820 THEN dblRate ELSE -999 END), 10, 4)) AS [5Y]  
  FROM @tblCurves_INGBANKMEXICO  
  GROUP BY   
  dteDate  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];10  
 @txtBegDate AS VARCHAR(10),  
 @txtEndDate AS VARCHAR(10)  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para extraer los reportes mensuales de tasas :: verificador  
  
 Modificado por: Csolorio  
 Modificacion: 20110331  
 Descripcion:    Modifico para que solo considere fechas habiles en México  
*/    
BEGIN  
  
 SELECT COUNT(txtIrc) AS intTotal  
 FROM tblIrc  
 WHERE  
  txtIrc = 'UFXU'  
  AND dteDate >= @txtBegDate  
  AND dteDate <= @txtEndDate  
  AND dbo.fun_IsTradingDate(dteDate,'MX')= 1  
  
END   
  
  
  
-- para extraer los reportes diarios de tasas :: bonos M :: precios :: gravados  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];11  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued >= '20021223'  
 ORDER BY   
  i.txtTv,  
  b.dteMaturity  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END), 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' UNION' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  'MBONOI' + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: bonos M :: precios :: excentos  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];12  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued < '20021223'  
 ORDER BY   
  i.txtTv,  
  b.dteMaturity  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END), 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' UNION' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  'MBONO' + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: udibonos :: precios :: excentos  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];13  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   (  
    i.txtTv LIKE 'S%'  
    AND i.txtTv NOT IN ('SP', 'SC')  
   )  
   OR  i.txtTv IN ('PI')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued < '20021223'  
 ORDER BY   
  i.txtTv,  
  i.txtSerie  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END)/ir.dblValue, 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+  
  ' UNION ' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+   
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  CASE   
  WHEN RTRIM(txtTv) = 'PI' THEN 'MPIC'  
  ELSE 'MUDI'  
  END + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: udibonos :: precios :: gravados  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];14  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   (  
    i.txtTv LIKE 'S%'  
    AND i.txtTv NOT IN ('SP', 'SC')  
   )  
   OR  i.txtTv IN ('PI')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued >= '20021223'  
 ORDER BY   
  i.txtTv,  
  i.txtSerie  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END)/ir.dblValue, 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+  
  ' UNION ' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+   
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  CASE   
  WHEN RTRIM(txtTv) = 'PI' THEN 'MPIC'  
  ELSE 'MUDI'  
  END + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: IRS  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];15  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 84 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [84c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 168 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [168c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 252 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [252c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [364c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 728 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [728c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1092 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1092c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1456 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1456c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1820 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1820c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 2548 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [2548c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 3640 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [3640c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 5460 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [5460c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 7280 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [7280c],  
  LTRIM(STR(MAX(CASE intTerm WHEN 10920 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [10920c]  
  FROM tblCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'TIE'  
  AND txtSubType = 'SWP'  
  AND intTerm IN  (  
    84,  
    168,  
    252,  
    364,  
    728,  
    1092,  
    1456,  
    1820,  
    2548,  
    3640,  
    5460,  
    7280,  
    10920  
  )  
  GROUP BY   
  dteDate  
  UNION  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 84 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 168 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 252 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 728 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 1092 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 1456 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 1820 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 2548 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 3640 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 5460 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 7280 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 10920 THEN dblRate * 100 ELSE -999 END), 10, 2))  
  FROM MxFixIncomeHist..tblHistoricCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'TIE'  
  AND txtSubType = 'SWP'  
  AND intTerm IN  (  
    84,  
    168,  
    252,  
    364,  
    728,  
    1092,  
    1456,  
    1820,  
    2548,  
    3640,  
    5460,  
    7280,  
    10920  
  )  
  GROUP BY   
  dteDate  
  ORDER BY   
  txtDate  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: interbancaria  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];16  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN    
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [4W]  
  FROM tblCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'SWP'  
  AND txtSubType = 'TI'  
  AND intTerm IN  ( 1, 28)  
  GROUP BY   
  dteDate  
  UNION  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate * 100 ELSE -999 END), 10, 2))  
  FROM MxFixIncomeHist..tblHistoricCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'SWP'  
  AND txtSubType = 'TI'  
  AND intTerm IN  ( 1, 28)  
  GROUP BY   
  dteDate  
  ORDER BY   
  txtDate  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: cetes i  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];17  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [4W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 91 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [13W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 182 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [26W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 273 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [39W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [52W]  
  FROM tblCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'CET'  
  AND txtSubType = 'CTI'  
  AND intTerm IN  (1,28,91,182,273,364)  
  GROUP BY   
  dteDate  
  UNION  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 91 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 182 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 273 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate * 100 ELSE -999 END), 10, 2))  
  FROM MxFixIncomeHist..tblHistoricCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'CET'  
  AND txtSubType = 'CTI'  
  AND intTerm IN  (1,28,91,182,273,364)  
  GROUP BY   
  dteDate  
  ORDER BY   
  txtDate  
  
END  
  
  
-- para extraer los reportes diario de tasas :: cetes  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];18  
 @txtDate AS VARCHAR(10)AS     
BEGIN  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [4W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 91 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [13W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 182 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [26W],  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [52W]  
  FROM tblCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'CET'  
  AND txtSubType = 'CT'  
  AND intTerm IN  (1,28,91,182,273,364)  
  GROUP BY   
  dteDate  
  UNION  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 28 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 91 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 182 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 364 THEN dblRate * 100 ELSE -999 END), 10, 2))  
  FROM MxFixIncomeHist..tblHistoricCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'CET'  
  AND txtSubType = 'CT'  
  AND intTerm IN  (1,28,91,182,273,364)  
  GROUP BY   
  dteDate  
  ORDER BY   
  txtDate   
  
END  
  
  
-- para extraer los reportes mensuales de tasas :: Forward Implicita  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];19  
 @txtDate AS VARCHAR(10)  
AS     
BEGIN  
  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1D],  
  LTRIM(STR(MAX(CASE intTerm WHEN 30 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [1M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 60 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [2M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 90 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [3M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 180 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [6M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 270 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [9M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 360 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [12M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 540 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [18M],  
  LTRIM(STR(MAX(CASE intTerm WHEN 728 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [2Y],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1092 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [3Y],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1456 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [4Y],  
  LTRIM(STR(MAX(CASE intTerm WHEN 1820 THEN dblRate * 100 ELSE -999 END), 10, 2)) AS [5Y]  
  FROM tblCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'FWD'  
  AND txtSubType = 'CU'  
  AND intTerm IN  (  
   1,  
   30,  
   60,  
   90,  
   180,  
   270,  
   360,  
   540,  
   728,  
   1092,  
   1456,  
   1820  
  )  
  GROUP BY   
  dteDate  
  UNION  
  SELECT   
  CONVERT(CHAR(10), dteDate, 101) AS txtDate,  
  LTRIM(STR(MAX(CASE intTerm WHEN 1 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 30 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 60 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 90 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 180 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 270 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 360 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 540 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 728 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 1092 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 1456 THEN dblRate * 100 ELSE -999 END), 10, 2)),  
  LTRIM(STR(MAX(CASE intTerm WHEN 1820 THEN dblRate * 100 ELSE -999 END), 10, 2))  
  FROM MxFixIncomeHist..tblHistoricCurves  
  WHERE  
  dteDate = @txtDate  
  AND txtType = 'FWD'  
  AND txtSubType = 'CU'  
  AND intTerm IN  (  
   1,  
   30,  
   60,  
   90,  
   180,  
   270,  
   360,  
   540,  
   728,  
   1092,  
   1456,  
   1820  
  )  
  GROUP BY   
  dteDate  
  ORDER BY   
  txtDate  
  
END  
  
  
-- para extraer el vector oficial con agregados  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];20  
 @txtDate AS VARCHAR(10),  
 @txtLiquidation AS CHAR(3),  
 @txtFlag AS CHAR(1)  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 -- precio de accion internacional...  
  
 DECLARE @tblIndexEquityPrices TABLE (  
  txtId1 CHAR(11),  
  dblPrice FLOAT,  
  txtCurrency CHAR(5),  
  dblExchange FLOAT,   
  dblMXNPrice FLOAT  
 )  
  
 -- obtengo los precios de las acciones en pesos  
 INSERT @tblIndexEquityPrices  
 SELECT   
  e.txtId1,  
  ep.dblPrice,  
  e.txtCurrency,  
    
  CASE  
  WHEN i.dblValue IS NULL THEN 1  
  ELSE i.dblValue  
  END AS dblExchange,  
    
  CASE  
  WHEN p.dblValue IS NULL THEN -999  
  ELSE p.dblValue  
  END AS dblMXNPrice  
  
 FROM   
  tblEquity AS e  
  INNER JOIN tblEquityPrices AS ep      
  ON e.txtId1 = ep.txtId1  
  LEFT OUTER JOIN tblIrc AS i  
  ON   
   i.txtIrc = (  
    CASE   
    WHEN e.txtCurrency IN ('USD') THEN 'UFXU'    
    ELSE e.txtCurrency  
    END  
   )  
   AND i.dteDate = @txtDate  
  
  LEFT OUTER JOIN tblPrices AS p  
  ON   
   e.txtId1 = p.txtId1   
   AND p.dteDate = @txtDate  
   AND p.txtItem = 'PAV'  
  
 WHERE  
  ep.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblEquityPrices   
   WHERE  
    txtId1 = ep.txtId1  
    AND dteDate <= @txtDate  
    AND txtOperationCode = ep.txtOperationCode  
  )  
  AND ep.dteTime = (  
   SELECT MAX(dteTime)  
   FROM tblEquityPrices  
   WHERE  
    txtId1 = ep.txtId1  
    AND dteDate = ep.dteDate  
    AND txtOperationCode = ep.txtOperationCode  
  )  
  AND ep.txtOperationCode = 'S01'  
  AND e.txtId1 IN ('UBCT0000001')  
  
 -- obtengo los precios en pesos    
 UPDATE @tblIndexEquityPrices  
 SET dblMXNPrice = dblPrice * dblExchange  
 WHERE  
  dblMXNPrice = -999  
  
 SET NOCOUNT OFF  
   
 -- segmento del vector de precios tradicional...   
  
 SELECT   
  'H ' +  
  CASE  
   WHEN txtTv IN ('1', '1A', '1B', '1E', '3', '0', '41', '51', '52',   
                         '53', '54', 'YY', 'FA', 'FI', 'WA', 'WI','1AFX','1ASP','1I') THEN 'MC'  
   ELSE 'MD'  
  END +  
  @txtDate +  
  txtTv + REPLICATE(' ',4 - LEN(txtTv)) +  
  txtEmisora + REPLICATE(' ',7 - LEN(txtEmisora)) +  
  txtSerie + REPLICATE(' ',6 - LEN(txtSerie)) +  
  
  CASE UPPER(txtLiquidation)  
   WHEN 'MP'THEN  
    SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 11, 6)  
   ELSE  
    SUBSTRING(REPLACE(STR(ROUND(dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPRS,6),16,6),  ' ', '0'), 11, 6)  
  END +   
  
  CASE UPPER(txtLiquidation)  
   WHEN 'MP'THEN  
    SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 11, 6)  
   ELSE  
    SUBSTRING(REPLACE(STR(ROUND(dblPRL,6),16,6),  ' ', '0'), 1, 9) +  
     SUBSTRING(REPLACE(STR(ROUND(dblPRL,6),16,6),  ' ', '0'), 11, 6)  
  END +   
  
  SUBSTRING(REPLACE(STR(ROUND(dblCPD,6),13,6),  ' ', '0'), 1, 6) +  
   SUBSTRING(REPLACE(STR(ROUND(dblCPD,6),13,6),  ' ', '0'), 8, 6) +  
  '025009' +  
  @txtFlag +  
  SUBSTRING(REPLACE(STR(ROUND(dblDTM,0),6,0),  ' ', '0'), 1, 6) +  
  
           CASE   
  WHEN ABS(dblUDR) < 1E-4 THEN  '00000000'  
  WHEN dblUDR < 0 THEN   
                  '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblUDR,6),9,4),  '-', '0'),' ','0'), 2, 3) +   
                 SUBSTRING(REPLACE(STR(ROUND(dblUDR,6),9,4),  ' ', '0'), 6, 4)   
         ELSE   
                 SUBSTRING(REPLACE(STR(ROUND(dblUDR,4),9,4),  ' ', '0'), 1, 4) +   
                 SUBSTRING(REPLACE(STR(ROUND(dblUDR,4),9,4),  ' ', '0'), 6, 4)  
         END AS txtVector,  
    
  txtTv,  
  txtEmisora,  
  txtSerie  
  
 FROM tmp_tblUnifiedPricesReport  
 WHERE   
  txtLiquidation IN (@txtLiquidation, 'MP')  
  
 UNION  
  
 -- segmento del vector de precios adicional   
  
 SELECT    
  'H ' +   
  'MC' +  
  @txtDate +  
  RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +  
  RTRIM(SUBSTRING(i.txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(i.txtEmisora, 1, 7))) +  
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
   
  SUBSTRING(REPLACE(STR(ROUND(c.dblMXNPrice,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblMXNPrice,6),16,6),  ' ', '0'), 11, 6) +  
   
  SUBSTRING(REPLACE(STR(ROUND(c.dblMXNPrice,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblMXNPrice,6),16,6),  ' ', '0'), 11, 6) +  
  
  '000000000000' +  
  '025009' +   
  @txtFlag +  
  '000000' +   
  '00000000' AS txtVector,  
  
  txtTv,  
  txtEmisora,  
  txtSerie  
    
  FROM   
  @tblIndexEquityPrices AS c  
  INNER JOIN tblIds AS i  
  ON c.txtId1 = i.txtId1  
 ORDER BY  
  txtTv,  
  txtEmisora,  
  txtSerie  
  
  
END  
  
  
-- para extraer el vector excel con agregados  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];21  
 @txtDate AS VARCHAR(10),  
 @txtLiquidation AS CHAR(3)  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 -- precio de accion internacional...  
  
 DECLARE @tblIndexEquityPrices TABLE (  
  txtId1 CHAR(11),  
  dblPrice FLOAT,  
  txtCurrency CHAR(5),  
  dblExchange FLOAT,   
  dblMXNPrice FLOAT  
 )  
  
 -- obtengo los precios de las acciones en pesos  
 INSERT @tblIndexEquityPrices  
 SELECT   
  e.txtId1,  
  ep.dblPrice,  
  e.txtCurrency,  
    
  CASE  
  WHEN i.dblValue IS NULL THEN 1  
  ELSE i.dblValue  
  END AS dblExchange,  
    
  CASE  
  WHEN p.dblValue IS NULL THEN -999  
  ELSE p.dblValue  
  END AS dblMXNPrice  
  
 FROM   
  tblEquity AS e  
  INNER JOIN tblEquityPrices AS ep      
  ON e.txtId1 = ep.txtId1  
  LEFT OUTER JOIN tblIrc AS i  
  ON   
   i.txtIrc = (  
    CASE   
    WHEN e.txtCurrency IN ('USD') THEN 'UFXU'    
    ELSE e.txtCurrency  
    END  
   )  
   AND i.dteDate = @txtDate  
  
  LEFT OUTER JOIN tblPrices AS p  
  ON   
   e.txtId1 = p.txtId1   
   AND p.dteDate = @txtDate  
   AND p.txtItem = 'PAV'  
  
 WHERE  
  ep.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblEquityPrices   
   WHERE  
    txtId1 = ep.txtId1  
    AND dteDate <= @txtDate  
    AND txtOperationCode = ep.txtOperationCode  
  )  
  AND ep.dteTime = (  
   SELECT MAX(dteTime)  
   FROM tblEquityPrices  
   WHERE  
    txtId1 = ep.txtId1  
    AND dteDate = ep.dteDate  
    AND txtOperationCode = ep.txtOperationCode  
  )  
  AND ep.txtOperationCode = 'S01'  
  AND e.txtId1 IN ('UBCT0000001')  
  
 -- obtengo los precios en pesos    
 UPDATE @tblIndexEquityPrices  
 SET dblMXNPrice = dblPrice * dblExchange  
 WHERE  
  dblMXNPrice = -999  
  
 SET NOCOUNT OFF  
  
 -- segmento del vector de precios tradicional...   
  
 SELECT   
  RTRIM(txtTv) AS txtTv,  
  RTRIM(txtEmisora) AS txtEmisora,  
  RTRIM(txtSerie) AS txtSerie,  
   
  CASE UPPER(txtLiquidation)  
  WHEN 'MP'THEN ROUND(dblPAV,6)  
  ELSE ROUND(dblPRL,6)  
  END AS dblPRL,  
   
  CASE UPPER(txtLiquidation)  
  WHEN 'MP'THEN 0  
  ELSE ROUND(dblPRS,6)  
  END AS dblPRS,  
   
  ROUND(dblCPD,6) AS dblCPD,  
  ROUND(dblCPA,6) AS dblCPA,  
   
  CASE   
  WHEN txtTv IN (  
   'IP',  
   'IT',  
   'L',  
   'LP',  
   'LS',  
   'LT',  
   'XA',  
   'IS'  
  ) THEN ROUND(dblLDR,6)  
   
  WHEN txtTv IN (  
   'B',  
   'BI',  
   'D',  
   'D3',  
   'G',  
   'I'  
  ) THEN ROUND(dblUDR,6)  
   
  ELSE ROUND(dblYTM,6)   
  
  END AS dblRate  
   
 FROM tmp_tblUnifiedPricesReport  
 WHERE   
  txtLiquidation IN (@txtLiquidation, 'MP')  
  
 UNION  
  
 -- segmento del vector de precios adicional   
  
 SELECT    
  RTRIM(txtTv) AS txtTv,  
  RTRIM(txtEmisora) AS txtEmisora,  
  RTRIM(txtSerie) AS txtSerie,   
  dblMXNPrice AS dblPRL,   
  0 AS dblPRS,   
  0 AS dblCPD,  
  0 AS dblCPA,   
  0 AS dblRate  
    
  FROM   
  @tblIndexEquityPrices AS c  
  INNER JOIN tblIds AS i  
  ON c.txtId1 = i.txtId1  
  
 ORDER BY  
  txtTv,  
  txtEmisora,  
  txtSerie  
  
END  
  
-- directivas para el vector de curvas   
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];22  
AS     
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @tblDirectives TABLE (  
  intSerial INT,  
  txtTipo CHAR(20),  
  txtSubTipo CHAR(50),  
  txtEmisora CHAR(7),  
  dblFactor FLOAT  
 )   
  
 INSERT @tblDirectives SELECT 1,'FTC', 'EUR', 'FTC/EUR', 0.01  
 INSERT @tblDirectives SELECT 2,'FWD', 'FIX', 'FWD/FIX', 0.01  
 INSERT @tblDirectives SELECT 3,'FTM', 'EUR', 'FTM/EUR', 0.01  
 INSERT @tblDirectives SELECT 4,'FWD', 'CU', 'FWD/CU', 1.00  
 INSERT @tblDirectives SELECT 5,'LIB', 'BL', 'LIB/BL', 1.00  
 INSERT @tblDirectives SELECT 6,'FWD', 'EUR', 'FWD/EUR', 1.00  
 INSERT @tblDirectives SELECT 7,'SWP', 'TI', 'SWP/TI', 1.00  
 INSERT @tblDirectives SELECT 8,'MSG', 'YLD', 'MSG/YLD', 1.00  
 INSERT @tblDirectives SELECT 9,'CET', 'CTI', 'CET/CTI', 1.00  
 INSERT @tblDirectives SELECT 10,'TDS', 'T28', 'TDS/T28', 1.00  
 INSERT @tblDirectives SELECT 11,'CET', 'CT', 'CET/CT', 1.00  
 INSERT @tblDirectives SELECT 12,'LIB', 'EUR', 'LIB/EUR', 1.00  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtTipo,  
  txtSubTipo,  
  txtEmisora,  
  dblFactor  
 FROM   
  @tblDirectives  
 ORDER BY   
  intSerial  
  
END  
  
  
-- Procedimientos para generar los layouts de Archivos de Curvas ING  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];23  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 21-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Implicita Pesos   
    CETESBLANKMXN_YYYYMMDD.txt = CETESMXTMXN_YYYYMMDD.txt = CETESMEXMXN_YYYYMMDD.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,1M,2M,3M,6M,9M,12M,18M,2Y,3Y,4Y,5Y,7Y,10Y,15Y,20Y,30Y' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD,FWD' AS [Type],'CU,CU,CU,CU,CU,CU,CU,CU,CU,CU,CU,CU,CU,CU,CU,CU,CU
' AS [SubType], '1,30,60,90,180,270,360,540,728,1092,1456,1820,2548,3640,5460,7280,10920' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];24  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 21-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Bancario AAA y TIIE 28   
        MXIBKBLANKMXN1_[DATE|YYYYMMDD].txt = MXIBKMEXMXN1_[DATE|YYYYMMDD].txt = MXIBKMXTMXN1_[DATE|YYYYMMDD].txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,4W' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'PLV,SWP' AS [Type],'3A,TI' AS [SubType], '1,28' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];25  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 21-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva TIIE Swap   
      MXIBKBLANKMXN2_aaaammdd.txt = MXIBKMEXMXN2_aaaammdd.txt = MXIBKMXTMXN2_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',84C,168C,252C,364C,728C,1092C,1456C,1820C,2548C,3640C,5460C,7280C,10920C' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'TIE,TIE,TIE,TIE,TIE,TIE,TIE,TIE,TIE,TIE,TIE,TIE,TIE' AS [Type],'SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP' AS [SubType],
 '84,168,252,364,728,1092,1456,1820,2548,3640,5460,7280,10920' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];26  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 21-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Real sin impuesto MXUDIMEXUDI1_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,28C,91C,182C,360C,728C' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'UDB,UDB,UDB,UDB,UDB,UDB' AS [Type],'U%,U%,U%,U%,U%,U%' AS [SubType], '1,28,91,182,360,728' AS [Nodos], '' AS [HLD], '1' AS [Factor
]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];27  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 21-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Real con impuesto   
     MXUDIMXTUDI1_aaaammdd.txt = MXUDIBLANKUDI1_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,4W,13W,26W,39W,52W' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'UDB,UDB,UDB,UDB,UDB,UDB' AS [Type],'UUI,UUI,UUI,UUI,UUI,UUI' AS [SubType], '1,28,91,182,273,364' AS [Nodos], '' AS [HLD], '1' AS [
Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];28  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 21-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Cross Currency Swap Udi/Libor   
      MXUSWBLANKUDI1_aaaammdd.txt = MXUSWMXTUDI1_aaaammdd.txt = MXUSWMEXUDI1_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,28C,91C,182C' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'ULS,ULS,ULS,ULS' AS [Type],'CCS,CCS,CCS,CCS' AS [SubType], '1,28,91,182' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];29  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 21-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Udi/Libor Tasa Swap   
    MXUSWBLANKUDI2_aaaammdd.txt = MXUSWMXTUDI2_aaaammdd.txt = MXUSWMEXUDI2_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',364C,728C,1092C,1456C,1820C,2458C,3640C,7280C' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'ULS,ULS,ULS,ULS,ULS,ULS,ULS,ULS' AS [Type],'SWP,SWP,SWP,SWP,SWP,SWP,SWP,SWP' AS [SubType], '364,728,1092,1456,1820,2458,3640,7280'
 AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];30  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 22-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Tasa Real sin Impuesto   
     MXUBKBLANKUDI1_aaaammdd.txt = MXUBKMEXUDI1_aaaammdd.txt = MXUBKMXTUDI1_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,28C,91C,182C,360C,728C' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'UDB,UDB,UDB,UDB,UDB,UDB' AS [Type],'U%,U%,U%,U%,U%,U%' AS [SubType], '1,28,91,182,360,728' AS [Nodos], '' AS [HLD], '1' AS [Factor
]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];31  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 22-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Cetes con impuesto   
      MXGOVMXTMXN1_aaaammdd.txt = MXGOVBLANKMXN1_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,4W,13W,26W,39W,52W' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'CET,CET,CET,CET,CET,CET' AS [Type],'CTI,CTI,CTI,CTI,CTI,CTI' AS [SubType], '1,28,91,182,273,364' AS [Nodos], '' AS [HLD], '1' AS [
Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];32  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 22-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Cetes sin impuesto MXGOVMEXMXN1_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',1D,4W' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'CURVES' AS [FRPIP],'CET,CET' AS [Type],'CT,CT' AS [SubType], '1,28' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];33  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 22-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Tipo de Cambio SPOT USDMXN_aaaammdd.txt  
  
 */  
  
BEGIN    
  
    SELECT 1 AS [Row],'Header' AS [TypeColumn],',SPOT' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'IRC' AS [FRPIP],'' AS [Type],'' AS [SubType], 'USD2' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];34  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 22-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Tipo de Cambio UDI UDIMXN_aaaammdd.txt  
  
 */  
  
BEGIN    
  
    SELECT 1 AS [Row],'Header' AS [TypeColumn],',UDI' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'IRC' AS [FRPIP],'' AS [Type],'' AS [SubType], 'UDI' AS [Nodos], '' AS [HLD], '1' AS [Factor]  
   
END  
  
  
-- para extraer los reportes diarios de tasas :: udibonos y pics:: precios :: sin impuesto  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];35  
 @txtDate AS VARCHAR(10)  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 23-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Udibonos sin impuesto MXUDIMEXUDI2_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   (  
    i.txtTv LIKE 'S%'  
    AND i.txtTv NOT IN ('SP', 'SC')  
   )  
   OR  i.txtTv IN ('PI')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued < '20021223'  
  AND i.txtId1 NOT IN ('MBBA5500003','MBBA5500001')  
 ORDER BY   
  i.txtTv,  
  i.txtSerie  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END)/ir.dblValue, 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+  
  ' UNION ' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+   
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  CASE   
  WHEN RTRIM(txtTv) = 'PI' THEN 'MPIC'  
  ELSE 'MUDI' + RTRIM(txtTv)  
  END  + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: udibonos y pics :: precios :: con impuesto  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];36  
 @txtDate AS VARCHAR(10)  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 23-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo Udibonos y pics con impuesto   
     MXUDIMXTUDI2_aaaammdd.txt = MXUDIBLANKUDI2_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   (  
    i.txtTv LIKE 'S%'  
    AND i.txtTv NOT IN ('SP', 'SC')  
   )  
   OR  i.txtTv IN ('PI')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued >= '20021223'  
 ORDER BY   
  i.txtTv,  
  i.txtSerie  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END)/ir.dblValue, 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+  
  ' UNION ' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+   
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  CASE   
  WHEN RTRIM(txtTv) = 'PI' THEN 'MPIC'  
  ELSE 'MUDI'  
  END + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: solo udibonos :: precios :: sin impuesto  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];37  
 @txtDate AS VARCHAR(10)  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 23-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo solo Udibonos sin impuesto   
    MXUBKBLANKUDI2_aaaammdd.txt = MXUBKMEXUDI2_aaaammdd.txt = MXUBKMXTUDI2_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   (  
    i.txtTv LIKE 'S%'  
    AND i.txtTv NOT IN ('SP', 'SC')  
   )  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued < '20021223'  
 ORDER BY   
  i.txtTv,  
  i.txtSerie  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END)/ir.dblValue, 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+  
  ' UNION ' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
   ' INNER JOIN tblIrc AS ir'+  
   ' ON ir.dteDate = hp.dteDate'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
   ' AND ir.txtIrc = ''UDI'''+  
  ' GROUP BY '+  
   ' hp.dteDate,'+  
   ' ir.dblValue'+   
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  CASE   
  WHEN RTRIM(txtTv) = 'PI' THEN 'MPIC'  
  ELSE 'MUDI'  
  END + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  txtSerie  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: bonos M :: precios :: gravados  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];38  
 @txtDate AS VARCHAR(10)  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 23-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo bonos M con impuesto   
        MXGOVMXTMXN2_aaaammdd.txt = MXGOVBLANKMXN2_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued >= '20021223'  
  AND i.txtId1 NOT IN ('MGOV0330053')  
 ORDER BY   
  i.txtTv,  
  b.dteMaturity  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END), 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' UNION' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  'MBONOI' + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
-- para extraer los reportes diarios de tasas :: bonos M :: precios :: excentos  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];39  
 @txtDate AS VARCHAR(10)  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 23-Feb-2007  
  Funcionalidad: Modulo para generar layout de archivo bonos M sin impuesto MXGOVMEXMXN2_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dteMaturity AS DATETIME  
 DECLARE @txtSQL AS VARCHAR(8000)  
 DECLARE @txtUni AS VARCHAR(8000)  
   
  
 -- determino el universo a incluir instrumentos  
 -- vigentes durante todo el periodo de extraccion...   
 SELECT   
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  b.dteMaturity  
 INTO #tblUni  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity >= @txtDate  
  AND b.dteIssued < '20021223'  
 ORDER BY   
  i.txtTv,  
  b.dteMaturity  
  
 -- construyo las sentencias de extraccion  
 DECLARE csr_universe CURSOR FOR  
 SELECT   
  txtId1,  
  dteMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
   
 OPEN csr_universe  
   
 FETCH NEXT FROM csr_universe   
 INTO   
  @txtId1,   
  @dteMaturity  
   
 SET @txtUni = ''  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @txtUni = @txtUni +  
   'LTRIM(STR(MAX(CASE hp.txtId1 WHEN '''+ @txtId1 +''' THEN hp.dblValue ELSE 0 END), 20, 2)),'  
  
  FETCH NEXT FROM csr_universe   
  INTO   
   @txtId1,   
   @dteMaturity  
   
 END  
   
 CLOSE csr_universe  
 DEALLOCATE csr_universe  
  
 SET @txtUni = LEFT(@txtUni, LEN(@txtUni) - 1)  
  
 -- genero el query para el reporte  
 SET @txtSQL =(  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN tblPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' UNION' +  
  ' SELECT '+  
   ' CONVERT(CHAR(10), hp.dteDate, 101) AS txtDate,'+  
   @txtUni +  
  ' FROM '+  
   ' #tblUni AS u'+  
   ' INNER JOIN MxFixIncomeHist..tblHistoricPrices AS hp'+  
   ' ON u.txtId1 = hp.txtId1'+  
  ' WHERE'+  
   ' hp.dteDate = ''' + @txtDate + '''' +   
   ' AND hp.txtItem = ''PRL'''+  
   ' AND hp.txtLiquidation = ''MD'''+  
  ' GROUP BY '+  
   ' hp.dteDate'+  
  ' ORDER BY '+  
   ' txtDate'  
 )  
  
 SET NOCOUNT OFF  
  
 -- genero el reporte sobre el universo  
 SELECT   
  'MBONO' + RTRIM(txtTv) + RTRIM(txtSerie) AS txtId,  
  RTRIM(CONVERT(CHAR(10), dteMaturity, 101)) AS txtMaturity  
 FROM #tblUni  
 ORDER BY   
  txtTv,  
  dteMaturity  
  
 -- genero el reporte de precios  
 EXEC (@txtSQL)  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];40  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 07-Mar-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva MXCCSMXT_aaaammdd.txt (Cross Currency)  
  
 */  
  
BEGIN    
  
 SELECT 1 AS [Row],'Header' AS [TypeColumn],',3M,6M,9M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,15Y,20Y' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT 2 AS [Row],'Detail' AS [TypeColumn],CONVERT(CHAR(10),CAST(@txtDate AS DATETIME),101) AS [Label],'LEVELSMARKET' AS [FRPIP],'CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR,CrossCUR' AS [Type],'MID,
MID,MID,MID,MID,MID,MID,MID,MID,MID,MID,MID' AS [SubType], '3M,6M,9M,1Y,2Y,3Y,4Y,5Y,7Y,10Y,15Y,20Y' AS [Nodos], '' AS [HLD], '100' AS [Factor]  
   
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];41  
 @txtDate AS VARCHAR(10),    
 @txtCode AS VARCHAR(10),  
 @txtValue AS VARCHAR(10),  
 @txtLabel AS VARCHAR(10)  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 07-Mar-2007  
  Funcionalidad: Obtiene Información de tblMarkets   
                       1. Para archivo Curva MXCCSMXT_aaaammdd.txt (Cross Currency)  
                       2. Para archivo Curva Rates MtM UPLOAD_aaaammdd.xls  (Tipo de Cambio SPOT y Puntos Forward bid/ask)  
  
  
 */  
  
BEGIN    
  
 SELECT   
  CASE WHEN @txtValue = 'MID' THEN dblLevel  
    WHEN @txtValue = 'BID' THEN dblLevelBid  
    WHEN @txtValue = 'ASK' THEN dblLevelAsk  
  END AS [dblValue]  
 FROM tblMarkets   
 WHERE dtedate = @txtDate   
 AND txtCode = @txtCode   
 AND txtLabel = @txtLabel  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];42  
 @txtDate AS VARCHAR(10)    
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 20-Mar-2007  
  Funcionalidad: Modulo para generar layout de archivo Curva Rates MtM UPLOAD_aaaammdd.xls (Tipo de Cambio SPOT y Puntos Forward bid/ask)  
  
 */  
  
BEGIN    
  
 SELECT  1 AS [Row],'Header' AS [TypeColumn],',,,,,ING' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
    SELECT  2 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
    SELECT  3 AS [Row],'LineBlank' AS [TypeColumn],'' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT  4 AS [Row],'Header' AS [TypeColumn],',DATE,TIME,BID,ASK' AS [Label],'' AS [FRPIP],'' AS [Type],'' AS [SubType], '' AS [Nodos], '' AS [HLD], '0' AS [Factor] UNION  
 SELECT  5 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN=,' + CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'IRC' AS [FRPIP],'' AS [Type],'' AS [SubType], 'USD2,USD2' AS [Nodos], '' AS [HLD], '1' AS [Factor] UNION  
 SELECT  6 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN1M=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '1M,1M' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT  7 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN2M=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '2M,2M' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT  8 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN3M=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '3M,3M' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT  9 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN6M=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '6M,6M' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT 10 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN9M=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '9M,9M' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT 11 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN1Y=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '1Y,1Y' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT 12 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN18M=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '18M,18M' AS [Nodos], '' AS [HLD], '1' AS
 [Factor] UNION   
 SELECT 13 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN2Y=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '2Y,2Y' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT 14 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN3Y=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '3Y,3Y' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT 15 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN4Y=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '4Y,4Y' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  UNION  
 SELECT 16 AS [Row],'Detail' AS [TypeColumn],'NY_USDMXN5Y=,'+ CONVERT(CHAR(8),CAST(@txtDate AS DATETIME),112) + ',235959' AS [Label],'LEVELSMARKET6D' AS [FRPIP],'PtosFWD,PtosFWD' AS [Type],'BID,ASK' AS [SubType], '5Y,5Y' AS [Nodos], '' AS [HLD], '1' AS [F
actor]  
   
END  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];43  
  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 26-Ago-2008  
  Funcionalidad: Modulo para generar producto: Vector_Emisoras_Nacionales_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  Detail  VARCHAR(2000)  
 )  
  
 INSERT @tmp_tblResults   
 SELECT    
  0 AS [Consecutivo],  
  'Consecutivo' + CHAR(124) +   
  'RAZON SOCIAL' + CHAR(124) +   
  'S&P LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC NAC' + CHAR(124) +   
  'S&P CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC NAC' + CHAR(124) +   
  'S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC NAC' + CHAR(124) +   
  'MOODY''S CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC NAC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC NAC' + CHAR(124) +   
  'FITCH CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC NAC' + CHAR(124) +   
  'FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M EXT'  AS [VectorEMI]  
 UNION  
 SELECT  
  intConsecutive AS [Consecutivo],  
  LTRIM(STR(intConsecutive,5,0)) + CHAR(124) +        -- [intConsecutiv]  
  (CASE WHEN RTRIM(txtISN) IS NULL THEN '' ELSE RTRIM(txtISN) END)  + CHAR(124) +   -- [RAZON SOCIAL]  
  (CASE WHEN RTRIM(txtSPQ_LN) IS NULL THEN '' ELSE RTRIM(txtSPQ_LN) END) + CHAR(124) +   -- [S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_LN) IS NULL THEN '' ELSE RTRIM(txtSPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_SN) IS NULL THEN '' ELSE RTRIM(txtSPQ_SN) END) + CHAR(124) +   -- [S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_SN) IS NULL THEN '' ELSE RTRIM(txtSPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGL) END) + CHAR(124) +   -- [S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGL) END) + CHAR(124) +   -- [S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGE) END) + CHAR(124) +   -- [S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGE) END) + CHAR(124) +   -- [S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_LN) IS NULL THEN '' ELSE RTRIM(txtDPQ_LN) END) + CHAR(124) +   -- [MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_LN) IS NULL THEN '' ELSE RTRIM(txtDPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_SN) IS NULL THEN '' ELSE RTRIM(txtDPQ_SN) END) + CHAR(124) +   -- [MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_SN) IS NULL THEN '' ELSE RTRIM(txtDPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGL) END)  + CHAR(124) +  -- [MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGL) END)  + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGL) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGE) END) + CHAR(124) +   -- [MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGE) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_LN) IS NULL THEN '' ELSE RTRIM(txtFIQ_LN) END) + CHAR(124) +   -- [FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_LN) IS NULL THEN '' ELSE RTRIM(txtFIQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_SN) IS NULL THEN '' ELSE RTRIM(txtFIQ_SN) END) + CHAR(124) +   -- [FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_SN) IS NULL THEN '' ELSE RTRIM(txtFIQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGL) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGL) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGE) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGE) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGE) END) AS [VectorEMI] -- [Fecha de ultimo cambio FITCH CP ESC GLOB M EXT]  
 FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)  
 WHERE txtVectorType = 'EEN'  
 ORDER BY  [Consecutivo]  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];44  
  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 27-Ago-2008  
  Funcionalidad: Modulo para generar producto: Vector_Sociedades_aaaammdd.txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  Detail  VARCHAR(2000)  
 )  
  
 INSERT @tmp_tblResults   
 SELECT    
  0 AS [Consecutivo],  
  'Consecutivo' + CHAR(124) +   
  'CLAVE' + CHAR(124) +   
  'RAZON SOCIAL' + CHAR(124) +   
  'S&P Escala Homogénea' + CHAR(124) +   
  'S&P Escala Nacional' + CHAR(124) +   
  'S&P Escala Global' + CHAR(124) +   
  'FECHA DE ULTIMA MODIFICACION S&P' + CHAR(124) +   
  'MOODY''S Escala Homogénea' + CHAR(124) +   
  'MOODY''S Escala Nacional' + CHAR(124) +   
  'MOODY''S Escala Global' + CHAR(124) +   
  'FECHA DE ULTIMA MODIFICACION MOODY''S' + CHAR(124) +   
  'FITCHS Escala Homogénea' + CHAR(124) +   
  'FITCHS Escala Nacional' + CHAR(124) +   
  'FITCHS Escala Global' + CHAR(124) +   
  'FECHA DE ULTIMA MODIFICACION FITCHS' AS [VectorEMI]  
 UNION  
 SELECT  
  intConsecutive AS [Consecutivo],  
  LTRIM(STR(intConsecutive,5,0)) + CHAR(124) +        -- [intConsecutiv]  
  (CASE WHEN LTRIM(RTRIM(i.txtISN_CVE)) IS NULL THEN '' ELSE LTRIM(RTRIM(i.txtISN_CVE)) END)  + CHAR(124) +  -- [CLAVE]  
  (CASE WHEN LTRIM(RTRIM(txtISN)) IS NULL THEN '' ELSE LTRIM(RTRIM(txtISN)) END)  + CHAR(124) +   -- [RAZON SOCIAL]  
  
  (CASE WHEN RTRIM(txtSPQ_EH) IS NULL THEN '' ELSE RTRIM(txtSPQ_EH) END) + CHAR(124) +   -- [S&P Escala Homogénea]  
  (CASE WHEN RTRIM(txtSPQ_EN) IS NULL THEN '' ELSE RTRIM(txtSPQ_EN) END) + CHAR(124) +   -- [S&P Escala Nacional]  
  (CASE WHEN RTRIM(txtSPQ_EG) IS NULL THEN '' ELSE RTRIM(txtSPQ_EG) END) + CHAR(124) +   -- [S&P Escala Global]  
  (CASE WHEN RTRIM(txtSPQD_EH) IS NULL THEN '' ELSE RTRIM(txtSPQD_EH) END) + CHAR(124) +   -- [FECHA DE ULTIMA MODIFICACION S&P]  
  
  (CASE WHEN RTRIM(txtDPQ_EH) IS NULL THEN '' ELSE RTRIM(txtDPQ_EH) END) + CHAR(124) +   -- [MOODY'S Escala Homogénea]  
  (CASE WHEN RTRIM(txtDPQ_EN) IS NULL THEN '' ELSE RTRIM(txtDPQ_EN) END) + CHAR(124) +   -- [MOODY'S Escala Nacional]  
  (CASE WHEN RTRIM(txtDPQ_EG) IS NULL THEN '' ELSE RTRIM(txtDPQ_EG) END) + CHAR(124) +   -- [MOODY'S Escala Global]  
  (CASE WHEN RTRIM(txtDPQD_EH) IS NULL THEN '' ELSE RTRIM(txtDPQD_EH) END) + CHAR(124) +   -- [FECHA DE ULTIMA MODIFICACION MOODY'S]  
  
  (CASE WHEN RTRIM(txtFIQ_EH) IS NULL THEN '' ELSE RTRIM(txtFIQ_EH) END) + CHAR(124) +   -- [FITCHS Escala Homogénea]  
  (CASE WHEN RTRIM(txtFIQ_EN) IS NULL THEN '' ELSE RTRIM(txtFIQ_EN) END) + CHAR(124) +   -- [FITCHS Escala Nacional]  
  (CASE WHEN RTRIM(txtFIQ_EG) IS NULL THEN '' ELSE RTRIM(txtFIQ_EG) END) + CHAR(124) +   -- [FITCHS Escala Global]  
  (CASE WHEN RTRIM(txtFIQD_EH) IS NULL THEN '' ELSE RTRIM(txtFIQD_EH) END)  AS [VectorEMI] -- [FECHA DE ULTIMA MODIFICACION FITCHS]  
  
 FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras AS v (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tblIssuerCompany AS i (NOLOCK)  
   ON i.txtIssuerName = v.txtISN  
 WHERE v.txtVectorType = 'SI'  
 ORDER BY  [Consecutivo]  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
-----------------------------------------------------------------------------------------------  
--   Autor:                     Mike Ramirez  
--   Fecha Modificacion:  12:02 p.m. 2012-08-02  
--   Descripcion:               Modulo 45: Se cambia la tabla de donde se extrae la informacion  
-----------------------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];45  
  
AS  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  Detail  VARCHAR(2000)  
 )  
  
 INSERT @tmp_tblResults   
 SELECT    
  0 AS [Consecutivo],  
  'Consecutivo' + CHAR(124) +   
  'RAZON SOCIAL' + CHAR(124) +   
  'S&P LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC NAC' + CHAR(124) +   
  'S&P CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC NAC' + CHAR(124) +   
  'S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC NAC' + CHAR(124) +   
  'MOODY''S CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC NAC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC NAC' + CHAR(124) +   
  'FITCH CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC NAC' + CHAR(124) +   
  'FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M EXT'  AS [VectorEMI]  
 UNION  
 SELECT  
  intConsecutive AS [Consecutivo],  
  LTRIM(STR(intConsecutive,5,0)) + CHAR(124) +        -- [intConsecutiv]  
  (CASE WHEN RTRIM(txtISN) IS NULL THEN '' ELSE RTRIM(txtISN) END)  + CHAR(124) +   -- [RAZON SOCIAL]  
  (CASE WHEN RTRIM(txtSPQ_LN) IS NULL THEN '' ELSE RTRIM(txtSPQ_LN) END) + CHAR(124) +   -- [S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_LN) IS NULL THEN '' ELSE RTRIM(txtSPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_SN) IS NULL THEN '' ELSE RTRIM(txtSPQ_SN) END) + CHAR(124) +   -- [S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_SN) IS NULL THEN '' ELSE RTRIM(txtSPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGL) END) + CHAR(124) +   -- [S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGL) END) + CHAR(124) +   -- [S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGE) END) + CHAR(124) +   -- [S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGE) END) + CHAR(124) +   -- [S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_LN) IS NULL THEN '' ELSE RTRIM(txtDPQ_LN) END) + CHAR(124) +   -- [MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_LN) IS NULL THEN '' ELSE RTRIM(txtDPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_SN) IS NULL THEN '' ELSE RTRIM(txtDPQ_SN) END) + CHAR(124) +   -- [MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_SN) IS NULL THEN '' ELSE RTRIM(txtDPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGL) END)  + CHAR(124) +  -- [MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGL) END)  + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGL) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGE) END) + CHAR(124) +   -- [MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGE) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_LN) IS NULL THEN '' ELSE RTRIM(txtFIQ_LN) END) + CHAR(124) +   -- [FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_LN) IS NULL THEN '' ELSE RTRIM(txtFIQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_SN) IS NULL THEN '' ELSE RTRIM(txtFIQ_SN) END) + CHAR(124) +   -- [FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_SN) IS NULL THEN '' ELSE RTRIM(txtFIQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGL) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGL) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGE) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGE) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGE) END) AS [VectorEMI] -- [Fecha de ultimo cambio FITCH CP ESC GLOB M EXT]  
 FROM MxFixIncome.dbo.tblVectorEmpresasEmisorasNew (NOLOCK)  
 WHERE txtVectorType = 'EEE'  
 ORDER BY  [Consecutivo]  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
  
-- para obtener vector de precios Ing_FBAAAAMMDD.pip  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];46  
  @txtDate AS VARCHAR(10),  
 @txtFlag AS VARCHAR(1) = '0'  
AS     
  
 /*  
  Creador: Lic. René López Salinas  
  Fecha: 17-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_FBAAAAMMDD.pip  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- Construyo tabla Temporal para reportar informacion  
 DECLARE @tblTemp TABLE (  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtData][VARCHAR](8000),  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  
  
 -- creamos el reporte con la informacion del vector original  
  
 INSERT @tblTemp  
 SELECT DISTINCT  
  ap.txtTV,  
  ap.txtEmisora,  
  ap.txtSerie,  
  SUBSTRING (  
   'H ' +  
   CASE  
    WHEN ap.txtTv IN ('1', '1A', '1B','1E', '3', '0', '41', '51', '52',   
                          '53', '54', 'YY', 'FA', 'FI', 'WA', 'WI','1AFX','1ASP','1I') THEN 'MC'  
    ELSE 'MD'  
   END +  
   @txtDate +  
   ap.txtTv + REPLICATE(' ',4 - LEN(ap.txtTv)) +  
   ap.txtEmisora + REPLICATE(' ',7 - LEN(ap.txtEmisora)) +  
   ap.txtSerie + REPLICATE(' ',6 - LEN(ap.txtSerie)) +  
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 1, 6) +  
    SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 8, 6) +  
   '025009' +  
   @txtFlag +  
   SUBSTRING(REPLACE(STR(ROUND(ap.dblDTM,0),6,0),  ' ', '0'), 1, 6) +  
   
                 CASE   
    WHEN ABS(ap.dblUDR) < 1E-4 THEN  '00000000'  
    WHEN ap.dblUDR < 0 THEN   
                    '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  '-', '0'),' ','0'), 2, 3) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  ' ', '0'), 6, 4)   
           ELSE   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 1, 4) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 6, 4)  
                  END , 1, 92)  
  
 FROM MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
   ON a1.txtId1 = ap.txtId1  
   AND a1.txtLiquidation = (  
    CASE ap.txtLiquidation    
    WHEN 'MP' THEN 'MD'    
    ELSE ap.txtLiquidation    
    END  
   )  
 WHERE   
  ap.txtLiquidation IN ('MD', 'MP')  
  AND ap.txtTv = 'FB'  
  
  
 -- Reporto información  
 SELECT txtData  
 FROM @tblTemp  
 ORDER BY txtTV, txtEmisora, txtSerie    
  
 SET NOCOUNT OFF   
  
END  
  
  
-- para obtener vector de precios Ing_FUTAAAAMMDD.pip  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];47  
  @txtDate AS VARCHAR(10),  
 @txtFlag AS VARCHAR(1) = '0'  
AS     
  
 /*  
  Creador: Lic. René López Salinas  
  Fecha: 17-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_FUTAAAAMMDD.pip  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- Construyo tabla Temporal para reportar informacion  
 DECLARE @tblTemp TABLE (  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtData][VARCHAR](8000),  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  
  
 -- creamos el reporte con la informacion del vector original  
  
 INSERT @tblTemp  
 SELECT DISTINCT  
  ap.txtTV,  
  ap.txtEmisora,  
  ap.txtSerie,  
  SUBSTRING (  
   'H ' +  
   CASE  
    WHEN ap.txtTv IN ('1', '1A', '1B','1E', '3', '0', '41', '51', '52',   
                          '53', '54', 'YY', 'FA', 'FI', 'WA', 'WI','1AFX','1ASP','1I') THEN 'MC'  
    ELSE 'MD'  
   END +  
   @txtDate +  
   ap.txtTv + REPLICATE(' ',4 - LEN(ap.txtTv)) +  
   ap.txtEmisora + REPLICATE(' ',7 - LEN(ap.txtEmisora)) +  
   ap.txtSerie + REPLICATE(' ',6 - LEN(ap.txtSerie)) +  
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 1, 6) +  
    SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 8, 6) +  
   '025009' +  
   @txtFlag +  
   SUBSTRING(REPLACE(STR(ROUND(ap.dblDTM,0),6,0),  ' ', '0'), 1, 6) +  
   
                 CASE   
    WHEN ABS(ap.dblUDR) < 1E-4 THEN  '00000000'  
    WHEN ap.dblUDR < 0 THEN   
                    '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  '-', '0'),' ','0'), 2, 3) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  ' ', '0'), 6, 4)   
           ELSE   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 1, 4) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 6, 4)  
                  END , 1, 92)  
  
 FROM MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
   ON a1.txtId1 = ap.txtId1  
   AND a1.txtLiquidation = (  
    CASE ap.txtLiquidation    
    WHEN 'MP' THEN 'MD'    
    ELSE ap.txtLiquidation    
    END  
   )  
 WHERE   
  ap.txtLiquidation IN ('MD', 'MP')  
  AND ap.txtTv IN ('FA','FC','FD','FI','FU')  
  
  
 -- Reporto información  
 SELECT txtData  
 FROM @tblTemp  
 ORDER BY txtTV, txtEmisora, txtSerie    
  
 SET NOCOUNT OFF   
  
END  
  
  
-- para obtener vector de precios Ing_IRSFWDAAAAMMDD.pip  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];48  
  @txtDate AS VARCHAR(10),  
 @txtFlag AS VARCHAR(1) = '0'  
AS     
  
 /*  
  Creador: Lic. René López Salinas  
  Fecha: 20-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_IRSFWDAAAAMMDD.pip  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- Construyo tabla Temporal para reportar informacion  
 DECLARE @tblTemp TABLE (  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtData][VARCHAR](92)  
 )  
  
 -- Obtenemos la información  
  
 -- Info: IRS-Bid  
 INSERT @tblTemp  
 SELECT   
  'MCC' AS [txtTv],  
  'TIIE28' AS [txtEmisora],  
             CASE   
   WHEN intterm = 84 THEN '3X1'       
   WHEN intterm = 168 THEN '6X1'  
          WHEN intterm = 252 THEN '9X1'  
   WHEN intterm = 364 THEN '13X1'  
              WHEN intterm = 728 THEN '26X1'  
   WHEN intterm = 1092 THEN '39X1'  
          WHEN intterm = 1456 THEN '52X1'  
   WHEN intterm = 1820 THEN '65X1'  
          WHEN intterm = 2548 THEN '91X1'  
   WHEN intterm = 3640 THEN '130X1'  
          WHEN intterm = 5460 THEN '195X1'  
   WHEN intterm = 7280 THEN '260X1'  
   WHEN intterm = 10920 THEN '390X1'  
          ELSE ''   
  END AS [txtSerie],  
  SUBSTRING (  
   'H MC' +  
   CONVERT(CHAR(8),dteDate,112) +  
   'MCC ' +   
   'TIIE28 ' +  
              CASE   
    WHEN intterm = 84 THEN '3X1   '       
    WHEN intterm = 168 THEN '6X1   '  
           WHEN intterm = 252 THEN '9X1   '  
    WHEN intterm = 364 THEN '13X1  '  
               WHEN intterm = 728 THEN '26X1  '  
    WHEN intterm = 1092 THEN '39X1  '  
           WHEN intterm = 1456 THEN '52X1  '  
    WHEN intterm = 1820 THEN '65X1  '  
           WHEN intterm = 2548 THEN '91X1  '  
    WHEN intterm = 3640 THEN '130X1 '  
           WHEN intterm = 5460 THEN '195X1 '  
    WHEN intterm = 7280 THEN '260X1 '  
    WHEN intterm = 10920 THEN '390X1 '  
           ELSE '      '   
   END +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 11, 6) +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 11, 6) +   
   '000000000000025009' + @txtFlag + '00000000000000', 1, 92) AS [txtData]  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
        WHERE   
  dtedate = @txtDate  
  AND txtCode = 'IRS'  
 ORDER BY intTerm  
  
 -- Info: IRS-Ask  
 INSERT @tblTemp  
        SELECT   
  'MCV' AS [txtTv],  
  'TIIE28' AS [txtEmisora],  
             CASE   
   WHEN intterm = 84 THEN '3X1'       
   WHEN intterm = 168 THEN '6X1'  
          WHEN intterm = 252 THEN '9X1'  
   WHEN intterm = 364 THEN '13X1'  
              WHEN intterm = 728 THEN '26X1'  
   WHEN intterm = 1092 THEN '39X1'  
          WHEN intterm = 1456 THEN '52X1'  
   WHEN intterm = 1820 THEN '65X1'  
          WHEN intterm = 2548 THEN '91X1'  
   WHEN intterm = 3640 THEN '130X1'  
          WHEN intterm = 5460 THEN '195X1'  
   WHEN intterm = 7280 THEN '260X1'  
   WHEN intterm = 10920 THEN '390X1'  
          ELSE ''   
  END AS [txtSerie],  
  SUBSTRING (  
   'H MC' +  
   CONVERT(CHAR(8),dteDate,112) +  
   'MCV ' +   
   'TIIE28 ' +  
              CASE   
    WHEN intterm = 84 THEN '3X1   '       
    WHEN intterm = 168 THEN '6X1   '  
           WHEN intterm = 252 THEN '9X1   '  
    WHEN intterm = 364 THEN '13X1  '  
               WHEN intterm = 728 THEN '26X1  '  
    WHEN intterm = 1092 THEN '39X1  '  
           WHEN intterm = 1456 THEN '52X1  '  
    WHEN intterm = 1820 THEN '65X1  '  
           WHEN intterm = 2548 THEN '91X1  '  
    WHEN intterm = 3640 THEN '130X1 '  
           WHEN intterm = 5460 THEN '195X1 '  
    WHEN intterm = 7280 THEN '260X1 '  
    WHEN intterm = 10920 THEN '390X1 '  
           ELSE '      '   
   END +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 11, 6) +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 11, 6) +   
   '000000000000025009' + @txtFlag + '00000000000000', 1, 92) AS [txtData]  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
        WHERE   
  dtedate = @txtDate  
  AND txtCode = 'IRS'  
 ORDER BY intTerm  
  
 -- Info: FWDs-Bid  
 INSERT @tblTemp  
        SELECT   
  'FWC ' AS [txtTv],  
  'MXPUSD ' AS [txtEmisora],  
  CASE   
   WHEN intterm = 1 THEN '1D'                
   WHEN intterm = 7 THEN '7D'  
   WHEN intterm >=20 AND intterm <=28 THEN '21D'      
   WHEN intterm >=30 AND intterm <=38 THEN '1M'  
   WHEN intterm >=60 AND intterm <=68 THEN '2M'  
   WHEN intterm >=90 AND intterm <=98 THEN '3M'  
   WHEN intterm >=180 AND intterm <=188 THEN '6M'     
   WHEN intterm >=270 AND intterm <=278 THEN '9M'  
   WHEN intterm >=360 AND intterm <=368 THEN '1Y'     
   WHEN intterm >=540 AND intterm <=550 THEN '1.5Y'  
   WHEN intterm >=730 AND intterm <=738 THEN '2Y'     
   WHEN intterm >=1090 AND intterm <=1099 THEN '3Y'  
   WHEN intterm >=1460 AND intterm <=1468 THEN '4Y'   
   WHEN intterm >=1820 AND intterm <=1828 THEN '5Y'  
   WHEN intterm >=2184 AND intterm <=2198 THEN '6Y'   
   ELSE ''  
  END AS [txtSerie],  
  SUBSTRING (  
   'H MD' +  
   CONVERT(CHAR(8),dteDate,112) +  
   'FWC ' +   
   'MXPUSD ' +  
              CASE   
    WHEN intterm = 1 THEN '1D    '                
    WHEN intterm = 7 THEN '7D    '  
    WHEN intterm >=20 AND intterm <=28 THEN '21D   '      
    WHEN intterm >=30 AND intterm <=38 THEN '1M    '  
    WHEN intterm >=60 AND intterm <=68 THEN '2M    '  
    WHEN intterm >=90 AND intterm <=98 THEN '3M    '  
    WHEN intterm >=180 AND intterm <=188 THEN '6M    '     
    WHEN intterm >=270 AND intterm <=278 THEN '9M    '  
    WHEN intterm >=360 AND intterm <=368 THEN '1Y    '     
    WHEN intterm >=540 AND intterm <=550 THEN '1.5Y  '  
    WHEN intterm >=730 AND intterm <=738 THEN '2Y    '     
    WHEN intterm >=1090 AND intterm <=1099 THEN '3Y    '  
    WHEN intterm >=1460 AND intterm <=1468 THEN '4Y    '   
    WHEN intterm >=1820 AND intterm <=1828 THEN '5Y    '  
    WHEN intterm >=2184 AND intterm <=2198 THEN '6Y    '   
    ELSE '      '  
   END +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 11, 6) +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelBid,6),16,6),  ' ', '0'), 11, 6) +   
   '000000000000025009' + @txtFlag + '00000000000000', 1, 92) AS [txtData]  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
 WHERE   
  dtedate = @txtDate  
  AND txtCode = 'PtosFWD'   
  AND intTerm NOT IN (14)  
 ORDER BY intTerm  
  
 -- Info: FWDs-Ask  
 INSERT @tblTemp  
        SELECT   
  'FWV ' AS [txtTv],  
  'MXPUSD ' AS [txtEmisora],  
  CASE   
   WHEN intterm = 1 THEN '1D'                
   WHEN intterm = 7 THEN '7D'  
   WHEN intterm >=20 AND intterm <=28 THEN '21D'      
   WHEN intterm >=30 AND intterm <=38 THEN '1M'  
   WHEN intterm >=60 AND intterm <=68 THEN '2M'  
   WHEN intterm >=90 AND intterm <=98 THEN '3M'  
   WHEN intterm >=180 AND intterm <=188 THEN '6M'     
   WHEN intterm >=270 AND intterm <=278 THEN '9M'  
   WHEN intterm >=360 AND intterm <=368 THEN '1Y'     
   WHEN intterm >=540 AND intterm <=550 THEN '1.5Y'  
   WHEN intterm >=730 AND intterm <=738 THEN '2Y'     
   WHEN intterm >=1090 AND intterm <=1099 THEN '3Y'  
   WHEN intterm >=1460 AND intterm <=1468 THEN '4Y'   
   WHEN intterm >=1820 AND intterm <=1828 THEN '5Y'  
   WHEN intterm >=2184 AND intterm <=2198 THEN '6Y'   
   ELSE ''  
  END AS [txtSerie],  
  SUBSTRING (  
   'H MD' +  
   CONVERT(CHAR(8),dteDate,112) +  
   'FWV ' +   
   'MXPUSD ' +  
              CASE   
    WHEN intterm = 1 THEN '1D    '                
    WHEN intterm = 7 THEN '7D    '  
    WHEN intterm >=20 AND intterm <=28 THEN '21D   '      
    WHEN intterm >=30 AND intterm <=38 THEN '1M    '  
    WHEN intterm >=60 AND intterm <=68 THEN '2M    '  
    WHEN intterm >=90 AND intterm <=98 THEN '3M    '  
    WHEN intterm >=180 AND intterm <=188 THEN '6M    '     
    WHEN intterm >=270 AND intterm <=278 THEN '9M    '  
    WHEN intterm >=360 AND intterm <=368 THEN '1Y    '     
    WHEN intterm >=540 AND intterm <=550 THEN '1.5Y  '  
    WHEN intterm >=730 AND intterm <=738 THEN '2Y    '     
    WHEN intterm >=1090 AND intterm <=1099 THEN '3Y    '  
    WHEN intterm >=1460 AND intterm <=1468 THEN '4Y    '   
    WHEN intterm >=1820 AND intterm <=1828 THEN '5Y    '  
    WHEN intterm >=2184 AND intterm <=2198 THEN '6Y    '   
    ELSE '      '  
   END +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 11, 6) +   
   SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(dblLevelAsk,6),16,6),  ' ', '0'), 11, 6) +   
   '000000000000025009' + @txtFlag + '00000000000000', 1, 92) AS [txtData]  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
 WHERE   
  dtedate = @txtDate  
  AND txtCode = 'PtosFWD'   
  AND intTerm NOT IN (14)  
 ORDER BY intTerm  
  
 -- Reporto información  
 SELECT txtData  
 FROM @tblTemp  
  
 SET NOCOUNT OFF   
  
END  
  
-- para obtener vector de precios Ing_MDAAAAMMDD.pip  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];49  
  @txtDate AS VARCHAR(10),  
 @txtFlag AS VARCHAR(1) = '0',  
 @txtLiquidation AS VARCHAR(3) = 'MD'  
AS     
  
 /*  
  Creador: Lic. René López Salinas  
  Fecha: 20-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_MDAAAAMMDD.pip  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- Construyo tabla Temporal para reportar informacion  
 DECLARE @tblTemp TABLE (  
  Row INT,  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtData][VARCHAR](116)  
 )  
  
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)  
 DECLARE @tmp_tblCurveToPricesVectorPIP TABLE (  
  Row INT,  
  Type  CHAR(3),  
  SubType  CHAR(3),  
  Tv CHAR(4),  
  Emisora CHAR(7),  
  Serie CHAR(6),  
  Descripcion CHAR(18),  
  dblBase FLOAT  
  PRIMARY KEY(Row)  
 )  
  
 INSERT @tmp_tblCurveToPricesVectorPIP  
  SELECT 00001,'FWD','CU','*D','CURVAD','PLAZO','IMPLICITA',100 UNION  
  SELECT 00002,'SWP','TI','*D','TDST28','PLAZO','IRS/TIIE',100 UNION  
  SELECT 00003,'RB1','B1','*R','REPOB1','PLAZO','REPO Bancario B1',100 UNION  
  SELECT 00004,'RB2','B2','*R','REPOB2','PLAZO','REPO Bancario B2',100 UNION  
  SELECT 00005,'RB3','B3','*R','REPOB3','PLAZO','REPO Bancario B3',100 UNION  
  SELECT 00006,'RB4','B4','*R','REPOB4','PLAZO','REPO Bancario B4',100 UNION  
  SELECT 00007,'RG2','G2','*R','REPOBO','PLAZO','REPO Guber G2',100 UNION  
  SELECT 00008,'RG2','G2I','*R','REPOBOI','PLAZO','REPO Guber G2 I',100 UNION  
  SELECT 00009,'RG1','G1','*R','REPOCT','PLAZO','REPO Guber G1',100 UNION  
  SELECT 00010,'RG1','G1I','*R','REPOCTI','PLAZO','REPO Guber G1 I',100 UNION  
  SELECT 00011,'RG3','G3','*R','REPOUB','PLAZO','REPO Guber G3',100 UNION  
  SELECT 00012,'RG3','G3I','*R','REPOUBI','PLAZO','REPO Guber G3 I',100 UNION  
  SELECT 00013,'RPR','A3','*R','REPOAAA','PLAZO','REPO PRIVADO AAA',100 UNION  
  SELECT 00014,'RPR','A2','*R','REPOAA','PLAZO','REPO PRIVADO AA',100 UNION  
  SELECT 00015,'LIB','BL','*D','LIBOR','PLAZO','LIBOR',100 UNION  
  SELECT 00016,'TSN','YLD','*D','TREUSD','PLAZO','TREASURIES',100 UNION  
  SELECT 00017,'UMS','REP','*R','REPOUM','PLAZO','REPO UMS',100 UNION  
  SELECT 00018,'CET','CT','CB','CETES','PLAZO','CETES',100 UNION  
  SELECT 00019,'PLV','P8','CEI','BANCARI','PLAZO','BANCARIO OTROS',100  
  
 -- Info:  Curvas en Formato Vector de Precios (Parte I)  
 INSERT @tblTemp  
 SELECT   
  01,  
  tmp.Tv,  
  tmp.Emisora,  
                CASE   
   WHEN tmp.Serie = 'PLAZO' THEN CONVERT(CHAR(6), c.intTerm)  
   WHEN tmp.Serie = 'FECHA' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm, @txtDate), 112),3,6)  
   WHEN tmp.Serie = 'FECHA3' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm -1 , @txtDate), 112),3,6)  
   ELSE '      '  
  END AS [Serie],  
  SUBSTRING (  
                    'H ' + 'MD' +   
                    CONVERT(CHAR(8), @txtDate, 112) +   
                    CONVERT(CHAR(4), tmp.Tv) +   
                    CONVERT(CHAR(7), tmp.Emisora) +   
                    (CASE   
    WHEN tmp.Serie = 'PLAZO' THEN CONVERT(CHAR(6), c.intTerm)  
    WHEN tmp.Serie = 'FECHA' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm, @txtDate), 112),3,6)  
    WHEN tmp.Serie = 'FECHA3' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm -1 , @txtDate), 112),3,6)  
    ELSE '      '  
   END) +   
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 11, 6) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 11, 6) +  
            '000000000000' +   
            '025009' +   
   @txtFlag +  
   '00000000000000'+'000000000000', 1, 116)  
 FROM MxFixIncome.dbo.tblCurves AS c (NOLOCK)  
  INNER JOIN @tmp_tblCurveToPricesVectorPIP AS tmp  
   ON c.txtType = tmp.Type AND c.txtSubType = tmp.SubType  
 WHERE   
  c.dteDate = @txtDate  
  AND tmp.Row <= 17  
 ORDER BY   
  tmp.Row,c.intTerm  
  
 -- Info: Vector de Precios  
 INSERT @tblTemp  
 SELECT DISTINCT  
  02,  
  ap.txtTV,  
  ap.txtEmisora,  
  ap.txtSerie,  
  SUBSTRING (  
   'H ' +  
   CASE  
    WHEN ap.txtTv IN ('1', '1A', '1B','1E', '3', '0', '41', '51', '52',   
                          '53', '54', 'YY', 'FA', 'FI', 'WA', 'WI','1AFX','1ASP','1I') THEN 'MC'  
    ELSE 'MD'  
   END +  
   CONVERT(CHAR(8), @txtDate, 112) +  
   ap.txtTv + REPLICATE(' ',4 - LEN(ap.txtTv)) +  
   ap.txtEmisora + REPLICATE(' ',7 - LEN(ap.txtEmisora)) +  
   ap.txtSerie + REPLICATE(' ',6 - LEN(ap.txtSerie)) +  
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 1, 6) +  
   SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 8, 6) +  
   '025009' +  
   @txtFlag +  
   SUBSTRING(REPLACE(STR(ROUND(ap.dblDTM,0),6,0),  ' ', '0'), 1, 6) +  
   
            CASE   
    WHEN ABS(ap.dblUDR) < 1E-4 THEN  '00000000'  
    WHEN ap.dblUDR < 0 THEN   
                    '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  '-', '0'),' ','0'), 2, 3) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  ' ', '0'), 6, 4)   
          ELSE   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 1, 4) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 6, 4)  
            END +   
            CASE WHEN dblLDR < 0 Then   
             '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblLDR,6),13,6),  '-', '0'),' ','0'), 2, 5) +   
                   SUBSTRING(REPLACE(STR(ROUND(dblLDR,6),13,6),  ' ', '0'), 8, 6)   
                 ELSE   
        SUBSTRING(REPLACE(STR(ROUND(dblLDR,6),13,6),  ' ', '0'), 1, 6) +   
        SUBSTRING(REPLACE(STR(ROUND(dblLDR,6),13,6),  ' ', '0'), 8, 6)  
         END +   
  
            CASE WHEN dblYTM < 0 Then   
             '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblYTM,6),13,6),  '-', '0'),' ','0'), 2, 5) +   
                   SUBSTRING(REPLACE(STR(ROUND(dblYTM,6),13,6),  ' ', '0'), 8, 6)   
                 ELSE   
        SUBSTRING(REPLACE(STR(ROUND(dblYTM,6),13,6),  ' ', '0'), 1, 6) +   
        SUBSTRING(REPLACE(STR(ROUND(dblYTM,6),13,6),  ' ', '0'), 8, 6)  
         END, 1, 116)  
 FROM MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
   ON a1.txtId1 = ap.txtId1  
   AND a1.txtLiquidation = (  
    CASE ap.txtLiquidation    
    WHEN 'MP' THEN 'MD'    
    ELSE ap.txtLiquidation    
    END  
   )  
 WHERE   
  ap.txtLiquidation IN (@txtLiquidation, 'MP')  
   AND ap.txtTv NOT IN ('FA','FC','FD','FI','FU','FB','*C','*CSP')  
 ORDER BY   
  ap.txtTV,  
  ap.txtEmisora,  
  ap.txtSerie  
  
 -- Info: Vector de Notas Estructuradas  
 INSERT @tblTemp  
 SELECT DISTINCT  
  02,  
  ap.txtTV,  
  ap.txtEmisora,  
  ap.txtSerie,  
  SUBSTRING (  
   'H ' +  
   CASE  
    WHEN ap.txtTv IN ('1', '1A', '1B','1E', '3', '0', '41', '51', '52',   
                          '53', '54', 'YY', 'FA', 'FI', 'WA', 'WI','1AFX','1ASP','1I') THEN 'MC'  
    ELSE 'MD'  
   END +  
   CONVERT(CHAR(8), @txtDate, 112) +  
   ap.txtTv + REPLICATE(' ',4 - LEN(ap.txtTv)) +  
   ap.txtEmisora + REPLICATE(' ',7 - LEN(ap.txtEmisora)) +  
   ap.txtSerie + REPLICATE(' ',6 - LEN(ap.txtSerie)) +  
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 1, 6) +  
   SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 8, 6) +  
   '025009' +  
   @txtFlag +  
   SUBSTRING(REPLACE(STR(ROUND(ap.dblDTM,0),6,0),  ' ', '0'), 1, 6) +  
   
            CASE   
    WHEN ABS(ap.dblUDR) < 1E-4 THEN  '00000000'  
    WHEN ap.dblUDR < 0 THEN   
                    '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  '-', '0'),' ','0'), 2, 3) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  ' ', '0'), 6, 4)   
           ELSE   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 1, 4) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 6, 4)  
            END +   
            CASE WHEN dblLDR < 0 Then   
             '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblLDR,6),13,6),  '-', '0'),' ','0'), 2, 5) +   
                   SUBSTRING(REPLACE(STR(ROUND(dblLDR,6),13,6),  ' ', '0'), 8, 6)   
                 ELSE   
        SUBSTRING(REPLACE(STR(ROUND(dblLDR,6),13,6),  ' ', '0'), 1, 6) +   
        SUBSTRING(REPLACE(STR(ROUND(dblLDR,6),13,6),  ' ', '0'), 8, 6)  
         END +   
            CASE WHEN dblYTM < 0 Then   
             '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblYTM,6),13,6),  '-', '0'),' ','0'), 2, 5) +   
                   SUBSTRING(REPLACE(STR(ROUND(dblYTM,6),13,6),  ' ', '0'), 8, 6)   
                 ELSE   
        SUBSTRING(REPLACE(STR(ROUND(dblYTM,6),13,6),  ' ', '0'), 1, 6) +   
        SUBSTRING(REPLACE(STR(ROUND(dblYTM,6),13,6),  ' ', '0'), 8, 6)  
         END, 1, 116)  
  FROM MxFixIncome.dbo.tmp_tblActualPricesSN AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
   ON a1.txtId1 = ap.txtId1  
   AND a1.txtLiquidation = (  
    CASE ap.txtLiquidation    
    WHEN 'MP' THEN 'MD'    
    ELSE ap.txtLiquidation    
    END  
   )  
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)  
   ON ap.txtId1 = op.txtDir  
 WHERE   
  ap.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND op.txtOwnerId = 'ing04'  
  AND op.txtProductId = 'SNOTES'  
  AND op.dteBeg <= @txtDate  
  AND op.dteEnd >= @txtDate  
 ORDER BY   
  ap.txtTV,  
  ap.txtEmisora,  
  ap.txtSerie  
  
 -- Info:  Curvas en Formato Vector de Precios (Parte II)  
 INSERT @tblTemp  
 SELECT    
  03,  
  tmp.Tv,  
  tmp.Emisora,  
                CASE   
   WHEN tmp.Serie = 'PLAZO' THEN CONVERT(CHAR(6), c.intTerm)  
   WHEN tmp.Serie = 'FECHA' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm, @txtDate), 112),3,6)  
   WHEN tmp.Serie = 'FECHA3' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm -1 , @txtDate), 112),3,6)  
   ELSE '      '  
  END AS [Serie],  
  SUBSTRING (  
                    'H ' + 'MD' +   
                    CONVERT(CHAR(8), @txtDate, 112) +   
                    CONVERT(CHAR(4), tmp.Tv) +   
                    CONVERT(CHAR(7), tmp.Emisora) +   
                    (CASE   
    WHEN tmp.Serie = 'PLAZO' THEN CONVERT(CHAR(6), c.intTerm)  
    WHEN tmp.Serie = 'FECHA' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm, @txtDate), 112),3,6)  
    WHEN tmp.Serie = 'FECHA3' THEN SUBSTRING(CONVERT(CHAR(8), DATEADD(DAY, c.intTerm -1 , @txtDate), 112),3,6)  
    ELSE '      '  
   END) +   
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 11, 6) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblRate*tmp.dblBase,6),16,6),  ' ', '0'), 11, 6) +  
            '000000000000' +   
            '025009' + @txtFlag +  
   '00000000000000'+'000000000000', 1, 116)  
 FROM MxFixIncome.dbo.tblCurves AS c (NOLOCK)  
  INNER JOIN @tmp_tblCurveToPricesVectorPIP AS tmp  
   ON c.txtType = tmp.Type AND c.txtSubType = tmp.SubType  
 WHERE   
  c.dteDate = @txtDate  
  AND tmp.Row > 17  
  AND c.intTerm <= 365  
 ORDER BY   
  tmp.Row,c.intTerm  
  
  
 -- Reporto información  
 SELECT txtData  
 FROM @tblTemp  
  
 SET NOCOUNT OFF   
  
END  
  
  
-- para obtener vector de precios Ing_TCAAAAMMDD.pip  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];50  
  @txtDate AS VARCHAR(10),  
 @txtFlag AS VARCHAR(1) = '0'  
AS     
  
 /*  
  Creador: Lic. René López Salinas  
  Fecha: 22-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_TCAAAAMMDD.pip  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 -- Construyo tabla Temporal para reportar informacion  
 DECLARE @tblTemp TABLE (  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtData][VARCHAR](8000),  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  
  
 -- creamos el reporte con la informacion del vector original  
  
 INSERT @tblTemp  
 SELECT DISTINCT  
  ap.txtTV,  
  ap.txtEmisora,  
  ap.txtSerie,  
  SUBSTRING (  
   'H ' +  
   CASE  
    WHEN ap.txtTv IN ('1', '1A', '1B','1E', '3', '0', '41', '51', '52',   
                          '53', '54', 'YY', 'FA', 'FI', 'WA', 'WI','1AFX','1ASP','1I') THEN 'MC'  
    ELSE 'MD'  
   END +  
   @txtDate +  
   ap.txtTv + REPLICATE(' ',4 - LEN(ap.txtTv)) +  
   ap.txtEmisora + REPLICATE(' ',7 - LEN(ap.txtEmisora)) +  
   ap.txtSerie + REPLICATE(' ',6 - LEN(ap.txtSerie)) +  
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP'THEN  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 11, 6)  
   END +   
    
   SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 1, 6) +  
    SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 8, 6) +  
   '025009' +  
   @txtFlag +  
   SUBSTRING(REPLACE(STR(ROUND(ap.dblDTM,0),6,0),  ' ', '0'), 1, 6) +  
   
                 CASE   
    WHEN ABS(ap.dblUDR) < 1E-4 THEN  '00000000'  
    WHEN ap.dblUDR < 0 THEN   
                    '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  '-', '0'),' ','0'), 2, 3) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  ' ', '0'), 6, 4)   
           ELSE   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 1, 4) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 6, 4)  
                  END , 1, 92)  
  
 FROM MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
   ON a1.txtId1 = ap.txtId1  
   AND a1.txtLiquidation = (  
    CASE ap.txtLiquidation    
    WHEN 'MP' THEN 'MD'    
    ELSE ap.txtLiquidation    
    END  
   )  
 WHERE   
  ap.txtLiquidation IN ('MD', 'MP')  
  AND ap.txtTv IN ('*C','*CSP')  
  AND ap.txtEMISORA <> 'MXPUDI'  
  
  
 -- Reporto información  
 SELECT txtData  
 FROM @tblTemp  
 ORDER BY txtTV, txtEmisora, txtSerie    
  
 SET NOCOUNT OFF   
  
END  
  
  
-- para obtener producto Ing_CetesAAAAMMDD.csv  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];51  
 @txtDate AS DATETIME  
  
 /*   
  
   Version 1.0    
     
  Creador: Lic. René López Salinas  
  Fecha: 22-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_CetesAAAAMMDD.csv  
  
 */  
  
AS   
BEGIN  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  TypeColumn VARCHAR(10),  
  Detail  VARCHAR(130)  
 )  
  
 -- Reporto Info:  Vector de Precios  
 INSERT @tmp_tblResults   
 SELECT 00001 AS [Row],'Detail'  AS [TypeColumn],   
   'B,CETES,' +   
   LTRIM(STR(intTerm,6,0))  + ',' +    
   LTRIM(STR(dblRate*100,19,6)) + ',' +    
   LTRIM(STR(10/(1+(((dblRate*100)*intTerm)/36000)),19,6))  
  FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
  WHERE dteDate = @txtDate  
   AND txtType = 'CET'  
   AND txtSubType = 'CT'  
  ORDER BY txtType, txtSubtype, intTerm  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF   
  
END  
RETURN 0  
  
  
-- para obtener producto Ing_IRSFWDAAAAMMDD.csv  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];52  
 @txtDate AS DATETIME  
  
 /*   
  
   Version 1.0    
     
  Creador: Lic. René López Salinas  
  Fecha: 22-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_IRSFWDAAAAMMDD.csv  
  
 */  
  
AS   
BEGIN  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  TypeColumn VARCHAR(10),  
  Detail  VARCHAR(130)  
 )  
  
 -- Reporto Info:  Vector de Precios  
 INSERT @tmp_tblResults   
        SELECT 00001 AS [Row],'Header' AS [TypeColumn],'' AS [Label]  
  
 INSERT @tmp_tblResults   
        SELECT 00002 AS [Row],'Header' AS [TypeColumn],'Fecha,Tipo Valor,Emisora,Serie,Precio Limpio,Precio Sucio,Intereses Acumulados,Cupón Actual,Sobretasa/Tasa de Rendimiento' AS [Label]  
  
 INSERT @tmp_tblResults   
        SELECT 00003 AS [Row],'Header' AS [TypeColumn],'' AS [Label]  
  
 -- Info: IRS-Bid  
 INSERT @tmp_tblResults   
 SELECT 00004 AS [Row],'Detail'  AS [TypeColumn],   
  CONVERT(CHAR(8),dteDate,112) + ',' +  
  'MCC' + ',' +  
  'TIIE28'  + ',' +  
             CASE   
   WHEN intterm = 84 THEN '3X1'       
   WHEN intterm = 168 THEN '6X1'  
          WHEN intterm = 252 THEN '9X1'  
   WHEN intterm = 364 THEN '13X1'  
              WHEN intterm = 728 THEN '26X1'  
   WHEN intterm = 1092 THEN '39X1'  
          WHEN intterm = 1456 THEN '52X1'  
   WHEN intterm = 1820 THEN '65X1'  
          WHEN intterm = 2548 THEN '91X1'  
   WHEN intterm = 3640 THEN '130X1'  
          WHEN intterm = 5460 THEN '195X1'  
   WHEN intterm = 7280 THEN '260X1'  
   WHEN intterm = 10920 THEN '390X1'  
          ELSE ''   
  END  + ',' +  
  LTRIM(STR(dblLevelBid,19,6))+ ',' +  
  LTRIM(STR(dblLevelBid,19,6))  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
        WHERE   
  dtedate = @txtDate  
  AND txtCode = 'IRS'  
 ORDER BY intTerm  
  
 -- Info: IRS-Ask  
 INSERT @tmp_tblResults   
 SELECT 00005 AS [Row],'Detail'  AS [TypeColumn],   
  CONVERT(CHAR(8),dteDate,112) + ',' +  
  'MCV' + ',' +  
  'TIIE28'  + ',' +  
             CASE   
   WHEN intterm = 84 THEN '3X1'       
   WHEN intterm = 168 THEN '6X1'  
          WHEN intterm = 252 THEN '9X1'  
   WHEN intterm = 364 THEN '13X1'  
              WHEN intterm = 728 THEN '26X1'  
   WHEN intterm = 1092 THEN '39X1'  
          WHEN intterm = 1456 THEN '52X1'  
   WHEN intterm = 1820 THEN '65X1'  
          WHEN intterm = 2548 THEN '91X1'  
   WHEN intterm = 3640 THEN '130X1'  
          WHEN intterm = 5460 THEN '195X1'  
   WHEN intterm = 7280 THEN '260X1'  
   WHEN intterm = 10920 THEN '390X1'  
          ELSE ''   
  END  + ',' +  
  LTRIM(STR(dblLevelAsk,19,6))+ ',' +  
  LTRIM(STR(dblLevelAsk,19,6))  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
        WHERE   
  dtedate = @txtDate  
  AND txtCode = 'IRS'  
 ORDER BY intTerm  
  
  
 -- Info: FWDs-Bid  
 INSERT @tmp_tblResults   
 SELECT 00006 AS [Row],'Detail'  AS [TypeColumn],   
  CONVERT(CHAR(8),dteDate,112) + ',' +  
  'FWC' + ',' +  
  'MXPUSD' + ',' +  
  CASE   
   WHEN intterm = 1 THEN '1D'                
   WHEN intterm = 7 THEN '7D'  
   WHEN intterm >=20 AND intterm <=28 THEN '21D'      
   WHEN intterm >=30 AND intterm <=38 THEN '1M'  
   WHEN intterm >=60 AND intterm <=68 THEN '2M'  
   WHEN intterm >=90 AND intterm <=98 THEN '3M'  
   WHEN intterm >=180 AND intterm <=188 THEN '6M'     
   WHEN intterm >=270 AND intterm <=278 THEN '9M'  
   WHEN intterm >=360 AND intterm <=368 THEN '1Y'     
   WHEN intterm >=540 AND intterm <=550 THEN '1.5Y'  
   WHEN intterm >=730 AND intterm <=738 THEN '2Y'     
   WHEN intterm >=1090 AND intterm <=1099 THEN '3Y'  
   WHEN intterm >=1460 AND intterm <=1468 THEN '4Y'   
   WHEN intterm >=1820 AND intterm <=1828 THEN '5Y'  
   WHEN intterm >=2184 AND intterm <=2198 THEN '6Y'   
   ELSE ''  
  END + ',' +  
  LTRIM(STR(dblLevelBid,19,6))+ ',' +  
  LTRIM(STR(dblLevelBid,19,6))  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
 WHERE   
  dtedate = @txtDate  
  AND txtCode = 'PtosFWD'   
  AND intTerm NOT IN (14)  
 ORDER BY intTerm  
  
 -- Info: FWDs-Ask  
 INSERT @tmp_tblResults   
 SELECT 00007 AS [Row],'Detail'  AS [TypeColumn],   
  CONVERT(CHAR(8),dteDate,112) + ',' +  
  'FWV' + ',' +  
  'MXPUSD' + ',' +  
  CASE   
   WHEN intterm = 1 THEN '1D'                
   WHEN intterm = 7 THEN '7D'  
   WHEN intterm >=20 AND intterm <=28 THEN '21D'      
   WHEN intterm >=30 AND intterm <=38 THEN '1M'  
   WHEN intterm >=60 AND intterm <=68 THEN '2M'  
   WHEN intterm >=90 AND intterm <=98 THEN '3M'  
   WHEN intterm >=180 AND intterm <=188 THEN '6M'     
   WHEN intterm >=270 AND intterm <=278 THEN '9M'  
   WHEN intterm >=360 AND intterm <=368 THEN '1Y'     
   WHEN intterm >=540 AND intterm <=550 THEN '1.5Y'  
   WHEN intterm >=730 AND intterm <=738 THEN '2Y'     
   WHEN intterm >=1090 AND intterm <=1099 THEN '3Y'  
   WHEN intterm >=1460 AND intterm <=1468 THEN '4Y'   
   WHEN intterm >=1820 AND intterm <=1828 THEN '5Y'  
   WHEN intterm >=2184 AND intterm <=2198 THEN '6Y'   
   ELSE ''  
  END + ',' +  
  LTRIM(STR(dblLevelAsk,19,6))+ ',' +  
  LTRIM(STR(dblLevelAsk,19,6))  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
 WHERE   
  dtedate = @txtDate  
  AND txtCode = 'PtosFWD'   
  AND intTerm NOT IN (14)  
 ORDER BY intTerm  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF   
  
END  
RETURN 0  
  
  
-- para obtener producto Ing_UbibonosAAAAMMDD.csv  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];53  
 @txtDate AS DATETIME  
  
 /*   
  
   Version 1.0    
     
  Creador: Lic. René López Salinas  
  Fecha: 22-Oct-2008  
  Funcionalidad: Modulo para generar el producto: Ing_UbibonosAAAAMMDD.csv  
  
 */  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  TypeColumn VARCHAR(10),  
  Detail  VARCHAR(130)  
 )  
  
 -- Reporto Info:  Vector de Precios  
 INSERT @tmp_tblResults   
        SELECT 00001 AS [Row],'Header' AS [TypeColumn],'' AS [Label]  
  
 INSERT @tmp_tblResults   
        SELECT 00002 AS [Row],'Header' AS [TypeColumn],'Fecha,Tipo Valor,Emisora,Serie,Precio Sucio,Precio Limpio,Intereses Acumulados' AS [Label]  
  
 INSERT @tmp_tblResults   
        SELECT 00003 AS [Row],'Header' AS [TypeColumn],'' AS [Label]  
  
 -- Info: Vector de Precios Udibonos  
 INSERT @tmp_tblResults   
 SELECT 00004 AS [Row],'Detail'  AS [TypeColumn],   
  CONVERT(CHAR(10),@txtDate,103) + ',' +   
  RTRIM(u.txtTv) + ',' +   
  RTRIM(u.txtEmisora) + ',' +   
  RTRIM(u.txtSerie) + ',' +   
  LTRIM(STR(ROUND(u.dblPRS,6),19,6)) + ',' +   
  LTRIM(STR(ROUND(u.dblPRL,6),19,6)) + ',' +   
  LTRIM(STR(ROUND(u.dblCPD,6),19,6))  
  FROM   
  tmp_tblActualPrices AS u (NOLOCK)  
  WHERE  
  u.txtLiquidation = 'MD'  
  AND u.txtTv IN ('S','S0','S3','S5')  
  
  ORDER BY   
  u.txtTv,  
  u.txtEmisora,  
  u.txtSerie  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF   
  
END  
RETURN 0  
  
-- para obtener producto: ING05_VAIAAAAMMDDCL.PIP  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];54  
  @txtDate AS DATETIME  
  
 /*   
  
   Version 1.0    
     
  Creador: Lic. René López Salinas  
  Fecha: 16-Feb-2009  
  Funcionalidad: Modulo para generar el producto: ING05_VAIAAAAMMDDCL.PIP  
  
 */  
  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row  VARCHAR(128)  
 )  
  
 -- creo tabla temporal de Keys Countries  
 DECLARE @tmp_tblKEYsCountries TABLE (  
  txtId1  CHAR(11),  
  dteDate DATETIME  
  PRIMARY KEY(txtId1)  
 )  
  
 -- creo tabla temporal de Keys Tickers Bloomberg  
 DECLARE @tbl_tmpIdsKEYsAddId7 TABLE (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY(txtId1)  
 )  
  
 -- creo tabla temporal de Keys Volumen  
 DECLARE @tbl_tmpKEYsVolumen TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] ),  
  [dteDate] [DATETIME] NOT NULL  
 )  
  
 -- creo tabla temporal de Keys Volumen Promedio 5 Dias  
 DECLARE @tbl_tmpKEYsVolumen_5D TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] ),  
  [dteDate] [DATETIME] NOT NULL  
 )  
  
 -- Carga información de Keys Countries  
 INSERT @tmp_tblKEYsCountries   
 SELECT tadd.txtId1,MAX(dteDate)  
 FROM MxFixIncome.dbo.tmp_tblActualPrices  AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
   ON ap.txtId1 = tadd.txtId1  
    AND txtItem = 'COUNTRY'  
 GROUP BY tadd.txtId1  
  
 -- Carga información de Keys Tickers Bloomberg  
 INSERT @tbl_tmpIdsKEYsAddId7  
 SELECT tadd.txtId1,MAX(tadd.dteDate)  
 FROM MxFixIncome.dbo.tmp_tblActualPrices  AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
   ON ap.txtId1 = tadd.txtId1 AND tadd.txtItem = 'ID7' AND tadd.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  tadd.txtId1  
  
 -- Carga información de Keys Volumen 60 Bloomberg  
 INSERT @tbl_tmpKEYsVolumen  
 SELECT tadd.txtId1,MAX(tadd.dteDate)  
 FROM MxFixIncome.dbo.tmp_tblActualPrices  AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tblVolumenPromedio tadd (NOLOCK)  
   ON ap.txtId1 = tadd.txtId1   
    AND txtSource = 'BLOGM'   
    AND intWindow = 60  
    AND tadd.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY tadd.txtId1  
  
 -- Carga información de Keys Volumen 180 BMV  
 INSERT @tbl_tmpKEYsVolumen  
 SELECT tadd.txtId1,MAX(tadd.dteDate)  
 FROM MxFixIncome.dbo.tmp_tblActualPrices  AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tblVolumenPromedio tadd (NOLOCK)  
   ON ap.txtId1 = tadd.txtId1   
    AND txtSource = 'BMV'   
    AND intWindow = 180  
    AND tadd.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY tadd.txtId1  
  
 -- Carga información de Keys Volumen 5 Bloomberg  
 INSERT @tbl_tmpKEYsVolumen_5D  
 SELECT tadd.txtId1,MAX(tadd.dteDate)  
 FROM MxFixIncome.dbo.tmp_tblActualPrices  AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tblVolumenPromedio tadd (NOLOCK)  
   ON ap.txtId1 = tadd.txtId1   
    AND txtSource = 'BLOGM'   
    AND intWindow = 5  
    AND tadd.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY tadd.txtId1  
  
  
 -- Acciones:  
 INSERT @tmp_tblResults  
 SELECT   
   CONVERT(CHAR(8),@txtDate,112) +  
   RTRIM(ap.txtTv) + REPLICATE(' ',4 - LEN(ap.txtTv)) +   
   RTRIM(ap.txtEmisora) + REPLICATE(' ',7 - LEN(ap.txtEmisora)) +   
   RTRIM(ap.txtSerie) + REPLICATE(' ',6 - LEN(ap.txtSerie)) +  
   CASE UPPER(ap.txtLiquidation)  
    WHEN 'MP' THEN  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
    ELSE  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
      SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
   END +   
   CASE   
       WHEN (a1.txtCUR <> 'NA' AND a1.txtCUR <> '-' AND a1.txtCUR <> '') THEN  
      CASE   
     WHEN RTRIM(a1.txtCUR)='[MPS] Peso Mexicano (MXN)' THEN 'MXN'  
     WHEN RTRIM(a1.txtCUR)='[USD] Dolar Americano (MXN)' THEN 'USD'  
     WHEN RTRIM(a1.txtCUR)='[UDI] Unidades de Inversion (MXN)' THEN 'UDI'  
     WHEN RTRIM(a1.txtCUR)='[EUR] Euro (MXN)' THEN 'EUR'   
     WHEN RTRIM(a1.txtCUR)='[JPY] Yen Japones (MXN)' THEN 'JPY'  
     WHEN RTRIM(a1.txtCUR)='[ITL] Lira Italiana (MXN)' THEN 'ITL'  
     WHEN RTRIM(a1.txtCUR)='[CHF] Franco Suizo (MXN)' THEN 'CHF'  
     WHEN RTRIM(a1.txtCUR)='[DEM] Marco Aleman (MXN)' THEN 'DEM'  
     WHEN RTRIM(a1.txtCUR)='[AUD] Dolar Australiano (MXN)' THEN 'AUD'  
     WHEN RTRIM(a1.txtCUR)='[BRL] Real Brasileno (MXN)' THEN 'BRL'  
     WHEN RTRIM(a1.txtCUR)='[GBP] Libra Inglesa (MXN)' THEN 'GBP'  
     WHEN RTRIM(a1.txtCUR)='[ARS] Peso Argentino (MXN)' THEN 'ARS'  
     WHEN RTRIM(a1.txtCUR)='[CAD] Dolar Canadiense (MXN)' THEN 'CAD'  
     WHEN RTRIM(a1.txtCUR)='[CLP] Peso Chileno (MXN)' THEN 'CLP'  
     WHEN RTRIM(a1.txtCUR)='[HKD] Hong Kong Dolar (MXN)' THEN 'HKD'  
     WHEN RTRIM(a1.txtCUR)='[MYR] Ringgit Kuala Lumpur (MXN)' THEN 'MYR'  
     WHEN RTRIM(a1.txtCUR)='[PEN] Sol Peruano (MXN)' THEN 'PEN'  
     WHEN RTRIM(a1.txtCUR)='[SMG] Salario Minimo General' THEN 'SMG'  
     WHEN RTRIM(a1.txtCUR)='(USD) Dolar Americano (MXN)' THEN 'USD'  
     WHEN RTRIM(a1.txtCUR)='(UDI) Unidades de Inversion (MXN)' THEN 'UDI'  
     WHEN RTRIM(a1.txtCUR)='(EUR) Euro (MXN)' THEN 'EUR'   
     WHEN RTRIM(a1.txtCUR)='(JPY) Yen Japones (MXN)' THEN 'JPY'  
     WHEN RTRIM(a1.txtCUR)='(ITL) Lira Italiana (MXN)' THEN 'ITL'  
     WHEN RTRIM(a1.txtCUR)='(CHF) Franco Suizo (MXN)' THEN 'CHF'  
     WHEN RTRIM(a1.txtCUR)='(DEM) Marco Aleman (MXN)' THEN 'DEM'  
     WHEN RTRIM(a1.txtCUR)='(AUD) Dolar Australiano (MXN)' THEN 'AUD'  
     WHEN RTRIM(a1.txtCUR)='(BRL) Real Brasileno (MXN)' THEN 'BRL'  
     WHEN RTRIM(a1.txtCUR)='(GBP) Libra Inglesa (MXN)' THEN 'GBP'  
     WHEN RTRIM(a1.txtCUR)='(ARS) Peso Argentino (MXN)' THEN 'ARS'  
     WHEN RTRIM(a1.txtCUR)='(CAD) Dolar Canadiense (MXN)' THEN 'CAD'  
     WHEN RTRIM(a1.txtCUR)='(CLP) Peso Chileno (MXN)' THEN 'CLP'  
     WHEN RTRIM(a1.txtCUR)='(HKD) Hong Kong Dolar (MXN)' THEN 'HKD'  
     WHEN RTRIM(a1.txtCUR)='(MYR) Ringgit Kuala Lumpur (MXN)' THEN 'MYR'  
     WHEN RTRIM(a1.txtCUR)='(PEN) Sol Peruano (MXN)' THEN 'PEN'  
     WHEN RTRIM(a1.txtCUR)='(SMG) Salario Minimo General' THEN 'SMG'  
     ELSE '000'  
    END   
      ELSE '000'  
   END  +  
   CASE   
    WHEN ap.txtTv IN ('0','00','1','1B','3','41','51','52','53','54') THEN 'MX'  
    ELSE  
     CASE WHEN (i.txtValue IS NULL) THEN '00'  
     ELSE   
      CONVERT(CHAR(2),i.txtValue)  
     END  
   END +   
   REPLICATE('0',7) +  -- Indice de Referencia  
   '0000000000' +  -- Porcentaje  
   CASE  
    WHEN (a1.txtID2 IS NULL OR RTRIM(a1.txtID2) = 'NA' OR LEN(a1.txtID2) <> 12) THEN REPLICATE('0', 12)  
    ELSE CONVERT(CHAR(12),a1.txtID2)  
            END +  
   CASE  
    WHEN a1.txtId3 IS NULL OR a1.txtId3 IN ('0', '-', ' ') OR LEN(a1.txtId3)<> 9 THEN REPLICATE('0', 9)  
    ELSE SUBSTRING(a1.txtId3, 1, 9)  
   END +  
   CASE  
    WHEN a1.txtId4 IS NULL OR a1.txtId4 IN ('0', '-', ' ') OR LEN(a1.txtId4)<> 7 THEN REPLICATE('0', 7)  
    ELSE SUBSTRING(a1.txtId4, 1, 7)  
   END +  
   CASE   
    WHEN (v.dblValue IS NULL) THEN REPLICATE('0',12)   -- Volumen operado del instrumento  
    ELSE SUBSTRING(REPLACE(STR(ROUND(v.dblValue,0),12,0),  ' ', '0'), 1, 12)  
   END +  
   CASE -- Ticker Blommberg  
    WHEN (id7.txtValue IS NULL) THEN REPLICATE('0', 14)  
    ELSE CONVERT(CHAR(14),id7.txtValue)  
   END +  
   CASE -- Volumen Promedio 5D  
    WHEN (v5D.dblValue IS NULL) THEN REPLICATE('0',12)     
    ELSE SUBSTRING(REPLACE(STR(ROUND(v5D.dblValue,0),12,0),  ' ', '0'), 1, 12)  
   END AS Row     
 FROM MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
   ON a1.txtId1 = ap.txtId1  
    AND a1.txtLiquidation = (  
     CASE ap.txtLiquidation    
     WHEN 'MP' THEN 'MD'    
     ELSE ap.txtLiquidation    
     END  
   )  
  LEFT OUTER JOIN @tbl_tmpIdsKEYsAddId7  AS tk7  
   ON ap.txtId1 = tk7.txtId1  
  LEFT OUTER JOIN MxFixIncome.dbo.tblIdsAdd AS id7 (NOLOCK)   
   ON id7.txtId1 = tk7.txtId1   
    AND id7.dteDate = tk7.dteDate  
    AND id7.txtItem = 'ID7'  
  LEFT OUTER JOIN @tmp_tblKEYsCountries AS tkc  
   ON ap.txtId1 = tkc.txtId1  
  LEFT OUTER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1   
    AND i.dteDate = tkc.dteDate  
    AND i.txtItem = 'COUNTRY'  
  LEFT OUTER JOIN @tbl_tmpKEYsVolumen AS tkv  
   ON ap.txtId1 = tkv.txtId1  
  LEFT OUTER JOIN @tbl_tmpKEYsVolumen_5D AS tkv5d  
   ON ap.txtId1 = tkv5d.txtId1  
  LEFT OUTER JOIN MxFixIncome.dbo.tblVolumenPromedio AS v (NOLOCK)   
   ON v.txtId1 = tkv.txtId1   
    AND v.dteDate = tkv.dteDate   
    AND v.txtSource IN ('BLOGM','BMV')  
    AND v.intWindow IN (60,180)  
  LEFT OUTER JOIN MxFixIncome.dbo.tblVolumenPromedio AS v5D (NOLOCK)   
   ON v5D.txtId1 = tkv5D.txtId1   
    AND v5D.dteDate = tkv5D.dteDate   
    AND v5D.txtSource IN ('BLOGM')  
    AND v5D.intWindow IN (5)  
 WHERE ap.txtLiquidation IN ('MD','MP')   
  AND ap.txtTv IN ('1','41','56','1A','1E','1I','YY',  
       '0','00','1AFX','1ASP','1B','1ESP','1ISP','3','51','52','53','54','55')  
  
 SELECT Row FROM @tmp_tblResults  
 ORDER BY Row  
  
 SET NOCOUNT OFF  
  
END  
RETURN 0  
  
-- para obtener producto: ING05_VDAAAAMMDD_2.PIP  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];55  
  @txtDate AS DATETIME  
  
 /*   
  
   Version 1.0    
     
  Creador: Lic. René López Salinas  
  Fecha: 20-Feb-2009  
  Funcionalidad: Modulo para generar el producto: ING05_VDAAAAMMDD_2.PIP  
  
 */  
  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @txtProcDate AS DATETIME  
 DECLARE @txtLiquidation AS VARCHAR(10)  
 DECLARE @txtFlag AS VARCHAR(1)  
 DECLARE @txtOwner AS CHAR(5)  
  
 SET @txtProcDate = (SELECT MxFixIncome.dbo.fun_NextTradingDate(CONVERT(CHAR(8),@txtDate,112),1,'MX'))  
 SET @txtLiquidation = '24H'  
 SET @txtFlag = '1'  
 SET @txtOwner = 'ING05'  
 ------------------------------------------------------------------------------------------------  
 -- genero buffers temporales  
 DECLARE @tbl_tmpData TABLE (  
  [txtId1] [char] (11) NOT NULL ,  
  [txtTv] [char] (10) NOT NULL ,  
  [txtIssuer] [char] (10) NOT NULL ,  
  [txtSeries] [char] (10) NOT NULL ,  
  [txtSerial] [char] (10) NOT NULL ,  
   PRIMARY KEY CLUSTERED   
    ([txtId1]),  
  [intDTM] [int] NOT NULL ,  
  [dblPav] [float] NOT NULL ,  
  [dblF0] [float] NOT NULL,  
  [dblMarketPrice] [float] NOT NULL,  
  [dblDelta] [float] NOT NULL,  
  [dblVolumen] [float],  
  [txtISIN] [char] (12),  
  [txtSedol] [char] (7),  
  [txtCusip] [char] (9),  
  [txtTicker] [char] (30)  
 )  
  
 -- genero buffers temporales  
 DECLARE @tbl_tmpActualMarketPrices TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] ),  
  [dblMarketPrice] [float] NOT NULL  
 )  
  
 DECLARE @tbl_tmpKEYsOutStanding TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] ),  
  [dteDate] [DATETIME] NOT NULL  
 )  
  
 DECLARE @tbl_tmpIdsKEYsAddId2 TABLE (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY(txtId1)  
 )  
  
 DECLARE @tbl_tmpIdsKEYsAddId3 TABLE (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY(txtId1)  
 )  
  
 DECLARE @tbl_tmpIdsKEYsAddId4 TABLE (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY(txtId1)  
 )  
  
 DECLARE @tbl_tmpIdsKEYsAddId7 TABLE (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY(txtId1)  
 )  
  
 DECLARE @tbl_tmpIdsVsOwners TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] )  
 )  
   
 ------------------------------------------------------------------------------------------------  
  
 -- Obtiene los instrumentos que pertenecen al cliente actual  
 INSERT @tbl_tmpIdsVsOwners  
 SELECT txtId1  
 FROM MxDerivatives.dbo.tblDerivativesOwners (NOLOCK)  
 WHERE  
  txtOwnerId = @txtOwner  
  AND dteBeg <= @txtDate  
  AND dteEnd >= @txtDate  
  
  -- obtengo los hechos de mercado   
 -- Opciones OA  
 INSERT @tbl_tmpActualMarketPrices  
 SELECT     
  i.txtId1,   
  (CASE WHEN d1.txtCurrency IN ('', 'MPS') OR d1.txtCurrency IS NULL   
     THEN 1*d.dblPrice  
       WHEN d1.txtCurrency IN ('UDI', 'MUD')   
     THEN (SELECT ROUND(dblValue,6)*d.dblPrice FROM MxFixIncome.dbo.tblIrc (NOLOCK)  
       WHERE dteDate = @txtDate AND txtIrc = 'UDI')  
      WHEN d1.txtCurrency IN ('USD', 'DLL', 'UFXU')   
     THEN (SELECT ROUND(dblValue,6)*d.dblPrice FROM MxFixIncome.dbo.tblIrc (NOLOCK)  
       WHERE dteDate = @txtDate AND txtIrc = 'UFXU')   
     ELSE   
     (SELECT ROUND(dblValue,6)*d.dblPrice FROM MxFixIncome.dbo.tblIrc (NOLOCK)  
      WHERE dteDate = @txtDate AND txtIrc = RTRIM(d1.txtCurrency)  
     )  
  END)  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
   ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
   ON i.txtId1 = d.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS d1 (NOLOCK)  
   ON i.txtId1 = d1.txtId1  
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
  AND i.txtTv IN ('OA', 'OC' ,'FWD', 'SWP')  
  
  
 -- Consolido Información  
 INSERT INTO @tbl_tmpData (  
  txtId1,  
  txtTv,  
  txtIssuer,  
  txtSeries,  
  txtSerial,  
  intDTM,  
  dblPav,  
  dblF0,  
  dblDelta,  
  dblMarketPrice  
 )  
 SELECT     
  i.txtId1,   
  i.txtTv,  
  i.txtIssuer,  
  i.txtSeries,  
  i.txtSerial,  
  CASE   
  WHEN DATEDIFF(d, @txtProcDate, d.dteMaturity) < 0 THEN 0  
  ELSE DATEDIFF(d, @txtProcDate, d.dteMaturity)  
  END AS intDTM,  
  MAX(CASE p.txtItem WHEN 'PAV' THEN p.dblValue ELSE -999999999 END) AS dblPav,  
  MAX(CASE p.txtItem WHEN 'F0' THEN p.dblValue ELSE -999999999 END) AS dblF0,  
  MAX(CASE p.txtItem WHEN 'DELTA' THEN p.dblValue ELSE -999999999 END) AS dblDelta,  
  CASE   
   WHEN mp.dblMarketPrice IS NULL THEN 0  
   ELSE mp.dblMarketPrice  
  END AS dblMarketPrice  
 FROM   
  MxDerivatives.dbo.tblPrices AS p (NOLOCK)  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
  ON p.txtId1 = d.txtId1  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON p.txtId1 = i.txtId1  
  LEFT OUTER JOIN @tbl_tmpActualMarketPrices AS mp  
  ON p.txtId1 = mp.txtId1  
  WHERE  
  p.dteDate = @txtDate  
  AND p.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND d.txtId1 IN (  
      SELECT txtId1  
      FROM @tbl_tmpIdsVsOwners  
  )  
 GROUP BY   
  i.txtId1,  
  i.txtTv,  
  i.txtIssuer,  
  i.txtSeries,  
  i.txtSerial,  
  d.dteMaturity,  
  mp.dblMarketPrice  
  
 -- Info: Delta  
 UPDATE @tbl_tmpData SET dblDelta = 0 WHERE dblDelta < -1 OR dblDelta > 1  
  
 -- Info: Volumen  
 UPDATE @tbl_tmpData SET dblVolumen = 0  
  
 INSERT @tbl_tmpKEYsOutStanding  
 SELECT tadd.txtId1,MAX(tadd.dteDate)  
 FROM @tbl_tmpData AS ap  
  INNER JOIN MxDerivatives.dbo.tblOutstanding tadd (NOLOCK)  
   ON ap.txtId1 = tadd.txtId1 AND txtSource = 'BLOOMBERG' AND tadd.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY tadd.txtId1  
  
 UPDATE ap  
 SET ap.dblVolumen = i.dblOutstanding  
 FROM @tbl_tmpData AS ap  
  INNER JOIN @tbl_tmpKEYsOutStanding AS tkc  
   ON ap.txtId1 = tkc.txtId1  
  INNER JOIN MxDerivatives.dbo.tblOutstanding AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1 AND i.dteDate = tkc.dteDate AND i.txtSource = 'BLOOMBERG'  
  
 -- Info: Isin  
 UPDATE @tbl_tmpData SET txtISIN = '000000000000'  
  
 INSERT @tbl_tmpIdsKEYsAddId2  
 SELECT e.txtId1,MAX(ia.dteDate)  
 FROM @tbl_tmpData AS e  
  INNER JOIN MxDerivatives.dbo.tblIdsAdd AS ia (NOLOCK)  
   ON e.txtId1 = ia.txtId1 AND ia.txtItem = 'ID2' AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  e.txtId1  
  
 UPDATE ap  
 SET ap.txtISIN = CONVERT(CHAR(12),i.txtValue)  
 FROM @tbl_tmpData AS ap  
  INNER JOIN @tbl_tmpIdsKEYsAddId2 AS tkc  
   ON ap.txtId1 = tkc.txtId1  
  INNER JOIN MxDerivatives.dbo.tblIdsAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1 AND i.dteDate = tkc.dteDate AND i.txtItem = 'ID2'  
  
 -- Info: Cusip  
 UPDATE @tbl_tmpData SET txtCusip = '000000000'  
  
 INSERT @tbl_tmpIdsKEYsAddId3  
 SELECT e.txtId1,MAX(ia.dteDate)  
 FROM @tbl_tmpData AS e  
  INNER JOIN MxDerivatives.dbo.tblIdsAdd AS ia (NOLOCK)  
   ON e.txtId1 = ia.txtId1 AND ia.txtItem = 'ID3' AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  e.txtId1  
  
 UPDATE ap  
 SET ap.txtCusip = CONVERT(CHAR(9),i.txtValue)  
 FROM @tbl_tmpData AS ap  
  INNER JOIN @tbl_tmpIdsKEYsAddId3 AS tkc  
   ON ap.txtId1 = tkc.txtId1  
  INNER JOIN MxDerivatives.dbo.tblIdsAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1 AND i.dteDate = tkc.dteDate AND i.txtItem = 'ID3'  
  
 -- Info: Sedol  
 UPDATE @tbl_tmpData SET txtSedol = '0000000'  
  
 INSERT @tbl_tmpIdsKEYsAddId4  
 SELECT e.txtId1,MAX(ia.dteDate)  
 FROM @tbl_tmpData AS e  
  INNER JOIN MxDerivatives.dbo.tblIdsAdd AS ia (NOLOCK)  
   ON e.txtId1 = ia.txtId1 AND ia.txtItem = 'ID4' AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  e.txtId1  
  
 UPDATE ap  
 SET ap.txtSedol = CONVERT(CHAR(7),i.txtValue)  
 FROM @tbl_tmpData AS ap  
  INNER JOIN @tbl_tmpIdsKEYsAddId4 AS tkc  
   ON ap.txtId1 = tkc.txtId1  
  INNER JOIN MxDerivatives.dbo.tblIdsAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1 AND i.dteDate = tkc.dteDate AND i.txtItem = 'ID4'  
  
 -- Info: Ticker Bloomberg  
 UPDATE @tbl_tmpData SET txtTicker = '000000000000000000000000000000'  
  
 INSERT @tbl_tmpIdsKEYsAddId7  
 SELECT e.txtId1,MAX(ia.dteDate)  
 FROM @tbl_tmpData AS e  
  INNER JOIN MxDerivatives.dbo.tblDerivativesAdd AS ia (NOLOCK)  
   ON e.txtId1 = ia.txtId1 AND ia.txtItem = 'ID9' AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  e.txtId1  
  
 UPDATE ap  
 SET ap.txtTicker = CONVERT(CHAR(30),i.txtValue)  
 FROM @tbl_tmpData AS ap  
  INNER JOIN @tbl_tmpIdsKEYsAddId7 AS tkc  
   ON ap.txtId1 = tkc.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1 AND i.dteDate = tkc.dteDate AND i.txtItem = 'ID9'  
  
 -- creo el vector  
 SELECT   
  'H ' +  
  'DR' +  
  CONVERT(CHAR(8),@txtDate,112) +  
  RTRIM(tmp.txtTv) + REPLICATE(' ',4 - LEN(tmp.txtTv)) +  
  RTRIM(tmp.txtIssuer) + REPLICATE(' ',7 - LEN(tmp.txtIssuer)) +  
  RTRIM(tmp.txtSeries) + REPLICATE(' ',6 - LEN(tmp.txtSeries)) +  
  
  CASE WHEN dblPAV < 0 THEN   
   
          '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblPAV,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
         SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 11, 6)   
  
  ELSE   
  SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  
  CASE WHEN dblPAV < 0 THEN   
  
          '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblPAV,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
         SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 11, 6)   
  
  ELSE   
  SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  '000000000000' +  
  '025009' +  
  @txtFlag +  
  SUBSTRING(REPLACE(STR(ROUND(intDTM,0),6,0),  ' ', '0'), 1, 6) +  
  '00000000' +   
  txtIsin +   
  RTRIM(tmp.txtSerial) + REPLICATE(' ',8 - LEN(tmp.txtSerial)) +   
  CASE WHEN dblMarketPrice < 0 THEN   
          '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
         SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  CASE WHEN dblDelta < 0 THEN   
          '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblDelta,6),16,6),  '-', '0'),' ','0'), 2, 1) +   
         SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6),  ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6),  ' ', '0'), 1, 2) +  
    SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  SUBSTRING(REPLACE(STR(ROUND(dblVolumen,0),9,0),  ' ', '0'), 1, 9) +  
  txtSedol +   
  txtCusip +   
  txtTicker  
 FROM @tbl_tmpData AS tmp  
 ORDER BY  
  tmp.txtTv,  
  tmp.txtIssuer,  
  tmp.txtSeries,  
  tmp.txtSerial  
  
 SET NOCOUNT OFF  
  
END  
RETURN 0  
  
  
-- para obtener producto: INGBANK_Emisiones_aaaammdd.xls y INGBANK_Emisiones_aaaammdd.txt  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];56  
  @dteDate AS DATETIME  
  
 /*   
  
     Version 1.0    
  
     Creador: Lic. René López Salinas  
  Fecha: 09-Mar-2009  
  Funcionalidad: Modulo para generar los productos: INGBANK_Emisiones_aaaammdd.xls y INGBANK_Emisiones_aaaammdd.txt  
  
 */  
  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
  SELECT   
   'Fecha' AS [Fecha],  
   ' Tipo Valor' AS [Tv],  
   'Emisora' AS [Emisora],  
   'Serie' AS [Serie],  
   'ISIN' AS [ISIN],  
   'Nombre Completo' AS [Nombre Completo],  
   'Primera calificacion Fitch' AS [txtFTFR],  
   'Calificacion Actual Fitch' AS [txtFIQ],  
   'Fecha Calificacion Fitch' AS [txtDT_FIQ],  
   'Plazo Calificacion Fitch' AS [txtTM_FIQ],  
   'Escala Calificacion Fitch' AS [txtSCL_FIQ],  
   'Primera calificacion Moodys' AS [txtMOFR],  
   'Calificacion Actual Moddys' AS [txtDPQ],  
   'Fecha Calificacion Moodys' AS [txtDT_DPQ],  
   'Plazo Calificacion Moodys' AS [txtTM_DPQ],  
   'Escala Calificacion Moodys' AS [txtSCL_DPQ],  
   'Primera calificacion S&P' AS [txtSPFR],  
   'Calificacion Actual S&P' AS [txtSPQ],  
   'Fecha Calificacion S&P' AS [txtDT_SPQ],  
   'Plazo Calificacion S&P' AS [txtTM_SPQ],  
   'Escala Calificacion S&P' AS [txtSCL_SPQ],  
   'Fecha Emision' AS [txtISD],  
   'Fecha vto' AS [txtMTD],  
   'Plazo Emision' AS [txtTTM],  
   'Cupones emision' AS [txtTCR],  
   'Condicion de Spread (+/-)' AS [txtOSP2],  
   'Sobretasa de Emision' AS [txtOSP3],  
   'Criterio para determinar la tasa de cupon' AS [txtREF_RULE],  
   'Criterio de Tasa Alterna 1' AS [txtYLD_TERM],  
   'Numero de Tasas de Referencia Alternas' AS [txtREF_IRC_NO],  
   'Tasa Alterna 1' AS [txtREF_IRC_2],  
   'Tasa Alterna 2' AS [txtREF_IRC_3],  
   'Tasa Alterna 3' AS [txtREF_IRC_4],  
   'Tipo de Tasa' AS [txtFVR2],  
   'Tipo de Tasa de Referencia de descuento' AS [txtDCR],  
   'Dias del corte' AS [txtDO],  
   'Tasa Cupon' AS [dblCPA],  
   'Rend Colocacion' AS [txtCYT],  
   'Dias (forma de pago)' AS [txtBAD],  
   'Dias base para Determinacion de Intereses' AS [txtYEAR],  
   'Plazo Cupon Vigente' AS [txtTCT],  
   'Flag Amortizable' AS [txtFSK],  
   'Tipo de Amortizacion' AS [txtSKT],  
   'Porcentaje de Amortizacion del VN' AS [txtPET],  
   'Total de Amortizaciones de Titulos y/o Principal' AS [txtTAT],  
   'Fecha de la siguiente Amortizacion' AS [txtNAT],  
   'Numero de Decimales Prospecto' AS [txtDEA],  
   'Moneda Emision' AS [txtCUR],  
   'Monto Emitido' AS [txtMOE],  
   'Monto Circulacion' AS [txtMOC],  
   'Titulos en Circulacion' AS [txtTIT],  
   'Titulos Emitidos' AS [txtTIE],  
   'Fecha de ultimo cambio en titulos en circulacion' AS [txtLOD],  
   'Valor Nominal' AS [txtNOM],  
   'Valor nominal actualizado' AS [txtCPFA],  
   'Fecha Inicio primer cupon' AS [txtFICD],  
   'Fecha final primer cupon' AS [txtFMCD],  
   'Fecha Siguiente Corte de Cupon' AS [txtNCR],  
   'Fecha de Ultimo Corte de Cupon' AS [txtLCR],  
   'Frec Cupon' AS [txtCPF],  
   'Frecuencia Pago Cupon Moda' AS [txtCPFA],  
   'Frecuencia de Revision de Tasas' AS [txtRPF],  
   'Numero de Tasas por Cupon' AS [txtRPP],  
   'Tasas Subperiodo Cupon' AS [txtLRV],  
   'Numero de Subperíodo Cupon' AS [txtRRI],  
   'Plazo de los Subperiodos que del Cupon Actual' AS [txtTRT],  
   'Fecha Inicio Subperíodo Cupon' AS [txtSUB],  
   'Fecha Corte Subperíodo Cupon' AS [txtSUE],  
   'Precio de colocacion de prospecto' AS [txtPRID],  
   'Precio Limpio Relativo (expresado en porcentaje)' AS [txtPRLR],  
   'Regla inhabil' AS [txtHLD],  
   'Sobretasa Impositiva' AS [txtNTR],  
   'Proteccion contra la Inflacion' AS [txtFPIL],  
   'Tipo de Mercado' AS [txtSMKT],  
   'Sector' AS [txtSEC],  
   'Instrumento Callable' AS [txtFCALL],  
   'Call en Cualquier Momento' AS [txtFCALL_ANY],  
   'Primera Fecha de Call' AS [txtCALL_FDT],  
   'Instrumento Putable' AS [txtFPUT],  
   'Dias para notificar Put' AS [txtPUT_ND],  
   'Notificacion de Evento' AS [txtNOT],  
   'Fecha de Cambio de Tasa de Fija a Flotante' AS [txtCVDT]  
  UNION  
  SELECT   
   CONVERT(CHAR(8),@dteDate,112) AS [Fecha],  
   ap.txtTv AS [Tv],  
   ap.txtEmisora AS [Emisora],  
   ap.txtSerie AS [Serie],  
   CASE WHEN (a1.txtID2  IS NULL OR RTRIM(a1.txtID2) = 'NA'  OR LEN(a1.txtID2) <> 12)  THEN '0' ELSE RTRIM(CONVERT(CHAR(12),a1.txtID2)) END AS [ISIN],  
   CASE WHEN (a1.txtNem  IS NULL OR RTRIM(a1.txtNem) = 'NA'  OR a1.txtNem = '-')  THEN ' '  ELSE LTRIM(RTRIM(REPLACE(a1.txtNem,CHAR(9),' ')))  END AS [Nombre Completo],  
   CASE WHEN (a2.txtFTFR IS NULL OR RTRIM(a2.txtFTFR) = 'NA' OR a2.txtFTFR = '-') THEN ' '  ELSE RTRIM(a2.txtFTFR) END AS [txtFTFR],  
   CASE WHEN (a1.txtFIQ  IS NULL OR RTRIM(a1.txtFIQ) = 'NA' OR a1.txtFIQ = '-') THEN ' '  ELSE RTRIM(a1.txtFIQ) END AS [txtFIQ],  
   CASE WHEN (a1.txtDT_FIQ IS NULL OR RTRIM(a1.txtDT_FIQ) = 'NA' OR a1.txtDT_FIQ = '-') THEN ' '  ELSE RTRIM(a1.txtDT_FIQ) END AS [txtDT_FIQ],  
   CASE WHEN (a2.txtTM_FIQ IS NULL OR RTRIM(a2.txtTM_FIQ) = 'NA' OR a2.txtTM_FIQ = '-') THEN ' '  ELSE RTRIM(a2.txtTM_FIQ) END AS [txtTM_FIQ],  
   CASE WHEN (a2.txtSCL_FIQ IS NULL OR RTRIM(a2.txtSCL_FIQ) = 'NA' OR a2.txtSCL_FIQ = '-') THEN ' '  ELSE RTRIM(a2.txtSCL_FIQ) END AS [txtSCL_FIQ],  
   CASE WHEN (a2.txtMOFR IS NULL OR RTRIM(a2.txtMOFR) = 'NA' OR a2.txtMOFR = '-') THEN ' '  ELSE RTRIM(a2.txtMOFR) END AS [txtMOFR],  
   CASE WHEN (a1.txtDPQ IS NULL OR RTRIM(a1.txtDPQ) = 'NA' OR a1.txtDPQ = '-') THEN ' '  ELSE RTRIM(a1.txtDPQ) END AS [txtDPQ],  
   CASE WHEN (a1.txtDT_DPQ IS NULL OR RTRIM(a1.txtDT_DPQ) = 'NA' OR a1.txtDT_DPQ = '-') THEN ' '  ELSE RTRIM(a1.txtDT_DPQ) END AS [txtDT_DPQ],  
   CASE WHEN (a2.txtTM_DPQ IS NULL OR RTRIM(a2.txtTM_DPQ) = 'NA' OR a2.txtTM_DPQ = '-') THEN ' '  ELSE RTRIM(a2.txtTM_DPQ) END AS [txtTM_DPQ],  
   CASE WHEN (a2.txtSCL_DPQ IS NULL OR RTRIM(a2.txtSCL_DPQ) = 'NA' OR a2.txtSCL_DPQ = '-') THEN ' '  ELSE RTRIM(a2.txtSCL_DPQ) END AS [txtSCL_DPQ],  
   CASE WHEN (a2.txtSPFR IS NULL OR RTRIM(a2.txtSPFR) = 'NA' OR a2.txtSPFR = '-') THEN ' '  ELSE RTRIM(a2.txtSPFR) END AS [txtSPFR],  
   CASE WHEN (a1.txtSPQ IS NULL OR RTRIM(a1.txtSPQ) = 'NA' OR a1.txtSPQ = '-') THEN ' '  ELSE RTRIM(a1.txtSPQ) END AS [txtSPQ],  
   CASE WHEN (a1.txtDT_SPQ IS NULL OR RTRIM(a1.txtDT_SPQ) = 'NA' OR a1.txtDT_SPQ = '-') THEN ' '  ELSE RTRIM(a1.txtDT_SPQ) END AS [txtDT_SPQ],  
   CASE WHEN (a2.txtTM_SPQ IS NULL OR RTRIM(a2.txtTM_SPQ) = 'NA' OR a2.txtTM_SPQ = '-') THEN ' '  ELSE RTRIM(a2.txtTM_SPQ) END AS [txtTM_SPQ],  
   CASE WHEN (a2.txtSCL_SPQ IS NULL OR RTRIM(a2.txtSCL_SPQ) = 'NA' OR a2.txtSCL_SPQ = '-') THEN ' '  ELSE RTRIM(a2.txtSCL_SPQ) END AS [txtSCL_SPQ],  
   CASE WHEN (a1.txtISD IS NULL OR RTRIM(a1.txtISD) = 'NA' OR a1.txtISD = '-') THEN ' '  ELSE RTRIM(a1.txtISD) END AS [txtISD],  
   CASE WHEN (a1.txtMTD IS NULL OR RTRIM(a1.txtMTD) = 'NA' OR a1.txtMTD = '-') THEN ' '  ELSE RTRIM(a1.txtMTD) END AS [txtMTD],  
   CASE WHEN (a1.txtTTM IS NULL OR RTRIM(a1.txtTTM) = 'NA' OR a1.txtTTM = '-') THEN ' '  ELSE RTRIM(a1.txtTTM) END AS [txtTTM],  
   CASE WHEN (a1.txtTCR IS NULL OR RTRIM(a1.txtTCR) = 'NA' OR a1.txtTCR = '-') THEN ' '  ELSE RTRIM(a1.txtTCR) END AS [txtTCR],  
   CASE WHEN (a1.txtOSP2 IS NULL OR RTRIM(a1.txtOSP2) = 'NA' OR a1.txtOSP2 = '-') THEN ' '  ELSE RTRIM(a1.txtOSP2) END AS [txtOSP2],  
   CASE WHEN (a1.txtOSP3 IS NULL OR RTRIM(a1.txtOSP3) = 'NA' OR a1.txtOSP3 = '-') THEN ' '  ELSE RTRIM(a1.txtOSP3) END AS [txtOSP3],  
   CASE WHEN (a1.txtREF_RULE IS NULL OR RTRIM(a1.txtREF_RULE) = 'NA' OR a1.txtREF_RULE = '-') THEN ' '  ELSE RTRIM(a1.txtREF_RULE) END AS [txtREF_RULE],  
   CASE WHEN (a1.txtYLD_TERM IS NULL OR RTRIM(a1.txtYLD_TERM) = 'NA' OR a1.txtYLD_TERM = '-') THEN ' '  ELSE RTRIM(a1.txtYLD_TERM) END AS [txtYLD_TERM],  
   CASE WHEN (a1.txtREF_IRC_NO IS NULL OR RTRIM(a1.txtREF_IRC_NO) = 'NA' OR a1.txtREF_IRC_NO = '-') THEN ' '  ELSE RTRIM(a1.txtREF_IRC_NO) END AS [txtREF_IRC_NO],  
   CASE WHEN (a1.txtREF_IRC_2 IS NULL OR RTRIM(a1.txtREF_IRC_2) = 'NA' OR a1.txtREF_IRC_2 = '-') THEN ' '  ELSE RTRIM(a1.txtREF_IRC_2) END AS [txtREF_IRC_2],  
   CASE WHEN (a1.txtREF_IRC_3 IS NULL OR RTRIM(a1.txtREF_IRC_3) = 'NA' OR a1.txtREF_IRC_3 = '-') THEN ' '  ELSE RTRIM(a1.txtREF_IRC_3) END AS [txtREF_IRC_3],  
   CASE WHEN (a1.txtREF_IRC_4 IS NULL OR RTRIM(a1.txtREF_IRC_4) = 'NA' OR a1.txtREF_IRC_4 = '-') THEN ' '  ELSE RTRIM(a1.txtREF_IRC_4) END AS [txtREF_IRC_4],  
   CASE WHEN (a1.txtFVR2 IS NULL OR RTRIM(a1.txtFVR2) = 'NA' OR a1.txtFVR2 = '-') THEN ' '  ELSE RTRIM(a1.txtFVR2) END AS [txtFVR2],  
   CASE WHEN (a1.txtDCR IS NULL OR RTRIM(a1.txtDCR) = 'NA' OR a1.txtDCR = '-') THEN ' '  ELSE RTRIM(a1.txtDCR) END AS [txtDCR],  
   CASE WHEN (a1.txtDO IS NULL OR RTRIM(a1.txtDO) = 'NA' OR a1.txtDO = '-') THEN '-99'  ELSE RTRIM(a1.txtDO) END AS [txtDO],  
   LTRIM(STR(ROUND(ap.dblCPA,6),9,6)) AS [dblCPA],  
   CASE WHEN (a1.txtCYT IS NULL OR RTRIM(a1.txtCYT) = 'NA' OR a1.txtCYT = '-') THEN ' '  ELSE RTRIM(a1.txtCYT) END AS [txtCYT],  
   CASE WHEN (a1.txtBAD IS NULL OR RTRIM(a1.txtBAD) = 'NA' OR a1.txtBAD = '-') THEN ' '  ELSE RTRIM(a1.txtBAD) END AS [txtBAD],  
   CASE WHEN (a1.txtYEAR IS NULL OR RTRIM(a1.txtYEAR) = 'NA' OR a1.txtYEAR = '-') THEN ' '  ELSE RTRIM(a1.txtYEAR) END AS [txtYEAR],  
   CASE WHEN (a1.txtTCT IS NULL OR RTRIM(a1.txtTCT) = 'NA' OR a1.txtTCT = '-') THEN ' '  ELSE RTRIM(a1.txtTCT) END AS [txtTCT],  
   CASE WHEN (a2.txtFSK IS NULL OR RTRIM(a2.txtFSK) = 'NA' OR a2.txtFSK = '-') THEN ' '  ELSE RTRIM(a2.txtFSK) END AS [txtFSK],  
   CASE WHEN (a2.txtSKT IS NULL OR RTRIM(a2.txtSKT) = 'NA' OR a2.txtSKT = '-') THEN ' '  ELSE RTRIM(a2.txtSKT) END AS [txtSKT],  
   CASE WHEN (a1.txtPET IS NULL OR RTRIM(a1.txtPET) = 'NA' OR a1.txtPET = '-') THEN ' '  ELSE RTRIM(a1.txtPET) END AS [txtPET],  
   CASE WHEN (a1.txtTAT IS NULL OR RTRIM(a1.txtTAT) = 'NA' OR a1.txtTAT = '-') THEN ' '  ELSE RTRIM(a1.txtTAT) END AS [txtTAT],  
   CASE WHEN (a1.txtNAT IS NULL OR RTRIM(a1.txtNAT) = 'NA' OR a1.txtNAT = '-') THEN ' '  ELSE RTRIM(a1.txtNAT) END AS [txtNAT],  
   CASE WHEN (a1.txtDEA IS NULL OR RTRIM(a1.txtDEA) = 'NA' OR a1.txtDEA = '-') THEN ' '  ELSE RTRIM(a1.txtDEA) END AS [txtDEA],  
   CASE WHEN (a1.txtCUR IS NULL OR RTRIM(a1.txtCUR) = 'NA' OR a1.txtCUR = '-') THEN ' '  ELSE RTRIM(a1.txtCUR) END AS [txtCUR],  
   CASE WHEN (a1.txtMOE IS NULL OR RTRIM(a1.txtMOE) = 'NA' OR a1.txtMOE = '-') THEN ' '  ELSE RTRIM(a1.txtMOE) END AS [txtMOE],  
   CASE WHEN (a1.txtMOC IS NULL OR RTRIM(a1.txtMOC) = 'NA' OR a1.txtMOC = '-') THEN ' '  ELSE RTRIM(a1.txtMOC) END AS [txtMOC],  
   CASE WHEN (a1.txtTIT IS NULL OR RTRIM(a1.txtTIT) = 'NA' OR a1.txtTIT = '-') THEN ' '  ELSE RTRIM(a1.txtTIT) END AS [txtTIT],  
   CASE WHEN (a1.txtTIE IS NULL OR RTRIM(a1.txtTIE) = 'NA' OR a1.txtTIE = '-') THEN ' '  ELSE RTRIM(a1.txtTIE) END AS [txtTIE],  
   CASE WHEN (a2.txtLOD IS NULL OR RTRIM(a2.txtLOD) = 'NA' OR a2.txtLOD = '-') THEN ' '  ELSE RTRIM(a2.txtLOD) END AS [txtLOD],  
   CASE WHEN (a1.txtNOM IS NULL OR RTRIM(a1.txtNOM) = 'NA' OR a1.txtNOM = '-') THEN ' '  ELSE RTRIM(a1.txtNOM) END AS [txtNOM],  
   CASE WHEN (a1.txtCPFA IS NULL OR RTRIM(a1.txtCPFA) = 'NA' OR a1.txtCPFA = '-') THEN ' '  ELSE RTRIM(a1.txtCPFA) END AS [txtCPFA],  
   CASE WHEN (a2.txtFICD IS NULL OR RTRIM(a2.txtFICD) = 'NA' OR a2.txtFICD = '-') THEN ' '  ELSE RTRIM(a2.txtFICD) END AS [txtFICD],  
   CASE WHEN (a2.txtFMCD IS NULL OR RTRIM(a2.txtFMCD) = 'NA' OR a2.txtFMCD = '-') THEN ' '  ELSE RTRIM(a2.txtFMCD) END AS [txtFMCD],  
   CASE WHEN (a1.txtNCR IS NULL OR RTRIM(a1.txtNCR) = 'NA' OR a1.txtNCR = '-') THEN ' '  ELSE RTRIM(a1.txtNCR) END AS [txtNCR],  
   CASE WHEN (a1.txtLCR IS NULL OR RTRIM(a1.txtLCR) = 'NA' OR a1.txtLCR = '-') THEN ' '  ELSE RTRIM(a1.txtLCR) END AS [txtLCR],  
   CASE WHEN (a1.txtCPF IS NULL OR RTRIM(a1.txtCPF) = 'NA' OR a1.txtCPF = '-') THEN ' '  ELSE RTRIM(a1.txtCPF) END AS [txtCPF],  
   CASE WHEN (a1.txtCPFA IS NULL OR RTRIM(a1.txtCPFA) = 'NA' OR a1.txtCPFA = '-') THEN ' '  ELSE RTRIM(a1.txtCPFA) END AS [txtCPFA],  
   CASE WHEN (a1.txtRPF IS NULL OR RTRIM(a1.txtRPF) = 'NA' OR a1.txtRPF = '-') THEN ' '  ELSE RTRIM(a1.txtRPF) END AS [txtRPF],  
   CASE WHEN (a1.txtRPP IS NULL OR RTRIM(a1.txtRPP) = 'NA' OR a1.txtRPP = '-') THEN ' '  ELSE RTRIM(a1.txtRPP) END AS [txtRPP],  
   CASE WHEN (a1.txtLRV IS NULL OR RTRIM(a1.txtLRV) = 'NA' OR a1.txtLRV = '-') THEN ' '  ELSE RTRIM(a1.txtLRV) END AS [txtLRV],  
   CASE WHEN (a1.txtRRI IS NULL OR RTRIM(a1.txtRRI) = 'NA' OR a1.txtRRI = '-') THEN ' '  ELSE RTRIM(a1.txtRRI) END AS [txtRRI],  
   CASE WHEN (a1.txtTRT IS NULL OR RTRIM(a1.txtTRT) = 'NA' OR a1.txtTRT = '-') THEN ' '  ELSE RTRIM(a1.txtTRT) END AS [txtTRT],  
   CASE WHEN (a1.txtSUB IS NULL OR RTRIM(a1.txtSUB) = 'NA' OR a1.txtSUB = '-') THEN ' '  ELSE RTRIM(a1.txtSUB) END AS [txtSUB],  
   CASE WHEN (a1.txtSUE IS NULL OR RTRIM(a1.txtSUE) = 'NA' OR a1.txtSUE = '-') THEN ' '  ELSE RTRIM(a1.txtSUE) END AS [txtSUE],  
   CASE WHEN (a2.txtPRID IS NULL OR RTRIM(a2.txtPRID) = 'NA' OR a2.txtPRID = '-') THEN ' '  ELSE RTRIM(a2.txtPRID) END AS [txtPRID],  
   CASE WHEN (a1.txtPRLR IS NULL OR RTRIM(a1.txtPRLR) = 'NA' OR a1.txtPRLR = '-') THEN ' '  ELSE RTRIM(a1.txtPRLR) END AS [txtPRLR],  
   CASE WHEN (a1.txtHLD IS NULL OR RTRIM(a1.txtHLD) = 'NA' OR a1.txtHLD = '-') THEN ' '  ELSE RTRIM(a1.txtHLD) END AS [txtHLD],  
   CASE WHEN (a1.txtNTR IS NULL OR RTRIM(a1.txtNTR) = 'NA' OR a1.txtNTR = '-') THEN ' '  ELSE RTRIM(a1.txtNTR) END AS [txtNTR],  
   CASE WHEN (a1.txtFPIL IS NULL OR RTRIM(a1.txtFPIL) = 'NA' OR a1.txtFPIL = '-') THEN ' '  ELSE RTRIM(a1.txtFPIL) END AS [txtFPIL],  
   CASE WHEN (a1.txtSMKT IS NULL OR RTRIM(a1.txtSMKT) = 'NA' OR a1.txtSMKT = '-') THEN ' '  ELSE RTRIM(a1.txtSMKT) END AS [txtSMKT],  
   CASE WHEN (a1.txtSEC IS NULL OR RTRIM(a1.txtSEC) = 'NA' OR a1.txtSEC = '-') THEN ' '  ELSE RTRIM(a1.txtSEC) END AS [txtSEC],  
   CASE WHEN (a2.txtFCALL IS NULL OR RTRIM(a2.txtFCALL) = 'NA' OR a2.txtFCALL = '-') THEN ' '  ELSE RTRIM(a2.txtFCALL) END AS [txtFCALL],  
   CASE WHEN (a2.txtFCALL_ANY IS NULL OR RTRIM(a2.txtFCALL_ANY) = 'NA' OR a2.txtFCALL_ANY = '-') THEN ' '  ELSE RTRIM(a2.txtFCALL_ANY) END AS [txtFCALL_ANY],  
   CASE WHEN (a2.txtCALL_FDT IS NULL OR RTRIM(a2.txtCALL_FDT) = 'NA' OR a2.txtCALL_FDT = '-') THEN ' '  ELSE RTRIM(a2.txtCALL_FDT) END AS [txtCALL_FDT],  
   CASE WHEN (a2.txtFPUT IS NULL OR RTRIM(a2.txtFPUT) = 'NA' OR a2.txtFPUT = '-') THEN ' '  ELSE RTRIM(a2.txtFPUT) END AS [txtFPUT],  
   CASE WHEN (a2.txtPUT_ND IS NULL OR RTRIM(a2.txtPUT_ND) = 'NA' OR a2.txtPUT_ND = '-') THEN ' '  ELSE RTRIM(a2.txtPUT_ND) END AS [txtPUT_ND],  
   CASE WHEN (a2.txtNOT IS NULL OR RTRIM(a2.txtNOT) = 'NA' OR a2.txtNOT = '-') THEN ' '  ELSE RTRIM(a2.txtNOT) END AS [txtNOT],  
   CASE WHEN (a2.txtCVDT IS NULL OR RTRIM(a2.txtCVDT) = 'NA' OR a2.txtCVDT = '-') THEN ' ' ELSE RTRIM(a2.txtCVDT) END AS [txtCVDT]  
  FROM MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
    INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
     ON a1.txtId1 = ap.txtId1  
     AND a1.txtLiquidation = (  
      CASE ap.txtLiquidation    
      WHEN 'MP' THEN 'MD'    
      ELSE ap.txtLiquidation    
      END  
     )  
    INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_2 AS a2 (NOLOCK)  
     ON a2.txtId1 = ap.txtId1  
     AND a2.txtLiquidation = (  
      CASE ap.txtLiquidation    
      WHEN 'MP' THEN 'MD'    
      ELSE ap.txtLiquidation    
      END  
     )  
  WHERE   
   ap.txtLiquidation IN ('MD', 'MP')  
   --AND ap.txtTv IN ('0')  
  ORDER BY   
   Tv,  
   Emisora,  
   Serie  
  
 SET NOCOUNT OFF  
  
END  
RETURN 0  
  
-----------------------------------------------------------------------------------------------  
--   Autor:                     Mike Ramirez  
--   Fecha Modificacion:  12:02 p.m. 2012-08-17  
--   Descripcion:               Modulo 57: Se cambia la tabla de donde se extrae la informacion  
-----------------------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];57  
  
AS  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 DECLARE @RECNO AS INTEGER  
 DECLARE @COLNO AS INTEGER  
 DECLARE @CONSECSUM AS FLOAT  
 DECLARE @CONSECLAST AS INTEGER  
 DECLARE @CONSECTODAY AS INTEGER  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  Detail  VARCHAR(2000)  
 )  
  
 SET @RECNO = (SELECT COUNT(*) FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK) WHERE txtVectorType = 'EEE') + 1  
 SET @COLNO = 38  
 SET @CONSECSUM = (SELECT SUM(intConsecutive) FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK) WHERE txtVectorType = 'EEE')  
 SET @CONSECTODAY = (SELECT TOP 1 intConsecutive   
      FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)   
      WHERE txtVectorType = 'EEE'  
      ORDER BY intConsecutive DESC)  
 SET @CONSECLAST = (SELECT TOP 1 intConsecutive   
      FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)   
      WHERE txtVectorType = 'EEE' AND intConsecutive < @CONSECTODAY  
      ORDER BY intConsecutive DESC)  
  
 INSERT @tmp_tblResults   
 SELECT    
  -1 AS [Consecutivo],  
  LTRIM(STR(@RECNO)) + CHAR(124) +   
  LTRIM(STR(@COLNO)) + CHAR(124) +   
  LTRIM(STR(@CONSECSUM)) + CHAR(124) +   
  LTRIM(STR(@CONSECLAST)) + CHAR(124) +   
  LTRIM(STR(@CONSECTODAY))  AS [VectorEMI]  
  
  
 INSERT @tmp_tblResults   
 SELECT    
  0 AS [Consecutivo],  
  'Consecutivo' + CHAR(124) +   
  'RAZON SOCIAL' + CHAR(124) +   
  'S&P LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC NAC' + CHAR(124) +   
  'S&P CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC NAC' + CHAR(124) +   
  'S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC NAC' + CHAR(124) +   
  'MOODY''S CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC NAC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC NAC' + CHAR(124) +   
  'FITCH CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC NAC' + CHAR(124) +   
  'FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M EXT'  AS [VectorEMI]  
 UNION  
 SELECT  
  intConsecutive AS [Consecutivo],  
  LTRIM(STR(intConsecutive,5,0)) + CHAR(124) +        -- [intConsecutiv]  
  (CASE WHEN RTRIM(txtISN) IS NULL THEN '' ELSE RTRIM(txtISN) END)  + CHAR(124) +   -- [RAZON SOCIAL]  
  (CASE WHEN RTRIM(txtSPQ_LN) IS NULL THEN '' ELSE RTRIM(txtSPQ_LN) END) + CHAR(124) +   -- [S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_LN) IS NULL THEN '' ELSE RTRIM(txtSPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_SN) IS NULL THEN '' ELSE RTRIM(txtSPQ_SN) END) + CHAR(124) +   -- [S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_SN) IS NULL THEN '' ELSE RTRIM(txtSPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGL) END) + CHAR(124) +   -- [S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGL) END) + CHAR(124) +   -- [S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGE) END) + CHAR(124) +   -- [S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGE) END) + CHAR(124) +   -- [S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_LN) IS NULL THEN '' ELSE RTRIM(txtDPQ_LN) END) + CHAR(124) +   -- [MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_LN) IS NULL THEN '' ELSE RTRIM(txtDPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_SN) IS NULL THEN '' ELSE RTRIM(txtDPQ_SN) END) + CHAR(124) +   -- [MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_SN) IS NULL THEN '' ELSE RTRIM(txtDPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGL) END)  + CHAR(124) +  -- [MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGL) END)  + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGL) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGE) END) + CHAR(124) +   -- [MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGE) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_LN) IS NULL THEN '' ELSE RTRIM(txtFIQ_LN) END) + CHAR(124) +   -- [FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_LN) IS NULL THEN '' ELSE RTRIM(txtFIQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_SN) IS NULL THEN '' ELSE RTRIM(txtFIQ_SN) END) + CHAR(124) +   -- [FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_SN) IS NULL THEN '' ELSE RTRIM(txtFIQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGL) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGL) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGE) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGE) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGE) END) AS [VectorEMI] -- [Fecha de ultimo cambio FITCH CP ESC GLOB M EXT]  
 FROM MxFixIncome.dbo.tblVectorEmpresasEmisorasNew (NOLOCK)  
 WHERE txtVectorType = 'EEE'  
 ORDER BY  [Consecutivo]  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];58  
  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 16-Oct-2009  
  Funcionalidad: Modulo para generar producto en calidad de prueba  
   Posteriormente se sustituira este SP por el modulo 43: ING_Vector_Emisoras_Nacionales_[DATE|YYYYMMDD].txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 DECLARE @RECNO AS INTEGER  
 DECLARE @COLNO AS INTEGER  
 DECLARE @CONSECSUM AS FLOAT  
 DECLARE @CONSECLAST AS INTEGER  
 DECLARE @CONSECTODAY AS INTEGER  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  Detail  VARCHAR(2000)  
 )  
  
  
 SET @RECNO = (SELECT COUNT(*) FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK) WHERE txtVectorType = 'EEN') + 1  
 SET @COLNO = 38  
 SET @CONSECSUM = (SELECT SUM(intConsecutive) FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK) WHERE txtVectorType = 'EEN')  
 SET @CONSECTODAY = (SELECT TOP 1 intConsecutive   
      FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)   
      WHERE txtVectorType = 'EEN'  
      ORDER BY intConsecutive DESC)  
 SET @CONSECLAST = (SELECT TOP 1 intConsecutive   
      FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)   
      WHERE txtVectorType = 'EEN' AND intConsecutive < @CONSECTODAY  
      ORDER BY intConsecutive DESC)  
  
 INSERT @tmp_tblResults   
 SELECT    
  -1 AS [Consecutivo],  
  LTRIM(STR(@RECNO)) + CHAR(124) +   
  LTRIM(STR(@COLNO)) + CHAR(124) +   
  LTRIM(STR(@CONSECSUM)) + CHAR(124) +   
  LTRIM(STR(@CONSECLAST)) + CHAR(124) +   
  LTRIM(STR(@CONSECTODAY))  AS [VectorEMI]  
    
 -- Reporta datos  
 INSERT @tmp_tblResults   
 SELECT    
  0 AS [Consecutivo],  
  'Consecutivo' + CHAR(124) +   
  'RAZON SOCIAL' + CHAR(124) +   
  'S&P LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC NAC' + CHAR(124) +   
  'S&P CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC NAC' + CHAR(124) +   
  'S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M LOC' + CHAR(124) +   
  'S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M LOC' + CHAR(124) +   
  'S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P LP ESC GLOB M EXT' + CHAR(124) +   
  'S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio S&P CP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC NAC' + CHAR(124) +   
  'MOODY''S CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC NAC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M LOC' + CHAR(124) +   
  'MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S LP ESC GLOB M EXT' + CHAR(124) +   
  'MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio MOODY''S CP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH LP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC NAC' + CHAR(124) +   
  'FITCH CP ESC NAC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC NAC' + CHAR(124) +   
  'FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M LOC' + CHAR(124) +   
  'FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH LP ESC GLOB M EXT' + CHAR(124) +   
  'FITCH CP ESC GLOB M EXT' + CHAR(124) +   
  'Fecha de ultimo cambio FITCH CP ESC GLOB M EXT'  AS [VectorEMI]  
 UNION  
 SELECT  
  intConsecutive AS [Consecutivo],  
  LTRIM(STR(intConsecutive,5,0)) + CHAR(124) +        -- [intConsecutiv]  
  (CASE WHEN RTRIM(txtISN) IS NULL THEN '' ELSE RTRIM(txtISN) END)  + CHAR(124) +   -- [RAZON SOCIAL]  
  (CASE WHEN RTRIM(txtSPQ_LN) IS NULL THEN '' ELSE RTRIM(txtSPQ_LN) END) + CHAR(124) +   -- [S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_LN) IS NULL THEN '' ELSE RTRIM(txtSPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P LP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_SN) IS NULL THEN '' ELSE RTRIM(txtSPQ_SN) END) + CHAR(124) +   -- [S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQD_SN) IS NULL THEN '' ELSE RTRIM(txtSPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio S&P CP ESC NAC]  
  (CASE WHEN RTRIM(txtSPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGL) END) + CHAR(124) +   -- [S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGL) END) + CHAR(124) +   -- [S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtSPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_LGE) END) + CHAR(124) +   -- [S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQ_SGE) END) + CHAR(124) +   -- [S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtSPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtSPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio S&P CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_LN) IS NULL THEN '' ELSE RTRIM(txtDPQ_LN) END) + CHAR(124) +   -- [MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_LN) IS NULL THEN '' ELSE RTRIM(txtDPQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S LP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_SN) IS NULL THEN '' ELSE RTRIM(txtDPQ_SN) END) + CHAR(124) +   -- [MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQD_SN) IS NULL THEN '' ELSE RTRIM(txtDPQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio MOODY'S CP ESC NAC]  
  (CASE WHEN RTRIM(txtDPQ_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGL) END)  + CHAR(124) +  -- [MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_LGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGL) END)  + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGL) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQD_SGL) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtDPQ_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_LGE) END) + CHAR(124) +   -- [MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_LGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQ_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQ_SGE) END) + CHAR(124) +   -- [MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtDPQD_SGE) IS NULL THEN '' ELSE RTRIM(txtDPQD_SGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio MOODY'S CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_LN) IS NULL THEN '' ELSE RTRIM(txtFIQ_LN) END) + CHAR(124) +   -- [FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_LN) IS NULL THEN '' ELSE RTRIM(txtFIQD_LN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH LP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_SN) IS NULL THEN '' ELSE RTRIM(txtFIQ_SN) END) + CHAR(124) +   -- [FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQD_SN) IS NULL THEN '' ELSE RTRIM(txtFIQD_SN) END) + CHAR(124) +   -- [Fecha de ultimo cambio FITCH CP ESC NAC]  
  (CASE WHEN RTRIM(txtFIQ_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGL) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_LGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGL) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQD_SGL) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGL) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH CP ESC GLOB M LOC]  
  (CASE WHEN RTRIM(txtFIQ_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_LGE) END) + CHAR(124) +   -- [FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_LGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_LGE) END) + CHAR(124) +  -- [Fecha de ultimo cambio FITCH LP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQ_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQ_SGE) END) + CHAR(124) +   -- [FITCH CP ESC GLOB M EXT]  
  (CASE WHEN RTRIM(txtFIQD_SGE) IS NULL THEN '' ELSE RTRIM(txtFIQD_SGE) END) AS [VectorEMI] -- [Fecha de ultimo cambio FITCH CP ESC GLOB M EXT]  
 FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)  
 WHERE txtVectorType = 'EEN'  
 ORDER BY  [Consecutivo]  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];59  
  
AS     
  
 /*  
  
  Creador: Lic. René López Salinas  
  Fecha: 16-Oct-2009  
  Funcionalidad: Modulo para generar producto en calidad de prueba  
   Posteriormente se sustituira este SP por el modulo 44: ING_Vector_Sociedades_[DATE|YYYYMMDD].txt  
  
 */  
  
BEGIN    
  
 SET NOCOUNT ON   
  
 DECLARE @RECNO AS INTEGER  
 DECLARE @COLNO AS INTEGER  
 DECLARE @CONSECSUM AS FLOAT  
 DECLARE @CONSECLAST AS INTEGER  
 DECLARE @CONSECTODAY AS INTEGER  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  Detail  VARCHAR(2000)  
 )  
  
  
 SET @RECNO = (SELECT COUNT(*) FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK) WHERE txtVectorType = 'SI') + 1  
 SET @COLNO = 15  
 SET @CONSECSUM = (SELECT SUM(intConsecutive) FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK) WHERE txtVectorType = 'SI')  
 SET @CONSECTODAY = (SELECT TOP 1 intConsecutive   
      FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)   
      WHERE txtVectorType = 'SI'  
      ORDER BY intConsecutive DESC)  
 SET @CONSECLAST = (SELECT TOP 1 intConsecutive   
      FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras (NOLOCK)   
      WHERE txtVectorType = 'SI' AND intConsecutive < @CONSECTODAY  
      ORDER BY intConsecutive DESC)  
  
 INSERT @tmp_tblResults   
 SELECT    
  -1 AS [Consecutivo],  
  LTRIM(STR(@RECNO)) + CHAR(124) +   
  LTRIM(STR(@COLNO)) + CHAR(124) +   
  LTRIM(STR(@CONSECSUM)) + CHAR(124) +   
  LTRIM(STR(@CONSECLAST)) + CHAR(124) +   
  LTRIM(STR(@CONSECTODAY))  AS [VectorEMI]  
  
  
 INSERT @tmp_tblResults   
 SELECT    
  0 AS [Consecutivo],  
  'Consecutivo' + CHAR(124) +   
  'CLAVE' + CHAR(124) +   
  'RAZON SOCIAL' + CHAR(124) +   
  'S&P Escala Homogénea' + CHAR(124) +   
  'S&P Escala Nacional' + CHAR(124) +   
  'S&P Escala Global' + CHAR(124) +   
  'FECHA DE ULTIMA MODIFICACION S&P' + CHAR(124) +   
  'MOODY''S Escala Homogénea' + CHAR(124) +   
  'MOODY''S Escala Nacional' + CHAR(124) +   
  'MOODY''S Escala Global' + CHAR(124) +   
  'FECHA DE ULTIMA MODIFICACION MOODY''S' + CHAR(124) +   
  'FITCHS Escala Homogénea' + CHAR(124) +   
  'FITCHS Escala Nacional' + CHAR(124) +   
  'FITCHS Escala Global' + CHAR(124) +   
  'FECHA DE ULTIMA MODIFICACION FITCHS' AS [VectorEMI]  
 UNION  
 SELECT  
  intConsecutive AS [Consecutivo],  
  LTRIM(STR(intConsecutive,5,0)) + CHAR(124) +        -- [intConsecutiv]  
  (CASE WHEN LTRIM(RTRIM(i.txtISN_CVE)) IS NULL THEN '' ELSE LTRIM(RTRIM(i.txtISN_CVE)) END)  + CHAR(124) +  -- [CLAVE]  
  (CASE WHEN LTRIM(RTRIM(txtISN)) IS NULL THEN '' ELSE LTRIM(RTRIM(txtISN)) END)  + CHAR(124) +   -- [RAZON SOCIAL]  
  
  (CASE WHEN RTRIM(txtSPQ_EH) IS NULL THEN '' ELSE RTRIM(txtSPQ_EH) END) + CHAR(124) +   -- [S&P Escala Homogénea]  
  (CASE WHEN RTRIM(txtSPQ_EN) IS NULL THEN '' ELSE RTRIM(txtSPQ_EN) END) + CHAR(124) +   -- [S&P Escala Nacional]  
  (CASE WHEN RTRIM(txtSPQ_EG) IS NULL THEN '' ELSE RTRIM(txtSPQ_EG) END) + CHAR(124) +   -- [S&P Escala Global]  
  (CASE WHEN RTRIM(txtSPQD_EH) IS NULL THEN '' ELSE RTRIM(txtSPQD_EH) END) + CHAR(124) +   -- [FECHA DE ULTIMA MODIFICACION S&P]  
  
  (CASE WHEN RTRIM(txtDPQ_EH) IS NULL THEN '' ELSE RTRIM(txtDPQ_EH) END) + CHAR(124) +   -- [MOODY'S Escala Homogénea]  
  (CASE WHEN RTRIM(txtDPQ_EN) IS NULL THEN '' ELSE RTRIM(txtDPQ_EN) END) + CHAR(124) +   -- [MOODY'S Escala Nacional]  
  (CASE WHEN RTRIM(txtDPQ_EG) IS NULL THEN '' ELSE RTRIM(txtDPQ_EG) END) + CHAR(124) +   -- [MOODY'S Escala Global]  
  (CASE WHEN RTRIM(txtDPQD_EH) IS NULL THEN '' ELSE RTRIM(txtDPQD_EH) END) + CHAR(124) +   -- [FECHA DE ULTIMA MODIFICACION MOODY'S]  
  
  (CASE WHEN RTRIM(txtFIQ_EH) IS NULL THEN '' ELSE RTRIM(txtFIQ_EH) END) + CHAR(124) +   -- [FITCHS Escala Homogénea]  
  (CASE WHEN RTRIM(txtFIQ_EN) IS NULL THEN '' ELSE RTRIM(txtFIQ_EN) END) + CHAR(124) +   -- [FITCHS Escala Nacional]  
  (CASE WHEN RTRIM(txtFIQ_EG) IS NULL THEN '' ELSE RTRIM(txtFIQ_EG) END) + CHAR(124) +   -- [FITCHS Escala Global]  
  (CASE WHEN RTRIM(txtFIQD_EH) IS NULL THEN '' ELSE RTRIM(txtFIQD_EH) END)  AS [VectorEMI] -- [FECHA DE ULTIMA MODIFICACION FITCHS]  
  
 FROM MxFixIncome.dbo.tblVectorEmpresasEmisoras AS v (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tblIssuerCompany AS i (NOLOCK)  
   ON i.txtIssuerName = v.txtISN  
 WHERE v.txtVectorType = 'SI'  
 ORDER BY  [Consecutivo]  
  
 SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
-- Autor:    Mike Ramírez  
-- Descripcion:   Procedimiento que genera el producto: ING01_VectorAnaliticoyyyymmdd24H.xls  
-- Fecha Creacion  : 09:49 p.m. 2011-05-05  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];60  
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
  
 INSERT @tblVector  
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
 INSERT @tblVector  
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
   AND p.txtOwnerId = 'ING01'    
   AND p.txtProductid IN ('SNOTES','PEQUITY')  
 ORDER BY txtTV, txtEmisora, txtSerie    
  
 SELECT   
  [dtedate],  
  [txtTv],  
  [txtEmisora],  
  [txtSerie],  
  [dblPRL],  
  [dblPRS],  
  [dblCPD],  
  [dblCuponCPA],  
  [dblLDR],  
  RTRIM(LTRIM([txtNEM])),  
  RTRIM(LTRIM([txtSEC])),  
  RTRIM(LTRIM([txtMOE])),  
  RTRIM(LTRIM([txtMOC])),  
  RTRIM(LTRIM([txtISD])),  
  RTRIM(LTRIM([txtTTM])),  
  RTRIM(LTRIM([txtMTD])),  
  RTRIM(LTRIM([txtNOM])),  
  RTRIM(LTRIM([txtCUR])),  
  RTRIM(LTRIM([txtIRCSUBY])),  
  RTRIM(LTRIM([txtCYT])),  
  RTRIM(LTRIM([txtOSP])),  
  RTRIM(LTRIM([txtCPF])),  
  [dblTasaCPA],  
  RTRIM(LTRIM([txtDTC])),  
  RTRIM(LTRIM([txtCRL])),  
  RTRIM(LTRIM([txtTCR])),  
  RTRIM(LTRIM([txtFCR])),  
  RTRIM(LTRIM([txtLPV])),  
  RTRIM(LTRIM([txtLPD])),  
  RTRIM(LTRIM([txtTHP])),  
  RTRIM(LTRIM([txtLCA])),  
  RTRIM(LTRIM([txtLPU])),  
  RTRIM(LTRIM([txtBYT])),  
  RTRIM(LTRIM([txtOYT])),  
  RTRIM(LTRIM([txtBSP])),  
  RTRIM(LTRIM([txtPSP])),  
  RTRIM(LTRIM([txtDPQ])),  
  RTRIM(LTRIM([txtSPQ])),  
  RTRIM(LTRIM([txtBUR])),  
  RTRIM(LTRIM([txtLIQ])),  
  RTRIM(LTRIM([txtDPC])),  
  RTRIM(LTRIM([txtWPC])),  
  RTRIM(LTRIM([txtMHP])),  
  RTRIM(LTRIM([txtIHP])),  
  RTRIM(LTRIM([txtSUS])),  
  RTRIM(LTRIM([txtVOL])),  
  RTRIM(LTRIM([txtVO2])),  
  RTRIM(LTRIM([txtDMF])),  
  RTRIM(LTRIM([txtDMT])),  
  RTRIM(LTRIM([txtCMT])),  
  RTRIM(LTRIM([txtVAR])),  
  RTRIM(LTRIM([txtSTD])),  
  RTRIM(LTRIM([txtVNA])),  
  RTRIM(LTRIM([txtFIQ])),  
  RTRIM(LTRIM([txtDMH])),  
  RTRIM(LTRIM([txtDIH])),  
  RTRIM(LTRIM([txtSTP])),  
  RTRIM(LTRIM([txtDMC])),  
  [dblYTM],  
  RTRIM(LTRIM([txtHRQ])),  
  RTRIM(LTRIM([txtDEF]))  
 FROM @tblVector  
 ORDER BY txtSortTV, txtSortEmisora, txtSortSerie  
  
 SET NOCOUNT OFF   
  
END  
  
-- Modificacion: Lic. René López Salinas  
-- Descripcion:  Procedimiento que genera el producto: VAI[YYYYMMDD]CL.PIP  
-- Fecha Modificacion : 08:00 p.m. 2012-10-01  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];61  
 @txtDate AS VARCHAR(10)  
  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
  DECLARE @txtOwnerId AS CHAR(5)  
 DECLARE @txtIndex AS CHAR(10)  
 DECLARE @dteMaxdate AS DATETIME  
 DECLARE @dblIndexValue AS FLOAT  
  
 -- creo tabla resultado  
 TRUNCATE TABLE tmp_tblResult_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tbltrackPrices_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblPond_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblEquityPrices_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblEquityPricesPIPTime_ING01_VAI  
 TRUNCATE TABLE tmp_tblEquityIndexesUnits_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblIndexEquityPrices_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_Temporal_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblIdsAddId3_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblIdsAddId4_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblIdsAddCountry_ING01_VAI_PIP  
 TRUNCATE TABLE tmp_tblIdsAdd_ING01_VAI_PIP  
  
 SET @txtOwnerId = 'ING01'  
  
 -- Contadores de ciclo   
 DECLARE @intTotalRow as int   
 DECLARE @intRow as int   
 SET @intRow = 1   
  
 -- Crear estructura de tabla para iterar  
 DECLARE @tmp_Temporal TABLE (   
  intRow int identity(1,1),   
  txtIndex CHAR(10)  
 PRIMARY KEY (intRow)   
 )   
  
 INSERT INTO @tmp_Temporal (txtIndex)  
 SELECT DISTINCT   
  ip.txtIndex  
 FROM   
  tblIndexesPortfolios AS ip (NOLOCK)  
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS o (NOLOCK)  
  ON ip.txtIndex = o.txtDir  
 WHERE  
  o.txtOwnerId = @txtOwnerId  
  AND o.dteBeg <= @txtDate  
  AND o.dteEnd >= @txtDate   
 ORDER BY  
  ip.txtIndex  
  
 SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal)   
  
 WHILE @intRow <= @intTotalRow   
 BEGIN   
  
      -- Obtengo la info de cada registro   
        SELECT   
            @txtIndex = txtIndex  
        FROM @tmp_Temporal  
        WHERE intRow = @intRow   
    
  -- obtengo composicion mas reciente  
  SET @dteMaxdate = (  
   SELECT   
    CASE   
    WHEN MAX(dteDate) IS NULL THEN '19790324'  
    ELSE MAX(dteDate)  
    END AS dteDate  
   FROM tblIndexesPortfolios (NOLOCK)  
   WHERE  
    txtIndex = @txtIndex  
    AND dteDate <= @txtDate  
  )  
  
  IF @dteMaxdate <> '19790324'  
  BEGIN  
  
  
   -- obtengo las fechas mas recientes  
   DELETE FROM tmp_tblEquityPrices_ING01_VAI_PIP  
  
   INSERT INTO tmp_tblEquityPrices_ING01_VAI_PIP (  
    txtId1,  
    dteDate  
   )  
   SELECT   
    e.txtId1,  
    MAX(ep.dteDate) AS dteDate  
   FROM   
    tblEquity AS e (NOLOCK)  
    INNER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON e.txtId1 = ep.txtId1  
    INNER JOIN tblIndexesPortfolios AS ip (NOLOCK)  
    ON e.txtId1 = ip.txtId1  
   WHERE  
    ip.txtIndex = @txtIndex  
    AND ip.dteDate = @dteMaxdate  
    AND ep.txtOperationCode = 'S01'  
    AND ep.dteDate <= @txtDate  
   GROUP BY   
    e.txtId1     
  
   -- obtengo las horas mas recientes  
   DELETE FROM tmp_tblEquityPricesPIPTime_ING01_VAI  
  
   INSERT INTO tmp_tblEquityPricesPIPTime_ING01_VAI (  
    txtId1,  
    dteTime  
   )  
   SELECT   
    e.txtId1,  
    MAX(ep.dteTime) AS dteTime  
   FROM   
    tmp_tblEquityPrices_ING01_VAI_PIP AS e  
    INNER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     e.txtId1 = ep.txtId1  
     AND e.dteDate = ep.dteDate  
     AND ep.txtOperationCode = 'S01'  
   GROUP BY   
    e.txtId1  
  
   -- obtengo la definicion mas reciente  
   -- de unidades por accion por indice  
   DELETE FROM tmp_tblEquityIndexesUnits_ING01_VAI_PIP  
    
   INSERT INTO tmp_tblEquityIndexesUnits_ING01_VAI_PIP (  
    txtId1,  
    dteDate  
   )  
   SELECT   
    txtId1,  
    MAX(dteDate)  
   FROM tblEquityIndexesUnits (NOLOCK)  
   WHERE  
    txtIrc = @txtIndex  
    AND dteDate <= @txtDate  
   GROUP BY   
    txtId1  
  
   -- obtengo los precios de las acciones en pesos  
   INSERT INTO tmp_tblIndexEquityPrices_ING01_VAI_PIP (  
    txtIndex,  
    dteDate,  
    txtId1,  
    dblCount,  
    dblPrice,  
    txtCurrency,  
    dblExchange,  
    dblMXNPrice,  
    dblPond,  
    dblUnits  
   )  
  
   SELECT   
    ip.txtIndex,  
    ip.dteDate,  
    ip.txtId1,  
    ip.dblCount,  
    ep.dblPrice,  
    e.txtCurrency,  
      
    CASE  
    WHEN i.dblValue IS NULL THEN 1  
    ELSE i.dblValue  
    END AS dblExchange,  
  
    CASE  
    WHEN p.dblValue IS NULL THEN -999  
    ELSE p.dblValue  
    END AS dblMXNPrice,  
  
    1E-10 AS dblPond,  
  
    CASE  
    WHEN eiu.dblUnits IS NULL THEN 1  
    ELSE eiu.dblUnits  
    END AS dblUnits  
  
   FROM   
    tblEquity AS e (NOLOCK)  
    INNER JOIN tblIndexesPortfolios AS ip (NOLOCK)  
    ON e.txtId1 = ip.txtId1  
    INNER JOIN tmp_tblEquityPrices_ING01_VAI_PIP AS ed  
    ON e.txtId1 = ed.txtId1  
    INNER JOIN tmp_tblEquityPricesPIPTime_ING01_VAI AS et  
    ON e.txtId1 = et.txtId1  
    INNER JOIN tblEquityPrices AS ep (NOLOCK)  
    ON   
     e.txtId1 = ep.txtId1  
     AND ep.dteDate = ed.dteDate  
     AND ep.dteTime = et.dteTime  
  
    LEFT OUTER JOIN tblIrc AS i (NOLOCK)  
    ON   
     i.txtIrc = (  
      CASE   
      WHEN e.txtCurrency IN ('USD') THEN 'UFXU'    
      ELSE e.txtCurrency  
      END  
     )  
     AND i.dteDate = @txtDate  
  
    LEFT OUTER JOIN tblPrices AS p (NOLOCK)  
    ON   
     e.txtId1 = p.txtId1  
     AND p.dteDate = @txtDate  
     AND p.txtItem = 'PAV'  
  
    LEFT OUTER JOIN tmp_tblEquityIndexesUnits_ING01_VAI_PIP AS eibuff  
    ON   
     e.txtId1 = eibuff.txtId1  
  
    LEFT OUTER JOIN tblEquityIndexesUnits AS eiu (NOLOCK)  
    ON   
     e.txtId1 = eiu.txtId1  
     AND eiu.txtIrc = @txtIndex  
     AND eiu.dteDate = eibuff.dteDate    
      
   WHERE  
    ip.txtIndex = @txtIndex  
    AND ip.dteDate = @dteMaxdate  
  
   -- obtengo los precios en pesos    
   UPDATE tmp_tblIndexEquityPrices_ING01_VAI_PIP  
   SET dblMXNPrice = dblPrice * dblExchange  
   WHERE  
    txtIndex = @txtIndex  
    AND dblMXNPrice = -999  
   
   -- obtengo el valor del indice en pesos  
   SET @dblIndexValue = (  
    SELECT  SUM(dblCount * dblMXNPrice * dblUnits)  
    FROM tmp_tblIndexEquityPrices_ING01_VAI_PIP  
    WHERE  
     txtIndex = @txtIndex  
   )  
  
   UPDATE tmp_tblIndexEquityPrices_ING01_VAI_PIP  
   SET dblPond = dblMXNPrice * dblCount * dblUnits / @dblIndexValue  
   WHERE  
    txtIndex = @txtIndex  
  
  END   
  
  -- skip siguiente registro   
  SET @intRow = @intRow + 1   
  
 END   
  
  
 INSERT tmp_tblIdsAddId3_ING01_VAI_PIP (  
  txtId1,  
  dteDate  
 )  
 SELECT   
  e.txtId1,  
  MAX(ia.dteDate) AS dteDate  
 FROM   
  tmp_tblIndexEquityPrices_ING01_VAI_PIP AS e  
  INNER JOIN tblIdsAdd AS ia (NOLOCK)  
  ON e.txtId1 = ia.txtId1  
 WHERE  
  ia.txtItem = 'ID3'  
  AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  e.txtId1  
  
  
 INSERT tmp_tblIdsAddId4_ING01_VAI_PIP (  
  txtId1,  
  dteDate  
 )  
 SELECT   
  e.txtId1,  
  MAX(ia.dteDate) AS dteDate  
 FROM   
  tmp_tblIndexEquityPrices_ING01_VAI_PIP AS e  
  INNER JOIN tblIdsAdd AS ia (NOLOCK)  
  ON e.txtId1 = ia.txtId1  
 WHERE  
  ia.txtItem = 'ID4'  
  AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  e.txtId1  
  
 INSERT tmp_tblIdsAddCountry_ING01_VAI_PIP (  
  txtId1,  
  dteDate  
 )  
 SELECT   
  e.txtId1,  
  MAX(ia.dteDate) AS dteDate  
 FROM   
  tmp_tblIndexEquityPrices_ING01_VAI_PIP AS e  
  INNER JOIN tblIdsAdd AS ia (NOLOCK)  
  ON e.txtId1 = ia.txtId1  
 WHERE  
  ia.txtItem = 'COUNTRY'  
  AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  e.txtId1  
  
 INSERT INTO tmp_tblIdsAdd_ING01_VAI_PIP (  
  txtId1,  
  txtId2,  
  txtId3,  
  txtId4,  
  txtCountry,  
  txtCur  
 )  
 SELECT DISTINCT   
  e.txtId1,  
  
  CASE  
  WHEN i.txtId2 IS NULL THEN ''  
  ELSE i.txtId2  
  END AS txtId2,  
  
  CASE  
  WHEN ia.txtValue IS NULL THEN ''  
  ELSE ia.txtValue  
  END AS txtId3,  
  
  CASE  
  WHEN iaQ.txtValue IS NULL THEN ''  
  ELSE iaQ.txtValue  
  END AS txtId4,  
  
  CASE  
  WHEN iaK.txtValue IS NULL THEN 'MX'  
  ELSE iaK.txtValue  
  END AS txtCountry,  
  
  CASE  
  WHEN e.txtCurrency IS NULL THEN 'MXN'  
  WHEN e.txtCurrency IN ('MPS', 'MXP') THEN 'MXN'  
  WHEN e.txtCurrency IN ('UFXU') THEN 'USD'  
  ELSE e.txtCurrency  
  END AS txtCur  
  
 FROM   
  tblIds AS i (NOLOCK)  
  INNER JOIN tblEquity AS e (NOLOCK)  
  ON i.txtId1 = e.txtId1  
  INNER JOIN tmp_tblIndexEquityPrices_ING01_VAI_PIP AS p  
  ON e.txtId1 = p.txtId1  
  LEFT OUTER JOIN tmp_tblIdsAddId3_ING01_VAI_PIP AS ia3  
  ON e.txtId1 = ia3.txtId1  
  LEFT OUTER JOIN tmp_tblIdsAddId4_ING01_VAI_PIP AS ia4  
  ON e.txtId1 = ia4.txtId1  
  LEFT OUTER JOIN tmp_tblIdsAddCountry_ING01_VAI_PIP AS iaC  
  ON e.txtId1 = iaC.txtId1  
  
  LEFT OUTER JOIN tblIdsAdd AS ia (NOLOCK)  
  ON   
   e.txtId1 = ia.txtId1  
   AND ia.txtItem = 'ID3'  
   AND ia.dteDate = ia3.dteDate  
  
  LEFT OUTER JOIN tblIdsAdd AS iaQ (NOLOCK)  
  ON   
   e.txtId1 = iaQ.txtId1  
   AND iaQ.txtItem = 'ID4'  
   AND iaQ.dteDate = ia4.dteDate  
  
  LEFT OUTER JOIN tblIdsAdd AS iaK (NOLOCK)  
  ON   
   e.txtId1 = iaK.txtId1  
   AND iaK.txtItem = 'COUNTRY'  
   AND iaK.dteDate = iaC.dteDate  
  
 INSERT tmp_tblPond_ING01_VAI_PIP (txtIndex,tblMXNPon)  
 SELECT   
  DISTINCT(l.txtIndex),  
  SUM(l.dblcount*o.dblPRS)  
 FROM tblIndexesPortfolios AS l  
    INNER JOIN tmp_tblunifiedpricesreport AS o  
    ON l.txtid1 = o.txtid1  
    AND l.dtedate = o.dtedate  
 WHERE o.txtTv IN ('S','S0','S3','S5','S7','M','M0','M3','M5','M7')   
  AND o.dtedate = @txtDate   
  AND o.txtliquidation = 'MD'   
 GROUP BY l.txtIndex   
  
 INSERT tmp_tbltrackPrices_ING01_VAI_PIP (txtID1,dtedate,txtTv,txtEmisora,txtSerie,dblMXNPrice,txtCUR,txtCountry,txtIndex,dblPond,txtId2,txtId3,txtId4)    
 SELECT  
  o.txtID1,  
  o.dtedate,  
  o.txtTv,  
  o.txtEmisora,  
  o.txtSerie,  
  
  CASE  
   WHEN o.dblPRS IS NULL THEN -999  
  ELSE o.dblPRS  
  END AS dblMXNPrice,  
  
  SUBSTRING(o.txtCUR,2,3),  
  o.txtCountry,  
  l.txtIndex,  
  CASE   
   WHEN o.dblPRS IS NULL THEN -999  
  ELSE  ((l.dblcount*o.dblPRS) / tblMXNPon)   
  END AS dblPond,  
  CASE WHEN o.txtId2 IS NULL OR o.txtId2 = '-' OR o.txtId2 = 'NA' THEN '' ELSE o.txtId2 END,  
  CASE WHEN o.txtId3 IS NULL OR o.txtId3 = '-' OR o.txtId3 = 'NA' THEN '' ELSE o.txtId3 END,  
  CASE WHEN o.txtId4 IS NULL OR o.txtId4 = '-' OR o.txtId4 = 'NA' THEN '' ELSE o.txtId4 END   
  
 FROM tblprices AS p  
  INNER JOIN tblids AS i  
  ON p.txtid1 = i.txtid1  
   INNER JOIN tblIndexesPortfolios AS l  
    ON p.txtid1 = l.txtid1  
    AND p.dtedate = l.dtedate  
    INNER JOIN tmp_tblunifiedpricesreport AS o  
    ON p.txtid1 = o.txtid1  
    AND p.txtLiquidation = o.txtLiquidation  
    INNER JOIN tmp_tblPond_ING01_VAI_PIP AS k  
    ON l.txtIndex = k.txtIndex  
     LEFT OUTER JOIN tblIrc AS ii (NOLOCK)  
     ON   
      ii.txtIrc = (  
       CASE   
       WHEN o.txtCUR IN ('[USD] Dolar Americano (MXN)') THEN 'UFXU'    
       ELSE o.txtCUR  
       END  
      )  
      AND ii.dteDate = @txtDate  
 WHERE o.txtTv IN ('S','S0','S3','S5','S7','M','M0','M3','M5','M7')   
  AND p.dtedate = @txtDate   
  AND o.txtliquidation = 'MD'   
  AND p.txtitem = 'PRS'  
 ORDER BY l.txtIndex  
  
 SET NOCOUNT OFF  
  
 -- resultados  
 INSERT tmp_tblResult_ING01_VAI_PIP  
  SELECT    
  CONVERT(CHAR(8),@txtDate) +  
  RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +  
  RTRIM(SUBSTRING(i.txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(i.txtEmisora, 1, 7))) +  
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
   
  SUBSTRING(REPLACE(STR(ROUND(c.dblMXNPrice,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblMXNPrice,6),16,6),  ' ', '0'), 11, 6) +  
   
  RTRIM(ia.txtCur) + REPLICATE(' ',3 - LEN(ia.txtCur)) +  
  RTRIM(ia.txtCountry) + REPLICATE(' ',2 - LEN(ia.txtCountry)) +  
  RTRIM(c.txtIndex) + REPLICATE(' ',7 - LEN(c.txtIndex)) +  
   
  SUBSTRING(REPLACE(STR(ROUND(c.dblPond * 100,6),11,6),  ' ', '0'), 1, 4) +  
   SUBSTRING(REPLACE(STR(ROUND(c.dblPond * 100,6),11,6),  ' ', '0'), 6, 6) +  
   
  RTRIM(ia.txtId2) + REPLICATE(' ',12 - LEN(ia.txtId2)) +  
  RTRIM(ia.txtId3) + REPLICATE(' ',9 - LEN(ia.txtId3)) +  
  RTRIM(ia.txtId4) + REPLICATE(' ',7 - LEN(ia.txtId4)) AS txtVectorPiP  
    
  FROM   
  tblIds AS i (NOLOCK)  
  INNER JOIN tmp_tblIndexEquityPrices_ING01_VAI_PIP AS c  
  ON i.txtId1 = c.txtId1  
  INNER JOIN tmp_tblIdsAdd_ING01_VAI_PIP AS ia  
  ON i.txtId1 = ia.txtId1  
  ORDER BY  
  c.txtIndex,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie  
   
 INSERT tmp_tblResult_ING01_VAI_PIP  
  SELECT     
  @txtDate +  
  RTRIM(txtTv) + REPLICATE(' ',4 - LEN(txtTv))+  
  RTRIM(SUBSTRING(txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(txtEmisora, 1, 7)))  +  
  RTRIM(txtSerie) + REPLICATE(' ',6 - LEN(txtSerie)) +  
   
  SUBSTRING(REPLACE(STR(ROUND(dblMXNPrice,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(dblMXNPrice,6),16,6),  ' ', '0'), 11, 6) +  
   
  RTRIM(txtCur) + REPLICATE(' ',3 - LEN(txtCur)) +  
  RTRIM(txtCountry) + REPLICATE(' ',2 - LEN(txtCountry)) +  
  RTRIM(txtIndex) + REPLICATE(' ',7 - LEN(txtIndex)) +  
   
  SUBSTRING(REPLACE(STR(ROUND(dblPond * 100,6),11,6),  ' ', '0'), 1, 4) +  
   SUBSTRING(REPLACE(STR(ROUND(dblPond * 100,6),11,6),  ' ', '0'), 6, 6) +  
   
  RTRIM(txtId2) + REPLICATE(' ',12 - LEN(txtId2)) +  
  RTRIM(txtId3) + REPLICATE(' ',9 - LEN(txtId3)) +  
  RTRIM(txtId4) + REPLICATE(' ',7 - LEN(txtId4))      
  FROM tmp_tbltrackPrices_ING01_VAI_PIP  
  ORDER BY  
  txtIndex,  
  txtTv,  
  txtEmisora,  
  txtSerie   
  
 -- Reporto informacion  
 SELECT LTRIM(txtData)  
 FROM tmp_tblResult_ING01_VAI_PIP  
  
END  
-------------------------------------------------------------------------------------------  
-- Autor:    Mike Ramírez  
-- Fecha Creacion  : 04:58 p.m. 2012-07-03  
-- Descripcion:   Procedimiento que genera el producto: ING_Curvas_MXT_[yyyymmdd].txt  
-------------------------------------------------------------------------------------------  
CREATE PROCEDURE [dbo].[sp_productos_INGBANKMEXICO];62  
 @txtDate AS DATETIME      
      
AS   
BEGIN        
   
 SET NOCOUNT ON  
   
  DECLARE @dblUDI AS FLOAT   
  
 -- Genera tabla temporal de resultados      
 DECLARE @tblResult TABLE (      
  [intSection][INTEGER],--[intSection]INT IDENTITY(1,1),--[intSection][INTEGER],      
  [txtData][VARCHAR](8000)      
 )      
   
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)      
 DECLARE @tmp_tblCurvesNodes TABLE (      
  [intSection][INTEGER],      
  [Label]  CHAR(30),    
  [Type]  CHAR(3),    
  [SubType]  CHAR(3),    
  [Node] INT,      
  [dblValue] VARCHAR(50)      
  PRIMARY KEY(intSection,Type,SubType,Node)      
 )   
   
-- 1. Crear estructura  
DECLARE @tmp_Temporal TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Tv_txt VARCHAR(10) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
-- 1. Crear estructura  
DECLARE @tmp_Temporal_1 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Tv_txt VARCHAR(10) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
-- 1. Crear estructura  
DECLARE @tmp_Temporal_2 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Tv_txt VARCHAR(10) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_Temporal2 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Tv_txt VARCHAR(50) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_Temporal2_1 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Tv_txt VARCHAR(50) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_Temporal2_2 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Tv_txt VARCHAR(50) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
-- 1. Crear estructura  
DECLARE @tmp_TemporalMarkets TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
dblLevel FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_TemporalMarkets2 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
dblLevel FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_TemporalMarkets2_1 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
dblLevel FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_TemporalMarkets2_2 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
dblLevel FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_Temporal3 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_Temporal3_1 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
DECLARE @tmp_Temporal3_2 TABLE (  
intRow INT IDENTITY(1,1),   
Label_txt VARCHAR(50) NOT NULL,  
Label_Serie_txt VARCHAR(50) NOT NULL,  
dblValor FLOAT   
PRIMARY KEY (intRow)  
)  
  
 DECLARE @dblT028 AS FLOAT  
  
 DECLARE @dblMXPUSD AS FLOAT  
 DECLARE @dblUSDEUR AS FLOAT  
 DECLARE @dblMXPUDI AS FLOAT  
 DECLARE @dblMXPEUR AS FLOAT  
  
 DECLARE @dblARSUSD AS FLOAT  
 DECLARE @dblBRLUSD AS FLOAT  
 DECLARE @dblCLPUSD AS FLOAT  
 DECLARE @dblCOPUSD AS FLOAT  
 DECLARE @dblUSDVEF AS FLOAT  
 DECLARE @dblPENUSD AS FLOAT  
  
 DECLARE @dblAMXL600 AS FLOAT  
 DECLARE @dblAMXL771 AS FLOAT  
 DECLARE @dblCBPF AS FLOAT  
 DECLARE @dblCFE AS FLOAT  
 DECLARE @dblCOMM573 AS FLOAT  
 DECLARE @dblCOMM270 AS FLOAT  
 DECLARE @dblHICOAM AS FLOAT  
 DECLARE @dblVWLEASE AS FLOAT  
  
 DECLARE @dblCBIC002 AS FLOAT  
 DECLARE @dblCBIC004 AS FLOAT  
 DECLARE @dblCBIC009  AS FLOAT  
 DECLARE @dblBACOMER AS FLOAT  
 DECLARE @dbl120621 AS FLOAT  
 DECLARE @dbl160616 AS FLOAT  
 DECLARE @dbl201210 AS FLOAT  
 DECLARE @dbl251204 AS FLOAT  
 DECLARE @dbl351122 AS FLOAT  
 DECLARE @dbl401115 AS FLOAT  
  
 DECLARE @descripcion_txt AS VARCHAR(80)   
 DECLARE @descripcion_ingles_txt AS VARCHAR(80)   
 DECLARE @Label_txt AS VARCHAR(80)   
 DECLARE @Label_TV_txt AS VARCHAR(80)   
 DECLARE @Label_Serie_txt AS VARCHAR(80)   
 DECLARE @dblValor AS FLOAT   
 DECLARE @dblLevel AS FLOAT   
  
-- Contadores de ciclo  
DECLARE @intTotalRow AS INT  
DECLARE @intRow AS INT  
  
 -- Tasas de Referencia      
 SET @dblT028 = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'T028')  
 SET @dblMXPUSD = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0000078')  
 SET @dblUSDEUR = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0000101')  
 SET @dblMXPUDI = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0000079')  
 SET @dblMXPEUR = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0000081')  
  
 SET @dblARSUSD = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0017462')  
 SET @dblBRLUSD = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0000116')  
 SET @dblCLPUSD = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0000541')  
 SET @dblCOPUSD = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC006830')  
 SET @dblUSDVEF = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0004252')  
 SET @dblPENUSD = (SELECT dblPRL FROM MxFixIncome.dbo.tmp_tblUnifiedpricesreport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0003423')  
  
 -- Tasas de Referencia      
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'UDI')   
  
 SET @dblAMXL600 = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0001942' AND txtLiquidation = 'MD')  
 SET @dblAMXL771 = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIPC7600121' AND txtLiquidation = 'MD')  
 SET @dblCBPF = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0002511' AND txtLiquidation = 'MD')  
 SET @dblCFE = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MCFO9550065' AND txtLiquidation = 'MD')  
 SET @dblCOMM573 = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0012648' AND txtLiquidation = 'MD')  
 SET @dblCOMM270 = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0000914' AND txtLiquidation = 'MD')  
 SET @dblHICOAM = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MCXE9500013' AND txtLiquidation = 'MD')  
 SET @dblVWLEASE = (SELECT (dblPRS/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtID1 = 'MIRC0011441' AND txtLiquidation = 'MD')  
  
 SET @dblCBIC002 = (SELECT (dblPRS/(CAST(txtVNA AS FLOAT)*@dblUDI))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MDPO0000001' AND txtLiquidation = 'MD')  
 SET @dblCBIC004 = (SELECT (dblPRS/(CAST(txtVNA AS FLOAT)*@dblUDI))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MDPP0000001' AND txtLiquidation = 'MD')  
 SET @dblCBIC009 = (SELECT (dblPRS/(CAST(txtVNA AS FLOAT)*@dblUDI))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MEKA5500001' AND txtLiquidation = 'MD')  
  
 SET @dblBACOMER = (SELECT (dblPRS/(CAST(txtVNA AS FLOAT)*@dblUDI))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MAAE8592183' AND txtLiquidation = 'MD')  
  
 SET @dbl160616 = (SELECT (dblPRL/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MGOV3301897' AND txtLiquidation = 'MD')  
 SET @dbl201210 = (SELECT (dblPRL/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MGOV3302331' AND txtLiquidation = 'MD')  
 SET @dbl251204 = (SELECT (dblPRL/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MGOV3301795' AND txtLiquidation = 'MD')  
 SET @dbl351122 = (SELECT (dblPRL/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MGOV3301796' AND txtLiquidation = 'MD')  
 SET @dbl401115 = (SELECT (dblPRL/CAST(txtVNA AS FLOAT))*100 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK) WHERE txtID1 = 'MGOV3302239' AND txtLiquidation = 'MD')  
  
 INSERT @tblResult      
--  SELECT 001,'CCY' + CHAR(9) + 'MXN' UNION      
--  SELECT 002,'INDEX' + CHAR(9) + 'MXIBK'  
  SELECT 001,'CCY MXN' UNION      
  SELECT 002,'INDEX MXIBK' UNION  
  SELECT 003,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 004,'ID MXT' UNION  
  SELECT 005,'MXN MXIBK MM'   
  
 INSERT @tblResult      
  SELECT 006,'1D  ' + LTRIM(@dblT028) UNION  
  SELECT 007,'28D  ' + LTRIM(@dblT028) UNION  
  SELECT 008,'MXN MXIBK AIC'  
  
 -- Nodos de Curvas (FRPiP)      
 INSERT @tmp_tblCurvesNodes   
  SELECT 009,'84C','TIE','SWP','84',NULL UNION                
  SELECT 010,'168C','TIE','SWP','168',NULL UNION      
  SELECT 011,'252C','TIE','SWP','252',NULL UNION                
  SELECT 012,'364C','TIE','SWP','364',NULL UNION      
  SELECT 013,'728C','TIE','SWP','728',NULL UNION                
  SELECT 014,'1092C','TIE','SWP','1092',NULL UNION      
  SELECT 015,'1456C','TIE','SWP','1456',NULL UNION      
  SELECT 016,'1820C','TIE','SWP','1820',NULL UNION                
  SELECT 017,'2548C','TIE','SWP','2548',NULL UNION      
  SELECT 018,'3640C','TIE','SWP','3640',NULL UNION                
  SELECT 019,'5460C','TIE','SWP','5460',NULL UNION      
  SELECT 020,'7280C','TIE','SWP','7280',NULL UNION                
  SELECT 021,'10920C','TIE','SWP','10920',NULL  
  
--------------------------------------------------------------------------- new 1  
 INSERT @tblResult  
  SELECT 022,'' UNION  
  SELECT 023,'CCY MXN' UNION      
  SELECT 024,'INDEX MXIBK' UNION  
  SELECT 025,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 026,'ID MEXASIF' UNION  
  SELECT 027,'MXN MXIBK MM'   
  
 INSERT @tblResult      
  SELECT 028,'1D  ' + LTRIM(@dblT028) UNION  
  SELECT 029,'28D  ' + LTRIM(@dblT028) UNION  
  SELECT 030,'MXN MXIBK AIC'  
  
 -- Nodos de Curvas (FRPiP)      
 INSERT @tmp_tblCurvesNodes   
  SELECT 031,'84C','TIE','SWP','84',NULL UNION                
  SELECT 032,'168C','TIE','SWP','168',NULL UNION      
  SELECT 033,'252C','TIE','SWP','252',NULL UNION                
  SELECT 034,'364C','TIE','SWP','364',NULL UNION      
  SELECT 035,'728C','TIE','SWP','728',NULL UNION                
  SELECT 036,'1092C','TIE','SWP','1092',NULL UNION      
  SELECT 037,'1456C','TIE','SWP','1456',NULL UNION      
  SELECT 038,'1820C','TIE','SWP','1820',NULL UNION                
  SELECT 039,'2548C','TIE','SWP','2548',NULL UNION      
  SELECT 040,'3640C','TIE','SWP','3640',NULL UNION                
  SELECT 041,'5460C','TIE','SWP','5460',NULL UNION      
  SELECT 042,'7280C','TIE','SWP','7280',NULL UNION                
  SELECT 043,'10920C','TIE','SWP','10920',NULL    
  
 INSERT @tblResult  
  SELECT 044,'' UNION  
  SELECT 045,'CCY MXN' UNION      
  SELECT 046,'INDEX MXIBK' UNION  
  SELECT 047,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 048,'ID RISK' UNION  
  SELECT 049,'MXN MXIBK MM'   
  
 INSERT @tblResult      
  SELECT 050,'1D  ' + LTRIM(@dblT028) UNION  
  SELECT 051,'28D  ' + LTRIM(@dblT028) UNION  
  SELECT 052,'MXN MXIBK AIC'  
  
 -- Nodos de Curvas (FRPiP)      
 INSERT @tmp_tblCurvesNodes   
  SELECT 053,'84C','TIE','SWP','84',NULL UNION                
  SELECT 054,'168C','TIE','SWP','168',NULL UNION      
  SELECT 055,'252C','TIE','SWP','252',NULL UNION                
  SELECT 056,'364C','TIE','SWP','364',NULL UNION      
  SELECT 057,'728C','TIE','SWP','728',NULL UNION                
  SELECT 058,'1092C','TIE','SWP','1092',NULL UNION      
  SELECT 059,'1456C','TIE','SWP','1456',NULL UNION      
  SELECT 060,'1820C','TIE','SWP','1820',NULL UNION                
  SELECT 061,'2548C','TIE','SWP','2548',NULL UNION      
  SELECT 062,'3640C','TIE','SWP','3640',NULL UNION                
  SELECT 063,'5460C','TIE','SWP','5460',NULL UNION      
  SELECT 064,'7280C','TIE','SWP','7280',NULL UNION                
  SELECT 065,'10920C','TIE','SWP','10920',NULL    
--------------------------------------------------------------------------- new 1  
  
 INSERT @tblResult  
  SELECT 066,'' UNION  
  SELECT 067,'CCY USD' UNION  
  SELECT 068,'INDEX MXUMS' UNION  
  SELECT 069,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 070,'ID MXT' UNION  
  SELECT 071,'USD MXUMS MM'    
  
 INSERT @tmp_tblCurvesNodes  
  SELECT 072,'1D','UMS','YUM','1',NULL UNION                
  SELECT 073,'1M','UMS','YUM','30',NULL UNION      
  SELECT 074,'2M','UMS','YUM','60',NULL UNION                
  SELECT 075,'3M','UMS','YUM','90',NULL UNION      
  SELECT 076,'6M','UMS','YUM','180',NULL UNION                
  SELECT 077,'9M','UMS','YUM','270',NULL UNION      
  SELECT 078,'12M','UMS','YUM','360',NULL UNION      
  SELECT 079,'18M','UMS','YUM','540',NULL UNION                
  SELECT 080,'2Y','UMS','YUM','720',NULL UNION      
  SELECT 081,'3Y','UMS','YUM','1080',NULL UNION                
  SELECT 082,'4Y','UMS','YUM','1440',NULL UNION      
  SELECT 083,'5Y','UMS','YUM','1800',NULL    
  
--------------------------------------------------------------------------- new 2  
  
 INSERT @tblResult  
  SELECT 084,'' UNION  
  SELECT 085,'CCY USD' UNION  
  SELECT 086,'INDEX MXUMS' UNION  
  SELECT 087,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 088,'ID MEXASIF' UNION  
  SELECT 089,'USD MXUMS MM'    
  
 INSERT @tmp_tblCurvesNodes  
  SELECT 090,'1D','UMS','YUM','1',NULL UNION                
  SELECT 091,'1M','UMS','YUM','30',NULL UNION      
  SELECT 092,'2M','UMS','YUM','60',NULL UNION                
  SELECT 093,'3M','UMS','YUM','90',NULL UNION      
  SELECT 094,'6M','UMS','YUM','180',NULL UNION                
  SELECT 095,'9M','UMS','YUM','270',NULL UNION      
  SELECT 096,'12M','UMS','YUM','360',NULL UNION      
  SELECT 097,'18M','UMS','YUM','540',NULL UNION                
  SELECT 098,'2Y','UMS','YUM','720',NULL UNION      
  SELECT 099,'3Y','UMS','YUM','1080',NULL UNION                
  SELECT 100,'4Y','UMS','YUM','1440',NULL UNION      
  SELECT 101,'5Y','UMS','YUM','1800',NULL   
  
 INSERT @tblResult  
  SELECT 102,'' UNION  
  SELECT 103,'CCY USD' UNION  
  SELECT 104,'INDEX MXUMS' UNION  
  SELECT 105,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 106,'ID RISK' UNION  
  SELECT 107,'USD MXUMS MM'    
  
 INSERT @tmp_tblCurvesNodes  
  SELECT 108,'1D','UMS','YUM','1',NULL UNION                
  SELECT 109,'1M','UMS','YUM','30',NULL UNION      
  SELECT 110,'2M','UMS','YUM','60',NULL UNION                
  SELECT 111,'3M','UMS','YUM','90',NULL UNION      
  SELECT 112,'6M','UMS','YUM','180',NULL UNION                
  SELECT 113,'9M','UMS','YUM','270',NULL UNION      
  SELECT 114,'12M','UMS','YUM','360',NULL UNION      
  SELECT 115,'18M','UMS','YUM','540',NULL UNION                
  SELECT 116,'2Y','UMS','YUM','720',NULL UNION      
  SELECT 117,'3Y','UMS','YUM','1080',NULL UNION                
  SELECT 118,'4Y','UMS','YUM','1440',NULL UNION      
  SELECT 119,'5Y','UMS','YUM','1800',NULL   
--------------------------------------------------------------------------- new 2  
  
 INSERT @tblResult  
  SELECT 120,'' UNION  
  SELECT 121,'CCY UDI' UNION  
  SELECT 122,'INDEX MXUDI' UNION  
  SELECT 123,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 124,'ID MXT' UNION  
  SELECT 125,'UDI MXUDI BPRI'    
  
SET @intRow = 1     
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal (Label_txt,Label_Tv_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MUDI',  
  RTRIM(txtTv),  
  RTRIM(txtSerie),  
  (dblPRL/(@dblUDI*100))  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtEmisora = 'UDIBONO' AND txtTv NOT IN ('SP','SC')  
 ORDER BY txtSerie, txtTv  
  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
   @Label_Tv_txt = Label_Tv_txt,  
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal   
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 126+@intRow,@Label_txt+@Label_Tv_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
--------------------------------------------------------------------------- new 3  
 INSERT @tblResult  
  SELECT 139,'' UNION  
  SELECT 140,'CCY UDI' UNION  
  SELECT 141,'INDEX MXUDI' UNION  
  SELECT 142,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 143,'ID MEXASIF' UNION  
  SELECT 144,'UDI MXUDI BPRI'    
  
SET @intRow = 1  
  
 -- Tasas de Referencia      
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'UDI')      
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal_1 (Label_txt,Label_Tv_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MUDI',  
  RTRIM(txtTv),  
  RTRIM(txtSerie),  
  (dblPRL/(@dblUDI*100))  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtEmisora = 'UDIBONO' AND txtTv NOT IN ('SP','SC')  
 ORDER BY txtSerie, txtTv  
  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal_1)  
  
WHILE @intRow <= @intTotalRow  
BEGIN  
  
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
   @Label_Tv_txt = Label_Tv_txt,  
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal_1   
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 145+@intRow,@Label_txt+@Label_Tv_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
 INSERT @tblResult  
  SELECT 156,'' UNION  
  SELECT 157,'CCY UDI' UNION  
  SELECT 158,'INDEX MXUDI' UNION  
  SELECT 159,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 160,'ID RISK' UNION  
  SELECT 161,'UDI MXUDI BPRI'    
  
SET @intRow = 1  
  
 -- Tasas de Referencia      
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'UDI')      
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal_2 (Label_txt,Label_Tv_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MUDI',  
  RTRIM(txtTv),  
  RTRIM(txtSerie),  
  (dblPRL/(@dblUDI*100))  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtEmisora = 'UDIBONO' AND txtTv NOT IN ('SP','SC')  
 ORDER BY txtSerie, txtTv  
  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal_2)  
  
WHILE @intRow <= @intTotalRow  
BEGIN  
  
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
   @Label_Tv_txt = Label_Tv_txt,  
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal_2   
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 162+@intRow,@Label_txt+@Label_Tv_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
--------------------------------------------------------------------------- new 3  
---4.1  
---Cambio de curva  
  INSERT @tblResult    
  SELECT 173,'' UNION  
  SELECT 174,'CCY UDI' UNION  
  SELECT 175,'INDEX MXUSW' UNION  
  SELECT 176,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 177,'ID MXT' UNION  
  SELECT 178,'UDI MXUSW MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 179,'1C','ULS','CCS','1',NULL UNION                
  SELECT 180,'28C','ULS','CCS','28',NULL UNION      
  SELECT 181,'91C','ULS','CCS','91',NULL UNION      
  SELECT 182,'182C','ULS','CCS','182',NULL   
  
  INSERT @tblResult  
  SELECT 183,'UDI MXUSW AIC'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 184,'364C','ULS','SWP','364',NULL UNION                
  SELECT 185,'728C','ULS','SWP','728',NULL UNION      
  SELECT 186,'1092C','ULS','SWP','1092',NULL UNION      
  SELECT 187,'1456C','ULS','SWP','1456',NULL UNION                
  SELECT 188,'1820C','ULS','SWP','1820',NULL UNION      
  SELECT 189,'2548C','ULS','SWP','2548',NULL UNION                
  SELECT 190,'3640C','ULS','SWP','3640',NULL UNION      
  SELECT 191,'7280C','ULS','SWP','7280',NULL UNION  
  SELECT 192,'10920C','ULS','SWP','10920',NULL  
  
--------------------------------------------------------------------------- new 4  
  INSERT @tblResult    
  SELECT 193,'' UNION  
  SELECT 194,'CCY UDI' UNION  
  SELECT 195,'INDEX MXUSW' UNION  
  SELECT 196,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 197,'ID MEXASIF' UNION  
  SELECT 198,'UDI MXUSW MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 199,'1C','ULS','CCS','1',NULL UNION                
  SELECT 200,'28C','ULS','CCS','28',NULL UNION      
  SELECT 201,'91C','ULS','CCS','91',NULL UNION      
  SELECT 202,'182C','ULS','CCS','182',NULL   
  
  INSERT @tblResult  
  SELECT 203,'UDI MXUSW AIC'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 204,'364C','ULS','SWP','364',NULL UNION                
  SELECT 205,'728C','ULS','SWP','728',NULL UNION      
  SELECT 206,'1092C','ULS','SWP','1092',NULL UNION      
  SELECT 207,'1456C','ULS','SWP','1456',NULL UNION                
  SELECT 208,'1820C','ULS','SWP','1820',NULL UNION      
  SELECT 209,'2548C','ULS','SWP','2548',NULL UNION                
  SELECT 210,'3640C','ULS','SWP','3640',NULL UNION      
  SELECT 211,'7280C','ULS','SWP','7280',NULL UNION  
  SELECT 212,'10920C','ULS','SWP','10920',NULL  
  
  INSERT @tblResult    
  SELECT 213,'' UNION  
  SELECT 214,'CCY UDI' UNION  
  SELECT 215,'INDEX MXUSW' UNION  
  SELECT 216,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 217,'ID RISK' UNION  
  SELECT 218,'UDI MXUSW MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 219,'1C','ULS','CCS','1',NULL UNION                
  SELECT 220,'28C','ULS','CCS','28',NULL UNION      
  SELECT 221,'91C','ULS','CCS','91',NULL UNION      
  SELECT 222,'182C','ULS','CCS','182',NULL   
  
  INSERT @tblResult  
  SELECT 223,'UDI MXUSW AIC'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 224,'364C','ULS','SWP','364',NULL UNION                
  SELECT 225,'728C','ULS','SWP','728',NULL UNION      
  SELECT 226,'1092C','ULS','SWP','1092',NULL UNION      
  SELECT 227,'1456C','ULS','SWP','1456',NULL UNION                
  SELECT 228,'1820C','ULS','SWP','1820',NULL UNION      
  SELECT 229,'2548C','ULS','SWP','2548',NULL UNION                
  SELECT 230,'3640C','ULS','SWP','3640',NULL UNION      
  SELECT 231,'7280C','ULS','SWP','7280',NULL UNION  
  SELECT 232,'10920C','ULS','SWP','10920',NULL  
  
--------------------------------------------------------------------------- new 4  
  
  INSERT @tblResult  
  SELECT 233,'' UNION  
  SELECT 234,'CCY UDI' UNION  
  SELECT 235,'INDEX MXUTI' UNION  
  SELECT 236,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 237,'ID MXT' UNION  
  SELECT 238,'UDI MXUTI MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 239,'1C','UDT','CCS','1',NULL UNION                
  SELECT 240,'28C','UDT','CCS','28',NULL UNION      
  SELECT 241,'91C','UDT','CCS','91',NULL UNION      
  SELECT 242,'182C','UDT','CCS','182',NULL   
  
  INSERT @tblResult  
  SELECT 243,'UDI MXUTI AIC'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 244,'364C','UDT','SWP','364',NULL UNION                
  SELECT 245,'728C','UDT','SWP','728',NULL UNION      
  SELECT 246,'1092C','UDT','SWP','1092',NULL UNION      
  SELECT 247,'1456C','UDT','SWP','1456',NULL UNION                
  SELECT 248,'1820C','UDT','SWP','1820',NULL UNION      
  SELECT 249,'2548C','UDT','SWP','2548',NULL UNION                
  SELECT 250,'3640C','UDT','SWP','3640',NULL UNION      
  SELECT 251,'7280C','UDT','SWP','7280',NULL UNION  
  SELECT 252,'10920C','UDT','SWP','10920',NULL  
  
--------------------------------------------------------------------------- new 5  
  INSERT @tblResult  
  SELECT 253,'' UNION  
  SELECT 254,'CCY UDI' UNION  
  SELECT 255,'INDEX MXUTI' UNION  
  SELECT 256,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 257,'ID MEXASIF' UNION  
  SELECT 258,'UDI MXUTI MM'  
  
  INSERT @tmp_tblCurvesNodes   
  SELECT 259,'1C','UDT','CCS','1',NULL UNION                
  SELECT 260,'28C','UDT','CCS','28',NULL UNION      
  SELECT 261,'91C','UDT','CCS','91',NULL UNION      
  SELECT 262,'182C','UDT','CCS','182',NULL   
  
  INSERT @tblResult  
  SELECT 263,'UDI MXUTI AIC'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 264,'364C','UDT','SWP','364',NULL UNION                
  SELECT 265,'728C','UDT','SWP','728',NULL UNION      
  SELECT 266,'1092C','UDT','SWP','1092',NULL UNION      
  SELECT 267,'1456C','UDT','SWP','1456',NULL UNION                
  SELECT 268,'1820C','UDT','SWP','1820',NULL UNION      
  SELECT 269,'2548C','UDT','SWP','2548',NULL UNION                
  SELECT 270,'3640C','UDT','SWP','3640',NULL UNION      
  SELECT 271,'7280C','UDT','SWP','7280',NULL UNION  
  SELECT 272,'10920C','UDT','SWP','10920',NULL  
  
  INSERT @tblResult  
  SELECT 273,'' UNION  
  SELECT 274,'CCY UDI' UNION  
  SELECT 275,'INDEX MXUTI' UNION  
  SELECT 276,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 277,'ID RISK' UNION  
  SELECT 278,'UDI MXUTI MM'  
  
  INSERT @tmp_tblCurvesNodes   
  SELECT 279,'1C','UDT','CCS','1',NULL UNION                
  SELECT 280,'28C','UDT','CCS','28',NULL UNION      
  SELECT 281,'91C','UDT','CCS','91',NULL UNION      
  SELECT 282,'182C','UDT','CCS','182',NULL   
  
  INSERT @tblResult  
  SELECT 283,'UDI MXUTI AIC'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 284,'364C','UDT','SWP','364',NULL UNION                
  SELECT 285,'728C','UDT','SWP','728',NULL UNION      
  SELECT 286,'1092C','UDT','SWP','1092',NULL UNION      
  SELECT 287,'1456C','UDT','SWP','1456',NULL UNION   
  SELECT 288,'1820C','UDT','SWP','1820',NULL UNION      
  SELECT 289,'2548C','UDT','SWP','2548',NULL UNION                
  SELECT 290,'3640C','UDT','SWP','3640',NULL UNION      
  SELECT 291,'7280C','UDT','SWP','7280',NULL UNION  
  SELECT 292,'10920C','UDT','SWP','10920',NULL  
  
--------------------------------------------------------------------------- new 5  
-- Este es 6.1  
  INSERT @tblResult    
  SELECT 293,'' UNION  
  SELECT 294,'CCY USD' UNION  
  SELECT 295,'INDEX MXCCS' UNION  
  SELECT 296,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 297,'ID MXT' UNION  
  SELECT 298,'USD MXCCS SPR'  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_TemporalMarkets (Label_txt,dblLevel)   
 SELECT   
  txtLabel,  
  (dblLevel*100)  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
 WHERE txtCode = 'CrossCur'   
  AND dteDate = @txtDate  
  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_TemporalMarkets)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @dblLevel = dblLevel  
        FROM @tmp_TemporalMarkets   
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 299+@intRow,@Label_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblLevel,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
  
--6.2  
--  INSERT @tblResult    
--  SELECT 312,'' UNION  
--  SELECT 313,'CCY USD' UNION  
--  SELECT 314,'INDEX MXCCS' UNION  
--  SELECT 315,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
--  SELECT 316,'ID AMLO' UNION  
--  SELECT 317,'USD MXCCS SPR'  
--  
--SET @intRow = 1  
--  
---- 2. Carga la informacin mediante Query e Insert  
--INSERT INTO @tmp_TemporalMarkets2 (Label_txt,dblLevel)   
-- SELECT  
--  txtLabel,  
--  (dblLevel*100)  
-- FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
-- WHERE txtCode = 'CrossCur'   
--  AND dteDate = @txtDate  
--  
--SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_TemporalMarkets2)  
--   
--WHILE @intRow <= @intTotalRow  
--BEGIN  
--   
--        -- Obtengo la info de cada registro  
--        SELECT   
--            @Label_txt = Label_txt,   
--            @dblLevel = dblLevel  
--        FROM @tmp_TemporalMarkets2   
--        WHERE intRow = @intRow  
--   
--  INSERT @tblResult      
--     SELECT 318+@intRow,@Label_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblLevel,6),19,9))  
--  
--    -- skip siguiente registro  
--    SET @intRow = @intRow + 1  
--   
--END  
  
--------------------------------------------------------------------------- new 6  
 ---6.3   
 INSERT @tblResult    
  SELECT 331,'' UNION  
  SELECT 332,'CCY USD' UNION  
  SELECT 333,'INDEX MXCCS' UNION  
  SELECT 334,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 335,'ID MEXASIF' UNION  
  SELECT 336,'USD MXCCS SPR'  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_TemporalMarkets2_1 (Label_txt,dblLevel)   
 SELECT  
  txtLabel,  
  (dblLevel*100)  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
 WHERE txtCode = 'CrossCur'   
  AND dteDate = @txtDate  
  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_TemporalMarkets2_1)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @dblLevel = dblLevel  
        FROM @tmp_TemporalMarkets2_1  
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 337+@intRow,@Label_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblLevel,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
   
  INSERT @tblResult    
  SELECT 350,'' UNION  
  SELECT 351,'CCY USD' UNION  
  SELECT 352,'INDEX MXCCS' UNION  
  SELECT 353,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 354,'ID RISK' UNION  
  SELECT 355,'USD MXCCS SPR'  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_TemporalMarkets2_2 (Label_txt,dblLevel)   
 SELECT  
  txtLabel,  
  (dblLevel*100)  
 FROM MxFixIncome.dbo.tblMarkets (NOLOCK)  
 WHERE txtCode = 'CrossCur'   
  AND dteDate = @txtDate  
  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_TemporalMarkets2_2)     
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @dblLevel = dblLevel  
        FROM @tmp_TemporalMarkets2_2  
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 356+@intRow,@Label_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblLevel,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
--------------------------------------------------------------------------- new 6  
---7.1  
  INSERT @tblResult    
  SELECT 369,'' UNION  
  SELECT 370,'CCY MXN' UNION  
  SELECT 371,'INDEX MXGOV' UNION  
  SELECT 372,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 373,'ID MXT' UNION  
  SELECT 374,'MXN MXGOV MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 375,'1D','CET','CTI','1',NULL UNION                
  SELECT 376,'4W','CET','CTI','28',NULL UNION      
  SELECT 377,'13W','CET','CTI','91',NULL UNION      
  SELECT 378,'26W','CET','CTI','182',NULL UNION                
  SELECT 379,'39W','CET','CTI','273',NULL UNION      
  SELECT 380,'52W','CET','CTI','364',NULL  
  
  INSERT @tblResult    
  SELECT 381,'MXN MXGOV BPRI'  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal2 (Label_txt,Label_Tv_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MBONOI',  
  RTRIM(txtTv),  
  RTRIM(txtSerie),  
  (dblPRL/100)  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtTv IN ('M','M0','M3','M5','M7')  
 ORDER BY txtSerie,txtTv  
  
--MBONOI[tv][serie]  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal2)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @Label_Tv_txt = Label_Tv_txt,   
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal2   
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 382+@intRow,@Label_txt+@Label_Tv_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
--------------------------------------------------------------------------- new 7  
---7.2  
  INSERT @tblResult    
  SELECT 405,'' UNION  
  SELECT 406,'CCY MXN' UNION  
  SELECT 407,'INDEX MXGOV' UNION  
  SELECT 408,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 409,'ID MEXASIF' UNION  
  SELECT 410,'MXN MXGOV MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 411,'1D','CET','CTI','1',NULL UNION                
  SELECT 412,'4W','CET','CTI','28',NULL UNION      
  SELECT 413,'13W','CET','CTI','91',NULL UNION      
  SELECT 414,'26W','CET','CTI','182',NULL UNION                
  SELECT 415,'39W','CET','CTI','273',NULL UNION      
  SELECT 416,'52W','CET','CTI','364',NULL  
  
  INSERT @tblResult    
  SELECT 417,'MXN MXGOV BPRI'  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal2_1 (Label_txt,Label_Tv_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MBONOI',  
  RTRIM(txtTv),  
  RTRIM(txtSerie),  
  (dblPRL/100)  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtTv IN ('M','M0','M3','M5','M7')  
 ORDER BY txtSerie,txtTv  
  
--MBONOI[tv][serie]  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal2_1)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @Label_Tv_txt = Label_Tv_txt,   
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal2_1  
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 418+@intRow,@Label_txt+@Label_Tv_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
-- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
--7.3  
  INSERT @tblResult    
  SELECT 441,'' UNION  
  SELECT 442,'CCY MXN' UNION  
  SELECT 443,'INDEX MXGOV' UNION  
  SELECT 444,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 445,'ID RISK' UNION  
  SELECT 446,'MXN MXGOV MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 447,'1D','CET','CTI','1',NULL UNION                
  SELECT 448,'4W','CET','CTI','28',NULL UNION      
  SELECT 449,'13W','CET','CTI','91',NULL UNION      
  SELECT 450,'26W','CET','CTI','182',NULL UNION                
  SELECT 451,'39W','CET','CTI','273',NULL UNION      
  SELECT 452,'52W','CET','CTI','364',NULL  
  
  INSERT @tblResult    
  SELECT 453,'MXN MXGOV BPRI'  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal2_2 (Label_txt,Label_Tv_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MBONOI',  
  RTRIM(txtTv),  
  RTRIM(txtSerie),  
  (dblPRL/100)  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtTv IN ('M','M0','M3','M5','M7')  
 ORDER BY txtSerie,txtTv  
  
--MBONOI[tv][serie]  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal2_2)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,  
            @Label_Tv_txt = Label_Tv_txt,  
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor  
        FROM @tmp_Temporal2_2  
        WHERE intRow = @intRow  
   
  INSERT @tblResult  
     SELECT 454+@intRow,@Label_txt+@Label_Tv_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
   
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
--------------------------------------------------------------------------- new 7  
---8.1  
  INSERT @tblResult    
  SELECT 477,'' UNION  
  SELECT 478,'CCY UDI' UNION  
  SELECT 479,'INDEX MXUNI' UNION  
  SELECT 480,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 481,'ID MXT' UNION  
  SELECT 482,'UDI MXUNI MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 483,'1D','UDB','YLD','1',NULL UNION                
  SELECT 484,'4W','UDB','YLD','28',NULL UNION      
  SELECT 485,'13W','UDB','YLD','91',NULL UNION      
  SELECT 486,'26W','UDB','YLD','182',NULL UNION                
  SELECT 487,'52W','UDB','YLD','364',NULL UNION      
  SELECT 488,'104W','UDB','YLD','728',NULL  
  
  INSERT @tblResult    
  SELECT 489,'UDI MXUNI BPRI'   
  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal3 (Label_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MPIC',  
  RTRIM(txtSerie),  
  (dblPRL/@dblUDI)  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtTv = 'PI'  
 ORDER BY txtSerie,txtTv  
  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal3)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal3   
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 490+@intRow,@Label_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
--------------------------------------------------------------------------- new 8  
--8.2  
  INSERT @tblResult    
  SELECT 493,'' UNION  
  SELECT 494,'CCY UDI' UNION  
  SELECT 495,'INDEX MXUNI' UNION  
  SELECT 496,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 497,'ID RISK' UNION  
  SELECT 498,'UDI MXUNI MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 499,'1D','UDB','YLD','1',NULL UNION                
  SELECT 500,'4W','UDB','YLD','28',NULL UNION      
  SELECT 501,'13W','UDB','YLD','91',NULL UNION      
  SELECT 502,'26W','UDB','YLD','182',NULL UNION                
  SELECT 503,'52W','UDB','YLD','364',NULL UNION      
  SELECT 504,'104W','UDB','YLD','728',NULL  
  
  INSERT @tblResult    
  SELECT 505,'UDI MXUNI BPRI'   
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal3_1 (Label_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MPIC',  
  RTRIM(txtSerie),  
  (dblPRL/@dblUDI)  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtTv = 'PI'  
 ORDER BY txtSerie,txtTv  
--MPICP011U[serie]  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal3_1)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal3_1  
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 506+@intRow,@Label_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
--8.3  
   
  INSERT @tblResult    
  SELECT 509,'' UNION  
  SELECT 510,'CCY UDI' UNION  
  SELECT 511,'INDEX MXUNI' UNION  
  SELECT 512,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 513,'ID MEXASIF' UNION  
  SELECT 514,'UDI MXUNI MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 515,'1D','UDB','YLD','1',NULL UNION                
  SELECT 516,'4W','UDB','YLD','28',NULL UNION      
  SELECT 517,'13W','UDB','YLD','91',NULL UNION      
  SELECT 518,'26W','UDB','YLD','182',NULL UNION                
  SELECT 519,'52W','UDB','YLD','364',NULL UNION      
  SELECT 520,'104W','UDB','YLD','728',NULL  
  
  INSERT @tblResult    
  SELECT 521,'UDI MXUNI BPRI'   
  
  
SET @intRow = 1  
  
-- 2. Carga la informacin mediante Query e Insert  
INSERT INTO @tmp_Temporal3_2 (Label_txt,Label_Serie_txt,dblValor)   
 SELECT   
  'MPIC',  
  RTRIM(txtSerie),  
  (dblPRL/@dblUDI)  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
 WHERE txtLiquidation = 'MD' AND txtTv = 'PI'  
 ORDER BY txtSerie,txtTv  
--MPICP011U[serie]  
SET @intTotalRow = (SELECT COUNT(*) FROM @tmp_Temporal3_2)  
   
WHILE @intRow <= @intTotalRow  
BEGIN  
   
        -- Obtengo la info de cada registro  
        SELECT   
            @Label_txt = Label_txt,   
            @Label_Serie_txt = Label_Serie_txt,  
            @dblValor = dblValor   
        FROM @tmp_Temporal3_2  
        WHERE intRow = @intRow  
   
  INSERT @tblResult      
     SELECT 522+@intRow,@Label_txt+@Label_Serie_txt+CHAR(9)+CHAR(9)+LTRIM(STR(ROUND(@dblValor,6),19,9))  
  
    -- skip siguiente registro  
    SET @intRow = @intRow + 1  
   
END  
  
  
--------------------------------------------------------------------------- new 8  
---9.1  
  INSERT @tblResult    
  SELECT 525,'' UNION  
  SELECT 526,'CCY MXN' UNION  
  SELECT 527,'INDEX CETES' UNION  
  SELECT 528,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 529,'ID MEXASIF' UNION  
  SELECT 530,'MXN CETES MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 531,'1D','FWD','CUX','1',NULL UNION                
  SELECT 532,'1M','FWD','CUX','31',NULL UNION      
  SELECT 533,'2M','FWD','CUX','61',NULL UNION      
  SELECT 534,'3M','FWD','CUX','94',NULL UNION                
  SELECT 535,'6M','FWD','CUX','182',NULL UNION      
  SELECT 536,'9M','FWD','CUX','276',NULL UNION  
  SELECT 537,'12M','FWD','CUX','367',NULL UNION                
  SELECT 538,'18M','FWD','CUX','550',NULL UNION      
  SELECT 539,'2Y','FWD','CUX','731',NULL UNION      
  SELECT 540,'3Y','FWD','CUX','1096',NULL UNION                
  SELECT 541,'4Y','FWD','CUX','1461',NULL UNION      
  SELECT 542,'5Y','FWD','CUX','1827',NULL UNION  
  SELECT 543,'7Y','FWD','CUX','2548',NULL UNION                
  SELECT 544,'10Y','FWD','CUX','3640',NULL UNION      
  SELECT 545,'15Y','FWD','CUX','5460',NULL UNION      
  SELECT 546,'20Y','FWD','CUX','7280',NULL UNION                
  SELECT 547,'30Y','FWD','CUX','10920',NULL  
  
--------------------------------------------------------------------------- new 9  
  INSERT @tblResult    
  SELECT 548,'' UNION  
  SELECT 549,'CCY MXN' UNION  
  SELECT 550,'INDEX CETES' UNION  
  SELECT 551,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 552,'ID MTX' UNION  
  SELECT 553,'MXN CETES MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 554,'1D','FWD','CUX','1',NULL UNION                
  SELECT 555,'1M','FWD','CUX','31',NULL UNION      
  SELECT 556,'2M','FWD','CUX','61',NULL UNION      
  SELECT 557,'3M','FWD','CUX','94',NULL UNION                
  SELECT 558,'6M','FWD','CUX','182',NULL UNION      
  SELECT 559,'9M','FWD','CUX','276',NULL UNION  
  SELECT 560,'12M','FWD','CUX','367',NULL UNION                
  SELECT 561,'18M','FWD','CUX','550',NULL UNION      
  SELECT 562,'2Y','FWD','CUX','731',NULL UNION      
  SELECT 563,'3Y','FWD','CUX','1096',NULL UNION                
  SELECT 564,'4Y','FWD','CUX','1461',NULL UNION      
  SELECT 565,'5Y','FWD','CUX','1827',NULL UNION  
  SELECT 566,'7Y','FWD','CUX','2548',NULL UNION                
  SELECT 567,'10Y','FWD','CUX','3640',NULL UNION      
  SELECT 568,'15Y','FWD','CUX','5460',NULL UNION      
  SELECT 569,'20Y','FWD','CUX','7280',NULL UNION                
  SELECT 570,'30Y','FWD','CUX','10920',NULL  
  
  INSERT @tblResult    
  SELECT 571,'' UNION  
  SELECT 572,'CCY MXN' UNION  
  SELECT 573,'INDEX CETES' UNION  
  SELECT 574,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 575,'ID RISK' UNION  
  SELECT 576,'MXN CETES MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 577,'1D','FWD','CUX','1',NULL UNION                
  SELECT 578,'1M','FWD','CUX','31',NULL UNION      
  SELECT 579,'2M','FWD','CUX','61',NULL UNION      
  SELECT 580,'3M','FWD','CUX','94',NULL UNION                
  SELECT 581,'6M','FWD','CUX','182',NULL UNION      
  SELECT 582,'9M','FWD','CUX','276',NULL UNION  
  SELECT 583,'12M','FWD','CUX','367',NULL UNION                
  SELECT 584,'18M','FWD','CUX','550',NULL UNION      
  SELECT 585,'2Y','FWD','CUX','731',NULL UNION      
  SELECT 586,'3Y','FWD','CUX','1096',NULL UNION                
  SELECT 587,'4Y','FWD','CUX','1461',NULL UNION      
  SELECT 588,'5Y','FWD','CUX','1827',NULL UNION  
  SELECT 589,'7Y','FWD','CUX','2548',NULL UNION                
  SELECT 590,'10Y','FWD','CUX','3640',NULL UNION      
  SELECT 591,'15Y','FWD','CUX','5460',NULL UNION      
  SELECT 592,'20Y','FWD','CUX','7280',NULL UNION                
  SELECT 593,'30Y','FWD','CUX','10920',NULL  
  
--------------------------------------------------------------------------- new 9  
--10.1  
  INSERT @tblResult    
  SELECT 593,'' UNION  
  SELECT 594,'CCY USD' UNION  
  SELECT 595,'INDEX LIBOR' UNION  
  SELECT 596,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 597,'ID MEXASIF' UNION  
  SELECT 598,'USD LIBOR MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 599,'1D','LIB','BL','1',NULL UNION                
  SELECT 600,'1M','LIB','BL','30',NULL UNION      
  SELECT 601,'3M','LIB','BL','91',NULL UNION      
  SELECT 602,'6M','LIB','BL','182',NULL UNION           
  SELECT 603,'9M','LIB','BL','273',NULL UNION      
  SELECT 604,'1Y','LIB','BL','364',NULL  
  
  INSERT @tblResult    
  SELECT 605,'USD LIBOR AIC'   
   
 INSERT @tmp_tblCurvesNodes   
  SELECT 606,'15M','LIB','YLD','455',NULL UNION                
  SELECT 607,'18M','LIB','YLD','546',NULL UNION      
  SELECT 608,'2Y','LIB','YLD','728',NULL UNION      
  SELECT 609,'3Y','LIB','YLD','1092',NULL UNION                
  SELECT 610,'4Y','LIB','YLD','1456',NULL UNION      
  SELECT 611,'5Y','LIB','YLD','1820',NULL UNION  
  SELECT 612,'6Y','LIB','YLD','2184',NULL UNION                
  SELECT 613,'7Y','LIB','YLD','2548',NULL UNION      
  SELECT 614,'8Y','LIB','YLD','2912',NULL UNION      
  SELECT 615,'9Y','LIB','YLD','3276',NULL UNION                
  SELECT 616,'10Y','LIB','YLD','3640',NULL UNION      
  SELECT 617,'11Y','LIB','YLD','4004',NULL UNION  
  SELECT 618,'12Y','LIB','YLD','4368',NULL UNION                
  SELECT 619,'13Y','LIB','YLD','4732',NULL UNION      
  SELECT 620,'14Y','LIB','YLD','5096',NULL UNION      
  SELECT 621,'15Y','LIB','YLD','5460',NULL UNION                
  SELECT 622,'16Y','LIB','YLD','5824',NULL UNION  
  SELECT 623,'17Y','LIB','YLD','6188',NULL UNION       
  SELECT 624,'18Y','LIB','YLD','6552',NULL UNION      
  SELECT 625,'19Y','LIB','YLD','6916',NULL UNION      
  SELECT 626,'20Y','LIB','YLD','7280',NULL UNION                
  SELECT 627,'21Y','LIB','YLD','7644',NULL UNION      
  SELECT 628,'22Y','LIB','YLD','8008',NULL UNION  
  SELECT 629,'23Y','LIB','YLD','8372',NULL UNION                
  SELECT 630,'24Y','LIB','YLD','8736',NULL UNION      
  SELECT 631,'25Y','LIB','YLD','9100',NULL UNION      
  SELECT 632,'26Y','LIB','YLD','9464',NULL UNION                
  SELECT 633,'27Y','LIB','YLD','9828',NULL UNION      
  SELECT 634,'28Y','LIB','YLD','10192',NULL UNION  
  SELECT 635,'29Y','LIB','YLD','10556',NULL UNION                
  SELECT 636,'30Y','LIB','YLD','10920',NULL    
  
--------------------------------------------------------------------------- new 10  
--10.2  
  INSERT @tblResult    
  SELECT 637,'' UNION  
  SELECT 638,'CCY USD' UNION  
  SELECT 639,'INDEX LIB1M' UNION  
  SELECT 640,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 641,'ID MEXASIF' UNION  
  SELECT 642,'USD LIBOR MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 643,'1D','LIB','BL','1',NULL UNION                
  SELECT 644,'1M','LIB','BL','30',NULL UNION      
  SELECT 645,'3M','LIB','BL','91',NULL UNION      
  SELECT 646,'6M','LIB','BL','182',NULL UNION           
  SELECT 647,'9M','LIB','BL','273',NULL UNION      
  SELECT 648,'1Y','LIB','BL','364',NULL  
  
  INSERT @tblResult    
  SELECT 649,'USD LIBOR AIC'   
   
 INSERT @tmp_tblCurvesNodes   
  SELECT 650,'15M','LIB','YLD','455',NULL UNION                
  SELECT 651,'18M','LIB','YLD','546',NULL UNION      
  SELECT 652,'2Y','LIB','YLD','728',NULL UNION      
  SELECT 653,'3Y','LIB','YLD','1092',NULL UNION                
  SELECT 654,'4Y','LIB','YLD','1456',NULL UNION      
  SELECT 655,'5Y','LIB','YLD','1820',NULL UNION  
  SELECT 656,'6Y','LIB','YLD','2184',NULL UNION                
  SELECT 657,'7Y','LIB','YLD','2548',NULL UNION      
  SELECT 658,'8Y','LIB','YLD','2912',NULL UNION      
  SELECT 659,'9Y','LIB','YLD','3276',NULL UNION                
  SELECT 660,'10Y','LIB','YLD','3640',NULL UNION      
  SELECT 661,'11Y','LIB','YLD','4004',NULL UNION  
  SELECT 662,'12Y','LIB','YLD','4368',NULL UNION                
  SELECT 663,'13Y','LIB','YLD','4732',NULL UNION      
  SELECT 664,'14Y','LIB','YLD','5096',NULL UNION      
  SELECT 665,'15Y','LIB','YLD','5460',NULL UNION                
  SELECT 666,'16Y','LIB','YLD','5824',NULL UNION  
  SELECT 667,'17Y','LIB','YLD','6188',NULL UNION                
  SELECT 668,'18Y','LIB','YLD','6552',NULL UNION      
  SELECT 669,'19Y','LIB','YLD','6916',NULL UNION      
  SELECT 670,'20Y','LIB','YLD','7280',NULL UNION                
  SELECT 671,'21Y','LIB','YLD','7644',NULL UNION      
  SELECT 672,'22Y','LIB','YLD','8008',NULL UNION  
  SELECT 673,'23Y','LIB','YLD','8372',NULL UNION                
  SELECT 674,'24Y','LIB','YLD','8736',NULL UNION      
  SELECT 675,'25Y','LIB','YLD','9100',NULL UNION      
  SELECT 676,'26Y','LIB','YLD','9464',NULL UNION                
  SELECT 677,'27Y','LIB','YLD','9828',NULL UNION      
  SELECT 678,'28Y','LIB','YLD','10192',NULL UNION  
  SELECT 679,'29Y','LIB','YLD','10556',NULL UNION                
  SELECT 680,'30Y','LIB','YLD','10920',NULL    
--10.3  
  INSERT @tblResult    
  SELECT 681,'' UNION  
  SELECT 682,'CCY USD' UNION  
  SELECT 683,'INDEX LIB3M' UNION  
  SELECT 684,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 685,'ID MEXASIF' UNION  
  SELECT 686,'USD LIBOR MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 687,'1D','LIB','BL','1',NULL UNION                
  SELECT 688,'1M','LIB','BL','30',NULL UNION      
  SELECT 689,'3M','LIB','BL','91',NULL UNION      
  SELECT 690,'6M','LIB','BL','182',NULL UNION           
  SELECT 691,'9M','LIB','BL','273',NULL UNION      
  SELECT 692,'1Y','LIB','BL','364',NULL  
  
  INSERT @tblResult    
  SELECT 693,'USD LIBOR AIC'   
   
 INSERT @tmp_tblCurvesNodes   
  SELECT 694,'15M','LIB','YLD','455',NULL UNION                
  SELECT 695,'18M','LIB','YLD','546',NULL UNION      
  SELECT 696,'2Y','LIB','YLD','728',NULL UNION      
  SELECT 697,'3Y','LIB','YLD','1092',NULL UNION                
  SELECT 698,'4Y','LIB','YLD','1456',NULL UNION      
  SELECT 699,'5Y','LIB','YLD','1820',NULL UNION  
  SELECT 700,'6Y','LIB','YLD','2184',NULL UNION                
  SELECT 701,'7Y','LIB','YLD','2548',NULL UNION      
  SELECT 702,'8Y','LIB','YLD','2912',NULL UNION      
  SELECT 703,'9Y','LIB','YLD','3276',NULL UNION                
  SELECT 704,'10Y','LIB','YLD','3640',NULL UNION      
  SELECT 705,'11Y','LIB','YLD','4004',NULL UNION  
  SELECT 706,'12Y','LIB','YLD','4368',NULL UNION                
  SELECT 707,'13Y','LIB','YLD','4732',NULL UNION      
  SELECT 708,'14Y','LIB','YLD','5096',NULL UNION      
  SELECT 709,'15Y','LIB','YLD','5460',NULL UNION                
  SELECT 710,'16Y','LIB','YLD','5824',NULL UNION  
  SELECT 711,'17Y','LIB','YLD','6188',NULL UNION                
  SELECT 712,'18Y','LIB','YLD','6552',NULL UNION      
  SELECT 713,'19Y','LIB','YLD','6916',NULL UNION      
  SELECT 714,'20Y','LIB','YLD','7280',NULL UNION                
  SELECT 715,'21Y','LIB','YLD','7644',NULL UNION      
  SELECT 716,'22Y','LIB','YLD','8008',NULL UNION  
  SELECT 717,'23Y','LIB','YLD','8372',NULL UNION                
  SELECT 718,'24Y','LIB','YLD','8736',NULL UNION      
  SELECT 719,'25Y','LIB','YLD','9100',NULL UNION      
  SELECT 720,'26Y','LIB','YLD','9464',NULL UNION                
  SELECT 721,'27Y','LIB','YLD','9828',NULL UNION      
  SELECT 722,'28Y','LIB','YLD','10192',NULL UNION  
  SELECT 723,'29Y','LIB','YLD','10556',NULL UNION                
  SELECT 724,'30Y','LIB','YLD','10920',NULL  
-- 3 LIB6M  10.4  
  INSERT @tblResult    
  SELECT 725,'' UNION  
  SELECT 726,'CCY USD' UNION  
  SELECT 727,'INDEX LIB6M' UNION  
  SELECT 728,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 729,'ID MEXASIF' UNION  
  SELECT 730,'USD LIBOR MM'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 731,'1D','LIB','BL','1',NULL UNION                
  SELECT 732,'1M','LIB','BL','30',NULL UNION      
  SELECT 733,'3M','LIB','BL','91',NULL UNION      
  SELECT 734,'6M','LIB','BL','182',NULL UNION           
  SELECT 735,'9M','LIB','BL','273',NULL UNION      
  SELECT 736,'1Y','LIB','BL','364',NULL  
  
  INSERT @tblResult    
  SELECT 737,'USD LIBOR AIC'   
   
 INSERT @tmp_tblCurvesNodes   
  SELECT 738,'15M','LIB','YLD','455',NULL UNION                
  SELECT 739,'18M','LIB','YLD','546',NULL UNION      
  SELECT 740,'2Y','LIB','YLD','728',NULL UNION      
  SELECT 741,'3Y','LIB','YLD','1092',NULL UNION                
  SELECT 742,'4Y','LIB','YLD','1456',NULL UNION      
  SELECT 743,'5Y','LIB','YLD','1820',NULL UNION  
  SELECT 744,'6Y','LIB','YLD','2184',NULL UNION                
  SELECT 745,'7Y','LIB','YLD','2548',NULL UNION      
  SELECT 746,'8Y','LIB','YLD','2912',NULL UNION      
  SELECT 747,'9Y','LIB','YLD','3276',NULL UNION                
  SELECT 748,'10Y','LIB','YLD','3640',NULL UNION      
  SELECT 749,'11Y','LIB','YLD','4004',NULL UNION  
  SELECT 750,'12Y','LIB','YLD','4368',NULL UNION                
  SELECT 751,'13Y','LIB','YLD','4732',NULL UNION      
  SELECT 752,'14Y','LIB','YLD','5096',NULL UNION      
  SELECT 753,'15Y','LIB','YLD','5460',NULL UNION                
  SELECT 754,'16Y','LIB','YLD','5824',NULL UNION  
  SELECT 755,'17Y','LIB','YLD','6188',NULL UNION                
  SELECT 756,'18Y','LIB','YLD','6552',NULL UNION      
  SELECT 757,'19Y','LIB','YLD','6916',NULL UNION      
  SELECT 758,'20Y','LIB','YLD','7280',NULL UNION                
  SELECT 759,'21Y','LIB','YLD','7644',NULL UNION      
  SELECT 760,'22Y','LIB','YLD','8008',NULL UNION  
  SELECT 761,'23Y','LIB','YLD','8372',NULL UNION                
  SELECT 762,'24Y','LIB','YLD','8736',NULL UNION      
  SELECT 763,'25Y','LIB','YLD','9100',NULL UNION      
  SELECT 764,'26Y','LIB','YLD','9464',NULL UNION                
  SELECT 765,'27Y','LIB','YLD','9828',NULL UNION      
  SELECT 766,'28Y','LIB','YLD','10192',NULL UNION  
  SELECT 767,'29Y','LIB','YLD','10556',NULL UNION                
  SELECT 768,'30Y','LIB','YLD','10920',NULL  
  
--------de aqui se elimino  
  
--------------------------------------------------------------------------- new 10  
  
 INSERT @tblResult    
  SELECT 769,'' UNION  
  SELECT 770,'FXRATE MXN USD' UNION  
  SELECT 771,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 772,'ID MEXASIF' UNION  
  SELECT 773,'SPOT ' + LTRIM(@dblMXPUSD)  
  
 INSERT @tblResult    
  SELECT 774,'' UNION  
  SELECT 775,'FXRATE USD EUR' UNION  
  SELECT 776,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 777,'ID MEXASIF' UNION  
  SELECT 778,'SPOT ' + LTRIM(@dblUSDEUR)   
  
 INSERT @tblResult    
  SELECT 779,'' UNION  
  SELECT 780,'FXRATE UDI MXN' UNION  
  SELECT 781,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 782,'ID MEXASIF' UNION  
  SELECT 783,'SPOT ' + LTRIM(@dblMXPUDI)   
  
 INSERT @tblResult    
  SELECT 784,'' UNION  
  SELECT 785,'FXRATE MXN EUR' UNION  
  SELECT 786,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 787,'ID MEXASIF' UNION  
  SELECT 788,'SPOT ' + LTRIM(@dblMXPEUR)   
  
------------------------ aqui va lo nuevo  
  
 INSERT @tblResult    
  SELECT 789,'' UNION  
  SELECT 790,'FXRATE USD ARS' UNION  
  SELECT 791,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 792,'ID MEXASIF' UNION  
  SELECT 793,'SPOT ' + LTRIM(@dblARSUSD)   
  
 INSERT @tblResult    
  SELECT 794,'' UNION  
  SELECT 795,'FXRATE USD BRL' UNION  
  SELECT 796,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 797,'ID MEXASIF' UNION  
  SELECT 798,'SPOT ' + LTRIM(@dblBRLUSD)  
  
 INSERT @tblResult    
  SELECT 799,'' UNION  
  SELECT 800,'FXRATE USD CLP' UNION  
  SELECT 801,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 802,'ID MEXASIF' UNION  
  SELECT 803,'SPOT ' + LTRIM(@dblCLPUSD)  
  
 INSERT @tblResult    
  SELECT 804,'' UNION  
  SELECT 805,'FXRATE USD COP' UNION  
  SELECT 806,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 807,'ID MEXASIF' UNION  
  SELECT 808,'SPOT ' + LTRIM(@dblCOPUSD)  
  
 INSERT @tblResult    
  SELECT 809,'' UNION  
  SELECT 810,'FXRATE USD VEF' UNION  
  SELECT 811,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 812,'ID MEXASIF' UNION  
  SELECT 813,'SPOT ' + LTRIM(@dblUSDVEF)  
  
 INSERT @tblResult    
  SELECT 814,'' UNION  
  SELECT 815,'FXRATE USD PEN' UNION  
  SELECT 816,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 817,'ID MEXASIF' UNION  
  SELECT 818,'SPOT ' + LTRIM(@dblPENUSD)  
  
------------------------ aqui va lo nuevo  
--Corregir  
 INSERT @tblResult    
  SELECT 819,'' UNION  
  SELECT 820,'SEC MXN DOM' UNION  
  SELECT 821,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 822,'ID MXT' UNION  
  SELECT 823,'AMXL60181236 ' + LTRIM(@dblAMXL600) UNION  
  SELECT 824,'AMXL77181236 ' + LTRIM(@dblAMXL771) UNION  
  SELECT 825,'CBPF48 ' + LTRIM(@dblCBPF) UNION  
  SELECT 826,'CFE10-2 ' + LTRIM(@dblCFE) UNION  
  SELECT 827,'COMM57300618 ' + LTRIM(@dblCOMM573) UNION  
  SELECT 828,'COMMEX8700MAR27 ' + LTRIM(@dblCOMM270) UNION  
  SELECT 829,'HICOAM07 ' + LTRIM(@dblHICOAM) UNION  
  SELECT 830,'VWLEAS10 ' + LTRIM(@dblVWLEASE)  
  
------------------------  
  
 INSERT @tblResult    
  SELECT 831,'' UNION  
  SELECT 832,'SEC UDI BOND' UNION  
  SELECT 833,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 834,'ID MXT' UNION  
  SELECT 835,'CBIC00300117 ' + LTRIM(@dblCBIC002) UNION  
  SELECT 836,'CBIC00310116 ' + LTRIM(@dblCBIC004) UNION  
  SELECT 837,'CBIC00331124 ' + LTRIM(@dblCBIC009)  
  
 INSERT @tblResult    
  SELECT 838,'' UNION  
  SELECT 839,'SEC UDI DOM' UNION  
  SELECT 840,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 841,'ID MXT' UNION  
  SELECT 842,'BACOME07U ' + LTRIM(@dblBACOMER)  
  
 INSERT @tblResult    
  SELECT 843,'' UNION  
  SELECT 844,'SEC UDI BOND' UNION  
  SELECT 845,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 846,'ID MXT' UNION  
  SELECT 847,'MUDIS160616 ' + LTRIM(@dbl160616) UNION  
  SELECT 848,'MUDIS201210 ' + LTRIM(@dbl201210) UNION  
  SELECT 849,'MUDIS251204 ' + LTRIM(@dbl251204) UNION  
  SELECT 850,'MUDIS351122 ' + LTRIM(@dbl351122) UNION  
  SELECT 851,'MUDIS401115 ' + LTRIM(@dbl401115)   
  
--16.1  
  INSERT @tblResult    
  SELECT 852,'' UNION  
  SELECT 853,'CCY MXN' UNION  
  SELECT 854,'INDEX PAGAR' UNION  
  SELECT 855,'DATE' + CHAR(9) + RTRIM(CAST(@txtDate AS FLOAT)+2) UNION  
  SELECT 856,'ID MXT' UNION  
  SELECT 857,'MXN PAGAR SPR'  
  
 INSERT @tmp_tblCurvesNodes   
  SELECT 858,'84C','PLV','ASK','84',NULL UNION                
  SELECT 859,'168C','PLV','ASK','168',NULL UNION      
  SELECT 860,'252C','PLV','ASK','252',NULL UNION      
  SELECT 861,'364C','PLV','ASK','364',NULL UNION           
  SELECT 862,'728C','PLV','ASK','728',NULL UNION      
  SELECT 863,'1092C','PLV','ASK','1092',NULL UNION  
  SELECT 864,'1456C','PLV','ASK','1456',NULL UNION                
  SELECT 865,'1820C','PLV','ASK','1820',NULL UNION      
  SELECT 866,'2548C','PLV','ASK','2548',NULL UNION      
  SELECT 867,'3640C','PLV','ASK','3640',NULL UNION           
  SELECT 868,'5460C','PLV','ASK','5460',NULL UNION      
  SELECT 869,'7280C','PLV','ASK','7280',NULL UNION  
  SELECT 870,'10920C','PLV','ASK','10920',NULL  
  
 -- Obtengo los valores de los FRPiP      
 UPDATE @tmp_tblCurvesNodes      
        SET dblValue = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0')*100,9,6))      
 FROM @tmp_tblCurvesNodes  
      
 INSERT @tblResult      
  SELECT intSection,RTRIM(Label) + CHAR(9) + CHAR(9) + LTRIM(dblValue)  
  FROM @tmp_tblCurvesNodes   
  
   
  -- Reporto los datos      
  SELECT RTRIM(txtData)      
  FROM @tblResult      
  ORDER BY intSection    
  
 SET NOCOUNT OFF  
  
END  
-------------------------------------------------------------------------------------------  
-- Autor:    Mike Ramírez  
-- Fecha Creacion:  13:09 p.m. 2012-09-25  
-- Descripcion:   Procedimiento que genera el producto: SURA_BENCHMARKS[yyyymmdd].xls  
-------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_INGBANKMEXICO;63  
  @dteDate AS DATETIME  
AS  
  
BEGIN  
  
  
  -- Variables Parametro del Producto  
  DECLARE @txtProductId VARCHAR(50)   
  SET @txtProductId = 'BENCH_CARTERAS_SURA'  
  
  -- Variables para Cursor  
  DECLARE @txtType VARCHAR(15)  
  DECLARE @intTaxes INT  
  DECLARE @fType VARCHAR(1)  
  DECLARE @txtInternetAlias VARCHAR(50)  
  
  DECLARE @tblBenchUniverse TABLE   
    (  
     txtType VARCHAR(15),  
     intTaxes INT,  
     fType VARCHAR(1),  
     txtInternetAlias VARCHAR(50)  
     PRIMARY KEY (txtType,intTaxes)  
    )   
  
  DECLARE @tblPiPIndexes TABLE  
    (  
     [dteDate] [datetime] NOT NULL,  
     [txtType] [char](15) NOT NULL,  
     [intTaxes] [int] NOT NULL,  
     [dblDividend] [float] NOT NULL,  
     [dblSpltiter] [float] NOT NULL,  
     [dblFactor] [float] NOT NULL,  
     [dblIndex] [float] NOT NULL,  
     [dblDividend24H] [float] NOT NULL,  
     [dblSpltiter24H] [float] NOT NULL,  
     [dblFactor24H] [float] NOT NULL,  
     [dblIndex24H] [float] NOT NULL,  
     [dblDuracion24H] [float] NULL,  
     [dblConvexidad24H] [float] NULL,  
     PRIMARY KEY ([dteDate], [txtType], [intTaxes])  
    )  
  
  DECLARE @tblPrices TABLE  
    (  
     [dteDate] [datetime] NOT NULL,  
     [txtID1] [char](11) NOT NULL,  
     [txtLiquidation] [char](3) NOT NULL,  
     [txtItem] [char](10) NOT NULL,  
     [dblValue] [float] NOT NULL,  
     [intFlag] [int] NOT NULL,  
     PRIMARY KEY ([dteDate],[txtID1],[txtLiquidation],[txtItem])  
    )  
  
  DECLARE @tblPortafolioBench TABLE  
    (  
     [txtType] [char](15) NOT NULL,  
     [dteDate] [datetime] NOT NULL,  
     [txtId1] [char](11) NOT NULL,  
     [txtLiquidation] [varchar](50) NOT NULL,  
     [intTaxes] [int] NOT NULL,  
     [txtTv] [char](10) NOT NULL,  
     [txtEmisora] [char](10) NOT NULL,  
     [txtSerie] [char](10) NOT NULL,  
     [dblMonto] [float] NOT NULL,  
     [dblPorcentaje] [float] NULL,  
     [dblDuracion] [float] NULL,  
     [dblConvexidad] [float] NULL,  
     [dblMontoTotal] [float] NULL,  
     [dblMontoTotalAyer] [float] NULL,  
     PRIMARY KEY ([txtType], [dteDate], [txtId1], [txtLiquidation], [intTaxes])  
    )  
  
  DECLARE @tmp_tblResults TABLE   
    (  
     Label01 VARCHAR(10),  
     Label02 VARCHAR(30),  
     Label03 VARCHAR(4),  
     Label04 VARCHAR(7),  
     Label05 VARCHAR(6),  
     Label06 FLOAT,  
     Label07 FLOAT,  
     Label08 FLOAT,  
     Label09 FLOAT,  
     Label10 FLOAT,  
     Label11 FLOAT,  
     Label12 FLOAT,  
     Label13 FLOAT,  
     Label14 FLOAT,  
     Label15 FLOAT,  
     Label16 FLOAT,  
     Label17 FLOAT,  
     Label18 FLOAT,  
     Label19 FLOAT,  
     Label20 VARCHAR(1),  
     Label21 FLOAT,  
     Label22 FLOAT,  
     Label23 FLOAT,  
     Label24 FLOAT,  
     Label25 FLOAT,  
     Label26 FLOAT  
    )   
  
  -- Universo del Producto  
  INSERT @tblBenchUniverse  
  SELECT DISTINCT p.txtType,b.intTaxes,'S',b.txtInternetAlias  
  FROM dbo.tblPiPIndexes AS p (NOLOCK)  
   INNER JOIN dbo.tblBenchCatalog AS b (NOLOCK)  
    ON p.txtType= b.txtType   
     AND p.intTaxes = b.intTaxes  
     AND p.dteDate = @dteDate  
   INNER JOIN MxProcesses..tblOwnersVsProductsDirectives AS pr (NOLOCK)  
    ON  RTRIM(LTRIM(pr.txtDir)) = RTRIM(LTRIM(p.txtType))  
     AND pr.txtProductId = @txtProductId  
     AND pr.txtOwnerId = 'SURA'  
     AND pr.dteBeg <= @dteDate  
     AND pr.dteEnd >= @dteDate  
  
  -- Obtengo los compuestos  
  UPDATE u  
  SET u.fType = 'C'  
  FROM @tblBenchUniverse AS u  
  WHERE txtType IN (  
       SELECT DISTINCT bcc.txtType  
       FROM tblBenchComplexComposition AS bcc (NOLOCK)  
         INNER JOIN @tblBenchUniverse AS u  
         ON  
          bcc.txtType = u.txtType  
          AND bcc.intTaxes = 0  
          AND bcc.dteBeg <= @dteDate  
          AND bcc.dteEnd >= @dteDate  
      )  
  -- Obtengo informacion de la fecha a procesar  
  INSERT @tblPiPIndexes(  
    dteDate,  
    txtType,  
    intTaxes,  
    dblDividend,  
    dblSpltiter,  
    dblFactor,  
    dblIndex,  
    dblDividend24H,  
    dblSpltiter24H,  
    dblFactor24H,  
    dblIndex24H,  
    dblDuracion24H,  
    dblConvexidad24H)  
  
   SELECT   
    dteDate,  
    txtType,  
    intTaxes,  
    dblDividend,  
    dblSpltiter,  
    dblFactor,  
    dblIndex,  
    dblDividend24H,  
    dblSpltiter24H,  
    dblFactor24H,  
    dblIndex24H,  
    dblDuracion24H,  
    dblConvexidad24H  
   FROM dbo.tblPiPIndexes (NOLOCK)  
   WHERE dteDate = @dteDate  
  
  INSERT @tblPrices(  
    dteDate,  
    txtID1,  
    txtLiquidation,  
    txtItem,  
    dblValue,  
    intFlag)  
  
   SELECT  
    dteDate,  
    txtID1,  
    txtLiquidation,  
    txtItem,  
    dblValue,  
    intFlag  
   FROM dbo.tblPrices (NOLOCK)  
   WHERE dteDate = @dteDate  
    AND txtLiquidation IN ('MD','24H','MP')  
    AND txtItem IN ('PRS','PRL','PAV','YTM','DTM')  
  
  INSERT @tblPortafolioBench(  
    txtType,  
    dteDate,  
    txtId1,  
    txtLiquidation,  
    intTaxes,  
    txtTv,  
    txtEmisora,  
    txtSerie,  
    dblMonto,  
    dblPorcentaje,  
    dblDuracion,  
    dblConvexidad,  
    dblMontoTotal,  
    dblMontoTotalAyer)  
  
   SELECT  
    txtType,  
    dteDate,  
    txtId1,  
    txtLiquidation,  
    intTaxes,  
    txtTv,  
    txtEmisora,  
    txtSerie,  
    dblMonto,  
    dblPorcentaje,  
    dblDuracion,  
    dblConvexidad,  
    dblMontoTotal,  
    dblMontoTotalAyer  
   FROM dbo.tblPortafolioBench (NOLOCK)  
   WHERE dteDate = @dteDate  
  
  -- Obtengo las carteras  
  DECLARE csr_Info_CARTERAS CURSOR FOR  
   SELECT txtType,intTaxes,fType,txtInternetAlias   
   FROM @tblBenchUniverse  
  
  OPEN csr_Info_CARTERAS  
  FETCH NEXT FROM csr_Info_CARTERAS  
  INTO  
   @txtType,  
   @intTaxes,  
   @fType,  
   @txtInternetAlias  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
    
   IF @fType = 'C' -- BenchMarks Compuesto  
   BEGIN  
  
    INSERT @tmp_tblResults      
    SELECT x1.Fecha,x1.Descripcion,x1.txtTv,x1.txtEmisora,x1.txtSerie,x1.PLimpio_24H,x1.Psucio_24H,x1.Yield_24H,  
      x1.DxVencer_24H,x1.Participacion_24H,x1.Duracion_24H,x1.Duracion_Portafolio_24H,x1.PLimpio_MD,  
      x1.Psucio_MD,x1.Yield_MD,x1.DxVencer_MD,x1.Participacion_MD,x1.Duracion_MD,x1.Duracion_Portafolio_MD,'',  
      y1.Participacion_24H,y1.Duracion_24H,y1.Duracion_Portafolio_24H,y1.Participacion_MD,y1.Duracion_MD,  
      y1.Duracion_Portafolio_MD   
    FROM (   
     select t1.Fecha,t1.Descripcion,t1.txtTv,t1.txtEmisora,t1.txtSerie,  
       t1.Participacion_24H,t1.PLimpio_24H,t1.Psucio_24H,t1.Yield_24H,t1.DxVencer_24H,t1.Duracion_24H,Duracion_Portafolio_24H,  
       t2.Participacion_MD,t2.PLimpio_MD,t2.Psucio_MD,t2.Yield_MD,t2.DxVencer_MD,t2.Duracion_MD,Duracion_Portafolio_MD,t2.Tipo  
     from (  
      Select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,a.txtEmisora,a.txtSerie,  
       STR((a.dblPorcentaje*b.Rsp)*100,10,6) as [Participacion_24H],STR(a.dblDuracion,10,6) as [Duracion_24H],PLimpio_24H,  
       Psucio_24H,Yield_24H,DxVencer_24H,Duracion_Portafolio_24H,Tipo='Bruto'  
      from (select a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion,  
         (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_24H,  
         (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_24H,  
         (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_24H,  
         (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_24H,  
         Duracion_Portafolio_24H = (select dblDuracion24H from @tblpipindexes  
                WHERE txtType=@txtType  
                 and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)   
                and intTaxes = 0 )  
        from @tblPortafolioBench a, @tblPrices b  
        where a.txtId1=b.txtId1  
         and a.dteDate=b.dteDate  
         and a.txtLiquidation=b.txtLiquidation  
         and a.dteDate = @dteDate --(select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
         and a.txtLiquidation  = '24H'  
         and a.txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
              where txtType = @txtType and intTaxes = 0   
              and dteBeg <= @dteDate and dteEnd >= @dteDate)  
         and a.intTaxes=0  
        group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion ) a  
      left OUTER JOIN (select dblSpltiter24H/(select dblSpltiter24H  from @tblPipIndexes   
                where txtType = @txtType  
                 and intTaxes=0 and dteDate = @dteDate) as Rsp,txtType   
          from @tblPipIndexes   
          where txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
               where txtType = @txtType and intTaxes = 0  
                and dteBeg <= @dteDate and dteEnd >= @dteDate)  
           and intTaxes=0  
           and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
        ) b on a.txtType=b.txtType  
       ) as t1   
     left outer join (  
      Select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,a.txtEmisora,a.txtSerie,  
       STR((a.dblPorcentaje*b.Rsp)*100,10,6) as [Participacion_MD],STR(a.dblDuracion,10,6) as [Duracion_MD],  
       PLimpio_MD,Psucio_MD,Yield_MD,DxVencer_MD,Duracion_Portafolio_MD,Tipo='Bruto'  
      from (select a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion,  
          (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_MD,  
          (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_MD,  
          (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_MD,  
          (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_MD,  
          Duracion_Portafolio_MD = 0  
        from @tblPortafolioBench a, @tblPrices b  
        where a.txtId1=b.txtId1  
          and a.dteDate=b.dteDate  
          and a.txtLiquidation=b.txtLiquidation  
          and a.dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
          and a.txtLiquidation  = 'MD'  
          and a.txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
               where txtType = @txtType and intTaxes = 0   
                and dteBeg <= @dteDate and dteEnd >= @dteDate)  
          and a.intTaxes=0  
      group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion ) a  
      left OUTER JOIN  
       (select dblSpltiter/(select dblSpltiter  from @tblPipIndexes   
            where txtType = @txtType   
             and intTaxes=0 and dteDate =@dteDate) as Rsp,txtType   
        from @tblPipIndexes  
        where txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
             where txtType = @txtType and intTaxes = 0  
              and dteBeg <= @dteDate and dteEnd >= @dteDate)   
         and intTaxes=0  
         and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
        ) b on a.txtType=b.txtType) as t2   
      on t1.txtTv=t2.txtTv and t1.txtEmisora=t2.txtEmisora and t1.txtSerie=t2.txtSerie  
    ) AS x1   
     LEFT OUTER JOIN  (  
      select t1.Fecha,t1.Descripcion,t1.txtTv,t1.txtEmisora,t1.txtSerie,t1.Participacion_24H,t1.PLimpio_24H,  
        t1.Psucio_24H,t1.Yield_24H,t1.DxVencer_24H,t1.Duracion_24H,Duracion_Portafolio_24H,t2.Participacion_MD,  
        t2.PLimpio_MD,t2.Psucio_MD,t2.Yield_MD,t2.DxVencer_MD,t2.Duracion_MD,Duracion_Portafolio_MD,t2.Tipo  
      from (  
       Select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,a.txtEmisora,a.txtSerie,  
        STR((a.dblPorcentaje*b.Rsp)*100,10,6) as [Participacion_24H],STR(a.dblDuracion,10,6) as [Duracion_24H],  
        PLimpio_24H,Psucio_24H,Yield_24H,DxVencer_24H,Duracion_Portafolio_24H,Tipo='Neto'  
        from (select a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion,  
        (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_24H,  
        (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_24H,  
        (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_24H,  
        (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_24H,  
        Duracion_Portafolio_24H = (select dblDuracion24H from @tblpipindexes  
               WHERE txtType=@txtType  
                and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)   
                and intTaxes = 1 )  
        from @tblPortafolioBench a, @tblPrices b  
        where a.txtId1=b.txtId1  
         and a.dteDate=b.dteDate  
         and a.txtLiquidation=b.txtLiquidation  
         and a.dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
         and a.txtLiquidation  = '24H'  
         and a.txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
              where txtType = @txtType and intTaxes = 1  
               and dteBeg <= @dteDate and dteEnd >= @dteDate)  
         and a.intTaxes=1  
        group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion ) a   
       left OUTER JOIN  
        (select dblSpltiter24H/(select dblSpltiter24H  from @tblPipIndexes  
              where txtType = @txtType  
               and intTaxes=1   
               and dteDate =@dteDate) as Rsp,txtType from @tblPipIndexes  
        where txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
             where txtType = @txtType and intTaxes = 1  
              and dteBeg <= @dteDate and dteEnd >= @dteDate)   
         and intTaxes=1  
         and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
        ) b on a.txtType=b.txtType  
      ) as t1   
      left outer join (  
       Select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,a.txtEmisora,a.txtSerie,  
        STR((a.dblPorcentaje*b.Rsp)*100,10,6) as [Participacion_MD],STR(a.dblDuracion,10,6) as [Duracion_MD],PLimpio_MD,  
        Psucio_MD,Yield_MD,DxVencer_MD,Duracion_Portafolio_MD,Tipo='Neto'  
        from (select a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion,  
           (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_MD,  
           (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_MD,  
           (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_MD,  
           (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_MD,  
           Duracion_Portafolio_MD = 0  
            from @tblPortafolioBench a, @tblPrices b  
            where a.txtId1=b.txtId1   
           and a.dteDate=b.dteDate   
           and a.txtLiquidation=b.txtLiquidation  
           and a.dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
           and a.txtLiquidation  = 'MD'  
           and a.txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
                where txtType = @txtType and intTaxes = 1  
                 and dteBeg <= @dteDate and dteEnd >= @dteDate)  
           and a.intTaxes=1  
           group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion) a  
        left OUTER JOIN  
         (select dblSpltiter/(select dblSpltiter  from @tblPipIndexes  
               where txtType = @txtType and intTaxes=1 and dteDate = @dteDate) as Rsp,txtType   
          from @tblPipIndexes  
         where txtType in (select txtSubPortfolio from  tblBenchComplexComposition (NOLOCK)   
              where txtType = @txtType and intTaxes = 1  
               and dteBeg <= @dteDate and dteEnd >= @dteDate)   
          and intTaxes=1 and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
        ) b on a.txtType=b.txtType  
       ) as t2 on t1.txtTv=t2.txtTv and t1.txtEmisora=t2.txtEmisora and t1.txtSerie=t2.txtSerie  
     ) AS y1   
      ON x1.txtTv=y1.txtTv and x1.txtEmisora=y1.txtEmisora and x1.txtSerie=y1.txtSerie   
    ORDER BY x1.txtTv,x1.txtEmisora,x1.txtSerie  
  
   END  
  
   IF @fType = 'S' -- BenchMarks Simple  
   BEGIN  
  
    INSERT @tmp_tblResults      
    select x1.Fecha,x1.Descripcion,x1.txtTv,x1.txtEmisora,x1.txtSerie,x1.PLimpio_24H,x1.Psucio_24H,x1.Yield_24H,  
      x1.DxVencer_24H,x1.Participacion_24H,x1.Duracion_24H,x1.Duracion_Portafolio_24H,x1.PLimpio_MD,x1.Psucio_MD,  
      x1.Yield_MD,x1.DxVencer_MD,x1.Participacion_MD,x1.Duracion_MD,x1.Duracion_Portafolio_MD,'',  
      y1.Participacion_24H,y1.Duracion_24H,y1.Duracion_Portafolio_24H,y1.Participacion_MD,y1.Duracion_MD,y1.Duracion_Portafolio_MD   
    from (   
     select t1.Fecha,t1.Descripcion,t1.txtTv,t1.txtEmisora,t1.txtSerie,  
      t1.Participacion_24H,t1.PLimpio_24H,t1.Psucio_24H,t1.Yield_24H,t1.DxVencer_24H,t1.Duracion_24H,Duracion_Portafolio_24H,  
      t2.Participacion_MD,t2.PLimpio_MD,t2.Psucio_MD,t2.Yield_MD,t2.DxVencer_MD,t2.Duracion_MD,Duracion_Portafolio_MD,t2.Tipo  
     from (  
       select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,  
         a.txtEmisora,a.txtSerie,  
         STR(a.dblPorcentaje*100,10,6) as [Participacion_24H],  
         STR(a.dblDuracion,10,6) as [Duracion_24H],  
         (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_24H,  
         (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_24H,  
         (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_24H,  
         (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_24H,  
         Duracion_Portafolio_24H = (select dblDuracion24H from @tblpipindexes  
                WHERE txtType=@txtType  
                and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
                and intTaxes = 0 )  
        from @tblPortafolioBench a, @tblPrices b  
        where a.txtId1=b.txtId1  
         and a.dteDate=b.dteDate  
         and a.txtLiquidation=b.txtLiquidation  
         and a.txtType in (@txtType)  
         and a.intTaxes=0  
         and a.dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
         and a.txtLiquidation='24H'  
       group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion  
      ) as t1   
     left outer join (  
       select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,a.txtEmisora,a.txtSerie,  
        STR(a.dblPorcentaje*100,10,6) as [Participacion_MD],  
        STR(a.dblDuracion,10,6) as [Duracion_MD],  
        (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_MD,  
        (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_MD,  
        (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_MD,  
        (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_MD,Tipo='Bruto',  
        Duracion_Portafolio_MD = 0  
       from @tblPortafolioBench a, @tblPrices b  
       where a.txtId1=b.txtId1  
        and a.dteDate=b.dteDate  
        and a.txtLiquidation=b.txtLiquidation  
        and a.txtType in (@txtType)  
        and a.intTaxes=0  
        and a.dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
        and a.txtLiquidation='MD'  
       group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion  
      ) as t2 on t1.txtTv=t2.txtTv and t1.txtEmisora=t2.txtEmisora and t1.txtSerie=t2.txtSerie  
     ) as x1   
    left outer join (  
     select t1.Fecha,t1.Descripcion,t1.txtTv,t1.txtEmisora,t1.txtSerie,  
       t1.Participacion_24H,t1.PLimpio_24H,t1.Psucio_24H,t1.Yield_24H,t1.DxVencer_24H,t1.Duracion_24H,Duracion_Portafolio_24H,  
       t2.Participacion_MD,t2.PLimpio_MD,t2.Psucio_MD,t2.Yield_MD,t2.DxVencer_MD,t2.Duracion_MD,Duracion_Portafolio_MD,t2.Tipo  
     from (  
      select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,  
       a.txtEmisora,a.txtSerie,  
       STR(a.dblPorcentaje*100,10,6) as [Participacion_24H],  
       STR(a.dblDuracion,10,6) as [Duracion_24H],  
       (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_24H,  
       (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_24H,  
       (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_24H,  
       (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_24H,Tipo='Neto',  
       Duracion_Portafolio_24H = (select dblDuracion24H from @tblpipindexes  
              WHERE txtType=@txtType  
               and dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)   
               and intTaxes = 1 )  
      from @tblPortafolioBench a, @tblPrices b  
       where a.txtId1=b.txtId1  
       and a.dteDate=b.dteDate  
       and a.txtLiquidation=b.txtLiquidation  
       and a.txtType in (@txtType)  
       and a.intTaxes=1  
       and a.dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
       and a.txtLiquidation='24H'  
      group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion  
       ) as t1   
    left outer join (  
        select convert(Char(10),a.dteDate,103) as [Fecha],Descripcion=@txtInternetAlias,a.txtTv,  
         a.txtEmisora,a.txtSerie,  
         STR(a.dblPorcentaje*100,10,6) as [Participacion_MD],  
         STR(a.dblDuracion,10,6) as [Duracion_MD],  
         (SUM(CASE WHEN b.txtItem  IN ('PRL','PAV') THEN b.dblValue ELSE 0 END)) AS PLimpio_MD,  
         (SUM(CASE WHEN  b.txtItem  IN ('PRS','PAV') THEN b.dblValue ELSE 0 END)) AS Psucio_MD,  
         (SUM(CASE WHEN  b.txtItem  IN ('YTM') THEN b.dblValue ELSE 0 END)) AS Yield_MD,  
         (SUM(CASE WHEN  b.txtItem  IN ('DTM') THEN b.dblValue ELSE 0 END)) AS DxVencer_MD,Tipo='Neto',  
         Duracion_Portafolio_MD = 0  
        from @tblPortafolioBench a, @tblPrices b  
        where a.txtId1=b.txtId1  
         and a.dteDate=b.dteDate  
         and a.txtLiquidation=b.txtLiquidation  
         and a.txtType in (@txtType)  
         and a.intTaxes=1  
         and a.dteDate = @dteDate -- (select max(dteDate) from tblpipindexes (NOLOCK) where dteDate<=@dteDate)  
         and a.txtLiquidation='MD'  
        group by a.txtTv,a.txtEmisora,a.txtSerie,a.dblPorcentaje,a.dteDate,a.txtType,a.dblDuracion  
       ) as t2 on t1.txtTv=t2.txtTv and t1.txtEmisora=t2.txtEmisora and t1.txtSerie=t2.txtSerie  
     ) as y1 on x1.txtTv=y1.txtTv and x1.txtEmisora=y1.txtEmisora and x1.txtSerie=y1.txtSerie   
    order by x1.txtTv,x1.txtEmisora,x1.txtSerie  
  
   END  
  
   FETCH NEXT FROM csr_Info_CARTERAS  
   INTO  
    @txtType,  
    @intTaxes,  
    @fType,  
    @txtInternetAlias   
  
  END  
  
  CLOSE csr_Info_CARTERAS  
  DEALLOCATE csr_Info_CARTERAS  
  
  -- Elimino valores NULL  
  UPDATE @tmp_tblResults SET Label13 = '' WHERE Label13 IS NULL  
  UPDATE @tmp_tblResults SET Label14 = '' WHERE Label14 IS NULL  
  UPDATE @tmp_tblResults SET Label15 = '' WHERE Label15 IS NULL  
  UPDATE @tmp_tblResults SET Label16 = '' WHERE Label16 IS NULL  
  UPDATE @tmp_tblResults SET Label17 = '' WHERE Label17 IS NULL  
  UPDATE @tmp_tblResults SET Label18 = '' WHERE Label18 IS NULL  
  UPDATE @tmp_tblResults SET Label19 = '' WHERE Label19 IS NULL  
  UPDATE @tmp_tblResults SET Label20 = '-'  
  UPDATE @tmp_tblResults SET Label21 = '' WHERE Label21 IS NULL  
  UPDATE @tmp_tblResults SET Label22 = '' WHERE Label22 IS NULL  
  UPDATE @tmp_tblResults SET Label23 = '' WHERE Label23 IS NULL  
  UPDATE @tmp_tblResults SET Label24 = '' WHERE Label24 IS NULL  
  UPDATE @tmp_tblResults SET Label25 = '' WHERE Label25 IS NULL  
  UPDATE @tmp_tblResults SET Label26 = '' WHERE Label26 IS NULL  
  
  -- Valida que la información este completa  
  IF ((SELECT count(*) FROM @tmp_tblResults) < 2)  
  BEGIN  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  END  
  
  ELSE  
   -- Reporto Información  
   SELECT  
     RTRIM(Label01),  
     RTRIM(Label02),  
     RTRIM(Label03),  
     RTRIM(Label04),  
     RTRIM(Label05),  
     Label06,  
     Label07,  
     Label08,  
     Label09,  
     Label10,  
     Label11,  
     Label12,  
     Label13,  
     Label14,  
     Label15,  
     Label16,  
     Label17,  
     Label18,  
     Label19,  
     Label20,  
     Label21,  
     Label22,  
     Label23,  
     Label24,  
     Label25,  
     Label26  
   FROM @tmp_tblResults   
  
 SET NOCOUNT OFF   
  
END  
--------------------------------------------------------------------------------------------------  
-- Creado por:    Mike Ramirez  
-- Fecha Modificacion:  11:39 am 20121211  
-- Descripcion Modulo 64: Se redefine la fecha para el calculo del rendimiento acumulado del año  
--------------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_INGBANKMEXICO;64  
  @dteDate AS DATETIME,  
 @txtLiquidation AS VARCHAR(10)  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
  DECLARE @intTaxes AS INT   
  DECLARE @dteLastMonthDate AS DATETIME  
  DECLARE @dteLastYearDate AS DATETIME  
  DECLARE @dteThisYearDate AS DATETIME  
  
  SET @intTaxes = 0   
  
  -- determino el valor de las fechas  
  SET @dteLastMonthDate = (  
   SELECT MxFixIncome.dbo.fun_NextTradingDate(@dteDate, -21, 'MX')  
  )  
  
  SET @dteLastYearDate = (  
   SELECT MxFixIncome.dbo.fun_NextTradingDate(@dteDate, -252, 'MX')  
  )  
   
  SET @dteThisYearDate =  (  
  
   SELECT MAX(dteDate)  
   FROM tblPiPIndexes    
   WHERE  
    dteDate <= SUBSTRING(CONVERT(CHAR(10), @dteDate, 112), 1, 4) + '0102'   
  )  
  
 SET NOCOUNT ON   
  
 DECLARE @tmp_tblPiPBenchmarks TABLE (  
   [C1] VARCHAR(1) NULL,    
   [C2] VARCHAR(50) NULL,   
   [C3] VARCHAR(50) NULL,   
   [C4] VARCHAR(50) NULL,   
   [C5] VARCHAR(50) NULL,   
   [C6] VARCHAR(50) NULL,   
   [C7] VARCHAR(50) NULL,   
   [C8] VARCHAR(50) NULL,   
   [C9] VARCHAR(50) NULL   
  )  
  
 IF @txtLiquidation = '24H'   
     
  BEGIN  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT   
       '0' AS [Seccion],  
     CASE WHEN @intTaxes = '0'     
       THEN 'PiPBenchmarks 24 Horas Bruto'  
       ELSE 'PiPBenchmarks 24 Horas Neto'  
     END AS [Nombre],  
     '' AS [Valor del índice 24 Horas],  
     '' AS [Valor de MercadoMillones de Pesos 24 Horas],  
     '' AS [Rend %1 Día],  
     '' AS [Rend %1 mes],  
     '' AS [Rend %12 meses],  
     '' AS [Rend %Acum en el año],  
     '' AS [Duración]  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT   
      '1' AS [Seccion],    
      'Fecha: ' + CONVERT(CHAR(10),@dteDate,103) AS [Nombre],  
     '' AS [Valor del índice 24 Horas],  
     '' AS [Valor de MercadoMillones de Pesos 24 Horas],  
     '' AS [Rend %1 Día],  
     '' AS [Rend %1 mes],  
     '' AS [Rend %12 meses],  
     '' AS [Rend %Acum en el año],  
     '' AS [Duración]  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT   
      '2' AS [Seccion],    
      'Nombre' AS [Nombre],  
     'Valor del índice 24 Horas' AS [Valor del índice 24 Horas],  
     'Valor de MercadoMillones de Pesos 24 Horas' AS [Valor de MercadoMillones de Pesos 24 Horas],  
     'Rend %1 Día' AS [Rend %1 Día],  
     'Rend %1 mes'AS [Rend %1 mes],  
     'Rend %12 meses'AS [Rend %12 meses],  
     'Rend %Acum en el año'AS [Rend %Acum en el año],  
     'Duración' AS [Duración]  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT   
    '3' AS [Seccion],    
    LTRIM(b.txtInternetAlias) AS [Nombre],  
    LTRIM(STR(i.dblIndex24H,12,6)) AS [Valor del indice 24 Horas],  
    CASE WHEN i.txtType IN ('TFGO','TFB') THEN ''   
        ELSE LTRIM(STR(i.dblSpltiter24H,20,0))   
    END  AS [Valor de MercadoMillones de Pesos 24 Horas],  
  
    CASE   
     WHEN i.dblFactor24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,i.dblFactor24H-1)*100,6,2)) END AS [Rend %1 Día],  
    CASE   
     WHEN i2.dblIndex24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,(i.dblIndex24H/i2.dblIndex24H)-1)*100,6,2)) END AS [Rend %1 mes],  
    CASE  
     WHEN i3.dblIndex24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,(i.dblIndex24H/i3.dblIndex24H)-1)*100,6,2)) END AS [Rend %12 meses],  
    CASE   
     WHEN i4.dblIndex24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,(i.dblIndex24H/i4.dblIndex24H)-1)*100,6,2)) END AS [Rend %Acum en el año],  
  
    CASE WHEN i.dblDuracion24H IS NULL   
     THEN LTRIM(STR(0,10,6))   
     ELSE LTRIM(STR(i.dblDuracion24H,10,6))  
    END AS [Duración]  
   FROM tblPiPIndexes AS i  
    INNER JOIN tblBenchCatalog AS b  
     ON i.txtType = b.txtType  
     AND i.intTaxes = b.intTaxes  
     AND i.intTaxes = @intTaxes  
     AND i.dteDate = @dteDate      -- Fecha Actual  
     AND txtInternetAlias IS NOT NULL  
    LEFT OUTER JOIN tblPiPIndexes AS i2  
     ON i2.txtType = b.txtType  
     AND i2.intTaxes = b.intTaxes  
     AND i2.intTaxes = @intTaxes  
     AND i2.dteDate = @dteLastMonthDate        -- 1 Mes Anterior  
     AND b.txtInternetAlias IS NOT NULL  
    LEFT OUTER JOIN tblPiPIndexes AS i3  
     ON i3.txtType = b.txtType  
     AND i3.intTaxes = b.intTaxes  
     AND i3.intTaxes = @intTaxes  
     AND i3.dteDate = @dteLastYearDate        -- 1 Año Anterior  
     AND b.txtInternetAlias IS NOT NULL  
    LEFT OUTER JOIN tblPiPIndexes AS i4  
     ON i4.txtType = b.txtType  
     AND i4.intTaxes = b.intTaxes  
     AND i4.intTaxes = @intTaxes  
     AND i4.dteDate = @dteThisYearDate        -- Fecha Rendimiento en e1 Año Anterior  
     AND b.txtInternetAlias IS NOT NULL  
   WHERE   
    b.txtType NOT IN ('T028','MX091','FONLIQ','SIECP','FONCP','FONLP','FONMP','SIELP')  
   ORDER BY b.intInternetSerial  
  
  END  
  
 ELSE IF @txtLiquidation = 'MD'   
  
  BEGIN  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT   
       '0' AS [Seccion],    
     CASE WHEN @intTaxes = '0'     
       THEN 'PiPBenchmarks Mismo Dia Bruto'  
       ELSE 'PiPBenchmarks Mismo Dia Neto'  
     END AS [Nombre],  
  
     '' AS [Valor del índice Mismo Día],  
     '' AS [Valor de MercadoMillones de Pesos Mismo Día],  
     '' AS [Rend %1 Día],  
     '' AS [Rend %1 mes],  
     '' AS [Rend %12 meses],  
     '' AS [Rend %Acum en el año],  
     '' AS [Duración]  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT   
      '1' AS [Seccion],    
      'Fecha: ' + CONVERT(CHAR(10),@dteDate,103) AS [Nombre],  
     '' AS [Valor del índice Mismo Día],  
     '' AS [Valor de MercadoMillones de Pesos Mismo Día],  
     '' AS [Rend %1 Día],  
     '' AS [Rend %1 mes],  
     '' AS [Rend %12 meses],  
     '' AS [Rend %Acum en el año],  
     '' AS [Duración]  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT   
      '2' AS [Seccion],    
      'Nombre' AS [Nombre],  
     'Valor del índice Mismo Día' AS [Valor del índice Mismo Día],  
     'Valor de MercadoMillones de Pesos Mismo Día'AS [Valor de MercadoMillones de Pesos Mismo Día],  
     'Rend %1 Día' AS [Rend %1 Día],  
     'Rend %1 mes'AS [Rend %1 mes],  
     'Rend %12 meses'AS [Rend %12 meses],  
     'Rend %Acum en el año'AS [Rend %Acum en el año],  
     'Duración' AS [Duración]  
  
   INSERT @tmp_tblPiPBenchmarks  
   SELECT  
    '3' AS [Seccion],    
    LTRIM(b.txtInternetAlias) AS [Nombre],  
    LTRIM(STR(i.dblIndex,12,6)) AS [Valor del índice Mismo Día],  
    CASE WHEN i.txtType IN ('TFGO','TFB') THEN ''   
        ELSE LTRIM(STR(i.dblSpltiter,20,0))   
    END  AS [Valor de MercadoMillones de Pesos Mismo Día],  
  
    CASE   
     WHEN i.dblFactor24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,i.dblFactor-1)*100,6,2)) END AS [Rend %1 Día],  
    CASE   
     WHEN i2.dblFactor24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,(i.dblIndex/i2.dblIndex)-1)*100,6,2)) END AS [Rend %1 mes],  
    CASE   
     WHEN i3.dblFactor24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,(i.dblIndex/i3.dblIndex)-1)*100,6,2)) END AS [Rend %12 meses],  
    CASE   
     WHEN i4.dblFactor24H IS NULL THEN '' ELSE LTRIM(STR(CONVERT(FLOAT,(i.dblIndex/i4.dblIndex)-1)*100,6,2)) END AS [Rend %Acum en el año],  
  
    LTRIM(STR(0,10,6)) AS [Duración]  
   FROM tblPiPIndexes AS i  
    INNER JOIN tblBenchCatalog AS b  
     ON i.txtType = b.txtType  
     AND i.intTaxes = b.intTaxes  
     AND i.intTaxes = @intTaxes  
     AND i.dteDate = @dteDate     -- Fecha Actual  
     AND txtInternetAlias IS NOT NULL  
    LEFT OUTER JOIN tblPiPIndexes AS i2  
     ON i2.txtType = b.txtType  
     AND i2.intTaxes = b.intTaxes  
     AND i2.intTaxes = @intTaxes  
     AND i2.dteDate = @dteLastMonthDate        -- 1 Mes Anterior  
     AND b.txtInternetAlias IS NOT NULL  
    LEFT OUTER JOIN tblPiPIndexes AS i3  
     ON i3.txtType = b.txtType  
     AND i3.intTaxes = b.intTaxes  
     AND i3.intTaxes = @intTaxes  
     AND i3.dteDate = @dteLastYearDate     -- 1 Año Anterior  
     AND b.txtInternetAlias IS NOT NULL  
    LEFT OUTER JOIN tblPiPIndexes AS i4  
     ON i4.txtType = b.txtType  
     AND i4.intTaxes = b.intTaxes  
     AND i4.intTaxes = @intTaxes  
     AND i4.dteDate = @dteThisYearDate        -- Fecha Rendimiento en e1 Año Anterior  
     AND b.txtInternetAlias IS NOT NULL  
   WHERE  
    b.txtType NOT IN ('BANK>>CP','BANK>>LP','T028','BANK','MX091','D2S','FONLIQ','SIECP',  
        'D1','D1-USD','FONCP','FONLP','FONMP','SIELP','SHF','SHF-MPS','SHF-UDI',  
        'CORP_M','CORP_M>>CP','CORP_M>>LP','D1-USD>>1AP','D1-USD>>5AP','D1-USD>>10AP',  
        'D1-USD>>20AP','D1-USD>>LP','D1-EUR')  
   ORDER BY b.intInternetSerial  
  
  END  
  
 SET NOCOUNT OFF   
  
 SELECT C2,C3,C4,C5,C6,C7,C8,C9   
 FROM @tmp_tblPiPBenchmarks  
  
END  
  
------------------------------------------------------------------  
-- Creado por:    Mike Ramirez  
-- Fecha:     04:35 pm 20130408  
-- Descripcion Modulo 65: Se migra el archivo de SURA_BENCHMARKS  
------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_INGBANKMEXICO;65  
 @dteDate AS DATETIME  
  
AS  
BEGIN  
  
 SET NOCOUNT ON  
   
    DECLARE @tblUniverse TABLE (  
  txtType CHAR(15),  
  fType CHAR(1)  
   PRIMARY KEY(txtType))  
  
 DECLARE @tmp_tblParticipacion TABLE (  
  txtType VARCHAR(15),  
  txtSubPortfolio VARCHAR(20),  
  dblSpltiter24H FLOAT,  
  dblSumDiv24H FLOAT,  
  dblSpltiter FLOAT,  
  dblSumDiv FLOAT,  
  dblWeight FLOAT  
   PRIMARY KEY (txtType,txtSubPortfolio)   
  )  
  
 DECLARE @tmp_tblResultPart TABLE (  
  txtType VARCHAR(15),  
  txtSubPortfolio VARCHAR(20),  
  dblSpltiter24H FLOAT,  
  dblPond24H FLOAT,  
  dblSpltiter FLOAT,  
  dblPond FLOAT,  
  dblWeight FLOAT  
   PRIMARY KEY (txtType,txtSubPortfolio)  
  )  
  
    DECLARE @tblBenchComplexComposition TABLE (  
  txtSuperType CHAR(15),  
  txtType CHAR(15),  
  dblWeight FLOAT,  
  fProcessed BIT  
   PRIMARY KEY(txtSuperType, txtType ))  
  
    DECLARE @tblBenchComposition TABLE (  
  txtType CHAR(15)  
   PRIMARY KEY(txtType))  
  
    DECLARE @tblSuperBenchComposition TABLE (  
  txtSuperType CHAR(15),  
  txtType CHAR(15),  
  dblWeight FLOAT  
   PRIMARY KEY(txtSuperType, txtType ))  
     
 DECLARE @tmp_tblSumPart TABLE (  
  txtType VARCHAR(15),  
  dblSumDiv24H FLOAT,  
  dblSumDiv FLOAT  
   PRIMARY KEY (txtType)   
  )  
  
    DECLARE @tblPortafolioBench TABLE (  
  txtType CHAR(15),  
  txtId1 CHAR(11),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10),  
  txtLiquidation CHAR(3),  
  dblPorcentaje FLOAT,  
  dblDuracion FLOAT,  
  dblPrice FLOAT  
   PRIMARY KEY(txtType, txtId1, txtLiquidation))  
  
    DECLARE @tblPortafolioBench24H TABLE (  
  txtType CHAR(15),  
  txtId1 CHAR(11),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10),  
  txtLiquidation CHAR(3),  
  dblPorcentaje FLOAT,  
  dblDuracion FLOAT,  
  dblPrice FLOAT  
   PRIMARY KEY(txtType, txtId1, txtLiquidation))  
     
    DECLARE @tblPortafolioBenchMD TABLE (  
  txtType CHAR(15),  
  txtId1 CHAR(11),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10),  
  txtLiquidation CHAR(3),  
  dblPorcentaje FLOAT,  
  dblDuracion FLOAT,  
  dblPrice FLOAT  
   PRIMARY KEY(txtType, txtId1, txtLiquidation)  
  )  
     
    DECLARE @tblPiPIndexes TABLE (  
  dteDate DATETIME,  
  txtType CHAR(15),  
  intTaxes INT,  
  dblSpltiter FLOAT,  
  --dblSpltiter FLOAT,  
  dblFactor FLOAT,  
  dblIndex FLOAT,  
  dblSpltiter24H FLOAT,  
  --dblSpltiter24H FLOAT,  
  dblFactor24H FLOAT,  
  dblIndex24H FLOAT,  
  dblDuracion24H FLOAT,  
  dblConvexidad24H FLOAT,  
  dblDuracion FLOAT  
   PRIMARY KEY (dteDate, txtType, intTaxes))  
  
    DECLARE @tblUnifiedPricesReport TABLE (  
  txtId1 VARCHAR(11),  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  txtLiquidation CHAR(4),    
  dblPRL FLOAT,  
  dblPRS FLOAT,  
  dblYTM FLOAT,  
  dblDTM FLOAT,  
  txtDMF VARCHAR(400)   
   PRIMARY KEY (txtId1,txtTv, txtEmisora, txtSerie, txtLiquidation))  
  
    DECLARE @tblWeights TABLE (  
  txtSuperType CHAR(15),  
  dblWeight FLOAT  
   PRIMARY KEY (txtSuperType))  
  
    DECLARE @tblMaxDates TABLE (  
  txtIRC CHAR(7),  
  dteDate DATETIME  
   PRIMARY KEY(txtIRC))  
  
    DECLARE @tblIRCMax TABLE (  
  txtIRC CHAR(7),  
  dteDate DATETIME,  
  dblValue FLOAT  
   PRIMARY KEY(txtIRC,dteDate))  
  
 DECLARE @tblIdsDer TABLE (  
  txtId1 CHAR(11),  
  txtTv CHAR(10),  
  txtIssuer CHAR(10),  
  txtSeries CHAR(10),  
  txtSerial VARCHAR(20)   
   PRIMARY KEY (txtId1))  
  
 -- Tabla para consolidar el resultado  
 DECLARE @tblResult TABLE (  
  txtSupertype CHAR(15),  
  txtType CHAR(15),  
  dteDate CHAR(10),  
  txtInternetAlias VARCHAR(50),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(20),  
  dblPRL24H FLOAT,  
  dblPRS24H FLOAT,  
  dblYTM24H FLOAT,  
  dblDTM24H FLOAT,  
  dblPorcentaje24H FLOAT,  
  txtDMF24H VARCHAR(400),  
  dblDuracion24H FLOAT,  
  dblPRL FLOAT,  
  dblPRS FLOAT,  
  dblYTM FLOAT,  
  dblDTM FLOAT,  
  dblPorcentaje FLOAT,  
  txtDMF VARCHAR(400),  
  dblDuracion FLOAT,  
  txtCom CHAR(1),  
  txtNeto24H CHAR(1),  
  txtDuraNeto24H CHAR(1),  
  txtDuraPortNeto24H CHAR(1),  
  txtNeto CHAR(1),  
  txtDuraNeto CHAR(1),  
  txtDuraPortNeto CHAR(1))  
    
 DECLARE @tmp_tblParticipacion2 TABLE (  
  txtType VARCHAR(15),  
  txtSubPortfolio VARCHAR(20),  
  dblSpltiter24H FLOAT,  
  dblSumDiv24H FLOAT,  
  dblSpltiter FLOAT,  
  dblSumDiv FLOAT,  
  dblWeight FLOAT  
   PRIMARY KEY (txtType,txtSubPortfolio)   
  )  
  
 DECLARE @tmp_tblSumPart2 TABLE (  
  txtType VARCHAR(15),  
  dblSumDiv24H FLOAT,  
  dblSumDiv FLOAT  
   PRIMARY KEY (txtType)   
  )  
  
 DECLARE @tmp_tblResultPart2 TABLE (  
  txtType VARCHAR(15),  
  txtSubPortfolio VARCHAR(20),  
  dblSpltiter24H FLOAT,  
  dblPond24H FLOAT,  
  dblSpltiter FLOAT,  
  dblPond FLOAT,  
  dblWeight FLOAT  
   PRIMARY KEY (txtType,txtSubPortfolio)  
  )  
  
 DECLARE @tmp_tblPartBenchSuper TABLE (  
  txtType VARCHAR(15),  
  txtSubPortfolio VARCHAR(20),  
  dblWeight FLOAT  
   PRIMARY KEY (txtType,txtSubPortfolio)   
  )  
  
 DECLARE @tmp_tblUniversoParalelo TABLE (   
  txtTypeSuper VARCHAR(20),  
  txtType VARCHAR(20),  
  txtSubPortfolio VARCHAR(20),  
  txtLiquidation CHAR(3),  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  dblPor FLOAT  
   PRIMARY KEY (txtTypeSuper,txtType,txtSubPortfolio,txtLiquidation,txtTv,txtEmisora,txtSerie)  
  )  
    
 -- Tabla para consolidar el resultado  
 DECLARE @tblResultCom TABLE (  
  txtSupertype CHAR(15),  
  txtType CHAR(15),  
  dteDate CHAR(10),  
  txtInternetAlias VARCHAR(40),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(20),  
  dblPRL24H FLOAT,  
  dblPRS24H FLOAT,  
  dblYTM24H FLOAT,  
  dblDTM24H FLOAT,  
  dblPorcentaje24H FLOAT,  
  txtDMF24H VARCHAR(50),  
  dblDuracion24H FLOAT,  
  dblPRL FLOAT,  
  dblPRS FLOAT,  
  dblYTM FLOAT,  
  dblDTM FLOAT,  
  dblPorcentaje FLOAT,  
  txtDMF VARCHAR(50),  
  dblDuracion FLOAT,  
  txtCom CHAR(1),  
  txtNeto24H CHAR(1),  
  txtDuraNeto24H CHAR(1),  
  txtDuraPortNeto24H CHAR(1),  
  txtNeto CHAR(1),  
  txtDuraNeto CHAR(1),  
  txtDuraPortNeto CHAR(1)  
  )  
  
 DECLARE @tblPONDuraciones TABLE (  
  txtSupertype CHAR(15),  
  txtType CHAR(15),  
  dblPDur24H FLOAT,  
  dblPDur FLOAT  
   PRIMARY KEY (txtSuperType,txtType)  
   )  
  
 DECLARE @tblSUMDuraciones TABLE (  
  txtSupertype CHAR(15),  
  dblSumDur24H FLOAT,  
  dblSumDur FLOAT  
   PRIMARY KEY (txtSupertype)  
   )  
  
 DECLARE @tblDuraciones TABLE (  
  txtSupertype CHAR(15),  
  txtType CHAR(15),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10),  
  dblPDur24H FLOAT,  
  dblPDur FLOAT  
   PRIMARY KEY (txtSuperType,txtType,txtTv,txtEmisora,txtSerie)  
   )  
  
  -- Obtener el universo de los benchmarks a procesar  
  INSERT @tblUniverse (txtType,ftype)  
   SELECT DISTINCT  
    txtType,  
    'S'  
   FROM MxProcesses.dbo.tblOwnersVsProductsDirectives AS pr (NOLOCK)  
    INNER JOIN MxFixIncome.dbo.tblBenchCatalog AS c (NOLOCK)  
    ON  
     pr.txtDir = c.txtType  
   WHERE  
    pr.txtProductId = 'BENCH_CARTERAS_SURA'  
    AND pr.dteBeg <= @dteDate  
    AND pr.dteEnd >= @dteDate  
    AND c.intTaxes = 0  
  
  -- Obtengo los compuestos  
  UPDATE u  
  SET u.fType = 'C'  
  FROM @tblUniverse AS u  
  WHERE txtType IN (  
       SELECT   
        DISTINCT   
        bcc.txtType  
       FROM MxFixIncome.dbo.tblBenchComplexComposition AS bcc (NOLOCK)  
        INNER JOIN @tblUniverse AS u  
         ON  
          bcc.txtType = u.txtType  
          AND bcc.intTaxes = 0  
          AND bcc.dteBeg <= @dteDate  
          AND bcc.dteEnd >= @dteDate  
      )  
  
  -- Obtengo los superbenchmarks  
  UPDATE u  
  SET u.fType = 'U'  
  FROM @tblUniverse AS u  
  WHERE txtType IN ('SURA_2012','SURA2_2012','SURA3_2012','SURA4_2012')  
  
  INSERT @tblMaxDates(txtIRC,dteDate)  
  SELECT  
   DISTINCT  
   txtIRC,  
   MAX(dteDate)  
  FROM tblIRC  
  WHERE  
   txtIRC IN ('TFG','IRT','SPXT')  
  GROUP BY txtIRC  
  
  INSERT @tblIRCMax (txtIRC,dteDate,dblValue)  
  SELECT  
   d.txtIRC,   
   d.dteDate,  
   i.dblValue  
  FROM tblIRC AS i   
   INNER JOIN @tblMaxDates AS d  
   ON  
    i.txtIRC = d.txtIRC  
    AND i.dteDate = d.dteDate   
  WHERE  
   i.txtIRC IN ('TFG','IRT','SPXT')  
  
  -- Obtenermos la composicion de los benchmarks  
  INSERT @tblBenchComplexComposition(  
   txtSuperType,  
   txtType,  
   dblWeight,  
   fProcessed)  
  
  SELECT DISTINCT   
   c.txtType,  
   c.txtSubPortfolio,  
   c.dblWeight,  
   0  
  FROM @tblUniverse AS u  
  INNER JOIN MxFixIncome.dbo.tblBenchComplexComposition AS c (NOLOCK)  
  ON  
   u.txtType = c.txtType  
  
  WHILE EXISTS(  
   SELECT DISTINCT  
    bc.txtType,  
    bc.txtSubPortfolio  
   FROM @tblBenchComplexComposition AS c  
    INNER JOIN MxFixIncome.dbo.tblBenchComplexComposition AS bc (NOLOCK)  
    ON  
     c.txtType = bc.txtType  
    LEFT OUTER JOIN @tblBenchComplexComposition AS abc   
    ON  
     bc.txtType = abc.txtSuperType  
     AND bc.txtSubPortfolio = abc.txtType  
   WHERE  
    abc.txtType IS NULL)  
  
  BEGIN  
  
   INSERT INTO @tblBenchComplexComposition(  
    txtSuperType,  
    txtType,  
    dblWeight,  
    fProcessed)  
  
   SELECT DISTINCT  
    bc.txtType,  
    bc.txtSubPortfolio,  
    bc.dblWeight,  
    0  
   FROM @tblBenchComplexComposition AS c  
    INNER JOIN MxFixIncome.dbo.tblBenchComplexComposition AS bc (NOLOCK)  
    ON  
     c.txtType = bc.txtType  
    LEFT OUTER JOIN @tblBenchComplexComposition AS abc   
    ON  
     bc.txtType = abc.txtSuperType  
     AND bc.txtSubPortfolio = abc.txtType  
   WHERE  
    abc.txtType IS NULL  
  
  END  
  
  INSERT @tblPortafolioBench(  
   txtType,  
   txtId1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,  
   dblPorcentaje,  
   dblDuracion)  
  
  SELECT DISTINCT    
   b.txtType,  
   b.txtId1,  
   b.txtTv,  
   b.txtEmisora,  
   b.txtSerie,  
   b.txtLiquidation,  
   b.dblPorcentaje,  
   b.dblDuracion  
  FROM @tblBenchComplexComposition AS c  
   INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS b (NOLOCK)  
   ON  
    c.txtType = b.txtType  
  WHERE  
   b.dteDate = @dteDate  
   AND b.txtLiquidation = '24H'  
  
  UNION  
  
  SELECT DISTINCT    
   b.txtType,  
   b.txtId1,  
   b.txtTv,  
   b.txtEmisora,  
   b.txtSerie,  
   b.txtLiquidation,  
   b.dblPorcentaje,  
   b.dblDuracion  
  FROM @tblUniverse AS u  
   INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS b (NOLOCK)  
   ON  
    u.txtType = b.txtType  
  WHERE  
   b.dteDate = @dteDate  
   AND b.txtLiquidation = '24H'  
  
  INSERT @tblPortafolioBench24H (  
   txtType,  
   txtId1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,  
   dblPorcentaje,  
   dblDuracion)  
  
  SELECT DISTINCT    
   b.txtType,  
   b.txtId1,  
   b.txtTv,  
   b.txtEmisora,  
   b.txtSerie,  
   b.txtLiquidation,  
   b.dblPorcentaje,  
   b.dblDuracion  
  FROM @tblBenchComplexComposition AS c  
   INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS b (NOLOCK)  
   ON  
    c.txtType = b.txtType  
  WHERE  
   b.dteDate = @dteDate  
   AND b.txtLiquidation = '24H'     
   
  UNION  
  
  SELECT DISTINCT    
   b.txtType,  
   b.txtId1,  
   b.txtTv,  
   b.txtEmisora,  
   b.txtSerie,  
   b.txtLiquidation,  
   b.dblPorcentaje,  
   b.dblDuracion  
  FROM @tblUniverse u  
   INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS b (NOLOCK)  
   ON  
    u.txtType = b.txtType  
  WHERE  
   b.dteDate = @dteDate  
   AND b.txtLiquidation = '24H'  
     
   INSERT @tblPortafolioBenchMD (txtType,txtId1,txtTv,txtEmisora,txtSerie,txtLiquidation,dblPorcentaje,dblDuracion)  
   SELECT DISTINCT    
    b.txtType,  
    b.txtId1,  
    b.txtTv,  
    b.txtEmisora,  
    b.txtSerie,  
    b.txtLiquidation,  
    b.dblPorcentaje,  
    b.dblDuracion  
   FROM @tblBenchComplexComposition AS c  
    INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS b (NOLOCK)  
    ON  
     c.txtType = b.txtType  
   WHERE  
    b.dteDate = @dteDate  
    AND b.txtLiquidation = 'MD'     
   
  UNION  
  
   SELECT DISTINCT    
    b.txtType,  
    b.txtId1,  
    b.txtTv,  
    b.txtEmisora,  
    b.txtSerie,  
    b.txtLiquidation,  
    b.dblPorcentaje,  
    b.dblDuracion  
   FROM @tblUniverse u  
    INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS b (NOLOCK)  
    ON  
     u.txtType = b.txtType  
   WHERE  
    b.dteDate = @dteDate  
    AND b.txtLiquidation = 'MD'  
  
  -- Obtengo informacion de la fecha a procesar  
  INSERT @tblPiPIndexes(  
   dteDate,  
   txtType,  
   intTaxes,  
   dblSpltiter,  
   --dblSpltiter,  
   dblFactor,  
   dblIndex,  
   dblSpltiter24H,  
   --dblSpltiter24H,  
   dblFactor24H,  
   dblIndex24H,  
   dblDuracion24H,  
   dblConvexidad24H,  
   dblDuracion)  
  SELECT  
   dteDate,  
   txtType,  
   intTaxes,  
   dblSpltiter,  
   --dblSpltiter,  
   dblFactor,  
   dblIndex,  
   dblSpltiter24H,  
   --dblSpltiter24H,  
   dblFactor24H,  
   dblIndex24H,  
   dblDuracion24H,  
   dblConvexidad24H,  
   dblDuracion  
  FROM MxFixIncome.dbo.tblPiPIndexes (NOLOCK)  
  WHERE   
   dteDate = @dteDate  
  
  INSERT @tblUnifiedPricesReport (  
   txtId1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,   
   dblPRL,  
   dblPRS,  
   dblYTM,  
   dblDTM,  
   txtDMF)  
  SELECT  
   txtId1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,   
   dblPRL,  
   dblPRS,  
   dblYTM,  
   dblDTM,  
   txtDMF   
  FROM tmp_tblUnifiedPricesReport (NOLOCK)  
  WHERE   
   txtLiquidation IN ('24H','MD','MP')  
  
  UNION  
  
  SELECT   
   DISTINCT  
   id.txtId1,  
   id.txtTv,  
   id.txtEmisora,  
   id.txtSerie,  
   'MD',  
   i.dblValue,  
   i.dblValue,  
   0,  
   0,  
   ''   
  FROM @tblIRCMax AS i  
   INNER JOIN MxFixIncome.dbo.tblIds AS id (NOLOCK)  
   ON   
    i.txtIRC = id.txtEmisora  
  
  --TRUNCATE TABLE @tblSuperBenchComposition  
  
  UPDATE @tblBenchComplexComposition  
  SET   
   fProcessed = 0  
  
  DECLARE @txtSuperType AS CHAR(15)  
  
   DELETE c  
   FROM @tblBenchComplexComposition AS c  
   LEFT OUTER JOIN @tblBenchComplexComposition AS x  
   ON  
  c.txtType = x.txtSuperType  
   LEFT OUTER JOIN @tblPortafolioBench p   
   ON   
  c.txtType = p.txtType   
  AND p.txtLiquidation = '24H'  
   WHERE   
  p.txtType IS NULL  
  AND x.txtType IS NULL  
   
  -- Obtengo el primer supertype  
  WHILE EXISTS(  
   SELECT DISTINCT TOP 1   
    txtSuperType  
   FROM @tblBenchComplexComposition AS c  
   WHERE  
    c.fProcessed = 0  
   ORDER BY  
    txtSuperType)  
  
  BEGIN  
     
   SELECT  
    @txtSuperType = txtSupertype  
   FROM @tblBenchComplexComposition AS c  
   WHERE  
    c.fProcessed = 0  
   ORDER BY  
    txtSuperType  
      
  -- Obtengo la composicion del super bench  
  INSERT @tblSuperBenchComposition(  
   txtSuperType,  
   txtType,  
   dblWeight)  
  
  SELECT DISTINCT   
   txtSuperType,  
   txtType,  
   dblWeight  
  FROM @tblBenchComplexComposition  
  WHERE  
   txtSuperType = @txtSuperType  
     
  INSERT @tblWeights(  
   txtSuperType,  
   dblWeight)  
  SELECT   
   b.txtSuperType,  
   1.0 / COUNT(b.txtType) AS dblWeight  
  FROM @tblBenchComplexComposition AS b  
  WHERE  
   b.dblWeight = -999  
  GROUP BY  
   b.txtSuperType  
  
  UPDATE c  
  SET   
   c.dblWeight = w.dblWeight  
  FROM @tblBenchComplexComposition AS c  
  INNER JOIN @tblWeights AS w  
  ON  
   c.txtSuperType = w.txtSuperType  
  
   WHILE EXISTS(  
    SELECT DISTINCT TOP 1   
     c.txtType  
    FROM @tblSuperBenchComposition AS c  
    INNER JOIN @tblBenchComplexComposition AS bc  
    ON  
     c.txtType = bc.txtSuperType  
    LEFT OUTER JOIN @tblSuperBenchComposition AS abc   
    ON  
     bc.txtType = abc.txtType  
     AND abc.txtSuperType = @txtSuperType  
    WHERE  
     abc.txtType IS NULL  
     AND c.txtSuperType = @txtSuperType)  
  
   BEGIN  
  
    INSERT @tblSuperBenchComposition(  
     txtSuperType,  
     txtType,  
     dblWeight)  
  
    SELECT DISTINCT  
     @txtSuperType,  
     bc.txtType,  
     c.dblWeight*bc.dblWeight  
    FROM @tblSuperBenchComposition AS c  
    INNER JOIN @tblBenchComplexComposition AS bc  
    ON  
     c.txtType = bc.txtSuperType  
    LEFT OUTER JOIN @tblSuperBenchComposition AS abc   
    ON  
     bc.txtType = abc.txtType  
     AND abc.txtSuperType = @txtSuperType  
    WHERE  
     abc.txtType IS NULL  
     AND c.txtSuperType = @txtSuperType  
  
   END  
  
   UPDATE @tblBenchComplexComposition  
   SET  
    fProcessed = 1  
   WHERE  
    txtSuperType = @txtSuperType  
  
  END  
  
   DELETE s  
   FROM @tblSuperBenchComposition AS s  
   INNER JOIN @tblBenchComplexComposition AS c  
   ON  
    s.txtType = c.txtSuperType  
  
  INSERT @tmp_tblParticipacion (txtType,txtSubPortfolio,dblSpltiter24H,dblSumDiv24H,dblSpltiter,dblSumDiv,dblWeight)   
   SELECT  
    bc.txtType,  
    bc.txtSubPortfolio,  
    i.dblSpltiter24H,  
    NULL,  
    i.dblSpltiter,  
    NULL,  
    bc.dblWeight  
   FROM MxFixIncome.dbo.tblbenchcomplexcomposition AS bc (NOLOCK)  
    INNER JOIN MxFixIncome.dbo.tblpipindexes AS i (NOLOCK)  
    ON   
     bc.txtSubPortfolio = i.txtType  
     AND i.dteDate = @dteDate  
   WHERE  
    bc.intTaxes = 0  
    AND bc.txtType NOT IN ('SIELP')    
   ORDER BY 1  
  
  INSERT @tmp_tblSumPart (txtType,dblSumDiv24H,dblSumDiv)  
   SELECT   
    txtType,  
    SUM(dblSpltiter24H),  
    SUM(dblSpltiter)   
   FROM @tmp_tblParticipacion  
   GROUP BY txtType   
  
  INSERT @tmp_tblResultPart (txtType,txtSubPortfolio,dblSpltiter24H,dblPond24H,dblSpltiter,dblPond,dblWeight)  
   SELECT   
    p.txtType,  
    p.txtSubPortfolio,  
    p.dblSpltiter24H,  
    (p.dblSpltiter24H / s.dblSumDiv24H) AS Pond24H,  
    p.dblSpltiter,  
    (p.dblSpltiter / s.dblSumDiv) AS Pond,  
    p.dblWeight  
   FROM @tmp_tblParticipacion AS p  
    INNER JOIN @tmp_tblSumPart AS s  
    ON   
     p.txtType = s.txtType  
  
  INSERT @tmp_tblParticipacion2 (txtType,txtSubPortfolio,dblSpltiter24H,dblSumDiv24H,dblSpltiter,dblSumDiv,dblWeight)   
   SELECT  
    bc.txtType,  
    bc.txtSubPortfolio,  
    i.dblSpltiter24H,  
    NULL,  
    i.dblSpltiter,  
    NULL,  
    bc.dblWeight  
   FROM MxFixIncome.dbo.tblbenchcomplexcomposition AS bc (NOLOCK)  
    INNER JOIN MxFixIncome.dbo.tblpipindexes AS i (NOLOCK)  
    ON   
     bc.txtSubPortfolio = i.txtType  
     AND i.dteDate = @dteDate  
   WHERE  
    bc.intTaxes = 0  
    AND bc.txtType NOT IN ('SIELP')    
   ORDER BY 1  
  
  INSERT @tmp_tblSumPart2 (txtType,dblSumDiv24H,dblSumDiv)  
   SELECT   
    txtType,  
    SUM(dblSpltiter24H),  
    SUM(dblSpltiter)   
   FROM @tmp_tblParticipacion2  
   GROUP BY txtType  
  
  INSERT @tmp_tblResultPart2 (txtType,txtSubPortfolio,dblSpltiter24H,dblPond24H,dblSpltiter,dblPond,dblWeight)  
   SELECT   
    p.txtType,  
    p.txtSubPortfolio,  
    p.dblSpltiter24H,  
    (p.dblSpltiter24H / s.dblSumDiv24H) AS Pond24H,  
    p.dblSpltiter,  
    (p.dblSpltiter / s.dblSumDiv) AS Pond,  
    p.dblWeight  
   FROM @tmp_tblParticipacion2 AS p  
    INNER JOIN @tmp_tblSumPart2 AS s  
    ON   
     p.txtType = s.txtType  
  
  INSERT @tmp_tblPartBenchSuper (txtType,txtSubPortfolio,dblWeight)  
   SELECT   
    txtType,  
    txtSubPortfolio,  
    dblWeight  
   FROM MxFixIncome.dbo.tblbenchcomplexcomposition (NOLOCK)  
   WHERE  
    txtType IN ('SURA_2012','SURA2_2012','SURA3_2012','SURA4_2012')  
     
  INSERT @tmp_tblUniversoParalelo (txtTypeSuper,txtType,txtSubPortfolio,txtLiquidation,txtTv,txtEmisora,txtSerie,dblPor)  
   SELECT   
    s.txtType,  
    r.txtType,  
    r.txtSubPortfolio,  
    p.txtLiquidation,  
    p.txtTv,  
    p.txtEmisora,  
    p.txtSerie,  
    ((p.dblPorcentaje * r.dblPond24H * s.dblWeight) * 100) AS Porct24H  
   FROM @tmp_tblResultPart2 AS r  
    INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS p (NOLOCK)  
    ON   
     r.txtSubPortfolio = p.txtType   
     AND p.txtLiquidation = '24H'  
    INNER JOIN @tmp_tblPartBenchSuper AS s  
    ON   
     r.txtType = s.txtSubPortfolio  
   WHERE  
     p.dtedate = @dteDate  
     AND r.txtSubPortfolio IN ('2U>>10AP',  
          '2U>>20AP',   
          '2U>>30AP',  
          'M_>>10AP',   
          'M_>>3AP',   
          'M_>>5AP',   
          'PI>>10AP',   
          'PI>>20AP',   
          'S_>>10AP',   
          'S_>>20AP',   
          'S_>>30AP',   
          'S_>>5AP')   
  
  UNION  
  
    SELECT  
    s.txtType,  
    r.txtType,  
    r.txtSubPortfolio,  
    p.txtLiquidation,  
    p.txtTv,  
    p.txtEmisora,  
    p.txtSerie,  
    (p.dblPorcentaje * r.dblPond * s.dblWeight) * 100   
   FROM @tmp_tblResultPart2 AS r  
    INNER JOIN MxFixIncome.dbo.tblPortafolioBench AS p (NOLOCK)  
    ON   
     r.txtSubPortfolio = p.txtType   
     AND p.txtLiquidation = 'MD'  
    INNER JOIN @tmp_tblPartBenchSuper AS s  
    ON   
     r.txtType = s.txtSubPortfolio  
   WHERE  
     p.dtedate = @dteDate  
     AND r.txtSubPortfolio IN ('2U>>10AP',  
          '2U>>20AP',   
          '2U>>30AP',  
          'M_>>10AP',   
          'M_>>3AP',   
          'M_>>5AP',   
          'PI>>10AP',   
          'PI>>20AP',   
          'S_>>10AP',   
          'S_>>20AP',   
          'S_>>30AP',   
          'S_>>5AP')  
   ORDER BY 1,4,5,6  
  
 -- Reportamos el archivo  
 INSERT @tblResultCom (txtSupertype,txtType,dteDate,txtInternetAlias,txtTv,txtEmisora,txtSerie,dblPRL24H,dblPRS24H,dblYTM24H,dblDTM24H,dblPorcentaje24H,txtDMF24H,dblDuracion24H,dblPRL,dblPRS,dblYTM,dblDTM,dblPorcentaje,txtDMF,dblDuracion,txtCom,txtNeto24
H,txtDuraNeto24H,txtDuraPortNeto24H,txtNeto,txtDuraNeto,txtDuraPortNeto)  
  -- Complejos  
  SELECT  
   c.txtSupertype,  
   c.txtType,  
   CONVERT(CHAR(10),@dteDate,103),  
   ca.txtInternetAlias,  
   b.txtTv,  
   b.txtEmisora,  
   b.txtSerie,  
   up.dblPRL,  
   up1.dblPRS,  
   up2.dblYTM,  
   up3.dblDTM,  
   b24.dblPorcentaje,  
   up4.txtDMF,  
   p.dblDuracion24H,  
   up5.dblPRL,   
   up6.dblPRS,  
   up7.dblYTM,  
   up8.dblDTM,  
   bMD.dblPorcentaje,  
   up9.txtDMF,  
   p.dblDuracion,  
   '-',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0'   
  FROM @tblSuperBenchComposition AS c  
   INNER JOIN @tblPortafolioBench AS b  
   ON    
    c.txtType = b.txtType  
   INNER JOIN @tblPortafolioBench24H AS b24  
   ON    
    c.txtType = b24.txtType  
    AND b.txtid1 = b24.txtid1  
   INNER JOIN MxFixIncome.dbo.tblBenchCatalog AS ca (NOLOCK)  
   ON  
    c.txtSuperType = ca.txtType  
    AND ca.intTaxes = 0  
   INNER JOIN @tblUnifiedPricesReport AS up  
   ON   
    b.txtId1 = up.txtId1  
    AND up.txtLiquidation IN ('24H','MP')  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up1  
   ON   
    b.txtId1 = up1.txtId1  
    AND up1.txtLiquidation IN ('24H','MP')   
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up2  
   ON   
    b.txtId1 = up2.txtId1  
    AND up2.txtLiquidation IN ('24H','MP')  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up3  
   ON   
    b.txtId1 = up3.txtId1  
    AND up3.txtLiquidation IN ('24H','MP')  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up4  
   ON   
    b.txtId1 = up4.txtId1  
    AND up4.txtLiquidation IN ('24H','MP')  
   LEFT OUTER JOIN @tblBenchComplexComposition AS bc24  
   ON  
     c.txtSuperType = bc24.txtSuperType   
     AND c.txtType = bc24.txtType   
   LEFT OUTER JOIN @tblPiPIndexes AS p  
   ON  
    c.txtType = p.txtType  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up5  
   ON   
    b.txtId1 = up5.txtId1  
    AND up5.txtLiquidation IN ('MD','MP')  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up6  
   ON   
    b.txtId1 = up6.txtId1  
    AND up6.txtLiquidation IN ('MD','MP')  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up7  
   ON   
    b.txtId1 = up7.txtId1  
    AND up7.txtLiquidation IN ('MD','MP')  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up8  
   ON   
    b.txtId1 = up8.txtId1  
    AND up8.txtLiquidation IN ('MD','MP')  
   LEFT OUTER JOIN @tblUnifiedPricesReport AS up9  
   ON   
    b.txtId1 = up9.txtId1  
    AND up9.txtLiquidation IN ('MD','MP')  
   LEFT OUTER JOIN @tblPortafolioBenchMD bMD  
   ON  
    c.txtType = bMD.txtType   
    AND b.txtid1 = bMD.txtid1   
  
  INSERT @tblDuraciones (txtSupertype,txtType,txtTv,txtEmisora,txtSerie,dblPDur24H,dblPDur)  
   SELECT  
    r.txtSupertype,  
    r.txtType,  
    r.txtTv,  
    r.txtEmisora,  
    r.txtSerie,  
    (r.dblDuracion24H * p.dblPond24H),  
    (r.dblDuracion * p.dblPond)  
   FROM @tblResultCom AS r  
   INNER  JOIN @tmp_tblResultPart AS p  
   ON   
    r.txtSupertype = p.txtType  
    AND r.txtType = p.txtSubPortfolio    
  INSERT @tblPONDuraciones (txtSupertype,txtType,dblPDur24H,dblPDur)  
   SELECT  
    DISTINCT   
     txtSupertype,  
     txtType,  
     dblPDur24H,  
     dblPDur  
   FROM @tblDuraciones  
     
  INSERT @tblSUMDuraciones (txtSupertype,dblSumDur24H,dblSumDur)   
   SELECT   
    DISTINCT  
     txtSupertype,  
     SUM(dblPDur24H),  
     SUM(dblPDur)  
   FROM @tblPONDuraciones  
   GROUP BY txtSupertype  
  
 -- Reportamos el archivo  
 INSERT @tblResult(txtSupertype,txtType,dteDate,txtInternetAlias,txtTv,txtEmisora,txtSerie,dblPRL24H,dblPRS24H,dblYTM24H,dblDTM24H,dblPorcentaje24H,txtDMF24H,dblDuracion24H,dblPRL,dblPRS,dblYTM,dblDTM,dblPorcentaje,txtDMF,dblDuracion,txtCom,txtNeto24H,txt
DuraNeto24H,txtDuraPortNeto24H,txtNeto,txtDuraNeto,txtDuraPortNeto)  
   SELECT   
   '',   
   b.txtType,  
   CONVERT(CHAR(10),@dteDate,103),  
   ca.txtInternetAlias,  
   b.txtTv,  
   b.txtEmisora,  
   b.txtSerie,  
   up.dblPRL,  
   up1.dblPRS,  
   up2.dblYTM,  
   up3.dblDTM,  
   b24.dblPorcentaje * 100,  
   up4.txtDMF,  
   p.dblDuracion24H,  
   up5.dblPRL,   
   up6.dblPRS,  
   up7.dblYTM,  
   up8.dblDTM,  
   CASE  
    WHEN u.txtType = 'CKD_2012' THEN b24.dblPorcentaje * 100  
    WHEN u.txtType = 'SURA_90_MPS_FLO' THEN b24.dblPorcentaje * 100  
    WHEN u.txtType = 'SURA_90_MPS_FIX' THEN b24.dblPorcentaje * 100  
    WHEN u.txtType = 'SURA_90_UDI_FIX' THEN b24.dblPorcentaje * 100  
    WHEN bMD.dblPorcentaje IS NULL THEN 0  
   ELSE bMD.dblPorcentaje * 100  
   END,  
   up9.txtDMF,  
   CASE   
    WHEN p.dblDuracion IS NULL THEN 0  
   ELSE p.dblDuracion  
   END,  
   '-',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0'  
  FROM @tblUniverse AS u  
  INNER JOIN @tblPortafolioBench AS b   
  ON  
   u.txtType = b.txtType  
  INNER JOIN @tblPortafolioBench24H AS b24  
  ON    
   u.txtType = b24.txtType  
   AND b.txtid1 = b24.txtid1  
  INNER JOIN MxFixIncome.dbo.tblBenchCatalog AS ca (NOLOCK)  
  ON  
   u.txtType = ca.txtType  
   AND ca.intTaxes = 0  
  INNER JOIN @tblUnifiedPricesReport AS up  
  ON   
   b.txtId1 = up.txtId1  
   AND up.txtLiquidation IN ('24H','MP')  
  LEFT OUTER JOIN @tblUnifiedPricesReport AS up1  
  ON   
   b.txtId1 = up1.txtId1  
   AND up1.txtLiquidation IN ('24H','MP')  
  LEFT OUTER JOIN @tblUnifiedPricesReport AS up2  
  ON   
   b.txtId1 = up2.txtId1  
   AND up2.txtLiquidation IN ('24H','MP')  
  LEFT OUTER JOIN @tblUnifiedPricesReport up3  
  ON   
   b.txtId1 = up3.txtId1  
   AND up3.txtLiquidation IN ('24H','MP')  
  LEFT OUTER JOIN @tblUnifiedPricesReport up4  
  ON   
   b.txtId1 = up4.txtId1  
   AND up4.txtLiquidation IN ('24H','MP')  
  LEFT OUTER JOIN @tblPiPIndexes p  
  ON  
   u.txtType = p.txtType  
  LEFT OUTER JOIN @tblUnifiedPricesReport up5  
  ON   
   b.txtId1 = up5.txtId1  
   AND up5.txtLiquidation IN ('MD','MP')  
  LEFT OUTER JOIN @tblUnifiedPricesReport up6  
  ON   
   b.txtId1 = up6.txtId1  
   AND up6.txtLiquidation IN ('MD','MP')  
  LEFT OUTER JOIN @tblUnifiedPricesReport up7  
  ON   
   b.txtId1 = up7.txtId1  
   AND up7.txtLiquidation IN ('MD','MP')  
  LEFT OUTER JOIN @tblUnifiedPricesReport up8  
  ON   
   b.txtId1 = up8.txtId1  
   AND up8.txtLiquidation IN ('MD','MP')   
  LEFT OUTER JOIN @tblUnifiedPricesReport up9  
  ON   
   b.txtId1 = up9.txtId1  
   AND up9.txtLiquidation IN ('MD','MP')  
  LEFT OUTER JOIN @tblPortafolioBenchMD bMD  
  ON  
   u.txtType = bMD.txtType   
   AND b.txtid1 = bMD.txtid1  
    WHERE  
      u.ftype = 'S'  
   
 UNION  
  
 -- Para obtener los compuestos  
  SELECT    
   r.txtSupertype,  
   r.txtType,  
   r.dteDate,  
   r.txtInternetAlias,  
   r.txtTv,  
   r.txtEmisora,  
   r.txtSerie,  
   STR(ROUND(r.dblPRL24H,6),16,6),  
   STR(ROUND(r.dblPRS24H,6),16,6),  
   STR(ROUND(r.dblYTM24H,6),13,6),  
   r.dblDTM24H,  
   CASE   
    WHEN r.txtSuperType = 'SURA_2012' AND r.txtType = 'FD_2012' THEN (1*-0.0828)*100    
    WHEN r.txtSuperType = 'SURA2_2012' AND r.txtType = 'FD_2012' THEN (1*-0.0092)*100  
    WHEN r.txtSuperType = 'SURA3_2012' AND r.txtType = 'FD_2012' THEN (1*-0.0578)*100  
    WHEN r.txtSuperType = 'SURA4_2012' AND r.txtType = 'FD_2012' THEN (1*-0.1472)*100  
   ELSE (r.dblPorcentaje24H * rp.dblPond24H)*100  
   END,  
   CASE   
    WHEN  
     r.txtDMF24H = '' THEN 'NA'  
   ELSE r.txtDMF24H  
   END,  
   STR(ROUND(d.dblSumDur24H,6),9,6),  
   STR(ROUND(r.dblPRL,6),16,6),  
   STR(ROUND(r.dblPRS,6),16,6),  
   STR(ROUND(r.dblYTM,6),13,6),  
   r.dblDTM,  
   CASE   
    WHEN r.txtSuperType = 'SURA_2012' AND r.txtType = 'FD_2012' THEN (1*-0.0828)*100    
    WHEN r.txtSuperType = 'SURA2_2012' AND r.txtType = 'FD_2012' THEN (1*-0.0092)*100  
    WHEN r.txtSuperType = 'SURA3_2012' AND r.txtType = 'FD_2012' THEN (1*-0.0578)*100  
    WHEN r.txtSuperType = 'SURA4_2012' AND r.txtType = 'FD_2012' THEN (1*-0.1472)*100  
    WHEN r.dblPorcentaje IS NULL THEN 0  
   ELSE (r.dblPorcentaje * rp.dblPond) * 100   
   END,  
   CASE  
    WHEN   
     r.txtDMF = '' THEN 'NA'  
   ELSE r.txtDMF  
   END,  
   STR(ROUND(d.dblSumDur,6),9,6),  
   r.txtCom,  
   r.txtNeto24H,  
   r.txtDuraNeto24H,  
   r.txtDuraPortNeto24H,  
   r.txtNeto,  
   r.txtDuraNeto,  
   r.txtDuraPortNeto  
  FROM @tblResultCom AS r  
   LEFT OUTER JOIN @tmp_tblResultPart AS rp  
   ON   
    r.txtSupertype = rp.txtType  
    AND r.txtType = rp.txtSubPortfolio   
   LEFT OUTER JOIN @tblSUMDuraciones as d  
   ON  
    r.txtSupertype = d.txtSupertype  
     
   UNION  
      
  SELECT   
   'SURA_2012',  
   CASE  
    WHEN txtEmisora = 'TFG' THEN 'FONDGUBN'  
    WHEN txtEmisora = 'IRT' THEN 'NAF_2012'  
    WHEN txtEmisora = 'SPXT' THEN 'SPY_2012'  
   ELSE ''  
   END,  
   CONVERT(CHAR(10),@dteDate,103),  
   'SURA_C3',  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   dblPRL,  
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.02 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.092 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.138 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   dblPRL,   
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.02 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.092 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.138 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   '-',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0'  
  FROM @tblUnifiedPricesReport AS p  
  WHERE   
   txtEmisora IN ('TFG','IRT','SPXT')  
   AND txtLiquidation = 'MD'  
  
   UNION  
      
  SELECT   
   'SURA2_2012',  
   CASE  
    WHEN txtEmisora = 'TFG' THEN 'FONDGUBN'  
    WHEN txtEmisora = 'IRT' THEN 'NAF_2012'  
    WHEN txtEmisora = 'SPXT' THEN 'SPY_2012'  
   ELSE ''  
   END,  
   CONVERT(CHAR(10),@dteDate,103),  
   'SURA_C1',  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   dblPRL,  
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.05 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.0154 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.0231 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   dblPRL,   
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.05 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.0154 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.0231 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   '-',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0'  
  FROM @tblUnifiedPricesReport AS p  
  WHERE   
   txtEmisora IN ('TFG','IRT','SPXT')  
   AND txtLiquidation = 'MD'  
  
 UNION   
  
  SELECT   
   'SURA3_2012',  
   CASE  
    WHEN txtEmisora = 'TFG' THEN 'FONDGUBN'  
    WHEN txtEmisora = 'IRT' THEN 'NAF_2012'  
    WHEN txtEmisora = 'SPXT' THEN 'SPY_2012'  
   ELSE ''  
   END,  
   CONVERT(CHAR(10),@dteDate,103),  
   'SURA_C2',  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   dblPRL,  
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.04 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.077 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.1155 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   dblPRL,   
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.04 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.077 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.1155 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   '-',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0'  
  FROM @tblUnifiedPricesReport AS p  
  WHERE   
   txtEmisora IN ('TFG','IRT','SPXT')  
   AND txtLiquidation = 'MD'  
  
  UNION  
  
  SELECT   
   'SURA4_2012',  
   CASE  
    WHEN txtEmisora = 'TFG' THEN 'FONDGUBN'  
    WHEN txtEmisora = 'IRT' THEN 'NAF_2012'  
    WHEN txtEmisora = 'SPXT' THEN 'SPY_2012'  
   ELSE ''  
   END,  
   CONVERT(CHAR(10),@dteDate,103),  
   'SURA_C4',  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   dblPRL,  
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.005 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.123 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.184 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   dblPRL,   
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (0.005 * 100)  
    WHEN txtEmisora = 'IRT' THEN (0.123 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (0.184 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   '-',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0'  
  FROM @tblUnifiedPricesReport AS p  
  WHERE   
   txtEmisora IN ('TFG','IRT','SPXT')  
   AND txtLiquidation = 'MD'  
  
  UNION  
  
  SELECT   
   '',  
   CASE  
    WHEN txtEmisora = 'TFG' THEN 'FONDGUBN'  
    WHEN txtEmisora = 'IRT' THEN 'NAF_2012'  
    WHEN txtEmisora = 'SPXT' THEN 'SPY_2012'  
   ELSE ''  
   END,  
   CONVERT(CHAR(10),@dteDate,103),  
   CASE  
    WHEN txtEmisora = 'TFG' THEN 'SURA_FONDGUBN'  
    WHEN txtEmisora = 'IRT' THEN 'SURA_NAF'  
    WHEN txtEmisora = 'SPXT' THEN 'SURA_SPY'  
   ELSE ''  
   END,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   dblPRL,  
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (1 * 100)  
    WHEN txtEmisora = 'IRT' THEN (1 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (1 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   dblPRL,   
   dblPRS,  
   dblYTM,  
   dblDTM,  
   CASE  
    WHEN txtEmisora = 'TFG' THEN (1 * 100)  
    WHEN txtEmisora = 'IRT' THEN (1 * 100)  
    WHEN txtEmisora = 'SPXT' THEN (1 * 100)  
   ELSE ''  
   END,  
   txtDMF,  
   '0',  
   '-',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0',  
   '0'  
  FROM @tblUnifiedPricesReport AS p  
  WHERE   
   txtEmisora IN ('TFG','IRT','SPXT')  
   AND txtLiquidation = 'MD'   
    
 INSERT @tblIdsDer (txtId1,txtTv,txtIssuer,txtSeries,txtSerial)  
  SELECT   
   i.txtId1,  
   i.txtTv,  
   i.txtIssuer,  
   i.txtSeries,  
   RTRIM(i.txtSeries) + '_' + RTRIM(i.txtSerial)  
  FROM @tblUnifiedPricesReport AS u  
   INNER JOIN @tblPortafolioBench AS p  
   ON  
    u.txtId1 = p.txtId1  
   INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
   ON  
    u.txtId1 = i.txtId1  
  WHERE  
   u.txtTv = 'FD'  
   AND u.txtEmisora = 'DEUA'  
   
     
 UPDATE r  
  SET r.txtSerie = i.txtSerial   
 FROM @tblResult AS r  
  INNER JOIN @tblIdsDer AS i  
  ON r.txtTv = i.txtTv  
  AND r.txtEmisora = i.txtIssuer  
  AND r.txtSerie = i.txtSeries  
 WHERE  
  r.txtTv = 'FD'  
  AND r.txtEmisora = 'DEUA'   
  
 UPDATE r  
  SET r.dblPorcentaje24H = p.dblPor  
 FROM @tblResult AS r  
  INNER JOIN @tmp_tblUniversoParalelo AS p  
  ON   
   r.txtSupertype = p.txtTypeSuper  
   AND r.txtTv = p.txtTv  
   AND r.txtEmisora = p.txtEmisora  
   AND r.txtSerie = p.txtSerie  
 WHERE  
   p.txtLiquidation = '24H'  
  
 UPDATE r  
  SET r.dblPorcentaje = p.dblPor  
 FROM @tblResult AS r  
  INNER JOIN @tmp_tblUniversoParalelo AS p  
  ON   
   r.txtSupertype = p.txtTypeSuper  
   AND r.txtTv = p.txtTv  
   AND r.txtEmisora = p.txtEmisora  
   AND r.txtSerie = p.txtSerie  
 WHERE  
   p.txtLiquidation = 'MD'  
  
 --Reportamos el archivo  
 SELECT    
  RTRIM(dteDate),  
  RTRIM(txtInternetAlias),  
  RTRIM(txtTv),  
  RTRIM(txtEmisora),  
  RTRIM(txtSerie),  
  STR(ROUND(dblPRL24H,6),16,6),  
  STR(ROUND(dblPRS24H,6),16,6),  
  STR(ROUND(dblYTM24H,6),13,6),  
  dblDTM24H,  
  STR(ROUND(dblPorcentaje24H,6),10,6),  
  CASE   
   WHEN  
    txtDMF24H = '' THEN 'NA'  
  ELSE txtDMF24H  
  END,  
  STR(ROUND(dblDuracion24H,6),9,6),  
  STR(ROUND(dblPRL,6),16,6),  
  STR(ROUND(dblPRS,6),16,6),  
  STR(ROUND(dblYTM,6),13,6),  
  dblDTM,  
  STR(ROUND(dblPorcentaje,6),10,6),  
  CASE  
   WHEN   
    txtDMF = '' THEN 'NA'  
  ELSE txtDMF  
  END,  
  STR(ROUND(dblDuracion,6),9,6),  
  RTRIM(txtCom),  
  RTRIM(txtNeto24H),  
  RTRIM(txtDuraNeto24H),  
  RTRIM(txtDuraPortNeto24H),  
  RTRIM(txtNeto),  
  RTRIM(txtDuraNeto),  
  RTRIM(txtDuraPortNeto)  
 FROM @tblResult  
    
  SET NOCOUNT OFF   
  
END  
  