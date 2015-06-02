  
  
select * from sys.procedures as A
inner join sys.syscomments as B
on a.object_id = b.id 
where b.text like '%tblAverageVector%' 

  
-- --------------------------------------------------------------------------------    
--  Autor:          JUNIOR    
--  Creacion:  2005.09.05    
-- Descripcion:    Procedimiento para la extraccion / estimacion    
--     de analiticos y su reporte hacia las tablas     
--     de analiticos diarios    
--  Modificado por: JATO    
--  Modificacion: 04:03 p.m. 2012-06-22    
--  Descripcion:    elimine el SET NOCOUNT OFF    
-- --------------------------------------------------------------------------------    
    
CREATE  PROCEDURE dbo.sp_createAndReportAnalytics    
 @txtProcDate AS VARCHAR (10),    
 @txtTvs AS VARCHAR (MAX),    
 @txtAnalytic AS VARCHAR (10),    
 @txtLastDate AS VARCHAR (10) = ''    
     
AS     
BEGIN    
    
 SET NOCOUNT ON    
    
 DECLARE @intI AS INTEGER    
 DECLARE @txtSuperTv AS VARCHAR(max)    
 DECLARE @txtTv AS VARCHAR(100)    
 DECLARE @txtSQL AS VARCHAR(max)    
 DECLARE @dteLastDay AS DATETIME    
    
 -- divido el string para obtener el tipo de valor    
 SELECT @txtTv = RTRIM(LTRIM(SUBSTRING(@txtTvs, 1, 3)))    
    
 -- creo una lista con los tipos de valor    
 SELECT @intI = 0    
 SELECT @txtSuperTv = ''    
 WHILE @txtTv <> ''    
 BEGIN    
    
  SET @txtSuperTv = @txtSuperTv + ',' + '''' + @txtTv + ''''    
  SELECT @intI = @intI + 1     
         SELECT @txtTv = RTRIM(LTRIM(SUBSTRING(@txtTvs, @intI * 4 + 1, 3)))    
    
    
 END    
     
 SELECT @txtSuperTv = SUBSTRING(@txtSuperTv, 2, LEN(@txtSuperTv))    
    
 -- defino el universo de instrumentos a tratar    
 -- unicamente aquellos para los que PiP genero precio    
 DELETE tblUni WHERE txtAnalytic = @txtAnalytic    
 SET @txtSQL = (    
  ' INSERT tblUni (' +    
   ' txtId1,' +    
   ' txtTv,' +    
   ' txtEmisora,' +    
   ' txtSerie,' +    
   ' txtAnalytic' +    
  ' )' +    
  ' SELECT DISTINCT' +    
   ' i.txtId1,' +    
   ' i.txtTv,' +    
   ' i.txtEmisora,' +    
   ' i.txtSerie, ' +    
   '''' +  RTRIM(@txtAnalytic) + ''' ' +    
  ' FROM' +    
   ' tmp_tblAnalyticsUni AS i (NOLOCK)' +    
  ' WHERE' +    
   ' i.txtTv IN ('+@txtSuperTv+') '    
 )    
 EXEC (@txtSQL)    
    
 -- devil    
 DECLARE @txtDate AS VARCHAR (10)    
 DECLARE @txtLiq AS CHAR(3)    
 DECLARE @txtLiqType AS CHAR(3)    
    
 -- indentifico la cantidad de liquidaciones    
 -- que requiere el analitico actual    
 SET @txtLiqType = (    
    
  SELECT     
   txtLiquidation    
  FROM tblItemsCatalog  (NOLOCK)    
  WHERE    
   txtItem = @txtAnalytic    
 )    
    
 -- obtengo los valores de las fechas liquidacion     
 IF @txtLiqType = 'UNI'    
 BEGIN    
    
 DECLARE crs_liquidations CURSOR FOR    
 SELECT     
  txtLiquidation,    
  CONVERT(CHAR(10), dteValuationValue, 112) AS txtDate    
 FROM tblLiquidationValues  (NOLOCK)    
 WHERE    
  txtLiquidation = 'MD'    
    
 END    
 ELSE IF @txtLiqType = 'FV'    
 BEGIN    
    
  DECLARE crs_liquidations CURSOR FOR    
  SELECT     
  txtLiquidation,    
  CONVERT(CHAR(10), dteValuationValue, 112) AS txtDate    
  FROM tblLiquidationValues  (NOLOCK)    
  ORDER BY     
  dteValuationValue,    
  txtLiquidation    
    
 END    
    
 OPEN crs_liquidations    
    
 FETCH NEXT FROM crs_liquidations     
 INTO @txtLiq, @txtDate    
    
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    
  -- depuro la tabla de resultados temporal    
  DELETE tblResults WHERE txtItem = @txtAnalytic    
    
  -- status    
  IF @txtAnalytic = 'SUS'    
  BEGIN    
      
   -- obtengo el status mas reciente    
   SELECT     
    s.txtId1,    
    c.txtDescription    
   INTO #tblSus    
   FROM     
    tblStatus AS s  (NOLOCK)    
     INNER JOIN tblStatusCatalog AS c  (NOLOCK)    
    ON     
     s.bytStatus = c.txtStatus    
    INNER JOIN tblUni AS u  (NOLOCK)    
    ON s.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
    WHERE    
    dteDate = (    
     SELECT MAX(dteDate)    
     FROM tblStatus  (NOLOCK)    
     WHERE    
      txtId1 = s.txtId1    
      AND dteDate <= @txtProcDate          
    )    
     
   -- reporto los resultados    
                 INSERT tblResults    
                 SELECT    
                    @txtDate,    
                     txtId1,    
                     @txtAnalytic,    
                     txtDescription    
                 FROM     
    #tblSus    
     
   -- agrego los demas instrumentos con Status 'activo'    
         INSERT tblResults    
   SELECT    
    @txtDate,    
    txtId1,    
    @txtAnalytic,    
    'Activo'    
   FROM    
    tblUni (NOLOCK)    
   WHERE    
    txtAnalytic = @txtAnalytic    
    AND txtId1 NOT IN    
    (    
       SELECT txtId1    
            FROM #tblSus    
    )    
     
  END    
    
  ELSE IF @txtAnalytic = 'DT_SPQ'    
   EXEC sp_analytic_dtspq;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'SPQ'    
  BEGIN    
     
   -- creo el contenerdor    
   if exists (     
    SELECT *     
    from dbo.sysobjects     
    where     
     id = object_id(N'[dbo].[tmp_tblSPQ]')     
     and OBJECTPROPERTY(id, N'IsUserTable') = 1    
    )    
    drop table [dbo].[tmp_tblSPQ]    
      
   CREATE TABLE [dbo].[tmp_tblSPQ] (    
    [txtId1] [varchar] (15) NOT NULL ,    
    [txtRate] [varchar] (10) NULL     
   )    
     
   -- creamos los buffers de insumos    
   EXEC sp_analytic_SPQ;1 @txtDate    
     
   -- reporto los resultados    
   EXEC sp_analytic_SPQ;2 @txtDate, @txtAnalytic    
     
  END     
    
  ELSE IF @txtAnalytic = 'DT_DPQ'    
   EXEC sp_analytic_dtdpq;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DPQ'    
  BEGIN    
     
   -- creo el contenerdor    
   if exists (     
    SELECT *     
    from dbo.sysobjects     
    where     
     id = object_id(N'[dbo].[tmp_tblDPQ]')     
     and OBJECTPROPERTY(id, N'IsUserTable') = 1    
    )    
    drop table [dbo].[tmp_tblDPQ]    
      
   CREATE TABLE [dbo].[tmp_tblDPQ] (    
    [txtId1] [varchar] (15) NOT NULL ,    
    [txtRate] [varchar] (10) NULL     
   )    
     
   -- creamos los buffers de insumos    
   EXEC sp_analytic_dpq;1 @txtDate    
     
   -- reporto los resultados    
   EXEC sp_analytic_dpq;2 @txtDate, @txtAnalytic    
     
  END     
    
  ELSE IF @txtAnalytic = 'DT_FIQ'    
  EXEC sp_analytic_dtfiq;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'FIQ'    
  BEGIN    
     
   -- creo el contenerdor    
   if exists (     
    SELECT *     
    from dbo.sysobjects     
    where     
     id = object_id(N'[dbo].[tmp_tblFIQ]')     
     and OBJECTPROPERTY(id, N'IsUserTable') = 1    
    )    
    drop table [dbo].[tmp_tblFIQ]    
      
   CREATE TABLE [dbo].[tmp_tblFIQ] (    
    [txtId1] [varchar] (15) NOT NULL ,    
    [txtRate] [varchar] (10) NULL     
   )    
     
   -- creamos los buffers de insumos    
   EXEC sp_analytic_FIQ;1 @txtDate    
     
   -- reporto los resultados    
   EXEC sp_analytic_FIQ;2 @txtDate, @txtAnalytic    
     
  END     
     
  ELSE IF @txtAnalytic = 'IRCSUBY'    
   EXEC sp_analytic_uda;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'VNA'    
   EXEC sp_analytic_vna;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MTD'    
  BEGIN    
     
   -- creo el contenerdor de MTD    
   if exists (     
    SELECT *     
    from dbo.sysobjects     
    where     
     id = object_id(N'[dbo].[tmp_tblMTD]')     
     and OBJECTPROPERTY(id, N'IsUserTable') = 1    
    )    
    drop table [dbo].[tmp_tblMTD]    
      
   CREATE TABLE [dbo].[tmp_tblMTD] (    
    [txtId1] [varchar] (15) NOT NULL ,    
    [dteDate] [datetime] NULL     
   )     
     
   -- creamos los buffers de insumos    
   EXEC sp_analytic_MTD;1 @txtDate    
     
   -- reporto los resultados    
   EXEC sp_analytic_MTD;2 @txtDate, @txtAnalytic    
     
  END     
     
  ELSE IF @txtAnalytic = 'NOM'    
   EXEC sp_analytic_nom;1 @txtDate, @txtAnalytic     
     
  ELSE IF @txtAnalytic = 'NEM'    
   EXEC sp_analytic_nem;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'LPD'     
   EXEC sp_analytic_lpd;1 @txtDate, @txtAnalytic     
     
  ELSE IF @txtAnalytic = 'LPV'    
   EXEC sp_analytic_lpv;1 @txtDate, @txtAnalytic     
     
  ELSE IF @txtAnalytic = 'MHP'    
   EXEC sp_analytic_mhp;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'IHP'    
   EXEC sp_analytic_ihp;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DMH'    
   EXEC sp_analytic_DMH;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DIH'    
   EXEC sp_analytic_DIH;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MYP'    
   EXEC sp_analytic_myp;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'IYP'    
   EXEC sp_analytic_iyp;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DMY'    
   EXEC sp_analytic_DMY;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DIY'    
   EXEC sp_analytic_DIY;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'AAA'    
   EXEC sp_analytic_AAA;1 @txtLastDate, @txtDate, @txtAnalytic     
    
  ELSE IF @txtAnalytic = 'DHP'    
   EXEC sp_analytic_dhp;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MMP'    
   EXEC sp_analytic_mmp;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MIH'    
   EXEC sp_analytic_MIH;1 @txtDate, @txtAnalytic     
     
  ELSE IF @txtAnalytic = 'MMH'    
   EXEC sp_analytic_MMH;1 @txtDate, @txtAnalytic     
     
  ELSE IF @txtAnalytic = 'MIP'    
   EXEC sp_analytic_mip;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MDY'    
   EXEC sp_analytic_mdy;1 @txtDate, @txtAnalytic     
     
  ELSE IF @txtAnalytic = 'DMI'    
   EXEC sp_analytic_DMI;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DMD'    
   EXEC sp_analytic_DMD;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'AAB'    
  BEGIN    
     
   -- reporto los resultados    
   INSERT tblResults    
   SELECT     
    @txtDate,    
    p.txtId1,    
    @txtAnalytic,    
    LTRIM(STR(MAX(p.dblValue), 11, 6))    
   FROM        
    tblPrices AS p (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON p.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
   WHERE     
    dteDate = @txtLastDate    
    AND txtItem IN ('PRL', 'PAV')    
    AND txtLiquidation IN ('MD', 'MP')    
   GROUP BY     
    p.txtId1    
     
  END     
     
  ELSE IF @txtAnalytic = 'DPC'    
   EXEC sp_analytic_dpc;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'WPC'    
   EXEC sp_analytic_wpc;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'TTM'    
   EXEC sp_analytic_ttm;1 @txtDate    
    
  ELSE IF @txtAnalytic = 'VOL'    
  BEGIN    
     
   -- calculo las volatilidades    
   -- las reporto hacia la tabla de resultados     
   INSERT tblResults    
   SELECT DISTINCT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,     
    'Hist Insuficiente'    
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN tmp_tblAllValues AS av (NOLOCK)    
    ON u.txtId1 = av.txtId1    
   WHERE    
    av.txtId1 IS NULL      
    AND u.txtAnalytic = @txtAnalytic    
   UNION    
   SELECT     
    @txtDate,    
    av.txtId1,    
    @txtAnalytic,    
    LTRIM(RTRIM(STR(    
     SQRT(SUM((dblX * dblX)*dblPond))*     
      1.644853 * 100,10,6)) + '%')    
   FROM     
    tblUni AS u (NOLOCK)    
    INNER JOIN tmp_tblAllValues AS av (NOLOCK)    
    ON u.txtId1 = av.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
   GROUP BY     
    av.txtId1    
     
  END     
     
  ELSE IF @txtAnalytic = 'VO2'    
  BEGIN    
     
   -- calculo las volatilidades    
   -- las reporto hacia la tabla de resultados     
   INSERT tblResults    
   SELECT DISTINCT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,     
    'Hist Insuficiente'    
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN tmp_tblAllValuesW AS av (NOLOCK)    
    ON u.txtId1 = av.txtId1    
   WHERE    
    av.txtId1 IS NULL      
    AND u.txtAnalytic = @txtAnalytic    
   UNION    
   SELECT     
    @txtDate,    
    av.txtId1,    
    @txtAnalytic,    
    LTRIM(RTRIM(STR(    
     SQRT(SUM((dblX * dblX)*dblPond))*     
      1.644853 * 100,10,6)) + '%')    
   FROM     
    tblUni AS u (NOLOCK)    
    INNER JOIN tmp_tblAllValuesW AS av (NOLOCK)    
    ON u.txtId1 = av.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
   GROUP BY     
    av.txtId1    
       END     
     
  ELSE IF @txtAnalytic = 'STD'    
  BEGIN    
     
   -- calculo las desviaciones    
   -- las reporto hacia la tabla de resultados     
   INSERT tblResults    
   SELECT DISTINCT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,     
    'Hist Insuficiente'    
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN tmp_tblAllValues AS av (NOLOCK)    
    ON u.txtId1 = av.txtId1    
   WHERE    
    av.txtId1 IS NULL      
    AND u.txtAnalytic = @txtAnalytic    
   UNION    
   SELECT     
    @txtDate,    
    av.txtId1,    
    @txtAnalytic,    
    LTRIM(RTRIM(STR(    
     SUM((dblX * dblX)*dblPond)*100,10,6)) + '%')    
   FROM     
    tblUni AS u (NOLOCK)    
    INNER JOIN tmp_tblAllValues AS av (NOLOCK)    
    ON u.txtId1 = av.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
   GROUP BY     
    av.txtId1    
     
  END     
     
  ELSE IF @txtAnalytic = 'TCR'    
   EXEC sp_analytic_tcr;1 @txtDate, @txtAnalytic    
     
  -- precio teorico del instrumento     
  -- por ahora reportamos el mismo precio 24H    
  -- calculado por PiP      
  ELSE IF @txtAnalytic = 'THP'    
  BEGIN    
     
   -- obtenemos los precios del vector    
   INSERT tblResults    
   SELECT DISTINCT     
    @txtDate,    
    p.txtId1,      
    @txtAnalytic,    
    LTRIM(STR(p.dblValue, 11, 6))    
   FROM     
    tblPrices AS p (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON p.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
    WHERE    
    dteDate = @txtDate    
    AND txtLiquidation IN ('MP', '24H')    
    AND txtItem IN ('PRS', 'PAV')      
     
  END    
     
  ELSE IF @txtAnalytic = 'VAR'    
   EXEC sp_analytic_var;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'FCR'    
   EXEC sp_analytic_fcr;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'PCR'    
   EXEC sp_analytic_pcr;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'BUR'    
   EXEC sp_analytic_bur;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DTC'    
   EXEC sp_analytic_dtc;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'OPP'    
  BEGIN    
     
     
   -- obtenemos los precios apertura    
   SELECT     
    e.txtId1,    
    e.dblPrice AS dblValue    
   INTO #tmp_tblOPP    
   FROM     
    tblEquityPrices AS e (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON e.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic      
   WHERE    
    e.txtOperationCode = 'A01'     
    AND e.dteDAte = @txtDate    
     
   -- agregamos los precios para los no operados    
   INSERT tblResults    
   SELECT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,    
    CASE     
     WHEN e.dblValue IS NULL THEN '-'    
     ELSE LTRIM(STR(e.dblValue, 5, 2))        
    END    
     
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN #tmp_tblOPP AS e (NOLOCK)    
    ON e.txtId1 = u.txtId1    
   WHERE    
    u.txtAnalytic = @txtAnalytic      
     
  END    
     
  ELSE IF @txtAnalytic = 'DMX'    
  BEGIN    
     
   -- obtenemos los precios maximos del dia    
   SELECT     
    e.txtId1,    
    e.dblMax AS dblValue    
   INTO #tmp_tblDMX    
   FROM     
    tblEquityPrices AS e (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON e.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic     
   WHERE    
    e.txtOperationCode = 'S01'     
    AND e.dteDAte = @txtDate    
    AND e.dteTime = (     
       
     SELECT MAX(dteTime)    
     FROM tblEquityPrices (NOLOCK)    
     WHERE    
      dteDate = e.dteDate    
      AND txtId1 = e.txtId1    
      AND txtOperationCode = e.txtOperationCode    
    )    
     
   -- agregamos los precios para los no operados    
   INSERT tblResults    
   SELECT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,    
    CASE     
     WHEN e.dblValue IS NULL THEN '-'    
     ELSE LTRIM(STR(e.dblValue, 5, 2))    
    END    
     
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN #tmp_tblDMX AS e    
    ON e.txtId1 = u.txtId1    
   WHERE    
    u.txtAnalytic = @txtAnalytic      
     
  END    
     
  ELSE IF @txtAnalytic = 'DMN'    
  BEGIN    
     
   -- obtenemos los precios minimos del dia    
   SELECT     
    e.txtId1,    
    e.dblMin AS dblValue    
   INTO #tmp_tblDMN    
   FROM     
    tblEquityPrices AS e (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON e.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic      
   WHERE    
    e.txtOperationCode = 'S01'     
    AND e.dteDAte = @txtDate    
    AND e.dteTime = (     
       
     SELECT MAX(dteTime)    
     FROM tblEquityPrices (NOLOCK)    
     WHERE    
      dteDate = e.dteDate    
      AND txtId1 = e.txtId1    
      AND txtOperationCode = e.txtOperationCode    
    )    
     
   -- agregamos los precios para los no operados    
   INSERT tblResults    
   SELECT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,    
    CASE     
     WHEN e.dblValue IS NULL THEN '-'    
     ELSE LTRIM(STR(e.dblValue, 5, 2))    
    END    
     
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN #tmp_tblDMN AS e    
    ON e.txtId1 = u.txtId1    
   WHERE    
    u.txtAnalytic = @txtAnalytic      
     
  END    
     
  ELSE IF @txtAnalytic = 'DVO'    
  BEGIN    
     
   -- obtenemos los precios minimos del dia    
   SELECT     
    e.txtId1,    
    e.dblAmount AS dblValue    
   INTO #tmp_tblDVO    
   FROM     
    tblEquityPrices AS e (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON e.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic      
   WHERE    
    e.txtOperationCode = 'S01'     
    AND e.dteDAte = @txtDate    
    AND e.dteTime = (     
       
     SELECT MAX(dteTime)    
     FROM tblEquityPrices (NOLOCK)    
     WHERE    
      dteDate = e.dteDate    
      AND txtId1 = e.txtId1    
      AND txtOperationCode = e.txtOperationCode    
    )    
     
   -- agregamos los precios para los no operados    
   INSERT tblResults    
   SELECT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,    
    CASE     
     WHEN e.dblValue IS NULL THEN '-'    
     ELSE LTRIM(STR(e.dblValue, 10, 0))    
    END    
     
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN #tmp_tblDVO AS e    
    ON e.txtId1 = u.txtId1    
   WHERE    
    u.txtAnalytic = @txtAnalytic      
     
  END    
     
  ELSE IF @txtAnalytic = 'PAG'    
  BEGIN    
     
   -- obtenemos los precios minimos del dia    
   SELECT     
    e.txtId1,    
    e.dblAverage AS dblValue    
   INTO #tmp_tblPAG    
   FROM     
    tblEquityPrices AS e (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON e.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic      
   WHERE    
    e.txtOperationCode = 'S01'     
    AND e.dteDAte = @txtDate    
    AND e.dteTime = (     
       
     SELECT MAX(dteTime)    
     FROM tblEquityPrices (NOLOCK)    
     WHERE    
      dteDate = e.dteDate    
      AND txtId1 = e.txtId1    
      AND txtOperationCode = e.txtOperationCode    
    )    
     
   -- agregamos los precios para los no operados    
   INSERT tblResults    
   SELECT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,    
    CASE     
     WHEN e.dblValue IS NULL THEN '-'    
     ELSE LTRIM(STR(e.dblValue, 5, 2))    
    END    
     
   FROM     
    tblUni AS u (NOLOCK)    
    LEFT OUTER JOIN #tmp_tblPAG AS e    
    ON e.txtId1 = u.txtId1    
   WHERE    
    u.txtAnalytic = @txtAnalytic     
     
  END    
     
  ELSE IF @txtAnalytic = 'SIZ'    
   EXEC sp_analytic_siz;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'SEC'    
   EXEC sp_analytic_sec;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'RAM'    
   EXEC sp_analytic_ram;1 @txtDate, @txtAnalytic    
    
     
  ELSE IF @txtAnalytic = 'STK'    
  BEGIN    
     
   INSERT tblResults    
   SELECT     
    @txtDate,    
    d.txtId1,    
    @txtAnalytic,    
    CASE    
     WHEN d.dblStrikePrice IS NULL THEN '0.00 MXN'    
     ELSE     
     
      CASE u.txtEmisora    
       WHEN 'CMX212E' THEN LTRIM(STR(d.dblStrikePrice, 10, 2)) + ' USD'    
       WHEN 'CMX412E' THEN LTRIM(STR(d.dblStrikePrice, 10, 2)) + ' USD'    
       ELSE LTRIM(STR(d.dblStrikePrice, 10, 2)) + ' MXP'    
      END     
    END          
     
   FROM     
    tblDerivatives AS d (NOLOCK)    
    INNER JOIN tblUni AS u (NOLOCK)    
    ON d.txtId1 = u.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
     
  END    
     
     
  ELSE IF @txtAnalytic = 'CTY'    
  BEGIN    
     
   INSERT tblResults    
   SELECT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,    
    CASE     
     WHEN UPPER(SUBSTRING(LTRIM(txtCouponRefRate), 1 ,3)) = 'FIX' THEN  'Tasa fija'    
     WHEN UPPER(SUBSTRING(LTRIM(txtCouponRefRate), 1 ,1)) = 'Y' THEN  'Tasa fija'    
     WHEN UPPER(SUBSTRING(LTRIM(txtCouponRefRate), 1 ,4)) = 'ZERO' THEN  'Cupon cero'    
     ELSE 'Tasa flotante'    
    END    
   FROM     
    tblUni AS u (NOLOCK)    
    INNER JOIN tblBonds AS b (NOLOCK)    
    ON u.txtId1 = b.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
   WHERE    
    txtCouponRefRate <> ''    
    AND NOT txtCouponRefRate IS NULL    
     
  END    
     
  ELSE IF @txtAnalytic = 'CRL'    
   EXEC sp_analytic_crl;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'LCR'    
   EXEC sp_analytic_lcr;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'NCR'    
   EXEC sp_analytic_ncr;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'BVL'    
  BEGIN    
     
   INSERT tblResults    
   SELECT     
    @txtDate,    
    u.txtId1,    
    @txtAnalytic,    
    LTRIM(STR(o.dblBookValue, 10, 6))    
        
   FROM     
    tblUni AS u (NOLOCK)    
    INNER JOIN tblEquityBookValue AS o (NOLOCK)    
    ON u.txtId1 = o.txtId1    
    AND u.txtAnalytic = @txtAnalytic    
    WHERE    
    o.dteDate = (    
     SELECT MAX(dteDate)     
     FROM tblEquityBookValue (NOLOCK)    
     WHERE    
      txtId1 = o.txtId1    
    )    
     
  END    
     
  ELSE IF @txtAnalytic = 'ISD'    
   EXEC sp_analytic_isd;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MOE'    
   EXEC sp_analytic_moe;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MOC'    
   EXEC sp_analytic_moc;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'FAM'    
   EXEC sp_analytic_FAM;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'TCT'    
   EXEC sp_analytic_tct;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'FAT'    
   EXEC sp_analytic_fat;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'PAT'    
   EXEC sp_analytic_pat;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DCR'    
   EXEC sp_analytic_dcr;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'NRD'    
   EXEC sp_analytic_nrd;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'LRD'    
   EXEC sp_analytic_lrd;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'FVR'    
   EXEC sp_analytic_fvr;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'MKT2'    
   EXEC sp_analytic_mkt2;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'SMKT'    
   EXEC sp_analytic_smkt;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'SPM'    
   EXEC sp_analytic_spm;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'AFO_SPR_UN'    
   EXEC sp_analytic_afo_spr_un;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DTM'    
   EXEC sp_analytic_dtm;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'LIQ'    
   EXEC sp_analytic_liq;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'ENG'    
   EXEC sp_analytic_eng;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'BAD'    
   EXEC sp_analytic_bad;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'EFD'    
   EXEC sp_analytic_efd;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'DEA'    
   EXEC sp_analytic_dea;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'ID2'    
   EXEC sp_analytic_ID2;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'ID3'    
   EXEC sp_analytic_ID3;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'ID4'    
   EXEC sp_analytic_ID4;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'CPF'    
   EXEC sp_analytic_cpf;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'RPF'    
   EXEC sp_analytic_rpf;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'OPI'    
   EXEC sp_analytic_opi;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'IRT'    
   EXEC sp_analytic_irt;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'TIT'    
   EXEC sp_analytic_tit;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'TIE'    
   EXEC sp_analytic_tie;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'CUR'    
   EXEC sp_analytic_cur;1 @txtDate, @txtAnalytic    
     
  ELSE IF @txtAnalytic = 'SERIAL'    
   EXEC sp_analytic_serial;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'PCC'    
   EXEC sp_analytic_pcc;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'RRI'    
   EXEC sp_analytic_rri;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'TRT'    
   EXEC sp_analytic_trt;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'LRV'    
   EXEC sp_analytic_lrv;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'OSP2'    
   EXEC sp_analytic_OSP2;1 @txtDate, @txtAnalytic    
       
  ELSE IF @txtAnalytic = 'YEAR'    
   EXEC sp_analytic_YEAR;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'DO'    
   EXEC sp_analytic_DO;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'SUE'    
   EXEC sp_analytic_SUE;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'SUB'    
   EXEC sp_analytic_SUB;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'CUR2'    
   EXEC sp_analytic_CUR2;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'RPP'    
   EXEC sp_analytic_RPP;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'PET'    
   EXEC sp_analytic_PET;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'OSP3'    
   EXEC sp_analytic_OSP3;1 @txtDate, @txtAnalytic    
      
  ELSE IF @txtAnalytic = 'FVR2'    
   EXEC sp_analytic_FVR2;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'PSPP'    
   EXEC sp_analytic_PSPP;1 @txtProcDate, @txtLiq, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'PSPA'    
   EXEC sp_analytic_PSPA;1 @txtProcDate, @txtLiq, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'PLPA'    
   EXEC sp_analytic_PLPA;1 @txtProcDate, @txtLiq, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'TAT'    
   EXEC sp_analytic_TAT;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'VCR'    
   EXEC sp_analytic_VCR;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'VRL'    
   EXEC sp_analytic_vrl;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'NAT'    
   EXEC sp_analytic_nat;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'TIO'    
   EXEC sp_analytic_tio;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'NTR'    
   EXEC sp_analytic_ntr;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'CPFA'    
   EXEC sp_analytic_cpfa;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'PRLR'    
   EXEC sp_analytic_PRLR;1 @txtProcDate, @txtLiq, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'RSK'    
   EXEC usp_analytic_RSK;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'RSK_PLZ'    
   EXEC usp_analytic_RSK_PLZ;1 @txtDate, @txtAnalytic    
    
  ELSE IF @txtAnalytic = 'RSK_ESC'    
   EXEC usp_analytic_RSK_ESC;1 @txtDate, @txtAnalytic    
    
  ELSE     
   EXEC sp_createAndReportAnalytics_Additional;1 @txtDate, @txtAnalytic, @txtLiq, @txtProcDate    
    
  -- cargo los datos en ...    
  -- la tabla diaria (tblDailyAnalytics)    
  -- (03:56 p.m. 2007-02-11) estos datos seran transferidos hacia la matriz     
  -- de analiticos (tmp_tblActualAnalytics) mediante triggers     
  IF @txtLiqType = 'UNI'    
   EXEC sp_analytics_report;1 @txtDate, @txtAnalytic, @txtLiq, 1    
  ELSE IF @txtLiqType = 'FV'    
   EXEC sp_analytics_report;1 @txtDate, @txtAnalytic, @txtLiq, 0    
    
  FETCH NEXT FROM crs_liquidations     
  INTO @txtLiq, @txtDate    
    
 END     
     
 CLOSE crs_liquidations    
 DEALLOCATE crs_liquidations    
     -- Depuracion Analitico de tblUni    
 DELETE tblUni WHERE txtAnalytic = @txtAnalytic    
    
 -- Depuracion Analitico de tblResults    
 DELETE tblResults WHERE txtItem = @txtAnalytic    
      
END 