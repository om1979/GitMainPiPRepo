  
  
--   Modificado por: Lic. René López Salinas  
--   Modificacion:  01:54 p.m. 2010-09-03  
--   Descripcion:     Modulo 1: Inclusion de TC (CNY,ARP,NZD)  
CREATE PROCEDURE dbo.sp_productos_BITAL;1  
 @txtFecha AS VARCHAR(10)  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
  -- euro  
  SELECT 1 AS intOrder, dblValue  
  INTO #tblCurrencies  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('EURU')  
   
  -- libra  
  INSERT  #tblCurrencies  
  SELECT 2 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('GBPU')  
   
  -- yen japones  
  INSERT  #tblCurrencies  
  SELECT 3 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('JPYX')  
   
  -- dolar canadiense  
  INSERT  #tblCurrencies  
  SELECT 4 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('CADX')  
   
  -- corona danesa  
  INSERT  #tblCurrencies  
  SELECT 5 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('DKKX')  
   
  -- franco suizo  
  INSERT  #tblCurrencies  
  SELECT 6 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('CHFX')  
   
  -- corona sueca  
  INSERT  #tblCurrencies  
  SELECT 7 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('SEKX')  
   
  -- real brasileno  
  INSERT  #tblCurrencies  
  SELECT 8 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('BRLX')  
   
  -- corona noruega  
  INSERT  #tblCurrencies  
  SELECT 9 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('NOKX')  
   
  -- plata spot  
  INSERT  #tblCurrencies  
  SELECT 10 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('PLATA')  
   
  -- oro  
  INSERT  #tblCurrencies  
  SELECT 11 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('ORO')  
   
  -- dolar fix  
  INSERT  #tblCurrencies  
  SELECT 12 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('UFXU')  
  
  -- PESO CHILENO  
  INSERT  #tblCurrencies  
  SELECT 13 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('CLP')  
  
  -- PESO CHILENO VS DOLAR  
  INSERT  #tblCurrencies  
  SELECT 14 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('CLPU')  
  
 -- Dólar Australiano  
  INSERT  #tblCurrencies  
  SELECT 15 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('AUDX')  
  
 -- Dólar Australiano/USD  
  INSERT  #tblCurrencies  
  SELECT 16 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('AUD')  
  
 -- YUAN VS USD  
  INSERT  #tblCurrencies  
  SELECT 17 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('CNYU')  
  
 -- Peso Argentina VS USD  
  INSERT  #tblCurrencies  
  SELECT 18 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('ARPX')  
  
 -- DOLAR NEOZELANDES VS USD  
  INSERT  #tblCurrencies  
  SELECT 19 AS intOrder, dblValue  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('NZDX')  
  
 SET NOCOUNT OFF  
   
  -- tipos de cambio MXP VS USD  
  SELECT  
  txtIrc,  
  dblValue AS dblValor  
  FROM tblIrc  
  WHERE  
  dteDate = @txtFecha  
  AND txtIRC IN ('USD0','USD1','USD2')  
  ORDER BY   
  txtIRC  
   
 -- monedas   
 SELECT   
  intOrder AS intOrden,  
  dblValue AS dblValor  
 FROM #tblCurrencies  
 ORDER BY   
  intOrder  
  
 END  
RETURN 0  
  
  
CREATE PROCEDURE dbo.sp_productos_BITAL;2  
  @txtDate AS VARCHAR(10)    
  
  
/*  
  Version 1.0    
     
   Procedimiento que genera archivo  
               curvas BITALCSV nuevo Formato  
     Elaborado: Por Josefina Renteria  
   Fecha: 10-Junio-2005  
*/    
  
 AS     
 BEGIN    
    
 SELECT txtType,txtSubType,intCurve =   
  CASE  WHEN txtType+'-'+txtSubType = 'CET-CT' THEN 1   
         WHEN txtType+'-'+txtSubType = 'PLV-P8' THEN 2  
         WHEN txtType+'-'+txtSubType = 'RB2-B2' THEN 3  
   WHEN txtType+'-'+txtSubType = 'RG2-G2' THEN 4  
   WHEN txtType+'-'+txtSubType = 'SWP-TI' THEN 5                                         
  END,  
         txtDescription  
 FROM tblCurvesCatalog  
 WHERE txtType+'-'+txtSubType IN ('CET-CT','PLV-P8','RB2-B2','RG2-G2','SWP-TI')  
              UNION  
             SELECT 'Tipo','SubTipo',0,'Plazo'  
 ORDER BY intCurve  
  
END  
  
RETURN 0  
  
CREATE PROCEDURE dbo.sp_productos_BITAL;3  
  @txtDate AS VARCHAR(10)    
  
  
/*  
  Version 1.0    
     
   Procedimiento que genera archivo  
               curvas TasasPiPBitalAAAAMMDD.csv nuevo Formato  
     Elaborado: Lic. René López Salinas  
   Fecha: 20-Junio-2005  
*/    
  
 AS     
 BEGIN    
    
  SELECT txtType,txtSubType,intCurve =   
   CASE  WHEN txtType+'-'+txtSubType = 'FTC-BRL' THEN 1   
          WHEN txtType+'-'+txtSubType = 'FTC-CAD' THEN 2  
          WHEN txtType+'-'+txtSubType = 'FTC-EUR' THEN 3     
              WHEN txtType+'-'+txtSubType = 'FTC-GBP' THEN 4    
                    WHEN txtType+'-'+txtSubType = 'FTC-JPY' THEN 5      
            END,  
         txtDescription  
  FROM tblCurvesCatalog  
  WHERE txtType+'-'+txtSubType IN ('FTC-BRL','FTC-CAD','FTC-EUR','FTC-GBP','FTC-JPY')  
  
        UNION  
  
        SELECT 'Tipo','SubTipo',0,'Plazo'  
  ORDER BY intCurve  
  
END  
  
RETURN 0  
  
  
--   Modificado por: Lic. René López Salinas  
--   Modificacion: 01:41 p.m. 2010-10-14  
--   Descripcion:     Modulo 4: Excluir del archivo el siguiente instrumento ID1: UIRC0008070  
CREATE PROCEDURE dbo.sp_productos_BITAL;4  
  @txtDate AS VARCHAR(10),  
  @txtLiquidation AS VARCHAR(3)  
  
  
AS     
BEGIN    
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row  CHAR(132),  
  Consecutivo INT  
  PRIMARY KEY(Consecutivo,Row)  
 )  
  
 -- creo tabla temporal para incluir instrumentos Fijos al Vector  
 DECLARE @tmp_tblEspecialFixedSecurities TABLE (  
  txtId1 CHAR(11),  
  txtId2  CHAR(12),  
  txtEmisora  CHAR(10),  
  dblPAV FLOAT  
  PRIMARY KEY(txtId2)  
 )  
  
 -- Declaracion de Constantes  
 DECLARE @ERecordTypeCode AS CHAR(1)  
 DECLARE @EFiller1 AS CHAR(29)  
 DECLARE @EFileName AS CHAR(40)  
 DECLARE @EFiller2 AS CHAR(2)  
 DECLARE @txtHHMMSS AS CHAR(6)  
 DECLARE @EFiller3 AS CHAR(2)  
 DECLARE @EFiller4 AS CHAR(44)  
  
 DECLARE @RecordTypeCode AS CHAR(1)  
 DECLARE @AliasSecurityCode AS CHAR(12)  
 DECLARE @Filler6 AS CHAR(3)  
 DECLARE @Filler7 AS CHAR(6)  
 DECLARE @IssuedSharedCapital AS CHAR(12)  
 DECLARE @Filler8 AS CHAR(20)  
  
  
 -- Asignación de Valores Constantes  
 SET @ERecordTypeCode = 'H'  
 SET @EFiller1 = '                             '      -- Filler1(29)  
 SET @EFileName = 'Stock Closing Prices File               '   -- FileName (40)  
 SET @EFiller2 = '  '            -- Filler2 (2)  
 SET @txtHHMMSS = REPLACE(CONVERT(CHAR(10),GETDATE(),108),':','') -- FileCreationTime (6)  
 SET @EFiller3 = '  '             -- Filler3 (2)  
 SET @EFiller4 = '                                            '  -- Filler4(44)  
  
 SET @RecordTypeCode = 'P'           -- RecordTypeCode(1)  
 SET @AliasSecurityCode = '            '        -- AliasSecurityCode(12)  
 SET @Filler6 = '   '            -- Filler6 (3)    
 SET @Filler7 = '      '            -- Filler6 (3)    
 SET @IssuedSharedCapital = '            '  
 SET @Filler8 = '                    '  
  
 SET NOCOUNT ON  
  
  
 INSERT @tmp_tblResults  
 SELECT  
  @ERecordTypeCode +  
  @EFiller1 +  
  @EFileName  +  
  @EFiller2  +  
  @txtHHMMSS +  
  @EFiller3  +  
  @txtDate +  
  @EFiller4 AS [Rows],         
  0  
  
 INSERT @tmp_tblResults  
 SELECT  DISTINCT  
  @RecordTypeCode +  
  CASE   
   WHEN a.txtTV LIKE '%SP%' THEN LTRIM(RTRIM(a.txtId1)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(a.txtId1))))  
      ELSE  
     CASE   
    WHEN LEN(LTRIM(RTRIM(i.txtId2))) = 12 THEN LTRIM(RTRIM(i.txtId2)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(i.txtId2))))  
    ELSE LTRIM(RTRIM(a.txtId1)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(a.txtId1)))) END   
  END +                          -- PrimarySecurityCode(12)  
  @AliasSecurityCode +  
  CASE   
   WHEN SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,35) = '-' OR SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,35) = 'NA' OR i.txtNem IS NULL  
    THEN SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) +  
         REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) -- Complemento -- SecuritiesName(35)  
      WHEN LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)) < 35   
    THEN SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35))) +  
         REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)))  -- Complemento SecuritiesName(35)  
      ELSE  
      SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)          -- SecuritiesName(35)  
  END +  
  CASE   
   UPPER(a.txtLiquidation)  
    WHEN 'MP'THEN  
     STR(ROUND(a.dblPAV,6),14,5)          -- ClosePricing(14)(9,5)  
    ELSE  
     STR(ROUND(a.dblPRS,6),14,5)          -- ClosePricing(14)(9,5)  
  END +  
  @Filler6 +   
  @txtDate +                  -- DateOfClosingPrice(8)  
  @Filler7 +   
  @txtHHMMSS +  
  'MXN' +                  -- Price Currency Mnemonic(3)  
  @IssuedSharedCapital +   
  @Filler8   
  AS [Rows],              
  1   
 FROM MxFixIncome.dbo.tmp_tblActualPrices AS a (NOLOCK)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS i (NOLOCK)  
   ON i.txtId1 = a.txtId1  
    AND i.txtLiquidation = (  
     CASE a.txtLiquidation    
     WHEN 'MP' THEN 'MD'    
     ELSE a.txtLiquidation    
     END  
    )  
 WHERE a.txtLiquidation IN (@txtLiquidation,'MP')  
  AND a.txtTv NOT IN ('*C','*CSP','FA','FB','FC','FCSP','FD','FI','FM','FS','FU','RC','SWT','WA','WASP','WC','WE','WESP','WI',  
     'OD','OA','OI','SWT','TR','*ISP','1ASP','1ESP','1ISP','56SP','74SP','81SP','93SP','D1SP','D2SP','D3SP',  
     'D4SP','D5SP','D6SP','D7SP','D8SP','D9SP','FSP','JSP','QSP','R3SP','YSP','YYSP')  
