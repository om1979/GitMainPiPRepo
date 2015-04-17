  
 

   DECLARE  @txtDate AS VARCHAR(10) = '20150324'
   DECLARE  @txtCategory AS CHAR(4) = 'CET'
   DECLARE  @fMatFlag AS BIT = 1
   DECLARE   @txtBlenderFlag VARCHAR(10)= 'BID'
   
   --4
   --774
  -- DECLARE   @txtBlenderFlag VARCHAR(10)= 'BID'

  
--CREATE PROCEDURE dbo.spi_LicuadoFinal;12  
--    @txtDate AS VARCHAR(10)  
--   ,@txtCategory AS CHAR(4)  
--   ,@fMatFlag AS BIT = 0  
--AS /*   
 --Autor:   CSOLORIO   
 --Creacion:  20121227  
 --Descripcion: Licua Guber  
  
-- Modificado por: CSOLORIO  
-- Modificacion: 20131126  
-- Descripcion: Se modifica obtencion de hechos para ponderar eliminando el distinct  
--*/  
  --  BEGIN  
  
        --SET NOCOUNT ON  
        --SET ANSI_WARNINGS OFF  
  
 DROP TABLE #itblMarketPositions  
 DROP TABLE #tblTvPlazoCatalog  
 DROP TABLE #tblHours  
 DROP TABLE #tblMaxYTMTime  
 DROP TABLE #tblMinOperation  
 DROP TABLE #tblOperations  
 DROP TABLE #tmp_itblPonderado  
 DROP TABLE #tblCorros  
 DROP TABLE #tblLastRates  
 DROP TABLE #tblNewRates  
 DROP TABLE #tblNewCorros  
 DROP TABLE #tblPosturas  
 DROP TABLE #tblBestRates  
 DROP TABLE #tblBestDuration  
 DROP TABLE #tblFillHoles  
 --DROP TABLE #tblBestDuration  
 DROP TABLE #itblCorroPonderado  
 DROP TABLE #itblCorroPonderadoSubastas  
 DROP TABLE #tblPosturasChoice  
 DROP TABLE #tblCorroCerradoRate 
  if OBJECT_ID('#tempdb..#tblMaxEndTime')is not null
 DROP TABLE #tblMaxEndTime
 
   if OBJECT_ID('#tempdb..#tblMaxBeginTime')is not null
 DROP TABLE #tblMaxBeginTime 


                           DROP TABLE #tblTimes 
   DROP TABLE #itblPonderado 
  
        DECLARE @dteBegin AS DATETIME  
        DECLARE @dteEnd AS DATETIME  
    
        CREATE TABLE #itblMarketPositions  
            (  
             intId INT IDENTITY  
            ,intTVPlazoId INT  
            ,txtTv CHAR(3)  
            ,intPlazo INT  
            ,dblRate FLOAT  
            ,dblAmount FLOAT  
            ,txtOperation CHAR(10)  
            ,dteBeginHour DATETIME  
            ,intBegin INT  
            ,dteEndHour DATETIME  
            ,intEnd INT PRIMARY KEY ( intId )  
            )  
     
        CREATE INDEX [IX_itblMarketPositions] ON  #itblMarketPositions  
        (   
        intId,  
        dteBeginHour,  
        dteEndHour  
        )  
  
        CREATE TABLE #tblTvPlazoCatalog  
            (  
       intId INT IDENTITY  
            ,txtTv CHAR(3)  
            ,intPlazo INT PRIMARY KEY ( intId )  
            )  
  
        CREATE TABLE #tblHours  
            (  
             intId INT IDENTITY  
            ,dteHour DATETIME PRIMARY KEY ( intId )  
           )  
  
        CREATE TABLE #tblMaxYTMTime  
            (  
             txtTv CHAR(3)  
            ,intPlazo INT  
            ,intSerial INT  
            ,dteTime DATETIME PRIMARY KEY ( txtTv, intPlazo, intSerial )  
            )  
  
        CREATE TABLE #tblMinOperation  
            (  
             intTVPlazoId INT  
            ,intOperation INT PRIMARY KEY ( intTVPlazoId )  
            )  
  
        CREATE TABLE #tblOperations  
            (  
             intId INT  
            ,intTVPlazoId INT              ,dblLastRate FLOAT  
            ,dblRate FLOAT  
            ,dblFinalRate FLOAT  
            ,dblAmount FLOAT  
            ,intBegin INT  
            ,intEnd INT  
            ,txtOperation CHAR(10)  
            ,intMinOperation INT PRIMARY KEY ( intId, intTVPlazoId )  
            )  
  
        CREATE TABLE #tmp_itblPonderado  
            (  
             intId INT IDENTITY(1, 1)  
            ,intTVPlazoId INT  
            ,txtOperation CHAR(10)  
            ,dblRate FLOAT  
            ,dblAmount FLOAT  
            ,intBegin INT  
            ,intEnd INT PRIMARY KEY ( intId )  
            )  
    
        CREATE TABLE #tblCorros  
            (  
             intTVPlazoId INT  
            ,txtType CHAR(1)  
            ,dblRate FLOAT  
            ,dblAmount FLOAT  
            ,dblKey FLOAT  
            ,intBeg INT  
            ,intEnd INT PRIMARY KEY ( intTVPlazoId, dblRate )  
            )  
  
        CREATE TABLE #tblNewCorros  
            (  
             intTVPlazoId INT  
            ,txtType CHAR(1)  
            ,dblRate FLOAT  
            ,dblAmount FLOAT  
            ,dblKey FLOAT PRIMARY KEY ( intTVPlazoId, dblRate )  
            )  
  
        CREATE TABLE #tblCorroCerradoRate  
            (  
             intTVPlazoId INT  
            ,dblRate FLOAT PRIMARY KEY ( intTVPlazoId )  
            )  
     
        CREATE TABLE #tblLastRates  
            (  
             intTVPlazoId INT  
            ,dblLastRate FLOAT  
            ,dblRate FLOAT PRIMARY KEY ( intTVPlazoId )  
            )  
     
        CREATE TABLE #tblNewRates  
            (  
             intTVPlazoId INT  
            ,dblRate FLOAT PRIMARY KEY ( intTVPlazoId )  
            )  
  
        CREATE TABLE #tblBestRates  
            (  
             intTVPlazoId INT  
            ,txtOperation CHAR(10)  
            ,dblRate FLOAT PRIMARY KEY ( intTVPlazoId )  
            )  
  
        CREATE TABLE #tblBestDuration  
            (  
             intTVPlazoId INT  
            ,txtOperation CHAR(10)  
            ,intDuration INT PRIMARY KEY ( intTVPlazoId )  
            )  
     
        CREATE TABLE #tblPosturas  
            (  
             intTVPlazoId INT  
            ,intId INT  
            ,txtOperation CHAR(10)  
            ,dblRate FLOAT  
            ,dblAmount FLOAT  
            ,intBegin INT  
          ,intEnd INT PRIMARY KEY ( intTVPlazoId )  
            )  
     
        CREATE TABLE #itblCorroPonderado  
            (  
             txtOperationType CHAR(1)  
            ,txtTv CHAR(3)  
            ,intPlazo INT  
            ,dblRate FLOAT  
        ,dblAmount FLOAT  
            )  
      
        CREATE TABLE #tblPosturasChoice  
            (  
             intTVPlazoId INT  
            ,intId INT  
            ,txtOperation CHAR(10)  
            ,dblRate FLOAT  
            ,dblAmount FLOAT  
         ,intBegin INT  
            ,intEnd INT PRIMARY KEY ( intId )  
            )  
  
        CREATE TABLE #tblFillHoles  
            (  
             intId INT  
            ,txtOperation CHAR(10)  
            ,intEnd INT  
            ,intNextBegin INT PRIMARY KEY ( intId )  
            )  
  
        CREATE TABLE #itblCorroPonderadoSubastas  
            (  
             txtTv CHAR(3)  
            ,intPlazo INT  
            ,dblRate FLOAT PRIMARY KEY ( txtTv, intPlazo )  
            )  
  
        DECLARE @dblMinRate FLOAT  
        DECLARE @dblMinAmount FLOAT  
        DECLARE @intMinTime INT  
        DECLARE @txtLiquidations CHAR(50)  
   
        SELECT  
            @intMinTime = txtValue  
        FROM  
            itblBlenderParams  
        WHERE  
 txtBlender = @txtCategory  
            AND txtItem = 'STO'  
  
        SELECT  
            @dblMinAmount = txtValue  
        FROM  
            itblBlenderParams  
        WHERE  
            txtBlender = @txtCategory  
            AND txtItem = 'AMM'  
  
    SELECT  
            @dblMinRate = txtValue  
        FROM  
            itblBlenderParams  
        WHERE  
            txtBlender = @txtCategory  
            AND txtItem = 'AMT'  
    
        SELECT  
            @dblMinRate = txtValue  
        FROM  
       itblBlenderParams  
        WHERE  
            txtBlender = @txtCategory  
            AND txtItem = 'AMT'  
  
        SELECT  
            @txtLiquidations = txtValue  
        FROM  
            itblBlenderParams  
        WHERE  
            txtBlender = @txtCategory  
            AND txtItem = 'ACL'  
  
 -- Obtengo las operaciones del periodo  
   
        IF @fMatFlag = 0   
            BEGIN  
   
                SELECT  
                    @dteBegin = dteHoraIniDia  
                FROM  
  itblParametrosLicuadora  
  
                SELECT  
                    @dteEnd = dteHoraMatutino  
                FROM  
                    itblParametrosLicuadora  
    
                INSERT  #itblMarketPositions  
                        (txtTv,intPlazo,dblRate,dblAmount,txtOperation ,dteBeginHour,dteEndHour   )  
                        SELECT  
                            p.txtTv  
                           ,p.intPlazo  
                           ,p.dblRate  
                           ,SUM(p.dblAmount)  
                           ,CASE WHEN p.txtOperation LIKE 'HECHO%'  
                                 THEN 'HECHO'  
                                 ELSE p.txtOperation  
                            END AS txtOperation  
                           ,CASE WHEN CONVERT(DATETIME, CONVERT(CHAR(5), p.dteBeginHour, 24)) < @dteBegin  
                                 THEN CONVERT(CHAR(5), @dteBegin, 24)  
                                 ELSE CONVERT(CHAR(5), p.dteBeginHour, 24)  
                            END AS dteBeginHour  
                           ,CASE WHEN CONVERT(DATETIME, CONVERT(CHAR(5), p.dteEndHour, 24)) > @dteEnd  
                                 THEN CONVERT(CHAR(5), @dteEnd, 24)  
                                 ELSE CONVERT(CHAR(5), p.dteEndHour, 24)  
                            END AS dteEndHour  
                        FROM  
                            itblMarketPositions p  
                            INNER JOIN itblCategoryTvs t ON p.txtTv = t.txtTv  
                        WHERE  
                            t.txtCategory = @txtCategory  
                        AND p.dteDate = @txtDate  
                            AND 1 = CASE WHEN @txtLiquidations = 'ALL' THEN 1  
                                         WHEN @txtLiquidations = p.txtLiquidation  
                                         THEN 1  
                                    END  
                            AND p.dblAmount > @dblMinAmount  
                            AND p.dblRate > @dblMinRate  
                            AND CASE WHEN p.txtOperation LIKE 'HECHO%' THEN 60  
                           ELSE DATEDIFF(SECOND, p.dteBeginHour,  
                                                   p.dteEndHour)  
                                END > @intMinTime  
                            AND p.dteEndHour > @dteBegin  
              AND p.dteBeginHour <= @dteEnd  
                        GROUP BY  
                            p.txtTv  
                           ,p.intPlazo  
                           ,p.dblRate  
                           ,p.txtOperation  
           ,CONVERT(CHAR(5), p.dteBeginHour, 24)  
                           ,CONVERT(CHAR(5), p.dteEndHour, 24)  
                        ORDER BY  
                            1  
                           ,6  
                           ,7   
     
    END  
  
        ELSE   
            BEGIN  
   
                SELECT  
                    @dteBegin = DATEADD(s, 1, dteHoraMatutino) -- 1900-01-01 12:59:59.000   
                FROM  
                    itblParametrosLicuadora  
  
                SELECT  
                    @dteEnd = dteCloseHour --1900-01-01 13:51:00.000  
                FROM  
                    itblClosesRandom  
                WHERE  
                    dteDate = @txtDate  
     
                INSERT  #itblMarketPositions  
               (   
                         txtTv  
                        ,intPlazo  
                        ,dblRate  
                        ,dblAmount  
                        ,txtOperation  
                        ,dteBeginHour  
   ,dteEndHour  
                        )  
                        SELECT  
                            p.txtTv  
                           ,p.intPlazo  
                           ,p.dblRate  
                           ,SUM(p.dblAmount)  
         ,CASE WHEN p.txtOperation LIKE 'HECHO%'  
                                 THEN 'HECHO'  
                                 ELSE p.txtOperation  
                            END AS txtOperation  
                           ,CASE WHEN CONVERT(DATETIME, CONVERT(CHAR(5), p.dteBeginHour, 24)) < @dteBegin  
                                 THEN CONVERT(CHAR(5), @dteBegin, 24)  
                                 ELSE CONVERT(CHAR(5), p.dteBeginHour, 24)  
                            END AS dteBeginHour  
                    ,CASE WHEN CONVERT(DATETIME, CONVERT(CHAR(5), p.dteEndHour, 24)) > @dteEnd  
                                 THEN CONVERT(CHAR(5), @dteEnd, 24)  
                                 ELSE CONVERT(CHAR(5), p.dteEndHour, 24)  
            END AS dteEndHour  
                        FROM  
                            itblMarketPositions p  
                            INNER JOIN itblCategoryTvs t ON p.txtTv = t.txtTv  
                        WHERE  
                            t.txtCategory = @txtCategory  
                            AND p.dteDate = @txtDate  
                            AND 1 = CASE WHEN @txtLiquidations = 'ALL' THEN 1  
                                         WHEN @txtLiquidations = p.txtLiquidation  
                           THEN 1  
                                    END  
                            AND p.dblAmount > @dblMinAmount  
                            AND p.dblRate > @dblMinRate  
                            AND CASE WHEN p.txtOperation LIKE 'HECHO%' THEN 60  
                                     ELSE DATEDIFF(SECOND, p.dteBeginHour,  
                                                   p.dteEndHour)  
                                END > @intMinTime  
                            AND p.dteEndHour > @dteBegin  
                            AND p.dteBeginHour <= @dteEnd  
                        GROUP BY  
                            p.txtTv  
                           ,p.intPlazo  
                           ,p.dblRate  
                           ,p.txtOperation  
                           ,CONVERT(CHAR(5), p.dteBeginHour, 24)  
                           ,CONVERT(CHAR(5), p.dteEndHour, 24)  
                        ORDER BY  
                            1  
                           ,6  
           ,7   
    
    
            END   
   
                     DELETE 
                           FROM  #itblMarketPositions 
								  WHERE txtOperation NOT LIKE  '%hecho%' AND  txtOperation  like  
									CASE 
										WHEN @txtBlenderFlag ='Bid' THEN 'Venta' 
										WHEN @txtBlenderFlag ='Ask' THEN 'Compra' 
									 END 
									AND @txtBlenderFlag    IN ('Bid','Ask')
  
 

  
        INSERT  #tblTvPlazoCatalog  
                (   
                 txtTv  
                ,intPlazo  
                )  
                SELECT DISTINCT  
                    txtTV  
                   ,intPlazo  
                FROM  
                    #itblMarketPositions  
  
        UPDATE  
            m  
        SET   
            intTVPlazoId = c.intId  
        FROM  
            #itblMarketPositions m  
            INNER JOIN #tblTvPlazoCatalog c ON m.txtTv = c.txtTv  
                                               AND m.intPlazo = c.intPlazo  
  
        INSERT  #tblHours  
                (   
                 dteHour  
                )  
                SELECT DISTINCT  
                    dteBeginHour  
        FROM  
                    #itblMarketPositions  
                UNION  
                SELECT DISTINCT  
                    dteEndHour  
                FROM  
                    #itblMarketPositions  
                ORDER BY  
                    1  
  
 -- Obtengo el codigo de horas  
  
        UPDATE  
            m  
        SET   
            m.intBegin = b.intId  
           ,m.intEnd = e.intId  
        FROM  
            #itblMarketPositions m  
            INNER JOIN #tblHours b ON m.dteBeginHour = b.dteHour  
            INNER JOIN #tblHours e ON m.dteEndHour = e.dteHour  
   
   
 
 -- Obtengo las tasas  
        IF @fMatFlag = 0   
            BEGIN  
    
                INSERT  #tblMaxYTMTime  
                        (   
                         txtTv  
						,intPlazo  
                        ,intSerial  
                        ,dteTime  
                        )  
                        SELECT  
                            t.txtTV  
                           ,DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intPlazo  
                           ,c.intSerialYTM AS intSerial  
                           ,MAX(l.dteTime) AS dteTime  
                        FROM  
                            itblNodesYTMCatalog c ( NOLOCK )  
                            INNER JOIN tblBonds b ( NOLOCK ) ON c.txtId1 = b.txtId1  
                            INNER JOIN itblCategoryTvs t ( NOLOCK ) ON c.txtCategory = t.txtCategory  
                                                              AND c.txtSubCategory = t.txtSubCategory  
                            INNER JOIN itblNodesYTMLevels_BidAskTest l ( NOLOCK ) ON c.intSerialYTM = l.intSerialYTM  
                        WHERE  
                            c.txtCategory = @txtCategory  
                            AND c.fStatus = 1  
                     AND c.dteBeg <= @txtDate  
                            AND l.dteDate = dbo.fun_NextTradingDate(@txtDate, -1, 'MX')  
                        GROUP BY  
							t.txtTV  
                           ,b.dteMaturity  
                           ,c.intSerialYTM  
                        ORDER BY  
                            1  
  

                INSERT  #tblLastRates  
                        (   
						intTVPlazoId   
                        ,dblLastRate  
                        ,dblRate  
                        )  
                        SELECT  
                            c.intId  
                           ,l.dblValue  
						,l.dblValue  
                        FROM  
                            #tblMaxYTMTime m  
                            INNER JOIN itblNodesYTMLevels_BidAskTest l ( NOLOCK ) ON m.intSerial = l.intSerialYTM  --TABLA CON SOLO LA FECHA DEL 20150324
							AND m.dteTime = l.dteTime  
                            INNER JOIN #tblTvPlazoCatalog c ON m.txtTv = c.txtTv  
                                                              AND m.intPlazo = c.intPlazo  
                        WHERE  l.dteDate = dbo.fun_NextTradingDate(@txtDate, -1,'MX')  
       
            END  
           

