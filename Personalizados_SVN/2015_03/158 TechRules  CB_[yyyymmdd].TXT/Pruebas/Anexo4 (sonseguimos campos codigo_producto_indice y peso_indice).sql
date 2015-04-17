

	/*Creamos tabla con Universo*/
		Declare @tblIndexesPortfolios_Now table (txtIndex	char(7),dteDate datetime,txtId1	char(11),dblCount	 decimal(20,14))
	/*Llenamos Universo*/
		insert into @tblIndexesPortfolios_Now
			select txtIndex,dteDate,txtId1,dblCount from dbo.tblIndexesPortfolios 
				where txtIndex 
				 in ('CETETRAC', 'IMC30', 'IPCCOMP', 'MEXBOL', 'M10TRAC', 'M5TRAC', 'UDITRAC' , 'UMSTRAC')
				 and  dtedate = @txtDate
				 
				 
				 
				 
				 /*Variable con suma de universo por Index*/
				 declare @tblSumcontainer table 
				 (
				 txtid varchar(10),
				 dblIndexCount  float --,
				 )
				 insert into @tblSumcontainer
							select  'CETETRAC',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'CETETRAC'
							UNION
							select  'IMC30',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'IMC30'
							UNION
							select  'IPCCOMP',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'IPCCOMP'
							UNION
							select  'MEXBOL',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'MEXBOL'
							UNION
							select  'M10TRAC',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'M10TRAC'
							UNION
							select  'M5TRAC',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'M5TRAC'
							UNION
							select  'UDITRAC',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'UDITRAC'
							UNION
							select  'UMSTRAC',SUM(dblCount)  from @tblIndexesPortfolios_Now where txtIndex  = 'UMSTRAC'

				 /*Actualizamos Campo dblCount  = dblCount / @dblIndexCount*/
					 update @tblIndexesPortfolios_Now
					 set dblCount = dblCount/(select dblIndexCount from @tblSumcontainer where txtid = txtIndex and  dblIndexCount is  not null )

		/*Declaramos tabla para contener resultados*/
			DECLARE @tblProduct_Indexes TABLE
				(
					txtId1 varchar(12),
					txtProductIndex varchar (100),
					txtPesoIndex varchar (100)
				)
				
			Declare @txtId1 varchar(12)
	/*Cursor para obtener Nombres de Indices (CODIGO_PRODUCTO_INDICE) y Precios de los Indices (PESO_INDICE)*/
			Declare IndexesPortfolios cursor GLOBAL
				 FOR
				  SELECT distinct txtid1 from @tblIndexesPortfolios_Now
			      
						Open IndexesPortfolios
							fetch IndexesPortfolios into @txtId1
								while(@@fetch_status=0)
									begin 

										DECLARE @str VARCHAR(100); 
										DECLARE @str2 VARCHAR(100)
										
										/*Conseguimos Codigos*/
										SELECT @str = COALESCE(@str +  '; ', '')+ RTRIM(LTRIM(txtIndex))    from @tblIndexesPortfolios_Now
											  where  txtId1 = @txtId1
										      
										/*Conseguimos Precios*/
											  SELECT @str2 = COALESCE(@str2 +  '; ', '')   +convert(varchar(100),dblCount)  from @tblIndexesPortfolios_Now
											  where txtId1 = @txtId1
											  
									  /*Guardamos los datos*/
											  Insert into @tblProduct_Indexes 
												Select @txtId1,@str,@str2 
												
												
												set @str = null
												set @str2 = null
												
													fetch  IndexesPortfolios into @txtId1
									end 
											
						close IndexesPortfolios
			deallocate IndexesPortfolios
	/*Se encuentra todo cargado en @tblProduct_Indexes*/
