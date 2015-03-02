  /*  
  Procedimiento para generar el analitico   
  VNA_P Valor nominal Actualizado en Pesos.   
  dentro del tren de procesos denominado     
  'sp_createAndReportAnalytics'       
           
  NOTA: El control de depuracion de tablas     
  esta controlado por 'sp_createAndReportAnalytics'     
     
   
  v.1.1 Armando (12:15 p.m. 07/10/2008)  
  Agrego tabla temporal para transferir a tblResults .        
   
  Creador: Armando   (10:00 a.m. 24/09/2008)  
  V.1   
  Para generar analitico VNA_P (Valor Nominal Actualizado en pesos)  
    
  v.1.2 Armando (11:30 a.m. 22/10/200)        
  Excluimos el instrumento   
    "d8 barclay 5-07"  Id1 = 'MIRC0001727'  
  para que tome el tipo de cambio de Udi del dia "2007-09-19 00:00:00.000"  
  
    
   
*/  
  
-- para obtener los insumos  
CREATE  PROCEDURE [dbo].[sp_analytic_vna_p]  
 @txtDate AS VARCHAR (10),  
 @txtAnalytic AS VARCHAR(10)  
AS  
BEGIN  
   
  
 SET NOCOUNT ON  
 DECLARE @tblResults  
  TABLE  (  
   dteDate DATETIME,  
   txtId1 VARCHAR(11),   
   txtItem VARCHAR(10),  
   txtValue FLOAT,  
   PRIMARY KEY (dteDate, txtId1, txtItem)  
   )  
  
  
 INSERT @tblResults  
 SELECT DISTINCT   
  @txtDate,  
  u.txtId1,  
  @txtAnalytic,  
  b.dblFaceValue *  
    CASE WHEN u.txtId1 ='MIRC0001727'  
     THEN '3.8562150000000002'  
      WHEN i.dblValue IS NULL  
     THEN 1  
     ELSE i.dblValue  
    END AS 'txtValue'  
 FROM tblUni AS u (NOLOCK)  
  INNER JOIN tblbonds AS b (NOLOCK)  
  ON   
   u.txtId1 = b.txtId1  
   AND u.txtAnalytic = @txtAnalytic  
  
  LEFT JOIN tblAmortizations AS a (NOLOCK)  
  ON   
   u.txtId1 = a.txtId1  
  
  LEFT JOIN tblIrc AS i (NOLOCK)  
  ON    
   i.txtIrc =   
    CASE      
     WHEN b.txtCurrency ='USD'  
     THEN 'UFXU'  
     ELSE b.txtCurrency  
    END  
   AND i.dtedate = b.dteIssued  
    
  LEFT JOIN tblDailyAnalytics AS da (NOLOCK)  
  ON  
   b.txtId1 = da.txtId1  
   AND da.txtItem ='VNA_P'  
     
 WHERE  
  a.txtId1 IS NULL  
  AND da.txtId1 IS NULL  
    
  
 UNION   --Bonos Amortizables  
 SELECT DISTINCT  
  @txtDate,  
  u.txtId1,  
  @txtAnalytic,  
  a.dblFactor *  
   CASE     
    WHEN i.dblValue IS NULL  
    THEN 1  
    ELSE i.dblValue  
      
   END  
  
 FROM   
  tblUni AS u  (NOLOCK)  
  INNER JOIN tblbonds AS b (NOLOCK)  
  ON   
   u.txtId1 = b.txtId1    
   AND u.txtAnalytic = @txtAnalytic  
  INNER JOIN tblAmortizations AS a (NOLOCK)  
  ON   
   u.txtId1 = a.txtId1  
  
  LEFT JOIN tblIrc AS i (NOLOCK)  
  ON    
   i.txtIrc = b.txtCurrency  
   AND i.dtedate = b.dteIssued  
  
  LEFT JOIN tblDailyAnalytics AS da(NOLOCK)  
  ON  
     
   b.txtId1 = da.txtId1  
   AND da.txtItem ='VNA_P'  
  
 WHERE  
  a.dteAmortization =  (  
     SELECT MAX(dteAmortization)  
     FROM tblAmortizations (NOLOCK)  
     WHERE  
     txtId1 = a.txtId1  
     AND dteAmortization <= @txtDate  
     )  
  AND da.txtId1 IS NULL  
     
  
 -- bonos amortizables con calendario de amor recortado  
 UNION   
 SELECT DISTINCT    
  @txtDate,  
  u.txtId1,  
  @txtAnalytic,  
  b.dblFaceValue *  
    CASE   
     WHEN i.dblValue IS NULL  
     THEN 1  
     ELSE i.dblValue   
    END  
   
 FROM   
  tblUni AS u  (NOLOCK)  
  INNER JOIN tblbonds AS b (NOLOCK)  
  ON   
   u.txtId1 = b.txtId1  
   AND u.txtAnalytic = @txtAnalytic  
  INNER JOIN tblAmortizations AS a (NOLOCK)  
  ON   
   u.txtId1 = a.txtId1  
  LEFT OUTER JOIN tblAmortizations AS a2 (NOLOCK)  
  ON   
   u.txtId1 = a2.txtId1  
   AND a2.dteAmortization = (  
      SELECT MAX(dteAmortization)  
      FROM tblAmortizations (NOLOCK)  
      WHERE  
      txtId1 = a.txtId1  
      AND dteAmortization <= @txtDate  
      )  
  
  LEFT OUTER JOIN tblIrc AS i (NOLOCK)  
  ON    
   i.txtIrc = b.txtCurrency  
   AND i.dtedate = b.dteIssued  
  
  LEFT JOIN tblDailyAnalytics AS da(NOLOCK)  
  ON  
     
   b.txtId1 = da.txtId1  
   AND da.txtItem ='VNA_P'  
  
 WHERE  
  a2.txtId1 IS NULL  
  AND da.txtId1 IS NULL  
   
  
   
 --Insertamos los resultados  
 BEGIN TRANSACTION  
  
  INSERT tblResults  
  SELECT  
   dteDate,  
   txtId1,  
   txtItem,  
   RTRIM(LTRIM(STR(txtValue,50,6)))  
  FROM @tblResults  
  
 COMMIT TRANSACTION  
  
  
 SET NOCOUNT OFF  
  
END   
  