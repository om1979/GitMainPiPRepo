  
  
/*  
 Version: 4.1  
  
 Procedimiento para obtener los datos de los   
 productos de JPMORGAN  
  
 Creador: Josefina Renteria  
  
 V4.0.1 CSOLORIO 20100205  
 Modifico el modulo 12 para que ordene por el campo intSection  
  
 v4.0.0 Lic. René López Salinas (11:56 a.m. 2009-10-24)  
 Agrego el modulo 15: Para generar producto JPMorgan_TC_aaaammdd.txt  
  
 v3.0.0 Lic. René López Salinas (12:44 p.m. 2009-10-01)  
 Agrego el modulo 13: Para generar producto LiborIRS_YYYYMMDD.xls  
 Agrego el modulo 14: Para generar producto TIIEIRS_YYYYMMDD.xls  
   
 v2.8.0 Lic. René López Salinas (03:42 p.m. 2009-08-04)  
 Modificación: Modulo 12, Agrego función dbo.fun_get_curve_complete para obtener información de curvas  
     con todos los plazos, interpolando aquellos plazos que no se encuentren en el rango  
     de la curva  
  
 v2.7.2 Lic. René López Salinas (05:03 p.m. 2009-07-29)  
 Modificación: Modulo 12: Modificación de la formula en la columna "ValorFactorDescuento"  
  
 v2.7.1 Lic. René López Salinas (06:07 p.m. 2009-05-26)  
 Modificación: Modulo 12: Agrego parametro @dblFactor para obtener en otra base el Valor Tasa  
  
 v2.7.0 Lic. René López Salinas (05:20 p.m. 2009-05-18)  
 Agrego el modulo 12: Para generar el paquete de curvas 2  
 con los productos: PiP_udlb_aaaammdd.txt, PiP_imp_aaaammdd.txt,PiP_lib_aaaammdd.txt,PiP_irs_aaaammdd.txt,PiP_cirs_aaaammdd.txt  
  
 v2.6.1 Lic. René López Salinas (041:05 p.m. 2009-02-11)  
 Modifique el modulo 7: Modificación del calculo, de curva de JP Morgan: 1 / ( 1 + ( Tasa / 100 / 360 ) * Periodo )  
 para generar nuevo producto pip_fw2_aaaammdd.txt  
  
 v2.6.0 Lic. René López Salinas (01:30 p.m. 2009-02-03)  
 Modifique el modulo 7: Cambio de parametro de curva FW2 - para generar nuevo producto pip_fw2_aaaammdd.txt  
  
 v2.5.0 Lic. René López Salinas (12:44 p.m. 2009-01-19)  
 Modifique el modulo 6: Agrego directivas de nodos de curva LIB/LB   
 en los plazos 1,7,15,30,60,90,180,360,520,720,1090,1450,1800,3600,5400,7200,10800  
  
 v2.4.0 Lic. René López Salinas (01:26 p.m. 2009-01-14)  
 Modifique el modulo 7: Agrego parametro de curva FW2 - para generar nuevo producto pip_fw2_aaaammdd.txt  
  
 v2.3.0 Lic. René López Salinas (03:07 p.m. 2008-10-03)  
 Agrego el modulo 11: Para Generar Producto: JPMorgan_aaaammdd.xls  
  
 v2.2.0 Lic. René López Salinas (02:16 p.m. 2008-09-05)  
 Modifique los modulos 5 y 6: Cambio tblForwards por ->  MxFixIncome.dbo.vw_markets_fwd  
  
 v2.0.1 Lic. René López Salinas (01:10 p.m. 2008-03-27)  
 Modifique el modulo 7: Cambio en 4 identificadores  
  
 v2.0.0 Lic. René López Salinas (12:44 p.m. 2008-01-16)  
 AGREGUE el modulo 10: Para extraer las directivas y generar el conjunto de archivos de curvas formato pagina WEB (Version PiP 2006)  
  
 v1.9.2 Lic. René López Salinas (12:52 p.m. 2008-01-11)  
 Modifique el modulo 8: Cambio el parametro de Nodo Máximo de la curva LIB-LB Generalizado -999  
    con esto ya no considera a que plazo    
  
 v1.9.1 Lic. René López Salinas (12:39 p.m. 2008-01-08)  
 Modifique el modulo 8: Cambio el parametro de Nodo Máximo de la curva LIB-LB de 10920 por 11315   
  
 v1.9 Lic. René López Salinas (02:02 p.m. 2008-01-07)  
 Modifique el modulo 8: Agrego 2 Nuevas directivas para obtener información de curvas  
    TSN-YLD; TSN-YTS  
  
 v1.8 Lic. René López Salinas (02:35 p.m. 2007-10-31)  
 Modifique directiva de extracción de la curva de libor en el   
              modulo 8 para ampliar el rango de extracción en la curva LIB/LB de 5475 -> 10920  
  
 v1.7 Lic. René López Salinas (01:25 p.m. 2007-08-31)  
 Modifique el modulo 5 Elimino directivas de obtención de las curvas Libor EUR y Libor GBP  
  
 v1.6 Lic. René López Salinas (01:21 p.m. 2007-08-27)  
 Modifique el modulo 8 para ampliar el rango de extracción en la curva SWP/TI de 5475 -> 10961  
  
 v1.5 Lic. René López Salinas (06:40 p.m. 2007-05-09)  
 Modifique el modulo 7 para extraer las curvas  
  pip_uTi1_aaaammdd.txt Udi/TIIE tasa Swap   (Expresado en Tasa)  
  pip_uTi2_aaaammdd.txt Udi/TIIE tasa Swap   (Expresado en Precio)  
  pip_uLi1_aaaammdd.txt   Udi/Libor tasa Swap  (Expresado en Tasa)  
  pip_uLi2_aaaammdd.txt   Udi/Libor tasa Swap  (Expresado en Precio)  
   
  
 v1.4 JATO (03:08 p.m. 2006-10-25)  
 Modifique el modulo 6 para extraer el nodo de 30 anios  
 de la curva de yield de bonos  
  
 v1.3 JATO (04:57 p.m. 2006-07-25)  
 Elimine la curva BDE/LT  
  
 v1.2 JATO (12:10 a.m. 2006-07-13)  
 Agregue los modulos 5, 6, 7, 8, 9 para la generacion  
 de factores de riesgo 1 y 2, tipos de cambio, tasas y curvas  
  
 v1.1 JATO (03:14 p.m. 2006-03-16)  
 Agregue directivas para creacion de archivo   
 de indices de mercado  
*/  
  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;1  
  @txtDate AS VARCHAR(10),  
 @txtLiquidation AS VARCHAR(10)  
  
AS  
BEGIN  
  
  SELECT     
   SUBSTRING (    
   '0000000000000000000000' +   
   'H ' +    
   SUBSTRING(b.txtCNBVMarket,1,2) +     
  
   CONVERT(CHAR(8),a.dteDate,112) +    
  
   a.txtTv + REPLICATE(' ',4 - LEN(a.txtTv)) +    
   a.txtEmisora + REPLICATE(' ',7 - LEN(a.txtEmisora)) +    
   a.txtSerie + REPLICATE(' ',6 - LEN(a.txtSerie)) +    
  
   CASE UPPER(a.txtLiquidation)    
    WHEN 'MP'THEN    
     SUBSTRING(REPLACE(STR(ROUND(a.dblPAV,6),13,6),  ' ', '0'), 1, 6) +    
      SUBSTRING(REPLACE(STR(ROUND(a.dblPAV,6),13,6),  ' ', '0'), 8, 6)    
    ELSE    
     SUBSTRING(REPLACE(STR(ROUND(a.dblPRS,6),13,6),  ' ', '0'), 1, 6) +    
      SUBSTRING(REPLACE(STR(ROUND(a.dblPRS,6),13,6),  ' ', '0'), 8, 6)    
   END +    
   '00000000000000000000000000' +    
   '                                                                                                    ' +   -- 155 Espacios  
   '                                                       '  
   , 1, 250)  As VectorJPMorgan   
  FROM  tmp_tblUnifiedPricesReport a     
   INNER JOIN tblTvCatalog b ON a.txtTv = b.txtTv    
    
  WHERE a.txtLiquidation IN (@txtLiquidation, 'MP')  -- @txtLiquidation  
  AND  a.txtTv NOT IN ('*C','*D','*F','*R','*CSP')    
  AND dtedate = @txtDate  
  ORDER BY a.txtTv,a.txtEmisora,a.txtSerie    
  
END  
  
  
/*  
  Version 1.0    
     
  -- Para generar archivo de Curva de Fra de Tiie para JPMORGAN  
  -- Tipo: SWP   SubTipo: TI  
  -- Las tasas deberan estar en porcentaje hasta el nodo 1092  
     Elaborado: Por Josefina Renteria  
     Fecha: 05-Nov-2003  
*/    
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;2  
 @txtDate AS VARCHAR(10)  
 AS     
 BEGIN    
    
 SELECT txtType,txtSubType,intCurve =   
  CASE WHEN txtType+'-'+txtSubType = 'SWP-TI' THEN 1                                         
  END,  
         txtDescription  
 FROM tblCurvesCatalog  
 WHERE txtType+'-'+txtSubType IN ('SWP-TI')  
              UNION  
             SELECT 'Tipo','SubTipo',0,'Plazo'  
 ORDER BY intCurve  
  
END  
-------------------------------------------------------------  
-- Autor:    Mike Ramirez  
-- Fecha Modificacion: 20121214 05:35 p.m  
-- Descripcion:   Se elimina el instrumento MABT0000003  
-------------------------------------------------------------  
-- para extraer las directivas para el archivo de   
-- indices de mercado  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;3  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 SELECT   
  -999 AS intSerial,  
  REPLICATE(' ', 50) AS txtTipo,  
  REPLICATE(' ', 50) AS txtId,  
  -999 AS intPlazo,  
  REPLICATE(' ', 50) AS txtAlias  
 INTO #tblDirectives  
 TRUNCATE TABLE #tblDirectives  
   
 INSERT #tblDirectives SELECT 1,'IRC','T028',0,'1'  
 INSERT #tblDirectives SELECT 2,'Curva','CET/CTI',28,'2'  
 INSERT #tblDirectives SELECT 3,'Curva','CET/CTI',91,'3'  
 INSERT #tblDirectives SELECT 4,'Curva','CET/CTI',182,'4'  
 INSERT #tblDirectives SELECT 5,'Curva','CET/CTI',364,'5'  
 INSERT #tblDirectives SELECT 6,'IRC','LUS030',0,'6'  
 INSERT #tblDirectives SELECT 7,'IRC','LUS091',0,'7'  
 INSERT #tblDirectives SELECT 8,'IRC','LUS182',0,'8'  
 INSERT #tblDirectives SELECT 9,'IRC','UFXU',0,'9'  
 INSERT #tblDirectives SELECT 10,'IRC','UDI',0,'10'  
 INSERT #tblDirectives SELECT 11,'IRC','IPC',0,'11'  
 --INSERT #tblDirectives SELECT 12,'Instrumento','MABT0000003/PAV/MP',0,'12'  
 INSERT #tblDirectives SELECT 12,'IRC','BRLX',0,'40'  
 INSERT #tblDirectives SELECT 13,'IRC','BZIDO',0,'41'  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtTipo,  
  txtId,  
  intPlazo,  
  txtAlias  
 FROM #tblDirectives  
 ORDER BY   
  intSerial  
  
END  
  
-- para obtener el valor de un precio desde tblPrices  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;4  
 @txtDate AS CHAR(10),  
 @txtId1 AS CHAR(11),  
 @txtItem AS CHAR(10),  
 @txtLiquidation AS CHAR(3)  
AS     
BEGIN    
  
 SELECT dblValue  
 FROM tblPrices  
 WHERE  
  dteDate = @txtDate  
  AND txtId1 = @txtId1  
  AND txtItem = @txtItem  
  AND txtLiquidation = @txtLiquidation  
  
  
END  
  
-- para extraer las directivas para el archivo de   
-- factores de riesgo  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;5  
 @txtDate AS CHAR(10),  
 @intCashTomTerm AS INT,  
 @intTomNextTerm AS INT  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @intData AS INT  
 DECLARE @intTerm AS INT  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dblRate AS FLOAT  
   
 -- tabla temporal  
 SELECT   
  -999 AS intSerial,  
  REPLICATE(' ', 50) AS txtTipo,  
  REPLICATE(' ', 50) AS txtId,  
  -999 AS intPlazo,  
  REPLICATE(' ', 50) AS txtAlias,  
  -1E-10 AS dblValue  
 INTO #tblDirectives  
 TRUNCATE TABLE #tblDirectives  
  
 -- curvas bloque 1   
 INSERT #tblDirectives SELECT 1,'Curva','CET/CT',1,'CETES mm', -999  
 INSERT #tblDirectives SELECT 2,'Curva','CET/CT',7,'CETES mm', -999  
 INSERT #tblDirectives SELECT 3,'Curva','CET/CT',14,'CETES mm', -999  
 INSERT #tblDirectives SELECT 4,'Curva','CET/CT',28,'CETES mm', -999  
 INSERT #tblDirectives SELECT 5,'Curva','CET/CT',60,'CETES mm', -999  
 INSERT #tblDirectives SELECT 6,'Curva','CET/CT',91,'CETES mm', -999  
 INSERT #tblDirectives SELECT 7,'Curva','CET/CT',120,'CETES mm', -999  
 INSERT #tblDirectives SELECT 8,'Curva','CET/CT',150,'CETES mm', -999  
 INSERT #tblDirectives SELECT 9,'Curva','CET/CT',180,'CETES mm', -999  
 INSERT #tblDirectives SELECT 10,'Curva','CET/CT',270,'CETES mm', -999  
 INSERT #tblDirectives SELECT 11,'Curva','CET/CT',365,'CETES mm', -999  
 INSERT #tblDirectives SELECT 12,'Curva','CET/CT',546,'CETES mm', -999  
 INSERT #tblDirectives SELECT 13,'Curva','CET/CT',728,'CETES mm', -999  
 INSERT #tblDirectives SELECT 14,'Curva','CET/CT',1092,'CETES mm', -999  
 INSERT #tblDirectives SELECT 15,'Curva','CET/CT',1456,'CETES mm', -999  
 INSERT #tblDirectives SELECT 16,'Curva','CET/CT',1820,'CETES mm', -999  
 INSERT #tblDirectives SELECT 17,'Curva','PLV/P8',1,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 18,'Curva','PLV/P8',7,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 19,'Curva','PLV/P8',14,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 20,'Curva','PLV/P8',28,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 21,'Curva','PLV/P8',60,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 22,'Curva','PLV/P8',91,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 23,'Curva','PLV/P8',120,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 24,'Curva','PLV/P8',150,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 25,'Curva','PLV/P8',180,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 26,'Curva','PLV/P8',270,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 27,'Curva','PLV/P8',365,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 28,'Curva','PLV/P8',546,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 29,'Curva','PLV/P8',728,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 30,'Curva','PLV/P8',1092,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 31,'Curva','PLV/P8',1456,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 32,'Curva','PLV/P8',1820,'PAGARES mm', -999  
 INSERT #tblDirectives SELECT 33,'Curva','FWD/CU',1,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 34,'Curva','FWD/CU',7,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 35,'Curva','FWD/CU',14,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 36,'Curva','FWD/CU',28,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 37,'Curva','FWD/CU',60,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 38,'Curva','FWD/CU',91,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 39,'Curva','FWD/CU',120,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 40,'Curva','FWD/CU',150,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 41,'Curva','FWD/CU',180,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 42,'Curva','FWD/CU',270,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 43,'Curva','FWD/CU',365,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 44,'Curva','FWD/CU',546,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 45,'Curva','FWD/CU',728,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 46,'Curva','FWD/CU',1092,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 47,'Curva','FWD/CU',1456,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 48,'Curva','FWD/CU',1820,'FWDS mm', -999  
 INSERT #tblDirectives SELECT 49,'Curva','LIB/BL',1,'USD mm', -999  
 INSERT #tblDirectives SELECT 50,'Curva','LIB/BL',7,'USD mm', -999  
 INSERT #tblDirectives SELECT 51,'Curva','LIB/BL',14,'USD mm', -999  
 INSERT #tblDirectives SELECT 52,'Curva','LIB/BL',28,'USD mm', -999  
 INSERT #tblDirectives SELECT 53,'Curva','LIB/BL',60,'USD mm', -999  
 INSERT #tblDirectives SELECT 54,'Curva','LIB/BL',91,'USD mm', -999  
 INSERT #tblDirectives SELECT 55,'Curva','LIB/BL',120,'USD mm', -999  
 INSERT #tblDirectives SELECT 56,'Curva','LIB/BL',150,'USD mm', -999  
 INSERT #tblDirectives SELECT 57,'Curva','LIB/BL',180,'USD mm', -999  
 INSERT #tblDirectives SELECT 58,'Curva','LIB/BL',270,'USD mm', -999  
 INSERT #tblDirectives SELECT 59,'Curva','LIB/BL',365,'USD mm', -999  
 INSERT #tblDirectives SELECT 60,'Curva','LUS/SWP',546,'USD mm', -999  
 INSERT #tblDirectives SELECT 61,'Curva','LUS/SWP',728,'USD mm', -999  
 INSERT #tblDirectives SELECT 62,'Curva','LUS/SWP',1092,'USD mm', -999  
 INSERT #tblDirectives SELECT 63,'Curva','LUS/SWP',1456,'USD mm', -999  
 INSERT #tblDirectives SELECT 64,'Curva','LUS/SWP',1820,'USD mm', -999  
 INSERT #tblDirectives SELECT 65,'Curva','LUS/SWP',2184,'USD mm', -999  
 INSERT #tblDirectives SELECT 66,'Curva','LUS/SWP',2548,'USD mm', -999  
 INSERT #tblDirectives SELECT 67,'Curva','LUS/SWP',2912,'USD mm', -999  
 INSERT #tblDirectives SELECT 68,'Curva','LUS/SWP',3276,'USD mm', -999  
 INSERT #tblDirectives SELECT 69,'Curva','LUS/SWP',3640,'USD mm', -999  
 INSERT #tblDirectives SELECT 70,'Curva','LUS/SWP',5460,'USD mm', -999  
 INSERT #tblDirectives SELECT 71,'Curva','LUS/SWP',7280,'USD mm', -999  
 INSERT #tblDirectives SELECT 72,'Curva','LUS/SWP',10920,'USD mm', -999  
 INSERT #tblDirectives SELECT 73,'Curva','PLU/P8',1,'Udipagare', -999  
 INSERT #tblDirectives SELECT 74,'Curva','PLU/P8',30,'Udipagare', -999  
 INSERT #tblDirectives SELECT 75,'Curva','PLU/P8',60,'Udipagare', -999  
 INSERT #tblDirectives SELECT 76,'Curva','PLU/P8',91,'Udipagare', -999  
 INSERT #tblDirectives SELECT 77,'Curva','PLU/P8',120,'Udipagare', -999  
 INSERT #tblDirectives SELECT 78,'Curva','PLU/P8',150,'Udipagare', -999  
 INSERT #tblDirectives SELECT 79,'Curva','PLU/P8',182,'Udipagare', -999  
 INSERT #tblDirectives SELECT 80,'Curva','PLU/P8',272,'Udipagare', -999  
 INSERT #tblDirectives SELECT 81,'Curva','PLU/P8',360,'Udipagare', -999  
 INSERT #tblDirectives SELECT 82,'Curva','PLU/P8',540,'Udipagare', -999  
 INSERT #tblDirectives SELECT 83,'Curva','PLU/P8',720,'Udipagare', -999  
 INSERT #tblDirectives SELECT 84,'Curva','PLU/P8',1080,'Udipagare', -999  
 INSERT #tblDirectives SELECT 85,'Curva','PLU/P8',1440,'Udipagare', -999  
 INSERT #tblDirectives SELECT 86,'Curva','PLU/P8',1800,'Udipagare', -999  
 INSERT #tblDirectives SELECT 87,'Curva','PLU/P8',2160,'Udipagare', -999  
 INSERT #tblDirectives SELECT 88,'Curva','PLU/P8',2520,'Udipagare', -999  
 INSERT #tblDirectives SELECT 89,'Curva','PLU/P8',2880,'Udipagare', -999  
 INSERT #tblDirectives SELECT 90,'Curva','PLU/P8',3240,'Udipagare', -999  
 INSERT #tblDirectives SELECT 91,'Curva','PLU/P8',3600,'Udipagare', -999  
  
 -- markets bloque 1  
  
 SET @intData = 91  
  
 DECLARE csr_markets_1 CURSOR  FOR  
 SELECT DISTINCT  
  intTerm,  
  dblLevelMid AS dblRate  
 FROM tblMarkets   
 WHERE  
  dteDate = @txtDate  
  and txtCode = 'IRS'  
 ORDER BY intTerm  
  
 OPEN csr_markets_1  
   
 FETCH NEXT FROM csr_markets_1   
 INTO @intTerm, @dblRate   
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Market',  
   'IRS',  
   @intTerm,  
   'IRS sw',  
   @dblRate  
   
  FETCH NEXT FROM csr_markets_1   
  INTO @intTerm, @dblRate   
  
 END  
   
 CLOSE csr_markets_1  
 DEALLOCATE csr_markets_1  
  
 -- precios bloque 1  
  
 DECLARE csr_prices_1 CURSOR  FOR  
 SELECT   
  i.txtId1,  
  DATEDIFF(d, @txtDate, b.dteMaturity) AS intTerm  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity > @txtDate  
  AND b.dteIssued < '20021223'  
 ORDER BY   
  intTerm  
  
 OPEN csr_prices_1  
   
 FETCH NEXT FROM csr_prices_1   
 INTO @txtId1, @intTerm  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Instrumento',  
   RTRIM(@txtId1) + '/YTM/MD',  
   @intTerm,  
   'BONO TF',  
   -999  
   
  FETCH NEXT FROM csr_prices_1   
  INTO @txtId1, @intTerm  
  
 END  
   
 CLOSE csr_prices_1  
 DEALLOCATE csr_prices_1  
  
 -- curvas bloque 2  
  
 INSERT #tblDirectives SELECT @intData + 1,'Curva','UDB/YLD',1,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 2,'Curva','UDB/YLD',182,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 3,'Curva','UDB/YLD',365,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 4,'Curva','UDB/YLD',728,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 5,'Curva','UDB/YLD',1092,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 6,'Curva','UDB/YLD',1456,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 7,'Curva','UDB/YLD',1820,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 8,'Curva','UDB/YLD',2184,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 9,'Curva','UDB/YLD',2548,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 10,'Curva','UDB/YLD',2912,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 11,'Curva','UDB/YLD',3276,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 12,'Curva','UDB/YLD',3640,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 13,'Curva','UDB/YLD',5460,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 14,'Curva','UDB/YLD',7280,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 15,'Curva','UDB/YLD',9100,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 16,'Curva','UDB/YLD',10920,'UDICVE', -999  
 INSERT #tblDirectives SELECT @intData + 17,'Curva','BPA/BP',1,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 18,'Curva','BPA/BP',182,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 19,'Curva','BPA/BP',364,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 20,'Curva','BPA/BP',542,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 21,'Curva','BPA/BP',728,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 22,'Curva','BPA/BP',910,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 23,'Curva','BPA/BP',1092,'IPAB Bonds', -999  
  
-- JATO (04:03 p.m. 2006-08-02)  
-- la curva fue recortada a solo 1100 nodos  
/*  
 INSERT #tblDirectives SELECT @intData + 24,'Curva','BPA/BP',1274,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 25,'Curva','BPA/BP',1456,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 26,'Curva','BPA/BP',1638,'IPAB Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 27,'Curva','BPA/BP',1820,'IPAB Bonds', -999  
*/  
 INSERT #tblDirectives SELECT @intData + 28,'Curva','BPT/BP',1,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 29,'Curva','BPT/BP',182,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 30,'Curva','BPT/BP',364,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 31,'Curva','BPT/BP',542,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 32,'Curva','BPT/BP',728,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 33,'Curva','BPT/BP',910,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 34,'Curva','BPT/BP',1092,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 35,'Curva','BPT/BP',1274,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 36,'Curva','BPT/BP',1456,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 37,'Curva','BPT/BP',1638,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 38,'Curva','BPT/BP',1820,'IPAT Bonds', -999  
 INSERT #tblDirectives SELECT @intData + 39,'Curva','BDE/SE',1,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 40,'Curva','BDE/SE',182,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 41,'Curva','BDE/SE',364,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 42,'Curva','BDE/SE',542,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 43,'Curva','BDE/SE',728,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 44,'Curva','BDE/SE',910,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 45,'Curva','BDE/SE',1092,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 46,'Curva','BDE/SE',1274,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 47,'Curva','BDE/SE',1456,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 48,'Curva','BDE/SE',1638,'Bondes 182', -999  
 INSERT #tblDirectives SELECT @intData + 49,'Curva','BDE/SE',1820,'Bondes 182', -999  
/*  
 INSERT #tblDirectives SELECT @intData + 50,'Curva','BDE/LT',1,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 51,'Curva','BDE/LT',182,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 52,'Curva','BDE/LT',364,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 53,'Curva','BDE/LT',542,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 54,'Curva','BDE/LT',728,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 55,'Curva','BDE/LT',910,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 56,'Curva','BDE/LT',1092,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 57,'Curva','BDE/LT',1274,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 58,'Curva','BDE/LT',1456,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 59,'Curva','BDE/LT',1638,'New Bondes', -999  
 INSERT #tblDirectives SELECT @intData + 60,'Curva','BDE/LT',1800,'New Bondes', -999  
*/  
 INSERT #tblDirectives SELECT @intData + 61,'Curva','RG2/G2I',1,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 62,'Curva','RG2/G2I',7,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 63,'Curva','RG2/G2I',14,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 64,'Curva','RG2/G2I',28,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 65,'Curva','RG2/G2I',60,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 66,'Curva','RG2/G2I',91,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 67,'Curva','RG2/G2I',120,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 68,'Curva','RG2/G2I',150,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 69,'Curva','RG2/G2I',180,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 70,'Curva','RG2/G2I',270,'Repo-I', -999  
 INSERT #tblDirectives SELECT @intData + 71,'Curva','RG2/G2I',360,'Repo-I', -999  
   
 -- precios bloque 2  
  
 SET @intData = @intData + 71  
  
 DECLARE csr_prices_2 CURSOR  FOR  
 SELECT   
  i.txtId1,  
  DATEDIFF(d, @txtDate, b.dteMaturity) AS intTerm  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  i.txtTv = 'BI'  
  AND b.dteMaturity > @txtDate  
 ORDER BY   
  intTerm  
  
 OPEN csr_prices_2  
   
 FETCH NEXT FROM csr_prices_2   
 INTO @txtId1, @intTerm  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Instrumento',  
   RTRIM(@txtId1) + '/YTM/MD',  
   @intTerm,  
   'CETES mm-i',  
   -999  
   
  FETCH NEXT FROM csr_prices_2   
  INTO @txtId1, @intTerm  
  
 END  
   
 CLOSE csr_prices_2  
 DEALLOCATE csr_prices_2  
  
 -- precios bloque 3  
  
 DECLARE csr_prices_3 CURSOR  FOR  
 SELECT   
  i.txtId1,  
  DATEDIFF(d, @txtDate, b.dteMaturity) AS intTerm  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity > @txtDate  
  AND b.dteIssued >= '20021223'  
 ORDER BY   
  intTerm  
  
 OPEN csr_prices_3  
   
 FETCH NEXT FROM csr_prices_3   
 INTO @txtId1, @intTerm  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Instrumento',  
   RTRIM(@txtId1) + '/YTM/MD',  
   @intTerm,  
   'BONOS mm-i',  
   -999  
   
  FETCH NEXT FROM csr_prices_3   
  INTO @txtId1, @intTerm  
  
 END  
   
 CLOSE csr_prices_3  
 DEALLOCATE csr_prices_3  
  
 -- markets bloque 2  
  
  -- CASH/TOM  
  
 INSERT #tblDirectives   
 SELECT   
  @intData + 1,  
  'Market',  
  'CASH / TOM',  
  -999,  
  'CASH / TOM',  
  ((i2.dblValue  - i1.dblValue ) / @intCashTomTerm)   
  
 FROM   
  tblIrc AS i1,  
  tblIrc AS i2  
 WHERE  
  i1.dteDate = @txtDate  
  AND i1.txtIrc = 'USD0'  
  AND i2.dteDate = @txtDate  
  AND i2.txtIrc = 'USD1'  
  
  -- TOM/NEXT  
 INSERT #tblDirectives   
 SELECT   
  @intData + 2,  
  'Market',  
  'TOM / NEXT',  
  -999,  
  'TOM / NEXT',  
  ((i2.dblValue  - i1.dblValue ) / @intTomNextTerm)   
 FROM   
  tblIrc AS i1,  
  tblIrc AS i2  
 WHERE  
  i1.dteDate = @txtDate  
  AND i1.txtIrc = 'USD1'  
  AND i2.dteDate = @txtDate  
  AND i2.txtIrc = 'USD2'  
  
  -- SPOT/NEXT  
 INSERT #tblDirectives   
 SELECT   
  @intData + 3,  
  'Market',  
  'SPOT / NEXT',  
  -999,  
  'SPOT / NEXT',  
  dblMid   
 FROM MxFixIncome.dbo.vw_markets_fwd (NOLOCK)  
 WHERE  
  dteDate = @txtDate  
  AND intTerm = 1  
  
 -- precios bloque 4  
  
 SET @intData = @intData + 3  
  
 DECLARE csr_prices_4 CURSOR  FOR  
 SELECT   
  i.txtId1,  
  DATEDIFF(d, @txtDate, b.dteMaturity) AS intTerm  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'S%'  
   AND i.txtTv NOT IN ('SP', 'SC')  
  )  
  AND b.dteMaturity > @txtDate  
  AND b.dteIssued >= '20021223'  
 ORDER BY   
  intTerm  
  
 OPEN csr_prices_4  
   
 FETCH NEXT FROM csr_prices_4   
 INTO @txtId1, @intTerm  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Instrumento',  
   RTRIM(@txtId1) + '/YTM/MD',  
   @intTerm,  
   'UDI-I',  
   -999  
   
  FETCH NEXT FROM csr_prices_4   
  INTO @txtId1, @intTerm  
  
 END  
   
 CLOSE csr_prices_4  
 DEALLOCATE csr_prices_4  
  
 -- curvas bloque 3  
   
 INSERT #tblDirectives SELECT @intData + 1,'Curva/100','CET/IRS',1,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 2,'Curva/100','CET/IRS',30,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 3,'Curva/100','CET/IRS',60,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 4,'Curva/100','CET/IRS',90,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 5,'Curva/100','CET/IRS',120,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 6,'Curva/100','CET/IRS',150,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 7,'Curva/100','CET/IRS',182,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 8,'Curva/100','CET/IRS',270,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 9,'Curva/100','CET/IRS',364,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 10,'Curva/100','CET/IRS',546,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 11,'Curva/100','CET/IRS',728,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 12,'Curva/100','CET/IRS',1092,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 13,'Curva/100','CET/IRS',1456,'CETE IRS mm', -999  
 INSERT #tblDirectives SELECT @intData + 14,'Curva/100','CET/IRS',1820,'CETE IRS mm', -999  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtTipo,  
  txtId,  
  intPlazo,  
  txtAlias,  
  dblValue  
 FROM #tblDirectives  
 ORDER BY   
  intSerial  
  
  
END  
-- para extraer las directivas para el archivo de   
-- factores de riesgo 2  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;6  
 @txtDate AS CHAR(10)  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @intData AS INT  
 DECLARE @intTerm AS INT  
 DECLARE @intNode AS INT  
 DECLARE @intMaxNode AS INT  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dblRate AS FLOAT  
   
 -- tabla temporal  
 SELECT   
  -999 AS intSerial,  
  REPLICATE(' ', 50) AS txtTipo,  
  REPLICATE(' ', 50) AS txtId,  
  -999 AS intPlazo,  
  REPLICATE(' ', 50) AS txtAlias,  
  -1E-10 AS dblValue  
 INTO #tblDirectives  
 TRUNCATE TABLE #tblDirectives  
  
 -- curvas bloque 1   
 INSERT #tblDirectives SELECT 1,'Curva','CET/CT',1,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 2,'Curva','CET/CT',7,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 3,'Curva','CET/CT',14,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 4,'Curva','CET/CT',28,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 5,'Curva','CET/CT',60,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 6,'Curva','CET/CT',91,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 7,'Curva','CET/CT',120,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 8,'Curva','CET/CT',150,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 9,'Curva','CET/CT',180,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 10,'Curva','CET/CT',270,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 11,'Curva','CET/CT',365,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 12,'Curva','CET/CT',546,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 13,'Curva','CET/CT',728,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 14,'Curva','CET/CT',1092,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 15,'Curva','CET/CT',1456,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 16,'Curva','CET/CT',1820,'CETES/mm', -999  
 INSERT #tblDirectives SELECT 17,'Curva','PLV/P8',1,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 18,'Curva','PLV/P8',7,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 19,'Curva','PLV/P8',14,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 20,'Curva','PLV/P8',28,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 21,'Curva','PLV/P8',60,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 22,'Curva','PLV/P8',91,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 23,'Curva','PLV/P8',120,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 24,'Curva','PLV/P8',150,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 25,'Curva','PLV/P8',180,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 26,'Curva','PLV/P8',270,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 27,'Curva','PLV/P8',365,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 28,'Curva','PLV/P8',546,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 29,'Curva','PLV/P8',728,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 30,'Curva','PLV/P8',1092,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 31,'Curva','PLV/P8',1456,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 32,'Curva','PLV/P8',1820,'PAGARES/mm', -999  
 INSERT #tblDirectives SELECT 33,'Curva','FWD/CU',1,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 34,'Curva','FWD/CU',7,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 35,'Curva','FWD/CU',14,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 36,'Curva','FWD/CU',28,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 37,'Curva','FWD/CU',60,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 38,'Curva','FWD/CU',91,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 39,'Curva','FWD/CU',120,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 40,'Curva','FWD/CU',150,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 41,'Curva','FWD/CU',180,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 42,'Curva','FWD/CU',270,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 43,'Curva','FWD/CU',365,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 44,'Curva','FWD/CU',546,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 45,'Curva','FWD/CU',728,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 46,'Curva','FWD/CU',1092,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 47,'Curva','FWD/CU',1456,'FWDS/mm', -999   INSERT #tblDirectives SELECT 48,'Curva','FWD/CU',1820,'FWDS/mm', -999  
 INSERT #tblDirectives SELECT 49,'Curva','LIB/BL',1,'USD/mm', -999  
 INSERT #tblDirectives SELECT 50,'Curva','LIB/BL',7,'USD/mm', -999  
 INSERT #tblDirectives SELECT 51,'Curva','LIB/BL',14,'USD/mm', -999  
 INSERT #tblDirectives SELECT 52,'Curva','LIB/BL',28,'USD/mm', -999  
 INSERT #tblDirectives SELECT 53,'Curva','LIB/BL',60,'USD/mm', -999  
 INSERT #tblDirectives SELECT 54,'Curva','LIB/BL',91,'USD/mm', -999  
 INSERT #tblDirectives SELECT 55,'Curva','LIB/BL',120,'USD/mm', -999  
 INSERT #tblDirectives SELECT 56,'Curva','LIB/BL',150,'USD/mm', -999  
 INSERT #tblDirectives SELECT 57,'Curva','LIB/BL',180,'USD/mm', -999  
 INSERT #tblDirectives SELECT 58,'Curva','LIB/BL',270,'USD/mm', -999  
 INSERT #tblDirectives SELECT 59,'Curva','LIB/BL',365,'USD/mm', -999  
 INSERT #tblDirectives SELECT 60,'Curva','LUS/SWP',546,'USD/mm', -999  
 INSERT #tblDirectives SELECT 61,'Curva','LUS/SWP',728,'USD/mm', -999  
 INSERT #tblDirectives SELECT 62,'Curva','LUS/SWP',1092,'USD/mm', -999  
 INSERT #tblDirectives SELECT 63,'Curva','LUS/SWP',1456,'USD/mm', -999  
 INSERT #tblDirectives SELECT 64,'Curva','LUS/SWP',1820,'USD/mm', -999  
 INSERT #tblDirectives SELECT 65,'Curva','LUS/SWP',3640,'USD/mm', -999  
 INSERT #tblDirectives SELECT 66,'Curva','LUS/SWP',5460,'USD/mm', -999  
 INSERT #tblDirectives SELECT 67,'Curva','PLU/P8',1,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 68,'Curva','PLU/P8',30,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 69,'Curva','PLU/P8',60,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 70,'Curva','PLU/P8',91,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 71,'Curva','PLU/P8',120,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 72,'Curva','PLU/P8',150,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 73,'Curva','PLU/P8',182,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 74,'Curva','PLU/P8',272,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 75,'Curva','PLU/P8',360,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 76,'Curva','PLU/P8',540,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 77,'Curva','PLU/P8',720,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 78,'Curva','PLU/P8',1080,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 79,'Curva','PLU/P8',1440,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 80,'Curva','PLU/P8',1800,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 81,'Curva','PLU/P8',2160,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 82,'Curva','PLU/P8',2520,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 83,'Curva','PLU/P8',2880,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 84,'Curva','PLU/P8',3240,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 85,'Curva','PLU/P8',3600,'Udipagare/', -999  
 INSERT #tblDirectives SELECT 86,'Curva/100','SWP/TI',1,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 87,'Curva/100','SWP/TI',30,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 88,'Curva/100','SWP/TI',60,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 89,'Curva/100','SWP/TI',90,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 90,'Curva/100','SWP/TI',180,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 91,'Curva/100','SWP/TI',365,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 92,'Curva/100','SWP/TI',540,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 93,'Curva/100','SWP/TI',728,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 94,'Curva/100','SWP/TI',1090,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 95,'Curva/100','SWP/TI',1800,'IRS/mm', -999  
 INSERT #tblDirectives SELECT 96,'Curva/100','SWP/TI',3650,'IRS/mm', -999  
  
  
 -- precios bloque 1  
  
 SET @intData = 96  
  
 DECLARE csr_prices_1 CURSOR  FOR  
 SELECT   
  i.txtId1,  
  DATEDIFF(d, @txtDate, b.dteMaturity) AS intTerm  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity > @txtDate  
  AND b.dteIssued < '20021223'  
 ORDER BY   
  intTerm  
  
 OPEN csr_prices_1  
   
 FETCH NEXT FROM csr_prices_1   
 INTO @txtId1, @intTerm  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Instrumento',  
   RTRIM(@txtId1) + '/YTM/MD',  
   @intTerm,  
   'BONO TF/',  
   -999  
   
  FETCH NEXT FROM csr_prices_1   
  INTO @txtId1, @intTerm  
  
 END  
   
 CLOSE csr_prices_1  
 DEALLOCATE csr_prices_1  
  
 -- curvas bloque 2  
  
 INSERT #tblDirectives SELECT @intData + 1,'Curva','UDB/YLD',1,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 2,'Curva','UDB/YLD',182,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 3,'Curva','UDB/YLD',365,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 4,'Curva','UDB/YLD',728,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 5,'Curva','UDB/YLD',1092,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 6,'Curva','UDB/YLD',1456,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 7,'Curva','UDB/YLD',1820,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 8,'Curva','UDB/YLD',2184,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 9,'Curva','UDB/YLD',2548,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 10,'Curva','UDB/YLD',2912,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 11,'Curva','UDB/YLD',3276,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 12,'Curva','UDB/YLD',3640,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 13,'Curva','UDB/YLD',5460,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 14,'Curva','UDB/YLD',7280,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 15,'Curva','UDB/YLD',9100,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 16,'Curva','UDB/YLD',10920,'UDICVE/', -999  
 INSERT #tblDirectives SELECT @intData + 17,'Curva','BPA/BP',1,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 18,'Curva','BPA/BP',182,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 19,'Curva','BPA/BP',364,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 20,'Curva','BPA/BP',542,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 21,'Curva','BPA/BP',728,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 22,'Curva','BPA/BP',910,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 23,'Curva','BPA/BP',1092,'IPAB Bonds/', -999  
  
-- JATO (04:03 p.m. 2006-08-02)  
-- la curva fue recortada a solo 1100 nodos  
/*  
 INSERT #tblDirectives SELECT @intData + 24,'Curva','BPA/BP',1274,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 25,'Curva','BPA/BP',1456,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 26,'Curva','BPA/BP',1638,'IPAB Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 27,'Curva','BPA/BP',1820,'IPAB Bonds/', -999  
*/  
 INSERT #tblDirectives SELECT @intData + 28,'Curva','BPT/BP',1,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 29,'Curva','BPT/BP',182,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 30,'Curva','BPT/BP',364,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 31,'Curva','BPT/BP',542,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 32,'Curva','BPT/BP',728,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 33,'Curva','BPT/BP',910,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 34,'Curva','BPT/BP',1092,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 35,'Curva','BPT/BP',1274,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 36,'Curva','BPT/BP',1456,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 37,'Curva','BPT/BP',1638,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 38,'Curva','BPT/BP',1820,'IPAT Bonds/', -999  
 INSERT #tblDirectives SELECT @intData + 39,'Curva','BDE/SE',1,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 40,'Curva','BDE/SE',182,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 41,'Curva','BDE/SE',364,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 42,'Curva','BDE/SE',542,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 43,'Curva','BDE/SE',728,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 44,'Curva','BDE/SE',910,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 45,'Curva','BDE/SE',1092,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 46,'Curva','BDE/SE',1274,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 47,'Curva','BDE/SE',1456,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 48,'Curva','BDE/SE',1638,'Bondes 182/', -999  
 INSERT #tblDirectives SELECT @intData + 49,'Curva','BDE/SE',1820,'Bondes 182/', -999  
/*  
 INSERT #tblDirectives SELECT @intData + 50,'Curva','BDE/LT',1,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 51,'Curva','BDE/LT',182,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 52,'Curva','BDE/LT',364,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 53,'Curva','BDE/LT',542,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 54,'Curva','BDE/LT',728,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 55,'Curva','BDE/LT',910,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 56,'Curva','BDE/LT',1092,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 57,'Curva','BDE/LT',1274,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 58,'Curva','BDE/LT',1456,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 59,'Curva','BDE/LT',1638,'New Bondes/', -999  
 INSERT #tblDirectives SELECT @intData + 60,'Curva','BDE/LT',1800,'New Bondes/', -999  
*/  
 INSERT #tblDirectives SELECT @intData + 61,'Curva','RG2/G2I',1,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 62,'Curva','RG2/G2I',7,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 63,'Curva','RG2/G2I',14,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 64,'Curva','RG2/G2I',28,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 65,'Curva','RG2/G2I',60,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 66,'Curva','RG2/G2I',91,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 67,'Curva','RG2/G2I',120,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 68,'Curva','RG2/G2I',150,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 69,'Curva','RG2/G2I',180,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 70,'Curva','RG2/G2I',270,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 71,'Curva','RG2/G2I',360,'Repo-I/', -999  
 INSERT #tblDirectives SELECT @intData + 72,'Curva','CET/CTI',1,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 73,'Curva','CET/CTI',7,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 74,'Curva','CET/CTI',14,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 75,'Curva','CET/CTI',28,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 76,'Curva','CET/CTI',60,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 77,'Curva','CET/CTI',91,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 78,'Curva','CET/CTI',120,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 79,'Curva','CET/CTI',150,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 80,'Curva','CET/CTI',180,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 81,'Curva','CET/CTI',270,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 82,'Curva','CET/CTI',365,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 83,'Curva','CET/CTI',546,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 84,'Curva','CET/CTI',728,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 85,'Curva','CET/CTI',1092,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 86,'Curva','CET/CTI',1456,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 87,'Curva','CET/CTI',1820,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 88,'Curva','CET/CTI',2002,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 89,'Curva','CET/CTI',2184,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 90,'Curva','CET/CTI',2366,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 91,'Curva','CET/CTI',2548,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 92,'Curva','CET/CTI',2730,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 93,'Curva','CET/CTI',2912,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 94,'Curva','CET/CTI',3094,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 95,'Curva','CET/CTI',3276,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 96,'Curva','CET/CTI',3458,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 97,'Curva','CET/CTI',3640,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 98,'Curva','CET/CTI',3822,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 99,'Curva','CET/CTI',4004,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 100,'Curva','CET/CTI',4186,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 101,'Curva','CET/CTI',4368,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 102,'Curva','CET/CTI',4550,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 103,'Curva','CET/CTI',4732,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 104,'Curva','CET/CTI',4914,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 105,'Curva','CET/CTI',5096,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 106,'Curva','CET/CTI',5278,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 107,'Curva','CET/CTI',5460,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 108,'Curva','CET/CTI',5642,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 109,'Curva','CET/CTI',5824,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 110,'Curva','CET/CTI',6006,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 111,'Curva','CET/CTI',6188,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 112,'Curva','CET/CTI',6370,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 113,'Curva','CET/CTI',6552,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 114,'Curva','CET/CTI',6734,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 115,'Curva','CET/CTI',6916,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 116,'Curva','CET/CTI',7098,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 117,'Curva','CET/CTI',7280,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 118,'Curva','CET/CTI',7462,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 119,'Curva','CET/CTI',7644,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 120,'Curva','CET/CTI',7826,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 121,'Curva','CET/CTI',8008,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 122,'Curva','CET/CTI',8190,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 123,'Curva','CET/CTI',8372,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 124,'Curva','CET/CTI',8554,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 125,'Curva','CET/CTI',8736,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 126,'Curva','CET/CTI',8918,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 127,'Curva','CET/CTI',9100,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 128,'Curva','CET/CTI',9282,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 129,'Curva','CET/CTI',9464,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 130,'Curva','CET/CTI',9646,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 131,'Curva','CET/CTI',9828,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 132,'Curva','CET/CTI',10010,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 133,'Curva','CET/CTI',10192,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 134,'Curva','CET/CTI',10374,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 135,'Curva','CET/CTI',10556,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 136,'Curva','CET/CTI',10738,'CETES/mm-i', -999  
 INSERT #tblDirectives SELECT @intData + 137,'Curva','CET/CTI',10920,'CETES/mm-i', -999  
  
 -- precios bloque 2  
  
 SET @intData = @intData + 137  
  
 DECLARE csr_prices_3 CURSOR  FOR  
 SELECT   
  i.txtId1,  
  DATEDIFF(d, @txtDate, b.dteMaturity) AS intTerm  
 FROM   
  tblIds AS i  
  INNER JOIN tblBonds AS b  
  ON i.txtId1 = b.txtId1  
 WHERE  
  (  
   i.txtTv LIKE 'M%'  
   AND i.txtTv NOT IN ('MP', 'MC')  
  )  
  AND b.dteMaturity > @txtDate  
  AND b.dteIssued >= '20021223'  
 ORDER BY   
  intTerm  
  
 OPEN csr_prices_3  
   
 FETCH NEXT FROM csr_prices_3   
 INTO @txtId1, @intTerm  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Instrumento',  
   RTRIM(@txtId1) + '/YTM/MD',  
   @intTerm,  
   'BONOS/mm-i',  
   -999  
   
  FETCH NEXT FROM csr_prices_3   
  INTO @txtId1, @intTerm  
  
 END  
   
 CLOSE csr_prices_3  
 DEALLOCATE csr_prices_3  
  
 -- markets bloque 1  
  
 DECLARE csr_markets_1 CURSOR  FOR  
 SELECT   
  intTerm,  
  dblMid  
 FROM MxFixIncome.dbo.vw_markets_fwd (NOLOCK)  
 WHERE  
  dteDate = @txtDate  
 ORDER BY    
  intTerm  
  
 OPEN csr_markets_1  
   
 FETCH NEXT FROM csr_markets_1   
 INTO @intTerm, @dblRate  
   
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
  
  SET @intData = @intData + 1  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'MARKET',  
   'FWDPoints',  
   @intTerm,  
   'FWDPoints/',  
   @dblRate  
   
  FETCH NEXT FROM csr_markets_1   
  INTO @intTerm, @dblRate  
  
 END  
   
 CLOSE csr_markets_1  
 DEALLOCATE csr_markets_1  
  
 -- curvas bloque 3  
  
 SET @intMaxNode = (  
  SELECT MAX(intTerm)  
  FROM tblCurves  
  WHERE  
   dteDate = @txtDate  
   AND txtType = 'SWP'  
   AND txtSubType = 'TI'  
 )  
  
 SET @intNode = 0  
 WHILE @intNode < @intMaxNode  
 BEGIN  
  
  SET @intNode = @intNode + 1  
  SET @intData = @intData + 1  
  
  INSERT #tblDirectives   
  SELECT   
   @intData,  
   'Curva/100',  
   'SWP/TI',  
   @intNode,  
   'SWAPS TIIE/',  
   -999  
  
 END  
  
 -- irc bloque 1  
  
 INSERT #tblDirectives SELECT @intData + 1,'Irc','W028',182,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 2,'Irc','W028',364,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 3,'Irc','W028',542,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 4,'Irc','W028',728,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 5,'Irc','W028',910,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 6,'Irc','W028',1092,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 7,'Irc','W028',1274,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 8,'Irc','W028',1456,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 9,'Irc','W028',1638,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 10,'Irc','W028',1820,'AUCT28/', -999  
 INSERT #tblDirectives SELECT @intData + 11,'Irc','W091',182,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 12,'Irc','W091',364,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 13,'Irc','W091',542,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 14,'Irc','W091',728,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 15,'Irc','W091',910,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 16,'Irc','W091',1092,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 17,'Irc','W091',1274,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 18,'Irc','W091',1456,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 19,'Irc','W091',1638,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 20,'Irc','W091',1820,'AUCT91/', -999  
 INSERT #tblDirectives SELECT @intData + 21,'Irc','W182',182,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 22,'Irc','W182',364,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 23,'Irc','W182',542,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 24,'Irc','W182',728,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 25,'Irc','W182',910,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 26,'Irc','W182',1092,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 27,'Irc','W182',1274,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 28,'Irc','W182',1456,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 29,'Irc','W182',1638,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 30,'Irc','W182',1820,'AUCT182/', -999  
 INSERT #tblDirectives SELECT @intData + 31,'Irc','UDI',1,'TCUDI/', -999  
  
 -- curvas bloque 4   
  
 SET @intData = @intData + 31  
   
 INSERT #tblDirectives SELECT @intData + 1,'Curva/100','CET/IRS',1,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 2,'Curva/100','CET/IRS',30,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 3,'Curva/100','CET/IRS',60,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 4,'Curva/100','CET/IRS',90,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 5,'Curva/100','CET/IRS',120,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 6,'Curva/100','CET/IRS',150,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 7,'Curva/100','CET/IRS',182,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 8,'Curva/100','CET/IRS',270,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 9,'Curva/100','CET/IRS',364,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 10,'Curva/100','CET/IRS',546,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 11,'Curva/100','CET/IRS',728,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 12,'Curva/100','CET/IRS',1092,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 13,'Curva/100','CET/IRS',1546,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 14,'Curva/100','CET/IRS',1820,'CETE IRS/ mm', -999  
 INSERT #tblDirectives SELECT @intData + 15,'Curva/100','LIB/EUR',1,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 16,'Curva/100','LIB/EUR',2,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 17,'Curva/100','LIB/EUR',3,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 18,'Curva/100','LIB/EUR',4,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 19,'Curva/100','LIB/EUR',5,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 20,'Curva/100','LIB/EUR',6,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 21,'Curva/100','LIB/EUR',7,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 22,'Curva/100','LIB/EUR',8,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 23,'Curva/100','LIB/EUR',9,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 24,'Curva/100','LIB/EUR',10,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 25,'Curva/100','LIB/EUR',11,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 26,'Curva/100','LIB/EUR',12,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 27,'Curva/100','LIB/EUR',13,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 28,'Curva/100','LIB/EUR',14,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 29,'Curva/100','LIB/EUR',15,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 30,'Curva/100','LIB/EUR',16,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 31,'Curva/100','LIB/EUR',17,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 32,'Curva/100','LIB/EUR',18,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 33,'Curva/100','LIB/EUR',19,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 34,'Curva/100','LIB/EUR',20,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 35,'Curva/100','LIB/EUR',21,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 36,'Curva/100','LIB/EUR',22,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 37,'Curva/100','LIB/EUR',23,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 38,'Curva/100','LIB/EUR',24,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 39,'Curva/100','LIB/EUR',25,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 40,'Curva/100','LIB/EUR',26,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 41,'Curva/100','LIB/EUR',27,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 42,'Curva/100','LIB/EUR',28,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 43,'Curva/100','LIB/EUR',29,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 44,'Curva/100','LIB/EUR',30,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 45,'Curva/100','LIB/EUR',31,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 46,'Curva/100','LIB/EUR',32,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 47,'Curva/100','LIB/EUR',33,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 48,'Curva/100','LIB/EUR',34,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 49,'Curva/100','LIB/EUR',35,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 50,'Curva/100','LIB/EUR',36,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 51,'Curva/100','LIB/EUR',37,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 52,'Curva/100','LIB/EUR',38,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 53,'Curva/100','LIB/EUR',39,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 54,'Curva/100','LIB/EUR',40,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 55,'Curva/100','LIB/EUR',41,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 56,'Curva/100','LIB/EUR',42,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 57,'Curva/100','LIB/EUR',43,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 58,'Curva/100','LIB/EUR',44,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 59,'Curva/100','LIB/EUR',45,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 60,'Curva/100','LIB/EUR',46,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 61,'Curva/100','LIB/EUR',47,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 62,'Curva/100','LIB/EUR',48,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 63,'Curva/100','LIB/EUR',49,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 64,'Curva/100','LIB/EUR',50,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 65,'Curva/100','LIB/EUR',51,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 66,'Curva/100','LIB/EUR',52,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 67,'Curva/100','LIB/EUR',53,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 68,'Curva/100','LIB/EUR',54,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 69,'Curva/100','LIB/EUR',55,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 70,'Curva/100','LIB/EUR',56,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 71,'Curva/100','LIB/EUR',57,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 72,'Curva/100','LIB/EUR',58,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 73,'Curva/100','LIB/EUR',59,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 74,'Curva/100','LIB/EUR',60,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 75,'Curva/100','LIB/EUR',61,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 76,'Curva/100','LIB/EUR',62,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 77,'Curva/100','LIB/EUR',63,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 78,'Curva/100','LIB/EUR',64,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 79,'Curva/100','LIB/EUR',65,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 80,'Curva/100','LIB/EUR',66,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 81,'Curva/100','LIB/EUR',67,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 82,'Curva/100','LIB/EUR',68,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 83,'Curva/100','LIB/EUR',69,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 84,'Curva/100','LIB/EUR',70,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 85,'Curva/100','LIB/EUR',71,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 86,'Curva/100','LIB/EUR',72,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 87,'Curva/100','LIB/EUR',73,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 88,'Curva/100','LIB/EUR',74,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 89,'Curva/100','LIB/EUR',75,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 90,'Curva/100','LIB/EUR',76,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 91,'Curva/100','LIB/EUR',77,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 92,'Curva/100','LIB/EUR',78,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 93,'Curva/100','LIB/EUR',79,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 94,'Curva/100','LIB/EUR',80,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 95,'Curva/100','LIB/EUR',81,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 96,'Curva/100','LIB/EUR',82,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 97,'Curva/100','LIB/EUR',83,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 98,'Curva/100','LIB/EUR',84,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 99,'Curva/100','LIB/EUR',85,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 100,'Curva/100','LIB/EUR',86,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 101,'Curva/100','LIB/EUR',87,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 102,'Curva/100','LIB/EUR',88,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 103,'Curva/100','LIB/EUR',89,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 104,'Curva/100','LIB/EUR',90,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 105,'Curva/100','LIB/EUR',91,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 106,'Curva/100','LIB/EUR',92,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 107,'Curva/100','LIB/EUR',93,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 108,'Curva/100','LIB/EUR',94,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 109,'Curva/100','LIB/EUR',95,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 110,'Curva/100','LIB/EUR',96,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 111,'Curva/100','LIB/EUR',97,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 112,'Curva/100','LIB/EUR',98,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 113,'Curva/100','LIB/EUR',99,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 114,'Curva/100','LIB/EUR',100,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 115,'Curva/100','LIB/EUR',101,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 116,'Curva/100','LIB/EUR',102,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 117,'Curva/100','LIB/EUR',103,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 118,'Curva/100','LIB/EUR',104,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 119,'Curva/100','LIB/EUR',105,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 120,'Curva/100','LIB/EUR',106,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 121,'Curva/100','LIB/EUR',107,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 122,'Curva/100','LIB/EUR',108,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 123,'Curva/100','LIB/EUR',109,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 124,'Curva/100','LIB/EUR',110,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 125,'Curva/100','LIB/EUR',111,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 126,'Curva/100','LIB/EUR',112,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 127,'Curva/100','LIB/EUR',113,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 128,'Curva/100','LIB/EUR',114,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 129,'Curva/100','LIB/EUR',115,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 130,'Curva/100','LIB/EUR',116,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 131,'Curva/100','LIB/EUR',117,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 132,'Curva/100','LIB/EUR',118,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 133,'Curva/100','LIB/EUR',119,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 134,'Curva/100','LIB/EUR',120,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 135,'Curva/100','LIB/EUR',121,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 136,'Curva/100','LIB/EUR',122,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 137,'Curva/100','LIB/EUR',123,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 138,'Curva/100','LIB/EUR',124,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 139,'Curva/100','LIB/EUR',125,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 140,'Curva/100','LIB/EUR',126,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 141,'Curva/100','LIB/EUR',127,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 142,'Curva/100','LIB/EUR',128,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 143,'Curva/100','LIB/EUR',129,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 144,'Curva/100','LIB/EUR',130,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 145,'Curva/100','LIB/EUR',131,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 146,'Curva/100','LIB/EUR',132,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 147,'Curva/100','LIB/EUR',133,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 148,'Curva/100','LIB/EUR',134,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 149,'Curva/100','LIB/EUR',135,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 150,'Curva/100','LIB/EUR',136,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 151,'Curva/100','LIB/EUR',137,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 152,'Curva/100','LIB/EUR',138,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 153,'Curva/100','LIB/EUR',139,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 154,'Curva/100','LIB/EUR',140,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 155,'Curva/100','LIB/EUR',141,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 156,'Curva/100','LIB/EUR',142,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 157,'Curva/100','LIB/EUR',143,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 158,'Curva/100','LIB/EUR',144,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 159,'Curva/100','LIB/EUR',145,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 160,'Curva/100','LIB/EUR',146,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 161,'Curva/100','LIB/EUR',147,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 162,'Curva/100','LIB/EUR',148,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 163,'Curva/100','LIB/EUR',149,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 164,'Curva/100','LIB/EUR',150,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 165,'Curva/100','LIB/EUR',151,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 166,'Curva/100','LIB/EUR',152,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 167,'Curva/100','LIB/EUR',153,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 168,'Curva/100','LIB/EUR',154,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 169,'Curva/100','LIB/EUR',155,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 170,'Curva/100','LIB/EUR',156,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 171,'Curva/100','LIB/EUR',157,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 172,'Curva/100','LIB/EUR',158,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 173,'Curva/100','LIB/EUR',159,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 174,'Curva/100','LIB/EUR',160,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 175,'Curva/100','LIB/EUR',161,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 176,'Curva/100','LIB/EUR',162,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 177,'Curva/100','LIB/EUR',163,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 178,'Curva/100','LIB/EUR',164,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 179,'Curva/100','LIB/EUR',165,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 180,'Curva/100','LIB/EUR',166,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 181,'Curva/100','LIB/EUR',167,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 182,'Curva/100','LIB/EUR',168,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 183,'Curva/100','LIB/EUR',169,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 184,'Curva/100','LIB/EUR',170,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 185,'Curva/100','LIB/EUR',171,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 186,'Curva/100','LIB/EUR',172,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 187,'Curva/100','LIB/EUR',173,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 188,'Curva/100','LIB/EUR',174,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 189,'Curva/100','LIB/EUR',175,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 190,'Curva/100','LIB/EUR',176,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 191,'Curva/100','LIB/EUR',177,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 192,'Curva/100','LIB/EUR',178,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 193,'Curva/100','LIB/EUR',179,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 194,'Curva/100','LIB/EUR',180,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 195,'Curva/100','LIB/EUR',181,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 196,'Curva/100','LIB/EUR',182,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 197,'Curva/100','LIB/EUR',183,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 198,'Curva/100','LIB/EUR',184,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 199,'Curva/100','LIB/EUR',185,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 200,'Curva/100','LIB/EUR',186,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 201,'Curva/100','LIB/EUR',187,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 202,'Curva/100','LIB/EUR',188,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 203,'Curva/100','LIB/EUR',189,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 204,'Curva/100','LIB/EUR',190,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 205,'Curva/100','LIB/EUR',191,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 206,'Curva/100','LIB/EUR',192,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 207,'Curva/100','LIB/EUR',193,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 208,'Curva/100','LIB/EUR',194,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 209,'Curva/100','LIB/EUR',195,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 210,'Curva/100','LIB/EUR',196,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 211,'Curva/100','LIB/EUR',197,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 212,'Curva/100','LIB/EUR',198,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 213,'Curva/100','LIB/EUR',199,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 214,'Curva/100','LIB/EUR',200,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 215,'Curva/100','LIB/EUR',201,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 216,'Curva/100','LIB/EUR',202,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 217,'Curva/100','LIB/EUR',203,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 218,'Curva/100','LIB/EUR',204,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 219,'Curva/100','LIB/EUR',205,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 220,'Curva/100','LIB/EUR',206,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 221,'Curva/100','LIB/EUR',207,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 222,'Curva/100','LIB/EUR',208,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 223,'Curva/100','LIB/EUR',209,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 224,'Curva/100','LIB/EUR',210,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 225,'Curva/100','LIB/EUR',211,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 226,'Curva/100','LIB/EUR',212,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 227,'Curva/100','LIB/EUR',213,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 228,'Curva/100','LIB/EUR',214,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 229,'Curva/100','LIB/EUR',215,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 230,'Curva/100','LIB/EUR',216,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 231,'Curva/100','LIB/EUR',217,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 232,'Curva/100','LIB/EUR',218,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 233,'Curva/100','LIB/EUR',219,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 234,'Curva/100','LIB/EUR',220,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 235,'Curva/100','LIB/EUR',221,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 236,'Curva/100','LIB/EUR',222,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 237,'Curva/100','LIB/EUR',223,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 238,'Curva/100','LIB/EUR',224,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 239,'Curva/100','LIB/EUR',225,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 240,'Curva/100','LIB/EUR',226,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 241,'Curva/100','LIB/EUR',227,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 242,'Curva/100','LIB/EUR',228,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 243,'Curva/100','LIB/EUR',229,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 244,'Curva/100','LIB/EUR',230,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 245,'Curva/100','LIB/EUR',231,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 246,'Curva/100','LIB/EUR',232,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 247,'Curva/100','LIB/EUR',233,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 248,'Curva/100','LIB/EUR',234,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 249,'Curva/100','LIB/EUR',235,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 250,'Curva/100','LIB/EUR',236,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 251,'Curva/100','LIB/EUR',237,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 252,'Curva/100','LIB/EUR',238,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 253,'Curva/100','LIB/EUR',239,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 254,'Curva/100','LIB/EUR',240,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 255,'Curva/100','LIB/EUR',241,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 256,'Curva/100','LIB/EUR',242,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 257,'Curva/100','LIB/EUR',243,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 258,'Curva/100','LIB/EUR',244,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 259,'Curva/100','LIB/EUR',245,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 260,'Curva/100','LIB/EUR',246,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 261,'Curva/100','LIB/EUR',247,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 262,'Curva/100','LIB/EUR',248,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 263,'Curva/100','LIB/EUR',249,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 264,'Curva/100','LIB/EUR',250,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 265,'Curva/100','LIB/EUR',251,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 266,'Curva/100','LIB/EUR',252,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 267,'Curva/100','LIB/EUR',253,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 268,'Curva/100','LIB/EUR',254,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 269,'Curva/100','LIB/EUR',255,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 270,'Curva/100','LIB/EUR',256,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 271,'Curva/100','LIB/EUR',257,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 272,'Curva/100','LIB/EUR',258,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 273,'Curva/100','LIB/EUR',259,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 274,'Curva/100','LIB/EUR',260,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 275,'Curva/100','LIB/EUR',261,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 276,'Curva/100','LIB/EUR',262,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 277,'Curva/100','LIB/EUR',263,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 278,'Curva/100','LIB/EUR',264,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 279,'Curva/100','LIB/EUR',265,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 280,'Curva/100','LIB/EUR',266,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 281,'Curva/100','LIB/EUR',267,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 282,'Curva/100','LIB/EUR',268,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 283,'Curva/100','LIB/EUR',269,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 284,'Curva/100','LIB/EUR',270,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 285,'Curva/100','LIB/EUR',271,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 286,'Curva/100','LIB/EUR',272,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 287,'Curva/100','LIB/EUR',273,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 288,'Curva/100','LIB/EUR',274,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 289,'Curva/100','LIB/EUR',275,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 290,'Curva/100','LIB/EUR',276,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 291,'Curva/100','LIB/EUR',277,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 292,'Curva/100','LIB/EUR',278,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 293,'Curva/100','LIB/EUR',279,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 294,'Curva/100','LIB/EUR',280,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 295,'Curva/100','LIB/EUR',281,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 296,'Curva/100','LIB/EUR',282,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 297,'Curva/100','LIB/EUR',283,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 298,'Curva/100','LIB/EUR',284,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 299,'Curva/100','LIB/EUR',285,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 300,'Curva/100','LIB/EUR',286,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 301,'Curva/100','LIB/EUR',287,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 302,'Curva/100','LIB/EUR',288,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 303,'Curva/100','LIB/EUR',289,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 304,'Curva/100','LIB/EUR',290,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 305,'Curva/100','LIB/EUR',291,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 306,'Curva/100','LIB/EUR',292,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 307,'Curva/100','LIB/EUR',293,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 308,'Curva/100','LIB/EUR',294,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 309,'Curva/100','LIB/EUR',295,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 310,'Curva/100','LIB/EUR',296,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 311,'Curva/100','LIB/EUR',297,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 312,'Curva/100','LIB/EUR',298,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 313,'Curva/100','LIB/EUR',299,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 314,'Curva/100','LIB/EUR',300,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 315,'Curva/100','LIB/EUR',301,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 316,'Curva/100','LIB/EUR',302,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 317,'Curva/100','LIB/EUR',303,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 318,'Curva/100','LIB/EUR',304,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 319,'Curva/100','LIB/EUR',305,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 320,'Curva/100','LIB/EUR',306,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 321,'Curva/100','LIB/EUR',307,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 322,'Curva/100','LIB/EUR',308,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 323,'Curva/100','LIB/EUR',309,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 324,'Curva/100','LIB/EUR',310,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 325,'Curva/100','LIB/EUR',311,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 326,'Curva/100','LIB/EUR',312,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 327,'Curva/100','LIB/EUR',313,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 328,'Curva/100','LIB/EUR',314,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 329,'Curva/100','LIB/EUR',315,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 330,'Curva/100','LIB/EUR',316,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 331,'Curva/100','LIB/EUR',317,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 332,'Curva/100','LIB/EUR',318,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 333,'Curva/100','LIB/EUR',319,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 334,'Curva/100','LIB/EUR',320,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 335,'Curva/100','LIB/EUR',321,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 336,'Curva/100','LIB/EUR',322,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 337,'Curva/100','LIB/EUR',323,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 338,'Curva/100','LIB/EUR',324,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 339,'Curva/100','LIB/EUR',325,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 340,'Curva/100','LIB/EUR',326,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 341,'Curva/100','LIB/EUR',327,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 342,'Curva/100','LIB/EUR',328,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 343,'Curva/100','LIB/EUR',329,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 344,'Curva/100','LIB/EUR',330,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 345,'Curva/100','LIB/EUR',331,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 346,'Curva/100','LIB/EUR',332,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 347,'Curva/100','LIB/EUR',333,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 348,'Curva/100','LIB/EUR',334,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 349,'Curva/100','LIB/EUR',335,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 350,'Curva/100','LIB/EUR',336,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 351,'Curva/100','LIB/EUR',337,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 352,'Curva/100','LIB/EUR',338,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 353,'Curva/100','LIB/EUR',339,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 354,'Curva/100','LIB/EUR',340,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 355,'Curva/100','LIB/EUR',341,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 356,'Curva/100','LIB/EUR',342,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 357,'Curva/100','LIB/EUR',343,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 358,'Curva/100','LIB/EUR',344,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 359,'Curva/100','LIB/EUR',345,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 360,'Curva/100','LIB/EUR',346,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 361,'Curva/100','LIB/EUR',347,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 362,'Curva/100','LIB/EUR',348,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 363,'Curva/100','LIB/EUR',349,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 364,'Curva/100','LIB/EUR',350,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 365,'Curva/100','LIB/EUR',351,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 366,'Curva/100','LIB/EUR',352,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 367,'Curva/100','LIB/EUR',353,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 368,'Curva/100','LIB/EUR',354,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 369,'Curva/100','LIB/EUR',355,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 370,'Curva/100','LIB/EUR',356,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 371,'Curva/100','LIB/EUR',357,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 372,'Curva/100','LIB/EUR',358,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 373,'Curva/100','LIB/EUR',359,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 374,'Curva/100','LIB/EUR',360,'LIBOR EURO/', -999  
 INSERT #tblDirectives SELECT @intData + 375,'Curva/100','LIB/GBP',1,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 376,'Curva/100','LIB/GBP',2,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 377,'Curva/100','LIB/GBP',3,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 378,'Curva/100','LIB/GBP',4,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 379,'Curva/100','LIB/GBP',5,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 380,'Curva/100','LIB/GBP',6,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 381,'Curva/100','LIB/GBP',7,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 382,'Curva/100','LIB/GBP',8,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 383,'Curva/100','LIB/GBP',9,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 384,'Curva/100','LIB/GBP',10,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 385,'Curva/100','LIB/GBP',11,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 386,'Curva/100','LIB/GBP',12,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 387,'Curva/100','LIB/GBP',13,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 388,'Curva/100','LIB/GBP',14,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 389,'Curva/100','LIB/GBP',15,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 390,'Curva/100','LIB/GBP',16,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 391,'Curva/100','LIB/GBP',17,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 392,'Curva/100','LIB/GBP',18,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 393,'Curva/100','LIB/GBP',19,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 394,'Curva/100','LIB/GBP',20,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 395,'Curva/100','LIB/GBP',21,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 396,'Curva/100','LIB/GBP',22,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 397,'Curva/100','LIB/GBP',23,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 398,'Curva/100','LIB/GBP',24,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 399,'Curva/100','LIB/GBP',25,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 400,'Curva/100','LIB/GBP',26,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 401,'Curva/100','LIB/GBP',27,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 402,'Curva/100','LIB/GBP',28,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 403,'Curva/100','LIB/GBP',29,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 404,'Curva/100','LIB/GBP',30,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 405,'Curva/100','LIB/GBP',31,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 406,'Curva/100','LIB/GBP',32,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 407,'Curva/100','LIB/GBP',33,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 408,'Curva/100','LIB/GBP',34,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 409,'Curva/100','LIB/GBP',35,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 410,'Curva/100','LIB/GBP',36,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 411,'Curva/100','LIB/GBP',37,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 412,'Curva/100','LIB/GBP',38,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 413,'Curva/100','LIB/GBP',39,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 414,'Curva/100','LIB/GBP',40,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 415,'Curva/100','LIB/GBP',41,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 416,'Curva/100','LIB/GBP',42,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 417,'Curva/100','LIB/GBP',43,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 418,'Curva/100','LIB/GBP',44,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 419,'Curva/100','LIB/GBP',45,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 420,'Curva/100','LIB/GBP',46,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 421,'Curva/100','LIB/GBP',47,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 422,'Curva/100','LIB/GBP',48,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 423,'Curva/100','LIB/GBP',49,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 424,'Curva/100','LIB/GBP',50,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 425,'Curva/100','LIB/GBP',51,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 426,'Curva/100','LIB/GBP',52,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 427,'Curva/100','LIB/GBP',53,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 428,'Curva/100','LIB/GBP',54,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 429,'Curva/100','LIB/GBP',55,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 430,'Curva/100','LIB/GBP',56,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 431,'Curva/100','LIB/GBP',57,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 432,'Curva/100','LIB/GBP',58,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 433,'Curva/100','LIB/GBP',59,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 434,'Curva/100','LIB/GBP',60,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 435,'Curva/100','LIB/GBP',61,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 436,'Curva/100','LIB/GBP',62,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 437,'Curva/100','LIB/GBP',63,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 438,'Curva/100','LIB/GBP',64,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 439,'Curva/100','LIB/GBP',65,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 440,'Curva/100','LIB/GBP',66,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 441,'Curva/100','LIB/GBP',67,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 442,'Curva/100','LIB/GBP',68,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 443,'Curva/100','LIB/GBP',69,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 444,'Curva/100','LIB/GBP',70,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 445,'Curva/100','LIB/GBP',71,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 446,'Curva/100','LIB/GBP',72,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 447,'Curva/100','LIB/GBP',73,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 448,'Curva/100','LIB/GBP',74,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 449,'Curva/100','LIB/GBP',75,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 450,'Curva/100','LIB/GBP',76,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 451,'Curva/100','LIB/GBP',77,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 452,'Curva/100','LIB/GBP',78,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 453,'Curva/100','LIB/GBP',79,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 454,'Curva/100','LIB/GBP',80,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 455,'Curva/100','LIB/GBP',81,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 456,'Curva/100','LIB/GBP',82,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 457,'Curva/100','LIB/GBP',83,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 458,'Curva/100','LIB/GBP',84,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 459,'Curva/100','LIB/GBP',85,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 460,'Curva/100','LIB/GBP',86,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 461,'Curva/100','LIB/GBP',87,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 462,'Curva/100','LIB/GBP',88,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 463,'Curva/100','LIB/GBP',89,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 464,'Curva/100','LIB/GBP',90,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 465,'Curva/100','LIB/GBP',91,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 466,'Curva/100','LIB/GBP',92,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 467,'Curva/100','LIB/GBP',93,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 468,'Curva/100','LIB/GBP',94,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 469,'Curva/100','LIB/GBP',95,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 470,'Curva/100','LIB/GBP',96,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 471,'Curva/100','LIB/GBP',97,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 472,'Curva/100','LIB/GBP',98,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 473,'Curva/100','LIB/GBP',99,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 474,'Curva/100','LIB/GBP',100,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 475,'Curva/100','LIB/GBP',101,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 476,'Curva/100','LIB/GBP',102,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 477,'Curva/100','LIB/GBP',103,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 478,'Curva/100','LIB/GBP',104,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 479,'Curva/100','LIB/GBP',105,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 480,'Curva/100','LIB/GBP',106,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 481,'Curva/100','LIB/GBP',107,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 482,'Curva/100','LIB/GBP',108,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 483,'Curva/100','LIB/GBP',109,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 484,'Curva/100','LIB/GBP',110,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 485,'Curva/100','LIB/GBP',111,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 486,'Curva/100','LIB/GBP',112,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 487,'Curva/100','LIB/GBP',113,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 488,'Curva/100','LIB/GBP',114,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 489,'Curva/100','LIB/GBP',115,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 490,'Curva/100','LIB/GBP',116,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 491,'Curva/100','LIB/GBP',117,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 492,'Curva/100','LIB/GBP',118,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 493,'Curva/100','LIB/GBP',119,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 494,'Curva/100','LIB/GBP',120,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 495,'Curva/100','LIB/GBP',121,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 496,'Curva/100','LIB/GBP',122,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 497,'Curva/100','LIB/GBP',123,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 498,'Curva/100','LIB/GBP',124,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 499,'Curva/100','LIB/GBP',125,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 500,'Curva/100','LIB/GBP',126,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 501,'Curva/100','LIB/GBP',127,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 502,'Curva/100','LIB/GBP',128,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 503,'Curva/100','LIB/GBP',129,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 504,'Curva/100','LIB/GBP',130,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 505,'Curva/100','LIB/GBP',131,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 506,'Curva/100','LIB/GBP',132,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 507,'Curva/100','LIB/GBP',133,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 508,'Curva/100','LIB/GBP',134,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 509,'Curva/100','LIB/GBP',135,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 510,'Curva/100','LIB/GBP',136,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 511,'Curva/100','LIB/GBP',137,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 512,'Curva/100','LIB/GBP',138,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 513,'Curva/100','LIB/GBP',139,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 514,'Curva/100','LIB/GBP',140,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 515,'Curva/100','LIB/GBP',141,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 516,'Curva/100','LIB/GBP',142,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 517,'Curva/100','LIB/GBP',143,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 518,'Curva/100','LIB/GBP',144,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 519,'Curva/100','LIB/GBP',145,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 520,'Curva/100','LIB/GBP',146,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 521,'Curva/100','LIB/GBP',147,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 522,'Curva/100','LIB/GBP',148,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 523,'Curva/100','LIB/GBP',149,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 524,'Curva/100','LIB/GBP',150,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 525,'Curva/100','LIB/GBP',151,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 526,'Curva/100','LIB/GBP',152,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 527,'Curva/100','LIB/GBP',153,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 528,'Curva/100','LIB/GBP',154,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 529,'Curva/100','LIB/GBP',155,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 530,'Curva/100','LIB/GBP',156,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 531,'Curva/100','LIB/GBP',157,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 532,'Curva/100','LIB/GBP',158,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 533,'Curva/100','LIB/GBP',159,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 534,'Curva/100','LIB/GBP',160,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 535,'Curva/100','LIB/GBP',161,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 536,'Curva/100','LIB/GBP',162,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 537,'Curva/100','LIB/GBP',163,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 538,'Curva/100','LIB/GBP',164,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 539,'Curva/100','LIB/GBP',165,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 540,'Curva/100','LIB/GBP',166,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 541,'Curva/100','LIB/GBP',167,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 542,'Curva/100','LIB/GBP',168,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 543,'Curva/100','LIB/GBP',169,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 544,'Curva/100','LIB/GBP',170,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 545,'Curva/100','LIB/GBP',171,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 546,'Curva/100','LIB/GBP',172,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 547,'Curva/100','LIB/GBP',173,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 548,'Curva/100','LIB/GBP',174,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 549,'Curva/100','LIB/GBP',175,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 550,'Curva/100','LIB/GBP',176,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 551,'Curva/100','LIB/GBP',177,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 552,'Curva/100','LIB/GBP',178,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 553,'Curva/100','LIB/GBP',179,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 554,'Curva/100','LIB/GBP',180,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 555,'Curva/100','LIB/GBP',181,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 556,'Curva/100','LIB/GBP',182,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 557,'Curva/100','LIB/GBP',183,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 558,'Curva/100','LIB/GBP',184,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 559,'Curva/100','LIB/GBP',185,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 560,'Curva/100','LIB/GBP',186,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 561,'Curva/100','LIB/GBP',187,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 562,'Curva/100','LIB/GBP',188,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 563,'Curva/100','LIB/GBP',189,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 564,'Curva/100','LIB/GBP',190,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 565,'Curva/100','LIB/GBP',191,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 566,'Curva/100','LIB/GBP',192,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 567,'Curva/100','LIB/GBP',193,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 568,'Curva/100','LIB/GBP',194,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 569,'Curva/100','LIB/GBP',195,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 570,'Curva/100','LIB/GBP',196,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 571,'Curva/100','LIB/GBP',197,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 572,'Curva/100','LIB/GBP',198,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 573,'Curva/100','LIB/GBP',199,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 574,'Curva/100','LIB/GBP',200,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 575,'Curva/100','LIB/GBP',201,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 576,'Curva/100','LIB/GBP',202,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 577,'Curva/100','LIB/GBP',203,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 578,'Curva/100','LIB/GBP',204,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 579,'Curva/100','LIB/GBP',205,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 580,'Curva/100','LIB/GBP',206,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 581,'Curva/100','LIB/GBP',207,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 582,'Curva/100','LIB/GBP',208,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 583,'Curva/100','LIB/GBP',209,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 584,'Curva/100','LIB/GBP',210,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 585,'Curva/100','LIB/GBP',211,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 586,'Curva/100','LIB/GBP',212,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 587,'Curva/100','LIB/GBP',213,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 588,'Curva/100','LIB/GBP',214,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 589,'Curva/100','LIB/GBP',215,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 590,'Curva/100','LIB/GBP',216,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 591,'Curva/100','LIB/GBP',217,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 592,'Curva/100','LIB/GBP',218,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 593,'Curva/100','LIB/GBP',219,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 594,'Curva/100','LIB/GBP',220,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 595,'Curva/100','LIB/GBP',221,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 596,'Curva/100','LIB/GBP',222,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 597,'Curva/100','LIB/GBP',223,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 598,'Curva/100','LIB/GBP',224,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 599,'Curva/100','LIB/GBP',225,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 600,'Curva/100','LIB/GBP',226,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 601,'Curva/100','LIB/GBP',227,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 602,'Curva/100','LIB/GBP',228,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 603,'Curva/100','LIB/GBP',229,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 604,'Curva/100','LIB/GBP',230,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 605,'Curva/100','LIB/GBP',231,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 606,'Curva/100','LIB/GBP',232,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 607,'Curva/100','LIB/GBP',233,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 608,'Curva/100','LIB/GBP',234,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 609,'Curva/100','LIB/GBP',235,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 610,'Curva/100','LIB/GBP',236,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 611,'Curva/100','LIB/GBP',237,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 612,'Curva/100','LIB/GBP',238,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 613,'Curva/100','LIB/GBP',239,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 614,'Curva/100','LIB/GBP',240,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 615,'Curva/100','LIB/GBP',241,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 616,'Curva/100','LIB/GBP',242,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 617,'Curva/100','LIB/GBP',243,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 618,'Curva/100','LIB/GBP',244,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 619,'Curva/100','LIB/GBP',245,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 620,'Curva/100','LIB/GBP',246,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 621,'Curva/100','LIB/GBP',247,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 622,'Curva/100','LIB/GBP',248,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 623,'Curva/100','LIB/GBP',249,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 624,'Curva/100','LIB/GBP',250,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 625,'Curva/100','LIB/GBP',251,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 626,'Curva/100','LIB/GBP',252,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 627,'Curva/100','LIB/GBP',253,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 628,'Curva/100','LIB/GBP',254,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 629,'Curva/100','LIB/GBP',255,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 630,'Curva/100','LIB/GBP',256,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 631,'Curva/100','LIB/GBP',257,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 632,'Curva/100','LIB/GBP',258,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 633,'Curva/100','LIB/GBP',259,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 634,'Curva/100','LIB/GBP',260,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 635,'Curva/100','LIB/GBP',261,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 636,'Curva/100','LIB/GBP',262,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 637,'Curva/100','LIB/GBP',263,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 638,'Curva/100','LIB/GBP',264,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 639,'Curva/100','LIB/GBP',265,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 640,'Curva/100','LIB/GBP',266,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 641,'Curva/100','LIB/GBP',267,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 642,'Curva/100','LIB/GBP',268,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 643,'Curva/100','LIB/GBP',269,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 644,'Curva/100','LIB/GBP',270,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 645,'Curva/100','LIB/GBP',271,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 646,'Curva/100','LIB/GBP',272,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 647,'Curva/100','LIB/GBP',273,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 648,'Curva/100','LIB/GBP',274,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 649,'Curva/100','LIB/GBP',275,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 650,'Curva/100','LIB/GBP',276,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 651,'Curva/100','LIB/GBP',277,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 652,'Curva/100','LIB/GBP',278,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 653,'Curva/100','LIB/GBP',279,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 654,'Curva/100','LIB/GBP',280,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 655,'Curva/100','LIB/GBP',281,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 656,'Curva/100','LIB/GBP',282,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 657,'Curva/100','LIB/GBP',283,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 658,'Curva/100','LIB/GBP',284,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 659,'Curva/100','LIB/GBP',285,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 660,'Curva/100','LIB/GBP',286,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 661,'Curva/100','LIB/GBP',287,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 662,'Curva/100','LIB/GBP',288,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 663,'Curva/100','LIB/GBP',289,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 664,'Curva/100','LIB/GBP',290,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 665,'Curva/100','LIB/GBP',291,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 666,'Curva/100','LIB/GBP',292,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 667,'Curva/100','LIB/GBP',293,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 668,'Curva/100','LIB/GBP',294,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 669,'Curva/100','LIB/GBP',295,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 670,'Curva/100','LIB/GBP',296,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 671,'Curva/100','LIB/GBP',297,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 672,'Curva/100','LIB/GBP',298,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 673,'Curva/100','LIB/GBP',299,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 674,'Curva/100','LIB/GBP',300,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 675,'Curva/100','LIB/GBP',301,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 676,'Curva/100','LIB/GBP',302,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 677,'Curva/100','LIB/GBP',303,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 678,'Curva/100','LIB/GBP',304,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 679,'Curva/100','LIB/GBP',305,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 680,'Curva/100','LIB/GBP',306,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 681,'Curva/100','LIB/GBP',307,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 682,'Curva/100','LIB/GBP',308,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 683,'Curva/100','LIB/GBP',309,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 684,'Curva/100','LIB/GBP',310,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 685,'Curva/100','LIB/GBP',311,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 686,'Curva/100','LIB/GBP',312,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 687,'Curva/100','LIB/GBP',313,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 688,'Curva/100','LIB/GBP',314,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 689,'Curva/100','LIB/GBP',315,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 690,'Curva/100','LIB/GBP',316,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 691,'Curva/100','LIB/GBP',317,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 692,'Curva/100','LIB/GBP',318,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 693,'Curva/100','LIB/GBP',319,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 694,'Curva/100','LIB/GBP',320,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 695,'Curva/100','LIB/GBP',321,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 696,'Curva/100','LIB/GBP',322,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 697,'Curva/100','LIB/GBP',323,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 698,'Curva/100','LIB/GBP',324,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 699,'Curva/100','LIB/GBP',325,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 700,'Curva/100','LIB/GBP',326,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 701,'Curva/100','LIB/GBP',327,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 702,'Curva/100','LIB/GBP',328,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 703,'Curva/100','LIB/GBP',329,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 704,'Curva/100','LIB/GBP',330,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 705,'Curva/100','LIB/GBP',331,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 706,'Curva/100','LIB/GBP',332,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 707,'Curva/100','LIB/GBP',333,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 708,'Curva/100','LIB/GBP',334,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 709,'Curva/100','LIB/GBP',335,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 710,'Curva/100','LIB/GBP',336,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 711,'Curva/100','LIB/GBP',337,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 712,'Curva/100','LIB/GBP',338,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 713,'Curva/100','LIB/GBP',339,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 714,'Curva/100','LIB/GBP',340,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 715,'Curva/100','LIB/GBP',341,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 716,'Curva/100','LIB/GBP',342,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 717,'Curva/100','LIB/GBP',343,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 718,'Curva/100','LIB/GBP',344,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 719,'Curva/100','LIB/GBP',345,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 720,'Curva/100','LIB/GBP',346,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 721,'Curva/100','LIB/GBP',347,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 722,'Curva/100','LIB/GBP',348,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 723,'Curva/100','LIB/GBP',349,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 724,'Curva/100','LIB/GBP',350,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 725,'Curva/100','LIB/GBP',351,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 726,'Curva/100','LIB/GBP',352,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 727,'Curva/100','LIB/GBP',353,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 728,'Curva/100','LIB/GBP',354,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 729,'Curva/100','LIB/GBP',355,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 730,'Curva/100','LIB/GBP',356,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 731,'Curva/100','LIB/GBP',357,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 732,'Curva/100','LIB/GBP',358,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 733,'Curva/100','LIB/GBP',359,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 734,'Curva/100','LIB/GBP',360,'LIBOR GBP/', -999  
 INSERT #tblDirectives SELECT @intData + 735,'Curva/100','MSG/YLD',182,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 736,'Curva/100','MSG/YLD',364,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 737,'Curva/100','MSG/YLD',542,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 738,'Curva/100','MSG/YLD',728,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 739,'Curva/100','MSG/YLD',910,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 740,'Curva/100','MSG/YLD',1092,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 741,'Curva/100','MSG/YLD',1274,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 742,'Curva/100','MSG/YLD',1456,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 743,'Curva/100','MSG/YLD',1638,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 744,'Curva/100','MSG/YLD',1820,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 745,'Curva/100','MSG/YLD',2184,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 746,'Curva/100','MSG/YLD',2548,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 747,'Curva/100','MSG/YLD',2912,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 748,'Curva/100','MSG/YLD',3276,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 749,'Curva/100','MSG/YLD',3640,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 750,'Curva/100','MSG/YLD',5460,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 751,'Curva/100','MSG/YLD',7280,'BONOS YLD/', -999  
 INSERT #tblDirectives SELECT @intData + 752,'Curva/100','MSG/YLD',10950,'BONOS YLD/', -999  
  
 INSERT #tblDirectives SELECT @intData + 753,'Curva/100','LIB/LB',1,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 754,'Curva/100','LIB/LB',7,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 755,'Curva/100','LIB/LB',15,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 756,'Curva/100','LIB/LB',30,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 757,'Curva/100','LIB/LB',60,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 758,'Curva/100','LIB/LB',90,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 759,'Curva/100','LIB/LB',180,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 760,'Curva/100','LIB/LB',360,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 761,'Curva/100','LIB/LB',520,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 762,'Curva/100','LIB/LB',720,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 763,'Curva/100','LIB/LB',1090,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 764,'Curva/100','LIB/LB',1450,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 765,'Curva/100','LIB/LB',1800,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 766,'Curva/100','LIB/LB',3600,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 767,'Curva/100','LIB/LB',5400,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 768,'Curva/100','LIB/LB',7200,'LIBOR USD/', -999  
 INSERT #tblDirectives SELECT @intData + 769,'Curva/100','LIB/LB',10800,'LIBOR USD/', -999  
  
 INSERT #tblDirectives SELECT @intData + 770,'Curva/100','UDB/YLI',1,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 771,'Curva/100','UDB/YLI',182,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 772,'Curva/100','UDB/YLI',365,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 773,'Curva/100','UDB/YLI',728,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 774,'Curva/100','UDB/YLI',1092,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 775,'Curva/100','UDB/YLI',1456,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 776,'Curva/100','UDB/YLI',1820,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 777,'Curva/100','UDB/YLI',2184,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 778,'Curva/100','UDB/YLI',2548,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 779,'Curva/100','UDB/YLI',2912,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 780,'Curva/100','UDB/YLI',3276,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 781,'Curva/100','UDB/YLI',3640,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 782,'Curva/100','UDB/YLI',5460,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 783,'Curva/100','UDB/YLI',7280,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 784,'Curva/100','UDB/YLI',9100,'YIELD REAL/', -999  
 INSERT #tblDirectives SELECT @intData + 785,'Curva/100','UDB/YLI',10920,'YIELD REAL/', -999  
  
 INSERT #tblDirectives SELECT @intData + 786,'Curva/100','MSG/YLD',1,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 787,'Curva/100','MSG/YLD',7,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 788,'Curva/100','MSG/YLD',14,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 789,'Curva/100','MSG/YLD',28,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 790,'Curva/100','MSG/YLD',60,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 791,'Curva/100','MSG/YLD',91,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 792,'Curva/100','MSG/YLD',120,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 793,'Curva/100','MSG/YLD',150,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 794,'Curva/100','MSG/YLD',180,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 795,'Curva/100','MSG/YLD',270,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 796,'Curva/100','MSG/YLD',365,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 797,'Curva/100','MSG/YLD',546,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 798,'Curva/100','MSG/YLD',728,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 799,'Curva/100','MSG/YLD',1092,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 800,'Curva/100','MSG/YLD',1456,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 801,'Curva/100','MSG/YLD',1820,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 802,'Curva/100','MSG/YLD',2184,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 803,'Curva/100','MSG/YLD',2548,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 804,'Curva/100','MSG/YLD',2912,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 805,'Curva/100','MSG/YLD',3276,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 806,'Curva/100','MSG/YLD',3640,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 807,'Curva/100','MSG/YLD',5460,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 808,'Curva/100','MSG/YLD',7280,'YIELD DE BONOS/', -999  
 INSERT #tblDirectives SELECT @intData + 809,'Curva/100','MSG/YLD',10950,'YIELD DE BONOS/', -999  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtTipo,  
  txtId,  
  intPlazo,  
  txtAlias,  
  dblValue  
 FROM #tblDirectives  
 ORDER BY   
  intSerial  
  
END  
  
  
-- para extraer las directivas para el archivo de   
-- curvas  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;7  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @intData AS INT  
 DECLARE @intTerm AS INT  
 DECLARE @intNode AS INT  
 DECLARE @intMaxNode AS INT  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dblRate AS FLOAT  
   
 -- tabla temporal  
 SELECT   
  -999 AS intSerial,  
  REPLICATE(' ', 50) AS txtCode,  
  REPLICATE(' ', 50) AS txtMet,  
  REPLICATE(' ', 50) AS txtType,  
  REPLICATE(' ', 50) AS txtSubType,  
  -999 AS intMaxTerm,  
  REPLICATE(' ', 50) AS txtFile  
 INTO #tblDirectives  
 TRUNCATE TABLE #tblDirectives  
  
 INSERT #tblDirectives SELECT 1, 'US1', 'Curva','LIB','LB', 5475, 'pip_us1_'  
 INSERT #tblDirectives SELECT 2, 'IR1', 'Curva','SWP','TI', -999, 'pip_ir1_'  
 INSERT #tblDirectives SELECT 3, 'IR2', 'Curva','CET','IRS', 5475, 'pip_ir2_'  
 INSERT #tblDirectives SELECT 4, 'US2', 'Curva/Alt1','LIB','LB', 5475, 'pip_us2_'  
 INSERT #tblDirectives SELECT 5, 'FW1', 'Curva/Alt1','SWP','TI', -999, 'pip_fw1_'  
 INSERT #tblDirectives SELECT 6, 'UT1', 'Curva','UDT','SWP', 5475, 'pip_uTi1_'  
 INSERT #tblDirectives SELECT 7, 'UT2', 'Curva/Alt1','UDT','SWP', 5475, 'pip_uTi2_'  
 INSERT #tblDirectives SELECT 8, 'UL1', 'Curva','ULS','SWP', 5475, 'pip_uLi1_'  
 INSERT #tblDirectives SELECT 9, 'UL2', 'Curva/Alt1','ULS','SWP', 5475, 'pip_uLi2_'  
 INSERT #tblDirectives SELECT 10, 'FW2', 'Curva/Alt1','FWD','CU', -999, 'pip_fw2_'  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtCode,  
  txtMet,  
  txtType,  
  txtSubType,  
  intMaxTerm,  
  txtFile  
 FROM #tblDirectives  
 ORDER BY   
  intSerial  
  
END  
  
-- para extraer las directivas para el archivo de   
-- tasas  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;8  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @intData AS INT  
 DECLARE @intTerm AS INT  
 DECLARE @intNode AS INT  
 DECLARE @intMaxNode AS INT  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dblRate AS FLOAT  
   
 -- tabla temporal  
 SELECT   
  -999 AS intSerial,  
  REPLICATE(' ', 50) AS txtCode,  
  REPLICATE(' ', 50) AS txtMet,  
  REPLICATE(' ', 50) AS txtType,  
  REPLICATE(' ', 50) AS txtSubType,  
  -999 AS intMaxTerm  
 INTO #tblDirectives  
 TRUNCATE TABLE #tblDirectives  
  
 INSERT #tblDirectives SELECT 1, 'LIBOR', 'Curva','LIB','LB', -999  
 INSERT #tblDirectives SELECT 2, 'TIIE28', 'Curva','SWP','TI', 10961  
 INSERT #tblDirectives SELECT 3, 'TBOND30 YIELD', 'Curva','TSN','YLD', 11990  
 INSERT #tblDirectives SELECT 4, 'TBOND30 ZCPO', 'Curva','TSN','YTS', 11990  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtCode,  
  txtMet,  
  txtType,  
  txtSubType,  
  intMaxTerm  
 FROM #tblDirectives  
 ORDER BY   
  intSerial  
  
END  
  
-- para extraer las directivas para el archivo de   
-- tipos de cambio  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;9  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @intData AS INT  
 DECLARE @intTerm AS INT  
 DECLARE @intNode AS INT  
 DECLARE @intMaxNode AS INT  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dblRate AS FLOAT  
   
 -- tabla temporal  
 SELECT   
  -999 AS intSerial,  
  REPLICATE(' ', 50) AS txtIrc,  
  REPLICATE(' ', 50) AS txtIrcCode,  
  REPLICATE(' ', 50) AS txtType,  
  REPLICATE(' ', 50) AS txtSubType,  
  REPLICATE(' ', 50) AS txtFile  
 INTO #tblDirectives  
 TRUNCATE TABLE #tblDirectives  
  
 INSERT #tblDirectives SELECT 1, 'EURUS2', 'TC Spot MXN/EUR','FPM','EUR', 'JPPFwd_MXN_EUR'  
 INSERT #tblDirectives SELECT 2, 'GBPUS2', 'TC Spot MXN/GBP','FPM','GBP', 'JPPFwd_MXN_GBP'  
 INSERT #tblDirectives SELECT 3, 'EURUS2', 'TC Spot MXN/EUR','FTM','EUR', 'JPTCFwd_MXN_EUR'  
 INSERT #tblDirectives SELECT 4, 'GBPUS2', 'TC Spot MXN/GBP','FTM','GBP', 'JPTCFwd_MXN_GBP'  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtIrc,  
  txtIrcCode,  
  txtType,  
  txtSubType,  
  txtFile  
 FROM #tblDirectives  
 ORDER BY   
  intSerial  
  
END  
  
-- para extraer las directivas para el archivo de   
-- curvas formato pagina WEB (Version PiP 2006)  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;10  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 DECLARE @intData AS INT  
 DECLARE @intTerm AS INT  
 DECLARE @intNode AS INT  
 DECLARE @intMaxNode AS INT  
 DECLARE @txtId1 AS CHAR(11)  
 DECLARE @dblRate AS FLOAT  
   
 -- tabla temporal  
 SELECT   
  -999 AS intSerial,  
  REPLICATE(' ', 50) AS txtCode,  
  REPLICATE(' ', 50) AS txtMet,  
  REPLICATE(' ', 50) AS txtType,  
  REPLICATE(' ', 50) AS txtSubType,  
  -999 AS intMaxTerm,  
  REPLICATE(' ', 50) AS txtFile,  
  REPLICATE(' ', 50) AS txtLabel  
 INTO #tblDirectives  
 TRUNCATE TABLE #tblDirectives  
  
 INSERT #tblDirectives SELECT 1, 'CETES', 'Curva','FWD','CU', -999, 'CETES_JPM','Tasa implícita Pesos Todos los Plazos Fecha '  
 INSERT #tblDirectives SELECT 2, 'UDIS', 'Curva','UDB','U%', -999, 'UDIS_JPM','Tasa real sin impto. Todos los Plazos Fecha '  
  
 SET NOCOUNT OFF  
  
 -- regreso el reporte  
 SELECT   
  intSerial,  
  txtCode,  
  txtMet,  
  txtType,  
  txtSubType,  
  intMaxTerm,  
  txtFile,  
  txtLabel  
 FROM #tblDirectives  
 ORDER BY   
  intSerial  
  
END  
  
-- Para Generar Producto: JPMorgan_aaaammdd.xls  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;11  
 @txtDate AS DATETIME  
  
 /*   
  
   Version 1.0    
     
    Procedimiento que genera el PRODUCTO JPMorgan_aaaammdd.xls  
      Creado por :  Lic. René López Salinas  
    Fecha: 03-Oct-2008  
  
 */  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
  SELECT   
   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],  
   ap.txtTv AS [Tipo Valor],  
   ap.txtEmisora AS [Emisora],  
   ap.txtSerie AS [Serie],  
   (CASE WHEN LEN(a1.txtId2) = 12 THEN a1.txtId2 ELSE '0' END) AS [ISIN],  
   ROUND(ap.dblPRL,6) AS [Precio Limpio MD],  
   (CASE WHEN ap.dblLDR <> -999.0 THEN ap.dblLDR ELSE 0 END) AS [Sobretasa de Valuación MD],  
   (CASE WHEN ap.dblYTM <> -999.0 THEN ap.dblYTM ELSE 0 END) AS [Rend a vto MD],  
   (CASE WHEN a1.txtDMC <> 'NA' AND a1.txtDTC <> '-' THEN a1.txtDMC ELSE ' ' END) AS [Duración Macaulay]  
  FROM   
   MxFixIncome.dbo.tmp_tblActualPrices AS ap (NOLOCK)  
   INNER JOIN MxFixIncome.dbo.tmp_tblActualAnalytics_1 AS a1 (NOLOCK)  
    ON a1.txtId1 = ap.txtId1  
     AND a1.txtLiquidation = (  
      CASE ap.txtLiquidation    
      WHEN 'MP' THEN 'MD'    
      ELSE ap.txtLiquidation    
      END  
      )  
  WHERE   
   ap.txtLiquidation IN ('MD', 'MP')  
   AND ap.txtTv IN ('2','2P','2U','3','3P','3U','41','4P','4U','6U','71','73','75','76','90','91','92','93','93SP',  
    '94','95','96','97','98','BI','CC','CP','D','D1','D1SP','D2','D2SP','D3','D3SP','D4','D4SP','D5','D5SP',  
    'D6','D6SP','D7','D7SP','D8','D8SP','F','FSP','G','I','IL','IP','IS','IT','J','JSP','JI','L','LD','LP',  
    'LS','LT','M','M0','M3','M5','M7','MC','MP','PI','Q','QSP','R','R1','R3','R3SP','RC','S','S0','S3','S5',  
    'SC','SP','XA')  
  ORDER by ap.txtTv,ap.txtEmisora,ap.txtSerie  
  
 SET NOCOUNT OFF   
  
END  
RETURN 0  
  
-- Para Generar Productos: Curvas 2 JPMORGAN  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;12  
 @txtDate AS DATETIME,  
 @txtType AS VARCHAR(3),  
 @txtSubType AS VARCHAR(3),  
 @txtCodigo AS VARCHAR(10),  
 @dblFactor AS FLOAT = 1  
  
 /*   
  
   Version 1.1  
     
    Procedimiento que genera los productos:   
     PiP_udlb_aaaammdd.txt, PiP_imp_aaaammdd.txt,PiP_lib_aaaammdd.txt,PiP_irs_aaaammdd.txt,PiP_cirs_aaaammdd.txt  
      Creado por:  Lic. René López Salinas  
    Modificado por: CSOLORIO 20100205  
    Descripcion Modificacion: Modifico el order by para que ordene por intSection  
    Fecha: 03-Oct-2008  
  
 */  
  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 -- genera tabla temporal de resultados  
  
 DECLARE @tblResult TABLE (  
  [intSection][INTEGER],  
  [CodigoTasa][VARCHAR](30),  
  [Periodo][VARCHAR](30),  
  [ValorTasa][VARCHAR](30),  
  [ValorFactorDescuento][VARCHAR](30),  
  [FechaTasa][VARCHAR](30)  
 )  
  
  
 INSERT @tblResult  
 SELECT   
  0,  
  'Codigo tasa' AS [CodigoTasa],  
  'Periodo'  AS [Periodo],  
  'Valor tasa' AS [ValorTasa],  
  'Valor Factor de descuento' AS [ValorFactorDescuento],  
  'Fecha tasa' AS [FechaTasa]  
  
 INSERT @tblResult  
 SELECT   
  1,  
  RTRIM(@txtCodigo) AS [CodigoTasa],  
  LTRIM(STR(intTerm,5,0)) AS [Periodo],  
  LTRIM(STR(dblRate*@dblFactor,11,4)) AS [ValorTasa],  
  LTRIM(STR(ROUND((1 / ( 1 + ( dblRate  * intTerm / 360 ) )),6),19,6)) AS [ValorFactorDescuento],  
  CONVERT(CHAR(8), @txtDate, 112) AS [FechaTasa]  
 FROM MxFixIncome.dbo.fun_get_curve_complete(@txtDate,@txtType,@txtSubType)  
 WHERE dteDate = @txtDate  
  AND txtType = @txtType  
  AND txtSubType = @txtSubType  
 ORDER BY intTerm  
  
 SELECT   
  CodigoTasa,  
  Periodo,  
  ValorTasa,  
  ValorFactorDescuento,  
  FechaTasa  
 FROM @tblResult  
    ORDER BY intSection, Periodo  
  
 SET NOCOUNT OFF   
  
END  
RETURN 0  
  
-- para generar el producto LiborIRS_YYYYMMDD.xls  
-- obtiene los Nodos especificados  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;13  
 @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 -- creo tabla temporal de determinados Nodos de Curvas   
 DECLARE @tmpLayoutxlFRPIP TABLE (  
  Row INT,  
  Label  VARCHAR(20),  
  Type  CHAR(3),  
  SubType  CHAR(5),  
  Node INT,  
  LabelNode VARCHAR(5),  
  dblValue FLOAT  
 )  
  
 -- Setting Info (FRPiP)  
 INSERT @tmpLayoutxlFRPIP  
      SELECT 01,'1D','LIB','LB',1,'cash',NULL UNION   
      SELECT 02,'1M','LIB','LB',28,'cash',NULL UNION   
      SELECT 03,'2M','LIB','LB',56,'cash',NULL UNION   
      SELECT 04,'3M','LIB','LB',84,'cash',NULL UNION   
      SELECT 05,'4M','LIB','LB',112,'cash',NULL UNION   
      SELECT 06,'5M','LIB','LB',140,'cash',NULL UNION   
      SELECT 07,'6M','LIB','LB',168,'cash',NULL UNION   
      SELECT 08,'9M','LIB','LB',252,'cash',NULL UNION   
      SELECT 09,'1Y','LIB','LB',364,'cash',NULL UNION         
      SELECT 10,'18M','LUS','SWP',532,'swap',NULL UNION         
      SELECT 11,'2Y','LUS','SWP',728,'swap',NULL UNION         
      SELECT 12,'3Y','LUS','SWP',1092,'swap',NULL UNION         
      SELECT 13,'4Y','LUS','SWP',1456,'swap',NULL UNION         
      SELECT 14,'5Y','LUS','SWP',1820,'swap',NULL UNION         
      SELECT 15,'6Y','LUS','SWP',2184,'swap',NULL UNION         
      SELECT 16,'7Y','LUS','SWP',2548,'swap',NULL UNION         
      SELECT 17,'8Y','LUS','SWP',2912,'swap',NULL UNION         
      SELECT 18,'9Y','LUS','SWP',3276,'swap',NULL UNION         
      SELECT 19,'10Y','LUS','SWP',3640,'swap',NULL UNION         
      SELECT 20,'12Y','LUS','SWP',4368,'swap',NULL UNION         
      SELECT 21,'15Y','LUS','SWP',5460,'swap',NULL UNION         
      SELECT 22,'20Y','LUS','SWP',7280,'swap',NULL UNION         
      SELECT 23,'25Y','LUS','SWP',9100,'swap',NULL UNION         
      SELECT 24,'30Y','LUS','SWP',10920,'swap',NULL  
  
 -- Obtengo los valores de los FRPiP  
 UPDATE @tmpLayoutxlFRPIP  
  SET dblValue = (SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0'))  
 FROM @tmpLayoutxlFRPIP AS FR  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmpLayoutxlFRPIP) = 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  IF ((SELECT count(*) FROM @tmpLayoutxlFRPIP WHERE dblValue IS NULL OR dblValue = -999) > 0)  
  
   BEGIN  
    RAISERROR ('ERROR: Falta Informacion', 16, 1)  
   END  
  
  ELSE  
  
   SELECT   
     CONVERT(CHAR(8),@txtDate,112) AS [dteDate],  
     RTRIM(Label) AS [Label],  
     RTRIM(LabelNode) AS [LabelNode],  
     CASE WHEN dblValue IS NULL OR dblValue = -999  
       THEN ''  
       ELSE  
       LTRIM(STR(dblValue,19,8))  
     END AS [dblValue]   
   FROM @tmpLayoutxlFRPIP   
  
 SET NOCOUNT OFF  
  
END  
-- para generar el producto TIIEIRS_YYYYMMDD.xls  
-- obtiene los Nodos especificados  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;14  
 @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 -- creo tabla temporal de determinados Nodos de Curvas   
 DECLARE @tmpLayoutxlFRPIP TABLE (  
  Row INT,  
  Label  VARCHAR(20),  
  Type  CHAR(3),  
  SubType  CHAR(5),  
  Node INT,  
  LabelNode VARCHAR(5),  
  dblValue FLOAT  
 )  
  
 -- Setting Info (FRPiP)  
 INSERT @tmpLayoutxlFRPIP  
      SELECT 01,'1','SWP','TI',1,'ON',NULL UNION   
      SELECT 02,'28','SWP','TI',28,'1X1',NULL UNION   
      SELECT 03,'84','TIE','SWP',84,'3X1',NULL UNION   
      SELECT 04,'168','TIE','SWP',168,'6X1',NULL UNION   
      SELECT 05,'252','TIE','SWP',252,'9X1',NULL UNION   
      SELECT 06,'364','TIE','SWP',364,'13x1',NULL UNION   
      SELECT 07,'728','TIE','SWP',728,'26x1',NULL UNION   
      SELECT 08,'1092','TIE','SWP',1092,'39x1',NULL UNION   
      SELECT 09,'1456','TIE','SWP',1456,'52x1',NULL UNION   
      SELECT 10,'1820','TIE','SWP',1820,'65x1',NULL UNION   
      SELECT 11,'2548','TIE','SWP',2548,'91x1',NULL UNION   
      SELECT 12,'3640','TIE','SWP',3640,'130x1',NULL UNION   
      SELECT 13,'4368','TIE','SWP',4368,'156x1',NULL UNION   
      SELECT 14,'5460','TIE','SWP',5460,'195x1',NULL UNION   
      SELECT 15,'7280','TIE','SWP',7280,'260x1',NULL UNION   
      SELECT 16,'10920','TIE','SWP',10920,'390x1',NULL  
  
 -- Obtengo los valores de los FRPiP  
 UPDATE @tmpLayoutxlFRPIP  
  SET dblValue = (SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0'))  
 FROM @tmpLayoutxlFRPIP AS FR  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmpLayoutxlFRPIP) = 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  IF ((SELECT count(*) FROM @tmpLayoutxlFRPIP WHERE dblValue IS NULL OR dblValue = -999) > 0)  
  
   BEGIN  
    RAISERROR ('ERROR: Falta Informacion', 16, 1)  
   END  
  
  ELSE  
  
   SELECT   
     CONVERT(CHAR(8),@txtDate,112) AS [dteDate],  
     RTRIM(Label) AS [Label],  
     RTRIM(LabelNode) AS [LabelNode],  
     CASE WHEN dblValue IS NULL OR dblValue = -999  
       THEN ''  
       ELSE  
       LTRIM(STR(dblValue,19,8))  
     END AS [dblValue]   
   FROM @tmpLayoutxlFRPIP   
  
 SET NOCOUNT OFF  
  
END  
  
-------------------------------------------------------------------------------  
--   Autor:     Mike Ramirez  
--   Fecha Modificacion: 11:13 2013-04-23  
--   Descripcion:   Modulo 15: Se incluyen dos nuevos tipos de cambio JPY y CAD    
-------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;15  
 @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row  CHAR(60),  
  Consecutivo INT  
  PRIMARY KEY(Consecutivo,Row)  
 )  
  
 INSERT @tmp_tblResults  
  SELECT   
   CONVERT(CHAR(8), i.dteDate,112) +  CHAR(9) +   
   'USD' +  CHAR(9) +   
   LTRIM(STR(ROUND(i.dblValue,6),14,6)) AS [Row],  
   1 AS [Consecutivo]  
  FROM   
   MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
  WHERE  
   i.dteDate = @txtDate  
   AND i.txtIRC = 'UFXU'  
  
 INSERT @tmp_tblResults  
  SELECT   
   CONVERT(CHAR(8), i.dteDate,112) +  CHAR(9) +   
   'MXV' +  CHAR(9) +   
   LTRIM(STR(ROUND(i.dblValue,6),14,6)) AS [Row],  
   2 AS [Consecutivo]  
  FROM   
   MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
  WHERE  
   i.dteDate = @txtDate  
   AND i.txtIRC = 'UDI'  
  
 INSERT @tmp_tblResults  
  SELECT   
   CONVERT(CHAR(8), i.dteDate,112) +  CHAR(9) +   
   'EUR' +  CHAR(9) +   
   LTRIM(STR(ROUND(i.dblValue,6),14,6)) AS [Row],  
   3 AS [Consecutivo]  
  FROM   
   MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
  WHERE  
   i.dteDate = @txtDate  
   AND i.txtIRC = 'EURU'  
  
 INSERT @tmp_tblResults  
  SELECT   
   CONVERT(CHAR(8), i.dteDate,112) +  CHAR(9) +   
   'GBP' +  CHAR(9) +   
   LTRIM(STR(ROUND(i.dblValue,6),14,6)) AS [Row],  
   4 AS [Consecutivo]  
  FROM   
   MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
  WHERE  
   i.dteDate = @txtDate  
   AND i.txtIRC = 'GBPU'  
  
 INSERT @tmp_tblResults  
  SELECT   
   CONVERT(CHAR(8), i.dteDate,112) +  CHAR(9) +   
   'JPY' +  CHAR(9) +   
   LTRIM(STR(ROUND(i.dblValue,6),14,6)) AS [Row],  
   5 AS [Consecutivo]  
  FROM   
   MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
  WHERE  
   i.dteDate = @txtDate  
   AND i.txtIRC = 'JPYU'  
  
 INSERT @tmp_tblResults  
  SELECT   
   CONVERT(CHAR(8), i.dteDate,112) +  CHAR(9) +   
   'CAD' +  CHAR(9) +   
   LTRIM(STR(ROUND(i.dblValue,6),14,6)) AS [Row],  
   6 AS [Consecutivo]  
  FROM   
   MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
  WHERE  
   i.dteDate = @txtDate  
   AND i.txtIRC = 'CADX'  
  
 --Reporamos el vector  
 SELECT   
  RTRIM(Row)   
 FROM @tmp_tblResults   
 ORDER BY Consecutivo,Row  
  
 SET NOCOUNT OFF  
  
END  
--   Autor:          Lic. René López Salinas  
--   Creacion:   Modulo 16 (07:31 p.m. 2010-08-11)  
--   Descripcion:     Procedimiento generico que genera productos de curvas en formato CSV   
--   Modificado por: Lic. René López Salinas  
--   Modificacion: 03:36 p.m. 2010-08-17  
--   Descripcion:     Modificacion: Se agrega Tipo de Cambio Fix  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;16  
  @txtDate AS DATETIME,  
 @txtType AS VARCHAR(3),  
 @txtSubType AS VARCHAR(3)  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  Row INT,  
  TypeColumn VARCHAR(10),  
  Detail  VARCHAR(250)  
 )  
  
 DECLARE @dblFixBxco AS FLOAT  
  
 SET @dblFixBxco = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'UFXU')  
  
 -- Reporto Info:  PLAZO,TASA,  
 INSERT @tmp_tblResults   
 SELECT  00001 AS [Row],'Header 1' AS [TypeColumn],   
   'TC FIX BANXICO' + ',' +    
   LTRIM(STR(@dblFixBxco,21,9))  
  
 -- Reporto Info:  PLAZO,TASA,  
 INSERT @tmp_tblResults   
 SELECT  00002 AS [Row],'Detail'    AS [TypeColumn],   
   LTRIM(STR(intTerm,5,0))  + ',' +    
   LTRIM(STR(dblRate,21,9))  
  FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
  WHERE dteDate = CONVERT(CHAR(8),@txtDate,112)  
   AND txtType = @txtType  
   AND txtSubType = @txtSubType  
  ORDER BY intterm  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResults WHERE Detail IS NULL) > 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  IF ((SELECT count(*) FROM @tmp_tblResults WHERE Detail LIKE '%-999%') > 0)  
  
  BEGIN  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  END  
  
  ELSE  
  
   SELECT Detail FROM @tmp_tblResults  
  
 SET NOCOUNT OFF  
  
END  
--   Autor:         Lic. René López Salinas  
--   Creacion:  01:09 p.m. 2010-10-28  
--   Descripcion:   Modulo 17: Procedimiento que genera el producto JPMorgan_MXNVOLaaaammdd.xls  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;17  
 @txtDate DATETIME  
  
AS  
BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtCode CHAR(10),  
   intNode INT,  
   intCol INT,  
   intRow INT,  
   dblValue FLOAT NULL,  
   intStrike FLOAT NULL  
    PRIMARY KEY (intCol, intRow)  
  )   
  
 DECLARE @dblValue AS FLOAT   
  
 -- Configuración de Directivas  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 3, 7, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 3, 8, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 3, 9, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 3, 10, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 3, 11, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 3, 12, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 3, 13, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 3, 14, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 3, 15, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 3, 16, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 3, 17, 11.91  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 3, 18, 11.91  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 4, 7, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 4, 8, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 4, 9, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 4, 10, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 4, 11, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 4, 12, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 4, 13, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 4, 14, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 4, 15, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 4, 16, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 4, 17, 12.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 4, 18, 12.39  
  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 5, 7, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 5, 8, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 5, 9, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 5, 10, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 5, 11, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 5, 12, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 5, 13, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 5, 14, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 5, 15, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 5, 16, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 5, 17, 12.9  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 5, 18, 12.9  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 6, 7, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 6, 8, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 6, 9, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 6, 10, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 6, 11, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 6, 12, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 6, 13, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 6, 14, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 6, 15, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 6, 16, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 6, 17, 13.32  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 6, 18, 13.32  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 7, 7, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 7, 8, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 7, 9, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 7, 10, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 7, 11, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 7, 12, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 7, 13, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 7, 14, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 7, 15, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 7, 16, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 7, 17, 13.71  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 7, 18, 13.71  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 8, 7, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 8, 8, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 8, 9, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 8, 10, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 8, 11, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 8, 12, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 8, 13, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 8, 14, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 8, 15, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 8, 16, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 8, 17, 13.95  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 8, 18, 13.95  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 9, 7, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 9, 8, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 9, 9, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 9, 10, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 9, 11, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 9, 12, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 9, 13, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 9, 14, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 9, 15, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 9, 16, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 9, 17, 14.22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 9, 18, 14.22  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 10, 7, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 10, 8, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 10, 9, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 10, 10, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 10, 11, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 10, 12, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 10, 13, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 10, 14, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 10, 15, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 10, 16, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 10, 17, 14.4  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 10, 18, 14.4  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1, 11, 7, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 7, 11, 8, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 30, 11, 9, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 45, 11, 10, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 60, 11, 11, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 90, 11, 12, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 120, 11, 13, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 150, 11, 14, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 180, 11, 15, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 270, 11, 16, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 365, 11, 17, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'MXN/VOL', 1800, 11, 18, 15  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow)SELECT 2, 'DATE', 'NA', 0, 1, 3  
  
  -- regreso los limites  
  SELECT  
  intSection,  
  MIN(intCol) AS intMinCol,  
  MAX(intCol) AS intMaxCol,  
  MIN(intRow) AS intMinRow,  
  MAX(intRow) AS intMaxRow  
  FROM @tblDirectives  
  GROUP BY   
  intSection  
  ORDER BY   
  intSection  
   
  -- regreso las directivas  
  SELECT   
  LTRIM(STR(intSection)) AS txtSection,  
  txtSource,  
  txtCode,  
  intNode,  
  intCol,  
  intRow,  
  dblValue,  
  intStrike  
  FROM @tblDirectives  
  ORDER BY   
  intSection,  
  intCol,  
  intRow  
  
  SET NOCOUNT OFF  
  
END   
------------------------------------------------------------  
--   Autor:         Mike Ramirez  
--   Creacion:  12:44 p.m. 2012-06-26  
--   Descripcion:   Modulo 18: Incluir un plazo en la sabana  
------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;18  
 @txtDate DATETIME  
  
AS  
BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtCode CHAR(10),  
   intNode INT,  
   intCol INT,  
   intRow INT,  
   dblValue FLOAT NULL,  
   intStrike FLOAT NULL  
    PRIMARY KEY (intCol, intRow)  
  )   
  
 DECLARE @dblValue AS FLOAT   
  
 -- Configuración de Directivas  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 3, 7, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 3, 8, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 3, 9, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 3, 10, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 3, 11, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 3, 12, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 3, 13, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 3, 14, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 3, 15, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 3, 16, 13  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 3, 17, 13  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 4, 7, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 4, 8, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 4, 9, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 4, 10, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 4, 11, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 4, 12, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 4, 13, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 4, 14, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 4, 15, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 4, 16, 14  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 4, 17, 14  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 5, 7, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 5, 8, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 5, 9, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 5, 10, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 5, 11, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 5, 12, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 5, 13, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 5, 14, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 5, 15, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 5, 16, 15  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 5, 17, 15  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 6, 7, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 6, 8, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 6, 9, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 6, 10, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 6, 11, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 6, 12, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 6, 13, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 6, 14, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 6, 15, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 6, 16, 16  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 6, 17, 16  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 7, 7, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 7, 8, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 7, 9, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 7, 10, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 7, 11, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 7, 12, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 7, 13, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 7, 14, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 7, 15, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 7, 16, 17  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 7, 17, 17  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 8, 7, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 8, 8, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 8, 9, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 8, 10, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 8, 11, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 8, 12, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 8, 13, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 8, 14, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 8, 15, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 8, 16, 18  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 8, 17, 18  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 9, 7, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 9, 8, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 9, 9, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 9, 10, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 9, 11, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 9, 12, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 9, 13, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 9, 14, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 9, 15, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 9, 16, 19  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 9, 17, 19  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 10, 7, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 10, 8, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 10, 9, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 10, 10, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 10, 11, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 10, 12, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 10, 13, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 10, 14, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 10, 15, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 10, 16, 20  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 10, 17, 20  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 11, 7, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 11, 8, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 11, 9, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 11, 10, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 11, 11, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 11, 12, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 11, 13, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 11, 14, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 11, 15, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 11, 16, 21  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 11, 17, 21  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 12, 7, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 12, 8, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 12, 9, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 12, 10, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 12, 11, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 12, 12, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 12, 13, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 12, 14, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 12, 15, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 12, 16, 22  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 12, 17, 22  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 13, 7, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 13, 8, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 13, 9, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 13, 10, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 13, 11, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 13, 12, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 13, 13, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 13, 14, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 13, 15, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 13, 16, 23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 13, 17, 23  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 1, 14, 7, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 7, 14, 8, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 30, 14, 9, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 45, 14, 10, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 90, 14, 11, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 120, 14, 12, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 150, 14, 13, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 180, 14, 14, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 270, 14, 15, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 365, 14, 16, 24  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUM/VOL', 720, 14, 17, 24  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow)SELECT 2, 'DATE', 'NA', 0, 1, 3  
  
  -- regreso los limites  
  SELECT  
  intSection,  
  MIN(intCol) AS intMinCol,  
  MAX(intCol) AS intMaxCol,  
  MIN(intRow) AS intMinRow,  
  MAX(intRow) AS intMaxRow  
  FROM @tblDirectives  
  GROUP BY   
  intSection  
  ORDER BY   
  intSection  
   
  -- regreso las directivas  
  SELECT   
  LTRIM(STR(intSection)) AS txtSection,  
  txtSource,  
  txtCode,  
  intNode,  
  intCol,  
  intRow,  
  dblValue,  
  intStrike  
  FROM @tblDirectives  
  ORDER BY   
  intSection,  
  intCol,  
  intRow  
  
  SET NOCOUNT OFF  
  
END   
  
--   Autor:          Lic. René López Salinas  
--   Creacion:  06:34 p.m. 2010-11-04  
--   Descripcion:     Procedimiento que genera producto JPMorganVectorLiquidaciones_aaaammdd.xls  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;19  
  @txtDate AS DATETIME  
  
AS     
BEGIN    
  
 SET NOCOUNT ON   
  
   SELECT DISTINCT  
    CONVERT(CHAR(8),@txtDate,112) AS Fecha,  
    ap.txtTv + REPLICATE(' ',4 - LEN(ap.txtTv)) AS TV,  
    ap.txtEmisora + REPLICATE(' ',7 - LEN(ap.txtEmisora)) AS Emisora,  
    ap.txtSerie + REPLICATE(' ',6 - LEN(ap.txtSerie)) AS Serie,  
  
    -- Datos Liquidation = 24H  
    CASE UPPER(ap24.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap24.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap24.dblPRL,6),16,6))  
    END AS PRL24H,   
  
    CASE UPPER(ap24.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap24.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap24.dblPRS,6),16,6))  
    END  AS PRS24H,  
    
    LTRIM(STR(ROUND(ap24.dblCPD,6),19,6)) AS CPD24H,  
    LTRIM(STR(ROUND(ap24.dblCPA,6),19,6)) AS CPA24H,  
    LTRIM(STR(ROUND(ap24.dblYTM,6),19,6)) AS YTM24H,  
    (CASE WHEN (ap24.txtFCR<>'NA' AND ap24.txtFCR<>'-' AND ap24.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap24.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR24H],  
    LTRIM(STR(ROUND(ap24.dblDTM,5),5)) AS DTM24H,  
    (CASE WHEN (ap24.txtDTC<>'NA' AND ap24.txtDTC<>'-' AND ap24.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap24.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC24H],  
  
    -- Datos Liquidation = 48H  
    CASE UPPER(ap48.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap48.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap48.dblPRL,6),16,6))  
    END AS PRL48H,   
  
    CASE UPPER(ap48.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap48.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap48.dblPRS,6),16,6))  
    END  AS PRS48H,  
    
    LTRIM(STR(ROUND(ap48.dblCPD,6),19,6)) AS CPD48H,  
    LTRIM(STR(ROUND(ap48.dblCPA,6),19,6)) AS CPA48H,  
    LTRIM(STR(ROUND(ap48.dblYTM,6),19,6)) AS YTM48H,  
    (CASE WHEN (ap48.txtFCR<>'NA' AND ap48.txtFCR<>'-' AND ap48.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap48.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR48H],  
    LTRIM(STR(ROUND(ap48.dblDTM,5),5)) AS DTM48H,  
    (CASE WHEN (ap48.txtDTC<>'NA' AND ap48.txtDTC<>'-' AND ap48.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap48.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC48H],  
  
    -- Datos Liquidation = 72H  
    CASE UPPER(ap72.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap72.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap72.dblPRL,6),16,6))  
    END AS PRL72H,   
  
    CASE UPPER(ap72.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap72.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap72.dblPRS,6),16,6))  
    END  AS PRS72H,  
    
    LTRIM(STR(ROUND(ap72.dblCPD,6),19,6)) AS CPD72H,  
    LTRIM(STR(ROUND(ap72.dblCPA,6),19,6)) AS CPA72H,  
    LTRIM(STR(ROUND(ap72.dblYTM,6),19,4)) AS YTM72H,  
    (CASE WHEN (ap72.txtFCR<>'NA' AND ap72.txtFCR<>'-' AND ap72.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap72.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR72H],  
    LTRIM(STR(ROUND(ap72.dblDTM,5),5)) AS DTM72H,  
    (CASE WHEN (ap72.txtDTC<>'NA' AND ap72.txtDTC<>'-' AND ap72.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap72.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC72H],  
  
    -- Datos Liquidation = 96H  
    CASE UPPER(ap96.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap96.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap96.dblPRL,6),16,6))  
    END AS PRL96H,   
  
    CASE UPPER(ap96.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap96.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap96.dblPRS,6),16,6))  
    END  AS PRS96H,  
    
    LTRIM(STR(ROUND(ap96.dblCPD,6),19,6)) AS CPD96H,  
    LTRIM(STR(ROUND(ap96.dblCPA,6),19,6)) AS CPA96H,  
    LTRIM(STR(ROUND(ap96.dblYTM,6),19,6)) AS YTM96H,  
    (CASE WHEN (ap96.txtFCR<>'NA' AND ap96.txtFCR<>'-' AND ap96.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap96.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR96H],  
    LTRIM(STR(ROUND(ap96.dblDTM,5),5)) AS DTM96H,  
    (CASE WHEN (ap96.txtDTC<>'NA' AND ap96.txtDTC<>'-' AND ap96.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap96.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC96H],  
  
    -- Datos Liquidation = 120H  
    CASE UPPER(ap120.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap120.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap120.dblPRL,6),16,6))  
    END AS PRL120H,   
  
    CASE UPPER(ap120.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap120.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap120.dblPRS,6),16,6))  
    END  AS PRS120H,  
    
    LTRIM(STR(ROUND(ap120.dblCPD,6),19,6)) AS CPD120H,  
    LTRIM(STR(ROUND(ap120.dblCPA,6),19,6)) AS CPA120H,  
    LTRIM(STR(ROUND(ap120.dblYTM,6),19,6)) AS YTM120H,  
    (CASE WHEN (ap120.txtFCR<>'NA' AND ap120.txtFCR<>'-' AND ap120.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap120.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR120H],  
    LTRIM(STR(ROUND(ap120.dblDTM,5),5)) AS DTM120H,  
    (CASE WHEN (ap120.txtDTC<>'NA' AND ap120.txtDTC<>'-' AND ap120.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap120.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC120H],  
  
    -- Datos Liquidation = 144H  
    CASE UPPER(ap144.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap144.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap144.dblPRL,6),16,6))  
    END AS PRL144H,   
  
    CASE UPPER(ap144.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap144.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap144.dblPRS,6),16,6))  
    END  AS PRS144H,  
    
    LTRIM(STR(ROUND(ap144.dblCPD,6),19,6)) AS CPD144H,  
    LTRIM(STR(ROUND(ap144.dblCPA,6),19,6)) AS CPA144H,  
    LTRIM(STR(ROUND(ap144.dblYTM,6),19,6)) AS YTM144H,  
    (CASE WHEN (ap144.txtFCR<>'NA' AND ap144.txtFCR<>'-' AND ap144.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap144.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR144H],  
    LTRIM(STR(ROUND(ap144.dblDTM,5),5)) AS DTM144H,  
    (CASE WHEN (ap144.txtDTC<>'NA' AND ap144.txtDTC<>'-' AND ap144.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap144.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC144H],  
  
    -- Datos Liquidation = 168H  
    CASE UPPER(ap168.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap168.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap168.dblPRL,6),16,6))  
    END AS PRL168H,   
  
    CASE UPPER(ap168.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap168.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap168.dblPRS,6),16,6))  
    END  AS PRS168H,  
    
    LTRIM(STR(ROUND(ap168.dblCPD,6),19,6)) AS CPD168H,  
    LTRIM(STR(ROUND(ap168.dblCPA,6),19,6)) AS CPA168H,  
    LTRIM(STR(ROUND(ap168.dblYTM,6),19,6)) AS YTM168H,  
    (CASE WHEN (ap168.txtFCR<>'NA' AND ap168.txtFCR<>'-' AND ap168.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap168.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR168H],  
    LTRIM(STR(ROUND(ap168.dblDTM,5),5)) AS DTM168H,  
    (CASE WHEN (ap168.txtDTC<>'NA' AND ap168.txtDTC<>'-' AND ap168.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap168.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC168H],  
  
    -- Datos Liquidation = 192H  
    CASE UPPER(ap192.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap192.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap192.dblPRL,6),16,6))  
    END AS PRL192H,   
  
    CASE UPPER(ap192.txtLiquidation)  
     WHEN 'MP'THEN  
      LTRIM(STR(ROUND(ap192.dblPAV,6),16,6))  
     ELSE  
      LTRIM(STR(ROUND(ap192.dblPRS,6),16,6))  
    END  AS PRS192H,  
    
    LTRIM(STR(ROUND(ap192.dblCPD,6),19,6)) AS CPD192H,  
    LTRIM(STR(ROUND(ap192.dblCPA,6),19,6)) AS CPA192H,  
    LTRIM(STR(ROUND(ap192.dblYTM,6),19,6)) AS YTM192H,  
    (CASE WHEN (ap192.txtFCR<>'NA' AND ap192.txtFCR<>'-' AND ap192.txtFCR<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap192.txtFCR AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [FCR192H],  
    LTRIM(STR(ROUND(ap192.dblDTM,5),5)) AS DTM192H,  
    (CASE WHEN (ap192.txtDTC<>'NA' AND ap192.txtDTC<>'-' AND ap192.txtDTC<>'')   
     THEN LTRIM(STR(ROUND(CAST(ap192.txtDTC AS FLOAT),5),5))  
     ELSE 'NA'  
     END) AS [DTC192H]  
   FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap (NOLOCK)  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap24 (NOLOCK)  
      ON ap24.txtId1 = ap.txtId1  
       AND ap24.txtLiquidation IN ('24H','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap48 (NOLOCK)  
      ON ap48.txtId1 = ap.txtId1  
       AND ap48.txtLiquidation IN ('48H','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap72 (NOLOCK)  
      ON ap72.txtId1 = ap.txtId1  
       AND ap72.txtLiquidation IN ('72H','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap96 (NOLOCK)  
      ON ap96.txtId1 = ap.txtId1  
       AND ap96.txtLiquidation IN ('96H','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap120 (NOLOCK)  
      ON ap120.txtId1 = ap.txtId1  
       AND ap120.txtLiquidation IN ('05D','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap144 (NOLOCK)  
      ON ap144.txtId1 = ap.txtId1  
       AND ap144.txtLiquidation IN ('06D','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap168 (NOLOCK)  
      ON ap168.txtId1 = ap.txtId1  
       AND ap168.txtLiquidation IN ('07D','MP')  
       INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap192 (NOLOCK)  
      ON ap192.txtId1 = ap.txtId1  
       AND ap192.txtLiquidation IN ('08D','MP')  
   WHERE   
    ap.txtLiquidation IN ('MD', 'MP')  
    AND ap.txtTV NOT IN ('1R','*C','*CSP','RC','TR')  
   ORDER BY TV,Emisora,Serie  
  
 SET NOCOUNT OFF   
  
END  
  
----------------------------------------------------------------------------------------  
--   Modificado por: Mike Ramírez    
--   Modificacion:   13:26 2013-07-30    
--   Descripcion:    Modulo 20: Se modifica la forma en la se obtiene el PRS_MO y PRL_MO  
----------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;20  
  @txtDate AS DATETIME,  
 @txtLiquidation AS VARCHAR(3)  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 DECLARE @dblUFXU AS FLOAT  
 DECLARE @dblEUR AS FLOAT  
 DECLARE @dblUDI AS FLOAT  
 DECLARE @dblJPY AS FLOAT  
 DECLARE @dblAUD AS FLOAT  
 DECLARE @dblCAD AS FLOAT  
 DECLARE @dblCHF AS FLOAT  
 DECLARE @dblGBP AS FLOAT  
 DECLARE @dblITL AS FLOAT  
 DECLARE @dblBRL AS FLOAT  
 DECLARE @dblInt AS FLOAT    
 DECLARE @dblCLP AS FLOAT  
 DECLARE @dblCOP AS FLOAT  
 DECLARE @dblDKK AS FLOAT  
 DECLARE @dblHKD AS FLOAT  
 DECLARE @dblIDR AS FLOAT  
 DECLARE @dblNOK AS FLOAT  
 DECLARE @dblPEN AS FLOAT  
 DECLARE @dblSEK AS FLOAT  
 DECLARE @dblSGD AS FLOAT  
 DECLARE @dblSMG AS FLOAT  
 DECLARE @dblTWD AS FLOAT  
 DECLARE @dblZAR AS FLOAT  
  
 -- creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  [dtedate][VARCHAR](10),  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtCUR][VARCHAR](400),  
  [dblPRL][FLOAT],  
  [dblPRS][FLOAT],  
  [txtPRL_MO][VARCHAR](400),  
  [txtPRS_MO][VARCHAR](400),  
  [txtCPD_MO][VARCHAR](400),  
  [dblCPD][FLOAT],  
  [dblCPA][FLOAT],  
  [dblRate][FLOAT]  
  PRIMARY KEY CLUSTERED (  
   txtTV, txtEmisora, txtSerie  
   )  
 )  
  
 SET @dblUFXU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UFXU' AND dteDate = @txtDate)  
 SET @dblEUR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'EUR' AND dteDate = @txtDate)  
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UDI' AND dteDate = @txtDate)  
 SET @dblJPY = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'JPY' AND dteDate = @txtDate)  
 SET @dblAUD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'AUD' AND dteDate = @txtDate)  
 SET @dblCAD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CAD' AND dteDate = @txtDate)  
 SET @dblCHF = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CHF' AND dteDate = @txtDate)  
 SET @dblGBP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'GBP' AND dteDate = @txtDate)  
 SET @dblITL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ITL' AND dteDate = @txtDate)  
 SET @dblBRL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'BRL' AND dteDate = @txtDate)  
 SET @dblInt = 1  
 SET @dblCLP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CLP' AND dteDate = @txtDate)  
 SET @dblCOP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'COP' AND dteDate = @txtDate)  
 SET @dblDKK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'DKK' AND dteDate = @txtDate)  
 SET @dblHKD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'HKD' AND dteDate = @txtDate)  
 SET @dblIDR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'IDR' AND dteDate = @txtDate)  
 SET @dblNOK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'NOK' AND dteDate = @txtDate)  
 SET @dblPEN = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'PEN' AND dteDate = @txtDate)  
 SET @dblSEK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SEK' AND dteDate = @txtDate)  
 SET @dblSGD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SGD' AND dteDate = @txtDate)  
 SET @dblSMG = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SMG' AND dteDate = @txtDate)  
 SET @dblTWD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'TWD' AND dteDate = @txtDate)  
 SET @dblZAR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ZAR' AND dteDate = @txtDate)  
  
 -- Reporto Info:  Vector Moneda de Origen (VPrecios)  
 INSERT @tmp_tblResults   
 SELECT DISTINCT  
   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],   
   RTRIM(ap.txtTv) AS [txtTv],  
   RTRIM(ap.txtEmisora) AS [txtEmisora],  
   RTRIM(ap.txtSerie) AS [txtSerie],  
   RTRIM(ap.txtCUR) AS [txtCUR],  
   RTRIM(STR(ROUND(CAST(ap.dblPRL AS FLOAT),6),19,6)),  
   RTRIM(STR(ROUND(CAST(ap.dblPRS AS FLOAT),6),19,6)),  
  --PRL  
   NULL,    
  --PRS  
   NULL,  
   NULL,  
   RTRIM(ap.dblCPD) AS [dblCPD],  
   RTRIM(ap.dblCPA) AS [dblCPA],  
  
   CASE  
   WHEN ap.txtTv IN (  
    'IP',  
    'IT',  
    'L',  
    'LD',  
    'LP',  
    'LS',  
    'LT',  
    'XA',  
    'IS',  
    'IQ',  
    'IM'   
   ) THEN ROUND(ap.dblLDR,6)  
    
   WHEN ap.txtTv IN (  
    'D',  
    'D3',  
    'G',  
    'I'  
   ) THEN ROUND(ap.dblUDR,6)  
    
   ELSE ROUND(ap.dblYTM,6)   
   
   END AS dblRate  
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap (NOLOCK)  
 WHERE ap.dteDate = @txtDate  
  AND ap.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND ap.txtTV NOT IN ('1R','1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP')  
  
 -- Reporto Info:  Vector Moneda de Origen (VNotas)  
 INSERT @tmp_tblResults   
 SELECT DISTINCT  
   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],   
   RTRIM(ap.txtTv) AS [txtTv],  
   RTRIM(ap.txtEmisora) AS [txtEmisora],  
   RTRIM(ap.txtSerie) AS [txtSerie],  
   RTRIM(ap.txtCUR) AS [txtCUR],  
   RTRIM(ap.dblPRL),  
   RTRIM(ap.dblPRS),  
  --PRL  
   NULL,  
   --PRS  
   NULL,  
    NULL,  
   RTRIM(ap.dblCPD) AS [dblCPD],  
   RTRIM(ap.dblCPA) AS [dblCPA],  
  
   CASE  
   WHEN ap.txtTv IN (  
    'IP',  
    'IT',  
    'L',  
    'LD',  
    'LP',  
    'LS',  
    'LT',  
    'XA',  
    'IS',  
    'IQ',  
    'IM'   
   ) THEN ROUND(ap.dblLDR,6)  
    
   WHEN ap.txtTv IN (  
    'D',  
    'D3',  
    'G',  
    'I'  
   ) THEN ROUND(ap.dblUDR,6)  
    
   ELSE ROUND(ap.dblYTM,6)   
   
   END AS dblRate  
 FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS ap (NOLOCK)  
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)  
    ON ap.txtId1 = op.txtDir  
 WHERE ap.dteDate = @txtDate  
  AND ap.txtLiquidation IN (@txtLiquidation, 'MP')  
  AND op.txtOwnerId = 'JPM02'  
  AND op.txtProductId = 'SNOTES'  
  
 -- Calculo Precio Limpio MO  
 UPDATE r  
 SET txtPRL_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUFXU),16,9))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRL]/@dblEUR),16,9))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUDI),16,9))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRL]/@dblJPY),16,9))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblAUD),16,9))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCAD),16,9))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCHF),16,9))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblGBP),16,9))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRL]/@dblITL),16,9))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblBRL),16,9))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRL/@dblInt),16,6))  
        
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRL]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRL]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRL]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblPEN),16,9))  
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRL]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR((dblPRL/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR((dblPRL/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST(dblPRL AS FLOAT),6),19,6))   
     END)  
 FROM @tmp_tblResults AS r  
  
 -- Calculo Precio Sucio MO  
 UPDATE r  
 SET txtPRS_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUFXU),16,9))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRS]/@dblEUR),16,9))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUDI),16,9))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRS]/@dblJPY),16,9))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblAUD),16,9))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCAD),16,9))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCHF),16,9))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblGBP),16,9))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRS]/@dblITL),16,9))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblBRL),16,9))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRS/@dblInt),16,6))   
  
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRS]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRS]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRS]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblPEN),16,9))  
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRS]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRS] AS FLOAT),6),19,6))  
     END)  
 FROM @tmp_tblResults AS r    
    
 -- Calculo Interes  
 UPDATE r  
 SET txtCPD_MO =   
     (CASE   
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN STR(ROUND(dblCPD,6),13,6)  
      ELSE ROUND(CAST(txtPRS_MO AS FLOAT),6) - ROUND(CAST(txtPRL_MO AS FLOAT),6)  
      END)   
 FROM @tmp_tblResults AS r  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResults) = 0)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  -- Reporta información   
  SELECT   
    [dtedate],  
    [txtTv],  
    [txtEmisora],  
    [txtSerie],  
  --PRL MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')   
    THEN STR(ROUND(dblPRL,6),16,6)  
    ELSE   
      (CASE WHEN (txtPRL_MO<>'NA' AND txtPRL_MO<>'-' AND txtPRL_MO<>'')   
       THEN STR(ROUND(CAST(txtPRL_MO AS FLOAT),6),16,6)  
       ELSE '0'  
       END)  
  END,  
  --PRS MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')   
    THEN STR(ROUND(dblPRS,6),16,6)  
    ELSE   
      (CASE WHEN (txtPRS_MO<>'NA' AND txtPRS_MO<>'-' AND txtPRS_MO<>'')   
       THEN STR(ROUND(CAST(txtPRS_MO AS FLOAT),6),16,6)  
       ELSE '0'  
       END)  
  END,  
  -- INTERES CPD  
  CASE   
   WHEN txtCPD_MO = 'NA' OR txtCPD_MO = '-' OR txtCPD_MO = '' THEN 0  
   WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN ROUND(dblCPD,6)  
   ELSE ROUND(CAST(txtCPD_MO AS FLOAT),6)  
  END,  
    [dblCPA],  
    [dblRate]  
  FROM @tmp_tblResults  
  
  ORDER BY  
   txtTv,  
   txtEmisora,  
   txtSerie  
     
  
 SET NOCOUNT OFF  
  
END  
   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
--   Autor:     Mike Ramirez    
--   Fecha Modificacion: 03:07 p.m. 2012-08-21    
--   Descripcion:   Modulo 21: Se excluyen del archivo los TV '1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP'    
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
CREATE  PROCEDURE dbo.sp_productos_JPMORGAN;21    
  --declare   
  @txtDate AS DATETIME  --= '20140725'  
    
AS     
BEGIN    
 SET NOCOUNT ON     
    
 -- creo tabla temporal de Resultados    
 DECLARE @tmp_tblResults TABLE (    
  [dtedate][VARCHAR](10),    
  [txtTv][VARCHAR](10),    
  [txtEmisora][VARCHAR](10),    
  [txtSerie][VARCHAR](10),    
  [txtPSPP_MD][VARCHAR](400),    
  [txtPSPP_24H][VARCHAR](400),    
  [txtPSPP_48H][VARCHAR](400)    
  PRIMARY KEY CLUSTERED (    
   txtTV, txtEmisora, txtSerie    
   )    
 )    
    
 -- Reporto Info:  Vector Moneda de Origen (VPrecios)    
 INSERT @tmp_tblResults     
 SELECT DISTINCT    
   CONVERT(CHAR(8),@txtDate,112) AS [Fecha],     
   RTRIM(ap.txtTv) AS [txtTv],    
   RTRIM(ap.txtEmisora) AS [txtEmisora],    
   RTRIM(ap.txtSerie) AS [txtSerie],    
   (CASE WHEN (ap.txtPSPP_MO<>'NA' AND ap.txtPSPP_MO<>'-' AND ap.txtPSPP_MO<>'' AND ISNUMERIC(ap.txtPSPP_MO)=1)     
    THEN LTRIM(STR(ROUND(CAST(ap.txtPSPP_MO AS FLOAT),6),19,6))     
    ELSE ''    
    END) AS [txtPSPP_MD],    
    
   (CASE WHEN (ap24.txtPSPP_MO<>'NA' AND ap24.txtPSPP_MO<>'-' AND ap24.txtPSPP_MO<>'' AND ISNUMERIC(ap24.txtPSPP_MO)=1)     
    THEN LTRIM(STR(ROUND(CAST(ap24.txtPSPP_MO AS FLOAT),6),19,6))     
    ELSE ''    
    END) AS [txtPSPP_24H],    
    
   (CASE WHEN (ap48.txtPSPP_MO<>'NA' AND ap48.txtPSPP_MO<>'-' AND ap48.txtPSPP_MO<>'' AND ISNUMERIC(ap48.txtPSPP_MO)=1)     
    THEN LTRIM(STR(ROUND(CAST(ap48.txtPSPP_MO AS FLOAT),6),19,6))     
    ELSE ''    
    END) AS [txtPSPP_48H]     
    
 FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap (NOLOCK)    
   INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap24 (NOLOCK)    
    ON ap.txtId1 = ap24.txtId1     
   INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS ap48 (NOLOCK)    
    ON ap.txtId1 = ap48.txtId1     
 WHERE ap.dteDate = @txtDate    
  AND ap.txtLiquidation IN ('MD','MP')    
  AND ap24.txtLiquidation IN ('24H','MP')    
  AND ap48.txtLiquidation IN ('481','MP')    
  AND ap.txtTV NOT IN ('1R','*C','*CSP','RC','TR','1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP')      
    
 -- Valida la información     
 IF ((SELECT count(*) FROM @tmp_tblResults) = 0)    
    
 BEGIN    
  RAISERROR ('ERROR: Falta Informacion', 16, 1)    
 END    
    
 ELSE    
    
  -- Reporta información     
  SELECT     
    [dtedate],    
    [txtTv],    
    [txtEmisora],    
    [txtSerie],    
    [txtPSPP_MD],    
    [txtPSPP_24H],    
    [txtPSPP_48H]    
  FROM @tmp_tblResults    
  ORDER BY    
   ap.txtTv,    
   ap.txtEmisora,    
   ap.txtSerie    
    
 SET NOCOUNT OFF    
 END   
   
--   Autor:      Mike Ramírez      
--   Creacion:   13:49 a.m. 2010-11-25      
--   Descripcion:     Procedimiento que genera producto personalizado JPMorgan UDILIBOR_[YYYYMMDD].xls      
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;22     
 @txtDate DATETIME  
AS       
BEGIN      
  
SET NOCOUNT ON   
  
DECLARE @tblResult TABLE  
 ([intSection] INT,  
  txtLabel VARCHAR(16),  
  txtNode VARCHAR(16),  
  txtValue VARCHAR(16)  
)  
DECLARE @tmp_tblCurvesNodes TABLE (    
   [intSection][INTEGER],    
   [Label]  CHAR(30),    
   [Type]  CHAR(3),    
   [SubType]  CHAR(3),  
   [NodeLabel]  CHAR(4),    
   [Node] INT,    
   [dblValue] VARCHAR(50)    
   PRIMARY KEY(intSection,Type,SubType,Node)  
)  
INSERT @tmp_tblCurvesNodes  
    SELECT 006,'UDILIBOR','ULS','CCS','TDSP','1',NULL UNION    
    SELECT 007,'UDILIBOR','ULS','CCS','1M','30',NULL UNION    
    SELECT 008,'UDILIBOR','ULS','CCS','2M','60',NULL UNION    
    SELECT 009,'UDILIBOR','ULS','CCS','3M','90',NULL UNION    
    SELECT 010,'UDILIBOR','ULS','CCS','4M','120',NULL UNION    
    SELECT 011,'UDILIBOR','ULS','CCS','5M','150',NULL UNION    
    SELECT 012,'UDILIBOR','ULS','CCS','6M','180',NULL UNION    
    SELECT 013,'UDILIBOR','ULS','CCS','9M','270',NULL UNION    
    SELECT 014,'UDILIBOR','ULS','CCS','1Y','360',NULL UNION   
    SELECT 015,'UDILIBOR','ULS','CCS','18M','540',NULL UNION    
    SELECT 016,'UDILIBOR','ULS','CCS','2Y','720',NULL UNION    
    SELECT 017,'UDILIBOR','ULS','CCS','3Y','1080',NULL UNION    
    SELECT 018,'UDILIBOR','ULS','CCS','4Y','1440',NULL UNION    
    SELECT 019,'UDILIBOR','ULS','CCS','5Y','1800',NULL UNION    
    SELECT 020,'UDILIBOR','ULS','CCS','6Y','2160',NULL UNION    
    SELECT 021,'UDILIBOR','ULS','CCS','7Y','2520',NULL UNION    
    SELECT 022,'UDILIBOR','ULS','CCS','8Y','2880',NULL UNION    
    SELECT 023,'UDILIBOR','ULS','CCS','9Y','3240',NULL UNION   
    SELECT 024,'UDILIBOR','ULS','CCS','10Y','3600',NULL UNION    
    SELECT 025,'UDILIBOR','ULS','CCS','12Y','4320',NULL UNION    
    SELECT 026,'UDILIBOR','ULS','CCS','15Y','5400',NULL UNION    
    SELECT 027,'UDILIBOR','ULS','CCS','20Y','7200',NULL UNION    
    SELECT 028,'UDILIBOR','ULS','CCS','25Y','9000',NULL UNION    
    SELECT 029,'UDILIBOR','ULS','CCS','30Y','10800',NULL UNION    
    SELECT 030,'UDILIBOR','ULS','CCS','40Y','10800',NULL  
  
--  Obtengo los valores de los nodos de curva    
UPDATE @tmp_tblCurvesNodes    
        SET dblValue = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0')*100,9,6))    
 FROM @tmp_tblCurvesNodes  
  
 INSERT @tblResult(intSection,txtLabel,txtNode,txtValue)  
  SELECT 001,CONVERT(CHAR(10),@txtDate,103),'','' UNION  
  SELECT 002,'','','' UNION  
  SELECT 003,'','','' UNION  
  SELECT 004,'UDILIBOR','','Rate' UNION  
  SELECT 005,'','',''  
  
 INSERT @tblResult (intSection,txtLabel,txtNode,txtValue)  
  SELECT intSection,'Cash Rates',nodeLabel,dblValue    
  FROM @tmp_tblCurvesNodes  
  
---- Valida que la información este completa      
 IF ((SELECT COUNT(*) FROM @tblResult WHERE txtValue LIKE '%-9990%') > 0)      
    
  BEGIN      
   RAISERROR ('ERROR: Falta Informacion', 16, 1)      
  END     
  
 ELSE    
  -- Reporto los datos    
  SELECT  
  txtLabel,   
  txtNode,  
  txtValue    
  FROM @tblResult    
  ORDER BY intSection    
    
 SET NOCOUNT OFF    
  
END  
  
--   Modificado por: Lic. René López Salinas  
--   Modificacion: 03:26 p.m. 2010-12-24  
--   Descripcion:     Modulo 23: Recalcular la curva que se reporta tomando como insumo la curva UDI-Libor  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;23       
 @txtDate DATETIME    
AS         
BEGIN        
    
  SET NOCOUNT ON     
  
 -- Genera tabla temporal de resultados  
 DECLARE @tblResult TABLE    
  ([intSection] INT,    
   txtData [VARCHAR](8000)  
 )    
 DECLARE @tmp_tblCurvesNodes TABLE (      
    [intSection][INTEGER],      
    [Label]  CHAR(30),      
    [Type]  CHAR(3),      
    [SubType]  CHAR(3),    
    [NodeLabel]  CHAR(10),      
    [Node] FLOAT,      
    [dblValue] FLOAT  
    PRIMARY KEY(intSection,Type,SubType,Node)    
 )   
  
 INSERT @tmp_tblCurvesNodes (intSection,Label,Type,SubType,NodeLabel,Node,dblValue)  
  SELECT 001,'UDILIBOR','ULS','CCS','"ONMMY"','1',NULL UNION      
  SELECT 002,'UDILIBOR','ULS','CCS','"1MMMY"','30',NULL UNION      
  SELECT 003,'UDILIBOR','ULS','CCS','"2MMMY"','60',NULL UNION      
  SELECT 004,'UDILIBOR','ULS','CCS','"3MMMY"','90',NULL UNION      
  SELECT 005,'UDILIBOR','ULS','CCS','"4MMMY"','120',NULL UNION      
  SELECT 006,'UDILIBOR','ULS','CCS','"5MMMY"','150',NULL UNION      
  SELECT 007,'UDILIBOR','ULS','CCS','"6MMMY"','180',NULL UNION      
  SELECT 008,'UDILIBOR','ULS','CCS','"9MMMY"','270',NULL UNION      
  SELECT 009,'UDILIBOR','ULS','CCS','"1YMMY"','360',NULL UNION     
  SELECT 010,'UDILIBOR','ULS','CCS','"18MBEY"','540',NULL UNION      
  SELECT 011,'UDILIBOR','ULS','CCS','"2YBEY"','720',NULL UNION      
  SELECT 012,'UDILIBOR','ULS','CCS','"3YBEY"','1080',NULL UNION      
  SELECT 013,'UDILIBOR','ULS','CCS','"4YBEY"','1440',NULL UNION      
  SELECT 014,'UDILIBOR','ULS','CCS','"5YBEY"','1800',NULL UNION      
  SELECT 015,'UDILIBOR','ULS','CCS','"6YBEY"','2160',NULL UNION      
  SELECT 016,'UDILIBOR','ULS','CCS','"7YBEY"','2520',NULL UNION      
  SELECT 017,'UDILIBOR','ULS','CCS','"8YBEY"','2880',NULL UNION      
  SELECT 018,'UDILIBOR','ULS','CCS','"9YBEY"','3240',NULL UNION     
  SELECT 019,'UDILIBOR','ULS','CCS','"10YBEY"','3600',NULL UNION      
  SELECT 020,'UDILIBOR','ULS','CCS','"12YBEY"','4320',NULL UNION      
  SELECT 021,'UDILIBOR','ULS','CCS','"15YBEY"','5400',NULL UNION      
  SELECT 022,'UDILIBOR','ULS','CCS','"20YBEY"','7200',NULL UNION      
  SELECT 023,'UDILIBOR','ULS','CCS','"25YBEY"','9000',NULL UNION      
  SELECT 024,'UDILIBOR','ULS','CCS','"30YBEY"','10800',NULL UNION      
  SELECT 025,'UDILIBOR','ULS','CCS','"40YBEY"','10800',NULL    
     
    
 --  Obtengo los valores de los nodos de curva      
 UPDATE @tmp_tblCurvesNodes      
   SET dblValue = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0'),9,6))      
 FROM @tmp_tblCurvesNodes    
  
 -- Formula para Recalcular la curva que se reporta tomando como insumo la curva UDI-Libor  
 UPDATE @tmp_tblCurvesNodes      
   SET dblValue = (POWER((1 + (dblValue * (Node/CAST(360 AS FLOAT)))),(CAST(182 AS FLOAT)/Node))-1)*(CAST(360 AS FLOAT) / CAST(182 AS FLOAT))*100  
 FROM @tmp_tblCurvesNodes    
  
 INSERT @tblResult (intSection,txtData)  
   SELECT intSection,RTRIM(nodeLabel) + ' ' + LTRIM(STR(ROUND(dblvalue,6),19,6)) + '%' + ' ' + '0' + ' ' + '0' + ' ' + '0'    
   FROM @tmp_tblCurvesNodes    
     
 -- Valida que la información este completa        
 IF ((SELECT COUNT(*) FROM @tblResult WHERE txtData LIKE '%-9990%') > 0)        
       
  BEGIN        
    RAISERROR ('ERROR: Falta Informacion', 16, 1)        
  END       
     
 ELSE  
     
 -- Reporto los datos      
   SELECT RTRIM(txtData)  
   FROM @tblResult      
   ORDER BY intSection      
       
 SET NOCOUNT OFF      
    
END  
--   Autor:      Mike Ramírez        
--   Creacion:   08:35 a.m. 2010-12-16        
--   Descripcion:     Procedimiento que genera producto personalizado JPMorgan yldcrvlc_tiieirs_aaaammdd.TXT        
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;24       
 @txtDate DATETIME    
AS         
BEGIN        
    
  SET NOCOUNT ON     
  
-- Genera tabla temporal de resultados  
DECLARE @tblResult TABLE    
 ([intSection] INT,    
  txtData [VARCHAR](8000)  
)    
DECLARE @tmp_tblCurvesNodes TABLE (      
   [intSection][INTEGER],      
   [Label]  CHAR(30),      
   [Type]  CHAR(3),      
   [SubType]  CHAR(3),    
   [NodeLabel]  CHAR(10),      
   [Node] INT,      
   [dblValue] VARCHAR(50)      
   PRIMARY KEY(intSection,Type,SubType,Node)    
)   
  
INSERT @tmp_tblCurvesNodes (intSection,Label,Type,SubType,NodeLabel,Node,dblValue)   
    SELECT 001,'IRS','SWP','TI','"ONMMY"','1',NULL UNION      
    SELECT 002,'IRS','SWP','TI','"4wMMY"','28',NULL UNION      
    SELECT 003,'SWAPTIIE','TIE','SWP','"12wBEY"','84',NULL UNION      
    SELECT 004,'SWAPTIIE','TIE','SWP','"24wBEY"','168',NULL UNION      
    SELECT 005,'SWAPTIIE','TIE','SWP','"36wBEY"','252',NULL UNION      
    SELECT 006,'SWAPTIIE','TIE','SWP','"52wBEY"','364',NULL UNION      
    SELECT 007,'SWAPTIIE','TIE','SWP','"104wBEY"','728',NULL UNION      
    SELECT 008,'SWAPTIIE','TIE','SWP','"156wBEY"','1092',NULL UNION      
    SELECT 009,'SWAPTIIE','TIE','SWP','"208wBEY"','1456',NULL UNION     
    SELECT 010,'SWAPTIIE','TIE','SWP','"260wBEY"','1820',NULL UNION      
    SELECT 011,'SWAPTIIE','TIE','SWP','"364wBEY"','2548',NULL UNION      
    SELECT 012,'SWAPTIIE','TIE','SWP','"520wBEY"','3640',NULL UNION      
    SELECT 013,'SWAPTIIE','TIE','SWP','"624wBEY"','4368',NULL UNION      
    SELECT 014,'SWAPTIIE','TIE','SWP','"780wBEY"','5460',NULL UNION      
    SELECT 015,'SWAPTIIE','TIE','SWP','"1040wBEY"','7280',NULL UNION      
    SELECT 016,'SWAPTIIE','TIE','SWP','"1560wBEY"','10920',NULL  
   
--  Obtengo los valores de los nodos de curva      
UPDATE @tmp_tblCurvesNodes      
        SET dblValue = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0')*100,9,6))      
FROM @tmp_tblCurvesNodes    
    
INSERT @tblResult (intSection,txtData)  
  SELECT intSection,RTRIM(nodeLabel) + ' ' + LTRIM(dblvalue) + '%' + ' ' + '0' + ' ' + '0' + ' ' + '0'    
  FROM @tmp_tblCurvesNodes    
    
-- Valida que la información este completa        
IF ((SELECT COUNT(*) FROM @tblResult WHERE txtData LIKE '%-9990%') > 0)        
      
 BEGIN        
   RAISERROR ('ERROR: Falta Informacion', 16, 1)        
 END       
    
ELSE  
      
-- Reporto los datos      
  SELECT RTRIM(txtData)  
  FROM @tblResult      
  ORDER BY intSection    
      
 SET NOCOUNT OFF      
    
END  
  
--   Autor:      Mike Ramírez        
--   Creacion:   08:41 a.m. 2010-12-16        
--   Descripcion:     Procedimiento que genera producto personalizado JPMorgan yldcrvlc_liborirs_aaaammdd.TXT        
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;25       
 @txtDate DATETIME    
AS         
BEGIN        
    
  SET NOCOUNT ON    
  
-- Genera tabla temporal de resultados  
DECLARE @tblResult TABLE    
 ([intSection] INT,    
  txtData [VARCHAR](8000)  
)    
DECLARE @tmp_tblCurvesNodes TABLE (      
   [intSection][INTEGER],      
   [Label]  CHAR(30),      
   [Type]  CHAR(3),      
   [SubType]  CHAR(3),    
   [NodeLabel]  CHAR(10),      
   [Node] INT,      
   [dblValue] VARCHAR(50)      
   PRIMARY KEY(intSection,Type,SubType,Node)    
)   
  
INSERT @tmp_tblCurvesNodes (intSection,Label,Type,SubType,NodeLabel,Node,dblValue)    
    SELECT 001,'LIBOR','LIB','LB','"ONMMY"','1',NULL UNION      
    SELECT 002,'LIBOR','LIB','LB','"1MMMY"','28',NULL UNION      
    SELECT 003,'LIBOR','LIB','LB','"2MMMY"','56',NULL UNION      
    SELECT 004,'LIBOR','LIB','LB','"3MMMY"','84',NULL UNION      
    SELECT 005,'LIBOR','LIB','LB','"4MMMY"','112',NULL UNION      
    SELECT 006,'LIBOR','LIB','LB','"5MMMY"','140',NULL UNION      
    SELECT 007,'LIBOR','LIB','LB','"6MMMY"','168',NULL UNION      
    SELECT 008,'LIBOR','LIB','LB','"9MMMY"','252',NULL UNION      
    SELECT 009,'LIBOR','LIB','LB','"1YMMY"','364',NULL UNION     
    SELECT 010,'LIBORDOLAR','LUS','SWP','"18MBEY"','532',NULL UNION      
    SELECT 011,'LIBORDOLAR','LUS','SWP','"2YBEY"','728',NULL UNION      
    SELECT 012,'LIBORDOLAR','LUS','SWP','"3YBEY"','1092',NULL UNION      
    SELECT 013,'LIBORDOLAR','LUS','SWP','"4YBEY"','1456',NULL UNION      
    SELECT 014,'LIBORDOLAR','LUS','SWP','"5YBEY"','1820',NULL UNION      
    SELECT 015,'LIBORDOLAR','LUS','SWP','"6YBEY"','2184',NULL UNION      
    SELECT 016,'LIBORDOLAR','LUS','SWP','"7YBEY"','2548',NULL UNION      
    SELECT 017,'LIBORDOLAR','LUS','SWP','"8YBEY"','2912',NULL UNION      
    SELECT 018,'LIBORDOLAR','LUS','SWP','"9YBEY"','3276',NULL UNION     
    SELECT 019,'LIBORDOLAR','LUS','SWP','"10YBEY"','3640',NULL UNION      
    SELECT 020,'LIBORDOLAR','LUS','SWP','"12YBEY"','4368',NULL UNION      
    SELECT 021,'LIBORDOLAR','LUS','SWP','"15YBEY"','5460',NULL UNION      
    SELECT 022,'LIBORDOLAR','LUS','SWP','"20YBEY"','7280',NULL UNION      
    SELECT 023,'LIBORDOLAR','LUS','SWP','"25YBEY"','9100',NULL UNION      
    SELECT 024,'LIBORDOLAR','LUS','SWP','"30YBEY"','10920',NULL   
   
--  Obtengo los valores de los nodos de curva      
UPDATE @tmp_tblCurvesNodes      
        SET dblValue = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(Type),RTRIM(SubType),Node,'0')*100,9,6))      
FROM @tmp_tblCurvesNodes    
    
INSERT @tblResult (intSection,txtData)   
  SELECT intSection,RTRIM(nodeLabel) + ' ' + LTRIM(dblvalue) + '%' + ' ' + '0' + ' ' + '0' + ' ' + '0'    
  FROM @tmp_tblCurvesNodes    
    
-- Valida que la información este completa        
IF ((SELECT COUNT(*) FROM @tblResult WHERE txtData LIKE '%-9990%') > 0)        
      
 BEGIN        
   RAISERROR ('ERROR: Falta Informacion', 16, 1)        
 END       
    
ELSE  
      
-- Reporto los datos      
  SELECT RTRIM(txtData)  
  FROM @tblResult      
  ORDER BY intSection      
         
 SET NOCOUNT OFF      
    
END  
  
--   Autor:         Lic. René López Salinas  
--   Creacion:  12:28 p.m. 2011-01-19  
--   Descripcion:   Modulo 26: Procedimiento que genera el producto JPMorgan_JPYVOLaaaammdd.xls  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;26  
 @txtDate DATETIME  
  
AS  
BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtCode CHAR(10),  
   intNode INT,  
   intCol INT,  
   intRow INT,  
   dblValue FLOAT NULL,  
   intStrike FLOAT NULL  
    PRIMARY KEY (intCol, intRow)  
  )   
  
 DECLARE @dblValue AS FLOAT   
  
 -- Configuración de Directivas  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 3, 7, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 3, 8, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 3, 9, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 3, 10, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 3, 11, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 3, 12, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 3, 13, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 3, 14, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 3, 15, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 3, 16, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 3, 17, 75.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 3, 18, 75.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 4, 7, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 4, 8, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 4, 9, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 4, 10, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 4, 11, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 4, 12, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 4, 13, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 4, 14, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 4, 15, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 4, 16, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 4, 17, 78.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 4, 18, 78.5  
  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 5, 7, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 5, 8, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 5, 9, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 5, 10, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 5, 11, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 5, 12, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 5, 13, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 5, 14, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 5, 15, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 5, 16, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 5, 17, 81.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 5, 18, 81.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 6, 7, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 6, 8, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 6, 9, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 6, 10, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 6, 11, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 6, 12, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 6, 13, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 6, 14, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 6, 15, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 6, 16, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 6, 17, 84.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 6, 18, 84.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 7, 7, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 7, 8, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 7, 9, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 7, 10, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 7, 11, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 7, 12, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 7, 13, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 7, 14, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 7, 15, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 7, 16, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 7, 17, 87.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 7, 18, 87.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 8, 7, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 8, 8, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 8, 9, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 8, 10, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 8, 11, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 8, 12, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 8, 13, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 8, 14, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 8, 15, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 8, 16, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 8, 17, 90.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 8, 18, 90.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 9, 7, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 9, 8, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 9, 9, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 9, 10, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 9, 11, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 9, 12, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 9, 13, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 9, 14, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 9, 15, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 9, 16, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 9, 17, 93.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 9, 18, 93.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 10, 7, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 10, 8, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 10, 9, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 10, 10, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 10, 11, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 10, 12, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 10, 13, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 10, 14, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 10, 15, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 10, 16, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 10, 17, 96.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 10, 18, 96.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 11, 7, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 11, 8, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 11, 9, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 11, 10, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 11, 11, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 11, 12, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 11, 13, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 11, 14, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 11, 15, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 11, 16, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 11, 17, 99.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 11, 18, 99.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 1, 12, 7, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 7, 12, 8, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 30, 12, 9, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 45, 12, 10, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 60, 12, 11, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 90, 12, 12, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 120, 12, 13, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 150, 12, 14, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 180, 12, 15, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 270, 12, 16, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 365, 12, 17, 102.5  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'JPY/VOL', 720, 12, 18, 102.5  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow)SELECT 2, 'DATE', 'NA', 0, 1, 3  
  
  -- regreso los limites  
  SELECT  
  intSection,  
  MIN(intCol) AS intMinCol,  
  MAX(intCol) AS intMaxCol,  
  MIN(intRow) AS intMinRow,  
  MAX(intRow) AS intMaxRow  
  FROM @tblDirectives  
  GROUP BY   
  intSection  
  ORDER BY   
  intSection  
   
  -- regreso las directivas  
  SELECT   
  LTRIM(STR(intSection)) AS txtSection,  
  txtSource,  
  txtCode,  
  intNode,  
  intCol,  
  intRow,  
  dblValue,  
  intStrike  
  FROM @tblDirectives  
  ORDER BY   
  intSection,  
  intCol,  
  intRow  
  
  SET NOCOUNT OFF  
  
END   
  
-------------------------------------------------------------------------------------  
-- Modificado por: Mike Ramírez    
-- Modificacion:   13:17 2013-07-30    
-- Descripcion:    Modulo 27: Se modifica la forma en la que se valida los precios MO  
-------------------------------------------------------------------------------------  
CREATE   PROCEDURE [dbo].[sp_productos_JPMORGAN];27  
 --DECLARE   
 @txtDate AS VARCHAR (20)   
  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @dblUFXU AS FLOAT  
 DECLARE @dblEUR AS FLOAT  
 DECLARE @dblUDI AS FLOAT  
 DECLARE @dblJPY AS FLOAT  
 DECLARE @dblAUD AS FLOAT  
 DECLARE @dblCAD AS FLOAT  
 DECLARE @dblCHF AS FLOAT  
 DECLARE @dblGBP AS FLOAT  
 DECLARE @dblITL AS FLOAT  
 DECLARE @dblBRL AS FLOAT  
 DECLARE @dblInt AS FLOAT   
 DECLARE @dblCLP AS FLOAT  
 DECLARE @dblCOP AS FLOAT  
 DECLARE @dblDKK AS FLOAT  
 DECLARE @dblHKD AS FLOAT  
 DECLARE @dblIDR AS FLOAT  
 DECLARE @dblNOK AS FLOAT  
 DECLARE @dblPEN AS FLOAT  
 DECLARE @dblSEK AS FLOAT  
 DECLARE @dblSGD AS FLOAT  
 DECLARE @dblSMG AS FLOAT  
 DECLARE @dblTWD AS FLOAT  
 DECLARE @dblZAR AS FLOAT  
  
 -- Creo tabla temporal de Resultados  
 DECLARE @tmp_tblUnifiedPricesReport TABLE (  
  [dteDate][DATETIME],  
  [txtId1][VARCHAR](11),  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtLiquidation][CHAR](5),  
  [txtMKT][VARCHAR](400),  
  [dblPRL][FLOAT],  
  [dblPRS][FLOAT],  
  [txtCUR][VARCHAR](400),  
  [txtPRS_MO][VARCHAR](400),  
  [txtPRL_MO][VARCHAR](400),  
  [txtCPD_MO][VARCHAR](400),  
  [dblCPD][FLOAT],  
  [dblDTM][FLOAT],  
  [dblUDR][FLOAT]  
  PRIMARY KEY CLUSTERED (  
   dtedate,txtliquidation,txtId1  
   )  
 )  
  
 DECLARE @tmp_tblResults TABLE (  
  [txtTV][CHAR](4),  
  [txtEmisora][CHAR](7),  
  [txtSerie][CHAR](6),  
  [txtData][VARCHAR](8000)  
  PRIMARY KEY (txtTv,txtEmisora,txtSerie)  
 )  
  
 SET @dblUFXU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UFXU' AND dteDate = @txtDate)  
 SET @dblEUR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'EUR' AND dteDate = @txtDate)  
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UDI' AND dteDate = @txtDate)  
 SET @dblJPY = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'JPY' AND dteDate = @txtDate)  
 SET @dblAUD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'AUD' AND dteDate = @txtDate)  
 SET @dblCAD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CAD' AND dteDate = @txtDate)  
 SET @dblCHF = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CHF' AND dteDate = @txtDate)  
 SET @dblGBP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'GBP' AND dteDate = @txtDate)  
 SET @dblITL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ITL' AND dteDate = @txtDate)  
 SET @dblBRL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'BRL' AND dteDate = @txtDate)  
 SET @dblInt = 1  
 SET @dblCLP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CLP' AND dteDate = @txtDate)  
 SET @dblCOP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'COP' AND dteDate = @txtDate)  
 SET @dblDKK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'DKK' AND dteDate = @txtDate)  
 SET @dblHKD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'HKD' AND dteDate = @txtDate)  
 SET @dblIDR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'IDR' AND dteDate = @txtDate)  
 SET @dblNOK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'NOK' AND dteDate = @txtDate)  
 SET @dblPEN = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'PEN' AND dteDate = @txtDate)  
 SET @dblSEK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SEK' AND dteDate = @txtDate)  
 SET @dblSGD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SGD' AND dteDate = @txtDate)  
 SET @dblSMG = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SMG' AND dteDate = @txtDate)  
 SET @dblTWD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'TWD' AND dteDate = @txtDate)  
 SET @dblZAR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ZAR' AND dteDate = @txtDate)  
   
 -- Universo a procesar (VPrecios)  
 INSERT @tmp_tblUnifiedPricesReport (dtedate,txtID1,txtTv,txtEmisora,txtSerie,txtLiquidation,txtMKT,dblPRL,dblPRS,txtCUR,txtPRS_MO,txtPRL_MO,txtCPD_MO,dblCPD,dblDTM,dblUDR)  
  SELECT   
   dtedate,  
   txtID1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,  
   txtMKT,  
   dblPRL,  
   dblPRS,  
   txtCUR,  
   txtPRS_MO,  
   txtPRL_MO,  
   txtCPD_MO,  
   dblCPD,  
   dblDTM,  
   dblUDR  
  FROM dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
     
 -- Universo a procesar (VNotas)  
 INSERT @tmp_tblUnifiedPricesReport (dtedate,txtID1,txtTv,txtEmisora,txtSerie,txtLiquidation,txtMKT,dblPRL,dblPRS,txtCUR,txtPRS_MO,txtPRL_MO,txtCPD_MO,dblCPD,dblDTM,dblUDR)  
  SELECT   
   dtedate,  
   txtID1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,  
   txtMKT,  
   dblPRL,  
   dblPRS,  
   txtCUR,  
   txtPRS_MO,  
   txtPRL_MO,  
   txtCPD_MO,  
   dblCPD,  
   dblDTM,  
   dblUDR  
 FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS ap (NOLOCK)  
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)  
    ON ap.txtId1 = op.txtDir  
 WHERE ap.dteDate =  @txtDate  
  AND ap.txtLiquidation IN ('MD','MP')  
  AND op.txtOwnerId = 'JPM02'  
  AND op.txtProductId = 'SNOTES'  
    
 -- Calculo Precio Limpio MO  
 UPDATE r  
 SET txtPRL_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUFXU),16,9))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRL]/@dblEUR),16,9))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUDI),16,9))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRL]/@dblJPY),16,9))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblAUD),16,9))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCAD),16,9))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCHF),16,9))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblGBP),16,9))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRL]/@dblITL),16,9))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblBRL),16,9))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRL/@dblInt),16,6))  
        
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRL]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRL]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRL]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblPEN),16,9))   
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRL]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRL] AS FLOAT),6),19,6))   
     END)  
 FROM @tmp_tblUnifiedPricesReport AS r  
  
 -- Calculo Precio Sucio MO  
 UPDATE r  
 SET txtPRS_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR((dblPRS/@dblUFXU),16,6))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR((dblPRS/@dblEUR),16,6))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR((dblPRS/@dblUDI),16,6))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR((dblPRS/@dblJPY),16,6))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR((dblPRS/@dblAUD),16,6))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR((dblPRS/@dblCAD),16,6))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR((dblPRS/@dblCHF),16,6))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR((dblPRS/@dblGBP),16,6))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR((dblPRS/@dblITL),16,6))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR((dblPRS/@dblBRL),16,6))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR(ROUND((dblPRS/@dblInt),6),16,6))  
  
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRS]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRS]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRS]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblPEN),16,9))  
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRS]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRS] AS FLOAT),6),19,6))  
     END)  
 FROM @tmp_tblUnifiedPricesReport AS r  
   
  
 -- Calculo Interes  
 UPDATE r  
 SET txtCPD_MO =   
     (CASE   
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN STR(ROUND(dblCPD,6),13,6)  
      ELSE ROUND(CAST(txtPRS_MO AS FLOAT),6) - ROUND(CAST(txtPRL_MO AS FLOAT),6)  
      END)   
 FROM @tmp_tblUnifiedPricesReport AS r  
   
 -- Agregar hacia una tabla tblResults  
  
 INSERT @tmp_tblResults (txtTv,txtEmisora,txtSerie,txtData)  
 SELECT  
  txtTV,  
  txtEmisora,  
  txtSerie,  
  'H '+  
  RTRIM(txtMKT) +    
  CONVERT(CHAR(8),dteDate,112) +  
  --TV+Emisora+Serie  
  RTRIM(txtTv) + REPLICATE(' ', 4 - LEN(RTRIM(txtTv))) +   
  RTRIM(txtEmisora) + REPLICATE(' ',7 - LEN(RTRIM(txtEmisora))) +  
  RTRIM(txtserie) + REPLICATE(' ',6 - LEN(RTRIM(txtSerie))) +  
  --PRS MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')   
    THEN REPLACE(SUBSTRING(STR(dblPRS,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRS,16,6),11,6)  
    ELSE   
      (CASE WHEN (txtPRS_MO<>'NA' AND txtPRS_MO<>'-' AND txtPRS_MO<>'')   
       THEN REPLACE(SUBSTRING(STR(CAST(txtPRS_MO AS FLOAT),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(txtPRS_MO AS FLOAT),16,6),11,6)  
       ELSE '000000000000000'  
       END)  
  END +  
  --PRL MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')   
    THEN REPLACE(SUBSTRING(STR(dblPRL,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRL,16,6),11,6)  
    ELSE   
      (CASE WHEN (txtPRL_MO<>'NA' AND txtPRL_MO<>'-' AND txtPRL_MO<>'')   
       THEN REPLACE(SUBSTRING(STR(CAST(txtPRL_MO AS FLOAT),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(txtPRL_MO AS FLOAT),16,6),11,6)  
       ELSE '000000000000000'  
       END)  
  END +  
  -- INTERES CPD  
  CASE   
   WHEN txtCPD_MO = 'NA' OR txtCPD_MO = '-' OR txtCPD_MO = '' THEN '000000000000'  
   WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN REPLACE(SUBSTRING(STR(ROUND(dblCPD,6),13,6),1,6),' ','0') + SUBSTRING(STR(ROUND(dblCPD,6),13,6),8,6)  
   ELSE REPLACE(SUBSTRING(STR(CAST(txtCPD_MO AS FLOAT),13,6),1,6),' ','0') + SUBSTRING(STR(CAST(txtCPD_MO AS FLOAT),13,6),8,6)  
  --ELSE '000000000000'  
  END +  
  '0250091' AS txtData   
 FROM @tmp_tblUnifiedPricesReport  
 WHERE   
   dteDate = @txtDate  
   AND txtLiquidation IN ('MD','MP')  
   AND txtTv NOT IN ('1R','1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP')  
      
   
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResults) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  SELECT RTRIM(txtData)  
  FROM @tmp_tblResults  
  ORDER BY txtTV,txtEmisora,txtSerie  
    
 SET NOCOUNT OFF  
  
END  
  
----------------------------------------------------------------------  
-- Modificado por: Mike Ramírez    
-- Modificacion:   13:17 2013-07-30    
-- Descripcion:    Modulo 28: Se modifa el calculo para los precios MO  
----------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;28  
 @txtDate AS VARCHAR (20)  
  
AS  
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @dblUFXU AS FLOAT  
 DECLARE @dblEUR AS FLOAT  
 DECLARE @dblUDI AS FLOAT  
 DECLARE @dblJPY AS FLOAT  
 DECLARE @dblAUD AS FLOAT  
 DECLARE @dblCAD AS FLOAT  
 DECLARE @dblCHF AS FLOAT  
 DECLARE @dblGBP AS FLOAT  
 DECLARE @dblITL AS FLOAT  
 DECLARE @dblBRL AS FLOAT  
 DECLARE @dblInt AS FLOAT   
 DECLARE @dblCLP AS FLOAT  
 DECLARE @dblCOP AS FLOAT  
 DECLARE @dblDKK AS FLOAT  
 DECLARE @dblHKD AS FLOAT  
 DECLARE @dblIDR AS FLOAT  
 DECLARE @dblNOK AS FLOAT  
 DECLARE @dblPEN AS FLOAT  
 DECLARE @dblSEK AS FLOAT  
 DECLARE @dblSGD AS FLOAT  
 DECLARE @dblSMG AS FLOAT  
 DECLARE @dblTWD AS FLOAT  
 DECLARE @dblZAR AS FLOAT   
  
 -- Creo tabla temporal de Resultados  
 DECLARE @tmp_tblUnifiedPricesReport TABLE (  
  [dteDate][DATETIME],  
  [txtId1][VARCHAR](11),  
  [txtTv][VARCHAR](10),  
  [txtEmisora][VARCHAR](10),  
  [txtSerie][VARCHAR](10),  
  [txtLiquidation][CHAR](5),  
  [txtMKT][VARCHAR](400),  
  [dblPRL][FLOAT],  
  [dblPRS][FLOAT],  
  [txtCUR][VARCHAR](400),  
  [txtPRS_MO][VARCHAR](400),  
  [txtPRL_MO][VARCHAR](400),  
  [txtCPD_MO][VARCHAR](400),  
  [dblCPD][FLOAT],  
  [dblDTM][FLOAT],  
  [dblUDR][FLOAT]  
  PRIMARY KEY CLUSTERED (  
   dtedate,txtliquidation,txtId1  
   )  
 )  
  
 DECLARE @tmp_tblResults TABLE (  
  [txtTV][CHAR](4),  
  [txtEmisora][CHAR](7),  
  [txtSerie][CHAR](6),  
  [txtData][VARCHAR](8000)  
  PRIMARY KEY (txtTv,txtEmisora,txtSerie)  
 )  
  
 SET @dblUFXU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UFXU' AND dteDate = @txtDate)  
 SET @dblEUR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'EUR' AND dteDate = @txtDate)  
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UDI' AND dteDate = @txtDate)  
 SET @dblJPY = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'JPY' AND dteDate = @txtDate)  
 SET @dblAUD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'AUD' AND dteDate = @txtDate)  
 SET @dblCAD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CAD' AND dteDate = @txtDate)  
 SET @dblCHF = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CHF' AND dteDate = @txtDate)  
 SET @dblGBP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'GBP' AND dteDate = @txtDate)  
 SET @dblITL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ITL' AND dteDate = @txtDate)  
 SET @dblBRL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'BRL' AND dteDate = @txtDate)  
 SET @dblInt = 1  
 SET @dblCLP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CLP' AND dteDate = @txtDate)  
 SET @dblCOP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'COP' AND dteDate = @txtDate)  
 SET @dblDKK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'DKK' AND dteDate = @txtDate)  
 SET @dblHKD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'HKD' AND dteDate = @txtDate)  
 SET @dblIDR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'IDR' AND dteDate = @txtDate)  
 SET @dblNOK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'NOK' AND dteDate = @txtDate)  
 SET @dblPEN = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'PEN' AND dteDate = @txtDate)  
 SET @dblSEK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SEK' AND dteDate = @txtDate)  
 SET @dblSGD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SGD' AND dteDate = @txtDate)  
 SET @dblSMG = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SMG' AND dteDate = @txtDate)  
 SET @dblTWD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'TWD' AND dteDate = @txtDate)  
 SET @dblZAR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ZAR' AND dteDate = @txtDate)  
   
 -- Universo a procesar (VPrecios)  
 INSERT @tmp_tblUnifiedPricesReport (dtedate,txtID1,txtTv,txtEmisora,txtSerie,txtLiquidation,txtMKT,dblPRL,dblPRS,txtCUR,txtPRS_MO,txtPRL_MO,txtCPD_MO,dblCPD,dblDTM,dblUDR)  
  SELECT   
   dtedate,  
   txtID1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,  
   txtMKT,  
   dblPRL,  
   dblPRS,  
   txtCUR,  
   txtPRS_MO,  
   txtPRL_MO,  
   txtCPD_MO,  
   dblCPD,  
   dblDTM,  
   dblUDR  
  FROM dbo.tmp_tblUnifiedPricesReport (NOLOCK)  
  
 -- Universo a procesar (VNotas)  
 INSERT @tmp_tblUnifiedPricesReport (dtedate,txtID1,txtTv,txtEmisora,txtSerie,txtLiquidation,txtMKT,dblPRL,dblPRS,txtCUR,txtPRS_MO,txtPRL_MO,txtCPD_MO,dblCPD,dblDTM,dblUDR)  
  SELECT   
   dtedate,  
   txtID1,  
   txtTv,  
   txtEmisora,  
   txtSerie,  
   txtLiquidation,  
   txtMKT,  
   dblPRL,  
   dblPRS,  
   txtCUR,  
   txtPRS_MO,  
   txtPRL_MO,  
   txtCPD_MO,  
   dblCPD,  
   dblDTM,  
   dblUDR  
 FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS ap (NOLOCK)  
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)  
    ON ap.txtId1 = op.txtDir  
 WHERE ap.dteDate =  @txtDate  
  AND ap.txtLiquidation IN ('24H','MP')  
  AND op.txtOwnerId = 'JPM02'  
  AND op.txtProductId = 'SNOTES'  
  
 -- Calculo Precio Limpio MO  
 UPDATE r  
 SET txtPRL_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUFXU),16,9))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRL]/@dblEUR),16,9))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUDI),16,9))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRL]/@dblJPY),16,9))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblAUD),16,9))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCAD),16,9))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCHF),16,9))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblGBP),16,9))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRL]/@dblITL),16,9))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblBRL),16,9))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRL/@dblInt),16,6))   
  
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRL]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRL]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRL]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblPEN),16,9))  
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRL]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRL] AS FLOAT),6),19,6))   
     END)  
 FROM @tmp_tblUnifiedPricesReport AS r  
  
 -- Calculo Precio Sucio MO  
 UPDATE r  
 SET txtPRS_MO = (CASE   
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUFXU),16,9))  
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRS]/@dblEUR),16,9))  
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUDI),16,9))  
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRS]/@dblJPY),16,9))  
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblAUD),16,9))  
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCAD),16,9))  
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCHF),16,9))  
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblGBP),16,9))  
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRS]/@dblITL),16,9))  
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblBRL),16,9))  
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRS/@dblInt),16,6))   
  
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCLP),16,9))  
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRS]/@dblCOP),16,9))  
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblDKK),16,9))  
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRS]/@dblHKD),16,9))  
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblIDR),16,9))  
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRS]/@dblNOK),16,9))  
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblPEN),16,9))  
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSEK),16,9))  
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSGD),16,9))  
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRS]/@dblSMG),16,9))  
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblTWD),16,6))  
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblZAR),16,6))  
        
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRS] AS FLOAT),6),19,6))  
     END)  
 FROM @tmp_tblUnifiedPricesReport AS r  
  
 -- Calculo Interes  
 UPDATE r  
 SET txtCPD_MO =   
     (CASE   
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN STR(ROUND(dblCPD,6),13,6)  
      ELSE ROUND(CAST(txtPRS_MO AS FLOAT),6) - ROUND(CAST(txtPRL_MO AS FLOAT),6)  
      END)   
 FROM @tmp_tblUnifiedPricesReport AS r  
   
 -- Agregar hacia una tabla tblResults  
 INSERT @tmp_tblResults (txtTv,txtEmisora,txtSerie,txtData)  
 SELECT  
  txtTV,  
  txtEmisora,  
  txtSerie,  
  'H '+  
  RTRIM(txtMKT) +    
  CONVERT(CHAR(8),dteDate,112) +  
  --TV+Emisora+Serie  
  RTRIM(txtTv) + REPLICATE(' ', 4 - LEN(RTRIM(txtTv))) +   
  RTRIM(txtEmisora) + REPLICATE(' ',7 - LEN(RTRIM(txtEmisora))) +  
  RTRIM(txtserie) + REPLICATE(' ',6 - LEN(RTRIM(txtSerie))) +  
  --PRS MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')   
    THEN REPLACE(SUBSTRING(STR(dblPRS,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRS,16,6),11,6)  
    ELSE   
      (CASE WHEN (txtPRS_MO<>'NA' AND txtPRS_MO<>'-' AND txtPRS_MO<>'')   
       THEN REPLACE(SUBSTRING(STR(CAST(txtPRS_MO AS FLOAT),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(txtPRS_MO AS FLOAT),16,6),11,6)  
       ELSE '000000000000000'  
       END)  
  END +  
  --PRL MD  
  CASE WHEN txtTv IN ('SWT','*C','*CSP')  
    THEN REPLACE(SUBSTRING(STR(dblPRL,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRL,16,6),11,6)  
    ELSE   
      (CASE WHEN (txtPRL_MO<>'NA' AND txtPRL_MO<>'-' AND txtPRL_MO<>'')   
       THEN REPLACE(SUBSTRING(STR(CAST(txtPRL_MO AS FLOAT),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(txtPRL_MO AS FLOAT),16,6),11,6)  
       ELSE '000000000000000'  
       END)  
  END +  
  -- INTERES CPD  
  CASE   
   WHEN txtCPD_MO = 'NA' OR txtCPD_MO = '-' OR txtCPD_MO = '' THEN '000000000000'  
   WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN REPLACE(SUBSTRING(STR(ROUND(dblCPD,6),13,6),1,6),' ','0') + SUBSTRING(STR(ROUND(dblCPD,6),13,6),8,6)  
   ELSE REPLACE(SUBSTRING(STR(CAST(txtCPD_MO AS FLOAT),13,6),1,6),' ','0') + SUBSTRING(STR(CAST(txtCPD_MO AS FLOAT),13,6),8,6)  
  --ELSE '000000000000'  
  END +  
  '0250091' +  
  -- PLAZO A VENCIMIENTO  
  REPLACE(STR(dblDTM,6),' ','0') +  
     -- TASA DESCUENTO  
        REPLACE(SUBSTRING(STR(dblUDR,9,4),1,4),' ','0') + SUBSTRING(STR(dblUDR,9,4),6,6)  
  AS txtData   
 FROM @tmp_tblUnifiedPricesReport    
 WHERE   
   dteDate = @txtDate  
   AND txtLiquidation IN ('24H','MP')  
   AND txtTv NOT IN ('1R','1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP')  
  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResults) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  SELECT RTRIM(txtData)  
  FROM @tmp_tblResults  
  ORDER BY txtTV,txtEmisora,txtSerie  
    
 SET NOCOUNT OFF  
  
END  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
--   Autor:     Mike Ramirez  
--   Fecha Modificacion: 02:55 p.m. 2012-08-21  
--   Descripcion:   Modulo 29: Se excluyen del archivo los TV '1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP'  
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;29   
 @txtDate AS DATETIME  
  
AS  
BEGIN  
   
 SET NOCOUNT ON  
  
 DECLARE @tmp_tblResults TABLE (  
  txtTV char(4),  
  txtEmisora char(7),  
  txtSerie char(6),  
  txtData varchar(8000)  
  PRIMARY KEY (txtTv,txtEmisora,txtSerie)  
 )  
  
 -- 1. Obtengo los instrumentos a los que se les calcula analitico promedio  
 INSERT @tmp_tblResults (txtTV,txtEmisora,txtSerie,txtData)  
 SELECT  
  VP.txtTV,  
  VP.txtEmisora,  
  VP.txtSerie,    
  LTRIM(RTRIM(CONVERT(CHAR(8),VP.dteDate,112))) +  
  --TV+Emisora+Serie  
  LTRIM(RTRIM(VP.txtTv)) + REPLICATE(' ', 4 - LEN(VP.txtTv)) +  
  LTRIM(RTRIM(VP.txtEmisora)) + REPLICATE(' ',7 - LEN(VP.txtEmisora)) +  
  LTRIM(RTRIM(VP.txtserie)) + REPLICATE(' ',6 - LEN(VP.txtSerie)) +   
  --PP MD    
  CASE WHEN (VP.txtPSPP_MO<>'NA' AND VP.txtPSPP_MO<>'-' AND VP.txtPSPP_MO<>'')   
    THEN REPLACE(SUBSTRING(STR(CAST(VP.txtPSPP_MO AS FLOAT),18,8),1,9),' ','0') + SUBSTRING(STR(CAST(VP.txtPSPP_MO AS FLOAT),18,8),11,18)  
     ELSE REPLACE(SUBSTRING(STR(VP.dblPRS,18,8),1,9),' ','0') + SUBSTRING(STR(VP.dblPRS,18,8),11,18) -- '00000000000000000'  
     END +  
     --PP 24H  
  CASE WHEN (VP1.txtPSPP_MO<>'NA' AND VP1.txtPSPP_MO<>'-' AND VP1.txtPSPP_MO<>'')   
    THEN REPLACE(SUBSTRING(STR(CAST(VP1.txtPSPP_MO AS FLOAT),18,8),1,9),' ','0') + SUBSTRING(STR(CAST(VP1.txtPSPP_MO AS FLOAT),18,8),11,18)  
    ELSE REPLACE(SUBSTRING(STR(VP1.dblPRS,18,8),1,9),' ','0') + SUBSTRING(STR(VP1.dblPRS,18,8),11,18) -- '00000000000000000'  
        END +  
  --PP 481  
  CASE WHEN (VP2.txtPSPP_MO<>'NA' AND VP2.txtPSPP_MO<>'-' AND VP2.txtPSPP_MO<>'')   
    THEN REPLACE(SUBSTRING(STR(CAST(VP2.txtPSPP_MO AS FLOAT),18,8),1,9),' ','0') + SUBSTRING(STR(CAST(VP2.txtPSPP_MO AS FLOAT),18,8),11,18)  
      ELSE REPLACE(SUBSTRING(STR(VP2.dblPRS,18,8),1,9),' ','0') + SUBSTRING(STR(VP2.dblPRS,18,8),11,18) -- '00000000000000000'  
     END AS Record    
 FROM   
  dbo.tmp_tblUnifiedPricesReport as VP (NOLOCK)  
  LEFT OUTER JOIN dbo.tmp_tblUnifiedPricesReport AS VP1 (NOLOCK)  
   ON  VP.txtId1 = VP1.txtId1  
  LEFT OUTER JOIN dbo.tmp_tblUnifiedPricesReport as VP2 (NOLOCK)  
   ON  VP.txtId1 = VP2.txtId1  
 WHERE   
  VP.dteDate = @txtDate  
  AND VP.txtLiquidation IN ('MD','MP')  
  AND VP1.txtLiquidation IN ('24H','MP')  
  AND VP2.txtLiquidation IN ('481','MP')  
  AND VP.txtTv NOT IN ('1R','FA','FB','FC','FD','FI','FM','FS','FU','OA',  
   'OC','OD','OI','WA','WASP','WC','WE','WESP','WI','TR','RC','SWT',  
   '1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP',  
   'D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP')  
  
 -- 2. Obtengo los instrumentos a los que no se les calcula analitico PROMEDIO  
 INSERT @tmp_tblResults (txtTV,txtEmisora,txtSerie,txtData)  
 SELECT  
  VP.txtTV,  
  VP.txtEmisora,  
  VP.txtSerie,    
  LTRIM(RTRIM(CONVERT(CHAR(8),VP.dteDate,112))) +  
  --TV+Emisora+Serie  
  LTRIM(RTRIM(VP.txtTv)) + REPLICATE(' ', 4 - LEN(VP.txtTv)) +  
  LTRIM(RTRIM(VP.txtEmisora)) + REPLICATE(' ',7 - LEN(VP.txtEmisora)) +  
  LTRIM(RTRIM(VP.txtserie)) + REPLICATE(' ',6 - LEN(VP.txtSerie)) +  
  --PP MD  
  REPLACE(SUBSTRING(STR(VP.dblValue,18,8),1,9),' ','0') + SUBSTRING(STR(VP.dblValue,18,8),11,18) +  
  --PP 24  
  REPLACE(SUBSTRING(STR(VP1.dblValue,18,8),1,9),' ','0') + SUBSTRING(STR(VP1.dblValue,18,8),11,18) +  
  --PP 48  
  REPLACE(SUBSTRING(STR(VP2.dblValue,18,8),1,9),' ','0') + SUBSTRING(STR(VP2.dblValue,18,8),11,18)  
 FROM   
  dbo.tblAverageVector as vp (NOLOCK)  
  LEFT OUTER JOIN dbo.tblAverageVector AS VP1 (NOLOCK)  
   ON  VP.dteDate = VP1.dteDate  
    AND VP.txtTv = VP1.txtTv  
    AND VP.txtEmisora = VP1.txtEmisora  
    AND VP.txtSerie = VP1.txtSerie  
  LEFT OUTER JOIN dbo.tblAverageVector as VP2 (NOLOCK)  
   ON  VP.dteDate = VP2.dteDate  
    AND VP.txtTv = VP2.txtTv  
    AND VP.txtEmisora = VP2.txtEmisora  
    AND VP.txtSerie = VP2.txtSerie  
 WHERE     
   VP.dteDate = @txtDate  
   AND VP.txtLiquidation = 'MD'  
   AND VP1.txtLiquidation = '24H'  
   AND VP2.txtLiquidation = '481'  
   AND VP.txtTv IN ('FA','FB','FC','FD','FI','FM','FS','FU','OA','OC','OD','OI','WA','WASP',  
        'WC','WE','WESP','WI','TR','RC','SWT',  
        '1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP',  
        'D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP')  
  
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResults) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT RTRIM(txtData)  
  FROM @tmp_tblResults  
  ORDER BY txtTV,txtEmisora,txtSerie  
    
 SET NOCOUNT OFF  
  
END  
--   Autor:         Mike Ramirez  
--   Creacion:  09:51 a.m. 2011-03-01  
--   Descripcion:   Modulo 30: Procedimiento que genera el producto JPMORGAN_EUSVOL[YYYYMMDD].xls  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;30  
 @txtDate DATETIME  
  
AS  
BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtCode CHAR(10),  
   intNode INT,  
   intCol INT,  
   intRow INT,  
   dblValue FLOAT NULL,  
   intStrike FLOAT NULL  
    PRIMARY KEY (intCol, intRow)  
  )   
  
 DECLARE @dblValue AS FLOAT   
  
 -- Configuración de Directivas  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 3, 7, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 3, 8, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 3, 9, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 3, 10, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 3, 11, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 3, 12, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 3, 13, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 3, 14, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 3, 15, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 3, 16, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 3, 17, 1.23  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 3, 18, 1.23  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 4, 7, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 4, 8, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 4, 9, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 4, 10, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 4, 11, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 4, 12, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 4, 13, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 4, 14, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 4, 15, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 4, 16, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 4, 17, 1.25  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 4, 18, 1.25  
  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 5, 7, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 5, 8, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 5, 9, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 5, 10, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 5, 11, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 5, 12, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 5, 13, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 5, 14, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 5, 15, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 5, 16, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 5, 17, 1.27  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 5, 18, 1.27  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 6, 7, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 6, 8, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 6, 9, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 6, 10, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 6, 11, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 6, 12, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 6, 13, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 6, 14, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 6, 15, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 6, 16, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 6, 17, 1.29  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 6, 18, 1.29  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 7, 7, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 7, 8, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 7, 9, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 7, 10, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 7, 11, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 7, 12, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 7, 13, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 7, 14, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 7, 15, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 7, 16, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 7, 17, 1.31  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 7, 18, 1.31  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 8, 7, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 8, 8, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 8, 9, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 8, 10, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 8, 11, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 8, 12, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 8, 13, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 8, 14, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 8, 15, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 8, 16, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 8, 17, 1.33  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 8, 18, 1.33  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 9, 7, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 9, 8, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 9, 9, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 9, 10, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 9, 11, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 9, 12, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 9, 13, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 9, 14, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 9, 15, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 9, 16, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 9, 17, 1.35  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 9, 18, 1.35  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 10, 7, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 10, 8, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 10, 9, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 10, 10, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 10, 11, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 10, 12, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 10, 13, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 10, 14, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 10, 15, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 10, 16, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 10, 17, 1.37  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 10, 18, 1.37  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 11, 7, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 11, 8, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 11, 9, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 11, 10, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 11, 11, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 11, 12, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 11, 13, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 11, 14, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 11, 15, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 11, 16, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 11, 17, 1.39  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 11, 18, 1.39  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 1, 12, 7, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 7, 12, 8, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 30, 12, 9, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 45, 12, 10, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 60, 12, 11, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 90, 12, 12, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 120, 12, 13, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 150, 12, 14, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 180, 12, 15, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 270, 12, 16, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 365, 12, 17, 1.41  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow,intStrike)SELECT 1, 'SURFACES', 'EUS/VOL', 720, 12, 18, 1.41  
  
  INSERT INTO @tblDirectives(intSection, txtSource,txtCode,intNode,intCol,intRow)SELECT 2, 'DATE', 'NA', 0, 1, 3  
  
  -- regreso los limites  
  SELECT  
  intSection,  
  MIN(intCol) AS intMinCol,  
  MAX(intCol) AS intMaxCol,  
  MIN(intRow) AS intMinRow,  
  MAX(intRow) AS intMaxRow  
  FROM @tblDirectives  
  GROUP BY   
  intSection  
  ORDER BY   
  intSection  
   
  -- regreso las directivas  
  SELECT   
  LTRIM(STR(intSection)) AS txtSection,  
  txtSource,  
  txtCode,  
  intNode,  
  intCol,  
  intRow,  
  dblValue,  
  intStrike  
  FROM @tblDirectives  
  ORDER BY   
  intSection,  
  intCol,  
  intRow  
  
  SET NOCOUNT OFF  
  
END   
    
-- Autor:   Mike Ramírez     
-- Creacion:  09:48 a.m. 2011-10-04    
-- Descripcion: Modulo 31: Procedimiento que genera producto JPMorganCCYBasis_[yyyymmdd].xls     
CREATE  PROCEDURE dbo.sp_productos_JPMORGAN;31    
  @txtDate AS DATETIME   --= '20140722'  
AS        
BEGIN        
    
SET NOCOUNT ON    
    
 -- creo tabla temporal de Directivas    
 DECLARE @tblDirectives TABLE (    
   indSheet INT,    
   SheetName CHAR(50),    
   intSection INT,    
   txtSource CHAR(50),    
   txtCode CHAR(250),    
   intCol INT,    
   intRow INT,    
   txtValue CHAR(50),    
   Node INT    
  PRIMARY KEY (indSheet, intCol, intRow)    
  )     
    
 -- Creación de Directivas para obtener información    
 -- <Sheet1> Date    
    
 INSERT @tblDirectives            
  SELECT 01,'Sheet1',1,'DATE','YYYYMMDD',2,1,CONVERT(CHAR(10),@txtDate,103),0    
    
 -- <Sheet1> SWPLIBTIIE    
 INSERT @tblDirectives    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1',4,6,NULL,1 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|28',4,7,NULL,28 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|56',4,8,NULL,56 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|84',4,9,NULL,84 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|168',4,10,NULL,168 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|252',4,11,NULL,252 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|364',4,12,NULL,364 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|728',4,13,NULL,728 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1092',4,14,NULL,1092 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1456',4,15,NULL,1456 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|1820',4,16,NULL,1820 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|2548',4,17,NULL,2548 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|3640',4,18,NULL,3640 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|4368',4,19,NULL,4368 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|5460',4,20,NULL,5460 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|7280',4,21,NULL,7280 UNION    
  SELECT 01,'Sheet1',2,'CURVES','SWPLIBTIIE|10920',4,22,NULL,10920    
    
 -- Obtengo los valores de los SWPLIBTIIE    
  UPDATE td     
   SET txtValue = LTRIM(STR(ROUND(dblLevel*100,8),12,8))    
  FROM @tblDirectives AS td    
  INNER JOIN tblMarkets AS m (NOLOCK)    
  ON td.node = m.intTerm    
  WHERE dteDate = @txtDate     
    AND m.txtCode = 'SWPLIBTIIE'    
    AND m.intTerm IN ('1','28','56','84','168','252','364','728','1092','1456','1820','2548','3640','4368','5460','7280','10920')    
    
 -- Valida la información     
 IF ((SELECT count(*) FROM @tblDirectives WHERE txtValue IS NULL) > 0)    
    
 BEGIN    
  RAISERROR ('ERROR: Falta Informacion', 16, 1)    
 END    
    
 ELSE    
 BEGIN    
    
    -- regreso los limites    
   SELECT    
    intSection,    
    MIN(intCol) AS intMinCol,    
    MAX(intCol) AS intMaxCol,    
    MIN(intRow) AS intMinRow,    
    MAX(intRow) AS intMaxRow    
    FROM @tblDirectives    
    GROUP BY     
    intSection    
    ORDER BY     
    intSection    
    
   -- regreso las directivas    
   SELECT     
    LTRIM(STR(intSection)) AS [intSection],    
    txtSource,    
    txtCode,    
    intCol AS [intCol],    
    intRow AS [intRow],    
    RTRIM(txtValue) AS [txtValue]    
   FROM @tblDirectives    
   ORDER BY     
    intSection,    
    intCol,    
    intRow    
    
 END     
    
 SET NOCOUNT OFF    
    
END    
    
  
  
-------------------------------------------------------------------------------------------------      
 --Autor:    Mike Ramírez      
 --Fecha Creacion:     03:02 a.m. 2012-03-01      
 --Descripcion:   Incluir una columna que reporte la fecha del proximo corte de cupón. txtNCR      
-------------------------------------------------------------------------------------------------      
CREATE PROCEDURE [dbo].[sp_productos_JPMORGAN];32    --'20140512' ,'24H'    
--DECLARE   
   @txtDate AS DATETIME, --= '20140506'     
--declare   
  @txtLiquidation AS VARCHAR(3) --= '24H'    
      
AS       
  
BEGIN      
      
 SET NOCOUNT ON      
      
--  DECLARE   
--   @txtDate AS DATETIME --= '20140506'     
--declare   
--  @txtLiquidation AS VARCHAR(3) --= '24H'    
    
--  SET @txtDate = '20140701'  
--  SET @txtLiquidation = '24H'  
      
 DECLARE @tblVector TABLE (      
  [txtSortTv][VARCHAR](10),      
  [txtSortEmisora][VARCHAR](10),      
  [txtSortSerie][VARCHAR](10),      
  [dtedate][VARCHAR](10),      
  [txtTv][VARCHAR](10),      
  [txtEmisora][VARCHAR](10),      
  [txtSerie][VARCHAR](10),      
  [dblPRS][VARCHAR](30),      
  [dblPRL][VARCHAR](30),      
  [dblCPD][VARCHAR](30),      
  [dblCuponCPA][VARCHAR](30),      
  [dblLDR][VARCHAR](30),      
  [txtNEM][VARCHAR](400),      
  [txtSEC][VARCHAR](400),      
  [txtMOE][VARCHAR](400),      
  [txtMOC][VARCHAR](400),      
  [txtISD][VARCHAR](400),      
  [txtTTM][VARCHAR](400),      
  [txtMTD][VARCHAR](400),      
  [txtNOM][VARCHAR](400),      
  [txtCUR][VARCHAR](400),      
  [txtIRCSUBY][VARCHAR](400),      
  [txtCYT][VARCHAR](400),      
  [txtOSP][VARCHAR](400),      
  [txtCPF][VARCHAR](400),      
  [dblTasaCPA][VARCHAR](30),      
  [txtDTC][VARCHAR](400),      
  [txtCRL][VARCHAR](400),      
  [txtTCR][VARCHAR](400),      
  [txtFCR][VARCHAR](400),      
  [txtLPV][VARCHAR](400),      
  [txtLPD][VARCHAR](400),      
  [txtTHP][VARCHAR](400),      
  [txtLCA][VARCHAR](400),      
  [txtLPU][VARCHAR](400),      
  [txtBYT][VARCHAR](400),      
  [txtOYT][VARCHAR](400),      
  [txtBSP][VARCHAR](400),      
  [txtPSP][VARCHAR](400),      
  [txtDPQ][VARCHAR](400),      
  [txtSPQ][VARCHAR](400),      
  [txtBUR][VARCHAR](400),      
  [txtLIQ][VARCHAR](400),      
  [txtDPC][VARCHAR](400),      
  [txtWPC][VARCHAR](400),      
  [txtMHP][VARCHAR](400),      
  [txtIHP][VARCHAR](400),      
  [txtSUS][VARCHAR](400),      
  [txtVOL][VARCHAR](400),      
  [txtVO2][VARCHAR](400),      
  [txtDMF][VARCHAR](400),      
  [txtDMT][VARCHAR](400),      
  [txtCMT][VARCHAR](400),      
  [txtVAR][VARCHAR](400),      
  [txtSTD][VARCHAR](400),      
  [txtVNA][VARCHAR](400),      
  [txtFIQ][VARCHAR](400),      
  [txtDMH][VARCHAR](400),      
  [txtDIH][VARCHAR](400),      
  [txtSTP][VARCHAR](400),      
  [txtDMC][VARCHAR](400),      
  [dblYTM][VARCHAR](30),      
  [txtHRQ][VARCHAR](400),      
  [txtDEF][VARCHAR](400),      
  [txtID2][VARCHAR](400),      
  [txtNCR][VARCHAR](400)      
  PRIMARY KEY CLUSTERED (      
   txtTV, txtEmisora, txtSerie      
   )      
 )      
      
 INSERT @tblVector (txtSortTv,txtSortEmisora,txtSortSerie,dtedate,txtTv,txtEmisora,txtSerie,dblPRS,dblPRL,dblCPD,dblCuponCPA,dblLDR,txtNEM,txtSEC,txtMOE,txtMOC,txtISD,txtTTM,txtMTD,txtNOM,txtCUR,txtIRCSUBY,txtCYT,txtOSP,txtCPF,dblTasaCPA,txtDTC,txtCRL,tx
tTCR,txtFCR,txtLPV,txtLPD,txtTHP,txtLCA,txtLPU,txtBYT,txtOYT,txtBSP,txtPSP,txtDPQ,txtSPQ,txtBUR,txtLIQ,txtDPC,txtWPC,txtMHP,txtIHP,txtSUS,txtVOL,txtVO2,txtDMF,txtDMT,txtCMT,txtVAR,txtSTD,txtVNA,txtFIQ,txtDMH,txtDIH,txtSTP,txtDMC,dblYTM,txtHRQ,txtDEF,txtID
2,txtNCR)      
 SELECT       
   txtTV AS [txtSortTv],      
   txtEmisora AS [txtSortEmisora],      
   txtSerie AS [txtSortSerie],      
   CONVERT(CHAR(8), dteDate,112) AS [dteDate],       
   txtTv AS [txtTv],       
   txtEmisora AS [txtEmisora],      
   txtSerie AS [txtSerie],      
   LTRIM(STR(ROUND(dblPRS,6),16,6)) AS [dblPRS],      
   LTRIM(STR(ROUND(dblPRL,6),16,6)) AS [dblPRL],      
   LTRIM(STR(ROUND(dblCPD,6),16,6)) AS [dblCPD],      
   LTRIM(STR(dblCPA,11,6)) AS [dblCuponCPA],      
   LTRIM(STR(dblLDR,11,6)) AS [dblLDR],      
   LTRIM(RTRIM(REPLACE(txtNEM,CHAR(9),' '))) AS [txtNEM],      
   txtSEC AS [txtSEC],      
   txtMOE AS [txtMOE],      
  txtMOC AS [txtMOC],      
   txtISD AS [txtISD],      
   txtTTM AS [txtTTM],      
   txtMTD AS [txtMTD],      
   txtNOM AS [txtNOM],      
   txtCUR AS [txtCUR],      
   txtIRCSUBY AS [txtIRCSUBY],      
   txtCYT AS [txtCYT],      
   txtOSP AS [txtOSP],      
   txtCPF AS [txtCPF],      
   CASE WHEN dblCPA = 0 THEN '0' ELSE LTRIM(STR(dblCPA,11,6)) END AS [dblTasaCPA],      
   txtDTC AS [txtDTC],      
   RTRIM(txtCRL) AS [txtCRL],      
   txtTCR AS [txtTCR],      
   txtFCR AS [txtFCR],      
   txtLPV AS [txtLPV],      
   txtLPD AS [txtLPD],      
   txtTHP AS [txtTHP],      
   txtLCA AS [txtLCA],      
   txtLPU AS [txtLPU],      
   txtBYT AS [txtBYT],      
   txtOYT AS [txtOYT],      
   txtBSP AS [txtBSP],      
   txtPSP AS [txtPSP],      
   txtDPQ AS [txtDPQ],      
   txtSPQ AS [txtSPQ],      
   txtBUR AS [txtBUR],      
   txtLIQ AS [txtLIQ],      
   txtDPC AS [txtDPC],      
   txtWPC AS [txtWPC],      
   txtMHP AS [txtMHP],      
   txtIHP AS [txtIHP],      
   txtSUS AS [txtSUS],      
   txtVOL AS [txtVOL],      
   txtVO2 AS [txtVO2],      
   [txtDMF] AS [txtDMF],      
   [txtDMT] AS [txtDMT],      
   [txtCMT] AS [txtCMT],      
   txtVAR AS [txtVAR],      
   txtSTD AS [txtSTD],      
   txtVNA AS [txtVNA],      
   txtFIQ AS [txtFIQ],      
   txtDMH AS [txtDMH],      
   txtDIH  AS [txtDIH],      
   [txtSTP] AS [txtSTP],      
   [txtDMC] AS [txtDMC],      
   LTRIM(STR(dblYTM,11,6)) AS [dblYTM],      
   [txtHRQ] AS [txtHRQ],      
   [txtDEF] AS [txtDEF],      
   CASE WHEN txtID2 = '-' OR txtID2 = 'NA' THEN '' ELSE txtID2 END AS [txtISIN],      
   [txtNCR] AS [txtNCR]      
 FROM   PIPMXSQL.MxFixIncome.dbo.tmp_tblUnifiedPricesReport (NOLOCK)       
 WHERE txtLiquidation IN (@txtLiquidation,'MP')       
 AND txtId1 NOT IN ('MIRC0000182')    
   AND dtedate = @txtDate        
 ORDER BY txtTV, txtEmisora, txtSerie        
    
 -- Info: Notas Estructuradas      
 INSERT @tblVector(txtSortTv,txtSortEmisora,txtSortSerie,dtedate,txtTv,txtEmisora,txtSerie,dblPRS,dblPRL,dblCPD,dblCuponCPA,dblLDR,txtNEM,txtSEC,txtMOE,txtMOC,txtISD,txtTTM,txtMTD,txtNOM,txtCUR,txtIRCSUBY,txtCYT,txtOSP,txtCPF,dblTasaCPA,txtDTC,txtCRL,txtT
CR,txtFCR,txtLPV,txtLPD,txtTHP,txtLCA,txtLPU,txtBYT,txtOYT,txtBSP,txtPSP,txtDPQ,txtSPQ,txtBUR,txtLIQ,txtDPC,txtWPC,txtMHP,txtIHP,txtSUS,txtVOL,txtVO2,txtDMF,txtDMT,txtCMT,txtVAR,txtSTD,txtVNA,txtFIQ,txtDMH,txtDIH,txtSTP,txtDMC,dblYTM,txtHRQ,txtDEF,txtID2,
txtNCR)   
 SELECT       
   txtTV AS [txtSortTv],      
   txtEmisora AS [txtSortEmisora],      
   txtSerie AS [txtSortSerie],      
   CONVERT(CHAR(8), dteDate,112) AS [dteDate],       
   txtTv AS [txtTv],       
   txtEmisora AS [txtEmisora],      
   txtSerie AS [txtSerie],      
   LTRIM(STR(ROUND(dblPRS,6),16,6)) AS [dblPRS],      
   LTRIM(STR(ROUND(dblPRL,6),16,6)) AS [dblPRL],      
   LTRIM(STR(ROUND(dblCPD,6),16,6)) AS [dblCPD],      
   LTRIM(STR(dblCPA,11,6)) AS [dblCuponCPA],      
   LTRIM(STR(dblLDR,11,6)) AS [dblLDR],      
   LTRIM(RTRIM(REPLACE(txtNEM,CHAR(9),' '))) AS [txtNEM],      
   txtSEC AS [txtSEC],      
   txtMOE AS [txtMOE],      
   txtMOC AS [txtMOC],      
   txtISD AS [txtISD],      
   txtTTM AS [txtTTM],      
   txtMTD AS [txtMTD],      
   txtNOM AS [txtNOM],      
   txtCUR AS [txtCUR],      
   txtIRCSUBY AS [txtIRCSUBY],      
   txtCYT AS [txtCYT],      
   txtOSP AS [txtOSP],      
   txtCPF AS [txtCPF],      
   CASE WHEN dblCPA = 0 THEN '0' ELSE LTRIM(STR(dblCPA,11,6)) END AS [dblTasaCPA],      
   txtDTC AS [txtDTC],      
   RTRIM(txtCRL) AS [txtCRL],      
   txtTCR AS [txtTCR],      
   txtFCR AS [txtFCR],      
   txtLPV AS [txtLPV],      
   txtLPD AS [txtLPD],      
   txtTHP AS [txtTHP],      
   txtLCA AS [txtLCA],      
   txtLPU AS [txtLPU],      
   txtBYT AS [txtBYT],      
   txtOYT AS [txtOYT],      
   txtBSP AS [txtBSP],      
   txtPSP AS [txtPSP],      
   txtDPQ AS [txtDPQ],      
   txtSPQ AS [txtSPQ],      
   txtBUR AS [txtBUR],      
   txtLIQ AS [txtLIQ],      
   txtDPC AS [txtDPC],      
   txtWPC AS [txtWPC],      
   txtMHP AS [txtMHP],      
   txtIHP AS [txtIHP],      
   txtSUS AS [txtSUS],      
   txtVOL AS [txtVOL],      
   txtVO2 AS [txtVO2],      
   [txtDMF] AS [txtDMF],      
   [txtDMT] AS [txtDMT],      
   [txtCMT] AS [txtCMT],      
   txtVAR AS [txtVAR],      
   txtSTD AS [txtSTD],      
   txtVNA AS [txtVNA],      
   txtFIQ AS [txtFIQ],      
   txtDMH AS [txtDMH],      
   txtDIH  AS [txtDIH],      
   [txtSTP] AS [txtSTP],      
   [txtDMC] AS [txtDMC],      
   LTRIM(STR(dblYTM,11,6)) AS [dblYTM],      
   [txtHRQ] AS [txtHRQ],      
   [txtDEF] AS [txtDEF],      
   CASE WHEN txtID2 = '-' OR txtID2 = 'NA' THEN '' ELSE txtID2 END AS [txtISIN],      
   [txtNCR] AS [txtNCR]      
 FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS i (NOLOCK)      
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS p (NOLOCK)      
   ON i.txtId1 = p.txtDir      
 WHERE txtLiquidation IN (@txtLiquidation,'MP')         
   AND dtedate = @txtDate      
   AND p.txtOwnerId = 'JPM02'        
   AND p.txtProductid = 'SNOTES'      
 ORDER BY txtTV, txtEmisora, txtSerie        
      
  
 SELECT    -- TOP 122  
  RTRIM(LTRIM([dtedate])),     
  RTRIM(LTRIM([txtTv])),    
  RTRIM(LTRIM([txtEmisora])),      
  RTRIM(LTRIM([txtSerie])),      
  [dblPRL],      
  [dblPRS],      
  [dblCPD],      
  [dblCuponCPA],      
  RTRIM(LTRIM([dblLDR])),      
  RTRIM(LTRIM([txtNEM])),      
  RTRIM(LTRIM([txtSEC])),      
  RTRIM(LTRIM([txtMOE])),      
  RTRIM(LTRIM([txtMOC])),      
  RTRIM(LTRIM([txtISD])),      
  RTRIM(LTRIM([txtTTM])),      
  RTRIM(LTRIM([txtMTD])),      
  RTRIM(LTRIM([txtNOM])),      
  RTRIM(LTRIM([txtCUR])),      
  RTRIM(LTRIM([txtIRCSUBY])),      
  RTRIM(LTRIM([txtCYT])),      
  RTRIM(LTRIM([txtOSP])),      
  RTRIM(LTRIM([txtCPF])),      
  RTRIM(LTRIM([dblTasaCPA])),    
  RTRIM(LTRIM([txtDTC])),      
  RTRIM(LTRIM([txtCRL])),      
  RTRIM(LTRIM([txtTCR])),      
  RTRIM(LTRIM([txtFCR])),      
  RTRIM(LTRIM([txtLPV])),      
  RTRIM(LTRIM([txtLPD])),      
  RTRIM(LTRIM([txtTHP])),      
  RTRIM(LTRIM([txtLCA])),      
  RTRIM(LTRIM([txtLPU])),      
  RTRIM(LTRIM([txtBYT])),      
  RTRIM(LTRIM([txtOYT])),      
  RTRIM(LTRIM([txtBSP])),  --      
  RTRIM(LTRIM([txtPSP])),      
  RTRIM(LTRIM([txtDPQ])),      
  RTRIM(LTRIM([txtSPQ])),      
  RTRIM(LTRIM([txtBUR])),      
  RTRIM(LTRIM([txtLIQ])),      
  RTRIM(LTRIM([txtDPC])),      
  RTRIM(LTRIM([txtWPC])),      
  RTRIM(LTRIM([txtMHP])),      
  RTRIM(LTRIM([txtIHP])),      
  RTRIM(LTRIM([txtSUS])),      
  RTRIM(LTRIM([txtVOL])),     
  RTRIM(LTRIM([txtVO2])),      
  RTRIM(LTRIM([txtDMF])),     
  RTRIM(LTRIM([txtDMT])),      
  RTRIM(LTRIM([txtCMT])),      
  RTRIM(LTRIM([txtVAR])),      
  RTRIM(LTRIM([txtSTD])),      
  RTRIM(LTRIM([txtVNA])),      
  RTRIM(LTRIM([txtFIQ])),      
  RTRIM(LTRIM([txtDMH])),     
  RTRIM(LTRIM([txtDIH])),      
  RTRIM(LTRIM([txtSTP])),      
  RTRIM(LTRIM([txtDMC])),      
  RTRIM(LTRIM([dblYTM])),      
  RTRIM(LTRIM([txtHRQ])),      
  RTRIM(LTRIM([txtDEF])),      
  RTRIM(LTRIM([txtID2])),  
--  RTRIM(LTRIM([txtNCR]))--CASE WHEN [txtNCR] IS NULL OR [txtNCR] = 'NA' OR [txtNCR] = '-' THEN 'NA' ELSE [txtNCR] END   
   CASE WHEN (txtNCR <> 'NA' AND txtNCR <> '-' AND txtNCR <> '')   
    THEN RTRIM(txtNCR)  
    ELSE ''  
   END  
 FROM @tblVector  
 ORDER BY txtSortTV, txtSortEmisora, txtSortSerie      
     
 SET NOCOUNT OFF       
  
END      
  
  
-------------------------------------------------------  
--   Creado por: Mike Ramirez  
--   Modificacion:  10:29 2013-07-04  
--   Descripcion: Modulo 33: Se incluye la Sabana NDX  
-------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;33  
 @txtDate DATETIME      
AS           
BEGIN          
      
  SET NOCOUNT ON  
  
  DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtType CHAR(8),  
   txtSubType CHAR(4),  
   txtISIN CHAR(30),  
   txtRIC CHAR(30),  
   txtCurrency CHAR(30),  
   txtIdentifier CHAR(30)  
    PRIMARY KEY (intSection)  
  )   
  
 DECLARE @dblValue AS FLOAT   
  
 -- Configuración de Directivas Sabanas  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 001, 'SURFACES','JSPY','CALL','US78462F1030','SPY.p','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 002, 'SURFACES','JMEXBL','CALL','','.MXX','MXN','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 003, 'SURFACES','JEWZ','CALL','US4642864007','EWZso.P','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 004, 'SURFACES','GMEX','PRVO','MXP370841019','GMEXICOB.MX','MXN','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 005, 'SURFACES','AMX','PRVO','MXP001691213','AMXL.MX','MXN','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 006, 'SURFACES','SPX','PRVO','','.INX','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 007, 'SURFACES','AAPL','PRVO','US0378331005','AAPL.OQ','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 008, 'SURFACES','EWJ','PRVO','US4642868487','EWJ.P','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 009, 'SURFACES','NDX','PRVO','','.NDX','USD','CALL'  
  
  -- regreso las directivas  
  SELECT   
  LTRIM(STR(intSection)) AS txtSection,  
  txtSource,  
  txtType,  
  txtSubType,  
  RTRIM(txtISIN) AS txtISIN,  
  RTRIM(txtRIC) AS txtRIC,  
  RTRIM(txtCurrency) AS txtCurrency,  
  RTRIM(txtIdentifier) AS txtIdentifier  
  FROM @tblDirectives  
  ORDER BY   
  intSection  
  
  SET NOCOUNT OFF  
  
END  
  
  
-------------------------------------------------------  
--   Autor:      Mike Ramirez  
--   Modificacion:  2013-11-01  
--   Descripcion:   Modulo 34: Se agregan 1 Subyacentes  
-------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;34  
@txtDate AS DATETIME   
   
AS   
BEGIN   
   
 SET NOCOUNT ON   
   
 -- genera tabla temporal de resultados   
 DECLARE @tblResult TABLE (   
 [intSection][INTEGER],   
 [txtData][VARCHAR](8000)   
 )   
    
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)   
 DECLARE @tmp_tblCurvesNodes TABLE (   
  [intSection][INTEGER],   
  [txtType] CHAR(3),   
  [txtSubType] CHAR(3),   
  [intNode] INT,   
  [txtISIN] CHAR(30),   
  [txtRIC] CHAR(30),   
  [txtid_ccy_std] CHAR(3),  
  [txtid_prd_mat] CHAR(3),  
  [dblrt_int] VARCHAR(50)  
 PRIMARY KEY(intSection,txtType,txtSubType,intNode)   
 )   
  
 -- Nodos de Curvas (FRPiP)   
 INSERT @tmp_tblCurvesNodes  
  SELECT 001,'LIB','YLD',1,'US78462F1030','SPY.p','USD','ON',NULL UNION   
  SELECT 002,'LIB','YLD',30,'US78462F1030','SPY.p','USD','1M',NULL UNION   
  SELECT 003,'LIB','YLD',60,'US78462F1030','SPY.p','USD','2M',NULL UNION   
  SELECT 004,'LIB','YLD',90,'US78462F1030','SPY.p','USD','3M',NULL UNION   
  SELECT 005,'LIB','YLD',180,'US78462F1030','SPY.p','USD','6M',NULL UNION   
  SELECT 006,'LIB','YLD',360,'US78462F1030','SPY.p','USD','1Y',NULL UNION   
  SELECT 007,'LIB','YLD',720,'US78462F1030','SPY.p','USD','2Y',NULL UNION   
  SELECT 008,'LIB','YLD',1080,'US78462F1030','SPY.p','USD','3Y',NULL UNION   
  SELECT 009,'LIB','YLD',1440,'US78462F1030','SPY.p','USD','4Y',NULL UNION   
  SELECT 010,'LIB','YLD',1800,'US78462F1030','SPY.p','USD','5Y',NULL UNION   
  SELECT 011,'LIB','YLD',2520,'US78462F1030','SPY.p','USD','7Y',NULL UNION   
  SELECT 012,'LIB','YLD',3600,'US78462F1030','SPY.p','USD','10Y',NULL UNION   
  SELECT 013,'LIB','YLD',7200,'US78462F1030','SPY.p','USD','20Y',NULL UNION   
  SELECT 014,'LIB','YLD',10800,'US78462F1030','SPY.p','USD','30Y',NULL  
  INSERT @tmp_tblCurvesNodes  
  SELECT 015,'SWP','TI',1,'','.MXX','MXN','ON',NULL UNION   
  SELECT 016,'SWP','TI',28,'','.MXX','MXN','1M',NULL UNION   
  SELECT 017,'SWP','TI',56,'','.MXX','MXN','2M',NULL UNION   
  SELECT 018,'SWP','TI',84,'','.MXX','MXN','3M',NULL UNION   
  SELECT 019,'SWP','TI',168,'','.MXX','MXN','6M',NULL UNION   
  SELECT 020,'SWP','TI',364,'','.MXX','MXN','1Y',NULL UNION   
  SELECT 021,'SWP','TI',728,'','.MXX','MXN','2Y',NULL UNION   
  SELECT 022,'SWP','TI',1092,'','.MXX','MXN','3Y',NULL UNION   
  SELECT 023,'SWP','TI',1456,'','.MXX','MXN','4Y',NULL UNION   
  SELECT 024,'SWP','TI',1820,'','.MXX','MXN','5Y',NULL UNION   
  SELECT 025,'SWP','TI',2548,'','.MXX','MXN','7Y',NULL UNION   
  SELECT 026,'SWP','TI',3640,'','.MXX','MXN','10Y',NULL UNION   
  SELECT 027,'SWP','TI',7280,'','.MXX','MXN','20Y',NULL UNION   
  SELECT 028,'SWP','TI',10920,'','.MXX','MXN','30Y',NULL  
  INSERT @tmp_tblCurvesNodes  
  SELECT 029,'LIB','YLD',1,'US4642864007','EWZso.p','USD','ON',NULL UNION   
  SELECT 030,'LIB','YLD',30,'US4642864007','EWZso.p','USD','1M',NULL UNION   
  SELECT 031,'LIB','YLD',60,'US4642864007','EWZso.p','USD','2M',NULL UNION   
  SELECT 032,'LIB','YLD',90,'US4642864007','EWZso.p','USD','3M',NULL UNION   
  SELECT 033,'LIB','YLD',180,'US4642864007','EWZso.p','USD','6M',NULL UNION   
  SELECT 034,'LIB','YLD',360,'US4642864007','EWZso.p','USD','1Y',NULL UNION   
  SELECT 035,'LIB','YLD',720,'US4642864007','EWZso.p','USD','2Y',NULL UNION   
  SELECT 036,'LIB','YLD',1080,'US4642864007','EWZso.p','USD','3Y',NULL UNION   
  SELECT 037,'LIB','YLD',1440,'US4642864007','EWZso.p','USD','4Y',NULL UNION   
  SELECT 040,'LIB','YLD',1800,'US4642864007','EWZso.p','USD','5Y',NULL UNION   
  SELECT 041,'LIB','YLD',2520,'US4642864007','EWZso.p','USD','7Y',NULL UNION   
  SELECT 042,'LIB','YLD',3600,'US4642864007','EWZso.p','USD','10Y',NULL UNION   
  SELECT 043,'LIB','YLD',7200,'US4642864007','EWZso.p','USD','20Y',NULL UNION   
  SELECT 044,'LIB','YLD',10800,'US4642864007','EWZso.p','USD','30Y',NULL  
    
  INSERT @tmp_tblCurvesNodes  
  SELECT 045,'SWP','TI',1,'MXP370841019','GMEXICOB.MX','MX','ON',NULL UNION   
  SELECT 046,'SWP','TI',28,'MXP370841019','GMEXICOB.MX','MX','1M',NULL UNION   
  SELECT 047,'SWP','TI',56,'MXP370841019','GMEXICOB.MX','MX','2M',NULL UNION   
  SELECT 048,'SWP','TI',84,'MXP370841019','GMEXICOB.MX','MX','3M',NULL UNION   
  SELECT 049,'SWP','TI',168,'MXP370841019','GMEXICOB.MX','MX','6M',NULL UNION   
  SELECT 050,'SWP','TI',364,'MXP370841019','GMEXICOB.MX','MX','1Y',NULL UNION   
  SELECT 051,'SWP','TI',728,'MXP370841019','GMEXICOB.MX','MX','2Y',NULL UNION   
  SELECT 052,'SWP','TI',1092,'MXP370841019','GMEXICOB.MX','MX','3Y',NULL UNION   
  SELECT 053,'SWP','TI',1456,'MXP370841019','GMEXICOB.MX','MX','4Y',NULL UNION   
  SELECT 054,'SWP','TI',1820,'MXP370841019','GMEXICOB.MX','MX','5Y',NULL UNION   
  SELECT 055,'SWP','TI',2548,'MXP370841019','GMEXICOB.MX','MX','7Y',NULL UNION   
  SELECT 056,'SWP','TI',3640,'MXP370841019','GMEXICOB.MX','MX','10Y',NULL UNION   
  SELECT 057,'SWP','TI',7280,'MXP370841019','GMEXICOB.MX','MX','20Y',NULL UNION   
  SELECT 058,'SWP','TI',10920,'MXP370841019','GMEXICOB.MX','MX','30Y',NULL  
    
  INSERT @tmp_tblCurvesNodes  
  SELECT 059,'SWP','TI',1,'MXP001691213','AMXL.MX','MX','ON',NULL UNION  
  SELECT 060,'SWP','TI',28,'MXP001691213','AMXL.MX','MX','1M',NULL UNION  
  SELECT 061,'SWP','TI',56,'MXP001691213','AMXL.MX','MX','2M',NULL UNION  
  SELECT 062,'SWP','TI',84,'MXP001691213','AMXL.MX','MX','3M',NULL UNION  
  SELECT 063,'SWP','TI',168,'MXP001691213','AMXL.MX','MX','6M',NULL UNION  
  SELECT 064,'SWP','TI',364,'MXP001691213','AMXL.MX','MX','1Y',NULL UNION  
  SELECT 065,'SWP','TI',728,'MXP001691213','AMXL.MX','MX','2Y',NULL UNION  
  SELECT 066,'SWP','TI',1090,'MXP001691213','AMXL.MX','MX','3Y',NULL UNION  
  SELECT 067,'SWP','TI',1456,'MXP001691213','AMXL.MX','MX','4Y',NULL UNION  
  SELECT 068,'SWP','TI',1820,'MXP001691213','AMXL.MX','MX','5Y',NULL UNION  
  SELECT 069,'SWP','TI',2548,'MXP001691213','AMXL.MX','MX','7Y',NULL UNION  
  SELECT 070,'SWP','TI',3640,'MXP001691213','AMXL.MX','MX','10Y',NULL UNION  
  SELECT 071,'SWP','TI',7280,'MXP001691213','AMXL.MX','MX','20Y',NULL UNION  
  SELECT 072,'SWP','TI',10920,'MXP001691213','AMXL.MX','MX','30Y',NULL  
  
  INSERT @tmp_tblCurvesNodes  
  SELECT 073,'LIB','YLD',1,'','.SPX','USD','ON  ',NULL UNION  
  SELECT 074,'LIB','YLD',30,'','.SPX','USD','1M  ',NULL UNION  
  SELECT 075,'LIB','YLD',60,'','.SPX','USD','2M  ',NULL UNION  
  SELECT 076,'LIB','YLD',90,'','.SPX','USD','3M  ',NULL UNION  
  SELECT 077,'LIB','YLD',180,'','.SPX','USD','6M  ',NULL UNION  
  SELECT 078,'LIB','YLD',360,'','.SPX','USD','1Y  ',NULL UNION  
  SELECT 079,'LIB','YLD',720,'','.SPX','USD','2Y  ',NULL UNION  
  SELECT 080,'LIB','YLD',1080,'','.SPX','USD','3Y  ',NULL UNION  
  SELECT 081,'LIB','YLD',1440,'','.SPX','USD','4Y  ',NULL UNION  
  SELECT 082,'LIB','YLD',1800,'','.SPX','USD','5Y  ',NULL UNION  
  SELECT 083,'LIB','YLD',2520,'','.SPX','USD','7Y  ',NULL UNION  
  SELECT 084,'LIB','YLD',3600,'','.SPX','USD','10Y ',NULL UNION  
  SELECT 085,'LIB','YLD',7200,'','.SPX','USD','20Y ',NULL UNION  
  SELECT 086,'LIB','YLD',10800,'','.SPX','USD','30Y ',NULL  
    
  INSERT @tmp_tblCurvesNodes    
  SELECT 087,'LIB','YLD',1,'US0378331005','AAPL.OQ','USD','ON  ',NULL UNION  
  SELECT 088,'LIB','YLD',30,'US0378331005','AAPL.OQ','USD','1M  ',NULL UNION  
  SELECT 089,'LIB','YLD',60,'US0378331005','AAPL.OQ','USD','2M  ',NULL UNION  
  SELECT 090,'LIB','YLD',90,'US0378331005','AAPL.OQ','USD','3M  ',NULL UNION  
  SELECT 091,'LIB','YLD',180,'US0378331005','AAPL.OQ','USD','6M  ',NULL UNION  
  SELECT 092,'LIB','YLD',360,'US0378331005','AAPL.OQ','USD','1Y  ',NULL UNION  
  SELECT 093,'LIB','YLD',720,'US0378331005','AAPL.OQ','USD','2Y  ',NULL UNION  
  SELECT 094,'LIB','YLD',1080,'US0378331005','AAPL.OQ','USD','3Y  ',NULL UNION  
  SELECT 095,'LIB','YLD',1440,'US0378331005','AAPL.OQ','USD','4Y  ',NULL UNION  
  SELECT 096,'LIB','YLD',1800,'US0378331005','AAPL.OQ','USD','5Y  ',NULL UNION  
  SELECT 097,'LIB','YLD',2520,'US0378331005','AAPL.OQ','USD','7Y  ',NULL UNION  
  SELECT 098,'LIB','YLD',3600,'US0378331005','AAPL.OQ','USD','10Y ',NULL UNION  
  SELECT 099,'LIB','YLD',7200,'US0378331005','AAPL.OQ','USD','20Y ',NULL UNION  
  SELECT 100,'LIB','YLD',10800,'US0378331005','AAPL.OQ','USD','30Y ',NULL  
    
  INSERT @tmp_tblCurvesNodes  
  SELECT 101,'LIB','YLD',1,'US4642868487','EWJ.P','USD','ON  ',NULL UNION  
  SELECT 102,'LIB','YLD',30,'US4642868487','EWJ.P','USD','1M  ',NULL UNION  
  SELECT 103,'LIB','YLD',60,'US4642868487','EWJ.P','USD','2M  ',NULL UNION  
  SELECT 104,'LIB','YLD',90,'US4642868487','EWJ.P','USD','3M  ',NULL UNION  
  SELECT 105,'LIB','YLD',180,'US4642868487','EWJ.P','USD','6M  ',NULL UNION  
  SELECT 106,'LIB','YLD',360,'US4642868487','EWJ.P','USD','1Y  ',NULL UNION  
  SELECT 107,'LIB','YLD',720,'US4642868487','EWJ.P','USD','2Y  ',NULL UNION  
  SELECT 108,'LIB','YLD',1080,'US4642868487','EWJ.P','USD','3Y  ',NULL UNION  
  SELECT 109,'LIB','YLD',1440,'US4642868487','EWJ.P','USD','4Y  ',NULL UNION  
  SELECT 110,'LIB','YLD',1800,'US4642868487','EWJ.P','USD','5Y  ',NULL UNION  
  SELECT 111,'LIB','YLD',2520,'US4642868487','EWJ.P','USD','7Y  ',NULL UNION  
  SELECT 112,'LIB','YLD',3600,'US4642868487','EWJ.P','USD','10Y ',NULL UNION  
  SELECT 113,'LIB','YLD',7200,'US4642868487','EWJ.P','USD','20Y ',NULL UNION  
  SELECT 114,'LIB','YLD',10800,'US4642868487','EWJ.P','USD','30Y ',NULL  
  
  INSERT @tmp_tblCurvesNodes    
  SELECT 115,'LIB','YLD',1,'','.NDX','USD','ON  ',NULL UNION  
  SELECT 116,'LIB','YLD',30,'','.NDX','USD','1M  ',NULL UNION  
  SELECT 117,'LIB','YLD',60,'','.NDX','USD','2M  ',NULL UNION  
  SELECT 118,'LIB','YLD',90,'','.NDX','USD','3M  ',NULL UNION  
  SELECT 119,'LIB','YLD',180,'','.NDX','USD','6M  ',NULL UNION  
  SELECT 120,'LIB','YLD',360,'','.NDX','USD','1Y  ',NULL UNION  
  SELECT 121,'LIB','YLD',720,'','.NDX','USD','2Y  ',NULL UNION  
  SELECT 122,'LIB','YLD',1080,'','.NDX','USD','3Y  ',NULL UNION  
  SELECT 123,'LIB','YLD',1440,'','.NDX','USD','4Y  ',NULL UNION  
  SELECT 124,'LIB','YLD',1800,'','.NDX','USD','5Y  ',NULL UNION  
  SELECT 125,'LIB','YLD',2520,'','.NDX','USD','7Y  ',NULL UNION  
  SELECT 126,'LIB','YLD',3600,'','.NDX','USD','10Y ',NULL UNION  
  SELECT 127,'LIB','YLD',7200,'','.NDX','USD','20Y ',NULL UNION  
  SELECT 128,'LIB','YLD',10800,'','.NDX','USD','30Y ',NULL  
    
  INSERT @tmp_tblCurvesNodes    
  SELECT 129,'LIB','YLD',1,'US81369Y6059','XLF.P','USD','ON  ',NULL UNION  
  SELECT 130,'LIB','YLD',30,'US81369Y6059','XLF.P','USD','1M  ',NULL UNION  
  SELECT 131,'LIB','YLD',60,'US81369Y6059','XLF.P','USD','2M  ',NULL UNION  
  SELECT 132,'LIB','YLD',90,'US81369Y6059','XLF.P','USD','3M  ',NULL UNION  
  SELECT 133,'LIB','YLD',180,'US81369Y6059','XLF.P','USD','6M  ',NULL UNION  
  SELECT 134,'LIB','YLD',360,'US81369Y6059','XLF.P','USD','1Y  ',NULL UNION  
  SELECT 135,'LIB','YLD',720,'US81369Y6059','XLF.P','USD','2Y  ',NULL UNION  
  SELECT 136,'LIB','YLD',1080,'US81369Y6059','XLF.P','USD','3Y  ',NULL UNION  
  SELECT 137,'LIB','YLD',1440,'US81369Y6059','XLF.P','USD','4Y  ',NULL UNION  
  SELECT 138,'LIB','YLD',1800,'US81369Y6059','XLF.P','USD','5Y  ',NULL UNION  
  SELECT 139,'LIB','YLD',2520,'US81369Y6059','XLF.P','USD','7Y  ',NULL UNION  
  SELECT 140,'LIB','YLD',3600,'US81369Y6059','XLF.P','USD','10Y ',NULL UNION  
  SELECT 141,'LIB','YLD',7200,'US81369Y6059','XLF.P','USD','20Y ',NULL UNION  
  SELECT 142,'LIB','YLD',10800,'US81369Y6059','XLF.P','USD','30Y ',NULL  
    
  INSERT @tmp_tblCurvesNodes  
  SELECT 143,'LIB','YLD',1,'US4642876142','IWM.P','USD','ON  ',NULL UNION  
  SELECT 144,'LIB','YLD',30,'US4642876142','IWM.P','USD','1M  ',NULL UNION  
  SELECT 145,'LIB','YLD',60,'US4642876142','IWM.P','USD','2M  ',NULL UNION  
  SELECT 146,'LIB','YLD',90,'US4642876142','IWM.P','USD','3M  ',NULL UNION  
  SELECT 147,'LIB','YLD',180,'US4642876142','IWM.P','USD','6M  ',NULL UNION  
  SELECT 148,'LIB','YLD',360,'US4642876142','IWM.P','USD','1Y  ',NULL UNION  
  SELECT 149,'LIB','YLD',720,'US4642876142','IWM.P','USD','2Y  ',NULL UNION  
  SELECT 150,'LIB','YLD',1080,'US4642876142','IWM.P','USD','3Y  ',NULL UNION  
  SELECT 151,'LIB','YLD',1440,'US4642876142','IWM.P','USD','4Y  ',NULL UNION  
  SELECT 152,'LIB','YLD',1800,'US4642876142','IWM.P','USD','5Y  ',NULL UNION  
  SELECT 153,'LIB','YLD',2520,'US4642876142','IWM.P','USD','7Y  ',NULL UNION  
  SELECT 154,'LIB','YLD',3600,'US4642876142','IWM.P','USD','10Y ',NULL UNION  
  SELECT 155,'LIB','YLD',7200,'US4642876142','IWM.P','USD','20Y ',NULL UNION  
  SELECT 156,'LIB','YLD',10800,'US4642876142','IWM.P','USD','30Y ',NULL  
  
  INSERT @tmp_tblCurvesNodes  
  SELECT 157,'SWP','TI',1,'MXP225611567','CMXCPO.MX','MX','ON',NULL UNION  
  SELECT 158,'SWP','TI',28,'MXP225611567','CMXCPO.MX','MX','1M',NULL UNION  
  SELECT 159,'SWP','TI',56,'MXP225611567','CMXCPO.MX','MX','2M',NULL UNION  
  SELECT 160,'SWP','TI',84,'MXP225611567','CMXCPO.MX','MX','3M',NULL UNION  
  SELECT 161,'SWP','TI',168,'MXP225611567','CMXCPO.MX','MX','6M',NULL UNION  
  SELECT 162,'SWP','TI',364,'MXP225611567','CMXCPO.MX','MX','1Y',NULL UNION  
  SELECT 163,'SWP','TI',728,'MXP225611567','CMXCPO.MX','MX','2Y',NULL UNION  
  SELECT 164,'SWP','TI',1090,'MXP225611567','CMXCPO.MX','MX','3Y',NULL UNION  
  SELECT 165,'SWP','TI',1456,'MXP225611567','CMXCPO.MX','MX','4Y',NULL UNION  
  SELECT 166,'SWP','TI',1820,'MXP225611567','CMXCPO.MX','MX','5Y',NULL UNION  
  SELECT 167,'SWP','TI',2548,'MXP225611567','CMXCPO.MX','MX','7Y',NULL UNION  
  SELECT 168,'SWP','TI',3640,'MXP225611567','CMXCPO.MX','MX','10Y',NULL UNION  
  SELECT 169,'SWP','TI',7280,'MXP225611567','CMXCPO.MX','MX','20Y',NULL UNION  
  SELECT 170,'SWP','TI',10920,'MXP225611567','CMXCPO.MX','MX','30Y',NULL  
    
 -- Obtengo los valores de los FRPiP   
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(txtType),RTRIM(txtSubType),intNode,'0')*100,9,6))   
 FROM @tmp_tblCurvesNodes   
    
 -- Repoto los encabezados  
 INSERT @tblResult  
  SELECT  
   000,  
   'ISIN'  + ',' +  
   'RIC'  + ',' +  
   'id_ccy_std'  + ',' +  
   'id_prd_mat'  + ',' +  
   'rt_int'  
  
 -- Reporto el Vector  
 INSERT @tblResult   
  SELECT   
  intSection,  
  RTRIM(txtISIN) + ',' +  
  RTRIM(txtRIC) + ',' +   
  RTRIM(txtid_ccy_std) + ',' +  
  RTRIM(txtid_prd_mat) + ',' +   
  RTRIM(dblrt_int)  
 FROM @tmp_tblCurvesNodes   
      
 -- Valida que la informacin este completa   
    
 IF EXISTS(  
   SELECT TOP 1 *   
   FROM @tblResult   
   WHERE txtData LIKE '%-9990%'  
   )   
    
 BEGIN   
 RAISERROR ('ERROR: Falta Informacion', 16, 1)   
 END   
    
 ELSE   
 -- Reporto los datos   
 SELECT RTRIM(txtData)   
 FROM @tblResult   
 ORDER BY intSection   
    
 SET NOCOUNT OFF   
   
END  
  
  
--------------------------------------------------------------------------  
--   Modificado por: Mike Ramirez  
--   Modificacion:  2013-11-01  
--   Descripcion:     Modificacion Modulo 35: Se agrega el RIC CMXCPO.MX  
--------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;35  
 @txtDate AS DATETIME   
  
AS   
BEGIN  
  
  SET NOCOUNT ON  
   
 DECLARE @dblSPY FLOAT  
 DECLARE @dblMEXBOL FLOAT  
 DECLARE @dblEWZ FLOAT  
 DECLARE @dblNDX FLOAT  
   
 -- genera tabla temporal de resultados   
 DECLARE @tblResult TABLE (   
 [intSection][INTEGER],   
 [txtData][VARCHAR](8000)   
 )   
   
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)   
 DECLARE @tmp_tblCurvesNodes TABLE (   
  [intSection][INTEGER],   
  [txtIRC] CHAR(11),   
  [txtISIN] CHAR(30),   
  [txtRIC] CHAR(30),   
  [txtid_ccy_std] CHAR(3),  
  [dblrt_int] VARCHAR(50),  
  [price_type] CHAR(4)  
 PRIMARY KEY(intSection,txtIRC)   
 )   
  
 -- Nodos de Curvas (FRPiP)   
 INSERT @tmp_tblCurvesNodes  
  SELECT 001,'SPY','US78462F1030','SPY.p','USD',NULL,'CLOS' UNION  
  SELECT 002,'MEXBOL','','.MXX','MXN',NULL,'CLOS' UNION  
  SELECT 003,'EWZ','US4642864007','EWZso.p','USD',NULL,'CLOS' UNION  
  SELECT 004,'MAJS0000001','MXP370841019','GMEXICOB.MX','MXN',NULL,'CLOS' UNION  
  SELECT 005,'MCXI0000002','MXP001691213','AMXL.MX','MXN',NULL,'CLOS' UNION  
  SELECT 006,'SPX','','.SPX','USD',NULL,'CLOS' UNION  
  SELECT 007,'MEPU0000001','US0378331005','AAPL.OQ','USD',NULL,'CLOS' UNION  
  SELECT 008,'EWJ','US4642868487','EWJ.P','USD',NULL,'CLOS' UNION  
  SELECT 009,'NDX','','.NDX','USD',NULL,'CLOS' UNION  
  SELECT 010,'XLF','US81369Y6059','XLF.P','USD',NULL,'CLOS' UNION  
  SELECT 011,'IWM','US4642876142','IWM.P','USD',NULL,'CLOS' UNION  
  SELECT 012,'MAAI0000003','MXP225611567','CMXCPO.MX','MXN',NULL,'CLOS'  
  
 -- Obtengo los valores de los FRPiP   
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'SPY' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'SPY') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'SPY'  
  
 UPDATE @tmp_tblCurvesNodes  
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'MEXBOL' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'MEXBOL') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'MEXBOL'  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'EWZ' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'EWZ') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'EWZ'  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'SPX' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'SPX') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'SPX'  
    
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(txtPRL_MO,9,6)  
       FROM MxFixincome.dbo.tmp_tblunifiedpricesreport (NOLOCK)  
       WHERE txtId1 = 'MAJS0000001' AND txtLiquidation = 'MP' )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'MAJS0000001'  
   
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(txtPRL_MO,9,6)  
       FROM MxFixincome.dbo.tmp_tblunifiedpricesreport (NOLOCK)  
       WHERE txtId1 = 'MCXI0000002' AND txtLiquidation = 'MP' )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'MCXI0000002'  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(txtPRL_MO,9,6)  
       FROM MxFixincome.dbo.tmp_tblunifiedpricesreport (NOLOCK)  
       WHERE txtId1 = 'MEPU0000001' AND txtLiquidation = 'MP' )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'MEPU0000001'  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'EWJ' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'EWJ') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'EWJ'  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'NDX' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'NDX') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'NDX'  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'XLF' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'XLF') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'XLF'  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(dblValue,9,6)  
      FROM MxFixincome.dbo.tblIRC (NOLOCK)  
      WHERE txtIRC = 'IWM' AND dteDate = (SELECT MAX(dteDate)  
              FROM MxFixincome.dbo.tblIRC (NOLOCK)  
              WHERE txtIRC = 'IWM') )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'IWM'  
  
  
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = ( SELECT STR(txtPRL_MO,9,6)  
       FROM MxFixincome.dbo.tmp_tblunifiedpricesreport (NOLOCK)  
       WHERE txtId1 = 'MAAI0000003' AND txtLiquidation = 'MP' )  
 FROM @tmp_tblCurvesNodes  
 WHERE txtIRC = 'MAAI0000003'  
  
 -- Repoto los encabezados  
 INSERT @tblResult  
  SELECT  
   000,  
   'ISIN'  + ',' +  
   'RIC'  + ',' +  
   'id_ccy_std' + ',' +  
   'rt_int' + ',' +  
   'price_type'   
   
 -- Reporto el Vector  
 INSERT @tblResult   
  SELECT   
  intSection,  
  RTRIM(txtISIN) + ',' +  
  RTRIM(txtRIC) + ',' +   
  RTRIM(txtid_ccy_std) + ',' +  
  RTRIM(dblrt_int) + ',' +  
  RTRIM(price_type)  
 FROM @tmp_tblCurvesNodes  
  
 -- Valida que la informacin este completa  
 IF EXISTS(   
   SELECT TOP 1 txtData   
   FROM @tblResult  
   WHERE txtData IS NULL  
 )  
   
 BEGIN   
  RAISERROR ('ERROR: Falta Informacion', 16, 1)   
 END   
  
 ELSE  
 -- Reporto los datos   
  SELECT RTRIM(txtData)   
  FROM @tblResult   
  ORDER BY intSection   
    
 SET NOCOUNT OFF   
  
END  
------------------------------------------------------------------------------------  
--   Modificado por: Mike Ramirez  
--   Modificacion:  09:46 a.m. 2012-03-16  
--   Descripcion:     Modificacion Modulo 36: Modificar las curvas que se reportan,   
--      se elminina (TSN/YLD), se agrega (LIB/LB) y (LUS/SWP)  
-------------------------------------------------------------------------------------    
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;36  
@txtDate AS DATETIME   
   
AS   
BEGIN   
   
 SET NOCOUNT ON   
  
 -- genera tabla temporal de resultados   
 DECLARE @tblResult TABLE (   
 [intSection][INTEGER],   
 [txtData][VARCHAR](8000)   
 )   
    
 -- creo tabla temporal de los principales Nodos de Curvas (FRPiP)   
 DECLARE @tmp_tblCurvesNodes TABLE (   
  [intSection][INTEGER],   
  [txtType] CHAR(3),   
  [txtSubType] CHAR(3),   
  [intNode] INT,   
  [txtid_ccy_std] CHAR(3),  
  [txtid_prd_mat] CHAR(3),  
  [dblrt_int] VARCHAR(50)  
 PRIMARY KEY(intSection,txtType,txtSubType,intNode)   
 )   
  
 -- Nodos de Curvas (FRPiP) Libor  
 INSERT @tmp_tblCurvesNodes  
  SELECT 001,'LIB','LB',1,'USD','ON',NULL UNION   
  SELECT 002,'LIB','LB',7,'USD','1W',NULL UNION   
  SELECT 003,'LIB','LB',14,'USD','2W',NULL UNION   
  SELECT 004,'LIB','LB',28,'USD','1M',NULL UNION   
  SELECT 005,'LIB','LB',60,'USD','2M',NULL UNION   
  SELECT 006,'LIB','LB',91,'USD','3M',NULL UNION   
  SELECT 007,'LIB','LB',120,'USD','4M',NULL UNION   
  SELECT 008,'LIB','LB',150,'USD','5M',NULL UNION   
  SELECT 009,'LIB','LB',180,'USD','6M',NULL UNION   
  SELECT 010,'LIB','LB',270,'USD','9M',NULL UNION   
  SELECT 011,'LIB','LB',365,'USD','1Y',NULL  
  
 -- Nodos de Curvas (FRPiP) Libor Swap  
 INSERT @tmp_tblCurvesNodes  
  SELECT 012,'LUS','SWP',546,'USD','18M',NULL UNION   
  SELECT 013,'LUS','SWP',728,'USD','2Y',NULL UNION   
  SELECT 014,'LUS','SWP',1092,'USD','3Y',NULL UNION   
  SELECT 015,'LUS','SWP',1456,'USD','4Y',NULL UNION   
  SELECT 016,'LUS','SWP',1820,'USD','5Y',NULL UNION   
  SELECT 017,'LUS','SWP',2184,'USD','6Y',NULL UNION   
  SELECT 018,'LUS','SWP',2548,'USD','7Y',NULL UNION   
  SELECT 019,'LUS','SWP',2912,'USD','8Y',NULL UNION   
  SELECT 020,'LUS','SWP',3276,'USD','9Y',NULL UNION   
  SELECT 021,'LUS','SWP',3640,'USD','10Y',NULL UNION  
  SELECT 022,'LUS','SWP',4368,'USD','12Y',NULL UNION   
  SELECT 023,'LUS','SWP',5460,'USD','15Y',NULL UNION   
  SELECT 024,'LUS','SWP',7280,'USD','20Y',NULL UNION  
  SELECT 025,'LUS','SWP',10920,'USD','30Y',NULL  
  
 INSERT @tmp_tblCurvesNodes  
  SELECT 026,'SWP','TI',1,'MXN','ON',NULL UNION   
  SELECT 027,'TIE','SWP',28,'MXN','1M',NULL UNION   
  SELECT 028,'TIE','SWP',56,'MXN','2M',NULL UNION   
  SELECT 029,'TIE','SWP',84,'MXN','3M',NULL UNION   
  SELECT 030,'TIE','SWP',168,'MXN','6M',NULL UNION   
  SELECT 031,'TIE','SWP',364,'MXN','1Y',NULL UNION   
  SELECT 032,'TIE','SWP',728,'MXN','2Y',NULL UNION   
  SELECT 033,'TIE','SWP',1092,'MXN','3Y',NULL UNION   
  SELECT 034,'TIE','SWP',1456,'MXN','4Y',NULL UNION   
  SELECT 035,'TIE','SWP',1820,'MXN','5Y',NULL UNION   
  SELECT 036,'TIE','SWP',2548,'MXN','7Y',NULL UNION   
  SELECT 037,'TIE','SWP',3640,'MXN','10Y',NULL UNION   
  SELECT 038,'TIE','SWP',7280,'MXN','20Y',NULL UNION   
  SELECT 039,'TIE','SWP',10920,'MXN','30Y',NULL  
  
 -- Obtengo los valores de los FRPiP   
 UPDATE @tmp_tblCurvesNodes   
 SET dblrt_int = (SELECT STR(MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),RTRIM(txtType),RTRIM(txtSubType),intNode,'0')*100,9,6))   
 FROM @tmp_tblCurvesNodes   
  
 -- Repoto los encabezados  
 INSERT @tblResult  
  SELECT  
   000,  
   'id_ccy_std'  + ',' +  
   'id_prd_mat'  + ',' +  
   'rt_int'  
  
 -- Reporto el Vector  
 INSERT @tblResult  
  SELECT  
  intSection,  
  RTRIM(txtid_ccy_std) + ',' +  
  RTRIM(txtid_prd_mat) + ',' +  
  RTRIM(dblrt_int)  
 FROM @tmp_tblCurvesNodes  
      
 -- Valida que la informacin este completa  
    
 IF EXISTS(  
   SELECT TOP 1 *  
   FROM @tblResult  
   WHERE txtData LIKE '%-9990%'  
   )  
    
  BEGIN  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  END  
    
 ELSE  
  -- Reporto los datos   
  SELECT RTRIM(txtData)  
  FROM @tblResult  
  ORDER BY intSection  
    
 SET NOCOUNT OFF  
   
END  
  
------------------------------------------------------------  
--   Creado por: Mike Ramirez  
--   Modificacion:  12:38 2013-11-01  
--   Descripcion: Modulo 37: Se agrega la Sabana CMXCPO.MX  
------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;37  
 @txtDate DATETIME      
AS           
BEGIN          
      
 SET NOCOUNT ON  
  
 DECLARE @tblDirectives TABLE (  
   intSection INT,  
   txtSource CHAR(20),  
   txtType CHAR(8),  
   txtSubType CHAR(4),  
   txtISIN CHAR(30),  
   txtRIC CHAR(30),  
   txtCurrency CHAR(30),  
   txtIdentifier CHAR(30)  
    PRIMARY KEY (intSection)  
 )  
  
 -- Configuración de Directivas Sabanas  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 001, 'SURFACES', 'VOLC','SPY','US78462F1030','SPY.p','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 002, 'SURFACES', 'VOLP','SPY','US78462F1030','SPY.p','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 003, 'SURFACES', 'VOLC','MBOL','','.MXX','MXN','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 004, 'SURFACES', 'VOLP','MBOL','','.MXX','MXN','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 005, 'SURFACES', 'VOLC','EWZ','US4642864007','EWZso.P','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 006, 'SURFACES', 'VOLP','EWZ','US4642864007','EWZso.P','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 007, 'SURFACES', 'VOLC','GMEX','MXP370841019','GMEXICOB.MX','MXN','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 008, 'SURFACES', 'VOLP','GMEX','MXP370841019','GMEXICOB.MX','MXN','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 009, 'SURFACES', 'VOLC','AMX','MXP001691213','AMXL.MX','MXN','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 010, 'SURFACES', 'VOLP','AMX','MXP001691213','AMXL.MX','MXN','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 011, 'SURFACES', 'VOLC','SPX','','.SPX','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 012, 'SURFACES', 'VOLP','SPX','','.SPX','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 013, 'SURFACES', 'VOLC','AAPL','US0378331005','AAPL.OQ','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 014, 'SURFACES', 'VOLP','AAPL','US0378331005','AAPL.OQ','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 015, 'SURFACES', 'VOLC','EWJ','US4642868487','EWJ.P','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 016, 'SURFACES', 'VOLP','EWJ','US4642868487','EWJ.P','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 017, 'SURFACES', 'VOLC','NDX','','.NDX','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 018, 'SURFACES', 'VOLP','NDX','','.NDX','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 019, 'SURFACES', 'VOLC','XLF','US81369Y6059','XLF.P','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 020, 'SURFACES', 'VOLP','XLF','US81369Y6059','XLF.P','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 021, 'SURFACES', 'VOLC','IWM','US4642876142','IWM.P','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 022, 'SURFACES', 'VOLP','IWM','US4642876142','IWM.P','USD','PUT'  
  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 023, 'SURFACES', 'VOLC','CX','MXP225611567','CMXCPO.MX','USD','CALL'  
 INSERT @tblDirectives(intSection, txtSource, txtType, txtSubType, txtISIN,txtRIC,txtCurrency,txtIdentifier)  
  SELECT 024, 'SURFACES', 'VOLP','CX','MXP225611567','CMXCPO.MX','USD','PUT'  
  
 -- Agregar candado para no generación de producto posterior al 27-Junio-2015  
 IF @txtDate >= '20150727'  
 BEGIN   
  RAISERROR ('ERROR: Validar con el cliente (Candado de generación)', 16, 1)   
 END   
  ELSE  
    -- regreso las directivas  
    SELECT   
    LTRIM(STR(intSection)) AS txtSection,  
    txtSource,  
    txtType,  
    txtSubType,  
    RTRIM(txtISIN) AS txtISIN,  
    RTRIM(txtRIC) AS txtRIC,  
    RTRIM(txtCurrency) AS txtCurrency,  
    RTRIM(txtIdentifier) AS txtIdentifier  
    FROM @tblDirectives  
    ORDER BY   
    intSection  
  
  SET NOCOUNT OFF  
  
END  
-------------------------------------------------------------------------  
-- Autor: Mike Ramirez  
-- Fecha Creacion: 01:24 p.m. 2012-04-20  
-- Descripcion: Modulo 38: Genera el producto JPMorgan_WMR_[yyyymmdd].txt   
-- que reporta el tipo de cambio WMR de Reuters  
-------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;38  
  @txtDate AS VARCHAR(10)  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 -- Creo tabla temporal de Resultados  
 DECLARE @tmp_tblResults TABLE (  
  intRow INT,  
  txtDate VARCHAR(100)  
  PRIMARY KEY(intRow)  
 )  
  
 INSERT @tmp_tblResults (intRow,txtDate)  
 SELECT   
  1,  
  @txtDate + CHAR(9) +  
  LTRIM(txtIrc) + CHAR(9) +  
  LTRIM(STR(ROUND(i.dblValue,6),14,6))  
  AS [txtDate]  
  
 FROM   
  MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
 WHERE  
    i.dteDate = @txtDate  
    AND i.txtIRC = 'MXUSWM'  
  
 -- Validar archivo  
 -- Valida la información   
 IF EXISTS (  
  SELECT TOP 1 *   
  FROM @tmp_tblResults  
    )  
 BEGIN  
  SELECT RTRIM(txtDate)   
  FROM @tmp_tblResults   
  ORDER BY intRow  
 END  
 ELSE  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
 SET NOCOUNT OFF  
  
END  
----------------------------------------------------------------------------------  
-- Autor:   Mike Ramirez  
-- Fecha Creacion: 10:15 p.m. 2012-08-14  
-- Descripcion:  Modulo 39: Genera el producto JPM_CURVA_EURMXN_[yyyymmdd].XLS   
----------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;39  
  @txtDate AS VARCHAR(10)  
AS   
BEGIN  
  
  
 SET NOCOUNT ON  
  
 DECLARE @tmpLayoutxlCurve TABLE (  
  SheetName CHAR(50),  
  Col INT,  
  Header CHAR(50),  
        Source CHAR(20),  
        Type CHAR(3),  
  SubType CHAR(3),  
  Range CHAR(15),  
  Factor CHAR(5),  
  DataType CHAR(3),   
  DataFormat CHAR(20),  
  fLoad CHAR(1),  
 PRIMARY KEY (Col)  
 )   
  
 -- <Sheet1> = Sheet1  
 INSERT @tmpLayoutxlCurve   
  SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'Cross Currency Swap Tiie/Euribor'  AS [Header],'CURVES' AS [Source],'ETS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [DataFormat],'1' AS
 [fLoad]  
   
 SELECT  
  RTRIM(SheetName) AS [SheetName],  
  Col AS [Col],  
  RTRIM(Header) AS [Header],  
        RTRIM(Source) AS [Source],  
        RTRIM(Type) AS [Type],  
  RTRIM(SubType) AS [SubType],  
  RTRIM(Range) AS [Range],  
  RTRIM(Factor) AS [Factor],  
  RTRIM(DataType) AS [DataType],   
  RTRIM(DataFormat) AS [DataFormat],  
  RTRIM(fLoad) AS [fLoad]  
 FROM @tmpLayoutxlCurve  
 WHERE Col > 0  
 ORDER BY Col  
  
 SET NOCOUNT OFF  
  
END  
  
/*  
-----------------------------------------------------------------------------------------------  
-- Modificado por:    Mike Ramírez    
-- Fecha Modificacion:   13:05 2013-02-12   
-- Descripcion Modulo 40:  Sp que genera el producto JPM_CURVA_GBPMX_[YYYYMMDD].TXT  
-----------------------------------------------------------------------------------------------  
-- Modificado por:    OMAR ADRIAN ACEVES GUTIERREZ  
-- Fecha Modificacion:   2014-06-04 12:49:54.493  
-- Descripcion Modulo 40:  se cambian valores originales (type:'EUR',SUBTYPE:'EUR')  
*/  
  
CREATE  PROCEDURE [dbo].[sp_productos_JPMORGAN];40  
 @txtDate AS DATETIME  
  
AS  
 BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tmpLayoutxlCurve TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
   SELECT   
    1,   
    'Fecha' + CHAR(9) + 'Plazo' + CHAR(9) + 'EURIBOR'  
      
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
  SELECT  
   2,  
   CONVERT(CHAR(10),@txtDate,103) + CHAR(9) +   
   LTRIM(intTerm) + CHAR(9) +  
   LTRIM(STR(dblRate,19,10))  
  FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
  WHERE dteDate = @txtDate   
   AND txtType = 'LIB'  
   AND txtSubtype = 'EUI'  
  --se cambian valores originales (type:'EUR',SUBTYPE:'EUR')  
   -- Valida la información   
 IF ((SELECT count(*) FROM @tmpLayoutxlCurve) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT txtData  
  FROM @tmpLayoutxlCurve  
  
  SET NOCOUNT OFF  
  
END  
  
------------------------------------------------------------------------------------  
-- Autor:   Mike Ramirez  
-- Fecha Creacion: 11:15 a.m. 2012-08-14  
-- Descripcion:  Modulo 41: Genera el producto JPM_CURVA_LIBOR-GBP_[yyyymmdd].XLS  
------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;41  
  @txtDate AS VARCHAR(10)  
AS   
BEGIN  
  
  
 SET NOCOUNT ON  
  
 DECLARE @tmpLayoutxlCurve TABLE (  
  SheetName CHAR(50),  
  Col INT,  
  Header CHAR(50),  
        Source CHAR(20),  
        Type CHAR(3),  
  SubType CHAR(3),  
  Range CHAR(15),  
  Factor CHAR(5),  
  DataType CHAR(3),   
  DataFormat CHAR(20),  
  fLoad CHAR(1),  
 PRIMARY KEY (Col)  
 )   
  
 -- <Sheet1> = Sheet1  
 INSERT @tmpLayoutxlCurve   
  SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'LIBOR GBP'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [DataFormat],'1' AS [fLoad]  
   
 SELECT  
  RTRIM(SheetName) AS [SheetName],  
  Col AS [Col],  
  RTRIM(Header) AS [Header],  
        RTRIM(Source) AS [Source],  
        RTRIM(Type) AS [Type],  
  RTRIM(SubType) AS [SubType],  
  RTRIM(Range) AS [Range],  
  RTRIM(Factor) AS [Factor],  
  RTRIM(DataType) AS [DataType],   
  RTRIM(DataFormat) AS [DataFormat],  
  RTRIM(fLoad) AS [fLoad]  
 FROM @tmpLayoutxlCurve  
 ORDER BY Col  
  
 SET NOCOUNT OFF  
  
END  
  
  
/*  
-------------------------------------------------------------  
-- Autor:    Mike Ramirez  
-- Fecha Modificacion: 11:30 2013-09-05  
-- Descripcion:   Modulo 42: Se agregan dos subyacentes  
-------------------------------------------------------------  
-------------------------------------------------------------  
-- modifico :    Omar Adrian Aceves Guttierrez  
-- Fecha Modificacion: 2014-03-20 11:57:00.030  
-- Descripcion:   Modulo 42: se agrega dos instrumentos MEPU0000001 y MAAI0000003   
           se elimina IRC NDX,se agrega case para PRICES  
-------------------------------------------------------------  
*/  
  
  
CREATE  PROCEDURE [dbo].[sp_productos_JPMORGAN];42  
-- DECLARE  
 @txtDate AS DATETIME   
 --SET @txtDate= '20140319'  
  
AS   
BEGIN  
  
  SET NOCOUNT ON  
  
 DECLARE @dblSumAvg As FLOAT  
  
 -- Creo tabla para presentar el Vector  
 DECLARE @tmp_tblVector TABLE (  
  [intConsecutive][INT],  
  [txtData][VARCHAR](8000)  
 PRIMARY KEY (intConsecutive))  
  
 -- Creo tabla para agrupar las directivas  
 DECLARE @tmp_tblDirectives TABLE (  
  [intConsecutive][INT],  
  [txtCode][VARCHAR](6),      
  [txtID1][VARCHAR](11),  
  [txtType][CHAR](3),  
  [txtSubtype][CHAR](3),  
  [txtISIN][VARCHAR](12),  
  [txtIRC][VARCHAR](11),  
  [txtCurrency][VARCHAR](6),  
  [txtConstituent][VARCHAR](60),  
  [txtDivRate][VARCHAR](60),  
  [txtIndexPoint][VARCHAR](60)  
 PRIMARY KEY (intConsecutive,txtID1) )  
  
 -- Creo tabla obtener el universo de los indices  
 DECLARE @tmp_tblIndexesUniv TABLE (  
  [txtID1][VARCHAR](11),      
  [dblPond][FLOAT]  
 PRIMARY KEY (txtID1) )  
   
 -- Inserto las directivas  
 INSERT @tmp_tblDirectives (intConsecutive,txtCode,txtID1,txtType,txtSubtype,txtISIN,txtIRC,txtCurrency,txtConstituent,txtDivRate,txtIndexPoint)  
  SELECT 1,'IRC','SPY','','','US78462F1030','SPY.p','USD','',NULL,NULL UNION  
  SELECT 2,'IRC','EWZ','','','US4642864007','EWZso.p','USD','',NULL,NULL UNION  
  SELECT 3,'PRICES','MAJS0000001','DIV','GMX','','.MXX','','GRUPO MEXICO S.A.B. DE C.V',NULL,NULL UNION  
  SELECT 4,'PRICES','MAAN0000004','DIV','WLM','','.MXX','','WAL-MART DE MEXICO S.A.B. DE C.V.',NULL,NULL UNION  
  SELECT 5,'PRICES','MABD0000001','DIV','ALF','','.MXX','','ALFA S.A.B. DE C.V.',NULL,NULL UNION  
  SELECT 6,'PRICES','MAHH0000002','DIV','TLV','','.MXX','','GRUPO TELEVISA S.A. DE C.V.',NULL,NULL UNION  
  SELECT 7,'PRICES','MAAY0000002','DIV','FMS','','.MXX','','FOMENTO ECONOMICO MEXICANO S. A. B. DE C. V.',NULL,NULL UNION  
  SELECT 8,'PRICES','MABC0000003','DIV','MXC','','.MXX','','MEXICHEM S.A.B DE C.V.',NULL,NULL UNION  
  SELECT 9,'PRICES','MCXI0000002','DIV','AMX','','.MXX','','AMERICA MOVIL S.A.B. DE C.V.',NULL,NULL UNION  
  SELECT 10,'IRC','EWJ','','','US464286848','EWJ.p','USD','',NULL,NULL UNION  
  --eliminado--SELECT 11,'IRCD','NDX','','','','.NDX','USD','NASDAQ 100 STOCK INDX',NULL,NULL UNION  
  SELECT 11,'IRCD','XLF','','','','XLF.P','USD','',NULL,NULL UNION  
  SELECT 12,'IRC','IWM','','','','IWM.P','USD','',NULL,NULL UNION  
  SELECT 13,'PRICES','MAJS0000001','DIV','GMX','MXP370841019','GMEXICOB.MX','MXN','GRUPO MEXICO S.A.B. DE C.V',NULL,NULL UNION   
  SELECT 14,'PRICES','MEPU0000001','','','US0378331005','.AAPL','USD','',NULL,NULL UNION  
  SELECT 15,'PRICES','MAAI0000003','','','MXP225611567','CMXCPO.MX','MXN','CEMENTOS MEXICANOS S.A. DE C.V.',NULL,NULL   
    
  
    
   
  -- Obtengo los Dividendos para los IRC  
  UPDATE d SET txtDivRate = STR(ROUND(ia.txtValue,6),17,6)  
  FROM @tmp_tblDirectives AS d  
   INNER JOIN MxFixIncome.dbo.tblircadd AS ia (NOLOCK)  
     ON d.txtID1 = ia.txtIRC  
  WHERE d.txtCode = 'IRC'   
   AND ia.dteDate = @txtDate  
   AND ia.txtItem = 'DIVIDP12M'  
  
  -- Obtengo los Dividendos para los IRC  
  UPDATE d SET txtDivRate = STR(ROUND(ia.txtValue,6),17,6)  
  FROM @tmp_tblDirectives AS d  
   INNER JOIN MxFixIncome.dbo.tblircadd AS ia (NOLOCK)  
     ON d.txtID1 = ia.txtIRC  
  WHERE d.txtCode = 'IRCD'   
   AND ia.dteDate = @txtDate  
   AND ia.txtItem = 'DIVIDEN'  
     
   
     
     
  
  -- Obtengo los Dividendos para los PRICES  
  UPDATE d SET txtDivRate =   
  (  
  CASE WHEN CONVERT (FLOAT ,STR(ROUND((SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),txtType,txtSubtype,1100,'0') * u.dblprl),6),17,6))  < 0.0 THEN '0'   
  ELSE STR(ROUND((SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@txtDate,112),txtType,txtSubtype,1100,'0') * u.dblprl),6),17,6) END   
  )  
    
  FROM @tmp_tblDirectives AS d  
   INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS u (NOLOCK)  
    ON d.txtId1 = u.txtId1  
  WHERE d.txtCode = 'PRICES'   
    
  
  
  -- Obtengo el Universo del indice MEXBOL  
  INSERT @tmp_tblIndexesUniv (txtID1,dblPond)  
   SELECT    
    p.txtId1,  
    (p.dblValue * ip.dblCount)   
   FROM MxFixIncome.dbo.tblindexesportfolios AS ip (NOLOCK)  
    INNER JOIN MxFixIncome.dbo.tblPrices AS p (NOLOCK)  
     ON ip.txtId1 = p.txtId1  
     AND ip.dteDate = p.dteDate  
   WHERE ip.txtIndex = 'MEXBOL'  
    AND ip.dteDate = @txtDate  
    AND p.txtItem = 'PAV'   
    AND p.txtLiquidation = 'MP'  
      
      
  
    
         
  
  -- Obtengo la suma del indice MEXBOL  
  SET @dblSumAvg = ( SELECT   
        SUM(dblPond)   
       FROM @tmp_tblIndexesUniv )  
  
   -- Obtengo los IndexPoint para los PRINCES  
  UPDATE d SET txtIndexPoint = STR(ROUND(((u.dblPond/@dblSumAvg) * 100),6),10,6)  
  FROM @tmp_tblDirectives AS d  
   INNER JOIN @tmp_tblIndexesUniv AS u  
    ON d.txtID1 = u.txtID1  
  WHERE d.txtCode = 'PRICES'  
  
  -- Agrego encabezados a la tabla Resultado  
  INSERT @tmp_tblVector (intConsecutive,txtData)  
   SELECT 0,'ISIN,RIC,Currency,Name of Constituent,Dividend Rate,Index Point,Ex Date,Record Date,Pay Date,Announced Date,Dividend Type,Announced/Forecast'  
  
  -- Consolido el vector y le damos formato  
  INSERT @tmp_tblVector (intConsecutive,txtData)  
   SELECT  
    intConsecutive,  
    LTRIM(txtISIN) + ',' +  
    LTRIM(txtIRC) + ',' +  
    LTRIM(txtCurrency) + ',' +  
    LTRIM(txtConstituent) + ',' +  
    CASE WHEN txtDivRate IS NULL THEN '' ELSE LTRIM(txtDivRate) END + ',' +  
    CASE WHEN txtIndexPoint IS NULL THEN '' ELSE LTRIM(txtIndexPoint) END + ',' +  
    CASE  
     WHEN txtCode = 'IRC' THEN CONVERT(CHAR(10),DATEADD(DAY, 364, @txtDate),101)  
     WHEN txtCode = 'IRCD' THEN CONVERT(CHAR(10),DATEADD(DAY, 364, @txtDate),101)    
     WHEN txtCode = 'PRICES' THEN CONVERT(CHAR(10),DATEADD(DAY, 1099, @txtDate),101)  
    ELSE '' END + ',' +  
    CASE  
     WHEN txtCode = 'IRC' THEN CONVERT(CHAR(10),DATEADD(DAY, 365, @txtDate),101)   
     WHEN txtCode = 'IRCD' THEN CONVERT(CHAR(10),DATEADD(DAY, 365, @txtDate),101)     
     WHEN txtCode = 'PRICES' THEN CONVERT(CHAR(10),DATEADD(DAY, 1100, @txtDate),101)  
    ELSE '' END + ',' +  
    CASE  
     WHEN txtCode = 'IRC' THEN CONVERT(CHAR(10),DATEADD(DAY, 365, @txtDate),101)  
     WHEN txtCode = 'IRCD' THEN CONVERT(CHAR(10),DATEADD(DAY, 365, @txtDate),101)      
     WHEN txtCode = 'PRICES' THEN CONVERT(CHAR(10),DATEADD(DAY, 1100, @txtDate),101)  
    ELSE '' END + ',' +  
    '' + ',' +  
    'Ordinary' + ',' +  
    'Forecasted'  
    FROM @tmp_tblDirectives AS d  
    ORDER BY d.intConsecutive   
  
  -- Valido Informacion  
  IF EXISTS ( SELECT TOP(1) *  
     FROM @tmp_tblIndexesUniv )  
  BEGIN  
   SELECT txtData  
   FROM @tmp_tblVector  
  END  
   ELSE   
   -- Reportamos el Vector  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
 SET NOCOUNT OFF   
  
END  
   
  
/*    
------------------------------------------------------------------------------------      
 Creado por:    Mike Ramírez        
 Modificacion:   13:20 2013-07-30       
 Descripcion:    Modulo 43: Se modifica la forma en la que se calcula los precios MO      
     
  Modificado por:    Aceves Gutierrez Omar Adrian      
 Modificacion:   2014-03-12 11:57:33.317     
 Descripcion:    Modulo 43: se agrega 2 elemnto SCTFG con serie 91, 28 y varibles     
   
   
     Modificado por:    Aceves Gutierrez Omar Adrian      
 Modificacion:   2014-05-20 17:20:23.753   
 Descripcion:    Modulo 43: se amplia longuitud de cadena a (10)a campo txtCURm  
   
     
------------------------------------------------------------------------------------    
*/    
CREATE   PROCEDURE dbo.sp_productos_JPMORGAN;43      
   @txtDate  VARCHAR (20)  --= '20140512'    
      
AS      
BEGIN      
      
 SET NOCOUNT ON      
    
 --DECLARE  @txtDate AS VARCHAR (20)      
 --SET @txtDate ='20140520'    
      
      
 DECLARE @dblUFXU AS FLOAT      
 DECLARE @dblEUR AS FLOAT      
 DECLARE @dblUDI AS FLOAT      
 DECLARE @dblJPY AS FLOAT      
 DECLARE @dblAUD AS FLOAT      
 DECLARE @dblCAD AS FLOAT      
 DECLARE @dblCHF AS FLOAT      
 DECLARE @dblGBP AS FLOAT      
 DECLARE @dblITL AS FLOAT      
 DECLARE @dblBRL AS FLOAT      
 DECLARE @dblInt AS FLOAT      
 DECLARE @dblCLP AS FLOAT      
 DECLARE @dblCOP AS FLOAT      
 DECLARE @dblDKK AS FLOAT      
 DECLARE @dblHKD AS FLOAT      
 DECLARE @dblIDR AS FLOAT      
 DECLARE @dblNOK AS FLOAT      
 DECLARE @dblPEN AS FLOAT      
 DECLARE @dblSEK AS FLOAT      
 DECLARE @dblSGD AS FLOAT      
 DECLARE @dblSMG AS FLOAT      
 DECLARE @dblTWD AS FLOAT      
 DECLARE @dblZAR AS FLOAT       
       
 -- Creo tabla temporal de Resultados      
 DECLARE @tmp_tblUnifiedPricesReport TABLE (      
  [dteDate][DATETIME],      
  [txtId1][VARCHAR](11),      
  [txtTv][VARCHAR](10),      
  [txtEmisora][VARCHAR](10),      
  [txtSerie][VARCHAR](10),      
  [txtLiquidation][CHAR](5),      
  [txtMKT][VARCHAR](400),      
  [dblPRL][FLOAT],      
  [dblPRS][FLOAT],      
  [txtCUR][VARCHAR](400),      
  [txtPRS_MO][VARCHAR](400),      
  [txtPRL_MO][VARCHAR](400),      
  [txtCPD_MO][VARCHAR](400),      
  [dblCPD][FLOAT],      
  [dblDTM][FLOAT],      
  [dblUDR][FLOAT],      
  [dblCPA][FLOAT],      
  [dblLDR][FLOAT],      
  [dblYTM][FLOAT],      
  [txtCURm][CHAR](10)      
  PRIMARY KEY CLUSTERED (      
   dtedate,txtliquidation,txtId1      
   )      
 )      
      
 DECLARE @tmp_tblResults TABLE (      
  [txtTV][CHAR](4),      
  [txtEmisora][CHAR](7),      
  [txtSerie][CHAR](6),      
  [txtData][VARCHAR](8000)      
  PRIMARY KEY (txtTv,txtEmisora,txtSerie)      
 )      
      
 SET @dblUFXU = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UFXU' AND dteDate = @txtDate)      
 SET @dblEUR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'EUR' AND dteDate = @txtDate)      
 SET @dblUDI = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'UDI' AND dteDate = @txtDate)      
 SET @dblJPY = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'JPY' AND dteDate = @txtDate)      
 SET @dblAUD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'AUD' AND dteDate = @txtDate)      
 SET @dblCAD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CAD' AND dteDate = @txtDate)      
 SET @dblCHF = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CHF' AND dteDate = @txtDate)      
 SET @dblGBP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'GBP' AND dteDate = @txtDate)      
 SET @dblITL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ITL' AND dteDate = @txtDate)      
 SET @dblBRL = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'BRL' AND dteDate = @txtDate)      
 SET @dblInt = 1      
 SET @dblCLP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'CLP' AND dteDate = @txtDate)      
 SET @dblCOP = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'COP' AND dteDate = @txtDate)      
 SET @dblDKK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'DKK' AND dteDate = @txtDate)      
 SET @dblHKD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'HKD' AND dteDate = @txtDate)      
 SET @dblIDR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'IDR' AND dteDate = @txtDate)      
 SET @dblNOK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'NOK' AND dteDate = @txtDate)      
 SET @dblPEN = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'PEN' AND dteDate = @txtDate)      
 SET @dblSEK = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SEK' AND dteDate = @txtDate)      
 SET @dblSGD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SGD' AND dteDate = @txtDate)      
 SET @dblSMG = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'SMG' AND dteDate = @txtDate)      
 SET @dblTWD = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'TWD' AND dteDate = @txtDate)      
 SET @dblZAR = (SELECT dblvalue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE txtIRC = 'ZAR' AND dteDate = @txtDate)      
       
 -- Universo a procesar (VPrecios)                              
 INSERT @tmp_tblUnifiedPricesReport (dtedate,txtID1,txtTv,txtEmisora,txtSerie,txtLiquidation,txtMKT,dblPRL,dblPRS,txtCUR,txtPRS_MO,txtPRL_MO,txtCPD_MO,dblCPD,dblDTM,dblUDR,dblCPA,dblLDR,dblYTM,txtCURm)      
  SELECT       
   dtedate,      
   txtID1,      
   txtTv,      
   txtEmisora,      
   txtSerie,      
   txtLiquidation,      
   txtMKT,      
   dblPRL,      
   dblPRS,      
   txtCUR,      
   txtPRS_MO,      
   txtPRL_MO,      
   txtCPD_MO,      
   dblCPD,      
   dblDTM,      
   dblUDR,      
   dblCPA,      
   dblLDR,      
   dblYTM,      
   SUBSTRING(txtCur,2,3)      
  FROM dbo.tmp_tblUnifiedPricesReport (NOLOCK)      
       
     
     
 -- Universo a procesar (VNotas)      
 INSERT @tmp_tblUnifiedPricesReport (dtedate,txtID1,txtTv,txtEmisora,txtSerie,txtLiquidation,txtMKT,dblPRL,dblPRS,txtCUR,txtPRS_MO,txtPRL_MO,txtCPD_MO,dblCPD,dblDTM,dblUDR,dblCPA,dblLDR,dblYTM,txtCURm)      
  SELECT       
   dtedate,      
   txtID1,      
   txtTv,      
   txtEmisora,      
   txtSerie,      
   txtLiquidation,      
   txtMKT,      
   dblPRL,      
   dblPRS,      
   txtCUR,      
   txtPRS_MO,      
   txtPRL_MO,      
   txtCPD_MO,      
   dblCPD,      
   dblDTM,      
   dblUDR,      
   dblCPA,      
   dblLDR,      
   dblYTM,      
   SUBSTRING(txtCur,2,3)      
 FROM MxFixIncome.dbo.tmp_tblUnifiedNotesReport AS ap (NOLOCK)      
  INNER JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS op  (NOLOCK)      
    ON ap.txtId1 = op.txtDir      
 WHERE ap.dteDate = @txtDate      
  AND ap.txtLiquidation IN ('MD','MP')      
  AND op.txtOwnerId = 'JPM02'      
  AND op.txtProductId = 'SNOTES'      
        
 -- Calculo Precio Limpio MO      
 UPDATE r      
 SET txtPRL_MO = (CASE         
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUFXU),16,6))      
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRL]/@dblEUR),16,6))      
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRL]/@dblUDI),16,6))      
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRL]/@dblJPY),16,6))      
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblAUD),16,6))      
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCAD),16,6))      
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCHF),16,6))      
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblGBP),16,6))      
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRL]/@dblITL),16,6))      
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblBRL),16,6))      
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRL/@dblInt),16,6))           
      
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRL]/@dblCLP),16,9))      
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRL]/@dblCOP),16,9))      
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRL]/@dblDKK),16,9))      
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRL]/@dblHKD),16,9))      
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblIDR),16,9))      
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRL]/@dblNOK),16,9))      
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRL]/@dblPEN),16,9))      
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSEK),16,9))      
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblSGD),16,9))      
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRL]/@dblSMG),16,9))      
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblTWD),16,6))      
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRL]/@dblZAR),16,6))      
            
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRL] AS FLOAT),6),19,6))      
      WHEN txtLiquidation = 'MP' THEN LTRIM(STR(ROUND(CAST([dblPRL] AS FLOAT),6),19,6))             
     END)       
 FROM @tmp_tblUnifiedPricesReport AS r      
       
 -- Calculo Precio Sucio MO      
 UPDATE r      
 SET txtPRS_MO = (CASE       
      WHEN txtCUR = '[USD] Dolar Americano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUFXU),16,6))      
      WHEN txtCUR = '[EUR] Euro (MXN)' THEN LTRIM(STR(([dblPRS]/@dblEUR),16,6))      
      WHEN txtCUR = '[UDI] Unidades de Inversion (MXN)' THEN LTRIM(STR(([dblPRS]/@dblUDI),16,6))      
      WHEN txtCUR = '[JPY] Yen Japones (MXN)' THEN LTRIM(STR(([dblPRS]/@dblJPY),16,6))      
      WHEN txtCUR = '[AUD] Dolar Australiano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblAUD),16,6))      
      WHEN txtCUR = '[CAD] Dolar Canadiense (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCAD),16,6))      
      WHEN txtCUR = '[CHF] Franco Suizo (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCHF),16,6))      
      WHEN txtCUR = '[GBP] Libra Inglesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblGBP),16,6))      
      WHEN txtCUR = '[ITL] Lira Italiana (MXN)' THEN LTRIM(STR(([dblPRS]/@dblITL),16,6))      
      WHEN txtCUR = '[BRL] Real Brasileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblBRL),16,6))      
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN LTRIM(STR((dblPRS/@dblInt),16,6))      
      
      WHEN txtCUR = '[CLP] Peso Chileno (MXN)' THEN LTRIM(STR(([dblPRS]/@dblCLP),16,9))      
      WHEN txtCUR = '[COP] Peso Colombiano (MXP)' THEN LTRIM(STR(([dblPRS]/@dblCOP),16,9))      
      WHEN txtCUR = '[DKK] Corona Danesa (MXN)' THEN LTRIM(STR(([dblPRS]/@dblDKK),16,9))      
      WHEN txtCUR = '[HKD] Hong Kong Dolar (MXN)' THEN LTRIM(STR(([dblPRS]/@dblHKD),16,9))      
      WHEN txtCUR = '[IDR] Rupia Indonesia  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblIDR),16,9))      
      WHEN txtCUR = '[NOK] Corona Noruega (MXN)' THEN LTRIM(STR(([dblPRS]/@dblNOK),16,9))      
      WHEN txtCUR = '[PEN] Sol Peruano (MXN)' THEN LTRIM(STR(([dblPRS]/@dblPEN),16,9))      
      WHEN txtCUR = '[SEK] Corona Sueca (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSEK),16,9))      
      WHEN txtCUR = '[SGD] Dolar Singapur  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblSGD),16,9))      
      WHEN txtCUR = '[SMG] Salario Minimo General' THEN LTRIM(STR(([dblPRS]/@dblSMG),16,9))      
      WHEN txtCUR = '[TWD] Nuevo Dolar Taiwan  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblTWD),16,6))      
      WHEN txtCUR = '[ZAR] Rand Rep. De Sudafrica  (MXN)' THEN LTRIM(STR(([dblPRS]/@dblZAR),16,6))      
            
      WHEN txtTv IN ('SWT','*C','*CSP') THEN LTRIM(STR(ROUND(CAST([dblPRS] AS FLOAT),6),19,6))      
      WHEN txtLiquidation = 'MP' THEN LTRIM(STR(ROUND(CAST([dblPRS] AS FLOAT),6),19,6))      
     END)      
 FROM @tmp_tblUnifiedPricesReport AS r      
      
  --SELECT * FROM @tmp_tblUnifiedPricesReport WHERE txtemisora = 'SCTFG'    
      
 -- Calculo Interes      
 UPDATE r      
 SET txtCPD_MO =       
     (CASE       
      WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN STR(ROUND(dblCPD,6),13,6)      
      ELSE ROUND(CAST(txtPRS_MO AS FLOAT),6) - ROUND(CAST(txtPRL_MO AS FLOAT),6)      
      END)       
 FROM @tmp_tblUnifiedPricesReport AS r      
   
   
   
     UPDATE  r  
   SET txtcurm = (  
   CASE   
  WHEN txtLiquidation = 'MP' AND txttv IN ('RC') THEN SUBSTRING(txtCur,2,3)   
  WHEN  txttv IN ('*C','*CSP') THEN (txtSerie)--serie  
     
  WHEN txtLiquidation = 'MP' AND  txttv NOT IN ('*C','*CSP','RC')THEN 'MXN'  
  ELSE  SUBSTRING(txtCur,2,3)   
 END   
     )   
   FROM @tmp_tblUnifiedPricesReport AS r  
   
   
 /*Cambios anterioes funcionales al 20140516*/  
 --   UPDATE  r  
 --  SET txtcurm = (  
 --  CASE WHEN txtLiquidation = 'MP' AND txttv IN ('*C','*CSP','RC') THEN SUBSTRING(txtCur,2,3)   
 -- WHEN txtLiquidation = 'MP' AND  txttv NOT IN ('*C','*CSP','RC')THEN 'MXN'  
 -- ELSE  SUBSTRING(txtCur,2,3)   
 --END   
 --    )   
 --  FROM @tmp_tblUnifiedPricesReport AS r  
      
    
    
 -- Agregar hacia una tabla tblResults      
 INSERT @tmp_tblResults (txtTv,txtEmisora,txtSerie,txtData)      
 SELECT      
  txtTV,      
  txtEmisora,      
  txtSerie,      
  'H '+      
  RTRIM(txtMKT) +        
  CONVERT(CHAR(8),dteDate,112) +      
  --TV+Emisora+Serie      
  RTRIM(txtTv) + REPLICATE(' ', 4 - LEN(RTRIM(txtTv))) +       
  RTRIM(txtEmisora) + REPLICATE(' ',7 - LEN(RTRIM(txtEmisora))) +      
  RTRIM(txtserie) + REPLICATE(' ',6 - LEN(RTRIM(txtSerie))) +      
  --PRS MD      
  CASE WHEN txtTv IN ('SWT','*C','*CSP') THEN REPLACE(SUBSTRING(STR(dblPRS,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRS,16,6),11,6)      
    WHEN txtLiquidation = 'MP' THEN REPLACE(SUBSTRING(STR(dblPRS,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRS,16,6),11,6)      
    ELSE       
      (CASE WHEN (txtPRS_MO<>'NA' AND txtPRS_MO<>'-' AND txtPRS_MO<>'')       
       THEN REPLACE(SUBSTRING(STR(CAST(txtPRS_MO AS FLOAT),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(txtPRS_MO AS FLOAT),16,6),11,6)      
       ELSE '000000000000000'      
       END)      
  END+      
  --PRL MD      
  CASE WHEN txtTv IN ('SWT','*C','*CSP') THEN REPLACE(SUBSTRING(STR(dblPRL,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRL,16,6),11,6)      
    WHEN txtLiquidation = 'MP' THEN REPLACE(SUBSTRING(STR(dblPRL,16,6),1,9),' ','0') + SUBSTRING(STR(dblPRL,16,6),11,6)        
    ELSE       
      (CASE WHEN (txtPRL_MO<>'NA' AND txtPRL_MO<>'-' AND txtPRL_MO<>'')       
       THEN REPLACE(SUBSTRING(STR(CAST(txtPRL_MO AS FLOAT),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(txtPRL_MO AS FLOAT),16,6),11,6)      
       ELSE '000000000000000'      
       END)      
  END +      
  -- INTERES CPD      
  CASE       
   WHEN txtCPD_MO = 'NA' OR txtCPD_MO = '-' OR txtCPD_MO = '' THEN '000000000000'      
   WHEN txtCUR = '[MPS] Peso Mexicano (MXN)' THEN REPLACE(SUBSTRING(STR(ROUND(dblCPD,6),13,6),1,6),' ','0') + SUBSTRING(STR(ROUND(dblCPD,6),13,6),8,6)      
   WHEN txtLiquidation = 'MP' THEN REPLACE(SUBSTRING(STR(ROUND(dblCPD,6),13,6),1,6),' ','0') + SUBSTRING(STR(ROUND(dblCPD,6),13,6),8,6)      
   ELSE REPLACE(SUBSTRING(STR(CAST(txtCPD_MO AS FLOAT),13,6),1,6),' ','0') + SUBSTRING(STR(CAST(txtCPD_MO AS FLOAT),13,6),8,6)      
  --ELSE '000000000000'      
  END +      
      
  '025009' +       
  '1' +      
  REPLACE(SUBSTRING(STR(dblCPA,13,6),1,6),' ','0') + SUBSTRING(STR(dblCPA,13,6),8,6) +      
       
  CASE       
   WHEN txtTv IN ('IP','IT','L','LD','LP','LS','LT','XA','IS','IQ','IM') THEN REPLACE(SUBSTRING(STR(dblLDR,13,6),1,6),' ','0') + SUBSTRING(STR(dblLDR,13,6),8,6)       
   WHEN txtTv IN ('D','D3','G','I') THEN REPLACE(SUBSTRING(STR(dblUDR,13,6),1,6),' ','0') + SUBSTRING(STR(dblUDR,13,6),8,6)      
  ELSE       
   REPLACE(SUBSTRING(STR(dblYTM,13,6),1,6),' ','0') + SUBSTRING(STR(dblYTM,13,6),8,6)        END +      
     
     
  CASE       
   WHEN RTRIM(txtCURm) = 'MPS' THEN 'MXN'      
  ELSE RTRIM(txtCURm)      
  END      
  AS txtData       
 FROM @tmp_tblUnifiedPricesReport      
 WHERE       
   dteDate = @txtDate      
   AND txtLiquidation IN ('MD','MP')      
   AND txtTv NOT IN ('56SP','1ASP','1ESP','1ISP','56SP','91SP','D1SP','D2SP','D4SP','D5SP','D6SP','D7SP','D8SP','FSP','JISP','JSP','QSP','R3SP','YYSP','FA','FB','FC','FD','FI','FM','FS','FU','OA','OD','OI','SWT')            
    
 ---Obtenemos el mayor de dos variables para su posterior incorparacion en un indice elaborado    
    
DECLARE @MaxTFG2 FLOAT    
DECLARE @MaxSC091  FLOAT    
DECLARE @MaxFinalValue FLOAT    
    
 SET @MaxTFG2 = (SELECT dblValue FROM dbo.tblIrc AS TT     
 INNER JOIN (SELECT  MAX(dteDate)AS dteDate FROM  dbo.tblIrc  WHERE txtIRC = 'TFG')  TDI     
   ON  TT.dteDate = TDI.dteDate    
   WHERE txtIRC = 'TFG' )    
      
 SET @MaxSC091 = (SELECT dblValue FROM dbo.tblIrc AS TT     
 INNER JOIN (SELECT  MAX(dteDate)AS dteDate FROM  dbo.tblIrc WHERE txtIRC = 'SC091')  TDI     
   ON  TT.dteDate = TDI.dteDate    
   WHERE txtIRC = 'SC091')    
    
 SET @MaxTFG2 = CASE WHEN @MaxTFG2 IS NULL THEN 0 ELSE @MaxTFG2  END     
 SET @MaxSC091 = CASE WHEN @MaxSC091 IS NULL THEN 0 ELSE  @MaxSC091 END     
    
    
 set @MaxFinalValue = CASE WHEN @MaxTFG2 > @MaxSC091 THEN @MaxTFG2    
  ELSE @MaxSC091 END    
    
-- indice elaborado    
    
 INSERT INTO @tmp_tblResults (txtTv,txtEmisora,txtSerie,txtData)      
  SELECT TOP 1 'TR','SCTFG','28','H '+ RTRIM(txtMKT)+CONVERT(CHAR(8),dteDate,112) +   RTRIM('TR') + REPLICATE(' ', 4 - LEN(RTRIM('TR'))) +       
    RTRIM('SCTFG') + REPLICATE(' ',7 - LEN(RTRIM('SCTFG'))) +      
    RTRIM(28) + REPLICATE(' ',6 - LEN(RTRIM(28))) +    
   REPLACE(SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),11,6)  +    
   REPLACE(SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),11,6)  +    
   '000000000000' + '025009' + '1' + '000000000000000000000000MXN'    
  FROM @tmp_tblUnifiedPricesReport WHERE dteDate =@txtdate    
      
     
     
  INSERT INTO @tmp_tblResults (txtTv,txtEmisora,txtSerie,txtData)      
   SELECT TOP 1 'TR','SCTFG','91','H '+ RTRIM(txtMKT)+CONVERT(CHAR(8),dteDate,112) +   RTRIM('TR') + REPLICATE(' ', 4 - LEN(RTRIM('TR'))) +       
    RTRIM('SCTFG') + REPLICATE(' ',7 - LEN(RTRIM('SCTFG'))) +      
    RTRIM(91) + REPLICATE(' ',6 - LEN(RTRIM(91))) +    
   REPLACE(SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),11,6)  +    
   REPLACE(SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),1,9),' ','0') + SUBSTRING(STR(CAST(@MaxFinalValue AS VARCHAR(100)),16,6),11,6)  +    
   '000000000000' + '025009' + '1' + '000000000000000000000000MXN'    
 FROM @tmp_tblUnifiedPricesReport WHERE dteDate =@txtdate    
    
 -- Valida la información       
    
 IF ((SELECT count(*) FROM @tmp_tblResults) < 1)      
      
 BEGIN      
  RAISERROR ('ERROR: Falta Informacion', 16, 1)      
 END      
      
 ELSE      
  SELECT RTRIM(txtData)      
  FROM @tmp_tblResults      
  ORDER BY txtTV,txtEmisora,txtSerie      
        
 SET NOCOUNT OFF      
  END -----------------------------------------------------------------------------------------------  
-- Creado por:    Mike Ramírez    
-- Fecha Creacion:   13:05 2013-02-12   
-- Descripcion Modulo 44:   Modulo 44: Sp que genera el producto JPM_CURVA_GBPMX_[YYYYMMDD].TXT  
-----------------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;44  
 @txtDate AS DATETIME  
  
AS  
 BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tmpLayoutxlCurve TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
   SELECT   
    1,   
    'Nodos' + CHAR(9) + 'Cross Currency Swap Libor(GBP)/TIIE'  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
  SELECT  
   2,   
   LTRIM(intTerm) + CHAR(9) +  
   LTRIM(STR(dblRate,19,10))  
  FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
  WHERE dteDate = @txtDate   
   AND txtType = 'CCS'  
   AND txtSubtype = 'GBP'  
    
   -- Valida la información   
 IF ((SELECT count(*) FROM @tmpLayoutxlCurve) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT txtData  
  FROM @tmpLayoutxlCurve  
  
  SET NOCOUNT OFF  
  
END  
-------------------------------------------------------------------------------------   
-- Creado por:    Mike Ramírez    
-- Fecha Creacion:   13:16 2013-03-25   
-- Descripcion Modulo 45: Sp que genera el producto JPM_Implicita_FIX[yyyymmdd].TXT  
-------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;45  
 @txtDate AS DATETIME  
  
AS  
 BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tmpLayoutxlCurve TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
   SELECT   
    1,   
    'Fecha' + CHAR(9) + 'Plazo' + CHAR(9) + 'Tasa'  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
  SELECT  
   2,  
   CONVERT(CHAR(10),@txtDate,103) + CHAR(9) +   
   LTRIM(intTerm) + CHAR(9) +  
   LTRIM(STR(dblRate,19,10))  
  FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
  WHERE dteDate = @txtDate   
   AND txtType = 'FWD'  
   AND txtSubtype = 'CUX'  
    
   -- Valida la información   
 IF ((SELECT count(*) FROM @tmpLayoutxlCurve) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT txtData  
  FROM @tmpLayoutxlCurve  
  
  SET NOCOUNT OFF  
  
END  
--------------------------------------------------------------------------------------  
-- Creado por:    Mike Ramírez    
-- Fecha Creacion:   10:50 2013-04-15   
-- Descripcion Modulo 46: Sp que genera el producto JPM_LIBOR_SPREADS_[yyyymmdd].TXT  
--------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;46  
 @txtDate AS DATETIME  
AS      
BEGIN      
  
 SET NOCOUNT ON  
  
 DECLARE @TASA1D AS FLOAT  
 DECLARE @TASA1M AS FLOAT  
 DECLARE @TASA1M6 AS FLOAT  
 DECLARE @TASA1Y AS FLOAT  
 DECLARE @TASA2M AS FLOAT  
 DECLARE @TASA2M6 AS FLOAT  
 DECLARE @TASA3M6 AS FLOAT  
 DECLARE @TASA4M6 AS FLOAT  
 DECLARE @TASA3M AS FLOAT  
 DECLARE @TASA6M AS FLOAT  
 DECLARE @TASA4M AS FLOAT  
 DECLARE @TASA6D AS FLOAT  
 DECLARE @USBA10A AS FLOAT  
 DECLARE @USBA10B AS FLOAT  
 DECLARE @USBA12A AS FLOAT  
 DECLARE @USBA12B AS FLOAT  
 DECLARE @USBA15A AS FLOAT  
 DECLARE @USBA15B AS FLOAT  
 DECLARE @USBA1A AS FLOAT  
 DECLARE @USBA1B AS FLOAT  
 DECLARE @USBA1FA AS FLOAT  
 DECLARE @USBA1FB AS FLOAT  
 DECLARE @USBA20A AS FLOAT  
 DECLARE @USBA20B AS FLOAT  
 DECLARE @USBA25A AS FLOAT  
 DECLARE @USBA25B AS FLOAT  
 DECLARE @USBA2A AS FLOAT  
 DECLARE @USBA2B AS FLOAT  
 DECLARE @USBA30A AS FLOAT  
 DECLARE @USBA30B AS FLOAT  
 DECLARE @USBA3A AS FLOAT  
 DECLARE @USBA3B AS FLOAT  
 DECLARE @USBA4A AS FLOAT  
 DECLARE @USBA4B AS FLOAT  
 DECLARE @USBA5A AS FLOAT  
 DECLARE @USBA5B AS FLOAT  
 DECLARE @USBA6A AS FLOAT  
 DECLARE @USBA6B AS FLOAT  
 DECLARE @USBA7A AS FLOAT  
 DECLARE @USBA7B AS FLOAT  
 DECLARE @USBA8A AS FLOAT  
 DECLARE @USBA8B AS FLOAT  
 DECLARE @USBA9A AS FLOAT  
 DECLARE @USBA9B AS FLOAT  
 DECLARE @USBAACA AS FLOAT  
 DECLARE @USBAACB AS FLOAT  
 DECLARE @USBAAFA AS FLOAT  
 DECLARE @USBAAFB AS FLOAT  
 DECLARE @USBAAIA AS FLOAT  
 DECLARE @USBAAIB AS FLOAT  
 DECLARE @USBC10A AS FLOAT  
 DECLARE @USBC10B AS FLOAT  
 DECLARE @USBC12A AS FLOAT  
 DECLARE @USBC12B AS FLOAT  
 DECLARE @USBC15A AS FLOAT  
 DECLARE @USBC15B AS FLOAT  
 DECLARE @USBC1A AS FLOAT  
 DECLARE @USBC1B AS FLOAT  
 DECLARE @USBC9B AS FLOAT  
 DECLARE @USBC1FA AS FLOAT  
 DECLARE @USBC1FB AS FLOAT  
 DECLARE @USBC20A AS FLOAT  
 DECLARE @USBC20B AS FLOAT  
 DECLARE @USBC25A AS FLOAT  
 DECLARE @USBC25B AS FLOAT  
 DECLARE @USBC2A AS FLOAT  
 DECLARE @USBC2B AS FLOAT  
 DECLARE @USBC30A AS FLOAT  
 DECLARE @USBC30B AS FLOAT  
 DECLARE @USBC3A AS FLOAT  
 DECLARE @USBC3B AS FLOAT  
 DECLARE @USBC4A AS FLOAT  
 DECLARE @USBC4B AS FLOAT  
 DECLARE @USBC5A AS FLOAT  
 DECLARE @USBC5B AS FLOAT  
 DECLARE @USBC6A AS FLOAT  
 DECLARE @USBC6B AS FLOAT  
 DECLARE @USBC7A AS FLOAT  
 DECLARE @USBC7B AS FLOAT  
 DECLARE @USBC8A AS FLOAT  
 DECLARE @USBC8B AS FLOAT  
 DECLARE @USBC9A AS FLOAT  
 DECLARE @USBCFA AS FLOAT  
 DECLARE @USBCFB AS FLOAT  
  
    DECLARE @tmp_tblIRCDateMax TABLE (  
   txtIRC CHAR(7),  
   dteDate DATETIME  
  PRIMARY KEY (txtIRC))  
    
    DECLARE @tmp_tblUniversIRC TABLE (  
   txtIRC CHAR(7),  
   dteDate DATETIME,  
   dblValue FLOAT)  
     
 DECLARE @tmp_tblIRCConsolidacion TABLE (  
   txtIRC CHAR(7),  
   dblValue FLOAT  
  PRIMARY KEY (txtIRC))  
  
 DECLARE @tmp_tblResult TABLE (  
   intSection INT,  
   txtData VARCHAR(8000)  
  PRIMARY KEY (intSection))  
  
 -- Cargamos las fechas máximas de los IRC  
 INSERT @tmp_tblIRCDateMax (txtIRC,dteDate)  
  SELECT  
    txtIRC,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
   WHERE  
    txtIRC IN ('USBA10A','USBA10B','USBA12A','USBA12B','USBA15A',  
       'USBA15B','USBA1A','USBA1B','USBA1FA','USBA1FB','USBA20A','USBA20B','USBA25A','USBA25B','USBA2A','USBA2B','USBA30A',  
       'USBA30B','USBA3A','USBA3B','USBA4A','USBA4B','USBA5A','USBA5B','USBA6A','USBA6B','USBA7A','USBA7B','USBA8A','USBA8B',  
       'USBA9A','USBA9B','USBAACA','USBAACB','USBAAFA','USBAAFB','USBAAIA','USBAAIB','USBC10A','USBC10B','USBC12A','USBC12B',  
       'USBC15A','USBC15B','USBC1A','USBC1B','USBC1FA','USBC1FB','USBC20A','USBC20B','USBC25A','USBC25B','USBC2A','USBC2B',  
       'USBC30A','USBC30B','USBC3A','USBC3B','USBC4A','USBC4B','USBC5A','USBC5B','USBC6A','USBC6B','USBC7A','USBC7B','USBC8A',  
       'USBC8B','USBC9A','USBCFA','USBCFB','USBC9B')   
   GROUP BY txtIRC   
  
 -- Obtenemos el universo de los IRC  
 INSERT @tmp_tblUniversIRC (txtIRC,dteDate,dblValue)  
  SELECT  
    txtIRC,  
    dteDate,  
    dblValue  
   FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
   WHERE  
    txtIRC IN ('USBA10A','USBA10B','USBA12A','USBA12B','USBA15A',  
       'USBA15B','USBA1A','USBA1B','USBA1FA','USBA1FB','USBA20A','USBA20B','USBA25A','USBA25B','USBA2A','USBA2B','USBA30A',  
       'USBA30B','USBA3A','USBA3B','USBA4A','USBA4B','USBA5A','USBA5B','USBA6A','USBA6B','USBA7A','USBA7B','USBA8A','USBA8B',  
       'USBA9A','USBA9B','USBAACA','USBAACB','USBAAFA','USBAAFB','USBAAIA','USBAAIB','USBC10A','USBC10B','USBC12A','USBC12B',  
       'USBC15A','USBC15B','USBC1A','USBC1B','USBC1FA','USBC1FB','USBC20A','USBC20B','USBC25A','USBC25B','USBC2A','USBC2B',  
       'USBC30A','USBC30B','USBC3A','USBC3B','USBC4A','USBC4B','USBC5A','USBC5B','USBC6A','USBC6B','USBC7A','USBC7B','USBC8A',  
       'USBC8B','USBC9A','USBCFA','USBCFB','USBC9B')   
  
 -- Obtengo los valores máximos de los IRC  
 INSERT @tmp_tblIRCConsolidacion (txtIRC,dblValue)  
  SELECT  
   m.txtIRC,  
   u.dblValue  
  FROM @tmp_tblIRCDateMax AS m  
   INNER JOIN @tmp_tblUniversIRC AS u  
   ON   
    m.txtIRC = u.txtIRC  
    AND m.dteDate = u.dteDate   
   
 SET @USBA10A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA10A')  
 SET @USBA10B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA10B')  
 SET @USBA12A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA12A')  
 SET @USBA12B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA12B')  
 SET @USBA15A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA15A')  
 SET @USBA15B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA15B')  
 SET @USBA1A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA1A')  
 SET @USBA1B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA1B')  
 SET @USBA1FA = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA1FA')  
 SET @USBA1FB = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA1FB')  
 SET @USBA20A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA20A')  
 SET @USBA20B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA20B')  
 SET @USBA25A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA25A')  
 SET @USBA25B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA25B')  
 SET @USBA2A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA2A')  
 SET @USBA2B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA2B')  
 SET @USBA30A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA30A')  
 SET @USBA30B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA30B')  
 SET @USBA3A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA3A')  
 SET @USBA3B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA3B')  
 SET @USBA4A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA4A')  
 SET @USBA4B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA4B')  
 SET @USBA5A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA5A')  
 SET @USBA5B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA5B')  
 SET @USBA6A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA6A')  
 SET @USBA6B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA6B')  
 SET @USBA7A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA7A')  
 SET @USBA7B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA7B')  
 SET @USBA8A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA8A')  
 SET @USBA8B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA8B')  
 SET @USBA9A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA9A')  
 SET @USBA9B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBA9B')  
 SET @USBAACA = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBAACA')  
 SET @USBAACB = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBAACB')  
 SET @USBAAFA = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBAAFA')  
 SET @USBAAFB = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBAAFB')  
 SET @USBAAIA = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBAAIA')  
 SET @USBAAIB = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBAAIB')  
 SET @USBC10A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC10A')  
 SET @USBC10B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC10B')  
 SET @USBC12A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC12A')  
 SET @USBC12B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC12B')  
 SET @USBC15A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC15A')  
 SET @USBC15B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC15B')  
 SET @USBC1A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC1A')  
 SET @USBC1B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC1B')  
 SET @USBC1FA = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC1FA')  
 SET @USBC1FB = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC1FB')  
 SET @USBC20A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC20A')  
 SET @USBC20B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC20B')  
 SET @USBC25A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC25A')  
 SET @USBC25B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC25B')  
 SET @USBC2A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC2A')  
 SET @USBC2B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC2B')  
 SET @USBC30A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC30A')  
 SET @USBC30B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC30B')  
 SET @USBC3A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC3A')  
 SET @USBC3B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC3B')  
 SET @USBC4A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC4A')  
 SET @USBC4B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC4B')  
 SET @USBC5A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC5A')  
 SET @USBC5B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC5B')  
 SET @USBC6A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC6A')  
 SET @USBC6B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC6B')  
 SET @USBC7A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC7A')  
 SET @USBC7B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC7B')  
 SET @USBC8A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC8A')  
 SET @USBC8B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC8B')  
 SET @USBC9A = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC9A')  
 SET @USBCFA = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBCFA')  
 SET @USBCFB = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBCFB')  
 SET @USBC9B = (SELECT dblValue FROM @tmp_tblIRCConsolidacion WHERE txtIRC = 'USBC9B')  
   
 SET @TASA3M = (STR(ROUND(((@USBAACB + @USBAACA)/CAST(2 AS FLOAT)),6),16,6))  
 SET @TASA6M = (STR(ROUND(((@USBCFB + @USBCFA)/CAST(2 AS FLOAT)),6),16,6))  
 SET @TASA4M = (STR(ROUND(((@USBCFB + @USBCFA)/CAST(2 AS FLOAT)),6),16,6))  
  
                                
  SET @TASA1D = (RTRIM(LTRIM(STR((POWER((CAST(1 AS FLOAT)+(CAST(90 AS FLOAT)*CAST((STR(ROUND(((@USBAACB + @USBAACA)/CAST(2 AS FLOAT)),6),16,6)) AS FLOAT)/CAST(360 AS FLOAT))),(CAST(1 AS FLOAT)/CAST(90 AS FLOAT)))-1) * STR(ROUND(CAST(360 AS FLOAT) / CAST(
1 AS FLOAT),6),16,6),16,6))))  
 SET @TASA6D = (RTRIM(LTRIM(STR((POWER((CAST(1 AS FLOAT)+(CAST(180 AS FLOAT)*CAST((STR(ROUND(((@USBCFB + @USBCFA)/CAST(2 AS FLOAT)),6),16,6)) AS FLOAT)/CAST(360 AS FLOAT))),(CAST(1 AS FLOAT)/CAST(180 AS FLOAT)))-1) * STR(ROUND(CAST(360 AS FLOAT) / CAST(1 
AS FLOAT),6),16,6),16,6))))    
  
 SET @TASA1M = (RTRIM(LTRIM(STR(ROUND(((CAST(29 AS FLOAT)/CAST(89 AS FLOAT))*(@TASA3M-@TASA1D)+@TASA1D),6),16,6))))   
  
 SET @TASA1M6 = (RTRIM(LTRIM(STR(ROUND(((CAST(29 AS FLOAT)/CAST(179 AS FLOAT))*(@TASA6M-@TASA6D)+@TASA6D),6),16,6))))  
   
 SET @TASA2M = (RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(60 AS FLOAT))*(@TASA3M-@TASA1M)+@TASA1M),6),16,6))))  
   
 SET @TASA2M6 = (RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(150 AS FLOAT))*(@TASA6M-@TASA1M6)+@TASA1M6),6),16,6))))  
  
 SET @TASA3M6 = (RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(120 AS FLOAT))*(@TASA6M-@TASA2M6)+@TASA2M6),6),16,6))))  
  
 SET @TASA4M = (RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(90 AS FLOAT))*((STR(ROUND(((@USBAAFB + @USBAAFA)/CAST(2 AS FLOAT)),6),16,6))-@TASA3M)+@TASA3M),6),16,6))))  
  
 SET @TASA4M6 = (RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(90 AS FLOAT))*(@TASA6M-@TASA3M6)+@TASA3M6),6),16,6))))  
   
 SET @TASA1Y = (RTRIM(LTRIM(STR(ROUND(((@USBC1B + @USBC1A)/CAST(2 AS FLOAT)),6),16,6))))  
   
 -- Consolidamos el Achivo  
 INSERT @tmp_tblResult (intSection,txtData)  
  SELECT 001,'INDEX' + CHAR(9) + '0.25' + CHAR(9) + '0.5' UNION   
  SELECT 002,'ONMMY' + CHAR(9) + RTRIM(LTRIM(STR(@TASA1D,16,6))) + CHAR(9) + RTRIM(LTRIM(STR(@TASA6D,16,6))) UNION   
  SELECT 003,'1mMMY' + CHAR(9) + RTRIM(LTRIM(STR(@TASA1M,16,6))) + CHAR(9) + RTRIM(LTRIM(STR(@TASA1M6,16,6))) UNION  
  SELECT 004,'2mMMY' + CHAR(9) + RTRIM(LTRIM(STR(@TASA2M,16,6))) + CHAR(9) + RTRIM(LTRIM(STR(@TASA2M6,16,6))) UNION             
  SELECT 005,'3mMMY' + CHAR(9) + RTRIM(LTRIM(STR(@TASA3M,16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(120 AS FLOAT))*(@TASA6M-@TASA2M6)+@TASA2M6),6),16,6))) UNION  
  SELECT 006,'4mMMY' + CHAR(9) + RTRIM(LTRIM(STR(@TASA4M,16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(90 AS FLOAT))*(@TASA6M-@TASA3M6)+@TASA3M6),6),16,6))) UNION  
  SELECT 007,'5mMMY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(60 AS FLOAT))*((STR(ROUND(((@USBAAFB + @USBAAFA)/CAST(2 AS FLOAT)),6),16,6))-@TASA4M)+@TASA4M),6),16,6)))   
         + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((CAST(30 AS FLOAT)/CAST(60 AS FLOAT))*(@TASA6M-@TASA4M6)+@TASA4M6),6),16,6))) UNION         
  SELECT 008,'6mMMY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBAAFB + @USBAAFA)/CAST(2 AS FLOAT)),6),16,6)))   
         + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBCFB + @USBCFA)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 009,'9mMMY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBAAIB + @USBAAIA)/CAST(2 AS FLOAT)),6),16,6)))   
         + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((CAST(90 AS FLOAT)/CAST(180 AS FLOAT))*(@TASA1Y-@TASA6M)+@TASA6M),6),16,6))) UNION  
  SELECT 010,'1yMMY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA1B + @USBA1A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC1B + @USBC1A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 011,'18mBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA1FB + @USBA1FA)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC1FB + @USBC1FA)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 012,'2yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA2B + @USBA2A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC2B + @USBC2A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 013,'3yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA3B + @USBA3A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC3B + @USBC3A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 014,'4yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA4B + @USBA4A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC4B + @USBC4A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 015,'5yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA5B + @USBA5A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC5B + @USBC5A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 016,'6yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA6B + @USBA6A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC6B + @USBC6A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 017,'7yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA7B + @USBA7A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC7B + @USBC7A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 018,'8yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA8B + @USBA8A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC8B + @USBC8A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 019,'9yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA9B + @USBA9A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC9B + @USBC9A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 020,'10yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA10B + @USBA10A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC10B + @USBC10A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 021,'12yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA12B + @USBA12A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC12B + @USBC12A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 022,'15yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA15B + @USBA15A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC15B + @USBC15A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 023,'20yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA20B + @USBA20A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC20B + @USBC20A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 024,'25yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA25B + @USBA25A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC25B + @USBC25A)/CAST(2 AS FLOAT)),6),16,6))) UNION  
  SELECT 025,'30yBEY' + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBA30B + @USBA30A)/CAST(2 AS FLOAT)),6),16,6))) + CHAR(9) + RTRIM(LTRIM(STR(ROUND(((@USBC30B + @USBC30A)/CAST(2 AS FLOAT)),6),16,6)))  
  
 -- Reportamos el vector  
  SELECT   
   txtData  
  FROM @tmp_tblResult  
  ORDER BY intSection    
  
 SET NOCOUNT OFF   
  
END  
  
----------------------------------------------------------------------------------------  
-- Creado por:    Mike Ramírez    
-- Fecha Creacion:   15:16 2013-04-15   
-- Descripcion Modulo 45: Sp que genera el producto JPM_CURVA_LIBOR_GBP_[YYYYMMDD].TXT  
----------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;47  
 @txtDate AS DATETIME  
  
AS  
 BEGIN  
   
  SET NOCOUNT ON  
  
  DECLARE @tmpLayoutxlCurve TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
   SELECT   
    1,   
    'Fecha' + CHAR(9) + 'Plazo' + CHAR(9) + 'LIBOR GBP'  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
  SELECT  
   2,  
   CONVERT(CHAR(10),@txtDate,105) + CHAR(9) +   
   LTRIM(intTerm) + CHAR(9) +  
   LTRIM(STR(dblRate,19,10))  
  FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
  WHERE dteDate = @txtDate   
   AND txtType = 'LBZ'  
   AND txtSubtype = 'GBP'   
       
   -- Valida la información   
 IF ((SELECT count(*) FROM @tmpLayoutxlCurve) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT txtData  
  FROM @tmpLayoutxlCurve  
  
  SET NOCOUNT OFF  
  
END  
---------------------------------------------------------------------------------  
-- Autor:   Mike Ramirez  
-- Fecha Creacion: 09:38 a.m. 2013-04-16  
-- Descripcion:  Modulo 48: Genera el producto JPM_CURVA_GBPMXN_[YYYYMMDD].XLS  
---------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;48  
  @txtDate AS VARCHAR(10)  
AS   
BEGIN  
  
 SET NOCOUNT ON  
  
 DECLARE @tmpLayoutxlCurve TABLE (  
  SheetName CHAR(50),  
  Col INT,  
  Header CHAR(50),  
        Source CHAR(20),  
        Type CHAR(3),  
  SubType CHAR(3),  
  Range CHAR(15),  
  Factor CHAR(5),  
  DataType CHAR(3),   
  DataFormat CHAR(20),  
  fLoad CHAR(1),  
 PRIMARY KEY (Col)  
 )   
  
 -- <Sheet1> = Sheet1  
 INSERT @tmpLayoutxlCurve   
  --SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'Cross Currency Swap Libor(GBP)/TIIE'  AS [Header],'CURVES' AS [Source],'CCS'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000' AS [DataFormat],'1
' AS [fLoad]  
   
 SELECT  
  RTRIM(SheetName) AS [SheetName],  
  Col AS [Col],  
  RTRIM(Header) AS [Header],  
        RTRIM(Source) AS [Source],  
        RTRIM(Type) AS [Type],  
  RTRIM(SubType) AS [SubType],  
  RTRIM(Range) AS [Range],  
  RTRIM(Factor) AS [Factor],  
  RTRIM(DataType) AS [DataType],   
  RTRIM(DataFormat) AS [DataFormat],  
  RTRIM(fLoad) AS [fLoad]  
 FROM @tmpLayoutxlCurve  
 ORDER BY Col  
  
 SET NOCOUNT OFF  
  
END  
  
---------------------------------------------------------------------------------------  
-- Modificado por:    Mike Ramírez    
-- Fecha Modificacion:   09:20 2013-04-17   
-- Descripcion Modulo 49:  Sp que genera el producto JPM_CCS_CADUSD_[yyyymmdd].TXT  
---------------------------------------------------------------------------------------  
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;49  
 @txtDate AS DATETIME  
  
AS  
 BEGIN  
   
  SET NOCOUNT ON  
   
  DECLARE @tmpLayoutxlCurve TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
   SELECT   
    1,   
    'Fecha' + CHAR(9) + 'Plazo' + CHAR(9) + 'EURIBOR'  
      
  INSERT @tmpLayoutxlCurve (Columna,txtData)  
   SELECT  
    2,   
    LTRIM(intTerm) + CHAR(9) +  
    LTRIM(STR(dblRate,19,10))  
   FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
   WHERE dteDate = @txtDate   
    AND txtType = 'LCD'  
    AND txtSubtype = 'MED'  
    
   -- Valida la información   
 IF ((SELECT count(*) FROM @tmpLayoutxlCurve) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT   
   txtData  
  FROM @tmpLayoutxlCurve  
  WHERE  
   Columna > 1  
  
  SET NOCOUNT OFF  
  
END  
  
----------------------------------------------------------------------------------------  
--   Autor:      Mike Ramirez  
--   Fecha Creacion:   11:47 2013-04-24  
--   Descripcion Modulo 50:  Proceso que genera el producto Curva_CCSYL[yyyymmdd].csv          
----------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;50  
  @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
   
   DECLARE @tmp_tblResult TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT   
    1,   
    'Fecha,Nodos,Yen/Libor'  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT  
    2,  
    REPLACE(CONVERT(CHAR(10),dteDate,105),'-','') + ',' +   
    LTRIM(intTerm) + ',' +  
    LTRIM(STR(dblRate,19,10))  
   FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
   WHERE dteDate = @txtDate   
    AND txtType = 'LJS'  
    AND txtSubtype = 'CCS'   
       
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResult) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT  
   txtData  
  FROM @tmp_tblResult  
  
  SET NOCOUNT OFF  
  
END  
  
-------------------------------------------------------------------------------------  
--   Autor:      Mike Ramirez  
--   Fecha Creacion:   14:47 2013-04-24  
--   Descripcion Modulo 51:  Proceso que genera el producto Curva_LC[yyyymmdd].csv          
-------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;51  
  @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
    
   DECLARE @tmp_tblResult TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT   
    1,   
    'Fecha,Nodos,Libor Canada'  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT  
    2,  
    REPLACE(CONVERT(CHAR(10),dteDate,105),'-','') + ',' +   
    LTRIM(intTerm) + ',' +  
    LTRIM(STR(dblRate,19,10))  
   FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
   WHERE dteDate = @txtDate   
    AND txtType = 'LIB'  
    AND txtSubtype = 'CAD'   
       
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResult) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT  
   txtData  
  FROM @tmp_tblResult  
  
  SET NOCOUNT OFF  
  
END  
  
-------------------------------------------------------------------------------------  
--   Autor:      Mike Ramirez  
--   Fecha Creacion:   15:03 2013-04-24  
--   Descripcion Modulo 52:  Proceso que genera el producto Curva_LY[yyyymmdd].csv          
-------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;52  
  @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
    
   DECLARE @tmp_tblResult TABLE (  
    Columna INT,  
    txtData VARCHAR(8000))  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT   
    1,   
    'Fecha,Nodos,Libor Yen'  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT  
    2,  
    REPLACE(CONVERT(CHAR(10),dteDate,105),'-','') + ',' +   
    LTRIM(intTerm) + ',' +  
    LTRIM(STR(dblRate,19,10))  
   FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
   WHERE dteDate = @txtDate   
    AND txtType = 'LIB'  
    AND txtSubtype = 'JPY'   
       
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResult) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT  
   txtData  
  FROM @tmp_tblResult  
  
  SET NOCOUNT OFF  
  
END  
  
-------------------------------------------------------------------------------------------  
--   Autor:      Mike Ramirez  
--   Fecha Creacion:   15:20 2013-07-25  
--   Descripcion Modulo 53:  Proceso que genera el producto JPPFwd_MXN_JPY[yyyymmdd].CSV          
-------------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;53  
  @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
   
 DECLARE @dblJPY AS FLOAT  
    
 DECLARE @tmp_tblResult TABLE (  
   Columna INT,  
   txtData VARCHAR(8000))  
  
  SET @dblJPY = (SELECT dblValue FROM MxFixIncome.dbo.tblIrc (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'JPY')  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT   
    1,   
    'TC SPOT MXN/JPY' + ',' + LTRIM(RTRIM(STR(ROUND(@dblJPY,5),8,5)))  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT  
    2,   
    LTRIM(intTerm) + ',' +  
    LTRIM(STR(dblRate,19,10))  
   FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
   WHERE dteDate = @txtDate   
    AND txtType = 'FPC'  
    AND txtSubtype = 'MJP'   
       
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResult) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT  
   txtData  
  FROM @tmp_tblResult  
  
  SET NOCOUNT OFF  
  
END  
  
--------------------------------------------------------------------------------------------  
--   Autor:      Mike Ramirez  
--   Fecha Creacion:   15:20 2013-07-25  
--   Descripcion Modulo 54:  Proceso que genera el producto JPPFwd_MXN_CAD_[yyyymmdd].csv          
--------------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;54  
  @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
   
 DECLARE @dblCAD AS FLOAT  
    
 DECLARE @tmp_tblResult TABLE (  
   Columna INT,  
   txtData VARCHAR(8000))  
  
  SET @dblCAD = (SELECT dblValue FROM MxFixIncome.dbo.tblIrc (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'CAD')  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT   
    1,   
    'TC SPOT MXN/CAD' + ',' + LTRIM(RTRIM(STR(ROUND(@dblCAD,5),8,5)))  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT  
    2,   
    LTRIM(intTerm) + ',' +  
    LTRIM(STR(dblRate,19,10))  
   FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
   WHERE dteDate = @txtDate   
    AND txtType = 'FPC'  
    AND txtSubtype = 'MCA'   
       
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResult) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT  
   txtData  
  FROM @tmp_tblResult  
  
  SET NOCOUNT OFF  
  
END  
  
--------------------------------------------------------------------------------------------  
--   Autor:      Mike Ramirez  
--   Fecha Creacion:   15:20 2013-07-25  
--   Descripcion Modulo 55:  Proceso que genera el producto JPPFwd_MXN_CHF_[yyyymmdd].csv          
--------------------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_JPMORGAN;55  
  @txtDate AS DATETIME  
AS     
BEGIN    
  
 SET NOCOUNT ON  
   
 DECLARE @dblCHF AS FLOAT  
    
 DECLARE @tmp_tblResult TABLE (  
   Columna INT,  
   txtData VARCHAR(8000))  
  
  SET @dblCHF = (SELECT dblValue FROM MxFixIncome.dbo.tblIrc (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'CHF')  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT   
    1,   
    'TC SPOT MXN/CHF' + ',' + LTRIM(RTRIM(STR(ROUND(@dblCHF,5),8,5)))  
  
  INSERT @tmp_tblResult (Columna,txtData)  
   SELECT  
    2,   
    LTRIM(intTerm) + ',' +  
    LTRIM(STR(dblRate,19,10))  
   FROM MxFixIncome.dbo.tblCurves (NOLOCK)  
   WHERE dteDate = @txtDate   
    AND txtType = 'FPC'  
    AND txtSubtype = 'MCH'   
       
 -- Valida la información   
 IF ((SELECT count(*) FROM @tmp_tblResult) <= 1)  
  
 BEGIN  
  RAISERROR ('ERROR: Falta Informacion', 16, 1)  
 END  
  
 ELSE  
  
  SELECT  
   txtData  
  FROM @tmp_tblResult  
  
  SET NOCOUNT OFF  
  
END  