-- AND (a.txtId1 IN ('MIRC0000081','MIRC0000084','MIRC0000075')  
 AND a.txtId1 NOT IN ('MHMG5200001','MHMG5200002','MHMG5200003','MHMG5200005','MHMG5200006','MHMG5200007','MHMG5200008','MHMG5200009','MHMH5200001',  
       'MHMH5200002','MHMH5200003','MHMH5200004',  
   'MIRC0004558','MIRC0004559','MIRC0004560','MIRC0004551','MIRC0004552','MIRC0004553','MIRC0004554','MIRC0004555',  
   'MIRC0004556','MIRC0004561','MIRC0004562','MIRC0004563','MIRC0004565','MIRC0004566','MIRC0004567','MIRC0004568',  
   'MIRC0004569','MIRC0004570','MIRC0004572','MIRC0004573','MIRC0004574','MIRC0004577',  
   'MIRC0004579','MIRC0004580','MIRC0004581','MIRC0004582','MIRC0004583','MIRC0004584','MIRC0004586','MIRC0004587',  
   'MIRC0004588','MIRC0004589','MIRC0004590','MIRC0004591','UIRC0008070')  
 --ORDER BY a.txtTv,a.txtEmisora,a.txtSerie  
  
  
 -- 1. Solicitud1_20080617: Caso Especial agrego instrumentos fijos:  
  
 -- INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200001','MP','PAV') FROM MxFixIncome.dbo.tblIds WHERE txtId1 = 'MHMG5200001'  
  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200001','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200001'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200002','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200002'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200003','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200003'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200005','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200005'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200006','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200006'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200007','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200007'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200008','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200008'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200009','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200009'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMH5200001','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMH5200001'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMH5200002','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMH5200002'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMH5200003','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMH5200003'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMH5200004','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMH5200004'  
  
 -- Solicitud1_20080626: Caso Especial agrego instrumentos fijos:  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMF5200009','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMF5200009'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0002482','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0002482'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003291','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003291'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003374','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003374'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003705','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003705'  
  
 -- Solicitud1_20080806: Caso Especial agrego instrumentos fijos:  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200010','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200010'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMG5200004','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMG5200004'  
  
 -- Solicitud1_20080821: Caso Especial agrego instrumentos fijos:  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003969','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003969'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003970','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003970'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003971','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003971'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003972','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003972'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003973','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003973'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0003974','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003974'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MHMH5200006','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MHMH5200006'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0001938','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0001938'  
  
 -- Solicitud1_20080930: Caso Especial agrego 42 instrumentos fijos TV = 52  
  INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004557','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004557'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004558','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004558'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004559','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004559'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004560','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004560'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004551','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004551'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004552','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004552'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004553','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004553'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004554','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004554'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004555','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004555'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004556','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004556'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004561','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004561'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004562','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004562'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004563','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004563'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004564','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004564'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004565','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004565'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004566','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004566'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004567','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004567'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004568','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004568'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004569','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004569'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004570','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004570'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004571','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004571'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004572','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004572'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004573','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004573'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004574','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004574'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004575','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004575'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004576','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004576'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004577','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004577'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004578','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004578'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004579','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004579'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004580','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004580'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004581','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004581'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004582','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004582'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004583','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004583'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004584','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004584'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004585','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004585'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004586','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004586'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004587','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004587'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004588','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004588'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004589','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004589'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004590','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004590'  
 --INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004591','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004591'  
 INSERT @tmp_tblEspecialFixedSecurities SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice(@txtDate,'MIRC0004592','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0004592'  
  
 -- Depuro los que si tuvieron último hecho en fecha actual  
 DELETE @tmp_tblEspecialFixedSecurities  
 FROM @tmp_tblEspecialFixedSecurities AS ef  
   INNER JOIN @tmp_tblResults AS r  
   ON ef.txtId2 = SUBSTRING(r.Row,2,12)  
  
 INSERT @tmp_tblResults  
 SELECT    
  @RecordTypeCode +  
  LTRIM(RTRIM(a.txtId2)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(a.txtId2)))) +    -- txtId2  
  @AliasSecurityCode +  
  CASE   
   WHEN SUBSTRING(LTRIM(RTRIM(i.txtName)),1,35) = '-' OR SUBSTRING(LTRIM(RTRIM(i.txtName)),1,35) = 'NA' OR i.txtName IS NULL  
    THEN SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) +  
         REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) -- Complemento -- SecuritiesName(35)  
      WHEN LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtName,CHAR(9),' '))),1,35)) < 35   
    THEN SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtName,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtName,CHAR(9),' '))),1,35))) +  
         REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtName,CHAR(9),' '))),1,35)))  -- Complemento SecuritiesName(35)  
      ELSE  
      SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtName,CHAR(9),' '))),1,35)          -- SecuritiesName(35)  
  END +  
  STR(ROUND(a.dblPAV,6),14,5) +             -- ClosePricing(14)(9,5)  
  @Filler6 +   
  @txtDate +                  -- DateOfClosingPrice(8)  
  @Filler7 +   
  @txtHHMMSS +  
  'MXN' +                  -- Price Currency Mnemonic(3)  
  @IssuedSharedCapital +   
  @Filler8   
  AS [Rows],              
  1   
 FROM @tmp_tblEspecialFixedSecurities a  
  INNER JOIN MxFixIncome.dbo.tblIssuerCatalog AS i  
   ON a.txtEmisora = i.txtShortName  
  
 -- 1. Solicitud1_20080617: FIN   
  
 -- Sustituir los caracteres no validos para el Sistema del cliente   
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'!',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'@',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'#',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'$',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'%',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'^',' ')  
-- UPDATE @tmp_tblResults SET Row = REPLACE(Row,'&',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'*',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,';',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'"',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'|',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'\',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'=',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'_',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'<',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'>',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'{',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'}',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'[',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,']',' ')  
  
 SELECT Row FROM @tmp_tblResults ORDER BY Consecutivo,Row  
    
 SET NOCOUNT OFF  
  
END  
RETURN 0  
------------------------------------------------------------------------------------------  
--   Modificado por: Mike Ramírez  
--   Modificacion: 12:43 p.m. 2012-12-05  
--   Descripcion: Modulo 5: Incluir los tipos de valor IQ e IM en el flag de securtiy type  
------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;5  
  @txtDate AS VARCHAR(10),  
  @txtLiquidation AS VARCHAR(3)  
  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 -- creo tabla temporal de TVs excluidos  
 DECLARE @tmp_tblUNIExclude TABLE (  
  TVs  VARCHAR(4)  
  PRIMARY KEY(TVs)  
 )  
  
 -- creo tabla temporal de Keys Countries  
 DECLARE @tmp_tblKEYsCountries TABLE (  
  txtId1  CHAR(11),  
  dteDate DATETIME  
  PRIMARY KEY(txtId1)  
 )  
  
 -- creo tabla temporal de Keys Info Siguiente Cupon Vigente y Número cupon vigente  
 DECLARE @tmp_tblKEYsCupCalendar TABLE (  
  txtId1  CHAR(11),  
  intCupId  INT,  
  dteBeg DATETIME  
  PRIMARY KEY(txtId1,intCupId,dteBeg)  
 )  
  
 -- creo tabla temporal de Keys Countries  
 DECLARE @tmp_tblKEYsEquityAdd TABLE (  
  txtId1  CHAR(11),  
  dteDate DATETIME  
  PRIMARY KEY(txtId1)  
 )  
  
 -- creo tabla temporal de Keys Countries  
 DECLARE @tmp_tblKEYsIRCAdd TABLE (  
  txtIRC  CHAR(7),  
  dteDate DATETIME  
  PRIMARY KEY(txtIRC)  
 )  
  
 -- creo tabla temporal de Keys Frecuencia Pago Cupon  
 DECLARE @tmp_tblKEYsBondsAddCPF TABLE (  
  txtId1  CHAR(11),  
  dteDate DATETIME  
  PRIMARY KEY(txtId1)  
 )  
  
 -- creo tabla temporal de Keys Fecha del siguiente corte de cupón menos cinco días hábiles  
 DECLARE @tmp_tblNextPayDate TABLE (  
  txtNextPayDate  CHAR(8),  
  txtNextPayDate_Last5  CHAR(8)  
  PRIMARY KEY(txtNextPayDate)  
 )  
  
 -- Conjunto de TVs Excluidos  
 INSERT @tmp_tblUNIExclude   
  SELECT '*C' UNION  
  SELECT '*CSP' UNION  
  SELECT 'FA' UNION  
  SELECT 'FB' UNION  
  SELECT 'FC' UNION  
  SELECT 'FCSP' UNION  
  SELECT 'FD' UNION  
  SELECT 'FI' UNION  
  SELECT 'FM' UNION  
  SELECT 'FS' UNION  
  SELECT 'FU' UNION  
  SELECT 'RC' UNION  
  SELECT 'SWT' UNION  
  SELECT 'WA' UNION  
  SELECT 'WASP' UNION  
  SELECT 'WC' UNION  
  SELECT 'WE' UNION  
  SELECT 'WESP' UNION  
  SELECT 'WI' UNION  
  SELECT 'OD' UNION  
  SELECT 'OA' UNION  
  SELECT 'OI' UNION  
  SELECT 'SWT' UNION  
  SELECT 'TR'  UNION  
  SELECT '*ISP' UNION  
  SELECT '1ASP' UNION  
  SELECT '1ESP' UNION  
  SELECT '1ISP' UNION  
  SELECT '56SP' UNION  
  SELECT '74SP' UNION  
  SELECT '81SP' UNION  
  SELECT '93SP' UNION  
  SELECT 'D1SP' UNION  
  SELECT 'D2SP' UNION  
  SELECT 'D3SP' UNION  
  SELECT 'D4SP' UNION  
  SELECT 'D5SP' UNION  
  SELECT 'D6SP' UNION  
  SELECT 'D7SP' UNION  
  SELECT 'D8SP' UNION  
  SELECT 'D9SP' UNION  
  SELECT 'FSP' UNION  
  SELECT 'JSP' UNION  
  SELECT 'QSP' UNION  
  SELECT 'R3SP' UNION  
  SELECT 'YSP' UNION  
  SELECT 'YYSP'  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row  VARCHAR(1005),  
  Consecutivo INT  
 )  
  
 -- creo tabla temporal de TACs  
 DECLARE @tmp_tblTACs TABLE (  
  txtId1  VARCHAR(11),  
  txtCalculator  CHAR(20),  
  txtTv CHAR(4),  
  txtEmisora CHAR(7),  
  txtSerie CHAR(6),  
  txtNOM CHAR(14),  
  txtVNA CHAR(14),  
  txtValue CHAR(14),  
  txtCusLoc CHAR(3),  
  txtCountry CHAR(2),  
  txtFirstPayDate CHAR(8),  
  txtCupon CHAR(4),  
  txtNextPayDate CHAR(8),  
  txtPrevPayDate CHAR(8),  
  txtIncomeCycleCode CHAR(1),  
  txtFieldAftertheabove CHAR(3),  
  txtInterestRateSetDate CHAR(8)  
  PRIMARY KEY(txtId1)  
 )  
  
 -- Obtengo el Universo de Instrumentos para obtener sus TACs  
 INSERT @tmp_tblTACs  
 SELECT   
  a.txtId1 AS txtId1,  
  (SELECT txtCalculator   
   FROM MxFixIncome.dbo.tblValuationMap   
   WHERE RTRIM(txtType) + '/' + RTRIM(txtSubType) = RTRIM(i.txtFAM)  
  ) AS txtCalculator,  
  a.txtTV AS txtTV,  
  a.txtEmisora AS txtEmisora,  
  a.txtSerie AS txtSerie,  
  CASE WHEN i.txtNOM <> '-' AND i.txtNOM <> 'NA' AND i.txtNOM <> ''   
   THEN STR(ROUND(CAST(txtNOM AS FLOAT),6),14,5)  -- i.txtNOM   
   ELSE REPLICATE(' ',13) + '0'  
  END AS txtNOM,  
  CASE WHEN i.txtVNA <> '-' AND i.txtVNA <> 'NA' AND i.txtVNA <> ''   
   THEN STR(ROUND(CAST(txtVNA AS FLOAT),6),14,5)  -- i.txtVNA  
   ELSE REPLICATE(' ',13) + '0'  
  END AS txtVNA,  
  '         0' AS dblValue,  
  'CDP' AS txtCusLoc,  
  'ZZ' AS txtCountry,  
  '        ' AS txtFirstPayDate,  
  '0000' AS txtCupon,  
  '        ' AS txtNextPayDate,  
  CASE   
      WHEN (i.txtLCR <> 'NA' AND i.txtLCR <> '-' AND i.txtLCR <> '')   
   THEN SUBSTRING(i.txtLCR,7,2) + SUBSTRING(i.txtLCR,5,2) + SUBSTRING(i.txtLCR,1,4)  
      ELSE REPLICATE(' ',8)  
  END AS txtPrevPayDate,  
  ' ' AS txtIncomeCycleCode,  
  '   ' AS txtFieldAftertheabove,  
  '        ' AS txtInterestRateSetDate  
 FROM MxFixIncome.dbo.tmp_tblActualPrices AS a (NOLOCK)   
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS i (NOLOCK)   
   ON i.txtId1 = a.txtId1  
    AND i.txtLiquidation = (  
     CASE a.txtLiquidation    
      WHEN 'MP' THEN 'MD'    
      ELSE a.txtLiquidation    
     END)  
 WHERE a.txtLiquidation IN (@txtLiquidation,'MP')            
  AND a.txtTv NOT IN (SELECT TVs FROM @tmp_tblUNIExclude)  
    AND a.txtId1 NOT IN ('MHMG5200001','MHMG5200002','MHMG5200003','MHMG5200005','MHMG5200006','MHMG5200007','MHMG5200008','MHMG5200009','MHMH5200001',  
       'MHMH5200002','MHMH5200003','MHMH5200004',  
   'MIRC0004558','MIRC0004559','MIRC0004560','MIRC0004551','MIRC0004552','MIRC0004553','MIRC0004554','MIRC0004555',  
   'MIRC0004556','MIRC0004561','MIRC0004562','MIRC0004563','MIRC0004565','MIRC0004566','MIRC0004567','MIRC0004568',  
   'MIRC0004569','MIRC0004570','MIRC0004572','MIRC0004573','MIRC0004574','MIRC0004577',  
   'MIRC0004579','MIRC0004580','MIRC0004581','MIRC0004582','MIRC0004583','MIRC0004584','MIRC0004586','MIRC0004587',  
   'MIRC0004588','MIRC0004589','MIRC0004590','MIRC0004591', 'MDTJ0000032', 'MDTK0000002','MIRC0008948','UIRC0008070')  
  
 -- Aseguro la clasificacion de todas las Familias de Bonos  
 UPDATE tac   
  SET txtCalculator = (SELECT txtCalculator   
     FROM MxFixIncome.dbo.tblValuationMap (NOLOCK)  
     WHERE RTRIM(txtType) + '/' + RTRIM(txtSubType) = RTRIM(b.txtType) + '/' + RTRIM(b.txtSubType)  
        )  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblBonds AS b (NOLOCK)  
   ON tac.txtId1 = b.txtId1  
  
 -- Obtengo los Valores Nominales por instrumento  
 UPDATE @tmp_tblTACs SET txtValue = STR(ROUND(CAST(txtVNA AS FLOAT),6),14,5) WHERE RTRIM(txtCalculator) = 'CUP_BOND' OR RTRIM(txtCalculator) = 'BREM_BOND'  
 UPDATE @tmp_tblTACs SET txtValue = STR(ROUND(CAST(txtNOM AS FLOAT),6),14,5) WHERE RTRIM(txtCalculator) = 'ZERO_BOND'  
  
 UPDATE tac   
  SET txtValue = STR(ROUND(a.dblFactor,6),14,5)  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblBonds AS b (NOLOCK)  
   ON tac.txtId1 = b.txtId1  
  INNER JOIN MxFixIncome.dbo.tblAmortizations AS a (NOLOCK)  
   ON tac.txtId1 = a.txtId1  
 WHERE  
  a.dteAmortization = (  
   SELECT MAX(dteAmortization)  
   FROM MxFixIncome.dbo.tblAmortizations (NOLOCK)  
   WHERE  
    txtId1 = a.txtId1  
  )  
  
 -- Los Borhis por solicitud de cliente en Cero  
 UPDATE @tmp_tblTACs SET txtValue = '             0' WHERE RTRIM(txtTV) = '97'  
  
 -- Se Determina el lugar en que son depositados los instrumentos  
 UPDATE @tmp_tblTACs SET txtCusLoc = 'ADR'  WHERE RTRIM(txtTV) IN ('YY','YYSP')   
 UPDATE @tmp_tblTACs SET txtCusLoc = 'CPO'  WHERE RTRIM(txtTV) IN ('YY','YYSP') AND RTRIM(txtSerie) LIKE '%CPO%'  
  
 -- BEG: Optimización Query: Info Countries  
 INSERT @tmp_tblKEYsCountries   
 SELECT tadd.txtId1,MAX(dteDate)  
 FROM @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
   ON tac.txtId1 = tadd.txtId1  
    AND txtItem = 'COUNTRY'  
 GROUP BY tadd.txtId1  
  
 -- Obtengo el codigo de pais  
 UPDATE tac   
  SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN @tmp_tblKEYsCountries AS tkc  
   ON tac.txtId1 = tkc.txtId1  
  INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1   
    AND i.dteDate = tkc.dteDate  
    AND i.txtItem = 'COUNTRY'  
 -- END: Optimización Query: Info Countries  
  
  
 -- Obtengo la fecha de pago del primer cupon del instrumento   
 UPDATE tac   
  SET txtFirstPayDate = SUBSTRING(CONVERT(CHAR(8),i.dteEnd,112),7,2) + SUBSTRING(CONVERT(CHAR(8),i.dteEnd,112),5,2) + SUBSTRING(CONVERT(CHAR(8),i.dteEnd,112),1,4),  
   txtPrevPayDate =  REPLACE(CONVERT(CHAR(10),  
     (SELECT MxFixIncome.dbo.fun_NextTradingDate(  
      i.dteEnd  
     ,-5,'MX'))  
     ,103),'/','')   
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblBondsCupCalendar AS i (NOLOCK)   
   ON tac.txtId1 = i.txtId1  
    AND i.intCupId = '1'  
  
 -- BEG: Optimización Query: Info Siguiente Cupon Vigente y Número cupon vigente  
 INSERT @tmp_tblKEYsCupCalendar     
 SELECT b.txtId1,b.intCupId,MIN(b.dteBeg)  
 FROM @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblBondsCupCalendar b (NOLOCK)  
   ON b.txtId1 = tac.txtId1  
    AND b.intCupId > 0   
    AND b.dteBeg <= @txtDate   
    AND b.dteEnd > @txtDate   
 GROUP BY b.txtId1,b.intCupId  
  
 -- Solicitud2_20081208: Inicializo para TV = 95 valor por Default  
 UPDATE tac   
  SET  txtCupon = '0001'  
 FROM   
  @tmp_tblTACs  AS tac  
 WHERE RTRIM(txtTV) = '95'  
  
 -- Obtengo la fecha del siguiente cupon vigente del instrumento y el número de cupon vigente  
 UPDATE tac   
  SET txtNextPayDate = SUBSTRING(CONVERT(CHAR(8),b.dteEnd,112),7,2) + SUBSTRING(CONVERT(CHAR(8),b.dteEnd,112),5,2) + SUBSTRING(CONVERT(CHAR(8),b.dteEnd,112),1,4),  
      txtCupon = SUBSTRING(REPLACE(STR(ROUND(b.intCupId,0),4,0),  ' ', '0'), 1, 4)  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN @tmp_tblKEYsCupCalendar AS tkc  
   ON tac.txtId1 = tkc.txtId1  
  INNER JOIN MxFixIncome.dbo.tblBondsCupCalendar AS b (NOLOCK)   
   ON b.txtId1 = tkc.txtId1  
    AND b.intCupId = tkc.intCupId  
    AND b.dteBeg = tkc.dteBeg  
 -- END: Optimización Query: Info Siguiente Cupon Vigente y Número cupon vigente  
  
 /* Solicitud1_20080715: Emisoras que aun no pagan el primer cupón poner en blanco hasta que pague el primer cupon */  
 UPDATE tac   
  SET txtFirstPayDate = '        '  
 FROM   
  @tmp_tblTACs  AS tac  
 WHERE (txtFirstPayDate <> '-' AND txtFirstPayDate <> 'NA' AND txtFirstPayDate <> '')  
  AND txtCupon <= 1  
  AND CONVERT(DATETIME,SUBSTRING(txtFirstPayDate,5,4) + SUBSTRING(txtFirstPayDate,3,2) + SUBSTRING(txtFirstPayDate,1,2)) > @txtDate  
  
  
 -- BEG: Optimización Query: Info número de cupon para instrumentos Accionarios  
 INSERT @tmp_tblKEYsEquityAdd   
 SELECT tadd.txtId1,MAX(dteDate)  
 FROM @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblEquityAdd tadd (NOLOCK)  
   ON tac.txtId1 = tadd.txtId1  
    AND txtItem = 'PCR'  
 GROUP BY tadd.txtId1  
  
  -- Solicitud2_20080605: Obtengo número de cupon para instrumentos Accionarios  
 UPDATE tac   
  SET  txtCupon = SUBSTRING(REPLACE(STR(ROUND(CAST(i.txtValue AS FLOAT),0),4,0),  ' ', '0'), 1, 4)  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN @tmp_tblKEYsEquityAdd AS tkc  
   ON tac.txtId1 = tkc.txtId1  
  INNER JOIN MxFixIncome.dbo.tblEquityAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1   
    AND i.dteDate = tkc.dteDate  
    AND i.txtItem = 'PCR'  
  
 INSERT @tmp_tblKEYsIRCAdd   
 SELECT tadd.txtIRC,MAX(dteDate)  
 FROM @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblIRCAdd tadd (NOLOCK)  
   ON tac.txtEmisora = tadd.txtIRC  
    AND tadd.txtItem = 'PCR'  
 GROUP BY tadd.txtIRC  
  
  -- Para TV = 1B  
 UPDATE tac   
  SET  txtCupon = SUBSTRING(REPLACE(STR(ROUND(CAST(i.txtValue AS FLOAT),0),4,0),  ' ', '0'), 1, 4)  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN @tmp_tblKEYsIRCAdd AS tkc  
   ON tac.txtEmisora = tkc.txtIRC  
  INNER JOIN MxFixIncome.dbo.tblIRCAdd AS i (NOLOCK)   
   ON i.txtIRC = tkc.txtIRC   
    AND i.dteDate = tkc.dteDate  
    AND i.txtItem = 'PCR'  
 -- END: Optimización Query: Info número de cupon para instrumentos Accionarios  
  
 -- BEG: Optimización Query: Info Frecuencia Pago Cupon  
 INSERT @tmp_tblKEYsBondsAddCPF  
 SELECT tadd.txtId1,MAX(dteDate)  
 FROM @tmp_tblTACs  AS tac  
  INNER JOIN MxFixIncome.dbo.tblBondsAdd tadd (NOLOCK)  
   ON tac.txtId1 = tadd.txtId1  
    AND tadd.txtItem = 'CPF'  
    AND tadd.txtValue <> '0'  
 GROUP BY tadd.txtId1  
  
 -- Obtengo la Frecuencia Pago Cupon  
 UPDATE tac   
  SET txtIncomeCycleCode = CONVERT(CHAR(1),SUBSTRING(i.txtValue,4,1)),  
      txtFieldAftertheabove = CONVERT(CHAR(3),SUBSTRING(i.txtValue,1,3))  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN @tmp_tblKEYsBondsAddCPF AS tkc  
   ON tac.txtId1 = tkc.txtId1  
  INNER JOIN MxFixIncome.dbo.tblBondsAdd AS i (NOLOCK)   
   ON i.txtId1 = tkc.txtId1  
    AND i.dteDate = tkc.dteDate  
    AND i.txtItem = 'CPF'  
 -- END: Optimización Query: Info Frecuencia Pago Cupon  
  
 -- Homologacion de Frencuencia de Pago Cupon  
 UPDATE @tmp_tblTACs SET txtIncomeCycleCode = 'H' WHERE txtIncomeCycleCode = 'S'  
 UPDATE @tmp_tblTACs SET txtIncomeCycleCode = 'X' WHERE txtIncomeCycleCode = 'D' AND txtFieldAftertheabove = '360'  
  
 -- BEG: Optimización Query: Info Fecha del siguiente corte de cupón menos cinco días hábiles  
 INSERT @tmp_tblNextPayDate  
 SELECT DISTINCT txtNextPayDate,NULL  
 FROM @tmp_tblTACs   
 WHERE   
  txtNextPayDate <> '-'   
  AND txtNextPayDate <> 'NA'   
  AND txtNextPayDate <> ''   
  
 /* Solicitud_20080609: Implemento Proceso con las funciones NextTrading  */  
 -- Fecha del siguiente corte de cupón menos cinco días hábiles.  
 UPDATE @tmp_tblNextPayDate  
 SET txtNextPayDate_Last5 =  REPLACE(CONVERT(CHAR(10),  
     (SELECT MxFixIncome.dbo.fun_NextTradingDate(  
      SUBSTRING(txtNextPayDate,5,4) + SUBSTRING(txtNextPayDate,3,2) + SUBSTRING(txtNextPayDate,1,2)  
     ,-5,'MX'))  
     ,103),'/','')   
  
 UPDATE tac   
 SET txtInterestRateSetDate = tkc.txtNextPayDate_Last5  
 FROM   
  @tmp_tblTACs  AS tac  
  INNER JOIN @tmp_tblNextPayDate AS tkc  
   ON tac.txtNextPayDate = tkc.txtNextPayDate  
 -- END: Optimización Query: Info Fecha del siguiente corte de cupón menos cinco días hábiles  
  
 -- Declaracion de Constantes  
 DECLARE @ctsBlank AS CHAR(58)  
 DECLARE @ctsReceivableTrade AS CHAR(1)  
 DECLARE @ctsForeignOwned AS CHAR(1)  
 DECLARE @ctsForeignSecurity AS CHAR(1)  
   
 DECLARE @ctsLendingIndc AS CHAR(1)  
 DECLARE @ctsBorrowingIndc AS CHAR(1)  
 DECLARE @ctsScripIndc AS CHAR(1)  
 DECLARE @ctsQuantityType AS CHAR(3)  
 DECLARE @ctsOddLotIndc AS CHAR(1)  
   
 DECLARE @ctsPoolIndc AS CHAR(1)  
 DECLARE @ctsInvestmentPlanCod AS CHAR(1)  
 DECLARE @ctsMarketStatusCode AS CHAR(1)  
 DECLARE @ctsTradingLimit AS CHAR(1)  
 DECLARE @ctsSecTaxType AS CHAR(6)  
 DECLARE @ctsPrcDivisor AS CHAR(13)  
 DECLARE @ctsParvalue AS CHAR(14)  
 DECLARE @ctsScpFeeChrgCalcCode AS CHAR(3)  
 DECLARE @ctsExceptionMovementQty AS CHAR(13)  
 DECLARE @ctsForeignOwnershipLimitTot AS CHAR(8)  
 DECLARE @ctsIndv AS CHAR(8)  
 DECLARE @ctsCust AS CHAR(8)  
 DECLARE @ctsMaxTotIndvOwnershipLimit AS CHAR(8)  
 DECLARE @ctsMaxIndvOwnershipLimit AS CHAR(8)  
 DECLARE @ctsRemarksLine1 AS CHAR(35)  
 DECLARE @ctsRemarksLine2 AS CHAR(35)  
 DECLARE @ctsRemarksLine3 AS CHAR(35)  
 DECLARE @ctsRemarksLine4 AS CHAR(35)  
 DECLARE @ctsSectorcode AS CHAR(3)  
   
 DECLARE @ctsOptionExpnDt AS CHAR(8)  
 DECLARE @ctsStampDutyRate AS CHAR(8)  
 DECLARE @ctsStrkPrc AS CHAR(14)  
 DECLARE @ctsSplitIssue AS CHAR(1)  
   
 DECLARE @ctsLoanMargin AS CHAR(8)  
 DECLARE @ctsBoardLotAmount AS CHAR(13)  
 DECLARE @ctsPhysicalMinDen AS CHAR(13)  
 DECLARE @ctsPhysicalMinIncr AS CHAR(13)  
 DECLARE @ctsCompanyGroupID AS CHAR(4)  
 DECLARE @ctsExcludefromCollateralforCertainCustomers AS CHAR(1)  
   
 DECLARE @ctsLocStatus AS CHAR(2)  
 DECLARE @ctsLocationMinDen AS CHAR(13)  
 DECLARE @ctsLocSecCod AS CHAR(12)  
 DECLARE @ctsLocProcsCod AS CHAR(2)  
 DECLARE @ctsLocationMinIncr AS CHAR(13)  
 DECLARE @ctsCstdyLocSecDesc AS CHAR(40)  
 DECLARE @ctsNetSettlement AS CHAR(1)  
 DECLARE @ctsRegistrar AS CHAR(10)  
 DECLARE @ctsPayAgentID AS CHAR(10)  
 DECLARE @ctsInfoAgentID AS CHAR(10)  
   
 DECLARE @ctsInterestRoundMethod AS CHAR(1)  
 DECLARE @ctsInterestCalcCode AS CHAR(1)  
 DECLARE @ctsIncomeType AS CHAR(1)  
 DECLARE @ctsIntRate AS CHAR(11)  
 DECLARE @ctsPresentmentRequired AS CHAR(1)  
   
 DECLARE @ctsLongShortCode AS CHAR(1)  
 DECLARE @ctsContractualIncome AS CHAR(1)  
 DECLARE @ctsContrSetlPostReceipt AS CHAR(1)  
 DECLARE @ctsContrSetlPostDelivery AS CHAR(1)  
 DECLARE @ctsPriSecTemplate AS CHAR(4)  
 DECLARE @ctsAutomaticTrade AS CHAR(1)  
 DECLARE @ctsEntitlementBasis AS CHAR(1)  
 DECLARE @ctsReportingIntType AS CHAR(1)  
 DECLARE @ctsCountryCode1 AS CHAR(2)  
 DECLARE @ctsValidationFlags1 AS CHAR(3)  
 DECLARE @ctsCountryCode2 AS CHAR(2)  
 DECLARE @ctsValidationFlags2 AS CHAR(3)  
 DECLARE @ctsCountryCode3 AS CHAR(2)  
 DECLARE @ctsValidationFlags3 AS CHAR(3)  
 DECLARE @ctsCountryCode4 AS CHAR(2)  
 DECLARE @ctsValidationFlags4 AS CHAR(3)  
 DECLARE @ctsCountryCode5 AS CHAR(2)  
 DECLARE @ctsValidationFlags5 AS CHAR(3)  
 DECLARE @ctsCountryCode6 AS CHAR(2)  
 DECLARE @ctsValidationFlags6 AS CHAR(3)  
 DECLARE @ctsCountryCode7 AS CHAR(2)  
 DECLARE @ctsValidationFlags7 AS CHAR(3)  
 DECLARE @ctsCountryCode8 AS CHAR(2)  
 DECLARE @ctsValidationFlags8 AS CHAR(3)  
 DECLARE @ctsCountryCode9 AS CHAR(2)  
 DECLARE @ctsValidationFlags9 AS CHAR(3)  
 DECLARE @ctsCountryCode10 AS CHAR(2)  
 DECLARE @ctsValidationFlags10 AS CHAR(3)  
 DECLARE @ctsCountryCode11 AS CHAR(2)  
 DECLARE @ctsValidationFlags11 AS CHAR(3)  
 DECLARE @ctsCountryCode12 AS CHAR(2)  
 DECLARE @ctsValidationFlags12 AS CHAR(3)  
 DECLARE @ctsCountryCode13 AS CHAR(2)  
 DECLARE @ctsValidationFlags13 AS CHAR(3)  
 DECLARE @ctsCountryCode14 AS CHAR(2)  
 DECLARE @ctsValidationFlags14 AS CHAR(3)  
 DECLARE @ctsCountryCode15 AS CHAR(2)  
 DECLARE @ctsValidationFlags15 AS CHAR(3)  
 DECLARE @ctsCountryCode16 AS CHAR(2)  
 DECLARE @ctsValidationFlags16 AS CHAR(3)  
 DECLARE @ctsCountryCode17 AS CHAR(2)  
 DECLARE @ctsValidationFlags17 AS CHAR(3)  
 DECLARE @ctsCountryCode18 AS CHAR(2)  
 DECLARE @ctsValidationFlags18 AS CHAR(3)  
 DECLARE @ctsCountryCode19 AS CHAR(2)  
 DECLARE @ctsValidationFlags19 AS CHAR(3)  
 DECLARE @ctsCountryCode20 AS CHAR(2)  
 DECLARE @ctsValidationFlags20 AS CHAR(3)  
 DECLARE @ctsCountryCode21 AS CHAR(2)  
 DECLARE @ctsValidationFlags21 AS CHAR(3)  
 DECLARE @ctsCountryCode22 AS CHAR(2)  
 DECLARE @ctsValidationFlags22 AS CHAR(3)  
 DECLARE @ctsCountryCode23 AS CHAR(2)  
 DECLARE @ctsValidationFlags23 AS CHAR(3)  
 DECLARE @ctsCountryCode24 AS CHAR(2)  
 DECLARE @ctsValidationFlags24 AS CHAR(3)  
 DECLARE @ctsCountryCode25 AS CHAR(2)  
 DECLARE @ctsValidationFlags25 AS CHAR(3)  
 DECLARE @ctsCountryCode26 AS CHAR(2)  
 DECLARE @ctsValidationFlags26 AS CHAR(3)  
 DECLARE @ctsCountryCode27 AS CHAR(2)  
 DECLARE @ctsValidationFlags27 AS CHAR(3)  
 DECLARE @ctsCountryCode28 AS CHAR(2)  
 DECLARE @ctsValidationFlags28 AS CHAR(3)  
 DECLARE @ctsCountryCode29 AS CHAR(2)  
 DECLARE @ctsValidationFlags29 AS CHAR(3)  
 DECLARE @ctsCountryCode30 AS CHAR(2)  
 DECLARE @ctsValidationFlags30 AS CHAR(3)  
  
  
 -- Asignación de Valores Constantes  
 SET @ctsBlank = REPLICATE(' ',58)                           -- (8)Constante: Espacios en blanco(58)  
 SET @ctsReceivableTrade = 'Y'                           -- (9)Constante: “Y”(1)  
 SET @ctsForeignOwned = 'B'                           -- (10)Constante: “B”(1)  
 SET @ctsForeignSecurity = 'N'                           -- (11)Constante: “N”(1)  
  
 SET @ctsLendingIndc = 'N'                            -- (14)Constante: “N” (1)  
 SET @ctsBorrowingIndc = 'N'                          -- (15)Constante: “N”(1)  
 SET @ctsScripIndc = 'N'                            -- (16)Constante: “N”(1)  
 SET @ctsQuantityType = 'UNT'                           -- (17)Constante: “SHS”(3)  
 SET @ctsOddLotIndc = 'Y'                           -- (18)Constante: “Y”(1)  
   
 SET @ctsPoolIndc = 'N'                            -- (20)Constante: “N”(1)  
 SET @ctsInvestmentPlanCod = ' '                           -- (21)Constante: Espacios en blanco(1)  
 SET @ctsMarketStatusCode = 'N'                           -- (22)Constante: “N”(1)  
 SET @ctsTradingLimit = 'N'                           -- (23)Constante: “N”(1)  
 SET @ctsSecTaxType = REPLICATE(' ',6)                          -- (24)Constante: Espacios en blanco(6)  
 SET @ctsPrcDivisor = '1' + REPLICATE(' ',12)                         -- (25)Constante: “1”(13)  
 SET @ctsParvalue = '0' + REPLICATE(' ',13)           -- (26)Constante: “0”(14)  
 SET @ctsScpFeeChrgCalcCode = '999'                          -- (27)Constante: “999 ”(3)  
 SET @ctsExceptionMovementQty = REPLICATE(' ',13)                        -- (28)Constante: Espacios en blanco(13)  
 SET @ctsForeignOwnershipLimitTot = '100.0000'                          -- (29)Constante: “100.0000”(8)  
 SET @ctsIndv = '100.0000'                           -- (30)Constante: “ 100.0000”(8)  
 SET @ctsCust = '100.0000'                           -- (31)Constante: “ 100.0000”(8)  
 SET @ctsMaxTotIndvOwnershipLimit = '100.0000'                         -- (32)Constante: “ 100.0000”(8)  
 SET @ctsMaxIndvOwnershipLimit = '100.0000'                         -- (33)Constante: “ 100.0000”(8)  
 SET @ctsRemarksLine1 = REPLICATE(' ',35)                         -- (34)Constante: Espacios en blanco(35)  
 SET @ctsRemarksLine2 = REPLICATE(' ',35)                         -- (35)Constante: Espacios en blanco(35)  
 SET @ctsRemarksLine3 = REPLICATE(' ',35)                         -- (36)Constante: Espacios en blanco(35)  
 SET @ctsRemarksLine4 = REPLICATE(' ',35)                         -- (37)Constante: Espacios en blanco(35)  
 SET @ctsSectorcode =  REPLICATE(' ',3)                         -- (38)Constante: Espacios en blanco(3)  
   
 SET @ctsOptionExpnDt = REPLICATE(' ',8)                          -- (43)Constante: Espacios en blanco(8)  
 SET @ctsStampDutyRate = '0' + REPLICATE(' ',7)                         -- (44)Constante: “0”(8)  
 SET @ctsStrkPrc = REPLICATE(' ',14)                          -- (45)Constante: Espacios en blanco(14)  
 SET @ctsSplitIssue = 'N'                           -- (46)Constante: “N”(1)  
   
 SET @ctsLoanMargin = '0' + REPLICATE(' ',7)                         -- (48)Constante: “0”(8)  
 SET @ctsBoardLotAmount = '1' + REPLICATE(' ',12)                        -- (49)Constante: “1”(13)  
 SET @ctsPhysicalMinDen = REPLICATE(' ',13)                         -- (50)Constante: Espacios en blanco(13)  
 SET @ctsPhysicalMinIncr = REPLICATE(' ',13)                         -- (51)Constante: Espacios en blanco.(13)  
 SET @ctsCompanyGroupID = REPLICATE(' ',4)                         -- (52)Constante: Espacios en blanco.(4)  
 SET @ctsExcludefromCollateralforCertainCustomers = 'N'                  -- (53)Constante: “N”(1)  
   
 SET @ctsLocStatus = REPLICATE(' ',2)                          -- (55)Constante: Espacios en blanco.(2)  
 SET @ctsLocationMinDen = REPLICATE(' ',13)                         -- (56)Constante: Espacios en blanco.(13)  
 SET @ctsLocSecCod =  REPLICATE(' ',12)                         -- (57)Constante: Espacios en blanco.(12)  
 SET @ctsLocProcsCod = REPLICATE(' ',2)                          -- (58)Constante: Espacios en blanco.(2)  
 SET @ctsLocationMinIncr = REPLICATE(' ',13)                         -- (59)Constante: Espacios en blanco.(13)  
 SET @ctsCstdyLocSecDesc = REPLICATE(' ',40)                         -- (60)Constante: Espacios en blanco.(40)  
 SET @ctsNetSettlement = 'N'                           -- (61)Constante: “N”(1)  
 SET @ctsRegistrar = REPLICATE(' ',10)                          -- (62)Constante: Espacios en blanco.(10)  
 SET @ctsPayAgentID = REPLICATE(' ',10)                           -- (63)Constante: Espacios en blanco.(10)  
 SET @ctsInfoAgentID = REPLICATE(' ',10)                          -- (64)Constante: Espacios en blanco.(10)  
   
 SET @ctsInterestRoundMethod = ' '                           -- (72)Constante: Espacios en blanco.(1)  
 SET @ctsInterestCalcCode = ' '                           -- (73)Constante: Espacios en blanco.(1)  
 SET @ctsIncomeType = ' '                            -- (74)Constante: Espacios en blanco.(1)  
 SET @ctsIntRate = REPLICATE(' ',11)                          -- (75)Constante: Espacios en blanco.(11)  
 SET @ctsPresentmentRequired = 'N'                          -- (76)Constante: “N”(1)  
   
 SET @ctsLongShortCode = ' '                           -- (79)Constante: Espacios en blanco.(1)  
 SET @ctsContractualIncome = 'N'                           -- (80)Constante: “N”(1)  
 SET @ctsContrSetlPostReceipt = 'N'                          -- (81)Constante: “N”(1)  
 SET @ctsContrSetlPostDelivery = 'N'                          -- (82)Constante: “N”(1)  
 SET @ctsPriSecTemplate = REPLICATE(' ',4)                         -- (83)Constante: Espacios en blanco.(4)  
 SET @ctsAutomaticTrade = 'N'                           -- (84)Constante: “N”(1)  
 SET @ctsEntitlementBasis = 'T'                           -- (85)Constante: “T”(1)  
 SET @ctsReportingIntType = ' '                           -- (86)Constante: Espacios en blanco.(1)  
 SET @ctsCountryCode1 = REPLICATE(' ',2)                          -- (87)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags1 = REPLICATE(' ',3)                         -- (88)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode2 = REPLICATE(' ',2)                          -- (89)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags2 = REPLICATE(' ',3)                         -- (90)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode3 = REPLICATE(' ',2)                          -- (91)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags3 = REPLICATE(' ',3)                         -- (92)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode4 = REPLICATE(' ',2)                          -- (93)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags4 = REPLICATE(' ',3)                          -- (94)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode5 = REPLICATE(' ',2)                          -- (95)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags5 = REPLICATE(' ',3)                         -- (96)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode6 = REPLICATE(' ',2)                          -- (97)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags6 = REPLICATE(' ',3)                         -- (98)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode7 = REPLICATE(' ',2)                          -- (99)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags7 = REPLICATE(' ',3)                          -- (100)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode8 = REPLICATE(' ',2)                          -- (101)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags8 = REPLICATE(' ',3)                         -- (102)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode9 = REPLICATE(' ',2)                          -- (103)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags9 = REPLICATE(' ',3)                         -- (104)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode10 = REPLICATE(' ',2)                         -- (105)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags10 = REPLICATE(' ',3)                         -- (106)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode11 = REPLICATE(' ',2)                         -- (107)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags11 = REPLICATE(' ',3)                         -- (108)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode12 = REPLICATE(' ',2)                         -- (109)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags12 = REPLICATE(' ',3)                         -- (110)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode13 = REPLICATE(' ',2)                         -- (111)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags13 = REPLICATE(' ',3)                         -- (112)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode14 = REPLICATE(' ',2)                         -- (113)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags14 = REPLICATE(' ',3)                         -- (114)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode15 = REPLICATE(' ',2)                         -- (115)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags15 = REPLICATE(' ',3)       -- (116)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode16 = REPLICATE(' ',2)                         -- (117)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags16 = REPLICATE(' ',3)            -- (118)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode17 = REPLICATE(' ',2)                         -- (119)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags17 = REPLICATE(' ',3)                         -- (120)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode18 = REPLICATE(' ',2)                         -- (121)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags18 = REPLICATE(' ',3)                         -- (122)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode19 = REPLICATE(' ',2)                         -- (123)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags19 = REPLICATE(' ',3)                         -- (124)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode20 = REPLICATE(' ',2)                         -- (125)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags20 = REPLICATE(' ',3)                         -- (126)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode21 = REPLICATE(' ',2)                         -- (127)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags21 = REPLICATE(' ',3)                         -- (128)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode22 = REPLICATE(' ',2)                         -- (129)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags22 = REPLICATE(' ',3)                         -- (130)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode23 = REPLICATE(' ',2)                         -- (131)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags23 = REPLICATE(' ',3)                         -- (132)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode24 = REPLICATE(' ',2)                         -- (133)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags24 = REPLICATE(' ',3)                         -- (134)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode25 = REPLICATE(' ',2)                         -- (135)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags25 = REPLICATE(' ',3)                         -- (136)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode26 = REPLICATE(' ',2)                         -- (137)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags26 = REPLICATE(' ',3)                         -- (138)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode27 = REPLICATE(' ',2)                         -- (139)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags27 = REPLICATE(' ',3)                         -- (140)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode28 = REPLICATE(' ',2)                         -- (141)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags28 = REPLICATE(' ',3)                         -- (142)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode29 = REPLICATE(' ',2)                         -- (143)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags29 = REPLICATE(' ',3)                     -- (144)Constante: Espacios en blanco.(3)  
 SET @ctsCountryCode30 = REPLICATE(' ',2)                         -- (145)Constante: Espacios en blanco.(2)  
 SET @ctsValidationFlags30 = REPLICATE(' ',3)                         -- (146)Constante: Espacios en blanco.(3)  
  
 INSERT @tmp_tblResults  
 SELECT  -- a.txtTv +'_'+ a.txtEmisora + '_' + a.txtSerie +'_' + a.txtId1+'_' + i.txtId2 + '|'+  
  -- a.txtTv +'_'+ a.txtEmisora + '_' + a.txtSerie  + '|'+  
  CASE   
       WHEN LEN(LTRIM(RTRIM(i.txtId2))) = 12 THEN LTRIM(RTRIM(i.txtId2)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(i.txtId2)))) + 'I'  
       ELSE REPLICATE(' ',12) + ' '   
  END +        -- SecurityCode + Identificador (12+1)  
  CONVERT(CHAR(4),a.txtTv) + ' ' + CONVERT(CHAR(7),a.txtEmisora) + ' ' + CONVERT(CHAR(6),a.txtSerie) + REPLICATE(' ',9) + -- @txtShortName +  
  CASE   
      WHEN SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,140) = '-' OR SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,140) = 'NA' OR i.txtNem IS NULL  
    THEN CONVERT(CHAR(140),REPLACE(REPLICATE(' ',4)+ CONVERT(CHAR(4),a.txtTv) + ' '   
       + CONVERT(CHAR(7),a.txtEmisora) + ' '   
       + CONVERT(CHAR(6),a.txtSerie) +   
     REPLICATE(' ',12+35),CHAR(9),' '))  
      ELSE  
    CONVERT(CHAR(140),REPLACE(REPLICATE(' ',4)+ CONVERT(CHAR(4),a.txtTv) + ' ' +   
      CONVERT(CHAR(7),a.txtEmisora) + ' ' +   
      CONVERT(CHAR(6),a.txtSerie) +   
     REPLICATE(' ',12+35) + i.txtNem,CHAR(9),' '))  
  END +          -- a.txtTv + a.txtEmisora + a.txtSerie + @txtName1(35) + @txtName2(35) + @txtName3(35) + @txtName4(35)  
  @ctsBlank +                               -- 8  
  @ctsReceivableTrade +                             -- 9  
  @ctsForeignOwned +                              -- 10  
  @ctsForeignSecurity +                             -- 11  
  CASE   
       WHEN t.txtCountry IS NULL THEN '--'  
       ELSE   
    CONVERT(CHAR(2),t.txtCountry)     -- @txtCountryCode  
  END +   
  CASE   
       WHEN a.txtTV IN ('D1','D1SP','D2','D2SP','D3','D3SP','D4','D4SP','D5','D5SP','D6','D6SP','D7','D7SP','D8','D8SP','JE','JI') THEN 'FDBI'  
       WHEN a.txtTV IN ('*F','FC','FCSP') THEN 'FDRV'  
       WHEN a.txtTV IN ('1A','1AFX','1ASP','1E','1ESP','1I','1ISP','56SP','YY','YYSP') THEN 'FEQU'  
       WHEN a.txtTV IN ('71','73','75','76','90','91','92','93','94','95','96','97','2P','2U','3P','3U','4P','4U','6U',  
        '93SP','D','IP','IS','IT','L','LD','LP','LS','LT','M','M0','M3','M5','M7','PI','Q','QSP','R','R1',  
        'S','S0','S3','S5','XA','*R','IM','IQ') THEN 'LBDI'  
       WHEN a.txtTV IN ('*D','F','FSP','J','JSP') THEN 'LDBI'  
       WHEN a.txtTV IN ('B','BI','CC','CP','MC','MP','SC','SP') THEN 'LDNB'  
       WHEN a.txtTV IN ('FA','FB','FD','FI','FM','FS','FU','OA','OD','OI','RC','SWT') THEN 'LDRV'  
       WHEN a.txtTV IN ('0','00','1','3','41','51','52','53','54','55','56','1B','CF') THEN 'LEQU'  
       WHEN a.txtTV IN ('WA','WASP','WC','WE','WESP','WI') THEN 'LWTS'  
       WHEN a.txtTV IN ('G','I','IL','P1') THEN 'NB  '  
       WHEN a.txtTV IN ('2') THEN 'OICS'  
       WHEN a.txtTV IN ('*C','*CSP') THEN 'NA  '  
       WHEN a.txtTV IN ('R3','R3SP','TR') THEN REPLICATE(' ',4)   
       ELSE   
   REPLICATE(' ',4)  
  END +         -- @txtSecurityType  
  @ctsLendingIndc +                              -- 14  
  @ctsBorrowingIndc +                              -- 15  
  @ctsScripIndc +                              -- 16  
  @ctsQuantityType +                              -- 17  
  @ctsOddLotIndc +                              -- 18  
  CASE   
      WHEN (i.txtCUR <> 'NA' AND i.txtCUR <> '-' AND i.txtCUR <> '') THEN  
     CASE   
    WHEN RTRIM(i.txtCUR)='[MPS] Peso Mexicano (MXN)' THEN 'MXN'  
    WHEN RTRIM(i.txtCUR)='[USD] Dolar Americano (MXN)' THEN 'USD'  
    WHEN RTRIM(i.txtCUR)='[UDI] Unidades de Inversion (MXN)' THEN 'UDI'  
    WHEN RTRIM(i.txtCUR)='[EUR] Euro (MXN)' THEN 'EUR'   
    WHEN RTRIM(i.txtCUR)='[JPY] Yen Japones (MXN)' THEN 'JPY'  
    WHEN RTRIM(i.txtCUR)='[ITL] Lira Italiana (MXN)' THEN 'ITL'  
    WHEN RTRIM(i.txtCUR)='[CHF] Franco Suizo (MXN)' THEN 'CHF'  
    WHEN RTRIM(i.txtCUR)='[DEM] Marco Aleman (MXN)' THEN 'DEM'  
    WHEN RTRIM(i.txtCUR)='[AUD] Dolar Australiano (MXN)' THEN 'AUD'  
    WHEN RTRIM(i.txtCUR)='[BRL] Real Brasileno (MXN)' THEN 'BRL'  
    WHEN RTRIM(i.txtCUR)='[GBP] Libra Inglesa (MXN)' THEN 'GBP'  
    WHEN RTRIM(i.txtCUR)='[ARS] Peso Argentino (MXN)' THEN 'ARS'  
    WHEN RTRIM(i.txtCUR)='[CAD] Dolar Canadiense (MXN)' THEN 'CAD'  
    WHEN RTRIM(i.txtCUR)='[CLP] Peso Chileno (MXN)' THEN 'CLP'  
    WHEN RTRIM(i.txtCUR)='[HKD] Hong Kong Dolar (MXN)' THEN 'HKD'  
    WHEN RTRIM(i.txtCUR)='[MYR] Ringgit Kuala Lumpur (MXN)' THEN 'MYR'  
    WHEN RTRIM(i.txtCUR)='[PEN] Sol Peruano (MXN)' THEN 'PEN'  
    WHEN RTRIM(i.txtCUR)='[SMG] Salario Minimo General' THEN 'SMG'  
    WHEN RTRIM(i.txtCUR)='(USD) Dolar Americano (MXN)' THEN 'USD'  
    WHEN RTRIM(i.txtCUR)='(UDI) Unidades de Inversion (MXN)' THEN 'UDI'  
    WHEN RTRIM(i.txtCUR)='(EUR) Euro (MXN)' THEN 'EUR'   
    WHEN RTRIM(i.txtCUR)='(JPY) Yen Japones (MXN)' THEN 'JPY'  
    WHEN RTRIM(i.txtCUR)='(ITL) Lira Italiana (MXN)' THEN 'ITL'  
    WHEN RTRIM(i.txtCUR)='(CHF) Franco Suizo (MXN)' THEN 'CHF'  
    WHEN RTRIM(i.txtCUR)='(DEM) Marco Aleman (MXN)' THEN 'DEM'  
    WHEN RTRIM(i.txtCUR)='(AUD) Dolar Australiano (MXN)' THEN 'AUD'  
    WHEN RTRIM(i.txtCUR)='(BRL) Real Brasileno (MXN)' THEN 'BRL'  
    WHEN RTRIM(i.txtCUR)='(GBP) Libra Inglesa (MXN)' THEN 'GBP'  
    WHEN RTRIM(i.txtCUR)='(ARS) Peso Argentino (MXN)' THEN 'ARS'  
    WHEN RTRIM(i.txtCUR)='(CAD) Dolar Canadiense (MXN)' THEN 'CAD'  
    WHEN RTRIM(i.txtCUR)='(CLP) Peso Chileno (MXN)' THEN 'CLP'  
    WHEN RTRIM(i.txtCUR)='(HKD) Hong Kong Dolar (MXN)' THEN 'HKD'  
    WHEN RTRIM(i.txtCUR)='(MYR) Ringgit Kuala Lumpur (MXN)' THEN 'MYR'  
    WHEN RTRIM(i.txtCUR)='(PEN) Sol Peruano (MXN)' THEN 'PEN'  
    WHEN RTRIM(i.txtCUR)='(SMG) Salario Minimo General' THEN 'SMG'  
    ELSE '   '  
   END   
     ELSE '   '  
  END  +        -- @txtBaseCurrency  
  @ctsPoolIndc +                              -- 20  
  @ctsInvestmentPlanCod +                             -- 21  
  @ctsMarketStatusCode +                             -- 22  
  @ctsTradingLimit +                              -- 23  
  @ctsSecTaxType +                              -- 24  
  @ctsPrcDivisor +                              -- 25  
  
  CASE WHEN i.txtVNA = '-' OR i.txtVNA = 'NA' OR i.txtVNA = '' THEN '0             '  
   ELSE LTRIM(RTRIM(STR(ROUND(CAST(i.txtVNA AS FLOAT),4),15,4))) + REPLICATE(' ',14-LEN(LTRIM(RTRIM(STR(ROUND(CAST(i.txtVNA AS FLOAT),4),15,4))))) --LTRIM(STR(ROUND(CAST(i.txtVNA AS FLOAT),4),15,4))  
  END +  
  
  --ROUND(i.txtVNA,4) +                              -- 26  
  @ctsScpFeeChrgCalcCode +                             -- 27  
  @ctsExceptionMovementQty +                             -- 28  
  @ctsForeignOwnershipLimitTot +                            -- 29  
  @ctsIndv +                               -- 30  
  @ctsCust +                               -- 31  
  @ctsMaxTotIndvOwnershipLimit +                            -- 32  
  @ctsMaxIndvOwnershipLimit +                             -- 33  
  @ctsRemarksLine1 +                              -- 34  
  @ctsRemarksLine2 +                              -- 35  
  @ctsRemarksLine3 +                              -- 36  
  @ctsRemarksLine4 +                              -- 37  
  @ctsSectorcode +                             -- 38  
  CASE   
      WHEN (i.txtISD <> 'NA' AND i.txtISD <> '-' AND i.txtISD <> '')   
   THEN SUBSTRING(i.txtISD,9,2) + SUBSTRING(i.txtISD,6,2) + SUBSTRING(i.txtISD,1,4)  
      ELSE REPLICATE(' ',8)  
  END  +        -- @txtIssueDate  
  CASE   
      WHEN (i.txtMTD <> 'NA' AND i.txtMTD <> '-' AND i.txtMTD <> '')   
   THEN SUBSTRING(i.txtMTD,9,2) + SUBSTRING(i.txtMTD,6,2) + SUBSTRING(i.txtMTD,1,4)  
      ELSE REPLICATE(' ',8)  
  END  +        -- @txtExpirationDate  
  CASE   
       WHEN a.txtTV LIKE '%SP%' THEN REPLICATE(' ',12)  
       ELSE  
     CASE   
        WHEN LEN(LTRIM(RTRIM(i.txtId2))) = 12 THEN LTRIM(RTRIM(i.txtId2)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(i.txtId2))))  
        ELSE REPLICATE(' ',12)  
          END   
  END +         -- @txtRptSecID  
  t.txtValue +        -- @dblExerPrice (NOM,VNA,FINISHAMORT)  
  @ctsOptionExpnDt +                              -- 43  
  @ctsStampDutyRate +                              -- 44  
  @ctsStrkPrc +                              -- 45  
  @ctsSplitIssue +                              -- 46  
  CASE   
      WHEN (i.txtTIE <> 'NA' AND i.txtTIE <> '-' AND i.txtTIE <> '' AND CAST(i.txtTIE AS FLOAT) <> 0)   
   THEN STR(ROUND(CAST(i.txtTIE AS FLOAT),0),13,0)  
      ELSE '    100000000'  
  END  +        -- txtTITTotalSecuritiesIssued  
  @ctsLoanMargin +                              -- 48  
  @ctsBoardLotAmount +                              -- 49  
  @ctsPhysicalMinDen +                              -- 50  
  @ctsPhysicalMinIncr +                             -- 51  
  @ctsCompanyGroupID +                              -- 52  
  @ctsExcludefromCollateralforCertainCustomers +                  -- 53  
  t.txtCusLoc +        -- @txtCustodyLocation  
  @ctsLocStatus +                              -- 55  
  @ctsLocationMinDen +                      -- 56  
  @ctsLocSecCod +                              -- 57  
  @ctsLocProcsCod +                     -- 58  
  @ctsLocationMinIncr +                             -- 59  
  @ctsCstdyLocSecDesc +                             -- 60  
  @ctsNetSettlement +                              -- 61  
  @ctsRegistrar +                              -- 62  
  @ctsPayAgentID +                              -- 63  
  @ctsInfoAgentID +                              -- 64  
  t.txtFirstPayDate +      -- @txtFirstPayDate +  
  CASE   
      WHEN (i.txtMTD <> 'NA' AND i.txtMTD <> '-' AND i.txtMTD <> '')   
   THEN SUBSTRING(i.txtMTD,9,2) + SUBSTRING(i.txtMTD,6,2) + SUBSTRING(i.txtMTD,1,4)  
      ELSE REPLICATE(' ',8)  
  END  +        -- @txtFinalPayDate  
  CASE   
      WHEN (ii.txtCALL_FDT <> 'NA' AND ii.txtCALL_FDT <> '-' AND ii.txtCALL_FDT <> '')   
   THEN SUBSTRING(ii.txtCALL_FDT,9,2) + SUBSTRING(ii.txtCALL_FDT,6,2) + SUBSTRING(ii.txtCALL_FDT,1,4)  
      ELSE REPLICATE(' ',8)  
  END  +        -- @txtFirstCallDate  
  t.txtNextPayDate +      -- @txtNextPayDate  txtNCR  
  t.txtPrevPayDate +          --  t.txtPrevPayDate = @txtPrevPayDate  
  t.txtNextPayDate +       -- @txtNextBookClose   
  t.txtInterestRateSetDate +     -- @txtInterestRateSetDate  
  @ctsInterestRoundMethod +                             -- 72  
  @ctsInterestCalcCode +                             -- 73  
  @ctsIncomeType +                              -- 74  
  @ctsIntRate +                              -- 75  
  @ctsPresentmentRequired +                             -- 76  
  t.txtIncomeCycleCode +       -- @txtIncomeCycleCode  
  t.txtFieldAftertheabove +      -- @txtFieldAftertheabove  
  @ctsLongShortCode +                              -- 79  
  @ctsContractualIncome +                             -- 80  
  @ctsContrSetlPostReceipt +                             -- 81  
  @ctsContrSetlPostDelivery +                             -- 82  
  @ctsPriSecTemplate +                            -- 83  
  @ctsAutomaticTrade +                              -- 84  
  @ctsEntitlementBasis +                             -- 85  
  @ctsReportingIntType +                             -- 86  
  @ctsCountryCode1 +                              -- 87  
  @ctsValidationFlags1 +                             -- 88  
  @ctsCountryCode2 +                              -- 89  
  @ctsValidationFlags2 +                             -- 90  
  @ctsCountryCode3 +                              -- 91  
  @ctsValidationFlags3 +                             -- 92  
  @ctsCountryCode4 +                              -- 93  
  @ctsValidationFlags4 +                             -- 94  
  @ctsCountryCode5 +                              -- 95  
  @ctsValidationFlags5 +                             -- 96  
  @ctsCountryCode6 +                              -- 97  
  @ctsValidationFlags6 +                             -- 98  
  @ctsCountryCode7 +                              -- 99  
  @ctsValidationFlags7 +                             -- 100  
  @ctsCountryCode8 +                              -- 101  
  @ctsValidationFlags8 +                             -- 102  
  @ctsCountryCode9 +                              -- 103  
  @ctsValidationFlags9 +                             -- 104  
  @ctsCountryCode10 +                              -- 105  
  @ctsValidationFlags10 +                             -- 106  
  @ctsCountryCode11 +                              -- 107  
  @ctsValidationFlags11 +                             -- 108  
  @ctsCountryCode12 +                              -- 109  
  @ctsValidationFlags12 +                             -- 110  
  @ctsCountryCode13 +                              -- 111  
  @ctsValidationFlags13 +                             -- 112  
  @ctsCountryCode14 +                              -- 113  
  @ctsValidationFlags14 +                             -- 114  
  @ctsCountryCode15 +                              -- 115  
  @ctsValidationFlags15 +                             -- 116  
  @ctsCountryCode16 +                              -- 117  
  @ctsValidationFlags16 +                             -- 118  
  @ctsCountryCode17 +                   -- 119  
  @ctsValidationFlags17 +                             -- 120  
  @ctsCountryCode18 +                              -- 121  
  @ctsValidationFlags18 +                             -- 122  
  @ctsCountryCode19 +                        -- 123  
  @ctsValidationFlags19 +                             -- 124  
  @ctsCountryCode20 +                              -- 125  
  @ctsValidationFlags20 +                             -- 126  
  @ctsCountryCode21 +                              -- 127  
  @ctsValidationFlags21 +                             -- 128  
  @ctsCountryCode22 +                              -- 129  
  @ctsValidationFlags22 +                             -- 130  
  @ctsCountryCode23 +                              -- 131  
  @ctsValidationFlags23 +                             -- 132  
  @ctsCountryCode24 +                              -- 133  
  @ctsValidationFlags24 +                             -- 134  
  @ctsCountryCode25 +                              -- 135  
  @ctsValidationFlags25 +                             -- 136  
  @ctsCountryCode26 +                              -- 137  
  @ctsValidationFlags26 +                             -- 138  
  @ctsCountryCode27 +                              -- 139  
  @ctsValidationFlags27 +                             -- 140  
  @ctsCountryCode28 +                              -- 141  
  @ctsValidationFlags28 +                             -- 142  
  @ctsCountryCode29 +                              -- 143  
  @ctsValidationFlags29 +                             -- 144  
  @ctsCountryCode30 +                              -- 145  
  @ctsValidationFlags30 +                             -- 146  
  CONVERT(CHAR(4),a.txtTv) +      -- @txtTipoValor  
  CONVERT(CHAR(7),a.txtEmisora) +     -- @txtEmisora  
  CONVERT(CHAR(6),a.txtSerie) +      -- @txtSerie  
  
  -- JATO (02:21 p.m. 2008-06-06)  
  -- agregue valores default  
  CASE a.txtTv  
  WHEN 'BI' THEN '0000'  
  WHEN '3P' THEN '0000'  
  WHEN '4P' THEN '0000'  
  WHEN 'CC' THEN '0000'  
  WHEN 'CP' THEN '0000'  
  WHEN 'G' THEN '0001'  
  WHEN 'I' THEN '0001'  
  WHEN 'IL' THEN '0001'  
  WHEN 'IP' THEN '0000'  
  WHEN 'IS' THEN '0000'  
  WHEN 'IT' THEN '0000'  
  WHEN 'LD' THEN '0000'  
  WHEN 'LS' THEN '0000'  
  WHEN 'M' THEN '0000'  
  WHEN 'M0' THEN '0000'  
  WHEN 'M7' THEN '0000'  
  WHEN 'MC' THEN '0000'  
  WHEN 'MP' THEN '0000'  
  WHEN 'S' THEN '0000'  
  WHEN 'S0' THEN '0000'  
  WHEN 'SC' THEN '0000'  
  WHEN 'SP' THEN '0000'  
  WHEN 'XA' THEN '0000'  
  ELSE t.txtCupon  
  END         -- @txtCupón  
  AS [Rows],              
  1  
 FROM @tmp_tblTACs AS t   
  LEFT OUTER JOIN MxFixIncome.dbo.tmp_tblActualPrices AS a (NOLOCK)   
   ON t.txtId1 = a.txtId1  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS i (NOLOCK)   
   ON i.txtId1 = a.txtId1  
    AND i.txtLiquidation = (  
     CASE a.txtLiquidation    
      WHEN 'MP' THEN 'MD'    
      ELSE a.txtLiquidation    
     END)  
  INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_2 AS ii (NOLOCK)   
   ON ii.txtId1 = a.txtId1  
    AND ii.txtLiquidation = (  
     CASE a.txtLiquidation    
      WHEN 'MP' THEN 'MD'    
      ELSE a.txtLiquidation    
     END)  
 WHERE a.txtLiquidation IN (@txtLiquidation,'MP')  
  AND a.txtTv NOT IN (SELECT TVs FROM @tmp_tblUNIExclude)  
   --OR a.txtId1 IN ('MIRC0000081','MIRC0000084','MIRC0000075'))  
 ORDER BY a.txtTv,a.txtEmisora,a.txtSerie  
  
 INSERT @tmp_tblResults (row,consecutivo)  
  SELECT 'MX52HS160011I52   HS-BRIC B-1                52   HS-BRIC B-1                                                  HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMX
LEQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                    
           MX52HS160011         0            0                     N                     1                                          NCDP                                                                                  N                                    
                                                                N     NNN    NT                                                                                                                                                       52  HS-BRICB-1   0000',2 
UNION  
  SELECT 'MX52HS160029I52   HS-BRIC B-2                52   HS-BRIC B-2                                                  HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS160029         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICB-2   0000',2 U
NION  
  SELECT 'MX52HS160037I52   HS-BRIC B-3                52   HS-BRIC B-3                                                  HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS160037         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICB-3   0000',2 U
NION  
  SELECT 'MX52HS160045I52   HS-BRIC B-4                52   HS-BRIC B-4                                                  HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS160045         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICB-4   0000',2 U
NION  
  SELECT 'MX52HS160060I52   HS-BRIC B-6                52   HS-BRIC B-6                                                  HSBC FONDO GLOBAL 1, S.A. DE C.V.        YBNMXLEQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0
