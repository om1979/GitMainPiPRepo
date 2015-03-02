  
 /*  
  Creador: JATO   
  Fecha: 2009-04-15  
  Descripción: Carga informacion de archivos de brokers para la licuadora de revisables  
  
  Modificación: Salvador Sosa  
  Fecha Modificacion: 2010-05-21  
  Descripción Modificación: guarada nodos que cotizan en rango para identificarlos en el futuro    
 */  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables]  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblRematePosturasRevOnLine]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblRematePosturasRevOnLine]  
   
 CREATE TABLE [dbo].[tmp_tblRematePosturasRevOnLine] (  
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
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];2  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)   
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga las Posturas de Enlace  
  
 Modificado por: PONATE  
 Modificacion: 20120425  
 Descripcion:    Modifico para poder recibir Ipabonos  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 UPDATE tmp_tblRematePosturasRevOnLine  
 SET txtHoraFin = '140000'  
 WHERE CAST(txtHoraFin AS INT) = 0  
   
 --- Tabla Temporal de Posturas REMATE  
 SELECT CONVERT(DATETIME,txtFecha) AS dteFecha,  
  CONVERT(DATETIME,txtFecha) AS dteLiquidacion,  
  CAST(txtPlazoIni AS INT) AS intInicio,  
  CAST(txtPlazoFin AS INT) AS intFin,  
  txtTv,  
  txtInstrumento,  
  txtSerie,  
   txtLiquidacion,   
  3 AS intBroker,  
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
  END AS dteInicio,  
  CASE WHEN LEN(txtHoraFin) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraFin,1,1) + ':' + SUBSTRING(txtHoraFin,2,2) + ':' + SUBSTRING(txtHoraFin,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraFin,1,2) + ':' + SUBSTRING(txtHoraFin,3,2) + ':' + SUBSTRING(txtHoraFin,5,2),108)  
  END AS dteFin  
 INTO #tmp_tblRematePosturasRev  
 FROM tmp_tblRematePosturasRevOnLine  
 WHERE txtTv IN ('IP','IS','IT','LD','LS','BREM','IQ','IM')  
 AND  txtInstrumento NOT IN ('CETES')  
 AND TXTMOVIM  = 'CO'  
  
 UPDATE #tmp_tblRematePosturasRev SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'  
 UPDATE #tmp_tblRematePosturasRev SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'  
  
 ----- elimino los registros de la tabla  
 ----- destino pero solo los Tv LD  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 3 -- REMATE  
 AND  txtOperation IN ('COMPRA','VENTA')  
 AND txtTv in ('LD')  
  
  
 --- Insertamos en el destino  
 --- Solo Bondes LD  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  -999 AS intLinea,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dblMonto AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tmp_tblRematePosturasRev AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
 AND m.txtInstrumento IN ('Bonde LD')  
 AND  b.dteMaturity > @txtMDDate  
 AND m.txtLiquidacion IN ('48','MD')  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio    
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intInicio)  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intFin)  
  
 ----- elimino los registros de la tabla  
 ----- destino pero solo los Tv LD  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 3 -- REMATE  
 AND  txtOperation IN ('COMPRA','VENTA')  
 AND txtTv IN ('IP','IS','IT','LS','XA','IQ','IM')  
  
 --- Insertamos en el destino  
 --- Todos Excepto Bondes LD  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtTv,  
  txtOperacion,  
  dblTasa,  
  dblMonto AS dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #tmp_tblRematePosturasRev  
 WHERE txtTv IN ('LS','XA')  
 AND txtLiquidacion IN ('48')  
  
 UNION  
  
 -- Cotizaciones en especifico  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblRematePosturasRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio = m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intInicio   
  
 UNION  
  
 -- Cotizaciones en rango  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblRematePosturasRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
  
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 3 -- REMATE  
   AND txtOperation IN ('COMPRA','VENTA')  
   AND txtTv IN ('IP','IS','IT','IQ','IM')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion,  
   STR(m.intInicio) + ' - ' + STR(m.intFin)  
 FROM #tmp_tblRematePosturasRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
 SET NOCOUNT OFF  
  
END  
  
-- para crear la tabla temporal de Hechos de REMATE  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];3  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblRemateHechosRevOnLine]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblRemateHechosRevOnLine]  
   
 CREATE TABLE [dbo].[tmp_tblRemateHechosRevOnLine] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtTv] [varchar] (20) NULL ,  
  [txtInstrumento] [varchar] (20) NULL ,  
  [txtSerie] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (20) NULL ,  
  [txtPlazoFin] [varchar] (20) NULL ,  
  [txtLiquidacion] [varchar] (20) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtHoraIni] [varchar] (20) NULL  
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];4  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 --- Tabla Temporal de hechos  
 SELECT CONVERT(DATETIME,txtFecha) AS dteFecha,  
  CONVERT(DATETIME,txtFecha) AS dteLiquidacion,  
  CAST(txtPlazoIni AS INT) AS intInicio,  
  CAST(txtPlazoFin AS INT) AS intFin,  
  txtTv,  
  txtInstrumento,  
  txtSerie,  
   txtLiquidacion,   
  3 AS intBroker,  
  'HECHO' AS txtOperacion,   
  CAST(txtMonto AS FLOAT) AS dblMonto,  
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteInicio,  
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteFin  
 INTO #tmp_tblRemateHechosRev  
 FROM tmp_tblRemateHechosRevOnLine  
 WHERE txtTv IN ('IP','IS','IT','LD','LS','BREM','IM','IQ')  
 AND  txtInstrumento NOT IN ('CETES')  
  
 UPDATE #tmp_tblRemateHechosRev SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'  
 UPDATE #tmp_tblRemateHechosRev SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'  
   
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 3 -- Remate  
 AND  txtOperation IN ('HECHO')  
 AND txtTv in ('LD') -- solo Bondes  
   
 --- Insertamos en la tabla destino  
 --- Solo Bondes  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  -999 AS intLinea,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dblMonto AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tmp_tblRemateHechosRev AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
 AND m.txtInstrumento IN ('Bonde LD')  
 AND  b.dteMaturity > @txtMDDate  
 AND m.txtLiquidacion IN ('48','MD')  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio    
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intInicio)  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intFin)  
   
 --- Elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 3 -- Remate  
 AND  txtOperation IN ('HECHO')  
 AND txtTv IN ('IP','IS','IT','LS','XA','IM','IQ')  
  
 --- Insertamos en la tabla destino  
 --- Todo menos Bondes   
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtTv,  
  txtOperacion,  
  dblTasa,  
  dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #tmp_tblRemateHechosRev   
 WHERE txtTv IN ('LS','BREM')  
 AND txtLiquidacion IN ('48')  
   
 UNION  
   
 -- cotizaciones en especifico  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblRemateHechosRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio = m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intInicio      
  
 UNION  
   
 -- cotizaciones en rango  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblRemateHechosRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
   
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 3 -- REMATE  
   AND txtOperation IN ('HECHO')  
   AND txtTv IN ('IP','IS','IT','IM','IQ')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT   
   m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion,  
   STR(m.intInicio) + ' - ' + STR(m.intFin)  
 FROM #tmp_tblRemateHechosRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
  
 SET NOCOUNT OFF  
  
END  
  
-- para crear la tabla temporal de posturas de VAR  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];5  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblVarPosturasRevOnLine]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblVarPosturasRevOnLine]  
   
 CREATE TABLE [dbo].[tmp_tblVarPosturasRevOnLine] (  
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
  [txtProducto] [varchar](100) NULL  
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];6  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)   
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: -- Carga las posturas de revisables provenientes de VAR  
  
 Modificado por: PONATE  
 Modificacion: 20120425  
 Descripcion: Modifico para poder recibir ipabonos  
*/  
  
BEGIN  
  
 SET NOCOUNT ON  
  
 UPDATE tmp_tblVarPosturasRevOnLine  
 SET txtHoraFin = '140000'  
 WHERE CAST(txtHoraFin AS INT) = 0  
   
 --- Tabla Temporal de Posturas VAR  
 SELECT CONVERT(DATETIME,txtFecha) AS dteFecha,  
  CONVERT(DATETIME,txtFecha) AS dteLiquidacion,  
  CAST(txtPlazoIni AS INT) AS intInicio,  
  CAST(txtPlazoFin AS INT) AS intFin,  
  txtTv,  
  txtInstrumento,  
  txtSerie,  
   txtLiquidacion,   
  7 AS intBroker,  
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
  END AS dteInicio,  
  CASE WHEN LEN(txtHoraFin) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraFin,1,1) + ':' + SUBSTRING(txtHoraFin,2,2) + ':' + SUBSTRING(txtHoraFin,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraFin,1,2) + ':' + SUBSTRING(txtHoraFin,3,2) + ':' + SUBSTRING(txtHoraFin,5,2),108)  
  END AS dteFin,  
  txtProducto  
 INTO #tmp_tblVarPosturasRev  
 FROM tmp_tblVarPosturasRevOnLine  
 WHERE txtTv IN ('IP','IS','IT','LD','LS','BREM','IQ','IM')  
 AND  txtInstrumento NOT IN ('CETES')  
 AND  txtProducto LIKE '%.%'  
  
 UPDATE #tmp_tblVarPosturasRev SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'  
 UPDATE #tmp_tblVarPosturasRev SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'  
  
 ----- elimino los registros de la tabla  
 ----- destino pero solo los Tv LD  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 7 -- VAR  
 AND  txtOperation IN ('COMPRA','VENTA')  
 AND txtTv in ('LD')  
  
  
 --- Insertamos en el destino  
 --- Solo Bondes LD  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  -999 AS intLinea,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dblMonto AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tmp_tblVarPosturasRev AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
 AND m.txtInstrumento IN ('Bonde LD')  
 AND  b.dteMaturity > @txtMDDate  
 AND m.txtLiquidacion IN ('48','MD')  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio    
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intInicio)  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intFin)  
 AND m.txtProducto LIKE '%.%'  
  
 ----- elimino los registros de la tabla  
 ----- destino pero solo los Tv LD  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 7 -- VAR  
 AND  txtOperation IN ('COMPRA','VENTA')  
 AND txtTv IN ('IP','IS','IT','LS','XA','IQ','IM')  
  
 --- Insertamos en el destino  
 --- Todos Excepto Bondes LD  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtTv,  
  txtOperacion,  
  dblTasa,  
  dblMonto AS dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #tmp_tblVarPosturasRev  
 WHERE txtTv IN ('LS','XA')  
 AND txtLiquidacion IN ('48')  
  
 UNION  
  
 -- cotizaciones en especifico  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblVarPosturasRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio = m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intInicio    
   AND m. txtProducto LIKE '%.%'  
  
 UNION  
  
 -- cotizaciones en rango  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblVarPosturasRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
   AND m. txtProducto LIKE '%.%'   
  
   
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 7 -- VAR  
   AND txtOperation IN ('COMPRA','VENTA')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion,  
   STR(m.intInicio) + ' - ' + STR(m.intFin)  
 FROM #tmp_tblVarPosturasRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
   AND m. txtProducto LIKE '%.%'   
  
 SET NOCOUNT OFF  
  
