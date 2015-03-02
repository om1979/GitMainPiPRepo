
/*
---------------------------------------------------------------------  
--   Modificado por: Mike Ramìrez  
--   Modificacion:     10:26 p.m. 2012-03-15  
--   Descripcion:       Modulo 1: Se agregan al universo los TV 56 SP  
---------------------------------------------------------------------  
--   Modificado por: Omar Adrian Aceves Gutierrez 
--   Modificacion:   2014-08-05 12:35:35.520
--   Descripcion:    se afregan ID´S especificos(final del archivo)
---------------------------------------------------------------------  
*/

alter PROCEDURE [dbo].[sp_analytic_FIFR]  
   @txtDate AS VARCHAR (10),     
   @txtAnalytic AS VARCHAR(5)
AS  
BEGIN  
 SET NOCOUNT ON  
  
   DECLARE @txtDateL AS DATETIME  
   DECLARE @txtDateM  AS DATETIME  
  
	   SET @txtDateM=DATEADD(YY,1,@txtDate)  
	   SET @txtDateL=DATEADD(YY,-1,@txtDate)  
	  
   DECLARE @Curt AS FLOAT  
   DECLARE @Contador AS INT  
   DECLARE @txtIrc AS VARCHAR(4)  
		SET @Contador=1  
  
   DECLARE @tmp_Cartera TABLE 
	   (  
	   txtId1 CHAR (11),   
	   Instrumento varchar(40),tipo varchar(40),  
	   txtCurrency CHAR(4))  
	   DECLARE @Volatilidades TABLE (  
	   Volatilidad FLOAT,   
	   txtCurrency AS CHAR(4)
	   )  
  
	   --Consigue Todo el universo de instrumentos Gubernamentales  
	   INSERT INTO @tmp_Cartera (txtId1, Instrumento,tipo,txtCurrency)   
		   SELECT 
				t.txtId1,RTRIM(txtTV)+'_'+RTRIM(txtEmisora)+'_'+RTRIM(txtSerie),'Gubernamental',b.txtCurrency  
		   FROM tmp_tblUnifiedPricesReport as t 
			INNER JOIN tblbonds as b 
				ON b.txtId1=t.txtId1  
		   WHERE TXTSMKT='Gubernamental' 
			   AND txtLiquidation='MD'   
			   AND txtSEC='GUBERNAMENTAL'  
			   AND txtTV  NOT IN ('S','S0','SC','SP','2P','2U','3P','3U','4P','4U','6U','CC','CP','MC','MP','D1','D1SP')  
			   AND txtTv NOT LIKE '%SP%'  
			   AND dblPRS>6  
			   AND dteDate=@txtDate  
			   AND t.txtid1 NOT IN 
				   (select distinct(txtID1)  
					from tblPricesSN   
					where dteDate =@txtDate)
				   AND t.txtId1 NOT IN (SELECT txtid1 FROM MxXamu.dbo.tblBondsMapping WHERE intFamily=1999)
			      
	   UNION   
		   SELECT 
				t.txtId1,RTRIM(txtTV)+'_'+RTRIM(txtEmisora)+'_'+RTRIM(txtSerie),'Gubernamental' ,b.txtCurrency  
		   FROM tmp_tblUnifiedPricesReport as t INNER JOIN tblbonds as b ON b.txtId1=t.txtId1  
				WHERE TXTSMKT='Gubernamental' AND txtLiquidation='MD'   
				   AND txtSEC='GUBERNAMENTAL EXTRANJERA'  
				   AND txtTv IN ('D1')  
				   AND dblPRS>6  
				   AND dteDate=@txtDate  
				   AND t.txtid1 NOT IN 
				   (select distinct(txtID1)  
						from tblPricesSN   
						where dteDate = @txtDate)  
				   AND t.txtId1 NOT IN (SELECT txtid1 FROM MxXamu.dbo.tblBondsMapping WHERE intFamily=1999) 

     
   DECLARE @carga TABLE
    (  
   txtId1 CHAR (11),   
   Instrumento varchar(40),tipo varchar(40),  
   txtCurrency CHAR(4),  
   dteDate DATETIME,  
   dblvalue FLOAT
   )  
      
		INSERT INTO @carga (txtId1, Instrumento,tipo,txtCurrency,dteDate,dblvalue)  
			SELECT c.*,p.dteDate,p.dblValue FROM @tmp_Cartera AS C 
				INNER JOIN dbo.tblprices AS p ON c.txtId1=p.txtID1  
				AND txtLiquidation='MD'
				AND txtItem='YTM' 
			ORDER BY c.txtId1,dteDate  

		INSERT INTO @carga (txtId1, Instrumento,tipo,txtCurrency,dteDate,dblvalue)   
			SELECT c.*,p.dteDate,p.dblValue FROM @tmp_Cartera AS C 
				INNER JOIN MxFixIncomeHist.dbo.tblHistoricPrices AS p ON c.txtId1=p.txtID1  
				AND txtLiquidation='MD' 
				AND txtItem='YTM' 
				AND dteDate BETWEEN @txtDateL 
				AND @txtDateM  
			ORDER BY c.txtId1,dteDate  


     DECLARE @Est_Guber TABLE 
		(  
		txtId1 CHAR (11),   
		dblvalue FLOAT
		)  
     
		INSERT @Est_Guber  
			SELECT txtId1,AVG(dblvalue)+3*STDEVP(dblvalue) FROM @carga GROUP BY txtId1  
     
