
--CREATE PROCEDURE dbo.sp_createVectorFile;42   -- Caso: CNBVEXT  

 --AS   
 --BEGIN  
  
 --SET NOCOUNT ON  
 
DECLARE @tblGet24hPrsData TABLE 
(
dblPRS24H          FLOAT,
TXTID124H	       VARCHAR(11),
txtLiquidation24H  VARCHAR(3)
)
/*Cargamos informacion de LIQ 24H para columna de reporte Precio Sucio 24H*/
INSERT INTO @tblGet24hPrsData
SELECT  A.dblPRS,A.TXTID1,A.txtLiquidation
 FROM  dbo.tmp_tblUnifiedPricesReport AS A
WHERE A.txtLiquidation in ('24H','MP')



  
 DECLARE @tblTemp TABLE (  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtData][VARCHAR](8000),  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  

   --INSERT @tblTemp  
  
   SELECT DISTINCT  
    ap.txtTV,  
    ap.txtEmisora,  
    ap.txtSerie,
    'H '+
    CASE  
     WHEN ap.txtTv IN ('1', '1A', '1B', '1E', '3', '0', '41', '51', '52',   
                           '53', '54', 'YY', 'FA', 'FI', 'WA', 'WI','1AFX','1ASP','1I','1C') THEN 'MC'  
     ELSE 'MD'  
    END +  
    '20141006' +  
    ap.txtTv + REPLICATE(' ',4 - LEN(ap.txtTv)) +  
    ap.txtEmisora + REPLICATE(' ',7 - LEN(ap.txtEmisora)) +  
    ap.txtSerie + REPLICATE(' ',6 - LEN(ap.txtSerie)) +  
    
    CASE UPPER(ap.txtLiquidation)  
     WHEN 'MP'THEN  
       CASE WHEN ap.dblPAV < 0 THEN  
        '-' + SUBSTRING(REPLACE(STR(ROUND(ABS(ap.dblPAV),6),16,6),  ' ', '0'), 2, 8) +  
          SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
         SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
       END  
     ELSE  
       CASE WHEN ap.dblPRS < 0 THEN  
        '-' + SUBSTRING(REPLACE(STR(ROUND(ABS(ap.dblPRS),6),16,6),  ' ', '0'), 2, 8) +  
          SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 1, 9) +  
         SUBSTRING(REPLACE(STR(ROUND(ap.dblPRS,6),16,6),  ' ', '0'), 11, 6)  
       END  
    END+   
    
    CASE UPPER(ap.txtLiquidation)  
     WHEN 'MP'THEN  
       CASE WHEN ap.dblPAV < 0 THEN  
        '-' + SUBSTRING(REPLACE(STR(ROUND(ABS(ap.dblPAV),6),16,6),  ' ', '0'), 2, 8) +  
          SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 1, 9) +  
         SUBSTRING(REPLACE(STR(ROUND(ap.dblPAV,6),16,6),  ' ', '0'), 11, 6)  
       END  
     ELSE  
       CASE WHEN ap.dblPRL < 0 THEN  
        '-' + SUBSTRING(REPLACE(STR(ROUND(ABS(ap.dblPRL),6),16,6),  ' ', '0'), 2, 8) +  
          SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 11, 6)  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 1, 9) +  
         SUBSTRING(REPLACE(STR(ROUND(ap.dblPRL,6),16,6),  ' ', '0'), 11, 6)  
       END  
    END +   
  
    SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6),  ' ', '0'), 1, 6) +  
     SUBSTRING(REPLACE(STR(ROUND(ap.dblCPD,6),13,6), ' ', '0'), 8, 6) +  
    '025009' +  
    '1' +  
    SUBSTRING(REPLACE(STR(ROUND(ap.dblDTM,0),6,0),  ' ', '0'), 1, 6) +  
   
             CASE   
    WHEN ABS(ap.dblUDR) < 1E-4 THEN  '00000000'  
    WHEN ap.dblUDR < 0 THEN   
                    '-' + SUBSTRING(REPLACE(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  '-', '0'),' ','0'), 2, 3) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,6),9,4),  ' ', '0'), 6, 4)   
           ELSE   
             SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 1, 4) +   
                   SUBSTRING(REPLACE(STR(ROUND(ap.dblUDR,4),9,4),  ' ', '0'), 6, 4)  
           END  +
          
   --txtlcr        
       LTRIM(SUBSTRING(ap.txtlcr,0,9)) + REPLICATE(' ',8 - LEN(LTRIM(SUBSTRING(ap.txtlcr,0,9))))+
   --dblPRS
	   SUBSTRING(REPLACE(STR(ROUND(LTRIM(ISNULL(PrsData.dblPRS24H,0)),6),13,6),  ' ', '0'), 1, 6) + 
       SUBSTRING(REPLACE(STR(ROUND(ISNULL(PrsData.dblPRS24H,0),6),13,6), ' ', '0'), 8, 6)+
      -- STR(ROUND(LTRIM(ap.dblPRS),6),9,6) +REPLICATE('0',13 - LEN(STR(ROUND(LTRIM(ap.dblPRS),6),9,6)))--+ 
   -- AS DTC 
     LTRIM(CASE WHEN  ISNUMERIC(txtDTC) = 1 AND txtDTC NOT IN ('',' ','NA','-') THEN  LTRIM(STR(ROUND(LTRIM(ap.txtDTC),0),4,0)) +REPLICATE(' ',4 - LEN(LTRIM(STR(ROUND(LTRIM(ap.txtDTC),0),4,0)) ))
     ELSE 'NA  ' END) 

     
   FROM  dbo.tmp_tblUnifiedPricesReport AS ap (NOLOCK)  
   LEFT OUTER JOIN @tblGet24hPrsData AS PrsData
   ON ap.txtId1 = PrsData.TXTID124H
   
   WHERE   
    ap.txtLiquidation IN ('MD', 'MP')


--14417


