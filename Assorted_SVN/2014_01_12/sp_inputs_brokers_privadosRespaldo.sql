  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados]  
 @txtDate AS VARCHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Crea la tabla temporal de operaciones  
     de enlace privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20100823  
 Descripcion: Se agrega campo de consecutivo  
*/  
BEGIN  
  
 IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[tmp_tblEnlaceOperacionesPrv]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 DROP TABLE [dbo].[tmp_tblEnlaceOperacionesPrv]  
   
 CREATE TABLE [dbo].[tmp_tblEnlaceOperacionesPrv] (  
  [txtConsecutivo] [VARCHAR](5) NULL,  
  [txtFecha] [VARCHAR](12) NULL,  
  [txtHoraIni] [VARCHAR](10) NULL,  
  [txtHoraFin] [VARCHAR](10) NULL,  
  [txtOperacion] [VARCHAR](10) NULL,  
  [txtLinea] [varchar] (10) NULL ,  
  [txtMonto] [VARCHAR](10) NULL,  
  [txtTasa] [VARCHAR](10) NULL,  
  [txtInstrumento] [VARCHAR](50) NULL,  
  [txtPlazo] [VARCHAR](50) NULL,  
  [txtLiquidacion] [VARCHAR](20) NULL,  
  [txtRestriccion] [varchar] (50) NULL     
 ) ON [PRIMARY]  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];2  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10),  
 @txt96Date  AS CHAR(10) = NULL  
   
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga hechos y posturas de privados Enlace  
  
 Modificado por: CSOLORIO  
 Modificacion: 20111122  
 Descripcion:    Agrego casos especificos para la coincidencia en intrumentos sospechosos  
*/  
BEGIN  
  
 SET NOCOUNT ON  
    
  IF @txt96Date IS NULL   
   SET @txt96Date = CONVERT(VARCHAR(10), dbo.fun_NextTradingDate(@txt72Date,1,'MX'),112)  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 -- TV  
  
 SELECT  
  CONVERT(DATETIME,e.txtFecha) dteDate,  
  CONVERT(DATETIME,e.txtHoraIni) AS dteInicio,  
  CASE   
   WHEN e.txtHoraFin = '_' THEN '1900-01-01 14:00:00.000'  
   ELSE CONVERT(DATETIME,e.txtHoraFin)   
  END AS dteFin,  
  RTRIM(LTRIM(MxFixIncome.dbo.fun_Split(e.txtInstrumento,' ',6))) AS txtEmisora,  
  RTRIM(LTRIM(MxFixIncome.dbo.fun_Split(REPLACE(e.txtInstrumento,' ',''),' ',7))) AS txtSerie,  
  CASE   
   WHEN e.txtOperacion = 'B' THEN 'COMPRA'  
   WHEN e.txtOperacion = 'O' THEN 'VENTA'  
   WHEN e.txtOperacion IN ('T','H') THEN 'HECHO'  
  END AS txtOperacion,  
  CONVERT(FLOAT,e.txtMonto) * 1000000 AS dblMonto,  
  CONVERT(FLOAT,e.txtTasa) AS dblTasa,  
  CASE   
   WHEN CHARINDEX('-',e.txtPlazo) > 0 THEN CAST(SUBSTRING(e.txtPlazo,1,CHARINDEX('-',e.txtPlazo)-1) AS INT)  
   WHEN RTRIM(LTRIM(e.txtPlazo)) = 'null' THEN NULL  
   ELSE CAST(e.txtPlazo AS INT)  
  END AS intPlazo,  
  CASE   
   WHEN RTRIM(LTRIM(e.txtLiquidacion)) = '48' THEN CONVERT(DATETIME,@txt48Date)  
   WHEN RTRIM(LTRIM(e.txtLiquidacion)) = '24' THEN CONVERT(DATETIME,@txt24Date)  
   WHEN RTRIM(LTRIM(e.txtLiquidacion)) IN ('MD','1','null') THEN CONVERT(DATETIME,@txtMDDate)  
  END AS dteLiquidation,  
  e.txtLiquidacion,  
  e.txtInstrumento  
 INTO #tblUniverse  
 FROM tmp_tblEnlaceOperacionesPRV e  
 LEFT OUTER JOIN tmp_tblEnlaceOperacionesPRV o  
 ON  
  e.txtConsecutivo = o.txtConsecutivo  
  AND e.txtHoraFin != o.txtHoraFin  
 WHERE   
  CONVERT(DATETIME,e.txtFecha) = @txtMDDate  
  AND (e.txtHoraFin != '_'  
   OR (e.txtHoraFin = '_'  
    AND o.txtHoraFin IS NULL))  
  
 -- Inserto en tabla de instrumentos  
  
 -- Buenos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  AND u.txtEmisora NOT IN (  
   'BI','M','IRS','UD','LD','BSW','FX',  
   'IP','IS','Spread','UL','UT','TP',  
   'SWP','SIRS','FWD','D','')  
  AND ISNUMERIC(u.txtEmisora) = 0  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 -- Borro para integrar  
  
 DELETE   
 FROM itblMarketPositionsPrivates  
 WHERE   
  intIdBroker = 1  
  AND dteDate = @txtMDDate  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  1,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteFin,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR p.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 1  
  AND dteDate = @txtMDDate  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  @txtMDDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPLazo,  
  1 AS intIdBroker,  
  CASE  
   WHEN u.txtOperacion IN ('COMPRA','VENTA') THEN 'POSTURA'  
   ELSE u.txtOperacion  
  END AS txtOperacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 WHERE   
  p.txtFlag = 'MALO'  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];3  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblRematePosturasPrivados]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblRematePosturasPrivados]  
   
 CREATE TABLE [dbo].[tmp_tblRematePosturasPrivados] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtTv] [varchar] (20) NULL ,  
  [txtInstrumento] [varchar] (20) NULL ,  
  [txtSerie] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (20) NULL ,  
  [txtPlazoFin] [varchar] (20) NULL ,  
  [txtMovim] [varchar] (20) NULL ,  
  [txtLiquidacion] [varchar] (20) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtHoraIni] [varchar] (20) NULL ,  
  [txtHoraFin] [varchar] (20) NULL ,  
  [txtRestriccion] [varchar] (20) NULL ,  
  [txtOperacion] [varchar] (20) NULL ,  
  [txtProducto] [varchar] (50) NULL  
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];4  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10)  
  
AS   
  
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Carga las posturas de Remate Privados   
 Modificado por: JATO  
 Modificacion: 03:49 p.m. 2011-08-26  
 Descripcion:    agregue el campo tv para validar los faltantes  
*/  
  
BEGIN  
  
 SET NOCOUNT ON  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 UPDATE tmp_tblRematePosturasPrivados  
 SET txtHoraFin = '140000'  
 WHERE txtHoraFin = '0'  
  
 --- Tabla Temporal de hechos  
 SELECT   
  CONVERT(DATETIME,txtFecha) AS dteDate,  
  CONVERT(DATETIME,txtFecha) AS dteLiquidacion,  
  CAST(txtPlazoFin AS INT) AS intPlazo,  
  txtTv,  
  SUBSTRING(txtProducto,CHARINDEX(' ',txtProducto)+1,CHARINDEX(' ',txtProducto,CHARINDEX(' ',txtProducto)+1)-CHARINDEX(' ',txtProducto)) AS txtEmisora,  
  txtSerie,  
   txtLiquidacion,  
  CASE   
   WHEN RTRIM(txtOperacion) = 'CP' THEN 'COMPRA'  
   WHEN RTRIM(txtOperacion) = 'VT' THEN 'VENTA'  
  END AS txtOperacion,   
  (CAST(txtMonto AS FLOAT) * 1000000) AS dblMonto,   
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteInicio,  
  CASE WHEN LEN(txtHoraFin) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraFin,1,1) + ':' + SUBSTRING(txtHoraFin,2,2) + ':' + SUBSTRING(txtHoraFin,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraFin,1,2) + ':' + SUBSTRING(txtHoraFin,3,2) + ':' + SUBSTRING(txtHoraFin,5,2),108)  
  END AS dteFin,  
  txtProducto AS txtInstrumento  
 INTO #tblUniverse  
 FROM tmp_tblRematePosturasPrivados  
 WHERE   
  txtInstrumento IN ('Corporativo','Bancario')  
  AND txtProducto NOT LIKE '%8P%'  
  
 ------------------------------------------------------------------------  
  
 INSERT #tblInstrumentos  
  
 -- Buenos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 UNION  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv != '-' THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora != '-' THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie != '-' THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 != '-' THEN p.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
  AND i.txtTv NOT LIKE '%SP'  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
  AND p.dteDate = @txtMDDate  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 -- Borro para integrar  
  
 DELETE  
 FROM itblMarketPositionsPrivates  
 WHERE  
  dteDate = @txtMDDate  
  AND intIdBroker = 3 -- Remate  
  AND txtOperation IN ('VENTA','COMPRA')  
  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  3,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteFin,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 3  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'POSTURA'  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPLazo,  
  3 AS intIdBroker,  
  'POSTURA'  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  p.txtTv = i.txtTv  
  AND p.txtemisora = i.txtemisora  
  AND p.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];5  
 @txtDate AS VARCHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: para crear la tabla temporal de posturas de VAR  
  
 Modificado por: CSOLORIO  
 Modificacion: 20101018  
 Descripcion: Agrego el campo de restriccion  
