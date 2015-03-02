      
/*         
----------------------------------------       
  Crea: Aceves Gutierrez Omar Adrian              
  Creacion:   2014-02-27 11:12:43.323             
  Descripcion:GENERAR PRODUCTOS GS_VectorAnalítico_MD_XLS, GS_VectorAnalítico_24H_XLS EN FORMATO CSV       
       
  MODIFICA: Aceves Gutierrez Omar Adrian              
  fECHA:     2014-08-22 09:49:40.807        
  Descripcion: SE CAMBIAN NOMBRES DE HEADERS EN REPORTE       
      
  MODIFICA: Aceves Gutierrez Omar Adrian              
  fECHA:   2014-08-26 10:35:00.703       
  Descripcion: se modifican frmatos de fecha para columnas mtd y isd     
    
    MODIFICA: Aceves Gutierrez Omar Adrian              
  fECHA:     2014-09-09 10:35:00.703       
  Descripcion: se modifica liquidacion a dinamica    
----------------------------------------       
*/            
   ALTER     PROCEDURE dbo.usp_productos_GoldmanSachs;4   '20140912','24h' 
        
   @dtedate DATETIME, -- ='20140909'             
   @txtliqtype VARCHAR(5) --= 'EOM'          
            
AS            
BEGIN            
SET NOCOUNT ON             
           
            
-----------------            
            
    DECLARE @dblBRL AS FLOAT            
   DECLARE @dblCHF AS FLOAT            
    DECLARE @dblEUR AS FLOAT            
    DECLARE @dblGBP AS FLOAT            
    DECLARE @dblITL AS FLOAT            
    DECLARE @dblJPY AS FLOAT            
    DECLARE @dblSMG AS FLOAT            
    DECLARE @dblUDI AS FLOAT            
    DECLARE @dblUFXU AS FLOAT            
    DECLARE @dblBRLUS2 AS FLOAT                DECLARE @dblCHFUS2 AS FLOAT            
    DECLARE @dblEURUS2 AS FLOAT            
    DECLARE @dblGBPUS2 AS FLOAT            
    DECLARE @dblITLUS2 AS FLOAT            
    DECLARE @dblJPYUS2 AS FLOAT            
  DECLARE @dblUSD2 AS FLOAT            
    DECLARE @dblAUD AS FLOAT            
    DECLARE @dblCAD AS FLOAT            
    DECLARE @dblCLP AS FLOAT            
    DECLARE @dblCOP AS FLOAT            
    DECLARE @dblDKK AS FLOAT            
    DECLARE @dblHKD AS FLOAT            
DECLARE @dblIDR AS FLOAT         
    DECLARE @dblNOK AS FLOAT            
    DECLARE @dblPEN AS FLOAT            
    DECLARE @dblSEK AS FLOAT            
    DECLARE @dblSGD AS FLOAT            
    DECLARE @dblTWD AS FLOAT            
    DECLARE @dblZAR AS FLOAT    
    DECLARE @dblAUDUS2 AS FLOAT            
    DECLARE @dblCADUS2 AS FLOAT            
    DECLARE @dblCLPUS2 AS FLOAT            
    DECLARE @dblDKKUS2 AS FLOAT            
    DECLARE @dblHKDUS2 AS FLOAT            
    DECLARE @dblIDRUS2 AS FLOAT       
    DECLARE @dblNOKUS2 AS FLOAT            
    DECLARE @dblSEKUS2 AS FLOAT            
            
          
            
  IF (SELECT COUNT(*) FROM tblIRC WHERE txtIRC IN ('BRL','CHF','EUR','GBP','ITL','JPY','SMG','UDI','UFXU') AND dteDate = @dtedate) <> 9            
     RAISERROR ('ERROR: Falta Informacion', 16, 1)            
            
  ELSE            
   BEGIN            
            
    DECLARE @tmp_tblUniv1 TABLE (            
txtIRC CHAR(7),             
     dblValue FLOAT            
    PRIMARY KEY (txtIRC))            
                
    INSERT @tmp_tblUniv1            
    SELECT             
     txtIRC,            
     dblValue            
    FROM tblIRC             
    WHERE             
     txtIRC IN ('BRL','CHF','EUR','GBP','ITL','JPY','SMG','UDI','UFXU')             
     AND dteDate = @dtedate            
        
    SET @dblBRL = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'BRL')             
    SET @dblCHF = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'CHF')              
    SET @dblEUR = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'EUR')              
    SET @dblGBP = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'GBP')              
    SET @dblITL = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'ITL')           
    SET @dblJPY = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'JPY')              
    SET @dblSMG = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'SMG')              
    SET @dblUDI = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'UDI')              
   SET @dblUFXU = (SELECT dblValue FROM @tmp_tblUniv1 WHERE txtIRC = 'UFXU')            
            
    DECLARE @tmp_tblPricesMO1 TABLE (            
     txtId1 CHAR(11),             
     txtCUR VARCHAR (400),            
     dblPRSMO FLOAT,            
     dblPRLMO FLOAT            
    PRIMARY KEY (txtID1,txtCUR))            
              INSERT @tmp_tblPricesMO1            
    SELECT            
     txtId1,            
     txtCUR,            
     CASE            
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblBRL)            
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblCHF)              
   WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblEUR)              
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblGBP)              
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblITL)              
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblJPY)              
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * 1)            
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblSMG)                  WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblUDI)            
  WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblUFXU)             
     END  AS PRS_MO,             
     CASE            
  WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblBRL)        WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblCHF)              
WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblEUR)              
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblGBP)              
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblITL)              
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblJPY)              
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * 1)            
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblSMG)              
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblUDI)            
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblUFXU)              
 END AS PRL_MO                 
   FROM dbo.tmp_tblUnifiedPricesReport    WHERE            
    txtLiquidation IN (@txtliqtype,'MP')            
    AND dteDate = @dtedate            
    AND txtTv IN ('D1','D2','D4','D5','D6','D7','D8')            
    AND txtVNA <> '-'        
  END            
-----            
         
  IF (SELECT COUNT(*) FROM tblIRC WHERE txtIRC IN ('BRLUS2','CHFUS2','EURUS2','GBPUS2','ITLUS2','JPYUS2','SMG','UDI','USD2') AND dteDate = @dtedate) <> 9            
  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)            
            
  ELSE            
BEGIN            
            
            
    DECLARE @tmp_tblUniv2 TABLE (            
     txtIRC CHAR(7),             
     dblValue FLOAT            
    PRIMARY KEY (txtIRC))            
                
    INSERT @tmp_tblUniv2            
    SELECT             
 txtIRC,            
     dblValue         
    FROM tblIRC             
    WHERE             
     txtIRC IN ('BRLUS2','CHFUS2','EURUS2','GBPUS2','ITLUS2','JPYUS2','SMG','UDI','USD2')             
     AND dteDate = @dtedate            
            
    SET @dblBRLUS2 = (SELECT dblValue FROM @tmp_tblUniv2 WHERE txtIRC = 'BRLUS2')             
    SET @dblCHFUS2 = (SELECT dblValue FROM @tmp_tblUniv2 WHERE txtIRC = 'CHFUS2')              
    SET @dblEURUS2 = (SELECT dblValue FROM @tmp_tblUniv2 WHERE txtIRC = 'EURUS2')              
    SET @dblGBPUS2 = (SELECT dblValue FROM @tmp_tblUniv2 WHERE txtIRC = 'GBPUS2')              
    SET @dblITLUS2 = (SELECT dblValue FROM @tmp_tblUniv2 WHERE txtIRC = 'ITLUS2')              
    SET @dblJPYUS2 = (SELECT dblValue FROM @tmp_tblUniv2 WHERE txtIRC = 'JPYUS2')              
    SET @dblUSD2 = (SELECT dblValue FROM @tmp_tblUniv2 WHERE txtIRC = 'USD2')         
            
    DECLARE @tmp_tblPricesMO2 TABLE (            
     txtId1 CHAR(11),             
     txtCUR VARCHAR (400),            
     dblPRSMO FLOAT,            
     dblPRLMO FLOAT            
    PRIMARY KEY (txtID1,txtCUR))            
            
    INSERT @tmp_tblPricesMO2            
    SELECT            
     txtId1,            
     txtCUR,            
     CASE            
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblBRLUS2)            
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblCHFUS2)              
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblEURUS2)              
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblGBPUS2)              
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblITLUS2)              
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblJPYUS2)              
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * 1)            
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblSMG)           
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblUDI)            
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRS * 100) / (CAST(txtVNA AS FLOAT) * @dblUSD2)        
     END  AS PRS_MO,             
     CASE            
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblBRLUS2)            
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblCHFUS2)              
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblEURUS2)              
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblGBPUS2)              
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblITLUS2)              
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblJPYUS2)    
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * 1)            WHEN txtCUR = '[SMG] Salario Minimo General' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblSMG)              
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblUDI)            
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRL * 100) / (CAST(txtVNA AS FLOAT) * @dblUSD2)              
     END AS PRL_MO                 
   FROM dbo.tmp_tblUnifiedPricesReport            WHERE            
    txtLiquidation IN (@txtliqtype,'MP')            
    AND dteDate = @dtedate            
    AND txtTv IN ('D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP')            
    AND txtVNA <> '-'       
  END     
            
            
----- 3            
            
  IF (SELECT COUNT(*) FROM tblIRC WHERE txtIRC IN ('AUD','BRL','CAD','CHF','CLP','COP','DKK','EUR','GBP','HKD','IDR','JPY','NOK','PEN','SEK','SGD','TWD','UDI','UFXU','ZAR') AND dteDate = @dtedate) <> 20            
            
   RAISERROR ('ERROR: Falta Informacion', 16, 1)            
            
  ELSE            
   BEGIN        
            
            
    DECLARE @tmp_tblUniv3 TABLE (            
     txtIRC CHAR(7),             
     dblValue FLOAT            
    PRIMARY KEY (txtIRC))            
                
    INSERT @tmp_tblUniv3           
   SELECT             
     txtIRC,            
     dblValue            
 FROM tblIRC             
    WHERE             
     txtIRC IN ('AUD','BRL','CAD','CHF','CLP','COP','DKK','EUR','GBP','HKD','IDR','JPY','NOK','PEN','SEK','SGD','TWD','UDI','UFXU','ZAR')            
     AND dteDate = @dtedate            
           
    SET @dblAUD = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'AUD')            
