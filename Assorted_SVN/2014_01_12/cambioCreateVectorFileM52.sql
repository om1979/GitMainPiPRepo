








/*
------------------------------------------------------------------------------------------------------------------------------------  
--   Autor:    Mike Ramirez  
--   Modificacion:  13:14  201308012  
--   Descripcion:     Modulo 52: Se crea otro producto paralelo sp_createVectorFile;8 al generico solo con la información nancional 

--	Modifica: Omar Aceves Gutierrez
--	Fecha:	  2014-09-09 10:57:43.973
--	Objetivo: Retirar Notas Estructuradas 
-------------------------------------------------------------------------------------------------------------------------------------
*/  
CREATE PROCEDURE dbo.sp_createVectorFile;52  
   @txtDate AS VARCHAR(10),  
   @txtLiquidation AS VARCHAR(10),  
   @txtVectorInfo AS VARCHAR(10) = 'all' -- Toda tipo de información es por default  
            --  puede ser 'all', 'sn', 'trad'  
  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 -- Creamos deposito  
 DECLARE @tblTemp TABLE (  
      [dteDate][VARCHAR](8),  
      [txtTv][VARCHAR](10),  
      [txtEmisora][VARCHAR](10),  
      [txtSerie][VARCHAR](10),  
      [dblPRL][FLOAT],        [dblPRS][FLOAT],  
      [dblCPD][FLOAT],  
      [dblCPA][FLOAT],  
      [dblRate][FLOAT],  
      PRIMARY KEY CLUSTERED (  
       txtTV, txtEmisora, txtSerie  
       )  
     )  
  
  -- insertamos datos tradicionales  
  IF @txtVectorInfo IN ('all','trad')  
   INSERT @tblTemp  
   SELECT DISTINCT  
   CONVERT(CHAR(8),@txtDate,112) AS txtFecha,  
   RTRIM(ap.txtTv) AS txtTv,  
   RTRIM(ap.txtEmisora) AS txtEmisora,  
   RTRIM(ap.txtSerie) AS txtSerie,  
    
   CASE UPPER(ap.txtLiquidation)  
   WHEN 'MP'THEN ROUND(ap.dblPAV,6)  
   ELSE ROUND(ap.dblPRL,6)  
   END AS dblPRL,  
    
   CASE UPPER(ap.txtLiquidation)  
   WHEN 'MP'THEN 0  
   ELSE ROUND(ap.dblPRS,6)  
   END AS dblPRS,  
    
   ROUND(ap.dblCPD,6) AS dblCPD,  
   ROUND(ap.dblCPA,6) AS dblCPA,  
    
   CASE   
   WHEN ap.txtTv IN (  
    'IP',  
    'IT',  
    'L',  
    'LD',  
    'LP',  
    'LS',  
    'LT',  
    'XA',  
    'IS',  
    'IM',  
    'IQ'  
   ) THEN ROUND(ap.dblLDR,6)  
    
   WHEN ap.txtTv IN (  
    'B',  
    'BI',  
    'D',  
    'D3',  
    'G',  
    'I'  
   ) THEN ROUND(ap.dblUDR,6)  
    
   ELSE ROUND(ap.dblYTM,6)   
   
   END AS dblRate  
    
  FROM tmp_tblUnifiedPricesReportNac AS ap (NOLOCK)  
  WHERE   
   ap.txtLiquidation IN (@txtLiquidation, 'MP')  
   AND NOT txtTv IN ('*F', '*R', '*D')  
  
 SET NOCOUNT OFF  
  
 SELECT *  
 FROM @tblTemp  
 ORDER BY  
  txtTv,  
  txtEmisora,  
  txtSerie  
  
END  