/*SI LA LICUADORA ES DEFINITIVA*/
        ELSE   
            BEGIN  
                INSERT  #tblLastRates  
                        (   
                       intTVPlazoId  
                        ,dblLastRate  
                        ,dblRate  
                        )  
                        SELECT 
                        DISTINCT  
                            p.intTVPlazoId  
                           ,t.dblTasaFinal  
                           ,t.dblTasaFinal  
                        FROM  
                            itblTasasLicuadasInterfaz t ( NOLOCK )  
                            INNER JOIN #itblMarketPositions p 
                            ON t.txtTV = p.txtTV  
                            AND t.intPlazo = p.intPlazo  
                            WHERE  t.fStatus = 0    
            END  


   /*wHILE PARA CALCULO DE PONDERADOS Y CORROS*/
        DECLARE @intHoras AS INT  
        DECLARE @intHour AS INT  
  
        SET @intHour = 1  
  
        SELECT  
            @intHoras = COUNT(*)  
        FROM  
            #tblHours  
  
        WHILE @intHour <= @intHoras   
            BEGIN  
    
                TRUNCATE TABLE #tblOperations  
                TRUNCATE TABLE #tblMinOperation                  TRUNCATE TABLE #tblNewRates  
                TRUNCATE TABLE #tblNewCorros  
                TRUNCATE TABLE #tblBestRates  
                TRUNCATE TABLE #tblBestDuration  

                INSERT  #tblOperations  