*/  
  
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblVarPosturasPrivados]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblVarPosturasPrivados]  
   
 CREATE TABLE [dbo].[tmp_tblVarPosturasPrivados] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtTv] [varchar] (20) NULL ,  
  [txtInstrumento] [varchar] (20) NULL ,  
  [txtSerie] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (20) NULL ,  
  [txtPlazoFin] [varchar] (20) NULL ,  
  [txtLiquidacion] [varchar] (20) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtHoraIni] [varchar] (20) NULL ,  
  [txtHoraFin] [varchar] (20) NULL ,  
  [txtRestriccion] [varchar] (20) NULL ,  
  [txtOperacion] [varchar] (20) NULL,  
  [txtProducto] [varchar] (50) NULL  
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];6  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10)  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Carga las posturas de VAR Privados   
  
 Modificado por: CSOLORIO  
 Modificacion: 20110809  
 Descripcion:    Se modifica para tomar la serie de su propia columna  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
  
 UPDATE tmp_tblVarPosturasPrivados  
 SET txtHoraFin = '140000'  
 WHERE txtHoraFin = '000000'  
  
  
 --- Tabla Temporal de hechos  
 SELECT   
  CONVERT(DATETIME,txtFecha) AS dteDate,  
  CAST(txtPlazoIni AS INT) AS intPlazo,  
  txtTv,  
  RTRIM(LTRIM(REPLACE(dbo.fun_Split(txtProducto,'',1),txtSerie,''))) AS txtEmisora,  
  txtSerie,  
   txtLiquidacion,   
  CASE   
  WHEN RTRIM(txtOperacion) = 'CP' THEN  
   'COMPRA'  
  WHEN RTRIM(txtOperacion) = 'VT' THEN  
   'VENTA'  
  END AS txtOperacion,   
  (CAST(txtMonto AS FLOAT) * 1000000) AS dblMonto,   
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteBeginHour,  
  CASE WHEN LEN(txtHoraFin) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraFin,1,1) + ':' + SUBSTRING(txtHoraFin,2,2) + ':' + SUBSTRING(txtHoraFin,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraFin,1,2) + ':' + SUBSTRING(txtHoraFin,3,2) + ':' + SUBSTRING(txtHoraFin,5,2),108)  
  END AS dteEndHour,  
  CASE  
   WHEN txtLiquidacion = 'MD' THEN @txtMDDate  
   WHEN txtLiquidacion = '24' THEN @txt24Date  
   WHEN txtLiquidacion = '48' THEN @txt48Date  
   WHEN txtLiquidacion = '72' THEN @txt72Date  
  END AS dteLiquidation,  
  
  txtProducto AS txtInstrumento  
 INTO #tmp_tblVARPosturas  
 FROM tmp_tblVarPosturasPrivados  
 WHERE txtInstrumento IN ('Corporativo','Bancario')   
  
 -- Inserto en tabla de instrumentos  
  
 -- Buenos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tmp_tblVARPosturas u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtTv = i.txtTv  
  AND u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND b.dteMaturity > @txtMDDate  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tmp_tblVARPosturas u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtTv = i.txtTv  
  AND u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND b.dteMaturity > @txtMDDate  
  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
  AND p.intIdBroker = 7  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
   
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsPrivates  
 WHERE  
  dteDate = @txtMDDate  
  AND intIdBroker = 7  
  AND txtOperation IN ('COMPRA','VENTA')  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  7,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteBeginHour,  
  u.dteEndHour,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tmp_tblVARPosturas u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtTv = i.txtTv  
  AND u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND b.dteMaturity > @txtMDDate  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
  
 -- Borro   
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 7  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'POSTURA'  
  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPLazo,  
  7 AS intIdBroker,  
  'POSTURA'  
 FROM #tblinstrumentos p  
 INNER JOIN #tmp_tblVARPosturas u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 WHERE   
  p.txtFlag = 'MALO'  
  
  
 SET NOCOUNT OFF  
  
END  
-- para crear la tabla temporal de HECHOS de REMATE  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];7  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblRemateHechosPrivados]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblRemateHechosPrivados]  
   
 CREATE TABLE [dbo].[tmp_tblRemateHechosPrivados] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtTv] [varchar] (20) NULL ,  
  [txtInstrumento] [varchar] (20) NULL ,  
  [txtSerie] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (20) NULL ,  
  [txtPlazoFin] [varchar] (20) NULL ,  
  [txtLiquidacion] [varchar] (20) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtHoraIni] [varchar] (20) NULL,  
  [txtProducto] [varchar] (50) NULL  
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];8  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Carga los hechos de Remate Privados   
 Modificado por: JATO  
 Modificacion: 03:49 p.m. 2011-08-26  
 Descripcion:    agregue el campo tv para validar los faltantes  
*/  
BEGIN  
  
 SET NOCOUNT OFF  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 UPDATE tmp_tblRematePosturasPrivados  
 SET txtHoraFin = '140000'  
 WHERE txtHoraFin = '0'  
  
 --- Tabla Temporal de hechos  
 SELECT   
  CONVERT(DATETIME,txtFecha) AS dteDate,  
  CONVERT(DATETIME,txtFecha) AS dteLiquidacion,  
  CAST(txtPlazoFin AS INT) AS intPlazo,  
  txtTv,  
  SUBSTRING(txtProducto,CHARINDEX(' ',txtProducto)+1,CHARINDEX(' ',txtProducto,CHARINDEX(' ',txtProducto)+1)-CHARINDEX(' ',txtProducto)) AS txtEmisora,  
  txtSerie,  
   txtLiquidacion,  
  'HECHO' AS txtOperacion,   
  CAST(txtMonto AS FLOAT) AS dblMonto,   
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteInicio,  
  txtProducto AS txtInstrumento  
 INTO #tblUniverse  
 FROM tmp_tblRemateHechosPrivados  
 WHERE   
  txtInstrumento IN ('Corporativo','Bancario')  
  AND txtProducto NOT LIKE '%8P%'  
  
 INSERT #tblInstrumentos  
  
 -- Buenos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 UNION  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL THEN p.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
  AND i.txtTv NOT LIKE '%SP'  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 DELETE  
 FROM itblMarketPositionsPrivates  
 WHERE  
  dteDate = @txtMDDate  
  AND intIdBroker = 3 -- Remate  
  AND txtOperation IN ('HECHO')  
  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  3,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteInicio,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro   
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 3  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'Hecho'  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPLazo,  
  3 AS intIdBroker,  
  'HECHO'  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  p.txtTv = i.txtTv  
  AND p.txtemisora = i.txtemisora  
  AND p.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];9  
 @txtDate AS VARCHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: para crear la tabla temporal de Hechos de VAR  
  
 Modificado por: CSOLORIO  
 Modificacion: 20101018  
 Descripcion: Agrego el campo de restriccion  