--Consigue Todo el universo de instrumentos Bancario  
	   INSERT INTO @tmp_Cartera (txtId1, Instrumento,tipo,txtCurrency)
	      
	   SELECT 
	   u.txtId1,RTRIM(u.txtTv)+'_'+RTRIM(u.txtEmisora)+'_'+RTRIM(u.txtSerie),'Bancario',b.txtCurrency  
	   FROM tmp_tblUnifiedPricesReport as u 
	   inner join tblbonds as b 
	   on u.txtId1=b.txtID1  
			WHERE txtSMKT ='Bancario' AND txtLiquidation='MD' AND txtSEC<>'GUBERNAMENTAL'  
			   --AND dteMaturity BETWEEN @txtDate AND @txtDateM  
			   AND txtTV  NOT IN ('S','S0','SC','SP','2P','2U','3P','3U','4P','4U','6U','CC','CP','MC','MP','D1')  
			   AND txtTv NOT LIKE '%SP%'  
			   AND dblPRS>6  
			   AND dteDate=@txtDate  
			   AND u.txtid1 NOT IN (select distinct(txtID1)  
					from tblPricesSN   
					where dteDate =@txtDate)
					AND u.txtId1 NOT IN (SELECT txtid1 FROM MxXamu.dbo.tblBondsMapping WHERE intFamily=1999)  
			    
			    
			          