(   
                         intId  
                        ,intTVPlazoId  
                        ,dblLastRate  
                        ,dblRate  
                        ,dblFinalRate  
                        ,dblAmount  
                        ,intBegin  
                        ,intEnd  
                        ,txtOperation  
                        )  
                        SELECT  
                            m.intId  
                           ,m.intTVPlazoId  
                           ,r.dblLastRate  
                           ,m.dblRate  
                           ,r.dblRate  
                           ,m.dblAmount  
                           ,m.intBegin  
                           ,m.intEnd  
                           ,m.txtOperation  
            FROM  
                            #itblMarketPositions m  
                            INNER JOIN #tblLastRates r ON m.intTVPlazoId = r.intTVPlazoId  
                        WHERE  
                            m.intBegin <= @intHour  
                 AND m.intEnd >= @intHour   

                INSERT  #tblMinOperation  
                        (   
                         intTVPlazoId  
                        ,intOperation  
                        )  
                        SELECT  
                            intTVPlazoId  
                           ,MIN(CASE WHEN txtOperation LIKE 'HECHO%' THEN 1  
                                     ELSE 3  
                                END)  
                        FROM  
     #tblOperations  
                        GROUP BY  
                            intTVPlazoId  
    
                UPDATE  
                    m  
                SET   
                    m.intOperation = 2  
                FROM  
                    #tblOperations v  
                    INNER JOIN #tblOperations c ON v.intTVPlazoId = c.intTVPlazoId  
                                                   AND v.dblRate = c.dblRate  
                    INNER JOIN #tblMinOperation m ON v.intTVPlazoId = m.intTVPlazoId  
                WHERE  
                    c.txtOperation = 'COMPRA'  
                    AND v.txtOperation = 'VENTA'  
     
                UPDATE  
                    o  
                SET   
                    o.intMinOperation = m.intOperation  
                FROM  
                    #tblOperations o  
                    INNER JOIN #tblMinOperation m ON o.intTVPlazoId = m.intTVPlazoId  
     
  -- Quito las posturas de los plazos que:  
    
  -- Ya tengan algo mas alto  
  -- Que ya no esten vivas  
    
                UPDATE  
                    p  
                SET   
                    p.intEnd = @intHour - 1  
                FROM  
                    #tblPosturas p  
                    LEFT OUTER JOIN #tblOperations o ON p.intId = o.intId                  WHERE  
                    o.intMinOperation < 3  
                    OR o.intMinOperation IS NULL  
    
                INSERT  #tmp_itblPonderado  
                        (   
                         intTVPlazoId  
 ,txtOperation  
                        ,dblRate  
                        ,dblAmount  
                        ,intBegin  
                        ,intEnd  
                        )  
                        SELECT  
                            intTVPlazoId  
                           ,txtOperation  
                           ,dblRate  
                           ,dblAmount  
                           ,intBegin  
                           ,intEnd  
                        FROM  
                            #tblPosturas  
                        WHERE  
                            intEnd != -999  
     
  -- Elimino  
    
                DELETE FROM  
                    #tblPosturas  
                WHERE  
                    intEnd != -999  
    
  -- Corros invertidos  
    
                INSERT  #tblNewCorros  
                        (   
                         intTVPlazoId  
                        ,txtType  
                        ,dblRate  
                        ,dblAmount  
                        ,dblKey  
                  )  
                        SELECT  
                            v.intTVPlazoId  
                           ,'I'  
                           ,( AVG(v.dblRate) + AVG(c.dblRate) ) / 2  
                           ,CASE WHEN MIN(v.dblAmount) <= MIN(c.dblAmount)  
                                 THEN MIN(v.dblAmount)  
                                 ELSE MIN(c.dblAmount)  
                            END  
                           ,SUM(v.dblRate) + SUM(c.dblRate) / SUM(v.dblAmount)  
                  + SUM(c.dblAmount)  
                        FROM  
                            #tblOperations v  
                            INNER JOIN #tblOperations c ON v.intTVPlazoId = c.intTVPlazoId  
                        WHERE  
          c.txtOperation = 'COMPRA'  
                            AND v.txtOperation = 'VENTA'  
                            AND v.intMinOperation = 3  
                            AND v.dblRate > c.dblRate  
                        GROUP BY  
            v.intTVPlazoId  
     
  
             INSERT  #tblNewCorros  
                        (   
                         intTVPlazoId  
                        ,txtType  
                        ,dblRate  
                        ,dblAmount  
           ,dblKey  
                        )  
                        SELECT  
                            v.intTVPlazoId  
                           ,'C'  
                           ,( AVG(v.dblRate) + AVG(c.dblRate) ) / 2  
                           ,CASE WHEN MIN(v.dblAmount) <= MIN(c.dblAmount)  
                                 THEN MIN(v.dblAmount)  
                                 ELSE MIN(c.dblAmount)  
                            END  
                           ,SUM(v.dblRate) + SUM(c.dblRate) / SUM(v.dblAmount)  
                            + SUM(c.dblAmount)  
                        FROM  
                            #tblOperations v  
                            INNER JOIN #tblOperations c ON v.intTVPlazoId = c.intTVPlazoId  
     LEFT OUTER JOIN #tblNewCorros n ON v.intTVPlazoId = n.intTVPlazoId  
                            LEFT OUTER JOIN #tblCorroCerradoRate r ON v.intTVPlazoId = r.intTVPlazoId  
                        WHERE  
                            c.txtOperation = 'COMPRA'  
                            AND v.txtOperation = 'VENTA'  
                            AND 1 = CASE WHEN ROUND(c.dblRate, 3) <= ROUND(ISNULL(r.dblRate,  
                                                              c.dblFinalRate),  
                                              3)  
                                              AND ROUND(v.dblRate, 3) >= ROUND(c.dblRate  
                                                              - .01, 3) THEN 1  
      WHEN ROUND(v.dblRate, 3) >= ROUND(ISNULL(r.dblRate,  
                                                              v.dblFinalRate),  
                                                              3)  
                                              AND ROUND(c.dblRate, 3) <= ROUND(v.dblRate  
                                                              + .01, 3) THEN 1  
                                         ELSE 0  
                                    END  
                            AND ROUND(ABS(v.dblRate - c.dblrate), 2) <= .01  
                            AND v.intMinOperation = 3  
                            AND n.intTVPlazoId IS NULL  
                        GROUP BY  
                            v.intTVPlazoId  
    
  -- Guardo la tasa original para seguir validando el corro  
    
                INSERT  #tblCorroCerradoRate  
                        (   
                         intTVPlazoId  
                        ,dblRate  
                        )  
                        SELECT DISTINCT  
                       o.intTVPlazoId  
                           ,o.dblLastRate  
                        FROM  
                            #tblNewCorros n  
                            INNER JOIN #tblOperations o ON n.intTVPlazoId = o.intTVPlazoId  
                      LEFT OUTER JOIN #tblCorros c ON n.intTVPlazoId = c.intTVPlazoId  
                                                            AND n.txtType = c.txtType  
   --AND n.dblKey = c.dblKey  
                        WHERE  
        n.txtType = 'C'  
                            AND c.intTVPlazoId IS NULL  
      
                INSERT  #tblNewCorros  
                        (   
                         intTVPlazoId  
                        ,txtType  
                        ,dblRate  
                        ,dblAmount  
                        ,dblKey  
                        )  
                        SELECT  
                            v.intTVPlazoId  
                           ,'H'  
                           ,v.dblRate  
                      ,CASE WHEN MIN(v.dblAmount) <= MIN(c.dblAmount)  
                                 THEN MIN(v.dblAmount)  
                                 ELSE MIN(c.dblAmount)  
 END  
                           ,SUM(v.dblRate) + SUM(c.dblRate)  
                       / COUNT(v.dblAmount) + COUNT(c.dblAmount)  
                        FROM  
                            #tblOperations v  
                            INNER JOIN #tblOperations c ON v.intTVPlazoId = c.intTVPlazoId  
   WHERE  
                            c.txtOperation = 'COMPRA'  
                            AND v.txtOperation = 'VENTA'  
                            AND v.dblRate = c.dblrate  
                            AND v.intMinOperation = 2  
  GROUP BY  
                            v.intTVPlazoId  
                           ,v.dblRate  
  
  -- Mato los corros que ya no existan  
    
                UPDATE  
                    c  
                SET   
                    c.intEnd = @intHour - 1  
                FROM  
                    #tblCorros c  
                    LEFT OUTER JOIN #tblNewCorros n ON c.intTVPlazoId = n.intTVPlazoId  
                                                       AND c.txtType = n.txtType  
                WHERE  
              n.intTVPlazoId IS NULL  
    
  -- Mato los corros cerrados que cambian a invertidos o choice  
    
                UPDATE  
                    c  
                SET   
                    c.intEnd = @intHour - 1  
                FROM  
            #tblCorros c  
                    INNER JOIN #tblNewCorros n ON c.intTVPlazoId = n.intTVPlazoId  
                WHERE  
                    c.txtType = 'C'  
                    AND n.txtType IN ( 'I', 'H' )  
    
  -- Mato los que cambian de llave  
    
                UPDATE  
                    c  
                SET   
                    c.intEnd = @intHour - 1  
                FROM  
                    #tblCorros c  
                    INNER JOIN #tblNewCorros n ON c.intTVPlazoId = n.intTVPlazoId  
                                                  AND c.txtType = n.txtType  
                                                  AND c.dblKey != n.dblKey  
                WHERE  
                    c.intEnd = -999  
  
  -- Inserto para ponderar  
    
               INSERT  #tmp_itblPonderado  
                        (   
                         intTVPlazoId  
                        ,txtOperation  
                        ,dblRate  
                        ,dblAmount  
                        ,intBegin  
                       ,intEnd  
                        )  
                        SELECT  
                            intTVPlazoId  
                           ,txtType  
                           ,dblRate  
                           ,dblAmount  
                  ,intBeg  
                           ,intEnd  
                        FROM  
                            #tblCorros  
                        WHERE  
                            intEnd != -999  
      
  -- Elimino los corros que ya ponderaron  
    
                DELETE FROM  
                    #tblCorros  
                WHERE  
                    intEnd != -999  
  
  -- Inserto los corros nuevos  
                INSERT  #tblCorros  
                        (   
                         intTVPlazoId  
                        ,txtType  
                        ,dblRate  
                        ,dblAmount  
                        ,dblKey  
                        ,intBeg  
                        ,intEnd  
                        )  
       SELECT  
                            n.intTVPlazoId  
                           ,n.txtType  
                           ,n.dblRate  
                           ,n.dblAmount  
                           ,n.dblKey  
                           ,@intHour  
                          ,-999  
                        FROM  
                            #tblNewCorros n  
                            LEFT OUTER JOIN #tblCorros c ON n.intTVPlazoId = c.intTVPlazoId  
                        WHERE  
     c.intTVPlazoId IS NULL  
     
  -- Elimino la tasa del corro cerrado  
    
                DELETE  
                   r  
                FROM  
                    #tblCorroCerradoRate r  
                    LEFT OUTER JOIN #tblCorros c ON r.intTVPlazoId = c.intTVPlazoId  
                                                    AND c.intEnd = -999  
                                                    AND c.txtType = 'C'  
                WHERE  
                    c.intTVPlazoId IS NULL   
     
  -- Mato las posturas cuyos plazos entraron en un corro  
    
                UPDATE  
                    p  
                SET   
                    p.intEnd = @intHour - 1  
                FROM  
                    #tblPosturas p  
                    INNER JOIN #tblCorros c ON p.intTVPlazoId = c.intTVPlazoId  
    
                INSERT  #tmp_itblPonderado  
                        (   
                         intTVPlazoId  
                        ,txtOperation  
                        ,dblRate  
,dblAmount  
                        ,intBegin  
                        ,intEnd  
                        )  
                        SELECT  
                            intTVPlazoId  
                           ,txtOperation  
                           ,dblRate  
                           ,dblAmount  
                           ,intBegin  
                           ,intEnd  
                        FROM  
                            #tblPosturas  
                        WHERE  
                            intEnd != -999  
     
  -- Elimino  
    
                DELETE FROM  
                    #tblPosturas  
                WHERE  
                    intEnd != -999  
     
  --------------------------------------------------------------------------------------------------------------  
  -----------------------------------LICUADO--------------------------------------------------------------------  
  --------------------------------------------------------------------------------------------------------------  
    
  -- Hechos  
    
                INSERT  #tmp_itblPonderado  
                        (   
                         intTVPlazoId  
                        ,txtOperation  
                        ,dblRate  
                        ,dblAmount  
  ,intBegin  
                        ,intEnd  
                        )  
                        SELECT  
                            intTVPlazoId  
                           ,txtOperation  
                           ,dblRate  
                           ,SUM(dblAmount)  
                           ,intBegin  
                           ,intEnd  
                        FROM  
                            #tblOperations  
                        WHERE  
                            txtOperation LIKE 'HECHO%'  
                   GROUP BY  
                            intTVPlazoId  
                           ,txtOperation  
                           ,dblRate  
                           ,intBegin  
                           ,intEnd  
  
  -- Obtenemos las tasas  
                    INSERT  #tblNewRates  
                        (   
                         intTVPlazoId  
                        ,dblRate  
                        )  
                        SELECT  
                            intTVPlazoId  
             ,AVG(dblRate)  
                        FROM  
                            #tblOperations  
                        WHERE  
                            intMinOperation = 1  
                            AND txtOperation LIKE 'HECHO%'  
           GROUP BY  
                            intTVPlazoId  
                        UNION  
                        SELECT  
                            intTVPlazoId  
                           ,AVG(dblRate)  
                        FROM  
             #tblCorros  
                        GROUP BY  
                            intTVPlazoId  
     
  -- Valido si existen posturas que mejoren el nivel guardo las mejores tasas  
    
                INSERT  #tblBestRates  
                        (         intTVPlazoId  
                        ,txtOperation  
                        ,dblRate  
                        )  
                        SELECT  
                            o.intTVPlazoId  
                           ,o.txtOperation  
             ,CASE WHEN o.txtOperation = 'VENTA'  
                                 THEN MAX(o.dblRate)  
                                 WHEN o.txtOperation = 'COMPRA'  
                                 THEN MIN(o.dblRate)  
                            END AS dblRate  
                        FROM  
                            #tblOperations o  
                            LEFT OUTER JOIN #tblCorros c ON o.intTVPlazoId = c.intTVPlazoId  
                        WHERE  
                            o.intMinOperation = 3  
                            AND c.intTVPlazoId IS NULL  
                            AND 1 = CASE WHEN o.txtOperation = 'VENTA'  
                                              AND ROUND(o.dblRate, 10) >= ROUND(o.dblFinalRate,  
                                        10) THEN 1  
                                         WHEN o.txtOperation = 'COMPRA'  
                                              AND ROUND(o.dblRate, 10) <= ROUND(o.dblFinalRate,  
                             10) THEN 1  
                                         ELSE 0  
                                    END  
                        GROUP BY  
                            o.intTVPlazoId  
                           ,o.txtOperation  
     
  -- Obtengo la postura mas larga con esa tasa  
    
                INSERT  #tblBestDuration  
                        (   
                         intTVPlazoId  
                        ,txtOperation  
                        ,intDuration  
          )  
                        SELECT  
                            r.intTVPlazoId  
                           ,r.txtOperation  
                           ,MAX(intEnd - intBegin)  
                        FROM  
                            #tblBestRates r  
                            INNER JOIN #tblOperations o ON r.intTVPlazoId = o.intTVPlazoId  
                                                           AND r.dblRate = o.dblRate  
                                                           AND r.txtOperation = o.txtOperation  
                        GROUP BY  
                            r.intTVPlazoId  
                           ,r.txtOperation  
     
  -- Elimino la mejor postura anterior  
    
                UPDATE  
                    p  
   SET   
                    p.intEnd = @intHour - 1  
                FROM  
                    #tblPosturas p  
                    INNER JOIN #tblBestRates r ON p.intTVPlazoId = r.intTVPlazoId  
    
                INSERT  #tmp_itblPonderado  
            (   
                         intTVPlazoId  
                        ,txtOperation  
                        ,dblRate  
                        ,dblAmount  
                        ,intBegin  
                        ,intEnd  
 )  
                        SELECT  
                            intTVPlazoId  
                           ,txtOperation  
                           ,dblRate  
                           ,dblAmount  
                           ,intBegin  
      ,intEnd  
                        FROM  
                            #tblPosturas  
                        WHERE  
                            intEnd != -999  
     
  -- Elimino  
    
                DELETE FROM  
                    #tblPosturas  
         WHERE  
                    intEnd != -999  
    
  -- Inserto las posturas  
     
                INSERT  #tblPosturas  
                        (   
                         intTVPlazoId  
                        ,intId  
                        ,txtOperation  
                        ,dblRate  
                        ,dblAmount  
                        ,intBegin  
                        ,intEnd  
                        )  
                    SELECT  
                            o.intTVPlazoId  
                  ,MIN(o.intId)  
                           ,o.txtOperation  
                           ,CASE WHEN o.txtOperation = 'COMPRA'  
                                 THEN o.dblRate - 0.01  
                                 WHEN o.txtOperation = 'VENTA'  
                                 THEN o.dblRate + 0.01  
                            END  
                           ,SUM(o.dblAmount)  
                           ,@intHour  
                           ,-999  
                        FROM  
                 #tblOperations o  
                            INNER JOIN #tblBestRates r ON o.intTVPlazoId = r.intTVPlazoId  
                                                          AND o.txtOperation = r.txtOperation  
                        AND o.dblRate = r.dblRate  
                            INNER JOIN #tblBestDuration d ON o.intTVPlazoId = d.intTVPlazoId  
                                                             AND o.txtOperation = d.txtOperation  
                                                 AND o.intEnd  
                                                             - o.intBegin = d.intDuration  
                        GROUP BY  
                            o.intTVPlazoId  
    ,o.txtOperation  
                           ,o.dblRate  
  -- Actualizo las tasas  
    
                INSERT  #tblNewRates  
                        (   
                         intTVPlazoId  
                        ,dblRate  
                        )                          SELECT  
                            intTVPlazoId  
                           ,dblRate  
                        FROM  
                            #tblPosturas  
    
  -- Actualizo las tasas anteriores  
    
                UPDATE  
                  r  
                SET   
                    r.dblLastRate = o.dblFinalRate  
                FROM  
                    #tblPosturas p  
                    INNER JOIN #tblOperations o ON p.intId = o.intId  
                    INNER JOIN #tblLastRates r ON o.intTVPlazoId = r.intTVPlazoId  
    
  -- Actualizo los cambios  
     
                UPDATE  
                    r  
                SET   
                    r.dblRate = n.dblRate  
                FROM  
                    #tblLastRates r  
                    INNER JOIN #tblNewRates n ON r.intTVPlazoId = n.intTVPlazoId  
    
                SET @intHour = @intHour + 1  
  
            END 
           
   --        SELECT * FROM #tblBestDuration
		 --  SELECT * FROM #tblCorros 
			--SELECT * FROM #tblCorroCerradoRate
			--SELECT * FROM #tblNewCorros
			--SELECT * FROM #tblOperations SELECT * FROM #tmp_itblPonderado  
   --        SELECT * FROM #tblNewRates
   --       SELECT * FROM #tblLastRates
   --       SELECT * FROM #tblPosturas
   
   /*FIN CALCULO  CORROS */
 -- Inserto los corros y las posturas que sigan vivas  
  
        INSERT  #tmp_itblPonderado  
          (   
                 intTVPlazoId  
                ,txtOperation  
                ,dblRate  
                ,dblAmount  
                ,intBegin  
                ,intEnd  
                )  
                SELECT  
                    intTVPlazoId  
                   ,txtType  
                   ,dblRate  
                   ,dblAmount  
                   ,intBeg  
                   ,@intHour - 1  
                FROM  
                    #tblCorros  
                WHERE  
                    intEnd = -999  
                UNION  
                SELECT  
                    intTVPlazoId  
                   ,txtOperation  
                   ,dblRate  
                   ,dblAmount  
                   ,intBegin  
                   ,@intHour - 1  
            FROM  
                    #tblPosturas  
                WHERE  
                    intEnd = -999  
  
 -- Actualizo las horas de fin de los choice  
  
        UPDATE  
            #tmp_itblPonderado  
        SET   
            intEnd = intBegin  
      WHERE  
            txtOperation = 'H'  
   
 -- Relleno los espacios intermedios   
   
        INSERT  #tblFillHoles  
                (   
                 intId  
                ,txtOperation  
                ,intEnd  
                ,intNextBegin  
             )  
                SELECT  
                    l.intId  
                   ,l.txtOperation  
                   ,l.intEnd  
                   ,CASE WHEN MIN(n.intBegin) IS NULL THEN -999  
                         ELSE MIN(n.intBegin)  
            END  
                FROM  
                    #tmp_itblPonderado l  
                    LEFT OUTER JOIN #tmp_itblPonderado n ON l.intTVPlazoId = n.intTVPlazoId  
                                                            AND l.intId != n.intId  
                                                            AND l.intEnd < n.intBegin  
                GROUP BY  
                    l.intId  
                   ,l.intEnd  
                   ,l.txtOperation  
    
        UPDATE  
            p  
        SET   
            p.intEnd = h.intNextBegin  
        FROM  
            #tblFillHoles h  
            INNER JOIN #tmp_itblPonderado p ON h.intId = p.intId  
        WHERE  
            h.intEnd != h.intNextBegin  
            AND h.intNextBegin != -999  
     AND h.txtOperation NOT LIKE 'H%'  
  
        INSERT  #tmp_itblPonderado  
                (   
                 intTVPlazoId  
                ,txtOperation  
                ,dblRate  
                ,dblAmount  
                ,intBegin  
				,intEnd  
                )  
                SELECT  
                    p.intTVPlazoId  
                   ,'POSTURA_H'  
                   ,p.dblRate  
                   ,p.dblAmount  
                   ,p.intEnd  
                   ,h.intNextBegin - 1                  FROM  
                    #tblFillHoles h  
                    INNER JOIN #tmp_itblPonderado p ON h.intId = p.intId  
                WHERE  
                    h.intEnd + 1 != h.intNextBegin  
                    AND h.intNextBegin != -999  
                    AND h.txtOperation LIKE 'H%'  
    
  
 -- Elimino para insertar itblPonderado   
  
        DELETE  
            p  
        FROM  
            itblPonderado_BidAsk  p  
            INNER JOIN #tblTvPlazoCatalog t ON p.txtTV = t.txtTV  
        WHERE  
            p.dteDate = @txtDate  
            AND p.dteBeginHour >= @dteBegin  
            AND p.dteEndHour <= @dteEnd   
             AND @txtBlenderFlag  = txtType
             AND TXTblenderMatFlag = @fMatFlag
          
             

 -- Inserto en itblPonderado  
        	 INSERT  dbo.itblPonderado_BidAsk
							( 
							 dteDate
							,intPlazo
							,txtOperation
							,txtTv
							,dblRate
							,dblAmount
							,dteBeginHour
							,dteEndHour
							,txtType
							,txtBlenderMatFlag
							)
							SELECT
								@txtDate
							   ,t.intPlazo
							   ,p.txtOperation
							   ,t.txtTv
							   ,p.dblRate
							   ,p.dblAmount
							   ,hb.dteHour
							   ,he.dteHour
							   ,@txtBlenderFlag
							   ,@fMatFlag
							FROM
								#tmp_itblPonderado p
								INNER JOIN #tblTvPlazoCatalog t ON p.intTVPlazoId = t.intId
								INNER JOIN #tblHours hb ON p.intBegin = hb.intId
								INNER JOIN #tblHours he ON p.intEnd = he.intId
                    
   
        IF @fMatFlag = 0   
            BEGIN  
   
                CREATE TABLE #tblMaxEndTime  
                    (  
                     txtTv CHAR(10)  
                    ,intPlazo INT  
                    ,dteTime DATETIME PRIMARY KEY ( txtTv, intPlazo )  
                    )  
      
                INSERT  #tblMaxEndTime  
                        (   
                         txtTv  
                        ,intPlazo  
                        ,dteTime  
                        )  
  SELECT DISTINCT  
                            p.txtTv  
                           ,p.intPlazo  
                           ,MAX(p.dteEndHour)  
                        FROM  
                            itblPonderado_BidAsk p ( NOLOCK )  
  INNER JOIN #tblTvPlazoCatalog t ON p.txtTV = t.txtTV  
                        WHERE  
                            p.dteDate = @txtDate  
                            AND p.dteBeginHour >= @dteBegin  
                            AND p.dteEndHour <= @dteEnd  
          GROUP BY  
                            p.txtTv  
                           ,p.intPlazo  
      
  -- De las horas maximas tomamos la que empezo despues  
  
                CREATE TABLE #tblMaxBeginTime  
                    (  
                     txtTv CHAR(10)  
                    ,intPlazo INT  
                    ,dteTime DATETIME PRIMARY KEY ( txtTv, intPlazo )  
                    )  
      
                INSERT  #tblMaxBeginTime  
                        (   
                         txtTv  
                    ,intPlazo  
                        ,dteTime  
                        )  
                        SELECT DISTINCT  
                            p.txtTv  
                           ,p.intPlazo  
                           ,MAX(p.dteBeginHour)  
                        FROM  
                            #tblMaxEndTime t  
                            INNER JOIN itblPonderado_BidAsk p ( NOLOCK ) ON t.txtTv = p.txtTv  
                                                              AND t.intPlazo = p.intPlazo  
                                                              AND t.dteTime = p.dteEndHour  
                        WHERE  
                            p.dteDate = @txtDate  
                        GROUP BY  
                            p.txtTv  
                    ,p.intPlazo  
      
  -- Si no obtenemos el ultimo nivel de las posturas  
    
                DELETE  
                    p  
                FROM  
                    itblPonderadoFinal_BidAsk p -- tblPonderadoFinal p  
                    INNER JOIN #tblTvPlazoCatalog t ON p.txtTV = t.txtTV  
                WHERE  
                    dteDate = @txtDate  
                    AND fStatus = @fMatFlag  
                    AND  txtType = @txtBlenderFlag
                    
                    
                    /*TODO BIEN HASTA ESTE PUNTO HACIA ARRIBA NO HAY CAMBIOS POR HACER*/
    
                IF @txtCategory = 'CET'   
                    BEGIN  
    
   -- Si tenemos subasta tomamos el nivel  

    
                        INSERT  itblPonderadoFinal_BidAsk  
                                (   
                                 dteDate  
                                ,txtTv  
                                ,intPlazo  
                                ,dblTasaFinal  
                                ,dblAmount  
                                ,fStatus
                               ,txtType   
                                )  
                                SELECT  
                                    r.dteDate  
                                   ,i.txtTv  
                                   ,DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intPlazo  
                                   ,r.dblPrice  
                                   ,r.dblAmount  
                                   ,@fMatFlag 
                                   ,@txtBlenderFlag 
								 FROM  
                                    tblBondsPricesRange AS r  
                                   ,tblIds AS i  
                                    INNER JOIN tblBonds AS b ON i.txtId1 = b.txtId1  
                                    INNER JOIN itblCategoryTvs t ( NOLOCK ) ON i.txtTV = t.txtTV  
                                WHERE  
                                    r.dteDate = @txtDate  
                                    AND t.txtCategory = @txtCategory  
									 AND r.txtType IN ( 'WET', 'CET' )  
                                    AND r.txtSubType = 'CT'  
                                    AND r.intBeg <= DATEDIFF(DAY, r.dteEfective,   b.dteMaturity)  
                                    AND r.intEnd >= DATEDIFF(DAY, r.dteEfective, b.dteMaturity)  
                                    AND i.txtTv = 'BI'  
                                UNION  
                                SELECT  
                                    r.dteDate  
                                   ,i.txtTv  
                                   ,DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intPlazo  
                                   ,r.dblPrice  
								   ,r.dblAmount  
                                   ,@fMatFlag
                                   ,@txtBlenderFlag  
                                FROM  
                                    tblBondsPricesRange AS r  
                                   ,tblIds AS i  
                                    INNER JOIN tblBonds AS b ON i.txtId1 = b.txtId1  
                                    INNER JOIN itblCategoryTvs t ( NOLOCK ) ON i.txtTV = t.txtTV  
                                WHERE  
                                    r.dteDate = @txtDate  
                                    AND t.txtCategory = @txtCategory  
                                    AND r.txtType = 'CET'  
                                    AND r.txtSubType LIKE 'B%'  
                                    AND r.intBeg <= DATEDIFF(DAY, r.dteEfective,b.dteMaturity)  
                                    AND r.intEnd >= DATEDIFF(DAY,r.dteEfective, b.dteMaturity)  
                                    AND i.txtTv LIKE 'M%'  
    
                    END  
                    
                    
                     
                    /* NO SE REQUIERE UTILIZARLO CASO SOLO SUBASTA (OTROS SE DEBE INCORPORAR ULTIMO QUERY)
             
  */
    
      --          INSERT  itblPonderadoFinal_BidAsk  
      --                  (   
      --                   dteDate  
      --                  ,txtTv  
						--,intPlazo  
      --                  ,dblTasaFinal  
      --                  ,dblAmount  
      --                  ,fStatus  
      --                  ,txtType
      --                  )  
      --                  SELECT  
      --                      p.dteDate  
      --                     ,p.txtTv  
      --                     ,p.intPlazo  
      --                     ,AVG(p.dblRate)  
      --                     ,MIN(p.dblAmount)  
      --                     ,@fMatFlag
      --                     ,@txtBlenderFlag
      --                  FROM  
      --                      #tblMaxEndTime t  
      --               INNER JOIN #tblMaxBeginTime b ON t.txtTv = b.txtTv  
      --                                                       AND t.intPlazo = b.intPlazo  
      --                      INNER JOIN itblPonderado_BidAsk p ( NOLOCK ) ON t.txtTv = p.txtTv  
      --                                                    AND t.intPlazo = p.intPlazo  
      --                                                        AND t.dteTime = p.dteEndHour  
      --                                                        AND b.dteTime = p.dteBeginHour  
      --                      LEFT OUTER JOIN itblPonderadoFinal_BidAsk f ( NOLOCK ) ON t.txtTv = f.txtTv  
      --                                                        AND t.intPlazo = f.intPlazo  
      --        AND p.dteDate = f.dteDate  
      --                                                        AND f.fStatus = @fMatFlag  
      --                  WHERE  
      --                      p.dteDate = @txtDate  
      --                      AND f.txtTv IS NULL  
      --                      AND P.txtType = @txtBlenderFlag
      --                  GROUP BY  
      --                      p.dteDate  
      --                     ,p.txtTv  
      --                     ,p.intPlazo   

            END  
           /*TERMINA CALCULO DE LICUADORA BANDA 1  MATFLAG = 0*/
           
         -- SELECT * FROM itblPonderadoFinal_BidAsk
          --SELECT * FROM   itblPonderado_BidAsk
         --TRUNCATE TABLE  itblPonderadoFinal_BidAsk
         -- TRUNCATE TABLE itblPonderado_BidAsk
        
       
         /*EMPIEZA CALCULO DE TASAS LICUADORA BANDA 2 MATFLAG = 1*/
   

        ELSE   
            BEGIN  
   
                CREATE TABLE #tblTimes  
                    (  
                     txtTv CHAR(3)  
                    ,intPlazo INT  
                    ,dteTime DATETIME  
                    ,txtId CHAR(3) PRIMARY KEY ( txtTv, intPlazo, txtId )  
                    )  
      
                CREATE TABLE #itblPonderado  
                    (  
                     intId INT IDENTITY(1, 1)  
                    ,intPlazo INT  
                    ,txtOperation CHAR(10)  
                    ,txtTv CHAR(3)  
                    ,dblRate FLOAT  
					,dblAmount FLOAT  
                    ,dteBeginHour DATETIME  
                    ,dteEndHour DATETIME  
                    )  
      
  -- Obtengo las horas de los extremos para rellenar  
    
                INSERT  #tblTimes  
        (   
                         txtTv  
                        ,intPlazo  
                        ,dteTime  
                        ,txtId  
                        )  
                        SELECT DISTINCT  
                            p.txtTv  
                      ,p.intPlazo  
                           ,MIN(p.dteBeginHour)  
                           ,'MIN'  
                        FROM  
                            itblPonderado_BIDASK p ( NOLOCK )  
                            INNER JOIN #tblTvPlazoCatalog t ON p.txtTV = t.txtTV  
                        WHERE  
                            p.dteBeginHour >= @dteBegin  
                            AND p.dteDate = @txtDate  
                        GROUP BY  
                            p.intPlazo  
                    ,p.txtTv  
                        UNION  
                        SELECT DISTINCT  
                            p.txtTv  
                           ,p.intPlazo  
                           ,MAX(p.dteEndHour)  
                           ,'MAX'  
                        FROM  
                            itblPonderado_BIDASK p ( NOLOCK )  
                            INNER JOIN #tblTvPlazoCatalog t ON p.txtTV = t.txtTV  
                        WHERE  
                            p.dteBeginHour >= @dteBegin  
                            AND p.dteDate = @txtDate  
                            AND P.TXTTYPE = @txtBlenderFlag
                            AND P.txtBlenderMatFlag =  @fMatFlag
                        GROUP BY  
                            p.intPlazo  
                           ,p.txtTv  
                           

                        

  -- Para posturas actualizo la hora de fin hasta el cierre  
    
				UPDATE   i  
					SET   
                    i.dteEndHour = @dteEnd  
						FROM  
							itblPonderado_BIDASK i ( NOLOCK )  
							INNER JOIN #tblTimes t ON i.txtTv = t.txtTv  
							AND i.intPlazo = t.intPlazo  
							LEFT OUTER JOIN itblPonderado_BIDASK ih ( NOLOCK ) ON i.intPlazo = ih.intPlazo  
																	  AND i.txtTv = ih.txtTv  
							 AND i.dteEndHour = ih.dteEndHour  
																	  AND i.txtOperation != ih.txtOperation  
						WHERE  
							i.dteBeginHour >= @dteBegin  
							AND i.dteEndHour = t.dteTime  
							AND i.dteDate = @txtDate  
							AND t.txtId = 'MAX'  
							AND i.txtOperation NOT LIKE 'HECHO%'  
							AND i.txtOperation != 'H'  
							AND ih.intPlazo IS NULL
							AND i.txtType = @txtBlenderFlag
							AND i.txtBlenderMatFlag =  @fMatFlag  
							
							
                INSERT  itblPonderado_BIDASK  
                        (   
                         dteDate  
                        ,intPlazo  
                        ,txtOperation  
                        ,txtTv  
                        ,dblRate  
						,dblAmount  
                        ,dteBeginHour  
                        ,dteEndHour 
                        ,txtType
                        ,txtBlenderMatFlag 
                        )  
						 -- Inserto Banda_1  
							SELECT  
								@txtDate  
								,i.intPlazo  
							   ,'BANDA_1'  
							   ,i.txtTv  
							   ,i.dblTasaFinal  
							   ,i.dblAmount  
							   ,@dteBegin  
							   ,t.dteTime
							   ,@txtBlenderFlag 
							   ,@fMatFlag 
							FROM  
								#tblTimes t  
								INNER JOIN itblTasasLicuadasInterfaz i ( NOLOCK ) ON t.txtTv = i.txtTv  
																  AND t.intPlazo = i.intPlazo  
							WHERE  
								i.fStatus = 0  
								AND t.dteTime != @dteBegin  
								AND t.txtId = 'MIN'  
                        UNION  
    
  -- Inserto una postura dummy para rellenar ponderar el nivel hasta el cierre  
                        SELECT  
                            i.dteDate  
                           ,i.intPlazo  
                           ,'POSTURA_H'  
                           ,i.txtTv  
							,i.dblRate  
                           ,i.dblAmount  
                           ,i.dteEndHour  
                           ,@dteEnd 
						   ,@txtBlenderFlag --POSTURAH
						   ,@fMatFlag --POSTURAH
                        FROM  
                            itblPonderado_BIDASK i ( NOLOCK )  
                            INNER JOIN #tblTimes t ON i.txtTv = t.txtTv  
                                                      AND i.intPlazo = t.intPlazo  
                        WHERE  
                            i.dteBeginHour >= @dteBegin  
                            AND i.dteEndHour = t.dteTime  
                            AND i.dteDate = @txtDate  
                            AND t.txtId = 'MAX'  
                            AND ( i.txtOperation LIKE 'HECHO%'  
                                  OR i.txtOperation = 'H'  
                    )  
                            AND i.dteEndHour != @dteEnd  
                            AND i.txtType = @txtBlenderFlag
							AND i.txtBlenderMatFlag =  @fMatFlag  
                            
                            

  
  -- Obtengo posturas ponderadas  

                INSERT  #itblCorroPonderado  
                        (   
                         txtOperationType  
						,txtTv  
                        ,intPlazo  
                        ,dblRate  
                        ,dblAmount  
                        )  
                        SELECT DISTINCT  
                            'P'  
                           ,p.txtTv  
                          ,p.intPlazo  
                           ,SUM(p.dblRate * p.dblAmount * DATEDIFF(s,  
                                                              p.dteBeginHour,  
                                                              p.dteEndHour))  
                            / SUM(p.dblAmount * DATEDIFF(s, p.dteBeginHour,  
                                                         p.dteEndHour))  
                           ,SUM(p.dblAmount * DATEDIFF(s, p.dteBeginHour,  
                                     p.dteEndHour))  
                            / SUM(DATEDIFF(s, p.dteBeginHour, p.dteEndHour))  
                        FROM  
                            itblPonderado_BIDASK p ( NOLOCK )  
                        INNER JOIN #tblTvPlazoCatalog t   
                        ON   
       p.txtTV = t.txtTV  
       AND p.intPlazo = t.intPlazo  
                        WHERE  
                            p.dteBeginHour >= @dteBegin  
                            AND p.txtOperation NOT LIKE 'HECHO%'  
                            AND p.txtOperation != 'H'  
                            AND p.dteDate = @txtDate  
                            AND P.txtType = @txtBlenderFlag
                        GROUP BY  
                            p.intPlazo  
                           ,p.txtTv  
                           
  -- Insertamos los Hechos  
  
                INSERT  #itblCorroPonderado  
                        (   
                         txtOperationType  
                        ,txtTv  
                        ,intPlazo  
                        ,dblRate  
                        ,dblAmount  
                        )  
							SELECT  
								'H'  
							   ,p.txtTv  
							   ,p.intPlazo  
							   ,p.dblRate  
							   ,p.dblAmount  
						   FROM  
								itblPonderado_BIDASK p ( NOLOCK )  
									INNER JOIN #tblTvPlazoCatalog t   
									ON   
									p.txtTV = t.txtTV  
									 AND p.intPlazo = t.intPlazo  
									 WHERE  
												p.dteBeginHour >= @dteBegin  
												AND ( p.txtOperation LIKE 'HECHO%'  
													  OR p.txtOperation = 'H'  
													)  
												AND p.dteDate = @txtDate  
												AND p.txtType = @txtBlenderFlag
												
											
         
  -- Insertamos la subasta  
    
                IF @txtCategory = 'CET'   
                    BEGIN  
    
   -- Si tenemos subasta tomamos el nivel  
    
                        INSERT  #itblCorroPonderado  
            (   
                                 txtOperationType  
                                ,txtTv  
                                ,intPlazo  
                                ,dblRate  
                                ,dblAmount  
             )  
                                SELECT  
                                    'S'  
                                   ,i.txtTv  
                                   ,DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intPlazo  
								   ,r.dblPrice  
                                   ,r.dblAmount  
                                FROM  
                                    tblBondsPricesRange AS r  
                                   ,tblIds AS i  
									INNER JOIN tblBonds AS b ON i.txtId1 = b.txtId1  
                                    INNER JOIN itblCategoryTvs t ( NOLOCK ) ON i.txtTV = t.txtTV  
                                WHERE  
                                    r.dteDate = @txtDate  
									AND t.txtCategory = @txtCategory  
                                    AND r.txtType IN ( 'WET', 'CET' )  
                                    AND r.txtSubType = 'CT'  
                                    AND r.intBeg <= DATEDIFF(DAY,r.dteEfective, b.dteMaturity)  
                                    AND r.intEnd >= DATEDIFF(DAY,r.dteEfective, b.dteMaturity)  
                                    AND i.txtTv = 'BI'  
                                UNION  
                                SELECT  
                                    'S'  
                                   ,i.txtTv  
                                   ,DATEDIFF(DAY, @txtDate, b.dteMaturity) AS intPlazo  
								   ,r.dblPrice  
                                   ,r.dblAmount  
									FROM  
										tblBondsPricesRange AS r  
									   ,tblIds AS i  
										INNER JOIN tblBonds AS b ON i.txtId1 = b.txtId1  
										INNER JOIN itblCategoryTvs t ( NOLOCK ) ON i.txtTV = t.txtTV  
											WHERE  
												r.dteDate = @txtDate  
												AND t.txtCategory = @txtCategory  
												AND r.txtType = 'CET'  
												AND r.txtSubType LIKE 'B%'  
												AND r.intBeg <= DATEDIFF(DAY,r.dteEfective,b.dteMaturity)  
												AND r.intEnd >= DATEDIFF(DAY,r.dteEfective,b.dteMaturity)  
												AND i.txtTv LIKE 'M%'  
		    
                    END  
                           

                DELETE  
                    p  
                FROM  itblPonderadoFinal_BidAsk p  
                    INNER JOIN #tblTvPlazoCatalog t ON p.txtTV = t.txtTV  
                WHERE  
                    p.dteDate = @txtDate  
                    AND p.fStatus = @fMatFlag
                     AND P.txtType = @txtBlenderFlag  
                    
    
   
    
                INSERT  itblPonderadoFinal_BidAsk  
                        (   
                         dteDate  
                        ,txtTv  
                        ,intPlazo  
						,dblTasaFinal  
                        ,dblAmount  
                        ,fStatus
                        ,txtType  
                        )  
							SELECT DISTINCT  
								@txtDate  
							    ,txtTv  
								,intPlazo  
							    ,SUM(dblRate * dblAmount) / SUM(dblAmount)  
							    ,0  
							    ,@fMatFlag  
							   ,@txtBlenderFlag 
									FROM  
										#itblCorroPonderado  
										 GROUP BY  
										txtTv  
									   ,intPlazo  
											ORDER BY  
											intPlazo  
                            
                            
  
  ---- Ajusto la el nivel de los nodos con subasta  
    
  --              INSERT  #itblCorroPonderadoSubastas  
  --                      (   
  --                       txtTv  
  --                      ,intPlazo  
  --                      ,dblRate  
  --                      )  
  --                      SELECT  
  --                          s.txtTv  
		--				   ,s.intPlazo  
  --                         ,CASE WHEN ISNULL(SUM(h.dblAmount), 0) >= s.dblAmount  * .1  THEN ( SUM(h.dblRate * h.dblAmount)   / SUM(h.dblAmount) + s.dblRate ) / 2  
  --                          ELSE s.dblRate  END  
		--						FROM  
		--							#itblCorroPonderado s  
		--							LEFT OUTER JOIN itblPonderado_BidAsk h ( NOLOCK ) ON s.txtTv = h.txtTv  
		--															  AND s.intPlazo = h.intPlazo  
		--															  AND h.txtOperation LIKE 'H%'  
		--										  AND h.dteBeginHour >= '11:30'  
		--															  AND h.dteDate = @txtDate  
		--						WHERE  
		--							s.txtOperationType = 'S'  
		--							AND H.txtBlenderMatFlag = @txtBlenderFlag
		--							 AND H.txttype = @fMatFlag
		--			   GROUP BY  
		--							s.txtTv  
		--						   ,s.intPlazo  
		--						   ,s.dblAmount  
		--						   ,s.dblRate  
								   
								   

     
  --              UPDATE  
  --                  p  
  --              SET                       p.dblTasaFinal = s.dblRate  
  --              FROM  
  --                  #itblCorroPonderadoSubastas s  
  --                  INNER JOIN itblPonderadoFinal_BidAsk p ON s.txtTv = p.txtTv  
  -- AND s.intPlazo = p.intPlazo  
  --              WHERE  
  --                  p.dteDate = @txtDate  
  --                  AND p.fStatus = @fMatFlag
  --                  AND p.txtBlenderMatFlag = @txtBlenderFlag  
  
            END  
    /*
     
        SET ANSI_WARNINGS ON   
        SET NOCOUNT OFF  
  
    END  
  
 
*/  