*/  
  
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblVarHechosPrivados]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblVarHechosPrivados]  
   
   
 CREATE TABLE [dbo].[tmp_tblVarHechosPrivados] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtTv] [varchar] (20) NULL ,  
  [txtInstrumento] [varchar] (20) NULL ,  
  [txtSerie] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (20) NULL ,  
  [txtPlazoFin] [varchar] (20) NULL ,  
  [txtLiquidacion] [varchar] (20) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtHoraIni] [varchar] (20) NULL,  
  [txtRestriccion] [varchar] (20) NULL ,  
  [txtProducto] [varchar] (50) NULL  
 ) ON [PRIMARY]  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];10  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Carga los hechos de VAR Privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110809  
 Descripcion:    Se modifica para tomar la serie de su propia columna  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 --- Tabla Temporal de hechos  
 SELECT   
  CONVERT(DATETIME,txtFecha) AS dteDate,  
  CAST(txtPlazoIni AS INT) AS intPlazo,  
  txtTv,  
  RTRIM(LTRIM(REPLACE(dbo.fun_Split(txtProducto,'',1),txtSerie,''))) AS txtEmisora,  
  txtSerie,  
   txtLiquidacion,   
  'HECHO' AS txtOperacion,   
  CAST(txtMonto AS FLOAT) AS dblMonto,   
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteBeginHour,  
  CASE  
   WHEN txtLiquidacion = 'MD' THEN @txtMDDate  
   WHEN txtLiquidacion = '24' THEN @txt24Date  
   WHEN txtLiquidacion = '48' THEN @txt48Date  
   WHEN txtLiquidacion = '72' THEN @txt72Date  
  END AS dteLiquidation,  
  
  
  txtProducto AS txtInstrumento  
 INTO #tmp_tblVARHechos  
 FROM tmp_tblVarHechosPrivados  
 WHERE txtInstrumento IN ('Corporativo','Bancario')  
  
  
 -- Inserto en tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 -- Buenos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tmp_tblVARHechos u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtTv = i.txtTv  
  AND u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND b.dteMaturity > @txtMDDate  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tmp_tblVARHechos u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtTv = i.txtTv  
  AND u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND b.dteMaturity > @txtMDDate  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
  AND p.intIdBroker = 7  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsPrivates  
 WHERE  
  dteDate = @txtMDDate  
  AND intIdBroker = 7  
  AND txtOperation IN ('HECHO')  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  7,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteBeginHour,  
  u.dteBeginHour,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tmp_tblVARHechos u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtTv = i.txtTv  
  AND u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND b.dteMaturity > @txtMDDate  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro   
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 7  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'HECHO'  
  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPLazo,  
  7 AS intIdBroker,  
  'HECHO'  
 FROM #tblinstrumentos p  
 INNER JOIN #tmp_tblVARHechos u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 WHERE   
  p.txtFlag = 'MALO'  
  
  
 SET NOCOUNT OFF  
  
END  
  
-- para crear la tabla temporal de SIF Posturas  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];11  
 @txtDate AS CHAR(10)  
AS   
BEGIN  
   
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblSifPosturasPrivados]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblSifPosturasPrivados]  
   
 CREATE TABLE [dbo].[tmp_tblSifPosturasPrivados] (  
  [txtFecha] [varchar] (50) NULL ,  
  [txtTTMIni] [varchar] (50) NULL ,  
  [txtTTMFin] [varchar] (50) NULL ,  
  [txtInstrumento] [varchar] (50) NULL ,  
  [txtLiq] [varchar] (50) NULL ,  
  [txtOp] [varchar] (50) NULL ,  
  [txtMonto] [varchar] (50) NULL ,  
  [txtTasa] [varchar] (50) NULL ,  
  [txtHoraIni] [varchar] (50) NULL ,  
  [txtHoraFin] [varchar] (50) NULL   
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];12  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10),  
 @txt96Date  AS CHAR(10) = NULL  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Carga las posturas de SIF Privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110322  
 Descripcion:    Se quietan instrumentos SP de la muestra y se integra por plazo  
   
*/  
BEGIN  
  
 SET @txt96Date = CONVERT(VARCHAR(10), dbo.fun_NextTradingDate(@txt72Date,1,'MX'),112)  
  
 SET NOCOUNT ON  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR(5))  
  
 --- Obtengo el Universo  
  SELECT  DISTINCT   
  CONVERT(DATETIME,txtFecha,111) AS dteDate,  
  CAST(txtTTMIni AS INT) AS intPlazo,  
  RTRIM(LTRIM(MxFixIncome.dbo.fun_Split(txtInstrumento,' ',1))) AS txtEmisora,  
  RTRIM(LTRIM(MxFixIncome.dbo.fun_Split(txtInstrumento,' ',2))) AS txtSerie,  
  txtLiq AS txtLiquidation,  
  CASE txtOp  
   WHEN 'CO' THEN 'COMPRA'  
   WHEN 'VE' THEN 'VENTA'  
  END AS txtOperacion,  
  CAST(txtMonto AS FLOAT) * 1000000 AS dblMonto,  
  CAST(txtTasa AS FLOAT) AS dblTasa,  
  CASE   
  WHEN LEN(txtHoraIni) = 6 THEN  
   CAST (  
    SUBSTRING(txtHoraIni, 1, 2) + ':' +  
    SUBSTRING(txtHoraIni, 3, 2) + ':' +  
    SUBSTRING(txtHoraIni, 5, 2) AS DATETIME)   
  WHEN LEN(txtHoraIni) = 5 THEN  
   CAST (  
    SUBSTRING(txtHoraIni, 1, 1) + ':' +  
    SUBSTRING(txtHoraIni, 2, 2) + ':' +  
    SUBSTRING(txtHoraIni, 4, 2) AS DATETIME)  
  WHEN LEN(txtHoraIni) = 1 THEN  
   CAST('14:00:00' AS DATETIME)  
  END AS dteBeginHour,  
   
  CASE   
  WHEN LEN(txtHoraFin) = 6 THEN  
   CAST (  
    SUBSTRING(txtHoraFin, 1, 2) + ':' +  
    SUBSTRING(txtHoraFin, 3, 2) + ':' +  
    SUBSTRING(txtHoraFin, 5, 2) AS DATETIME)   
  WHEN LEN(txtHoraFin) = 5 THEN  
   CAST (  
    SUBSTRING(txtHoraFin, 1, 1) + ':' +  
    SUBSTRING(txtHoraFin, 2, 2) + ':' +  
    SUBSTRING(txtHoraFin, 4, 2) AS DATETIME)   
  WHEN LEN(txtHoraFin) = 1 THEN  
   CAST('14:00:00' AS DATETIME)  
  END AS dteEndHour,  
  CASE  
   WHEN txtLiq = 'MD' THEN @txtMDDate  
   WHEN txtLiq = '24' THEN @txt24Date  
   WHEN txtLiq = '48' THEN @txt48Date  
   WHEN txtLiq = '72' THEN @txt72Date  
   WHEN txtLiq = '96' THEN @txt96Date  
  END AS dteLiquidation,  
  txtInstrumento  
  INTO #tblUniverse  
  FROM tmp_tblSifPosturasPrivados  
  
 -- Inserto en tabla de instrumentos  
  
 -- Buenos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
  AND p.intIdBroker = 4  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
   
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsPrivates  
 WHERE  
  dteDate = @txtMDDate  
  AND intIdBroker = 4  
  AND txtOperation IN ('COMPRA', 'VENTA')  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  4,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteBeginHour,  
  CASE  
   WHEN u.dteEndHour = '1900-01-01 00:00:00.000' THEN '1900-01-01 14:00:00.000'  
   WHEN u.dteEndHour = '1900-01-01 23:59:59.000' THEN '1900-01-01 14:00:00.000'  
   ELSE u.dteEndHour  
  END AS dteEndHour,  
  u.txtLiquidation  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR p.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 4  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'POSTURA'  
  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  @txtMDDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPLazo,  
  4 AS intIdBroker,  
  'POSTURA'  
 FROM #tblinstrumentos p  
 WHERE p.txtFlag = 'MALO'  
  
 SET NOCOUNT OFF  
  
