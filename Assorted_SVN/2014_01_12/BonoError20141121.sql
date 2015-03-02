





--SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
--WHERE txtValue LIKE '%MEI_H%'


SELECT * FROM  MxProcesses..tblProcessParameters
WHERE txtProcess = 'MEI_H'


SELECT * FROM  tmp_tblMEIHechos

SELECT * FROM  

    
      
--CREATE   PROCEDURE [dbo].[sp_inputs_brokers];19      
DECLARE  @txtMDDate  AS CHAR(10)='20141112'     
DECLARE  @txt24Date  AS CHAR(10)='20141113'  
DECLARE  @txt48Date  AS CHAR(10)='20141114'   
DECLARE  @txt72Date  AS CHAR(10)='20141118'
DECLARE  @txt96Date  AS CHAR(10)='20141119'
      
--AS       
/*       
 Autor:   ???      
 Creacion:  ???      
 Descripcion: Carga los hechos de MEI      
        
 Modificado por: CSOLORIO      
 Modificacion: 20110525      
 Descripcion:    Ajuste por cambio en insumo      
*/      
--BEGIN      
      
      
      
      
 SET NOCOUNT ON      
 
    DECLARE  @txtMDDate  AS CHAR(10)='20141112'     
DECLARE  @txt24Date  AS CHAR(10)='20141113'  
DECLARE  @txt48Date  AS CHAR(10)='20141114'   
DECLARE  @txt72Date  AS CHAR(10)='20141118'
DECLARE  @txt96Date  AS CHAR(10)='20141119'
        
      
       
 --- Primea tabla Temporal      
 SELECT CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteDate,      
  CONVERT(DATETIME,SUBSTRING(txtDate,1,10)) AS dteLiquidacion,      
  CASE WHEN txtPlazo = 0 THEN      
   SUBSTRING(txtInstrumento,CHARINDEX(' ',txtInstrumento)+1,      
    (CHARINDEX(' ',txtInstrumento,CHARINDEX(' ',txtInstrumento)+1)-1)-CHARINDEX(' ',txtInstrumento))      
  ELSE      
   txtPlazo      
  END AS txtPlazo,      
  MxFixIncome.dbo.fun_Split(txtInstrumento,' ',1) AS txtInstrumento,      
  txtLiquidacion,       
  CASE WHEN txtOperacion = 'VENTA' THEN      
   'HECHO'      
  ELSE      
   'HECHO'      
  END AS txtOperacion,       
  CAST(txtMonto AS FLOAT) AS dblMonto,       
  CAST(txtTasa AS FLOAT) AS dblTasa,       
  DATEADD(DAY,DATEDIFF(DAY,CAST(CAST(txtHora AS FLOAT) AS DATETIME),'1900-01-01 00:00:00.000'),CAST(CAST(txtHora AS FLOAT) AS DATETIME)) AS dteHora,      
  (txtDate+txtPlazo+txtInstrumento+txtLiquidacion+txtOperacion+txtMonto+txtTasa+txtHora) AS txtGarbage      
 INTO #tblMeiHechosTemp       
 FROM tmp_tblMEIHechos     
 
       
 SELECT dteDate,      
  dteLiquidacion,      
  txtLiquidacion,      
  5 AS intBroker,      
  CASE WHEN CHARINDEX('-',txtPlazo,1) > 0 THEN      
   CAST(SUBSTRING(txtPlazo,1,CHARINDEX('-',txtPlazo,1)-1) AS INT)      
  ELSE         CAST(txtPlazo AS INT)      
  END AS intInicio, 
       
  CASE WHEN CHARINDEX('-',txtPlazo,1) > 0 THEN      
   CAST(SUBSTRING(txtPlazo,CHARINDEX('-',txtPlazo,1)+1,LEN(txtPlazo)-CHARINDEX('-',txtPlazo,1)) AS INT)      
  ELSE     
 
   CAST(txtPlazo AS INT)     
  END AS intFin,
   SUBSTRING(txtPlazo,1,4) ,
    
    txtPlazo
--LEN(txtPlazo),
  
  
  
  --txtInstrumento,      
  --txtOperacion,       
  --dblMonto,       
  --dblTasa,      
  --dteHora,      
  txtGarbage      
 --INTO #tblMeiHechos      
 FROM #tblMeiHechosTemp      
 WHERE txtLiquidacion IN ('48','24')
 AND txtGarbage = '2014-11-12 01:07:22 p.m.2943AMX 112248Compra300000006.6541955.5467824074'
 
 
 
 
 
 
 SELECT * FROM  #tblMeiHechosTemp
 --- Actualizamos las dos tablas      
 UPDATE #tblMeiHechos SET dteLiquidacion =@txtMDDate WHERE txtLiquidacion = 'MD'      
 UPDATE #tblMeiHechos SET dteLiquidacion =@txt24Date WHERE txtLiquidacion = '24'      
 UPDATE #tblMeiHechos SET dteLiquidacion =@txt48Date WHERE txtLiquidacion = '48'      
 UPDATE #tblMeiHechos SET dteLiquidacion =@txt72Date WHERE txtLiquidacion = '72'      
 UPDATE #tblMeiHechos SET dteLiquidacion =@txt96Date WHERE txtLiquidacion = '96'       
       
 ----- elimino los registros de la tabla destino      
 --DELETE      
 --FROM itblMarketPositions      
 --WHERE      
 -- dteDate = @txtMDDate      
 -- AND intIdBroker = 5      
 -- AND txtOperation NOT IN ('COMPRA','VENTA')      
 -- AND TXTTV <> 'LD'      
       
 --- Insertamos en el destino      
      
 -- JATO (09:40 a.m. 2007-05-18)      
 -- bonos      
 
   DECLARE  @txtMDDate  AS CHAR(10)='20141112'     
