


--back usp_getUserSchedule1




sp_helptext usp_getUserSchedule1


CREATE   PROCEDURE usp_getUserSchedule1  --'cr',null,null,null,'8064','20140101','20140107',null,null,1      
    --usp_getUserSchedule1 'CR',NULL,1109,NULL,NULL,'20140101','20140109',NULL,null,1    
        
  
    --usp_getUserSchedule1    
    --'CR'    
    --,NULL    
    --,1109    
    --,null    
    --,NULL    
    --,'20140101'    
    --,'20140109'    
    --,'null'    
    --,NULL    
    --,1      
        
    --DECLARE @txtCountry CHAR(2) = 'cr'        
    --,@intClientId INT = NULL              
    --,@intCompanyId INT = 1109              
    --,@txtUsername VARCHAR(50) = NULL             
    --,@txtName VARCHAR(50) = NULL        
    --,@dteBeg DATETIME = '20140101'              
    --,@dteEnd DATETIME = '20140107'          
    --,@txtCompanyName VARCHAR(50) = NULL       
    --,@txtName1 VARCHAR(50) = NULL       
    --,@intReportType INT = 1    
        
        
--'pe',10561,'','','',NULL,'',''            
 -- Add the parameters for the stored procedure here              
    @txtCountry CHAR(2)              
   ,@intClientId INT = NULL              
   ,@intCompanyId INT = NULL              
   ,@txtUsername VARCHAR(50) = NULL              
   ,@txtName VARCHAR(50) = NULL              
   ,@dteBeg DATETIME = NULL              
   ,@dteEnd DATETIME = ''           
   ,@txtCompanyName VARCHAR(50) = NULL        
   ,@txtName1 VARCHAR(50) = NULL         
   ,@intReportType INT = 0             
         
