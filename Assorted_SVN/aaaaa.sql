



SELECT * FROM  CoProcesses..tblProcessBinnacle AS TPB
WHERE txtProcess = 'TRANSFER_LAWEB_BOCEA'

C:\WINDOWS\TEMP\BEEA3E6A7BDD4610ABDB975129C3BD4B.wsf(27, 3) 
Execute: Execute.EecuteStoredProcedure.Query timeout expired

1900-01-01 17:42:44.997


C:\WINDOWS\TEMP\AEEDEB5D335B4339BF33B34AE3D3A0F3.wsf(27, 3)
 Execute: Execute.EecuteStoredProcedure.Query timeout expired
 
 
 

SELECT * FROM   CoProcesses..tblProcessBinnacle AS TPB
WHERE txtProcess IN
(
'TRANSFER_LAWEB_PRICES_ACC' --1900-01-01 17:45:11.710
--'TRANSFER_LAWEB_BOCEA' --1900-01-01 17:47:15.637
--'TRANSFER_LAWEB_PRICES_EUR'--1900-01-01 17:47:54.983
)


--UPDATE  CoProcesses..tblProcessBinnacle 
--SET txtstatus = 'END'
--WHERE txtProcess IN
--(
----'TRANSFER_LAWEB_PRICES_ACC' --1900-01-01 17:45:11.710
----'TRANSFER_LAWEB_BOCEA' --1900-01-01 17:47:15.637
--'TRANSFER_LAWEB_PRICES_EUR'--1900-01-01 17:47:54.983
--)
--AND dteEndTime = '1900-01-01 17:47:54.983'






SELECT * FROM   CoProcesses..tblProcessBinnacle AS TPB
WHERE txtProcess IN (
'TRANSFER_LAWEB_PRICES_ACC',
'TRANSFER_LAWEB_BOCEA',
'TRANSFER_LAWEB_PRICES_EUR')







C:\WINDOWS\TEMP\CA76757600B84D10954DE1E07B3319DA.wsf(28, 3)
 Execute: Execute.EecuteStoredProcedure.Query timeout expired


C:\WINDOWS\TEMP\F5EBB987E4324EF8B17F2853EF2DF181.wsf(28, 3) Execute: Execute.EecuteStoredProcedure.Query timeout expired
SELECT DATEDIFF(hours,'1900-01-01 17:42:44.997','1900-01-01 17:47:54.983')

SELECT 47-42

SELECT '.'+ txtParameter + ' = ' + '"' + txtValue + '"' FROM  CoProcesses..tblProcessParameters AS TPP
WHERE txtProcess IN (
--'TRANSFER_LAWEB_PRICES_ACC',
'TRANSFER_LAWEB_BOCEA'--,
--'TRANSFER_LAWEB_PRICES_EUR'
)

SELECT * FROM  CoProcesses..tblProcessCatalog AS TPC 
WHERE txtProcess IN (
--'TRANSFER_LAWEB_PRICES_ACC',
'TRANSFER_LAWEB_BOCEA'--,
--'TRANSFER_LAWEB_PRICES_EUR'
)

1
2
3
4
5
6
CREATE PROCEDURE [dbo].[foo_1] @x int AS
  PRINT 'x is ' + CONVERT(varchar(8), @x)



CREATE PROCEDURE [dbo].[foo_2] @x char AS
  PRINT 'x is ' + @x
  
  
  
  
GO
If you want to kn



20150213

usp_GenerateVectorsLoadCommands;3 'CO','20150213',5000,'[VEC_SYNC_PATH]'
usp_transfer_instruments;401 'CO', '20150213', 'BOCEA'
usp_GenerateVectorsLoadCommands;1 'CO','20150213',100000,'[VEC_SYNC_PATH]'
usp_GenerateVectorsLoadCommands;5 'CO','[VEC_SYNC_PATH]'


usp_GenerateVectorsLoadCommands;3 'CO','20150215',5000,'[VEC_SYNC_PATH]'
usp_transfer_instruments;401 'CO', '20150215', 'ACCIONES'
usp_GenerateVectorsLoadCommands;1 'CO','20150215',100000,'[VEC_SYNC_PATH]'
usp_GenerateVectorsLoadCommands;5 'CO','[VEC_SYNC_PATH]'



usp_GenerateVectorsLoadCommands;3 'CO','20150215',5000,'[VEC_SYNC_PATH]'
usp_transfer_instruments;401 'CO', '20150215', 'EUROBONOS'
usp_GenerateVectorsLoadCommands;1 'CO','20150215',100000,'[VEC_SYNC_PATH]'
usp_GenerateVectorsLoadCommands;5 'CO','[VEC_SYNC_PATH]'

usp_transfer_instruments;401 'CO','20150213', 'BOCEA'

sp_helptext usp_transfer_instruments


SELECT * FROM  sys.tables 
WHERE name = 'tblLog'


TRANSFER_LAWEB_BOCEA	    1900-01-01 00:10:01.667	    1900-01-01 00:10:01.667
TRANSFER_LAWEB_PRICES_ACC	1900-01-01 00:05:00.000		1900-01-01 00:05:00.000
TRANSFER_LAWEB_PRICES_EUR	1900-01-01 00:05:00.000		1900-01-01 00:05:00.000


