  
---------- Para Generar Producto: PiP_Bonds_aaaammdd.xls  
--------CREATE PROCEDURE dbo.sp_productos_STATESTREET;3  
-------- @txtDate AS DATETIME  
  
-------- /*   
  
  
--------  v2.0 Lic. Rene Lopez Salinas (06:57 2009-06-26)  
--------  Modifico Modulo 3: Inclusión de los ítems: CUR y PRLR  
  
--------   Version 1.0    
     
--------    Procedimiento que genera el PRODUCTO PiP_Bonds_aaaammdd.xls  
--------      Creado por :  Lic. René López Salinas  
--------    Fecha: 12-Feb-2009  
  
-------- */  
  
--------AS   
--------BEGIN  
  
-------- SET NOCOUNT ON   
  
--------  SELECT   
--------   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],  
--------   ap.txtTv AS [Tipo Valor],  
--------   ap.txtEmisora AS [Emisora],  
--------   ap.txtSerie AS [Serie],  
--------   (CASE WHEN LEN(a1.txtId2) = 12 THEN a1.txtId2 ELSE '0' END) AS [ISIN],  
--------   ROUND(ap.dblPRL,6) AS [Precio Limpio MD],  
--------   ROUND(ap.dblPRS,6) AS [Precio Sucio MD],  
--------   ROUND(ap.dblCPD,6) AS [Intereses Devengados MD],  
--------   (CASE WHEN ap.dblYTM <> -999.0 THEN ap.dblYTM ELSE 0 END) AS [Rend a vto MD],  
--------   (CASE WHEN ap.dblLDR <> -999.0 THEN ap.dblLDR ELSE 0 END) AS [Sobretasa de Valuación MD],  
--------   (CASE WHEN txtCUR <> 'NA' AND txtCUR <> '-' THEN RTRIM(a1.txtCUR) ELSE '' END) AS [Moneda Emisión],  
   
   
--------   (CASE WHEN txtPRLR <> 'NA' AND txtCUR <> '-' THEN RTRIM(a1.txtPRLR) ELSE '' END) AS [Precio Limpio Relativo (expresado en porcentaje)]  
  
  
--------  FROM   
--------   MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
--------   INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
--------    ON a1.txtId1 = ap.txtId1  
--------     AND a1.txtLiquidation = (  
--------      CASE ap.txtLiquidation    
--------      WHEN 'MP' THEN 'MD'    
--------      ELSE ap.txtLiquidation    
--------      END  
--------      )  
--------  WHERE   
--------   ap.txtLiquidation IN ('MD', 'MP')  
--------   AND ap.txtTv IN ('2','2P','2U','3','3P','3U','41','4P','4U','6U','71','73','75','76','90','91','92','93','93SP',  
--------    '94','95','96','97','98','BI','CC','CP','D','D1','D1SP','D2','D2SP','D3','D3SP','D4','D4SP','D5','D5SP',  
--------    'D6','D6SP','D7','D7SP','D8','D8SP','F','FSP','G','I','IL','IP','IS','IT','J','JSP','JI','L','LD','LP',  
--------    'LS','LT','M','M0','M3','M5','M7','MC','MP','PI','Q','QSP','R','R1','R3','R3SP','RC','S','S0','S3','S5',  
--------    'SC','SP','XA')  
--------  ORDER by ap.txtTv,ap.txtEmisora,ap.txtSerie  
  
-------- SET NOCOUNT OFF   
  
--------END  
--------RETURN 0  


--------SELECT * FROM sys.procedures
--------WHERE name LIKE '%sp_analytic_PRLR%'


--------sp_helptext sp_analytic_PRLR


  
-------- ---------------------------------------------------------------------------  
--------  Autor:          JATO  
--------  Creacion:  2006.09.19  
--------  Descripcion:    para generar el analitico precio limpio relativo  
--------  Modificado por: JATO  
--------  Modificacion: 12:22 p.m. 2010-12-30  
--------  Descripcion:    refactorizacion y aplicacion de candados  
-------- ---------------------------------------------------------------------------  
  
------CREATE PROCEDURE dbo.sp_analytic_PRLR;1  
------ @txtDate AS CHAR (10),  
------ @txtLiq AS CHAR (3),  
------ @txtAnalytic AS CHAR(10)  
------AS  
------BEGIN  
  
------ SET NOCOUNT ON  
  
