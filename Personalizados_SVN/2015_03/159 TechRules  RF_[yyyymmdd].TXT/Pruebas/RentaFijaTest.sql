
/*
Modifica:  oaceves
Fecha de Modificación:  2015-04-06 11:11:00
Descripcion  :   Se agregan 5 campos nuevos Calificación S&P  Calificación FITCH  Calificación Moodys  Calificación HR Ratings  DISTRIBUCION_TIPO_TASA
--------------------------------------------------------------------------------  
--  Modificado por: Mike Ramirez  
--  Fecha: 17:05 p.m. 2011-07-27  
--  Descripcion: Modulo:3 Modificación en el reporte de la columna txtFIQ     
--  Modificado por:  Mike  --  Modificacion: 09:14 a.m. 2011-12-23  
--  Descripcion:    Uso de mejores practicas de optimizacion  
--------------------------------------------------------------------------------  
*/
ALTER  PROCEDURE dbo.usp_productos_TechRules;3      
   @txtDate AS DATETIME      
     -- set @txtDate = '20150330'
AS         
BEGIN        
      
 SET NOCOUNT ON    
   
 -- Creo tabla temporal de resultados      
 DECLARE @tblResult TABLE (      
 [intSection][INTEGER],      
 [txtData][VARCHAR](8000)      
 )      
  
  -- Creo tabla temporal para extraer el universo de datos    
 DECLARE @tmp_tblTemp TABLE (  
   [IntCustId] INT,  
   [txtISD] CHAR(8),  
   [txtMTD] CHAR(8),  
   [txtCAL] CHAR(20),  
   [intNOM] CHAR(20),  
   [txtCPA] CHAR(20),  
   [intfloat] CHAR(10),  
   [txtCPF] CHAR(20),  
   [txtNCR] CHAR(20),  
   [txtFIQ] CHAR(20),  
   [dteDate] CHAR(8),  
   [dblCPD] CHAR(20),  
   [dblYTM] CHAR(20),  
   [txtCMT] CHAR(20),  
   [txtDMC] CHAR(20),  
   [txtDMF] CHAR(20),
   [txtSPQ] CHAR(20),
   [txtFIQ2] CHAR(20),
   [txtDPQ] CHAR(20),
   [txtHRQ] CHAR(20),
   [txtCTY] CHAR(20)
   PRIMARY KEY(IntCustId)  
 )  
