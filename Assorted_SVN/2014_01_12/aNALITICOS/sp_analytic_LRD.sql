

SELECT * FROM  dbo.tblItemsCatalog AS TIC
WHERE txtItem LIKE '%lRD%'



sp_analytic_LRD.sql

SELECT txtId1, txtLRD FROM  dbo.tmp_tblUnifiedPricesReport AS TTUPR





  
-- para obtener los resultados  
--CREATE PROCEDURE dbo.sp_analytic_LRD;1  
 DECLARE @txtDate AS VARCHAR (10)--,  
 DECLARE  @txtAnalytic AS VARCHAR(5)  
 SET @txtDate = '20141118'
 SET @txtAnalytic = 'LRD'
--AS  
--BEGIN  

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
     Y: tblEurobonosCouponsRates.txtTv = tblUni.txtTv 
     Y: tblEurobonosCouponsRates.txtEmisora = tblUni.txtEmisora   
     Y: tblUni.txtAnalytic = @txtAnalytic  
     DONDE:   NOT EXISTS (SELECT tblBondsRateCalendar.txtId1 FROM tblBondsRateCalendar AS c)  --DONDE NO EXISTAN DATOS 
     Y: NOT EXISTS (SELECT * FROM tblDailyRates)  -- DE tblBondsRateCalendar Y tblDailyRates
     Y: tblEurobonosCouponsRates.dteinicio <= @txtDate --dteinicio SEA MENOR O IGUAL A @txtDate
        Y: tblEurobonosCouponsRates.dteFinal > @txtDate  
      