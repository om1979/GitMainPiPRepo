  
    
CREATE  PROCEDURE dbo.usp_ValidateAndUpdateAnalytics;6    
 @txtDate CHAR(8)    
/*     
 Autor:   CSOLORIO    
 Creacion:  20131204    
 Descripcion: Actualiza analiticos de TIT y TIE    
    
 Modificado por: Mike Ramirez     
 Modificacion: 20140616    
 Descripcion: Se modifica update que actualiza sobre temporales de analiticos    
   
*/     
  
AS    
BEGIN    
    
 SET NOCOUNT ON    
     
 CREATE TABLE #tblData(    
  txtId1 CHAR(11),    
  txtType CHAR(3),    
  dteDate DATE    
   PRIMARY KEY (txtId1,txtType))    
    
 CREATE TABLE #tblResults(    
  txtId1 CHAR(11),    
  txtItem CHAR(3),    
  txtValue VARCHAR(15)    
   PRIMARY KEY (txtId1,txtItem))    
    
 INSERT #tblData(    
  txtId1,    
  txtType,    
  dteDate)    
      
 SELECT     
  o.txtId1,    
  'MIN',   
  MIN(o.dteDate)    
 FROM tblOutstanding o (NOLOCK)    
 INNER JOIN tblIds i (NOLOCK)    
 ON    
  o.txtId1 = i.txtID1    
 INNER JOIN vw_prices_notes p    
 ON    
  o.txtId1 = p.txtID1    
 WHERE    
  o.dteDate <= @txtDate    
  AND p.dteDate = @txtDate    
 AND o.dblOutstanding > 0    
  AND (    
   i.txtTV NOT LIKE '%SP'    
   OR i.txtTV = 'SP')    
 GROUP BY    
  o.txtId1    
    
 UNION    
    
 SELECT     
  o.txtId1,    
  'MAX',    
  MAX(o.dteDate)    
 FROM tblOutstanding o (NOLOCK)    
 INNER JOIN tblIds i (NOLOCK)    
 ON    
  o.txtId1 = i.txtID1    
 INNER JOIN vw_prices_notes p    
 ON    
  o.txtId1 = p.txtID1    
 WHERE    
  o.dteDate <= @txtDate    
  AND p.dteDate = @txtDate    
  AND (    
   i.txtTV NOT LIKE '%SP'    
   OR i.txtTV = 'SP')    
 GROUP BY    
o.txtId1     
    
 INSERT #tblResults(    
  txtId1,    
  txtItem,    
  txtValue)     
      
 SELECT     
  d.txtId1,    
  'TIE',    
  LTRIM(RTRIM(STR(o.dblOutstanding,20,0)))    
 FROM #tblData d    
 INNER JOIN tblOutStanding o (NOLOCK)    
 ON    
  d.txtId1 = o.txtId1    
  AND d.dteDate = o.dteDate    
 WHERE    
  d.txtType = 'MIN'    
    
 UNION    
    
 SELECT     
  d.txtId1,    
  'TIT',    
  LTRIM(RTRIM(STR(o.dblOutstanding,20,0)))    
 FROM #tblData d    
 INNER JOIN tblOutStanding o (NOLOCK)    
 ON    
  d.txtId1 = o.txtId1    
  AND d.dteDate = o.dteDate    
 WHERE    
  d.txtType = 'MAX'    
    
 -- Los que faltan    
    
 INSERT tblDailyAnalytics(    
  txtId1,    
  txtLiquidation,    
  txtItem,    
  txtValue)    
    
 SELECT    
  r.txtId1,    
  'MD',    
  r.txtItem,    
  r.txtValue    
 FROM #tblResults r    
 INNER JOIN tblIds i (NOLOCK)    
 ON    
  r.txtId1 = i.txtID1    
 LEFT OUTER JOIN tblDailyAnalytics a    
 ON    
  r.txtId1 = a.txtId1    
  AND r.txtItem = a.txtItem    
  AND a.txtLiquidation = 'MD'    
 WHERE   
  a.txtId1 IS NULL      
 ORDER BY    
  r.txtId1,    
  r.txtItem    
    
 UPDATE a    
 SET     
  a.txtValue = r.txtValue    
 FROM #tblResults r    
 INNER JOIN tblDailyAnalytics a (NOLOCK)    
 ON    
  r.txtId1 = a.txtId1    
  AND r.txtItem = a.txtItem    
 AND a.txtLiquidation = 'MD'    
  AND r.txtValue != a.txtValue     
    
 -- Actualizo TIE    
      
 UPDATE t    
 SET     
  t.txtTIE = r.txtValue    
 FROM tmp_tblActualAnalytics_1 t (NOLOCK)    
 INNER JOIN tblDailyAnalytics a (NOLOCK)    
 ON    
  t.txtId1 = a.txtId1    
  AND t.txtLiquidation = a.txtLiquidation    
  --AND t.txtTIE != a.txtValue    
 INNER JOIN #tblResults r    
 ON    
  t.txtId1 = r.txtId1    
  AND a.txtItem = r.txtItem    
 WHERE    
  a.txtItem = 'TIE'    
  AND a.txtLiquidation = 'MD'    
    
UPDATE t    
 SET     
  t.txtTIT = r.txtValue    
 FROM tmp_tblActualAnalytics_1 t (NOLOCK)    
 INNER JOIN tblDailyAnalytics a (NOLOCK)    
 ON    
  t.txtId1 = a.txtId1    
  AND t.txtLiquidation = a.txtLiquidation    
  --AND t.txtTIT != a.txtValue    
 INNER JOIN #tblResults r    
 ON    
  t.txtId1 = r.txtId1    
  AND a.txtItem = r.txtItem    
 WHERE    
  a.txtItem = 'TIT'    
  AND a.txtLiquidation = 'MD'    
    
 SET NOCOUNT OFF    
     
END    
  