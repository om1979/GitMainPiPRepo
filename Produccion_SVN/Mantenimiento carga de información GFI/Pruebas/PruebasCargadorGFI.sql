



--select * from tmp_tblHECHOSGFI
--"sp_inputs_brokers;47 '[FORMAT(TODAY, YYYYMMDD)]'"

--select * from tmp_tblPosturasGFI
--"sp_inputs_brokers;46 '[FORMAT(TODAY, YYYYMMDD)]'"


--helptextxmodulo sp_inputs_brokers,46

select * from  MxProcesses .dbo.tblprocessparameters
where txtProcess like '%gfi%'


  
    
    
    
    
/*    
-----------------------------------------------------------------------------------      
Modificado por:   Mike Ramirez      
Modificacion:   20141104      
Descripcion Mod 47:  Restringir cuando el tipo de operación no este definido      
    
Modifica: Omar Adrian Aceves Gutierrez    
Fecha:  2014-12-04 20:03:05.430    
Descripcion:Se agregan validaciones y candados para validar plazos si es un hecho la hora de fin y de inicio sera la misma     
-----------------------------------------------------------------------------------         
*/    
    
    
   --
   
   --select * from tblIds
   --where txtTV = 'M'
   --and 
    
----CREATE    PROCEDURE [dbo].[sp_inputs_brokers];47            
--declare @dtedate char(10)       = '20150505'      
            
----AS             
----BEGIN       
---- SET NOCOUNT ON          
     
     
--   DECLARE @intBroker AS INT            
            
--SET @intBroker = (            
--     SELECT       
--      intIdBroker            
--     FROM itblBrokerCatalog            
--     WHERE            
--      txtBroker LIKE '%GFI%'      
--     )            
         
--     ------Elimina Registros Previos-------------------------------------             
--   --       DELETE       
--   --itblMarketPositions            
--   --WHERE intIdBroker = 13            
--   -- AND dteDate = @dtedate            
--   -- AND txtOperation = 'HECHO'       
      
--------Carga de Hechos-------------------------------------             
-- SELECT             
--   t.intLine,       
--   i.txtID1,            
--   CONVERT(DATETIME,t.txtFecha,111) as DteDate,            
--   t.txtHoraIni,      
--    CASE   --si se trata de un hecho dejamos la hr de fin = a la hr de Inicio         
--     WHEN t.txtIndicator = 'H' THEN    t.txtHoraIni        
--     WHEN t.txtIndicator = 'T' THEN    t.txtHoraIni        
--   ELSE t.txtHoraFin           
--   END AS txtHoraFin  ,-- SI NO SE MANTIENE HR ORIGINAL    
--   datediff(s,t.txtHoraIni,t.txtHoraFin) as Duration,            
--   CASE            
--     WHEN t.txtIndicator = 'H' THEN 'HECHO'            
-- WHEN t.txtIndicator = 'T' THEN 'HECHO'            
--   ELSE t.txtIndicator            
--   END AS txtIndicator,            
--   CAST(t.txtSize as FLOAT)as dblamount,            
--   t.dblrate,            
--   t.txtInsName,            
--   t.txtInsID,            
--   CASE            
--   WHEN t.txtInsName = 'CETES' then SUBSTRING(t.txtInsId,1,2)            
--    WHEN t.txtInsName = 'BONOS' then SUBSTRING(t.txtInsId,1,1)            
--    WHEN t.txtInsName = 'BONDESD' then SUBSTRING(t.txtInsId,1,2)            
--    WHEN t.txtInsName = 'BPA182' then SUBSTRING(t.txtInsId,1,2)            
--    WHEN t.txtInsName = 'UDIBONO' then SUBSTRING(t.txtInsId,1,1)            
--    WHEN t.txtInsName = 'BPAG182' then SUBSTRING(t.txtInsId,1,2)            
--    WHEN t.txtInsName = 'BPAG91' then SUBSTRING(t.txtInsId,1,2)              WHEN t.txtInsName = 'BPAG28' then SUBSTRING(t.txtInsId,1,2)            
--   ELSE txtInsID            
--   END AS txttv,            
--   CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN            
--    CAST(SUBSTRING(t.txtMatDate,1,CHARINDEX('-',t.txtMatDate)-1) AS INT)            
--   ELSE            
--    CAST(t.txtMatDate AS INT)            
--   END AS intInicio,                CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN            
--    CAST(SUBSTRING(t.txtMatDate,CHARINDEX('-',t.txtMatDate)+1,LEN(RTRIM(t.txtMatDate))-CHARINDEX('-',t.txtMatDate)) AS INT)            
--   ELSE       
--    CAST(t.txtMatDate AS INT)            
-- END AS intFin,            
--   DATEDIFF(DAY,GETDATE(),p.dteMaturity)  as txtplazo,            
--   t.txtSetDate as txtliquidation,            
--   t.txtRestriction            
-- INTO #tblInputsGFI            
-- FROM tmp_tblHechosGFI as t            
-- INNER JOIN tblids as i          
-- ON       
--  ltrim (rtrim(txttv))+'_'+ltrim (rtrim(txtemisora))+'_'+ltrim (rtrim(txtserie)) = SUBSTRING(CAST(t.txtinsID AS VARCHAR), 1, CHARINDEX( ' ',t.txtinsID)-1)            
-- INNER JOIN mxfixincome..tblBonds  as p            
-- ON       
--  i.txtID1 = p.txtID1            
-- WHERE              
--  t.txtSize <=100000000000      
--  AND t.txtFecha = @dtedate       
--   AND 1 = CASE /*validamos que este contenido el tipo de valor en =Liq 48 o que tv= LD sea liq = MD */    
--    WHEN i.txtTV IN ('BI','M','S','LD','IM','IQ','IS','IT' ) AND t.txtSetDate = '48' THEN 1    
--    WHEN i.txtTV IN ('LD') AND t.txtSetDate = 'MD'THEN 1  END        
--    AND DATEDIFF(mi,t.txtHoraIni,t.txtHoraFin)>=1        
-- ORDER BY 1            
     
     
     
