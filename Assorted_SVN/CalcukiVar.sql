  
  
  
  --SELECT * FROM  dbo.tblIds AS TI
  --WHERE txtTV = '1ASP'
  --AND txtEmisora ='JD'
  --AND txtSerie = 'N'

  		
--UIRC0016929

--SELECT TOP 10 * FROM  tmp_unitest_20150209

--INSERT INTO   dbo.tmp_unitest_20150209 
  
  
--    SELECT txtID1,txtTV,txtEmisora,txtSerie,'VAR' FROM  dbo.tblIds AS TI
--  WHERE txtTV = '1ASP'
--  AND txtEmisora ='JD'
--  AND txtSerie = 'N'




  
    
--CREATE PROCEDURE [dbo].[sp_analytic_var]                              
-- @txtDate AS VARCHAR (10),                              
-- @txtAnalytic AS VARCHAR (10)                              
--AS         
                             
--BEGIN                              
                               
-- SET NOCOUNT ON                              
                    
-- -- agrego los analiticos a la tabla de resultados                              
                             
-- DELETE FROM  dbo.tblResults WHERE txtItem = 'VAR'                              
                             
-- INSERT tblResults                              
--  SELECT @txtDate,                              
--   v.txtId1,                              
--   @txtAnalytic,                                 
--   LTRIM(STR(v.dblVar,11,6))                               
--  FROM tblUni u                              
--   INNER JOIN mxXamu.dbo.tblVar v                              
--    ON u.txtId1 = v.txtId1                              
--  WHERE u.txtAnalytic = 'VAR'                              
--   AND v.dteFecha = @txtDate                              
--   AND v.txtMTXId NOT IN ('MALFA1000','MALFA')              
        
--------------------------------- INSTRUMENTOS QUE NO TIENEN VaR-------------------------                             
---- CARGA LOS IDS1 DE INTRUMENTOS QUE NO TIENEN VaR HACIA LA TABLA MxFixIncome.dbo.tmp_tblIds1EstVar          
---- GENERA LA TABLA MxFixIncome.dbo.tmp_tblHistCalculateVar CON LA HISTORIA DE 500 ESCENARIOS DE CADA IDS1 INSTRUMENTO.        
        
--  EXEC sp_analytic_var;2 @txtDate                             
        
----- CALCULA EL VaR A LOS INSTRTUMENTOS DE LA TABLA MxFixIncome.dbo.tmp_tblIds1EstVar                          
----- Y LOS INSERTA EN dbo.tblResults                          
          
--  EXEC sp_analytic_var;3 @txtDate ,'MD','PRS',500          
                           
----- CALCULA EL VaR A LOS INSTRTUMENTOS DE LA TABLA MxFixIncome.dbo.tmp_tblIds1EstVar                        
----- Y LOS INSERTA EN dbo.tblResults                          
               
--  EXEC sp_analytic_var;3 @txtDate ,'MP','PAV',500                           
-----------------------------------------------------------------------------------------                          
                                               
-- SET NOCOUNT OFF         
                              
--END   
  
  
    
--CREATE PROCEDURE [dbo].[sp_analytic_var];2                            
                            
      DECLARE @dteDate DATETIME = '20150206'                             
                                  
--AS                                                              
--BEGIN                                                                  
--        SET NOCOUNT ON                             
            
           
                      
------------------------------------------------------ ARRRANQUE ---------------------------------------------                  
  --DECLARE @dteDate DATETIME                             
   --SET @dteDate = '20140630'             
--------------------------------------------------------------------------------------------------------------            
                
     --DROP TABLE  #TBL_SOPORTE_ESCENARIOS            
     --DROP TABLE  #TBL_HIST_FECHAS            
     --DROP TABLE  #TBL_INST_SIN_VAR_IDS             
     --DROP TABLE  #TBL_HIST_PRICES            
     --DROP TABLE  #TBL_HIST_FECHAS_KEY            
               
    DECLARE @txtAnalytic AS VARCHAR (10)             
        SET @txtAnalytic  =  'VAR'               
                    
    DECLARE @intDays          INT           -- # De Días Historicos                     
        SET @intDays        = 500                      
                      
    DECLARE @dteDateEscenario   DATETIME    -- # Fecha escenario                   
     SELECT @dteDateEscenario = DBO.FUN_NextTradingDate( @dteDate, -@intDays,'MX' )                         
--------------------------------------------------------------------------------------------------------------                       
                            
  CREATE TABLE #TBL_INST_SIN_VAR_IDS                                   
        ( txtID1      CHAR(11)      NOT NULL,                       
          txtTv       VARCHAR(10),                      
          txtEmisora  VARCHAR(10),                      
          txtSerie    VARCHAR(10),                      
          txtAnalytic VARCHAR(10),                      
          txtEstatus  VARCHAR(10),            
          intMarket   INT             
          PRIMARY KEY (txtID1) )                      
                                
  CREATE TABLE #TBL_HIST_PRICES                                             
        ( txtID1          CHAR(11)  NOT NULL,                      
          dteDate         DATETIME  NOT NULL,                        
          txtLiquidation  CHAR(3),                      
          txtItem         CHAR(3),                      
          dblValue        FLOAT     NOT NULL              
          PRIMARY KEY (dteDate,txtID1,txtLiquidation,txtItem) )                
                      
  CREATE TABLE #TBL_HIST_FECHAS         -- Contiene t fechas historicas de operación, a partir de la fecha de valuación                               
        ( dteDate         DATETIME  NOT NULL,                                 
          PRIMARY KEY NONCLUSTERED  (dteDate) )              
                      
  CREATE TABLE #TBL_SOPORTE_ESCENARIOS  -- SOPORTE DE ESCENARIOS EN TBLPRICES                           
        ( txtID1          CHAR(11)  NOT NULL,                       
          dteDate         DATETIME,                      
          txtLiquidation  CHAR(3),                      
          txtItem         CHAR(3),                      
          dteEscenario    DATETIME,                      
          intDaysHist     INT,              
          txtEstatus      CHAR(20)      -- 'OK', 'Datos Insuficientes'            
          PRIMARY KEY (dteDate,txtID1,txtLiquidation,txtItem) )            
                    
  CREATE TABLE #TBL_HIST_FECHAS_KEY           
       ( dteDate          DATETIME,            
         txtId1           CHAR(11),            
         txtLiquidation   CHAR(3),            
         txtItem          CHAR(10),            
         PRIMARY KEY ( dteDate ,txtId1 ,txtLiquidation ,txtItem ) )                 
             