END  
  
  
-- para crear la tabla temporal de Hechos de VAR  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];7  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblVarHechosRevOnLine]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblVarHechosRevOnLine]  
   
 CREATE TABLE [dbo].[tmp_tblVarHechosRevOnLine] (  
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
  [txtProducto] [VARCHAR] (100) NULL  
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];8  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
AS  
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para cargar hechos de instrumentos revisables provenientes de VAR  
  
 Modificado por: CSOLORIO  
 Modificacion: 20140318  
 Descripcion: Agrego restriccion en la carga de instrumentos en plazo  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 --- Tabla Temporal de hechos  
 SELECT DISTINCT  
  CONVERT(DATETIME,txtFecha) AS dteFecha,  
  CONVERT(DATETIME,txtFecha) AS dteLiquidacion,  
  CAST(txtPlazoIni AS INT) AS intInicio,  
  CAST(txtPlazoFin AS INT) AS intFin,  
  txtTv,  
  txtInstrumento,  
  txtSerie,  
   txtLiquidacion,   
  7 AS intBroker,  
  'HECHO' AS txtOperacion,   
  CAST(txtMonto AS FLOAT) AS dblMonto,  
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteInicio,  
  CASE WHEN LEN(txtHoraIni) = 5 THEN  
   CONVERT(DATETIME,'0' + SUBSTRING(txtHoraIni,1,1) + ':' + SUBSTRING(txtHoraIni,2,2) + ':' + SUBSTRING(txtHoraIni,4,2),108)  
  ELSE  
   CONVERT(DATETIME,SUBSTRING(txtHoraIni,1,2) + ':' + SUBSTRING(txtHoraIni,3,2) + ':' + SUBSTRING(txtHoraIni,5,2),108)  
  END AS dteFin,  
  txtProducto  
 INTO #tmp_tblVarHechosRev  
 FROM tmp_tblVarHechosRevOnLine  
 WHERE txtTv IN ('IP','IS','IT','LD','LS','BREM', 'IQ', 'IM')  
 AND  txtInstrumento NOT IN ('CETES')  
  
 UPDATE #tmp_tblVarHechosRev SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'  
 UPDATE #tmp_tblVarHechosRev SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'  
   
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 7 -- VAR  
 AND  txtOperation IN ('HECHO')  
 AND txtTv in ('LD') -- solo Bondes  
   
 --- Insertamos en la tabla destino  
 --- Solo Bondes  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  -999 AS intLinea,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dblMonto AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tmp_tblVarHechosRev AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
 AND m.txtInstrumento IN ('Bonde LD')  
 AND  b.dteMaturity > @txtMDDate  
 AND m.txtLiquidacion IN ('48','MD')  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio    
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intInicio)  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intFin)  
   
 --- Elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 7 -- VAR  
 AND  txtOperation IN ('HECHO')  
 AND txtTv IN ('IP','IS','IT','LS','XA', 'IQ', 'IM')  
  
 --- Insertamos en la tabla destino  
 --- Todo menos Bondes   
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtTv,  
  txtOperacion,  
  dblTasa,  
  dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #tmp_tblVarHechosRev   
 WHERE txtTv IN ('LS','BREM')  
 AND txtLiquidacion IN ('48')  
  
 UNION  
  
 -- cotizaciones en especifico  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblVarHechosRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio = m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intInicio    
  
 UNION  
  
 -- cotizaciones en rango  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tmp_tblVarHechosRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 7 -- VAR  
   AND txtOperation IN ('HECHO')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion,  
   STR(m.intInicio) + ' - ' + STR(m.intFin)  
 FROM #tmp_tblVarHechosRev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtTV IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];9  
 @txtDate AS CHAR(10)  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para crear la tabla temporal de SIF Posturas  
  
 Modificado por: CSOLORIO  
 Modificacion: 20111208  
 Descripcion:    Agrego campo de restriccion  
*/  
  
BEGIN  
   
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblSifPosturasRev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblSifPosturasRev]  
   
 CREATE TABLE [dbo].[tmp_tblSifPosturasRev] (  
  [txtFecha] [varchar] (50) NULL ,  
  [txtTTMIni] [varchar] (50) NULL ,  
  [txtTTMFin] [varchar] (50) NULL ,  
  [txtInstrumento] [varchar] (50) NULL ,  
  [txtLiq] [varchar] (50) NULL ,  
  [txtOp] [varchar] (50) NULL ,  
  [txtMonto] [varchar] (50) NULL ,  
  [txtTasa] [varchar] (50) NULL ,  
  [txtHoraIni] [varchar] (50) NULL ,  
  [txtHoraFin] [varchar] (50) NULL,   
  [txtRestriccion] [varchar] (50) NULL   
 ) ON [PRIMARY]  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];10  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga las Posturas de Enlace  
  
 Modificado por: CSOLORIO  
 Modificacion: 20120927  
 Descripcion:    Modifico identificacion de bonos IM e IQ  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE  @intBroker AS INT   
  
 ----- obtengo el ID del broker   
 SET @intBroker = (  
  SELECT intIdBroker  
  FROM itblBrokerCatalog  
  WHERE  
   txtBroker LIKE '%SIF%'  
 )  
  
  
 ----- elimino duplicados y creo campo de fecha base  
  SELECT  DISTINCT   
  CONVERT(DATETIME,txtFecha,111) AS dteFecha,  
  CAST(txtTTMIni AS INT) AS intTTMIni,  
  CAST(txtTTMFin AS INT) AS intTTMFin,  
  txtInstrumento,  
  txtLiq,  
  txtOp,  
  CAST(txtMonto AS FLOAT) AS dblMonto,  
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
  END AS dteHoraIni,  
   
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
  END AS dteHoraFin,  
  
  CAST('1899-12-31' AS DATETIME) dteBaseDate  
  INTO #tmp_tblSifMercado  
  FROM tmp_tblSifPosturasRev  
  WHERE txtLiq IN ('48','MD')  
  AND txtInstrumento IN ('BPAS','BPIS','BPAT','LD28','L182','BXA','BPAM','BPAQ')  
  ORDER BY dteHoraIni  
    
   
 ----- establezco la fecha base   
 UPDATE #tmp_tblSifMercado SET dteBaseDate =@txtMDDate WHERE txtLiq = 'MD'  
 UPDATE #tmp_tblSifMercado SET dteBaseDate =@txt24Date WHERE txtLiq = '24'  
 UPDATE #tmp_tblSifMercado SET dteBaseDate =@txt48Date WHERE txtLiq = '48'  
   
 ----- ajusto los plazos de busqueda   
  UPDATE #tmp_tblSifMercado  
  SET   
  intTTMIni = intTTMIni + CAST(dteBaseDate - @txtMDDate AS INT),  
  intTTMFin = intTTMFin + CAST(dteBaseDate - @txtMDDate AS INT)  
  WHERE txtInstrumento = 'LD28'  
  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM  itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = @intBroker  
 AND  txtOperation IN ('COMPRA', 'VENTA')  
 AND txtTv in ('LD')  
  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IP'  
 WHERE txtInstrumento = 'BPAS'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IS'  
 WHERE txtInstrumento = 'BPIS'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IT'  
 WHERE txtInstrumento = 'BPAT'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'LD'  
 WHERE txtInstrumento = 'LD28'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'LS'  
 WHERE txtInstrumento = 'L182'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'XA'  
 WHERE txtInstrumento = 'BXA'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IM'  
 WHERE txtInstrumento = 'BPAM'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IQ'  
 WHERE txtInstrumento = 'BPAQ'  
   
 -- Agregamos Bondes D a la tabla  
 INSERT itblMarketPositions  
 SELECT  DISTINCT   
  m.dteFecha AS dteDate,  
  @intBroker AS intIdBroker,  
  -999 AS intLine,  
  DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazo,  
  i.txtTv,  
   
  CASE m.txtOp  
  WHEN 'CO' THEN 'COMPRA'  
  WHEN 'VE' THEN 'VENTA'  
  END AS txtOperation,  
   
  m.dblTasa AS dblRate,  
  m.dblMonto * 1000000 AS dblAmount,  
   
  RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,  
   
  CASE   
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
   '14:00:00'  
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
   '14:00:00'  
  ELSE RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
  END AS dteEndHour,  
  m.txtLiq  
 FROM  #tmp_tblSifMercado AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv in ('LD')  
 AND  (m.intTTMIni <= DATEDIFF(d, @txtMDDate, b.dteMaturity)  
   OR m.intTTMIni <= DATEDIFF(d, @txt48Date, b.dteMaturity))  
 AND  (m.intTTMFin >= DATEDIFF(d, @txtMDDate, b.dteMaturity)  
   OR m.intTTMFin >= DATEDIFF(d, @txt48Date, b.dteMaturity))  
 AND  m.txtInstrumento IN ('LD')  
  
  
 DELETE  
 FROM  itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = @intBroker  
 AND  txtOperation IN ('COMPRA', 'VENTA')  
  
 -- agrego los reales... los separe del query anterior  
 INSERT  itblMarketPositionsRevi  
 SELECT  DISTINCT   
  m.dteFecha AS dteDate,  
  @intBroker AS intIdBroker,  
  m.intTTMIni,  
  m.intTTMFin,  
  m.txtInstrumento,  
   
  CASE m.txtOp  
  WHEN 'CO' THEN 'COMPRA'  
  WHEN 'VE' THEN 'VENTA'  
  END AS txtOperation,  
   
  m.dblTasa AS dblRate,  
  m.dblMonto * 1000000 AS dblAmount,  
   
  RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,  
   
  CASE   
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
   '14:00:00'  
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
   '14:00:00'  
  ELSE RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
  END AS dteEndHour,  
  m.txtLiq  
 FROM  #tmp_tblSifMercado AS m  
 WHERE m.txtInstrumento IN ('LS','XA')  
  
 UNION  
  
 -- cotizaciones en especifico  
 SELECT  m.dteFecha AS dteDate,  
   @intBroker AS intIdBroker,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoFin,  
   i.txtTv,    
   CASE m.txtOp  
    WHEN 'CO' THEN 'COMPRA'  
    WHEN 'VE' THEN 'VENTA'  
   END AS txtOperation,    
   m.dblTasa AS dblRate,  
   m.dblMonto * 1000000 AS dblAmount,    
   RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,    
   CASE   
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
     '14:00:00'  
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
     '14:00:00'  
    ELSE   
     RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
   END AS dteEndHour,  
   m.txtLiq  
 FROM  #tmp_tblSifMercado AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND m.intTTMIni = m.intTTMFin   
   AND m.intTTMIni = DATEDIFF(d, @txt48Date, b.dteMaturity)  
   
 UNION  
  
 -- cotizaciones en rango  
 SELECT  m.dteFecha AS dteDate,  
   @intBroker AS intIdBroker,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoFin,  
   i.txtTv,    
   CASE m.txtOp  
    WHEN 'CO' THEN 'COMPRA'  
    WHEN 'VE' THEN 'VENTA'  
   END AS txtOperation,    
   m.dblTasa AS dblRate,  
   m.dblMonto * 1000000 AS dblAmount,    
   RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,    
   CASE   
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
     '14:00:00'  
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
     '14:00:00'  
    ELSE   
     RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
   END AS dteEndHour,  
   m.txtLiq  
 FROM  #tmp_tblSifMercado AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND m.intTTMIni <> m.intTTMFin  
   AND m.intTTMIni < DATEDIFF(d, @txt48Date, b.dteMaturity)  
   AND m.intTTMFin >= DATEDIFF(d, @txt48Date, b.dteMaturity)  
   
   
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = @intBroker  
   AND txtOperation IN ('COMPRA', 'VENTA')  
  
 INSERT itblMarketReviRangeNodes  
   (      dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   @intBroker,  
   STR(DATEDIFF(d, @txtMDDate, b.dteMaturity)),  
   i.txtTv,    
   CASE m.txtOp  
    WHEN 'CO' THEN 'COMPRA'  
    WHEN 'VE' THEN 'VENTA'  
   END AS txtOperation,    
   RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,    
   CASE   
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
     '14:00:00'  
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
     '14:00:00'  
    ELSE   
     RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
   END AS dteEndHour,  
   m.txtLiq,  
   STR(m.intTTMIni) + ' - ' + STR(m.intTTMFin)  
 FROM  #tmp_tblSifMercado AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND m.intTTMIni <> m.intTTMFin  
   AND m.intTTMIni < DATEDIFF(d, @txt48Date, b.dteMaturity)  
   AND m.intTTMFin >= DATEDIFF(d, @txt48Date, b.dteMaturity)  
  
 SET NOCOUNT OFF  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];11  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
AS  
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para cargar hechos de SIF  
  
 Modificado por: CSOLORIO  
 Modificacion: 20120927  
 Descripcion:    Modifico identificacion de bonos IM e IQ  