--  --INSERT itblMarketPositions  (dteDate,intIdBroker,intLine,intPlazo,txtTv,txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)          
--    SELECT DISTINCT             
--   dteDate,            
--   @intBroker,            
--   intLine,            
--   txtplazo,   
--   txtTv,            
--   txtindicator,            
--   dblRate,            
--   dblAmount,            
--   txtHoraIni,            
--   txtHoraFin,            
--   txtLiquidation            
--   FROM #tblInputsGFI            
--   WHERE      
--    txtIndicator <> ''      
             
  --SET NOCOUNT OFF            
      
--END      
        
    
            
  /*
 OBTENEMOS PLAZOS DE CASO
		 --select * from #tblranges     
		 --  where txtIns in('bi_cetes_150611','bi_cetes_150618','bi_cetes_150625')
        
 obtenemos los identificadores que son considerados por diferencia de tiempo
				   ------------------Rangos Finales Consolidados--------------------------          
				SELECT   DATEDIFF(HH,txtHoraIni,txtHoraFin), *
			   --p.txtID1,          
			   --p.txtTV,          
			   --p.txtEmisora,          
			   --p.txtSerie,          
			   --p.txtIns,          
			   --p.txtPlazo          
				-- INTO #tblrangesFinal          
				 FROM #tblranges AS p      
				 INNER JOIN tmp_tblPosturasGFI AS g          
				 ON           
				p.txtEmisora = g.txtInsName          
				 INNER JOIN tblBonds AS b          
				 ON          
			   p.txtId1 = b.txtId1          
				 LEFT OUTER JOIN #tblOpRango AS o          
				 ON          
			   p.txtEmisora = o.txtinsname          
				 WHERE        
			   g.txtMatDate like '%-%'       
				  --AND  P.txtIns = 'bi_cetes_150611'
			AND G.intLine = 290
			   AND p.txtPlazo BETWEEN o.intInicio AND o.intFin    
			   AND  txtIns NOT IN ('bi_cetes_150611','bi_cetes_150618','bi_cetes_150625')      
			     


  */
 

/*tabla temp*/ 
-- select * from  tmp_tblPosturasGFI
--select * into  tmp_tmp_tblPosturasGFI_oaceves from tmp_tblPosturasGFI
      
     
/*      
GFI_POSTURAS      
      
Modifica: Omar Adrian Aceves Gutierrez      
Fecha:  2014-12-04 20:03:05.430      
Descripcion:Se agregan validaciones y candados para validar plazos si es un hecho la hora de fin y de inicio sera la misma   
-----------------------------------------------------------------------------------           
*/      
 --CREATE    PROCEDURE [dbo].[sp_inputs_brokers];46          
