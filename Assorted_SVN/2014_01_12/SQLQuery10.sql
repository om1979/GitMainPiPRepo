  
  
  select * from tblbonds where txtId1 in (	
	select txtid1 from tblIds
	where txttv = '*c' and txtemisora = 'AEDUSD')
	





SELECT * FROM  MIRC0004099

	
	
	
 --   select * from tblderivatives where txtId1 in (	
	--select txtid1 from tblIds
	--where txttv = '*c' and txtemisora = 'AEDUSD')

	
	--		select * from tblEquity where txtId1 in (	
	--select txtid1 from tblIds
	--where txttv = '*c' and txtemisora = 'AEDUSD')
  
  
  
  SELECT * FROM  dbo.tblBondsAdd AS TBA
  WHERE txtId1 = 'MIRC0004099'
  
  SELECT * FROM  dbo.bkp_tblDailyAnalytics_20140307 AS BTDA
  
  
   
  
  
  
  
  SELECT * FROM  dbo.tblBonds 
  WHERE txtId1 IN ('MIRC0004099','MIRC0024026','MIRC0021953','MIRC0024027')
  
 SELECT * FROM  tblDerivatives
  WHERE txtId1 IN ('MIRC0004099','MIRC0024026','MIRC0021953','MIRC0024027')
  
  SELECT * FROM  dbo.tblEquity 
  WHERE txtId1 IN ('MIRC0004099','MIRC0024026','MIRC0021953','MIRC0024027')
  
  
  
  
  
  
  
  
  
   /*Conseguimos id's*/
   SELECT * FROM  dbo.tblIds 
   WHERE txtTv = '*C'AND txtEmisora 
   IN ('CNHUSD','MXPCNH','USDCHF','USDCNH')

   
--  SELECT txtId1,* FROM  tmp_tblUnifiedPricesReport
--  WHERE txtTv = '*C'
--  AND txtEmisora IN 
--  ('CNHUSD',
--'MXPCNH',
--'USDCHF',
--'USDCNH')