*/  
BEGIN  
 SET NOCOUNT ON  
  
 DECLARE  @intBroker AS INT   
  
 ----- obtengo el ID del broker  
 SET @intBroker = (  
  SELECT intIdBroker  
  FROM itblBrokerCatalog  
  WHERE  
   txtBroker LIKE '%SIF%'  
 )  
  
 -- elimino duplicados y creo campo de fecha base  
 -- sumo los montos de operaciones identicas  
  SELECT  DISTINCT   
  CONVERT(DATETIME,txtFecha,11) AS dteFecha,  
  CAST(txtTTMIni AS INT) AS intTTMIni,  
  CAST(txtTTMFin AS INT) AS intTTMFin,  
  txtInstrumento,  
  txtLiq,  
  txtOp,  
  CAST(txtMonto AS FLOAT) AS dblMonto,  
  CAST(txtTasa AS FLOAT) AS dblTasa,  
  
 CASE WHEN LEN(txtHoraIni) = 6 THEN  
  CAST (  
   SUBSTRING(txtHoraIni, 1, 2) + ':' +  
   SUBSTRING(txtHoraIni, 3, 2) + ':' +  
   SUBSTRING(txtHoraIni, 5, 2) AS DATETIME)   
 ELSE  
  CAST (  
   SUBSTRING(txtHoraIni, 1, 1) + ':' +  
   SUBSTRING(txtHoraIni, 2, 2) + ':' +  
   SUBSTRING(txtHoraIni, 4, 2) AS DATETIME)  
 END AS dteHoraIni,  
  
 CASE WHEN LEN(txtHoraIni) = 6 THEN  
  CAST (  
   SUBSTRING(txtHoraFin, 1, 2) + ':' +  
   SUBSTRING(txtHoraFin, 3, 2) + ':' +  
   SUBSTRING(txtHoraFin, 5, 2) AS DATETIME)   
 ELSE  
  CAST (  
   SUBSTRING(txtHoraFin, 1, 1) + ':' +  
   SUBSTRING(txtHoraFin, 2, 2) + ':' +  
   SUBSTRING(txtHoraFin, 4, 2) AS DATETIME)   
 END AS dteHoraFin,  
  
  CAST('1899-12-31' AS DATETIME) dteBaseDate  
 INTO  #tmp_tblSifMercado  
 FROM  tmp_tblSifHechosRev  
 WHERE  txtLiq IN ('48','MD')  
 AND txtInstrumento IN ('BPAS','BPIS','BPAT','LD28','L182','XA','BPAM','BPAQ')  
  
   
 ----- establezco la fecha base   
 UPDATE #tmp_tblSifMercado SET dteBaseDate =@txtMDDate WHERE txtLiq = 'MD'  
 UPDATE #tmp_tblSifMercado SET dteBaseDate =@txt24Date WHERE txtLiq = '24'  
 UPDATE #tmp_tblSifMercado SET dteBaseDate =@txt48Date WHERE txtLiq = '48'  
   
 ----- ajusto los plazos de busqueda   
  UPDATE #tmp_tblSifMercado  
  SET   
  intTTMIni = intTTMIni + CAST(dteBaseDate - @txtMDDate AS INT),  
  intTTMFin = intTTMFin + CAST(dteBaseDate - @txtMDDate AS INT)  
  WHERE  txtInstrumento = 'LD28'  
  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM  itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = @intBroker  
 AND  txtOperation = 'HECHO'  
 AND  txtTv in ('LD')  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IP'  
 WHERE txtInstrumento = 'BPAS'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IS'  
 WHERE txtInstrumento = 'BPIS'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IT'  
 WHERE txtInstrumento = 'BPAT'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'LD'  
 WHERE txtInstrumento = 'LD28'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'LS'  
 WHERE txtInstrumento = 'L182'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'XA'  
 WHERE txtInstrumento = 'BXA'  
   
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IM'  
 WHERE txtInstrumento = 'BPAM'  
  
 UPDATE #tmp_tblSifMercado  
 SET txtInstrumento = 'IQ'  
 WHERE txtInstrumento = 'BPAQ'  
  
 -- Agrego los LD a la tabla  
 INSERT itblMarketPositions  
 SELECT  DISTINCT   
  m.dteFecha AS dteDate,  
  @intBroker AS intIdBroker,  
  -999 AS intLine,  
  DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  'HECHO' AS txtOperation,  
  m.dblTasa AS dblRate,  
  m.dblMonto * 1000000 AS dblAmount,  
   
  RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,  
   
  CASE   
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
   '14:00:00'  
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
   '14:00:00'  
  ELSE RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
  END AS dteEndHour,   
  m.txtLiq  
  FROM  #tmp_tblSifMercado AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv in ('LD')  
 AND  (m.intTTMIni <= DATEDIFF(d, @txtMDDate, b.dteMaturity)  
  OR m.intTTMIni <= DATEDIFF(d, @txt48Date, b.dteMaturity))  
 AND  (m.intTTMFin >= DATEDIFF(d, @txtMDDate, b.dteMaturity)  
  OR m.intTTMFin >= DATEDIFF(d, @txt48Date, b.dteMaturity))  
 AND m.txtInstrumento IN ('LD')  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM  itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = @intBroker  
 AND  txtOperation = 'HECHO'  
  
  
 -- todos los demas revisables  
 INSERT itblMarketPositionsRevi  
 SELECT DISTINCT   
  m.dteFecha AS dteDate,  
  @intBroker AS intIdBroker,  
  m.intTTMIni,  
  m.intTTMFin,  
  m.txtInstrumento,  
  'HECHO' AS txtOperation,  
  m.dblTasa AS dblRate,  
  m.dblMonto * 1000000 AS dblAmount,  
  RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,  
  CASE   
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
   '14:00:00'  
  WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
   '14:00:00'  
  ELSE RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
  END AS dteEndHour,   
  m.txtLiq  
 FROM  #tmp_tblSifMercado AS m  
 WHERE m.txtInstrumento IN ('LS','XA')  
   
 UNION  
  
 -- cotizaciones en especifico  
 SELECT  m.dteFecha AS dteDate,  
   @intBroker AS intIdBroker,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   'HECHO' AS txtOperation,  
   m.dblTasa AS dblRate,  
   m.dblMonto * 1000000 AS dblAmount,  
   RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,  
   CASE   
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
     '14:00:00'  
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
     '14:00:00'  
    ELSE   
     RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
   END AS dteEndHour,   
   m.txtLiq  
  FROM  #tmp_tblSifMercado AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND m.intTTMIni = m.intTTMFin  
   AND m.intTTMIni = DATEDIFF(d, @txt48Date, b.dteMaturity)  
   
 UNION  
  
 -- cotizaciones en rango  
 SELECT  m.dteFecha AS dteDate,  
   @intBroker AS intIdBroker,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   'HECHO' AS txtOperation,  
   m.dblTasa AS dblRate,  
   m.dblMonto * 1000000 AS dblAmount,  
   RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,  
   CASE   
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
     '14:00:00'  
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
     '14:00:00'  
    ELSE   
     RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
   END AS dteEndHour,   
   m.txtLiq  
  FROM  #tmp_tblSifMercado AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND m.intTTMIni <> m.intTTMFin  
   AND m.intTTMIni < DATEDIFF(d, @txt48Date, b.dteMaturity)  
   AND m.intTTMFin >= DATEDIFF(d, @txt48Date, b.dteMaturity)  
  
   
 -- Registramos nodos que cotizaron en ragno  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = @intBroker  
   AND txtOperation = 'HECHO'  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   @intBroker,  
   DATEDIFF(d, @txtMDDate, b.dteMaturity),  
   i.txtTv,  
   'HECHO' AS txtOperation,  
   RTRIM(CONVERT(CHAR(8), m.dteHoraIni, 108)) AS dteBeginHour,  
   CASE   
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '23:59:59' THEN   
     '14:00:00'  
    WHEN RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108)) = '00:00:00' THEN   
     '14:00:00'  
    ELSE   
     RTRIM(CONVERT(CHAR(8), m.dteHoraFin, 108))  
   END AS dteEndHour,   
   m.txtLiq,  
   STR(m.intTTMIni) + ' - ' + STR(m.intTTMFin)  
  FROM  #tmp_tblSifMercado AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND m.intTTMIni <> m.intTTMFin  
   AND m.intTTMIni < DATEDIFF(d, @txt48Date, b.dteMaturity)  
   AND m.intTTMFin >= DATEDIFF(d, @txt48Date, b.dteMaturity)  
  
  
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];12  
 @txtDate AS CHAR(10)  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para crear la tabla temporal de posturas de Tradition  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110111  
 Descripcion:    Cambio nombre de la tabla  
*/  
  
BEGIN  
   
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblTraditionPosturasRev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblTraditionPosturasRev]  
   
 CREATE TABLE [dbo].[tmp_tblTraditionPosturasRev] (  
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
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];13  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga las Posturas de TRADITION  
  
 Modificado por: Carlos Solorio  
 Modificacion: 20130815  
 Descripcion:    Agrego el IS a la lista de TV validos  
*/  
  
  
BEGIN  
  
 SET NOCOUNT ON  
  
 --- Primea tabla Temporal  
 SELECT CONVERT(DATETIME,txtFecha,103) AS dteFecha,  
  CONVERT(DATETIME,txtFecha,103) AS dteLiquidacion,  
  CAST(txtPlazoIni AS INT) AS intInicio,  
  CAST(txtPlazoFin AS INT) AS intFin,  
  
  CASE   
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IP' THEN  
   'IP'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'ST' THEN        
   'IT'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'TP' THEN  
   'IT'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'XA' THEN  
   'XA'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IS' THEN  
   'IS'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'LD' THEN  
   'LD'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'LS' THEN  
   'LS'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IQ' THEN  
   'IQ'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IM' THEN  
   'IM'  
  END AS txtInstrumento,  
  
   txtLiquidacion,   
  6 AS intBroker,  
  CASE WHEN txtOperacion = 'VE' THEN  
   'VENTA'  
  ELSE  
   'COMPRA'  
  END AS txtOperacion,   
  CAST(txtMonto AS FLOAT) AS dblMonto,   
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CASE WHEN txtInicio IS NULL THEN   
   '1900-01-01 14:00:00.000'  
  ELSE  
   CONVERT(DATETIME,txtInicio)  
  END AS dteInicio,  
  CASE WHEN txtFin IS NULL THEN   
   '1900-01-01 14:00:00.000'  
  ELSE  
   CONVERT(DATETIME,txtFin)  
  END AS dteFin  
 INTO #tblTraditionTemp   
 FROM tmp_tblTraditionPosturasRev  
 WHERE txtLiquidacion IN ('48','MD')  
 AND  SUBSTRING(txtInstrumento,1,2)  IN ('IP','ST','TP','XA','SP','LD','LS','IQ','IM','IS')  
 AND txtPlazoIni NOT LIKE ('%@%')  
   
 --- Actualizamos las dos tablas  
 UPDATE #tblTraditionTemp SET dteLiquidacion =@txtMDDate WHERE txtLiquidacion = 'MD'  
 UPDATE #tblTraditionTemp SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'  
 UPDATE #tblTraditionTemp SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'  
   
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 6 -- TRADITION  
 AND  txtOperation IN ('COMPRA','VENTA')  
 AND  txtTv in ('LD')  
  
 --- Insertamos en el destino  
 --- LD  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  -999 AS intLine,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  SUM(m.dblMonto) * 1000000 AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tblTraditionTemp AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
 AND m.txtInstrumento IN ('LD')  
 AND  b.dteMaturity > @txtMDDate  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intInicio )  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intFin )  
 GROUP BY  
  m.dteFecha,  
  m.intBroker,  
  b.dteMaturity,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 6 -- TRADITION  
 AND  txtOperation IN ('COMPRA','VENTA')  
  
 -- Todos los demas revisables  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtInstrumento,  
  txtOperacion,  
  dblTasa,  
  SUM(dblMonto) * 1000000 AS dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #tblTraditionTemp  
 WHERE txtInstrumento IN ('XA')   
 GROUP BY  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtInstrumento,  
  txtOperacion,  
  dblTasa,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
  
 UNION  
  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  SUM(m.dblMonto) * 1000000 AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tblTraditionTemp AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LS')  
 AND  m.txtInstrumento IN ('LS')  
 AND  i.txtTv = m.txtInstrumento  
 AND  b.dteMaturity > @txtMDDate  
 AND  DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio    
 AND  DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
 GROUP BY   
  m.dteFecha,  
  m.intBroker,  
  b.dteMaturity,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
  
 UNION  
  
 -- cotizaciones en especifico  
 SELECT m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   SUM(m.dblMonto) * 1000000 AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tblTraditionTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IT','IS', 'IQ', 'IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.intInicio = m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intInicio  
 GROUP BY   
  m.dteFecha,  
  m.intBroker,  
  b.dteMaturity,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
   
 UNION  
  
 -- cotizaciones en rango  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   SUM(m.dblMonto) * 1000000 AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tblTraditionTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IT','IS','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
 GROUP BY   
   m.dteFecha,  
   m.intBroker,  
   b.dteMaturity,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
   
  
 -- Registramos nodos qeu cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 6 -- TRADITION  
   AND txtOperation IN ('COMPRA','VENTA')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion,  
   STR(m.intInicio) + ' - ' + STR(m.intFin)  
 FROM #tblTraditionTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IT','IS','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.intInicio <> m.intFin   
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];14  
 @txtDate AS CHAR(10)  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para crear la tabla temporal de hechos de Tradition  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110111  
 Descripcion:    Cambio nombre de la tabla  
