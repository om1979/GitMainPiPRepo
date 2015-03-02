
    
    
alter  PROCEDURE [dbo].[sp_clsXamuOmeEquityMatrix];3    
 @txtDate AS CHAR(10),    
 @intBegScen AS INT = 500,    
 @intEndScen AS INT = 1    
 AS    
/*     
 Autor:   ????        
 Creacion:  ????    
 Descripcion: Para obtener los datos de la matriz omega de acciones    
    
 Modificado por: Csolorio    
 Modificacion: 20120217    
 Descripcion: Segmento la obtencion del universo instrumentos Spots    
*/     
 BEGIN    
    
 SET NOCOUNT ON    
    
 DECLARE @intScenW AS INT     
 DECLARE @intScen AS INT     
 DECLARE @txtSQL AS VARCHAR(8000)    
 DECLARE @txtSQLResults AS VARCHAR(8000)    
    
 -- creo la tabla de resultados ------------------------------------    
    
 CREATE TABLE #tblUniverse (      
  dteFecha DATETIME,    
  txtId1 CHAR(11),    
  txtTv VARCHAR(4),    
  txtIssuer VARCHAR(7),    
  txtSeries VARCHAR(6),    
  txtSerial VARCHAR(8),    
  dblValPrice FLOAT,    
  dblMarketPrice FLOAT,    
   PRIMARY KEY(txtId1)     
 )    
    
 -- obtengo los datos ------------------------------------    
    
 DECLARE @txtTable AS VARCHAR(50)    
 DECLARE @txtTableMemo AS VARCHAR(50)    
 DECLARE @intTable AS INT    
 DECLARE @intField AS INT    
 DECLARE @intTableBeg AS INT    
 DECLARE @intTableEnd AS INT    
 DECLARE @intNext AS INT    
    
 -- ids y precios de escenario teorico y de vector    
 -- los teoricos los puedo obtener de cualquier tabla    
 -- de matrices pues no cambian    
    
 INSERT INTO #tblUniverse (      
  dteFecha,    
  txtId1,    
  txtTv,    
  txtIssuer,    
  txtSeries,    
  txtSerial,    
  dblValPrice,    
  dblMarketPrice    
 )     
 SELECT     
  m.dteFecha,     
  i.txtId1,    
  RTRIM(i.txtTv),    
  RTRIM(i.txtEmisora),    
  RTRIM(i.txtSerie),    
  '0',    
  m.dblTeorico,     
  m.dblTeorico    
 FROM tblMatrizPreciosAcciones AS m (NOLOCK)    
 INNER JOIN PIPMXSQL.MxFixIncome.dbo.tblIds AS i (NOLOCK)    
 ON     
  m.txtId1 = i.txtId1    
 INNER JOIN PIPMXSQL.mxFixincome.dbo.tblTvCatalog AS c (NOLOCK)    
 ON    
  i.txtTv = c.txtTv    
 LEFT OUTER JOIN PIPMXSQL.mxFixincome.dbo.tblPricesDestinations AS pd (NOLOCK)    
 ON    
  m.txtId1 = pd.txtId1    
  AND pd.fRiskMatrix = 1    
 WHERE    
  m.dteFecha = @txtDate      
  AND m.txtItem = 'PAV'      
  AND m.dblTeorico <> -999    
  AND i.txtTv NOT LIKE '%SP'    
  AND 1 =     
   CASE    
    WHEN c.txtCNBVMarket = 'EC' AND pd.txtId1 IS NULL THEN 0    
    ELSE 1    
   END    
    
 INSERT INTO #tblUniverse (      
  dteFecha,    
  txtId1,    
  txtTv,    
  txtIssuer,    
  txtSeries,    
  txtSerial,    
  dblValPrice,    
  dblMarketPrice)    
    
 SELECT     
  m.dteFecha,     
  i.txtId1,    
  RTRIM(i.txtTv),    
  RTRIM(i.txtEmisora),    
  RTRIM(i.txtSerie),    
  '0',    
  m.dblTeorico,     
  m.dblTeorico    
 FROM #tblUniverse AS u (NOLOCK)    
 INNER JOIN PIPMXSQL.mxFixincome.dbo.tblIds AS i (NOLOCK)    
 ON    
  RTRIM(LTRIM(u.txtTv)) + 'SP' = i.txtTv    
  AND u.txtIssuer = i.txtEmisora    
  AND u.txtSeries = i.txtSerie    
 INNER JOIN tblMatrizPreciosAcciones AS m (NOLOCK)    
 ON    
  i.txtId1 = m.txtId1    
 WHERE     
  m.dteFecha = @txtDate      
  AND m.txtItem = 'PAV'      
  AND m.dblTeorico <> -999    
    
 -- elimino los instrumentos que no esten en todas las matrices    
 -- precios de escenarios    
 SET @intScenW = @intBegScen     
 SET @intScen = 1    
 SET @txtSQL = ''    
 SET @txtTableMemo = ''    
 WHILE @intScenW >= @intEndScen    
 BEGIN    
      
  -- identifico la tabla fuente    
  SET @intTable = ((@intScenW - 1) /500)    
  SET @intTableBeg = 500 * (@intTable + 1)    
  SET @intTableEnd = 500 * @intTable + 1    
      
  IF @intTableBeg = 500 AND @intTableEnd = 1    
   SET @txtTable =  'tblMatrizPreciosAcciones'    
  ELSE     
   SET @txtTable =  'tblMatrizPreciosAcciones_' + LTRIM(STR(@intTableBeg)) + '_' + LTRIM(STR(@intTableEnd))      
    
  -- si hay un cambio de tabla entonces ejecuto el query de verificacion    
  IF @txtTableMemo <> @txtTable    
  BEGIN    
       
   -- actualizo el paquete de campos    
   SET @txtSQL = (    
    ' DELETE r' +    
    ' FROM  ' +    
     ' #tblUniverse AS r' +    
    ' LEFT OUTER JOIN ' + @txtTable + ' AS m (NOLOCK)' +    
     ' ON ' +    
      ' r.txtId1 = m.txtId1' +    
      ' AND m.dteFecha = ''' + @txtDate + '''' +    
    ' WHERE' +    
     ' m.txtId1 IS NULL'         
    )    
   EXEC (@txtSQL)    
   SET @txtTableMemo = @txtTable    
    
  END    
    
  SET @intScenW = @intScenW - 1     
  SET @intScen = @intScen + 1    
    
 END    
    
 -- inicializo la tabla de resultados    
 CREATE TABLE #tblResults (    
  dteFecha DATETIME,    
  txtId1 CHAR(11),    
  txtTv VARCHAR(4),    
  txtIssuer VARCHAR(7),    
  txtSeries VARCHAR(6),    
  txtSerial VARCHAR(12)    
   PRIMARY KEY(txtId1)    
      
 )    
 INSERT INTO #tblResults (    
  dteFecha,    
  txtId1,    
  txtTv,    
  txtIssuer,    
  txtSeries,    
  txtSerial    
 )    
 SELECT    
  dteFecha,    
  txtId1,    
  txtTv,    
  txtIssuer,    
  txtSeries,    
  txtSerial    
 FROM #tblUniverse    
    
 -- precios de escenarios    
 SET @intScenW = @intBegScen     
 SET @intScen = 1    
 SET @intNext = 1    
 SET @intScen = 1    
 SET @txtSQL = ''    
 SET @txtTable = ''    
 WHILE @intScenW >= @intEndScen    
 BEGIN    
    
  -- identifico la tabla fuente    
  SET @intTable = ((@intScenW - 1) /500)    
  SET @intTableBeg = 500 * (@intTable + 1)    
  SET @intTableEnd = 500 * @intTable + 1    
  SET @intField = 500 - (@intScenW - (@intTable * 500)) + 1      
    
  IF @intTableBeg = 500 AND @intTableEnd = 1    
   SET @txtTable =  'tblMatrizPreciosAcciones'    
  ELSE     
   SET @txtTable =  'tblMatrizPreciosAcciones_' + LTRIM(STR(@intTableBeg)) + '_' + LTRIM(STR(@intTableEnd))    
    
  -- agrego campos a la tabla actual    
  SET @txtSQLResults = (    
   ' ALTER TABLE #tblResults ADD dblValue' + REPLACE(STR(@intScen, 3), ' ', '0') + ' FLOAT'    
  )    
  EXEC (@txtSQLResults)    
    
  -- genero el query    
  SET @txtSQL = @txtSQL + (    
   'dblValue' + REPLACE(STR(@intScen, 3), ' ', '0') +     
    ' =  m.dblValue' + REPLACE(STR(@intField, 3), ' ', '0') +     
     ' - m.dblTeorico,'     
  )    
    
  -- se terminaron los n chances    
  -- o hay cambio de tabla    
  -- o es el ultimo escenario    
  IF @intNext = 150 OR @intTable <> ((@intScenW - 2) /500) OR @intScenW = @intEndScen    
  BEGIN    
       
   -- actualizo el paquete de campos    
   SET @txtSQL = SUBSTRING(@txtSQL, 1, LEN(@txtSQL) - 1)    
   SET @txtSQL = (    
    ' UPDATE r' +    
    ' SET ' + @txtSQL +    
    ' FROM ' +    
     ' #tblResults AS r' +    
     ' INNER JOIN ' + @txtTable + ' AS m (NOLOCK)' +    
     ' ON ' +    
      ' r.txtId1 = m.txtId1' +    
      ' AND m.txtItem = ''PAV''' +    
      ' AND m.dteFecha = ''' + @txtDate + ''''    
    )    
   EXEC (@txtSQL)    
    
   -- reset    
   SET @intNext = 0    
   SET @txtSQL = ''    
  END    
    
  -- si hay un cambio de tabla y no estamos en el primer ciclo    
  -- entonces entrego el contenido      
  IF @intTable <> ((@intScenW - 2) /500) OR @intScenW = @intEndScen    
  BEGIN       
    
   -- completo tabla    
   EXEC(' ALTER TABLE #tblResults ADD dblValPrice FLOAT')    
   EXEC(' ALTER TABLE #tblResults ADD dblMarketPrice FLOAT')    
       
   EXEC(    
    ' UPDATE r' +    
    ' SET ' +    
     ' dblValPrice = u.dblValPrice,' +    
     ' dblMarketPrice = u.dblMarketPrice ' +     
    ' FROM  ' +    
     ' #tblUniverse AS u' +    
     ' INNER JOIN #tblResults AS r' +    
     ' ON u.txtId1 = r.txtId1'    
   )    
   SET NOCOUNT OFF    
      
   EXEC(    
    ' SELECT *' +    
    ' FROM #tblResults' +    
    ' ORDER BY ' +    
     ' txtTv,' +    
     ' txtIssuer,' +    
     ' txtSeries,' +    
     ' txtSerial'    
   )    
    
   SET NOCOUNT ON    
    
   -- elimino las columnas agregadas    
   -- esto para no superar la restriccion    
   -- de 8mil byes por renglon soportados    
   ALTER TABLE #tblResults DROP COLUMN dblValPrice    
   ALTER TABLE #tblResults DROP COLUMN dblMarketPrice     
    
   WHILE @intScen >= 1     
   BEGIN    
    
    SET @txtSQLResults = (    
     ' ALTER TABLE #tblResults DROP COLUMN dblValue' + REPLACE(STR(@intScen, 3), ' ', '0')    
    )    
    EXEC (@txtSQLResults)    
    SET @intScen = @intScen - 1    
    
   END    
   SET @intScen = 0    
    
  END    
    
  SET @intScenW = @intScenW - 1     
  SET @intScen = @intScen + 1    
  SET @intNext = @intNext + 1    
    
 END    
    
 SET NOCOUNT OFF    
    
 END    
  
      