000100.0000100.0000                                                                                                                                                               MX52HS160060         0            0                     N                    
 1                                          NCDP                                                                                  N                                                                                                    N     NNN    NT         
                                                                                                                                              52  HS-BRICB-6   0000',2 UNION  
  SELECT 'MX52HS1600E8I52   HS-BRIC BFA2               52   HS-BRIC BFV1                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600E8         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBFA2  0000',2 U
NION  
  SELECT 'MX52HS160094I52   HS-BRIC BFP1               52   HS-BRIC BFP1                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS160094         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBFP1  0000',2 U
NION  
  SELECT 'MX52HS1600B4I52   HS-BRIC BFP2               52   HS-BRIC BFP2                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600B4         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBFP2  0000',2 U
NION  
  SELECT 'MX52HS160078I52   HS-BRIC BFS1               52   HS-BRIC BFS1                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS160078         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBFS1  0000',2 U
NION  
  SELECT 'MX52HS160086I52   HS-BRIC BFS2               52   HS-BRIC BFS2                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS160086         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBFS2  0000',2 U
NION  
  SELECT 'MX52HS1600C2I52   HS-BRIC BFV2               52   HS-BRIC BFV2                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600C2         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBFV2  0000',2 U
NION  
  SELECT 'MX52HS1600N9I52   HS-BRIC BIF4               52   HS-BRIC BIF4                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600N9         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBIF4  0000',2 U
NION  
  SELECT 'MX52HS1600O7I52   HS-BRIC BIF5               52   HS-BRIC BIF5                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600O7         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBIF5  0000',2 U
NION  
  SELECT 'MX52HS1600P4I52   HS-BRIC BIF6               52   HS-BRIC BIF6                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600P4         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBIF6  0000',2 U
NION  
  SELECT 'MX52HS1600H1I52   HS-BRIC BIX1               52   HS-BRIC BIX1                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600H1         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBIX1  0000',2 U
NION  
  SELECT 'MX52HS1600I9I52   HS-BRIC BIX2               52   HS-BRIC BIX2                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600I9         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                       52  HS-BRICBIX2  0000',2 UNION  
  SELECT 'MX52HS1600K5I52   HS-BRIC BMF4               52   HS-BRIC BMF4                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMX
LEQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                    
           MX52HS1600K5         0            0                     N                     1                                          NCDP                                                                                  N                                    
                                                                N     NNN    NT                                                                                                                                                       52  HS-BRICBMF4  0000',2 
UNION  
  SELECT 'MX52HS1600M1I52   HS-BRIC BMF5               52   HS-BRIC BMF5                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600M1         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBMF5  0000',2 U
NION  
  SELECT 'MX52HS1600L3I52   HS-BRIC BMF6               52   HS-BRIC BMF6                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600L3         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBMF6  0000',2 U
NION  
  SELECT 'MX52HS1600F5I52   HS-BRIC BMX1               52   HS-BRIC BMX1                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600F5         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                               52  HS-BRICBMX1  0000',2 UNION  
  SELECT 'MX52HS1600G3I52   HS-BRIC BMX2               52   HS-BRIC BMX2                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMX
LEQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                    
           MX52HS1600G3         0            0                     N                     1                                          NCDP                                                                                  N                                    
                                                                N     NNN    NT                                                                                                                                                       52  HS-BRICBMX2  0000',2 
UNION  
  SELECT 'MX52HS1600J7I52   HS-BRIC BNF3               52   HS-BRIC BNF3                                                 HSBC FONDO GLOBAL 1, S.A. DE C.V.                                                                                               YBNMXL
EQUNNNUNTYMXNN NN      1            0             999             100.0000100.0000100.0000100.0000100.0000                                                                                                                                                     
          MX52HS1600J7         0            0                     N                     1                                          NCDP                                                                                  N                                     
                                                               N     NNN    NT                                                                                                                                                       52  HS-BRICBMF3  0000',2  
  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'!',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'@',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'#',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'$',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'%',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'^',' ')  
-- UPDATE @tmp_tblResults SET Row = REPLACE(Row,'&',' ')  
-- UPDATE @tmp_tblResults SET Row = REPLACE(Row,'*',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,';',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'"',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'|',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'\',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'=',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'_',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'<',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'>',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'{',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'}',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,'[',' ')  
 UPDATE @tmp_tblResults SET Row = REPLACE(Row,']',' ')  
  
 SELECT Row FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
-- Para obtener los parametros de configuración  
-- Producto: ReportosHSBCyyyymmdd.xls  
CREATE PROCEDURE dbo.sp_productos_BITAL;6  
  @txtDate AS DATETIME  
  
/*  
  Version 1.0    
     
   Agrego Modulo 6: Procedimiento que genera archivo reportosHSBC_aaaammdd.xls  
     Elaborado: Lic. René López Salinas  
   Fecha: 24-Julio-2008  
*/    
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 DECLARE @tmpLayoutxlCurve TABLE (  
  indSheet INT,  
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
 PRIMARY KEY (indSheet,Col)  
 )   
  
 -- <Sheet1> = Sheet1  
 INSERT @tmpLayoutxlCurve   
  SELECT 01 AS [indSheet], 'Rep. B3' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 01 AS [indSheet], 'Rep. B3' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION  
 
   SELECT 01 AS [indSheet], 'Rep. B3' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RB3' AS [Type],'B3'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 02 AS [indSheet], 'Rep. B2' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 02 AS [indSheet], 'Rep. B2' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION  
 
   SELECT 02 AS [indSheet], 'Rep. B2' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RB2' AS [Type],'B2'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] UNION  
  SELECT 03 AS [indSheet], 'Rep. B1' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 03 AS [indSheet], 'Rep. B1' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION  
 
   SELECT 03 AS [indSheet], 'Rep. B1' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RB1' AS [Type],'B1'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] UNION  
  SELECT 04 AS [indSheet], 'Rep. G3 Bruto' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNIO
N   
  SELECT 04 AS [indSheet], 'Rep. G3 Bruto' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] U
NION   
   SELECT 04 AS [indSheet], 'Rep. G3 Bruto' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RG3' AS [Type],'G3I'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] U
NION  
  SELECT 05 AS [indSheet], 'Rep. G3 Neto' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNION
   
  SELECT 05 AS [indSheet], 'Rep. G3 Neto' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UN
ION   
   SELECT 05 AS [indSheet], 'Rep. G3 Neto' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RG3' AS [Type],'G3'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] UNI
ON  
  SELECT 06 AS [indSheet], 'Rep. G2 Bruto' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNIO
N   
  SELECT 06 AS [indSheet], 'Rep. G2 Bruto' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] U
NION   
   SELECT 06 AS [indSheet], 'Rep. G2 Bruto' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RG2' AS [Type],'G2I'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] U
NION  
  SELECT 07 AS [indSheet], 'Rep. G2 Neto' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNION
   
  SELECT 07 AS [indSheet], 'Rep. G2 Neto' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UN
ION   
   SELECT 07 AS [indSheet], 'Rep. G2 Neto' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RG2' AS [Type],'G2'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] UNI
ON  
  SELECT 08 AS [indSheet], 'Rep. G1 Bruto' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNIO
N   
  SELECT 08 AS [indSheet], 'Rep. G1 Bruto' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] U
NION   
   SELECT 08 AS [indSheet], 'Rep. G1 Bruto' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RG1' AS [Type],'G1I'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad] U
NION  
  SELECT 09 AS [indSheet], 'Rep. G1 Neto' AS [SheetName], 1  AS [Col],'FECHA' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'YYYYMMDD' AS [DataFormat],'1' AS [fLoad] UNION
   
  SELECT 09 AS [indSheet], 'Rep. G1 Neto' AS [SheetName], 2  AS [Col],'PLAZO'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UN
ION   
   SELECT 09 AS [indSheet], 'Rep. G1 Neto' AS [SheetName], 3  AS [Col],'TASA'   AS [Header],'CURVES'    AS [Source],'RG1' AS [Type],'G1'  AS [SubType],'1-360' AS [Range],'1' AS [Factor], 'DBL' AS [DataType], '0.000000'   AS [DataFormat],'1' AS [fLoad]  
  
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
 ORDER BY indSheet,Col  
  
 SET NOCOUNT OFF  
  
END  
  
/*------------------------------------------------------  
--   Autor:      Mike Ramírez  
--   Creacion:   10:53 2013-08-09  
--   Descripcion: Se agrega una curva Ptos Fwd CNH/USD  
  
Modifica:Omar Adrian Aceves Gutierrez   
Fecha:2014-03-26 12:18:02.163  
Nota: SE AGREGA Implicita CNH '99'  
------------------------------------------------------  
*/  
  
CREATE  PROCEDURE dbo.sp_productos_BITAL;7   
  @txtDate AS DATETIME  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
--DECLARE   
--@txtDate AS DATETIME  
--SET @txtDate = '20140214'  
  
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
  SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'Cetes'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'CT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 3 AS [Col],'Cetes IMPTO'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'CTI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 4 AS [Col],'Yield Bonos'  AS [Header],'CURVES' AS [Source],'MSG'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 5 AS [Col],'Ipabono'  AS [Header],'CURVES' AS [Source],'BPA'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION  
 
  SELECT 'Sheet1' AS [SheetName], 6 AS [Col],'Ipabono Trimestral'  AS [Header],'CURVES' AS [Source],'BPT'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 7 AS [Col],'Bonde 182'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'SE'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
  
  SELECT 'Sheet1' AS [SheetName], 8 AS [Col],'Bondes LT'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'LT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'0' AS [fLoad] UNION
  
  SELECT 'Sheet1' AS [SheetName], 9 AS [Col],'Brems'  AS [Header],'CURVES' AS [Source],'XA'    AS [Type],'XA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 10 AS [Col],'Yield Real'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 11 AS [Col],'Real'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'U%'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 12 AS [Col],'Real IMPTO'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'UUI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 13 AS [Col],'Pagares Udizados' AS [Header],'CURVES' AS [Source],'PLU'    AS [Type],'P8'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 14 AS [Col],'Reporto Guber G1'  AS [Header],'CURVES' AS [Source],'RG1'    AS [Type],'G1'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 15 AS [Col],'Reporto Guber G1 IMPTO'  AS [Header],'CURVES' AS [Source],'RG1'    AS [Type],'G1I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 16 AS [Col],'Reporto Guber G2'  AS [Header],'CURVES' AS [Source],'RG2'    AS [Type],'G2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 17 AS [Col],'Reporto Guber G2 IMPTO'  AS [Header],'CURVES' AS [Source],'RG2'    AS [Type],'G2I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 18 AS [Col],'Reporto Guber G3'  AS [Header],'CURVES' AS [Source],'RG3'    AS [Type],'G3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 19 AS [Col],'Reporto Guber G3 IMPTO'  AS [Header],'CURVES' AS [Source],'RG3'    AS [Type],'G3I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 20 AS [Col],'Reporto Bancario B1'  AS [Header],'CURVES' AS [Source],'RB1'    AS [Type],'B1'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 21 AS [Col],'Reporto Bancario B2'  AS [Header],'CURVES' AS [Source],'RB2'    AS [Type],'B2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 22 AS [Col],'Reporto Bancario B3'  AS [Header],'CURVES' AS [Source],'RB3'    AS [Type],'B3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 23 AS [Col],'Reporto Bancario B4'  AS [Header],'CURVES' AS [Source],'RB4'    AS [Type],'B4'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 24 AS [Col],'Bancario B1'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'3A'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 25 AS [Col],'Bancario B2'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'P8'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 26 AS [Col],'Bancario B3'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'PO'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 27 AS [Col],'Bancario B4'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'BIN'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] U
NION   
  SELECT 'Sheet1' AS [SheetName], 28 AS [Col],'Ums'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 29 AS [Col],'Cedes Dolarizados'  AS [Header],'CURVES' AS [Source],'CDE'    AS [Type],'USD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fL
oad] UNION   
  SELECT 'Sheet1' AS [SheetName], 30 AS [Col],'Calificacion A'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
 UNION   
  SELECT 'Sheet1' AS [SheetName], 31 AS [Col],'Calificacion AA'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 32 AS [Col],'Calificacion AAA'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 33 AS [Col],'Calificacion B'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'B0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
UNION   
  SELECT 'Sheet1' AS [SheetName], 34 AS [Col],'Calificacion C'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'C0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
 UNION   
  SELECT 'Sheet1' AS [SheetName], 35 AS [Col],'Calificacion D '  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'D0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 36 AS [Col],'Implicita Pesos'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CU'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 37 AS [Col],'Puntos Forward'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'PIP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 38 AS [Col],'Tipo de Cambio Forward'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'LB'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS
 [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 39 AS [Col],'Fras Tiie'  AS [Header],'CURVES' AS [Source],'TDS'    AS [Type],'T28'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 40 AS [Col],'Descuento Irs'  AS [Header],'CURVES' AS [Source],'SWP'    AS [Type],'TI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] 
UNION   
  SELECT 'Sheet1' AS [SheetName], 41 AS [Col],'Treasuries'  AS [Header],'CURVES' AS [Source],'TSN'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 42 AS [Col],'Libor Yield'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] U
NION   
  SELECT 'Sheet1' AS [SheetName], 43 AS [Col],'Libor'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'BL'   AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 44 AS [Col],'Cross Currency ASK'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'VTA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 45 AS [Col],'Cross Currency BID'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'CPA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 46 AS [Col],'Cross Currency MID'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'MED'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 47 AS [Col],'Libor Canada'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] 
 UNION   
  SELECT 'Sheet1' AS [SheetName], 48 AS [Col],'Libor Euro'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 49 AS [Col],'Libor Yen'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 50 AS [Col],'Libor Marco'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'DEM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] U
NION   
  SELECT 'Sheet1' AS [SheetName], 51 AS [Col],'Riesgo Mexico'  AS [Header],'CURVES' AS [Source],'SPD'    AS [Type],'PA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] 
UNION   
  SELECT 'Sheet1' AS [SheetName], 52 AS [Col],'Tipo de Cambio Forward (Base FIX)'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'FIX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFo
rmat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 53 AS [Col],'Implicita Pesos (Base FIX)'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CUX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'
1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 54 AS [Col],'Ipabono Semestral'  AS [Header],'CURVES' AS [Source],'BPS'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 55 AS [Col],'Cross Currency Swap Udi/Libor'  AS [Header],'CURVES' AS [Source],'ULS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat
],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 56 AS [Col],'Libor Hong Kong'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'HKD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 57 AS [Col],'Implicita en Forward de Peso Colombiano'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'COP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 58 AS [Col],'Cetes Irs'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'IRS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 59 AS [Col],'Libor Australiana'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'AUD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fL
oad] UNION   
  SELECT 'Sheet1' AS [SheetName], 60 AS [Col],'Libor Franco Suizo'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'CHF'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 61 AS [Col],'Libor Londres'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
 UNION   
  SELECT 'Sheet1' AS [SheetName], 62 AS [Col],'Implicita en Forward de Real Brasilenio'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 63 AS [Col],'Bondes D'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'XA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
  
   SELECT 'Sheet1' AS [SheetName], 64 AS [Col],'Cross Currency Swap Udi/TIIE'  AS [Header],'CURVES' AS [Source],'UDT'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'    AS [DataFormat],'1' A
S [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 65 AS [Col],'Udi/TIIE tasa Swap'  AS [Header],'CURVES' AS [Source],'UDT'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 66 AS [Col],'Yield Bonos Neto'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'YT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 67 AS [Col],'Euribor'  AS [Header],'CURVES' AS [Source],'EUR'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
  
  SELECT 'Sheet1' AS [SheetName], 68 AS [Col],'Implicita en Forward de Euro'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat]
,'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 69 AS [Col],'Implicita en Forward de Yen Japones'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [Data
Format],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 70 AS [Col],'Implicita en Forward de Dolar Canadiense'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS 
[DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 71 AS [Col],'Tipo de Cambio Forward Dolar Canadiense'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 72 AS [Col],'Tipo de Cambio Forward Euro'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],
'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 73 AS [Col],'Tipo de Cambio Forward MXP/EUR'  AS [Header],'CURVES' AS [Source],'FTM'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataForma
t],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 74 AS [Col],'Tipo de Cambio Forward Real Brasilenio'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [D
ataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 75 AS [Col],'Tipo de Cambio Forward Yen Japones'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataF
ormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 76 AS [Col],'Implicita en Forward de Libra Esterlina'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 77 AS [Col],'Tipo de Cambio Forward Libra Esterlina'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [D
ataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 78 AS [Col],'Reporto UMS'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'REP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] U
NION   
  SELECT 'Sheet1' AS [SheetName], 79 AS [Col],'Cross Currency Swap Libor USD/Euribor'  AS [Header],'CURVES' AS [Source],'LES'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [Da
taFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 80 AS [Col],'Cross Currency Swap Tiie/Euribor'  AS [Header],'CURVES' AS [Source],'ETS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFor
mat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 81 AS [Col],'Ums Zero 364/YTM'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'YUM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 82 AS [Col],'Libor Yen Cupon Cero'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS 
[fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 83 AS [Col],'Libor Euro Cupon Cero'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS
[fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 84 AS [Col],'Udi/Libor tasa Swap'  AS [Header],'CURVES' AS [Source],'ULS'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [
fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 85 AS [Col],'Yield Real con Impuesto'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'YLI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' 
AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 86 AS [Col],'Reporto Privados AAA'  AS [Header],'CURVES' AS [Source],'RPR'    AS [Type],'A3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [
fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 87 AS [Col],'Cross Currency Swap TIIE/Libor Bid'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'CCB'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataF
ormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 88 AS [Col],'Tiie Swap'  AS [Header],'CURVES' AS [Source],'TIE'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 89 AS [Col],'Libor CLP'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'CLP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 90 AS [Col],'Implicita Peso Chileno/Dolar'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CLP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat]
,'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 91 AS [Col],'Implicita Peso Chileno/Peso Mexicano'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CLM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [Dat
aFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 92 AS [Col],'Ptos FWD CLP/USD'  AS [Header],'CURVES' AS [Source],'FWP'    AS [Type],'CLP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 93 AS [Col],'Ptos FWD CLP/MXN'  AS [Header],'CURVES' AS [Source],'FWP'    AS [Type],'CLM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 94 AS [Col],'Bonos Globales Brasil'  AS [Header],'CURVES' AS [Source],'BRL'    AS [Type],'GLO'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS
 [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 95 AS [Col],'Deuda Nominal Brasil'  AS [Header],'CURVES' AS [Source],'BRL'    AS [Type],'LTN'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS 
[fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 96 AS [Col],'Puntos FWD/BRL'  AS [Header],'CURVES' AS [Source],'FWP'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 97 AS [Col],'Implicita Real Brasileño/Dolar'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataForma
t],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 98 AS [Col],'Puntos Forward CNH/USD'  AS [Header],'CURVES' AS [Source],'FWP'    AS [Type],'CNH'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad]  UNION   
  SELECT 'Sheet1' AS [SheetName], 99 AS [Col],'Implicita CNH'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CNH'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
  
  
  
  
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
  
--   Autor: Lic. René López Salinas  
--   Creacion: 12:00 a.m. 2011-05-10    
--   Descripcion:     Modulo 8: Para generar producto HSBCCurvasGuberYYYYMMDD.xls  
CREATE PROCEDURE dbo.sp_productos_BITAL;8  
  @txtDate AS DATETIME  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 DECLARE @dteMatrixIni AS DATETIME  
 DECLARE @dblFirstRow AS FLOAT  
 DECLARE @intFaulty AS INTEGER  
  
 -- creo tabla temporal de Directivas  
 DECLARE @tblDirectives TABLE (  
   indSheet INT,  
   SheetName CHAR(60),  
   intSection INT,  
   txtSource CHAR(50),  
   txtCode CHAR(250),  
   intCol INT,  
   intRow INT,  
   txtValue CHAR(100),  
   Type  CHAR(3),  
   SubType  CHAR(3),  
   Node INT,  
   intStrike INT  
  PRIMARY KEY (indSheet, intCol, intRow)  
  )   
  
 -- Obtengo la fecha inicial del rango en el producto  
 SET @dteMatrixIni = '20071231'  
 SET @dblFirstRow = 0  
 SET @intFaulty = 0  
  
 -- Calculo las coordenadas donde se escribira la información del día  
 SELECT @dblFirstRow = count(*)+1  -- Calcula el número de registro donde escribirá la información actual  
 FROM MxFixIncome.dbo.fun_get_trading_dates(@dteMatrixIni, @txtDate, 'MX')  
  
 -- Creación de Directivas para obtener información  (No olvidar el factor,item,tvs)  
 -- <Sheet 1><SECCION 1> FECHA  
 INSERT @tblDirectives  
  SELECT 01,'UMS',1,'LABEL', 'Fecha', 1, @dblFirstRow, CONVERT(CHAR(10),@txtDate,111),NULL,NULL,NULL,NULL  
  
 -- <Sheet 1><SECCION 2> UMS  
 INSERT @tblDirectives  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|1', 2, @dblFirstRow, NULL,'UMS','YLD',1,NULL UNION  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|180',  3, @dblFirstRow, NULL,'UMS','YLD',180,NULL UNION  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|360', 4, @dblFirstRow, NULL,'UMS','YLD',360,NULL UNION  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|720', 5, @dblFirstRow, NULL,'UMS','YLD',720,NULL UNION  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|1800', 6, @dblFirstRow, NULL,'UMS','YLD',1800,NULL UNION  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|3600', 7, @dblFirstRow, NULL,'UMS','YLD',3600,NULL UNION  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|7200', 8, @dblFirstRow, NULL,'UMS','YLD',7200,NULL UNION  
  SELECT 01,'UMS',2,'CURVES', 'UMS-YLD|10800', 9, @dblFirstRow, NULL,'UMS','YLD',10800,NULL  
  
 -- <Sheet 2><SECCION 1> FECHA  
 INSERT @tblDirectives  
  SELECT 02,'cetes c Impuesto',3,'LABEL', 'Fecha', 1, @dblFirstRow, CONVERT(CHAR(10),@txtDate,111),NULL,NULL,NULL,NULL  
  
 -- <Sheet 2><SECCION 2> cetes c Impuesto  
 INSERT @tblDirectives  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|1', 2, @dblFirstRow, NULL,'CET','CTI',1,NULL UNION  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|180',  3, @dblFirstRow, NULL,'CET','CTI',180,NULL UNION  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|360', 4, @dblFirstRow, NULL,'CET','CTI',360,NULL UNION  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|720', 5, @dblFirstRow, NULL,'CET','CTI',720,NULL UNION  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|1800', 6, @dblFirstRow, NULL,'CET','CTI',1800,NULL UNION  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|3600', 7, @dblFirstRow, NULL,'CET','CTI',3600,NULL UNION  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|7200', 8, @dblFirstRow, NULL,'CET','CTI',7200,NULL UNION  
  SELECT 02,'cetes c Impuesto',4,'CURVES', 'CET-CTI|10800', 9, @dblFirstRow, NULL,'CET','CTI',10800,NULL  
  
 -- <Sheet 3><SECCION 1> FECHA  
 INSERT @tblDirectives  
  SELECT 03,'Real c Impuesto',5,'LABEL', 'Fecha', 1, @dblFirstRow, CONVERT(CHAR(10),@txtDate,111),NULL,NULL,NULL,NULL  
  
 -- <Sheet 3><SECCION 2> Real c Impuesto  
 INSERT @tblDirectives  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|1', 2, @dblFirstRow, NULL,'UDB','UUI',1,NULL UNION  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|180',  3, @dblFirstRow, NULL,'UDB','UUI',180,NULL UNION  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|360', 4, @dblFirstRow, NULL,'UDB','UUI',360,NULL UNION  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|720', 5, @dblFirstRow, NULL,'UDB','UUI',720,NULL UNION  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|1800', 6, @dblFirstRow, NULL,'UDB','UUI',1800,NULL UNION  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|3600', 7, @dblFirstRow, NULL,'UDB','UUI',3600,NULL UNION  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|7200', 8, @dblFirstRow, NULL,'UDB','UUI',7200,NULL UNION  
  SELECT 03,'Real c Impuesto',6,'CURVES', 'UDB-UUI|10800', 9, @dblFirstRow, NULL,'UDB','UUI',10800,NULL  
  
 -- <Sheet 4><SECCION 1> FECHA  
 INSERT @tblDirectives  
  SELECT 04,'Flotantes',7,'LABEL', 'Fecha', 1, @dblFirstRow, CONVERT(CHAR(10),@txtDate,111),NULL,NULL,NULL,NULL  
  
 -- <Sheet 4><SECCION 2> Flotantes  
 INSERT @tblDirectives  
  SELECT 04,'Flotantes',8,'CURVES', 'BPT-BP|1', 2, @dblFirstRow, NULL,'BPT','BP',1,NULL UNION  
  SELECT 04,'Flotantes',8,'CURVES', 'BPT-BP|180',  3, @dblFirstRow, NULL,'BPT','BP',180,NULL UNION  
  SELECT 04,'Flotantes',8,'CURVES', 'BPT-BP|360', 4, @dblFirstRow, NULL,'BPT','BP',360,NULL UNION  
  SELECT 04,'Flotantes',8,'CURVES', 'BPT-BP|720', 5, @dblFirstRow, NULL,'BPT','BP',720,NULL UNION  
  SELECT 04,'Flotantes',8,'CURVES', 'BPT-BP|1800', 6, @dblFirstRow, NULL,'BPT','BP',1800,NULL  
  
 -- Obtengo los valores de los FRPiP  
 UPDATE @tblDirectives  
  SET txtValue = LTRIM(STR(ROUND((SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0'))*100,13),19,13))  
 FROM @tblDirectives AS FR  
 WHERE   
  txtSource = 'CURVES'  
  
 SELECT @intFaulty = COUNT(*)  
 FROM @tblDirectives AS FR  
 WHERE   
  txtSource = 'CURVES'  
  AND RTRIM(txtValue)= '-99900'  
  
 -- Valida información  
 IF (@dblFirstRow = 0 OR @intFaulty > 0)  
  BEGIN  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  END  
 ELSE  
  BEGIN  
   -- regreso los Sheets  
   SELECT  
    LTRIM(STR(indSheet)) AS [indSheet],  
    RTRIM(SheetName) AS [SheetName]  
   FROM @tblDirectives  
   GROUP BY   
   indSheet,SheetName  
   ORDER BY   
   indSheet,SheetName  
  
   -- regreso los limites  
   SELECT  
    intSection,  
    MIN(intCol) AS intMinCol,  
    MAX(intCol) AS intMaxCol,  
    MIN(intRow) AS intMinRow,  
    MAX(intRow) AS intMaxRow,  
    indSheet  
   FROM @tblDirectives  
   GROUP BY   
    indSheet,intSection  
   ORDER BY   
    indSheet,intSection  
  
  -- regreso las directivas  
  SELECT   
    LTRIM(STR(intSection)) AS [intSection],  
    LTRIM(STR(indSheet)) AS [indSheet],  
    intCol AS [intCol],  
    intRow AS [intRow],  
    RTRIM(txtValue) AS [txtValue]  
  FROM @tblDirectives  
  ORDER BY   
    intSection,  
    indSheet,  
    intCol,  
    intRow  
  END  
  
 SET NOCOUNT OFF   
  
END  
-- Autor: Mike Ramirez  
-- Creacion: 08:42 p.m. 2011-10-10  
-- Descripcion: Modulo 9: Genera vector de derivados personalizado HSB05_VD[yyyymmdd]_SOL.PIP  
CREATE PROCEDURE sp_productos_BITAL;9  
@txtDate AS VARCHAR(10),  
@txtFlag AS VARCHAR(1)  
AS   
BEGIN  
  
SET NOCOUNT ON  
  
 DECLARE @txtProcDate AS DATETIME  
 DECLARE @txtLiquidation AS VARCHAR(10)  
 DECLARE @txtOwner AS CHAR(5)  
  
 SET @txtProcDate = (SELECT MxFixIncome.dbo.fun_NextTradingDate(CONVERT(CHAR(8),@txtDate,112),1,'MX'))  
 SET @txtLiquidation = '24H'  
 SET @txtOwner = 'HSB05'  
  
------------------------------------------------------------------------------------------------  
 -- genero buffers temporales  
 DECLARE @tbl_tmpData TABLE (  
  [txtId1] [char] (11) NOT NULL,  
  [txtTv] [char] (10) NOT NULL,  
  [txtIssuer] [char] (10) NOT NULL,  
  [txtSeries] [char] (10) NOT NULL,  
  [txtSerial] [char] (10) NOT NULL,  
  [txtLiquidation] [char] (3) NOT NULL  
   PRIMARY KEY CLUSTERED   
    ([txtId1],[txtLiquidation]),  
  [intDTM] [int] NOT NULL,  
  [dblPav] [float] NOT NULL,  
  [dblMarketPrice] [float] NOT NULL,  
  [dblFRR] [float] NOT NULL,  
  [dblDelta] [float] NOT NULL,  
  [dblLAR] [float] NOT NULL,  
  [dblSHO] [float] NOT NULL  
 )  
  
 -- genero buffers temporales MARKET PRICES  
 DECLARE @tbl_tmpActualMarketPrices TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] ),  
  [dblMarketPrice] [float] NOT NULL  
 )  
  
 -- genero buffers temporales IDS vs OWNERS  
 DECLARE @tbl_tmpIdsVsOwners TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] )  
 )  
  
 ------------------------------------------------------------------------------------------------  
 -- *******************************************  
 -- HECHOS DE MERCADO  
 -- *******************************************  
 -- identifico los instrumentos   
 -- que pertenecen al cliente actual  
  
 INSERT INTO @tbl_tmpIdsVsOwners (txtId1)  
 SELECT txtId1  
 FROM MxDerivatives.dbo.tblDerivativesOwners (NOLOCK)  
 WHERE  
  txtOwnerId = @txtOwner  
  AND dteBeg <= @txtDate  
  AND dteEnd >= @txtDate  
  
 -- obtengo los hechos de mercado   
 -- FUTUROS  
 INSERT @tbl_tmpActualMarketPrices  
 SELECT   
  i.txtId1,   
  dblPrice  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
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
  AND (  
   i.txtTv IN ('FA', 'FD', 'FU', 'FS')  
   OR (  
    i.txtTv IN ('FI', 'FB')  
    AND i.txtIssuer IN ('IPC', 'CE91','M10','M3','TE28')  
   )  
  )  
  AND i.txtSerial LIKE 'P%'  
 UNION  
 SELECT   
  i.txtId1,   
  100 / dblPrice AS dblPrice  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
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
  AND i.txtTv IN ('FC')  
  AND i.txtIssuer = 'CEUA'  
  AND i.txtSerial LIKE 'P%'  
 UNION  
 SELECT   
  i.txtId1,   
  dblPrice * (  
 CASE   
  WHEN ir.dblVAlue IS NULL THEN 1  
 ELSE ir.dblVAlue  
 END   
 ) AS dblPrice  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS de (NOLOCK)  
  ON i.txtId1 = de.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
  LEFT OUTER JOIN MxFixIncome..tblIrc AS ir (NOLOCK)  
  ON   
   ir.txtIrc = (  
     CASE de.txtCurrency  
     WHEN 'USD' THEN 'UFXU'  
     WHEN 'DLL' THEN 'UFXU'  
     ELSE de.txtCurrency  
     END   
      )   
   AND ir.dteDate = @txtDate  
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
  AND i.txtTv IN ('FC', 'FI', 'FB')  
  AND NOT i.txtIssuer IN ('CEUA', 'IPC', 'CE91','M10','M3','TE28', 'JY')  
  AND i.txtSerial LIKE 'P%'  
 UNION  
 SELECT   
  i.txtId1,   
  dblPrice * (  
 CASE   
  WHEN ir.dblVAlue IS NULL THEN 1  
 ELSE ir.dblVAlue  
 END   
  ) /10000 AS dblPrice  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS de (NOLOCK)  
  ON i.txtId1 = de.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
  LEFT OUTER JOIN MxFixIncome..tblIrc AS ir (NOLOCK)  
  ON   
  ir.txtIrc = (  
     CASE de.txtCurrency  
     WHEN 'USD' THEN 'UFXU'  
     WHEN 'DLL' THEN 'UFXU'  
     ELSE de.txtCurrency  
     END   
     )   
  AND ir.dteDate = @txtDate  
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
  AND i.txtTv IN ('FC')  
  AND i.txtIssuer IN ('JY')  
  AND i.txtSerial LIKE 'P%'  
    
 -- obtengo los F0 para los demas instrumentos  
 -- que esten en el vector de precios  
 INSERT @tbl_tmpActualMarketPrices  
 SELECT  
  i.txtId1,  
  CASE d.intFamily  
  WHEN 13 THEN p.dblValue * 100  
  ELSE p.dblValue  
  END AS dblMarketPrice  
    
 FROM  
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblPrices AS p (NOLOCK)  
  ON p.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
  ON p.txtId1 = d.txtId1  
 WHERE  
  p.dteDate = @txtDate  
  AND p.txtLiquidation = @txtLiquidation  
  AND p.txtItem = 'F0'  
  AND i.txtTv IN ('FWD', 'CALL', 'PUT')  
  
 -- ************************************************  
 -- obtengo el consolidado  
 -- ************************************************  
 INSERT @tbl_tmpData  
  SELECT   
   i.txtId1,   
   i.txtTv,  
   i.txtIssuer,  
   i.txtSeries,  
   i.txtSerial,  
   p.txtLiquidation,  
   CASE   
    WHEN DATEDIFF(d, @txtProcDate, d.dteMaturity) < 0 THEN 0  
   ELSE DATEDIFF(d, @txtProcDate, d.dteMaturity)  
   END AS intDTM,  
   MAX(CASE p.txtItem WHEN 'PAV' THEN p.dblValue ELSE -999999999 END) AS dblPav,  
   CASE   
    WHEN mp.dblMarketPrice IS NULL THEN 0  
   ELSE mp.dblMarketPrice  
   END AS dblMarketPrice,  
   MAX(CASE p.txtItem WHEN 'FRR' THEN p.dblValue ELSE 0 END) AS dblFRR,  
   MAX(CASE p.txtItem WHEN 'DELTA' THEN p.dblValue ELSE -999 END) AS dblDelta,  
   MAX(CASE p.txtItem WHEN 'LAR' THEN p.dblValue ELSE 0 END) AS dblLar,  
   MAX(CASE p.txtItem WHEN 'SHO' THEN p.dblValue ELSE 0 END) AS dblSho  
  FROM   
   @tbl_tmpIdsVsOwners AS u  
   INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
   ON u.txtId1 = i.txtId1  
   INNER JOIN MxDerivatives.dbo.tblPrices AS p (NOLOCK)  
   ON u.txtId1 = p.txtId1  
   INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
   ON u.txtId1 = d.txtId1  
   LEFT OUTER JOIN @tbl_tmpActualMarketPrices AS mp  
   ON u.txtId1 = mp.txtId1  
  WHERE  
   p.dteDate = @txtDate  
  GROUP BY   
   i.txtId1,  
   i.txtTv,  
   i.txtIssuer,  
   i.txtSeries,  
   i.txtSerial,  
   p.txtLiquidation,  
   d.dteMaturity,  
   mp.dblMarketPrice  
  
 -- Agrego tblDerivativesPrices.dblPrice del conjunto de los TV = {OA,OI,OD}  
 UPDATE u  
  SET dblMarketPrice = dp.dblPrice  
 FROM  
  @tbl_tmpData AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS dp (NOLOCK)  
  ON i.txtId1 = dp.txtId1  
 WHERE  
  dp.dteDate = @txtDate  
  AND i.txtTv IN ('OA','OI','OD')  
  
 -- correccion de deltas   
 UPDATE @tbl_tmpData   
  SET dblDelta = 0  
 WHERE  
  dblDelta = -999  
  
 SET NOCOUNT OFF  
  
 -- creo el vector  
 SELECT   
  'H ' +  
  'DR' +  
  @txtDate +  
  RTRIM(txtTv) + REPLICATE(' ',4 - LEN(txtTv)) +  
  RTRIM(txtIssuer) + REPLICATE(' ',7 - LEN(txtIssuer)) +  
  RTRIM(txtSeries) + REPLICATE(' ',6 - LEN(txtSeries)) +  
  CASE WHEN dblPAV < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblPAV,6),16,6), '-', '0'),' ','0'), 2, 8) +   
    SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6)   
  END +  
  CASE WHEN dblPAV < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblPAV,6),16,6), '-', '0'),' ','0'), 2, 8) +   
    SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblPAV,6),16,6), ' ', '0'), 11, 6)   
  END +  
  '000000000000' +  
  '025009' +  
  @txtFlag +  
  SUBSTRING(REPLACE(STR(ROUND(intDTM,0),6,0), ' ', '0'), 1, 6) +  
  '00000000' +   
  '000000000000' +   
  RTRIM(txtSerial) + REPLICATE(' ',8 - LEN(txtSerial)) +   
  CASE WHEN dblMarketPrice < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), '-', '0'),' ','0'), 2, 8) +   
    SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6), ' ', '0'), 11, 6)   
  END +  
  CASE WHEN dblFRR < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblFRR,6),16,6), '-', '0'),' ','0'), 2, 8) +   
    SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6), ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6), ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6), ' ', '0'), 11, 6)   
  END +  
  CASE WHEN dblDelta < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblDelta,6),16,6), '-', '0'),' ','0'), 2, 8) +   
    SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6), ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6), ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6), ' ', '0'), 11, 6)   
  END +  
  CASE  
   WHEN i.dblValue IS NULL THEN '000001000000'  
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(i.dblValue,6),13,6), ' ', '0'), 1, 6) +  
    SUBSTRING(REPLACE(STR(ROUND(i.dblValue,6),13,6), ' ', '0'), 8, 6)   
  END +  
  CASE WHEN a.dblLar < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblLar,6),16,6), '-', '0'),' ','0'), 2, 8) +   
    SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6), ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6), ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6), ' ', '0'), 11, 6)   
  END +  
  CASE WHEN a.dblSho < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblSho,6),16,6), '-', '0'),' ','0'), 2, 8) +   
    SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6), ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6), ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6), ' ', '0'), 11, 6)   
  END  
 FROM   
  @tbl_tmpData AS a  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
  ON a.txtId1 = d.txtId1  
  LEFT OUTER JOIN MxFixIncome.dbo.tblIrc AS i (NOLOCK)  
  ON   
   i.txtIrc = (  
     CASE   
      WHEN d.txtCurrency IN ('USD', 'DLL') THEN 'UFXU'  
      WHEN d.txtCurrency IN ('MUD') THEN 'UDI'  
     ELSE  
      d.txtCurrency  
     END   
     )  
  AND i.dteDate = @txtDate  
 WHERE   
  txtLiquidation IN (@txtLiquidation, 'MP')  
  ORDER BY  
   txtTv,  
   txtIssuer,  
   txtSeries,  
   txtSerial  
END  
------------------------------------------------------------------------  
-- Autor: Mike Ramirez  
-- Fecha Modificacion: 15:54 p.m. 2012-05-04  
-- Descripcion: Modulo 10: Se modifican los campos que reporta el vector  
------------------------------------------------------------------------  
CREATE PROCEDURE sp_productos_BITAL;10  
 @txtDate AS VARCHAR(10),  
 @txtFlag AS VARCHAR(1)  
