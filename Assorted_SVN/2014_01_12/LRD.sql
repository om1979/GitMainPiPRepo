

SELECT * FROM  dbo.tblItemsCatalog AS TIC
WHERE txtItem LIKE '%lRD%'





SELECT txtId1, txtLRD FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR





  
-- para obtener los resultados  
--CREATE PROCEDURE dbo.sp_analytic_LRD;1  
 DECLARE @txtDate AS VARCHAR (10)--,  
 DECLARE  @txtAnalytic AS VARCHAR(5)  
 SET @txtDate = '20141118'
 SET @txtAnalytic = 'LRD'
--AS  
--BEGIN  



Select @@version

 --Query que me manda los cupones que estan en tblDailyRates y tblEurobonosCouponsRates, y que no estan en tblBondsRateCalendar  
 --INSERTA EN  tblResults....  
 SELECT 
 DISTINCT   
  @txtDate,  --FECHA VARIABLE
  tblBondsRateCalendar.txtId1,  
  @txtAnalytic,  
  tblBondsRateCalendar.dtebeg
 DE_TABLAS:tblUni,tblBondsRateCalendar
  inner_JOIN: tblBondsRateCalendar 
  ON tblUni.txtId1 = tblBondsRateCalendar.txtId1  
  Y: tblUni.txtAnalytic = @txtAnalytic  
 DONDE:                               
  tblBondsRateCalendar.dtebeg <= @txtDate   
  Y: tblBondsRateCalendar.dteend > @txtDate   
 
 --UNION CON
 
 SELECT DISTINCT  
     @txtDate,  
     tblUni.txtId1,   
     @txtAnalytic,  
     ,tblEurobonosCouponsRates.dteinicio
	DE_TABLAS:      
     tblEurobonosCouponsRates,tblUni,tblBondsRateCalendar 
      inner_JOIN: tblUni 
     ON tblEurobonosCouponsRates.txtSerie = tblUni.txtSerie 
     AND tblEurobonosCouponsRates.txtTv = tblUni.txtTv 
     AND tblEurobonosCouponsRates.txtEmisora = tblUni.txtEmisora   
     AND tblUni.txtAnalytic = @txtAnalytic  
 WHERE   NOT EXISTS (SELECT tblBondsRateCalendar.txtId1 FROM tblBondsRateCalendar AS c)  
     AND NOT EXISTS (SELECT * FROM tblDailyRates)  
     AND tblEurobonosCouponsRates.dteinicio <= @txtDate  
        AND tblEurobonosCouponsRates.dteFinal > @txtDate  
      