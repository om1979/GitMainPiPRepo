USE [MxFixIncome]
GO

/****** Object:  Table [dbo].[itblPonderadoFinal]    Script Date: 11/25/2014 16:12:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[itblPonderadoFinal_BidAsk](
	[dteDate] [datetime] NOT NULL,
	[txtTv] [char](11) NOT NULL,
	[intPlazo] [int] NOT NULL,
	[dblTasaFinal] [float] NOT NULL,
	[dblAmount] [float] NULL,
	[fStatus] [bit] NULL,
	[txtType] [varchar](20) NULL 
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



spi_LicuadoFinalTestOaceves '20141124' ,'CET',1,'Bid'



   SELECT * FROM  dbo.itblPonderado_BidAsk AS IPFBA 
	WHERE intPlazo = 1639
	ORDER BY dteBeginHour



  SELECT *   FROM  dbo.itblPonderadoFinal_BidAsk AS IPFBA 
  WHERE intPlazo = 1639



SELECT * FROM  [VIA-MXSQL].MxFixIncome.dbo.itblPonderado AS IPFBA
where dteDate = '20141217'
and intPlazo = '6007'



SELECT * FROM  dbo.itblPonderado_BidAsk AS IPFBA
where dteDate = '20141217'
and intPlazo = '6007'
--24 0-ask
--40 0-(-)




TRUNCATE TABLE dbo.itblPonderadoFinal_BidAsk
TRUNCATE TABLE dbo.itblPonderado_BidAsk


  SELECT *   FROM  dbo.itblPonderadoFinal_BidAsk AS IPFBA 
  ORDER BY txtType,3


SELECT * FROM  dbo.itblPonderadoFinal_BidAsk AS IPFBA
where dteDate = '20141217'
and intPlazo = '6007'