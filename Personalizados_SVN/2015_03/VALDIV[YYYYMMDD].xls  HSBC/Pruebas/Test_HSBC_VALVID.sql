  
    
/*    
AUTOR:OmaR Adrian Aceves Gutierrez    
FECHA:2014-03-03 15:31:12.253    
OBJETIVO:Crear personalizado HSBC_VALDIV_XLS    
*/    
ALTER  PROCEDURE sp_productos_BITAL;23    
    
--DECLARE     
@txtDate AS DATETIME    
--SET @txtDate = '20150206'    
  
AS     
BEGIN     
    
SET NOCOUNT ON      
    
	    
	DECLARE @tblDirectives TABLE (      
	   indSheet INT,      
	   SheetName CHAR(50),      
	   intSection INT,      
	   txtSource CHAR(50),      
	   txtCode CHAR(250),      
	   intCol INT,      
	   intRow INT,         txtValue VARCHAR(20),    
		Node INT      
	  PRIMARY KEY (indSheet, intCol, intRow)      
	  )      
	      
      
      
      /*Calculamos tipos de cambios compuestos*/
		DECLARE @dblUFXU  FLOAT  SET @dblUFXU = (SELECT LTRIM(STR( CAST(dblValue AS DECIMAL (18,10)) ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'UFXU')    
		DECLARE @ORO1 DECIMAL(18,8)   SET @ORO1 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * 1.205652 * @dblUFXU / 50,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')    
		DECLARE @ORO2 DECIMAL(18,8)   SET @ORO2 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) *(1+0.02)* @dblUFXU ,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')     
		DECLARE @ORO3 DECIMAL(18,8)   SET @ORO3 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * 0.48227 *1.04 * @dblUFXU/20,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'ORO')     
		DECLARE @PLATA1 DECIMAL(18,8) SET @PLATA1 = (SELECT LTRIM(STR(ROUND((CAST(dblValue AS DECIMAL (18,10)) +1.5)* @dblUFXU ,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'PLATA')     
		DECLARE @PLATA2 DECIMAL(18,8) SET @PLATA2 = (SELECT LTRIM(STR(ROUND(CAST(dblValue AS DECIMAL (18,10)) * @dblUFXU * 5 + 5 *@dblUFXU  ,6,0) ,15,6) ) FROM MxFixIncome.dbo.tblIRC WHERE dteDate =  @txtDate AND txtIRC = 'PLATA')     
    
   
   
    /*
   Agregamos a catalogo tiipos de cambio a consultar 
   */
	   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue,Node)      
		   SELECT 01,'VALDIV',1,'GBPX','GBPX',3,9,NULL,NULL UNION     
		   SELECT 01,'VALDIV',1,'CHFX','CHFX',3,10,NULL,NULL UNION     
		   SELECT 01,'VALDIV',1,'FRFX','FRFX',3,11,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'DKKX','DKKX',3,12,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'NLGX','NLGX',3,13,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'SEKX','SEKX',3,14,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'DEMX','DEMX',3,15,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'ESPX','ESPX',3,16,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'BEFX','BEFX',3,17,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'ITLX','ITLX',3,18,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'JPYX','JPYX',3,19,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'ATSX','ATSX',3,20,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'CADX','CADX',3,21,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'NOKX','NOKX',3,22,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'BRLX','BRLX',3,23,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'EURX','EURX',3,24,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'UFXU','UFXU',3,25,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'UFXU','UFXU',3,26,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'ORO','ORO',3,27,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'ORO','ORO',3,28,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'ORO','ORO',3,29,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'PLATA','PLATA',3,30,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'ORO','ORO',3,31,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'PLATA','PLATA',3,32,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'CNYX','CNYX',3,33,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'AUDX','AUDX',3,34,NULL,NULL UNION    
		   SELECT 01,'VALDIV',1,'CNHX','CNHX',3,35,NULL,NULL UNION     
		   SELECT 01,'VALDIV',1,'RUBX','RUBX',3,36,NULL,NULL    
	   
   
		/*Obtenemos los tipos de cambio para casos Genericos*/
			 UPDATE @tblDirectives    
			 SET txtValue = (SELECT LTRIM(STR(dblValue,15,4)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource)    
		
		
		/*Obtenemos los tipos de cambio Para campos especificos*/   
			 UPDATE @tblDirectives    
			 SET txtValue =     
			 ( SELECT LTRIM(STR(dblValue,15,5)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			 WHERE intRow IN (14)    
			     
			 UPDATE @tblDirectives    
			     
			 SET txtValue =     
			  (   SELECT LTRIM(STR(1/dblValue,15,5)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			  WHERE intRow IN (9,24,34)    
			    
			     
			 UPDATE @tblDirectives    
			 SET txtValue =     
			  (SELECT LTRIM(STR(dblValue *(1+0.02)* @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			  WHERE intRow IN (27)    
			     
			     
			 UPDATE @tblDirectives    
			 SET txtValue =     
			  (   SELECT LTRIM(STR(dblValue * 1.205652 * @dblUFXU /50,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			  WHERE intRow IN (28)    
			     
			 UPDATE @tblDirectives    
			 SET txtValue =     
			  (   SELECT LTRIM(STR(dblValue * @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			  WHERE intRow IN (29)    
			     
			    
			 UPDATE @tblDirectives    
			 SET txtValue =     
			 ( SELECT LTRIM(STR(dblValue * @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			 WHERE intRow IN (30)   
			     
			  UPDATE @tblDirectives    
			 SET txtValue =     
			 (   SELECT LTRIM(STR(dblValue *0.48227*1.04* @dblUFXU /20,15,4)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			 WHERE intRow IN (31)    
			     
			    
			  UPDATE @tblDirectives    
			 SET txtValue =     
			 ( SELECT LTRIM(STR((dblValue + 6)* @dblUFXU,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
			 WHERE intRow IN (32)    
			 
			 
			
			 
    
     /*Valores para cuarta columna 1 hoja de Excel */
	  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
		   SELECT 01,'VALDIV',2,'GBP','GBP',4,5,CONVERT(bigint,CONVERT(datetime,@txtDate+ 2)) UNION     
		   SELECT 01,'VALDIV',2,'GBP','GBP',4,9,NULL UNION     
		   SELECT 01,'VALDIV',2,'CHF','CHF',4,10,NULL UNION    
		   SELECT 01,'VALDIV',2,'FRF','FRF',4,11,NULL UNION    
		   SELECT 01,'VALDIV',2,'DKK','DKK',4,12,NULL UNION    
		   SELECT 01,'VALDIV',2,'NLG','NLG',4,13,NULL UNION    
		       
		   SELECT 01,'VALDIV',2,'SEK','SEK',4,14,NULL UNION    
		   SELECT 01,'VALDIV',2,'DEM','DEM',4,15,NULL UNION    
		   SELECT 01,'VALDIV',2,'ESP','ESP',4,16,NULL UNION    
		   SELECT 01,'VALDIV',2,'BEF','BEF',4,17,NULL UNION    
		   SELECT 01,'VALDIV',2,'ITL','ITL',4,18,NULL UNION    
		       
		   SELECT 01,'VALDIV',2,'JPY','JPYX',4,19,NULL UNION    
		   SELECT 01,'VALDIV',2,'ATS','ATS',4,20,NULL UNION    
		   SELECT 01,'VALDIV',2,'CAD','CAD',4,21,NULL UNION    
		   SELECT 01,'VALDIV',2,'NOK','NOK',4,22,NULL UNION    
		   SELECT 01,'VALDIV',2,'BRL','BRL',4,23,NULL UNION    
		       
		   SELECT 01,'VALDIV',2,'EUR','EUR',4,24,NULL UNION     
		       
		   SELECT 01,'VALDIV',2,'--','--',4,25,'--' UNION    
		   SELECT 01,'VALDIV',2,'--','--',4,26,'--' UNION    
		   SELECT 01,'VALDIV',2,'--','--',4,27,'PLATA LIBERTAD' UNION     
		       
		   SELECT 01,'VALDIV',2,'PLATA','ORO',4,28,NULL UNION    
		   SELECT 01,'VALDIV',2,'','',4,29,'--' UNION    
		   SELECT 01,'VALDIV',2,'PLATA','ORO',4,30,NULL UNION    
		   SELECT 01,'VALDIV',2,'PLATA','PLATA',4,31,'--' UNION    
		   SELECT 01,'VALDIV',2,'ORO','ORO',4,32,'--' UNION    
		   SELECT 01,'VALDIV',2,'CNY','CNY',4,33,NULL UNION    
		   SELECT 01,'VALDIV',2,'AUD','AUD',4,34,NULL UNION    
		   SELECT 01,'VALDIV',2,'CNH','CNH',4,35,NULL UNION    
		   SELECT 01,'VALDIV',2,'RUB','RUB',4,36,NULL      
    
     /*Obtenemos los tipos de cambio para casos Genericos*/
		 UPDATE @tblDirectives    
		 SET txtValue =     
		 (CASE WHEN txtValue IS  NULL  THEN     
		 (SELECT  LTRIM(STR( CONVERT(VARCHAR(50),ROUND(dblValue,6,0)),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 2)    
		  ELSE txtValue END     
		  )    
  /*Obtenemos los tipos de cambio Para campos especificos*/
		UPDATE @tblDirectives    
		SET txtValue =     
		(SELECT  LTRIM(STR((dblValue + 1.5)* @dblUFXU,15,6))  FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource)    
		WHERE intSection = 2 AND intRow IN(28,30)    
		    
     
    
     
     /*oaceves */
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
   SELECT 01,'VALDIV',3,'GBPX','GBPX',8,9,NULL UNION     
   SELECT 01,'VALDIV',3,'DEMX','DEMX',8,10,NULL UNION     
   SELECT 01,'VALDIV',3,'JPYX','JPYX',8,11,NULL UNION     
   SELECT 01,'VALDIV',3,'CHFX','CHFX',8,12,NULL UNION     
   SELECT 01,'VALDIV',3,'FRFX','FRFX',8,13,NULL UNION     
   SELECT 01,'VALDIV',3,'CADX','CADX',8,14,NULL UNION     
   SELECT 01,'VALDIV',3,'NLGX','NLGX',8,15,NULL UNION     
   SELECT 01,'VALDIV',3,'SEKX','SEKX',8,16,NULL UNION     
   SELECT 01,'VALDIV',3,'ESPX','ESPX',8,17,NULL UNION     
   SELECT 01,'VALDIV',3,'BEFX','BEFX',8,18,NULL UNION     
   SELECT 01,'VALDIV',3,'ITLX','ITLX',8,19,NULL UNION     
   SELECT 01,'VALDIV',3,'ATSX','ATSX',8,20,NULL UNION     
   SELECT 01,'VALDIV',3,'DKKX','DKKX',8,21,NULL UNION     
   SELECT 01,'VALDIV',3,'NOKX','NOKX',8,22,NULL UNION     
   SELECT 01,'VALDIV',3,'BRLX','BRLX',8,23,NULL UNION    
   SELECT 01,'VALDIV',3,'EURX','EURX',8,24,NULL UNION    
   SELECT 01,'VALDIV',3,'CNYX','CNYX',8,25,NULL  UNION    
   SELECT 01,'VALDIV',3,'AUDX','AUDX',8,26,NULL  UNION    
   SELECT 01,'VALDIV',3,'CNHX','CNHX',8,27,NULL UNION     
   SELECT 01,'VALDIV',3,'PLATA','PLATA',8,28,NULL  UNION    
   SELECT 01,'VALDIV',3,'ORO','ORO',8,29,NULL    UNION 
   SELECT 01,'VALDIV',3,'RUBU','RUBU',8,30,NULL   
    
UPDATE @tblDirectives    
 SET txtValue =     
 (CASE WHEN txtValue IS  NULL  THEN     
 (SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection =3)    
  ELSE txtValue END     
  )    
  UPDATE @tblDirectives    
 SET txtValue =     
 ( SELECT LTRIM(STR(1/dblValue,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )    
 WHERE intSection = 3 AND  intRow = 24    
    
 UPDATE @tblDirectives    
 SET txtValue =     
 ( SELECT LTRIM(STR(1/dblValue,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )    
 WHERE intSection = 3 AND  intRow = 26    
     
    
    
    /*Marco Aleman */
	   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
			SELECT 01,'VALDIV',4,'EURX','EURX',8,38,NULL UNION     
			SELECT 01,'VALDIV',4,'EURX','EURX',8,39,NULL      
	    
    
		 UPDATE @tblDirectives    
		 SET txtValue =     
		 ( SELECT LTRIM(STR(dblValue * 200.482,15,4)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource  )    
		 WHERE intSection = 4 AND  intRow = 38    
		     
		 UPDATE @tblDirectives    
		 SET txtValue =     
		 ( SELECT LTRIM(@dblUFXU /(200.482 * CAST(dblValue AS DECIMAL(32,32)))) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = txtSource )    
		 WHERE intSection = 4 AND intRow = 39    
	   
     
 /*    
 --comienzo de suganda pagina en excel    
 --    
 */    
     
    
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
   SELECT 2,'DIV X DLR',5,'UFXU','UFXU',4,8,NULL  UNION     
   SELECT 2,'DIV X DLR',5,'1','1',4,9,1  UNION       
   SELECT 2,'DIV X DLR',5,'GBPX','GBPX',4,10,NULL UNION     
   SELECT 2,'DIV X DLR',5,'CHFX','CHFX',4,11,NULL UNION     
   SELECT 2,'DIV X DLR',5,'FRFX','FRFX',4,12,NULL  UNION     
       
   SELECT 2,'DIV X DLR',5,'DKKX','DKKX',4,13,NULL UNION       
   SELECT 2,'DIV X DLR',5,'NLGX','NLGX',4,14,NULL UNION     
   SELECT 2,'DIV X DLR',5,'SEKX','NOKX',4,15,NULL UNION      
   SELECT 2,'DIV X DLR',5,'DEMX','DEMX',4,16,NULL UNION     
   SELECT 2,'DIV X DLR',5,'ESPX','ESPX',4,17,NULL UNION     
       
         
   SELECT 2,'DIV X DLR',5,'BEFX','BEFX',4,18,NULL UNION     
   SELECT 2,'DIV X DLR',5,'ITLX','ITLX',4,19,NULL UNION      
   SELECT 2,'DIV X DLR',5,'JPYX','JPYX',4,20,NULL UNION     
   SELECT 2,'DIV X DLR',5,'ATSX','ATSX',4,21,NULL UNION       
   SELECT 2,'DIV X DLR',5,'CADX','CADX',4,22,NULL UNION     
       
   SELECT 2,'DIV X DLR',5,'NOKX','NOKX',4,23,NULL UNION      
   SELECT 2,'DIV X DLR',5,'BRLX','BRLX',4,24,NULL UNION     
   SELECT 2,'DIV X DLR',5,'ORO1','DEMX',4,25,NULL UNION   --    
      SELECT 2,'DIV X DLR',5,'PTE','PTE',4,26,NULL UNION     
      SELECT 2,'DIV X DLR',5,'UFXU/(PLATA1*2)','DEMX',4,27,NULL UNION  --    
      SELECT 2,'DIV X DLR',5,'ORO2/UFXU','GBPX',4,28,NULL UNION     
   SELECT 2,'DIV X DLR',5,'UFXU/PLATA1','DEMX',4,29,NULL     
    
 UPDATE @tblDirectives    
 SET txtValue =     
 (CASE WHEN txtValue IS  NULL  THEN     
 (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 5)    
  ELSE txtValue END     
  )    
      
  UPDATE @tblDirectives    
  SET txtValue = STR(1/(@ORO1/@dblUFXU),15,6)    
  WHERE intSection = 5 AND intRow = 25    
     
  UPDATE @tblDirectives    
  SET txtValue = STR(@dblUFXU/(@PLATA1*2),15,6)    
  WHERE intSection = 5 AND intRow = 27    
     
 /*update made UFXU / ORO2*/    
  UPDATE @tblDirectives    
  SET txtValue = STR(@dblUFXU/@ORO2,15,6)    
  WHERE intSection = 5 AND intRow = 28    
    
 UPDATE @tblDirectives    
  SET txtValue = STR(@dblUFXU / @PLATA1,15,6)    
  WHERE intSection = 5 AND intRow = 29    
     
    
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
   SELECT 2,'DIV X DLR',5,'(2*UFXU)/ORO2','GBPX',4,30,NULL UNION     
   SELECT 2,'DIV X DLR',5,'(4*UFXU)/ORO2','DEMX',4,31,NULL UNION      
   SELECT 2,'DIV X DLR',5,'(10*UFXU)/ORO2','GBPX',4,32,NULL UNION     
   SELECT 2,'DIV X DLR',5,'(20*UFXU)/ORO2','DEMX',4,33,NULL UNION  --    
   SELECT 2,'DIV X DLR',5,'(1.635*UFXU)/PLATA1','GBPX',4,34,NULL UNION     
   SELECT 2,'DIV X DLR',5,'(3.5*UFXU)/PLATA1','DEMX',4,35,NULL UNION      
   SELECT 2,'DIV X DLR',5,'(6*UFXU)/PLATA1','GBPX',4,36,NULL UNION     
   SELECT 2,'DIV X DLR',5,'(9*UFXU)/PLATA1','DEMX',4,37,NULL UNION --5    
   SELECT 2,'DIV X DLR',5,'ORO2/UFXU','GBPX',4,38,NULL UNION     
   SELECT 2,'DIV X DLR',5,'(2*UFXU)/ORO2','DEMX',4,39,NULL UNION      
   SELECT 2,'DIV X DLR',5,'(4*UFXU)/ORO2','GBPX',4,40,NULL UNION     
   SELECT 2,'DIV X DLR',5,'UFXU/PLATA1','DEMX',4,41,NULL UNION ---    
   SELECT 2,'DIV X DLR',5,'(1.635*@dblUFXU)/@PLATA1','GBPX',4,42,NULL UNION     
   SELECT 2,'DIV X DLR',5,'(3.5 * @dblUFXU)/@PLATA1','DEMX',4,43,NULL UNION      
   SELECT 2,'DIV X DLR',5,'@dblUFXU/@PLATA2','GBPX',4,44,NULL UNION     
   SELECT 2,'DIV X DLR',5,'@dblUFXU/@PLATA2','DEMX',4,45,NULL UNION    
   SELECT 2,'DIV X DLR',5,'1/@ORO','DEMX',4,46,NULL  UNION ---    
   SELECT 2,'DIV X DLR',5,'1/PLATA','GBPX',4,47,NULL UNION     
   SELECT 2,'DIV X DLR',5,'@dblUFXU/ORO3','DEMX',4,48,NULL UNION      
   SELECT 2,'DIV X DLR',5,'@dblUFXU','GBPX',4,49,NULL UNION     
   SELECT 2,'DIV X DLR',5,'EURX','DEMX',4,50,NULL UNION    
   SELECT 2,'DIV X DLR',5,'1/(PLATA+6)','DEMX',4,51,NULL  UNION ---    
   SELECT 2,'DIV X DLR',5,'CLPX','GBPX',4,52,NULL UNION     
   SELECT 2,'DIV X DLR',5,'CLF/UFXU','DEMX',4,53,NULL UNION      
   SELECT 2,'DIV X DLR',5,'CNYX','GBPX',4,54,NULL UNION     
   SELECT 2,'DIV X DLR',5,'1/AUDX','DEMX',4,55,NULL UNION    
   SELECT 2,'DIV X DLR',5,'CNHX','DEMX',4,56,NULL   UNION    
   SELECT 2,'DIV X DLR',5,'RUBX','RUBX',4,57,NULL         
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (2*@dblUFXU)/@ORO2,15,6)    
   WHERE intSection = 5 AND intRow = 30    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (4*@dblUFXU)/@ORO2 ,15,6)    
   WHERE intSection = 5 AND intRow = 31    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (10*@dblUFXU)/@ORO2,15,6)    
   WHERE intSection = 5 AND intRow = 32    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (20*@dblUFXU)/@ORO2,15,6)    
   WHERE intSection = 5 AND intRow = 33    
    
   UPDATE @tblDirectives    
   SET txtValue = STR((1.635*@dblUFXU)/@PLATA1  ,15,6)    
   WHERE intSection = 5 AND intRow = 34    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (3.5*@dblUFXU)/@PLATA1  ,15,6)    
   WHERE intSection = 5 AND intRow = 35    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (6*@dblUFXU)/@PLATA1 ,15,6)    
   WHERE intSection = 5 AND intRow = 36    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (9*@dblUFXU)/@PLATA1,15,6)    
   WHERE intSection = 5 AND intRow = 37    
 ----    
 /*update made UFXU / ORO2*/    
  UPDATE @tblDirectives    
   SET txtValue = STR(@dblUFXU/@ORO2,15,6)    
   WHERE intSection = 5 AND intRow = 38    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (2*@dblUFXU)/@ORO2 ,15,6)    
   WHERE intSection = 5 AND intRow = 39    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (4*@dblUFXU)/@ORO2 ,15,6)    
   WHERE intSection = 5 AND intRow = 40    
       
  UPDATE @tblDirectives    
   SET txtValue = STR(@dblUFXU/@PLATA1,15,6)    
   WHERE intSection = 5 AND intRow = 41    
   --    
  UPDATE @tblDirectives    
   SET txtValue = STR((1.635*@dblUFXU)/@PLATA1 ,15,6)    
   WHERE intSection = 5 AND intRow = 42    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (3.5 * @dblUFXU)/@PLATA1 ,15,6)    
   WHERE intSection = 5 AND intRow = 43  --PLATA PRECOL. 1/4 ONZA    
    
  UPDATE @tblDirectives    
   SET txtValue = STR( @dblUFXU/@PLATA2,15,6)    
   WHERE intSection = 5 AND intRow = 44    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @dblUFXU/@PLATA2,15,6)    
   WHERE intSection = 5 AND intRow = 45    
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )    
   WHERE intSection = 5 AND intRow = 46    
 ---    
     
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )    
   WHERE intSection = 5 AND intRow = 47    
       
       
   --------------    
    UPDATE @tblDirectives    
   SET txtValue = STR( @dblUFXU/@ORO3,15,6)    
   WHERE intSection = 5 AND intRow = 48  --ORO CHICO    
       
   UPDATE @tblDirectives    
   SET txtValue = STR( @dblUFXU,15,6)    
   WHERE intSection = 5 AND intRow = 49      
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )    
   WHERE intSection = 5 AND intRow = 50    
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(1 / (dblValue + 6 ) ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )    
   WHERE intSection = 5 AND intRow = 51    
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLPX' )    
   WHERE intSection = 5 AND intRow = 52    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(dblValue/@dblUFXU,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )    
   WHERE intSection = 5 AND intRow = 53    
       
   
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNYX' )    
   WHERE intSection = 5 AND intRow = 54    
       
       
  UPDATE @tblDirectives    
SET txtValue =     
   ( SELECT LTRIM(STR(1/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'AUDX' )    
   WHERE intSection = 5 AND intRow = 55    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNHX' )    
   WHERE intSection = 5 AND intRow = 56    
   
   
   UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'RUBX' )    
   WHERE intSection = 5 AND intRow = 57    
       
       
   /*    
   COLUMNA 3 HOJA 2     
   */    
    INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
   SELECT 2,'DIV X DLR',6,'1','1',5,8,1  UNION     
   SELECT 2,'DIV X DLR',6,'UFXU','UFXU',5,9,NULL   UNION       
   SELECT 2,'DIV X DLR',6,'GBP','GBP',5,10,NULL UNION     
   SELECT 2,'DIV X DLR',6,'CHF','CHF',5,11,NULL UNION     
   SELECT 2,'DIV X DLR',6,'FRF','FRF',5,12,NULL  UNION     
   SELECT 2,'DIV X DLR',6,'DKK','DKK',5,13,NULL UNION       
   SELECT 2,'DIV X DLR',6,'NLG','NLG',5,14,NULL UNION     
   SELECT 2,'DIV X DLR',6,'SEK','SEK',5,15,NULL UNION      
   SELECT 2,'DIV X DLR',6,'DEM','SEKX',5,16,NULL UNION     
   SELECT 2,'DIV X DLR',6,'ESP','ESP',5,17,NULL UNION     
   SELECT 2,'DIV X DLR',6,'BEF','BEF',5,18,NULL UNION     
   SELECT 2,'DIV X DLR',6,'ITL','ITL',5,19,NULL UNION      
   SELECT 2,'DIV X DLR',6,'JPY','JPY',5,20,NULL UNION     
   SELECT 2,'DIV X DLR',6,'ATS','ATS',5,21,NULL UNION       
   SELECT 2,'DIV X DLR',6,'CAD','CAD',5,22,NULL  UNION     
       
   SELECT 2,'DIV X DLR',6,'NOK','NOK',5,23,null UNION     
   SELECT 2,'DIV X DLR',6,'BRL','BRL',5,24,NULL UNION      
   SELECT 2,'DIV X DLR',6,'JPY','JPY',5,25,NULL  UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,26,NULL  UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,27,NULL UNION --ERROR DECIMALES    
       
   SELECT 2,'DIV X DLR',6,'--','--',5,28,@ORO2 UNION     
   SELECT 2,'DIV X DLR',6,'--','---',5,29,STR(@PLATA1,15,6)  UNION      
   SELECT 2,'DIV X DLR',6,'--','--',5,30,STR(@ORO2/2,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,31,STR(@ORO2/4,15,6)    UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,32,STR(@ORO2/10,15,6)   UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,33,STR(@ORO2/20,15,6) UNION     
       
       
   SELECT 2,'DIV X DLR',6,'ATS','---',5,34,STR(@PLATA1/1.635,15,6)  UNION      
   SELECT 2,'DIV X DLR',6,'ATS','--',5,35,STR(@PLATA1/3.5,15,6)   UNION     
   SELECT 2,'DIV X DLR',6,'ATS','--',5,36,STR(@PLATA1/6,15,6)    UNION       
   SELECT 2,'DIV X DLR',6,'ATS','--',5,37,STR(@PLATA1/9,15,6)     UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,38,STR(@ORO2,15,6)    UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,39,STR(@ORO2/2,15,6)   UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,40,STR(@ORO2/4,15,6) UNION      
   SELECT 2,'DIV X DLR',6,'--','--',5,41,STR(@PLATA1,15,6)  UNION     
   SELECT 2,'DIV X DLR',6,'ATS','--',5,42,STR(@PLATA1/ 1.635,15,6)     UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,43,STR(@PLATA1/3.5,15,6)    UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,44,STR(@PLATA2,15,6)   UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,45,STR(@PLATA2,15,6) UNION      
   SELECT 2,'DIV X DLR',6,'--','--',5,46,NULL   UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,47,STR(@PLATA1,15,6) UNION    
   SELECT 2,'DIV X DLR',6,'--','--',5,48,STR(@ORO3,15,6) UNION      
       
       
   SELECT 2,'DIV X DLR',6,'-1','-1',5,49,1   UNION       
   SELECT 2,'DIV X DLR',6,'EUR','EUR',5,50,NULL   UNION       
   SELECT 2,'DIV X DLR',6,'--','--',5,51,NULL UNION     
   SELECT 2,'DIV X DLR',6,'--','--',5,52,NULL   UNION      
   SELECT 2,'DIV X DLR',6,'--','--',5,53,STR(@PLATA1,15,6)  UNION     
       
   SELECT 2,'DIV X DLR',6,'CNY','CNY',5,54,NULL UNION     
   SELECT 2,'DIV X DLR',6,'AUD','AUD',5,55,NULL   UNION      
   SELECT 2,'DIV X DLR',6,'CNH','CNH',5,56,NULL   UNION   
   SELECT 2,'DIV X DLR',6,'RUB','RUB',5,57,NULL 
      
      
       
 UPDATE @tblDirectives    
  SET txtValue =     
  (CASE WHEN txtValue IS  NULL  THEN     
  (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 6)    
   ELSE txtValue END     
   )    
       
       
       
  UPDATE @tblDirectives    
   SET txtValue = STR( round(@ORO1,6,0),10,6)     
   WHERE intSection = 6 AND intRow = 25    
       
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( @dblUFXU/dblValue,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PTE' )    
   WHERE intSection = 6 AND intRow = 26    
       
  UPDATE @tblDirectives    
   SET txtValue =STR( round(@PLATA1*2 ,6,0),10,6)               
   WHERE intSection = 6 AND intRow = 27      
    
    
UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue * @dblUFXU,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )    
   WHERE intSection = 6 AND intRow = 46    
       
 UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue * @dblUFXU,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )    
   WHERE intSection = 6 AND intRow = 47    
    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( (dblValue+6) * @dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )    
   WHERE intSection = 6 AND intRow = 51    
    
    
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue * @dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLP' )    
   WHERE intSection = 6 AND intRow = 52    
    
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( @dblUFXU / dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )    
   WHERE intSection = 6 AND intRow = 53    
    
    
    
/*    
columna 3 sheet2    
*/    
    
  INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
    
   SELECT 2,'DIV X DLR',7,'Int','Int',6,4,CONVERT(bigint,CONVERT(datetime,@txtDate+2))  UNION     
   SELECT 2,'DIV X DLR',7,'UFXU','UFXU',6,8,NULL  UNION     
   SELECT 2,'DIV X DLR',7,'1','1',6,9,1   UNION      
   SELECT 2,'DIV X DLR',7,'GBX','GBX',6,10,NULL   UNION      
   SELECT 2,'DIV X DLR',7,'CHF','CHF',6,11,NULL UNION     
   SELECT 2,'DIV X DLR',7,'FRF','FRF',6,12,NULL UNION    
   SELECT 2,'DIV X DLR',7,'DKK','DKK',6,13,NULL UNION     
       
   SELECT 2,'DIV X DLR',7,'NLG','NLG',6,14,NULL UNION     
   SELECT 2,'DIV X DLR',7,'NOK','NOK',6,15,NULL UNION    
   SELECT 2,'DIV X DLR',7,'DEM','DEM',6,16,NULL UNION     
   SELECT 2,'DIV X DLR',7,'ESP','ESP',6,17,NULL UNION     
   SELECT 2,'DIV X DLR',7,'BEF','BEF',6,18,NULL UNION    
   SELECT 2,'DIV X DLR',7,'ITL','ITL',6,19,NULL UNION    
   SELECT 2,'DIV X DLR',7,' JPY',' JPY',6,20,NULL UNION    
       
   SELECT 2,'DIV X DLR',7,'ATS','ATS',6,21,NULL UNION     
   SELECT 2,'DIV X DLR',7,'CAD','CAD',6,22,NULL UNION     
   SELECT 2,'DIV X DLR',7,'NOK','NOK',6,23,NULL UNION    
   SELECT 2,'DIV X DLR',7,'BRLX','BRLX',6,24,NULL UNION     
   -----    
   SELECT 2,'DIV X DLR',7,'@ORO1/@UFXU','@ORO1/@UFXU',6,25,NULL  UNION     
   SELECT 2,'DIV X DLR',7,'1/PTE','1/PTE',6,26,NULL  UNION     
   SELECT 2,'DIV X DLR',7,'--','--',6,27,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@UFXU/@ORO2','--',6,28,NULL UNION    
   SELECT 2,'DIV X DLR',7,'@PLATA1/@UFXU','--',6,29,NULL  UNION     
       
   SELECT 2,'DIV X DLR',7,'ORO2/(2*@dblUFXU)','--',6,30,NULL UNION     
   SELECT 2,'DIV X DLR',7,'ORO2/(4*@dblUFXU)','--',6,31,NULL UNION     
   SELECT 2,'DIV X DLR',7,'ORO2/(10*@dblUFXU)','--',6,32,NULL UNION    
   SELECT 2,'DIV X DLR',7,'ORO2/(20*@dblUFXU)','--',6,33,NULL UNION     
   SELECT 2,'DIV X DLR',7,'PLATA1/(1.635*@dblUFXU)','--',6,34,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@PLATA1/(3.5 *@dblUFXU)','--',6,35,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@PLATA1/(6*@dblUFXU)','--',6,36,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@PLATA1/(9*@dblUFXU)','--',6,37,NULL UNION    
  SELECT 2,'DIV X DLR',7,'@dblUFXU/@ORO2','--',6,38,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@ORO2/(2*@dblUFXU)','--',6,39,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@ORO2/(4*@dblUFXU)','--',6,40,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@PLATA1/@dblUFXU','--',6,41,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@PLATA1/(1.635*@dblUFXU)','--',6,42,NULL UNION    
   SELECT 2,'DIV X DLR',7,'@PLATA1/(3.5*@dblUFXU)','--',6,43,NULL UNION     
   SELECT 2,'DIV X DLR',7,'@PLATA2/@dblUFXU','--',6,44,NULL UNION     
           
   SELECT 2,'DIV X DLR',7,'@PLATA2/@dblUFXU','--',6,45,NULL UNION     
   SELECT 2,'DIV X DLR',7,'ORO','--',6,46,NULL UNION     
   SELECT 2,'DIV X DLR',7,'PLATA','--',6,47,NULL UNION    
   SELECT 2,'DIV X DLR',7,'ORO3/@dblUFXU','--',6,48,NULL UNION   
   SELECT 2,'DIV X DLR',7,'1','1',6,49,1 UNION     
   SELECT 2,'DIV X DLR',7,'1/EURX','--',6,50,NULL UNION     
   SELECT 2,'DIV X DLR',7,'PLATA+6','--',6,51,NULL UNION     
   SELECT 2,'DIV X DLR',7,'CLP','--',6,52,NULL UNION    
   SELECT 2,'DIV X DLR',7,'@dblUFXU/CLF','--',6,53,NULL UNION     
   SELECT 2,'DIV X DLR',7,'CNY/@dblUFXU','--',6,54,NULL UNION    
   SELECT 2,'DIV X DLR',7,'AUDX','--',6,55,NULL UNION     
   SELECT 2,'DIV X DLR',7,'CNH / @dblUFXU','--',6,56,NULL UNION  
   SELECT 2,'DIV X DLR',7,'RUBU','RUBU',6,57,NULL     
------    
    
    
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'UFXU' )    
   WHERE intSection = 7 AND intRow = 8    
      
      
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'GBPX' )    
   WHERE intSection = 7 AND intRow = 10    
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CHFX' )    
   WHERE intSection = 7 AND intRow = 11    
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'FRFX' )    
   WHERE intSection = 7 AND intRow = 12    
       
    UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'DKKX' )    
   WHERE intSection = 7 AND intRow = 13    
       
   --    
   UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'NLGX' )    
   WHERE intSection = 7 AND intRow = 14    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'SEKX' )    
   WHERE intSection = 7 AND intRow = 15    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'DEMX' )    
   WHERE intSection = 7 AND intRow = 16    
       
UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ESPX' )    
   WHERE intSection = 7 AND intRow = 17    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'BEFX' )    
   WHERE intSection = 7 AND intRow = 18    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ITLX' )    
   WHERE intSection = 7 AND intRow = 19    
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'JPYX' )    
   WHERE intSection = 7 AND intRow = 20    
       
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ATSX' )    
   WHERE intSection = 7 AND intRow = 21    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CADX' )    
   WHERE intSection = 7 AND intRow = 22    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'NOKX' )    
   WHERE intSection = 7 AND intRow = 23    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(  1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'BRLX' )    
   WHERE intSection = 7 AND intRow = 24    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO1/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 25      
          
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PTE' )    
   WHERE intSection = 7 AND intRow = 26    
       
       
  UPDATE @tblDirectives    
   SET txtValue = STR( (@PLATA1*2)/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 27      
       
   /*UPDATED VALUE ORO2 / UFXU*/    
  UPDATE @tblDirectives      
   SET txtValue = STR( @ORO2/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 28      
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 29      
  ----------    
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/(2*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 30      
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/(4*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 31      
          
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/(10*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 32     
        
  UPDATE @tblDirectives    
   SET txtValue = STR(@ORO2/(20*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 33      
    
  UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/(1.635*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 34      
       
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/(3.5 *@dblUFXU),15,6)    
 WHERE intSection = 7 AND intRow = 35      
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/(6*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 36      
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/(9*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 37      
   ----------    
       
   /*UPDATED VALUE ORO2 / UFXU*/    
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 38      
       
       
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/(2*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 39      
          
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO2/(4*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 40     
     
  UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 41      
    
  UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/(1.635*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 42     
       
   UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA1/(3.5*@dblUFXU),15,6)    
   WHERE intSection = 7 AND intRow = 43      
       
   UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA2/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 44      
       
   UPDATE @tblDirectives    
   SET txtValue = STR( @PLATA2/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 45     
          
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'ORO' )    
   WHERE intSection = 7 AND intRow = 46    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )    
   WHERE intSection = 7 AND intRow = 47    
       
  UPDATE @tblDirectives    
   SET txtValue = STR( @ORO3/@dblUFXU,15,6)    
   WHERE intSection = 7 AND intRow = 48    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )    
   WHERE intSection = 7 AND intRow = 50    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue +6  ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'PLATA' )    
   WHERE intSection = 7 AND intRow = 51    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLP' )    
   WHERE intSection = 7 AND intRow = 52    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( @dblUFXU /dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CLF' )    
   WHERE intSection = 7 AND intRow = 53    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR(dblValue/@dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNY' )    
   WHERE intSection = 7 AND intRow = 54    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'AUDX' )    
   WHERE intSection = 7 AND intRow = 55    
       
  UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( dblValue/ @dblUFXU ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'CNH' )    
   WHERE intSection = 7 AND intRow = 56    
    
        UPDATE @tblDirectives    
   SET txtValue =     
   (  SELECT LTRIM(STR( dblValue ,15,6))  FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'RUBU' )    
   WHERE intSection = 7 AND intRow = 57    
    
/*    
sheet 3 colomna 1    
*/    
    
   INSERT @tblDirectives (indSheet,SheetName,intSection,txtSource,txtCode,intCol,intRow,txtValue)      
       
       
   SELECT 3,'Mesa de Control',8,'Int','Int',4,6,CONVERT(bigint,CONVERT(datetime,@txtDate+2)) UNION      
       
       
   SELECT 3,'Mesa de Control',8,'UFXU','UFXU',4,9,null  UNION      
   SELECT 3,'Mesa de Control',8,'1/GBPX','1/GBPX',4,10,NULL    UNION --    
   SELECT 3,'Mesa de Control',8,'CHFX','CHFX',4,11,NULL    UNION      
   SELECT 3,'Mesa de Control',8,'FRFX','FRFX',4,12,NULL    UNION     
       
   SELECT 3,'Mesa de Control',8,'DKKX','DKKX',4,13,NULL  UNION     
   SELECT 3,'Mesa de Control',8,'NLGX','NLGX',4,14,NULL  UNION      
   SELECT 3,'Mesa de Control',8,'SEKX','SEKX',4,15,NULL UNION     
       
   SELECT 3,'Mesa de Control',8,'DEMX','DEMX',4,16,NULL  UNION     
   SELECT 3,'Mesa de Control',8,'ESPX','ESPX',4,17,NULL  UNION      
   SELECT 3,'Mesa de Control',8,'BEFX','BEFX',4,18,NULL UNION     
       
   SELECT 3,'Mesa de Control',8,'ITLX','ITLX',4,19,NULL  UNION   
   SELECT 3,'Mesa de Control',8,'JPYX','JPYX',4,20,NULL  UNION      
   SELECT 3,'Mesa de Control',8,'ATSX','ATSX',4,21,NULL  UNION     
       
       
   SELECT 3,'Mesa de Control',8,'CADX','CADX',4,22,NULL UNION     
   SELECT 3,'Mesa de Control',8,'NOKX','NOKX',4,23,NULL  UNION     
   SELECT 3,'Mesa de Control',8,'BRLX','BRLX',4,24,NULL  UNION      
   SELECT 3,'Mesa de Control',8,'1/EURX','1/EURX',4,25,NULL UNION    
   SELECT 3,'Mesa de Control',8,'AUDX','AUDX',4,26,NULL UNION 
   SELECT 3,'Mesa de Control',8,'RUBX','RUBX',4,27,NULL     
    
      
      
 UPDATE @tblDirectives    
  SET txtValue =     
  (CASE WHEN txtValue IS  NULL  THEN     
  (SELECT LTRIM(STR(ROUND(dblValue,6,0),10,6)) FROM MxFixIncome.dbo.tblIRC  WHERE dteDate = @txtDate AND txtIRC = txtSource AND  intSection = 8)    
   ELSE txtValue END     
   )    
       
       
   UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'GBPX' )    
   WHERE intSection = 8 AND intRow = 10 --1/GBPX    
       
    UPDATE @tblDirectives    
   SET txtValue =     
   ( SELECT LTRIM(STR( 1/dblValue ,15,6)) FROM MxFixIncome.dbo.tblIRC WHERE dteDate = @txtDate AND txtIRC = 'EURX' )    
   WHERE intSection = 8 AND intRow = 25 --1/EURX    
    
    
    
    
  SELECT      
    LTRIM(STR(indSheet)) AS [indSheet],      
    RTRIM(SheetName) AS [SheetName]      
    FROM @tblDirectives      
    GROUP BY       
    indSheet,SheetName      
    ORDER BY       
    indSheet,SheetName      
      
    -- regreso los limites      
   SELECT      
 intSection,      
    MIN(intCol) AS intMinCol,      
    MAX(intCol) AS intMaxCol,      
    MIN(intRow) AS intMinRow,      
    MAX(intRow) AS intMaxRow,      
    indSheet      
    FROM @tblDirectives      
    GROUP BY       
    indSheet,intSection      
  ORDER BY       
    indSheet,intSection      
      
   -- regreso las directivas      
   SELECT      
    LTRIM(STR(intSection)) AS [intSection],      
    LTRIM(STR(indSheet)) AS [indSheet],      
    intCol AS [intCol],      
    intRow AS [intRow],      
  RTRIM(txtValue) AS [txtValue]      
   FROM @tblDirectives      
   ORDER BY       
    intSection,      
    indSheet,      
    intCol,      
    intRow      
      
 SET NOCOUNT OFF     
END    
   
   
   
/*
Configuracion 

   SELECT * FROM  dbo.tblActiveX
   WHERE txtProceso = 'HSBC_VALVID_XLS' 
   
*/