SET @dblCAD = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'CAD')          
    SET @dblCLP = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'CLP')            
    SET @dblCOP = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'COP')            
    SET @dblDKK = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'DKK')            
    SET @dblHKD = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'HKD')            
    SET @dblIDR = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'IDR')       
    SET @dblNOK = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'NOK')            
    SET @dblPEN = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'PEN')            
    SET @dblSEK = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'SEK')            
    SET @dblSGD = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'SGD')            
    SET @dblTWD = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'TWD')            
    SET @dblZAR = (SELECT dblValue FROM @tmp_tblUniv3 WHERE txtIRC = 'ZAR')            
            
    DECLARE @tmp_tblPricesMO3 TABLE (            
     txtId1 CHAR(11),             
     txtCUR VARCHAR (400),           
     dblPRSMO FLOAT,            
     dblPRLMO FLOAT            
    PRIMARY KEY (txtID1,txtCUR))   
            
    INSERT @tmp_tblPricesMO3            
    SELECT            
     txtId1,            
     txtCUR,            
     CASE            
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN (dblPRS / @dblAUD)            
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRS / @dblBRL)            
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN (dblPRS / @dblCAD)            
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRS / @dblCHF)            
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN (dblPRS / @dblCLP)            
  WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN (dblPRS / @dblCOP)            
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN (dblPRS / @dblDKK)            
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRS / @dblEUR)            
      WHEN txtCUR = '[GBp] Libra Inglesa (MXN)' THEN (dblPRS / @dblGBP)            
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN (dblPRS / @dblHKD)            
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN (dblPRS / @dblIDR)            
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRS / @dblJPY)            
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRS / 1)            
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN (dblPRS / @dblNOK)            
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN (dblPRS / @dblPEN)            
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN (dblPRS / @dblSEK)            
  WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN (dblPRS / @dblSGD)            
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN (dblPRS / @dblTWD)            
     WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRS / @dblUDI)            
     WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRS / @dblUFXU)            
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN (dblPRS / @dblZAR)       
     END  AS PRS_MO,             
     CASE            
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN (dblPRL / @dblAUD)            
   WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRL / @dblBRL)            
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN (dblPRL / @dblCAD)            
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRL / @dblCHF)            
WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN (dblPRL / @dblCLP)            
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN (dblPRL / @dblCOP)            
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN (dblPRL / @dblDKK)            
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRL / @dblEUR)            
      WHEN txtCUR = '[GBp] Libra Inglesa (MXN)' THEN (dblPRL / @dblGBP)          
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN (dblPRL / @dblHKD)           
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN (dblPRL / @dblIDR)            
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRL / @dblJPY)            
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRL / 1)            
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN (dblPRL / @dblNOK)            
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN (dblPRL / @dblPEN)            
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN (dblPRL / @dblSEK)            
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN (dblPRL / @dblSGD)            
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN (dblPRL / @dblTWD)            
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRL / @dblUDI)            
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRL / @dblUFXU)            
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN (dblPRL / @dblZAR)            
     END AS PRL_MO                
   FROM dbo.tmp_tblUnifiedPricesReport         
   WHERE            
 txtLiquidation IN (@txtliqtype,'MP')            
    AND  txtTv  NOT IN ('*C','*CSP','D1','D2','D4','D5','D6','D7','D8','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP')         
    AND   CHARINDEX('sp',txtTv,2) <1        
        
              
           
                    
         
  END             
            
  IF (SELECT COUNT(*) FROM tblIRC WHERE txtIRC IN ('AUDUS2','BRLUS2','CADUS2','CHFUS2','CLPUS2','COP','DKKUS2','EURUS2','GBPUS2','HKDUS2','IDR','JPYUS2','NOKUS2','PEN','SEKUS2','SGD','TWD','UDI','USD2','ZAR') AND dteDate = @dtedate) <> 20                
  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)            
            
  ELSE            
   BEGIN            
            
            
    DECLARE @tmp_tblUniv4 TABLE (            
     txtIRC CHAR(7),       
     dblValue FLOAT     
  PRIMARY KEY (txtIRC))            
                
    INSERT @tmp_tblUniv4            
    SELECT             
     txtIRC,            
    dblValue            
    FROM tblIRC             
    WHERE             
     txtIRC IN ('AUDUS2','BRLUS2','CADUS2','CHFUS2','CLPUS2','COP','DKKUS2','EURUS2','GBPUS2','HKDUS2','IDR','JPYUS2','NOKUS2','PEN','SEKUS2','SGD','TWD','UDI','USD2','ZAR')             
     AND dteDate = @dtedate            
            
    SET @dblAUDUS2 = (SELECT dblValue FROM @tmp_tblUniv4 WHERE txtIRC = 'AUDUS2')         
    SET @dblCADUS2 = (SELECT dblValue FROM @tmp_tblUniv4 WHERE txtIRC = 'CADUS2')            
    SET @dblCLPUS2 = (SELECT dblValue FROM @tmp_tblUniv4 WHERE txtIRC = 'CLPUS2')            
    SET @dblDKKUS2 = (SELECT dblValue FROM @tmp_tblUniv4 WHERE txtIRC = 'DKKUS2')            
    SET @dblHKDUS2 = (SELECT dblValue FROM @tmp_tblUniv4 WHERE txtIRC = 'HKDUS2')            
    SET @dblNOKUS2 = (SELECT dblValue FROM @tmp_tblUniv4 WHERE txtIRC = 'NOKUS2')           
    SET @dblSEKUS2 = (SELECT dblValue FROM @tmp_tblUniv4 WHERE txtIRC = 'SEKUS2')         
            
    DECLARE @tmp_tblPricesMO4 TABLE (            
     txtId1 CHAR(11),             
     txtCUR VARCHAR (400),            
     dblPRSMO FLOAT,           
     dblPRLMO FLOAT            
    PRIMARY KEY (txtID1,txtCUR))            
            
    INSERT @tmp_tblPricesMO4          
    SELECT            
     txtId1,            
     txtCUR,            
     CASE            
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN (dblPRS / @dblAUDUS2)            
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRS / @dblBRLUS2)            
WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN (dblPRS / @dblCADUS2)            
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRS / @dblCHFUS2)            
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN (dblPRS / @dblCLPUS2)            
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN (dblPRS / @dblCOP)            
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN (dblPRS / @dblDKKUS2)            
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRS / @dblEURUS2)            
      WHEN txtCUR = '[GBp] Libra Inglesa (MXN)' THEN (dblPRS / @dblGBPUS2)            
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN (dblPRS / @dblHKDUS2)            
WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN (dblPRS / @dblIDR)            
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRS / @dblJPYUS2)            
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRS / 1)            
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN (dblPRS / @dblNOKUS2)            
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN (dblPRS / @dblPEN)            
 WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN (dblPRS / @dblSEKUS2)            
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN (dblPRS / @dblSGD)                WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN (dblPRS / @dblTWD)            
     WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRS / @dblUDI)            
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRS / @dblUSD2)        
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN (dblPRS / @dblZAR)       
     END  AS PRS_MO,             
     CASE            
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN (dblPRL / @dblAUDUS2)            
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN (dblPRL / @dblBRLUS2)            
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN (dblPRL / @dblCADUS2)            
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN (dblPRL / @dblCHFUS2)            
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN (dblPRL / @dblCLPUS2)            
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN (dblPRL / @dblCOP)            
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN (dblPRL / @dblDKKUS2)            
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN (dblPRL / @dblEURUS2)            
      WHEN txtCUR = '[GBp] Libra Inglesa (MXN)' THEN (dblPRL / @dblGBPUS2)            
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN (dblPRL / @dblHKDUS2)            
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN (dblPRL / @dblIDR)         
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN (dblPRL / @dblJPYUS2)          
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN (dblPRL / 1)            
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN (dblPRL / @dblNOKUS2)            
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN (dblPRL / @dblPEN)       
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN (dblPRL / @dblSEKUS2)            
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN (dblPRL / @dblSGD)            
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN (dblPRL / @dblTWD)           
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN (dblPRL / @dblUDI)            
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN (dblPRL / @dblUSD2)            
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN (dblPRL / @dblZAR)            
     END AS PRL_MO              
   FROM dbo.tmp_tblUnifiedPricesReport           
   WHERE            
    txtLiquidation IN (@txtliqtype,'MP')            
    AND dteDate = @dtedate        AND txtTv NOT IN ('*C','*CSP','D1','D2','D4','D5','D6','D7','D8','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','SP')            
    AND txtTv LIKE '%SP'           
            
  END            
