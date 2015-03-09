
	/*		
		Autor:Omar aceves Gutiererz      
		Fecha: 20140226      
		Notas: modulo ;22   se agrega un proceso que genera archivo TCHSBC[DATE|YYYYMMDD].XLS formato y columnas nuevas  

		Modifica:  Omar Adrian Aceves Guttierez
		Fecha de Modificación:  2015-03-09 14:26:55
		Descripcion  :   SE agrega tipos de Valor RUB, RUBX

	*/      
	  
	ALTER   PROCEDURE dbo.sp_productos_BITAL;22       
			@txtDate AS DATETIME              
			AS             
			BEGIN      
			         
			SET NOCOUNT ON      
			  
			  
			--DECLARE       
			--@txtDate AS DATETIME       
			--SET @txtDate = '20150206'      
			  
			DECLARE @dblUSD0 AS FLOAT      
			DECLARE @dblUSD1 AS FLOAT      
			DECLARE @dblUSD2 AS FLOAT      
			DECLARE @dblUFXU AS FLOAT      
			      
			-- Tabla para obtener el universo de IRC´s      
			DECLARE @tmp_tblMaxDate TABLE (      
			txtIRC CHAR(7),      
			dteDate DATETIME      
			PRIMARY KEY (txtIRC))      
			  
			-- Tabla para obtener el universo de IRC´s      
			DECLARE @tmp_tblUniverseIRC TABLE (      
			txtIRC CHAR(7),      
			dteDate DATETIME,      
			dblValue FLOAT      
			PRIMARY KEY (txtIRC))      
			  
			-- genera tabla temporal de resultados          
			DECLARE @tblResult TABLE (          
			[intSection][INTEGER],      
			[dteDate][VARCHAR](50),      
			[txtLabel][VARCHAR](50),         
			[dblValIRC1][VARCHAR](50),         
			[dblValIRC2][VARCHAR](50)      
			--[txtData][VARCHAR](8000)          
			)      
			  
			-- creo tabla temporal de los principales Nodos de Curvas (FRPiP)          
			DECLARE @tmp_tblDirectivesIRC TABLE (          
			[intSection][INTEGER],      
			[txtIRC]  CHAR(30),      
			[txtIRC2]  CHAR(30),          
			[Label]  CHAR(30),            
			[dblValueOr] VARCHAR(50),      
			[dblValue] VARCHAR(50)           
			PRIMARY KEY(intSection)          
			)          
			     
			SET @dblUSD0 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD0')      
			SET @dblUSD1 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD1')      
			SET @dblUSD2 = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'USD2')      
			SET @dblUFXU = (SELECT dblValue FROM MxFixIncome.dbo.tblIRC (NOLOCK) WHERE dteDate = @txtDate AND txtIRC = 'UFXU')      
			  
			-- Obtenemos los maximos del Universo a procesar       
			INSERT @tmp_tblMaxDate       
			SELECT      
			txtIRC,      
			MAX(dteDate)      
			FROM MxFixIncome.dbo.tblIRC (NOLOCK)      
			WHERE      
			txtIRC IN ('EUR','EURX','GBP','GBPX','JPY','JPYX','CAD','CADX','DKK','DKKX','CHF',      
			'CHFX','SEK','SEKX','BRL','BRLX','NOK','NOKX','PLATA','ORO','UFXU','CLP','CLPX','AUD',      
			'AUDX','CNY','CNYX','ARP','ARPX','NZD','NZDX','CNH','CNHX','CLF','TFB','RUB','RUBX')      
			GROUP BY txtIRC      
			  
			-- Obtenemos el universo de los IRC      
			INSERT @tmp_tblUniverseIRC      
			SELECT       
			m.txtIRC,      
			m.dteDate,      
			i.dblValue      
			FROM @tmp_tblMaxDate AS m      
			INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)      
			ON m.txtIRC = i.txtIRC      
			AND m.dteDate = i.dteDate       
			  
			-- Obtengo los encabezados      
			INSERT @tblResult          
			SELECT 001,'TIPO DE CAMBIO','','','' UNION      
			SELECT 002,'','','','' UNION --espacio en blanco      
			SELECT 003,'TC de Valuación (FIX)',LTRIM(STR(ROUND(@dblUFXU,6),16,6)),'','' UNION        
			SELECT 004,'Mismo Dia',LTRIM(STR(ROUND(@dblUSD0,6),16,6)),'','' UNION          
			SELECT 005,'24 horas',LTRIM(STR(ROUND(@dblUSD1,6),16,6)),'','' UNION        
			SELECT 006,'Spot',LTRIM(STR(ROUND(@dblUSD2,6),16,6)),'','' UNION      
			SELECT 007,'','','','' UNION --espacio en blanco      
			SELECT 008,'FECHA', CONVERT(CHAR(10),@txtDate,3),'',''UNION      
			SELECT 009,'','','','' UNION --espacio en blanco      
			SELECT 010,'Otras Monedas','CLAVE','Tipo de Cambio SOBRE MXN','Tipo de Cambio Sobre USD'       
			  
			-- Obetenemos los IRC's      
			INSERT @tmp_tblDirectivesIRC (intSection,txtIRC,txtIRC2,Label,dblValueOr,dblValue)     
			SELECT 011,'EUR','EURX','EUR',NULL,NULL UNION          
			SELECT 012,'GBP','GBPX','GBP',NULL,NULL UNION          
			SELECT 013,'JPY','JPYX','JPY',NULL,NULL UNION          
			SELECT 014,'CAD','CADX','CAD',NULL,NULL UNION          
			SELECT 015,'DKK','DKKX','DKK',NULL,NULL UNION          
			SELECT 016,'CHF','CHFX','CHF',NULL,NULL UNION          
			SELECT 017,'SEK','SEKX','SEK',NULL,NULL UNION          
			SELECT 018,'BRL','BRLX','BRL',NULL,NULL UNION          
			SELECT 019,'NOK','NOKX','NOK',NULL,NULL UNION        
			SELECT 020,'PLATA','PLATA','PLATA',NULL,NULL UNION          
			SELECT 021,'ORO','ORO','ORO',NULL,NULL UNION      
			SELECT 022,'UFXU','UFXU','UFX',NULL,NULL UNION      
			SELECT 023,'CLP','CLPX','CLP',NULL,NULL UNION      
			SELECT 024,'CLF','CLF','CLF',NULL,NULL UNION      
			SELECT 025,'CNY','CNYX','CNY',NULL,NULL UNION      
			SELECT 026,'AUD','AUDX','AUDX',NULL,NULL UNION      
			SELECT 027,'ARP','ARPX','ARP',NULL,NULL UNION      
			SELECT 028,'NZD','NZDX','NZD',NULL,NULL UNION      
			SELECT 029,'CNH','CNHX','CNH',NULL,NULL UNION 
			SELECT 030,'RUB','RUBX','RUB',NULL,NULL         
			    
			    
			-- SELECT * FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'ONFFE0D'    
			    
			DECLARE  @maxdate DATETIME       
			 SET @maxdate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB')     
			     
			  DECLARE  @maxdateONFFE0D DATETIME       
			SET @maxdateONFFE0D = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIrc WHERE txtIRC = 'ONFFE0D')      
			     
			     
			 
			INSERT @tblResult          
			SELECT 030,'Tasa ponderada de fondeo bancario','',(SELECT CAST(dblValue AS VARCHAR(50)) + '%' FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB' AND dteDate =@maxdate),''  UNION       
			SELECT 031,'','Overnight',(SELECT CAST(dblValue AS VARCHAR(50)) + '%' FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'ONFFE0D' AND dteDate =@maxdateONFFE0D),'' UNION       
			SELECT 032,'','Ventanilla MD','',''       
			    
			    
			--SELECT * FROM @tmp_tblUniverseIRC      
			-- Obtengo los valores de los IRC's      
			UPDATE d      
			SET d.dblValueOr = STR(ROUND(u.dblValue,9),16,9)      
			FROM @tmp_tblDirectivesIRC AS d      
			INNER JOIN @tmp_tblUniverseIRC AS u      
			ON d.txtIRC = u.txtIRC      
			WHERE      
			d.txtIRC <> '1'      
			  
			-- Obtengo los valores de los IRC's          
			UPDATE d      
			SET d.dblValue = STR(ROUND(u.dblValue,9),16,9)      
			FROM @tmp_tblDirectivesIRC AS d      
			INNER JOIN @tmp_tblUniverseIRC AS u      
			ON d.txtIRC2 = u.txtIRC      
			--   AND d.txtIRC IN ('EURU','GBPU','PLATA','ORO','UFXU','AUDX','CNHX')      
			WHERE      
			d.txtIRC <> '1'      
			  
			-- Obtengo los valores de los IRC's          
			UPDATE d      
			SET d.dblValueOr = STR(ROUND((u.dblValue * @dblUFXU),9),16,9)      
			FROM @tmp_tblDirectivesIRC AS d      
			INNER JOIN @tmp_tblUniverseIRC AS u      
			ON d.txtIRC = u.txtIRC      
			AND d.txtIRC = 'PLATA'      
			  
			-- Obtengo los valores de los IRC's          
			UPDATE d      
			SET d.dblValueOr = STR(ROUND((u.dblValue * @dblUFXU),9),16,9)      
			FROM @tmp_tblDirectivesIRC AS d      
			INNER JOIN @tmp_tblUniverseIRC AS u      
			ON d.txtIRC = u.txtIRC      
			AND d.txtIRC = 'ORO'      
			  
			-- Obtengo los valores de los IRC's          
			UPDATE d      
			SET d.dblValueOr = '1'      
			FROM @tmp_tblDirectivesIRC AS d      
			INNER JOIN @tmp_tblUniverseIRC AS u         ON d.txtIRC = u.txtIRC      
			AND d.txtIRC = 'UFXU'      
			     
			-- Obtengo los valores de los IRC's     CLF/ UFXU      
			  
			UPDATE d      
			SET d.dblValue = STR(ROUND((u.dblValue / @dblUFXU),9),16,9)      
			FROM @tmp_tblDirectivesIRC AS d   
			INNER JOIN @tmp_tblUniverseIRC AS u      
			ON d.txtIRC = u.txtIRC      
			AND d.txtIRC = 'CLF'      
			     
			     
			--SELECT * FROM @tmp_tblDirectivesIRC      
			     
			-- Obtengo los valores de los IRC's   TFB      
			      
			 DECLARE  @maxgetdate DATETIME       
			 SET @maxgetdate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB')      
			UPDATE d      
			SET d.dblValueOr = (SELECT CAST(dblValue AS VARCHAR(50)) + '%' FROM  MxFixIncome.dbo.tblIrc WHERE txtIRC = 'TFB' AND dteDate =@maxgetdate)      
			FROM @tmp_tblDirectivesIRC AS d      
			INNER JOIN @tmp_tblUniverseIRC AS u      
			ON d.txtIRC = u.txtIRC      
			AND d.txtIRC = 'TFB'      
			     
			  
			/*se agrega columna de descripcion en A1 */      
			DECLARE @tmpValuesDesc TABLE       
			(      
			txtIrc VARCHAR(50),      
			txtDesc VARCHAR(50)      
			)       
			      
			INSERT INTO @tmpValuesDesc      
			VALUES ('EUR','Euro/USD'),      
			('GBP','Libra/USD'),      
			('JPY','Yen/USD'),      
			('CAD','D. Canadian/USD'),      
			('DKK','Corona Danesa/USD'),      
			('CHF','Franco Suizo/USD '),      
			('SEK','Corona Sueca/USD'),      
			('BRL','Real Brasileño/USD'),      
			('NOK','Corona Noruega/USD'),      
			('PLATA','Plata spot'),      
			('ORO','Oro Spot'),      
			('UFXU','Peso/USDBanxico'),      
			('CLP','Peso Chileno/USD'),      
			('CLF','Peso Chileno/CLF'),      
			('CNY','Yuan Chino Onshore/USD'),      
			('AUD','Dólar Australiano/USD'),      
			('CNH','Yuan Chino Offshore/USD'),      
			('RUB','Rublo Ruso') 
			  
			/*se agrega un INNER JOIN con @tmpValuesDesc para ligar descripcion con irc's @tmp_tblDirectivesIRC */      
			INSERT @tblResult      
			SELECT             
			intSection,tmpValuesDesc.txtDesc,RTRIM(Label),LTRIM(dblValueOr),LTRIM(dblValue)       
			FROM @tmp_tblDirectivesIRC AS tblDirectivesIRC      
			INNER JOIN @tmpValuesDesc AS tmpValuesDesc      
			ON tblDirectivesIRC.txtIRC = tmpValuesDesc.txtIrc      
			  
			-- Reporto los datos      
			/*en lugar de fecha reportamos descripción*/      
			   
			IF EXISTS(      
			SELECT TOP 1 dteDate      
			FROM @tblResult      
			)      
			  
			SELECT      
			dteDate,      
			txtLabel,         
			dblValIRC1,         
			dblValIRC2      
			FROM @tblResult          
			ORDER BY       
			intSection          
			  
			ELSE      
			 RAISERROR ('ERROR: Falta Informacion', 16, 1)      
			  
			     
			SET NOCOUNT OFF       
	      
	END      



--SELECT * FROM  dbo.tblIrc
--WHERE txtIRC = 'RUB'
--AND dteDate = '20150305'

--SELECT * FROM  dbo.tblIrc
--WHERE txtIRC = 'RUBX'
--AND dteDate = '20150305'