-- Cargo universo  
 INSERT @tmp_tblTemp (IntCustId,txtISD,txtMTD,txtCAL,intNOM,txtCPA,intfloat,txtCPF,txtNCR,txtFIQ,dteDate,dblCPD,dblYTM,txtCMT,txtDMC,txtDMF,txtSPQ,txtFIQ2,txtDPQ,txtHRQ,txtCTY)  
  SELECT  
   id.intCustomerId,  
   CASE  
    WHEN upr.txtISD = '-' THEN ''  
    ELSE CONVERT(CHAR(8),CONVERT(DATETIME, ISNULL(upr.txtISD, '1900-01-01')),112)   
   END,  
   CASE   
    WHEN upr.txtMTD = '-' OR upr.txtMTD = 'NA' THEN ''   
    ELSE CONVERT(CHAR(8),CONVERT(DATETIME, ISNULL(upr.txtMTD, '1900-01-01')),112)   
   END,  
   bs.txtcalendar,  
   upr.txtNOM,  
   upr.dblCPA,  
   bs.intfixfloat,  
   upr.txtCPF,  
   upr.txtNCR,  
   upr.txtFIQ,  
   CONVERT(CHAR(8),upr.dteDate,112),  
   upr.dblCPD,  
   upr.dblYTM,  
   upr.txtCMT,  
   upr.txtDMC,  
   upr.txtDMF,  
   upr.txtSPQ,
   upr.txtFIQ,
   upr.txtDPQ,
   upr.txtHRQ,
   upr.txtCTY
  FROM MxFixincome.dbo.tmp_tblUnifiedPricesReport AS upr (NOLOCK)  
   INNER JOIN MxFixincome.dbo.tblids AS id (NOLOCK)  
   ON upr.txtId1 = id.txtId1  
   INNER JOIN MxFixincome.dbo.tblbonds AS bs (NOLOCK)  
   ON upr.txtid1 = bs.txtid1  
  WHERE id.txtTv IN ('94','D3','D3SP','D7','D7SP','F','FSP','G','I','IL','J','JI','JSP','Q','QSP','2U','3U','4U','6U',  
            '92','95','96','B','BI','CC','CP','D1','D1SP','IP','IS','IT','L','LD','LP','LS','LT','M','M0','M3',  
         'M5','M7','MC','MP','PI','S','S0','S3','S5','SC','SP','TR','XA','2','2P','3P','4P','71','73','75','76',  
         '90','91','91SP','93','93SP','97','98','D','D2','D2SP','P1','R','R1','R3','R3SP','D4','D4SP','D5','D5SP',  
         'D6','D6SP','D8','D8SP','JE')   
   AND upr.txtliquidation = 'MD'   
   AND upr.dtedate = @txtDate  
  
 -- Genero tabla de resultados  
 INSERT @tblResult (intSection,txtData)   
  SELECT  
   1,  
   'PiP'+SUBSTRING('0000000000',1,10-LEN(LTRIM(STR(IntCustId)))) + LTRIM(STR(IntCustId))+'|'+  
   RTRIM(txtISD)+'|'+  
   RTRIM(txtMTD)+'|'+  
   RTRIM(txtCAL)+'|'+  
   RTRIM(intNOM)+'|'+  
   RTRIM(txtCPA)+'|'+  
   CASE  
    WHEN intfloat IS NULL OR intfloat = '-' OR intfloat = 'NA' THEN ''  
    ELSE RTRIM(intfloat)  
   END+'|'+  
   ''+'|'+  
   CASE  
    WHEN txtCPF IS NULL OR txtCPF = '-' OR txtCPF = 'NA' THEN ''   
    ELSE RTRIM(txtCPF)   
   END+'|'+  
   CASE   
    WHEN txtNCR IS NULL OR txtNCR = '-' OR txtNCR = 'NA' THEN ''   
    ELSE RTRIM(txtNCR)   
   END+'|'+  
   'MXN'+'|'+  
   ''+'|'+  
   ''+'|'+  
   CASE   
    WHEN txtFIQ IS NULL OR txtFIQ = '-' OR txtFIQ = 'NA' OR txtFIQ = 'RETIRADA' THEN ''   
    ELSE RTRIM(txtFIQ)   
   END+'|'+  
   RTRIM(dteDate)+'|'+  
   RTRIM(dblCPD)+'|'+  
   RTRIM(dblYTM)+'|'+  
   RTRIM(dblYTM)+'|'+  
   CASE   
    WHEN txtCMT IS NULL OR txtCMT = '-' OR txtCMT = 'NA' THEN ''   
    ELSE RTRIM(txtCMT)   
   END+'|'+  
   CASE   
    WHEN txtCMT IS NULL OR txtCMT = '-' OR txtCMT = 'NA' THEN ''   
    ELSE RTRIM(txtCMT)   
   END+'|'+  
   CASE   
    WHEN txtDMC IS NULL OR txtDMC = '-' OR txtDMC = 'NA' THEN ''   
    ELSE RTRIM(txtDMC)   
   END+'|'+  
   CASE   
    WHEN txtDMC IS NULL OR txtDMC = '-' OR txtDMC = 'NA' THEN ''   
    ELSE RTRIM(txtDMC)   
   END+'|'+  
   CASE   
    WHEN txtDMF IS NULL OR txtDMF = '-' OR txtDMF = 'NA' THEN ''   
    ELSE RTRIM(txtDMF)   
   END+'|'+  
   CASE   
    WHEN txtDMF IS NULL OR txtDMF = '-' OR txtDMF = 'NA' THEN ''   
    ELSE RTRIM(txtDMF)   
   END  
   
   +'|'+  
   CASE   
    WHEN txtSPQ IS NULL OR txtSPQ = '-' OR txtSPQ = 'NA' THEN ''   
    ELSE RTRIM(txtSPQ)   
   END  
   +'|'+  
   CASE   
    WHEN txtFIQ IS NULL OR txtFIQ2 = '-' OR txtFIQ2 = 'NA' THEN ''   
    ELSE RTRIM(txtFIQ2)   
   END  
   +'|'+  
   CASE   
    WHEN txtDPQ IS NULL OR txtDPQ = '-' OR txtDPQ = 'NA' THEN ''   
    ELSE RTRIM(txtDPQ)   
   END  
   +'|'+  
   CASE   
    WHEN txtHRQ IS NULL OR txtHRQ = '-' OR txtHRQ = 'NA' THEN ''   
    ELSE RTRIM(txtHRQ)   
   END  
      +'|'+  
   CASE   
    WHEN txtCTY IS NULL OR txtCTY = '-' OR txtCTY = 'NA' THEN ''   
    ELSE RTRIM(txtCTY)   
   END  
   
  FROM @tmp_tblTemp  
  
 -- Valida la información     
 IF EXISTS(  
  SELECT TOP 1 intsection  
  FROM @tblResult  
 )  
 BEGIN  
  -- Reporto informacion       
   SELECT   
   LTRIM(txtData)       
   FROM @tblResult      
   ORDER BY intSection    
 END  
 ELSE   
  RAISERROR ('ERROR: Falta Informacion', 16, 1)    
  
 SET NOCOUNT OFF   
      
END  