------ -- obtengo el universo y la moneda  
------ -- filtro los que no esten vigentes para eliminar  
------ -- instrumentos cuya valuacion sea cuestionable  
  
------ DECLARE  @tblIdsData TABLE (  
------  txtId1 CHAR(11),  
------  txtCurrency CHAR(4),  
------  dblVNA FLOAT  
------   PRIMARY KEY(txtId1)  
------ )  
------ INSERT INTO @tblIdsData (  
------  txtId1,  
------  txtCurrency  
------ )  
------ SELECT DISTINCT  
------  u.txtId1,  
------  CASE    
------  WHEN b.txtCurrency = 'USD' THEN 'UFXU'  
------  ELSE b.txtCurrency   
------  END AS txtCurrency  
  
------ FROM   
------  tblUni AS u (NOLOCK)  
------  INNER JOIN tblBonds AS b (NOLOCK)  
------  ON u.txtId1 = b.txtId1  
------  AND u.txtAnalytic = @txtAnalytic  
------ WHERE  
------  b.dteMaturity > @txtDate   
  
------ -- obtengo el universo monedas  
------ DECLARE @tblCurrencies TABLE (  
------  txtCurrency CHAR(4)  
------   PRIMARY KEY(txtCurrency)  
------ )  
------ INSERT INTO @tblCurrencies (  
------  txtCurrency  
------ )  
------ SELECT DISTINCT txtCurrency  
------ FROM @tblIdsData  
  
------ -- obtengo los valores x moneda  
------ DECLARE @tblCurrenciesValues TABLE (  
------  txtCurrency CHAR(4),  
------  dblValue FLOAT  
------   PRIMARY KEY(txtCurrency)  
------ )  
------ INSERT INTO  @tblCurrenciesValues (  
------  txtCurrency,  
------  dblValue  
------ )  
------ SELECT   
------  c.txtCurrency,  
------  CASE  
------  WHEN i.dblValue IS NULL THEN 1  
------  ELSE i.dblValue  
------  END  AS  dblValue  
------ FROM   
------  @tblCurrencies AS c  
------  LEFT OUTER JOIN tblIrc AS i (NOLOCK)  
------  ON   
------   c.txtCurrency = i.txtIrc  
------   AND i.dteDate = (  
------    SELECT MAX(dteDate)  
------    FROM tblIrc (NOLOCK)  
------    WHERE  
------     txtIrc = i.txtIrc  
------     AND dteDate <= @txtDate  
------   )  
  
------ -- obtengo valores nominales  
------ UPDATE i  
------ SET dblVNA = a.txtValue  
------ FROM   
------  @tblIdsData AS i  
------  INNER JOIN tblDailyAnalytics AS a (NOLOCK)  
------  ON   
------   i.txtId1 = a.txtId1  
------   AND a.txtItem = 'VNA'  
  
------ -- verifico los valores nominales  
------ DECLARE @txtId1 CHAR(11)  
------ DECLARE @txtResult VARCHAR(8000)  
  
------ SELECT TOP 1  
------  @txtId1 = txtId1  
------ FROM @tblIdsData  
------ WHERE  
------  dblVNA IS NULL  
------  OR dblVNA = 0  
   
------ IF NOT @txtId1 IS NULL   
------ BEGIN  
------  SET @txtResult = 'Instrumento con VNA erroneo: ' + @txtId1  
------  RAISERROR (@txtResult, 16, 1)  
------  RETURN -1  
------ END  
  
------ SET NOCOUNT OFF  
  
------ INSERT tblResults (  
------  dteDate,  
------  txtId1,  
------  txtItem,  
------  txtValue  
------ )  
------ SELECT DISTINCT  
------  @txtDate AS txtDate,  
------  i.txtId1,  
------  @txtAnalytic AS txtItem,  
------  LTRIM(STR((p.dblValue / cv.dblValue) / i.dblVNA * 100, 16, 6)) AS txtValue  
------ FROM   
------  @tblIdsData AS i  
------  INNER JOIN @tblCurrenciesValues AS cv  
------  ON i.txtCurrency = cv.txtCurrency  
------  INNER JOIN vw_prices_notes AS p (NOLOCK)  
------  ON   
------   i.txtId1 = p.txtId1  
------   AND p.txtItem = 'PRL'  
------   AND p.txtLiquidation = @txtLiq  
------ WHERE  
------  p.dteDate = @txtDate  
  
------END  




------SELECT * from mxprocesses..tblprocessconfiguration
------WHERE txtProcess = 'irc_acc_ext'