SELECT * FROM  CoProcesses..tblProcessBinnacle AS TPB
WHERE txtProcess = 'TRANSFER_LAWEB_GUB'




SELECT * FROM  SYNCRO_tblSubsidiaryDictionary


SELECT * 
FROM dbo.tblSubsidiaryDictionary AS sDic
	WHERE txtCountry = 'CO'
	
SELECT * FROM  CoProcesses..tblProcessCatalog AS TPC
WHERE txtProcess = 'TRANSFER_LAWEB_BOCEA'


SELECT * FROM CoProcesses..tblProcessParameters AS TPP
WHERE txtProcess = 'TRANSFER_LAWEB_BOCEA'

SELECT * FROM  CoProcesses..tblConstants AS TC
WHERE txtConstant = 'VEC_SYNC_PATH'


VEC_SYNC_PATH








--UPDATE CoProcesses..tblProcessDurations
--SET dteAllowed = '1900-01-01 00:30:01.667'
--WHERE txtProcess 
-- IN (
--'TRANSFER_LAWEB_PRICES_ACC',
--'TRANSFER_LAWEB_BOCEA',
--'TRANSFER_LAWEB_PRICES_EUR')




SELECT * FROM  
CoProcesses..tblProcessDurations AS TPD
WHERE txtProcess 
 IN (
'TRANSFER_LAWEB_PRICES_ACC',
'TRANSFER_LAWEB_BOCEA',
'TRANSFER_LAWEB_PRICES_EUR')








--300


UPDATE CoProcesses..tblProcessParameters
SET txtValue = 1000
WHERE txtProcess = 'TRANSFER_LAWEB_PRICES_EUR'
AND txtParameter = 'TimeOut'



sp_helptext  usp_GenerateVectorsLoadCommands


SELECT * FROM  CoProcesses..tblProcessParameters AS TPP
WHERE txtProcess IN (
'TRANSFER_LAWEB_BOCEA')

sp_helptext usp_Transfer_Vectores_Cloud;1



SELECT * FROM  CoProcesses..tblProcessBinnacle AS TPB
WHERE txtProcess = 'VECTOR_DAT_CLOUD_ACC'



CREATE PROCEDURE [dbo].[usp_Transfer_Vectores_Cloud]


sp_helptext usp_GeneraVectorsToLaWeb









  
-------------------------------------------------------------------------------------------------------------------  
--  
-- Autor:  Jorge Sergio Carsi Zúñiga  
-- Fecha Creacion: 10 de Octubre, 2012  
-- Autor Modif.:   
-- Fecha Modif.:   
-- Version: 1.0.0.1  
-- Descripcion:  - Sube Información de Vectores hacia la Nube  
  
--  
-------------------------------------------------------------------------------------------------------------------  
AS  
BEGIN  
   
  SET NOCOUNT ON  
    
  exec SQLPREAZURE.LaWeb.dbo.usp_GeneraVectorsToLaWeb;1 'CO'  
  
  
  SET NOCOUNT OFF  
  
END  
  
  
  
  
  CREATE PROCEDURE [dbo].[usp_GeneraVectorsToLaWeb]                
 @txtCountry AS CHAR (2)                
 ,@txtDate AS CHAR(8) = ''                
AS                
--------------------------------------------------------------------------------------------------                
--Autor:          JATO                
--Creacion:   01:46 p.m. 2013-02-21                
--Descripción:     Procedimiento que sincroniza los vectores hacia azure                
--Modificado por: CSOLORIO                
--Modificacion:  20130409                
--Descripción:  Modifico el llamado a la sincronizacion de catalogos                
--------------------------------------------------------------------------------------------------                
BEGIN                
                
 SET NOCOUNT ON            
          
 -- determino la fecha de ejecucion                
 IF @txtDate = ''                
  SELECT                 
   @txtDate = CONVERT(CHAR(8), dtePrices, 112)                
  FROM dbo.tblSubsidiaryDictionary                
  WHERE                 
   txtCountry = @txtCountry                
         
 -- depuro directorios                
 EXEC dbo.usp_GeneraVectoresToAzure;5 @txtCountry                
          
 -- sincronizo catalogos locales                
 EXEC dbo.usp_GeneraVectoresToAzure;3 @txtCountry, @txtDate, 5000                 
          
 -- cargo datos del dia                
 EXEC dbo.usp_GeneraVectoresToAzure;1 @txtCountry, @txtDate, 10000             
   
 -- Sincronizo catalogos en Azure   
 --DECLARE @txtCommand AS VARCHAR(200)    
 --SET @txtCommand = '"usp_GeneraVectoresToAzure;4 @txtCountry = ' + '''' + @txtCountry + ''',@txtDate = ''' + @txtDate + '''"'  
 --EXEC usp_ExecuteAzureQuery @txtCommand  
 EXEC SQLAZURE.LaWeb_DRP.dbo.usp_GeneraVectoresToAzure;4 @txtCountry, @txtDate                
         
 -- sincronizaciones particulares                
 IF @txtCountry = 'MX'  
 BEGIN                
 EXEC dbo.usp_GeneraVectoresToAzure;2 @txtDate, 10000                
 END  
    
 SET NOCOUNT OFF                
  
END  