*/  
  
BEGIN  
   
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblTraditionHechosRev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblTraditionHechosRev]  
   
 CREATE TABLE [dbo].[tmp_tblTraditionHechosRev] (  
  [txtFecha] [varchar] (20) NULL ,  
  [txtPlazoIni] [varchar] (10) NULL ,  
  [txtPlazoFin] [varchar] (10) NULL ,  
  [txtInstrumento] [varchar] (10) NULL ,  
  [txtLiquidacion] [varchar] (10) NULL ,  
  [txtOperacion] [varchar] (10) NULL ,  
  [txtMonto] [varchar] (20) NULL ,  
  [txtTasa] [varchar] (20) NULL ,  
  [txtInicio] [varchar] (20) NULL ,  
  [txtFin] [varchar] (20) NULL   
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];15  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga los hechos de Tradition  
  
 Modificado por: Carlos Solorio  
 Modificacion: 20130815  
 Descripcion:    Agrego el IS a la lista de TV validos  
*/  
BEGIN  
   
 SET NOCOUNT ON  
  
 --- Primea tabla Temporal  
 SELECT CASE   
  WHEN txtFecha LIKE ('%Ene%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Ene','Jan'),103)  
  WHEN txtFecha LIKE ('%Abr%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Abr','Apr'),103)  
  WHEN txtFecha LIKE ('%Ago%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Ago','Aug'),103)  
  WHEN txtFecha LIKE ('%Dic%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Dic','Dec'),103)  
  ELSE  
   CONVERT(DATETIME,txtFecha,103)  
  END AS dteFecha,  
  CASE   
  WHEN txtFecha LIKE ('%Ene%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Ene','Jan'),103)  
  WHEN txtFecha LIKE ('%Abr%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Abr','Apr'),103)  
  WHEN txtFecha LIKE ('%Ago%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Ago','Aug'),103)  
  WHEN txtFecha LIKE ('%Dic%') THEN  
   CONVERT(DATETIME,REPLACE(txtFecha,'Dic','Dec'),103)  
  ELSE  
   CONVERT(DATETIME,txtFecha,103)  
  END AS dteLiquidacion,  
  CAST(txtPlazoIni AS INT) AS intInicio,  
  CAST(txtPlazoFin AS INT) AS intFin,  
  CASE   
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IP' THEN  
   'IP'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'TP' THEN  
   'IT'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'XA' THEN  
   'XA'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IS' THEN  
   'IS'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'LD' THEN  
   'LD'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'LS' THEN  
   'LS'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IQ' THEN  
   'IQ'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IM' THEN  
   'IM'  
  END AS txtInstrumento,  
   txtLiquidacion,   
  6 AS intBroker,  
  'HECHO' AS txtOperacion,   
  CAST(txtMonto AS FLOAT) * 1000000 AS dblMonto,   
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CONVERT(DATETIME,txtInicio) AS dteInicio,  
  CONVERT(DATETIME,txtFin) AS dteFin  
 INTO #tblTraditionTemp   
 FROM tmp_tblTraditionHechosRev  
 WHERE txtLiquidacion IN ('48','MD')  
 AND  txtInstrumento  IN ('IP','IT','TP','SP','IS','LD','LS','XA','IQ','IM','IS')  
 AND txtPlazoIni NOT LIKE ('%@%')  
   
 --- Actualizamos las dos tablas  
 UPDATE #tblTraditionTemp SET dteLiquidacion =@txtMDDate WHERE txtLiquidacion = 'MD'  
 UPDATE #tblTraditionTemp SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'  
 UPDATE #tblTraditionTemp SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'  
   
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 6 -- TRADITION  
 AND  txtOperation IN ('HECHO')  
 AND txtTv in ('LD')  
   
 --- Insertamos en el destino  
 --- LD  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  -999 AS intLine,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  SUM(m.dblMonto) AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tblTraditionTemp AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
 AND m.txtInstrumento IN ('LD')  
 AND  b.dteMaturity > @txtMDDate  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intInicio )  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  OR DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin )  
 GROUP BY  
  m.dteFecha,  
  m.intBroker,  
  b.dteMaturity,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
   
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 6 -- TRADITION  
 AND  txtOperation IN ('HECHO')  
 AND txtTv IN ('IP','IT','LS','XA','IS','IQ','IM')  
   
 --- Todos los demas revisables  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtInstrumento,  
  txtOperacion,  
  dblTasa,  
  SUM(dblMonto) AS dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #tblTraditionTemp  
 WHERE txtInstrumento IN ('XA','LS' )  
 GROUP BY  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtInstrumento,  
  txtOperacion,  
  dblTasa,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
  
 INSERT itblMarketPositionsRevi  
   
 -- cotizaciones en especifico  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   SUM(m.dblMonto) AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tblTraditionTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IT','IS','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.intInicio = m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intInicio    
 GROUP BY  
  m.dteFecha,  
  m.intBroker,  
  b.dteMaturity,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
    
 UNION  
  
 -- cotizaciones en rango  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   SUM(m.dblMonto) AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tblTraditionTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IT','IS','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
 GROUP BY  
   m.dteFecha,  
   m.intBroker,  
   b.dteMaturity,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
  
   
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 6 -- TRADITION  
   AND txtOperation IN ('HECHO')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion,  
   STR(m.intInicio) + ' - ' + STR(m.intFin)  
 FROM #tblTraditionTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IT','IS','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
 SET NOCOUNT OFF  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];16  
 @txtDate AS VARCHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion: Para crear la tabla temporal de Operaciones de ENLACE  
  
 Modificado por: CSOLORIO  
 Modificacion: 20110111  
 Descripcion:    Cambio nombre de la tabla  
*/  
  
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblEnlaceOperacionesRev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblEnlaceOperacionesRev]  
   
 CREATE TABLE [dbo].[tmp_tblEnlaceOperacionesRev] (  
  [txtConsecutivo] [varchar] (5) NULL ,  
  [txtFecha] [varchar] (12) NULL ,  
  [txtInicio] [varchar] (10) NULL ,  
  [txtFin] [varchar] (10) NULL ,  
  [txtOperacion] [char] (10) NULL ,  
  [txtLinea] [varchar] (10) NULL ,  
  [txtMonto] [varchar] (10) NULL ,  
  [txtTasa] [varchar] (10) NULL ,  
  [txtInstrumento] [char] (50) NULL ,  
  [txtPlazo] [char] (20) NULL ,  
  [txtLiquidacion] [char] (10) NULL   
 ) ON [PRIMARY]  
  