declare @dtedate char(10)       = '20150505'            
           
 --AS           
 --BEGIN          
 --SET NOCOUNT ON    
      
      
 /*ACTUALIZAMOS TABLA NULOS SE ASIGNA HR DE CIERRE*/      
 --UPDATE GFI      
 --SET txtHoraFin =  ISNULL(txtHoraFin,'14:00:00')       
 --FROM  tmp_tblPosturasGFI AS GFI      
      
      
   DECLARE           
    @intBroker AS INT ,          
    @txtemisora varchar(10),          
    @IntRange int ,          
  @FinRange int          
           
   ----- obtengo el ID del broker           
   SET @intBroker = (          
    SELECT intIdBroker          
    FROM itblBrokerCatalog          
    WHERE     
  txtBroker LIKE '%GFI%'          
   )           
 --------------Depuro Información Tablas Temporales-----------------             
   --DELETE           
   -- itblMarketPositions           
   --WHERE           
   -- intIdBroker = 13          
   -- AND dteDate = @dtedate          
   -- AND txtOperation <> 'HECHO'          
           
------------------Reviso que existan operaciones en Rango--------------------------          
    SELECT           
   t.txtinsname ,   t.txtMatDate,    
   CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN          
    CAST(SUBSTRING(t.txtMatDate,1,CHARINDEX('-',t.txtMatDate)-1) AS INT)          
   ELSE         
    CAST(t.txtMatDate AS INT)          
   END AS intInicio,          
   CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN          
    CAST(SUBSTRING(t.txtMatDate,CHARINDEX('-',t.txtMatDate)+1,LEN(RTRIM(t.txtMatDate))-CHARINDEX('-',t.txtMatDate)) AS INT)       
   ELSE          
    CAST(t.txtMatDate AS INT)          
   END AS intFin          
   -- INTO #tblOpRango           
    FROM tmp_tblPosturasGFI AS t          
    WHERE           
  txtMatDate like '%-%'  
 
--SELECT * FROM #tblOpRango  
  
   --  intLine	txtFecha	txtHoraIni	txtHoraFin	txtIndicator	txtSize	dblrate	txtInsName	txtInsID	txtMatDate	txtSetDate	txtRestriction
--290	20150505	11:58:16	14:00:00	B	100000000      	3.09	CETES          	BI_CETES_003 30-50 48    	30-50     	48	     
       
             
           --declare @dtedate char(10)       = '20150505'            
          declare @dtedate char(10)       = '20150505'  
          
          
          --!!!los calculos de los plazos son correctos !!!
