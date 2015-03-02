  
  
    
ALTER     PROCEDURE [dbo].[sp_productos_DEUTSCHEBANK];5   
 --DECLARE   
 @dtedate VARCHAR(10) --  = '20140814'  
   
 AS    
 BEGIN     
 SET NOCOUNT ON     
    
    
    /*obtenemos fechas maximas por tipo de irc asi como su valor para esa fecha */
  DECLARE      @getirctotable TABLE  
  (  
  txtIRC VARCHAR(7),  
  dteDate DATETIME  ,
  dblValue FLOAT
  
  )  
  INSERT INTO @getirctotable  
  SELECT txtIRC,dteDate,dblValue FROM dbo.tblIrc  AS C    
  WHERE dteDate = (SELECT MAX(dteDate) FROM dbo.tblIrc  AS AA WHERE AA.txtIRC = C.txtIRC )  
    
    
    /*otenemos universo de unficada y dircetivas por clientes con el fin de acelear consulta*/
  DECLARE  @tmp_tblUnifiedLinked TABLE 
  (
    txtId1 VARCHAR(12),
    txtDir VARCHAR(50),
    smallCur varchar(4)   
  )
  INSERT INTO @tmp_tblUnifiedLinked
   SELECT rep.txtId1 ,owners2.txtDir,SUBSTRING(rep.txtCUR,2,3)  FROM MxProcesses.dbo.tblOwnersVsProductsDirectives AS owners2 
   INNER  JOIN dbo.tmp_tblUnifiedPricesReport AS Rep    
   ON owners2.txtDir = Rep.txtId1    
   WHERE    owners2.txtOwnerId = 'db02'    
  AND owners2.txtProductId = 'vpi'    
     
    
    
    
    /*se usa unificada , tblirc para obtener ids1,valor de idi */
  DECLARE  @tblGetIrc TABLE    
  (    
  txtId1 VARCHAR(12),    
  txtDir VARCHAR(50),    
  smallCur varchar(4),    
  txtValue VARCHAR(50)    
  )    
   INSERT @tblGetIrc    
  SELECT     rep.txtId1,rep.txtDir,rep.smallCur ,c.dblValue    
  FROM     
  @tmp_tblUnifiedLinked AS rep 
  INNER JOIN dbo.tblIrc AS C 
  ON CASE WHEN smallCur = 'USD' THEN 'UFXU'    
  ELSE smallCur END  = c.txtIRC      
   AND C.dteDate = (select   MAX(dteDate) from @getirctotable AS AA WHERE AA.txtIrc = C.txtIRC)
   
  
    