END  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];17  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga las Operaciones de Enlace  
  
 Modificado por: CSOLORIO  
 Modificacion: 20120926  
 Descripcion:    Modifico identificacion de IM e IQ  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 --- Tabla Temporal de hechos  
 SELECT txtConsecutivo,  
  CONVERT(DATETIME,txtFecha) AS dteFecha,  
  CONVERT(DATETIME,txtFecha) AS dteLiquidacion,  
  CASE WHEN CHARINDEX('-',txtPlazo) > 0 THEN  
   CAST(SUBSTRING(txtPlazo,1,CHARINDEX('-',txtPlazo)-1) AS INT)  
  ELSE  
   CAST(txtPlazo AS INT)  
  END AS intInicio,  
   
  CASE WHEN CHARINDEX('-',txtPlazo) > 0 THEN  
   CAST(SUBSTRING(txtPlazo,CHARINDEX('-',txtPlazo)+1,LEN(RTRIM(txtPlazo))-CHARINDEX('-',txtPlazo)) AS INT)  
  ELSE  
   CAST(txtPlazo AS INT)  
  END AS intFin,  
    
  CASE   
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IP' THEN  
   'IP'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'IS' THEN  
   'IS'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'TP' THEN  
   'IT'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'LD' THEN  
   'LD'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'LS' THEN  
   'LS'  
  WHEN SUBSTRING(txtInstrumento,1,2) = 'XA' THEN  
   'XA'  
  WHEN dbo.fun_split(txtInstrumento,'',1) = 'BPAG91' THEN   
   'IQ'  
  WHEN dbo.fun_split(txtInstrumento,'',1) = 'BPAG28' THEN  
   'IM'  
  
  END AS txtInstrumento,  
   txtLiquidacion,   
  1 AS intBroker,  
  CASE   
  WHEN RTRIM(txtOperacion) = 'T' THEN  
   'HECHO'  
  WHEN RTRIM(txtOperacion) = 'H' THEN  
   'HECHO'  
  END AS txtOperacion,   
  CAST(txtLinea AS INT) AS intLinea,  
  CAST(txtMonto AS FLOAT) AS dblMonto,   
  CAST(txtTasa AS FLOAT) AS dblTasa,   
  CONVERT(DATETIME,txtFin) AS dteInicio,  
  CONVERT(DATETIME,txtFin) AS dteFin  
 INTO #tmp_tblHechosEnlace  
 FROM tmp_tblEnlaceOperacionesRev  
 WHERE txtLiquidacion IN ('48','24','MD')  
 AND RTRIM(txtOperacion) IN ('T','H')  
 ORDER BY  
  intLinea  
   
   
 --- Tabla temporal de posturas  
 SELECT   
  CASE  
   WHEN f.txtConsecutivo IS NULL THEN c.txtConsecutivo   
   ELSE f.txtConsecutivo  
  END AS txtConsecutivo,  
  CASE  
   WHEN f.txtFecha IS NULL THEN CONVERT(DATETIME,c.txtFecha)  
   ELSE CONVERT(DATETIME,f.txtFecha)  
  END AS dteFecha,  
  CASE  
   WHEN f.txtFecha IS NULL THEN CONVERT(DATETIME,c.txtFecha)  
   ELSE CONVERT(DATETIME,f.txtFecha)  
  END AS dteLiquidacion,  
  CASE  
   WHEN f.txtPlazo IS NULL THEN     
    CASE   
     WHEN CHARINDEX('-',c.txtPlazo) > 0 THEN CAST(SUBSTRING(c.txtPlazo,1,CHARINDEX('-',c.txtPlazo)-1) AS INT)  
     ELSE CAST(c.txtPlazo AS INT)  
    END  
   ELSE    
    CASE   
     WHEN CHARINDEX('-',f.txtPlazo) > 0 THEN CAST(SUBSTRING(f.txtPlazo,1,CHARINDEX('-',f.txtPlazo)-1) AS INT)  
     ELSE CAST(f.txtPlazo AS INT)  
    END  
  END AS intInicio,  
  CASE  
   WHEN f.txtPlazo IS NULL THEN   
    CASE   
     WHEN CHARINDEX('-',c.txtPlazo) > 0 THEN CAST(SUBSTRING(c.txtPlazo,CHARINDEX('-',c.txtPlazo)+1,LEN(RTRIM(c.txtPlazo))-CHARINDEX('-',c.txtPlazo)) AS INT)  
     ELSE CAST(c.txtPlazo AS INT)  
    END   
   ELSE   
    CASE   
     WHEN CHARINDEX('-',f.txtPlazo) > 0 THEN CAST(SUBSTRING(f.txtPlazo,CHARINDEX('-',f.txtPlazo)+1,LEN(RTRIM(f.txtPlazo))-CHARINDEX('-',f.txtPlazo)) AS INT)  
     ELSE CAST(f.txtPlazo AS INT)  
    END  
  END AS intFin,  
  CASE  
   WHEN f.txtInstrumento IS NULL THEN   
    CASE   
     WHEN SUBSTRING(c.txtInstrumento,1,2) = 'IP' THEN 'IP'  
     WHEN SUBSTRING(c.txtInstrumento,1,2) = 'IS ' THEN 'IS'  
     WHEN SUBSTRING(c.txtInstrumento,1,2) = 'TP' THEN 'IT'  
     WHEN SUBSTRING(c.txtInstrumento,1,2) = 'LD' THEN 'LD'  
     WHEN SUBSTRING(c.txtInstrumento,1,2) = 'LS' THEN 'LS'       
     WHEN SUBSTRING(c.txtInstrumento,1,2) = 'XA' THEN 'XA'  
     WHEN dbo.fun_split(c.txtInstrumento,'',1) = 'BPAG91' THEN 'IQ'  
     WHEN dbo.fun_split(c.txtInstrumento,'',1) = 'BPAG28' THEN 'IM'  
    END  
   ELSE  
    CASE   
     WHEN SUBSTRING(f.txtInstrumento,1,2) = 'IP' THEN 'IP'  
     WHEN SUBSTRING(f.txtInstrumento,1,2) = 'IS ' THEN 'IS'  
     WHEN SUBSTRING(f.txtInstrumento,1,2) = 'TP' THEN 'IT'  
     WHEN SUBSTRING(f.txtInstrumento,1,2) = 'LD' THEN 'LD'  
     WHEN SUBSTRING(f.txtInstrumento,1,2) = 'LS' THEN 'LS'       
     WHEN SUBSTRING(f.txtInstrumento,1,2) = 'XA' THEN 'XA'  
     WHEN dbo.fun_split(f.txtInstrumento,'',1) = 'BPAG91' THEN 'IQ'  
     WHEN dbo.fun_split(f.txtInstrumento,'',1) = 'BPAG28' THEN 'IM'  
    END    
  END AS txtInstrumento,   
   c.txtLiquidacion,   
  1 AS intBroker,  
  CASE   
  WHEN RTRIM(c.txtOperacion) = 'B' THEN  
   'COMPRA'  
  WHEN RTRIM(c.txtOperacion) = 'O' THEN  
   'VENTA'  
  END AS txtOperacion,   
  CASE  
   WHEN f.txtLinea IS NULL THEN CAST(c.txtLinea AS INT)   
   ELSE CAST(f.txtLinea AS INT)   
  END AS intLinea,  
  CASE  
   WHEN f.txtMonto IS NULL THEN CAST(c.txtMonto AS FLOAT)  
   ELSE CAST(f.txtMonto AS FLOAT)  
  END AS dblMonto,  
  CASE  
   WHEN f.txtTasa IS NULL THEN CAST(c.txtTasa AS FLOAT)   
   ELSE CAST(f.txtTasa AS FLOAT)   
  END AS dblTasa,  
  CASE  
   WHEN f.txtInicio IS NULL THEN CONVERT(DATETIME,c.txtInicio)   
   ELSE CONVERT(DATETIME,f.txtInicio)  
  END AS dteInicio,  
  CASE   
   WHEN f.txtFin IS NULL THEN '1900-01-01 14:00:00.000'  
   ELSE CONVERT(DATETIME,f.txtFin)   
  END AS dteFin  
 INTO #tmp_tblPosturasEnlace  
 FROM tmp_tblEnlaceOperacionesRev AS c   
 LEFT OUTER JOIN tmp_tblEnlaceOperacionesRev AS f  
 ON   
  c.txtConsecutivo = f.txtConsecutivo  
  AND f.txtFin != '_'  
 WHERE  
  c.txtLiquidacion IN ('48','24','MD')  
  AND RTRIM(c.txtOperacion) IN ('B','O')  
  AND c.txtFin = '_'  
 ORDER BY  
  c.txtConsecutivo  
  
   
 SELECT dteFecha,  
  dteLiquidacion,  
  CASE WHEN intInicio > intFin THEN  
   intFin  
  ELSE  
   intInicio  
  END AS intInicio,  
  CASE WHEN intInicio > intFin THEN  
   intInicio  
  ELSE  
   intFin  
  END AS intFin,  
  txtInstrumento,  
   txtLiquidacion,   
  intBroker,  
  txtOperacion,   
  intLinea,  
  dblMonto,   
  dblTasa,   
  dteInicio,  
  dteFin  
 INTO #tblEnlaceTemp  
 FROM #tmp_tblHechosEnlace  
   
 UNION  
   
 SELECT dteFecha,  
  dteLiquidacion,  
  CASE WHEN intInicio > intFin THEN  
   intFin  
  ELSE  
   intInicio  
  END AS intInicio,  
  CASE WHEN intInicio > intFin THEN  
   intInicio  
  ELSE  
   intFin  
  END AS intFin,  
  txtInstrumento,  
   txtLiquidacion,   
  intBroker,  
  txtOperacion,   
  intLinea,  
  dblMonto,   
  dblTasa,   
  dteInicio,  
  dteFin  
 FROM #tmp_tblPosturasEnlace  
   
  
 UPDATE #tblEnlaceTemp SET dteLiquidacion =@txtMDDate WHERE txtLiquidacion = 'MD'   
 UPDATE #tblEnlaceTemp SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'  
 UPDATE #tblEnlaceTemp SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'  
   
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 1 -- ENLACE  
 AND  txtTv = 'LD'  
   
 --- Insertamos en el destino  
 --- Bondes LD  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  m.dteFecha,  
  m.intBroker,  
  intLinea,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  m.txtOperacion,  
  m.dblTasa,  
  m.dblMonto * 1000000 AS dblMonto,  
  m.dteInicio,  
  m.dteFin,  
  m.txtLiquidacion  
 FROM #tblEnlaceTemp AS m,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
 AND m.txtInstrumento IN ('LD')  
 AND  b.dteMaturity > @txtMDDate  
 AND m.txtLiquidacion IN ('48','MD')  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intInicio  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intInicio )  
 AND (DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intFin )  
  
 ----- elimino los registros de la tabla destino  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 1 -- ENLACE  
   
 --- Todos los demas revisables  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteFecha,  
  intBroker,  
  intInicio,  
  intFin,  
  txtInstrumento,  
  txtOperacion,  
  dblTasa,  
  dblMonto * 1000000 AS dblMonto,  
  dteInicio,  
  dteFin,  
  txtLiquidacion  
 FROM #tblEnlaceTemp  
 WHERE txtInstrumento IN ('LS','XA')  
  
 UNION  
  
 -- cotizaciones en especifico  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto * 1000000 AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tblEnlaceTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON  
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio = m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intInicio    
  
 UNION  
  
 -- cotizaciones en rango  
 SELECT  m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto * 1000000 AS dblMonto,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion  
 FROM #tblEnlaceTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON  
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
  
 -- Registramos flags de cotizaciones  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 1 -- ENLACE  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   m.intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteInicio,  
   m.dteFin,  
   m.txtLiquidacion,  
   STR(m.intInicio) + ' - ' + STR(m.intFin)  
 FROM #tblEnlaceTemp AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b  
   ON  
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IQ','IM')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intInicio <> m.intFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intInicio    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intFin  
  
 SET NOCOUNT OFF  
  
END  
  
--SELECT   
-- *  
--FROM SQLTEST.mxFixincome.dbo.itblMarketPositionsRevi  
--WHERE  
-- txtTv  IN ('IM','IQ')  
-- AND intIdBroker = 1  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];18  
 @txtDate AS VARCHAR(10)  
  
AS  
/*   
 Autor:    ???  
 Creacion:   ???  
 Descripcion:  Elimina y crea la tabla temporal de posturas de Eurobrokers  
  
 Modificado por:  Csolorio  
 Modificacion:  20111116  
 Descripcion:  Cambio el nombre de la tabla  
*/   
BEGIN  
  
 IF EXISTS (  
   SELECT   
    *   
   FROM dbo.sysobjects   
   WHERE   
    id = object_id(N'[dbo].[tmp_tblEurobPosturasRevi]')   
    AND OBJECTPROPERTY(id, N'IsUserTable') = 1)  
  
 DROP TABLE [dbo].[tmp_tblEurobPosturasRevi]  
   
 CREATE TABLE [dbo].[tmp_tblEurobPosturasRevi] (  
  [txtDate] [varchar] (20) ,  
  [txtPlazo] [varchar] (50)  ,  
  [txtOperation] [varchar] (20)  ,  
  [txtRate] [varchar] (20) ,  
  [txtAmount] [varchar] (50) ,  
  [txtBeginHour] [varchar] (20)  ,  
  [txtEndHour] [varchar] (20)    
 ) ON [PRIMARY]  
  
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];19  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga Hechos y Posturas de Eurobrokers  
  
 Modificado por: CSOLORIO  
 Modificacion: 20121217  
 Descripcion:    Modifico para considerar el caso en que el dblamount es null  
