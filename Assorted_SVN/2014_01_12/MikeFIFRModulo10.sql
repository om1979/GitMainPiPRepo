--VIFR_EXCEL sp_createVectorFile ;10   --;55 NAcional
--VIFR_TEXT
--sp_helptext 
--sp_createVectorFile ;10


--dbo.tmp_tblUnifiedPricesReport_20140718
  
------------------------------------------------------------------------------------------------------------------------------------  
-- Autor:    Mike Ramírez  
-- Fecha Modificacion: 15:53 p.m. 2014-03-11  
-- Descripcion:   Modulo 10: Cambios mayores en campos: Titulos Operados, Fecha de Emisión, Fecha Vencimiento, Días por vencer   
------------------------------------------------------------------------------------------------------------------------------------  
--CREATE PROCEDURE dbo.   sp_createVectorFile;10   '20140731'
 DECLARE  @txtDate AS VARCHAR(10)--,  
 declare @txtOwner AS VARCHAR(50) = 'all'--, -- Todos los instrumentos son por default  
 declare @txtVectorInfo AS VARCHAR(10) = 'all' -- Toda tipo de información es por default  
            --  puede ser 'all', 'sn', 'trad'  
  
--AS   
--BEGIN  
-- SET NOCOUNT ON  
  
 -- Creamos deposito  
 DECLARE @tblTemp TABLE (  
      [Fecha][VARCHAR](8),  
      [Tipo Valor][VARCHAR](10),  
      [Emisora][VARCHAR](10),  
      [Serie][VARCHAR](10),  
      [ISIN][CHAR](12),  
      [Fecha de Emisión][VARCHAR](50),  
      [Fecha de Vencimiento][VARCHAR](50),  
      [Días por vencer][FLOAT],  
      [Fácil Realización][CHAR](2),  
      [Monto en Circulación][FLOAT],  
      [Monto Acumulado de operación 60d][FLOAT],  
      [Monto promedio de Operación diaria 60d][FLOAT],  
      [Índice de Operación acumulado][FLOAT],  
      [Índice de Operación Promedio 60d][FLOAT],  
      [títulos operados en el día][FLOAT],  
      [títulos acumulados operados en 60 días][FLOAT],  
      [títulos promedio operados en 60 días][FLOAT],  
      PRIMARY KEY CLUSTERED (  
       [Tipo Valor], [Emisora], [Serie]  
       )  
     )  
  
 -- Insertamos datos tradicionales  
 IF @txtVectorInfo IN ('all','trad')  
  
  -- Agrego Bonds   
  INSERT @tblTemp  
  SELECT DISTINCT  
   @txtDate AS [Fecha],  
   ap.txtTv AS [Tipo Valor],  
   ap.txtEmisora AS [Emisora],  
   ap.txtSerie AS [Serie],  
            CASE  
                 WHEN (a1.txtId2 IS NULL OR LEN(a1.txtId2) <> 12 ) THEN ''  
                 ELSE CONVERT(CHAR(12),a1.txtId2)  
   END AS [ISIN],  
   CASE  
    WHEN a1.txtISD IS NULL THEN a1.txtISD  
    WHEN a1.txtISD = '-' THEN NULL  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtISD,1,4) +   
     SUBSTRING(a1.txtISD,6,2) +   
     SUBSTRING(a1.txtISD,9,2)  
   END AS [Fecha de Emisión],  
   CASE  
    WHEN a1.txtMTD IS NULL THEN a1.txtMTD  
    WHEN a1.txtMTD = '-' THEN NULL  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtMTD,1,4) +   
     SUBSTRING(a1.txtMTD,6,2) +   
     SUBSTRING(a1.txtMTD,9,2)  
    END AS [Fecha de Vencimiento],  
   ap.dblDTM AS [Días por vencer],  
         CASE   
    WHEN a1.txtFIFR = '1' THEN 'SI'   
    ELSE 'NO'  
   END AS [Fácil Realización],  
   CASE WHEN a1.txtMOC <> '-' AND a1.txtMOC <> 'NULL' AND a1.txtMOC <> 'NA' THEN CAST(a1.txtMOC AS FLOAT)   
     ELSE NULL  
   END AS [Monto en Circulación],  
   CASE WHEN a1.txtMAO60 <> '-' AND a1.txtMAO60 <> 'NULL' AND a1.txtMAO60 <> 'NA' THEN CAST(a1.txtMAO60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto Acumulado de operación 60d],  
   CASE WHEN a1.txtMPOD60 <> '-' AND a1.txtMPOD60 <> 'NULL' AND a1.txtMPOD60 <> 'NA' THEN CAST(a1.txtMPOD60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto promedio de Operación diaria 60d],  
   CASE WHEN a1.txtIOA60 <> '-' AND a1.txtIOA60 <> 'NULL' AND a1.txtIOA60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOA60 AS FLOAT)<100 THEN CAST(a1.txtIOA60 AS FLOAT) ELSE 99.999999 END   
     ELSE 0  
   END AS [Índice de Operación acumulado],  
   CASE WHEN a1.txtIOP60 <> '-' AND a1.txtIOP60 <> 'NULL' AND a1.txtIOP60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOP60 AS FLOAT)<100 THEN CAST(a1.txtIOP60 AS FLOAT) ELSE 99.999999 END  
     ELSE 0  
   END AS [Índice de Operación Promedio 60d],  
   CASE WHEN a2.txtTOD <> '-' AND a2.txtTOD <> 'NULL' AND a2.txtTOD <> 'NA' THEN CAST(a2.txtTOD AS FLOAT)   
     ELSE NULL  
   END AS [títulos operados en el día],  
   CASE WHEN a2.txtTAO60 <> '-' AND a2.txtTAO60 <> 'NULL' AND a2.txtTAO60 <> 'NA' THEN CAST(a2.txtTAO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos acumulados operados en 60 días],  
   CASE WHEN a2.txtTPO60 <> '-' AND a2.txtTPO60 <> 'NULL' AND a2.txtTPO60 <> 'NA' THEN CAST(a2.txtTPO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos promedio operados en 60 días]  
 FROM tmp_tblActualPrices AS ap (NOLOCK)  
 INNER JOIN tblBonds b (NOLOCK)  
  ON ap.txtId1 = b.txtId1   
 INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
  ON a1.txtId1 = ap.txtId1  
  AND a1.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 INNER JOIN tmp_tblActualAnalytics_2 AS a2 (NOLOCK)  
  ON a2.txtId1 = ap.txtId1  
  AND a2.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 WHERE  
  ap.txtLiquidation = 'MD'  
 AND b.txtType NOT IN ('EU2','EM2')  
  
 -- Agrego Equity  
 INSERT @tblTemp  
 SELECT DISTINCT  
   @txtDate AS [Fecha],  
   ap.txtTv AS [Tipo Valor],  
   ap.txtEmisora AS [Emisora],  
   ap.txtSerie AS [Serie],  
            CASE  
                 WHEN (a1.txtId2 IS NULL OR LEN(a1.txtId2) <> 12 ) THEN ''  
                 ELSE CONVERT(CHAR(12),a1.txtId2)  
   END AS [ISIN],  
   CASE  
    WHEN a1.txtISD IS NULL THEN a1.txtISD  
    WHEN a1.txtISD = '-' THEN NULL  
    WHEN a1.txtISD = 'NA' THEN '        '  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtISD,1,4) +   
     SUBSTRING(a1.txtISD,6,2) +   
     SUBSTRING(a1.txtISD,9,2)  
   END AS [Fecha de Emisión],  
   CASE  
    WHEN a1.txtMTD IS NULL THEN a1.txtMTD  
    WHEN a1.txtMTD = '-' THEN NULL  
    WHEN a1.txtMTD = 'NA' THEN '        '  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtMTD,1,4) +   
     SUBSTRING(a1.txtMTD,6,2) +   
     SUBSTRING(a1.txtMTD,9,2)  
    END AS [Fecha de Vencimiento],  
   ap.dblDTM AS [Días por vencer],  
          CASE   
    WHEN a1.txtFIFR = '1' THEN 'SI'   
    ELSE 'NO'  
   END AS [Fácil Realización],  
   CASE WHEN a1.txtMOC <> '-' AND a1.txtMOC <> 'NULL' AND a1.txtMOC <> 'NA' THEN CAST(a1.txtMOC AS FLOAT)   
     ELSE NULL  
   END AS [Monto en Circulación],  
   CASE WHEN a1.txtMAO60 <> '-' AND a1.txtMAO60 <> 'NULL' AND a1.txtMAO60 <> 'NA' THEN CAST(a1.txtMAO60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto Acumulado de operación 60d],  
   CASE WHEN a1.txtMPOD60 <> '-' AND a1.txtMPOD60 <> 'NULL' AND a1.txtMPOD60 <> 'NA' THEN CAST(a1.txtMPOD60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto promedio de Operación diaria 60d],  
  
   CASE WHEN a1.txtIOA60 <> '-' AND a1.txtIOA60 <> 'NULL' AND a1.txtIOA60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOA60 AS FLOAT)<100 THEN CAST(a1.txtIOA60 AS FLOAT) ELSE 99.999999 END   
     ELSE 0  
   END AS [Índice de Operación acumulado],  
   CASE WHEN a1.txtIOP60 <> '-' AND a1.txtIOP60 <> 'NULL' AND a1.txtIOP60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOP60 AS FLOAT)<100 THEN CAST(a1.txtIOP60 AS FLOAT) ELSE 99.999999 END  
     ELSE 0  
   END AS [Índice de Operación Promedio 60d],  
   CASE WHEN a2.txtTOD <> '-' AND a2.txtTOD <> 'NULL' AND a2.txtTOD <> 'NA' THEN CAST(a2.txtTOD AS FLOAT)   
     ELSE NULL  
   END AS [títulos operados en el día],  
   CASE WHEN a2.txtTAO60 <> '-' AND a2.txtTAO60 <> 'NULL' AND a2.txtTAO60 <> 'NA' THEN CAST(a2.txtTAO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos acumulados operados en 60 días],  
   CASE WHEN a2.txtTPO60 <> '-' AND a2.txtTPO60 <> 'NULL' AND a2.txtTPO60 <> 'NA' THEN CAST(a2.txtTPO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos promedio operados en 60 días]  
 FROM tmp_tblActualPrices AS ap (NOLOCK)  
 INNER JOIN tblEquity e (NOLOCK)  
  ON ap.txtId1 = e.txtId1   
 INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
  ON a1.txtId1 = ap.txtId1  
  AND a1.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 INNER JOIN tmp_tblActualAnalytics_2 AS a2 (NOLOCK)  
  ON a2.txtId1 = ap.txtId1  
  AND a2.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 WHERE  
  ap.txtLiquidation = 'MP'  
  AND ap.txtTV NOT IN ('1I','1ISP')  
  
 -- Agrego 1I,1ISP  
 INSERT @tblTemp  
 SELECT DISTINCT  
   @txtDate AS [Fecha],  
   ap.txtTv AS [Tipo Valor],  
   ap.txtEmisora AS [Emisora],  
   ap.txtSerie AS [Serie],  
            CASE  
                 WHEN (a1.txtId2 IS NULL OR LEN(a1.txtId2) <> 12 ) THEN ''  
                 ELSE CONVERT(CHAR(12),a1.txtId2)  
   END AS [ISIN],  
   CASE  
    WHEN a1.txtISD IS NULL THEN a1.txtISD  
    WHEN a1.txtISD = '-' THEN NULL  
    WHEN a1.txtISD = 'NA' THEN '        '  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtISD,1,4) +   
     SUBSTRING(a1.txtISD,6,2) +   
     SUBSTRING(a1.txtISD,9,2)  
   END AS [Fecha de Emisión],  
   CASE  
    WHEN a1.txtMTD IS NULL THEN a1.txtMTD  
    WHEN a1.txtMTD = '-' THEN NULL  
    WHEN a1.txtMTD = 'NA' THEN '        '  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtMTD,1,4) +   
     SUBSTRING(a1.txtMTD,6,2) +   
     SUBSTRING(a1.txtMTD,9,2)  
    END AS [Fecha de Vencimiento],  
   ap.dblDTM AS [Días por vencer],  
          CASE   
    WHEN a1.txtFIFR = '1' THEN 'SI'   
    ELSE 'NO'  
   END AS [Fácil Realización],  
   CASE WHEN a1.txtMOC <> '-' AND a1.txtMOC <> 'NULL' AND a1.txtMOC <> 'NA' THEN CAST(a1.txtMOC AS FLOAT)   
     ELSE NULL  
   END AS [Monto en Circulación],  
   CASE WHEN a1.txtMAO60 <> '-' AND a1.txtMAO60 <> 'NULL' AND a1.txtMAO60 <> 'NA' THEN CAST(a1.txtMAO60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto Acumulado de operación 60d],  
   CASE WHEN a1.txtMPOD60 <> '-' AND a1.txtMPOD60 <> 'NULL' AND a1.txtMPOD60 <> 'NA' THEN CAST(a1.txtMPOD60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto promedio de Operación diaria 60d],  
  
   CASE WHEN a1.txtIOA60 <> '-' AND a1.txtIOA60 <> 'NULL' AND a1.txtIOA60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOA60 AS FLOAT)<100 THEN CAST(a1.txtIOA60 AS FLOAT) ELSE 99.999999 END   
     ELSE 0  
   END AS [Índice de Operación acumulado],  
   CASE WHEN a1.txtIOP60 <> '-' AND a1.txtIOP60 <> 'NULL' AND a1.txtIOP60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOP60 AS FLOAT)<100 THEN CAST(a1.txtIOP60 AS FLOAT) ELSE 99.999999 END  
     ELSE 0  
   END AS [Índice de Operación Promedio 60d],  
   CASE WHEN a2.txtTOD <> '-' AND a2.txtTOD <> 'NULL' AND a2.txtTOD <> 'NA' THEN CAST(a2.txtTOD AS FLOAT)   
     ELSE NULL  
   END AS [títulos operados en el día],  
   CASE WHEN a2.txtTAO60 <> '-' AND a2.txtTAO60 <> 'NULL' AND a2.txtTAO60 <> 'NA' THEN CAST(a2.txtTAO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos acumulados operados en 60 días],  
   CASE WHEN a2.txtTPO60 <> '-' AND a2.txtTPO60 <> 'NULL' AND a2.txtTPO60 <> 'NA' THEN CAST(a2.txtTPO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos promedio operados en 60 días]  
 FROM tmp_tblActualPrices AS ap (NOLOCK)  
 INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
  ON a1.txtId1 = ap.txtId1  
  AND a1.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 INNER JOIN tmp_tblActualAnalytics_2 AS a2 (NOLOCK)  
  ON a2.txtId1 = ap.txtId1  
  AND a2.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 WHERE  
  ap.txtLiquidation = 'MP'  
  AND ap.txtTV IN ('1I','1ISP')  
  
 -- Agrego Derivatives  
 INSERT @tblTemp  
 SELECT DISTINCT  
   @txtDate AS [Fecha],  
   ap.txtTv AS [Tipo Valor],  
   ap.txtEmisora AS [Emisora],  
   ap.txtSerie AS [Serie],  
            CASE  
                 WHEN (a1.txtId2 IS NULL OR LEN(a1.txtId2) <> 12 ) THEN ''  
    ELSE CONVERT(CHAR(12),a1.txtId2)  
   END AS [ISIN],  
   CASE  
    WHEN a1.txtISD IS NULL THEN a1.txtISD  
    WHEN a1.txtISD = '-' THEN NULL  
    WHEN a1.txtISD = 'NA' THEN '        '  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtISD,1,4) +   
     SUBSTRING(a1.txtISD,6,2) +   
     SUBSTRING(a1.txtISD,9,2)  
   END AS [Fecha de Emisión],  
   CASE  
    WHEN a1.txtMTD IS NULL THEN a1.txtMTD  
    WHEN a1.txtMTD = '-' THEN NULL  
    WHEN a1.txtMTD = 'NA' THEN '        '  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtMTD,1,4) +   
     SUBSTRING(a1.txtMTD,6,2) +   
     SUBSTRING(a1.txtMTD,9,2)  
    END AS [Fecha de Vencimiento],  
   ap.dblDTM AS [Días por vencer],  
          CASE   
    WHEN a1.txtFIFR = '1' THEN 'SI'   
    ELSE 'NO'  
   END AS [Fácil Realización],  
   CASE WHEN a1.txtMOC <> '-' AND a1.txtMOC <> 'NULL' AND a1.txtMOC <> 'NA' THEN CAST(a1.txtMOC AS FLOAT)   
     ELSE NULL  
   END AS [Monto en Circulación],  
   NULL AS [Monto Acumulado de operación 60d],  
   NULL AS [Monto promedio de Operación diaria 60d],  
    0 AS [Índice de Operación acumulado],  
   0 AS [Índice de Operación Promedio 60d],  
   NULL AS [títulos operados en el día],  
   NULL AS [títulos acumulados operados en 60 días],  
   NULL AS [títulos promedio operados en 60 días]  
 FROM tmp_tblActualPrices AS ap (NOLOCK)  
 INNER JOIN tblDerivatives d (NOLOCK)  
  ON ap.txtId1 = d.txtId1   
 INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
  ON a1.txtId1 = ap.txtId1  
  AND a1.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 INNER JOIN tmp_tblActualAnalytics_2 AS a2 (NOLOCK)  
  ON a2.txtId1 = ap.txtId1  
  AND a2.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 WHERE  
  ap.txtLiquidation = 'MP'  
  
 -- insertamos datos de notas estructuradas  
 IF @txtVectorInfo IN ('all','sn')  
  INSERT @tblTemp  
  SELECT DISTINCT  
   @txtDate AS [Fecha],  
   ap.txtTv AS [Tipo Valor],  
   ap.txtEmisora AS [Emisora],  
   ap.txtSerie AS [Serie],  
            CASE  
                 WHEN (a1.txtId2 IS NULL OR LEN(a1.txtId2) <> 12 ) THEN ''  
                 ELSE CONVERT(CHAR(12),a1.txtId2)  
   END AS [ISIN],  
   CASE  
    WHEN a1.txtISD IS NULL THEN a1.txtISD  
    WHEN a1.txtISD = '-' THEN NULL  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtISD,1,4) +   
     SUBSTRING(a1.txtISD,6,2) +   
     SUBSTRING(a1.txtISD,9,2)  
   END AS [Fecha de Emisión],  
   CASE  
    WHEN a1.txtMTD IS NULL THEN a1.txtMTD  
    WHEN a1.txtMTD = '-' THEN NULL  
    WHEN LEN(RTRIM(a1.txtISD))< 10 THEN NULL  
    ELSE   
     SUBSTRING(a1.txtMTD,1,4) +   
     SUBSTRING(a1.txtMTD,6,2) +   
     SUBSTRING(a1.txtMTD,9,2)  
    END AS [Fecha de Vencimiento],  
   ap.dblDTM AS [Días por vencer],  
         CASE   
    WHEN a1.txtFIFR = '1' THEN 'SI'   
    ELSE 'NO'  
   END AS [Fácil Realización],  
   CASE WHEN a1.txtMOC <> '-' AND a1.txtMOC <> 'NULL' AND a1.txtMOC <> 'NA' THEN CAST(a1.txtMOC AS FLOAT)   
     ELSE NULL  
   END AS [Monto en Circulación],  
   CASE WHEN a1.txtMAO60 <> '-' AND a1.txtMAO60 <> 'NULL' AND a1.txtMAO60 <> 'NA' THEN CAST(a1.txtMAO60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto Acumulado de operación 60d],  
   CASE WHEN a1.txtMPOD60 <> '-' AND a1.txtMPOD60 <> 'NULL' AND a1.txtMPOD60 <> 'NA' THEN CAST(a1.txtMPOD60 AS FLOAT)   
     ELSE NULL  
   END AS [Monto promedio de Operación diaria 60d],  
   CASE WHEN a1.txtIOA60 <> '-' AND a1.txtIOA60 <> 'NULL' AND a1.txtIOA60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOA60 AS FLOAT)<100 THEN CAST(a1.txtIOA60 AS FLOAT) ELSE 99.999999 END   
     ELSE 0  
   END AS [Índice de Operación acumulado],  
   CASE WHEN a1.txtIOP60 <> '-' AND a1.txtIOP60 <> 'NULL' AND a1.txtIOP60 <> 'NA'   
     THEN CASE WHEN CAST(a1.txtIOP60 AS FLOAT)<100 THEN CAST(a1.txtIOP60 AS FLOAT) ELSE 99.999999 END  
     ELSE 0  
   END AS [Índice de Operación Promedio 60d],  
   CASE WHEN a2.txtTOD <> '-' AND a2.txtTOD <> 'NULL' AND a2.txtTOD <> 'NA' THEN CAST(a2.txtTOD AS FLOAT)   
     ELSE NULL  
   END AS [títulos operados en el día],  
   CASE WHEN a2.txtTAO60 <> '-' AND a2.txtTAO60 <> 'NULL' AND a2.txtTAO60 <> 'NA' THEN CAST(a2.txtTAO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos acumulados operados en 60 días],  
   CASE WHEN a2.txtTPO60 <> '-' AND a2.txtTPO60 <> 'NULL' AND a2.txtTPO60 <> 'NA' THEN CAST(a2.txtTPO60 AS FLOAT)   
     ELSE NULL  
   END AS [títulos promedio operados en 60 días]  
 FROM tmp_tblActualPricesSN AS ap (NOLOCK)  
 INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)  
  ON ap.txtId1 = op.txtDir  
 INNER JOIN tblBonds b (NOLOCK)  
  ON ap.txtId1 = b.txtId1   
 INNER JOIN tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
  ON a1.txtId1 = ap.txtId1  
  AND a1.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 INNER JOIN tmp_tblActualAnalytics_2 AS a2 (NOLOCK)  
  ON a2.txtId1 = ap.txtId1  
  AND a2.txtLiquidation = (  
   CASE ap.txtLiquidation    
   WHEN 'MP' THEN 'MD'    
   ELSE ap.txtLiquidation    
   END  
  )  
 WHERE  
  ap.txtLiquidation = 'MD'  
 AND b.txtType NOT IN ('EU2','EM2')  
 AND op.txtOwnerId IN (  
  SELECT * FROM fun_select_owners (@txtOwner)  
 )  
 AND op.txtProductId IN ('SNOTES', 'PEQUITY')  
 AND op.dteBeg <= @txtDate  
 AND op.dteEnd >= @txtDate  
  
 DELETE FROM @tblTemp WHERE [Monto en Circulación] > 99999999999999.99  
   
 UPDATE @tblTemp SET [Fácil Realización] = 'SI'  
 WHERE [Tipo Valor] IN ('94','1B') AND [Emisora] IN ('BSANT','NAFTRAC') AND [Serie] IN ('11-2','02')  
  
 UPDATE @tblTemp SET [Fácil Realización] = 'SI'  
 WHERE [Tipo Valor] IN ('IM','IQ')  
  
 -- Para los fondos HSBC  
 UPDATE @tblTemp   
  SET [Fácil Realización] = 'SI'  
 WHERE [Emisora] IN ('HSBC-RV','HSBCDOL','HSBCF1+','HSBC-F0','HSBC-MP','HSBCBOL','HSBC-D2','HSBCCOR')   
 
 
  -- Para los fondos HSBC  
 UPDATE @tblTemp   
  SET [Fácil Realización] = 'SI'  
 WHERE [Emisora] = 'TEMFAIA' AND [Serie] = 'LX' AND [Tipo Valor] IN ('56','56SP')
 
 
 
 SELECT  
  [Fecha],  
  [Tipo Valor],  
  [Emisora],  
  [Serie],  
  [ISIN],  
  CASE  
   WHEN [Tipo Valor] IN ('0','00','1','1A','1E','1I','51','52','53','54','55','56','1B','3','41','1S','1R','1C','CF','YY') THEN NULL  
  ELSE [Fecha de Emisión] END,  
  CASE   
   WHEN [Tipo Valor] IN ('0','00','1','1A','1E','1I','51','52','53','54','55','56','1B','3','41','1S','1R','1C','CF','YY') THEN NULL  
  ELSE [Fecha de Vencimiento] END,  
  CASE   
   WHEN [Tipo Valor] IN ('0','00','1','1A','1E','1I','51','52','53','54','55','56','1B','3','41','1S','1R','1C','CF','YY') THEN NULL  
  ELSE [Días por vencer] END,  
  [Fácil Realización],  
  [Monto en Circulación],  
  [Monto Acumulado de operación 60d],  
  [Monto promedio de Operación diaria 60d],  
  [Índice de Operación acumulado],  
  [Índice de Operación Promedio 60d],  
  CASE   
   WHEN [Tipo Valor] IN ('51','52','53','54','55','56') THEN NULL  
  ELSE [títulos operados en el día] END,  
  [títulos acumulados operados en 60 días],  
  [títulos promedio operados en 60 días]  
 FROM @tblTemp  
 WHERE  
  [Emisora] NOT LIKE ('URUG%')   
  AND [Emisora] NOT LIKE ('ARGE%')  
  AND [Emisora] NOT LIKE ('GREE%')    

 ORDER BY   
  [Tipo Valor],  
  [Emisora],  
  [Serie]  
  
 SET NOCOUNT OFF  
  
--END  
--   Descripcion:     Se modifico para incluir los TV = 1I  

  