------SELECT * from mxprocesses..tblprocessconfiguration
------WHERE txtProcess = 'load_global_trac'



----helptextxmodulo 'usp_inputs_global_equity',5
------usp_inputs_global_equity;6


----"usp_inputs_global_equity;5 
  
----CREATE PROCEDURE dbo.usp_inputs_global_equity;6  
---- @txtDate CHAR(10),  
---- @txtSource CHAR(10)  
----AS  
----/*   
---- Autor:   Csolorio  
---- Creacion:  20110609  
---- Descripcion:    Carga los titulos de trackers internacionales en tblOutstanding  
  
---- Modificado por:   
---- Modificacion:   
---- Descripcion:      
----*/  
----BEGIN  
---- SET NOCOUNT ON  
  
---- CREATE TABLE #tblUniverse (  
----  txtId1 CHAR(11),  
----  dblOutstanding FLOAT  
----   PRIMARY KEY(txtId1)  
---- )   
  
---- CREATE TABLE #tblOutstandingLastDates(  
----  txtId1 CHAR(11),  
----  dteDate DATETIME  
----   PRIMARY KEY(txtId1))  
  
---- -- verico si existen instrumentos erroneos  
---- IF NOT EXISTS (  
----  SELECT *  
----  FROM tmp_tblInputsGlobalTracOutstanding AS d (NOLOCK)  
----  LEFT OUTER JOIN tblIDs  AS i (NOLOCK)  
----  ON   
----   d.txtIRC = i.txtEmisora   
----   AND i.txtTv IN ('1I')  
----  WHERE  
----   i.txtId1 IS NULL  
----   AND txtIrc NOT IN ('DEMT')  
---- )  
---- BEGIN  
  
----  -- identico los id1  
----  INSERT #tblUniverse (  
----   txtId1,  
----   dblOutstanding  
----  )  
----  SELECT DISTINCT   
----   i.txtId1,  
----   d.dblTitulo  
----  FROM tmp_tblInputsGlobalTracOutstanding AS d (NOLOCK)  
----  INNER JOIN tblIDs  AS i (NOLOCK)  
----  ON   
----   d.txtIRC = i.txtEmisora   
----  WHERE  
----   i.txtTv IN ('1I')  
    
----  UNION  
  
----  SELECT DISTINCT   
----   i.txtId1,  
----   d.dblTitulo  
----  FROM tmp_tblInputsGlobalTracOutstanding AS d (NOLOCK)  
----  INNER JOIN tblIrcCatalog  AS i (NOLOCK)  
----  ON   
----   d.txtIRC = i.txtIrc   
----  WHERE  
----   i.txtIrc IN ('DEMT')  
  
----  -- Obtengo los ultimos registros por intrumento  
  
----  INSERT #tblOutstandingLastDates(  
----   txtId1,  
----   dteDate)  
  
----  SELECT   
----   o.txtId1,  
----   MAX(o.dteDate)  
----  FROM  #tblUniverse a  
----  INNER JOIN tblOutsTanding o (NOLOCK)   
----  ON  
----   a.txtId1 = o.txtId1  
----  WHERE   
----   o.dteDate <= @txtDate  
----  GROUP BY   
----   o.txtId1  
     
----  -- Elimino lo que voy a insertar  
  
----  DELETE o  
----  FROM #tblUniverse u  
----  INNER JOIN tblOutsTanding o (NOLOCK)   
----  ON  
----   u.txtId1 = o.txtId1  
----   AND o.dteDate = @txtDate  
----  WHERE   
----   o.txtSource = @txtSource  
  
----  INSERT tblOutsTanding(  
----   txtId1,  
----   dteDate,  
----   dblOutstanding,  
----   txtSource)  
  
----  SELECT   
----   u.txtId1,  
----   @txtDate,  
----   u.dblOutstanding,  
----   @txtSource  
----  FROM  #tblUniverse u  
----  INNER JOIN #tblOutstandingLastDates d  
----  ON  
----   u.txtId1 = d.txtId1  
----  INNER JOIN tblOutsTanding o (NOLOCK)   
----  ON  
----   d.txtId1 = o.txtId1  
----   AND d.dteDate = o.dteDate  
----  WHERE   
----   o.dblOutsTanding != u.dblOutstanding  
----   AND u.dblOutstanding > 0  
  
---- END   
---- ELSE  
---- BEGIN  
----  RAISERROR('Hay instrumentos no registrados',18,2) WITH SETERROR  
----  RETURN -1  
---- END  
  