*/  
BEGIN  
 SET NOCOUNT ON  
  
 SELECT  CONVERT(DATETIME,txtDate) AS dteDate,  
  CONVERT(DATETIME,txtDate) AS dteLiquidacion,  
  CASE   
   WHEN SUBSTRING(txtPlazo,1,2) = 'IP' THEN  
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-CHARINDEX(' ',txtPlazo))  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
   WHEN SUBSTRING(txtPlazo,1,2) = 'IS' THEN   
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-CHARINDEX(' ',txtPlazo))  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
   WHEN SUBSTRING(txtPlazo,1,2) = 'IM' THEN  
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-CHARINDEX(' ',txtPlazo))  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
   WHEN SUBSTRING(txtPlazo,1,2) = 'IQ' THEN   
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-CHARINDEX(' ',txtPlazo))  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
   WHEN SUBSTRING(txtPlazo,1,2) = 'IT' THEN  
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-CHARINDEX(' ',txtPlazo))  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
   WHEN SUBSTRING(txtPlazo,1,2) = 'LS' THEN  
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-CHARINDEX(' ',txtPlazo))  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
   WHEN SUBSTRING(txtPlazo,1,2) = 'XA' THEN  
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-CHARINDEX(' ',txtPlazo))  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
   WHEN SUBSTRING(txtPlazo,1,2) = 'LD' THEN  
    CASE WHEN CHARINDEX(' ',txtPlazo,4) = 0 THEN  
     SUBSTRING(txtPlazo,4,LEN(txtPlazo)-4)  
    ELSE  
     SUBSTRING(txtPlazo,4,CHARINDEX(' ',txtPlazo,4)-4)  
    END  
  END AS txtPlazo,  
  SUBSTRING(txtPlazo,1,2) AS txtTv,  
  txtOperation,  
  txtRate AS dblRate,  
  txtAmount,  
  txtBeginHour,  
  txtEndHour  
 INTO #tblEuroBrokersPositionsFiltro  
 FROM  tmp_tblEurobPosturasRevi  
 WHERE (txtPlazo LIKE ('%IP%')  
 OR  txtPlazo LIKE ('%IS%')  
 OR  txtPlazo LIKE ('%IT%')  
 OR  txtPlazo LIKE ('%LD%')  
 OR  txtPlazo LIKE ('%LS%')  
 OR  txtPlazo LIKE ('%XA%')  
 OR  txtPlazo LIKE ('%IM%')  
 OR  txtPlazo LIKE ('%IQ%'))  
 AND NOT txtPlazo LIKE '%*%'  
 ORDER BY txtBeginHour  
  
  
 SELECT dteDate,  
  dteLiquidacion,  
  CASE WHEN CHARINDEX('-',txtPlazo) > 0 THEN  
   CAST(SUBSTRING(txtPlazo,1,CHARINDEX('-',txtPlazo)-1) AS INT)  
  ELSE  
   CAST(txtPlazo AS INT)  
  END AS intInicio,  
  CASE WHEN CHARINDEX('-',txtPlazo) > 0 THEN  
   CAST(SUBSTRING(txtPlazo,CHARINDEX('-',txtPlazo)+1,LEN(RTRIM(txtPlazo))-CHARINDEX('-',txtPlazo)) AS INT)  
  ELSE  
   CAST(txtPlazo AS INT)  
  END AS intFin,  
  txtTv,  
  txtOperation,  
  dblRate,  
  
  CASE   
  WHEN CHARINDEX('A',txtAmount) > 0 THEN  
   CASE  
   WHEN txtOperation LIKE '%COMPLETE' THEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('A',txtAmount)-1) AS FLOAT)  
   ELSE  
    CASE   
    WHEN txtTv IN ('IP','IS','IT','LD','LS','XA','IM','IQ') THEN  
     CASE   
     WHEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('A',txtAmount)-1) AS FLOAT) <= 20 THEN  
      CAST(SUBSTRING(txtAmount,1,CHARINDEX('A',txtAmount)-1) AS FLOAT)  
     ELSE  
      0  
     END  
    END  
   END  
  WHEN CHARINDEX('R',txtAmount) > 0 THEN  
   CASE  
   WHEN txtOperation LIKE '%COMPLETE' THEN CAST(SUBSTRING(txtAmount,1,CHARINDEX('R',txtAmount)-1) AS FLOAT)  
   ELSE  
    CASE   
    WHEN txtTv IN ('IP','IS','IT','LD','LS','XA','IM','IQ') THEN  
     CAST(SUBSTRING(txtAmount,1,CHARINDEX('R',txtAmount)-1) AS FLOAT)  
    END  
   END  
  WHEN CHARINDEX('+',txtAmount) > 0 THEN  
   CAST(SUBSTRING(txtAmount,1,CHARINDEX('+',txtAmount)-1) AS FLOAT)  
  WHEN CHARINDEX('-',txtAmount) > 0 THEN  
   CAST(SUBSTRING(txtAmount,1,CHARINDEX('-',txtAmount)-1) AS FLOAT)  
  ELSE  
   CAST(txtAmount AS FLOAT)  
  END AS dblAmount,  
  txtBeginHour,  
  txtEndHour  
 INTO #tblEuroBrokersPositions  
 FROM #tblEuroBrokersPositionsFiltro  
 WHERE    
  txtAmount NOT LIKE '%T%'  
  AND txtAmount IS NOT NULL  
 ORDER BY txtBeginHour  
   
  
 UPDATE  #tblEuroBrokersPositions   
 SET  dteLiquidacion = @txt48Date   
  
 UPDATE #tblEuroBrokersPositions  
 SET  txtEndHour = '14:00:00'  
 WHERE txtEndHour = '00:00:00'  
  
 SELECT  DISTINCT  
  e.dteDate,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
  i.txtTv,  
  CASE   
   WHEN e.txtOperation = 'BID' THEN  
    'COMPRA'  
   WHEN e.txtOperation = 'BID_TRADE' THEN  
    'COMPRA'  
   WHEN e.txtOperation = 'BID_TRADED' THEN  
    'COMPRA'  
   WHEN e.txtOperation = 'OFFER' THEN  
    'VENTA'  
   WHEN e.txtOperation = 'OFFER_TRADE' THEN  
    'VENTA'  
   WHEN e.txtOperation = 'OFFER_TRADED' THEN  
    'VENTA'  
   WHEN e.txtOperation LIKE '%COMPLETE' THEN  
    'HECHO'  
   WHEN e.txtOperation LIKE '%ERROR' THEN   
    'ERROR'  
  END AS txtOperation,  
  e.dblRate,  
  e.dblAmount * 1000000 AS dblAmount,  
  CASE   
   WHEN e.txtOperation LIKE '%COMPLETE' THEN CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME)  
   ELSE CAST(SUBSTRING(e.txtBeginHour,1,8) AS DATETIME)   
  END AS dteBeginHour,  
  CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME) AS dteEndHour,  
  '48' AS txtLiquidation  
 INTO #itblMarketPositions  
 FROM #tblEuroBrokersPositions AS e INNER JOIN tblIds AS i  
  ON e.txtTv = i.txtTv  
  INNER JOIN tblBonds AS b  
  ON b.txtId1 = i.txtId1  
 WHERE  b.dteMaturity >= @txtMDDate  
 AND DATEDIFF(DAY,e.dteLiquidacion,b.dteMaturity) >= e.intInicio-2    
 AND DATEDIFF(DAY,e.dteLiquidacion,b.dteMaturity) <= e.intFin  
 AND e.txtTv = 'LD'  
   
 UNION  
  
 SELECT DISTINCT  
  dteDate,  
  intInicio AS intPlazoIni,  
  intFin AS intPlazoFin,  
  txtTv,  
  CASE   
   WHEN txtOperation = 'BID' THEN  
    'COMPRA'  
   WHEN txtOperation = 'BID_TRADE' THEN  
    'COMPRA'  
   WHEN txtOperation = 'BID_TRADED' THEN  
    'COMPRA'  
   WHEN txtOperation = 'OFFER' THEN  
    'VENTA'  
   WHEN txtOperation = 'OFFER_TRADE' THEN  
    'VENTA'  
   WHEN txtOperation = 'OFFER_TRADED' THEN  
    'VENTA'  
   WHEN txtOperation LIKE '%COMPLETE' THEN  
    'HECHO'  
   WHEN txtOperation LIKE '%ERROR' THEN   
    'ERROR'  
  END AS txtOperation,  
  dblRate,  
  dblAmount * 1000000 AS dblAmount,  
  CASE   
   WHEN txtOperation LIKE '%COMPLETE' THEN CAST(SUBSTRING(txtEndHour,1,8) AS DATETIME)  
   ELSE CAST(SUBSTRING(txtBeginHour,1,8) AS DATETIME)   
  END AS dteBeginHour,  
  CAST(SUBSTRING(txtEndHour,1,8) AS DATETIME) AS dteEndHour,  
  '48' AS txtLiquidation  
 FROM #tblEuroBrokersPositions  
 WHERE txtTv IN ('LS','XA')  
   
 UNION  
  
 SELECT  e.dteDate,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   CASE   
    WHEN e.txtOperation = 'BID' THEN 'COMPRA'  
    WHEN e.txtOperation = 'BID_TRADE' THEN 'COMPRA'  
    WHEN e.txtOperation = 'BID_TRADED' THEN 'COMPRA'  
    WHEN e.txtOperation = 'OFFER' THEN 'VENTA'  
    WHEN e.txtOperation = 'OFFER_TRADE' THEN 'VENTA'  
    WHEN e.txtOperation = 'OFFER_TRADED' THEN 'VENTA'  
    WHEN e.txtOperation LIKE '%COMPLETE' THEN 'HECHO'  
    WHEN e.txtOperation LIKE '%ERROR' THEN 'ERROR'  
   END AS txtOperation,  
   e.dblRate,  
   e.dblAmount * 1000000 AS dblAmount,  
   CASE   
    WHEN e.txtOperation LIKE '%COMPLETE' THEN CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME)  
    ELSE CAST(SUBSTRING(e.txtBeginHour,1,8) AS DATETIME)   
   END AS dteBeginHour,  
   CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME) AS dteEndHour,  
   '48' AS txtLiquidation  
 FROM #tblEuroBrokersPositions AS e   
   INNER JOIN tblIds AS i (NOLOCK)  
   ON   
    e.txtTv = i.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE  b.dteMaturity >= @txtMDDate  
   AND e.intInicio = e.intFin  
   AND DATEDIFF(day,@txt48Date,b.dteMaturity) = e.intInicio  
   AND e.txtTv IN ('IP','IS','IT','IM','IQ')  
      
 UNION  
  
 SELECT  e.dteDate,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   CASE   
    WHEN e.txtOperation = 'BID' THEN 'COMPRA'  
    WHEN e.txtOperation = 'BID_TRADE' THEN 'COMPRA'  
    WHEN e.txtOperation = 'BID_TRADED' THEN 'COMPRA'  
    WHEN e.txtOperation = 'OFFER' THEN 'VENTA'  
    WHEN e.txtOperation = 'OFFER_TRADE' THEN 'VENTA'  
    WHEN e.txtOperation = 'OFFER_TRADED' THEN 'VENTA'  
    WHEN e.txtOperation LIKE '%COMPLETE' THEN 'HECHO'  
    WHEN e.txtOperation LIKE '%ERROR' THEN 'ERROR'  
   END AS txtOperation,  
   e.dblRate,  
   e.dblAmount * 1000000 AS dblAmount,  
   CASE   
    WHEN e.txtOperation LIKE '%COMPLETE' THEN CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME)  
    ELSE CAST(SUBSTRING(e.txtBeginHour,1,8) AS DATETIME)   
   END AS dteBeginHour,  
   CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME) AS dteEndHour,  
   '48' AS txtLiquidation  
 FROM #tblEuroBrokersPositions AS e   
   INNER JOIN tblIds AS i (NOLOCK)  
   ON   
    e.txtTv = i.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE  b.dteMaturity >= @txtMDDate  
   AND e.intInicio <> e.intFin  
   AND DATEDIFF(day,@txt48Date,b.dteMaturity) > e.intInicio  
   AND DATEDIFF(day,@txt48Date,b.dteMaturity) <= e.intFin  
   AND e.txtTv IN ('IP','IS','IT','IM','IQ')  
  
 -- Quito aquellos hechos con error  
  
 DELETE m  
 FROM #itblMarketPositions m  
 INNER JOIN #itblMarketPositions e  
 ON  
  m.intPlazoIni = e.intPlazoIni  
  AND m.intPlazoFin = e.intPlazoFin  
  AND m.txtTv = e.txtTv  
  AND m.dteEndHour = e.dteBeginHour  
 WHERE   
  e.txtOperation LIKE '%ERROR'  
  AND m.txtOperation LIKE '%COMPLETE'  
  
  
 -- Eliminamos la información de la tabla destino  
 DELETE  
 FROM  itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 2  
 AND txtTv = 'LD'  
   
 --- Solo Bondes D  
 INSERT  itblMarketPositions  
  
 SELECT  DISTINCT  
  dteDate,  
  2 AS intBroker,  
  -999 AS intLine,  
  intPlazoIni,  
  txtTv,  
  txtOperation,  
  dblRate,  
  dblAmount,  
  dteBeginHour,  
  dteEndHour,  
  txtLiquidation  
 FROM #itblMarketPositions  
 WHERE   
  txtTv = 'LD'  
  AND dblAmount IS NOT NULL  
  AND txtOperation != 'ERROR'  
  
 -- Eliminamos la información de la tabla destino  
 DELETE  
 FROM  itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 2  
  
 --- Todos los demas revisables  
 INSERT  itblMarketPositionsRevi  
 SELECT  DISTINCT  
  dteDate,  
  2 AS intBroker,  
  intPlazoIni,  
  intPlazoFin,  
  txtTv,  
  txtOperation,  
  dblRate,  
  dblAmount,  
  dteBeginHour,  
  dteEndHour,  
  txtLiquidation  
 FROM #itblMarketPositions  
 WHERE   
  txtTv != 'LD'  
  AND dblAmount IS NOT NULL  
  AND txtOperation != 'ERROR'  
  
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 2  
  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   e.dteDate,  
   2 AS intBroker,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   CASE   
    WHEN e.txtOperation = 'BID' THEN 'COMPRA'  
    WHEN e.txtOperation = 'BID_TRADE' THEN 'COMPRA'  
    WHEN e.txtOperation = 'BID_TRADED' THEN 'COMPRA'  
    WHEN e.txtOperation = 'OFFER' THEN 'VENTA'  
    WHEN e.txtOperation = 'OFFER_TRADE' THEN 'VENTA'  
    WHEN e.txtOperation = 'OFFER_TRADED' THEN 'VENTA'  
    WHEN e.txtOperation LIKE '%COMPLETE' THEN 'HECHO'  
   END AS txtOperation,  
   CASE   
    WHEN e.txtOperation LIKE '%COMPLETE' THEN CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME)  
    ELSE CAST(SUBSTRING(e.txtBeginHour,1,8) AS DATETIME)   
   END AS dteBeginHour,  
   CAST(SUBSTRING(e.txtEndHour,1,8) AS DATETIME) AS dteEndHour,  
   '48' AS txtLiquidation,  
   STR(e.intInicio) + ' - ' + STR(e.intFin)  
 FROM #tblEuroBrokersPositions AS e   
   INNER JOIN tblIds AS i (NOLOCK)  
   ON   
    e.txtTv = i.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE  b.dteMaturity >= @txtMDDate  
   AND e.intInicio <> e.intFin  
   AND DATEDIFF(day,@txt48Date,b.dteMaturity) > e.intInicio  
   AND DATEDIFF(day,@txt48Date,b.dteMaturity) <= e.intFin  
   AND e.txtTv IN ('IP','IS','IT','IM','IQ')  
  
 SET NOCOUNT OFF  
  
