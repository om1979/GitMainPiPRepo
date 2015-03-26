

--select * from MxProcesses.dbo.tblpr


--select * from tblpipbenchmarks

--select * from sys.tables
--where name like '%map%'



--select * from tblActiveX
--where txtProceso = 'TECHRULES_VEC_BENCHS'
--sp_helptext usp_productos_TECHRULES;1 '[DATE|YYYYMMDD]'


/*
Autor:	Omar Adrian Aceves G.
Fecha:	2015-03-23 14:44:47.813
Objetivo Crear personalizado 
*/

	declare @tblReporter table
	(
	intID int IDENTITY(1,1),
	txtData varchar(500)  
	)
	insert @tblReporter
		select 'Fecha' + CHAR(9)+	'Nombre' +char(9)	+'MD'+CHAR(9)+	'24H'
		
	insert @tblReporter	 
		select '24/02/2015' + char(9)+'PiPCetes-28d' + CHAR(9) +str(dblIndex,10,7) + char(9) + str (dblIndex24H,10,7)  from tblPiPIndexes
		where txttype = 'B_>>5AP'
		and dteDate =  '20150224'
		
		--(select MAX(dteDate) from tblPiPIndexes
		--where txttype = 'B_>>5AP')
		
	insert @tblReporter
		select '24/02/2015' + char(9)+'PiPG-Fix5A' + CHAR(9) +str(dblIndex,10,7) + char(9) + str (dblIndex24H,10,7)  from tblPiPIndexes
		where txttype = 'PIPF5A'
		and dteDate = '20150224'
		
		
		select txtData from @tblReporter
		order by intID		
	
	
-- (select MAX(dteDate) from tblPiPIndexes
--where txttype = 'PIPF5A')



--select dblindex from  MxFixIncome.dbo.tblBenchCatalog 
--where txtType in ('B_>>5AP', 'PIPF5A')