END  
  
-- para crear la tabla temporal de SIF Posturas  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];13  
 @txtDate AS CHAR(10)  
AS   
BEGIN  
   
 TRUNCATE TABLE tmp_tblSifHechosPrivados  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];14  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10),  
 @txt96Date  AS CHAR(10) = NULL  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Carga los Hechos de SIF Privados  
 Modificado por: JATO  
 Modificacion: 03:49 p.m. 2011-08-26  
 Descripcion:    agregue el campo tv para validar los faltantes  
*/  
  
BEGIN  
  
 SET NOCOUNT ON  
  
 IF @txt96Date IS NULL   
  SET @txt96Date = CONVERT(VARCHAR(10), dbo.fun_NextTradingDate(@txt72Date,1,'MX'),112)  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 --- Obtengo el Universo  
  SELECT  DISTINCT   
  CONVERT(DATETIME,txtFecha,111) AS dteDate,  
  CAST(txtTTMIni AS INT) AS intPlazo,  
  RTRIM(LTRIM(MxFixIncome.dbo.fun_Split(txtInstrumento,' ',1))) AS txtEmisora,  
  RTRIM(LTRIM(MxFixIncome.dbo.fun_Split(txtInstrumento,' ',2))) AS txtSerie,  
  txtLiq AS txtLiquidation,  
  'HECHO' AS txtOperacion,  
  CAST(txtMonto AS FLOAT) * 1000000 AS dblMonto,  
  CAST(txtTasa AS FLOAT) AS dblTasa,  
  CASE   
  WHEN LEN(txtHoraIni) = 6 THEN  
   CAST (  
    SUBSTRING(txtHoraIni, 1, 2) + ':' +  
    SUBSTRING(txtHoraIni, 3, 2) + ':' +  
    SUBSTRING(txtHoraIni, 5, 2) AS DATETIME)   
  WHEN LEN(txtHoraIni) = 5 THEN  
   CAST (  
    SUBSTRING(txtHoraIni, 1, 1) + ':' +  
    SUBSTRING(txtHoraIni, 2, 2) + ':' +  
    SUBSTRING(txtHoraIni, 4, 2) AS DATETIME)  
  WHEN LEN(txtHoraIni) = 1 THEN  
   CAST('14:00:00' AS DATETIME)  
  END AS dteBeginHour,  
   
  CASE   
  WHEN LEN(txtHoraFin) = 6 THEN  
   CAST (  
    SUBSTRING(txtHoraFin, 1, 2) + ':' +  
    SUBSTRING(txtHoraFin, 3, 2) + ':' +  
    SUBSTRING(txtHoraFin, 5, 2) AS DATETIME)   
  WHEN LEN(txtHoraFin) = 5 THEN  
   CAST (  
    SUBSTRING(txtHoraFin, 1, 1) + ':' +  
    SUBSTRING(txtHoraFin, 2, 2) + ':' +  
    SUBSTRING(txtHoraFin, 4, 2) AS DATETIME)   
  WHEN LEN(txtHoraFin) = 1 THEN  
   CAST('14:00:00' AS DATETIME)  
  END AS dteEndHour,  
  CASE  
   WHEN txtLiq = 'MD' THEN @txtMDDate  
   WHEN txtLiq = '24' THEN @txt24Date  
   WHEN txtLiq = '48' THEN @txt48Date  
   WHEN txtLiq = '72' THEN @txt72Date  
   WHEN txtLiq = '96' THEN @txt96Date  
     
  END AS dteLiquidation,  
  txtInstrumento  
  INTO #tblUniverse  
  FROM tmp_tblSifHechosPrivados  
  
 -- Inserto en tabla de instrumentos  
  
 -- Buenos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
  AND p.intIdBroker = 4  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
   
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsPrivates  
 WHERE  
  dteDate = @txtMDDate  
  AND intIdBroker = 4  
  AND txtOperation = 'HECHO'  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  4,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteBeginHour,  
  CASE  
   WHEN u.dteEndHour = '1900-01-01 00:00:00.000' THEN '1900-01-01 14:00:00.000'  
   WHEN u.dteEndHour = '1900-01-01 23:59:59.000' THEN '1900-01-01 14:00:00.000'  
   ELSE u.dteEndHour  
  END AS dteEndHour,  
  u.txtLiquidation  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR p.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 4  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'HECHO'  
  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPlazo,  
  4 AS intIdBroker,  
  'HECHO'  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  p.txtTV = i.txtTV  
  AND p.txtemisora = i.txtemisora  
  AND p.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR p.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  AND p.txtFlag = 'MALO'  
  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];15  
 @txtDate AS VARCHAR(10)  
  
AS   
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100820  
 Descripcion: Crea la tabla temporal de posturas de eurobrokers  
  
 Modificado por: Csolorio  
 Modificacion: 20110113  
 Descripcion:    Cambio nombre de la tabla  
*/  
  
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblEurobOperacionesPRV]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblEurobOperacionesPRV]  
   
   
 CREATE TABLE [dbo].[tmp_tblEurobOperacionesPRV] (  
  [txtDate] [varchar] (20) ,  
  [txtPlazo] [varchar] (50)  ,  
  [txtOperation] [varchar] (20)  ,  
  [txtRate] [varchar] (20) ,  
  [txtAmount] [varchar] (50) ,  
  [txtBeginHour] [varchar] (20)  ,  
  [txtEndHour] [varchar] (20)    
 ) ON [PRIMARY]  
  
  
END  
  
CREATE PROCEDURE dbo.sp_inputs_brokers_privados;16  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100816  
 Descripcion:    Para cargar hechos y posturas de eurobrokers Privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110614  
 Descripcion:    Se modifica carga de registros sospechosos  
*/  
  
  
BEGIN  
  
 SET NOCOUNT ON  
   
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR(5))  
  
 SELECT  
  CONVERT(DATETIME,txtDate) AS dteDate,  
  CAST(RTRIM(LTRIM(SUBSTRING(txtPlazo,LEN(RTRIM(LTRIM(txtPlazo)))-CHARINDEX(' ',REVERSE(RTRIM(LTRIM(txtPlazo))))+1, LEN(RTRIM(LTRIM(txtPlazo))))))AS INT) AS intPlazo,  
  REPLACE(LTRIM(RTRIM(SUBSTRING(txtPlazo,1,CHARINDEX(' ',txtPlazo)))),'*','') AS txtEmisora,  
  LTRIM(RTRIM(SUBSTRING(txtPlazo,LEN(LTRIM(RTRIM(SUBSTRING(txtPlazo,1,CHARINDEX(' ',txtPlazo)))))+ 1,LEN(RTRIM(LTRIM(txtPlazo)))-CHARINDEX(' ',REVERSE(RTRIM(LTRIM(txtPlazo))))-LEN(LTRIM(RTRIM(SUBSTRING(txtPlazo,1,CHARINDEX(' ',txtPlazo)))))+1))) AS txtSer
