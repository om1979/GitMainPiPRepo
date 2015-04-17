
/*
AUTOR:		OMAR ADRIAN ACEVES GUTIERREZ
FECHA:		20150416
OBJETIVO:	REPORTAR PRODUCTO MSC09_VD  CSV USANDO INSUMOS DE MxDerivatives
*/


DECLARE @dteDate varchar(11) = '20150417'
	
			/*TABLA DE TRABAJO PARA CONTENER ITEMS A CONSULTAR*/
		DECLARE  @tblItems TABLE
		(
		intId int identity (1,1),
		txtItem varchar(15)
		)
		insert into @tblItems
			select 'SWP1ISD' union 
			SELECT 'SWP1MTD'  UNION 
			SELECT 'SWP1NOM' UNION
			SELECT 'SWP1IRC' UNION
			SELECT 'SWP1FIJ' UNION
			SELECT 'SWP1SPD' UNION
			SELECT 'SWP2NOM' UNION
			SELECT 'SWP2IRC' UNION
			SELECT 'SWP2FIJ' UNION
			SELECT 'SWP2SPD'
		/*TABLA DE TRABAJO PARA CONTENER RESULTADOS DE LOS ITEMS CONSULTADOS*/
		declare @tblDerivatives table
		(
		dtedate varchar(10),
		txtItem Varchar(20),
		txtid1 varchar(12),
		txtid2 varchar(12),
		txtemisora varchar(12),
		txtValue varchar(50),
		txtConcat varchar(max)
		)

		/*
		PASO 1:	CONSEGUIMOS VALORES CON FECHA MAXIMA DISPONIBLE POR CADA ITEM
		               DESDE tblderivativesadd Y TAMBIEN OBTENEMOS EL TXTI2 Y EMISORA DESDE tblids
		*/
		DECLARE @COUNTER INT = 1
		DECLARE @tblDerivativestABLE VARCHAR(20) = '@tblDerivatives'

			while  (@COUNTER  <=(select max(intId) from @tblItems) )
				BEGIN
					declare @TXTITEM      varchar(15)=(select txtitem from @tblItems where intId = @COUNTER)--NOMBRE DE ITEM
					declare @TXTCOLUMN  varchar(15)=(select 'txt'+txtitem from @tblItems where intId = @COUNTER) --COLUMNA
					DECLARE @TXTVAL VARCHAR(MAX)
					
					SET @TXTVAL =
						(
							select 
							    ' select CONVERT(VARCHAR(20),Add1.dtedate,112) ,Add1.txtId1,D1.txtId2,txtItem,D1.txtIssuer,'+
								' case when '+ char(39)+@TXTITEM+CHAR(39)  + ' in(''SWP1FIJ'',''SWP1SPD'',''SWP2FIJ'',''SWP2SPD'') '  +
								' then convert(varchar(50),convert(decimal(20,6),convert(float,txtvalue)))   ' +
							    ' when ' +  char(39)+@TXTITEM+CHAR(39)  + ' in(''SWP2NOM'',''SWP1NOM'') then  convert(varchar(50),convert(decimal(20,3),convert(float,txtvalue)))  else  txtvalue end  ' +
							    ' from mxderivatives.dbo.tblderivativesadd as Add1 '+
							    ' inner join  mxderivatives.dbo.tblids as D1 ' +
							    ' on   Add1.txtId1 = D1.txtID1 ' +
								' INNER JOIN  MxDerivatives.dbo.tblDerivativesOwners AS Own ' +
								' ON D1.txtId1 = Own.txtId1 ' +
							    ' where  Add1.txtItem = ' + char(39)+@TXTITEM+CHAR(39)  +
							    ' and add1.dteDate = '   +  '(select MAX(dteDate) from MxDerivatives.dbo.tblderivativesadd  where txtItem = '+ char(39)+@TXTITEM+CHAR(39) + '   and txtId1 = Own.txtId1) '+
								' and Own.txtOwnerId = ''MSC09'' ' +
							    ' and Own.dteEnd >= '  + char(39)+  @dteDate +CHAR(39)  
						)
					INSERT INTO @tblDerivatives (dtedate,txtId1,txtId2,txtItem,txtemisora,txtvalue) 
					EXEC(@TXTVAL)
					
					--select @TXTVAL
					SET @COUNTER = @COUNTER+1
					SET @TXTVAL = NULL
			END 


			/*PASO	2:	ACTUALIZAMOS FORMATO DE FECHAS PARA ITEMS: 'SWP1ISD','SWP1MTD'*/
				UPDATE A 
				SET TXTVALUE =CONVERT(VARCHAR(20),CONVERT(DATETIME,TXTVALUE),103) 
				FROM @tblDerivatives AS a
				WHERE TXTITEM IN('SWP1ISD','SWP1MTD')
			

			/*PASO 3:		CONSEGUIMOS ITEM LAR,SHO,PAV DE TBLPRICES */
				declare @itemtoRequest varchar(10)
				declare @intCounter int = 1
				
					while (@intCounter <= 3)
						BEGIN 
							SET @itemtoRequest = (select case when @intCounter = 1 then 'LAR' when @intCounter = 2 then 'SHO' when  @intCounter = 3 then   'PAV' END )
								
								INSERT INTO @tblDerivatives(dtedate,txtitem,txtid1,txtid2,txtemisora,txtvalue)
										SELECT @dteDate AS dtedate ,txtItem as txtitem,TXTID1 as txtid1,'TXTID2' as txtid2 ,'TXTEMISORA' as txtemisora,CONVERT(VARCHAR(50),CONVERT(DECIMAL(20,6),DBLVALUE)) as txtvalue FROM MxDerivatives.dbo.tblPrices
										WHERE txtLiquidation in( 'MD','MP')
										AND txtItem = @itemtoRequest
										AND intFlag = 1
										AND dteDate = @dteDate
										and txtId1 in (select distinct txtId1 from @tblDerivatives)
										
										set @intCounter = @intCounter+1
						END
						
						

					/*PASO 4:	ACTUALIZAMOS CAMPOS TXTID2 Y TXTEMISORA PARA TODOS LOS PRECIOS CONSEGUIDOS EN EL PASO 3 */
										
					DECLARE @CONTAINER TABLE 
					(
					TXTID1 VARCHAR(12),
					--txtitem VARCHAR(50),
					txtid2 VARCHAR(12),
					txtemisora VARCHAR(50)
					)
							INSERT @CONTAINER
							select DISTINCT TXTID1,txtid2,txtemisora
							from @tblDerivatives TableAct
							WHERE txtitem  NOT in ('LAR','SHO','PAV')
				
								UPDATE a
								SET a.txtid2 =U.txtid2,
								a.txtemisora = U.txtemisora
								FROM @tblDerivatives  AS a
								INNER JOIN @CONTAINER AS U
								on u.txtid1 = a.txtid1
								WHERE A.txtitem  in ('LAR','SHO','PAV')
								

								/*PASO 5: 
									CONSTRUIMOS TABLAS TEMPORALES  REALIZAR REPORTE
									(ESTAS SON NECESARIAS YA QUE SE DEBE CAMBIAR LA ESTRUCTURA DE LA TABLA DE VERTICAL A HORIZONTAL) 
								*/
								DECLARE @idsEmi TABLE(TXTID1 VARCHAR(12),txtid2 varchar(50),txtemisora varchar(50)) 
									INSERT INTO @idsEmi
									SELECT DISTINCT TXTID1,txtid2,txtemisora FROM @tblDerivatives
									
						
							DECLARE @SWP1ISD TABLE(TXTID1 VARCHAR(12),TXTSWP1ISD VARCHAR(50)) 
									INSERT INTO @SWP1ISD
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP1ISD'
						
						
							DECLARE @SWP1MTD TABLE(TXTID1 VARCHAR(12),TXTSWP1MTD VARCHAR(50)) 
									INSERT INTO @SWP1MTD
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP1MTD'
						
						
							DECLARE @SWP1NOM TABLE(TXTID1 VARCHAR(12),TXTSWP1NOM VARCHAR(50)) 
									INSERT INTO @SWP1NOM
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP1NOM'
						
						
							DECLARE @SWP1IRC TABLE(TXTID1 VARCHAR(12),TXTSWP1IRC VARCHAR(50)) 
									INSERT INTO @SWP1IRC
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP1IRC'
									
							DECLARE @SWP1FIJ TABLE(TXTID1 VARCHAR(12),TXTSWP1FIJ VARCHAR(50)) 
									INSERT INTO @SWP1FIJ
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP1FIJ'
						
							DECLARE @SWP1SPD TABLE(TXTID1 VARCHAR(12),TXTSWP1SPD VARCHAR(50)) 
									INSERT INTO @SWP1SPD
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP1SPD'
						
							DECLARE @SWP2NOM TABLE(TXTID1 VARCHAR(12),TXTSWP1SPD VARCHAR(50)) 
									INSERT INTO @SWP2NOM
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP2NOM'
						
							DECLARE @SWP2IRC TABLE(TXTID1 VARCHAR(12),txtSWP2IRC VARCHAR(50)) 
									INSERT INTO @SWP2IRC
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP2IRC'
						
							DECLARE @SWP2FIJ TABLE(TXTID1 VARCHAR(12),txtSWP2FIJ VARCHAR(50)) 
									INSERT INTO @SWP2FIJ
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP2FIJ'
									
							DECLARE @SWP2SPD TABLE(TXTID1 VARCHAR(12),txtSWP2SPD VARCHAR(50)) 
									INSERT INTO @SWP2SPD
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SWP2SPD'
						
								/*Creamos tablas para organizar datos de forma horizontal para los datos de precios LAR,SHO,PAV*/
							DECLARE @PriceLAR TABLE(TXTID1 VARCHAR(12),txtPriceLAR VARCHAR(50)) 
									INSERT INTO @PriceLAR
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'LAR'
									
							DECLARE @PriceSHO TABLE(TXTID1 VARCHAR(12),txtPriceSHO VARCHAR(50)) 
									INSERT INTO @PriceSHO
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'SHO'	
									
							DECLARE @PricePAV TABLE(TXTID1 VARCHAR(12),txtPricePAV VARCHAR(50)) 
									INSERT INTO @PricePAV
									SELECT DISTINCT TXTID1,TXTVALUE FROM @tblDerivatives WHERE txtItem = 'PAV'
									
						
						
						/*PASO 6: CREAMOS TABLA PARA CONTENER RESULTADOS*/
						
						DECLARE  @TBLREPORTqUERY TABLE
						(
						intid int  identity(1,1),
						txtid1 varchar(12),
						txtid2 varchar(12),
						txtemisora varchar(20),
						txtConcat varchar(max)
						)
						
						/*PASO 7: INSETAMOS TITULOS*/
						insert into @TBLREPORTqUERY
						
											
					select 'TITULO','TITULO','TITULO',
							'ID PIP'+','+
							'ID MS'+','+
							'TIP_SWAP'+','+
							'Fecha de Inicio'+','+
							'Fecha de Vencimiento'+','+
							'Nominal Recibe'+','+
							'Tasa de Referencia Recibe'+','+
							'Tasa Fija Recibe'+','+
							'Spread Recibe'+','+
							'Nominal Entrega'+','+
							'Tasa de Referencia Entrega'+','+
							'Tasa Fija Entrega'+','+
							'Spread Entrega'+','+
							'Pata Larga'+','+
							'Pata Corta'+','+
							'Valuacion'

						
						
						/*PASO 8: INSERTAMOS DATOS DE CONSULTA*/
						insert into @TBLREPORTqUERY
						select 
						AABC.TXTID1,
						rtrim(ltrim(AABC.txtid2)),
						AABC.txtemisora,
						AABC.TXTID1+','+
						rtrim(ltrim(AABC.txtid2))+','+
						AABC.txtemisora+','+
						a.TXTSWP1MTD+','+
						b.TXTSWP1ISD+','+
						c.TXTSWP1MTD+','+
						d.TXTSWP1NOM+','+ 
						e.TXTSWP1IRC+','+
						a1.TXTSWP1FIJ+','+
						b1.TXTSWP1SPD+','+
						c1.TXTSWP1SPD+','+
						d1.txtSWP2IRC+','+
						e1.txtSWP2FIJ+','+
						a2.txtSWP2SPD+','+
						isnull(lar.txtPriceLAR,'')+','+
						isnull(SHO.txtPriceSHO,'')+','+
						pav.txtPricePAV
						 
						from @idsEmi as AABC
						full outer join @SWP1MTD as A
						on AABC.txtid1 = a.txtid1 
						full outer join @SWP1ISD as B
						on AABC.TXTID1 = b.TXTID1
						full outer join @SWP1MTD as c
						on AABC.TXTID1 = c.TXTID1
						full outer join @SWP1NOM as  d
						on AABC.TXTID1 = d.TXTID1
						full outer join @SWP1IRC as e
						on AABC.TXTID1 = e.TXTID1
						full outer join @SWP1FIJ as a1
						on AABC.TXTID1 = a1.TXTID1
						full outer join @SWP1SPD as b1
						on AABC.TXTID1 = b1.TXTID1
						full outer join @SWP2NOM as c1
						on AABC.TXTID1 = c1.TXTID1
						full outer join @SWP2IRC as d1
						on AABC.TXTID1 = d1.TXTID1
						full outer join @SWP2FIJ as e1
						on AABC.TXTID1 = e1.TXTID1
						full outer join @SWP2SPD as a2
						on AABC.TXTID1 = a2.TXTID1
						full outer join @PriceLAR as lar 
						on AABC.TXTID1 = lar.TXTID1
						full outer join @PriceSHO as SHO 
						on AABC.TXTID1 = SHO.TXTID1
						INNER    JOIN @PricePAV as PAV 
						on AABC.TXTID1 = PAV.TXTID1		
						 
				 /*PASO 9: REPORTAMOS CONSULTA SI HAY NULOS TRONAMOS LA CONSULTA*/    
				 IF ((SELECT count(*) FROM @TBLREPORTqUERY where txtConcat is null) >0)      
				   BEGIN    
				  
				declare @errorData varchar(200)= (select top 1  'Error: El producto reporta Nulos en:' +  txtid1 +'_' +txtid2 +'_'+txtemisora  from @TBLREPORTqUERY   where txtConcat is null)
				 
				 
					RAISERROR (  @errorData , 16, 1)    
				   END      
					 ELSE    
						   -- Reporto informacion       
						   SELECT LTRIM(txtConcat)       
						   FROM @TBLREPORTqUERY      
						   order by intid asc
						  -- ORDER BY intSection      
	        
