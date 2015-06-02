--PiP_TFD[FORMAT(TODAY, YYYYMMDD)]_109_1000.txtselect * from MxProcesses.dbo.tblprocessparameters
--where txtParameter = 'ConsarFile2'
where  txtvalue like '%_109_1000.txt%'
and txtValue like '"PiP_TFD_1000%'

select  '.' + txtParameter + ' =' , * from MxProcesses.dbo.tblprocessparameters
where txtprocess = 'FILES_DELTA_GEN_1000'



select * from MxProcesses.dbo.tblprocesscatalog
where txtprocess in (
'BMX01_1000',
'BMX01_FIX_1000'
)
and  bitstatus= 1





select  '.' + txtParameter + ' =' , * from MxProcesses.dbo.tblprocessparameters
where txtprocess = 'BMX01_1000'

 
--BMX01_1000 clsBanamex	DeltaMatrix
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------PiP_TF[yyyymmdd]_109_1000.txt
"PiP_TF[FORMAT(TODAY, YYYYMMDD)]_109_1000.txt"select * from MxProcesses.dbo.tblprocessparameters
--where txtParameter = 'ConsarFile2'
where  txtvalue like '%_109_1000.txt%'
--and txtValue like '"PiP_TF%'

select * from MxProcesses.dbo.tblprocesscatalog
where txtprocess in (
'REP_ALFA_1000',
'REP_ALFA_FIX_1000'
)
and  bitstatus= 1

clsXamuMatrix	Execute

--REP_ALFA_1000




select LEN('000000000')
select LEN('000000')

select  '.' + txtParameter + ' =' , * from MxProcesses.dbo.tblprocessparameters
where txtprocess = 'REP_ALFA_1000'