---- SET NOCOUNT OFF  
  
----END  


  
--CREATE PROCEDURE dbo.usp_inputs_global_equity;5  
-- @txtDate CHAR(10),  
-- @txtSource CHAR(10)  
--AS  
--/*   
-- Autor:   Csolorio  
-- Creacion:  20110609  
-- Descripcion:    Carga los precios de trackers internacionales en tblIrc  
  
-- Modificado por: Csolorio  
-- Modificacion: 20120321  
-- Descripcion:    Modifico para solo insertar solo registros del dia  
--*/  
--BEGIN  
  
-- SET NOCOUNT ON  
  
-- DECLARE @txtId  AS CHAR(50)  
  
-- SET @txtId = ''  
  
-- SELECT  
--  @txtId = RTRIM(LTRIM(t.txtIRC))  
-- FROM  tmp_tblInputsGlobalTrac t  
-- LEFT OUTER JOIN tblIrcCatalog c (NOLOCK)  
-- ON  
--  t.txtIrc = c.txtIrc  
-- WHERE   
--  c.txtIrc IS NULL     
  
-- IF @txtId = ''  
  
-- BEGIN  
  
--  DECLARE @dteDatetime AS DATETIME  
  
--  SET @dteDatetime = GETDATE()  
  
--  -- Si los registros son del dia  
  
--  IF CONVERT(DATETIME,CONVERT(VARCHAR(8), GETDATE(), 112)) = CONVERT(DATETIME,@txtDate)  
--  BEGIN  
   
--   -- Depuro   
    
--   EXEC sp_inputs_bloomberg;53 @dteDatetime,'BLOO_TRA'  
  
--   -- Inserto en tabla de insumos  
  
--   INSERT tmp_tblInputsStates  
--   SELECT  DISTINCT   
--    txtIRC,   
--    dblValue,   
--    @dteDatetime,  
--    'BLOO_TRA'      
--   FROM dbo.tmp_tblInputsGlobalTrac (NOLOCK)  
--   WHERE  
--    dblValue != -999  
  
--  END  
    
--  BEGIN TRANSACTION TRANS_Trac  
  
--   -- Elimino  
  
--   DELETE p  
--   FROM tmp_tblInputsGlobalTrac t  
--   INNER JOIN dbo.tblIrc p   
--   ON   
--    t.txtIrc = p.txtIrc  
--    AND t.dteDate = p.dteDate  
--   WHERE  
--    t.dblValue != -999  
--    AND t.dteDate = @txtDate  
  
--   -- Inserto registros nuevos  
  
--   INSERT dbo.tblIrc (  
--    txtIRC,   
--    dteDate,   
--    dblValue,   
--    dtetime)  
  
--   SELECT DISTINCT   
--    t.txtIRC,   
--    t.dteDate,  
--    CASE  
--     WHEN t.txtCrncy = 'GBp' AND ASCII(SUBSTRING(LTRIM(RTRIM(t.txtCrncy)), LEN(LTRIM(RTRIM(t.txtCrncy))),1)) = 112 THEN t.dblValue / 100  
--     ELSE t.dblValue  
--    END AS dblValue,  
--    CONVERT(DATETIME,CONVERT(CHAR(8),@dteDatetime,108)) AS dteTime  
--   FROM dbo.tmp_tblInputsGlobalTrac t (NOLOCK)  
--   WHERE     
--    t.dblValue != -999  
--    AND t.dteDate = @txtDate  
  
--   IF @@ERROR = 0  
    
--    COMMIT TRANSACTION TRANS_Trac    
--   ELSE  
--   BEGIN  
--    ROLLBACK TRANSACTION TRANS_Trac  
--    RAISERROR('Ocurrio un error al insertar los registros nuevos',18,2) WITH SETERROR  
--    RETURN -1  
--   END  
-- END  
  
-- ELSE  
   
--  RAISERROR('El instrumento %s no existe en los catalogos, favor de revisar la fuente de información',18,2,@txtId) WITH SETERROR  
   
-- SET NOCOUNT OFF  
--END  
  
  
--  SELECT * FROM  dbo.tblIrc 
--  WHERE txtIRC = 'sco'
--  AND dteDate = '20140828'
--  tmp_tblInputsGlobalTrac
--  SELECT * FROM  tmp_tblInputsGlobalTrac
--  WHERE txtIRC = 'sco'
  
  
--  SELECT * FROM  dbo.tblIrcCatalog
--  WHERE txtIrc = 'GBp'
  
  
--  sp_clsEquityPricing;10
  
