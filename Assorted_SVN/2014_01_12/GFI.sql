  
  
  
  
  SELECT * FROM  MxProcesses..tblProcessParameters AS TPP
  WHERE txtProcess LIKE '%GFI_p%'
  
  

       
       
       --"sp_inputs_brokers;47 '[FORMAT(TODAY, YYYYMMDD)]'"
       
       
       DECLARE  @dtedate char(10)   = '20141202'      

               
               
               
            IF OBJECT_ID('tempdb..#tblInputsGFI')  IS NOT NULL
            DROP TABLE  #tblInputsGFI 
  
------Carga de Hechos-------------------------------------         
 SELECT         
   t.intLine,   
   i.txtID1,        
   CONVERT(DATETIME,t.txtFecha,111) as DteDate,        
   t.txtHoraIni,        
   t.txtHoraFin,        
   datediff(s,t.txtHoraIni,t.txtHoraFin) as Duration,        
   CASE        
     WHEN t.txtIndicator = 'H' THEN 'HECHO'        
     WHEN t.txtIndicator = 'T' THEN 'HECHO'        
   ELSE t.txtIndicator        
   END AS txtIndicator,        
   CAST(t.txtSize as FLOAT)as dblamount,        
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
   p.dblValue as txtplazo,        
   t.txtSetDate as txtliquidation,        
   t.txtRestriction        
 INTO #tblInputsGFI        
 FROM tmp_tblHechosGFI as t        
 INNER JOIN tblids as i      
 ON   
  ltrim (rtrim(txttv))+'_'+ltrim (rtrim(txtemisora))+'_'+ltrim (rtrim(txtserie)) = SUBSTRING(CAST(t.txtinsID AS VARCHAR), 1, CHARINDEX( ' ',t.txtinsID)-1)        
 INNER JOIN mxfixincome..tblprices as p        
 ON   
  i.txtID1 = p.txtID1        
 WHERE  
  p.txtItem = 'DTM'        
  AND p.txtLiquidation = '48H'        
 and t.txtSize <=100000000000  
  AND t.txtFecha = @dtedate   
   AND 1 = CASE /*validamos que este contenido el tipo de valor en =Liq 48 o que tv= LD sea liq = MD */
		  WHEN i.txtTV IN ('BI','M','S','LD','IM','IQ','IS','IT' ) AND t.txtSetDate = '48' THEN 1
		  WHEN i.txtTV IN ('LD') AND t.txtSetDate = 'MD'THEN 1  END    
		  AND DATEDIFF(mi,t.txtHoraIni,t.txtHoraFin)>=1    
 ORDER BY 1        
 
 
 
	 /*agregamos columna para validar candado sobre tabla de trabajo */
	 go
		 ALTER TABLE #tblInputsGFI
		 ADD fstatus bit 
	 go

	 /*candado  para validar plazos        M_BONOS_241205 3662 48   = IntPlazo   */
	UPDATE tt
	SET fstatus =
	CASE WHEN txtliquidation = '48' AND  SUBSTRING(txtInsID,CHARINDEX(' ',txtInsID,0),  CHARINDEX('48',txtInsID,0)-CHARINDEX(' ',txtInsID,0)) = txtplazo THEN 1
		WHEN txtliquidation = '24' AND  SUBSTRING(txtInsID,CHARINDEX(' ',txtInsID,0),  CHARINDEX('24',txtInsID,0)-CHARINDEX(' ',txtInsID,0))= txtplazo THEN 1
		WHEN txtliquidation = 'MD' AND SUBSTRING(txtInsID,CHARINDEX(' ',txtInsID,0),  CHARINDEX('MD',txtInsID,0)-CHARINDEX(' ',txtInsID,0))= txtplazo THEN 1
	  ELSE 0
	  END  
	  from #tblInputsGFI AS tt
  
  
  
  
  
  
 SELECT 
intLine	
,txtID1
,DteDate	
,txtHoraIni	
,txtHoraFin	
,Duration	
,txtIndicator	
,dblamount	
,dblrate	
,txtInsName	
,txtInsID
,txttv	
,intInicio	
,intFin	
,txtplazo	
,txtliquidation	
,txtRestriction
    FROM  #tblInputsGFI
		WHERE fstatus =1

 
 
 
 --SELECT * FROM  dbo.itblMarketPositions 
 --WHERE dteDate = '20141201'
 --AND intIdBroker = 13
 
 --SELECT * FROM  dbo.itblBrokerCatalog AS IBC
 
 
 	  

        
    