------------------------------------                      
-- INSTRUMENTOS QUE NO TIENEN VAR --                      
------------------------------------                  
INSERT INTO    #TBL_INST_SIN_VAR_IDS                          
              (  txtID1,                           
                 txtTv,                      
                 txtEmisora,                       
                 txtSerie,                          
                 txtAnalytic,                       
                 txtEstatus,            
                 intMarket       )                       
                         
          SELECT                
                  A.txtId1,                      
                  A.txtTv,                      
                  A.txtEmisora,                      
                  A.txtSerie,                      
               A.txtAnalytic,                      
     --B.dteFecha,                      
     --B.txtId1,                      
     --B.txtMTXId,                      
     --B.dblVaR,                      
     --B.dteEscenario,                      
     --B.intCurDateScen,                      
     --B.dteWorstScen,                      
     --B.dteBestScen                      
           'Sin VaR'     AS 'Estatus',                               
         tv.intMarket AS 'Mercado'            
            FROM  tmp_unitest_20150209 AS A WITH(NOLOCK)                      
LEFT OUTER  JOIN  MxXamu.dbo.tblVar      AS B WITH(NOLOCK)                      
              ON  B.dteFecha = @dteDate                      
             AND  A.txtId1   = B.txtId1                      
             AND  B.txtMTXId  NOT IN ('MALFA1000','MALFA')                      
      INNER JOIN  dbo.tblTvCatalog       AS tv WITH(NOLOCK)                      
              ON  tv.txtTv = A.txtTv             
           WHERE  A.txtAnalytic = @txtAnalytic             
             AND  B.txtId1    IS NULL                      
             AND  B.dteFecha  IS NULL                      
        ORDER BY  A.txtTv,A.txtEmisora,A.txtSerie                
            
 ----------------------------------------- VALIDACIÓN ESCENARIOS TBL PRICES ----------------------------------------------- ------------                        
              
    INSERT INTO  #TBL_HIST_FECHAS ( dteDate )                      
                
         SELECT  dteDate                      
           FROM  dbo.tblDates                      
          WHERE  dteDate BETWEEN ( @dteDateEscenario ) AND ( @dteDate )                      
       ORDER BY  dteDate DESC                          
          
          
              
 INSERT #TBL_HIST_FECHAS_KEY (dteDate ,txtId1 ,txtLiquidation ,txtItem)            
           
 SELECT F.dteDate ,c.txtID1 ,'MD' ,'PRS'            
   FROM #TBL_HIST_FECHAS F, #TBL_INST_SIN_VAR_IDS C            
  WHERE C.intMarket = 0            
           
 UNION             
           
 SELECT F.dteDate ,c.txtID1 ,'MP' ,'PAV'            
   FROM #TBL_HIST_FECHAS F, #TBL_INST_SIN_VAR_IDS C            
  WHERE C.intMarket = 1  

  

            
     --  ACTUAL  tblPrices                      
         INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, txtLiquidation,txtItem, dblValue)                          
            
     SELECT  DISTINCT                      
                      p.txtID1,                        
                      p.dteDate,                      
                      p.txtLiquidation,                      
                      p.txtItem,                      
                      p.dblValue                         
        FROM #TBL_HIST_FECHAS_KEY      AS k             
  INNER JOIN MxFixIncome.dbo.tblPrices AS p WITH(NOLOCK)                      
          ON k.dteDate        = p.dteDate             
         AND k.txtId1         = p.txtId1             
         AND K.txtLiquidation = p.txtLiquidation             
         AND k.txtItem        = p.txtItem                     
 -- ORDER BY B.txtID1                    
                       
    --   tblHistoricPrices                      
         INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, txtLiquidation,txtItem, dblValue)                          
            
     SELECT  DISTINCT                      
                      p.txtID1,                        
                      p.dteDate,                   
                      p.txtLiquidation,                      
                      p.txtItem,                      
                      p.dblValue                         
        FROM #TBL_HIST_FECHAS_KEY                   AS k             
  INNER JOIN MxFixIncomeHist.dbo.tblHistoricPrices  AS p WITH(NOLOCK)                      
          ON k.dteDate        = p.dteDate             
         AND k.txtId1         = p.txtId1             
         AND K.txtLiquidation = p.txtLiquidation             
         AND k.txtItem        = p.txtItem                     
 -- ORDER BY B.txtID1                    
            
          
  --     2014 tblHistoricPrices                        
         INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, txtLiquidation,txtItem, dblValue)                          
            
     SELECT  DISTINCT                      
                      p.txtID1,                        
                      p.dteDate,                      
                      p.txtLiquidation,                      
                      p.txtItem,                      
                      p.dblValue                         
        FROM #TBL_HIST_FECHAS_KEY                        AS k             
  INNER JOIN MxFixIncomeHist_2014.dbo.tblHistoricPrices  AS p WITH(NOLOCK)                      
          ON k.dteDate        = p.dteDate             
         AND k.txtId1         = p.txtId1             
         AND K.txtLiquidation = p.txtLiquidation             
         AND k.txtItem        = p.txtItem                     
 -- ORDER BY B.txtID1                  
   
   
   
          
  --     2013 tblHistoricPrices                        
         INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, txtLiquidation,txtItem, dblValue)                          
            
     SELECT  DISTINCT                      
                      p.txtID1,                        
                      p.dteDate,                      
                      p.txtLiquidation,                      
                      p.txtItem,                      
                      p.dblValue                         
        FROM #TBL_HIST_FECHAS_KEY                        AS k             
  INNER JOIN MxFixIncomeHist_2013.dbo.tblHistoricPrices  AS p WITH(NOLOCK)                      
          ON k.dteDate        = p.dteDate             
         AND k.txtId1         = p.txtId1             
         AND K.txtLiquidation = p.txtLiquidation             
         AND k.txtItem        = p.txtItem                     
 -- ORDER BY B.txtID1                  
          
  --     2012 tblHistoricPrices                        
         INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, txtLiquidation,txtItem, dblValue)                          
            
     SELECT  DISTINCT                      
                      p.txtID1,                        
                      p.dteDate,                      
                      p.txtLiquidation,                      
                      p.txtItem,                      
                      p.dblValue                         
        FROM #TBL_HIST_FECHAS_KEY                        AS k             
  INNER JOIN MxFixIncomeHist_2012.dbo.tblHistoricPrices  AS p WITH(NOLOCK)                      
          ON k.dteDate        = p.dteDate             
         AND k.txtId1         = p.txtId1             
         AND K.txtLiquidation = p.txtLiquidation             
         AND k.txtItem        = p.txtItem                     
 -- ORDER BY B.txtID1                  
          

  --     2011 tblHistoricPrices                        
         INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, txtLiquidation,txtItem, dblValue)                         
            
     SELECT  DISTINCT                      
                      p.txtID1,                        
                      p.dteDate,                      
                      p.txtLiquidation,                      
                      p.txtItem,                      
                      p.dblValue                         
        FROM #TBL_HIST_FECHAS_KEY                        AS k             
  INNER JOIN MxFixIncomeHist_2011.dbo.tblHistoricPrices  AS p WITH(NOLOCK)                      
          ON k.dteDate        = p.dteDate             
         AND k.txtId1         = p.txtId1             
         AND K.txtLiquidation = p.txtLiquidation             
         AND k.txtItem        = p.txtItem                     
 -- ORDER BY B.txtID1                  
                
            
  --     2010 tblHistoricPrices                        
         INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, txtLiquidation,txtItem, dblValue)                          
            
     SELECT  DISTINCT                      
                      p.txtID1,                        
                      p.dteDate,                      
                      p.txtLiquidation,                      
                      p.txtItem,                      
                      p.dblValue                         
        FROM #TBL_HIST_FECHAS_KEY                        AS k             
  INNER JOIN MxFixIncomeHist_2010.dbo.tblHistoricPrices  AS p WITH(NOLOCK)                      
          ON k.dteDate        = p.dteDate             
         AND k.txtId1         = p.txtId1             
         AND K.txtLiquidation = p.txtLiquidation             
         AND k.txtItem        = p.txtItem                     
 -- ORDER BY B.txtID1                   
           SELECT * FROM  #TBL_HIST_PRICES
           
           
           
           
           
           
           
           