--  helptextXmodulo 'sp_clsEquityPricing',10


  
-- ---------------------------------------------------------------------------  
--  Autor:          ??  
--  Creacion:  ??  
--  Descripcion:    para valuar trackers internacionales  
--  Modificado por: JATO  
--  Modificacion: 08:29 a.m. 2011-03-18  
-- Descripcion:    ya no utilizamos el flag FVP para distribuir hacia vector  
-- ---------------------------------------------------------------------------  
  
--CREATE PROCEDURE dbo.sp_clsEquityPricing;10  
 DECLARE @txtDate CHAR(10)  = '20140828'
--AS  
--BEGIN  
  
 SET NOCOUNT ON  
  
 -- creo tablas para agilizar consulta  
 DECLARE @tblUni TABLE  (  
  txtId1 CHAR(11),   
  txtIrc CHAR(7)  
   PRIMARY KEY (txtId1)  
 )  
  
 DECLARE @tblIrc TABLE  (  
  txtIrc CHAR(7),  
  dteDate DATETIME  
   PRIMARY KEY (txtIrc)  
 )  
  
 DECLARE @tblIdsAddCur TABLE  (  
  txtId1 CHAR(11),  
  dteDate DATETIME  
   PRIMARY KEY (txtId1)  
 )  
  
 -- resultados  
 DECLARE @tblPrices TABLE  (  
  txtId1 CHAR(11),  
  dblPrice FLOAT  
   PRIMARY KEY (txtId1)  
 )   
  
 -- defino el universo posible  
 INSERT INTO @tblUni (  
  txtId1,  
  txtIrc  
 )  
 SELECT   
  i.txtId1,  
  ic.txtIrc    
 FROM   
  dbo.tblIds AS i (NOLOCK)  
  INNER JOIN dbo.tblIrcCatalog AS ic (NOLOCK)  
  ON i.txtEmisora = ic.txtIrc  
  INNER JOIN dbo.tblValuationMap AS vm (NOLOCK)  
  ON   
   i.txtType = vm.txtType  
   AND i.txtSubType = vm.txtSubType  
  INNER JOIN dbo.tblPricesDestinations AS pd (NOLOCK)  
  ON i.txtId1 = pd.txtId1  
 WHERE  
  i.txtType = 'TRA'    -- trackers extranjeros  
  AND i.txtSubType = 'EXT'  -- trackers extranjeros  
  AND vm.fLoad = 1    -- familia activa  
  AND pd.fVPrices  = 1   -- flag de incorporacion activo  
  AND NOT i.txtTv LIKE '%SP'  -- que no sean spots  
  AND ic.txtIrc NOT IN ('DEM') -- aquellos que por alguna razon no pueden tener el irc igual a la emisora  
  and txtirc= 'sco'
 -- Aquellos que por alguna razon no pueden tener el irc igual a la emisora  
   
 UNION   
  
 SELECT   
  i.txtId1,  
  ic.txtIrc    
 FROM   
  tblIds AS i  
  INNER JOIN tblIrcCatalog AS ic (NOLOCK)  
  ON i.txtId1 = ic.txtId1  
  INNER JOIN tblValuationMap AS vm (NOLOCK)  
  ON      i.txtType = vm.txtType  
   AND i.txtSubType = vm.txtSubType  
  INNER JOIN dbo.tblPricesDestinations AS pd (NOLOCK)  
  ON i.txtId1 = pd.txtId1  
 WHERE  
  i.txtType = 'TRA'    -- trackers extranjeros  
  AND i.txtSubType = 'EXT'  -- trackers extranjeros    AND vm.fLoad = 1    -- familia activa  
  AND pd.fVPrices  = 1   -- flag de incorporacion activo  
  AND NOT i.txtTv LIKE '%SP'  -- que no sean spots  
  AND ic.txtIrc IN ('DEMT')  -- aquellos que por alguna razon no pueden tener el irc igual a la emisora  
  
 -- obtengo el codigo de moneda   
 INSERT INTO @tblIdsAddCur (  
  txtId1,  
  dteDate  
 )  
 SELECT   
  u.txtId1,  
  MAX(ia.dteDate)  
 FROM   
  @tblUni AS u  
  INNER JOIN tblIdsAdd AS ia (NOLOCK)  
  ON u.txtId1 = ia.txtId1  
 WHERE  
  ia.txtItem = 'CUR'    AND ia.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  u.txtId1   
   
 -- obtengo la fecha mas reciente para el precio  
 INSERT INTO @tblIRC (  
  txtIrc,  
  dteDate  
 )  
 SELECT   
  u.txtIrc,  
  MAX(i.dteDate)  
 FROM   
  @tblUni AS u  
  INNER JOIN tblIrc AS i (NOLOCK)  
  ON u.txtIrc = i.txtIrc  
 WHERE  
  i.dteDate < CAST(@txtDate AS DATETIME) + 1  
 GROUP BY   
  u.txtIrc  
  
 -- obtengo los precios en pesos  
 INSERT INTO @tblPrices (  
  txtId1,  
  dblPrice  
 )  
 SELECT  
  u.txtId1,  
  ir.dblValue * ir2.dblValue AS dblPrice  
 FROM   
  @tblUni AS u  
  INNER JOIN @tblIRC AS p  
  ON u.txtIrc = p.txtIrc  
  INNER JOIN @tblIdsAddCur AS c  
  ON u.txtId1 = c.txtId1  
  INNER JOIN tblIrc AS ir (NOLOCK)  
  ON   
   u.txtIrc = ir.txtIrc   
   AND ir.dteDate = p.dteDate  
  INNER JOIN tblIdsAdd AS ia (NOLOCK)  
  ON   
   u.txtId1 = ia.txtId1  
   AND ia.dteDate = c.dteDate  
   AND ia.txtItem = 'CUR'  
  INNER JOIN tblIrc AS ir2 (NOLOCK)  
  ON   
   ir2.txtIrc = (  
    CASE   
    WHEN ia.txtValue IN ('USD', 'DLL') THEN 'UFXU'  
    ELSE ia.txtValue  
    END  
   )  
   AND ir2.dteDate = @txtDate  
  
 --BEGIN TRAN  
  
  -- depuro los precios  
  --DELETE p2  
  --FROM   
  -- @tblPrices AS p  
  -- INNER JOIN tblPrices AS p2  
  -- ON   
  --  p.txtId1 = p2.txtId1  
  --  AND p2.dteDate = @txtDate  
   
  -- cargo los precios  
   --INSERT tblPrices   
  SELECT   
   @txtDate AS dteDate,  
   txtID1,  
   'MP' AS txtLiquidation,  
   'PAV' AS txtItem,  
   dblPrice AS dblValue,  
   1 AS intFlag  
  FROM @tblPrices  
  
 --COMMIT TRAN  
  