-----------------            
DECLARE @tmp_AnaAnalitic TABLE            
(            
 [txtId1][VARCHAR](11),             
 [dtedate][VARCHAR](10),            
 [txtTv][VARCHAR](10),            
 [txtEmisora][VARCHAR](10),            
 [txtSerie][VARCHAR](10),            
 [dblPRL][VARCHAR](30),            
 [dblPRS][VARCHAR](30),            
 [dblCPD][VARCHAR](30),            
 [dblCuponCPA][VARCHAR](30),            
 [dblLDR][VARCHAR](30),            
 [txtNEM][VARCHAR](400), --COLLATE Modern_Spanish_CI_AI ,             
 [txtSEC][VARCHAR](400), --COLLATE Modern_Spanish_CI_AI ,            
 [txtMOE][VARCHAR](400),         
 [txtMOC][VARCHAR](400),            
 [txtISD][VARCHAR](400),            
 [txtTTM][VARCHAR](400),            
 [txtMTD][VARCHAR](400),  [txtNOM][VARCHAR](400),            
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
 [txtBYT][VARCHAR](400),      [txtOYT][VARCHAR](400),            
 [txtBSP][VARCHAR](400),            
 [txtPSP][VARCHAR](400),            
 [txtDPQ][VARCHAR](400),            
 [txtSPQ][VARCHAR](400),            
 [txtBUR][VARCHAR](400),            
 [txtLIQ][VARCHAR](400),             [txtDPC][VARCHAR](400),            
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
 [TXTID2][VARCHAR](400),            
 --[TXTTVEMI][VARCHAR](400),            
 [TXTPRS_MO][VARCHAR](400),            
 [TXTPRL_MO][VARCHAR](400),        
 [TXTPRDIFF][VARCHAR](400)             
            
             
--COLLATE SQL_Latin1_General_CP1_CI_AS             
            
)            
            
            
            