END   
  
  
-- EuroBrokers HEchos  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];20  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblEurobHechosRev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblEurobHechosRev]  
   
   
 CREATE TABLE [dbo].[tmp_tblEurobHechosRev] (  
  [txtDate] [varchar] (20) ,  
  [txtLiquidacion] [varchar] (20) ,  
  [txtTv] [varchar] (5) ,  
  [txtInicio] [varchar] (50) ,  
  [txtFinal] [varchar] (50) ,  
  [txtOperation] [varchar] (20)  ,  
  [txtAmount] [varchar] (20) ,  
  [txtRate] [varchar] (20) ,  
  [txtHour] [varchar] (20)  
 ) ON [PRIMARY]  
   
   
  
END  
  
CREATE PROCEDURE dbo.sp_inputs_brokers_revisables;21  
 @txtDate AS VARCHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
  
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Carga los Hechos de Eurobrokers  
  
 Modificado por: PONATE  
 Modificacion: 20120427  
 Descripcion:    Modifico para agregar Ipabonos  
*/  
BEGIN  
  
 SET NOCOUNT ON  
  
 -- Eliminamos la infromación de la tabla destino  
 DELETE  
 FROM  itblMarketPositions  
 WHERE dteDate = @txtDate  
 AND  intIdBroker = 2  
 AND  txtOperation IN ('HECHO')  
 AND txtTv = 'LD'  
  
 --- Insertamos en la tabla destino  
 --- Bondes D  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
  CONVERT(DATETIME,e.txtDate) AS dteDate,  
  2 AS intBroker,  
  -999 AS intLine,  
  DATEDIFF(DAY,@txtDate,b.dteMaturity) AS intPlazo,  
  i.txtTv,  
  CASE WHEN e.txtOperation = 'D' THEN  
   'HECHO'  
  ELSE   
   'HECHO'  
  END AS txtOperation,  
  CAST(e.txtRate AS FLOAT) AS dblRate,  
  CAST(e.txtAmount AS FLOAT) AS dblAmount,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteBeginHour,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteEndHour,  
  CASE   
  WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txtDate THEN  
   'MD'  
  WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date THEN  
   '48'  
  END AS txtLiquidation  
 FROM  tmp_tblEurobHechosRev AS e,  
  tblIds AS i INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  b.dteMaturity > CONVERT(DATETIME,e.txtDate)  
 AND CAST(e.txtInicio AS INT) = DATEDIFF(DAY,CONVERT(DATETIME,e.txtLiquidacion),b.dteMaturity)  
 AND CAST(e.txtFinal AS INT) = DATEDIFF(DAY,CONVERT(DATETIME,e.txtLiquidacion),b.dteMaturity)  
 AND i.txtTv IN ('LD')  
 AND e.txtTv IN ('LD')  
 AND (  
   CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date  
   OR CONVERT(DATETIME,e.txtLiquidacion) = @txtDate  
  )  
  
 -- Eliminamos la infromación de la tabla destino  
 DELETE  
 FROM  itblMarketPositionsRevi  
 WHERE dteDate = @txtDate  
 AND  intIdBroker = 2  
 AND  txtOperation IN ('HECHO')  
  
   
 --- Insertamos en la tabla destino  
 --- Todos los demas revisables  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
  CONVERT(DATETIME,txtDate) AS dteDate,  
  2 AS intBroker,  
  CAST(txtInicio AS INT) AS intInicio,  
  CAST(txtFinal AS INT) AS intFinal,  
  txtTv,  
  'HECHO' AS txtOperation,  
  CAST(txtRate AS FLOAT) AS dblRate,  
  CAST(txtAmount AS FLOAT) AS dblAmount,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHour AS FLOAT) AS DATETIME)) AS dteBeginHour,  
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHour AS FLOAT) AS DATETIME)) AS dteEndHour,  
  '48' AS txtLiquidation  
 FROM  tmp_tblEurobHechosRev  
 WHERE  txtTv IN ('LS','XA')  
 AND CONVERT(DATETIME,txtLiquidacion) = @txt48Date  
  
 UNION  
  
 -- cotizaciones en especifico  
 SELECT  CONVERT(DATETIME,e.txtDate) AS dteDate,  
   2 AS intBroker,  
   DATEDIFF(DAY,@txtDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(DAY,@txtDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   CASE   
    WHEN e.txtOperation = 'D' THEN 'HECHO'  
    ELSE 'HECHO'  
   END AS txtOperation,  
   CAST(e.txtRate AS FLOAT) AS dblRate,  
   CAST(e.txtAmount AS FLOAT) AS dblAmount,  
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteBeginHour,  
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteEndHour,  
   CASE   
    WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txtDate THEN 'MD'  
    WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date THEN '48'  
   END AS txtLiquidation  
 FROM  tmp_tblEurobHechosRev AS e  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = e.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    i.txtId1 = b.txtId1  
 WHERE  b.dteMaturity > CONVERT(DATETIME,e.txtDate)  
   AND CAST(e.txtInicio AS INT) = CAST(e.txtFinal AS INT)  
   AND CAST(e.txtInicio AS INT) = DATEDIFF(DAY,CONVERT(DATETIME,e.txtLiquidacion),b.dteMaturity)  
   AND e.txtTv IN ('IP','IS','IT','IM','IQ')  
   AND CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date  
    
 UNION  
  
 -- cotizaciones en rango  
 SELECT  CONVERT(DATETIME,e.txtDate) AS dteDate,  
   2 AS intBroker,  
   DATEDIFF(DAY,@txtDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(DAY,@txtDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   CASE   
    WHEN e.txtOperation = 'D' THEN 'HECHO'  
    ELSE 'HECHO'  
   END AS txtOperation,  
   CAST(e.txtRate AS FLOAT) AS dblRate,  
   CAST(e.txtAmount AS FLOAT) AS dblAmount,  
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteBeginHour,  
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteEndHour,  
   CASE   
    WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txtDate THEN 'MD'  
    WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date THEN '48'  
   END AS txtLiquidation  
 FROM  tmp_tblEurobHechosRev AS e  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = e.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    i.txtId1 = b.txtId1  
 WHERE  b.dteMaturity > CONVERT(DATETIME,e.txtDate)  
   AND CAST(e.txtInicio AS INT) <> CAST(e.txtFinal AS INT)  
   AND CAST(e.txtInicio AS INT) < DATEDIFF(DAY,CONVERT(DATETIME,e.txtLiquidacion),b.dteMaturity)  
   AND CAST(e.txtFinal AS INT) >= DATEDIFF(DAY,CONVERT(DATETIME,e.txtLiquidacion),b.dteMaturity)  
   AND e.txtTv IN ('IP','IS','IT','IM','IQ')  
   AND CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date  
  
 -- Registramos flags de cotizaciones  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtDate  
   AND intIdBroker = 2  
   AND txtOperation IN ('HECHO')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   CONVERT(DATETIME,e.txtDate) AS dteDate,  
   2 AS intBroker,  
   DATEDIFF(DAY,@txtDate,b.dteMaturity),  
   i.txtTv,  
   CASE   
    WHEN e.txtOperation = 'D' THEN 'HECHO'  
    ELSE 'HECHO'  
   END AS txtOperation,  
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteBeginHour,  
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(e.txtHour AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(e.txtHour AS FLOAT) AS DATETIME)) AS dteEndHour,  
   CASE   
    WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txtDate THEN 'MD'  
    WHEN CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date THEN '48'  
   END AS txtLiquidation,  
   e.txtInicio + ' - ' + e.txtFinal  
 FROM  tmp_tblEurobHechosRev AS e  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = e.txtTv  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    i.txtId1 = b.txtId1  
 WHERE  b.dteMaturity > CONVERT(DATETIME,e.txtDate)  
   AND CAST(e.txtInicio AS INT) <> CAST(e.txtFinal AS INT)  
   AND CAST(e.txtInicio AS INT) < DATEDIFF(DAY,CONVERT(DATETIME,e.txtLiquidacion),b.dteMaturity)  
   AND CAST(e.txtFinal AS INT) >= DATEDIFF(DAY,CONVERT(DATETIME,e.txtLiquidacion),b.dteMaturity)  
   AND e.txtTv IN ('IP','IS','IT','IM','IQ')  
   AND CONVERT(DATETIME,e.txtLiquidacion) = @txt48Date  
     
 SET NOCOUNT OFF  
   
  
END  
  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];22  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 /*   
 Autor:   Salvador Sosa  
 Creacion:  2010-08-17  
 Descripcion:    Crea tabla temporal para la carga de posturas de MEI  
 */  
  
 SET NOCOUNT ON  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblMEIPosturas_Rev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblMEIPosturas_Rev]  
   
   
 CREATE TABLE [dbo].[tmp_tblMEIPosturas_Rev](  
  [txtDate] [varchar](50) NULL,  
  [txtPlazo] [varchar](20) NULL,  
  [txtInstrumento] [varchar](50) NULL,  
  [txtLiquidacion] [varchar](20) NULL,  
  [txtOperacion] [varchar](25) NULL,  
  [txtMonto] [varchar](20) NULL,  
  [txtTasa] [varchar](20) NULL,  
  [txtHoraIni] [varchar](50) NULL,  
  [txtHoraFin] [varchar](50) NULL  
 ) ON [PRIMARY]  
  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];23  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
BEGIN  
  
/*   
 Autor:   Salvador Sosa  
 Creacion:  2010-08-17  
 Descripcion:    Carga de posturas de MEI  
  
 Modificado por: PONATE  
 Modificacion: 20120425  
 Descripcion:    Ajuste para IPABONOS  
*/  
  
 SET NOCOUNT ON  
  
 SELECT DISTINCT  
   CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteFecha,  
   CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteLiquidacion,  
   CASE  
    WHEN CHARINDEX('-',txtInstrumento,1) > 0 THEN CAST(REPLACE(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',2),'-',1),'*','') AS INT)  
    ELSE CAST(REPLACE(txtPlazo,'*','') AS INT)  
   END AS intPlazoIni,  
   CASE  
    WHEN CHARINDEX('-',txtInstrumento,1) > 0 THEN CAST(REPLACE(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',2),'-',2),'*','') AS INT)  
    ELSE CAST(REPLACE(txtPlazo,'*','') AS INT)  
   END AS intPlazoFin,   
   SUBSTRING(txtInstrumento,1,CHARINDEX(' ',txtInstrumento)-1) AS txtInstrumento,  
   txtLiquidacion,   
   CASE WHEN txtOperacion = 'Vendedor' THEN  
    'VENTA'  
   ELSE  
    'COMPRA'  
   END AS txtOperacion,   
   CAST(txtMonto AS FLOAT) AS dblMonto,   
   CAST(txtTasa AS FLOAT) AS dblTasa,   
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHoraIni AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHoraIni AS FLOAT) AS DATETIME)) AS dteHoraIni,  
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHoraFin AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHoraFin AS FLOAT) AS DATETIME)) AS dteHoraFin  
 INTO #tmp_tblMEIPosturas_Rev  
 FROM tmp_tblMEIPosturas_Rev  
 WHERE txtInstrumento not like ('%SWP%')  
   AND txtInstrumento not like ('%PRUEB%')  
   AND txtInstrumento not like ('%CASI%')  
   AND txtInstrumento not like ('%AMX%')  
   AND txtInstrumento not like ('%CFE%')  
   AND txtInstrumento not like ('%METRO%')  
   AND txtInstrumento not like ('%PAT%')  
   AND txtInstrumento not like ('%PMX%')  
   AND txtInstrumento not like ('% SP')  
   AND  
   (  
    txtInstrumento LIKE '%IP%'   
    OR txtInstrumento LIKE '%IS%'   
    OR txtInstrumento LIKE '%LD%'  
    OR txtInstrumento LIKE '%IT%'  
    OR txtInstrumento LIKE '%IM%'  
    OR txtInstrumento LIKE '%IQ%'  
   )  
  
  
 UPDATE #tmp_tblMEIPosturas_Rev  
 SET  dteHoraFin = '1900-01-01 14:00:00.000'  
 WHERE dteHoraFin IS NULL  
  
 UPDATE #tmp_tblMEIPosturas_Rev  
 SET  dteLiquidacion = @txt24Date  
 WHERE txtLiquidacion = '24'  
  
 UPDATE #tmp_tblMEIPosturas_Rev  
 SET  dteLiquidacion = @txt48Date  
 WHERE txtLiquidacion = '48'  
   
 ----- elimino los registros de la tabla  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 5 -- MEI  
 AND  txtOperation IN ('COMPRA','VENTA')  
 AND txtTv in ('LD')  
  
  
 --- Insertamos en el destino  
 --- Solo Bondes LD  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
   m.dteFecha,  
   5,  
   -999 AS intLinea,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto,  
   m.dteHoraIni,  
   m.dteHoraFin,  
   m.txtLiquidacion  
 FROM #tmp_tblMEIPosturas_Rev AS m,  
   tblIds AS i   
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
   AND m.txtInstrumento LIKE ('%LD%')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48','MD')  
   AND   
   (  
    DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intPlazoIni  
    OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intPlazoIni  
   )  
   AND   
   (  
    DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intPlazoFin  
    OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intPlazoFin  
   )  
   
   
 ----- elimino los registros de la tabla  
 ----- destino pero solo los Tv LD  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 5 -- MEI  
   AND txtOperation IN ('COMPRA','VENTA')  
   AND txtTv IN ('IP','IS','IT','LS','XA','IM','IQ')  
  
 --- Insertamos en el destino  
 --- Todos Excepto Bondes LD  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
   dteFecha,  
   5,  
   intPlazoIni,  
   intPlazoFin,  
   txtInstrumento,  
   txtOperacion,  
   dblTasa,  
   dblMonto,  
   dteHoraIni,  
   dteHoraFin,  
   txtLiquidacion  
 FROM #tmp_tblMEIPosturas_Rev  
 WHERE txtInstrumento IN ('LS','XA')  
   AND txtLiquidacion IN ('48')  
  
 UNION  
  
 -- Cotizaciones en especifico  
 SELECT  m.dteFecha,  
   5,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto,  
   m.dteHoraIni,  
   m.dteHoraFin,  
   m.txtLiquidacion  
 FROM #tmp_tblMEIPosturas_Rev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intPlazoIni = m.intPlazoIni  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intPlazoIni   
  
 UNION  
  
 -- Cotizaciones en rango  
 SELECT  m.dteFecha,  
   5,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto,  
   m.dteHoraIni,  
   m.dteHoraFin,  
   m.txtLiquidacion  
 FROM #tmp_tblMEIPosturas_Rev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intPlazoIni <> m.intPlazoFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intPlazoIni  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intPlazoFin  
  
  
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 5 -- MEI  
   AND txtOperation IN ('COMPRA','VENTA')  
   AND txtTv IN ('IP','IS','IT','IM','IQ')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   5,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteHoraIni,  
   m.dteHoraFin,  
   m.txtLiquidacion,  
   STR(m.intPlazoIni) + ' - ' + STR(m.intPlazoFin)  
 FROM #tmp_tblMEIPosturas_Rev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intPlazoIni <> m.intPlazoFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intPlazoIni    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intPlazoFin   
  
