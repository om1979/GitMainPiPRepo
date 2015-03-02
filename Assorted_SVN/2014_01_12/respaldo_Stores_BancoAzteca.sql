 CREATE PROCEDURE dbo.sp_productos_BANCOAZTECA;1  
 @txtDate AS VARCHAR(10)  
  
 /*   
   Version 1.0    
     
    Procedimiento que genera PRODUCTO de Factores de Riesgo para BANCOAZTECA  
      Elaborado por :  Lic. René López Salinas  
    Fecha: 18-Abr-2006  
 */  
  
 AS   
 BEGIN  
  
 SET NOCOUNT ON   
  
        SELECT -999 AS [Columm],'XXXXXXXXXXXXXXXXXXXXXXXXX' AS [Label],'XXXXXXXXXX' AS [Source],'XXXXXXXXXX' AS [IRCcode],'XXX' AS [Type],'XXX' AS [SubType],'-99999' AS [Nodo],'XXX' AS [Item],'XXXXXXXXXXXXXXX' AS [TVs],'-999' AS [HLD],'-999' AS [Factor]  
 INTO #tmp_tblFRBancoAzteca  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 1 AS [Columm],'Fecha' AS [Label],'DATE()' AS [Source],'DD/MM/YYYY' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 2 AS [Columm],'IPC' AS [Label],'IRC' AS [Source],'IPC' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 3 AS [Columm],'IND.SOC.INV.COM.' AS [Label],'IRC' AS [Source],'ISOC1' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 4 AS [Columm],'IND.SOC.DEUDA P.F.' AS [Label],'IRC' AS [Source],'ISOC2' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 5 AS [Columm],'IND.SOC.DEUDA P.M.' AS [Label],'IRC' AS [Source],'ISOC3' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 6 AS [Columm],'MEXIBOR 28' AS [Label],'IRC' AS [Source],'MX028' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 7 AS [Columm],'MEXIBOR 91' AS [Label],'IRC' AS [Source],'MX091' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 8 AS [Columm],'MEXIBOR 180' AS [Label],'IRC' AS [Source],'MX180' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 9 AS [Columm],'MEXIBOR 270' AS [Label],'IRC' AS [Source],'MX270' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 10 AS [Columm],'MEXIBOR 360' AS [Label],'IRC' AS [Source],'MX360' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 11 AS [Columm],'FIX' AS [Label],'IRC' AS [Source],'UFXU' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 12 AS [Columm],'Reporto Bancario 1' AS [Label],'CURVES' AS [Source],'RB001' AS [IRCcode],'RB1' AS [Type],'B1' AS [SubType],'1' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 13 AS [Columm],'Reporto Bancario 7' AS [Label],'CURVES' AS [Source],'RB007' AS [IRCcode],'RB1' AS [Type],'B1' AS [SubType],'7' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 14 AS [Columm],'Reporto Bancario 28' AS [Label],'CURVES' AS [Source],'RB028' AS [IRCcode],'RB1' AS [Type],'B1' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 15 AS [Columm],'Reporto Bancario 91' AS [Label],'CURVES' AS [Source],'RB091' AS [IRCcode],'RB1' AS [Type],'B1' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 16 AS [Columm],'Reporto Bancario 182' AS [Label],'CURVES' AS [Source],'RB182' AS [IRCcode],'RB1' AS [Type],'B1' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
      SELECT 17 AS [Columm],'Reporto Bancario 360' AS [Label],'CURVES' AS [Source],'RB360' AS [IRCcode],'RB1' AS [Type],'B1' AS [SubType],'360' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 18 AS [Columm],'Reporto Gubernamental 1' AS [Label],'CURVES' AS [Source],'RG001' AS [IRCcode],'RG1' AS [Type],'G1' AS [SubType],'1' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 19 AS [Columm],'Reporto Gubernamental 7' AS [Label],'CURVES' AS [Source],'RG007' AS [IRCcode],'RG1' AS [Type],'G1' AS [SubType],'7' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 20 AS [Columm],'Reporto Gubernamental 28' AS [Label],'CURVES' AS [Source],'RG028' AS [IRCcode],'RG1' AS [Type],'G1' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 21 AS [Columm],'Reporto Gubernamental 91' AS [Label],'CURVES' AS [Source],'RG091' AS [IRCcode],'RG1' AS [Type],'G1' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 22 AS [Columm],'Reporto Gubernamental 182' AS [Label],'CURVES' AS [Source],'RG182' AS [IRCcode],'RG1' AS [Type],'G1' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 23 AS [Columm],'Reporto Gubernamental 360' AS [Label],'CURVES' AS [Source],'RG360' AS [IRCcode],'RG1' AS [Type],'G1' AS [SubType],'360' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 24 AS [Columm],'CETES 1' AS [Label],'CURVES' AS [Source],'ICI001' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'1' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 25 AS [Columm],'CETES 7' AS [Label],'CURVES' AS [Source],'ICI007' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'7' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 26 AS [Columm],'CETES 28' AS [Label],'CURVES' AS [Source],'ICI028' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 27 AS [Columm],'CETES 91' AS [Label],'CURVES' AS [Source],'ICI091' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 28 AS [Columm],'CETES 182' AS [Label],'CURVES' AS [Source],'ICI182' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 29 AS [Columm],'CETES 278' AS [Label],'CURVES' AS [Source],'ICI278' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'278' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 30 AS [Columm],'CETES 364' AS [Label],'CURVES' AS [Source],'ICI364' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 31 AS [Columm],'CETES 728' AS [Label],'CURVES' AS [Source],'ICI728' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'728' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 32 AS [Columm],'CETES 1092' AS [Label],'CURVES' AS [Source],'ICI3YR' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'1092' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 33 AS [Columm],'CETES 1456' AS [Label],'CURVES' AS [Source],'ICI4YR' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'1456' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 34 AS [Columm],'CETES 1820' AS [Label],'CURVES' AS [Source],'ICI5YR' AS [IRCcode],'CET' AS [Type],'CTI' AS [SubType],'1820' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 35 AS [Columm],'PAGARES 1' AS [Label],'CURVES' AS [Source],'IP001' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'1' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 36 AS [Columm],'PAGARES 7' AS [Label],'CURVES' AS [Source],'IP007' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'7' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 37 AS [Columm],'PAGARES 28' AS [Label],'CURVES' AS [Source],'IP028' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 38 AS [Columm],'PAGARES 91' AS [Label],'CURVES' AS [Source],'IP091' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 39 AS [Columm],'PAGARES 182' AS [Label],'CURVES' AS [Source],'IP182' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 40 AS [Columm],'PAGARES 278' AS [Label],'CURVES' AS [Source],'IP278' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'278' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 41 AS [Columm],'PAGARES 364' AS [Label],'CURVES' AS [Source],'IP364' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 42 AS [Columm],'PAGARES 728' AS [Label],'CURVES' AS [Source],'IP728' AS [IRCcode],'PLV' AS [Type],'3A' AS [SubType],'728' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 43 AS [Columm],'Papel Comercial AAA' AS [Label],'IRC' AS [Source],'SPAAA' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 44 AS [Columm],'UDI' AS [Label],'IRC' AS [Source],'UDI' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 45 AS [Columm],'NASDAQ' AS [Label],'IRC' AS [Source],'NQX' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 46 AS [Columm],'DOW' AS [Label],'IRC' AS [Source],'INDU' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 47 AS [Columm],'EURO' AS [Label],'IRC' AS [Source],'EUR' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 48 AS [Columm],'Costo Porc. Prom' AS [Label],'IRC' AS [Source],'CPP' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 49 AS [Columm],'Tasa Real 91' AS [Label],'CURVES' AS [Source],'TR091' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 50 AS [Columm],'Tasa Real 182' AS [Label],'CURVES' AS [Source],'TR182' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 51 AS [Columm],'Tasa Real 364' AS [Label],'CURVES' AS [Source],'TR364' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 52 AS [Columm],'Tasa Real 728' AS [Label],'CURVES' AS [Source],'TR728' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'728' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 53 AS [Columm],'Tasa Real 1092' AS [Label],'CURVES' AS [Source],'TRM09' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'1092' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 54 AS [Columm],'Tasa Real 1830' AS [Label],'CURVES' AS [Source],'TRM83' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'1830' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 55 AS [Columm],'Tasa Real 2550' AS [Label],'CURVES' AS [Source],'TRY07' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'2540' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 56 AS [Columm],'Tasa Real 3630' AS [Label],'CURVES' AS [Source],'TRY10' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'3620' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 57 AS [Columm],'Tasa Real 7290' AS [Label],'CURVES' AS [Source],'TRY20' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'7290' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 58 AS [Columm],'Tasa Real 10920' AS [Label],'CURVES' AS [Source],'TRY30' AS [IRCcode],'UDB' AS [Type],'U%' AS [SubType],'10930' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 59 AS [Columm],'TNOTES USGG2YR' AS [Label],'IRC' AS [Source],'TNY02' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 60 AS [Columm],'TNOTES USGG5YR' AS [Label],'IRC' AS [Source],'TNY05' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 61 AS [Columm],'TNOTES USGG10YR' AS [Label],'IRC' AS [Source],'TNY10' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 62 AS [Columm],'TNOTES USGG30YR' AS [Label],'IRC' AS [Source],'TNY30' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 63 AS [Columm],'Treasuris 0/N' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'1' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 64 AS [Columm],'Treasuris 1WK' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'7' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 65 AS [Columm],'Treasuris 2WK' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'14' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 66 AS [Columm],'Treasuris 1MO' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'30' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 67 AS [Columm],'Treasuris 2MO' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'60' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 68 AS [Columm],'Treasuris 3MO' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 69 AS [Columm],'Treasuris 6MO' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 70 AS [Columm],'Treasuris 9MO' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'270' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 71 AS [Columm],'Treasuris 1YR' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 72 AS [Columm],'Treasuris 2YR' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'720' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 73 AS [Columm],'Treasuris 3YR' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'1092' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 74 AS [Columm],'Treasuris 4YR' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'1456' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 75 AS [Columm],'Treasuris 5YR' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TSN' AS [Type],'YLD' AS [SubType],'1820' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 76 AS [Columm],'BONDES28 28' AS [Label],'CURVES' AS [Source],'IB028' AS [IRCcode],'BDE' AS [Type],'OL' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 77 AS [Columm],'BONDES28 364' AS [Label],'CURVES' AS [Source],'IB364' AS [IRCcode],'BDE' AS [Type],'OL' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 78 AS [Columm],'BONDES28 728' AS [Label],'CURVES' AS [Source],'IB728' AS [IRCcode],'BDE' AS [Type],'OL' AS [SubType],'728' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 79 AS [Columm],'BONDES91 364' AS [Label],'CURVES' AS [Source],'IT364' AS [IRCcode],'BDE' AS [Type],'NW' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 80 AS [Columm],'BONDES91 728' AS [Label],'CURVES' AS [Source],'IT728' AS [IRCcode],'BDE' AS [Type],'NW' AS [SubType],'728' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 81 AS [Columm],'BONDES91 1092' AS [Label],'CURVES' AS [Source],'ITM09' AS [IRCcode],'BDE' AS [Type],'NW' AS [SubType],'1092' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 82 AS [Columm],'BONDES182 1092' AS [Label],'CURVES' AS [Source],'ISM82' AS [IRCcode],'BDE' AS [Type],'SE' AS [SubType],'1000' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 83 AS [Columm],'Spread Mex05' AS [Label],'IRC' AS [Source],'SX005' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 84 AS [Columm],'Spread Mex06' AS [Label],'IRC' AS [Source],'SX006' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 85 AS [Columm],'Spread Mex07' AS [Label],'IRC' AS [Source],'SX007' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 86 AS [Columm],'Spread Mex08' AS [Label],'IRC' AS [Source],'SX008' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 87 AS [Columm],'Spread Mex09' AS [Label],'IRC' AS [Source],'SX009' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 88 AS [Columm],'Spread Mex10' AS [Label],'IRC' AS [Source],'SX010' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 89 AS [Columm],'Spread Mex11' AS [Label],'IRC' AS [Source],'SX011' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 90 AS [Columm],'Spread Mex16' AS [Label],'IRC' AS [Source],'SX016' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 91 AS [Columm],'Spread Mex19' AS [Label],'IRC' AS [Source],'SX019' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 92 AS [Columm],'Spread Mex26' AS [Label],'IRC' AS [Source],'SX026' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 93 AS [Columm],'Cetes Subasta 28' AS [Label],'IRC' AS [Source],'SC028' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 94 AS [Columm],'Cetes Subasta 91' AS [Label],'IRC' AS [Source],'SC091' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 95 AS [Columm],'Cetes Subasta 182' AS [Label],'IRC' AS [Source],'SC182' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 96 AS [Columm],'Cetes Subasta 364' AS [Label],'IRC' AS [Source],'SC364' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 97 AS [Columm],'TIIE 28' AS [Label],'IRC' AS [Source],'T028' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 98 AS [Columm],'TIIE 91' AS [Label],'IRC' AS [Source],'T091' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 99 AS [Columm],'LIBOR 1' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'1' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 100 AS [Columm],'LIBOR 7' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'7' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 101 AS [Columm],'LIBOR 28' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 102 AS [Columm],'LIBOR 30' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'30' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 103 AS [Columm],'LIBOR 90' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'90' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 104 AS [Columm],'LIBOR 91' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 105 AS [Columm],'LIBOR 180' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'180' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 106 AS [Columm],'LIBOR 182' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 107 AS [Columm],'LIBOR 278' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'278' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 108 AS [Columm],'LIBOR 360' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'360' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 109 AS [Columm],'LIBOR 720' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'720' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 110 AS [Columm],'LIBOR 728' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'728' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 111 AS [Columm],'LIBOR 1080' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'1080' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 112 AS [Columm],'LIBOR 1092' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'1092' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 113 AS [Columm],'LIBOR 1800' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'1800' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 114 AS [Columm],'LIBOR 3600' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'LIB' AS [Type],'BL' AS [SubType],'3600' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 115 AS [Columm],'M5 1080' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'1080' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 116 AS [Columm],'M5 1300' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'1300' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 117 AS [Columm],'M5 1500' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'1500' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 118 AS [Columm],'M5 1800' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'1800' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 119 AS [Columm],'M3 200' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'200' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 120 AS [Columm],'M3 600' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'600' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 121 AS [Columm],'M3 720' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'720' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 122 AS [Columm],'M3 900' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'900' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 123 AS [Columm],'M7 2548' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'2548' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 124 AS [Columm],'M0 3640' AS [Label],'PRICES' AS [Source],'BONOSM' AS [IRCcode],'' AS [Type],'' AS [SubType],'3640' AS [Nodo],'YTM' AS [Item],'M;M0;M7;M5;M3' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 125 AS [Columm],'Yield Maturity 91' AS [Label],'CURVES' AS [Source],'YM091' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'91' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 126 AS [Columm],'Yield Maturity 182' AS [Label],'CURVES' AS [Source],'YM182' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'182' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 127 AS [Columm],'Yield Maturity 364' AS [Label],'CURVES' AS [Source],'YM364' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 128 AS [Columm],'Yield Maturity 728' AS [Label],'CURVES' AS [Source],'YM728' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'728' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 129 AS [Columm],'Yield Maturity 1092' AS [Label],'CURVES' AS [Source],'YMM09' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'1092' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 130 AS [Columm],'Yield Maturity 1830' AS [Label],'CURVES' AS [Source],'YMM83' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'1830' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 131 AS [Columm],'Yield Maturity 2540' AS [Label],'CURVES' AS [Source],'YMY07' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'2540' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 132 AS [Columm],'Yield Maturity 3630' AS [Label],'CURVES' AS [Source],'YMY10' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'3620' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 133 AS [Columm],'Yield Maturity 7290' AS [Label],'CURVES' AS [Source],'YMY20' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'7290' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor] UNION   
               SELECT 134 AS [Columm],'Yield Maturity 10930' AS [Label],'CURVES' AS [Source],'YMY30' AS [IRCcode],'UDB' AS [Type],'YLD' AS [SubType],'10930' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'1' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 135 AS [Columm],'TFB' AS [Label],'IRC' AS [Source],'TFB' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 136 AS [Columm],'TFG' AS [Label],'IRC' AS [Source],'TFG' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 137 AS [Columm],'INMEX' AS [Label],'IRC' AS [Source],'INM' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 138 AS [Column],'PiP-Guber' AS [Label],'BENCHMARKS' AS [Source],'PIPGUBMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 139 AS [Column],'PiPG-Cetes' AS [Label],'BENCHMARKS' AS [Source],'B_MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 140 AS [Column],'PiPG-Bonde91' AS [Label],'BENCHMARKS' AS [Source],'LPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 141 AS [Column],'PiPG-BondeT' AS [Label],'BENCHMARKS' AS [Source],'LTMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 142 AS [Column],'PiPG-Bonde182' AS [Label],'BENCHMARKS' AS [Source],'LSMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 143 AS [Column],'PiPG-Bonos' AS [Label],'BENCHMARKS' AS [Source],'M_MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 144 AS [Column],'PiPG-Udibonos' AS [Label],'BENCHMARKS' AS [Source],'S_MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 145 AS [Column],'PiPG-Brems' AS [Label],'BENCHMARKS' AS [Source],'XAMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 146 AS [Column],'PiPG-BPAS' AS [Label],'BENCHMARKS' AS [Source],'IPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 147 AS [Column],'PiP-Pic' AS [Label],'BENCHMARKS' AS [Source],'PIMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 148 AS [Column],'PiP-UMS' AS [Label],'BENCHMARKS' AS [Source],'D1MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 149 AS [Column],'PiPFondeo-G' AS [Label],'BENCHMARKS' AS [Source],'TFGOMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 150 AS [Column],'PiPCetes-7d' AS [Label],'BENCHMARKS' AS [Source],'B>>007MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 151 AS [Column],'PiPCetes-28d' AS [Label],'BENCHMARKS' AS [Source],'B>>028MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 152 AS [Column],'PiPCetes-70-90d' AS [Label],'BENCHMARKS' AS [Source],'B>>091MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 153 AS [Column],'PiPCetes-91d' AS [Label],'BENCHMARKS' AS [Source],'B>>090MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 154 AS [Column],'PiPCetes-182d' AS [Label],'BENCHMARKS' AS [Source],'B>>182MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 155 AS [Column],'PiPCetes-364d' AS [Label],'BENCHMARKS' AS [Source],'B>>364MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 156 AS [Column],'PIPG-Fix' AS [Label],'BENCHMARKS' AS [Source],'PIPFMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 157 AS [Column],'PIPG-Fix1M' AS [Label],'BENCHMARKS' AS [Source],'PIPF1MMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 158 AS [Column],'PIPG-Fix3M' AS [Label],'BENCHMARKS' AS [Source],'PIPF3MMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 159 AS [Column],'PIPG-Fix6M' AS [Label],'BENCHMARKS' AS [Source],'PIPF6MMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 160 AS [Column],'PIPG-Fix12M' AS [Label],'BENCHMARKS' AS [Source],'PIPF12MMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 161 AS [Column],'PIPG-Fix13M' AS [Label],'BENCHMARKS' AS [Source],'PIPF13MMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 162 AS [Column],'PIPG-Float' AS [Label],'BENCHMARKS' AS [Source],'PIPFLMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 163 AS [Column],'PIPG-Float12M' AS [Label],'BENCHMARKS' AS [Source],'PIPFLCPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 164 AS [Column],'PIPG-Float12M+' AS [Label],'BENCHMARKS' AS [Source],'PIPFLLPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 165 AS [Column],'PIPG-Real' AS [Label],'BENCHMARKS' AS [Source],'PIPREALMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 166 AS [Column],'PIPFondeo-B' AS [Label],'BENCHMARKS' AS [Source],'TFBMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 167 AS [Column],'PIP-Bank' AS [Label],'BENCHMARKS' AS [Source],'BANKMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 168 AS [Column],'PIP-Bank12M' AS [Label],'BENCHMARKS' AS [Source],'BANK>>CPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 169 AS [Column],'PIP-Bank12M+' AS [Label],'BENCHMARKS' AS [Source],'BANK>>LPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 170 AS [Column],'PiP-TIIE28' AS [Label],'BENCHMARKS' AS [Source],'T028MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 171 AS [Column],'PIP-Mexibor91' AS [Label],'BENCHMARKS' AS [Source],'MX091MD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 172 AS [Column],'PIP-Corp' AS [Label],'BENCHMARKS' AS [Source],'CORPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 173 AS [Column],'PIP-Corp12M' AS [Label],'BENCHMARKS' AS [Source],'CORP>>CPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 174 AS [Column],'PIP-Corp12M+' AS [Label],'BENCHMARKS' AS [Source],'CORP>>LPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 175 AS [Column],'PIP-Eurobonos' AS [Label],'BENCHMARKS' AS [Source],'D2SMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 176 AS [Column],'PIP-Fondos-Liq' AS [Label],'BENCHMARKS' AS [Source],'FONLIQMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 177 AS [Column],'PIP-Fondos-CP' AS [Label],'BENCHMARKS' AS [Source],'FONCPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 178 AS [Column],'PIP-Fondos-MP' AS [Label],'BENCHMARKS' AS [Source],'FONMPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 179 AS [Column],'PIP-Fondos-LP' AS [Label],'BENCHMARKS' AS [Source],'FONLPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 180 AS [Column],'PIP-Siefore-CP' AS [Label],'BENCHMARKS' AS [Source],'SIECPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 181 AS [Column],'PIP-Siefore-LP' AS [Label],'BENCHMARKS' AS [Source],'SIELPMD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor] UNION   
               SELECT 182 AS [Column],'PiP-Guber24H' AS [Label],'BENCHMARKS' AS [Source],'PIPGUB24H' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 183 AS [Columm],'XA 364' AS [Label],'PRICES' AS [Source],'BREMSXA' AS [IRCcode],'' AS [Type],'' AS [SubType],'364' AS [Nodo],'LDR' AS [Item],'XA' AS [TVs],'' AS [HLD],'0' AS [Factor] UNION   
               SELECT 184 AS [Columm],'XA 1092' AS [Label],'PRICES' AS [Source],'BREMSXA' AS [IRCcode],'' AS [Type],'' AS [SubType],'1092' AS [Nodo],'LDR' AS [Item],'XA' AS [TVs],'' AS [HLD],'0' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 185 AS [Columm],'TDST 28' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 186 AS [Columm],'TDST 56' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'56' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 187 AS [Columm],'TDST 84' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'84' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 188 AS [Columm],'TDST 112' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'112' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 189 AS [Columm],'TDST 140' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'140' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 190 AS [Columm],'TDST 168' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'168' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 191 AS [Columm],'TDST 196' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'196' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 192 AS [Columm],'TDST 224' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'224' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 193 AS [Columm],'TDST 252' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'252' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 194 AS [Columm],'TDST 280' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'280' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 195 AS [Columm],'TDST 308' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'308' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 196 AS [Columm],'TDST 336' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'336' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 197 AS [Columm],'TDST 364' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 198 AS [Columm],'TDST 448' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'448' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 199 AS [Columm],'TDST 532' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'532' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 200 AS [Columm],'TDST 616' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'616' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 201 AS [Columm],'TDST 700' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'700' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 202 AS [Columm],'TDST 784' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'784' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 203 AS [Columm],'TDST 868' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'868' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 204 AS [Columm],'TDST 952' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'952' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 205 AS [Columm],'TDST 1008' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'SWP' AS [Type],'TI' AS [SubType],'1008' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 206 AS [Columm],'Forward TIIE 28' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 207 AS [Columm],'Forward TIIE 56' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'56' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 208 AS [Columm],'Forward TIIE 84' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'84' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 209 AS [Columm],'Forward TIIE 112' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'112' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 210 AS [Columm],'Forward TIIE 140' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'140' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 211 AS [Columm],'Forward TIIE 168' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'168' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 212 AS [Columm],'Forward TIIE 196' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'196' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 213 AS [Columm],'Forward TIIE 224' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'224' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 214 AS [Columm],'Forward TIIE 252' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'252' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 215 AS [Columm],'Forward TIIE 280' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'280' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 216 AS [Columm],'Forward TIIE 308' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'308' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 217 AS [Columm],'Forward TIIE 336' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'336' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 218 AS [Columm],'Forward TIIE 364' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'364' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 219 AS [Columm],'Forward TIIE 448' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'448' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 220 AS [Columm],'Forward TIIE 532' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'532' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 221 AS [Columm],'Forward TIIE 616' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'616' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 222 AS [Columm],'Forward TIIE 700' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'700' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 223 AS [Columm],'Forward TIIE 784' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'784' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 224 AS [Columm],'Forward TIIE 868' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'868' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 225 AS [Columm],'Forward TIIE 952' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'952' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 226 AS [Columm],'Forward TIIE 1008' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'TDS' AS [Type],'T28' AS [SubType],'1008' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 227 AS [Columm],'Activa Bancaria 28' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 228 AS [Columm],'Activa Bancaria 56' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'56' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 229 AS [Columm],'Activa Bancaria 84' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'84' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 230 AS [Columm],'Activa Bancaria 112' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'112' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 231 AS [Columm],'Activa Bancaria 140' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'140' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 232 AS [Columm],'Activa Bancaria 168' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'168' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 233 AS [Columm],'Activa Bancaria 196' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'196' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 234 AS [Columm],'Activa Bancaria 224' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'224' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 235 AS [Columm],'Activa Bancaria 252' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'252' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 236 AS [Columm],'Activa Bancaria 280' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'280' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 237 AS [Columm],'Activa Bancaria 308' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'308' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 238 AS [Columm],'Activa Bancaria 336' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'336' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 239 AS [Columm],'Activa Bancaria 360' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'BID' AS [SubType],'360' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 240 AS [Columm],'Pasiva Bancaria 28' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'28' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 241 AS [Columm],'Pasiva Bancaria 56' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'56' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 242 AS [Columm],'Pasiva Bancaria 84' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'84' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 243 AS [Columm],'Pasiva Bancaria 112' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'112' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 244 AS [Columm],'Pasiva Bancaria 140' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'140' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 245 AS [Columm],'Pasiva Bancaria 168' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'168' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 246 AS [Columm],'Pasiva Bancaria 196' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'196' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 247 AS [Columm],'Pasiva Bancaria 224' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'224' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 248 AS [Columm],'Pasiva Bancaria 252' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'252' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 249 AS [Columm],'Pasiva Bancaria 280' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'280' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 250 AS [Columm],'Pasiva Bancaria 308' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'308' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 251 AS [Columm],'Pasiva Bancaria 336' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'336' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor] UNION   
               SELECT 252 AS [Columm],'Pasiva Bancaria 360' AS [Label],'CURVES' AS [Source],'' AS [IRCcode],'PLV' AS [Type],'ASK' AS [SubType],'360' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'0.01' AS [Factor]  
  
 INSERT INTO #tmp_tblFRBancoAzteca  
               SELECT 253 AS [Columm],'US FEDERAL FUNDS RATE' AS [Label],'IRC' AS [Source],'FDFD' AS [IRCcode],'' AS [Type],'' AS [SubType],'' AS [Nodo],'' AS [Item],'' AS [TVs],'' AS [HLD],'' AS [Factor]  
  
 SET NOCOUNT OFF   
  
 SELECT * FROM #tmp_tblFRBancoAzteca  
 WHERE Columm > 0  
 ORDER BY Columm  
  
 END  
 RETURN 0  CREATE PROCEDURE dbo.sp_productos_BANCOAZTECA;2  
 @txtDate AS VARCHAR(10),  
        @dblNodo AS INTEGER,  
 @txtItem AS VARCHAR(3),  
        @txtTVs AS VARCHAR(30)   
  
 /*   
   Version 1.0    
     
    Procedimiento que genera Factores de Riesgo para BANCOAZTECA,  
                  en base a una liquidacion e item  
      Elaborado por :  Lic. René López Salinas  
    Fecha: 10-Abr-2006  
 */  
  
 AS   
 BEGIN  
  
 DECLARE @dblValue AS FLOAT  
  
 SET NOCOUNT ON   
  
 /* Selecciona el más cercano al Nodo proporcionado */  
  
 SELECT TOP 1 a.txtID1 AS [txtID1],a.dblValue AS [dblValue],ABS(a.dblValue - @dblNodo) AS [DIFER]   
 INTO #tmp_tblFRCONSAR  
 FROM tblPrices a, tblIds b  
        WHERE dteDate = @txtDate  
     AND a.txtId1 = b.txtId1  
            AND a.txtLiquidation = 'MD' and a.txtitem in ('DTM')  
            AND b.txttv in ('M','M0','M7','M5','M3')  
            AND b.txtId1 NOT IN ('MGOV050001','MGOV0330046','MGOV0330047','MGOV0330048','MGOV0330051','MGOV070001')  
 ORDER BY DIFER  
  
 SET @dblValue = (SELECT a.dblValue From tblPrices a, tblIds b  
                  WHERE a.dteDate = @txtDate AND a.txtId1 = b.txtId1   
            AND a.txtId1 = (SELECT TOP 1 txtID1 FROM #tmp_tblFRCONSAR)  
                  AND a.txtLiquidation = 'MD' and a.txtitem in (@txtItem)  
                  AND b.txttv in ('M','M0','M7','M5','M3')  
           AND b.txtId1 NOT IN ('MGOV050001','MGOV0330046','MGOV0330047','MGOV0330048','MGOV0330051','MGOV070001'))  
  
  
 SET NOCOUNT OFF   
  
 IF @dblValue IS NOT NULL  
  BEGIN  
    SELECT @dblValue AS [dblValue]  
  END  
  
 END  
 RETURN 0  
   
 CREATE PROCEDURE dbo.sp_productos_BANCOAZTECA;3  
 @txtDate AS VARCHAR(10),  
    @dblNodo AS INTEGER,  
 @txtItem AS VARCHAR(3),  
    @txtTVs AS VARCHAR(30)   
 AS   
/*   
 Autor:    Lic. René López Salinas  
 Creacion:   11-Abr-2006  
 Descripcion:  Procedimiento que genera Factores de Riesgo para BANCOAZTECA,  
      en base a una liquidacion e item PARA BREMS  
  
 Modificado por:  Csolorio  
 Modificacion:  20110721  
 Descripcion:  Fijo la fecha a 20110720  
  
 Modificado por:  Mike Ramirez  
 Modificacion:  20130730  
 Descripcion:  Se apunta hacia la base historica de MxFixIncomeHist_2011  
  
*/  
 BEGIN  
  
 DECLARE @dblValue AS FLOAT  
  
 SET NOCOUNT ON   
  
 /* Selecciona el más cercano al Nodo proporcionado */  
  
 SELECT TOP 1 a.txtID1 AS [txtID1],a.dblValue AS [dblValue],ABS(a.dblValue - @dblNodo) AS [DIFER]   
 INTO #tmp_tblFRCONSAR  
 FROM MxFixIncomeHist_2011.dbo.tblhistoricPrices a, tblIds b  
        WHERE dteDate = '20110720'  
     AND a.txtId1 = b.txtId1  
            AND a.txtLiquidation = 'MD' and a.txtitem in ('DTM')  
            AND b.txttv in ('XA')  
 ORDER BY DIFER  
  
 SET @dblValue = (SELECT a.dblValue From MxFixIncomeHist_2011.dbo.tblhistoricPrices a, tblIds b  
                  WHERE a.dteDate = '20110720' AND a.txtId1 = b.txtId1   
            AND a.txtId1 = (SELECT TOP 1 txtID1 FROM #tmp_tblFRCONSAR)  
                  AND a.txtLiquidation = 'MD' and a.txtitem in (@txtItem)  
                  AND b.txttv in ('XA'))  
  
 SET @dblValue=213.4116114  
   
 SET NOCOUNT OFF   
  
 IF @dblValue IS NOT NULL  
  BEGIN  
    SELECT @dblValue AS [dblValue]  
  END  
  
 END  
  
  
------------------------------------------------------------------------------------------------------  
--   Autor:          Mike Ramirez  
--   Creacion:   11:58 2013-04-17  
--   Descripcion :     Procedimiento que genera producto Azteca_VPAforado_Liquidaciones[yyyymmdd].csv  
------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BANCOAZTECA;4  
  @txtDate AS DATETIME,  
 @txtFlag AS CHAR(1)  
  
AS     
BEGIN    
  
 SET NOCOUNT ON   
    
   SELECT DISTINCT  
    'H' + ',' +  
    RTRIM(ap.txtMKT) + ',' +  
    CONVERT(CHAR(10),@txtDate,103) + ',' +  
    RTRIM(ap.txtTv) + ',' +  
    RTRIM(ap.txtEmisora) + ',' +  
    RTRIM(ap.txtSerie) + ',' +  
    CASE UPPER(ap.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap.dblPRS,6),16,6))  
    END + ',' +  --  AS PRSMD  
    CASE UPPER(ap.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap.dblPRL,6),16,6))  
    END + ',' +   --  AS PRLMD  
    LTRIM(STR(ROUND(ap.dblCPD,6),19,6)) + ',' + --AS CPDMD  
    LTRIM(STR(ROUND(ap.dblCPA,6),19,6)) + ',' + --AS CPAMD  
    '025900' + ',' +  
    @txtFlag + ',' +  
    LTRIM(STR(ROUND(ap.dblDTM,5),5)) + ',' + --AS DTMMD  
    CASE    
     WHEN ap.txtTv IN ('IP','IT','L','LD','LP','LS','LT','XA','IS','IQ','IM') THEN LTRIM(STR(ROUND(ap.dblLDR,6),13,6))  
     WHEN ap.txtTv IN ('D','D3','G','I') THEN LTRIM(STR(ROUND(ap.dblUDR,6),13,6))  
    ELSE LTRIM(STR(ROUND(ap.dblYTM,6),13,6))  
    END + ',' +  
    RTRIM(ap.txtId2)  + ',' +  
  
    -- Para 24H   
    CASE UPPER(ap24.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap24.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap24.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS24  
    CASE UPPER(ap24.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap24.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap24.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL24  
    LTRIM(STR(ROUND(ap24.dblCPD,6),19,6)) + ',' + --AS CPD24  
    CASE   
     WHEN ap24.txtDTC = 'NA' OR ap24.txtDTC = '-' OR ap24.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap24.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap24.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap24.dblCPA,6),19,6)) + ',' +  --AS CPA24  
  
    -- Para 481   
    CASE UPPER(ap48.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap48.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap48.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS48  
    CASE UPPER(ap48.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap48.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap48.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL48  
    LTRIM(STR(ROUND(ap48.dblCPD,6),19,6)) + ',' + --AS CPD48  
    CASE   
     WHEN ap48.txtDTC = 'NA' OR ap48.txtDTC = '-' OR ap48.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap48.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap48.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap48.dblCPA,6),19,6)) + ',' + --AS CPA48  
  
    -- Para 721   
    CASE UPPER(ap72.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap72.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap72.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS72  
    CASE UPPER(ap72.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap72.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap72.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL72  
    LTRIM(STR(ROUND(ap72.dblCPD,6),19,6)) + ',' + --AS CPD72  
    CASE   
     WHEN ap72.txtDTC = 'NA' OR ap72.txtDTC = '-' OR ap72.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap72.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap72.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap72.dblCPA,6),19,6)) + ',' + --AS CPA72    
  
    -- Para 961   
    CASE UPPER(ap96.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap96.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap96.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS96  
    CASE UPPER(ap96.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap96.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap96.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL96  
    LTRIM(STR(ROUND(ap96.dblCPD,6),19,6)) + ',' + --AS CPD96  
    CASE   
     WHEN ap96.txtDTC = 'NA' OR ap96.txtDTC = '-' OR ap96.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap96.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap96.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap96.dblCPA,6),19,6)) + ',' + --AS CPA96  
      
    -- Para 05D   
    CASE UPPER(ap05D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap05D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap05D.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS05D  
    CASE UPPER(ap05D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap05D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap05D.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL05D  
    LTRIM(STR(ROUND(ap05D.dblCPD,6),19,6)) + ',' + --AS CPD05D  
    CASE   
     WHEN ap05D.txtDTC = 'NA' OR ap05D.txtDTC = '-' OR ap05D.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap05D.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap05D.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap05D.dblCPA,6),19,6))  + ',' + --AS CPA05D  
      
    -- Para 06D   
    CASE UPPER(ap06D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap06D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap06D.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS06D  
    CASE UPPER(ap06D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap06D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap06D.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL06D  
    LTRIM(STR(ROUND(ap06D.dblCPD,6),19,6)) + ',' + --AS CPD06D  
    CASE   
     WHEN ap06D.txtDTC = 'NA' OR ap06D.txtDTC = '-' OR ap06D.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap06D.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap06D.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap06D.dblCPA,6),19,6))  + ',' + --AS CPA06D  
  
    -- Para 07D   
    CASE UPPER(ap07D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap07D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap07D.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS07D  
    CASE UPPER(ap07D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap07D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap07D.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL07D  
    LTRIM(STR(ROUND(ap07D.dblCPD,6),19,6)) + ',' + --AS CPD07D  
    CASE   
     WHEN ap07D.txtDTC = 'NA' OR ap07D.txtDTC = '-' OR ap07D.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap07D.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap07D.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap07D.dblCPA,6),19,6)) + ',' + --AS CPA07D  
  
    -- Para 08D   
    CASE UPPER(ap08D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap08D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap08D.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS08D  
    CASE UPPER(ap08D.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap08D.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap08D.dblPRL,6),16,6))  
    END + ',' +   --  AS PRL08D  
    LTRIM(STR(ROUND(ap08D.dblCPD,6),19,6)) + ',' + --AS CPD08D  
    CASE   
     WHEN ap08D.txtDTC = 'NA' OR ap08D.txtDTC = '-' OR ap08D.txtDTC IS NULL THEN ''  
    ELSE LTRIM(STR(ROUND(ap08D.txtDTC,6),19,6))   
    END + ',' + --DTC  
    LTRIM(STR(ROUND(ap08D.dblUDR,6),13,6)) + ',' +   
    LTRIM(STR(ROUND(ap08D.dblCPA,6),19,6)) + ',' + --AS CPA08D  
  
    RTRIM(ap.txtPCR) + ',' +  
    CASE UPPER(ap.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap.dblPRS,6),16,6))  
    END + ',' +  --  AS PRSMD      
    CASE UPPER(ap24.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap24.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap24.dblPRS,6),16,6))  
    END + ',' +  --  AS PRS24  
      
    CASE  
     WHEN ap.txtPSPP IS NULL OR ap.txtPSPP = '-' OR ap.txtPSPP = 'NA' THEN ''   
    ELSE LTRIM(STR(ROUND(ap.txtPSPP,6),16,6))  
    END + ',' +  
  
    CASE  
     WHEN ap24.txtPSPP IS NULL OR ap24.txtPSPP = '-' OR ap24.txtPSPP = 'NA' THEN ''   
    ELSE LTRIM(STR(ROUND(ap24.txtPSPP,6),16,6))  
    END + ',' +        
  
    CASE  
     WHEN ap.txtAFO_SPR_UN IS NULL OR ap.txtAFO_SPR_UN = '-' OR ap.txtAFO_SPR_UN = 'NA' THEN ''   
    ELSE LTRIM(STR(ROUND(ap.txtAFO_SPR_UN,2),5,2))  
    END + ',' +  
      
    RTRIM(ap.txtSPM) + ',' +  
    RTRIM(ap.txtSPQ) + ',' +  
    RTRIM(ap.txtFIQ) + ',' +  
    RTRIM(ap.txtDPQ) + ',' +   
  
    CASE  
     WHEN ap.txtPSPA IS NULL OR ap.txtPSPA = '-' OR ap.txtPSPA = 'NA' THEN ''   
    ELSE LTRIM(STR(ROUND(ap.txtPSPA,6),16,6))  
    END + ',' +  
  
    CASE  
     WHEN ap24.txtPSPA IS NULL OR ap24.txtPSPA = '-' OR ap24.txtPSPA = 'NA' THEN ''   
    ELSE LTRIM(STR(ROUND(ap24.txtPSPA,6),16,6))  
    END  
   FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap (NOLOCK)  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap24 (NOLOCK)  
      ON ap24.txtId1 = ap.txtId1  
       AND ap24.txtLiquidation IN ('24H','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap48 (NOLOCK)  
      ON ap48.txtId1 = ap.txtId1  
       AND ap48.txtLiquidation IN ('481','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap72 (NOLOCK)  
      ON ap72.txtId1 = ap.txtId1  
       AND ap72.txtLiquidation IN ('721','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap96 (NOLOCK)  
      ON ap96.txtId1 = ap.txtId1  
       AND ap96.txtLiquidation IN ('961','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap05D (NOLOCK)  
      ON ap05D.txtId1 = ap.txtId1  
       AND ap05D.txtLiquidation IN ('05D','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap06D (NOLOCK)  
      ON ap06D.txtId1 = ap.txtId1  
       AND ap06D.txtLiquidation IN ('06D','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap07D (NOLOCK)  
      ON ap07D.txtId1 = ap.txtId1  
       AND ap07D.txtLiquidation IN ('07D','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap08D (NOLOCK)  
      ON ap08D.txtId1 = ap.txtId1  
       AND ap08D.txtLiquidation IN ('08D','MP')  
   WHERE   
    ap.txtLiquidation IN ('MD', 'MP')  
   
 SET NOCOUNT OFF   
  
END  