--Concentra toda la información Calculando el LCVar  
	   DECLARE @Concentrado TABLE 
	   (  
		  txtId1 CHAR (11),   
		  Instrumento varchar(40),  
		  tipo varchar(40),Promedio FLOAT,  
		  MinDte DATETIME,  
		  MaxDate DATETIME,  
		  Desv FLOAT ,   
		  Precio FLOAT,  
		  txtCurrency VARCHAR(4)
	  )  
      
      
   --SELECT * FROM @tmp_Cartera WHERE tipo='Bancario'  
	   INSERT INTO @Concentrado (txtId1, Instrumento,tipo,Promedio,MinDte,MaxDate,Desv,PRECIO,txtCurrency)  
		SELECT c.txtId1,Instrumento,tipo,AVG(CAST(txtvalue AS FLOAT)),  
			MIN(b.dteDate) AS MinDte,MAX(b.dteDate) AS MaxDte,STDEVP(CAST(txtValue AS FLOAT)) AS desv,  
			MAX(dblvalue) AS Precio, MAX(txtCurrency) AS txtCurrency  
		FROM @tmp_Cartera  AS c   
		   INNER JOIN dbo.tblBondsAdd AS b  
		   ON c.txtId1=b.txtId1  
		   INNER JOIN dbo.tblprices AS p  
	   ON c.txtId1=p.txtID1 and b.txtId1=p.txtID1 --and b.dteDate=p.dteDate  
		 WHERE tipo='Bancario' 
			AND b.txtItem='LDR'   
			AND p.dteDate=@txtDate  
		   AND p.txtItem  IN ('PRL','PRS') AND p.txtliquidation='MD'  
		   AND b.dteDate>=@txtDateL  
			   GROUP BY c.txtId1,Instrumento,tipo  
			   ORDER by MinDte  
		   
		   DECLARE @Reciente TABLE (  
			  Instrumento varchar(40),  
			  Fecha DATETIME)  
        
	   INSERT INTO @Reciente(Instrumento,Fecha)  
			SELECT RTRIM(txttv)+'_'+RTRIM(txtEmisora)+'_'+RTRIM(txtSerie),MAX(dtedate)   
				FROM dbo.itblMarketPositionsPrivates   
					GROUP BY RTRIM(txttv)+'_'+RTRIM(txtEmisora)+'_'+RTRIM(txtSerie)  
   UNION  
			SELECT RTRIM(txttv)+'_'+RTRIM(txtEmisora)+'_'+RTRIM(txtSerie),MAX(dtedate)   
				FROM MxFixIncomeHIst.dbo.itblHistoricMarketPositionsPrivates   
					GROUP BY RTRIM(txttv)+'_'+RTRIM(txtEmisora)+'_'+RTRIM(txtSerie)  
	  
  