INSERT INTO @tmp_AnaAnalitic            
          
 SELECT             
  RTRIM(LTRIM([txtId1])),            
  CONVERT(VARCHAR(10),[dtedate],112),            
  UPPER([txtTv]),            
  UPPER([txtEmisora]),            
  UPPER([txtSerie]),            
  CONVERT(VARCHAR(400),STR(ROUND([dblPRL],6),15,6)),            
  STR(ROUND([dblPRS],6),15,6),            
  STR(ROUND([dblCPD],6),10,6),            
  STR(ROUND([dblCPA],6),10,6) AS [dblCuponCPA],            
  STR(ROUND([dblLDR],6),10,6),            
              
             
  --RTRIM(LTRIM([txtNEM])),--10            
  REPLACE( replace( replace( replace( replace( replace( RTRIM(LTRIM(r.txtNEM)), 'á', 'A' ), 'é', 'E' ), 'í', 'I' ), 'ó', 'O' ), 'ú', 'U' ),',',''),         
  replace( replace( replace( replace( replace( RTRIM(LTRIM(r.txtSEC)), 'á', 'A' ), 'é', 'E' ), 'í', 'I' ), 'ó', 'O' ), 'ú', 'U' ) ,            
          
  --RTRIM(LTRIM([txtSEC])),            
              
  RTRIM(LTRIM([txtMOE])),            
  RTRIM(LTRIM([txtMOC])),            
              
              
  RTRIM(CASE WHEN r.txtISD = '-' OR r.txtISD = 'NA' THEN 'NA' ELSE CONVERT(CHAR(10),CONVERT(DATETIME, ISNULL(r.txtISD, '1900-01-01')),101) END),            
  RTRIM(LTRIM([txtTTM])),            
  RTRIM(CASE WHEN r.txtMTD = '-' OR r.txtMTD = 'NA' THEN 'NA' ELSE CONVERT(CHAR(10),CONVERT(DATETIME, ISNULL(r.txtMTD, '1900-01-01')),101) END),            
              
  CASE WHEN r.txtNOM = '-' OR r.txtNOM = 'NA' THEN 'NA' ELSE STR(ROUND(RTRIM(LTRIM([txtNOM])),12),21,12)END ,            
              
              
              
  replace( replace( replace( replace( replace( RTRIM(LTRIM(r.txtCUR)), 'á', 'A' ), 'é', 'E' ), 'í', 'I' ), 'ó', 'O' ), 'ú', 'U' ) ,            UPPER(r.txtIRCSUBY),            
  CASE WHEN  r.txtCYT = '-' OR r.txtCYT = 'NA' THEN 'NA' ELSE  STR(ROUND(RTRIM(LTRIM([txtCYT])),6),10,6)END,--20                      
              
              
  CASE WHEN r.txtOSP = '-' OR r.txtOSP ='NA' THEN 'NA' ELSE  STR(ROUND(RTRIM(LTRIM([txtOSP])),6),10,6)END,            
  UPPER(RTRIM(LTRIM([txtCPF]))),            
  [dblCPA],--<<<>>>            
              
  RTRIM(LTRIM([txtDTC])),            
  UPPER(RTRIM(LTRIM([txtCRL]))),            
  RTRIM(LTRIM([txtTCR])),            
  RTRIM(LTRIM([txtFCR])),       
              
  CASE WHEN r.txtLPV = '-' OR r.txtLPV = 'NA' THEN 'NA' ELSE             
    CASE ISNUMERIC(r.txtLPV) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtLPV])),6),15,6) else 'NA' END END ,            
       
  CASE WHEN r.txtLPD = '-' OR r.txtLPD = 'NA' THEN 'NA' ELSE             
 CASE ISNUMERIC(r.txtLPD) WHEN 1 THEN   CONVERT(CHAR(10),CONVERT(DATETIME, ISNULL(r.txtLPD, '1900-01-01')),103)  else 'NA' END END,             
              
  CASE WHEN r.txtTHP = '-' OR r.txtTHP = 'NA' THEN 'NA' ELSE             
    CASE ISNUMERIC(r.txtTHP) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtTHP])),6),15,6) else 'NA' END END, --30            
   ----            
               
  CASE WHEN r.txtLCA = '-' OR r.txtLCA = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtLCA) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtLCA])),6),10,6) else 'NA' END END ,           
               
            
  CASE WHEN r.txtLPU = '-' OR r.txtLPU = 'NA' THEN 'NA' ELSE             
    CASE ISNUMERIC(r.txtLPU) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtLPU])),6),10,6) else 'NA' END END ,         
        
  CASE WHEN r.txtBYT = '-' OR r.txtBYT = 'NA' THEN 'NA' ELSE            
    CASE ISNUMERIC(r.txtBYT) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtBYT])),6),10,6) else 'NA' END END ,            
               
  CASE WHEN r.txtOYT = '-' OR r.txtOYT = 'NA' THEN 'NA' ELSE             
    CASE ISNUMERIC(r.txtOYT) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtOYT])),6),10,6) else 'NA' END END ,            
     
  CASE WHEN r.txtBSP = '-' OR r.txtBSP = 'NA' THEN 'NA' ELSE             
    CASE ISNUMERIC(r.txtBSP) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtBSP])),6),10,6) else 'NA' END END ,            
               
  CASE WHEN r.txtPSP = '-' OR r.txtPSP = 'NA' THEN 'NA' ELSE             
    CASE ISNUMERIC(r.txtPSP) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtPSP])),6),10,6) else 'NA' END END ,            
         
  UPPER(RTRIM(LTRIM([txtDPQ]))),            
  UPPER(RTRIM(LTRIM([txtSPQ]))),            UPPER(RTRIM(LTRIM([txtBUR]))),            
  RTRIM(LTRIM([txtLIQ])),--40            
  RTRIM(LTRIM([txtDPC])),            
  RTRIM(LTRIM([txtWPC])),            
            
  CASE WHEN r.txtMHP = '-' OR r.txtMHP = 'NA' THEN 'NA' ELSE             
    CASE ISNUMERIC(r.txtMHP) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtMHP])),6),15,6) else 'NA' END END ,--BR_PRC_MA2             
                
  CASE WHEN r.txtIHP = '-' OR r.txtIHP = 'NA' THEN 'NA' ELSE             CASE ISNUMERIC(r.txtIHP) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtIHP])),6),15,6) else 'NA' END END ,--BR_PRC_MI2            
            
  UPPER(RTRIM(LTRIM([txtSUS]))),            
              
              
              
  RTRIM(LTRIM([txtVOL])),            
  RTRIM(LTRIM([txtVO2])),            
              
     
  CASE WHEN r.txtDMF = '-' OR r.txtDMF = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtDMF) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtDMF])),12),20,12) else 'NA' END END ,            
                
  CASE WHEN r.txtDMT = '-' OR r.txtDMT = 'NA' THEN 'NA' ELSE      
   CASE ISNUMERIC(r.txtDMT) WHEN 1 THEN  STR(ROUND(RTRIM(LTRIM([txtDMT])),12),20,12) else 'NA' END END ,            
  ----            
  CASE WHEN r.txtCMT = '-' OR r.txtCMT = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtCMT) WHEN 1 THEN  STR(ROUND(RTRIM(LTRIM([txtCMT])),12),19,12) else 'NA' END END ,--50            
               
  CASE WHEN r.txtVAR = '-' OR r.txtVAR = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtVAR) WHEN 1 THEN  STR(ROUND(RTRIM(LTRIM([txtVAR])),12),19,12) else 'NA' END END ,            
               
   RTRIM(LTRIM([txtSTD])),            
           
  CASE WHEN r.txtVNA = '-' OR r.txtVNA = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtVNA) WHEN 1 THEN  STR(ROUND(RTRIM(LTRIM([txtVNA])),6),13,6) else 'NA' END END ,            
          
  UPPER(RTRIM(LTRIM([txtFIQ]))),            
              
              
  CASE WHEN r.txtDMH = '-' OR r.txtDMH = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtDMH) WHEN 1 THEN   CONVERT(CHAR(10),CONVERT(DATETIME, ISNULL(r.txtDMH, '1900-01-01')),103) else 'NA' END END,             
               
  CASE WHEN r.txtDIH = '-' OR r.txtDIH = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtDIH) WHEN 1 THEN   CONVERT(CHAR(10),CONVERT(DATETIME, ISNULL(r.txtDIH, '1900-01-01')),103) else 'NA' END END ,                      
                
  CASE WHEN r.txtSTP = '-' OR r.txtSTP = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtSTP) WHEN 1 THEN   STR(ROUND(RTRIM(LTRIM([txtSTP])),12),20,12) else 'NA' END END ,            
               
               
  CASE WHEN r.txtDMC = '-' OR r.txtDMC = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtDMC) WHEN 1 THEN  STR(ROUND(RTRIM(LTRIM([txtDMC])),12),20,12) else 'NA' END END ,            
  
  RTRIM(LTRIM([dblYTM])),--<<<>>>            
              
  UPPER(RTRIM(LTRIM([txtHRQ]))),--60             
              
              
  RTRIM( CASE WHEN r.txtDEF = '-' OR r.txtDEF = 'NA' THEN 'NA' ELSE             
   CASE ISNUMERIC(r.txtDEF) WHEN 1 THEN  STR(ROUND(RTRIM(LTRIM([txtDEF])),12),20,12) else 'NA' END END ),            
       
  CASE WHEN LEN(r.TXTID2) <> 12            
     THEN 'NA'            
     ELSE r.TXTID2            
       END,            
                     
  CASE             
   WHEN r.txtTv IN ('*C','*CSP') THEN STR(ROUND(dblPRS,6),16,6) ELSE NULL END ,            
              CASE             
   WHEN r.txtTv IN ('*C','*CSP') THEN STR(ROUND(dblPRL,6),16,6) ELSE NULL END ,        
           
   ''--vacio para diferencia entre precios            
            
  FROM dbo.tmp_tblUnifiedPricesReport AS r            
 WHERE             
   r.txtLiquidation IN (@txtliqtype,'MP')            
   AND r.dtedate = @dtedate             
            
            
