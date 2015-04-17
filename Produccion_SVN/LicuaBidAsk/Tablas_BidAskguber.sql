
--Drop table itblPonderadoFinal_BidAsk
                 
                 CREATE TABLE [dbo].[itblPonderadoFinal_BidAsk]
						(
					[dteDate] [datetime] NOT NULL,
					[txtTv] [char] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
					[intPlazo] [int] NOT NULL,
					[dblTasaFinal] [float] NOT NULL,
					[dblAmount] [float] NULL,
					[fStatus] [bit] NULL,
					[txtType] [varchar] (20),--Bid-Ask

						) 
					ON [PRIMARY]
					GO
					CREATE NONCLUSTERED INDEX [IX_itblPonderadoFinal_BidAsk] ON [itblPonderadoFinal_BidAsk] ([dteDate], [intPlazo]) ON [PRIMARY]
					GO
                
              CREATE TABLE [dbo].[itblPonderado_BidAsk]
							(
								[dteDate] [datetime] NULL,
								[intPlazo] [int] NULL,
								[txtOperation] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
								[txtTv] [char] (11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
								[dblRate] [float] NULL,
								[dblAmount] [float] NULL,
								[dteBeginHour] [datetime] NULL,
								[dteEndHour] [datetime] NULL,
								[txtType] [varchar] (20),
						        [txtBlenderMatFlag] [varchar](50) NULL
						       ) 
					 ON [PRIMARY]
				GO
				CREATE NONCLUSTERED INDEX [IX_itblPonderado_BidAsk] ON [dbo].[itblPonderado_BidAsk] ([dteDate], [intPlazo]) ON [PRIMARY]
				GO