AS   
BEGIN  
  
SET NOCOUNT ON  
  
 DECLARE @txtProcDate AS DATETIME  
 DECLARE @txtLiquidation AS VARCHAR(10)  
 DECLARE @txtOwner AS CHAR(5)  
  
 SET @txtLiquidation = '24H'  
 SET @txtOwner = 'HSB05'  
  
 -- genero buffers temporales  
 DECLARE @tbl_tmpData TABLE (  
  [txtId1] [char] (11) NOT NULL,  
  [txtTv] [char] (10) NOT NULL,  
  [txtIssuer] [char] (10) NOT NULL,  
  [txtSeries] [char] (10) NOT NULL,  
  [dblPav] [float] NOT NULL,  
  [dblDV] [float] NOT NULL  
   PRIMARY KEY (txtId1)  
 )  
  
 -- genero buffers temporales IDS vs OWNERS  
 DECLARE @tbl_tmpIdsVsOwners TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] )  
 )  
  
 -- ********************************  
 -- HECHOS DE MERCADO  
 -- ********************************  
 -- identifico los instrumentos   
 -- que pertenecen al cliente actual  
  
 INSERT INTO @tbl_tmpIdsVsOwners (txtId1)  
  SELECT txtId1  
  FROM MxDerivatives.dbo.tblDerivativesOwners (NOLOCK)  
  WHERE  
   txtOwnerId = @txtOwner  
   AND dteBeg <= @txtDate  
   AND dteEnd >= @txtDate  
  
 -- ************************************************  
 -- obtengo el consolidado  
 -- ************************************************  
 INSERT INTO @tbl_tmpData   
  SELECT  
   RTRIM(i.txtId1),  
   RTRIM(i.txtTv),  
   RTRIM(i.txtIssuer),  
   RTRIM(i.txtSeries),  
   STR((p.dblValue / d.dblLotSize),9,6),  
   CASE   
    WHEN DATEDIFF(d, dteIssued, d.dteMaturity) < 0 THEN 0  
   ELSE DATEDIFF(d, dteIssued, d.dteMaturity)  
   END AS DiasVencer   
  FROM @tbl_tmpIdsVsOwners AS ow  
    INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
     ON ow.txtId1 = i.txtId1  
      INNER JOIN MxDerivatives..tblPrices AS p  
       ON ow.txtId1 = p.txtId1  
        INNER JOIN MxDerivatives..tblDerivatives AS d  
         ON ow.txtId1 = d.txtId1  
  WHERE p.dteDate = @txtDate   
    AND p.txtItem = 'F0'   
    AND p.txtLiquidation IN (@txtLiquidation,'24H')  
  
 -- creo el vector  
 SELECT  
  @txtDate,  
  RTRIM(txtTv),  
  RTRIM(txtIssuer),  
  RTRIM(txtSeries),  
  LTRIM(STR(ROUND(dblPAV,6),16,6)),  
  LTRIM(STR(ROUND(dblDV,0),6,0))  
 FROM   
  @tbl_tmpData AS a  
 ORDER BY  
  txtTv,  
  txtIssuer,  
  txtSeries   
   
 SET NOCOUNT OFF  
  
END  
--   Autor: Mike Ramirez  
--   Creacion: 09:54 a.m. 2011-11-30  
--   Descripcion:  Generar un vector basado en el moneda de origen HSBC_MonedaOrigen[yyyymmdd].xls  
CREATE PROCEDURE dbo.sp_productos_BITAL;11  
  @txtDate AS DATETIME,  
 @txtLiquidation AS VARCHAR(3)  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  [dtedate][VARCHAR](10),  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtID2][VARCHAR](400),  
  [dblPRS][VARCHAR](30),  
  [dblPRL][VARCHAR](30),  
  [dblCPD][VARCHAR](30),  
  [txtCUR][VARCHAR](400),  
  [txtPRL_MO][VARCHAR](400),  
  [txtPRS_MO][VARCHAR](400),  
  [txtCPD_MO][VARCHAR](400),  
  [txtBUR][VARCHAR](400)  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  
  
 -- Reporto Info:  Vector Moneda de Origen (VPrecios)  
 INSERT @tmp_tblResults (dtedate,txtTv,txtEmisora,txtSerie,txtID2,dblPRS,dblPRL,dblCPD,txtCUR,txtPRL_MO,txtPRS_MO,txtCPD_MO,txtBUR)  
 SELECT DISTINCT  
   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],   
   RTRIM(ap.txtTv) AS [txtTv],  
   RTRIM(ap.txtEmisora) AS [txtEmisora],  
   RTRIM(ap.txtSerie) AS [txtSerie],  
   (CASE WHEN LEN(ap.txtId2) = 12 THEN ap.txtId2 ELSE '0' END) AS [txtID2],  
  
   (CASE UPPER(ap.txtLiquidation)  
   WHEN 'MP'THEN LTRIM(STR(ROUND(dblPAV,6),19,6))  
   ELSE LTRIM(STR(ROUND(dblPRS,6),19,6))  
   END) AS [dblPRS],  
   
   (CASE UPPER(ap.txtLiquidation)  
   WHEN 'MP'THEN LTRIM(STR(ROUND(dblPAV,6),19,6))  
   ELSE LTRIM(STR(ROUND(dblPRL,6),19,6))  
   END) AS [dblPRL],  
   
   LTRIM(STR(ROUND(dblCPD,6),19,6)) AS [dblCPD],  
  
   (CASE WHEN RTRIM(txtCUR)<>'-' AND RTRIM(txtCUR)<>'NA' AND RTRIM(txtCUR)<>''   
     THEN RTRIM(ap.txtCUR)   
     ELSE ''  
    END) AS [txtCUR],  
  
   (CASE WHEN (ap.txtPRL_MO<>'NA' AND ap.txtPRL_MO<>'-' AND ap.txtPRL_MO<>'')   
    THEN LTRIM(STR(ROUND(CAST(ap.txtPRL_MO AS FLOAT),6),19,6))   
    ELSE ''  
    END) AS [ap.txtPRL_MO],  
  
   (CASE WHEN (ap.txtPRS_MO<>'NA' AND ap.txtPRS_MO<>'-' AND ap.txtPRS_MO<>'')   
    THEN LTRIM(STR(ROUND(CAST(ap.txtPRS_MO AS FLOAT),6),19,6))   
    ELSE ''  
    END) AS [ap.txtPRS_MO],  
  
   (CASE WHEN (ap.txtCPD_MO<>'NA' AND ap.txtCPD_MO<>'-' AND ap.txtCPD_MO<>'')   
    THEN LTRIM(STR(ROUND(CAST(ap.txtCPD_MO AS FLOAT),6),19,6))   
    ELSE ''  
    END) AS [ap.txtCPD_MO],  
  
   --LTRIM(ap.txtBUR)  
   (CASE WHEN ap.txtBUR = 'NA' OR ap.txtBUR = '-' OR ap.txtBUR = ''   
    THEN ''   
    ELSE LTRIM(ap.txtBUR)  
    END) AS [ap.txtBUR]  
  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap (NOLOCK)  
 WHERE ap.dteDate = @txtDate  
  AND ap.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND ap.txtTv IN ('0','00','1','1A','1ASP','1B','1C','1E','1ESP','1I','1ISP','1S','3','41','51','52','54','56','56SP','CF','YY','YYSP')  
  
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
    [txtID2],  
    [dblPRS],  
    [dblPRL],  
    [dblCPD],  
    [txtCUR],  
    [txtPRL_MO],  
    [txtPRS_MO],  
    [txtCPD_MO],  
    [txtBUR]  
  FROM @tmp_tblResults  
  ORDER BY  
   ap.txtTv,  
   ap.txtEmisora,  
   ap.txtSerie  
  
 SET NOCOUNT OFF  
  
END  
RETURN 0------------------------------------------------------------------------------------  
--   Autor:    Mike Ramirez  
--   Fecha Creacion: 10:19 a.m. 2012-09-20  
--   Descripcion:       Modulo 12: Genera producto HSBC_LIBOR_SPREADS_[yyyymmdd].xls  
------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;12  
 @txtDate AS DATETIME  
  
AS  
BEGIN  
   
   SET NOCOUNT ON  
   
 -- Tabla Temporal para cargar las Directivas  
 DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtCode CHAR(50),  
   txtCode2  CHAR(50),  
   SubType  CHAR(3),  
   Node INT,  
   intCol INT,  
   intRow INT,  
   dblValue VARCHAR(4800)  
  PRIMARY KEY (intCol,intRow)  
  )   
   
 -- <SECCION 1> 1M LIBOR VS 3M LIBOR   
 INSERT @tblDirectives  
  SELECT 1, 'IRC','USBAACB','','','',3,3,NULL UNION  
  SELECT 1, 'IRC','USBAAFB','','','',3,4,NULL UNION  
  SELECT 1, 'IRC','USBAAIB','','','',3,5,NULL UNION  
  SELECT 1, 'IRC','USBA1B','','','',3,6,NULL UNION  
  SELECT 1, 'IRC','USBA2B','','','',3,7,NULL UNION  
  SELECT 1, 'IRC','USBA3B','','','',3,8,NULL UNION  
  SELECT 1, 'IRC','USBA4B','','','',3,9,NULL UNION  
  SELECT 1, 'IRC','USBA5B','','','',3,10,NULL UNION  
  SELECT 1, 'IRC','USBA7B','','','',3,11,NULL UNION  
  SELECT 1, 'IRC','USBA10B','','','',3,12,NULL UNION  
  SELECT 1, 'IRC','USBA15B','','','',3,13,NULL UNION  
  SELECT 1, 'IRC','USBA20B','','','',3,14,NULL UNION  
  SELECT 1, 'IRC','USBA25B','','','',3,15,NULL UNION  
  SELECT 1, 'IRC','USBA30B','','','',3,16,NULL  
   
 -- <SECCION 2> 1M LIBOR VS 3M LIBOR    
 INSERT @tblDirectives  
  SELECT 2, 'IRC','USBAACA','','','',4,3,NULL UNION  
  SELECT 2, 'IRC','USBAAFA','','','',4,4,NULL UNION  
  SELECT 2, 'IRC','USBAAIA','','','',4,5,NULL UNION  
  SELECT 2, 'IRC','USBA1A','','','',4,6,NULL UNION  
  SELECT 2, 'IRC','USBA2A','','','',4,7,NULL UNION  
  SELECT 2, 'IRC','USBA3A','','','',4,8,NULL UNION  
  SELECT 2, 'IRC','USBA4A','','','',4,9,NULL UNION  
  SELECT 2, 'IRC','USBA5A','','','',4,10,NULL UNION  
  SELECT 2, 'IRC','USBA7A','','','',4,11,NULL UNION  
  SELECT 2, 'IRC','USBA10A','','','',4,12,NULL UNION  
  SELECT 2, 'IRC','USBA15A','','','',4,13,NULL UNION  
  SELECT 2, 'IRC','USBA20A','','','',4,14,NULL UNION  
  SELECT 2, 'IRC','USBA25A','','','',4,15,NULL UNION  
  SELECT 2, 'IRC','USBA30A','','','',4,16,NULL  
   
 -- <SECCION 3>   
 INSERT @tblDirectives  
  SELECT 3, 'IRCCAL','USBAACB','USBAACA','','',5,3,NULL UNION  
  SELECT 3, 'IRCCAL','USBAAFB','USBAAFA','','',5,4,NULL UNION  
  SELECT 3, 'IRCCAL','USBAAIB','USBAAIA','','',5,5,NULL UNION  
  SELECT 3, 'IRCCAL','USBA1B','USBA1A','','',5,6,NULL UNION  
  SELECT 3, 'IRCCAL','USBA2B','USBA2A','','',5,7,NULL UNION  
  SELECT 3, 'IRCCAL','USBA3B','USBA3A','','',5,8,NULL UNION  
  SELECT 3, 'IRCCAL','USBA4B','USBA4A','','',5,9,NULL UNION  
  SELECT 3, 'IRCCAL','USBA5B','USBA5A','','',5,10,NULL UNION  
  SELECT 3, 'IRCCAL','USBA7B','USBA7A','','',5,11,NULL UNION  
  SELECT 3, 'IRCCAL','USBA10B','USBA10A','','',5,12,NULL UNION  
  SELECT 3, 'IRCCAL','USBA15B','USBA15A','','',5,13,NULL UNION  
  SELECT 3, 'IRCCAL','USBA20B','USBA20A','','',5,14,NULL UNION  
  SELECT 3, 'IRCCAL','USBA25B','USBA25A','','',5,15,NULL UNION  
  SELECT 3, 'IRCCAL','USBA30B','USBA30A','','',5,16,NULL  
  
 -- <SECCION 4> 3M LIBOR VS 6M LIBOR    
 INSERT @tblDirectives  
  SELECT 4, 'IRC','USBCFB','','','',3,19,NULL UNION  
  SELECT 4, 'IRC','USBC1B','','','',3,20,NULL UNION  
  SELECT 4, 'IRC','USBC2B','','','',3,21,NULL UNION  
  SELECT 4, 'IRC','USBC3B','','','',3,22,NULL UNION  
  SELECT 4, 'IRC','USBC4B','','','',3,23,NULL UNION  
  SELECT 4, 'IRC','USBC5B','','','',3,24,NULL UNION  
  SELECT 4, 'IRC','USBC7B','','','',3,25,NULL UNION  
  SELECT 4, 'IRC','USBC10B','','','',3,26,NULL UNION  
  SELECT 4, 'IRC','USBC15B','','','',3,27,NULL UNION  
  SELECT 4, 'IRC','USBC20B','','','',3,28,NULL UNION  
  SELECT 4, 'IRC','USBC25B','','','',3,29,NULL UNION  
  SELECT 4, 'IRC','USBC30B','','','',3,30,NULL  
   
 -- <SECCION 5> 3M LIBOR VS 6M LIBOR    
 INSERT @tblDirectives  
  SELECT 5, 'IRC','USBCFA','','','',4,19,NULL UNION  
  SELECT 5, 'IRC','USBC1A','','','',4,20,NULL UNION  
  SELECT 5, 'IRC','USBC2A','','','',4,21,NULL UNION  
  SELECT 5, 'IRC','USBC3A','','','',4,22,NULL UNION  
  SELECT 5, 'IRC','USBC4A','','','',4,23,NULL UNION  
  SELECT 5, 'IRC','USBC5A','','','',4,24,NULL UNION  
  SELECT 5, 'IRC','USBC7A','','','',4,25,NULL UNION  
  SELECT 5, 'IRC','USBC10A','','','',4,26,NULL UNION  
  SELECT 5, 'IRC','USBC15A','','','',4,27,NULL UNION  
  SELECT 5, 'IRC','USBC20A','','','',4,28,NULL UNION  
  SELECT 5, 'IRC','USBC25A','','','',4,29,NULL UNION  
  SELECT 5, 'IRC','USBC30A','','','',4,30,NULL  
   
 -- <SECCION 6>  
 INSERT @tblDirectives  
  SELECT 6, 'IRCCAL','USBCFB','USBCFA','','',5,19,NULL UNION  
  SELECT 6, 'IRCCAL','USBC1B','USBC1A','','',5,20,NULL UNION  
  SELECT 6, 'IRCCAL','USBC2B','USBC2A','','',5,21,NULL UNION  
  SELECT 6, 'IRCCAL','USBC3B','USBC3A','','',5,22,NULL UNION  
  SELECT 6, 'IRCCAL','USBC4B','USBC4A','','',5,23,NULL UNION  
  SELECT 6, 'IRCCAL','USBC5B','USBC5A','','',5,24,NULL UNION  
  SELECT 6, 'IRCCAL','USBC7B','USBC7A','','',5,25,NULL UNION  
  SELECT 6, 'IRCCAL','USBC10B','USBC10A','','',5,26,NULL UNION  
  SELECT 6, 'IRCCAL','USBC15B','USBC15A','','',5,27,NULL UNION  
  SELECT 6, 'IRCCAL','USBC20B','USBC20A','','',5,28,NULL UNION  
  SELECT 6, 'IRCCAL','USBC25B','USBC25A','','',5,29,NULL UNION  
  SELECT 6, 'IRCCAL','USBC30B','USBC30A','','',5,30,NULL  
  
 -- <SECCION 7> 1M LIBOR VS 6M LIBOR    
 INSERT @tblDirectives  
  SELECT 7, 'IRC','USBBFB','','','',3,33,NULL UNION  
  SELECT 7, 'IRC','USBB1B','','','',3,34,NULL UNION  
  SELECT 7, 'IRC','USBB2B','','','',3,35,NULL UNION  
  SELECT 7, 'IRC','USBB3B','','','',3,36,NULL UNION  
  SELECT 7, 'IRC','USBB4B','','','',3,37,NULL UNION  
  SELECT 7, 'IRC','USBB5B','','','',3,38,NULL UNION  
  SELECT 7, 'IRC','USBB7B','','','',3,39,NULL UNION  
  SELECT 7, 'IRC','USBB10B','','','',3,40,NULL UNION  
  SELECT 7, 'IRC','USBB15B','','','',3,41,NULL UNION  
  SELECT 7, 'IRC','USBB20B','','','',3,42,NULL UNION  
  SELECT 7, 'IRC','USBB25B','','','',3,43,NULL UNION  
  SELECT 7, 'IRC','USBB30B','','','',3,44,NULL  
   
 -- <SECCION 8> 1M LIBOR VS 6M LIBOR    
 INSERT @tblDirectives  
  SELECT 8, 'IRC','USBBFA','','','',4,33,NULL UNION  
  SELECT 8, 'IRC','USBB1A','','','',4,34,NULL UNION  
  SELECT 8, 'IRC','USBB2A','','','',4,35,NULL UNION  
  SELECT 8, 'IRC','USBB3A','','','',4,36,NULL UNION  
  SELECT 8, 'IRC','USBB4A','','','',4,37,NULL UNION  
  SELECT 8, 'IRC','USBB5A','','','',4,38,NULL UNION  
  SELECT 8, 'IRC','USBB7A','','','',4,39,NULL UNION  
  SELECT 8, 'IRC','USBB10A','','','',4,40,NULL UNION  
  SELECT 8, 'IRC','USBB15A','','','',4,41,NULL UNION  
  SELECT 8, 'IRC','USBB20A','','','',4,42,NULL UNION  
  SELECT 8, 'IRC','USBB25A','','','',4,43,NULL UNION  
  SELECT 8, 'IRC','USBB30A','','','',4,44,NULL  
  
 -- <SECCION 9>  
 INSERT @tblDirectives  
  SELECT 9, 'IRCCAL','USBBFB','USBBFA','','',5,33,NULL UNION  
  SELECT 9, 'IRCCAL','USBB1B','USBB1A','','',5,34,NULL UNION  
  SELECT 9, 'IRCCAL','USBB2B','USBB2A','','',5,35,NULL UNION  
  SELECT 9, 'IRCCAL','USBB3B','USBB3A','','',5,36,NULL UNION  
  SELECT 9, 'IRCCAL','USBB4B','USBB4A','','',5,37,NULL UNION  
  SELECT 9, 'IRCCAL','USBB5B','USBB5A','','',5,38,NULL UNION  
  SELECT 9, 'IRCCAL','USBB7B','USBB7A','','',5,39,NULL UNION  
  SELECT 9, 'IRCCAL','USBB10B','USBB10A','','',5,40,NULL UNION  
  SELECT 9, 'IRCCAL','USBB15B','USBB15A','','',5,41,NULL UNION  
  SELECT 9, 'IRCCAL','USBB20B','USBB20A','','',5,42,NULL UNION  
  SELECT 9, 'IRCCAL','USBB25B','USBB25A','','',5,43,NULL UNION  
  SELECT 9, 'IRCCAL','USBB30B','USBB30A','','',5,44,NULL  
  
 -- <SECCION 10> 3M LIBOR VS 12M LIBOR    
 INSERT @tblDirectives  
  SELECT 10, 'IRC','USBL1B','','','',3,47,NULL UNION  
  SELECT 10, 'IRC','USBL2B','','','',3,48,NULL UNION  
  SELECT 10, 'IRC','USBL3B','','','',3,49,NULL UNION  
  SELECT 10, 'IRC','USBL4B','','','',3,50,NULL UNION  
  SELECT 10, 'IRC','USBL5B','','','',3,51,NULL UNION  
  SELECT 10, 'IRC','USBL7B','','','',3,52,NULL UNION  
  SELECT 10, 'IRC','USBL10B','','','',3,53,NULL UNION  
  SELECT 10, 'IRC','USBL15B','','','',3,54,NULL UNION  
  SELECT 10, 'IRC','USBL20B','','','',3,55,NULL UNION  
  SELECT 10, 'IRC','USBL25B','','','',3,56,NULL UNION  
  SELECT 10, 'IRC','USBL30B','','','',3,57,NULL  
   
 -- <SECCION 11> 3M LIBOR VS 12M LIBOR    
 INSERT @tblDirectives  
  SELECT 11, 'IRC','USBL1A','','','',4,47,NULL UNION  
  SELECT 11, 'IRC','USBL2A','','','',4,48,NULL UNION  
  SELECT 11, 'IRC','USBL3A','','','',4,49,NULL UNION  
  SELECT 11, 'IRC','USBL4A','','','',4,50,NULL UNION  
  SELECT 11, 'IRC','USBL5A','','','',4,51,NULL UNION  
  SELECT 11, 'IRC','USBL7A','','','',4,52,NULL UNION  
  SELECT 11, 'IRC','USBL10A','','','',4,53,NULL UNION  
  SELECT 11, 'IRC','USBL15A','','','',4,54,NULL UNION  
  SELECT 11, 'IRC','USBL20A','','','',4,55,NULL UNION  
  SELECT 11, 'IRC','USBL25A','','','',4,56,NULL UNION  
  SELECT 11, 'IRC','USBL30A','','','',4,57,NULL  
  
 -- <SECCION 12>  
 INSERT @tblDirectives  
  SELECT 12, 'IRCCAL','USBL1B','USBL1A','','',5,47,NULL UNION  
  SELECT 12, 'IRCCAL','USBL2B','USBL2A','','',5,48,NULL UNION  
  SELECT 12, 'IRCCAL','USBL3B','USBL3A','','',5,49,NULL UNION  
  SELECT 12, 'IRCCAL','USBL4B','USBL4A','','',5,50,NULL UNION  
  SELECT 12, 'IRCCAL','USBL5B','USBL5A','','',5,51,NULL UNION  
  SELECT 12, 'IRCCAL','USBL7B','USBL7A','','',5,52,NULL UNION  
  SELECT 12, 'IRCCAL','USBL10B','USBL10A','','',5,53,NULL UNION  
  SELECT 12, 'IRCCAL','USBL15B','USBL15A','','',5,54,NULL UNION  
  SELECT 12, 'IRCCAL','USBL20B','USBL20A','','',5,55,NULL UNION  
  SELECT 12, 'IRCCAL','USBL25B','USBL25A','','',5,56,NULL UNION  
  SELECT 12, 'IRCCAL','USBL30B','USBL30A','','',5,57,NULL   
  
 -- Obtengo los valores de los IRC  
 UPDATE u  
  SET dblValue = (SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode))  
 FROM  
  @tblDirectives AS u  
 WHERE txtSource = 'IRC'  
   
 -- Obtengo los valores de los IRCCAL  
 UPDATE u  
  SET dblValue = (((SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode)) + (SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode2)))/2)  
 FROM  
  @tblDirectives AS u  
 WHERE txtSource = 'IRCCAL'  
   
 -- Valida la información   
 IF ((SELECT COUNT(*) FROM @tblDirectives WHERE dblValue IS NULL AND txtSource = 'IRC') > 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  IF ((SELECT count(*) FROM @tblDirectives WHERE dblValue LIKE '%-999%') > 0)  
  
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
    LTRIM(RTRIM(STR(intSection))) AS txtSection,  
    LTRIM(RTRIM(txtSource)),  
    LTRIM(RTRIM(txtCode)),  
    intCol,  
    intRow,  
    LTRIM(RTRIM(dblValue))  
    FROM @tblDirectives  
    ORDER BY   
    intSection,  
    intCol,  
    intRow  
  
   END  
  
 SET NOCOUNT OFF  
  
END   
------------------------------------------------------------------------------  
-- Autor:     Mike Ramirez  
-- Fecha Modificacion:  10:30 a.m  2012-12-03  
-- Descripcion:    Modificar la validación sobre el campo Consecutivo  
------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;13  
 @txtDate AS VARCHAR(10),  
 @txtFlag AS VARCHAR(1)  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @txtProcDate AS DATETIME  
 DECLARE @txtLiquidation AS VARCHAR(10)  
 DECLARE @txtOwner AS CHAR(5)  
  
 SET @txtProcDate = (SELECT MxFixIncome.dbo.fun_NextTradingDate(CONVERT(CHAR(8),@txtDate,112),1,'MX'))  
 SET @txtLiquidation = '24H'  
 SET @txtOwner = 'HSB03'  
 ------------------------------------------------------------------------------------------------  
 -- genero buffers temporales  
 DECLARE @tbl_tmpData TABLE (  
  [txtId1] [char] (11) NOT NULL ,  
  [txtTv] [char] (10) NOT NULL ,  
  [txtIssuer] [char] (10) NOT NULL ,  
  [txtSeries] [char] (10) NOT NULL ,  
  [txtSerial] [char] (10) NOT NULL ,  
  [txtLiquidation] [char] (3) NOT NULL  
   PRIMARY KEY CLUSTERED   
    ([txtId1],[txtLiquidation]),  
  [intDTM] [int] NOT NULL ,  
  [dblPav] [float] NOT NULL ,  
  [dblMarketPrice] [float] NOT NULL,  
  [dblFRR] [float] NOT NULL,  
  [dblDelta] [float] NOT NULL,  
  [dblLAR] [float] NOT NULL ,  
  [dblSHO] [float] NOT NULL  
 )  
  
 -- genero buffers temporales MARKET PRICES  
 DECLARE @tbl_tmpActualMarketPrices TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] ),  
  [dblMarketPrice] [float] NOT NULL  
 )  
  
 -- genero buffers temporales IDS vs OWNERS  
 DECLARE @tbl_tmpIdsVsOwners TABLE (  
  [txtId1] [char] (11) NOT NULL   
   PRIMARY KEY CLUSTERED ( [txtId1] )  
 )  
  
 ------------------------------------------------------------------------------------------------  
 -- *******************************************  
 -- HECHOS DE MERCADO  
 -- *******************************************  
  
 -- JATO (01:47 p.m. 2007-07-17)  
 -- identifico los instrumentos   
 -- que pertenecen al cliente actual  
  
 INSERT INTO @tbl_tmpIdsVsOwners (txtId1)  
 SELECT txtId1  
 FROM MxDerivatives.dbo.tblDerivativesOwners (NOLOCK)  
 WHERE  
  txtOwnerId = @txtOwner  
  AND dteBeg <= @txtDate  
  AND dteEnd >= @txtDate  
 UNION  
 SELECT d.txtId1  
 FROM   
  MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
  LEFT OUTER JOIN MxDerivatives.dbo.tblDerivativesOwners AS o (NOLOCK)  
  ON d.txtId1 = o.txtId1  
 WHERE  
  o.txtId1 IS NULL  
  
  
  -- obtengo los hechos de mercado   
 -- FUTUROS  
 INSERT @tbl_tmpActualMarketPrices  
 SELECT     
  i.txtId1,   
  dblPrice  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
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
  AND (  
   i.txtTv IN ('FA', 'FD', 'FU', 'FS')  
   OR (  
    i.txtTv IN ('FI', 'FB')  
    AND i.txtIssuer IN ('IPC', 'CE91','M10','M3','TE28')  
  
   )  
  )  
  AND i.txtSerial LIKE 'P%'  
 UNION  
 SELECT     
  i.txtId1,   
  100 / dblPrice AS dblPrice  
 FROM   
  
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
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
  AND i.txtTv IN ('FC')  
  AND i.txtIssuer = 'CEUA'  
  AND i.txtSerial LIKE 'P%'  
  
 UNION  
 SELECT     
  i.txtId1,   
  dblPrice * (  
   CASE   
   WHEN ir.dblVAlue IS NULL THEN 1  
   ELSE ir.dblVAlue  
   END      
  ) AS dblPrice  
 FROM   
  
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS de (NOLOCK)  
  ON i.txtId1 = de.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
  LEFT OUTER JOIN MxFixIncome.dbo.tblIrc AS ir (NOLOCK)  
  ON   
   ir.txtIrc = (  
    CASE de.txtCurrency  
    WHEN 'USD' THEN 'UFXU'  
    WHEN 'DLL' THEN 'UFXU'  
    ELSE de.txtCurrency  
    END   
   )    
   AND ir.dteDate = @txtDate  
  
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
  AND i.txtTv IN ('FC', 'FI', 'FB')  
  AND NOT i.txtIssuer IN ('CEUA', 'IPC', 'CE91','M10','M3','TE28', 'JY')  
  AND i.txtSerial LIKE 'P%'  
 UNION  
 SELECT     
  i.txtId1,   
  dblPrice * (  
   CASE   
   WHEN ir.dblVAlue IS NULL THEN 1  
   ELSE ir.dblVAlue  
   END      
  ) /10000 AS dblPrice  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS de (NOLOCK)  
  ON i.txtId1 = de.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS d (NOLOCK)  
  ON i.txtId1 = d.txtId1  
  LEFT OUTER JOIN MxFixIncome.dbo.tblIrc AS ir (NOLOCK)  
  ON   
   ir.txtIrc = (  
    CASE de.txtCurrency  
    WHEN 'USD' THEN 'UFXU'  
    WHEN 'DLL' THEN 'UFXU'  
    ELSE de.txtCurrency  
    END   
   )    
   AND ir.dteDate = @txtDate  
  
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
  AND i.txtTv IN ('FC')  
  AND i.txtIssuer IN ('JY')  
  AND i.txtSerial LIKE 'P%'  
  
  
 -- MEXDER de 1 dia  
 INSERT @tbl_tmpActualMarketPrices  
 SELECT    
  i2.txtId1,  
  t.dblMarketPrice  
  FROM   
  @tbl_tmpActualMarketPrices AS t  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON t.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblIds AS i2 (NOLOCK)  
  ON   
   i.txtTv = i2.txtTv  
   AND i.txtIssuer = i2.txtIssuer  
   AND i.txtSeries = i2.txtSeries  
 WHERE  
  i.txtSerial LIKE 'P%'  
  AND NOT i2.txtSerial LIKE 'P%'  
  AND i2.txtId1 NOT IN ('XGPP0000037',  
'XGPP0000038',  
'XGPP0000039',  
'XGPP0000040',  
'XGPP0000041',  
'XGPP0000042',  
'XGPP0000043',  
'XGPP0000046',  
'XGPP0000047',  
'XGPP0000048',  
'XGPP0000049',  
'XGPP0000050',  
'XGPP0000051',  
'XGPP0000052',  
'XGPP0000053')  
  
  
  -- obtengo los F0 para los demas instrumentos  
 -- que esten en el vector de precios  
 INSERT @tbl_tmpActualMarketPrices  
 SELECT  
  i.txtId1,  
  CASE d.intFamily  
  WHEN 13 THEN p.dblValue * 100  
  ELSE p.dblValue  
  END AS dblMarketPrice  
   
 FROM  
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblPrices AS p (NOLOCK)  
  ON p.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
  ON p.txtId1 = d.txtId1  
  WHERE  
  p.dteDate = @txtDate  
  AND p.txtLiquidation = @txtLiquidation  
  AND p.txtItem = 'F0'  
  AND i.txtTv IN  ('FWD', 'CALL', 'PUT')  
  
 -- ************************************************  
 -- obtengo el consolidado  
 -- ************************************************  
  
 INSERT @tbl_tmpData   
 SELECT   
  i.txtId1,   
  i.txtTv,  
  i.txtIssuer,  
  i.txtSeries,  
  i.txtSerial,  
  p.txtLiquidation,  
  
  CASE   
  WHEN DATEDIFF(d, @txtProcDate, d.dteMaturity) < 0 THEN 0  
  ELSE DATEDIFF(d, @txtProcDate, d.dteMaturity)  
  END AS intDTM,  
  
  MAX(CASE p.txtItem WHEN 'PAV' THEN p.dblValue ELSE -999999999 END) AS dblPav,  
  CASE   
   WHEN mp.dblMarketPrice IS NULL THEN 0  
   ELSE mp.dblMarketPrice  
  END AS dblMarketPrice,  
  MAX(CASE p.txtItem WHEN 'FRR' THEN p.dblValue ELSE 0 END) AS dblFRR,  
  MAX(CASE p.txtItem WHEN 'DELTA' THEN p.dblValue ELSE -999 END) AS dblDelta,  
  MAX(CASE p.txtItem WHEN 'LAR' THEN p.dblValue ELSE 0 END) AS dblLar,  
  MAX(CASE p.txtItem WHEN 'SHO' THEN p.dblValue ELSE 0 END) AS dblSho  
 FROM   
  @tbl_tmpIdsVsOwners AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
  ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblPrices AS p (NOLOCK)  
  ON u.txtId1 = p.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
  ON u.txtId1 = d.txtId1  
  LEFT OUTER JOIN @tbl_tmpActualMarketPrices AS mp  
  ON u.txtId1 = mp.txtId1  
  WHERE  
  p.dteDate = @txtDate  
 GROUP BY   
  i.txtId1,  
  i.txtTv,  
  i.txtIssuer,  
  i.txtSeries,  
  i.txtSerial,  
  p.txtLiquidation,  
  d.dteMaturity,  
  mp.dblMarketPrice  
  
 -- Agrego tblDerivativesPrices.dblPrice del conjunto de los TV = {OA,OI,OD}  
 UPDATE u  
 SET dblMarketPrice = dp.dblPrice  
 FROM  
  @tbl_tmpData AS u  
  INNER JOIN MxDerivatives.dbo.tblIds AS i (NOLOCK)  
   ON u.txtId1 = i.txtId1  
  INNER JOIN MxDerivatives.dbo.tblDerivativesPrices AS dp (NOLOCK)  
   ON i.txtId1 = dp.txtId1  
 WHERE  
  dp.dteDate = @txtDate  
  AND i.txtTv IN ('OA','OI','OD')  
  
 -- correccion de deltas   
 UPDATE @tbl_tmpData   
 SET dblDelta = 0  
 WHERE  
  dblDelta = -999  
  
 SET NOCOUNT OFF  
  
 -- creo el vector  
 SELECT   
  'H ' +  
  'DR' +  
  @txtDate +  
  RTRIM(txtTv) + REPLICATE(' ',4 - LEN(txtTv)) +  
  RTRIM(txtIssuer) + REPLICATE(' ',7 - LEN(txtIssuer)) +  
  RTRIM(txtSeries) + REPLICATE(' ',6 - LEN(txtSeries)) +  
  
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
  '000000000000' +   
  SUBSTRING(RTRIM(txtSerial),1,10) +   
  CASE  
   WHEN LEN(txtSerial) > 10 THEN ''  
   ELSE REPLICATE('0',10 - LEN(txtSerial))  
  END +  
  CASE WHEN dblMarketPrice < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
           SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblMarketPrice,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  
  CASE WHEN dblFRR < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblFRR,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
           SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6),  ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6),  ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblFRR,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  
  CASE WHEN dblDelta < 0 THEN   
   '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(dblDelta,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
           SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6),  ' ', '0'), 11, 6)   
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6),  ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(dblDelta,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  
  CASE  
  WHEN i.dblValue IS NULL THEN '000001000000'  
  ELSE   
   SUBSTRING(REPLACE(STR(ROUND(i.dblValue,6),13,6),  ' ', '0'), 1, 6) +  
    SUBSTRING(REPLACE(STR(ROUND(i.dblValue,6),13,6),  ' ', '0'), 8, 6)   
  END  +  
  
  CASE WHEN a.dblLar < 0 THEN   
   
      '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblLar,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
         SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6),  ' ', '0'), 11, 6)   
  
  ELSE   
  SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(a.dblLar,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  
  CASE WHEN a.dblSho < 0 THEN   
   
          '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(a.dblSho,6),16,6),  '-', '0'),' ','0'), 2, 8) +   
         SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6),  ' ', '0'), 11, 6)   
  
  ELSE   
  SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(a.dblSho,6),16,6),  ' ', '0'), 11, 6)   
  END  
  
 FROM   
  @tbl_tmpData  AS a  
  INNER JOIN MxDerivatives.dbo.tblDerivatives AS d (NOLOCK)  
  ON a.txtId1 = d.txtId1  
  LEFT OUTER JOIN MxFixIncome.dbo.tblIrc AS i (NOLOCK)  
  ON   
   i.txtIrc = (  
    CASE   
    WHEN d.txtCurrency IN ('USD', 'DLL') THEN 'UFXU'  
    WHEN d.txtCurrency IN ('MUD') THEN 'UDI'  
    ELSE  
     d.txtCurrency  
    END   
   )  
   AND i.dteDate = @txtDate  
  
 WHERE   
  txtLiquidation IN (@txtLiquidation, 'MP')  
 ORDER BY  
  txtTv,  
  txtIssuer,  
  txtSeries,  
  txtSerial  
  
END  
--------------------------------------------------------------------------------------------  
--   Autor:    Mike Ramirez  
--   Fecha Creacion: 10:04 a.m. 2012-11-30  
--   Descripcion:       Modulo 14: Genera producto HSBC_LIBOR_SPREADS_EUR-GBP_[yyyymmdd].xls  
--------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;14  
 @txtDate AS DATETIME  
  
