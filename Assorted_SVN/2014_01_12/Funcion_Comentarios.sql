
dbo.sp_hCommenter 0,'','aaaaa'


 /*   
 Autor:   Omar Adrian Aceves Gtuerriez  
 Creacion:  20121214  
 Descripcion: Comentador Automatico 

*/ 
 ALTER    PROCEDURE dbo.sp_hCommenter  
 @BitUserAction  BIT = 0,
 @txtUser  varchar(100) = 'Anonimo',
 @UserDescription varchar(1000) = 'Sin comentarios Asignados'
 AS
 BEGIN
 
 
 SET @UserDescription  = 
 (
 SELECT CASE WHEN LEN(@UserDescription) = 0  OR @UserDescription IN ('',NULL,'-') 
 THEN 'Sin comentarios Asignados' 
 ELSE @UserDescription END
 )

 /*Nombres*/
 SET @txtUser = 
 (
 SELECT  
	CASE
		WHEN LEN(@txtUser) = 0  OR @txtUser IN ('',NULL,'-') THEN ( SELECT  SUBSTRING(CURRENT_USER,CHARINDEX('\',CURRENT_USER,0) +1,20)    )
		WHEN @txtUser IN ('o','O') THEN 'Omar Adrian Aceves Guttierez'
		--agregar case para ingresar nombre del usuario 
		ELSE @txtUser END
 )

 
 DECLARE @UserAction varchar(20)
 SET  @UserAction = (SELECT CASE WHEN @BitUserAction = 0 THEN 'Autor' ELSE 'Modifica'END )
 
 DECLARE @userActionDate varchar(30)
 SET  @userActionDate = (SELECT CASE WHEN @BitUserAction = 0 THEN 'Fecha de Creación' ELSE 'Fecha de Modificación' END )
 

 DECLARE  @ReportComment TABLE 
 (
 intId int IDENTITY(1,1),
 txtLine varchar(max)
 )
 
 
 INSERT INTO @ReportComment 
 SELECT '/*'  
INSERT INTO @ReportComment 
 SELECT @UserAction  +  ':  ' +@txtUser 
 INSERT INTO @ReportComment 
 SELECT @userActionDate + ':  '+  CONVERT(VARCHAR(50),GETDATE(),120) 
INSERT INTO @ReportComment  
 SELECT 'Descripcion  ' + ':   '  +  @UserDescription 
 INSERT INTO @ReportComment  
 SELECT '*/' 
 
 
 SELECT RTRIM(LTRIM(txtLine)) FROM  @ReportComment ORDER BY intId  ASC
 
 END 
 