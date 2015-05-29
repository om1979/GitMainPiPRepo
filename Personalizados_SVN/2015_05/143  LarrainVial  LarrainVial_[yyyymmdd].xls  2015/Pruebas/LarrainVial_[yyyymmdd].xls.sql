--OK
--insert into tblprocesos
--select 
--'LARRAINVIAL_INS_XLS'
--,txtLibreria
--,txtClase
--,txtMetodo
--,'VECTOR INSTRUMENTOS LARRAINVIAL'
-- from tblprocesos 
--where txtProducto = 'DB_VPI_XLS'


--insert into tblactivex
--select 
--'LARRAINVIAL_INS_XLS'
--,txtPropiedad
--,txtTipo
--,txtValor
--,txtDescripcion
-- from tblactivex
--where txtproceso = 'DB_VPI_XLS'



--update tblactivex
--set txtvalor = 'Template_LarrainVial_Ins.xls'
--where txtproceso = 'LARRAINVIAL_INS_XLS'  
--and  txtpropiedad = 'TemplateFile'


--sp_productos_DEUTSCHEBANK;5 '[DATE|YYYYMMDD]'



--select * from tblactivex 
--where txtproceso = 'LARRAINVIAL_INS_XLS'  

----sp_productos_DEUTSCHEBANK;5 '[DATE|YYYYMMDD]'

----OK
----insert into MxProcesses..tblProductGeneratorMap
----	select 
----	'LARRAINVIAL_INS_XLS'
----	,txtFamily
----	,'INACTIVO'
----	,3
----	,'laRain01'
----	,1
----	 from MxProcesses..tblProductGeneratorMap
----	where txtProduct = 'DB_VPI_XLS'



----	select *  from MxProcesses..tblProductGeneratorMap
----	where txtProduct like  '%LARRAINVIAL_INS_XLS%'



--select *  from MxProcesses..tblProductGeneratorMap
--where txtpack = 'OPERATIVO_2'


--UPDATE MxProcesses..tblProductGeneratorMap
--SET txtpack = 'DEFINITIVO_2'
--WHERE txtProduct like  '%LARRAINVIAL_INS_XLS%'

--SELECT * FROM MxProcesses..tblProductGeneratorMap


--WHERE  txtProduct like  '%LARRAINVIAL_INS_XLS%'



--UPDATE MxProcesses..tblProductGeneratorMap
--SET fload = 1
--where txtpack = 'OPERATIVO_2'
--and txtProduct = 'PIP_MARKET_REF_DEF_HTM'



--SELECT * FROM SYS.tables WHERE name LIKE '%OWNERS%'
--SELECT * FROM tblOwnersCatalog
-- WHERE  txtDescription LIKE '%LARRAIN%'


--INSERT INTO tblOwnersCatalog
--SELECT 'laRain01','LarrainVial'


--SELECT * FROM SYS.PROCEDURES 
--WHERE 
--NAME LIKE '%LARRAINVIAL%'
 

--select * from sys.tables where name like '%map%'


--select * from tmp_tblUnifiedPricesReport









--/*
--Autor:		Omar Adrian Aceves Gutierrez
--Fecha:		2015-05-14 12:30:23.693
--Objetivo:		Elaborar personalizado  de arrainVial_[yyyymmdd].xls
--*/

alter  PROCEDURE usp_productos_LarrainVial;3 
 @dtedate datetime