-- UPDATE 1            
            
UPDATE r SET r.TXTPRS_MO = STR(ROUND(p.dblPRSMO,6),16,6), r.TXTPRL_MO = STR(ROUND(p.dblPRLMO,6),16,6)            
FROM @tmp_AnaAnalitic AS r            
INNER JOIN @tmp_tblPricesMO1 AS p            
ON            
 r.txtId1 = p.txtId1            
 AND r.txtCUR = p.txtCUR            
            
UPDATE r SET r.TXTPRS_MO = STR(ROUND(p.dblPRSMO,6),16,6), r.TXTPRL_MO = STR(ROUND(p.dblPRLMO,6),16,6)        
FROM @tmp_AnaAnalitic AS r            
INNER JOIN @tmp_tblPricesMO2 AS p            
ON            
 r.txtId1 = p.txtId1            
 AND r.txtCUR = p.txtCUR            
            
UPDATE r SET r.TXTPRS_MO = STR(ROUND(p.dblPRSMO,6),16,6), r.TXTPRL_MO = STR(ROUND(p.dblPRLMO,6),16,6)            
FROM @tmp_AnaAnalitic AS r    INNER JOIN @tmp_tblPricesMO3 AS p            
ON     
 r.txtId1 = p.txtId1            
 AND r.txtCUR = p.txtCUR            
            
