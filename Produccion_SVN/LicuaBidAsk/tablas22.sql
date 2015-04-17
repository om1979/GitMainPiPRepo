/*
creamos tabla de trabajo itblNodesYTMLevels_BidAskTest
que contendra los valores de 20150309 para pruebas
contiene 2 nuevas columnas 
--	[txtLicType] [varchar](50),  valores  (banda1,banda2)
--	[txtLevelsType] [varchar](50) valores (Guber,BidAsk)
*/



--spi_LicuadoFinal;3 '20150324','CET', 1
--para cargar tazaslicuadas interfaz con los datos del dia



----USE [MxFixIncome]
----GO

--/****** Object:  Table [dbo].[bkp_itblNodesYTMLevels_20140630]    Script Date: 03/13/2015 10:45:42 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE TABLE [dbo].[itblNodesYTMLevels_BidAskTest](
	[dteDate] [datetime] NOT NULL,
	[intSerialYTM] [int] NOT NULL,
	[dblValue] [float] NOT NULL,
	[dblSpread] [float] NULL,
	[dblBid] [float] NULL,
	[dblAsk] [float] NULL,
	[dteTime] [datetime] ,
	[txtLicType] [varchar](50) NULL ,
	[txtLevelsType] [varchar](50)
) ON [PRIMARY]

GO

--select * from itblNodesYTMLevels_BidAskTest
insert into itblNodesYTMLevels_BidAskTest
select 
dteDate
,intSerialYTM
,dblValue
,dblSpread
,dblBid
,dblAsk
,dteTime
,NULL 
,'BidAsk'
 from itblNodesYTMLevels
where dtedate = '20150323'


SELECT * FROM itblTasasLicuadasInterfaz
--truncate table itblNodesYTMLevels_BidAskTest



select * from sys.tables where name like '%YTMLevels%'
select distinct dtedate from  itblNodesYTMLevelsHist
where dtedate = '20150325'



--SELECT * FROM  itblNodesYTMLevels_BidAskTest



-- select * from [via-mxsql].mxfixincome.dbo.itblNodesYTMLevels
--where dtedate = '20150324'




--select * from itblNodesYTMLevels_BidAskTest

--select * from itblponderado_BidAsk

--select * from itblponderadoFinal_BidAsk


--select * from
--itblNodesYTMLevels_BidAskTest


--truncate  table itblponderado_BidAsk

--truncate table itblponderadoFinal_BidAsk


--crear tablas 
		----select * from itblponderado_BidAsk
		----select * from itblponderadoFinal_BidAsk

		--insert into itblNodesYTMLevels_BidAskTest
		--select 
		--dteDate
		--,intSerialYTM
		--,dblValue
		--,dblSpread
		--,dblBid
		--,dblAsk
		--,dteTime
		--,NULL 
		--,'BidAsk'
		-- from [via-mxsql].mxfixincome.dbo.itblNodesYTMLevels
		--where dtedate = '20150323'


	--itblMarketPositions
	--insertar informacion con la fecha a trabajar 
	
	
	
	--insert into itblMarketPositions
	--		select * from [via-mxsql].mxfixincome.dbo.itblMarketPositions
	--		where dtedate = '20150324'
			
			
	--		select *  from itblMarketPositions
	--					where dtedate = '20150324'
			
			
			
			--ACTUALIZAR TABLAS DE PRUEBAS CON DATOS DE PRODUCCION 
			
--select * from  itblParametrosLicuadora
--select * from  itblClosesRandom 
--select * from   itblBlenderParams 
   
   
   
   
   
--DELETE  FROM itblNodesYTMLevels_BidAskTest 
--   where dtedate = '20150323'
   
   
   
--   insert into itblClosesRandom 
--   select * from   [via-mxsql].mxfixincome.dbo.itblClosesRandom
--     where dtedate = '20150324'