AS  
BEGIN  
   
   SET NOCOUNT ON  
   
 -- Tabla Temporal para cargar las Directivas  
 DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtCode CHAR(50),  
   txtCode2  CHAR(50),  
   SubType  CHAR(3),  
   Node INT,  
   intCol INT,  
   intRow INT,  
   dblValue VARCHAR(4800)  
  PRIMARY KEY (intCol,intRow)  
  )   
   
 -- <SECCION 1> 3M EURIBOR VS 6M EURIBOR  
 INSERT @tblDirectives  
  SELECT 1, 'IRC','EUBST1B','','','',3,3,NULL UNION  
  SELECT 1, 'IRC','EUBST2B','','','',3,4,NULL UNION  
  SELECT 1, 'IRC','EUBST3B','','','',3,5,NULL UNION  
  SELECT 1, 'IRC','EUBST4B','','','',3,6,NULL UNION  
  SELECT 1, 'IRC','EUBST5B','','','',3,7,NULL UNION  
  SELECT 1, 'IRC','EUBST6B','','','',3,8,NULL UNION  
  SELECT 1, 'IRC','EUBST7B','','','',3,9,NULL UNION  
  SELECT 1, 'IRC','EUBST8B','','','',3,10,NULL UNION  
  SELECT 1, 'IRC','EUBST9B','','','',3,11,NULL UNION  
  SELECT 1, 'IRC','EUBS10B','','','',3,12,NULL UNION  
  SELECT 1, 'IRC','EUBS11B','','','',3,13,NULL UNION  
  SELECT 1, 'IRC','EUBS12B','','','',3,14,NULL UNION  
  SELECT 1, 'IRC','EUBS15B','','','',3,15,NULL UNION  
  SELECT 1, 'IRC','EUBS20B','','','',3,16,NULL UNION  
  SELECT 1, 'IRC','EUBS25B','','','',3,17,NULL UNION  
  SELECT 1, 'IRC','EUBS30B','','','',3,18,NULL  
   
 -- <SECCION 2> 3M EURIBOR VS 6M EURIBOR  
 INSERT @tblDirectives  
  SELECT 2, 'IRC','EUBST1A','','','',4,3,NULL UNION  
  SELECT 2, 'IRC','EUBST2A','','','',4,4,NULL UNION  
  SELECT 2, 'IRC','EUBST3A','','','',4,5,NULL UNION  
  SELECT 2, 'IRC','EUBST4A','','','',4,6,NULL UNION  
  SELECT 2, 'IRC','EUBST5A','','','',4,7,NULL UNION  
  SELECT 2, 'IRC','EUBST6A','','','',4,8,NULL UNION  
  SELECT 2, 'IRC','EUBST7A','','','',4,9,NULL UNION  
  SELECT 2, 'IRC','EUBST8A','','','',4,10,NULL UNION  
  SELECT 2, 'IRC','EUBST9A','','','',4,11,NULL UNION  
  SELECT 2, 'IRC','EUBS10A','','','',4,12,NULL UNION  
  SELECT 2, 'IRC','EUBS11A','','','',4,13,NULL UNION  
  SELECT 2, 'IRC','EUBS12A','','','',4,14,NULL UNION  
  SELECT 2, 'IRC','EUBS15A','','','',4,15,NULL UNION  
  SELECT 2, 'IRC','EUBS20A','','','',4,16,NULL UNION  
  SELECT 2, 'IRC','EUBS25A','','','',4,17,NULL UNION  
  SELECT 2, 'IRC','EUBS30A','','','',4,18,NULL  
   
 -- <SECCION 3> 3M EURIBOR VS 6M EURIBOR  
 INSERT @tblDirectives  
  SELECT 3, 'IRCCAL','EUBST1B','EUBST1A','','',5,3,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST2B','EUBST2A','','',5,4,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST3B','EUBST3A','','',5,5,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST4B','EUBST4A','','',5,6,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST5B','EUBST5A','','',5,7,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST6B','EUBST6A','','',5,8,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST7B','EUBST7A','','',5,9,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST8B','EUBST8A','','',5,10,NULL UNION  
  SELECT 3, 'IRCCAL','EUBST9B','EUBST9A','','',5,11,NULL UNION  
  SELECT 3, 'IRCCAL','EUBS10B','EUBS10A','','',5,12,NULL UNION  
  SELECT 3, 'IRCCAL','EUBS11B','EUBS11A','','',5,13,NULL UNION  
  SELECT 3, 'IRCCAL','EUBS12B','EUBS12A','','',5,14,NULL UNION  
  SELECT 3, 'IRCCAL','EUBS15B','EUBS15A','','',5,15,NULL UNION  
  SELECT 3, 'IRCCAL','EUBS20B','EUBS20A','','',5,16,NULL UNION  
  SELECT 3, 'IRCCAL','EUBS25B','EUBS25A','','',5,17,NULL UNION  
  SELECT 3, 'IRCCAL','EUBS30B','EUBS30A','','',5,18,NULL  
  
 -- <SECCION 4> 6M GBP VS 3M GBP  
 INSERT @tblDirectives  
  SELECT 4, 'IRC','BPSFC1B','','','',3,21,NULL UNION  
  SELECT 4, 'IRC','BPSFC2B','','','',3,22,NULL UNION  
  SELECT 4, 'IRC','BPSFC3B','','','',3,23,NULL UNION  
  SELECT 4, 'IRC','BPSFC4B','','','',3,24,NULL UNION  
  SELECT 4, 'IRC','BPSFC5B','','','',3,25,NULL UNION  
  SELECT 4, 'IRC','BPSFC6B','','','',3,26,NULL UNION  
  SELECT 4, 'IRC','BPSFC7B','','','',3,27,NULL UNION  
  SELECT 4, 'IRC','BPSFC8B','','','',3,28,NULL UNION  
  SELECT 4, 'IRC','BPSFC9B','','','',3,29,NULL UNION  
  SELECT 4, 'IRC','BPSF10B','','','',3,30,NULL UNION  
  SELECT 4, 'IRC','BPSF12B','','','',3,31,NULL UNION  
  SELECT 4, 'IRC','BPSF15B','','','',3,32,NULL UNION  
  SELECT 4, 'IRC','BPSF20B','','','',3,33,NULL UNION  
  SELECT 4, 'IRC','BPSF25B','','','',3,34,NULL UNION  
  SELECT 4, 'IRC','BPSF30B','','','',3,35,NULL  
   
 -- <SECCION 5> 6M GBP VS 3M GBP  
 INSERT @tblDirectives  
  SELECT 5, 'IRC','BPSFC1A','','','',4,21,NULL UNION  
  SELECT 5, 'IRC','BPSFC2A','','','',4,22,NULL UNION  
  SELECT 5, 'IRC','BPSFC3A','','','',4,23,NULL UNION  
  SELECT 5, 'IRC','BPSFC4A','','','',4,24,NULL UNION  
  SELECT 5, 'IRC','BPSFC5A','','','',4,25,NULL UNION  
  SELECT 5, 'IRC','BPSFC6A','','','',4,26,NULL UNION  
  SELECT 5, 'IRC','BPSFC7A','','','',4,27,NULL UNION  
  SELECT 5, 'IRC','BPSFC8A','','','',4,28,NULL UNION  
  SELECT 5, 'IRC','BPSFC9A','','','',4,29,NULL UNION  
  SELECT 5, 'IRC','BPSF10A','','','',4,30,NULL UNION  
  SELECT 5, 'IRC','BPSF12A','','','',4,31,NULL UNION  
  SELECT 5, 'IRC','BPSF15A','','','',4,32,NULL UNION  
  SELECT 5, 'IRC','BPSF20A','','','',4,33,NULL UNION  
  SELECT 5, 'IRC','BPSF25A','','','',4,34,NULL UNION  
  SELECT 5, 'IRC','BPSF30A','','','',4,35,NULL  
   
 -- <SECCION 6> 6M GBP VS 3M GBP   
 INSERT @tblDirectives  
  SELECT 6, 'IRCCAL','BPSFC1B','BPSFC1A','','',5,21,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC2B','BPSFC2A','','',5,22,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC3B','BPSFC3A','','',5,23,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC4B','BPSFC4A','','',5,24,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC5B','BPSFC5A','','',5,25,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC6B','BPSFC6A','','',5,26,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC7B','BPSFC7A','','',5,27,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC8B','BPSFC8A','','',5,28,NULL UNION  
  SELECT 6, 'IRCCAL','BPSFC9B','BPSFC9A','','',5,29,NULL UNION  
  SELECT 6, 'IRCCAL','BPSF10B','BPSF10A','','',5,30,NULL UNION  
  SELECT 6, 'IRCCAL','BPSF12B','BPSF12A','','',5,31,NULL UNION  
  SELECT 6, 'IRCCAL','BPSF15B','BPSF15A','','',5,32,NULL UNION  
  SELECT 6, 'IRCCAL','BPSF20B','BPSF20A','','',5,33,NULL UNION  
  SELECT 6, 'IRCCAL','BPSF25B','BPSF25A','','',5,34,NULL UNION  
  SELECT 6, 'IRCCAL','BPSF30B','BPSF30A','','',5,35,NULL  
  
 -- <SECCION 7> GBP vs USD BASIS SWAPS    
 INSERT @tblDirectives  
  SELECT 7, 'IRC','BPBSS1B','','','',3,38,NULL UNION  
  SELECT 7, 'IRC','BPBSS2B','','','',3,39,NULL UNION  
  SELECT 7, 'IRC','BPBSS3B','','','',3,40,NULL UNION  
  SELECT 7, 'IRC','BPBSS4B','','','',3,41,NULL UNION  
  SELECT 7, 'IRC','BPBSS5B','','','',3,42,NULL UNION  
  SELECT 7, 'IRC','BPBSS6B','','','',3,43,NULL UNION  
  SELECT 7, 'IRC','BPBSS7B','','','',3,44,NULL UNION  
  SELECT 7, 'IRC','BPBSS8B','','','',3,45,NULL UNION  
  SELECT 7, 'IRC','BPBSS9B','','','',3,46,NULL UNION  
  SELECT 7, 'IRC','BPBS10B','','','',3,47,NULL UNION  
  SELECT 7, 'IRC','BPBS12B','','','',3,48,NULL UNION  
  SELECT 7, 'IRC','BPBS15B','','','',3,49,NULL UNION  
  SELECT 7, 'IRC','BPBS20B','','','',3,50,NULL UNION  
  SELECT 7, 'IRC','BPBS25B','','','',3,51,NULL UNION  
  SELECT 7, 'IRC','BPBS30B','','','',3,52,NULL  
  
 -- <SECCION 8> GBP vs USD BASIS SWAPS  
 INSERT @tblDirectives  
  SELECT 8, 'IRC','BPBSS1A','','','',4,38,NULL UNION  
  SELECT 8, 'IRC','BPBSS2A','','','',4,39,NULL UNION  
  SELECT 8, 'IRC','BPBSS3A','','','',4,40,NULL UNION  
  SELECT 8, 'IRC','BPBSS4A','','','',4,41,NULL UNION  
  SELECT 8, 'IRC','BPBSS5A','','','',4,42,NULL UNION  
  SELECT 8, 'IRC','BPBSS6A','','','',4,43,NULL UNION  
  SELECT 8, 'IRC','BPBSS7A','','','',4,44,NULL UNION  
  SELECT 8, 'IRC','BPBSS8A','','','',4,45,NULL UNION  
  SELECT 8, 'IRC','BPBSS9A','','','',4,46,NULL UNION  
  SELECT 8, 'IRC','BPBS10A','','','',4,47,NULL UNION  
  SELECT 8, 'IRC','BPBS12A','','','',4,48,NULL UNION  
  SELECT 8, 'IRC','BPBS15A','','','',4,49,NULL UNION  
  SELECT 8, 'IRC','BPBS20A','','','',4,50,NULL UNION  
  SELECT 8, 'IRC','BPBS25A','','','',4,51,NULL UNION  
  SELECT 8, 'IRC','BPBS30A','','','',4,52,NULL  
  
 -- <SECCION 9> GBP vs USD BASIS SWAPS  
 INSERT @tblDirectives  
  SELECT 9, 'IRCCAL','BPBSS1B','BPBSS1A','','',5,38,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS2B','BPBSS2A','','',5,39,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS3B','BPBSS3A','','',5,40,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS4B','BPBSS4A','','',5,41,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS5B','BPBSS5A','','',5,42,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS6B','BPBSS6A','','',5,43,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS7B','BPBSS7A','','',5,44,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS8B','BPBSS8A','','',5,45,NULL UNION  
  SELECT 9, 'IRCCAL','BPBSS9B','BPBSS9A','','',5,46,NULL UNION  
  SELECT 9, 'IRCCAL','BPBS10B','BPBS10A','','',5,47,NULL UNION  
  SELECT 9, 'IRCCAL','BPBS12B','BPBS12A','','',5,48,NULL UNION  
  SELECT 9, 'IRCCAL','BPBS15B','BPBS15A','','',5,49,NULL UNION  
  SELECT 9, 'IRCCAL','BPBS20B','BPBS20A','','',5,50,NULL UNION  
  SELECT 9, 'IRCCAL','BPBS25B','BPBS25A','','',5,51,NULL UNION  
  SELECT 9, 'IRCCAL','BPBS30B','BPBS30A','','',5,52,NULL  
  
 -- Obtengo los valores de los IRC  
 UPDATE u  
  SET dblValue = (SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode))  
 FROM  
  @tblDirectives AS u  
 WHERE txtSource = 'IRC'  
   
 -- Obtengo los valores de los IRCCAL  
 UPDATE u  
  SET dblValue = (((SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode)) + (SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode2)))/2)  
 FROM  
  @tblDirectives AS u  
 WHERE txtSource = 'IRCCAL'  
   
 -- Valida la información   
 IF ((SELECT COUNT(*) FROM @tblDirectives WHERE dblValue IS NULL AND txtSource = 'IRC') > 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  IF ((SELECT count(*) FROM @tblDirectives WHERE dblValue LIKE '%-999%') > 0)  
  
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
    LTRIM(RTRIM(STR(intSection))) AS txtSection,  
    LTRIM(RTRIM(txtSource)),  
    LTRIM(RTRIM(txtCode)),  
    intCol,  
    intRow,  
    LTRIM(RTRIM(dblValue))  
    FROM @tblDirectives  
    ORDER BY   
    intSection,  
    intCol,  
    intRow  
  
   END  
  
 SET NOCOUNT OFF  
  
END   
  
-----------------------------------------------------------------------------------------------------------------  
--   Autor:    Mike Ramirez  
--   Fecha Creacion: 13:48 2012-12-06  
--   Descripcion:       Modulo 15: Se generará un nuevo producto que incluirá dos curvas de colones de Costa Rica  
-----------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;15  
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
  SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'Curva Yield Lineal Colones'  AS [Header],'CURVES' AS [Source],'SCR'    AS [Type],'CLY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [DataFormat],'1' AS [fLo
ad] UNION   SELECT 'Sheet1' AS [SheetName], 3 AS [Col],'Curva Yield Lineal Colones en Dólares'  AS [Header],'CURVES' AS [Source],'SCR'    AS [Type],'DLY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [Dat
aFormat],'1' AS [fLoad]   
   
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
 ORDER BY Col  
  
 SET NOCOUNT OFF  
  
END  
  
-------------------------------------------------------  
--   Autor:    Mike Ramirez  
--   Fecha Creacion: 10:10 2013-09-13  
--   Descripcion:       Modulo 16: Se agrega un TC CNHX  
-------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;16     
  @txtDate AS DATETIME      
      
AS         
BEGIN        
      
 SET NOCOUNT ON  
  
 DECLARE @dblUSD0 AS FLOAT  
 DECLARE @dblUSD1 AS FLOAT  
 DECLARE @dblUSD2 AS FLOAT  
      
 -- Tabla para obtener el universo de IRC´s  
 DECLARE @tmp_tblMaxDate TABLE (  
  txtIRC CHAR(7),  
  dteDate DATETIME  
 PRIMARY KEY (txtIRC))  
  
 -- Tabla para obtener el universo de IRC´s  
 DECLARE @tmp_tblUniverseIRC TABLE (  
  txtIRC CHAR(7),  
  dteDate DATETIME,  
  dblValue FLOAT  
 PRIMARY KEY (txtIRC))  
  
  -- genera tabla temporal de resultados      
  DECLARE @tblResult TABLE (      
   [intSection][INTEGER],      
   [txtData][VARCHAR](8000)      
  )      
      
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)      
 DECLARE @tmp_tblDirectivesIRC TABLE (      
   [intSection][INTEGER],  
   [txtIRC]  CHAR(30),      
   [Label]  CHAR(30),        
   [dblValueOr] VARCHAR(50),  
   [dblValue] VARCHAR(50)       
  PRIMARY KEY(intSection)      
  )      
     
 SET @dblUSD0 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD0')  
 SET @dblUSD1 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD1')  
 SET @dblUSD2 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD2')  
  
 -- Obtenemos los maximos del Universo a procesar   
 INSERT @tmp_tblMaxDate   
  SELECT  
   txtIRC,  
   MAX(dteDate)  
  FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
  WHERE  
   txtIRC IN ('USD0',  
      'USD1',  
      'USD2',  
      'EURU',  
      'GBPU',  
      'JPYX',  
      'CADX',  
      'DKKX',  
      'CHFX',  
      'SEKX',  
      'BRLX',  
      'NOKX',  
      'PLATA',  
      'ORO',  
      'UFXU',  
      'CLP',  
      'CLPU',  
      'AUDX',  
      'CNYU',  
      'ARPX',  
      'NZDX',  
      'CNHX')  
  GROUP BY txtIRC  
  
 -- Obtenemos el universo de los IRC  
 INSERT @tmp_tblUniverseIRC  
  SELECT   
   m.txtIRC,  
   m.dteDate,  
   i.dblValue  
  FROM @tmp_tblMaxDate AS m  
   INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
   ON m.txtIRC = i.txtIRC  
   AND m.dteDate = i.dteDate   
  
  -- Obtengo los encabezados  
  INSERT @tblResult      
  SELECT 001,'TIPO DE CAMBIO' UNION  
  SELECT 002,'Mismo Dia' + ',' + LTRIM(STR(ROUND(@dblUSD0,6),16,6)) UNION      
  SELECT 003,'24 horas' + ',' + LTRIM(STR(ROUND(@dblUSD1,6),16,6)) UNION    
  SELECT 004,'Spot' + ',' + LTRIM(STR(ROUND(@dblUSD2,6),16,6)) UNION  
  SELECT 005,'Fecha,Clave,Tipo cambio orig,Tipo de Cambio Sobre Dolar'  
  
  -- Obetenemos los IRC's  
  INSERT @tmp_tblDirectivesIRC (intSection,txtIRC,Label,dblValueOr,dblValue)     
  SELECT 006,'EURU','EUR',NULL,NULL UNION      
  SELECT 007,'GBPU','GBP',NULL,NULL UNION      
  SELECT 008,'JPYX','JPY',NULL,NULL UNION      
  SELECT 009,'CADX','CAD',NULL,NULL UNION      
  SELECT 010,'DKKX','DKK',NULL,NULL UNION      
  SELECT 011,'CHFX','CHF',NULL,NULL UNION      
  SELECT 012,'SEKX','SEK',NULL,NULL UNION      
  SELECT 013,'BRLX','BRL',NULL,NULL UNION      
  SELECT 014,'NOKX','NOK',NULL,NULL UNION      
  SELECT 015,'PLATA','PLATA',NULL,NULL UNION      
  SELECT 016,'ORO','ORO',NULL,NULL UNION  
  SELECT 017,'UFXU','UFX',NULL,NULL UNION  
  SELECT 018,'CLP','CLP',NULL,NULL UNION  
  SELECT 019,'CLPU','CLPU',NULL,NULL UNION  
  SELECT 020,'AUDX','AUDX',NULL,NULL UNION  
  SELECT 021,'CNYU','CNY',NULL,NULL UNION  
  SELECT 022,'ARPX','ARP',NULL,NULL UNION  
  SELECT 023,'NZDX','NZD',NULL,NULL UNION  
  SELECT 024,'CNHX','CNH',NULL,NULL   
  
  -- Obtengo los valores de los IRC's  
  UPDATE d  
   SET d.dblValue = STR(ROUND(u.dblValue,9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
  
  -- Obtengo los valores de los IRC's      
  UPDATE d  
   SET d.dblValueOr = STR(ROUND(u.dblValue,9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
   AND d.txtIRC IN ('EURU','GBPU','PLATA','ORO','UFXU','AUDX','CNHX')  
  
  -- Obtengo los valores de los IRC's      
  UPDATE d  
   SET d.dblValue = STR(ROUND( 1 / u.dblValue,9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
   AND d.txtIRC = 'CNHX'  
  
  -- Obtengo los valores de los IRC's      
  UPDATE d  
   SET d.dblValueOr = STR(ROUND((1 / u.dblValue),9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
   AND d.txtIRC IN ('JPYX','CADX','DKKX','CHFX','SEKX','BRLX','NOKX','CLP','CLPU','CNYU','ARPX','NZDX')  
  
  INSERT @tblResult  
   SELECT         
    intSection,CONVERT(CHAR(10),@txtDate,103) + ',' +  RTRIM(Label) + ',' + LTRIM(dblValue) + ',' + LTRIM(dblValueOr)  
   FROM @tmp_tblDirectivesIRC  
  
  -- Valida que la información este completa        
  IF ((SELECT COUNT(*) FROM @tblResult WHERE txtData IS NULL) > 0 )  
       
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
  
-------------------------------------------------------------------------------------------  
--   Autor:       Mike Ramirez  
--   Creacion:   9:13 a.m. 2013-06-07  
--   Descripcion:    Modulo 17:  Procedimiento que genera producto HSBC_VF[YYYYMMDD].txt  
-------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;17  
  @txtDate AS DATETIME   
  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 -- Tabla de Resultados  
 DECLARE @tblResults TABLE (  
  [txtTv][VARCHAR](15),  
  [txtEmisora][VARCHAR](15),  
  [txtSerie][VARCHAR](15),  
  [txtData][VARCHAR](8000),  
   PRIMARY KEY(txtTv,txtEmisora,txtSerie)  
 )  
   
 INSERT @tblResults (txtTv,txtEmisora,txtSerie,txtData)  
   SELECT   
    um.txtTv,  
    um.txtEmisora,  
    um.txtSerie,  
    CONVERT(CHAR(8),um.dteDate, 112) +  
    CASE   
     WHEN um.txtTv IS NULL THEN SUBSTRING(( CONVERT(CHAR(4), '') ), 1, 4)  
     WHEN LTRIM(RTRIM(um.txtTv)) = '-' THEN SUBSTRING(( CONVERT(CHAR(4), '') ), 1, 4)  
     WHEN LTRIM(RTRIM(um.txtTv)) = 'NA' THEN SUBSTRING(( CONVERT(CHAR(4), '') ), 1, 4)  
    ELSE REPLACE(SUBSTRING((CONVERT(CHAR(4),um.txtTv) ), 1, 4),' ', CHAR(32))  
    END +  
    CASE   
     WHEN um.txtEmisora IS NULL THEN SUBSTRING(( CONVERT(CHAR(7), '') ), 1, 7)  
     WHEN LTRIM(RTRIM(um.txtEmisora)) = '-' THEN SUBSTRING(( CONVERT(CHAR(7), '') ), 1, 7)  
     WHEN LTRIM(RTRIM(um.txtEmisora)) = 'NA' THEN SUBSTRING(( CONVERT(CHAR(7), '') ), 1, 7)  
    ELSE REPLACE(SUBSTRING(( CONVERT(CHAR(7),um.txtEmisora) ), 1, 7),' ', CHAR(32))  
    END +  
    CASE   
     WHEN um.txtSerie IS NULL THEN SUBSTRING(( CONVERT(CHAR(6), '') ), 1, 6)  
     WHEN LTRIM(RTRIM(um.txtSerie)) = '-' THEN SUBSTRING(( CONVERT(CHAR(6), '') ), 1, 6)  
     WHEN LTRIM(RTRIM(um.txtSerie)) = 'NA' THEN SUBSTRING(( CONVERT(CHAR(6), '') ), 1, 6)  
    ELSE REPLACE(SUBSTRING(( CONVERT(CHAR(6),um.txtSerie) ), 1, 6),' ', CHAR(32))  
    END +  
    CASE   
     WHEN um.txtPCR IS NULL THEN REPLACE(SUBSTRING(CONVERT(CHAR(4), ' '), 1, 4), ' ',CHAR(48))  
     WHEN ISNUMERIC(um.txtPCR) = 1 AND um.txtPCR <> '-' THEN SUBSTRING(REPLACE(STR(ROUND(um.txtPCR, 4), 4, 0), ' ',CHAR(48)), 1, 4)  
        + SUBSTRING(REPLACE(STR(ROUND(um.txtPCR, 0), 4, 0), ' ',CHAR(48)), 4, 0)  
    ELSE REPLACE(SUBSTRING(CONVERT(CHAR(4), ' '), 1, 4), ' ',CHAR(48))  
    END +  
    CASE   
     WHEN um.dblDTM IS NULL THEN SUBSTRING(CONVERT(CHAR(5), ' '), 1, 5)  
    ELSE SUBSTRING(REPLACE(STR(ROUND(um.dblDTM, 5), 5, 0), ' ',CHAR(48)), 1, 5)  
      + SUBSTRING(REPLACE(STR(ROUND(um.dblDTM, 0), 5, 0),' ', CHAR(48)), 5, 0)  
    END +  
    CASE   
     WHEN um.dblPRL IS NULL THEN SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17)  
    ELSE SUBSTRING(REPLACE(STR(ROUND(um.dblPRL, 9), 18, 8),' ', CHAR(48)), 1, 9)  
      + SUBSTRING(REPLACE(STR(ROUND(um.dblPRL, 8), 16,8), ' ', CHAR(48)), 9, 8)  
    END +  
    CASE   
     WHEN u24.dblPRL IS NULL THEN SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17)  
    ELSE SUBSTRING(REPLACE(STR(ROUND(u24.dblPRL, 9), 18, 8),' ', CHAR(48)), 1, 9)  
      + SUBSTRING(REPLACE(STR(ROUND(u24.dblPRL, 8), 16,8), ' ', CHAR(48)), 9, 8)  
    END +  
    CASE   
     WHEN um.txtPSPP IS NULL THEN REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))  
     WHEN ISNUMERIC(um.txtPSPP) = 1 AND um.txtPSPP <> '-' THEN SUBSTRING(REPLACE(STR(ROUND(um.txtPSPP, 9), 18,8), ' ', CHAR(48)), 1, 9)  
       + SUBSTRING(REPLACE(STR(ROUND(um.txtPSPP, 8), 17,8), ' ', CHAR(48)), 10, 8)  
    ELSE REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))  
    END +  
    CASE  
     WHEN u24.txtPSPP IS NULL THEN REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))  
     WHEN ISNUMERIC(u24.txtPSPP) = 1 AND u24.txtPSPP <> '-' THEN SUBSTRING(REPLACE(STR(ROUND(u24.txtPSPP, 9), 18,8), ' ', CHAR(48)), 1, 9)  
       + SUBSTRING(REPLACE(STR(ROUND(u24.txtPSPP, 8),17, 8), ' ', CHAR(48)), 10, 8)  
    ELSE REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))  
    END +  
    CASE  
     WHEN um.txtAFO_SPR_UN IS NULL THEN REPLACE(SUBSTRING(CONVERT(CHAR(6), ' '), 1, 6), ' ',CHAR(48))  
     WHEN ISNUMERIC(um.txtAFO_SPR_UN) = 1 AND um.txtAFO_SPR_UN <> '-' THEN SUBSTRING(REPLACE(STR(ROUND(um.txtAFO_SPR_UN, 2), 7, 4), ' ',CHAR(48)), 1, 2)  
       + SUBSTRING(REPLACE(STR(ROUND(um.txtAFO_SPR_UN, 4), 6, 4), ' ',CHAR(48)), 3, 4)  
    ELSE REPLACE(SUBSTRING(CONVERT(CHAR(6), ' '), 1, 6), ' ',CHAR(48))  
    END +  
    CASE   
     WHEN um.txtSPM IS NULL THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtSPM)) = '-' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtSPM)) = 'NA' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
    ELSE REPLACE(SUBSTRING(( CONVERT(CHAR(12),um.txtSPM) ),1, 12), ' ', CHAR(32))  
    END +  
    CASE   
     WHEN um.txtSPQ IS NULL THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtSPQ)) = '-' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtSPQ)) = 'NA' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
    ELSE REPLACE(SUBSTRING(( CONVERT(CHAR(12),um.txtSPQ) ), 1, 12),' ', CHAR(32))  
    END +  
    CASE   
     WHEN um.txtFIQ IS NULL THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtFIQ )) = '-' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtFIQ )) = 'NA' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
    ELSE REPLACE(SUBSTRING(( CONVERT(CHAR(12),um.txtFIQ ) ),1, 12), ' ', CHAR(32))  
    END +  
    CASE   
     WHEN um.txtDPQ IS NULL THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtDPQ)) = '-' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
     WHEN LTRIM(RTRIM(um.txtDPQ)) = 'NA' THEN SUBSTRING(( CONVERT(CHAR(12), '') ), 1, 12)  
    ELSE REPLACE(SUBSTRING(( CONVERT(CHAR(12),um.txtDPQ) ), 1, 12),' ', CHAR(32))  
    END +   
    CASE   
     WHEN um.txtPLPA IS NULL THEN REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))  
     WHEN ISNUMERIC(um.txtPLPA) = 1 AND um.txtPLPA <> '-' THEN SUBSTRING(REPLACE(STR(ROUND(um.txtPLPA,9), 18, 8), ' ', CHAR(48)), 1, 9)  
       + SUBSTRING(REPLACE(STR(ROUND(um.txtPLPA,8), 17, 8), ' ', CHAR(48)),10,8)  
    ELSE LTRIM(RTRIM(REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))))  
    END +  
    CASE   
     WHEN u24.txtPLPA IS NULL THEN REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))  
     WHEN ISNUMERIC(u24.txtPLPA) = 1 AND u24.txtPLPA <> '-' THEN SUBSTRING(REPLACE(STR(ROUND(u24.txtPLPA,9), 18, 8), ' ', CHAR(48)), 1, 9)  
       + SUBSTRING(REPLACE(STR(ROUND(u24.txtPLPA,8), 17, 8), ' ', CHAR(48)),10,8)  
    ELSE LTRIM(RTRIM(REPLACE(SUBSTRING(CONVERT(CHAR(17), ' '), 1, 17), ' ',CHAR(48))))  
    END AS [Precio Limpio Promedio Aforado 24H]   
   FROM tmp_tblUnifiedPricesReport AS um (NOLOCK)  
   INNER JOIN tmp_tblUnifiedPricesReport AS u24 (NOLOCK)  
   ON  
    um.txtId1 = u24.txtId1   
    AND u24.txtLiquidation = '24H'    
   WHERE   
   um.dteDate = @txtDate  
   AND um.txtLiquidation = 'MD'  
   AND um.txtTv IN ('94','I','IL','J','JI','JSP','2U','3U','4U','6U','92','95','96','B','BI','CC','CP','D1','D1SP','IP','IS','IT','IM','IQ','L',  
   'LD','LP','LS','LT','M','M0','M3','M5','M7','MC','MP','PI','S','S0','S3','S5','SC','SP','TR','XA','2','2P','3P','4P','71','73','75','76','90',  
   '91','91SP','93','93SP','97','98','99','D','P1','R','R1','R3','R3SP')  
   ORDER BY 1,2,3  
  
 SET NOCOUNT OFF    
  
  -- Valida que la informacin este completa   
 IF NOT EXISTS(  
   SELECT TOP 1 *   
   FROM @tblResults  
   )   
    
 BEGIN   
  RAISERROR ('ERROR: Falta Informacion', 16, 1)   
 END   
    
 ELSE   
 -- Reporto los datos   
  SELECT LTRIM(txtData)  
  FROM @tblResults   
    
END  
-------------------------------------------------------------------------  
--   Autor:       Mike Ramirez  
--   Creacion:   10:52 2013-09-10  
--   Descripcion:    Modulo 18: Se migra el producto TCHSBC[YYYYMMDD].xls  
-------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;18  
  @txtDate AS DATETIME   
  
AS   
BEGIN  
  
   SET NOCOUNT ON  
  
 -- Tabla Temporal para cargar las Directivas  
 DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtCode CHAR(50),  
   txtCode2  CHAR(50),  
   SubType  CHAR(3),  
   Node INT,  
   intCol INT,  
   intRow INT,  
   dblValue VARCHAR(4800)  
  PRIMARY KEY (intCol,intRow)  
  )   
   
 -- <SECCION 1> TC  USD0,USD1,USD2  
 INSERT @tblDirectives  
  SELECT 1, 'IRC','USD0','','','',2,3,NULL UNION  
  SELECT 1, 'IRC','USD1','','','',2,4,NULL UNION  
  SELECT 1, 'IRC','USD2','','','',2,5,NULL  
   
 -- <SECCION 2> TC  Otras monedas    
 INSERT @tblDirectives  
  SELECT 2, 'IRC','EURU','','','',3,10,NULL UNION  
  SELECT 2, 'IRC','GBPU','','','',3,11,NULL UNION  
  SELECT 2, 'IRC','JPYX','','','',3,12,NULL UNION  
  SELECT 2, 'IRC','CADX','','','',3,13,NULL UNION  
  SELECT 2, 'IRC','DKKX','','','',3,14,NULL UNION  
  SELECT 2, 'IRC','CHFX','','','',3,15,NULL UNION  
  SELECT 2, 'IRC','SEKX','','','',3,16,NULL UNION  
  SELECT 2, 'IRC','BRLX','','','',3,17,NULL UNION  
  SELECT 2, 'IRC','NOKX','','','',3,18,NULL UNION  
  SELECT 2, 'IRC','PLATA','','','',3,19,NULL UNION  
  SELECT 2, 'IRC','ORO','','','',3,20,NULL UNION  
  SELECT 2, 'IRC','UFXU','','','',3,21,NULL UNION  
  SELECT 2, 'IRC','CLP','','','',3,22,NULL UNION  
  SELECT 2, 'IRC','CLPU','','','',3,23,NULL UNION  
  SELECT 2, 'IRC','AUDX','','','',3,24,NULL UNION  
  SELECT 2, 'IRC','CNYU','','','',3,25,NULL UNION    
  SELECT 2, 'IRC','ARPX','','','',3,26,NULL UNION  
  SELECT 2, 'IRC','NZDX','','','',3,27,NULL UNION  
  SELECT 2, 'IRCD','CNHX','','','',3,28,NULL  
  
 -- <SECCION 3> TC  SOBRE DOLAR    
 INSERT @tblDirectives  
  SELECT 3, 'IRC','EURU','','','',4,10,NULL UNION  
  SELECT 3, 'IRC','GBPU','','','',4,11,NULL UNION  
  SELECT 3, 'IRCD','JPYX','','','',4,12,NULL UNION  
  SELECT 3, 'IRCD','CADX','','','',4,13,NULL UNION  
  SELECT 3, 'IRCD','DKKX','','','',4,14,NULL UNION  
  SELECT 3, 'IRCD','CHFX','','','',4,15,NULL UNION  
  SELECT 3, 'IRCD','SEKX','','','',4,16,NULL UNION  
  SELECT 3, 'IRCD','BRLX','','','',4,17,NULL UNION  
  SELECT 3, 'IRCD','NOKX','','','',4,18,NULL UNION  
  SELECT 3, 'IRC','PLATA','','','',4,19,NULL UNION  
  SELECT 3, 'IRC','ORO','','','',4,20,NULL UNION  
  SELECT 3, 'IRC','UFXU','','','',4,21,NULL UNION  
  SELECT 3, 'IRCD','CLP','','','',4,22,NULL UNION  
  SELECT 3, 'IRCD','CLPU','','','',4,23,NULL UNION  
  SELECT 3, 'IRC','AUD','','','',4,24,NULL UNION  
  SELECT 3, 'IRCD','CNYU','','','',4,25,NULL UNION    
  SELECT 3, 'IRCD','ARPX','','','',4,26,NULL UNION  
  SELECT 3, 'IRCD','NZDX','','','',4,27,NULL UNION  
  SELECT 3, 'IRC','CNHX','','','',4,28,NULL  
  
 -- <SECCION 4> Fecha    
 INSERT @tblDirectives  
  SELECT 4, '','EURU','','','',2,7,SUBSTRING(REPLACE(CONVERT(CHAR(11),@txtDate,106),' ','-'),1,7) + SUBSTRING(REPLACE(CONVERT(CHAR(11),@txtDate,106),' ','-'),10,2)   
     
 -- Obtengo los valores de los IRC  
 UPDATE u  
  SET dblValue = STR(ROUND((SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode)),9),16,9)  
 FROM  
  @tblDirectives AS u  
 WHERE txtSource = 'IRC'  
  
 -- Obtengo los valores de los IRC Dolar  
 UPDATE u  
  SET dblValue = STR(ROUND(1/(SELECT MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCode)),9),16,9)  
 FROM  
  @tblDirectives AS u  
 WHERE txtSource = 'IRCD'  
    
 -- Valida la información   
 IF ((SELECT COUNT(*) FROM @tblDirectives WHERE dblValue IS NULL AND txtSource = 'IRC') > 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  IF ((SELECT COUNT(*) FROM @tblDirectives WHERE dblValue LIKE '%-999%') > 0)  
  
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
    LTRIM(RTRIM(STR(intSection))) AS txtSection,  
    LTRIM(RTRIM(txtSource)),  
    LTRIM(RTRIM(txtCode)),  
    intCol,  
    intRow,  
    LTRIM(RTRIM(dblValue))  
    FROM @tblDirectives  
    ORDER BY   
    intSection,  
    intCol,  
    intRow  
  
   END  
  
 SET NOCOUNT OFF  
  
END  
  
  
  
  
-------------------------------------------------------------------------  
--   Autor:       Mike Ramirez  
--   Creacion:   04:19 2013-09-12  
--   Descripcion:    Modulo 19: Se migra el producto TCHSBC[YYYYMMDD].CSV  
-------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_BITAL;19  
  @txtDate AS DATETIME   
  
AS   
BEGIN  
  
   SET NOCOUNT ON  
             
  -- genera tabla temporal de resultados      
  DECLARE @tblResult TABLE (      
   [intSection][INTEGER],      
   [txtData][VARCHAR](8000)      
  )      
         
 DECLARE @dblUSD0 AS FLOAT  
 DECLARE @dblUSD1 AS FLOAT  
 DECLARE @dblUSD2 AS FLOAT  
 DECLARE @dblEURU AS FLOAT  
 DECLARE @dblGBPU AS FLOAT  
 DECLARE @dblJPYX AS FLOAT  
 DECLARE @dblCADX AS FLOAT  
 DECLARE @dblDKKX AS FLOAT   
 DECLARE @dblCHFX AS FLOAT  
 DECLARE @dblSEKX AS FLOAT  
 DECLARE @dblBRLX AS FLOAT  
 DECLARE @dblNOKX AS FLOAT  
 DECLARE @dblPLATA AS FLOAT  
 DECLARE @dblORO AS FLOAT  
 DECLARE @dblUFXU AS FLOAT  
 DECLARE @dblCLP AS FLOAT  
 DECLARE @dblCLPU AS FLOAT  
 DECLARE @dblAUDX AS FLOAT  
 DECLARE @dblCNYU AS FLOAT  
 DECLARE @dblARPX AS FLOAT  
 DECLARE @dblNZDX AS FLOAT  
 DECLARE @dblCNHX AS FLOAT      
     
   -- Tasas de Referencia      
  SET @dblUSD0 = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'USD0')  
  SET @dblUSD1 = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'USD1')  
  SET @dblUSD2 = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'USD2')  
  SET @dblEURU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'EURU')  
  SET @dblGBPU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'GBPU')  
  SET @dblJPYX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'JPYX')  
  SET @dblCADX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'CADX')  
  SET @dblDKKX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'DKKX')   
  SET @dblCHFX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'CHFX')  
  SET @dblSEKX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'SEKX')  
  SET @dblBRLX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'BRLX')  
  SET @dblNOKX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'NOKX')  
  SET @dblPLATA = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'PLATA')  
  SET @dblORO = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'ORO')  
  SET @dblUFXU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'UFXU')  
  SET @dblCLP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'CLP')  
  SET @dblCLPU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'CLPU')  
  SET @dblAUDX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'AUDX')  
  SET @dblCNYU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'CNYU')  
  SET @dblARPX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'ARPX')  
  SET @dblNZDX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'NZDX')  
  SET @dblCNHX = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = CONVERT(CHAR(8),@txtDate,112) AND txtIrc = 'CNHX')  
      
     -- Encabezados y primer plano  
  INSERT @tblResult      
   SELECT 001,'TIPO DE CAMBIO' UNION      
   SELECT 002,'Mismo Dia,' + LTRIM(STR(ROUND(@dblUSD0,6),13,6)) UNION  
   SELECT 003,'24 horas,' + LTRIM(STR(ROUND(@dblUSD1,6),13,6)) UNION       
   SELECT 004,'Spot,' + LTRIM(STR(ROUND(@dblUSD2,6),13,6)) UNION       
   SELECT 005,'Fecha,Clave,Tipo cambio orig,Tipo de Cambio Sobre Dolar'  
  
  -- Obtengo los valores de los FRPiP del segundo plano      
  INSERT @tblResult      
   SELECT 006,CONVERT(CHAR(10),@txtDate,103) + ',' + 'EUR' + ',' + LTRIM(STR(ROUND(@dblEURU,9),16,9)) + ',' + LTRIM(STR(ROUND(@dblEURU,9),16,9)) UNION      
   SELECT 007,CONVERT(CHAR(10),@txtDate,103) + ',' + 'GBP' + ',' + LTRIM(STR(ROUND(@dblGBPU,9),16,9)) + ',' + LTRIM(STR(ROUND(@dblGBPU,9),16,9)) UNION  
   SELECT 008,CONVERT(CHAR(10),@txtDate,103) + ',' + 'JPY' + ',' + LTRIM(STR(ROUND(@dblJPYX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblJPYX,9),16,9)) UNION  
   SELECT 009,CONVERT(CHAR(10),@txtDate,103) + ',' + 'CAD' + ',' + LTRIM(STR(ROUND(@dblCADX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblCADX,9),16,9)) UNION  
   SELECT 010,CONVERT(CHAR(10),@txtDate,103) + ',' + 'DKK' + ',' + LTRIM(STR(ROUND(@dblDKKX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblDKKX,9),16,9)) UNION  
   SELECT 011,CONVERT(CHAR(10),@txtDate,103) + ',' + 'CHF' + ',' + LTRIM(STR(ROUND(@dblCHFX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblCHFX,9),16,9)) UNION  
   SELECT 012,CONVERT(CHAR(10),@txtDate,103) + ',' + 'SEK' + ',' + LTRIM(STR(ROUND(@dblSEKX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblSEKX,9),16,9)) UNION  
   SELECT 013,CONVERT(CHAR(10),@txtDate,103) + ',' + 'BRL' + ',' + LTRIM(STR(ROUND(@dblBRLX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblBRLX,9),16,9)) UNION  
   SELECT 014,CONVERT(CHAR(10),@txtDate,103) + ',' + 'NOK' + ',' + LTRIM(STR(ROUND(@dblNOKX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblNOKX,9),16,9)) UNION  
   SELECT 015,CONVERT(CHAR(10),@txtDate,103) + ',' + 'PLATA' + ',' + LTRIM(STR(ROUND(@dblPLATA,9),16,9)) + ',' + LTRIM(STR(ROUND(@dblPLATA,9),16,9)) UNION  
   SELECT 016,CONVERT(CHAR(10),@txtDate,103) + ',' + 'ORO' + ',' + LTRIM(STR(ROUND(@dblORO,9),16,9)) + ',' + LTRIM(STR(ROUND(@dblORO,9),16,9)) UNION  
   SELECT 017,CONVERT(CHAR(10),@txtDate,103) + ',' + 'UFX' + ',' + LTRIM(STR(ROUND(@dblUFXU,9),16,9)) + ',' + LTRIM(STR(ROUND(@dblUFXU,9),16,9)) UNION  
   SELECT 018,CONVERT(CHAR(10),@txtDate,103) + ',' + 'CLP' + ',' + LTRIM(STR(ROUND(@dblCLP,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblCLP,9),16,9)) UNION  
   SELECT 019,CONVERT(CHAR(10),@txtDate,103) + ',' + 'CLPU' + ',' + LTRIM(STR(ROUND(@dblCLPU,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblCLPU,9),16,9)) UNION  
   SELECT 020,CONVERT(CHAR(10),@txtDate,103) + ',' + 'AUDX' + ',' + LTRIM(STR(ROUND(@dblAUDX,9),16,9)) + ',' + LTRIM(STR(ROUND(@dblAUDX,9),16,9)) UNION  
   SELECT 021,CONVERT(CHAR(10),@txtDate,103) + ',' + 'CNY' + ',' + LTRIM(STR(ROUND(@dblCNYU,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblCNYU,9),16,9)) UNION  
   SELECT 022,CONVERT(CHAR(10),@txtDate,103) + ',' + 'ARP' + ',' + LTRIM(STR(ROUND(@dblARPX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblARPX,9),16,9)) UNION  
   SELECT 023,CONVERT(CHAR(10),@txtDate,103) + ',' + 'NZD' + ',' + LTRIM(STR(ROUND(@dblNZDX,9),16,9)) + ',' + LTRIM(STR(ROUND(1/@dblNZDX,9),16,9)) UNION  
   SELECT 024,CONVERT(CHAR(10),@txtDate,103) + ',' + 'CNH' + ',' + LTRIM(STR(ROUND(1/@dblCNHX,9),16,9)) + ',' + LTRIM(STR(ROUND(@dblCNHX,9),16,9))  
      
 -- Valida que la información este completa  
 IF ((SELECT COUNT(*) FROM tblIrc WHERE txtirc IN ('USD0','USD1','USD2','EURU','GBPU','JPYX','CADX','DKKX','CHFX','SEKX','BRLX','NOKX','PLATA','ORO','UFXU','CLP','CLPU','AUDX','CNYU','ARPX','NZDX','CNHX') and dtedate = @txtDate AND dblvalue IS NOT NULL) <
11)    
   BEGIN      
    RAISERROR ('ERROR: Falta Informacion', 16, 1)      
   END       
  ELSE   
  
   -- Reporto los datos;  
   SELECT RTRIM(txtData)      
   FROM @tblResult      
   ORDER BY intSection      
      
 SET NOCOUNT OFF   
  
