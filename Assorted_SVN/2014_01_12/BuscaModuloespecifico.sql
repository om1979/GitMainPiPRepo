--create procedure sys.sp_helptext  
DECLARE @objname nvarchar(776)  = 'sp_productos_ACCIVAL'
DECLARE  @columnname sysname = NULL  
DECLARE @proDNum INT    = 2
--as   
--set nocount on  

DECLARE @mytableToHist TABLE
(
TEXT VARCHAR(400)
)

  
declare @dbname sysname  
,@objid int  
,@BlankSpaceAdded   int  
,@BasePos       int  
,@CurrentPos    int  
,@TextLength    int  
,@LineId        int  
,@AddOnLen      int  
,@LFCR          int --lengths of line feed carriage return  
,@DefinedLength int  
  
/* NOTE: Length of @SyscomText is 4000 to replace the length of  
** text column in syscomments.  
** lengths on @Line, #CommentText Text column and  
** value for @DefinedLength are all 255. These need to all have  
** the same values. 255 was selected in order for the max length  
** display using down level clients  
*/  
,@SyscomText nvarchar(4000)  
,@Line          nvarchar(255)  
  
select @DefinedLength = 255  
select @BlankSpaceAdded = 0 /*Keeps track of blank spaces at end of lines. Note Len function ignores  
                             trailing blank spaces*/  
CREATE TABLE #CommentText  
(LineId int  
 ,Text  nvarchar(255) collate database_default)  
  
/*  
**  Make sure the @objname is local to the current database.  
*/  
select @dbname = parsename(@objname,3)  
if @dbname is null  
 select @dbname = db_name()  
else if @dbname <> db_name()  
        begin  
                raiserror(15250,-1,-1)  
                --return (1)  
        end  
  
/*  
**  See if @objname exists.  
*/  
select @objid = object_id(@objname)  
if (@objid is null)  
        begin  
  raiserror(15009,-1,-1,@objname,@dbname)  
  --return (1)  
        end  
 

DECLARE @fromToLine  int = 0		
DECLARE @TotakNum  INT = 0
DECLARE @TotalLines INT = (
		SELECT LEN(b.definition) /255
			AS text from syscomments AS A
			INNER JOIN sys.numbered_procedures AS B
			ON a.id =B.object_id
			where id = @objid 
			and encrypted = 0  
			AND procedure_number = @proDNum
			AND A.colid =1 
			AND a.number = 1
		)
		
WHILE(@TotakNum <= @TotalLines )

		begin 		
INSERT INTO @mytableToHist
		SELECT 
		SUBSTRING(b.definition,@fromToLine,255)
		AS text from syscomments AS A
				INNER JOIN sys.numbered_procedures AS B
				ON a.id =B.object_id
				where id =@objid 
				and encrypted = 0  
				AND procedure_number = @proDNum
				AND A.colid =1 
				AND a.number = 1
				
			SET @fromToLine = @fromToLine + 255	
			SET @TotakNum =@TotakNum +1
		END 	




    begin  
        /*  
        **  Find out how many lines of text are coming back,  
        **  and return if there are none.  
        */  
        if (select count(*) from syscomments c, sysobjects o where o.xtype not in ('S', 'U')  
            and o.id = c.id and o.id = @objid) = 0  
                begin  
                        raiserror(15197,-1,-1,@objname)  
                        --return (1)  
                end  
  
        if (select count(*) from syscomments where id = @objid and encrypted = 0) = 0  
                begin  
                        raiserror(15471,-1,-1,@objname)  
                        --return (0)  
                end  
  
  declare ms_crs_syscom  CURSOR LOCAL  
  FOR

	SELECT TEXT FROM @mytableToHist	
		
  FOR READ ONLY  
  
    end  
  
/*  
**  else get the text.  
*/  
select @LFCR = 2  
select @LineId = 1  
  
  
OPEN ms_crs_syscom  
  
FETCH NEXT from ms_crs_syscom into @SyscomText  
  
WHILE @@fetch_status >= 0  
begin  
  
    select  @BasePos    = 1  
  select  @CurrentPos = 1  
    select  @TextLength = LEN(@SyscomText)  
  
    WHILE @CurrentPos  != 0  
    begin  
        --Looking for end of line followed by carriage return  
        select @CurrentPos =   CHARINDEX(char(13)+char(10), @SyscomText, @BasePos)  
  
        --If carriage return found  
        IF @CurrentPos != 0  
        begin  
            /*If new value for @Lines length will be > then the  
            **set length then insert current contents of @line  
            **and proceed.  
            */  
            while (isnull(LEN(@Line),0) + @BlankSpaceAdded + @CurrentPos-@BasePos + @LFCR) > @DefinedLength  
            begin  
                select @AddOnLen = @DefinedLength-(isnull(LEN(@Line),0) + @BlankSpaceAdded)  
                INSERT #CommentText VALUES  
                ( @LineId,  
                  isnull(@Line, N'') + isnull(SUBSTRING(@SyscomText, @BasePos, @AddOnLen), N''))  
                select @Line = NULL, @LineId = @LineId + 1,  
                       @BasePos = @BasePos + @AddOnLen, @BlankSpaceAdded = 0  
            end  
            select @Line    = isnull(@Line, N'') + isnull(SUBSTRING(@SyscomText, @BasePos, @CurrentPos-@BasePos + @LFCR), N'')  
            select @BasePos = @CurrentPos+2  
            INSERT #CommentText VALUES( @LineId, @Line )  
            select @LineId = @LineId + 1  
            select @Line = NULL  
        end  
        else  
        --else carriage return not found  
        begin  
            IF @BasePos <= @TextLength  
            begin  
                /*If new value for @Lines length will be > then the  
                **defined length  
                */  
                while (isnull(LEN(@Line),0) + @BlankSpaceAdded + @TextLength-@BasePos+1 ) > @DefinedLength  
                begin  
                    select @AddOnLen = @DefinedLength - (isnull(LEN(@Line),0) + @BlankSpaceAdded)  
                    INSERT #CommentText VALUES  
                    ( @LineId,  
                      isnull(@Line, N'') + isnull(SUBSTRING(@SyscomText, @BasePos, @AddOnLen), N''))  
                    select @Line = NULL, @LineId = @LineId + 1,  
                        @BasePos = @BasePos + @AddOnLen, @BlankSpaceAdded = 0  
                end  
                select @Line = isnull(@Line, N'') + isnull(SUBSTRING(@SyscomText, @BasePos, @TextLength-@BasePos+1 ), N'')  
                if LEN(@Line) < @DefinedLength and charindex(' ', @SyscomText, @TextLength+1 ) > 0  
                begin  
                    select @Line = @Line + ' ', @BlankSpaceAdded = 1  
                end  
            end  
        end  
    end  
  
 FETCH NEXT from ms_crs_syscom into @SyscomText  
end  
  
IF @Line is NOT NULL  
    INSERT #CommentText VALUES( @LineId, @Line )  
  
select Text from #CommentText order by LineId  
  
CLOSE  ms_crs_syscom  
DEALLOCATE  ms_crs_syscom  
  
DROP TABLE  #CommentText  
  
--return (0) -- sp_helptext  