AS
BEGIN 

	declare @tblFinalReport table 
	(
	intID int identity(1,1),
	dtedate varchar(15),
	txttv varchar(20),
	txtemisora varchar(20),
	txtserie varchar(20),
	txtid2 varchar(15),
	txtprs_mo varchar(100),
	txtprl_mo varchar(100),
	txtcpd_mo varchar(100),
	txtCUR2 varchar(20)
	)

	--/*PASO1: HACEMOS CONSULTA CON UNIVERSO Y UNIFICADA */
	insert into @tblFinalReport
	select CONVERT(VARCHAR(10),b.dtedate,111),B.txttv,b.txtemisora,b.txtserie,b.txtid2,
	convert(decimal(10,6),b.dblprs),
	convert(decimal(10,6),b.dblprl),
	convert(decimal(10,6),b.dblcpd) ,
	case when b.txtCUR2  = 'MPS' then 'MXN' else b.txtcur2 end as txtcur2
	from tblLarrainVial_instruments as A
	inner join tmp_tblUnifiedPricesReport as B
	on a.txtid1 = b.txtID2
	where b.dtedate = @dtedate
	and b.txtliquidation in ('MD','MP')
	and a.txtid1 <> 'XS1075314911'
	union 
	/*PASO2: AGREGAMOS CASO ESPECIAL PARA TXTID2 XS1075314911 */
	select  distinct CONVERT(VARCHAR(10),b.dtedate,111),B.txttv,b.txtemisora,b.txtserie,b.txtid2,
		convert(varchar(100),convert(decimal(10,6),b.dblprs / 100)) as txtprs_mo,
	convert(varchar(100),convert(decimal(10,6),b.dblprl / 100)) as txtprl_mo,
	convert(varchar(100),convert(decimal(10,6),b.dblcpd / 100))as txtcpd_mo,
	case when b.txtCUR2  = 'MPS' then 'MXN' else b.txtcur2 end as txtcur2
	from tblLarrainVial_instruments as A
	inner join tmp_tblUnifiedPricesReport as B
	on a.txtid1 = b.txtID2
	where b.dtedate = @dtedate
	and b.txtliquidation in ('MD','MP')
	and a.txtid1 = 'XS1075314911'
	

	----/*PASO3: VALIDAMOS NULOS */
	DECLARE @VALIDATE TABLE
	(
	 intNUllFlag int  
	)
	insert into @VALIDATE
	SELECT NULL FROM @tblFinalReport WHERE  txtprl_mo IS NULL  
	UNION 
	SELECT NULL FROM @tblFinalReport WHERE  txtprs_mo IS NULL  
	UNION 
	SELECT NULL FROM @tblFinalReport WHERE  txtcpd_mo IS NULL 
	UNION 
	SELECT NULL FROM @tblFinalReport WHERE  txtCUR2 IS NULL 
	
	/*PASO4: ACTUALIZAMOS PRS,PRL,CPD CALCULADOS EN PASO 2
				  EN BASE A LOS TXTCUR2 DEL ISNTURMENTO Y LO 
				  DIVIDIMOS ENTRE EL TIPO DE CAMBIO DEL DIA	
	*/
	UPDATE @tblFinalReport
	SET 
		txtprl_mo   = CONVERT(DECIMAL(10,6),txtprl_mo)/IRC.dblValue,
		txtprs_mo  = CONVERT(DECIMAL(10,6),txtprs_mo)/IRC.dblValue,
		txtcpd_mo = CONVERT(DECIMAL(10,6),txtcpd_mo)/IRC.dblValue
	FROM tblirc AS IRC
		INNER JOIN @tblFinalReport AS DATA
			ON IRC.txtIRC = DATA.txtcur2
			AND DATA.DTEDATE = IRC.dteDate
		where IRC.dteDate = @dteDate
		AND txtIRC = DATA.txtCUR2
		AND DATA.txtcur2  <> 'MXN'
		AND dtetime = (select MAX(dtetime) from tblirc where dteDate = @dteDate and txtIRC = DATA.txtcur2 )



/*PASO5: REPORTAMOS PRODUCTO SI NO HAY NULOS Y HAY INFO  */
	if (select COUNT(*) from @VALIDATE WHERE intNUllFlag IS NULL ) < 1  AND (SELECT COUNT(INTID) FROM  @tblFinalReport ) >= 1
			BEGIN 
									select dtedate,txttv,txtemisora,txtserie,txtid2,
									convert(decimal(10,6),txtprs_mo),
									convert(decimal(10,6),txtprl_mo),
									convert(decimal(10,6),txtcpd_mo),
									txtCUR2 from @tblFinalReport
							ORDER BY intID ASC 
			END
				ELSE
				
				BEGIN 
						DECLARE @ERRRORMSQ VARCHAR(100) = 'PRODUCTO REPORTA NULOS O NO HAY INFORMACION PARA REPORTAR'
						 RAISERROR (  @ERRRORMSQ , 16, 1)  

				END 
END 