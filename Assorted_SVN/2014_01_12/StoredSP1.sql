

--SQL_STOREDP_PRODUCTOS_INVEX


--sp_helptext sp_productos_invex 


  
--CREATE  PROCEDURE dbo.sp_productos_INVEX;1   
    @txtDate AS VARCHAR(10) ,  
    @txtLiquidation AS VARCHAR(10)  
    
    
 --AS       
 --BEGIN      
    
 SELECT    
 --campos  
  txtEmisora + REPLICATE(' ', 7 - LEN(txtEmisora)) +     
  txtSerie + REPLICATE(' ', 6 - LEN(txtSerie)) +     
   CASE WHEN (txtPCR='NA' OR txtPCR = '-' OR txtPCR IS NULL) THEN '00000'     
   ELSE REPLICATE('0', 5 - LEN(RTRIM(txtPCR))) + RTRIM(txtPCR)    
   END +     
         txtTv + REPLICATE(' ', 4 - LEN(txtTv)) +  
         --si tv esta contenido en .. entonces ''   
  CASE    
      WHEN txtTv IN ('0','00','1','3','41','51','52','53','54','1A','1E','WA','WC','WI','FA','FB','FD','FI','YY','1B','1AFX','1ASP','1I','1ISP') THEN '  '    
      WHEN txtTv IN ('B','G','I','D','BI') THEN 'TD'    
      WHEN txtSerie LIKE ('%U%') THEN 'RU'    
      ELSE 'TR'    
      END +    
  CASE     
      WHEN txtBUR IN ('MEDIA') THEN 'MEDB'    
      WHEN txtBUR IN ('BAJA') THEN 'BAJB'    
      WHEN txtBUR IN ('NULA') THEN 'NULB'    
      WHEN txtBUR IN ('MINIMA') THEN 'MINB'    
      WHEN txtBUR IN ('ALTA') THEN 'ALTB'    
      ELSE '    '    
       END +    
  CASE    
      WHEN txtTv IN ('71','73','75','2','PI','D','R1','2U','3U','4U') THEN 'B03'    
      WHEN txtTv IN ('J','F','I','G','Q') THEN 'B02'    
      WHEN txtTv IN ('L','S3','S5','S0','D1','M3','M5','IP','LP','LS','LT','XA','B','M0','IT','M7','BI','M','IS','S') THEN 'B01'    
      WHEN txtTv IN ('WI') THEN 'D02'
      --si el valor cae aqui pasa a condicion anidada    
      WHEN txtTv IN ('WA','WC') 
      --condicion anidada
      THEN 'D01'    
		 WHEN txtTv IN ('0','00','1','3','41','1E','1ESP','1B','1AFX') THEN    
                        CASE WHEN txtSEC LIKE '%INDUSTRIA%' THEN 'A01'    
                             WHEN txtSEC LIKE '%COMERC%' THEN 'A02'    
                             WHEN txtSEC LIKE '%COMUNICACIONES%' THEN 'A03'    
                             WHEN txtSEC LIKE '%SERVIC%' THEN 'A04'    
                             WHEN txtSEC LIKE '%VARIO%' THEN 'A05'    
                                ELSE '   '    
                             END    
      WHEN txtTv IN ('1A','1ASP','1I','1ISP') THEN    
                        CASE WHEN txtSEC LIKE '%INDUSTRIA%' THEN 'S01'    
                             WHEN txtSEC LIKE '%COMERC%' THEN 'S02'    
                             WHEN txtSEC LIKE '%COMUNICACIONES%' THEN 'S03'    
                             WHEN txtSEC LIKE '%SERVIC%' THEN 'S04'    
                             WHEN txtSEC LIKE '%VARIO%' THEN 'S05'    
                                ELSE '   '    
                             END   
                             --fin de condicion anidada 
      ELSE '   '  
        
      END +    
      --se agregan demas campos
      --case es solo para restringir nulos
   CASE WHEN (txtSPQ='NA' OR txtSPQ = '-' OR txtSPQ IS NULL)     
   THEN '          '     
   ELSE RTRIM(txtSPQ) + REPLICATE(' ', 10 - LEN(txtSPQ))    
   END +     
   CASE WHEN (txtFIQ='NA' OR txtFIQ = '-' OR txtFIQ IS NULL)     
   THEN '          '     
   ELSE RTRIM(txtFIQ) + REPLICATE(' ', 10 - LEN(txtFIQ))    
   END +     
    CASE WHEN (txtDPQ='NA' OR txtDPQ = '-' OR txtDPQ IS NULL)     
   THEN '          '     
   ELSE RTRIM(txtDPQ) + REPLICATE(' ', 10 - LEN(txtDPQ))    
   END +     
  CASE WHEN (txtTIT='NA' OR txtTIT = '-' OR txtTIT IS NULL)     
   THEN '000000000000000'     
   ELSE REPLICATE('0', 15 - LEN(txtTIT)) + RTRIM(txtTIT)    
   END +     
  SUBSTRING(REPLACE(STR(ROUND(dblDTM,0),5,0),  ' ', '0'), 1, 5)  
 FROM dbo.tmp_tblUnifiedPricesreport     

 WHERE dteDate = @txtDate    
 --donde la liquidacion sea MP y la liquidacion pasada como variable
 AND txtLiquidation IN (@txtLiquidation,'MP')    
 --no este contenido en los siguinetes tv
 AND txtTv NOT IN ('*R','*C','*D','*F','*CSP')    
 ORDER BY txtTv,txtEmisora,txtSerie  
 
 
 
   
--END    
--RETURN 0   