--/*CARGAMOS INFORMACION PARA INDICES DE REFERENCIA */    
     
 DECLARE @temptableRef1 TABLE     
 (    
 TtxtIdi1H VARCHAR(12),    
 txtValueH VARCHAR(50)    
 PRIMARY KEY (TtxtIdi1H)    
 )    
    
 INSERT @temptableRef1    
  SELECT  a.txtId1,b.txtValue    
  FROM   dbo.tmp_tblunifiedpricesreport AS A    
  INNER   JOIN tblIdsadd AS B    
  ON a.txtId1 = b.txtId1    
    WHERE A.txtLiquidation IN ('MP')     
    AND txttv IN ('1I','1ISP','1B','1C')    
    AND txtItem = 'REF_IND'    
      AND   CONVERT(VARCHAR(10),b.dteDate,112) = (SELECT  MAX(CAST( CONVERT(VARCHAR(10),dteDate,112)AS VARCHAR(10)))  FROM    tblIdsadd WHERE dteDate NOT LIKE '%2102%' AND  txtId1 = a.txtId1)    
         
 DECLARE @temptableRef2 TABLE     
 (    
 TtxtIdi1I VARCHAR(12),    
 txtValueI VARCHAR(50)    
 PRIMARY KEY (TtxtIdi1I)     
 )    
  INSERT @temptableRef2    
 SELECT DISTINCT a.txtId1,b.txtValue    
   FROM   dbo.tmp_tblunifiedpricesreport AS A    
   LEFT OUTER  JOIN tblequityadd AS B    
   ON a.txtId1 = b.txtId1    
    WHERE A.txtLiquidation IN ('MP')     
    AND  txttv NOT IN ('1I','1ISP','1B','1C')    
    AND txtItem = 'REF_IND'    
    AND  CONVERT(VARCHAR(10),b.dteDate,112) =(SELECT  MAX(CAST( CONVERT(VARCHAR(10),dteDate,112)AS VARCHAR(10))) FROM       tblequityadd WHERE txtId1 = a.txtId1)    
        
        
  DECLARE   @IndicesREff  TABLE    
  (    
  txtIndiceREF VARCHAR(50),    
  txtid1 varchar(13)    
  PRIMARY KEY (txtId1)    
  )    
    
  INSERT @IndicesREff    
   SELECT     
   CASE     
    WHEN A.txtLiquidation = 'MD'  THEN  'NA'    
    WHEN A.txtLiquidation = 'MP' AND a.txttv IN ('1I','1ISP','1B','1C') THEN b.txtValueH    
    WHEN A.txtLiquidation = 'MP' AND a.txttv NOT IN ('1I','1ISP','1B','1C') THEN I.txtValueI    
    ELSE 'NA' END ,A.TXTID1    
    FROM   dbo.tmp_tblunifiedpricesreport AS A    
    LEFT OUTER   JOIN @temptableRef1 AS B    
    ON a.txtId1 = b.TtxtIdi1H    
    LEFT OUTER JOIN @temptableRef2 AS I    
    ON a.txtId1 = I.TtxtIdi1I    
      WHERE A.txtLiquidation IN ('MD','MP')     
            
        
        
    UPDATE r    
    SET txtIndiceREF = CASE WHEN r.txtIndiceREF IS NULL THEN 'NA' ELSE r.txtIndiceREF END     
    FROM @IndicesREff as r    
       
     
 /*    
 COMIENZA CONSULTA A REPORTAR    
 */    
 WITH T AS (    
 SELECT     
  txtTv,    
  txtEmisora,    
  txtSerie,    
  CASE WHEN LEN(txtID2)<12 THEN 'NA' ELSE txtID2 END  AS ID2,    
     
  SUBSTRING(TXTCUR,CHARINDEX('[',TXTCUR,1)+1,3)  AS TXTCUR ,    
      
   CASE     
    WHEN a.txtliquidation   = 'MP'   THEN  UPPER(txtSUS)    
    WHEN a.txtLiquidation   = 'MD'  AND   txtMTD  >= a.dteDate THEN 'VIGENTE'     
    WHEN a.txtliquidation   = 'MD'  AND   txtMTD  <= a.dteDate THEN 'VENCIDO'     
    ELSE 'NA'    
    END AS estatus,--estatus      
      
      
/*Tipo de Cambio*/    
  CASE     
      WHEN SUBSTRING(a.txtCUR,2,3) = 'MPS' THEN '1'     
   ELSE   GetIrc.txtValue END AS  tipo_de_cambio,    
     
    
--FACTOR RIESGO (CHECAR)    
 CASE WHEN a.txtSEC_STYPE = '-' THEN 'NA' ELSE a.txtSEC_STYPE  END   AS factor_riesgp,    
    
--Índice de Referencia    
 CASE WHEN txtDCR = '-'  THEN 'NA' ELSE txtDCR END AS DCR,    
     
--txtDCR,    
 dblPRS AS PRS,    
/*-- MERCADO*/      
     
 txtSMKT AS MERCADO,    
     
 /*CASE     
  WHEN txtTv IN ('0','00','1','1A','1B','1C','1E','1I','1ISP','1R','3','41','1S','CF','YY','1ASP','1ISP','YYSP','1ESP')     
  THEN 'MERCADO ACCIONARIO'    
  WHEN txtTv IN ('51','52','53','54','55','56','56SP') THEN 'SOCIEDAD DE INVERSION'    
  ELSE 'MERCADO DE DINERO'    
  END AS MERCADO, */    
     
     
 txtSPM AS SPM,    
 txtMOC AS MOC,    
    
    
    
/*PAGINA  2 DE WORD*/    
 txtVOL AS VOL,    
 txtCOUNTRY AS COUNTRY,    
    
    
 CASE WHEN txtIRTM = '' OR txtIRTM = NULL THEN 'NA' ELSE txtIRTM END  AS IRTM,    
 CASE WHEN txtIRTA = '' OR txtIRTA = NULL THEN 'NA' ELSE txtIRTA END  AS IRTA,    
 CASE WHEN txtIRTC = '' OR txtIRTC = NULL THEN 'NA' ELSE txtIRTC END  AS IRTC,    
    
/*Rendimiento Mensual*/    
 CASE WHEN txtRMEN = '' OR txtRMEN = NULL THEN 'NA' ELSE txtRMEN END  AS RMEN,    
    
/*Rendimiento del día*/    
 CASE WHEN txtRDIA = '' OR txtRDIA = NULL THEN 'NA' ELSE txtRDIA END  AS RDIA,    
    
/*VAR DE MERCADO*/    
 CASE WHEN txtVAR = 'Datos Insuficientes' THEN 'NA' ELSE txtVAR END  AS VAR1,    
     
 txtLCOM AS LCOM,    
/*--VAR DE LIQUIDEZ*/    
 txtLVAR AS LVAR,    
    
/*gARANTIA*/    
 CASE     
  WHEN a.txtLiquidation = 'MP' THEN  'NA'    
  WHEN a.txtQUIR = 'BURSATILIZACION' THEN  'SI'    
  WHEN a.txtQUIR = 'QUIROGRAFARIO' THEN  'NO'    ELSE txtQUIR     
  END AS GARANTIA,    
       
/*Tipo de Garantia*/    
    
    
CASE     
WHEN a.txttgar = 'B' THEN 'BURSATILIZACION'    
WHEN a.txttgar = 'F' THEN 'FIDEICOMISO'    
WHEN a.txttgar = 'G' THEN 'GARANTIA ESPECIFICA'    
WHEN a.txttgar = 'Q' THEN 'QUIROGRAFARIO' END     
 AS TGAR,     
     
/*AFORO*/     
 a.txtAFO_SPR_UN AS SPR_UN,    
     
    
    
    
/**/--BID (PENDIENTE)    
CASE WHEN    I.dblBidVolume is null THEN '0'    
ELSE      
CASE WHEN CONVERT(varchar(100),I.dblBidVolume ) = '#N/A' OR CONVERT(varchar(100),I.dblBidVolume ) = 'N/A' OR CONVERT(varchar(100),I.dblAskVolume ) = 'NA' THEN '0'    
ELSE CONVERT(varchar(100),I.dblBidVolume) END  END AS BID,    
    
--'NA',    
--'NA',    
    
----/**/--ASK (PENDIENTE)    
CASE WHEN   CONVERT(varchar(100),I.dblAskVolume )IS NULL THEN  '0'    
ELSE  CASE WHEN CONVERT(varchar(100),I.dblAskVolume ) = '#N/A' OR CONVERT(varchar(100),I.dblAskVolume ) = 'N/A' OR CONVERT(varchar(100),I.dblAskVolume ) = 'NA' THEN '0' ELSE      
CONVERT(varchar(100),I.dblAskVolume ) END END AS ASK,    
    
------/**/--Volumen_Operado (PENDIENTE)    
CASE WHEN  I.dblBidVolume - I.dblAskVolume IS NULL   THEN '0'    
ELSE        
 CONVERT(varchar(100),I.dblBidVolume- I.dblAskVolume) END AS DIIFOPE ,    
    
       
dblDTM AS dtm    
    
 FROM   dbo.tmp_tblunifiedpricesreport AS A    
       
  LEFT OUTER JOIN @IndicesREff AS H    
   ON A.txtid1 = H.TXTID1    
       
  LEFT OUTER  JOIN tblIrc AS IRC    
 ON a.txtEmisora = IRC.txtIRC AND IRC.dteDate = (SELECT MAX(dteDate) FROM dbo.tblIrc WHERE A.txtEmisora = IRC.txtIRC)    
     
 LEFT OUTER JOIN @tblGetIrc AS GetIrc    
 ON a.txtId1 = GetIrc.txtId1    
     
RIGHT  JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS owners2 --323    
 ON a.txtId1 = owners2.txtDir      
     
     
 LEFT OUTER JOIN tblequitybidaskvolume AS I    
 ON owners2.txtDir = I.txtid1 AND I.dteDate = @dtedate    
     
    
 /*TGAR*/    
 WHERE   a.txtLiquidation IN ('MP','MD')    
    
 AND txtTv NOT IN     
     
 (    
 '*C','*CSP','1ASP','1ESP','1ISP',    
 '54','56SP','91SP','D1SP',    
 'D2SP','D4SP','D5SP','D6SP',    
 'D7SP','D8SP','FA','FB',    
 'FC','FD','FI','FM',    
 'FS','FSP','FU','JISP',    
 'JSP','OA','OD','OI',    
 'QSP','R3SP SWT','TR',    
 'WA','WC','WI','YYSP'    
 )    
  
  AND   owners2.txtOwnerId = 'db02'    
  AND owners2.txtProductId = 'vpi'    
     
    
    
/*agregamos union para cargar solo las columna  valores de IRC'S en consulta */    
UNION     
 SELECT     
 ISNULL(NULL,'xxxxxx'),-- SE AGREGA ESTE VALOR PARA REPORTAR TIPOS DE CAMBIO AL ULTIMO    
 txtIRC,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 CONVERT(VARCHAR(50),dblValue),    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
 ISNULL(NULL,'') ,    
    ISNULL(NULL,'') ,    
 ISNULL(NULL,'')     
     
     
 from  dbo.tblIrc AS t1      
  WHERE t1.txtIRC  IN      
   (    
 'MEXBOL'    
 ,'COMP'    
 ,'SPX'    
 ,'LATIBE2'    
 ,'LATIBEX'    
 ,'UKX'    
 ,'QQQQ'---no aparece     
 ,'EWZ'    
 ,'EWH'    
 ,'IBOV'    
 ,'DAX'    
 ,'NKY'    
 ,'IBB'    
 ,'EWA'    
 ,'NDX'    
 ,'NQX')    
  AND dteDate = (SELECT MAX(dteDate) FROM tblIrc T2 WHERE T1.txtIRC = T2.txtIRC)    
      
   )    
    
 SELECT     
  CASE WHEN TXTTV = 'xxxxxx' THEN RTRIM(LTRIM('')) ELSE RTRIM(LTRIM(TXTTV)) END ,    
  TXTEMISORA,    
  TXTSERIE,    
  ID2,    
  TXTCUR,    
  ESTATUS,    
  TIPO_DE_CAMBIO,    
  FACTOR_RIESGP,    
  DCR,    
  PRS,    
  MERCADO,    
  SPM,MOC,VOL,COUNTRY,IRTM,IRTA,    
  IRTC,RMEN,RDIA,VAR1,LCOM,LVAR,GARANTIA,TGAR,SPR_UN,BID,ASK,DIIFOPE,DTM    
  FROM  T    
 ORDER BY  txttv --DESC      
SET NOCOUNT ON     
END 