------------------Busca Operaciones Esten Dentro de los Rangos--------------------------          
    SELECT          
   i.txtID1,          
   i.txtTV,          
   i.txtEmisora,          
   i.txtSerie,          
   LTRIM(RTRIM(txttv))+'_'+LTRIM(RTRIM(txtemisora))+'_'+LTRIM(RTRIM(txtserie)) AS txtIns,          
   DATEDIFF(d,@dtedate,b.dteMaturity) as txtplazo  ,
   null      as txtIns  
    --INTO #tblranges          
      FROM MxFixIncome..tblIds AS i          
      INNER JOIN tblbonds AS b          
      ON  i.txtID1 = b.txtID1   
      where i.txtEmisora IN ( SELECT txtInsname FROM #tblOpRango ) 
    
      
      select b.*
      ,a.txtInsID
      ,a.txtSetDate,
      case when a.txtSetDate = 48 then b.intInicio -2  else  b.intInicio end as txtInicioArrange,
       case when a.txtSetDate = 48 then b.intFin -2  else  b.intFin end as txtFinalArrange
      into #getdata
      from tmp_tblPosturasGFI as A
      inner join #tblOpRango     as B
      on a.intline = b.intline
      
      select * from #tblranges as A
      inner join #getdata as B
      on a.txtplazo -2 = b.txtInicioArrange
      
      
      
      
      
          select * from tmp_tblPosturasGFI
    i.txtEmisora IN ( SELECT txtInsname FROM #tblOpRango ) 
    
    
   SELECT * FROM #tblOpRango
   
   SELECT * FROM #tblranges    
   WHERE TXTPLAZO IN ( 
'30',
'58',
'65',
'72',
'79',
'86',
'93'
)


------------------Rangos Finales Consolidados--------------------------  

--!!!! se encuentra que hay posturas con niveles para la linia 290 diferentes de       bi_cetes_150611, bi_cetes_150618, bi_cetes_150625.
--porque esta mal si la diferencia de tiempos es mayor a un minuto?
  
    SELECT
   p.txtID1,          
   p.txtTV,          
   p.txtEmisora,          
   p.txtSerie,          
   p.txtIns,          
   p.txtPlazo          
    -- INTO #tblrangesFinal          
     FROM #tblranges AS p      
     INNER JOIN tmp_tblPosturasGFI AS g          
     ON           
    p.txtEmisora = g.txtInsName          
     INNER JOIN tblBonds AS b          
     ON          
   p.txtId1 = b.txtId1          
     LEFT OUTER JOIN #tblOpRango AS o          
     ON          
   p.txtEmisora = o.txtinsname          
     WHERE        
   g.txtMatDate like '%-%'       
   AND p.txtPlazo BETWEEN o.intInicio AND o.intFin    
   
   
   --SELECT * FROM #tblrangesFinal
   --SELECT DATEDIFF(HH,'11:58:16','14:00:00')
   --11:58:16	14:00:00
   
           
------------------Asigno Valores a Instrumentos en el Rango--------------------------          
    SELECT        DISTINCT    
   t.intLine, 
   --R.TXTINS,--OACEVES         
   t.txtFecha AS dteDate,          
   t.txtHoraIni,          
   t.txtHoraFin,          
   DATEDIFF(s,t.txtHoraIni,t.txtHoraFin) AS Duration,          
   CASE          
    WHEN t.txtIndicator = 'O' THEN 'VENTA'          
    WHEN t.txtIndicator = 'B' THEN 'COMPRA'          
    ELSE t.txtIndicator          
   END AS txtIndicator,          
   CAST(t.txtSize AS FLOAT) AS dblamount,        
   t.dblrate,          
   t.txtInsName,          
   t.txtInsID,          
   CASE          
    WHEN t.txtInsName = 'CETES' THEN SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'BONOS' THEN SUBSTRING(t.txtInsId,1,1)          
    WHEN t.txtInsName = 'BONDESD' THEN SUBSTRING(t.txtInsId,1,2)     
    WHEN t.txtInsName = 'BPA182' THEN SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'UDIBONO' THEN SUBSTRING(t.txtInsId,1,1)          
    WHEN t.txtInsName = 'BPAG182' THEN SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'BPAG91' THEN SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'BPAG28' THEN SUBSTRING(t.txtInsId,1,2)          
    ELSE txtInsID          
   END AS txttv,          
   r.txtplazo,          
   t.txtSetDate AS txtliquidation,          
   t.txtRestriction ,       
   t.txtMatDate  
    --INTO #tblOpFinal          
     FROM tmp_tblPosturasGFI AS t          
    INNER JOIN #tblrangesFinal AS r          
     ON           
   r.txtEmisora = t.txtInsName          
     WHERE           
   txtMatDate LIKE '%-%'      
   --AND r.txtplazo  IN ('37','51','44') --OACEVES 
   --AND t.intLine =290 --OACEBES
   and convert(int, r.txtplazo) -2 >=
   CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 
   THEN  CAST(SUBSTRING(t.txtMatDate,1,CHARINDEX('-',t.txtMatDate)-1) AS INT)     
    ELSE         CAST(t.txtMatDate AS INT)          END 
   and  convert(int, r.txtplazo) -2 <= CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN          
    CAST(SUBSTRING(t.txtMatDate,CHARINDEX('-',t.txtMatDate)+1,LEN(RTRIM(t.txtMatDate))-CHARINDEX('-',t.txtMatDate)) AS INT)       
  ELSE          
    CAST(t.txtMatDate AS INT)          
   END 
    
   --drop table #tblOpFinal
   
   
    
   --and           
   --CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN          
   -- CAST(SUBSTRING(t.txtMatDate,CHARINDEX('-',t.txtMatDate)+1,LEN(RTRIM(t.txtMatDate))-CHARINDEX('-',t.txtMatDate)) AS INT)       
   --ELSE          
   -- CAST(t.txtMatDate AS INT)          
   --END AS intFin          
   
   
   select * from #tblOpFinal  
 where intline = 290 
AND  TXTPLAZO NOT IN ('37','51','44'
           
 ------------------Inserta operaciones en Rango--------------------------          
    -- INSERT itblMarketPositions  (dteDate,intIdBroker,intLine,intPlazo,txtTv,txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)        
     SELECT DISTINCT           
   dteDate,          
   13,     
   intLine,          
   txtplazo,         txtTv,          
   txtindicator,          
   dblRate,          
   dblAmount,          
   txtHoraIni,          
   case when txtHoraFin is null then txtHoraIni else txtHoraFin end ,     
   txtLiquidation          
   FROM #tblOpFinal          
           
 ------Operaciones en Plazo-------------------------------------           
       
    SELECT           
   t.intLine,          
   i.txtID1,          
   CONVERT(DATETIME,t.txtFecha,112) AS DteDate,          
   t.txtHoraIni,          
   t.txtHoraFin,          
   DATEDIFF(s,t.txtHoraIni,t.txtHoraFin) AS Duration,          
   CASE          
    WHEN t.txtIndicator = 'O' THEN 'VENTA'          
    WHEN t.txtIndicator = 'B' THEN 'COMPRA'    
    ELSE t.txtIndicator          
   END AS txtIndicator,          
   CAST(t.txtSize AS FLOAT) AS dblamount,          
   t.dblrate,          
   t.txtInsName,          
     t.txtInsID,          
   CASE          
    WHEN t.txtInsName = 'CETES' then SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'BONOS' then SUBSTRING(t.txtInsId,1,1)          
    WHEN t.txtInsName = 'BONDESD' then SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'BPA182' then SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'UDIBONO' then SUBSTRING(t.txtInsId,1,1)          
    WHEN t.txtInsName = 'BPAG182' then SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'BPAG91' then SUBSTRING(t.txtInsId,1,2)          
    WHEN t.txtInsName = 'BPAG28' then SUBSTRING(t.txtInsId,1,2)          
    ELSE txtInsID          
   END AS txttv,          
   CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN          
    CAST(SUBSTRING(t.txtMatDate,1,CHARINDEX('-',t.txtMatDate)-1) AS INT)          
   ELSE          
   CAST(t.txtMatDate AS INT)          
   END AS intInicio,          
    CASE WHEN CHARINDEX('-',t.txtMatDate) > 0 THEN          
    CAST(SUBSTRING(t.txtMatDate,CHARINDEX('-',t.txtMatDate)+1,LEN(RTRIM(t.txtMatDate))-CHARINDEX('-',t.txtMatDate)) AS INT)        
   ELSE          
   CAST(t.txtMatDate AS INT)          
   END AS intFin,          
   DATEDIFF(DAY,@dtedate,P.dteMaturity) as txtplazo,        
   t.txtSetDate as txtliquidation,          
   t.txtRestriction      
       INTO #tblInputsGFI          
     FROM tmp_tblPosturasGFI AS t          
      INNER JOIN tblids AS i          
      ON           
    LTRIM(RTRIM(txttv))+'_'+LTRIM(RTRIM(txtemisora))+'_'+LTRIM(RTRIM(txtserie)) = SUBSTRING(CAST(t.txtinsID AS VARCHAR), 1, CHARINDEX( ' ',t.txtinsID)-1)          
      INNER JOIN mxfixincome..tblBonds AS p          
      ON i.txtID1 = p.txtID1               
      WHERE  t.txtSize <=100000000000          
      AND t.txtFecha =  @dtedate        
      AND 1 = CASE   /*validamos que este contenido el tipo de valor en =Liq 48 o que tv= LD sea liq = MD */      
       WHEN i.txtTV IN ('BI','M','S','LD','IM','IQ','IS','IT' ) AND t.txtSetDate = '48' THEN 1      
       WHEN i.txtTV IN ('LD') AND t.txtSetDate = 'MD'THEN 1  END          
       AND DATEDIFF(mi,t.txtHoraIni,t.txtHoraFin)>=1                  
    ORDER BY 1        
   
   --select * from #tblInputsGFI 
   --where txtInsID like '%150611%'
   
   --where txtInsName = 'CETES'
    
        
 ----------------------Inserta operaciones en Plazo--------------------------          
 --   INSERT itblMarketPositions  (dteDate,intIdBroker,intLine,intPlazo,txtTv,txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)        
  SELECT DISTINCT           --293
   dteDate,          
   @intBroker,          
   intLine,          
   txtplazo,          
   txtTv,          
 txtindicator,          
   dblRate,          
   dblAmount,          
   txtHoraIni,          
   case when txtHoraFin is null then txtHoraIni else txtHoraFin end ,          
   txtLiquidation ,
   txtInsID         
  FROM #tblInputsGFI          
          
 -- SET NOCOUNT OFF          
    
 --END   
        
        
        