AS               
BEGIN              
 -- SET NOCOUNT ON added to prevent extra result sets from              
 -- interfering with SELECT statements.              
        SET NOCOUNT ON;              
        -- Creo tabla de datos de usuario           
        
  --usp_getUserSchedule1 'MX',null,null,null,'ldejesus',null,'',NULL        
          
    
    if (@txtCompanyName = 'null')      
 begin      
    set @txtCompanyName = null     
 end      
      
      
 if (@txtName != '')      
 begin      
    set @intClientId = convert(int,@txtName)      
 end      
      
  --DECLARE @txtCountry CHAR(2) = 'cr'        
  --  ,@intClientId INT = NULL              
  --  ,@intCompanyId INT = 1109              
  --  ,@txtUsername VARCHAR(50) = NULL             
  --  ,@txtName VARCHAR(50) = NULL        
  --  ,@dteBeg DATETIME = '20140101'              
  --  ,@dteEnd DATETIME = '20140107'          
  --  ,@txtCompanyName VARCHAR(50) = NULL       
  --  ,@txtName1 VARCHAR(50) = NULL       
  --  ,@intReportType INT = 1    
      
      
     SELECT @intClientId = intClientId        
     FROM dbo.tblClientsCatalog        
     WHERE txtUsername = @txtUsername        
     AND txtSCountry = @txtCountry        
     AND intStatus = 1      
     if (@intClientId = '')    
     begin    
     set @intClientId = null    
     end    
             
  if object_id('tempdb..#tblUsersData') is not null  
   drop table #tblUsersData  
             
        CREATE TABLE #tblUsersData              
            (              
             intClientId INT              
            ,txtUsername VARCHAR(50)              
            ,txtName VARCHAR(150)              
            ,txtCompanyDescription VARCHAR(150)              
            ,txtSCountry CHAR(2)              
            ,txtEmail VARCHAR(50)              
            ,txtPhone VARCHAR(50)              
            ,dteEffective CHAR(11)                
            ,dteEnd CHAR(11)                
            )              
                    
        -- Drop table para pruebas  
  IF OBJECT_ID('tempdb..#tblReport') IS NOT NULL  
                DROP TABLE  #tblReport  
                  
        CREATE TABLE #tblReport              
            (              
             [intId] INT              
            ,[txtCountry] CHAR(4)              
            ,[dteDate] CHAR(10)              
            ,[txtUsername] VARCHAR(50)              
            ,[txtName] VARCHAR(150)              
            ,[txtEmail] VARCHAR(50)              
            ,[txtPhone] VARCHAR(50)              
            ,[dteEffective] varchar(150)   
            ,[dteEnd] varchar(150)            
            ,[txtCompanyName] VARCHAR(150)              
            ,[txtController] VARCHAR(100)              
            ,[txtAction] VARCHAR(100)              
            ,[intVisits] VARCHAR(50)               
            )             
      
      
        if (@dteEnd  = '')        
     begin        
       set @dteEnd = (select convert(char(10), max(dtedate),112) from tblUserActivityHist as ua        
       inner join tblClientsCatalog  as cliCat        
       on ua.intClientId = cliCat.intClientId          
       where cliCat.intClientId  = @intClientId)        
     end             
        
                    --  SELECT * FROM #tblReport    
        IF @intReportType = 1               
            INSERT  INTO #tblReport              
                    (               
                     intId  
                    ,txtCountry  
                    ,dteDate  
                    ,txtUsername  
      ,txtName  
                    ,txtEmail              
                    ,txtPhone              
                   ,dteEffective              
                    ,dteEnd              
                    ,txtCompanyName              
                    ,txtController              
                    ,txtAction              
                    ,intVisits              
                    )              
            VALUES              
                    (               
                     -1-- intId - int              
                    ,'País' -- txtCountry - char(2)              
                    ,'Fecha'-- dteDate - char(10)              
                    ,'Usuario' -- txtUsername - varchar(50)              
                    ,'Nombre' -- txtName - varchar(150)              
                    ,'Correo' -- txtEmail - varchar(50)              
                    ,'Teléfono' -- txtPhone - varchar(50)              
                    ,'Fecha de contratación' -- dteEffective - char(21)              
      ,'Fecha vencimiento' -- dteEnd - char(17)              
                    ,'Compañía' -- txtCompanyName - varchar(150)              
                    ,'Sección' -- txtController - varchar(100)              
                    ,'Subsección' -- txtAction - varchar(100)              
                    ,'Visitas'  -- intVisits - char(10)              
                    )              
            
                
        INSERT  #tblUsersData              
                (               
                 intClientId              
                ,txtUsername              
                ,txtName              
                ,txtCompanyDescription              
                ,txtSCountry              
                ,txtEmail              
                ,txtPhone              
                ,dteEffective              
                ,dteEnd              
                )      
                SELECT              
                    cliCat.intClientId              
                   ,cliCat.txtUsername              
                   ,cliCat.txtName + ' ' + cliCat.txtLastName + ' '              
                    + cliCat.txtLastName2              
                   ,compCat.txtName              
                   ,cliCat.txtSCountry              
                   ,cliCat.txtEmail              
                   ,cliCat.txtPhone              
                   ,CONVERT(CHAR(10),cliCat.dteEffective,111)AS  dteEffective          
                   ,CONVERT(CHAR(10),cliCat.dteEnd,111)AS  dteEffective          
                FROM              
                    dbo.tblClientsCatalog cliCat              
                    INNER JOIN dbo.tblCompaniesCatalog compCat ON cliCat.intCompanyId = compCat.intCompanyId              
                                                              AND cliCat.txtSCountry = compCat.txtSCountry              
                WHERE              
                    cliCat.txtSCountry = @txtCountry -- Selección de país              
                    AND cliCat.intClientId LIKE '%' + RTRIM(ISNULL(CAST(@intClientId AS CHAR(10)), '%')) + '%' -- Id del cliente              
                    AND cliCat.txtUsername LIKE ISNULL(@txtUsername, '%')              
                    + '%' -- Nombre de usuario              
                    AND CONCAT(cliCat.txtName, cliCat.txtLastName,cliCat.txtLastName2) LIKE '%' + ISNULL(@txtName1, '%') + '%' -- Datos del usuario              
                    AND compCat.txtName LIKE '%' + ISNULL(@txtCompanyName, '%') + '%' -- Nombre de la empresa              
                    AND compCat.intCompanyId LIKE '%' + RTRIM(ISNULL(CAST(@intCompanyId AS CHAR(10)), '%')) + '%';          
                            
                                
      -- Id de la empresa              
              
  -- Hago conteo de número de visitas              
        WITH    tblUserActivityReport ( intClientId, dteDate, txtController, txtAction, intCount )              
                  AS ( SELECT              
       cliCat.intClientId              
         ,CONVERT(CHAR(10), ua.dteDate, 111)              
         ,ua.txtController              
         ,ua.txtAction              
       ,COUNT(ua.txtAction)              
                       FROM              
                        dbo.tblClientsCatalog cliCat              
       INNER JOIN dbo.tblUserActivityHist ua ON ua.intClientId = cliCat.intClientId              
       INNER JOIN #tblUsersData uData ON cliCat.intClientId = uData.intClientId              
                       WHERE              
       cliCat.txtSCountry = @txtCountry -- Selección de país              
       AND cliCat.intClientId LIKE '%'              
       + RTRIM(ISNULL(CAST(@intClientId AS CHAR(10)), '%'))              
       + '%' -- Id del cliente              
       AND cliCat.txtUsername LIKE ISNULL(@txtUsername, '%')              
       + '%' -- Nombre de usuario              
       AND CONCAT(cliCat.txtName, cliCat.txtLastName,              
         cliCat.txtLastName2) LIKE '%'              
       + ISNULL(@txtName1, '%') + '%' -- Datos del usuario              
       AND CONVERT(CHAR(10), ua.dteDate, 111) BETWEEN ISNULL(@dteBeg,@dteEnd)              
        AND @dteEnd -- Fechas              
             GROUP BY              
        cliCat.intClientId              
        ,CONVERT(CHAR(10), ua.dteDate, 111)              
        ,ua.txtController              
        ,ua.txtAction              
                     )              
            -- Genero reporte, limito a 65000 registros para exportación              
            INSERT  INTO #tblReport              
                    (               
                     intId              
                    ,txtCountry              
                    ,dteDate              
                    ,txtUsername              
                    ,txtName              
                    ,txtEmail              
                    ,txtPhone              
                    ,dteEffective          
      ,dteEnd          
                    ,txtCompanyName              
                    ,txtController              
                    ,txtAction              
                    ,intVisits              
                    )              
                    SELECT DISTINCT TOP 65000              
                        1              
                       ,uData.txtSCountry [txtCountry]              
                       ,uaReport.dteDate [dteDate]              
                       ,uData.txtUsername [txtUsername]              
                       ,dbo.fun_varcharToProperCase(uData.txtName) [txtName]              
                       ,uData.txtEmail [txtEmail]              
                       ,uData.txtPhone [txtPhone]              
                       ,CONVERT(CHAR(11),uData.dteEffective , 111)            
                       ,CONVERT(CHAR(11),uData.dteEnd , 112)                
       ,uData.txtCompanyDescription [txtCompanyName]              
                       ,contCat.txtDescription [txtController]           
                       ,actCat.txtDescription [txtAction]              
                       ,convert(varchar(10),uaReport.intCount) [intVisits]              
                    FROM              
                        tblUserActivityReport uaReport              
                        INNER JOIN #tblUsersData uData ON uaReport.intClientId = uData.intClientId              
                        INNER JOIN dbo.tblControllersCatalog contCat ON contCat.txtName = uaReport.txtController              
                        INNER JOIN dbo.tblActionsCatalog actCat ON actCat.txtName = uaReport.txtAction              
                    ORDER BY              
                        uaReport.dteDate              
                       ,uData.txtUsername              
                                     
        SELECT              
            txtCountry              
           ,dteDate              
           ,txtUsername              
           ,txtName              
           ,txtEmail              
                     
           ,txtPhone              
           ,dteEffective          
           ,dteEnd          
           ,txtCompanyName              
           ,txtController              
           ,txtAction              
           ,intVisits              
        FROM              
            #tblReport r              
        ORDER BY              
            intId              
           ,dteDate              
           ,txtUsername              
              
              
   END   