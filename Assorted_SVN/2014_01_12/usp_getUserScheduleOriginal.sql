  
  
  
    --usp_getUserSchedule  'pe','','','','','20130819','20131031','',''  
  
-- ===========================================================    
-- Author:  Abraham Alamilla    
-- Create date: 2013/06/24 10:35:00    
-- Description: Obtiene el reporte de la bitácora del usuario    
-- Author:  Abraham Alamilla    
-- Modified: 20130703 11:10    
-- Description: Se agrega parámetro para exportación    
-- ===========================================================    
CREATE PROCEDURE usp_getUserSchedule     
 -- Add the parameters for the stored procedure here    
    @txtCountry CHAR(2)    
   ,@intClientId INT = NULL    
   ,@intCompanyId INT = NULL    
   ,@txtUsername VARCHAR(50) = NULL    
   ,@txtName VARCHAR(50) = NULL    
   ,@dteBeg DATETIME = NULL    
   ,@dteEnd DATETIME    
   ,@txtCompanyName VARCHAR(50) = NULL    
   ,@intReportType INT = 0    
AS     
    BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
        SET NOCOUNT ON;    
        -- Creo tabla de datos de usuario    
        CREATE TABLE #tblUsersData    
            (    
             intClientId INT    
            ,txtUsername VARCHAR(50)    
            ,txtName VARCHAR(150)    
            ,txtCompanyDescription VARCHAR(150)    
            ,txtSCountry CHAR(2)    
            ,txtEmail VARCHAR(50)    
            ,txtPhone VARCHAR(50)    
            ,dteEffective DATETIME    
            ,dteEnd DATETIME    
            )    
                
        CREATE TABLE #tblReport    
            (    
             [intId] INT    
            ,[txtCountry] CHAR(4)    
            ,[dteDate] CHAR(10)    
            ,[txtUsername] VARCHAR(50)    
            ,[txtName] VARCHAR(150)    
            ,[txtEmail] VARCHAR(50)    
            ,[txtPhone] VARCHAR(50)    
            ,[dteEffective] DATETIME    
            ,[dteEnd] DATETIME  
            ,[txtCompanyName] VARCHAR(150)    
            ,[txtController] VARCHAR(100)    
            ,[txtAction] VARCHAR(100)    
            ,[intVisits] INT     
            )    
                
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
                   ,cliCat.dteEffective    
              ,cliCat.dteEnd    
                FROM    
                    dbo.tblClientsCatalog cliCat    
                    INNER JOIN dbo.tblCompaniesCatalog compCat ON cliCat.intCompanyId = compCat.intCompanyId    
                                                              AND cliCat.txtSCountry = compCat.txtSCountry    
                WHERE    
                    cliCat.txtSCountry = @txtCountry -- Selección de país    
                    AND cliCat.intClientId LIKE '%'    
                    + RTRIM(ISNULL(CAST(@intClientId AS CHAR(10)), '%')) + '%' -- Id del cliente    
                    AND cliCat.txtUsername LIKE ISNULL(@txtUsername, '%')    
                    + '%' -- Nombre de usuario    
                    AND CONCAT(cliCat.txtName, cliCat.txtLastName,    
                               cliCat.txtLastName2) LIKE '%' + ISNULL(@txtName,    
                                                              '%') + '%' -- Datos del usuario    
                    AND compCat.txtName LIKE '%' + ISNULL(@txtCompanyName, '%')    
                    + '%' -- Nombre de la empresa    
                    AND compCat.intCompanyId LIKE '%'    
                    + RTRIM(ISNULL(CAST(@intCompanyId AS CHAR(10)), '%'))    
                    + '%';    
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
                        + ISNULL(@txtName, '%') + '%' -- Datos del usuario    
                        AND CONVERT(CHAR(10), ua.dteDate, 111) BETWEEN ISNULL(@dteBeg,    
                                                              @dteEnd)    
                                                              AND    
                                                              @dteEnd -- Fechas    
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
                       ,uData.dteEffective [dteEffective]    
                       ,uData.dteEnd [dteEnd]    
                       ,uData.txtCompanyDescription [txtCompanyName]    
                       ,contCat.txtDescription [txtController]    
                       ,actCat.txtDescription [txtAction]    
                       ,uaReport.intCount [intVisits]    
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
           ,CONVERT(varCHAR(11),dteEffective,112)  AS Fecha1  
           ,CONVERT(CHAR(11),dteEnd,112)  AS fecha2   
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