
----0
--SELECT 
--dbo.fun_IsTradingDate((SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112)),'MX')




---- 1
--SELECT 
--CONVERT(VARCHAR(10),dbo.fun_NextTradingDate((SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112)),-1,'MX'),112)




DECLARE @txtDate  DATETIME = '20140530'
DECLARE @txtMyLatDate  INT  = (SELECT dbo.fun_IsTradingDate((SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112)),'MX'))


DECLARE @txtDateToExecute VARCHAR(10)
 IF (@txtMyLatDate = 1)
	SET @txtDateToExecute = (SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112))
 ELSE 
 BEGIN 
	 SET @txtDateToExecute =(  CONVERT(VARCHAR(10),dbo.fun_NextTradingDate((SELECT CONVERT(VARCHAR(10),DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE())+1,0)),112)),-1,'MX'),112))
 END 


    IF (@txtDate = @txtDateToExecute)
    BEGIN
		SELECT 'a trabajar!'
    END 
    ELSE 
		BEGIN 
		DECLARE  @TxtErrorMessage  VARCHAR(100)=  'Error solo se debe ejecutar cada fin de mes proxima fecha: ' + @txtDateToExecute

		
		RAISERROR ( @TxtErrorMessage,11,2,3)
		END
    
    
    
    
  