UPDATE r SET r.TXTPRS_MO = STR(ROUND(p.dblPRSMO,6),16,6), r.TXTPRL_MO = STR(ROUND(p.dblPRLMO,6),16,6)            
FROM @tmp_AnaAnalitic AS r            
INNER JOIN @tmp_tblPricesMO4 AS p            
ON            
 r.txtId1 = p.txtId1            
 AND r.txtCUR = p.txtCUR            
           
           
   /*SE ESTABLE REGLA ANEXO 1 (1_ PARA *C Y CPS)*/        
   UPDATE @tmp_AnaAnalitic        
    SET TXTPRS_MO = dblPRS        
    WHERE TXTTV IN ('*C','CPS')        
           
   UPDATE @tmp_AnaAnalitic        
    SET TXTPRL_MO = dblPRL        
    WHERE TXTTV IN ('*C','CPS')        
           
   /*SE AGREGAN DIFERENCIA ENTRE PRS_MO Y PRL_MO*/        
   UPDATE @tmp_AnaAnalitic      
   SET TXTPRDIFF =  CONVERT( FLOAT,TXTPRS_MO) - TXTPRL_MO        
        
           
           
 DECLARE @temptittle TABLE          
 (           
 lineas varchar(max)          
 )          
           
 INSERT INTO @temptittle          
         ( lineas )          
 VALUES  (           
  'FECHA'+','+ 'TIPO VALOR'+','+ 'EMISORA'+','+ 'SERIE'+','+ 'PRECIO LIMPIO'+','+ 'PRECIO SUCIO'+','+ 'INTERESES ACUMULADOS'+','+ 'CUPON ACTUAL'+','+ 'SOBRETASA'+','+ 'NOMBRE COMPLETO'+','+ 'SECTOR'+','+ 'MONTO EMITIDO'+','+ 'MONTO EN CIRCULACION'+','+'FECHA EMISIÓN'+','+ 'PLAZO EMISION'+','+ 'FECHA VTO'+','+ 'VALOR NOMINAL'+','+ 'MONEDA EMISION'+','+ 'SUBYACENTE'+','+ 'REND. COLOCACION'+','+ 'ST COLOCACION'+','+ 'FREC. CPN'+','+ 'TASA CUPON'+','+ 'DIAS TRANSC. CPN'+','+ 'REGLA CUPON'+','+ 'CUPONES EMISION'+','+'CUPONES X COBRAR'+','+ 'HECHO DE MKT'+','+ 'FECHA U.H.'+','+ 'PRECIO TEORICO'+','+ 'POST COMPRA'+','+ 'POST VENTA'+','+ 'YIELD COMPRA'+','+ 'YIELD VENTA'+','+ 'SPREAD COMPRA'+','+ 'SPREAD VENTA'+','+ 'MDYS'+','+ 'S&P'+','+ 'BURSATILIDAD'+','    +'LIQUIDEZ'+','+ 'CAMBIO DIARIO'+','+ 'CAMBIO SEMANAL'+','+ 'PRECIO MAX 12M'+','+ 'PRECIO MIN 12M'+','+ 'SUSPENSION'+','+ 'VOLATILIDAD'+','+ 'VOLATILIDAD 2'+','+ 'DURACION'+','+ 'DURACION MONET.'+','+ 'CONVEXIDAD'+','+ 'VAR'+','+ 'DESVIACION STAND'+',' + 'VALOR NOMINAL ACTUALIZADO'+','+ 'CALIFICACION FITCH'+','+ 'FECHA PRECIO MAXIMO'+','+ 'FECHA PRECIO MINIMO'+','+ 'SENSIBILIDAD'+','+ 'DURACION MACAULAY'+','+ 'TASA DE RENDIMIENTO'+','+ 'HR RATINGS'+','+ 'DURACION EFECTIVA'+','+ 'ISIN'+','+ 'Precio Sucio MO'+','+'Precio Limpio MO'+','+'Intereses Acumulados MO')          
           
     INSERT INTO @temptittle          
         ( lineas )          
         
 select         
 dtedate+','+txtTv          
 +','+txtEmisora            
