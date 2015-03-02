USE [MxFixIncome]
GO

/****** Object:  Table [dbo].[itblPonderado]    Script Date: 11/25/2014 16:12:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[itblPonderado_BidAsk](
	[dteDate] [datetime] NULL,
	[intPlazo] [int] NULL,
	[txtOperation] [varchar](50) NULL,
	[txtTv] [char](11) NULL,
	[dblRate] [float] NULL,
	[dblAmount] [float] NULL,
	[dteBeginHour] [datetime] NULL,
	[dteEndHour] [datetime] NULL,
	[txtType] [varchar](20) NULL 
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


