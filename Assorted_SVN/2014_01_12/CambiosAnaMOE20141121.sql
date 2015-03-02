

ALTER    PROCEDURE dbo.sp_analytic_moe;1      
    @txtDate AS VARCHAR (10),--= '20141121'      
    @txtAnalytic AS VARCHAR(5) --='MOE'          
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
 
 
 
 Modifica:	Omar Adrian Aceves Gutierrez
 Fecha:		2014-11-27 10:53:21.687
 Objetivo:  Se incorpora Equitys
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
--Tablas para contener datos de Equity Oaceves  

	create table #pricesaction ( txtId1 CHAR(11),
			txtCurrency CHAR(6),
			dteDate DATETIME,
			dblPrices FLOAT,
			dblTC FLOAT,
			dblpesosp FLOAT
			primary key(txtId1))
	        
	--FECHAS MÍNIMAS 
	create table #tblDateMin  (
		   txtId1 CHAR(11),
		   txtCurrency CHAR(6),
		   dteDateMin DATETIME
		   PRIMARY KEY(txtId1))
		   
	--ÚLTIMA OPERACIÓN 
	create table #tblTimeMAX  (
		   txtId1 CHAR(11),
		   txtCurrency CHAR(6),
		   dteDateMin DATETIME,
		   dteTime DATETIME
		   PRIMARY KEY(txtId1))   
----------------------------------------------------------
        
 ------------------------------------------------       
/*Cargamos datos requeridos para EQUITY*/
------------------------------------------------

	INSERT #tblDateMin
		SELECT
		  E.txtId1,
		  E.txtCurrency,
		  MIN(EP.dteDate)
		FROM tblEquity AS E
		INNER JOIN tblEquityPrices AS EP
		ON 
		 E.txtId1=EP.txtid1
		 INNER JOIN dbo.tblUni Uni
		 ON E.txtid1 = Uni.txtId1
		WHERE E.dteMaturity>@txtDate
		AND E.dteIssued<=@txtDate
		AND EP.txtOperationCode = 'S01'
		AND EP.dblPrice > 0
		GROUP BY E.txtId1,E.txtCurrency



	INSERT #tblTimeMAX
		SELECT
		  DM.txtId1,
		  DM.txtCurrency,
		  DM.dteDateMin, 
		  MAX(EP.dteTime)
		FROM #tblDateMin AS DM
		INNER JOIN tblEquityPrices AS EP
		ON 
		 DM.txtId1=EP.txtid1
		 AND DM.dteDateMin=EP.dteDate
		WHERE EP.txtOperationCode = 'S01'
		AND EP.dblPrice > 0
		GROUP BY DM.txtId1,DM.txtCurrency,DM.dteDateMin


	insert  #pricesaction
		SELECT distinct
		  TM.txtId1,
		  TM.txtCurrency,
		  TM.dteDateMin,
		  EP.dblPrice,
		  ISNULL(I.dblValue,1),
		  EP.dblPrice*ISNULL(I.dblValue,1)

		FROM #tblTimeMAX AS TM
		INNER JOIN tblEquityPrices AS EP
		ON 
		 TM.txtId1=EP.txtid1
		 AND TM.dteDateMin=EP.dteDate
		 AND TM.dteTime=EP.dteTime
		LEFT OUTER JOIN tblIrc AS I
		ON 
		 I.txtIRC= CASE TM.txtCurrency
			 WHEN 'USD' THEN 'UFXU'
			 ELSE TM.txtCurrency
			END
		 AND I.dteDate=TM.dteDateMin
		WHERE EP.txtOperationCode = 'S01'
        
        
    
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
  dbo.tblUni AS u (NOLOCK)      
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
  dbo.tblUni AS u (NOLOCK)      
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
 FROM dbo.tblUni u (NOLOCK)      
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
      
 ---- instrumentos sin amortizaciones      
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
   
  UNION 
  
   --EQUITY
SELECT DISTINCT 
	priceS.txtId1,
	ROUND(priceS.dblPrices,6)*ROUND(TOS2.dblOutstanding,6)
	FROM  
	#pricesaction AS priceS
	INNER JOIN @tblOutstanding AS TOS
	ON priceS.txtId1 = TOS.txtId1
	INNER JOIN dbo.tblOutStanding AS TOS2
	ON TOS.dteDate = TOS2.dteDate
	AND TOS.txtId1 = TOS2.txtId1
	  
	  
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
  LTRIM(STR(n.dblNom * t.dblOutstanding, 25, 6))      
 FROM       
  @tblNom AS n      
  INNER JOIN @tblTit AS t      
  ON n.txtId1 = t.txtId1      
      
 SET NOCOUNT OFF      
END 