ie,  
  CASE   
   WHEN txtOperation = 'BID' THEN 'COMPRA'  
   WHEN txtOperation = 'BID_TRADE' THEN 'COMPRA'  
   WHEN txtOperation = 'BID_TRADED' THEN 'COMPRA'  
   WHEN txtOperation = 'OFFER' THEN 'VENTA'  
   WHEN txtOperation = 'OFFER_TRADE' THEN 'VENTA'  
   WHEN txtOperation = 'OFFER_TRADED' THEN 'VENTA'  
   WHEN txtOperation LIKE '%COMPLETE' THEN 'HECHO'  
   WHEN txtOperation LIKE '%ERROR' THEN 'ERROR'  
  END AS txtOperacion,  
  CAST(txtRate AS FLOAT) AS dblTasa,  
  CASE   
   WHEN CHARINDEX('A',txtAmount) > 0 THEN   
    CASE  
     WHEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('A',txtAmount)-1) AS FLOAT) >= 20 AND txtOperation NOT LIKE '%COMPLETE' THEN -999  
     ELSE CAST(SUBSTRING(txtAmount,1,CHARINDEX('A',txtAmount)-1) AS FLOAT) * 1000000  
    END  
   WHEN CHARINDEX('R',txtAmount) > 0 THEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('R',txtAmount)-1) AS FLOAT) * 1000000  
   WHEN CHARINDEX('+',txtAmount) > 0 THEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('+',txtAmount)-1) AS FLOAT) * 1000000  
   WHEN CHARINDEX('-',txtAmount) > 0 THEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('-',txtAmount)-1) AS FLOAT) * 1000000  
   WHEN CHARINDEX('P',txtAmount) > 0 THEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('P',txtAmount)-1) AS FLOAT) * 1000000  
   ELSE CAST(txtAmount AS FLOAT) * 1000000  
  END AS dblMonto,  
  txtBeginHour AS dteInicio,  
  CASE  
   WHEN txtEndHour = '00:00:00' THEN  '14:00:00'  
   ELSE txtEndHour   
  END AS dteFin,  
  txtPlazo AS txtInstrumento,  
  CASE  
   WHEN CHARINDEX('A',txtAmount) > 0 THEN 'A'  
   WHEN CHARINDEX('R',txtAmount) > 0 THEN 'R'  
   WHEN CHARINDEX('+',txtAmount) > 0 THEN '+'  
   WHEN CHARINDEX('-',txtAmount) > 0 THEN '-'  
   WHEN CHARINDEX('P',txtAmount) > 0 THEN 'P'  
   ELSE ''  
  END AS txtRestriccion  
 INTO #tblUniverse  
 FROM tmp_tblEurobOperacionesPRV  
 WHERE   
  txtPlazo LIKE '*%'  
  AND txtPlazo NOT LIKE '% X %'  
  
 -- Inserto en tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 -- Buenos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 UNION  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 -- Integro  
  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteFin,  
  CASE  
   WHEN p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity) THEN '24'  
   WHEN p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity) THEN '48'   
   WHEN p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity) THEN '72'  
   WHEN p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity) THEN 'MD'  
  END AS txtLiquidacion  
 INTO #itblMarketPositions  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
  
 -- Identifico los registros con error  
  
 DELETE m  
 FROM #itblMarketPositions m  
 INNER JOIN #itblMarketPositions e  
 ON  
  m.txtTv = e.txtTv  
  AND m.txtEmisora = e.txtEmisora  
  AND m.txtSerie = e.txtSerie  
  AND m.dteFin = e.dteInicio  
 WHERE   
  e.txtOperacion = 'ERROR'  
  AND m.txtOperacion = 'HECHO'  
   
 -- Borro para integrar  
  
 DELETE   
 FROM itblMarketPositionsPrivates  
 WHERE   
  intIdBroker = 2  
  AND dteDate = @txtMDDate  
  
 -- Inserto  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT  
  dteDate,  
  2,  
  -999,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtOperacion,  
  dblTasa,  
  dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #itblMarketPositions  
 WHERE   
  txtOperacion != 'ERROR'  
  AND dblMonto IS NOT NULL  
     
    
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 2  
  AND dteDate = @txtMDDate  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  @txtMDDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPLazo,  
  2 AS intIdBroker,  
  CASE  
   WHEN u.txtOperacion IN ('COMPRA','VENTA') THEN 'POSTURA'  
   ELSE u.txtOperacion  
  END AS txtOperacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 WHERE   
  p.txtFlag = 'MALO'  
  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE dbo.sp_inputs_brokers_privados;17  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10),  
 @txt96Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100823  
 Descripcion:    Para cargar posturas de MEI Privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110805  
 Descripcion:    Modifico carga de instrumentos "Malos"  
*/  
  
BEGIN  
  
 SET NOCOUNT ON  
   
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 SELECT  
  CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteDate,  
  CAST(txtPlazo AS INT) AS intPlazo,  
  LTRIM(RTRIM(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))) AS txtEmisora,  
  CASE  
   WHEN CHARINDEX('@',txtInstrumento) > 0 THEN REPLACE(LTRIM(RTRIM(dbo.fun_Split(SUBSTRING(txtInstrumento,LEN(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))+2,LEN(txtInstrumento)),' ',1))),'@','')  
   WHEN CHARINDEX('*',txtInstrumento) > 0 THEN REPLACE(LTRIM(RTRIM(dbo.fun_Split(SUBSTRING(txtInstrumento,LEN(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))+2,LEN(txtInstrumento)),' ',1))),'*','')  
   ELSE LTRIM(RTRIM(dbo.fun_Split(SUBSTRING(txtInstrumento,LEN(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))+2,LEN(txtInstrumento)),' ',1)))  
  END AS txtSerie,  
  CASE  
   WHEN txtOperacion = 'Vendedor' THEN 'VENTA'  
   WHEN txtOperacion = 'Comprador' THEN 'COMPRA'  
  END AS txtOperacion,  
  txtLiquidacion,  
  CASE  
   WHEN txtLiquidacion = 'MD' THEN CONVERT(DATETIME,@txtMDDate)  
   WHEN txtLiquidacion = '24' THEN CONVERT(DATETIME,@txt24Date)  
   WHEN txtLiquidacion = '48' THEN CONVERT(DATETIME,@txt48Date)  
   WHEN txtLiquidacion = '72' THEN CONVERT(DATETIME,@txt72Date)  
   WHEN txtLiquidacion = '96' THEN CONVERT(DATETIME,@txt96Date)  
  END AS dteLiquidation,  
  CAST(txtTasa AS FLOAT) AS dblTasa,  
  CAST(txtMonto AS FLOAT) AS dblMonto,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHoraIni AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHoraIni AS FLOAT) AS DATETIME)) AS dteInicio,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHoraFin AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHoraFin AS FLOAT) AS DATETIME)) AS dteFin,  
  txtInstrumento,  
  CASE  
   WHEN CHARINDEX('@',txtInstrumento) > 0 THEN '@'  
   WHEN CHARINDEX('*',txtInstrumento) > 0 THEN '*'  
   ELSE ''  
  END AS txtRestriccion  
 INTO #tblUniverse  
 FROM tmp_tblMEIPosturasPRV  
 WHERE   
  txtInstrumento LIKE '%-%'  
  AND txtInstrumento NOT LIKE 'IP %'  
  AND txtInstrumento NOT LIKE 'BI %'  
  AND txtInstrumento NOT LIKE 'IT %'  
  AND txtInstrumento NOT LIKE 'IS %'  
  AND txtInstrumento NOT LIKE 'LD %'  
  
 INSERT #tblInstrumentos  
  
 -- Buenos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 UNION  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
  AND p.intIdBroker = 5  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 -- Borro para integrar  
  
 DELETE   
 FROM itblMarketPositionsPrivates  
 WHERE   
  intIdBroker = 5  
  AND dteDate = @txtMDDate  
  AND txtOperation IN ('COMPRA','VENTA')  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  5,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteFin,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR p.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 5  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'POSTURA'  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPlazo,  
  5 AS intIdBroker,  
  'POSTURA'  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 WHERE   
  p.txtFlag = 'MALO'  
  
 SET NOCOUNT OFF  
  
END  
  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];18  
 @txtDate  AS CHAR(10)  
AS   
  
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100824  
 Descripcion: Crea la tabla temporal de Hechos de MEI  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110309  
 Descripcion:    Cambio tabla temporal  
*/  
  
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblMEIHechosPRV]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblMEIHechosPRV]  
   
   
 CREATE TABLE [dbo].[tmp_tblMEIHechosPRV] (  
  [txtDate] [VARCHAR] (50),  
  [txtPlazo] [VARCHAR] (20),  
  [txtInstrumento] [VARCHAR] (50),  
  [txtLiquidacion] [VARCHAR] (20),  
  [txtOperacion] [VARCHAR] (25),  
  [txtMonto] [VARCHAR] (20),  
  [txtTasa] [VARCHAR] (20),  
  [txtHora] [VARCHAR] (50),  
  [txtRest] [VARCHAR] (3),  
 ) ON [PRIMARY]  
   
   
  
