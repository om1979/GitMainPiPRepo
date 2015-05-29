
      
      
      select * from  tblprocessparameters 
      where  txtprocess like '%gfi%'

/*      
GFI_POSTURAS      
      
Modifica: Omar Adrian Aceves Gutierrez      
Fecha:  2014-12-04 20:03:05.430      
Descripcion:Se agregan validaciones y candados para validar plazos si es un hecho la hora de fin y de inicio sera la misma   

Modifica:		Omar Adrian Aceves Gutierrez  
Fecha:		2015-05-14 10:02:05.943
Objetico:		que considera los siguientes cambios:
				1-las posturas se establecen dentro de sus rangos correctos
				2-el rango 70-94 es cambiado a [70-90] 
				3- las posturas que entren en mas de 1 rango serán duplicadas para todos los 
				ejemplo (Un plazo 70 entra en 2 rangos [50-70] y [70-94])
-----------------------------------------------------------------------------------           
*/      
 ALTER      PROCEDURE [dbo].[sp_inputs_brokers];46  
@dtedate char(10)     
           
 AS           
 BEGIN          
 SET NOCOUNT ON    
    
 /*ACTUALIZAMOS TABLA NULOS SE ASIGNA HR DE CIERRE*/      
 UPDATE GFI      
 SET txtHoraFin =  ISNULL(txtHoraFin,'14:00:00')       
 FROM  tmp_tblPosturasGFI AS GFI      
      
      
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
   DELETE           
    itblMarketPositions           
   WHERE           
    intIdBroker = 13          
    AND dteDate = @dtedate          
    AND txtOperation <> 'HECHO'          
           
------------------Reviso que existan operaciones en Rango--------------------------          
    SELECT           
   t.txtinsname,          
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
    --INTO #tblOpRango          
    FROM tmp_tblPosturasGFI AS t          
    WHERE           
  txtMatDate like '%-%'     
 
/*SE ACUTUALIZAN LOS RANGOS QUE TERMINEN EN 94 A 92 YA QUE LAS POSTURAS DEBEN RESPETAR LOS RANGOS INTERNOS Y NO LOS DEL BROKER*/
update #tblOpRango
	set intFin = 92
		where intInicio = 70
		and intFin = 94       
           
------------------Busca Operaciones Esten Dentro de los Rangos--------------------------          
    SELECT          
   i.txtID1,          
   i.txtTV,          
   i.txtEmisora,          
   i.txtSerie,          
   LTRIM(RTRIM(txttv))+'_'+LTRIM(RTRIM(txtemisora))+'_'+LTRIM(RTRIM(txtserie)) AS txtIns,          
   DATEDIFF(d,@dtedate,b.dteMaturity) as txtplazo          
   INTO #tblranges          
      FROM MxFixIncome..tblIds AS i          
      INNER JOIN tblbonds AS b          
      ON           
    i.txtID1 = b.txtID1          
      WHERE           
    i.txtEmisora IN ( SELECT txtInsname FROM #tblOpRango )       
   
   
------------------Rangos Finales Consolidados--------------------------          
    SELECT          
   p.txtID1,          
   p.txtTV,          
   p.txtEmisora,          
   p.txtSerie,          
   p.txtIns,          
   p.txtPlazo          
    INTO #tblrangesFinal          
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
   
   
------------------Asigno Valores a Instrumentos en el Rango--------------------------          
    SELECT           
   t.intLine,    
   r.txtins,--oaceves    
   t.txtMatDate,--oaceves         
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
   t.txtRestriction          
     INTO #tblOpFinal          
     FROM tmp_tblPosturasGFI AS t          
     INNER JOIN #tblrangesFinal AS r          
     ON           
   r.txtEmisora = t.txtInsName          
     WHERE           
   txtMatDate LIKE '%-%'
   and 
	/*PLAZO - 2 DIAS  ES MAYOR O IGUAL A PLAZO INICIAL DE RANGOS  (nos aseguramos de tomar solo los plazos dentro de los rangos correctos)*/  
		convert(int, r.txtplazo) -2 >=
		   CASE 
				WHEN CHARINDEX('-',t.txtMatDate) > 0 
				THEN  CAST(SUBSTRING(t.txtMatDate,1,CHARINDEX('-',t.txtMatDate)-1) AS INT)     
				ELSE         CAST(t.txtMatDate AS INT)          
			END 
			/*PLAZO - 2 DIAS  ES MAYOR O IGUAL A PLAZO FINAL DE RANGOS*/  
   and  
	   convert(int, r.txtplazo) -2 <=
			CASE 
				WHEN CHARINDEX('-',t.txtMatDate) > 0 
				THEN  CAST(SUBSTRING(t.txtMatDate,CHARINDEX('-',t.txtMatDate)+1,LEN(RTRIM(t.txtMatDate))-CHARINDEX('-',t.txtMatDate)) AS INT)       
				ELSE  CAST(t.txtMatDate AS INT)    
			END  
			
			/*Replicamos para demas plazos sie stos se intercalan como 30-50   50- 70 ...etc */
			insert into #tblOpFinal 
			SELECT distinct
				intLine,
				txtIns,
					case 
						when txtmatDate = '30-50' and a.txtplazo = '52' then '50-70' 
						when txtmatDate = '50-70' and a.txtplazo = '52' then '30-50' 
						when txtmatDate = '50-70'  and a.txtplazo = '72' then '70-94' 
						 when txtmatDate =  '70-94' and a.txtplazo = '72' then '50-70' 
					end as txtMatDate,
				dteDate,
				txtHoraIni,
				txtHoraFin,
				Duration,
				txtIndicator,
				dblamount,
				dblrate,
				txtInsName,
				txtInsID,
				txttv,
				txtplazo,
				txtliquidation,
				txtRestriction
		   FROM #tblOpFinal  as A
			   where convert(int, a.txtplazo) in  (72,52)
			   and txtMatDate  in ('50-70','30-50','70-94')
			  
 ------------------Inserta operaciones en Rango--------------------------          
     INSERT itblMarketPositions  (dteDate,intIdBroker,intLine,intPlazo,txtTv,txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)        
		 SELECT DISTINCT           
		   dteDate,          
		   13,     
		   intLine,          
		   txtplazo,         
		   txtTv,          
		   txtindicator,          
		   dblRate,          
		   dblAmount,          
		   txtHoraIni,          
		   case when txtHoraFin is null then txtHoraIni else txtHoraFin end ,     
		   txtLiquidation          
	   FROM #tblOpFinal          
	           
 --------Operaciones en Plazo-------------------------------------           
       
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
        
 ----------------------Inserta operaciones en Plazo--------------------------          
    INSERT itblMarketPositions  (dteDate,intIdBroker,intLine,intPlazo,txtTv,txtOperation,dblRate,dblAmount,dteBeginHour,dteEndHour,txtLiquidation)        
  SELECT DISTINCT           
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
   txtLiquidation          
  FROM #tblInputsGFI          
          
  SET NOCOUNT OFF          
    
 END   
        
        
        
    
            
  