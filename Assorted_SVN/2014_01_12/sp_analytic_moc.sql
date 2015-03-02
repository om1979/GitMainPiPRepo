  
CREATE PROCEDURE dbo.sp_analytic_moc;1  
 @txtDate AS VARCHAR (10),  
 @txtAnalytic AS VARCHAR(5)  
  
AS  
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para calcular el analitico MOC  
   
 Modificado por: CSOLORIO  
 Modificacion: 20121127  
 Descripcion: Modifico calculo de analitico para PEquity  
*/  
  
BEGIN  
  
 SET NOCOUNT ON  
  
 -- JATO (07:05 p.m. 2008-01-23)  
 -- obtengo la fecha mas reciente de titulos  
 -- para todos los instrumentos del universo   
  
 DECLARE @tblOutstanding TABLE (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1)  
 )  
  
 INSERT INTO @tblOutstanding (  
  txtId1,  
  dteDate  
 )  
 SELECT   
  u.txtId1,  
  MAX(dteDate)  
 FROM   
  tblUni AS u (NOLOCK)  
  INNER JOIN tblOutstanding AS o (NOLOCK)  
  ON   
   u.txtId1 = o.txtId1  
   AND u.txtAnalytic = @txtAnalytic  
 WHERE    
  o.dteDate <= @txtDate  
  AND o.dblOutstanding >  0  
 GROUP BY  
  u.txtId1  
  
 -- JATO (07:05 p.m. 2008-01-23)  
 -- obtengo la fecha mas reciente de amortizacion  
 -- para todos los instrumentos del universo   
  
 DECLARE @tblAmortizations TABLE (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1)  
 )  
  
 INSERT INTO @tblAmortizations (  
  txtId1,  
  dteDate  
 )  
 SELECT   
  u.txtId1,  
  MAX(dteAmortization)  
 FROM   
  tblUni AS u (NOLOCK)  
  INNER JOIN tblAmortizations AS o (NOLOCK)  
  ON   
   u.txtId1 = o.txtId1  
   AND u.txtAnalytic = @txtAnalytic  
 WHERE  
  o.dteAmortization <= @txtDate   
 GROUP BY  
  u.txtId1  
    
 UNION  
   
 SELECT   
  u.txtId1,  
  MAX(dteDate)  
 FROM tblUni AS u (NOLOCK)  
 INNER JOIN tblPrivateAdd AS o (NOLOCK)  
 ON   
  u.txtId1 = o.txtId1  
  AND u.txtAnalytic = @txtAnalytic  
 WHERE  
  o.dteDate <= @txtDate   
  AND o.txtItem = 'NOM'  
 GROUP BY  
  u.txtId1  
  
 -- bonos :: bullet y  
 -- bonos :: amortizables :: calendario incompleto  
 INSERT tblResults (  
  dteDate,  
  txtId1,  
  txtItem,  
  txtValue  
 )  
 SELECT DISTINCT  
  @txtDate,        
  b.txtId1,  
  @txtAnalytic,  
  LTRIM(STR(b.dblFaceValue * c.dblOutstanding, 19, 6))  
 FROM   
  @tblOutstanding AS buff  
  INNER JOIN tblBonds AS b (NOLOCK)  
  ON buff.txtId1 = b.txtId1   
  INNER JOIN tblOutStanding c (NOLOCK)  
  ON   
   buff.txtId1 = c.txtId1  
   AND c.dteDate = buff.dteDate  
  LEFT OUTER JOIN @tblAmortizations AS buff2  
  ON buff.txtId1 = buff2.txtId1  
  LEFT OUTER JOIN tblAmortizations AS am (NOLOCK)  
  ON   
   b.txtId1 = am.txtId1  
   AND am.dteAmortization = buff2.dteDate  
 WHERE   
  am.txtId1 IS NULL  
  
 -- bonos :: amortizables  
 INSERT tblResults (  
  dteDate,  
  txtId1,  
  txtItem,  
  txtValue  
 )  
 SELECT DISTINCT  
  @txtDate,        
  b.txtId1,  
  @txtAnalytic,  
  LTRIM(STR(am.dblFactor * c.dblOutstanding, 19, 6))  
 FROM   
  @tblOutstanding AS buff  
  INNER JOIN tblBonds AS b (NOLOCK)  
  ON buff.txtId1 = b.txtId1   
  INNER JOIN tblOutStanding c (NOLOCK)  
  ON   
   buff.txtId1 = c.txtId1  
   AND c.dteDate = buff.dteDate  
  INNER JOIN @tblAmortizations AS buff2  
  ON buff.txtId1 = buff2.txtId1  
  INNER JOIN tblAmortizations AS am (NOLOCK)  
  ON   
   b.txtId1 = am.txtId1  
   AND am.dteAmortization = buff2.dteDate  
  
 -- equity  
 INSERT tblResults (  
  dteDate,  
  txtId1,  
  txtItem,  
  txtValue  
 )  
 SELECT DISTINCT  
  @txtDate,  
        buff.txtId1,  
        @txtAnalytic,  
        LTRIM(STR(p.dblValue * d.dblOutstanding, 19, 6))  
 FROM   
  @tblOutstanding AS buff  
  INNER JOIN vw_prices_notes p (NOLOCK)  
  ON   
   buff.txtId1 = p.txtId1   
  INNER JOIN tblOutStanding d (NOLOCK)  
  ON   
   buff.txtId1 = d.txtId1  
   AND d.dteDate = buff.dteDate  
  INNER JOIN tblIds i (NOLOCK)  
  ON   
   buff.txtId1 = i.txtId1  
  INNER JOIN tblTvCatalog c (NOLOCK)  
  ON  
   i.txtTv = c.txtTv  
 WHERE   
  p.dteDate = @txtDate  
     AND p.txtLiquidation IN ('MP','MD')  
     AND p.txtItem = 'PAV'  
  AND c.intMarket = 1  
  AND i.txtTv != '1R'  
  
 --Private Equity  
  
 INSERT tblResults (  
  dteDate,  
  txtId1,  
  txtItem,  
  txtValue  
 )  
 SELECT DISTINCT  
  @txtDate,  
        buff.txtId1,  
        @txtAnalytic,  
        LTRIM(STR(p.txtValue * d.dblOutstanding, 19, 6))  
 FROM   
  @tblOutstanding AS buff  
  INNER JOIN @tblAmortizations a  
  ON  
   buff.txtId1 = a.txtId1  
  INNER JOIN tblPrivateAdd p (NOLOCK)  
  ON  
   a.txtID1 = p.txtId1  
   AND a.dteDate = p.dteDate  
  INNER JOIN tblOutStanding d (NOLOCK)  
  ON   
   buff.txtId1 = d.txtId1  
   AND d.dteDate = buff.dteDate  
  INNER JOIN tblIds i (NOLOCK)  
  ON   
   buff.txtId1 = i.txtId1  
 WHERE   
     p.txtItem = 'NOM'  
  AND i.txtTv = '1R'  
  
 SET NOCOUNT OFF  
  
END  
  