END  
  
/*-----------------------------------------------------------------------    
   Autor:       Mike Ramirez    
   Creacion:   10:13 2013-10-14    
   Descripcion:    Modulo 20: Genera el producto Indicadores para HSBC    
 -----------------------------------------------------------------------    
 Modificación: Omar Aceves  
 Fecha:   2014-05-14 11:22:24.890  
 Objetivo:  Se canmbia forma de  reportar en formato  CSV delimitado por comas   
*/-----------------------------------------------------------------------    
  
CREATE  PROCEDURE dbo.sp_productos_BITAL;20    
--DECLARE   
@txtDate AS DATETIME   
    
AS       
BEGIN      
    
 SET NOCOUNT ON    
    
 -- creo tabla temporal de los principales Nodos de Curvas y Tipos de Cambio (FRPiP)    
 DECLARE @tmpLayoutxlFRPIP TABLE (    
  Row INT,    
  Label  VARCHAR(20),    
  Type  CHAR(3),    
  SubType  CHAR(7),    
  Node INT,    
  LabelNode VARCHAR(5),    
  dblValue FLOAT    
 )    
    
 DECLARE @tmp_tblDatesKey TABLE (    
  [txtIRC][CHAR](7),    
  [dteDate][DATETIME]    
  PRIMARY KEY (txtIRC)    
 )    
    
 DECLARE @tmp_tblUniversoIRC TABLE (    
  [txtIRC][CHAR](7),    
  [dteDate][DATETIME],    
  [dblValue][FLOAT]    
  PRIMARY KEY (txtIRC,dteDate)     
 )     
    
     DECLARE @tmpResultTables TABLE  
   (  
   Label2 VARCHAR(100),  
   dblValue2 VARCHAR(100)  
   )  
     
 -- Obtenemos los máximos    
 INSERT @tmp_tblDatesKey (txtIRC,dteDate)    
  SELECT    
   txtIRC,    
   MAX(dteDate)    
  FROM tblIrc    
  WHERE    
   txtIRC IN ('T028',    
      'T091',    
      'T182',    
      'SC028',    
      'SC091',    
      'SC182',    
      'SC364',    
      'IL030',    
      'IL090',    
      'IL180',    
      'IL360',    
      'IM3YR',    
      'IM5YR',    
      'IM10YR')    
  GROUP BY txtIRC    
    
 -- Obtenemos los máximos valores IRC    
 INSERT @tmp_tblUniversoIRC (txtIRC,dteDate,dblValue)    
  SELECT    
   k.txtIRC,    
   k.dteDate,    
   i.dblValue    
  FROM @tmp_tblDatesKey AS k    
  INNER JOIN tblIrc AS i    
  ON    
   i.txtIRC = k.txtIRC    
   AND i.dteDate = k.dteDate    
    
 -- Setting Info (FRPiP)    
 INSERT @tmpLayoutxlFRPIP    
 --   'Nombre,Valor',  
   
   SELECT 00,'Nombre,Valor','null','null',0,'0',NULL UNION    
      SELECT 01,'TIIE 28 dias','IRC','T028',0,'0',NULL UNION     
      SELECT 02,'TIIE 91 dias','IRC','T091',0,'0',NULL UNION     
      SELECT 03,'Nodo PiP TIIE 182','IRC','T182',0,'0',NULL UNION     
      SELECT 04,'Cetes Subasta 028','IRC','SC028',0,'0',NULL UNION     
      SELECT 05,'Cetes Subasta 091','IRC','SC091',0,'0',NULL UNION     
      SELECT 06,'Cetes Subasta 182','IRC','SC182',0,'0',NULL UNION     
      SELECT 07,'Cetes Subasta 364','IRC','SC364',0,'0',NULL UNION    
   SELECT 08,'Libor 030 dias','IRC','IL030',0,'0',NULL UNION    
      SELECT 09,'Libor 090 dias','IRC','IL090',0,'0',NULL UNION     
      SELECT 10,'Libor 180 dias','IRC','IL180',0,'0',NULL UNION     
      SELECT 11,'Libor 360 dias','IRC','IL360',0,'0',NULL UNION     
      SELECT 12,'Bonos M a 3 años','IRC','IM3YR',0,'0',NULL UNION     
      SELECT 13,'Bonos M a 5 años','IRC','IM5YR',0,'0',NULL UNION     
      SELECT 14,'Bonos M a 10 años','IRC','IM10YR',0,'0',NULL UNION     
      SELECT 15,'Cetes a 28 das c/impto','CET','CTI',28,'28',NULL UNION     
      SELECT 16,'Cetes a 91 das c/impto','CET','CTI',91,'91',NULL UNION     
      SELECT 17,'Cetes a 182 das c/impto','CET','CTI',182,'182',NULL UNION     
      SELECT 18,'Cetes a 364 das c/impto','CET','CTI',364,'364',NULL    
          
 -- Obtengo los valores de los FRPiP    
 UPDATE @tmpLayoutxlFRPIP    
  SET dblValue = (SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0'))    
 FROM @tmpLayoutxlFRPIP AS FR    
 WHERE     
  Row > 0 AND Type <> 'IRC' AND Type <> ''    
    
 -- Obtengo los valores de los FRPiP    
 UPDATE @tmpLayoutxlFRPIP    
  SET dblValue = u.dblValue    
 FROM @tmpLayoutxlFRPIP AS FR    
 INNER JOIN @tmp_tblUniversoIRC AS u    
 ON    
  FR.SubType = u.txtIRC    
 WHERE    
  Type = 'IRC'    
    
 -- Valida la información     
 IF ((SELECT count(*) FROM @tmpLayoutxlFRPIP) = 0)    
    
 BEGIN    
  RAISERROR ('ERROR: Falta Informacion', 16, 1)    
 END    
    
 ELSE    
  IF ((    
   SELECT COUNT(*) FROM @tmpLayoutxlFRPIP     
   WHERE Row IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)   -- FRPIP para la validacion    
    AND (dblValue = -999 OR dblValue IS NULL)    
   ) > 0)    
    
  BEGIN    
   RAISERROR ('ERROR: Falta Informacion', 16, 1)    
  END    
    
  ELSE    
    
     
   INSERT INTO @tmpResultTables  
     SELECT     
   Label + ',' AS label2 ,  
     CASE WHEN dblValue IS NULL OR dblValue = -999    
       THEN ''    
       ELSE    
       LTRIM(STR(ROUND(dblValue,8),12,8))    
     END AS [dblValue2]     
   FROM @tmpLayoutxlFRPIP     
     
     
   UPDATE @tmpResultTables  
   SET Label2 = 'Nombre,Valor' WHERE Label2 = 'Nombre,Valor,'  
     
   SELECT   
   Label2+dblValue2  
   AS [dblValue2]    
   FROM  @tmpResultTables  
     
 SET NOCOUNT OFF    
    
END    
  
  
-------------------------------------------------------  
--   Autor:    Mike Ramirez  
--   Fecha Creacion: 10:10 2013-09-13  
--   Descripcion:       Modulo 21:   
-------------------------------------------------------  
CREATE  PROCEDURE dbo.sp_productos_BITAL;21     
  @txtDate AS DATETIME      
      
