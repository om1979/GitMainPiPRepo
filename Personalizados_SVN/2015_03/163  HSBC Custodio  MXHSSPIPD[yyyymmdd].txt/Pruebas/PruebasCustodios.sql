

--select * from tblActiveX where txtProceso like '%MXHSSPIPD%'


--select * from tblProcesos
--where txtProducto = 'HSBC_VECTOR_MXHSSPIPD'


--sp_productos_BITAL ;4 '20150325','MD'

  
--   Modificado por: Lic. René López Salinas    
--   Modificacion: 01:41 p.m. 2010-10-14    
--   Descripcion:     Modulo 4: Excluir del archivo el siguiente instrumento ID1: UIRC0008070    






--CREATE  PROCEDURE dbo.sp_productos_BITAL;4  
declare   
  @txtDate AS VARCHAR(10) = '20150325',    
  @txtLiquidation AS VARCHAR(3)    = 'MD'
    
    --,'MD'
--AS       
--BEGIN      
    
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
 DECLARE @txtIrcUSDvalue AS CHAR(20)  
 DECLARE @txtIrcEURvalue AS CHAR(20)  
    
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

--OBTENEMOS TIPO DE CAMBIO DEK DIA USD
SET @txtIrcUSDvalue = (select dblValue from tblirc where txtirc = 'UFXU' and dteDate = @txtDate)
SET @txtIrcEURvalue = (select dblValue from tblirc where txtirc = 'EUR' and dteDate = @txtDate)
     
    
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
 INSERT @tmp_tblEspecialFixedSecurities 


 SELECT txtId1,txtId2,txtEmisora,MxFixIncome.dbo.fun_GetLastItemPrice('20150315','MIRC0003705','MP','PAV') FROM MxFixIncome.dbo.tblIds (NOLOCK) WHERE txtId1 = 'MIRC0003705'    
    
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




/*SE AGREGA SECCION DE INSTRUMENTOS CON CUSIP  2015-03-26 16:35:36.517 Oaceves*/
	 INSERT @tmp_tblResults    
			 SELECT 
			  @RecordTypeCode +     
			CASE     
				WHEN LEN(LTRIM(RTRIM(i.TXTID3))) >= 9 THEN LTRIM(RTRIM(i.TXTID3)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(i.TXTID3)))) end  -- PrimarySecurityCode(12)   
			+ @AliasSecurityCode +    
			  CASE     
			   WHEN SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,35) = '-' OR SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,35) = 'NA' OR i.txtNem IS NULL    
				THEN SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) +    
					 REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) -- Complemento -- SecuritiesName(35)    
				  WHEN LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)) < 35     
				THEN SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35))) +    
					 REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)))  -- Complemento SecuritiesName(35)    
				  ELSE    
				  SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)          -- SecuritiesName(35)    
			  END + STR(ROUND(a.dblPRS/@txtIrcUSDvalue,6),14,5) +
			  @Filler6 +     
			  @txtDate +                  -- DateOfClosingPrice(8)    
			  @Filler7 +     
			  @txtHHMMSS +    
			  'MXN' +                  -- Price Currency Mnemonic(3)    
			  @IssuedSharedCapital +     
			  @Filler8   
			  AS [Rows],                
			  2     
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
			  AND I.txtID3 not in ('-','NA')
			  
			  
				  
				--  /*SE AGREGA SECCION DE INSTRUMENTOS CON SEDOL  2015-03-26 16:35:36.517 Oaceves*/
						  INSERT @tmp_tblResults    
								 SELECT 
								  @RecordTypeCode +     
								CASE     
									WHEN LEN(LTRIM(RTRIM(i.TXTID4))) >=7 THEN LTRIM(RTRIM(i.TXTID4)) + REPLICATE(' ',12-LEN(LTRIM(RTRIM(i.TXTID4)))) end  -- PrimarySecurityCode(12)   
								+ @AliasSecurityCode +    
								  CASE     
								   WHEN SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,35) = '-' OR SUBSTRING(LTRIM(RTRIM(i.txtNem)),1,35) = 'NA' OR i.txtNem IS NULL    
									THEN SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) +    
										 REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(a.txtEmisora,CHAR(9),' '))),1,35))) -- Complemento -- SecuritiesName(35)    
									  WHEN LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)) < 35     
									THEN SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35))) +    
										 REPLICATE(' ',35 - LEN(SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)))  -- Complemento SecuritiesName(35)    
									  ELSE    
									  SUBSTRING(LTRIM(RTRIM(REPLACE(i.txtNem,CHAR(9),' '))),1,35)          -- SecuritiesName(35)    
								  END + STR(ROUND(a.dblPRS/@txtIrcEURvalue,6),14,5) +
								  @Filler6 +     
								  @txtDate +                  -- DateOfClosingPrice(8)    
								  @Filler7 +     
								  @txtHHMMSS +    
								  'MXN' +                  -- Price Currency Mnemonic(3)    
								  @IssuedSharedCapital +     
								  @Filler8   
								  AS [Rows],                
								  3     
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
								  AND I.txtID4 not in ('-')
				  
	
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
    
   
   if ((select COUNT(*) FROM @tmp_tblResults where Row is null) > 0)
   BEGIN 
   RAISERROR('ARCHIVO GENERADO CON NULOS ', 16, 1)
    END 
   ELSE 
   BEGIN 
   SELECT Row FROM @tmp_tblResults ORDER BY Consecutivo,Row   
   END  
    
-- SET NOCOUNT OFF    
    
----END    
----RETURN 0 