---------------------------------------------------------------            
--------------------------- REPORTE ---------------------------            
---------------------------------------------------------------            
            
INSERT INTO #TBL_SOPORTE_ESCENARIOS                      
                         
   (  txtID1,                            
      dteDate,                            
      txtLiquidation,                       
      txtItem,                          
      dteEscenario,                       
      intDaysHist,            
      txtEstatus     )                      
                         
     SELECT    txtID1,                      
              -- @dteDate,                       
               txtLiquidation,                      
               txtItem,                       
             --dblValue                           
               MIN   (dteDate) AS  'dteEscenario',                        
               COUNT (dteDate )AS  '# Escenarios Historicos',            
               CASE WHEN  COUNT   (dteDate ) <= 30            
               THEN 'Datos Insuficientes'            
               ELSE 'OK'            
               END            
      FROM #TBL_HIST_PRICES                   
  GROUP BY txtID1,txtItem,txtLiquidation                
              
         
              
-------------------------------- REPORTE ------------------------                        
                
--      DELETE  FROM MxFixIncome.dbo.tmp_tblHistCalculateVar              
--      INSERT       MxFixIncome.dbo.tmp_tblHistCalculateVar            
               
--                 ( dteDate,                    
--                   txtID1,                    
--                   txtLiquidation,             
--                   txtItem,                    
--                   dblValue  )                 
             
--           SELECT distinct        
--                  dteDate,            
--                  txtID1,            
--                  txtLiquidation,            
--                  txtItem,             
--                  dblValue             
--            FROM  #TBL_HIST_PRICES            
               
--    DELETE  FROM MxFixIncome.dbo.tmp_tblIds1EstVar              
--    INSERT       MxFixIncome.dbo.tmp_tblIds1EstVar             
                
        SELECT          
                 distinct        
                 txtID1,                            
                 dteDate,                            
                 txtLiquidation,                       
                 txtItem,                          
                 dteEscenario,                       
                 intDaysHist,            
                 txtEstatus                
         FROM    #TBL_SOPORTE_ESCENARIOS                      
  --            WHERE txtID1 = 'UIRC0016929'
             
             SELECT * FROM  #TBL_HIST_PRICES
              WHERE txtID1 = 'MIRC0018427'
             
             SELECT * FROM  MxFixIncome.dbo.tmp_tblIds1EstVar   
             WHERE txtID1 = 'MIRC0018427'
             
             
             SELECT * FROM  dbo.tblBonds AS TB
             WHERE txtId1 = 'MIRC0018427'
             
              
             SELECT * FROM  dbo.tblBondsAdd  AS TB
             WHERE txtId1 = 'MIRC0018427'
             
             SELECT * FROM  dbo.tblIds AS TI
              WHERE txtId1 = 'MIRC0018427' 
              
              
              SELECT * FROM  dbo.tblIdsAdd AS TIA
                WHERE txtId1 = 'MIRC0018427' 
                
                
                
                
  --              SELECT * FROM  tmp_unitest_20150209
                
                
                
  --              INSERT INTO tmp_unitest_20150209
               
  --            SELECT txtID1,txtTV,txtEmisora,txtSerie,'VAR' FROM  dbo.tblIds AS TI
  --            WHERE txtTV = '1R'
  --            AND txtEmisora = 'LATINCK'
  --            AND txtSerie = '12'
              
              		
		--SELECT * FROM  tmp_unitest_20150209



              
              
  --            SELECT * FROM  dbo.tblIdsAdd AS TIA
             
             
             
             
             
             
             
             
             
               