+','+txtSerie+','+LTRIM(dblPRL)+','+LTRIM(dblPRS )           
+','+LTRIM(dblCPD)+','+LTRIM(dblCuponCPA)+','+LTRIM(dblLDR)            
+','+LTRIM(txtNEM)+','+LTRIM(txtSEC)+','+LTRIM(txtMOE)           
+','+LTRIM(txtMOC)    
+','+LTRIM(txtISD)    
+','+LTRIM(txtTTM)            
+','+LTRIM(txtMTD)    
+','+LTRIM(txtNOM)+','+LTRIM(txtCUR )           
+','+txtIRCSUBY+','+txtCYT+','+txtOSP            
+','+txtCPF+','+dblTasaCPA+','+txtDTC           
+','+LTRIM(txtCRL)+','+LTRIM(txtTCR)+','+LTRIM(txtFCR)           
+','+LTRIM(txtLPV)+','+RTRIM(LTRIM(txtLPD))+','+RTRIM( LTRIM(txtTHP))          
+','+LTRIM(txtLCA)+','+LTRIM(txtLPU)+','+LTRIM(txtBYT)            
+','+LTRIM(txtOYT)+','+LTRIM(txtBSP)+','+LTRIM(txtPSP)            
+','+LTRIM(txtDPQ)+','+LTRIM(txtSPQ)+','+LTRIM(txtBUR)            
+','+LTRIM(txtLIQ)+','+LTRIM(txtDPC)+','+LTRIM(txtWPC)            
+','+LTRIM(txtMHP)+','+LTRIM(txtIHP)+','+LTRIM(txtSUS)            
+','+LTRIM(txtVOL)+','+LTRIM(txtVO2)+','+LTRIM(txtDMF)            
+','+LTRIM(txtDMT)+','+LTRIM(txtCMT)+','+LTRIM(txtVAR)            
+','+LTRIM(txtSTD)+','+LTRIM(txtVNA)+','+LTRIM(txtFIQ)            
+','+RTRIM(LTRIM(txtDMH))+','          
+LTRIM( RTRIM(txtDIH))+','+LTRIM( RTRIM(txtSTP))            
+','+LTRIM(txtDMC)+','+LTRIM(dblYTM)+','+LTRIM(txtHRQ)            
+','+LTRIM(txtDEF)+','+LTRIM(TXTID2)+','+LTRIM(TXTPRS_MO)            
+','+LTRIM(TXTPRL_MO)+','+ TXTPRDIFF          
          
  FROM @tmp_AnaAnalitic  AS A          
 ORDER  BY txtTv,txtEmisora,txtSerie             
         
         
 DECLARE @IrcUDI FLOAT  = (        
 SELECT dblValue FROM  dbo.tblIrc        
 WHERE txtIRC = 'UDI'        
 AND  dtedate  = @dtedate)        
        
         
  DECLARE @IrcUFXU FLOAT  = (        
 SELECT dblValue FROM  dbo.tblIrc        
 WHERE txtIRC = 'UFXU'        
 AND  dtedate  = @dtedate)        
     
         
 DECLARE @totalIRCS VARCHAR(100)= @IrcUDI/@IrcUFXU         
         
 INSERT INTO @temptittle        
 SELECT TOP 1        
dtedate +','+'*C'+','+'USDUDI'+','+'UDI'+','+ @totalIRCS +','+@totalIRCS+','+'0'+','+'0'+','+'0'+','+'[USD] PESO MEXICANO (VMD)'+','+        
'TIPO DE CAMBIO'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'[USD] PESO MEXICANO (VMD)'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'0'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA        '+','+        
'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA'+','+'NA        '+','+        
'NA        '+','+        
'NA'+','+'NA'+','+'0'+','+'NA'+','+'NA'+','+'NA'+','+ @totalIRCS+',' + @totalIRCS+',' +'0'        
         FROM @tmp_AnaAnalitic  AS A          
        
    IF EXISTS(            
  SELECT TOP 1 dteDate    FROM @tmp_AnaAnalitic            
 )            
            
 SELECT * FROM @temptittle          
          
          
 ELSE            
   RAISERROR ('ERROR: Falta Informacion', 16, 1)            
            
            
 SET NOCOUNT OFF             
 END 