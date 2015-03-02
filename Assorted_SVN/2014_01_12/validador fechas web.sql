
DECLARE 
@SysDate varchar(10),
@Mes varchar(2),
@Anio varchar(4),
@FechaTabla varchar(20),

@filial AS VARCHAR(3),
@bandera AS INT,
@banderaConsulta AS INT,
@TempLocalTable AS VARCHAR(200),
@TempLocalTableHist AS VARCHAR(200),
@consultaSQL AS VARCHAR(200),
@TipoConsulta AS varchar(10),
@TipoConsultaStoreParameter AS varchar(10),
@consulta varchar(200)
	SET @bandera = 0
	SET @banderaConsulta = 1
	SET @TipoConsulta = 'Vectors'
	SET  @TipoConsultaStoreParameter = ''''+ @TipoConsulta +''''
	---FechaTabla---------------------------------------
		SET @SysDate =   CONVERT(CHAR(10),GETDATE(),112)
		SET @Mes = SUBSTRING ( @SysDate,5,2) 
		--SET @Mes = '10'
		SET @Anio = SUBSTRING ( @SysDate,0,5) 
		SET @FechaTabla = '_'+ @Anio + '_' + @Mes
		PRINT @FechaTabla
	------------------------------------------
WHILE (@banderaConsulta <= 2)
BEGIN
	WHILE (@bandera < 3)
		BEGIN 
			IF @bandera = 0 
				SET @filial = 'CO'
			IF @bandera = 1 
				SET @filial = 'CR'
			IF @bandera = 2 
				SET @filial = 'MX'
				PRINT @TipoConsulta
				
				IF OBJECT_ID('tempdb..#TempLocalTable') IS  NULL 
				CREATE TABLE   #TempLocalTable(dtedate  datetime)
				
				IF OBJECT_ID('tempdb..#TempLocalTableHist') IS  NULL 
				CREATE TABLE   #TempLocalTableHist(dtedate  datetime)
				
SET @TempLocalTable = 'SELECT   DISTINCT TOP 7 dtedate  INTO #TempLocalTable FROM SQLAZURE.laweb_bk.'+ @filial +'.tbl'+@TipoConsulta + '  ORDER BY dtedate DESC'
SET @TempLocalTableHist = 'SELECT   DISTINCT TOP 7 dtedate  INTO #TempLocalTableHist FROM SQLAZURE_'+@filial+'.laweb'+@filial+'.dbo.tbl'+@TipoConsulta+ +@FechaTabla + ' ORDER BY dtedate DESC' 
	PRINT @TempLocalTable
	PRINT @TempLocalTableHist
	EXEC(@TempLocalTable)
	EXEC(@TempLocalTableHist)

	PRINT 'intento de consulta TempTable'

SET @consultaSQL = 'SELECT  DISTINCT TOP 7 dtedate  FROM #TempLocalTable  WHERE NOT EXISTS (SELECT  DISTINCT TOP 7 dtedate FROM #TempLocalTableHist )' 
			
			EXEC(@consultaSQL)
				--PRINT @consultaSQL

		IF @@ROWCOUNT = 0
		BEGIN
			PRINT '0 registros afectados en: ' + @filial
						IF @banderaConsulta = 2
							BEGIN 
								 SET @TipoConsulta = 'Curves'
								SET @TipoConsultaStoreParameter = ''''+ @TipoConsulta +''''
							END
				IF @bandera = 0 
			BEGIN
				SET  @consulta = 'SQLAZURE.laweb_bk.dbo.usp_DeleteVectorsCurvesTest '+ @TipoConsultaStoreParameter +', '''','''','''',''CO'','''','''','''','''','''','''','''','''',''''   '
				PRINT @consulta
				EXEC(@consulta)
				 PRINT 'COLOMBIA'
			END
				  IF @bandera = 1 
							BEGIN
								SET  @consulta = 'SQLAZURE.laweb_bk.dbo.usp_DeleteVectorsCurvesTest '+ @TipoConsultaStoreParameter +', '''','''','''',''CR'','''','''','''','''','''','''','''','''',''''   '
								PRINT @consulta
								EXEC(@consulta)
								 PRINT 'COSTA RICA'
							END   

							IF @bandera = 2 
							BEGIN    
								SET  @consulta = 'SQLAZURE.laweb_bk.dbo.usp_DeleteVectorsCurvesTest '+ @TipoConsultaStoreParameter +', '''','''','''',''MX'','''','''','''','''','''','''','''','''',''''   '
								PRINT @consulta
								EXEC(@consulta)
							 PRINT 'MEXICO'
							END         
            
		END
				PRINT 'Trucamos tablas Temporales'
			  DROP  TABLE #TempLocalTable 
			  DROP  TABLE #TempLocalTableHist

			SET @bandera = @bandera + 1

		PRINT @filial
		PRINT @bandera 
	END
	  SET @banderaConsulta = @banderaConsulta + 1
	  SET @bandera = 0
	  SET @TipoConsulta = 'Curves'
	  SET @TipoConsultaStoreParameter = ''''+ @TipoConsulta +''''
	  PRINT @TipoConsultaStoreParameter
	 
END