--Muestra el concentrado final  
     
   
   DECLARE @Final TABLE (  
   txtId1 CHAR (11),   
   Instrumento varchar(40),  
   tipo varchar(40),  
   LCVar FLOAT,  
   Precio FLOAT,  
   txtCurrency CHAR(4))  
     
   INSERT INTO @Final 
   (txtId1,Instrumento,tipo,LCVar,Precio,txtCurrency)    
   SELECT txtId1,c.Instrumento,tipo,((Precio*(Promedio+3*desv))/2) AS LCVaR,Precio ,c.txtCurrency  
   FROM @Concentrado as C INNER JOIN @Reciente as R  
   ON c.Instrumento=r.Instrumento  
   
   UNION 
    
   SELECT c.txtId1,Instrumento,tipo,MAX(g.dblvalue),MAX(p.dblValue),c.txtCurrency   
   FROM @tmp_Cartera AS C INNER JOIN dbo.tblprices AS P   
   ON C.txtId1=P.txtID1  
   INNER JOIN @Est_Guber AS g ON g.txtId1=p.txtID1 AND g.txtId1=c.txtId1  
   WHERE p.dteDate=@txtDate  
   AND p.txtItem  IN ('PRL','PRS') AND p.txtliquidation='MD'  
   AND tipo='Gubernamental'  
   GROUP BY C.txtId1,Instrumento,tipo,c.txtCurrency  
  
  
   DECLARE @tmp_Valatilidades TABLE (  
    Volatilidad_Moneda FLOAT,   
    txtIRC VARCHAR(4),  
    Teta FLOAT  
   PRIMARY KEY (txtIRC))  
  
   INSERT @tmp_Valatilidades  
   
   SELECT STDEVP(dblValue)AS Volatilidad_Moneda, txtIRC,(((LOG(dbo.fun_Curt(txtIRC,@txtDate,@txtDateL))/3)*0.4)+1) AS Teta  
   --INTO #Volatilidades  
   FROM tblIrc AS I INNER JOIN (SELECT CASE WHEN txtCurrency ='USD'   
   THEN 'UFXU' ELSE txtCurrency END AS [txtCurrency]  
   FROM ( SELECT distinct b.txtCurrency   
     FROM tblBONDS AS b INNER JOIN @Final AS f   
     ON f.txtId1=b.txtId1)AS TBLCURRENCY) AS C On i.txtIRC=c.txtCurrency  
   WHERE dteDate Between @txtDateL AND @txtDate  
   GROUP BY txtIRC      
  
   INSERT INTO @tmp_Valatilidades   
   SELECT 1,'MPS',1   
   
   UPDATE @tmp_Valatilidades  
   SET txtIRC='USD' WHERE txtIRC='UFXU'  
  
  DECLARE @Calcula TABLE (  
   txtId1 CHAR (11),   
   Instrumento varchar(40),  
   tipo varchar(40),  
   LCVar FLOAT,  
   Precio FLOAT,  
   txtCurrency CHAR(4),  
   MCVar FLOAT)  
  
  INSERT INTO @Calcula     
  SELECT   
   f.*,  
   Precio*(1-EXP(-2.33*Volatilidad_Moneda*Teta)) AS MCVaR   
  FROM @Final AS f   
  INNER JOIN @tmp_Valatilidades AS v   
   ON v.txtIRC = f.txtCurrency  
  
  DECLARE @tmp_tblLiquidez TABLE (  
   txtId1 CHAR(11),   
   txtInstrumento VARCHAR(50),  
   txtTipo VARCHAR(50),  
   dblliquidez FLOAT   
  PRIMARY KEY (txtID1))  
  
  INSERT @tmp_tblLiquidez  
  SELECT   
   txtId1,  
   Instrumento,  
   tipo,--Precio,txtCurrency,LCVar+MCVar AS TVar,ABS(LCVar),  
   (ABS(LCVar)/(LCVar+MCVar))*100 AS Liquidez   
  --INTO #liquidez  
  FROM @Calcula  
  --WHERE (ABS(LCVar)/(LCVar+MCVar))*100>30  
  ORDER BY Liquidez desc , Instrumento  
  
  --Agregamos acciones  
  INSERT @tmp_tblLiquidez  
  SELECT   
   i.txtId1,  
   RTRIM(txtTV)+'_'+RTRIM(txtEmisora)+'_'+RTRIM(txtSerie),  
   'Acciones',  
   CASE    
    WHEN e.dblAmount IS NULL THEN 0   
   ELSE (e.dblAmount/s.dblOutstanding)*100   
   END AS 'Indice'   
  FROM dbo.tblOutStanding AS s (NOLOCK)  
  INNER JOIN dbo.tblIds AS i (NOLOCK)  
   ON s.txtId1 = i.txtID1   
  INNER JOIN dbo.tblEquityPrices AS e (NOLOCK)  
   ON e.txtid1 = i.txtID1   
   AND e.txtid1 = s.txtId1   
   AND s.dteDate = e.dteDate  
  WHERE   
   s.dteDate = @txtDate  
   AND e.txtOperationCode = 'S01'  
   AND i.txtTV IN ('1A','1E')  
   
--se agregan valores con id1 especifico   (oaceves) 
  	  INSERT INTO   @tmp_tblLiquidez
  			SELECT b.txtId1,RTRIM(b.txtTV)+'_'+RTRIM(b.txtEmisora)+'_'+RTRIM(b.txtSerie),'Especifico',31.00000
				FROM   dbo.tblIds as b 
					WHERE b.txtId1 IN 
					(	
				'MHYW5200001',
				'MHYW5200002',
				'UGRB5200001',
				'UGRB5200002',
				'UIRC0002454',
				'UIRC0002451',
				'UIRC0002452',
				'UIRC0002455',
				'MIRC0000946',
				'MIRC0000947',
				'UIRC0002453',
				'UIRC0002456'
					)				
--fin carga especifica
  -- Reportamos el resultado  r
  INSERT tblResults  
  SELECT  
   @txtDate,  
   txtId1,  
   @txtAnalytic,  
   CASE WHEN LTRIM(STR(dblliquidez, 19, 6)) >= '30.00000' THEN '1' ELSE '0' END  
		FROM @tmp_tblLiquidez  
		
SET NOCOUNT OFF  
  
END   