-- SET NOCOUNT OFF  
  
--END  




--UIRC0015937


SELECT *
FROM dbo.tblIrcCatalog
WHERE txtircname LIKE '%CETE%'

SELECT *
FROM dbo.tmp_tblUnifiedPricesReport
WHERE TXTTV = 'BI'
AND TXTLIQUIDATION = 'CET'

SELECT *
FROM dbo.tblIrc
WHERE TXTIRC IN ('C021',
'C028',
'C084',
'C091',
'C154',
'C168',
'C182',
'C329',
'C336',
'C357',
'C360',
'C364',
'CET001',
'CET007',
'CET028',
'CET060',
'CET091',
'CET182',
'CET270',
'CET364',
'CETETRC',
'G028',
'G091',
'G182',
'G364',
'IC001',
'IC007',
'IC014',
'IC028',
'IC060',
'IC091',
'IC182',
'IC278',
'IC364',
'IC3YR',
'IC4YR',
'IC5YR',
'IC728',
'ICI001',
'ICI028',
'ICI056',
'ICI091',
'ICI10YR',
'ICI12YR',
'ICI15YR',
'ICI17YR',
'ICI182',
'ICI20YR',
'ICI21YR',
'ICI270',
'ICI364',
'ICI3YR',
'ICI5YR',
'ICI728',
'ICI7YR',
'IEC030',
'IEC090',
'IEC182',
'IEC270',
'IEC360',
'SC028',
'SC091',
'SC182',
'SC361',
'SC364',
'W028',
'W091',
'W168',
'W182',
'W360',
'W364')
AND DTEDATE > '20140826'
ORDER BY dtedate


txtTv	txtEmisora	txtSerie	dblPRS
TR	CETES	364	3.02
TR	CETES	91	2.86
TR	CETES	182	2.96
TR	CETES	28	2.76

SELECT *
FROM TBL