--END       
    
         
         
         
         /*
         
         
         
         
         
--------------------------------------------------------------------------------------------------------------                                                                                  
-- Author:       Jonathan Ortega Gallegos                                                                            
-- Created:      2014/06/20                                                                         
-- Description:  Metodo  utilizado  para  calcular  el  VaR  parametrico y/o                                             
--               VaR discreto, en aquellos instrumentos que no lo reportaron.                                               
-- Modified By:                                                                                   
-- Modified:                                                                                  
                                            
        -- MxFixIncome.dbo.tmp_tblIds_NotVar                                     
-- EXEC sp_analytic_var;3 '20140619' ,'MD','PRS',500                                               
-- EXEC sp_analytic_var;3 '20140619' ,'MP','PAV',500                                                                 
--------------------------------------------------------------------------------------------------------------                                                                                   
CREATE PROCEDURE [dbo].[sp_analytic_var];3                                              
                                            
      @dteDate          DATETIME,                                              
      @txtLiquidation   CHAR(3),                                             
      @txtItem          CHAR(3),                                             
      @intDays          INT                                                              
AS                                                                                  
BEGIN                                                                                  
                                                                                   
 --BEGIN TRY                                                                                  
  
  
--declare @dteDate DATETIME  
--declare @txtLiquidation CHAR(3)  
--declare @txtItem CHAR(3)  
--declare @intDays INT                                                              
--set @dteDate = '20150205'  
--set @txtLiquidation = 'MP'  
--set @txtItem = 'PAV'  
--set @intDays = 500  
  
                                                                                   
   SET NOCOUNT ON                                               
------------------------------------------ VARIABLES DE ARRANQUE ---------------------------------------------                                               
   --  DECLARE @dteDate          DATETIME -- Fecha de valuación                                            
   --  DECLARE @intDays          INT      -- Número de días historicos a partir de la fecha de valuación                                            
   --  DECLARE @txtItem          CHAR(3)                                             
   --  DECLARE @txtLiquidation   CHAR(3)                                             
     DECLARE @dteDateEscenario DATETIME -- Fecha escenario                                            
     DECLARE @txtTipoVar       CHAR(11) -- P: PARAMETRICO / D: DISCRETO                                            
     DECLARE @dblPercentil     FLOAT    -- Percentil al 97.50%                                            
     DECLARE @txtCNBVMarket    CHAR(3)  -- MC : Mercado de Capitales Nacional/Extranjero y/o                                            
                                        -- MD : Mercado de Deuda     Nacional/Extranjero.                                            
                                            
---------------------  CONFIGURACIÓN DE MERCADO  -----------------                                              
                                            
-- EC    Mercado de Capitales Extranjero ------- -> CONVENIO MC                                            
-- MC    Mercado de Capitales Nacional   ------- -> CONVENIO MC                                             
-- ED    Mercado de Deuda Extranjero     ------- -> CONVENIO MD                                            
-- MD    Mercado de Deuda Nacional       ------- -> CONVENIO MD              
-- txtCNBVMarket MC / MD        
-------------------------------------------------- TABLAS -----------------------------------------------------                                                
         
   --  DROP TABLE  #TBL_HIST_PRICES        
   --  DROP TABLE  #TBL_CALC_VAR        
   --  DROP TABLE  #tblResults        
   --  DROP TABLE  #TBL_INST_SIN_VAR         
   --  DROP TABLE  #TBL_HIST_PRICES_DESFACE        
   --  DROP TABLE  #TBL_VAR        
   --  DROP TABLE  #TBL_PRECIO_VALUACION        
         
 DECLARE  @TBL_HIST_FECHAS TABLE -- Contiene t fechas historicas de operación, a partir de la fecha de valuación                                                     
         ( dteDate          DATETIME  NOT NULL,                                                       
           PRIMARY KEY NONCLUSTERED  (dteDate) )                                          
                                                     
 CREATE TABLE #TBL_HIST_PRICES                                                   
         ( txtID1           CHAR(11)  NOT NULL,                       
           dteDate          DATETIME  NOT NULL,                                             
           dblPrice       FLOAT     NOT NULL )                                            
                                                     
 CREATE TABLE #TBL_HIST_PRICES_DESFACE                         
         ( txtID1           CHAR(11)  NOT NULL,                                      
           dteDate          DATETIME  NOT NULL,                                             
           dblPrice         FLOAT     NOT NULL )                                              
                                              
 CREATE TABLE #TBL_CALC_VAR                                                         
         ( txtID1           CHAR(11)  NOT NULL,                                            
           dteDate          DATETIME  NOT NULL,                                             
           dblRenDis        FLOAT,                                                
           dblRenPar        FLOAT              )                                              
                                                      
 CREATE TABLE #TBL_VAR                                          
         ( dteDate          DATETIME  NOT NULL,                                               
           txtID1           CHAR(11)  NOT NULL,                                            
           dblMedia         FLOAT,                                               
           dblDesvStd       FLOAT,                                               
           dblPercentil     FLOAT             )                                          
                                            
 CREATE TABLE #TBL_PRECIO_VALUACION   -- Contiene los precios de los instrumentos en fecha de valuación                                                      
        ( dteDate           DATETIME  NOT NULL,                                               
          txtID1            CHAR(11)  NOT NULL,                                            
          dblPrice          FLOAT     NOT NULL                                            
       PRIMARY KEY (dteDate,txtID1,dblPrice) )                          
                         
 CREATE TABLE #tblResults                        
       (  dteDate DATETIME     NOT NULL,                        
          txtId1  VARCHAR (15) NOT NULL,                        
          txtItem VARCHAR(10)  NOT NULL,                        
          txtValue VARCHAR (400)                        
       PRIMARY KEY (dteDate,txtID1,txtItem)  )        
               
 CREATE TABLE #TBL_INST_SIN_VAR                                                         
        ( txtID1 CHAR(11) NOT NULL                                             
                 PRIMARY KEY (txtID1)        )                       
                            
                                          
---------------------------------- CONFIGURACIÓN DEL INSTRUMENTO ------------------------------------------                                               
                                               
    --  SET @txtItem        = 'PAV' -- Precio Actualizado Valuacion                  
    --  SET @txtLiquidation = 'MP' -- Misma Liquidacion                                            
    --  SET @dteDate        = '20140627'                                             
    --  SET @intDays        = 250                                            
      SET @dblPercentil   = 1.95996398454005 -- Con Nivel de confianza al 97.5%                                             
      --SET @txtTipoVar     = 'DISCRETO'                                             
    SET @txtTipoVar     = 'PARAMETRICO'                                             
                                             
----------------------------------- INSTRUMENTOS QUE NO TIENEN VAR -----------------------------------------                                             
                                            
--Nota: Insertar mediante proceso los ids de los intrumentos que no tienen VaR                      
                                         
   INSERT INTO  #TBL_INST_SIN_VAR (txtID1)                                            
          
   SELECT  txtID1          
     FROM  MxFixIncome.dbo.tmp_tblIds1EstVar         
    WHERE  txtLiquidation    =  @txtLiquidation          
      AND  txtItem           =  @txtItem        
      AND  txtEstatus        =  'OK'        
              
                                                 
----------------- CREAMOS t FECHAS HISTORICAS (VALIDAS) A PARTIR DE LA FECHA DE VALUACIÓN ---------------                                             
              
        SELECT  @dteDateEscenario = DBO.FUN_NextTradingDate( @dteDate, -@intDays,'MX' )                                            
           
   INSERT INTO   @TBL_HIST_FECHAS ( dteDate )                                            
        SELECT  dteDate                                            
          FROM  tblDates                                            
         WHERE  dteDate BETWEEN ( @dteDateEscenario ) AND ( @dteDate )                                            
      ORDER BY  dteDate DESC                                            
                                            
----------------------------------- CONTRUIMOS LOS PRECIOS HISTORICOS -------------------------------------                                              
           
     INSERT  INTO #TBL_HIST_PRICES ( txtID1,dteDate, dblPrice )            
             
     SELECT  DISTINCT                             
             A.txtID1,                                              
             A.dteDate,                                            
            -- P.txtID1,                                            
            -- P.txtLiquidation,                                            
            -- P.txtItem,                                            
             A.dblValue                                               
            -- P.intFlag                                         
       FROM MxFixIncome.dbo.tmp_tblHistCalculateVar AS A WITH(NOLOCK)                                            
 INNER JOIN  @TBL_HIST_FECHAS                           AS B                                            
         ON A.dteDate         =   B.dteDate                                            
 INNER JOIN #TBL_INST_SIN_VAR                          AS C                                                    
         ON A.txtID1          =   C.txtID1                                               
      WHERE A.txtItem         =   @txtItem                                            
        AND A.txtLiquidation  =   @txtLiquidation                    
           
------------------------ OBTENEMOS EL PRECIO DE LOS INTRUMENTOS EN LA FEHA VE VALUACIÓN -------------------                                                
                                                 
     INSERT INTO #TBL_PRECIO_VALUACION ( dteDate,txtID1, dblPrice )                                            
             
     SELECT dteDate,                                            
            txtID1,                                            
            dblPrice                                            
      FROM #TBL_HIST_PRICES                                             
     WHERE dteDate = @dteDate                                            
                              
--------------------------------------------------- PRECIOS ------------------------------------------------                 
                                              
    INSERT INTO #TBL_HIST_PRICES_DESFACE ( txtID1,dteDate, dblPrice )                                             
                                                   
    SELECT DISTINCT                                            
                    txtID1,                                            
                    dbo.FUN_NextTradingDate(dteDate, +1,'MX'),                                            
                    dblPrice                                            
              FROM #TBL_HIST_PRICES                                           
                                             
------------------------------------------------ CALCULO DEL VAR -------------------------------------------                                                
            
          INSERT INTO #TBL_CALC_VAR ( txtID1,dteDate,dblRenDis,dblRenPar )                                             
                                            
               SELECT  A.txtID1,                                        
                       A.dteDate,                                            
                     --A.dblPrice,                                       
                     --B.dteDate,                                            
                     --B.dblPrice,                                            
                                                      
            CASE WHEN  B.dblPrice <> 0    AND A.dblPrice <> 0                                          
                 THEN  A.dblPrice/B.dblPrice - 1                                              
                 ELSE  0                                             
                  END  AS 'RenDis',                                            
                                                    
            CASE WHEN B.dblPrice <> 0     AND A.dblPrice <> 0                
                 THEN LOG(A.dblPrice/B.dblPrice)                                                 
                 ELSE 0                                            
                  END AS 'RenPar'                                            
       FROM  #TBL_HIST_PRICES           AS A                                            
 INNER JOIN  #TBL_HIST_PRICES_DESFACE   AS B                                            
         ON  A.dteDate = B.dteDate                                            
      WHERE  A.txtID1  = B.txtID1                                            
   ORDER BY  A.txtID1, A.dteDate DESC                                            
                         
------------------------------------------------ CASO DISCRETO ---------------------------------------------                                            
                                            
     IF @txtTipoVar =  'DISCRETO'                                             
                                                
        BEGIN                                             
                INSERT INTO #TBL_VAR                                                                      ( dteDate,                                                    
                    txtID1,                                                    
                    dblMedia,                                                   
                    dblDesvStd,                                             
                    dblPercentil                                            
                  )                                            
                                                             
                SELECT @dteDate       AS 'dteDate',                                            
                       txtID1         AS 'txtID1',                                            
                  AVG (dblRenDis)     AS 'Media Dis',                                            
      STDEV (dblRenDis)     AS 'Desviación STD Dis',                                            
    @dblPercentil  AS 'Percentil (97.5%)'                                            
                                            
         FROM #TBL_CALC_VAR  AS A                             
     GROUP BY txtID1                                            
                                            
        END                                                 
---------------------------------------------- CASO PARAMETRICO  --------------------------------------------                                            
     ELSE                                            
                                             
     BEGIN                             
             INSERT INTO #TBL_VAR                                                    
               ( dteDate,                                                    
                 txtID1,                                                    
                 dblMedia,                                                   
                 dblDesvStd,                                                 
                 dblPercentil                                             
               )                                            
                                            
               SELECT @dteDate       AS 'dteDate',                                            
                      txtID1         AS 'txtID1',                 
                 AVG (dblRenPar)     AS 'Media Dis',                                            
               STDEV (dblRenPar)     AS 'Desviación STD Dis',                                            
                      @dblPercentil  AS 'Percentil (97.5%)'                                            
               FROM #TBL_CALC_VAR  AS A                                            
           GROUP BY txtID1                                            
                                                 
    END                                                     
                                                      
                                            
SET NOCOUNT OFF                                              
                                            
-----------------------------------------------------------------------------------------------------------                                            
---------------------------------------------- RESULT / VAR -----------------------------------------------                                            
-----------------------------------------------------------------------------------------------------------                                            
           
      INSERT INTO  #tblResults (  dteDate, txtId1, txtItem, txtValue  )                        
                                
                                
           SELECT   distinct                       
                      @dteDate   AS 'dteFecha',                                             
                      A.txtID1   AS 'txtId1',                                             
                     'VAR'       AS 'txtItem',                                            
                    
                            
                 CASE WHEN B.dblPrice<>0 AND A.dblDesvStd <>0 AND A.dblPercentil<>0            
                 THEN      B.dblPrice      * A.dblDesvStd   *     A.dblPercentil             
                 ELSE 0            
                 END  AS 'dblVaR'               
                            
             --  B.dblPrice   * A.dblDesvStd   * A.dblPercentil  AS 'dblVaR'                            
             --  @dteDate                                        AS 'dteFecha',                                             
             --  A.txtID1                                        AS 'txtId1',                                             
             --  '¿?'                                            AS 'txtMTXId',                                            
             --  B.dblPrice   * A.dblDesvStd   * A.dblPercentil  AS 'dblVaR',                                            
             --  -- @dteDateEscenario                            AS 'dteEscenario',                               
             -- ( SELECT MIN (C.dteDate)FROM @TBL_HIST_PRICES AS C WHERE C.txtID1  = B.txtID1) AS  'dteEscenario',                                        
             -- ( SELECT count(*)FROM @TBL_HIST_PRICES AS C WHERE C.txtID1  = B.txtID1)        AS  'Días Historia',                                            
             --  '¿?'              AS 'intCurDateScen',                                            
             --  '¿?'              AS 'dteWorstScen',                                            
             --  '¿?'              AS 'dteBestScen'                                  
                --A.dblMedia                                      AS 'Media',                           
                --A.dblDesvStd                                    AS 'Desviación',                                            
                --A.dblPercentil                                  AS 'Desviación STD',                                            
                --B.dblPrice   * A.dblDesvStd   * A.dblPercentil  AS 'VaR',                                            
                --A.dblDesvStd * A.dblPercentil                   AS 'VaR%',                                            
                --@txtTipoVar                                     AS 'Tipo VaR'                                            
           FROM #TBL_VAR               AS A                                            
     INNER JOIN #TBL_PRECIO_VALUACION     AS B                                            
             ON  A.dteDate  =  B.dteDate                                            
            AND  A.txtID1   =  B.txtID1                                               
                                             
-----------------------------------------------------------------------------------------------------------                    
                                  
   INSERT INTO  #tblResults (  dteDate, txtId1, txtItem, txtValue  )                        
                                  
        SELECT  dteDate,           
       txtID1,        
       'VAR',   --txtItem,        
       txtEstatus        
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar         
        WHERE   txtLiquidation   =  @txtLiquidation          
          AND   txtItem           =  @txtItem        
          AND   txtEstatus = 'Datos Insuficientes'        
  
       IF  EXISTS (  SELECT TOP 1 txtId1 FROM #tblResults  )                                                            
                            
         BEGIN    INSERT dbo.tblResults                       
               SELECT  distinct     
                   a.dteDate,                        
                    a.txtId1,                        
                    a.txtItem,                        
                    a.txtValue                          
             FROM  #tblResults  as a    
   left outer join   dbo.tblResults   as b    
             on      a.dteDate = b.dteDate and  a.txtId1    =b.txtId1 and a.txtItem = b.txtItem  
             where     
     b.dteDate is null   
     and b.txtId1  is  null   
     and b.txtItem is null                      
                                                                 
          END                       
        
END      
  
     
  
--------------------------------------------------------------------------------------------------------------                                                                
-- Author:       Jonathan Ortega Gallegos                                                          
-- Created:      2014/06/20                                                       
-- Description:  Metodo  utilizado par realizar nun reporte en aquellos instrumentos          
--               que no presentaron VaR          
-- Modified By:                                                                 
-- Modified:                                                                
                          
-- EXEC sp_analytic_var;4    
                                             
--------------------------------------------------------------------------------------------------------------                                                                 
    
CREATE PROCEDURE [dbo].[sp_analytic_var];4                            
                          
     -- @dteDate DATETIME                           
                                
AS                                                            
 BEGIN                                                                
         SET NOCOUNT ON                           
                    
                    
 -- DECLARE @dteDate     AS DATETIME                    
 -- SET @dteDate      =  '2014-06-23 00:00:00.000'            
           
 ------------------------------------------------------------------------------------------------------------------------                     
          
             
      --DROP TABLE #TBL_INST_EN_MATRICES          
      --DROP TABLE #TBL_INST_EN_MATRICES_1000_501          
      --DROP TABLE #TBL_TOTAL_INST          
             
                              
CREATE TABLE #TBL_INST_EN_MATRICES                             
        ( dteDate         DATETIME  NOT NULL,                     
          txtID1          CHAR(11)  NOT NULL,                     
          txtLiquidation  CHAR(11)  NOT NULL,                     
          txtItem         CHAR(11)  NOT NULL,                 
          txtMatriz       CHAR(60),                    
          txtMTXId        VARCHAR(11)                    
          PRIMARY KEY (dteDate,txtID1,txtLiquidation,txtItem) )           
                    
                               
CREATE TABLE #TBL_INST_EN_MATRICES_1000_501                          
        ( dteDate         DATETIME  NOT NULL,                     
          txtID1          CHAR(11)  NOT NULL,                     
          txtLiquidation  CHAR(11)  NOT NULL,                     
          txtItem         CHAR(11)  NOT NULL,                 
          txtMatriz       CHAR(60),                    
          txtMTXId        VARCHAR(11)                    
          PRIMARY KEY (dteDate,txtID1,txtLiquidation,txtItem) )                    
            
               
CREATE TABLE #TBL_TOTAL_INST                             
        ( dteDate      DATETIME     NOT NULL,                     
          txtID1       CHAR(11),                    
          txtTv        VARCHAR(10),                    
          txtEmisora   VARCHAR(10),                    
          txtSerie     VARCHAR(10),                    
          txtAnalytic  VARCHAR(10),                    
          txtEstatus   VARCHAR(10),                    
          txtMTXId     CHAR(10),                    
          txtMatriz           VARCHAR(35),                    
          txtMatriz_1000_501  VARCHAR(35),                    
          PRIMARY KEY (txtID1)               )                    
                              
             
---------------------------------------------- ESTAN EN MATRICES ? -----------------------------------------------                    
                    
--MxXamu.dbo.tblMatrizPreciosBonos                      
INSERT INTO #TBL_INST_EN_MATRICES ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                                          
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
          'tblMatrizPreciosBonos' AS 'txtMatriz',                    
       'BP'                  AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar   AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosBonos       AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
--MxXamu.dbo.tblMatrizPreciosBonos_1000_501                      
INSERT INTO #TBL_INST_EN_MATRICES_1000_501 ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                    
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
    'tblMatrizPreciosBonos_1000_501' AS 'txtMatriz',                    
       'BP'                    AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar   AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosBonos_1000_501       AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
 ------------------------------------------------------------------------------------------------------------------                   
          
--MxXamu.dbo.tblMatrizPrecios                      
INSERT INTO #TBL_INST_EN_MATRICES ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                    
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
          'tblMatrizPrecios' AS 'txtMatriz',                    
       'DP'                    AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar   AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPrecios       AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
--MxXamu.dbo.tblMatrizPrecios_1000_501                       
INSERT INTO #TBL_INST_EN_MATRICES_1000_501 ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                    
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
    'tblMatrizPrecios_1000_501' AS 'txtMatriz',                    
       'DP'                        AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPrecios_1000_501 AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
------------------------------------------------------------------------------------------------------------------          
                   
--MxXamu.dbo.tblMatrizPreciosAcciones                      
INSERT INTO #TBL_INST_EN_MATRICES ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                    
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
          'tblMatrizPreciosAcciones'           AS 'txtMatriz',                    
       'AP'                                 AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar  AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosAcciones   AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
--MxXamu.dbo.tblMatrizPreciosAcciones_1000_501                       
INSERT INTO #TBL_INST_EN_MATRICES_1000_501 ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                     
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
    'tblMatrizPreciosAcciones_1000_501'         AS 'txtMatriz',                    
       'AP'                                        AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar         AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosAcciones_1000_501 AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
------------------------------------------------------------------------------------------------------------------          
          
--MxXamu.dbo.tblMatrizPreciosIndices                      
INSERT INTO #TBL_INST_EN_MATRICES ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                    
                      
    SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
          'tblMatrizPreciosIndices'           AS 'txtMatriz',                    
       'IP'                                 AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar  AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosIndices   AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
--MxXamu.dbo.tblMatrizPreciosIndices_1000_501                       
INSERT INTO #TBL_INST_EN_MATRICES_1000_501 ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                     
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
    'tblMatrizPreciosIndices_1000_501'         AS 'txtMatriz',                    
       'IP'                                        AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar         AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosIndices_1000_501 AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
------------------------------------------------------------------------------------------------------------------          
          
--MxXamu.dbo.tblMatrizPreciosFondos                      
INSERT INTO #TBL_INST_EN_MATRICES ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                    
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
          'tblMatrizPreciosFondos'           AS 'txtMatriz',                    
       'FP'                                 AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar  AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosFondos   AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
--MxXamu.dbo.tblMatrizPreciosFondos_1000_501                       
INSERT INTO #TBL_INST_EN_MATRICES_1000_501 ( dteDate, txtID1, txtLiquidation, txtItem,txtMatriz, txtMTXId )                     
                      
        SELECT  A.dteDate,          
    A.txtID1,          
    A.txtLiquidation,          
    A.txtItem,          
    'tblMatrizPreciosFondos_1000_501'         AS 'txtMatriz',                    
       'FP'                                        AS 'txtMTXId'                    
         FROM  MxFixIncome.dbo.tmp_tblIds1EstVar         AS A                    
   INNER JOIN  MxXamu.dbo.tblMatrizPreciosFondos_1000_501 AS B WITH(NOLOCK)                    
           ON  A.txtID1 = B.txtId1            
          AND  A.dteDate = B.dteFecha            
               
------------------------------------------- REPORTE -------------------------------------------------------------          
              
--INSERT INTO @TBL_TOTAL_INST                           
--        ( dteDate,                         
--          txtID1,                          
--          txtTv,                            
--          txtEmisora,                  
--          txtSerie,                         
--          txtAnalytic,                      
--          txtEstatus,                       
--          txtMTXId,                         
--          txtMatriz,              
--          txtMatriz_1000_501  )                     
                          
                          
                          
                          
        SELECT  --distinct          
                 A.dteDate         AS 'dteDate',          
                 A.txtID1          AS 'txtID1',          
        A.txtLiquidation  AS 'txtLiquidation',          
     A.txtItem         AS 'txtItem',          
     A.dteEscenario    AS 'dteEscenario',          
     A.intDaysHist     AS 'intDaysHist',          
              
              
      CASE WHEN   A.txtEstatus = 'OK'          
        THEN  'Calculado bajo VaR Parametrico'          
     ELSE  'No Calculado' END AS 'txtEstatus_VaR',          
          
    --B.dteDate         AS 'B.dteDate',                    
    --B.txtID1          AS 'B.txtID1',                            
    --B.txtLiquidation  AS 'B.txtLiquidation',                    
    --B.txtItem         AS 'B.txtItem',                         
    --B.txtMatriz       AS 'B.txtMatriz',                          
    --B.txtMTXId        AS 'B.txtMTXId',            
     CASE WHEN  B.txtMTXId IS NULL                    
          THEN 'No aplica'                    
          ELSE  B.txtMTXId    END  AS 'txtMTXId',            
                   
     CASE WHEN  B.txtMatriz IS NULL                    
          THEN 'No esta en matrices'                    
          ELSE  B.txtMatriz   END  AS 'txtMatriz',             
                   
       --C.dteDate         AS 'C.dteDate',                     
    --C.txtID1          AS 'C.txtID1',                       
    --C.txtLiquidation  AS 'C.txtLiquidation',                  
    --C.txtItem         AS 'C.txtItem',                        
    --C.txtMatriz       AS 'C.txtMatriz',                      
    --C.txtMTXId        AS 'C.txtMTXId',           
           
     CASE WHEN  C.txtMatriz IS NULL                    
          THEN 'No esta en matrices_1000_501'                    
          ELSE  C.txtMatriz  END  AS 'txtMatriz_1000_501',                    
              
     CASE WHEN  C.txtMTXId IS NULL                    
          THEN 'No aplica'                    
          ELSE  C.txtMTXId   END  AS 'txtMTXId'                      
                  
           FROM MxFixIncome.dbo.tmp_tblIds1EstVar AS A                    
LEFT OUTER JOIN #TBL_INST_EN_MATRICES                AS B                    
             ON A.txtID1  = B.txtID1           
            AND A.dteDate = B.dteDate                    
LEFT OUTER JOIN #TBL_INST_EN_MATRICES_1000_501       AS C                    
             ON B.txtID1  = C.txtID1           
            AND B.dteDate = C.dteDate  
             
             
             
           WHERE  A.txtid1 in(  
              
            'MIRC0030290',  
 'LAGE0000594',  
'UIRC0016098',  
'UIRC0016619',  
'UIRC0016621',  
'UIRC0016622',  
'UIRC0016623',  
'UIRC0016928',  
'UFGQ0000001',  
'UIRC0013911',  
'UIRC0013166',  
'UIRC0013917',  
'UIRC0016611',  
'UIRC0016832',  
'UIRC0016833',  
'UIRC0016834',  
'UIRC0016835',  
'UIRC0016836',  
'MADZ9110070',  
'MADZ9110071',  
'MADZ9110093',  
'MCTX9110099',  
'MIRC0010676',  
'MIRC0031919',  
'MIRC0031922',  
'MIRC0028977',  
'MIRC0028978',  
'MIRC0028992',  
'MIRC0028993',  
'MIRC0028869',  
'MIRC0028870',  
'MIRC0028872',  
'MIRC0028824',  
'MIRC0028825',  
'MIRC0028708',  
'MIRC0016746',  
'MIRC0031951',  
'MADZ5220664',  
'MCNJ5220314',  
'MCNJ5220342',  
'MIRC0015584',  
'MIRC0012856',  
'MIRC0010736',  
'MIRC0010737',  
'MIRC0010743',  
'MIRC0010744',  
'MIRC0010749',  
'MIRC0010750',  
'MIRC0010800',  
'MIRC0026053',  
'MIRC0026055',  
'MIRC0023305',  
'MIRC0016761',  
'MIRC0030244',  
'MIRC0030253',  
'MIRC0030350',  
'MIRC0027933',  
'MIRC0028855',  
'MIRC0028812',  
'MIRC0028887',  
'MIRC0028905',  
'MIRC0028906',  
'MIRC0028971',  
'MIRC0031898',  
'MIRC0031399',  
'MIRC0031608',  
'MIRC0031609',  
'MIRC0031610',  
'MIRC0031611',  
'MIRC0031612',  
'MIRC0031613',  
'MIRC0031614',  
'MSCT0000021',  
'MIRC0031507',  
'MIRC0031508',  
'MIRC0031509',  
'MIRC0031510',  
'MIRC0031511',  
'MIRC0031512',  
'MIRC0030163',  
'MIRC0029383',  
'UIRC0001588',  
'UIRC0002292',  
  
'UIRC0016946',  
'MIRC0030273'  
              
              
            )  
              
                                
       ORDER BY A.dteDate,A.txtEstatus,B.txtMatriz                    
            
             
 SET NOCOUNT OFF                      
          
END       
        
      
                      
CREATE PROCEDURE [dbo].[sp_analytic_var];5                       
                      
     -- @dteDate DATETIME                       
                            
AS                                                        
--------------------------------------------------------------------------------------------------------------                                                            
-- Author:                                                        
-- Created:                                                       
-- Modified By:                                                             
-- Modified:                                                            
-- Description:      
--------------------------------------------------------------------------------------------------------------                                                             
 BEGIN                                                            
         SET NOCOUNT ON                       
   
         
         SET NOCOUNT OFF                  
      
END          

*/