AS         
BEGIN       
      
 SET NOCOUNT ON  
  
 --DECLARE @txtDate AS DATETIME  
 --SET @txtDate = '20140226'  
  
 DECLARE @dblUSD0 AS FLOAT  
 DECLARE @dblUSD1 AS FLOAT  
 DECLARE @dblUSD2 AS FLOAT  
 DECLARE @dblUFXU AS FLOAT  
  
      
 -- Tabla para obtener el universo de IRC´s  
 DECLARE @tmp_tblMaxDate TABLE (  
  txtIRC CHAR(7),  
  dteDate DATETIME  
 PRIMARY KEY (txtIRC))  
  
 -- Tabla para obtener el universo de IRC´s  
 DECLARE @tmp_tblUniverseIRC TABLE (  
  txtIRC CHAR(7),  
  dteDate DATETIME,  
  dblValue FLOAT  
 PRIMARY KEY (txtIRC))  
  
  -- genera tabla temporal de resultados      
  DECLARE @tblResult TABLE (      
   [intSection][INTEGER],      
   [txtData][VARCHAR](8000)      
  )      
      
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)      
 DECLARE @tmp_tblDirectivesIRC TABLE (      
   [intSection][INTEGER],  
   [txtIRC]  CHAR(30),  
   [txtIRC2]  CHAR(30),      
   [Label]  CHAR(30),        
   [dblValueOr] VARCHAR(50),  
   [dblValue] VARCHAR(50)       
  PRIMARY KEY(intSection)      
  )      
     
 SET @dblUSD0 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD0')  
 SET @dblUSD1 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD1')  
 SET @dblUSD2 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD2')  
 SET @dblUFXU = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'UFXU')  
  
  
 -- Obtenemos los maximos del Universo a procesar   
 INSERT @tmp_tblMaxDate   
  SELECT  
   txtIRC,  
   MAX(dteDate)  
  FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
  WHERE  
   txtIRC IN ('EUR','EURX','GBP','GBPX','JPY','JPYX','CAD','CADX','DKK','DKKX','CHF',  
   'CHFX','SEK','SEKX','BRL','BRLX','NOK','NOKX','PLATA','ORO','UFXU','CLP','CLPX','AUD',  
   'AUDX','CNY','CNYX','ARP','ARPX','NZD','NZDX','CNH','CNHX')  
  GROUP BY txtIRC  
  
 -- Obtenemos el universo de los IRC  
 INSERT @tmp_tblUniverseIRC  
  SELECT   
   m.txtIRC,  
   m.dteDate,  
   i.dblValue  
  FROM @tmp_tblMaxDate AS m  
   INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
   ON m.txtIRC = i.txtIRC  
   AND m.dteDate = i.dteDate   
  
  -- Obtengo los encabezados  
  INSERT @tblResult      
  SELECT 001,'TIPO DE CAMBIO' UNION  
  SELECT 002,'Mismo Dia' + ',' + LTRIM(STR(ROUND(@dblUSD0,6),16,6)) UNION      
  SELECT 003,'24 horas' + ',' + LTRIM(STR(ROUND(@dblUSD1,6),16,6)) UNION    
  SELECT 004,'Spot' + ',' + LTRIM(STR(ROUND(@dblUSD2,6),16,6)) UNION  
  SELECT 005,'Fecha,Clave,Tipo de Cambio SOBRE MXN,Tipo de Cambio Sobre USD'  
  
  -- Obetenemos los IRC's  
  INSERT @tmp_tblDirectivesIRC (intSection,txtIRC,txtIRC2,Label,dblValueOr,dblValue)     
  SELECT 006,'EUR','EURX','EUR',NULL,NULL UNION      
  SELECT 007,'GBP','GBPX','GBP',NULL,NULL UNION      
  SELECT 008,'JPY','JPYX','JPY',NULL,NULL UNION      
  SELECT 009,'CAD','CADX','CAD',NULL,NULL UNION      
  SELECT 010,'DKK','DKKX','DKK',NULL,NULL UNION      
  SELECT 011,'CHF','CHFX','CHF',NULL,NULL UNION      
  SELECT 012,'SEK','SEKX','SEK',NULL,NULL UNION      
  SELECT 013,'BRL','BRLX','BRL',NULL,NULL UNION      
  SELECT 014,'NOK','NOKX','NOK',NULL,NULL UNION      
  SELECT 015,'PLATA','PLATA','PLATA',NULL,NULL UNION      
  SELECT 016,'ORO','ORO','ORO',NULL,NULL UNION  
  SELECT 017,'UFXU','UFXU','UFX',NULL,NULL UNION  
  SELECT 018,'CLP','CLPX','CLP',NULL,NULL UNION  
  SELECT 020,'AUD','AUDX','AUD',NULL,NULL UNION  
  SELECT 021,'CNY','CNYX','CNY',NULL,NULL UNION  
  SELECT 022,'ARP','ARPX','ARP',NULL,NULL UNION  
  SELECT 023,'NZD','NZDX','NZD',NULL,NULL UNION  
  SELECT 024,'CNH','CNHX','CNH',NULL,NULL  
  
  -- Obtengo los valores de los IRC's  
  UPDATE d  
   SET d.dblValueOr = STR(ROUND(u.dblValue,9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
  WHERE  
   d.txtIRC <> '1'  
  
  -- Obtengo los valores de los IRC's      
  UPDATE d  
   SET d.dblValue = STR(ROUND(u.dblValue,9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC2 = u.txtIRC  
--   AND d.txtIRC IN ('EURU','GBPU','PLATA','ORO','UFXU','AUDX','CNHX')  
  WHERE  
   d.txtIRC <> '1'  
  
  -- Obtengo los valores de los IRC's      
  UPDATE d  
   SET d.dblValueOr = STR(ROUND((u.dblValue * @dblUFXU),9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
   AND d.txtIRC = 'PLATA'  
  
  -- Obtengo los valores de los IRC's      
  UPDATE d  
   SET d.dblValueOr = STR(ROUND((u.dblValue * @dblUFXU),9),16,9)  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
   AND d.txtIRC = 'ORO'  
  
  -- Obtengo los valores de los IRC's      
  UPDATE d  
   SET d.dblValueOr = '1'  
  FROM @tmp_tblDirectivesIRC AS d  
   INNER JOIN @tmp_tblUniverseIRC AS u  
   ON d.txtIRC = u.txtIRC  
   AND d.txtIRC = 'UFXU'  
  
  INSERT @tblResult  
   SELECT         
    intSection,CONVERT(CHAR(10),@txtDate,103) + ',' +  RTRIM(Label) + ',' + LTRIM(dblValueOr) + ',' + LTRIM(dblValue)   
   FROM @tmp_tblDirectivesIRC  
  
  -- Valida que la información este completa        
  IF ((SELECT COUNT(*) FROM @tblResult WHERE txtData IS NULL) > 0 )  
       
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
  
CREATE PROCEDURE dbo.sp_productos_BITAL;22     
  @txtDate AS DATETIME        
        
AS           
/*    
Autor:Omar aceves Gutiererz    
Fecha: 20140226    
Notas: modulo ;22   se agrega un proceso que genera archivo TCHSBC[DATE|YYYYMMDD].XLS formato y columnas nuevas     
*/    
    
BEGIN    
           
 SET NOCOUNT ON    
    
    
--DECLARE     
--@txtDate AS DATETIME     
--SET @txtDate = '20140520'    
    
 DECLARE @dblUSD0 AS FLOAT    
 DECLARE @dblUSD1 AS FLOAT    
 DECLARE @dblUSD2 AS FLOAT    
 DECLARE @dblUFXU AS FLOAT    
        
 -- Tabla para obtener el universo de IRC´s    
 DECLARE @tmp_tblMaxDate TABLE (    
  txtIRC CHAR(7),    
  dteDate DATETIME    
 PRIMARY KEY (txtIRC))    
    
 -- Tabla para obtener el universo de IRC´s    
 DECLARE @tmp_tblUniverseIRC TABLE (    
  txtIRC CHAR(7),    
  dteDate DATETIME,    
  dblValue FLOAT    
 PRIMARY KEY (txtIRC))    
    
  -- genera tabla temporal de resultados        
  DECLARE @tblResult TABLE (        
    [intSection][INTEGER],    
    [dteDate][VARCHAR](50),    
    [txtLabel][VARCHAR](50),       
    [dblValIRC1][VARCHAR](50),       
    [dblValIRC2][VARCHAR](50)    
   --[txtData][VARCHAR](8000)        
  )    
    
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)        
 DECLARE @tmp_tblDirectivesIRC TABLE (        
    [intSection][INTEGER],    
    [txtIRC]  CHAR(30),    
    [txtIRC2]  CHAR(30),        
    [Label]  CHAR(30),          
    [dblValueOr] VARCHAR(50),    
    [dblValue] VARCHAR(50)         
  PRIMARY KEY(intSection)        
  )        
       
 SET @dblUSD0 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD0')    
 SET @dblUSD1 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD1')    
 SET @dblUSD2 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD2')    
 SET @dblUFXU = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'UFXU')    
    
 -- Obtenemos los maximos del Universo a procesar     
 INSERT @tmp_tblMaxDate     
  SELECT    
   txtIRC,    
   MAX(dteDate)    
  FROM MxFixIncome.dbo.tblIRC (NOLOCK)    
  WHERE    
   txtIRC IN ('EUR','EURX','GBP','GBPX','JPY','JPYX','CAD','CADX','DKK','DKKX','CHF',    
   'CHFX','SEK','SEKX','BRL','BRLX','NOK','NOKX','PLATA','ORO','UFXU','CLP','CLPX','AUD',    
   'AUDX','CNY','CNYX','ARP','ARPX','NZD','NZDX','CNH','CNHX','CLF','TFB')    
  GROUP BY txtIRC    
    
 -- Obtenemos el universo de los IRC    
 INSERT @tmp_tblUniverseIRC    
  SELECT     
   m.txtIRC,    
   m.dteDate,    
   i.dblValue    
  FROM @tmp_tblMaxDate AS m    
   INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)    
   ON m.txtIRC = i.txtIRC    
   AND m.dteDate = i.dteDate     
    
  -- Obtengo los encabezados    
  INSERT @tblResult        
  SELECT 001,'TIPO DE CAMBIO','','','' UNION    
  SELECT 002,'','','','' UNION --espacio en blanco    
  SELECT 003,'TC de Valuación (FIX)',LTRIM(STR(ROUND(@dblUFXU,6),16,6)),'','' UNION      
  SELECT 004,'Mismo Dia',LTRIM(STR(ROUND(@dblUSD0,6),16,6)),'','' UNION        
  SELECT 005,'24 horas',LTRIM(STR(ROUND(@dblUSD1,6),16,6)),'','' UNION      
  SELECT 006,'Spot',LTRIM(STR(ROUND(@dblUSD2,6),16,6)),'','' UNION    
  SELECT 007,'','','','' UNION --espacio en blanco    
  SELECT 008,'FECHA', CONVERT(CHAR(10),@txtDate,3),'',''UNION    
  SELECT 009,'','','','' UNION --espacio en blanco    
  SELECT 010,'Otras Monedas','CLAVE','Tipo de Cambio SOBRE MXN','Tipo de Cambio Sobre USD'     
    
  -- Obetenemos los IRC's    
  INSERT @tmp_tblDirectivesIRC (intSection,txtIRC,txtIRC2,Label,dblValueOr,dblValue)       
  SELECT 011,'EUR','EURX','EUR',NULL,NULL UNION        
  SELECT 012,'GBP','GBPX','GBP',NULL,NULL UNION        
  SELECT 013,'JPY','JPYX','JPY',NULL,NULL UNION        
  SELECT 014,'CAD','CADX','CAD',NULL,NULL UNION        
  SELECT 015,'DKK','DKKX','DKK',NULL,NULL UNION        
  SELECT 016,'CHF','CHFX','CHF',NULL,NULL UNION        
  SELECT 017,'SEK','SEKX','SEK',NULL,NULL UNION        
  SELECT 018,'BRL','BRLX','BRL',NULL,NULL UNION        
  SELECT 019,'NOK','NOKX','NOK',NULL,NULL UNION        
  SELECT 020,'PLATA','PLATA','PLATA',NULL,NULL UNION        
  SELECT 021,'ORO','ORO','ORO',NULL,NULL UNION    
  SELECT 022,'UFXU','UFXU','UFX',NULL,NULL UNION    
  SELECT 023,'CLP','CLPX','CLP',NULL,NULL UNION    
  SELECT 024,'CLF','CLF','CLF',NULL,NULL UNION    
  SELECT 025,'CNY','CNYX','CNY',NULL,NULL UNION    
  SELECT 026,'AUD','AUDX','AUDX',NULL,NULL UNION    
  SELECT 027,'ARP','ARPX','ARP',NULL,NULL UNION    
  SELECT 028,'NZD','NZDX','NZD',NULL,NULL UNION    
  SELECT 029,'CNH','CNHX','CNH',NULL,NULL      
      
      
   -- SELECT * FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'ONFFE0D'  
      
  DECLARE  @maxdate DATETIME     
     SET @maxdate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB')    
       
      DECLARE  @maxdateONFFE0D DATETIME     
  SET @maxdateONFFE0D = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIrc WHERE txtIRC = 'ONFFE0D')    
       
       
   
  INSERT @tblResult        
  SELECT 030,'Tasa ponderada de fondeo bancario','',(SELECT CAST(dblValue AS VARCHAR(50)) + '%' FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB' AND dteDate =@maxdate),''  UNION     
  SELECT 031,'','Overnight',(SELECT CAST(dblValue AS VARCHAR(50)) + '%' FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'ONFFE0D' AND dteDate =@maxdateONFFE0D),'' UNION     
  SELECT 032,'','Ventanilla MD','',''     
      
      
--SELECT * FROM @tmp_tblUniverseIRC    
  -- Obtengo los valores de los IRC's    
  UPDATE d    
   SET d.dblValueOr = STR(ROUND(u.dblValue,9),16,9)    
  FROM @tmp_tblDirectivesIRC AS d    
   INNER JOIN @tmp_tblUniverseIRC AS u    
   ON d.txtIRC = u.txtIRC    
  WHERE    
   d.txtIRC <> '1'    
    
  -- Obtengo los valores de los IRC's        
  UPDATE d    
   SET d.dblValue = STR(ROUND(u.dblValue,9),16,9)    
  FROM @tmp_tblDirectivesIRC AS d    
   INNER JOIN @tmp_tblUniverseIRC AS u    
   ON d.txtIRC2 = u.txtIRC    
--   AND d.txtIRC IN ('EURU','GBPU','PLATA','ORO','UFXU','AUDX','CNHX')    
  WHERE    
   d.txtIRC <> '1'    
    
  -- Obtengo los valores de los IRC's        
  UPDATE d    
   SET d.dblValueOr = STR(ROUND((u.dblValue * @dblUFXU),9),16,9)    
  FROM @tmp_tblDirectivesIRC AS d    
   INNER JOIN @tmp_tblUniverseIRC AS u    
   ON d.txtIRC = u.txtIRC    
   AND d.txtIRC = 'PLATA'    
    
  -- Obtengo los valores de los IRC's        
  UPDATE d    
   SET d.dblValueOr = STR(ROUND((u.dblValue * @dblUFXU),9),16,9)    
  FROM @tmp_tblDirectivesIRC AS d    
   INNER JOIN @tmp_tblUniverseIRC AS u    
   ON d.txtIRC = u.txtIRC    
   AND d.txtIRC = 'ORO'    
    
  -- Obtengo los valores de los IRC's        
  UPDATE d    
   SET d.dblValueOr = '1'    
  FROM @tmp_tblDirectivesIRC AS d    
   INNER JOIN @tmp_tblUniverseIRC AS u    
   ON d.txtIRC = u.txtIRC    
   AND d.txtIRC = 'UFXU'    
       
 -- Obtengo los valores de los IRC's     CLF/ UFXU    
    
   UPDATE d    
   SET d.dblValue = STR(ROUND((u.dblValue / @dblUFXU),9),16,9)    
  FROM @tmp_tblDirectivesIRC AS d    
   INNER JOIN @tmp_tblUniverseIRC AS u    
   ON d.txtIRC = u.txtIRC    
   AND d.txtIRC = 'CLF'    
       
       
   --SELECT * FROM @tmp_tblDirectivesIRC    
       
    -- Obtengo los valores de los IRC's   TFB    
        
     DECLARE  @maxgetdate DATETIME     
     SET @maxgetdate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB')    
   UPDATE d    
   SET d.dblValueOr = (SELECT CAST(dblValue AS VARCHAR(50)) + '%' FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB' AND dteDate =@maxgetdate)    
  FROM @tmp_tblDirectivesIRC AS d    
   INNER JOIN @tmp_tblUniverseIRC AS u    
   ON d.txtIRC = u.txtIRC    
   AND d.txtIRC = 'TFB'    
       
    
   /*se agrega columna de descripcion en A1 */    
    DECLARE @tmpValuesDesc TABLE     
    (    
    txtIrc VARCHAR(50),    
    txtDesc VARCHAR(50)    
    )     
        
    INSERT INTO @tmpValuesDesc    
    VALUES ('EUR','Euro/USD'),    
    ('GBP','Libra/USD'),    
    ('JPY','Yen/USD'),    
    ('CAD','D. Canadian/USD'),    
    ('DKK','Corona Danesa/USD'),    
    ('CHF','Franco Suizo/USD '),    
    ('SEK','Corona Sueca/USD'),    
    ('BRL','Real Brasileño/USD'),    
    ('NOK','Corona Noruega/USD'),    
    ('PLATA','Plata spot'),    
    ('ORO','Oro Spot'),    
    ('UFXU','Peso/USDBanxico'),    
    ('CLP','Peso Chileno/USD'),    
    ('CLF','Peso Chileno/CLF'),    
    ('CNY','Yuan Chino Onshore/USD'),    
    ('AUD','Dólar Australiano/USD'),    
    ('CNH','Yuan Chino Offshore/USD')    
    
/*se agrega un INNER JOIN con @tmpValuesDesc para ligar descripcion con irc's @tmp_tblDirectivesIRC */    
  INSERT @tblResult    
   SELECT           
    intSection,tmpValuesDesc.txtDesc,RTRIM(Label),LTRIM(dblValueOr),LTRIM(dblValue)     
   FROM @tmp_tblDirectivesIRC AS tblDirectivesIRC    
   INNER JOIN @tmpValuesDesc AS tmpValuesDesc    
   ON tblDirectivesIRC.txtIRC = tmpValuesDesc.txtIrc    
    
   -- Reporto los datos    
   /*en lugar de fecha reportamos descripción*/    
     
   IF EXISTS(    
   SELECT TOP 1 dteDate    
   FROM @tblResult    
  )    
    
    SELECT    
    dteDate,    
    txtLabel,       
    dblValIRC1,       
    dblValIRC2    
    FROM @tblResult        
    ORDER BY     
    intSection        
    
   ELSE    
     RAISERROR ('ERROR: Falta Informacion', 16, 1)    
    
       
   SET NOCOUNT OFF     
    
END    
  
  
/*  
AUTOR:OmaR Adrian Aceves Gutierrez  
FECHA:2014-03-03 15:31:12.253  
OBJETIVO:Crear personalizado HSBC_VALDIV_XLS  
*/  
CREATE PROCEDURE sp_productos_BITAL;23  
  
--DECLARE   
@txtDate AS DATETIME  
--SET @txtDate = '20140310'  
  
AS   
BEGIN   
  
SET NOCOUNT ON    
  
  
DECLARE @tblDirectives TABLE (    
   indSheet INT,    
   SheetName CHAR(50),    
   intSection INT,    
   txtSource CHAR(50),    
   txtCode CHAR(250),    
   intCol INT,    
   intRow INT,    
   txtValue VARCHAR(20),  
    Node INT    
  PRIMARY KEY (indSheet, intCol, intRow)    
  )    
    
DECLARE @dblUFXU  FLOAT  SET @dblUFXU = (SELECT LTRIM(STR( CAST(dblValue AS DECIMAL (18,10)) ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'UFXU')  
DECLARE @ORO1 DECIMAL(18,8)   SET @ORO1 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * 1.205652 * @dblUFXU / 50,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')  
DECLARE @ORO2 DECIMAL(18,8)   SET @ORO2 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) *(1+0.02)* @dblUFXU ,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')   
DECLARE @ORO3 DECIMAL(18,8)   SET @ORO3 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * 0.48227 *1.04 * @dblUFXU/20,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')   
DECLARE @PLATA1 DECIMAL(18,8) SET @PLATA1 = (SELECT LTRIM(STR(ROUND((CAST(dblValue AS DECIMAL (18,10)) +1.5)* @dblUFXU ,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'PLATA')   
DECLARE @PLATA2 DECIMAL(18,8) SET @PLATA2 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * @dblUFXU * 5 + 5 *@dblUFXU  ,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'PLATA')   
  
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue,Node)    
   SELECT 01,'VALDIV',1,'GBPX','GBPX',3,9,NULL,NULL UNION   
   SELECT 01,'VALDIV',1,'CHFX','CHFX',3,10,NULL,NULL UNION   
   SELECT 01,'VALDIV',1,'FRFX','FRFX',3,11,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'DKKX','DKKX',3,12,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'NLGX','NLGX',3,13,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'SEKX','SEKX',3,14,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'DEMX','DEMX',3,15,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ESPX','ESPX',3,16,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'BEFX','BEFX',3,17,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ITLX','ITLX',3,18,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'JPYX','JPYX',3,19,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ATSX','ATSX',3,20,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'CADX','CADX',3,21,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'NOKX','NOKX',3,22,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'BRLX','BRLX',3,23,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'EURX','EURX',3,24,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'UFXU','UFXU',3,25,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'UFXU','UFXU',3,26,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,27,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,28,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,29,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'PLATA','PLATA',3,30,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,31,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'PLATA','PLATA',3,32,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'CNYX','CNYX',3,33,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'AUDX','AUDX',3,34,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'CNHX','CNHX',3,35,NULL,NULL  
   
   
 UPDATE @tblDirectives  
 SET txtValue = (SELECT LTRIM(STR(dblValue,15,4)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource)  
   
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(dblValue,15,5)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (14)  
   
 UPDATE @tblDirectives  
   
 SET txtValue =   
  (   SELECT LTRIM(STR(1/dblValue,15,5)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (9,24,34)  
  
   
 UPDATE @tblDirectives  
 SET txtValue =   
  (SELECT LTRIM(STR(dblValue *(1+0.02)* @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (27)  
   
   
   
 UPDATE @tblDirectives  
 SET txtValue =   
  (   SELECT LTRIM(STR(dblValue * 1.205652 * @dblUFXU /50,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (28)  
   
 UPDATE @tblDirectives  
 SET txtValue =   
  (   SELECT LTRIM(STR(dblValue * @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (29)  
   
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(dblValue * @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (30)  
   
  UPDATE @tblDirectives  
 SET txtValue =   
 (   SELECT LTRIM(STR(dblValue *0.48227*1.04* @dblUFXU /20,15,4)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (31)  
   
  
  UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR((dblValue + 6)* @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (32)  
  
   
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 01,'VALDIV',2,'GBP','GBP',4,5,CONVERT(bigint,CONVERT(datetime,@txtDate+ 2)) UNION   
   SELECT 01,'VALDIV',2,'GBP','GBP',4,9,NULL UNION   
   SELECT 01,'VALDIV',2,'CHF','CHF',4,10,NULL UNION  
   SELECT 01,'VALDIV',2,'FRF','FRF',4,11,NULL UNION  
   SELECT 01,'VALDIV',2,'DKK','DKK',4,12,NULL UNION  
   SELECT 01,'VALDIV',2,'NLG','NLG',4,13,NULL UNION  
     
   SELECT 01,'VALDIV',2,'SEK','SEK',4,14,NULL UNION  
   SELECT 01,'VALDIV',2,'DEM','DEM',4,15,NULL UNION  
   SELECT 01,'VALDIV',2,'ESP','ESP',4,16,NULL UNION  
   SELECT 01,'VALDIV',2,'BEF','BEF',4,17,NULL UNION  
   SELECT 01,'VALDIV',2,'ITL','ITL',4,18,NULL UNION  
     
   SELECT 01,'VALDIV',2,'JPY','JPYX',4,19,NULL UNION  
   SELECT 01,'VALDIV',2,'ATS','ATS',4,20,NULL UNION  
   SELECT 01,'VALDIV',2,'CAD','CAD',4,21,NULL UNION  
   SELECT 01,'VALDIV',2,'NOK','NOK',4,22,NULL UNION  
   SELECT 01,'VALDIV',2,'BRL','BRL',4,23,NULL UNION  
     
   SELECT 01,'VALDIV',2,'EUR','EUR',4,24,NULL UNION   
     
   SELECT 01,'VALDIV',2,'--','--',4,25,'--' UNION  
   SELECT 01,'VALDIV',2,'--','--',4,26,'--' UNION  
   SELECT 01,'VALDIV',2,'--','--',4,27,'PLATA LIBERTAD' UNION   
     
   SELECT 01,'VALDIV',2,'PLATA','ORO',4,28,NULL UNION  
   SELECT 01,'VALDIV',2,'','',4,29,'--' UNION  
   SELECT 01,'VALDIV',2,'PLATA','ORO',4,30,NULL UNION  
   SELECT 01,'VALDIV',2,'PLATA','PLATA',4,31,'--' UNION  
   SELECT 01,'VALDIV',2,'ORO','ORO',4,32,'--' UNION  
   SELECT 01,'VALDIV',2,'CNY','CNY',4,33,NULL UNION  
   SELECT 01,'VALDIV',2,'AUD','AUD',4,34,NULL UNION  
   SELECT 01,'VALDIV',2,'CNH','CNH',4,35,NULL  
   
 UPDATE @tblDirectives  
 SET txtValue =   
 (CASE WHEN txtValue IS  NULL  THEN   
 (SELECT  LTRIM(STR( CONVERT(VARCHAR(50),ROUND(dblValue,6,0)),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 2)  
  ELSE txtValue END   
  )  
    
UPDATE @tblDirectives  
SET txtValue =   
(SELECT  LTRIM(STR((dblValue + 1.5)* @dblUFXU,15,6))  FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
WHERE intSection = 2 AND intRow IN(28,30)  
  
   
   
   
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 01,'VALDIV',3,'GBPX','GBPX',8,9,NULL UNION   
   SELECT 01,'VALDIV',3,'DEMX','DEMX',8,10,NULL UNION   
   SELECT 01,'VALDIV',3,'JPYX','JPYX',8,11,NULL UNION   
   SELECT 01,'VALDIV',3,'CHFX','CHFX',8,12,NULL UNION   
   SELECT 01,'VALDIV',3,'FRFX','FRFX',8,13,NULL UNION   
   SELECT 01,'VALDIV',3,'CADX','CADX',8,14,NULL UNION   
   SELECT 01,'VALDIV',3,'NLGX','NLGX',8,15,NULL UNION   
   SELECT 01,'VALDIV',3,'SEKX','SEKX',8,16,NULL UNION   
   SELECT 01,'VALDIV',3,'ESPX','ESPX',8,17,NULL UNION   
   SELECT 01,'VALDIV',3,'BEFX','BEFX',8,18,NULL UNION   
   SELECT 01,'VALDIV',3,'ITLX','ITLX',8,19,NULL UNION   
   SELECT 01,'VALDIV',3,'ATSX','ATSX',8,20,NULL UNION   
   SELECT 01,'VALDIV',3,'DKKX','DKKX',8,21,NULL UNION   
   SELECT 01,'VALDIV',3,'NOKX','NOKX',8,22,NULL UNION   
   SELECT 01,'VALDIV',3,'BRLX','BRLX',8,23,NULL UNION  
   SELECT 01,'VALDIV',3,'EURX','EURX',8,24,NULL UNION  
   SELECT 01,'VALDIV',3,'CNYX','CNYX',8,25,NULL  UNION  
   SELECT 01,'VALDIV',3,'AUDX','AUDX',8,26,NULL  UNION  
   SELECT 01,'VALDIV',3,'CNHX','CNHX',8,27,NULL UNION   
   SELECT 01,'VALDIV',3,'PLATA','PLATA',8,28,NULL  UNION  
   SELECT 01,'VALDIV',3,'ORO','ORO',8,29,NULL    
  
UPDATE @tblDirectives  
 SET txtValue =   
 (CASE WHEN txtValue IS  NULL  THEN   
 (SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection =3)  
  ELSE txtValue END   
  )  
  UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(1/dblValue,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )  
 WHERE intSection = 3 AND  intRow = 24  
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(1/dblValue,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )  
 WHERE intSection = 3 AND  intRow = 26  
   
  
  
  
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
 SELECT 01,'VALDIV',4,'EURX','EURX',8,37,NULL UNION   
 SELECT 01,'VALDIV',4,'EURX','EURX',8,38,NULL    
  
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(dblValue * 200.482,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )  
 WHERE intSection = 4 AND  intRow = 37  
   
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(@dblUFXU /(200.482 * CAST(dblValue AS DECIMAL(32,32)))) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource )  
 WHERE intSection = 4 AND intRow = 38  
   
   
 ------  
   
   
-- 38 0.0915  
   
   
-- SELECT 13.2248 / (200.482 * CAST(0.721032518566587 AS DECIMAL(32,32) ))  
   
-- SELECT * FROM  MxFixIncome.dbo.tblIRC WHERE dteDate = '20140310' AND txtIRC = 'UFXU'  
   
   
--DECLARE   
--@txtDate AS DATETIME  
--SET @txtDate = '20140310'  
--DECLARE @dblUFXU  FLOAT  SET @dblUFXU = (SELECT LTRIM(STR( CAST(dblValue AS DECIMAL (18,10)) ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'UFXU')  
--PRINT @dblUFXU  
   
   
------  
   
 /*  
 --comienzo de suganda pagina en excel  
 --  
 */  
   
  
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 2,'DIV X DLR',5,'UFXU','UFXU',4,8,NULL  UNION   
   SELECT 2,'DIV X DLR',5,'1','1',4,9,1  UNION     
   SELECT 2,'DIV X DLR',5,'GBPX','GBPX',4,10,NULL UNION   
   SELECT 2,'DIV X DLR',5,'CHFX','CHFX',4,11,NULL UNION   
   SELECT 2,'DIV X DLR',5,'FRFX','FRFX',4,12,NULL  UNION   
     
   SELECT 2,'DIV X DLR',5,'DKKX','DKKX',4,13,NULL UNION     
   SELECT 2,'DIV X DLR',5,'NLGX','NLGX',4,14,NULL UNION   
   SELECT 2,'DIV X DLR',5,'SEKX','NOKX',4,15,NULL UNION    
   SELECT 2,'DIV X DLR',5,'DEMX','DEMX',4,16,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ESPX','ESPX',4,17,NULL UNION   
     
       
   SELECT 2,'DIV X DLR',5,'BEFX','BEFX',4,18,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ITLX','ITLX',4,19,NULL UNION    
   SELECT 2,'DIV X DLR',5,'JPYX','JPYX',4,20,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ATSX','ATSX',4,21,NULL UNION     
   SELECT 2,'DIV X DLR',5,'CADX','CADX',4,22,NULL UNION   
     
   SELECT 2,'DIV X DLR',5,'NOKX','NOKX',4,23,NULL UNION    
   SELECT 2,'DIV X DLR',5,'BRLX','BRLX',4,24,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ORO1','DEMX',4,25,NULL UNION   --  
      SELECT 2,'DIV X DLR',5,'PTE','PTE',4,26,NULL UNION   
      SELECT 2,'DIV X DLR',5,'UFXU/(PLATA1*2)','DEMX',4,27,NULL UNION  --  
      SELECT 2,'DIV X DLR',5,'ORO2/UFXU','GBPX',4,28,NULL UNION   
   SELECT 2,'DIV X DLR',5,'UFXU/PLATA1','DEMX',4,29,NULL   
  
 UPDATE @tblDirectives  
 SET txtValue =   
 (CASE WHEN txtValue IS  NULL  THEN   
 (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 5)  
  ELSE txtValue END   
  )  
    
  UPDATE @tblDirectives  
  SET txtValue = STR(1/(@ORO1/@dblUFXU),15,6)  
  WHERE intSection = 5 AND intRow = 25  
   
  UPDATE @tblDirectives  
  SET txtValue = STR(@dblUFXU/(@PLATA1*2),15,6)  
  WHERE intSection = 5 AND intRow = 27  
   
 /*update made UFXU / ORO2*/  
  UPDATE @tblDirectives  
  SET txtValue = STR(@dblUFXU/@ORO2,15,6)  
  WHERE intSection = 5 AND intRow = 28  
   
 UPDATE @tblDirectives  
  SET txtValue = STR(@dblUFXU / @PLATA1,15,6)  
  WHERE intSection = 5 AND intRow = 29  
   
  
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 2,'DIV X DLR',5,'(2*UFXU)/ORO2','GBPX',4,30,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(4*UFXU)/ORO2','DEMX',4,31,NULL UNION    
   SELECT 2,'DIV X DLR',5,'(10*UFXU)/ORO2','GBPX',4,32,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(20*UFXU)/ORO2','DEMX',4,33,NULL UNION  --  
   SELECT 2,'DIV X DLR',5,'(1.635*UFXU)/PLATA1','GBPX',4,34,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(3.5*UFXU)/PLATA1','DEMX',4,35,NULL UNION    
   SELECT 2,'DIV X DLR',5,'(6*UFXU)/PLATA1','GBPX',4,36,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(9*UFXU)/PLATA1','DEMX',4,37,NULL UNION --5  
   SELECT 2,'DIV X DLR',5,'ORO2/UFXU','GBPX',4,38,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(2*UFXU)/ORO2','DEMX',4,39,NULL UNION    
   SELECT 2,'DIV X DLR',5,'(4*UFXU)/ORO2','GBPX',4,40,NULL UNION   
   SELECT 2,'DIV X DLR',5,'UFXU/PLATA1','DEMX',4,41,NULL UNION ---  
   SELECT 2,'DIV X DLR',5,'(1.635*@dblUFXU)/@PLATA1','GBPX',4,42,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(3.5 * @dblUFXU)/@PLATA1','DEMX',4,43,NULL UNION    
   SELECT 2,'DIV X DLR',5,'@dblUFXU/@PLATA2','GBPX',4,44,NULL UNION   
   SELECT 2,'DIV X DLR',5,'@dblUFXU/@PLATA2','DEMX',4,45,NULL UNION  
   SELECT 2,'DIV X DLR',5,'1/@ORO','DEMX',4,46,NULL  UNION ---  
   SELECT 2,'DIV X DLR',5,'1/PLATA','GBPX',4,47,NULL UNION   
   SELECT 2,'DIV X DLR',5,'@dblUFXU/ORO3','DEMX',4,48,NULL UNION    
   SELECT 2,'DIV X DLR',5,'@dblUFXU','GBPX',4,49,NULL UNION   
   SELECT 2,'DIV X DLR',5,'EURX','DEMX',4,50,NULL UNION  
   SELECT 2,'DIV X DLR',5,'1/(PLATA+6)','DEMX',4,51,NULL  UNION ---  
   SELECT 2,'DIV X DLR',5,'CLPX','GBPX',4,52,NULL UNION   
   SELECT 2,'DIV X DLR',5,'CLF/UFXU','DEMX',4,53,NULL UNION    
   SELECT 2,'DIV X DLR',5,'CNYX','GBPX',4,54,NULL UNION   
   SELECT 2,'DIV X DLR',5,'1/AUDX','DEMX',4,55,NULL UNION  
   SELECT 2,'DIV X DLR',5,'CNHX','DEMX',4,56,NULL    
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (2*@dblUFXU)/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 30  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (4*@dblUFXU)/@ORO2 ,15,6)  
   WHERE intSection = 5 AND intRow = 31  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (10*@dblUFXU)/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 32  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (20*@dblUFXU)/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 33  
  
   UPDATE @tblDirectives  
   SET txtValue = STR((1.635*@dblUFXU)/@PLATA1  ,15,6)  
   WHERE intSection = 5 AND intRow = 34  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (3.5*@dblUFXU)/@PLATA1  ,15,6)  
   WHERE intSection = 5 AND intRow = 35  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (6*@dblUFXU)/@PLATA1 ,15,6)  
   WHERE intSection = 5 AND intRow = 36  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (9*@dblUFXU)/@PLATA1,15,6)  
   WHERE intSection = 5 AND intRow = 37  
 ----  
 /*update made UFXU / ORO2*/  
  UPDATE @tblDirectives  
   SET txtValue = STR(@dblUFXU/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 38  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (2*@dblUFXU)/@ORO2 ,15,6)  
   WHERE intSection = 5 AND intRow = 39  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (4*@dblUFXU)/@ORO2 ,15,6)  
   WHERE intSection = 5 AND intRow = 40  
     
  UPDATE @tblDirectives  
   SET txtValue = STR(@dblUFXU/@PLATA1,15,6)  
   WHERE intSection = 5 AND intRow = 41  
   --  
  UPDATE @tblDirectives  
   SET txtValue = STR((1.635*@dblUFXU)/@PLATA1 ,15,6)  
   WHERE intSection = 5 AND intRow = 42  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (3.5 * @dblUFXU)/@PLATA1 ,15,6)  
   WHERE intSection = 5 AND intRow = 43  --PLATA PRECOL. 1/4 ONZA  
  
  UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU/@PLATA2,15,6)  
   WHERE intSection = 5 AND intRow = 44  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU/@PLATA2,15,6)  
   WHERE intSection = 5 AND intRow = 45  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )  
   WHERE intSection = 5 AND intRow = 46  
 ---  
   
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 5 AND intRow = 47  
     
     
   --------------  
    UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU/@ORO3,15,6)  
   WHERE intSection = 5 AND intRow = 48  --ORO CHICO  
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU,15,6)  
   WHERE intSection = 5 AND intRow = 49    
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )  
   WHERE intSection = 5 AND intRow = 50  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(1 / (dblValue + 6 ) ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 5 AND intRow = 51  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLPX' )  
   WHERE intSection = 5 AND intRow = 52  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(dblValue/@dblUFXU,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )  
   WHERE intSection = 5 AND intRow = 53  
     
      
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNYX' )  
   WHERE intSection = 5 AND intRow = 54  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'AUDX' )  
   WHERE intSection = 5 AND intRow = 55  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNHX' )  
   WHERE intSection = 5 AND intRow = 56  
     
   /*  
   COLUMNA 3 HOJA 2   
   */  
    INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 2,'DIV X DLR',6,'1','1',5,8,1  UNION   
   SELECT 2,'DIV X DLR',6,'UFXU','UFXU',5,9,NULL   UNION     
   SELECT 2,'DIV X DLR',6,'GBP','GBP',5,10,NULL UNION   
   SELECT 2,'DIV X DLR',6,'CHF','CHF',5,11,NULL UNION   
   SELECT 2,'DIV X DLR',6,'FRF','FRF',5,12,NULL  UNION   
   SELECT 2,'DIV X DLR',6,'DKK','DKK',5,13,NULL UNION     
   SELECT 2,'DIV X DLR',6,'NLG','NLG',5,14,NULL UNION   
   SELECT 2,'DIV X DLR',6,'SEK','SEK',5,15,NULL UNION    
   SELECT 2,'DIV X DLR',6,'DEM','SEKX',5,16,NULL UNION   
   SELECT 2,'DIV X DLR',6,'ESP','ESP',5,17,NULL UNION   
   SELECT 2,'DIV X DLR',6,'BEF','BEF',5,18,NULL UNION   
   SELECT 2,'DIV X DLR',6,'ITL','ITL',5,19,NULL UNION    
   SELECT 2,'DIV X DLR',6,'JPY','JPY',5,20,NULL UNION   
   SELECT 2,'DIV X DLR',6,'ATS','ATS',5,21,NULL UNION     
   SELECT 2,'DIV X DLR',6,'CAD','CAD',5,22,NULL  UNION   
     
   SELECT 2,'DIV X DLR',6,'NOK','NOK',5,23,null UNION   
   SELECT 2,'DIV X DLR',6,'BRL','BRL',5,24,NULL UNION    
   SELECT 2,'DIV X DLR',6,'JPY','JPY',5,25,NULL  UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,26,NULL  UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,27,NULL UNION --ERROR DECIMALES  
     
   SELECT 2,'DIV X DLR',6,'--','--',5,28,@ORO2 UNION   
   SELECT 2,'DIV X DLR',6,'--','---',5,29,STR(@PLATA1,15,6)  UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,30,STR(@ORO2/2,15,6)   UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,31,STR(@ORO2/4,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,32,STR(@ORO2/10,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,33,STR(@ORO2/20,15,6) UNION   
     
     
   SELECT 2,'DIV X DLR',6,'ATS','---',5,34,STR(@PLATA1/1.635,15,6)  UNION    
   SELECT 2,'DIV X DLR',6,'ATS','--',5,35,STR(@PLATA1/3.5,15,6)   UNION   
   SELECT 2,'DIV X DLR',6,'ATS','--',5,36,STR(@PLATA1/6,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'ATS','--',5,37,STR(@PLATA1/9,15,6)     UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,38,STR(@ORO2,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,39,STR(@ORO2/2,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,40,STR(@ORO2/4,15,6) UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,41,STR(@PLATA1,15,6)  UNION   
   SELECT 2,'DIV X DLR',6,'ATS','--',5,42,STR(@PLATA1/ 1.635,15,6)     UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,43,STR(@PLATA1/3.5,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,44,STR(@PLATA2,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,45,STR(@PLATA2,15,6) UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,46,NULL   UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,47,STR(@PLATA1,15,6) UNION  
   SELECT 2,'DIV X DLR',6,'--','--',5,48,STR(@ORO3,15,6) UNION    
     
     
   SELECT 2,'DIV X DLR',6,'-1','-1',5,49,1   UNION     
   SELECT 2,'DIV X DLR',6,'EUR','EUR',5,50,NULL   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,51,NULL UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,52,NULL   UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,53,STR(@PLATA1,15,6)  UNION   
     
   SELECT 2,'DIV X DLR',6,'CNY','CNY',5,54,NULL UNION   
   SELECT 2,'DIV X DLR',6,'AUD','AUD',5,55,NULL   UNION    
   SELECT 2,'DIV X DLR',6,'CNH','CNH',5,56,NULL   
    
    
    
     
 UPDATE @tblDirectives  
  SET txtValue =   
  (CASE WHEN txtValue IS  NULL  THEN   
  (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 6)  
   ELSE txtValue END   
   )  
     
     
     
   UPDATE @tblDirectives  
   SET txtValue = STR( round(@ORO1,6,0),10,6)   
   WHERE intSection = 6 AND intRow = 25  
     
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( @dblUFXU/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PTE' )  
   WHERE intSection = 6 AND intRow = 26  
     
  UPDATE @tblDirectives  
   SET txtValue =STR( round(@PLATA1*2 ,6,0),10,6)             
   WHERE intSection = 6 AND intRow = 27    
  
  
 UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue * @dblUFXU,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )  
   WHERE intSection = 6 AND intRow = 46  
     
 UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue * @dblUFXU,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 6 AND intRow = 47  
  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( (dblValue+6) * @dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 6 AND intRow = 51  
  
  
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue * @dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLP' )  
   WHERE intSection = 6 AND intRow = 52  
  
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( @dblUFXU / dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )  
   WHERE intSection = 6 AND intRow = 53  
  
  
  
/*  
columna 3 sheet2  
*/  
  
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
  
   SELECT 2,'DIV X DLR',7,'Int','Int',6,4,CONVERT(bigint,CONVERT(datetime,@txtDate+2))  UNION   
   SELECT 2,'DIV X DLR',7,'UFXU','UFXU',6,8,NULL  UNION   
   SELECT 2,'DIV X DLR',7,'1','1',6,9,1   UNION    
   SELECT 2,'DIV X DLR',7,'GBX','GBX',6,10,NULL   UNION    
   SELECT 2,'DIV X DLR',7,'CHF','CHF',6,11,NULL UNION   
   SELECT 2,'DIV X DLR',7,'FRF','FRF',6,12,NULL UNION  
   SELECT 2,'DIV X DLR',7,'DKK','DKK',6,13,NULL UNION   
     
   SELECT 2,'DIV X DLR',7,'NLG','NLG',6,14,NULL UNION   
   SELECT 2,'DIV X DLR',7,'NOK','NOK',6,15,NULL UNION  
   SELECT 2,'DIV X DLR',7,'DEM','DEM',6,16,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ESP','ESP',6,17,NULL UNION   
   SELECT 2,'DIV X DLR',7,'BEF','BEF',6,18,NULL UNION  
   SELECT 2,'DIV X DLR',7,'ITL','ITL',6,19,NULL UNION  
   SELECT 2,'DIV X DLR',7,' JPY',' JPY',6,20,NULL UNION  
     
   SELECT 2,'DIV X DLR',7,'ATS','ATS',6,21,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CAD','CAD',6,22,NULL UNION   
   SELECT 2,'DIV X DLR',7,'NOK','NOK',6,23,NULL UNION  
   SELECT 2,'DIV X DLR',7,'BRLX','BRLX',6,24,NULL UNION   
   -----  
   SELECT 2,'DIV X DLR',7,'@ORO1/@UFXU','@ORO1/@UFXU',6,25,NULL  UNION   
   SELECT 2,'DIV X DLR',7,'1/PTE','1/PTE',6,26,NULL  UNION   
   SELECT 2,'DIV X DLR',7,'--','--',6,27,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@UFXU/@ORO2','--',6,28,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@PLATA1/@UFXU','--',6,29,NULL  UNION   
     
   SELECT 2,'DIV X DLR',7,'ORO2/(2*@dblUFXU)','--',6,30,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ORO2/(4*@dblUFXU)','--',6,31,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ORO2/(10*@dblUFXU)','--',6,32,NULL UNION  
   SELECT 2,'DIV X DLR',7,'ORO2/(20*@dblUFXU)','--',6,33,NULL UNION   
   SELECT 2,'DIV X DLR',7,'PLATA1/(1.635*@dblUFXU)','--',6,34,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(3.5 *@dblUFXU)','--',6,35,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(6*@dblUFXU)','--',6,36,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(9*@dblUFXU)','--',6,37,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@dblUFXU/@ORO2','--',6,38,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@ORO2/(2*@dblUFXU)','--',6,39,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@ORO2/(4*@dblUFXU)','--',6,40,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/@dblUFXU','--',6,41,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(1.635*@dblUFXU)','--',6,42,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@PLATA1/(3.5*@dblUFXU)','--',6,43,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA2/@dblUFXU','--',6,44,NULL UNION   
     
  
   SELECT 2,'DIV X DLR',7,'@PLATA2/@dblUFXU','--',6,45,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ORO','--',6,46,NULL UNION   
   SELECT 2,'DIV X DLR',7,'PLATA','--',6,47,NULL UNION  
   SELECT 2,'DIV X DLR',7,'ORO3/@dblUFXU','--',6,48,NULL UNION   
   SELECT 2,'DIV X DLR',7,'1','1',6,49,1 UNION   
   SELECT 2,'DIV X DLR',7,'1/EURX','--',6,50,NULL UNION   
   SELECT 2,'DIV X DLR',7,'PLATA+6','--',6,51,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CLP','--',6,52,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@dblUFXU/CLF','--',6,53,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CNY/@dblUFXU','--',6,54,NULL union  
   SELECT 2,'DIV X DLR',7,'AUDX','--',6,55,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CNH / @dblUFXU','--',6,56,NULL   
------  
  
  
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'UFXU' )  
   WHERE intSection = 7 AND intRow = 8  
    
    
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'GBPX' )  
   WHERE intSection = 7 AND intRow = 10  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CHFX' )  
   WHERE intSection = 7 AND intRow = 11  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'FRFX' )  
   WHERE intSection = 7 AND intRow = 12  
     
    UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'DKKX' )  
   WHERE intSection = 7 AND intRow = 13  
     
   --  
   UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'NLGX' )  
   WHERE intSection = 7 AND intRow = 14  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'SEKX' )  
   WHERE intSection = 7 AND intRow = 15  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'DEMX' )  
   WHERE intSection = 7 AND intRow = 16  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ESPX' )  
   WHERE intSection = 7 AND intRow = 17  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'BEFX' )  
   WHERE intSection = 7 AND intRow = 18  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ITLX' )  
   WHERE intSection = 7 AND intRow = 19  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'JPYX' )  
   WHERE intSection = 7 AND intRow = 20  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ATSX' )  
   WHERE intSection = 7 AND intRow = 21  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CADX' )  
   WHERE intSection = 7 AND intRow = 22  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'NOKX' )  
   WHERE intSection = 7 AND intRow = 23  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'BRLX' )  
   WHERE intSection = 7 AND intRow = 24  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO1/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 25    
        
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PTE' )  
   WHERE intSection = 7 AND intRow = 26  
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (@PLATA1*2)/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 27    
     
   /*UPDATED VALUE ORO2 / UFXU*/  
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 28    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 29    
   ----------  
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(2*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 30    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(4*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 31    
        
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(10*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 32   
      
  UPDATE @tblDirectives  
   SET txtValue = STR(@ORO2/(20*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 33    
  
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(1.635*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 34    
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(3.5 *@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 35    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(6*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 36    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(9*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 37    
   ----------  
     
   /*UPDATED VALUE ORO2 / UFXU*/  
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 38    
     
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(2*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 39    
        
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(4*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 40   
      
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 41    
  
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(1.635*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 42    
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(3.5*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 43    
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 44    
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 45   
        
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )  
   WHERE intSection = 7 AND intRow = 46  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 7 AND intRow = 47  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO3/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 48  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )  
   WHERE intSection = 7 AND intRow = 50  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue +6  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 7 AND intRow = 51  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLP' )  
   WHERE intSection = 7 AND intRow = 52  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( @dblUFXU /dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )  
   WHERE intSection = 7 AND intRow = 53  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(dblValue/@dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNY' )  
   WHERE intSection = 7 AND intRow = 54  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'AUDX' )  
   WHERE intSection = 7 AND intRow = 55  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue/ @dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNH' )  
   WHERE intSection = 7 AND intRow = 56  
  
     
  
  
/*  
sheet 3 colomna 1  
*/  
  
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
     
     
   SELECT 3,'Mesa de Control',8,'Int','Int',4,6,CONVERT(bigint,CONVERT(datetime,@txtDate+2)) UNION    
     
     
   SELECT 3,'Mesa de Control',8,'UFXU','UFXU',4,9,null  UNION    
   SELECT 3,'Mesa de Control',8,'1/GBPX','1/GBPX',4,10,NULL    UNION --  
   SELECT 3,'Mesa de Control',8,'CHFX','CHFX',4,11,NULL    UNION    
   SELECT 3,'Mesa de Control',8,'FRFX','FRFX',4,12,NULL    UNION   
     
   SELECT 3,'Mesa de Control',8,'DKKX','DKKX',4,13,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'NLGX','NLGX',4,14,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'SEKX','SEKX',4,15,NULL UNION   
     
   SELECT 3,'Mesa de Control',8,'DEMX','DEMX',4,16,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'ESPX','ESPX',4,17,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'BEFX','BEFX',4,18,NULL UNION   
     
   SELECT 3,'Mesa de Control',8,'ITLX','ITLX',4,19,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'JPYX','JPYX',4,20,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'ATSX','ATSX',4,21,NULL  UNION   
     
     
   SELECT 3,'Mesa de Control',8,'CADX','CADX',4,22,NULL UNION   
   SELECT 3,'Mesa de Control',8,'NOKX','NOKX',4,23,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'BRLX','BRLX',4,24,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'1/EURX','1/EURX',4,25,NULL  UNION--  
   SELECT 3,'Mesa de Control',8,'AUDX','AUDX',4,26,NULL   
  
    
    
 UPDATE @tblDirectives  
  SET txtValue =   
  (CASE WHEN txtValue IS  NULL  THEN   
  (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 8)  
   ELSE txtValue END   
   )  
     
     
   UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'GBPX' )  
   WHERE intSection = 8 AND intRow = 10 --1/GBPX  
     
    UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )  
   WHERE intSection = 8 AND intRow = 25 --1/EURX  
  
  
  
  
  SELECT    
    LTRIM(STR(indSheet)) AS [indSheet],    
    RTRIM(SheetName) AS [SheetName]    
    FROM @tblDirectives    
    GROUP BY     
    indSheet,SheetName    
    ORDER BY     
    indSheet,SheetName    
    
    -- regreso los limites    
   SELECT    
    intSection,    
    MIN(intCol) AS intMinCol,    
    MAX(intCol) AS intMaxCol,    
    MIN(intRow) AS intMinRow,    
    MAX(intRow) AS intMaxRow,    
    indSheet    
    FROM @tblDirectives    
    GROUP BY     
    indSheet,intSection    
    ORDER BY     
    indSheet,intSection    
    
   -- regreso las directivas    
   SELECT    
    LTRIM(STR(intSection)) AS [intSection],    
    LTRIM(STR(indSheet)) AS [indSheet],    
    intCol AS [intCol],    
    intRow AS [intRow],    
    RTRIM(txtValue) AS [txtValue]    
   FROM @tblDirectives    
   ORDER BY     
    intSection,    
    indSheet,    
    intCol,    
    intRow    
    
 SET NOCOUNT OFF   
END  
  
  
  
  
  
  
/*  
Autor:  Aceves Gutierrez Omar Adrian  
Fecha:  2014-05-21 10:24:14.037  
Objetivo: Realizar un proceso VALDIV[YYYYMDD]_Banxico.xls que genere tipos de cambio solo en fin de mes  (HSBC_VALVID_Banxico_XLS)  
*/  
  
CREATE   PROCEDURE sp_productos_BITAL;24 --'20140530'  
  
  
--DECLARE    
@txtDate AS DATETIME   
--sET @txtDate = '20140630'  
  
  
AS     
BEGIN     
sET NOCOUNT ON      
    
    
    
--  /*PROCESO PARA DETERMINAR SI ES FIN DE MES Y EJECUTARLO   (ULTIMO DIA DEL MES LABORABLE L a V  )*/  
    
--  DECLARE @txtMyLatDate  INT  = (SELECT dbo.fun_IsTradingDate((SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112)),'MX'))  
  
  
--DECLARE @txtDateToExecute VARCHAR(10)  
-- IF (@txtMyLatDate = 1)  
-- SET @txtDateToExecute = (SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112))  
-- ELSE   
-- BEGIN   
--  SET @txtDateToExecute =(  CONVERT(VARCHAR(10),dbo.fun_NextTradingDate((SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112)),-1,'MX'),112))  
-- END   
   
 --SELECT @txtDateToExecute  
   
  
  
  
    
  /*EMPIEZA SP A EJECUTARSE */  
  
DECLARE @TempGetHistPrices TABLE   
(  
dteDate DATETIME,  
txtid1 VARCHAR(12),  
dblValue FLOAT   
)  
INSERT INTO @TempGetHistPrices  
SELECT dteDate,txtID1,dblValue FROM tblPrices  
WHERE txtID1 IN  ('MIRC0010951','MIRC0000369','MIRC0000312','MIRC0000368','MIRC0000338','MIRC0000303',  
'MIRC0000350','MIRC0000301','MIRC0000378','MIRC0000304','MIRC0000305','MIRC0000294','MIRC0023388') AND dteDate = @txtDate  
  
  
  
  
  
  
DECLARE @tblDirectives TABLE (    
   indSheet INT,    
   SheetName CHAR(50),    
     
   intSection INT,    
   txtSource CHAR(50),    
   txtCode CHAR(250),    
   intCol INT,    
   intRow INT,    
   txtValue VARCHAR(20),  
    Node INT    
  PRIMARY KEY (indSheet, intCol, intRow)    
  )    
    
DECLARE @dblUFXU  FLOAT  SET @dblUFXU = (SELECT LTRIM(STR( CAST(dblValue AS DECIMAL (18,10)) ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'UFXU')  
DECLARE @ORO1 DECIMAL(18,8)   SET @ORO1 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * 1.205652 * @dblUFXU / 50,6,0) ,15,6) ) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')  
DECLARE @ORO2 DECIMAL(18,8)   SET @ORO2 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) *(1+0.02)* @dblUFXU ,6,0) ,15,6) ) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')   
DECLARE @ORO3 DECIMAL(18,8)   SET @ORO3 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * 0.48227 *1.04 * @dblUFXU/20,6,0) ,15,6) ) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')   
DECLARE @PLATA1 DECIMAL(18,8) SET @PLATA1 = (SELECT LTRIM(STR(ROUND((CAST(dblValue AS DECIMAL (18,10)) +1.5)* @dblUFXU ,6,0) ,15,6) ) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'PLATA')   
DECLARE @PLATA2 DECIMAL(18,8) SET @PLATA2 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * @dblUFXU * 5 + 5 *@dblUFXU  ,6,0) ,15,6) ) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'PLATA')   
  
  
  
  
  
  
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue,Node)    
   SELECT 01,'VALDIV',1,'MIRC0010951','UFXU',3,9,NULL,NULL UNION   
   SELECT 01,'VALDIV',1,'UFXU','MIRC0000369',3,10,NULL,NULL UNION   
     
   SELECT 01,'VALDIV',1,'FRFX','FRFX',3,11,NULL,NULL UNION-- OK  
   SELECT 01,'VALDIV',1,'UFXU','MIRC0000312',3,12,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'NLGX','NLGX',3,13,NULL,NULL UNION--OK  
     
   SELECT 01,'VALDIV',1,'MIRC0000368','UFXU',3,14,NULL,NULL UNION  
     
     
   SELECT 01,'VALDIV',1,'DEMX','DEMX',3,15,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'ESPX','ESPX',3,16,NULL,NULL UNION--  
   SELECT 01,'VALDIV',1,'BEFX','BEFX',3,17,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'ITLX','ITLX',3,18,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'UFXU','MIRC0000338',3,19,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ATSX','ATSX',3,20,NULL,NULL UNION--OK  
     
   SELECT 01,'VALDIV',1,'UFXU','MIRC0000303',3,21,NULL,NULL UNION--  
   SELECT 01,'VALDIV',1,'UFXU','MIRC0000350',3,22,NULL,NULL UNION--  
   SELECT 01,'VALDIV',1,'UFXU',' MIRC0000301',3,23,NULL,NULL UNION--  
   SELECT 01,'VALDIV',1,'MIRC0000378','UFXU',3,24,NULL,NULL UNION--  
     
     
   SELECT 01,'VALDIV',1,'UFXU','UFXU',3,25,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'UFXU','UFXU',3,26,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,27,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,28,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,29,NULL,NULL UNION--OK  
   SELECT 01,'VALDIV',1,'PLATA','PLATA',3,30,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'ORO','ORO',3,31,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'PLATA','PLATA',3,32,NULL,NULL UNION  
     
   SELECT 01,'VALDIV',1,'UFXU','MIRC0000305',3,33,NULL,NULL UNION  
   SELECT 01,'VALDIV',1,'MIRC0000294','UFXU',3,34,NULL,NULL UNION  
     
   SELECT 01,'VALDIV',1,'UFXU','MIRC0023388',3,35,NULL,NULL  
    
 UPDATE @tblDirectives  
 SET txtValue = (SELECT LTRIM(STR(dblValue,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC    
 WHERE dteDate = @txtDate AND txtIRC = txtSource)  
   
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(dblValue,15,5)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (14)  
   
 UPDATE @tblDirectives  
   
 SET txtValue =   
  (   SELECT LTRIM(STR(1/dblValue,15,5)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (24,34)  
  
   
 UPDATE @tblDirectives  
 SET txtValue =   
  (SELECT LTRIM(STR(dblValue *(1+0.02)* @dblUFXU,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (27)  
   
   
   
 UPDATE @tblDirectives  
 SET txtValue =   
  (   SELECT LTRIM(STR(dblValue * 1.205652 * @dblUFXU /50,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (28)  
   
 UPDATE @tblDirectives  
 SET txtValue =   
  (   SELECT LTRIM(STR(dblValue * @dblUFXU,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
  WHERE intRow IN (29)  
   
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(dblValue * @dblUFXU,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (30)  
   
  UPDATE @tblDirectives  
 SET txtValue =   
 (   SELECT LTRIM(STR(dblValue *0.48227*1.04* @dblUFXU /20,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (31)  
   
  
  UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR((dblValue + 6)* @dblUFXU,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
 WHERE intRow IN (32)  
  
  
/*BORRAMOS VALORES PARA TXTID1*/  
 UPDATE @tblDirectives  
 SET txtvalue = null  
 WHERE txtSource LIKE '%MI%'  
 OR txtCode LIKE '%MI%'  
   
 /*actualizamos valores para TXTID1 */  
   
 UPDATE @tblDirectives  
 SET txtvalue = (  
 SELECT CASE WHEN intRow = 9  THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10))  FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0010951')/@dblUFXU,15,4))   
    WHEN intRow = 10 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000369'),15,4))   
    WHEN intRow = 12 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000312'),15,4))   
    WHEN intRow = 14 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000368'),15,4))   
    WHEN intRow = 19 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000338'),15,4))   
    WHEN intRow = 21 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000303'),15,4))   
    WHEN intRow = 22 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000350'),15,4))   
    WHEN intRow = 23 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000301'),15,4))     
    WHEN intRow = 24 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000378')/@dblUFXU,15,4))   
    WHEN intRow = 33 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000305'),15,4))   
    WHEN intRow = 34 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294')/@dblUFXU,15,4))   
    WHEN intRow = 35 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0023388'),15,4))   
 ELSE txtvalue  
   
 END   
 )  
   
   
   
 --SELECT * FROM @tblDirectives  
   
   
  
/*COLUMNA 2 HOJA 1 */  
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 01,'VALDIV',2,'GBP','GBP',4,5,CONVERT(bigint,CONVERT(datetime,@txtDate+ 2)) UNION   
   SELECT 01,'VALDIV',2,'GBP','GBP',4,9,NULL UNION   
   SELECT 01,'VALDIV',2,'CHF','CHF',4,10,NULL UNION  
   SELECT 01,'VALDIV',2,'FRF','FRF',4,11,NULL UNION  
   SELECT 01,'VALDIV',2,'DKK','DKK',4,12,NULL UNION  
   SELECT 01,'VALDIV',2,'NLG','NLG',4,13,NULL UNION  
     
   SELECT 01,'VALDIV',2,'SEK','SEK',4,14,NULL UNION  
   SELECT 01,'VALDIV',2,'DEM','DEM',4,15,NULL UNION  
   SELECT 01,'VALDIV',2,'ESP','ESP',4,16,NULL UNION  
   SELECT 01,'VALDIV',2,'BEF','BEF',4,17,NULL UNION  
   SELECT 01,'VALDIV',2,'ITL','ITL',4,18,NULL UNION  
     
   SELECT 01,'VALDIV',2,'JPY','JPYX',4,19,NULL UNION  
   SELECT 01,'VALDIV',2,'ATS','ATS',4,20,NULL UNION  
   SELECT 01,'VALDIV',2,'CAD','CAD',4,21,NULL UNION  
   SELECT 01,'VALDIV',2,'NOK','NOK',4,22,NULL UNION  
   SELECT 01,'VALDIV',2,'BRL','BRL',4,23,NULL UNION  
     
   SELECT 01,'VALDIV',2,'EUR','EUR',4,24,NULL UNION   
     
   SELECT 01,'VALDIV',2,'--','--',4,25,'--' UNION  
   SELECT 01,'VALDIV',2,'--','--',4,26,'--' UNION  
   SELECT 01,'VALDIV',2,'--','--',4,27,'PLATA LIBERTAD' UNION   
     
   SELECT 01,'VALDIV',2,'PLATA','ORO',4,28,NULL UNION  
   SELECT 01,'VALDIV',2,'','',4,29,'--' UNION  
   SELECT 01,'VALDIV',2,'PLATA','ORO',4,30,NULL UNION  
   SELECT 01,'VALDIV',2,'PLATA','PLATA',4,31,'--' UNION  
   SELECT 01,'VALDIV',2,'ORO','ORO',4,32,'--' UNION  
   SELECT 01,'VALDIV',2,'CNY','CNY',4,33,NULL UNION  
   SELECT 01,'VALDIV',2,'AUD','AUD',4,34,NULL UNION  
   SELECT 01,'VALDIV',2,'CNH','CNH',4,35,NULL  
   
 --SELECT * FROM @tblDirectives  
  
   
 UPDATE @tblDirectives  
 SET txtValue =   
 (CASE WHEN txtValue IS  NULL  THEN   
 (SELECT  LTRIM(STR( CONVERT(VARCHAR(50),ROUND(dblValue,6,0)),10,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 2)  
  ELSE txtValue END   
  )  
    
UPDATE @tblDirectives  
SET txtValue =   
(SELECT  LTRIM(STR((dblValue + 1.5)* @dblUFXU,15,6))  FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)  
WHERE intSection = 2 AND intRow IN(28,30)  
  
/*BORRAMOS VALORES PREVIOS*/  
  
UPDATE @tblDirectives  
 SET txtvalue = null  
 WHERE   intSection = 2   
 AND intRow IN(9,10,12,14,19,21,22,23,24,33,34,35)  
  
  
 UPDATE @tblDirectives  
 SET txtvalue = (  
 SELECT CASE WHEN intRow = 9  THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0010951'),15,6))   
    WHEN intRow = 10 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000369'),15,6))   
    WHEN intRow = 12 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000312'),15,6))   
    WHEN intRow = 14 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000368'),15,6))   
    WHEN intRow = 19 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000338'),15,6))   
    WHEN intRow = 21 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000303'),15,6))   
    WHEN intRow = 22 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000350'),15,6))   
    WHEN intRow = 23 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000301'),15,6))   
    WHEN intRow = 24 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000378'),15,6))   
    WHEN intRow = 33 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000305'),15,6))   
    WHEN intRow = 34 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294'),15,6))   
    WHEN intRow = 35 THEN  LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0023388'),15,6))   
 ELSE txtvalue  
   
 END   
 )  
 WHERE   intSection = 2   
  
    
  /*COLUMNA 3 HOJA 1 */  
    
    
   
   
   
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 01,'VALDIV',3,'GBPX','GBPX',8,9,NULL UNION   
   SELECT 01,'VALDIV',3,'DEMX','DEMX',8,10,NULL UNION   
   SELECT 01,'VALDIV',3,'JPYX','JPYX',8,11,NULL UNION   
   SELECT 01,'VALDIV',3,'CHFX','CHFX',8,12,NULL UNION   
   SELECT 01,'VALDIV',3,'FRFX','FRFX',8,13,NULL UNION   
   SELECT 01,'VALDIV',3,'CADX','CADX',8,14,NULL UNION   
   SELECT 01,'VALDIV',3,'NLGX','NLGX',8,15,NULL UNION   
   SELECT 01,'VALDIV',3,'SEKX','SEKX',8,16,NULL UNION   
   SELECT 01,'VALDIV',3,'ESPX','ESPX',8,17,NULL UNION   
   SELECT 01,'VALDIV',3,'BEFX','BEFX',8,18,NULL UNION   
   SELECT 01,'VALDIV',3,'ITLX','ITLX',8,19,NULL UNION   
   SELECT 01,'VALDIV',3,'ATSX','ATSX',8,20,NULL UNION   
   SELECT 01,'VALDIV',3,'DKKX','DKKX',8,21,NULL UNION   
   SELECT 01,'VALDIV',3,'NOKX','NOKX',8,22,NULL UNION   
   SELECT 01,'VALDIV',3,'BRLX','BRLX',8,23,NULL UNION  
   SELECT 01,'VALDIV',3,'EURX','EURX',8,24,NULL UNION  
   SELECT 01,'VALDIV',3,'CNYX','CNYX',8,25,NULL  UNION  
   SELECT 01,'VALDIV',3,'AUDX','AUDX',8,26,NULL  UNION  
   SELECT 01,'VALDIV',3,'CNHX','CNHX',8,27,NULL UNION   
   SELECT 01,'VALDIV',3,'PLATA','PLATA',8,28,NULL  UNION  
   SELECT 01,'VALDIV',3,'ORO','ORO',8,29,NULL    
  
UPDATE @tblDirectives  
 SET txtValue =   
 (CASE WHEN txtValue IS  NULL  THEN   
 (SELECT LTRIM(STR(dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection =3)  
  ELSE txtValue END   
  )  
  UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(1/dblValue,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )  
 WHERE intSection = 3 AND  intRow = 24  
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(1/dblValue,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )  
 WHERE intSection = 3 AND  intRow = 26  
   
  
  
  
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
 SELECT 01,'VALDIV',4,'EURX','EURX',8,37,NULL UNION   
 SELECT 01,'VALDIV',4,'EURX','EURX',8,38,NULL    
  
  
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(STR(dblValue * 200.482,15,4)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )  
 WHERE intSection = 4 AND  intRow = 37  
   
 UPDATE @tblDirectives  
 SET txtValue =   
 ( SELECT LTRIM(@dblUFXU /(200.482 * CAST(dblValue AS DECIMAL(32,32)))) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource )  
 WHERE intSection = 4 AND intRow = 38  
   
   
   
   
UPDATE @tblDirectives  
 SET txtvalue = null  
 WHERE   intSection = 3   
 AND intRow IN(9,11,12,14,16,21,22,23,24,25,26,27)  
   
   
  
 UPDATE @tblDirectives  
 SET txtvalue = (  
 SELECT CASE   
    WHEN intRow = 9  THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0010951'),15,4))  
    WHEN intRow = 11 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000338'),15,4))  
    WHEN intRow = 12 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000369'),15,4))  
    WHEN intRow = 14 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000303'),15,4))  
    WHEN intRow = 16 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000368'),15,4))  
    WHEN intRow = 21 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000312'),15,4))  
    WHEN intRow = 22 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000350'),15,4))  
    WHEN intRow = 23 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294'),15,4))  
    WHEN intRow = 24 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000378')/@dblUFXU,15,4))  
    WHEN intRow = 25 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000305'),15,4))  
    WHEN intRow = 26 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294')/@dblUFXU,15,4))  
    WHEN intRow = 27 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0023388'),15,4))  
 ELSE txtvalue  
   
 END   
 )  
 WHERE   intSection = 3   
  
 --SELECT * FROM @tblDirectives  
   
  
  --actualizada a banxico con exito 1 hoja excel       |  
   
 /*  
 --comienzo de suganda pagina en excel   ^  
 */  
   
  
  
   
   
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 2,'DIV X DLR',5,'UFXU','UFXU',4,8,NULL  UNION   
   SELECT 2,'DIV X DLR',5,'1','1',4,9,1  UNION     
   SELECT 2,'DIV X DLR',5,'GBPX','GBPX',4,10,NULL UNION   
   SELECT 2,'DIV X DLR',5,'CHFX','CHFX',4,11,NULL UNION   
   SELECT 2,'DIV X DLR',5,'FRFX','FRFX',4,12,NULL  UNION   
     
   SELECT 2,'DIV X DLR',5,'DKKX','DKKX',4,13,NULL UNION     
   SELECT 2,'DIV X DLR',5,'NLGX','NLGX',4,14,NULL UNION   
   SELECT 2,'DIV X DLR',5,'SEKX','NOKX',4,15,NULL UNION    
   SELECT 2,'DIV X DLR',5,'DEMX','DEMX',4,16,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ESPX','ESPX',4,17,NULL UNION   
     
       
   SELECT 2,'DIV X DLR',5,'BEFX','BEFX',4,18,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ITLX','ITLX',4,19,NULL UNION    
   SELECT 2,'DIV X DLR',5,'JPYX','JPYX',4,20,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ATSX','ATSX',4,21,NULL UNION     
   SELECT 2,'DIV X DLR',5,'CADX','CADX',4,22,NULL UNION   
     
   SELECT 2,'DIV X DLR',5,'NOKX','NOKX',4,23,NULL UNION    
   SELECT 2,'DIV X DLR',5,'BRLX','BRLX',4,24,NULL UNION   
   SELECT 2,'DIV X DLR',5,'ORO1','DEMX',4,25,NULL UNION   --  
      SELECT 2,'DIV X DLR',5,'PTE','PTE',4,26,NULL UNION   
      SELECT 2,'DIV X DLR',5,'UFXU/(PLATA1*2)','DEMX',4,27,NULL UNION  --  
      SELECT 2,'DIV X DLR',5,'ORO2/UFXU','GBPX',4,28,NULL UNION   
   SELECT 2,'DIV X DLR',5,'UFXU/PLATA1','DEMX',4,29,NULL   
     
     
    
  
 UPDATE @tblDirectives  
 SET txtValue =   
 (CASE WHEN txtValue IS  NULL  THEN   
 (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 5)  
  ELSE txtValue END   
  )  
    
  UPDATE @tblDirectives  
  SET txtValue = STR(1/(@ORO1/@dblUFXU),15,6)  
  WHERE intSection = 5 AND intRow = 25  
   
  UPDATE @tblDirectives  
  SET txtValue = STR(@dblUFXU/(@PLATA1*2),15,6)  
  WHERE intSection = 5 AND intRow = 27  
   
 /*update made UFXU / ORO2*/  
  UPDATE @tblDirectives  
  SET txtValue = STR(@dblUFXU/@ORO2,15,6)  
  WHERE intSection = 5 AND intRow = 28  
   
 UPDATE @tblDirectives  
  SET txtValue = STR(@dblUFXU / @PLATA1,15,6)  
  WHERE intSection = 5 AND intRow = 29  
   
  
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 2,'DIV X DLR',5,'(2*UFXU)/ORO2','GBPX',4,30,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(4*UFXU)/ORO2','DEMX',4,31,NULL UNION    
   SELECT 2,'DIV X DLR',5,'(10*UFXU)/ORO2','GBPX',4,32,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(20*UFXU)/ORO2','DEMX',4,33,NULL UNION  --  
   SELECT 2,'DIV X DLR',5,'(1.635*UFXU)/PLATA1','GBPX',4,34,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(3.5*UFXU)/PLATA1','DEMX',4,35,NULL UNION    
   SELECT 2,'DIV X DLR',5,'(6*UFXU)/PLATA1','GBPX',4,36,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(9*UFXU)/PLATA1','DEMX',4,37,NULL UNION --5  
   SELECT 2,'DIV X DLR',5,'ORO2/UFXU','GBPX',4,38,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(2*UFXU)/ORO2','DEMX',4,39,NULL UNION    
   SELECT 2,'DIV X DLR',5,'(4*UFXU)/ORO2','GBPX',4,40,NULL UNION   
   SELECT 2,'DIV X DLR',5,'UFXU/PLATA1','DEMX',4,41,NULL UNION ---  
   SELECT 2,'DIV X DLR',5,'(1.635*@dblUFXU)/@PLATA1','GBPX',4,42,NULL UNION   
   SELECT 2,'DIV X DLR',5,'(3.5 * @dblUFXU)/@PLATA1','DEMX',4,43,NULL UNION    
   SELECT 2,'DIV X DLR',5,'@dblUFXU/@PLATA2','GBPX',4,44,NULL UNION   
   SELECT 2,'DIV X DLR',5,'@dblUFXU/@PLATA2','DEMX',4,45,NULL UNION  
   SELECT 2,'DIV X DLR',5,'1/@ORO','DEMX',4,46,NULL  UNION ---  
   SELECT 2,'DIV X DLR',5,'1/PLATA','GBPX',4,47,NULL UNION   
   SELECT 2,'DIV X DLR',5,'@dblUFXU/ORO3','DEMX',4,48,NULL UNION    
   SELECT 2,'DIV X DLR',5,'@dblUFXU','GBPX',4,49,NULL UNION   
   SELECT 2,'DIV X DLR',5,'EURX','DEMX',4,50,NULL UNION  
   SELECT 2,'DIV X DLR',5,'1/(PLATA+6)','DEMX',4,51,NULL  UNION ---  
   SELECT 2,'DIV X DLR',5,'CLPX','GBPX',4,52,NULL UNION   
   SELECT 2,'DIV X DLR',5,'CLF/UFXU','DEMX',4,53,NULL UNION    
   SELECT 2,'DIV X DLR',5,'CNYX','GBPX',4,54,NULL UNION   
   SELECT 2,'DIV X DLR',5,'1/AUDX','DEMX',4,55,NULL UNION  
   SELECT 2,'DIV X DLR',5,'CNHX','DEMX',4,56,NULL    
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (2*@dblUFXU)/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 30  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (4*@dblUFXU)/@ORO2 ,15,6)  
   WHERE intSection = 5 AND intRow = 31  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (10*@dblUFXU)/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 32  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (20*@dblUFXU)/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 33  
  
   UPDATE @tblDirectives  
   SET txtValue = STR((1.635*@dblUFXU)/@PLATA1  ,15,6)  
   WHERE intSection = 5 AND intRow = 34  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (3.5*@dblUFXU)/@PLATA1  ,15,6)  
   WHERE intSection = 5 AND intRow = 35  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (6*@dblUFXU)/@PLATA1 ,15,6)  
   WHERE intSection = 5 AND intRow = 36  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (9*@dblUFXU)/@PLATA1,15,6)  
   WHERE intSection = 5 AND intRow = 37  
 ----  
 /*update made UFXU / ORO2*/  
  UPDATE @tblDirectives  
   SET txtValue = STR(@dblUFXU/@ORO2,15,6)  
   WHERE intSection = 5 AND intRow = 38  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (2*@dblUFXU)/@ORO2 ,15,6)  
   WHERE intSection = 5 AND intRow = 39  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (4*@dblUFXU)/@ORO2 ,15,6)  
   WHERE intSection = 5 AND intRow = 40  
     
  UPDATE @tblDirectives  
   SET txtValue = STR(@dblUFXU/@PLATA1,15,6)  
   WHERE intSection = 5 AND intRow = 41  
   --  
  UPDATE @tblDirectives  
   SET txtValue = STR((1.635*@dblUFXU)/@PLATA1 ,15,6)  
   WHERE intSection = 5 AND intRow = 42  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (3.5 * @dblUFXU)/@PLATA1 ,15,6)  
   WHERE intSection = 5 AND intRow = 43  --PLATA PRECOL. 1/4 ONZA  
  
  UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU/@PLATA2,15,6)  
   WHERE intSection = 5 AND intRow = 44  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU/@PLATA2,15,6)  
   WHERE intSection = 5 AND intRow = 45  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )  
   WHERE intSection = 5 AND intRow = 46  
 ---  
   
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 5 AND intRow = 47  
     
     
   --------------  
    UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU/@ORO3,15,6)  
   WHERE intSection = 5 AND intRow = 48  --ORO CHICO  
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @dblUFXU,15,6)  
   WHERE intSection = 5 AND intRow = 49    
     
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )  
  -- WHERE intSection = 5 AND intRow = 50  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(1 / (dblValue + 6 ) ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 5 AND intRow = 51  
     
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLPX' )  
  -- WHERE intSection = 5 AND intRow = 52  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(dblValue/@dblUFXU,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )  
   WHERE intSection = 5 AND intRow = 53  
     
      
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNYX' )  
  -- WHERE intSection = 5 AND intRow = 54  
     
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'AUDX' )  
  -- WHERE intSection = 5 AND intRow = 55  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNHX' )  
  -- WHERE intSection = 5 AND intRow = 56  
     
     
     
     
      
UPDATE @tblDirectives  
 SET txtvalue = null  
 WHERE   intSection = 5   
 AND intRow IN(10,11,13,15,20,22,23,24,50,52,54,55,56)  
   
   
  
 UPDATE @tblDirectives  
 SET txtvalue = (  
 SELECT CASE   
    WHEN intRow = 10 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0010951'),15,6))  
    WHEN intRow = 11 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000369'),15,6))  
    WHEN intRow = 13 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000312'),15,6))  
    WHEN intRow = 15 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000368'),15,6))  
    WHEN intRow = 20 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000338'),15,6))  
    WHEN intRow = 22 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000303'),15,6))  
    WHEN intRow = 23 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000350'),15,6))  
    WHEN intRow = 24 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000301'),15,6))  
    WHEN intRow = 50 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000378'),15,6))  
    WHEN intRow = 52 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000304'),15,6))  
    WHEN intRow = 54 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000305'),15,6))  
    WHEN intRow = 55 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294')/@dblUFXU,15,6))  
    WHEN intRow = 56 THEN LTRIM(STR(@dblUFXU/(SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0023388'),15,6))  
 ELSE txtvalue  
   
 END   
 )  
 WHERE   intSection = 5   
     
  
  
     
   /*  
   COLUMNA 3 HOJA 2   
   */  
    INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
   SELECT 2,'DIV X DLR',6,'1','1',5,8,1  UNION   
   SELECT 2,'DIV X DLR',6,'UFXU','UFXU',5,9,NULL   UNION     
   SELECT 2,'DIV X DLR',6,'GBP','GBP',5,10,NULL UNION   
   SELECT 2,'DIV X DLR',6,'CHF','CHF',5,11,NULL UNION   
   SELECT 2,'DIV X DLR',6,'FRF','FRF',5,12,NULL  UNION   
   SELECT 2,'DIV X DLR',6,'DKK','DKK',5,13,NULL UNION     
   SELECT 2,'DIV X DLR',6,'NLG','NLG',5,14,NULL UNION   
   SELECT 2,'DIV X DLR',6,'SEK','SEK',5,15,NULL UNION    
   SELECT 2,'DIV X DLR',6,'DEM','SEKX',5,16,NULL UNION   
   SELECT 2,'DIV X DLR',6,'ESP','ESP',5,17,NULL UNION   
   SELECT 2,'DIV X DLR',6,'BEF','BEF',5,18,NULL UNION   
   SELECT 2,'DIV X DLR',6,'ITL','ITL',5,19,NULL UNION    
   SELECT 2,'DIV X DLR',6,'JPY','JPY',5,20,NULL UNION   
   SELECT 2,'DIV X DLR',6,'ATS','ATS',5,21,NULL UNION     
   SELECT 2,'DIV X DLR',6,'CAD','CAD',5,22,NULL  UNION   
     
   SELECT 2,'DIV X DLR',6,'NOK','NOK',5,23,null UNION   
   SELECT 2,'DIV X DLR',6,'BRL','BRL',5,24,NULL UNION    
   SELECT 2,'DIV X DLR',6,'JPY','JPY',5,25,NULL  UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,26,NULL  UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,27,NULL UNION --ERROR DECIMALES  
     
   SELECT 2,'DIV X DLR',6,'--','--',5,28,@ORO2 UNION   
   SELECT 2,'DIV X DLR',6,'--','---',5,29,STR(@PLATA1,15,6)  UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,30,STR(@ORO2/2,15,6)   UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,31,STR(@ORO2/4,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,32,STR(@ORO2/10,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,33,STR(@ORO2/20,15,6) UNION   
     
     
   SELECT 2,'DIV X DLR',6,'ATS','---',5,34,STR(@PLATA1/1.635,15,6)  UNION    
   SELECT 2,'DIV X DLR',6,'ATS','--',5,35,STR(@PLATA1/3.5,15,6)   UNION   
   SELECT 2,'DIV X DLR',6,'ATS','--',5,36,STR(@PLATA1/6,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'ATS','--',5,37,STR(@PLATA1/9,15,6)     UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,38,STR(@ORO2,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,39,STR(@ORO2/2,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,40,STR(@ORO2/4,15,6) UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,41,STR(@PLATA1,15,6)  UNION   
   SELECT 2,'DIV X DLR',6,'ATS','--',5,42,STR(@PLATA1/ 1.635,15,6)     UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,43,STR(@PLATA1/3.5,15,6)    UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,44,STR(@PLATA2,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,45,STR(@PLATA2,15,6) UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,46,NULL   UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,47,STR(@PLATA1,15,6) UNION  
   SELECT 2,'DIV X DLR',6,'--','--',5,48,STR(@ORO3,15,6) UNION    
     
     
   SELECT 2,'DIV X DLR',6,'-1','-1',5,49,1   UNION     
   SELECT 2,'DIV X DLR',6,'EUR','EUR',5,50,NULL   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,51,NULL UNION   
   SELECT 2,'DIV X DLR',6,'--','--',5,52,NULL   UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,53,STR(@PLATA1,15,6)  UNION   
     
   SELECT 2,'DIV X DLR',6,'CNY','CNY',5,54,NULL UNION   
   SELECT 2,'DIV X DLR',6,'AUD','AUD',5,55,NULL   UNION    
   SELECT 2,'DIV X DLR',6,'CNH','CNH',5,56,NULL   
    
    
    
     
 UPDATE @tblDirectives  
  SET txtValue =   
  (CASE WHEN txtValue IS  NULL  THEN   
  (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 6)  
   ELSE txtValue END   
   )  
     
     
     
   UPDATE @tblDirectives  
   SET txtValue = STR( round(@ORO1,6,0),10,6)   
   WHERE intSection = 6 AND intRow = 25  
     
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( @dblUFXU/dblValue,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PTE' )  
   WHERE intSection = 6 AND intRow = 26  
     
  UPDATE @tblDirectives  
   SET txtValue =STR( round(@PLATA1*2 ,6,0),10,6)             
   WHERE intSection = 6 AND intRow = 27    
  
  
 UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue * @dblUFXU,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )  
   WHERE intSection = 6 AND intRow = 46  
     
 UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue * @dblUFXU,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 6 AND intRow = 47  
  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( (dblValue+6) * @dblUFXU ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 6 AND intRow = 51  
  
  
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR( dblValue * @dblUFXU ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLP' )  
  -- WHERE intSection = 6 AND intRow = 52  
  
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( @dblUFXU / dblValue ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )  
   WHERE intSection = 6 AND intRow = 53  
  
  
  
      
UPDATE @tblDirectives  
 SET txtvalue = null  
 WHERE   intSection = 6   
 AND intRow IN(10,11,13,15,20,22,23,24,50,52,54,55,56)  
   
   
  
  
 UPDATE @tblDirectives  
 SET txtvalue = (  
 SELECT CASE   
    WHEN intRow = 10 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0010951'),15,6))  
    WHEN intRow = 11 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000369'),15,6))  
    WHEN intRow = 13 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000312'),15,6))  
    WHEN intRow = 15 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000368'),15,6))  
    WHEN intRow = 20 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000338'),15,6))  
    WHEN intRow = 22 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000303'),15,6))  
    WHEN intRow = 23 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000350'),15,6))  
    WHEN intRow = 24 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000301'),15,6))  
    WHEN intRow = 50 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000378'),15,6))  
      
    WHEN intRow = 52 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000304')*@dblUFXU,15,6))  
      
      
    WHEN intRow = 54 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000305'),15,6))  
    WHEN intRow = 55 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294'),15,6))  
    WHEN intRow = 56 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0023388'),15,6))  
 ELSE txtvalue  
   
 END   
 )  
 WHERE   intSection = 6   
     
  
      
  
/*  
columna 3 sheet2  
*/  
  
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
  
   SELECT 2,'DIV X DLR',7,'Int','Int',6,4,CONVERT(bigint,CONVERT(datetime,@txtDate+2))  UNION   
   SELECT 2,'DIV X DLR',7,'UFXU','UFXU',6,8,NULL  UNION   
   SELECT 2,'DIV X DLR',7,'1','1',6,9,1   UNION    
   SELECT 2,'DIV X DLR',7,'GBX','GBX',6,10,NULL   UNION    
   SELECT 2,'DIV X DLR',7,'CHF','CHF',6,11,NULL UNION   
   SELECT 2,'DIV X DLR',7,'FRF','FRF',6,12,NULL UNION  
   SELECT 2,'DIV X DLR',7,'DKK','DKK',6,13,NULL UNION   
     
   SELECT 2,'DIV X DLR',7,'NLG','NLG',6,14,NULL UNION   
   SELECT 2,'DIV X DLR',7,'NOK','NOK',6,15,NULL UNION  
   SELECT 2,'DIV X DLR',7,'DEM','DEM',6,16,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ESP','ESP',6,17,NULL UNION   
   SELECT 2,'DIV X DLR',7,'BEF','BEF',6,18,NULL UNION  
   SELECT 2,'DIV X DLR',7,'ITL','ITL',6,19,NULL UNION  
   SELECT 2,'DIV X DLR',7,' JPY',' JPY',6,20,NULL UNION  
     
   SELECT 2,'DIV X DLR',7,'ATS','ATS',6,21,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CAD','CAD',6,22,NULL UNION   
   SELECT 2,'DIV X DLR',7,'NOK','NOK',6,23,NULL UNION  
   SELECT 2,'DIV X DLR',7,'BRLX','BRLX',6,24,NULL UNION   
   -----  
   SELECT 2,'DIV X DLR',7,'@ORO1/@UFXU','@ORO1/@UFXU',6,25,NULL  UNION   
   SELECT 2,'DIV X DLR',7,'1/PTE','1/PTE',6,26,NULL  UNION   
   SELECT 2,'DIV X DLR',7,'--','--',6,27,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@UFXU/@ORO2','--',6,28,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@PLATA1/@UFXU','--',6,29,NULL  UNION   
     
   SELECT 2,'DIV X DLR',7,'ORO2/(2*@dblUFXU)','--',6,30,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ORO2/(4*@dblUFXU)','--',6,31,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ORO2/(10*@dblUFXU)','--',6,32,NULL UNION  
   SELECT 2,'DIV X DLR',7,'ORO2/(20*@dblUFXU)','--',6,33,NULL UNION   
   SELECT 2,'DIV X DLR',7,'PLATA1/(1.635*@dblUFXU)','--',6,34,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(3.5 *@dblUFXU)','--',6,35,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(6*@dblUFXU)','--',6,36,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(9*@dblUFXU)','--',6,37,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@dblUFXU/@ORO2','--',6,38,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@ORO2/(2*@dblUFXU)','--',6,39,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@ORO2/(4*@dblUFXU)','--',6,40,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/@dblUFXU','--',6,41,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA1/(1.635*@dblUFXU)','--',6,42,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@PLATA1/(3.5*@dblUFXU)','--',6,43,NULL UNION   
   SELECT 2,'DIV X DLR',7,'@PLATA2/@dblUFXU','--',6,44,NULL UNION   
     
  
   SELECT 2,'DIV X DLR',7,'@PLATA2/@dblUFXU','--',6,45,NULL UNION   
   SELECT 2,'DIV X DLR',7,'ORO','--',6,46,NULL UNION   
   SELECT 2,'DIV X DLR',7,'PLATA','--',6,47,NULL UNION  
   SELECT 2,'DIV X DLR',7,'ORO3/@dblUFXU','--',6,48,NULL UNION   
   SELECT 2,'DIV X DLR',7,'1','1',6,49,1 UNION   
   SELECT 2,'DIV X DLR',7,'1/EURX','--',6,50,NULL UNION   
   SELECT 2,'DIV X DLR',7,'PLATA+6','--',6,51,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CLP','--',6,52,NULL UNION  
   SELECT 2,'DIV X DLR',7,'@dblUFXU/CLF','--',6,53,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CNY/@dblUFXU','--',6,54,NULL union  
   SELECT 2,'DIV X DLR',7,'AUDX','--',6,55,NULL UNION   
   SELECT 2,'DIV X DLR',7,'CNH / @dblUFXU','--',6,56,NULL   
------  
  
  
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'UFXU' )  
   WHERE intSection = 7 AND intRow = 8  
    
    
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'GBPX' )  
  -- WHERE intSection = 7 AND intRow = 10  
     
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CHFX' )  
  -- WHERE intSection = 7 AND intRow = 11  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'FRFX' )  
   WHERE intSection = 7 AND intRow = 12  
     
   -- UPDATE @tblDirectives  
   --SET txtValue =   
   --( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'DKKX' )  
   --WHERE intSection = 7 AND intRow = 13  
     
   --  
   UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'NLGX' )  
   WHERE intSection = 7 AND intRow = 14  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'SEKX' )  
  -- WHERE intSection = 7 AND intRow = 15  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'DEMX' )  
   WHERE intSection = 7 AND intRow = 16  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ESPX' )  
   WHERE intSection = 7 AND intRow = 17  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'BEFX' )  
   WHERE intSection = 7 AND intRow = 18  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ITLX' )  
   WHERE intSection = 7 AND intRow = 19  
     
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'JPYX' )  
  -- WHERE intSection = 7 AND intRow = 20  
     
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ATSX' )  
   WHERE intSection = 7 AND intRow = 21  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CADX' )  
  -- WHERE intSection = 7 AND intRow = 22  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'NOKX' )  
  -- WHERE intSection = 7 AND intRow = 23  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'BRLX' )  
  -- WHERE intSection = 7 AND intRow = 24  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO1/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 25    
        
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PTE' )  
   WHERE intSection = 7 AND intRow = 26  
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( (@PLATA1*2)/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 27    
     
   /*UPDATED VALUE ORO2 / UFXU*/  
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 28    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 29    
   ----------  
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(2*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 30    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(4*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 31    
        
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(10*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 32   
      
  UPDATE @tblDirectives  
   SET txtValue = STR(@ORO2/(20*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 33    
  
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(1.635*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 34    
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(3.5 *@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 35    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(6*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 36    
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(9*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 37    
   ----------  
     
   /*UPDATED VALUE ORO2 / UFXU*/  
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 38    
     
     
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(2*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 39    
        
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO2/(4*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 40   
      
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 41    
  
  UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(1.635*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 42    
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA1/(3.5*@dblUFXU),15,6)  
   WHERE intSection = 7 AND intRow = 43    
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 44    
     
   UPDATE @tblDirectives  
   SET txtValue = STR( @PLATA2/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 45   
        
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )  
   WHERE intSection = 7 AND intRow = 46  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 7 AND intRow = 47  
     
  UPDATE @tblDirectives  
   SET txtValue = STR( @ORO3/@dblUFXU,15,6)  
   WHERE intSection = 7 AND intRow = 48  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )  
   WHERE intSection = 7 AND intRow = 50  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( dblValue +6  ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )  
   WHERE intSection = 7 AND intRow = 51  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR( dblValue ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLP' )  
  -- WHERE intSection = 7 AND intRow = 52  
     
  UPDATE @tblDirectives  
   SET txtValue =   
   ( SELECT LTRIM(STR( @dblUFXU /dblValue ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )  
   WHERE intSection = 7 AND intRow = 53  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR(dblValue/@dblUFXU ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNY' )  
  -- WHERE intSection = 7 AND intRow = 54  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR( dblValue ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'AUDX' )  
  -- WHERE intSection = 7 AND intRow = 55  
     
  --UPDATE @tblDirectives  
  -- SET txtValue =   
  -- ( SELECT LTRIM(STR( dblValue/ @dblUFXU ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNH' )  
  -- WHERE intSection = 7 AND intRow = 56  
  
     
  
UPDATE @tblDirectives  
 SET txtvalue = null  
 WHERE   intSection = 7   
 AND intRow IN(10,11,13,15,20,22,23,24,50,52,54,55,56)  
   
   
  
  
 UPDATE @tblDirectives  
 SET txtvalue = (  
 SELECT CASE   
  WHEN intRow = 10 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0010951')/@dblUFXU,15,6))   
  WHEN intRow = 11 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000369')/@dblUFXU,15,6))   
  WHEN intRow = 13 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000312')/@dblUFXU,15,6))   
  WHEN intRow = 15 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000368')/@dblUFXU,15,6))   
  WHEN intRow = 20 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000338')/@dblUFXU,15,6))   
  WHEN intRow = 22 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000303')/@dblUFXU,15,6))   
  WHEN intRow = 23 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000350')/@dblUFXU,15,6))  
  WHEN intRow = 24 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000301')/@dblUFXU,15,6))   
  WHEN intRow = 50 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000378')/@dblUFXU,15,6))  
  WHEN intRow = 52 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000304'),15,6))  
  WHEN intRow = 54 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000305')/@dblUFXU,15,6))   
  WHEN intRow = 55 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294'),15,6))   
  WHEN intRow = 56 THEN LTRIM(STR((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0023388')/@dblUFXU,15,6))   
   
 ELSE txtvalue  
 END   
 )  
 WHERE   intSection = 7   
     
     
  
/*  
sheet 3 colomna 1  
*/  
  
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)    
     
     
   SELECT 3,'Mesa de Control',8,'Int','Int',4,6,CONVERT(bigint,CONVERT(datetime,@txtDate+2)) UNION    
     
     
   SELECT 3,'Mesa de Control',8,'UFXU','UFXU',4,9,null  UNION    
   SELECT 3,'Mesa de Control',8,'1/GBPX','1/GBPX',4,10,NULL    UNION --  
   SELECT 3,'Mesa de Control',8,'CHFX','CHFX',4,11,NULL    UNION    
   SELECT 3,'Mesa de Control',8,'FRFX','FRFX',4,12,NULL    UNION   
     
   SELECT 3,'Mesa de Control',8,'DKKX','DKKX',4,13,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'NLGX','NLGX',4,14,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'SEKX','SEKX',4,15,NULL UNION   
     
   SELECT 3,'Mesa de Control',8,'DEMX','DEMX',4,16,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'ESPX','ESPX',4,17,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'BEFX','BEFX',4,18,NULL UNION   
     
   SELECT 3,'Mesa de Control',8,'ITLX','ITLX',4,19,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'JPYX','JPYX',4,20,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'ATSX','ATSX',4,21,NULL  UNION   
     
     
   SELECT 3,'Mesa de Control',8,'CADX','CADX',4,22,NULL UNION   
   SELECT 3,'Mesa de Control',8,'NOKX','NOKX',4,23,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'BRLX','BRLX',4,24,NULL  UNION    
   SELECT 3,'Mesa de Control',8,'1/EURX','1/EURX',4,25,NULL  UNION--  
   SELECT 3,'Mesa de Control',8,'AUDX','AUDX',4,26,NULL   
  
    
    
 UPDATE @tblDirectives  
  SET txtValue =   
  (CASE WHEN txtValue IS  NULL  THEN   
  (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 8)  
   ELSE txtValue END   
   )  
     
     
   --UPDATE @tblDirectives  
   --SET txtValue =   
   --( SELECT LTRIM(STR( 1/dblValue ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'GBPX' )  
   --WHERE intSection = 8 AND intRow = 10 --1/GBPX  
     
   -- UPDATE @tblDirectives  
   --SET txtValue =   
   --( SELECT LTRIM(STR( 1/dblValue ,15,6)) FROM PIPMXSQL.MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )  
   --WHERE intSection = 8 AND intRow = 25 --1/EURX  
     
     
     
     
   UPDATE @tblDirectives  
 SET txtvalue = (  
 SELECT CASE   
  WHEN intRow = 10 THEN LTRIM(STR(((SELECT dblValue FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0010951')/@dblUFXU),15,6))   
  WHEN intRow = 11 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000369'),15,6))  
  WHEN intRow = 13 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000312'),15,6))    
  WHEN intRow = 15 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000368'),15,6))   
  WHEN intRow = 20 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000338'),15,6))    
  WHEN intRow = 22 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000303'),15,6))    
  WHEN intRow = 23 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000350'),15,6))    
  WHEN intRow = 24 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000301'),15,6))    
  WHEN intRow = 25 THEN LTRIM(STR(((SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000378')/@dblUFXU),15,6))  
  WHEN intRow = 26 THEN LTRIM(STR(@dblUFXU / (SELECT CAST(dblValue AS DECIMAL (18,10)) FROM @TempGetHistPrices WHERE txtid1 = 'MIRC0000294'),15,6))    
    
 ELSE txtvalue  
 END   
 )  
 WHERE   intSection = 8   
     
   
  
     
     
     
/*REPORTAMOS CONSULTA*/  
  
  SELECT    
    LTRIM(STR(indSheet)) AS [indSheet],    
    RTRIM(SheetName) AS [SheetName]    
    FROM @tblDirectives    
    GROUP BY     
    indSheet,SheetName    
    ORDER BY     
    indSheet,SheetName    
    
    -- regreso los limites    
   SELECT    
    intSection,    
    MIN(intCol) AS intMinCol,    
    MAX(intCol) AS intMaxCol,    
    MIN(intRow) AS intMinRow,    
    MAX(intRow) AS intMaxRow,    
    indSheet    
    FROM @tblDirectives    
    GROUP BY     
    indSheet,intSection    
    ORDER BY     
    indSheet,intSection    
    
   -- regreso las directivas    
   SELECT    
    LTRIM(STR(intSection)) AS [intSection],    
    LTRIM(STR(indSheet)) AS [indSheet],    
    intCol AS [intCol],    
    intRow AS [intRow],    
    RTRIM(txtValue) AS [txtValue]    
   FROM @tblDirectives    
   ORDER BY     
    intSection,    
    indSheet,    
    intCol,    
    intRow    
  
     
      
    
  /*FIN DE SP*/  
END  
SET NOCOUNT OFF  
  
  
    
-----------------------------------------------------------------------------------------------------    
-- Autor:      Mike Ramirez    
-- Fecha:      15/07/2014  10:03 am    
-- Descripcion Modulo 25:     Se migra el producto  tasaspipbital[YYYYMMDD].csv a la clase generica    
-----------------------------------------------------------------------------------------------------    
CREATE  PROCEDURE dbo.sp_productos_BITAL;25    
 @txtDate AS VARCHAR(10)    
     
AS     
BEGIN    
    
 SET NOCOUNT ON    
    
  DECLARE @tmp_CurvesAS TABLE (    
   [intIndex][INT],    
   [txtUniv][VARCHAR](8000)    
   )    
    
  -- Valida la información     
  IF (SELECT     
           COUNT(DISTINCT(txtSubtype))     
      FROM tblCurves     
      WHERE     
    txtType = 'FTC'     
    AND txtSubtype IN ('BRL','CAD','EUR','GBP','JPY')     
    AND dteDate = @txtDate) <> 5    
    
   RAISERROR ('ERROR: Falta Informacion', 16, 1)    
    
  ELSE    
   BEGIN    
    
    -- Se carga la curva Tipo de Cambio Forward Real Brasilenio    
    INSERT @tmp_CurvesAS (intIndex,txtUniv)    
     SELECT     
      1,    
      '"' + @txtDate + '","' + 'FTC-BRL"' + ',' + LTRIM(RTRIM(STR(intTerm))) + ',' + LTRIM(RTRIM(STR(ROUND(dblRate,9),14,9)))    
     FROM dbo.fun_get_curve_complete(@txtDate,'FTC','BRL')    
     ORDER BY intTerm    
    
    -- Se carga la curva Tipo de Cambio Forward Dolar Canadiense    
    INSERT @tmp_CurvesAS (intIndex,txtUniv)    
     SELECT     
      2,    
      '"' + @txtDate + '","' + 'FTC-CAD"' + ',' + LTRIM(RTRIM(STR(intTerm))) + ',' + LTRIM(RTRIM(STR(ROUND(dblRate,9),14,9)))    
     FROM dbo.fun_get_curve_complete(@txtDate,'FTC','CAD')    
     ORDER BY intTerm    
    
    -- Se carga la curva Tipo de Cambio Forward Euro    
    INSERT @tmp_CurvesAS (intIndex,txtUniv)    
     SELECT    
      3,    
      '"' + @txtDate + '","' + 'FTC-EUR"' + ',' + LTRIM(RTRIM(STR(intTerm))) + ',' + LTRIM(RTRIM(STR(ROUND(dblRate,9),14,9)))    
     FROM dbo.fun_get_curve_complete(@txtDate,'FTC','EUR')    
     ORDER BY intTerm    
    
    -- Se carga la curva Tipo de Cambio Forward Libra Esterlina    
    INSERT @tmp_CurvesAS (intIndex,txtUniv)    
     SELECT     
      4,    
      '"' + @txtDate + '","' + 'FTC-GBP"' + ',' + LTRIM(RTRIM(STR(intTerm))) + ',' + LTRIM(RTRIM(STR(ROUND(dblRate,9),14,9)))    
     FROM dbo.fun_get_curve_complete(@txtDate,'FTC','GBP')    
     ORDER BY intTerm    
    
    -- Se carga la curva Tipo de Cambio Forward Yen Japones    
    INSERT @tmp_CurvesAS (intIndex,txtUniv)    
     SELECT     
      5,    
      '"' + @txtDate + '","' + 'FTC-JPY"' + ',' + LTRIM(RTRIM(STR(intTerm))) + ',' + LTRIM(RTRIM(STR(ROUND(dblRate,9),14,9)))    
     FROM dbo.fun_get_curve_complete(@txtDate,'FTC','JPY')    
     WHERE    
      intTerm <= 4000    
     ORDER BY intTerm    
    
    -- Se carga el ultimo registro    
    INSERT @tmp_CurvesAS (intIndex,txtUniv)    
     SELECT     
      6,    
      '"99999999","000-000","0","0"'    
      
    -- Reportamos Resultado    
     SELECT    
      txtUniv    
     FROM @tmp_CurvesAS    
   END    
    
 SET NOCOUNT OFF     
     
END    
  