DECLARE  @txt24Date  AS CHAR(10)='20141113'  
DECLARE  @txt48Date  AS CHAR(10)='20141114'   
DECLARE  @txt72Date  AS CHAR(10)='20141118'
DECLARE  @txt96Date  AS CHAR(10)='20141119'
        
      
 SELECT  DISTINCT
 b.dteMaturity,m.dteLiquidacion,
    DATEDIFF(DAY,m.dteLiquidacion,b.dteMaturity)'||' , m.intFin, 
  m.dteDate,      
  m.intBroker,      
  -999 AS intLine,      
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,      
  i.txtTv,      
  m.txtOperacion,      
  m.dblTasa,      
  m.dblMonto,      
  m.dteHora,      
  m.dteHora AS dteHoraFin,      
  m.txtLiquidacion,      
  m.txtGarbage      
 --INTO #itblMarketPositionsTempH      
 FROM #tblMeiHechos AS m,      
  tblIds AS i INNER JOIN tblBonds AS b      
  ON b.txtId1 = i.txtId1    
  
    
 WHERE i.txtTv IN ('M','M0','M3','M5','M7')
   
 AND m.txtInstrumento NOT IN ('G2','G3','IP','P8','UD','XA','CB','BI')  
 AND  b.dteMaturity > @txtMDDate  
     
 AND DATEDIFF(DAY,m.dteLiquidacion,b.dteMaturity) >= m.intInicio  
   AND dblTasa = 6.65    
       
       
       
       
       
 AND DATEDIFF(DAY,m.dteLiquidacion,b.dteMaturity) <= m.intFin      
    
       
       SELECT * FROM  #tblMeiHechos
       
       SELECT * FROM  #itblMarketPositionsTempH
       
       
       
 UNION      
      
 -- JATO (09:40 a.m. 2007-05-18)      
 -- cetes   
  
   
       
 SELECT  DISTINCT      
  m.dteDate,      
  m.intBroker,      
  -999 AS intLine,      
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,      
  i.txtTv,      
  m.txtOperacion,      
  m.dblTasa,      
  m.dblMonto,      
  m.dteHora,      
  m.dteHora AS dteHoraFin,      
  m.txtLiquidacion,      
  m.txtGarbage      
 FROM #tblMeiHechos AS m,      
  tblIds AS i INNER JOIN tblBonds AS b     
  ON b.txtId1 = i.txtId1      
 WHERE i.txtTv IN ('BI')      
 AND m.txtInstrumento IN ('BI')      
 AND  b.dteMaturity > @txtMDDate      
 AND DATEDIFF(DAY,m.dteLiquidacion,b.dteMaturity) >= m.intInicio        
 AND DATEDIFF(DAY,m.dteLiquidacion,b.dteMaturity) <= m.intFin      
      
UNION      
      
 -- JATO (09:40 a.m. 2007-05-18)      
 -- reales   
 

      
 SELECT  DISTINCT      
  m.dteDate,      
  m.intBroker,      
  -999 AS intLine,      
  DATEDIFF(day,@txtMDDate,b.dteMaturity) AS intPlazo,      
  i.txtTv,      
  m.txtOperacion,      
  m.dblTasa,      
  m.dblMonto,      
  m.dteHora,      
  m.dteHora AS dteHoraFin,      
  m.txtLiquidacion,      
  m.txtGarbage      
 FROM #tblMeiHechos AS m,      
  tblIds AS i INNER JOIN tblBonds AS b      
  ON b.txtId1 = i.txtId1      
 WHERE i.txtTv IN ('S','S0','PI','2U')      
 AND m.txtInstrumento IN ('UD', 'CB')      
 AND  b.dteMaturity > @txtMDDate      
 AND DATEDIFF(DAY,m.dteLiquidacion,b.dteMaturity) >= m.intInicio        
 AND DATEDIFF(DAY,m.dteLiquidacion,b.dteMaturity) <= m.intFin      
      
 ORDER BY      
  m.dteHora      
      
 INSERT itblMarketPositions  (dteDate,intIdBroker,intLine,intPlazo,txtTv,txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)  
 SELECT DISTINCT      
  dteDate,      
  intBroker,      
  intLine,      
  intPlazo,      
  txtTv,      
  txtOperacion,      
  dblTasa,      
  dblMonto,      
  dteHora,      
  dteHoraFin,      
  txtLiquidacion      
 FROM #itblMarketPositionsTempH      
      
 SET NOCOUNT OFF      
      
END   
  
  
  
  SELECT * FROM  itblMarketPositions
  WHERE dteDate = '20141112'
  AND txtplazo  = ''