END  
  
  
CREATE PROCEDURE dbo.sp_inputs_brokers_privados;19  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10),  
 @txt96Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100823  
 Descripcion:    Para cargar hechos de MEI Privados  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110508  
 Descripcion:    Modifico carga de instrumentos "Malos"  
*/  
  
BEGIN  
  
 SET NOCOUNT ON  
   
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 SELECT  
  CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteDate,  
  CAST(txtPlazo AS INT) AS intPlazo,  
  LTRIM(RTRIM(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))) AS txtEmisora,  
  CASE  
   WHEN CHARINDEX('@',txtInstrumento) > 0 THEN REPLACE(LTRIM(RTRIM(dbo.fun_Split(SUBSTRING(txtInstrumento,LEN(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))+2,LEN(txtInstrumento)),' ',1))),'@','')  
   WHEN CHARINDEX('*',txtInstrumento) > 0 THEN REPLACE(LTRIM(RTRIM(dbo.fun_Split(SUBSTRING(txtInstrumento,LEN(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))+2,LEN(txtInstrumento)),' ',1))),'*','')  
   ELSE LTRIM(RTRIM(dbo.fun_Split(SUBSTRING(txtInstrumento,LEN(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',1),'-',1))+2,LEN(txtInstrumento)),' ',1)))  
  END AS txtSerie,  
  'HECHO' AS txtOperacion,  
  txtLiquidacion,  
  CASE  
   WHEN txtLiquidacion = 'MD' THEN CONVERT(DATETIME,@txtMDDate)  
   WHEN txtLiquidacion = '24' THEN CONVERT(DATETIME,@txt24Date)  
   WHEN txtLiquidacion = '48' THEN CONVERT(DATETIME,@txt48Date)  
   WHEN txtLiquidacion = '72' THEN CONVERT(DATETIME,@txt72Date)  
   WHEN txtLiquidacion = '96' THEN CONVERT(DATETIME,@txt96Date)  
  END AS dteLiquidation,  
  CAST(txtTasa AS FLOAT) AS dblTasa,  
  CAST(txtMonto AS FLOAT) AS dblMonto,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHora AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHora AS FLOAT) AS DATETIME)) AS dteInicio,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHora AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHora AS FLOAT) AS DATETIME)) AS dteFin,  
  txtInstrumento,  
  CASE  
   WHEN CHARINDEX('@',txtInstrumento) > 0 THEN '@'  
   WHEN CHARINDEX('*',txtInstrumento) > 0 THEN '*'  
   ELSE ''  
  END AS txtRestriccion  
 INTO #tblUniverse  
 FROM tmp_tblMEIHechosPRV  
 WHERE   
  txtInstrumento LIKE '%-%'  
  AND txtInstrumento NOT LIKE 'IP %'  
  AND txtInstrumento NOT LIKE 'BI %'  
  AND txtInstrumento NOT LIKE 'IT %'  
  AND txtInstrumento NOT LIKE 'IS %'  
  AND txtInstrumento NOT LIKE 'LD %'  
  
 INSERT #tblInstrumentos  
  
 -- Buenos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 UNION  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR u.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
  AND p.intIdBroker = 5  
 WHERE   
  ( i.txtid1 IS NULL  
   OR b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 -- Borro para integrar  
  
 DELETE   
 FROM itblMarketPositionsPrivates  
 WHERE   
  intIdBroker = 5  
  AND dteDate = @txtMDDate  
  AND txtOperation = 'HECHO'  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  5,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteFin,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity)  
   OR p.intPlazo = DATEDIFF(d,@txt96Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'   
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 5  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'HECHO'  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPlazo,  
  5 AS intIdBroker,  
  'HECHO'  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 WHERE   
  p.txtFlag = 'MALO'  
  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE [dbo].[sp_Inputs_Brokers_Privados];20  
 @txtDate AS CHAR(10)  
AS   
  
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100909  
 Descripcion:    Crea tabla temporal de posturas de Tradition  
  
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
  
BEGIN  
   
 IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[tmp_tblTraditionPosturasPrv]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 DROP TABLE [dbo].[tmp_tblTraditionPosturasPrv]  
   
 CREATE TABLE [dbo].[tmp_tblTraditionPosturasPrv] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (10) NULL ,  
  [txtPlazoFin] [varchar] (10) NULL ,  
  [txtInstrumento] [varchar] (20) NULL ,  
  [txtLiquidacion] [varchar] (10) NULL ,  
  [txtOperacion] [varchar] (10) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtInicio] [varchar] (20) NULL ,  
  [txtFin] [varchar] (20) NULL,  
  [txtCond] [varchar] (3) NULL  
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];21  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   Csolorio  
 Creacion:  20100909  
 Descripcion:    Posturas de privados Tradition  
 Modificado por: PONATE, Csolorio  
 Modificacion: 2012-07-05  
 Descripcion:    se agrega campo txtCond, para eliminar los que tengan * y el valor sea mayor a 20 (20 millones)  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 SELECT  
  CONVERT(DATETIME,dbo.fun_Split(txtFecha,'/',3)+dbo.fun_Split(txtFecha,'/',2)+dbo.fun_Split(txtFecha,'/',1),112) AS dteDate,  
  CAST(txtPlazoFin AS INT) AS intPlazo,  
  txtInstrumento,  
  dbo.fun_Split(txtInstrumento,' ',1)AS txtEmisora,  
  dbo.fun_Split(txtInstrumento,' ',2)AS txtSerie,  
  txtLiquidacion,  
  CASE  
   WHEN txtLiquidacion = 'MD' THEN @txtMDDate   
   WHEN txtLiquidacion = '24' THEN @txt24Date   
   WHEN txtLiquidacion = '48' THEN @txt48Date   
  END AS dteLiquidacion,  
  CASE  
   WHEN txtOperacion = 'VE' THEN 'VENTA'  
   WHEN txtOperacion = 'CO' THEN 'COMPRA'  
  END AS txtOperacion,  
  CONVERT(FLOAT, txtMonto) * 1000000 AS dblMonto,  
  CONVERT(FLOAT, txtTasa)AS dblTasa,  
  CONVERT(DATETIME,txtInicio) AS dteInicio,  
  CONVERT(DATETIME,txtFin) AS dteFin  
 INTO #tblUniverse  
 FROM tmp_tblTraditionPosturasPrv  
 WHERE  
  txtCond IS NULL   
  OR (txtCond = '*' AND CONVERT(FLOAT, txtMonto) < 20)  
  
 -- Buenos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 -- Borro para integrar  
  
 DELETE   
 FROM itblMarketPositionsPrivates  
 WHERE   
  intIdBroker = 6  
  AND dteDate = @txtMDDate  
  AND txtOperation IN ('COMPRA','VENTA')  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  6,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteFin,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 6  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'POSTURA'  
  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPlazo,  
  6 AS intIdBroker,  
  'POSTURA'  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  p.txtTV = i.txtTV  
  AND p.txtemisora = i.txtemisora  
  AND p.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 SET NOCOUNT OFF  
END  
  
  
CREATE PROCEDURE [dbo].[sp_Inputs_Brokers_Privados];22  
 @txtDate AS CHAR(10)  
AS   
  
