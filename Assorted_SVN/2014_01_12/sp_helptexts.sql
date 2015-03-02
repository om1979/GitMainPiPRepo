USE [JProCo]
GO

/****** Object:  StoredProcedure [dbo].[usp_helptexts]   Script Date: 06/07/2013 00:21:53:510 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_helptexts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_helptexts]
GO

USE [JProCo]
GO

/****** Object:  StoredProcedure [dbo].[usp_helptexts]   Script Date: 06/07/2013 00:21:53:510 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*************************************************************   
** File:     [usp_helptexts]  
** Author:   Prasad Sahoo
** Description: Child script of usp_helptext
** Purpose:   Merged script for multiple input objects
** Date:   06/07/2013
  
**************************************************************   
** Change History   
**************************************************************   
** PR   Date        Author				Change Description    
** --   --------    -------			-----------------------------  
** 1    06/07/2013  Prasad Sahoo			Created
**************************************************************/    

CREATE PROC usp_helptexts
(
@ObjNames nvarchar(max)
)
as
begin
SET NOCOUNT ON 

DECLARE @dbname varchar(50)
set @dbname = 'USE [' + (SELECT DB_NAME()) + ']'

CREATE TABLE #MergedScript
(Texts varchar(max))

DECLARE @CurObj varchar(max)
DECLARE @CurSelect CURSOR
SET @CurSelect = CURSOR FOR
SELECT RTRIM(LTRIM(ID)) FROM (SELECT ID FROM udf_CSVsplit(@ObjNames, ',')) Temp

OPEN @CurSelect
FETCH NEXT
FROM @CurSelect INTO @CurObj
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO #MergedScript (Texts)
EXECUTE Usp_helptext @CurObj
INSERT INTO #MergedScript (Texts)
VALUES (''), ('')
FETCH NEXT
FROM @CurSelect INTO @CurObj
END
CLOSE @CurSelect
DEALLOCATE @CurSelect

UPDATE #MergedScript SET Texts = '' where Texts = @dbname
SELECT Texts FROM #MergedScript
DROP TABLE #MergedScript
end

