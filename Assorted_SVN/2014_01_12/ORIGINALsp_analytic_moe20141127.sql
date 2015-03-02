        
        
        
  /*
  original produccion  2014-11-27 10:54:54.677
  
  */      

        
CREATE   PROCEDURE dbo.sp_analytic_moe;1      
 @txtDate AS VARCHAR (10),      
 @txtAnalytic AS VARCHAR(5)      
AS      
      
/*       
 Autor:   Rene "El Reno" Lopez      
 Creacion:  25-Abril-2003      
 Descripcion:    Procedimiento para generar el analitico moe      
     dentro del tren de procesos denominado      
     'sp_createAndReportAnalytics'      
      
 Modificado por: Csolorio      
 Modificacion: 20100923      
 Descripcion:    Se modifica para que calcule para el 1R      
*/      
      
BEGIN      
      
 SET NOCOUNT ON      
      
 -- genero buffer para agilizar la consulta      
 DECLARE @tblAmortizations TABLE (      
  txtId1 CHAR(11),      
  dteDate DATETIME      
   PRIMARY KEY(txtId1)      
 )       
      
 DECLARE @tblNom TABLE (      
  txtId1 CHAR(11),      
  dblNom FLOAT      
   PRIMARY KEY(txtId1)      
 )      
      
 DECLARE @tblTit TABLE (      
  txtId1 CHAR(11),      
  dblOutstanding FLOAT      
   PRIMARY KEY(txtId1)      
 )      
      
 DECLARE @tblOutstanding TABLE (      
  txtId1 CHAR(11),      
  dteDate DATETIME      
   PRIMARY KEY(txtId1)      
 )      
      
 --------------------------------------------------      
 -- obtengo los nominales originales      
 --------------------------------------------------      
      
 -- genero buffer de datos minimos      
 INSERT @tblAmortizations (      
  txtId1,      
  dteDate      
 )      
 SELECT       
  u.txtId1,      
  MIN(a.dteAmortization)      
 FROM       
  tblUni AS u (NOLOCK)      
  INNER JOIN tblAmortizations AS a (NOLOCK)      
  ON       
   u.txtId1 = a.txtId1      
 WHERE      
  u.txtAnalytic = @txtAnalytic      
  GROUP BY       
  u.txtId1      
      
 -- Pequity      
      
 INSERT @tblAmortizations (      
  txtId1,      
  dteDate      
 )      
 SELECT       
  u.txtId1,      
  MIN(a.dteDate)      
 FROM tblUni u (NOLOCK)      
 INNER JOIN tblPrivateAdd a      
 ON      
  u.txtId1 = a.txtId1      
  AND txtItem = 'NOM'      
  GROUP BY       
  u.txtId1      
      
 -- genero buffer de valores nominales      
 INSERT INTO @tblNom(      
  txtId1,      
  dblNom      
 )      
      
 -- instrumentos sin amortizaciones      
 SELECT DISTINCT       
  u.txtId1,      
  b.dblFaceValue      
 FROM       
  tblUni AS u  (NOLOCK)      
  INNER JOIN tblBonds AS b (NOLOCK)      
  ON u.txtId1 = b.txtId1        
  LEFT JOIN tblAmortizations AS a (NOLOCK)      
  ON u.txtId1 = a.txtId1      
 WHERE      
  u.txtAnalytic = @txtAnalytic      
  AND a.txtId1 IS NULL      
      
 UNION      
      
 -- instrumentos con amortizaciones      
 SELECT DISTINCT       
  buff.txtId1,      
  a.dblFactor AS dblNom      
 FROM       
  @tblAmortizations AS buff      
  INNER JOIN tblBonds AS b (NOLOCK)      
  ON buff.txtId1 = b.txtId1        
  INNER JOIN tblAmortizations AS a (NOLOCK)      
  ON       
   a.txtId1 = buff.txtId1      
   AND a.dteAmortization = buff.dteDate      
      
 UNION      
      
 -- Pequity      
      
 SELECT DISTINCT       
  buff.txtId1,      
  CAST (a.txtValue AS FLOAT) AS dblNom      
 FROM       
  @tblAmortizations AS buff       
  INNER JOIN tblPrivateAdd AS a (NOLOCK)      
  ON       
   buff.txtId1 = a.txtId1      
   AND buff.dteDate = a.dteDate      
   AND a.txtItem = 'NOM'      
      
 --------------------------------------------------      
 -- obtengo los titulos emitidos      
 --------------------------------------------------      
      
 -- genero buffer de datos minimos      
 INSERT @tblOutstanding (      
  txtId1,      
  dteDate      
 )      
 SELECT       
  u.txtId1,      
  MIN(o.dteDate)      
 FROM       
  tblUni AS u (NOLOCK)      
  INNER JOIN tblOutStanding AS o (NOLOCK)      
  ON       
   u.txtId1 = o.txtId1      
 WHERE      
  u.txtAnalytic = @txtAnalytic      
  AND dblOutstanding >  0       
  AND dteDate <= @txtDate      
  GROUP BY       
  u.txtId1      
      
 INSERT INTO  @tblTit(       
  txtId1,      
  dblOutstanding      
 )      
 SELECT       
  buff.txtId1,      
  o.dblOutstanding      
 FROM       
  @tblOutstanding AS buff      
  INNER JOIN tblOutStanding AS o (NOLOCK)      
  ON       
   buff.txtId1 = o.txtId1      
   AND buff.dteDate = o.dteDate      
      
 --------------------------------------------------      
 -- reporto los montos emitidos      
 --------------------------------------------------      
      
 INSERT tblResults (      
  dteDate,      
  txtId1,      
  txtItem,      
  txtValue      
 )      
 SELECT       
  @txtDate,      
  n.txtId1,      
  @txtAnalytic,      
  LTRIM(STR(n.dblNom * t.dblOutstanding, 19, 6))      
 FROM       
  @tblNom AS n      
  INNER JOIN @tblTit AS t      
  ON n.txtId1 = t.txtId1      
      
 SET NOCOUNT OFF      
END 