/*   
 Autor:   Carlos Solorio  
 Creacion:  20100909  
 Descripcion:    Crea tabla temporal de hechos de Tradition  
  
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
  
BEGIN  
   
 IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[tmp_tblTraditionHechosPrv]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 DROP TABLE [dbo].[tmp_tblTraditionHechosPrv]  
   
 CREATE TABLE [dbo].[tmp_tblTraditionHechosPrv] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (10) NULL ,  
  [txtPlazoFin] [varchar] (10) NULL ,  
  [txtInstrumento] [varchar] (20) NULL ,  
  [txtLiquidacion] [varchar] (10) NULL ,  
  [txtOperacion] [varchar] (10) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtInicio] [varchar] (20) NULL ,  
  [txtFin] [varchar] (20) NULL   
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_privados];23  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10),  
 @txt72Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   Csolorio  
 Creacion:  20100909  
 Descripcion:    Hechos de privados Tradition  
 Modificado por: JATO  
 Modificacion: 03:49 p.m. 2011-08-26  
 Descripcion:    agregue el campo tv para validar los faltantes  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 CREATE TABLE #tblInstrumentos (  
  txtTv VARCHAR(10),  
  txtEmisora VARCHAR(10),  
  txtSerie VARCHAR(10),  
  intPlazo INT,  
  txtInstrumento VARCHAR(50),  
  txtFlag VARCHAR (5))  
  
 SELECT  
  CONVERT(DATETIME,dbo.fun_Split(txtFecha,'/',3)+dbo.fun_Split(txtFecha,'/',2)+dbo.fun_Split(txtFecha,'/',1),112) AS dteDate,  
  CAST(txtPlazoFin AS INT) AS intPlazo,  
  txtInstrumento,  
  dbo.fun_Split(txtInstrumento,' ',1)AS txtEmisora,  
  dbo.fun_Split(txtInstrumento,' ',2)AS txtSerie,  
  txtLiquidacion,  
  CASE  
   WHEN txtLiquidacion = 'MD' THEN @txtMDDate   
   WHEN txtLiquidacion = '24' THEN @txt24Date   
   WHEN txtLiquidacion = '48' THEN @txt48Date   
  END AS dteLiquidacion,  
  'HECHO' AS txtOperacion,  
  CONVERT(FLOAT, txtMonto) * 1000000 AS dblMonto,  
  CONVERT(FLOAT, txtTasa)AS dblTasa,  
  CONVERT(DATETIME,txtInicio) AS dteInicio,  
  CONVERT(DATETIME,txtFin) AS dteFin  
 INTO #tblUniverse  
 FROM tmp_tblTraditionHechosPrv  
  
  
 -- Buenos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.intPlazo,  
  u.txtInstrumento,  
  'BUENO'  
 FROM #tblUniverse u  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  u.txtEmisora = i.txtEmisora  
  AND u.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
  
 -- Malos  
 -- Verifico vs tabla de instrumentos  
  
 INSERT #tblInstrumentos  
  
 SELECT DISTINCT  
  CASE   
   WHEN p.txtTv IS NOT NULL THEN p.txtTv  
   ELSE i.txtTV  
  END AS txtTv,  
  CASE   
   WHEN p.txtEmisora IS NOT NULL THEN p.txtEmisora  
   ELSE i.txtEmisora  
  END AS txtEmisora,  
  CASE   
   WHEN p.txtSerie IS NOT NULL THEN p.txtSerie  
   ELSE i.txtSerie  
  END AS txtSerie,  
  CASE  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NOT NULL THEN p.intPlazo  
   WHEN i.txtId1 IS NOT NULL AND p.intPlazo IS NULL THEN u.intPlazo  
  END AS intPlazo,  
  u.txtInstrumento,  
  'MALO'  
 FROM #tblUniverse u  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  u.txtemisora = i.txtemisora  
  AND u.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (u.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR u.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 LEFT OUTER JOIN tmp_tblInstrumentosPRV p  
 ON  
  u.txtInstrumento = p.txtInstrumento  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 --  Quito los malos que hagan mach con un bueno  
  
 DELETE i2  
 FROM #tblInstrumentos i  
 INNER JOIN #tblInstrumentos i2  
 ON  
  i.txtInstrumento = i2.txtInstrumento  
 WHERE   
  i.txtFlag = 'BUENO'  
  AND i2.txtFlag = 'MALO'  
  
 -- Borro para integrar  
  
 DELETE   
 FROM itblMarketPositionsPrivates  
 WHERE   
  intIdBroker = 6  
  AND dteDate = @txtMDDate  
  AND txtOperation IN ('HECHO')  
  
 -- Inserto lo que hace mach  
  
 INSERT itblMarketPositionsPrivates(  
 dteDate,  
 intIdBroker,  
 intLine,  
 intPlazo,  
 txtTv,  
 txtEmisora,  
 txtSerie,  
 txtOperation,  
 dblRate,  
 dblAmount,  
 dteBeginHour,  
 dteEndHour,  
 txtLiquidation)  
  
 SELECT DISTINCT  
  u.dteDate,  
  6,  
  -999,  
  p.intPlazo,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  u.txtOperacion,  
  u.dblTasa,  
  u.dblMonto,  
  u.dteInicio,  
  u.dteFin,  
  u.txtLiquidacion  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
  AND p.intPlazo = u.intPlazo  
 INNER JOIN tblids i (NOLOCK)  
 ON   
  p.txtEmisora = i.txtEmisora  
  AND p.txtSerie = i.txtSerie  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE  
  i.txtTv NOT LIKE '%SP'  
  
 -- Borro solo lo que voy a integrar  
  
 DELETE   
 FROM tmp_tblInstrumentosPRV  
 WHERE  
  intIdBroker = 6  
  AND dteDate = @txtMDDate  
  AND txtOperacion = 'HECHO'  
 -- Inserto  
  
 INSERT tmp_tblInstrumentosPRV(  
  dteDate,  
  txtInstrumento,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  intidBroker,  
  txtOperacion)  
  
 SELECT DISTINCT  
  u.dteDate,  
  p.txtInstrumento,  
  CASE   
   WHEN p.txtTv IS NULL THEN '-'  
   ELSE p.txtTv   
  END AS txtTv,  
  CASE  
   WHEN p.txtEmisora IS NULL THEN '-'  
   ELSE p.txtEmisora  
  END AS txtEmisora,  
  CASE  
   WHEN p.txtSerie IS NULL THEN '-'  
   ELSE p.txtSerie   
  END AS txtSerie,  
  CASE  
   WHEN p.intPlazo IS NULL THEN 0  
   ELSE p.intPlazo  
  END AS intPlazo,  
  6 AS intIdBroker,  
  'HECHO'  
 FROM #tblinstrumentos p  
 INNER JOIN #tblUniverse u  
 ON   
  p.txtInstrumento = u.txtInstrumento  
 LEFT OUTER JOIN tblids i (NOLOCK)  
 ON   
  p.txtTV = i.txtTV  
  AND p.txtemisora = i.txtemisora  
  AND p.txtserie = i.txtserie  
 LEFT OUTER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
  AND (p.intPlazo = DATEDIFF(d,@txtMDDate,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt24Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt48Date,b.dteMaturity)   
   OR p.intPlazo = DATEDIFF(d,@txt72Date,b.dteMaturity))  
 WHERE   
  ( i.txtid1 IS NULL  
   OR  b.txtId1 IS NULL)  
  
 SET NOCOUNT OFF  
END  
  
CREATE PROCEDURE dbo.sp_inputs_brokers_privados;24  
 @txtDate AS CHAR(8)  
AS  
/*   
 Autor:   CSOLORIO   
 Creacion:  20111221  
 Descripcion: Carga la informacion de hechos de Indeval  
  
 Modificado por: Csolorio  
 Modificacion: 20130405  
 Descripcion: Agrego TV JE  
   
 Modificado por: Mike Ramirez  
 Modificacion: 20131127  
 Descripcion: Agrego TV CD  
*/     
BEGIN    
  
 SET NOCOUNT ON  
  
  
 CREATE TABLE #tblData (  
  txtId1 CHAR(11),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10),  
  intPlazo INT,  
  dblRate FLOAT,  
  dblAmount  FLOAT,  
  dteLiquidationDate DATETIME,  
  txtLiquidation CHAR(3),  
  dteHour DATETIME)  
  