END  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];24  
 @txtDate AS VARCHAR(10)  
  
AS   
BEGIN  
  
 /*   
 Autor:   Salvador Sosa  
 Creacion:  2010-08-17  
 Descripcion:    Crea tabla temporal para la carga de hechos de MEI  
 */  
  
 SET NOCOUNT ON  
  
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblMEIHechos_Rev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblMEIHechos_Rev]  
   
 CREATE TABLE [dbo].[tmp_tblMEIHechos_Rev](  
  [txtDate] [varchar](50) NULL,  
  [txtPlazo] [varchar](20) NULL,  
  [txtInstrumento] [varchar](50) NULL,  
  [txtLiquidacion] [varchar](20) NULL,  
  [txtOperacion] [varchar](25) NULL,  
  [txtMonto] [varchar](20) NULL,  
  [txtTasa] [varchar](20) NULL,  
  [txtHora] [varchar](50) NULL,  
  [txtRest] [VARCHAR] (3),    
 ) ON [PRIMARY]  
  
END  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];25  
 @txtMDDate  AS CHAR(10),  
 @txt24Date  AS CHAR(10),  
 @txt48Date  AS CHAR(10)  
  
AS   
BEGIN  
  
 /*   
 Autor:   Salvador Sosa  
 Creacion:  2010-08-17  
 Descripcion:    Carga de hechos de MEI  
  
 Modificado por: PONATE  
 Modificacion: 20120425  
 Descripcion:    Ajuste para Ipabonos  
 */  
  
 SELECT DISTINCT  
   CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteFecha,  
   CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteLiquidacion,  
   CASE  
    WHEN CHARINDEX('-',txtInstrumento,1) > 0 THEN CAST(REPLACE(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',2),'-',1),'*','') AS INT)  
    ELSE CAST(REPLACE(txtPlazo,'*','') AS INT)  
   END AS intPlazoIni,  
   CASE  
    WHEN CHARINDEX('-',txtInstrumento,1) > 0 THEN CAST(REPLACE(dbo.fun_Split(dbo.fun_Split(txtInstrumento,' ',2),'-',2),'*','') AS INT)  
    ELSE CAST(REPLACE(txtPlazo,'*','') AS INT)  
   END AS intPlazoFin,   
   SUBSTRING(txtInstrumento,1,CHARINDEX(' ',txtInstrumento)-1) AS txtInstrumento,  
   txtLiquidacion,   
   'HECHO' AS txtOperacion,   
   CAST(txtMonto AS FLOAT) AS dblMonto,   
   CAST(txtTasa AS FLOAT) AS dblTasa,   
   DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHora AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHora AS FLOAT) AS DATETIME)) AS dteHora  
 INTO #tmp_tblMEIHechos_Rev  
 FROM tmp_tblMEIHechos_Rev  
 WHERE txtInstrumento not like ('%SWP%')  
   AND txtInstrumento not like ('%PRUEB%')  
   AND txtInstrumento not like ('%CASI%')  
   AND txtInstrumento not like ('%AMX%')  
   AND txtInstrumento not like ('%CFE%')  
   AND txtInstrumento not like ('%METRO%')  
   AND txtInstrumento not like ('%PAT%')  
   AND txtInstrumento not like ('%PMX%')  
   AND txtInstrumento not like ('% SP')  
   AND  
   (  
    txtInstrumento LIKE '%IP%'   
    OR txtInstrumento LIKE '%IS%'   
    OR txtInstrumento LIKE '%LD%'  
    OR txtInstrumento LIKE '%IT%'  
    OR txtInstrumento LIKE '%IM%'  
    OR txtInstrumento LIKE '%IQ%'  
   )  
  
 UPDATE #tmp_tblMEIHechos_Rev  
 SET  dteHora = '1900-01-01 14:00:00.000'  
 WHERE dteHora IS NULL  
  
 UPDATE #tmp_tblMEIHechos_Rev  
 SET  dteLiquidacion = @txt24Date  
 WHERE txtLiquidacion = '24'  
  
 UPDATE #tmp_tblMEIHechos_Rev  
 SET  dteLiquidacion = @txt48Date  
 WHERE txtLiquidacion = '48'  
   
 ----- elimino los registros de la tabla  
 DELETE  
 FROM itblMarketPositions  
 WHERE dteDate = @txtMDDate  
 AND  intIdBroker = 5 -- MEI  
 AND  txtOperation = 'HECHO'  
 AND txtTv in ('LD')  
  
  
 --- Insertamos en el destino  
 --- Solo Bondes LD  
 INSERT itblMarketPositions  
 SELECT  DISTINCT  
   m.dteFecha,  
   5,  
   -999 AS intLinea,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto,  
   m.dteHora,  
   m.dteHora,  
   m.txtLiquidacion  
 FROM #tmp_tblMEIHechos_Rev AS m,  
   tblIds AS i   
   INNER JOIN tblBonds AS b  
   ON   
    b.txtId1 = i.txtId1  
 WHERE i.txtTv IN ('LD')  
   AND m.txtInstrumento LIKE ('%LD%')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48','MD')  
   AND   
   (  
    DATEDIFF(DAY,@txt48Date,b.dteMaturity) >= m.intPlazoIni  
    OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) >= m.intPlazoIni  
   )  
   AND   
   (  
    DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intPlazoFin  
    OR DATEDIFF(DAY,@txtMDDate,b.dteMaturity) <= m.intPlazoFin  
   )  
   
   
 ----- elimino los registros de la tabla  
 ----- destino pero solo los Tv LD  
 DELETE  
 FROM itblMarketPositionsRevi  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 5 -- MEI  
   AND txtOperation = 'HECHO'  
   AND txtTv IN ('IP','IS','IT','LS','XA','IQ','IR')  
  
 --- Insertamos en el destino  
 --- Todos Excepto Bondes LD  
 INSERT itblMarketPositionsRevi  
 SELECT  DISTINCT  
   dteFecha,  
   5,  
   intPlazoIni,  
   intPlazoFin,  
   txtInstrumento,  
   txtOperacion,  
   dblTasa,  
   dblMonto,  
   dteHora,  
   dteHora,  
   txtLiquidacion  
 FROM #tmp_tblMEIHechos_Rev  
 WHERE txtInstrumento IN ('LS','XA')  
   AND txtLiquidacion IN ('48')  
  
 UNION  
  
 -- Cotizaciones en especifico  
 SELECT  m.dteFecha,  
   5,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto,  
   m.dteHora,  
   m.dteHora,  
   m.txtLiquidacion  
 FROM #tmp_tblMEIHechos_Rev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intPlazoIni = m.intPlazoIni  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) = m.intPlazoIni   
  
 UNION  
  
 -- Cotizaciones en rango  
 SELECT  m.dteFecha,  
   5,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoIni,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazoFin,  
   i.txtTv,  
   m.txtOperacion,  
   m.dblTasa,  
   m.dblMonto,  
   m.dteHora,  
   m.dteHora,  
   m.txtLiquidacion  
 FROM #tmp_tblMEIHechos_Rev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento   
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intPlazoIni <> m.intPlazoFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intPlazoIni  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intPlazoFin  
  
  
 -- Registramos nodos que cotizaron en rango  
   
 DELETE  
 FROM itblMarketReviRangeNodes  
 WHERE dteDate = @txtMDDate  
   AND intIdBroker = 5 -- MEI  
   AND txtOperation = 'HECHO'  
   AND txtTv IN ('IP','IS','IT','IM','IQ')  
  
 INSERT itblMarketReviRangeNodes  
   (  
    dteDate,  
    intIdBroker,  
    intTerm,  
    txtTv,  
    txtOperation,  
    dteBeginHour,  
    dteEndHour,  
    txtLiquidation,  
    txtTermRange  
   )  
 SELECT  DISTINCT  
   m.dteFecha,  
   5,  
   DATEDIFF(day,@txtMDDate,b.dteMaturity),  
   i.txtTv,  
   m.txtOperacion,  
   m.dteHora,  
   m.dteHora,  
   m.txtLiquidacion,  
   STR(m.intPlazoIni) + ' - ' + STR(m.intPlazoFin)  
 FROM #tmp_tblMEIHechos_Rev AS m  
   INNER JOIN tblIds AS i (NOLOCK)  
   ON  
    i.txtTv = m.txtInstrumento  
   INNER JOIN tblBonds AS b (NOLOCK)  
   ON   
    b.txtId1 = i.txtId1  
 WHERE m.txtInstrumento IN ('IP','IS','IT','IM','IQ')  
   AND b.dteMaturity > @txtMDDate  
   AND m.txtLiquidacion IN ('48')  
   AND m.intPlazoIni <> m.intPlazoFin  
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) > m.intPlazoIni    
   AND DATEDIFF(DAY,@txt48Date,b.dteMaturity) <= m.intPlazoFin   
  
END  
  
  
  
  
CREATE PROCEDURE [dbo].[sp_inputs_brokers_revisables];26  
 @txtDate AS CHAR(10)  
AS   
/*   
 Autor:   Carlos Solorio  
 Creacion:  20110111  
 Descripcion: Para crear la tabla temporal de SIF Hechos  
  
 Modificado por:   
 Modificacion:   
 Descripcion:      
*/  
  
BEGIN  
   
 if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tmp_tblSifHechosRev]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)  
 drop table [dbo].[tmp_tblSifHechosRev]  
   
 CREATE TABLE [dbo].[tmp_tblSifHechosRev] (  
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
  