-- CREATE TABLE #tblAmortizationsDates (  
--  txtId1 CHAR(11),  
--  dteDate DATETIME  
--   PRIMARY KEY (txtId1))  
--  
-- CREATE TABLE #tblFaceValue (  
--  txtId1 CHAR(11),  
--  txtCurrency CHAR(5),  
--  dblFaceValue FLOAT  
--   PRIMARY KEY (txtId1))  
--  
-- -- Obtengo las ultimas amortizaciones  
--  
-- INSERT #tblAmortizationsDates(  
--  txtId1,  
--  dteDate)  
--  
-- SELECT   
--  d.txtId1,  
--  MAX(a.dteAmortization)   
-- FROM #tblData d  
-- INNER JOIN tblAmortizations a (NOLOCK)  
-- ON  
--  d.txtId1 = a.txtid1  
--  AND a.dteAmortization <= '20111214'  
-- GROUP BY  
--  d.txtId1  
--  
-- -- Obtengo el valor nominal  
--  
-- INSERT #tblFaceValue(  
--  txtId1,  
--  txtCurrency,  
--  dblFaceValue)  
--  
-- SELECT DISTINCT  
--  d.txtId1,  
--  b.txtCurrency,  
--  CASE  
--   WHEN a.dblFactor IS NULL THEN b.dblFaceValue  
--   ELSE a.dblFactor  
--  END as dblFaceValue  
-- FROM #tblData d  
-- INNER JOIN tblBonds b (NOLOCK)  
-- ON  
--  d.txtId1 = b.txtId1  
-- LEFT OUTER JOIN #tblAmortizationsDates ad (NOLOCK)  
-- ON  
--  d.txtId1 = ad.txtId1  
-- LEFT OUTER JOIN tblAmortizations a (NOLOCK)  
-- ON  
--  d.txtId1 = a.txtId1  
--  AND ad.dteDate = a.dteAmortization  
--  
  
 INSERT #tblData(  
  txtId1,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  dblRate,  
  dblAmount,  
  dteLiquidationDate,  
  txtLiquidation,  
  dteHour)  
  
 SELECT DISTINCT  
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  DATEDIFF(d,CONVERT(DATETIME,r.txtLiquidation),b.dteMaturity),  
  CONVERT(FLOAT,r.txtPrice) AS dblRate,  
  CONVERT(FLOAT,r.txtAmount) AS dblAmount,  
  CONVERT(DATETIME,r.txtLiquidation) AS dteLiquidationDate,  
  CASE  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = @txtDate THEN 'MD'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,1,'MX') THEN '24'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,2,'MX') THEN '48'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,3,'MX') THEN '72'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN '96'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,5,'MX') THEN '120'  
     
  END AS txtLiquidation,  
  CONVERT(DATETIME,txtDTM) AS dteDateTime   
 FROM tmp_tblIndevalReference r  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  r.txtIsin = i.txtId2  
  AND i.txtTv NOT LIKE '%SP'  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
 WHERE  
  i.txtTv IN (  
   '2','2U','2P','90','91','92',   
   '93','94','95','97','98','D2',   
   'D7','D8','F','J','JI','Q','JE','CD')  
  AND r.txtMatch = 'CON_MATCH'  
  AND (  
   r.txtOrigin = 'CUENTA_PROPIA'  
   OR r.txtDestiny = 'CUENTA_PROPIA')  
  AND CONVERT(DATETIME,r.txtDate) = @txtDate  
  AND CONVERT(DATETIME,r.txtLiquidation) <= dbo.fun_NextTradingDate(@txtDate,4,'MX')  
  
 DELETE  
 FROM itblMarketPositionsPrivates  
 WHERE   
  dteDate = @txtDate  
  AND intIdBroker = 11   
  
 INSERT itblMarketPositionsPrivates(  
  dteDate,  
  intIdBroker,  
  intLine,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtOperation,  
  dblRate,  
  dblAmount,  
  dteBeginHour,  
  dteEndHour,  
  txtLiquidation)  
  
 SELECT DISTINCT  
  @txtDate,  
  11,  
  -999,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  'HECHO',  
  dblRate,      
  SUM(dblAmount),  
  dteHour,  
  dteHour,  
  txtLiquidation  
 FROM #tblData  
 GROUP BY  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  dblRate,      
  dteHour,  
  txtLiquidation  
  
 SET NOCOUNT OFF  
  
END  
  
  
  
CREATE PROCEDURE dbo.sp_inputs_brokers_privados;25  
 @txtDate AS CHAR(8)  
AS  
/*   
 Autor:   CSOLORIO   
 Creacion:  20111221  
 Descripcion: Carga la informacion de hechos de Indeval  
  
 Modificado por: Csolorio  
 Modificacion: 20130405  
 Descripcion: Agrego TV JE  
  
 Modificado por: Mike Ramirez  
 Modificacion: 20131127  
 Descripcion: Agrego TV CD  
  
*/     
BEGIN    
  
 SET NOCOUNT ON  
  
  
 CREATE TABLE #tblData (  
  txtId1 CHAR(11),  
  txtTv CHAR(10),  
  txtEmisora CHAR(10),  
  txtSerie CHAR(10),  
  intPlazo INT,  
  dblRate FLOAT,  
  dblAmount  FLOAT,  
  dteLiquidationDate DATETIME,  
  txtLiquidation CHAR(3),  
  dteHour DATETIME)  
  
 INSERT #tblData(  
  txtId1,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  intPlazo,  
  dblRate,  
  dblAmount,  
  dteLiquidationDate,  
  txtLiquidation,  
  dteHour)  
  
 SELECT DISTINCT  
  i.txtId1,  
  i.txtTv,  
  i.txtEmisora,  
  i.txtSerie,  
  DATEDIFF(d,CONVERT(DATETIME,r.txtLiquidation),b.dteMaturity),  
  CONVERT(FLOAT,r.txtPrice) AS dblRate,  
  CONVERT(FLOAT,r.txtAmount) AS dblAmount,  
  CONVERT(DATETIME,r.txtLiquidation) AS dteLiquidationDate,  
  CASE  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = @txtDate THEN 'MD'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,1,'MX') THEN '24'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,2,'MX') THEN '48'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,3,'MX') THEN '72'  
   WHEN CONVERT(DATETIME,r.txtLiquidation) = dbo.fun_NextTradingDate(@txtDate,4,'MX') THEN '96'  
  END AS txtLiquidation,  
  CONVERT(DATETIME,txtDTM) AS dteDateTime   
 FROM tmp_tblIndevalReferenceCierre r  
 INNER JOIN tblIds i (NOLOCK)  
 ON  
  r.txtIsin = i.txtId2  
  AND i.txtTv NOT LIKE '%SP'  
 INNER JOIN tblBonds b (NOLOCK)  
 ON  
  i.txtId1 = b.txtId1  
 WHERE  
  i.txtTv IN (  
   '2','2U','2P','90','91','92',   
   '93','94','95','97','98','D2',   
   'D7','D8','F','J','JI','Q','JE','CD')  
  AND r.txtMatch = 'CON_MATCH'  
  AND (  
   r.txtOrigin = 'CUENTA_PROPIA'  
   OR r.txtDestiny = 'CUENTA_PROPIA')  
  AND CONVERT(DATETIME,r.txtDate) = @txtDate  
  AND CONVERT(DATETIME,r.txtLiquidation) <= dbo.fun_NextTradingDate(@txtDate,4,'MX')  
  
 DELETE  
 FROM inv.itblMarketPositionsPrivates  
 WHERE   
  dteDate = @txtDate  
  
 INSERT inv.itblMarketPositionsPrivates(  
  dteDate,  
  intIdBroker,  
  intLine,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtOperation,  
  dblRate,  
  dblAmount,  
  dteBeginHour,  
  dteEndHour,  
  txtLiquidation)  
  
 SELECT DISTINCT  
  @txtDate,  
  11,  
  -999,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  'HECHO',  
  dblRate,      
  SUM(dblAmount),  
  dteHour,  
  dteHour,  
  txtLiquidation  
 FROM #tblData  
 GROUP BY  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  dblRate,      
  dteHour,  
  txtLiquidation  
  
 UNION  
  
 SELECT   
  dteDate,  
  intIdBroker,  
  intLine,  
  intPlazo,  
  txtTv,  
  txtEmisora,  
  txtSerie,  
  txtOperation,  
  dblRate,  
  dblAmount,  
  dteBeginHour,  
  dteEndHour,  
  txtLiquidation  
 FROM dbo.itblMarketPositionsPrivates (NOLOCK)  
 WHERE   
  dteDate = @txtDate  
  
 SET NOCOUNT OFF  
  
END  