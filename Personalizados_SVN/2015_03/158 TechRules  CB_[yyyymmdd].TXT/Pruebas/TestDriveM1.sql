
----select * from tblactivex
----where txtProceso ='TECHRULES_VEC_BENCHS'



--select * into dbo.Bkp_tmp_tblUnifiedPricesReport_20150331 from tmp_tblUnifiedPricesReport
--select * from tblactivex where txtvalor like '%CB%'
--and txtpropiedad like '%FileName%'

/*    
----------------------------------------------------------      
--   Modificado por: Mike Ramírez      
--   Modificacion: 15:18 p.m. 2012-04-26      
--   Descripcion: Modulo 1: Se modificar la columna NOMBRE      
----------------------------------------------------------      
-- Modifica:  Omar Adrian Aceves Gutierrez    
-- Fecha:   2014-10-07 14:21:31.007    
--  Descripcion: agregan valores especificos en base a Catalogo de Benchmarks    
----------------------------------------------------------      
----------------------------------------------------------      
-- Modifica:  Omar Adrian Aceves Gutierrez    
-- Fecha:   2014-10-22 11:54:30.300   
--  Descripcion: se agrega tipo de valor CF a universo  
----------------------------------------------------------      
*/    
 --CREATE   PROCEDURE dbo.usp_productos_TECHRULES;1 --'20141002'         
 declare @txtDate AS DATETIME = '20150401'     
 --AS         
 --BEGIN        
      
 --SET NOCOUNT ON      
      
 -- Tabla de Resultados      
 DECLARE @tblResults TABLE (      
  [intConsecutivo][INT],      
  [txtTv][VARCHAR](15),      
  [txtEmisora][VARCHAR](15),      
  [txtSerie][VARCHAR](15),      
  [txtData][VARCHAR](8000),      
  PRIMARY KEY CLUSTERED (      
   intConsecutivo,txtTV,txtEmisora,txtSerie      
   )      
 )      
      
 -- Tabla Universo de Instrumentos a procesar      
 DECLARE @tblUniverso TABLE (      
  [txtId1][CHAR](11),      
  [txtTv][VARCHAR](10),      
  [txtEmisora][VARCHAR](10),      
  [txtSerie][VARCHAR](10),      
  [txtTipoActivo][CHAR](1),      
  [intCustomerId][INT]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 -- Tabla Buffer de Vectores       
 DECLARE @tmp_tblUnifiedPricesReport TABLE (      
  [txtTv] [varchar](10) NOT NULL,      
  [txtEmisora] [varchar](10) NOT NULL,      
  [txtSerie] [varchar](10) NOT NULL,      
  [txtId1] [varchar](11) NOT NULL,      
  [txtLiquidation] [varchar](3) NOT NULL,      
  [dblPRL] [float] NULL,      
  [txtNEM] [varchar](400) NULL,      
  [txtCUR] [varchar](3) NULL,      
  [txtTIT] [varchar](400) NULL,      
  [txtCOUNTRY] [varchar](400) NULL,      
  [txtSEC] [varchar](400) NULL,
  [txtBur][Varchar](10)    NULL,
 [txtid2][Varchar](12) null       
  PRIMARY KEY CLUSTERED (      
   txtLiquidation,txtId1      
   )      
 )      
      
 -- Tabla Buffer de Vectores       
 DECLARE @tmp_tblUnifiedPricesEquity TABLE (      
  [txtTv] [varchar](10),      
  [txtEmisora] [varchar](10),      
  [txtSerie] [varchar](10),      
  [txtId1] [varchar](11),      
  [dblAmount] [float]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 -- Tabla OLD_VALUE      
 DECLARE @tblIdsAddOLD_VALUE TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME],      
  [txtItem][CHAR](10),      
  [txtValue][VARCHAR](50)      
  PRIMARY KEY CLUSTERED (      
   txtId1,dteDate,txtItem      
   )      
 )      
      
 DECLARE @tmp_tblKEYsNW_TV TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKEYsNW_NEC TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKEYsNW_SER TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKEYsOLD_TV TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKEYsOLD_NEC TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKEYsOLD_SER TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKEYsFECHA_AJUSTE TABLE (      
  [txtId1][CHAR](11),      
  [dteDate][DATETIME]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKeyAccionesNal TABLE (      
  [txtid1][CHAR](11),      
  [dblPrice][FLOAT]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 DECLARE @tmp_tblKeyAccionesNal_1 TABLE (      
  [txtid1][CHAR](11),      
  [dblMax][FLOAT],      
  [dblMin][FLOAT]      
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      
      
 -- Tabla Intermedia para Obtención de Datos      
 DECLARE @tblVectorPricesBenchMarks TABLE (      
  [txtId1][CHAR](11),      
  [txtTv][VARCHAR](10),      
  [txtEmisora][VARCHAR](10),      
  [txtSerie][VARCHAR](10),      
  [txtCODIGO_PRODUCTO][CHAR](13),      
  [txtTIPO_ACTIVO][CHAR](1),      
  [dteFECHA][DATETIME],      
  [dblPRECIO][FLOAT],      
  [txtNOMBRE][VARCHAR](50) NULL,      
  [txtCODIGO_INTERNACIONAL][VARCHAR](19) NULL,      
  [txtDIVISA][VARCHAR](3) NULL,      
  [dblOPEN][FLOAT] NULL,      
  [dblHIGH][FLOAT] NULL,      
  [dblLOW][FLOAT] NULL,      
  [txtVOLUMEN][VARCHAR](20) NULL,      
  [txtEMISOR_PRECIO][VARCHAR](60) NULL,   -- (Item: txtSuperIssuerName -> tabla tblSuperIssuersCatalog)      
  [txtPAIS][VARCHAR](2) NULL,      
  [txtSECTOR][VARCHAR](50) NULL,    -- (Item: SEC)      
  [txtCODIGO_INTERNACIONAL_BENCHMARK][CHAR](1) NULL,      
  [txtDIVISA_BENCHMARK][VARCHAR](3) NULL,   -- MXN para todos      
  [txtCODIGO_PRODUCTO_BENCHMARK][VARCHAR](19) NULL,      
  [txtCATEGORIA][VARCHAR](100) NULL,      
  [dteFECHA_AJUSTE][DATETIME] NULL,      
  [txtDESCRIPCION][VARCHAR](25) NULL,       
  [txtFACTOR_AJUSTE][CHAR](1) NULL,      
  [txtESTATUS_INSTRUMENTO][CHAR](1) NULL,      
  [txtNEW_VALUE][VARCHAR](19) NULL,       
  [txtOLD_VALUE][VARCHAR](19) NULL,        
  [txtOLDTv][VARCHAR](10),      
  [txtOLDEmisora][VARCHAR](10),      
  [txtOLDSerie][VARCHAR](10),      
  [txtNem][VARCHAR](50) null ,
  [txtBur][Varchar](10) null ,
  [txtid2][Varchar](12) null   
  PRIMARY KEY CLUSTERED (      
   txtId1      
   )      
 )      


/*Agregamos codigo para calcular Anexo 4 de Layout   -OACEVES*/


/*Creamos tabla con Universo*/
	Declare @tblIndexesPortfolios_Now table (txtIndex	char(7),dteDate datetime,txtId1	char(11),dblCount	 decimal(20,14))
/*Llenamos Universo*/
	insert into @tblIndexesPortfolios_Now
		select txtIndex,dteDate,txtId1,dblCount from dbo.tblIndexesPortfolios 
			where txtIndex 
			 in ('CETETRAC', 'IMC30', 'IPCCOMP', 'MEXBOL', 'M10TRAC', 'M5TRAC', 'UDITRAC' , 'UMSTRAC')
			 and  dtedate =@txtDate

			 /*Variable con suma de universo*/
			 declare @txtxUniverseCount float = (select  SUM(dblCount)  from @tblIndexesPortfolios_Now)
			 
			 /*Actualizamos Campo dblCount  = dblCount / @txtxUniverseCount*/
			 
			 update @tblIndexesPortfolios_Now
			 set dblCount =dblCount /@txtxUniverseCount
			 
			-- select * from @tblIndexesPortfolios_Now
			 
			 

			 
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


/*Fin de calculo de Anexo 4*/




/*Inicia codigo original de ¨Productro*/
 -- 1. Obtengo universo de instrumentos a procesar      
 INSERT @tblUniverso (txtId1,txtTV,txtEmisora,txtSerie,txtTipoActivo,intCustomerId)       
 SELECT          
   i.txtId1,i.txtTv,i.txtEmisora,i.txtSerie,      
   CASE WHEN i.txtTV IN ('J','JI','JSP','D1','D1SP','IP','IS','IT','L','LD','LP','LS','LT','M','M0','M3','M5','M7','MC','MP','S','S0','S3','S5','SC','SP','XA','D2','D2SP','D3','D3SP','D4','D4SP','D5','D5SP','D6','D6SP') THEN 'B'      
     WHEN i.txtTV IN ('*C', '*CSP') THEN 'C'      
     WHEN i.txtTV IN ('51','52','53','54','55','56','56SP') THEN 'F'      
     WHEN i.txtTV IN ('OA','OC','OD','OI') THEN 'O'      
     WHEN i.txtTV IN ('0','00','1','1A','1AFX','1ASP','1E','1ESP','3','41','1S','YY','YYSP','CF') THEN 'S'      
     WHEN i.txtTV IN ('FA','FB','FC','FD','FI','FM','FS','FU') THEN 'T'      
     WHEN i.txtTV IN ('WA','WASP','WC','WE','WESP','WI') THEN 'W'      
     WHEN i.txtTV IN ('FWD') THEN '3'      
     WHEN i.txtTV IN ('94','2U','3U','4U','92','95','96','B','BI','2P','3P','4P','90','91','91SP','93','93SP','97','98','R','R1','R3','R3SP','6U','CC','CP') THEN 'V'      
     WHEN i.txtTV IN ('1B','1C','1I','1ISP') THEN '8'      
     WHEN i.txtTV IN ('F','FSP') THEN 'D'      
     WHEN i.txtTV IN ('IRS','SWT') THEN '2'      
     WHEN i.txtTV IN ('2','71','75','D7','D7SP','G','I','PI','Q','QSP','73','76','D8','D8SP','IL','D','P1','JE') THEN 'A'      
     WHEN i.txtTV IN ('TR') THEN 'R'      
   ELSE ' '      
   END AS txtTipoActivo,      
   intCustomerId      
 FROM MxFixincome.dbo.tblIds AS i (NOLOCK)      
   INNER JOIN MxFixincome.dbo.tmp_tblActualPrices AS p (NOLOCK)      
    ON i.txtId1 = p.txtId1      
 WHERE       
  i.txtTV IN (      
     'J','JI','JSP','D1','D1SP','IP','IS','IT','L','LD','LP','LS','LT','M','M0','M3','M5','M7','MC','MP','S','S0','S3','S5','SC','SP','XA','D2','D2SP','D3','D3SP','D4','D4SP','D5','D5SP','D6','D6SP',      
     '*C','*CSP',      
     '51','52','53','54','55','56','56SP',      
     'OA','OC','OD','OI',      
     '0','00','1','1A','1AFX','1ASP','1E','1ESP','3','41','1S','YY','YYSP',      
     'FA','FB','FC','FD','FI','FM','FS','FU',      
     'WA','WASP','WC','WE','WESP','WI',      
     'FWD',      
     '94','2U','3U','4U','92','95','96','B','BI','2P','3P','4P','90','91','91SP','93','93SP','97','98','R','R1','R3','R3SP','6U','CC','CP',      
     '1B','1C','1I','1ISP',      
     'F','FSP',      
     'IRS','SWT',      
     '2','71','75','D7','D7SP','G','I','PI','Q','QSP','73','76','D8','D8SP','IL','D','P1','JE',      
     'TR','CF'      
     )      
  AND p.txtLiquidation IN ('MD','MP')      
      
 INSERT @tmp_tblUnifiedPricesEquity (txtTv,txtEmisora,txtSerie,txtId1,dblAmount)      
  SELECT      
   i.txtTv,      
   i.txtEmisora,      
   i.txtSerie,      
   i.txtId1,      
   e.dblAmount      
  FROM MxFixincome.dbo.tblIds AS i (NOLOCK)      
   INNER JOIN MxFixincome.dbo.tblequityprices AS e (NOLOCK)      
   ON i.txtId1 = e.txtid1      
  WHERE i.txtTv IN ('1','0','00','CF')       
   AND e.txtoperationCode = 'S01'       
   AND e.dtedate = @txtDate      
      
 -- Acciones Nacionales      
 INSERT @tmp_tblKeyAccionesNal (txtid1,dblPrice)      
  SELECT       
   p.txtid1,      
   p.dblPrice      
  FROM MxFixincome.dbo.tblEquityPrices AS p      
   INNER JOIN MxFixincome.dbo.tblIds AS i      
   ON p.txtId1 = i.txtId1      
  WHERE i.txtTv IN ('0','1','41')      
   AND p.txtOperationCode = 'A01'       
   AND p.dteDate = @txtDate       
   AND p.txtSource = 'BMV'       
      
 INSERT @tmp_tblKeyAccionesNal_1 (txtid1,dblMax,dblMin)      
  SELECT       
   p.txtid1,      
   p.dblMax,      
   p.dblMin      
  FROM MxFixincome.dbo.tblEquityPrices AS p      
   INNER JOIN MxFixincome.dbo.tblIds AS i      
   ON p.txtId1 = i.txtId1      
  WHERE i.txtTv IN ('0','1','41')      
   AND p.txtOperationCode = 'S01'       
   AND p.dteDate = @txtDate       
   AND p.txtSource = 'BMV'      
      
 -- 2. Cargo información universo a la tabla Intermedia para Obtención de Datos      
 INSERT @tblVectorPricesBenchMarks (txtId1,txtTv,txtEmisora,txtSerie,txtTIPO_ACTIVO,txtCODIGO_PRODUCTO)      
 SELECT txtId1,txtTv,txtEmisora,txtSerie,txtTipoActivo,'PiP'+ SUBSTRING('0000000000',1,10-LEN(LTRIM(STR(intCustomerId)))) + LTRIM(STR(intCustomerId))      
 FROM @tblUniverso      
      
 INSERT @tmp_tblUnifiedPricesReport(txtTv,txtEmisora,txtSerie,txtId1,txtLiquidation,dblPRL,txtNEM,txtCUR,txtTIT,txtCOUNTRY,txtSEC,txtBur,txtid2)      
 SELECT       
  RTRIM(txtTv),      
  RTRIM(txtEmisora),      
  RTRIM(txtSerie),      
  RTRIM(txtId1),      
  RTRIM(txtLiquidation),      
  dblPRL,      
  RTRIM(txtNEM),      
  CASE WHEN txtTv IN ('*C','*CSP') THEN SUBSTRING(RTRIM(txtSerie),1,3) ELSE 'MXN' END AS txtCUR,      
  RTRIM(txtTIT),      
  RTRIM(txtCOUNTRY),      
  RTRIM(txtSEC),  
 case 
	when txtbur =  '-' then 'VACIO'
	when txtBUR = 'ALTA' then '4'
	when txtBUR = 'BAJA' then '1'
	when txtBUR = 'MEDIA' then '2'
	when txtBUR = 'MINIMA' then '0'
	when txtBUR = 'NA' then 'VACIO'
	when txtBUR = 'NULA' then '0'
	when txtBUR = 'SIN BURSATILIDAD' then '0'
end,
  RTRIM(txtID2)
  
 FROM dbo.tmp_tblUnifiedPricesReport (NOLOCK)      
      
 -- 3. Obtengo la informacion de precios de Vector MD      
 -- 3.1 Para Items diponibles y defaults      
 UPDATE v      
 SET --v.txtCODIGO_PRODUCTO = 'CodigoProd',      
  v.dteFECHA = @txtDate,      
  v.dblPRECIO = p.dblPRL,      
  v.txtNOMBRE = CASE WHEN p.txtTV IN ('YY','YYSP') THEN RTRIM(p.txtEmisora) + ' ' + RTRIM(p.txtSerie) + ' ' + 'ADR' ELSE RTRIM(p.txtEmisora) + ' ' + RTRIM(p.txtSerie) END,      
  v.txtCODIGO_INTERNACIONAL = RTRIM(p.txtTV) + '_' + RTRIM(p.txtEmisora) + '_' + RTRIM(p.txtSerie),      
  v.txtDIVISA = p.txtCUR,      
  v.dblOPEN = CASE WHEN p.txtTV IN ('0','1','41') THEN RTRIM(STR(ROUND(an.dblPrice,6),19,6)) ELSE p.dblPRL END,      
  v.dblHIGH = CASE WHEN p.txtTV IN ('0','1','41') THEN RTRIM(STR(ROUND(an1.dblMax,6),19,6)) ELSE p.dblPRL END,      
  v.dblLOW = CASE WHEN p.txtTV IN ('0','1','41') THEN RTRIM(STR(ROUND(an1.dblMin,6),19,6)) ELSE p.dblPRL END,      
  v.txtVOLUMEN = CASE WHEN p.txtTV IN ('1','0','00') THEN RTRIM(STR(ROUND(pe.dblAmount,6),19,6)) ELSE p.txtTIT END,      
  v.txtPAIS = p.txtCOUNTRY,      
  v.txtSECTOR = p.txtSEC,      
  v.txtCODIGO_INTERNACIONAL_BENCHMARK = '',      
  v.txtDIVISA_BENCHMARK = '',       -- Para todos      
  v.txtCODIGO_PRODUCTO_BENCHMARK = '',       
  v.dteFECHA_AJUSTE = NULL,       -- Fecha de cambio de identificadores. Fecha de split en acciones      
  v.txtDESCRIPCION = '',        -- Reporta "Cambio de identificadores" si hay cambio en los identificadores o "Split" si hay  un split en acciones      
  v.txtFACTOR_AJUSTE = '',       -- Se reportara en blanco hasta que el área de Insumos reporte esta información      
  v.txtESTATUS_INSTRUMENTO = '1',      
  v.txtNEW_VALUE = RTRIM(p.txtTV) + '_' + RTRIM(p.txtEmisora) + '_' + RTRIM(p.txtSerie),      
  v.txtOLD_VALUE = '',
 v.txtNem= substring(p.txtNEM,0,50) ,--oaceves test  
v.txtBur = p.txtBur , --oaceves test 
v.txtid2 = p.txtid2 --oaceves test 
 FROM @tmp_tblUnifiedPricesReport AS p      
   INNER JOIN @tblVectorPricesBenchMarks AS v      
    ON p.txtId1 = v.txtId1      
   LEFT OUTER JOIN @tmp_tblUnifiedPricesEquity AS pe      
    ON p.txtId1 = pe.txtId1       
   LEFT OUTER JOIN @tmp_tblKeyAccionesNal AS an      
    ON p.txtId1 = an.txtId1       
   LEFT OUTER JOIN @tmp_tblKeyAccionesNal_1 AS an1      
    ON p.txtId1 = an1.txtId1         
 WHERE       
  p.txtLiquidation IN('MD','MP')      
      
 -- 3.1.1 Para cambio en campo SECTOR      
 UPDATE v      
 SET v.txtSECTOR = RTRIM(p.intSector)      
 FROM dbo.tblBMVSectorCatalog AS p (NOLOCK)      
   INNER JOIN @tblVectorPricesBenchMarks AS v      
    ON p.txtDescription = v.txtSECTOR      
      
 -- 3.2 Para EMISOR_PRECIO      
 UPDATE v      
 SET v.txtEMISOR_PRECIO = (CASE         
        WHEN v.txtTV IN ('1A','1ASP','YY','YYSP') THEN 'Sistema Internacional de Cotizaciones (SIC)'      
        WHEN v.txtTV IN ('0','00','1','3','41') THEN 'Bolsa Mexicana de Valores'      
        WHEN v.txtTV IN ('56','56SP') THEN 'Operadora extranjera'      
        WHEN v.txtTV IN ('54') THEN 'AFORE' + ' ' + RTRIM(txtSuperIssuer)      
        WHEN p.txtSuperIssuer = 'TASA' THEN 'Intercam Fondos'      
        WHEN p.txtSuperIssuer = 'OAFIRME' THEN 'AFIRME'      
        WHEN p.txtSuperIssuer = 'ADICION' THEN 'Vanguardia'      
        WHEN v.txtTV IN ('1E','1ESP') THEN 'Mercado Extranjero'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%ISHARES%' THEN 'BLACK ROCK'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%CURRENCYSHARES%' THEN 'CURRENCYSHARES'          WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%DVG%' THEN 'DV G'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%DIREXION%' THEN 'DIREXION'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%EASYETF%' THEN 'EASYETF'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%GLOBAL X%' THEN 'GLOBALX'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%HANG SENG%' THEN 'HANG SENG INVESTMENT MANAGEMENT'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%IPATH%' THEN 'iPath ETN'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%POWERSHARES%' THEN 'POWERSHARES'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%PROSHARES%' THEN 'PROSHARES'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%S.A.P.I.B.%' THEN 'SAPIB'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%PROTEGO CASA DE BOLSA%' THEN 'SMARTSHARES PROTEGO'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%SPDR%' THEN 'SPDR'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%STREETTRACKS%' THEN 'STATE STREET GLOBAL ADVISORS'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%UBS-ETF%' THEN 'UBS'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%MARKET VECTORS%' THEN 'VANECK'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%VANGUARD%' THEN 'VANGUARD'      
        WHEN v.txtTV IN ('1B','1C','1I','1ISP','1S') AND u.txtNEM LIKE '%WISDOMTREE%' THEN 'WISDOMTREE'      
        ELSE SUBSTRING(RTRIM(p.txtSuperIssuer),1,19)      
        END)      
 FROM MxFixincome.dbo.tblissuersCatalog AS p (NOLOCK)      
   INNER JOIN @tblVectorPricesBenchMarks AS v      
    ON p.txtIssuer = v.txtEmisora      
    INNER JOIN @tmp_tblUnifiedPricesReport AS u      
    ON p.txtIssuer = u.txtEmisora      
   
 -- 3.3 Para CATEGORIA      
 UPDATE v      
 SET v.txtCATEGORIA = SUBSTRING(RTRIM(p.txtTV),1,100)      
 FROM MxFixincome.dbo.tblTVCatalog AS p (NOLOCK)      
   INNER JOIN @tblVectorPricesBenchMarks AS v      
    ON p.txtTv = v.txtTv      
      
 -- 3.4 Para ESTATUS INSTRUMENTO      
 UPDATE v      
 SET v.txtESTATUS_INSTRUMENTO = '0'      
 FROM MxFixincome.dbo.tblFixedPrices AS p (NOLOCK)      
   INNER JOIN @tblVectorPricesBenchMarks AS v      
    ON p.txtId1 = v.txtId1      
 WHERE txtLiquidation IN ('MD','MP')      
      
 -- 3.5 Para obtener OLD_VALUE      
 -- 3.5.1 Obtengo todos los key disponibles para los items: TV,EMISORA,SERIE       
 INSERT @tblIdsAddOLD_VALUE (txtId1,dteDate,txtItem,txtValue)      
 SELECT txtId1,dteDate,txtItem,txtValue      
 FROM MxFixincome.dbo.tblIdsAdd AS tacc (NOLOCK)       
 WHERE txtItem IN ('TV','NEC','SER')      
      
 -- 3.5.2 Obtengo los Key más recientes      
 INSERT @tmp_tblKEYsNW_TV(txtId1,dteDate)      
 SELECT txtId1,MAX(dteDate)      
 FROM @tblIdsAddOLD_VALUE      
 WHERE txtItem = 'TV'      
 GROUP BY txtId1      
      
 INSERT @tmp_tblKEYsNW_NEC(txtId1,dteDate)      
 SELECT txtId1,MAX(dteDate)      
 FROM @tblIdsAddOLD_VALUE      
 WHERE txtItem = 'NEC'      
 GROUP BY txtId1      
      
 INSERT @tmp_tblKEYsNW_SER(txtId1,dteDate)      
 SELECT txtId1,MAX(dteDate)      
 FROM @tblIdsAddOLD_VALUE      
 WHERE txtItem = 'SER'      
 GROUP BY txtId1      
      
 --  3.5.3 Obtengo penultima fecha de ajuste los penultimos Key      
 INSERT @tmp_tblKEYsFECHA_AJUSTE      
 SELECT txtId1,MAX(dteDate)      
 FROM @tblIdsAddOLD_VALUE      
 WHERE txtItem IN ('TV','NEC','SER')      
 GROUP BY txtId1      
      
 -- 3.5.4 Para FECHA_AJUSTE      
 UPDATE v      
 SET v.dteFECHA_AJUSTE = f.dteDate,      
  v.txtDESCRIPCION = 'Cambio de identificadores'      
 FROM @tmp_tblKEYsFECHA_AJUSTE AS f      
   INNER JOIN @tblVectorPricesBenchMarks AS v      
    ON f.txtId1 = v.txtId1      
      
 -- 3.5.5 Elimino los Items más recientes para tomar el penúltimo cambio      
 DELETE tac       
 FROM       
  @tblIdsAddOLD_VALUE AS tac      
  INNER JOIN @tmp_tblKEYsNW_TV AS tkc      
   ON tac.txtId1 = tkc.txtId1       
    AND tac.dteDate = tkc.dteDate      
    AND tac.txtItem = 'TV'      
      
 DELETE tac       
 FROM       
  @tblIdsAddOLD_VALUE AS tac      
  INNER JOIN @tmp_tblKEYsNW_NEC AS tkc      
   ON tac.txtId1 = tkc.txtId1       
    AND tac.dteDate = tkc.dteDate      
    AND tac.txtItem = 'NEC'      
      
 DELETE tac       
 FROM       
  @tblIdsAddOLD_VALUE AS tac      
  INNER JOIN @tmp_tblKEYsNW_SER AS tkc      
   ON tac.txtId1 = tkc.txtId1       
    AND tac.dteDate = tkc.dteDate      
    AND tac.txtItem = 'SER'      
      
 -- 3.5.6 Obtengo los penultimos Key      
 INSERT @tmp_tblKEYsOLD_TV(txtId1,dteDate)      
 SELECT txtId1,MAX(dteDate)      
 FROM @tblIdsAddOLD_VALUE      
 WHERE txtItem = 'TV'      
 GROUP BY txtId1      
      
 INSERT @tmp_tblKEYsOLD_NEC(txtId1,dteDate)      
 SELECT txtId1,MAX(dteDate)      
 FROM @tblIdsAddOLD_VALUE      
 WHERE txtItem = 'NEC'      
 GROUP BY txtId1      
      
 INSERT @tmp_tblKEYsOLD_SER(txtId1,dteDate)      
 SELECT txtId1,MAX(dteDate)      
 FROM @tblIdsAddOLD_VALUE      
 WHERE txtItem = 'SER'      
 GROUP BY txtId1      
      
 -- 3.5.7 Obtengo los valores penúltimo cambio      
 UPDATE v      
 SET v.txtOLDTv = RTRIM(tac.txtValue)      
 FROM       
  @tblVectorPricesBenchMarks AS v      
  INNER JOIN @tmp_tblKEYsOLD_TV AS tkc      
    ON tkc.txtId1 = v.txtId1      
  INNER JOIN @tblIdsAddOLD_VALUE AS tac      
   ON tac.txtId1 = tkc.txtId1       
    AND tac.dteDate = tkc.dteDate      
    AND tac.txtItem = 'TV'      
 UPDATE v      
 SET v.txtOLDEmisora = RTRIM(tac.txtValue)      
 FROM       
  @tblVectorPricesBenchMarks AS v      
  INNER JOIN @tmp_tblKEYsOLD_NEC AS tkc      
    ON tkc.txtId1 = v.txtId1      
  INNER JOIN @tblIdsAddOLD_VALUE AS tac      
   ON tac.txtId1 = tkc.txtId1       
    AND tac.dteDate = tkc.dteDate      
    AND tac.txtItem = 'NEC'      
      
 UPDATE v      
 SET v.txtOLDSerie = RTRIM(tac.txtValue)      
 FROM       
  @tblVectorPricesBenchMarks AS v      
  INNER JOIN @tmp_tblKEYsOLD_SER AS tkc      
    ON tkc.txtId1 = v.txtId1      
  INNER JOIN @tblIdsAddOLD_VALUE AS tac      
   ON tac.txtId1 = tkc.txtId1       
    AND tac.dteDate = tkc.dteDate      
    AND tac.txtItem = 'SER'      
      
 -- 3.5.8 Determino ultimo código asignado      
 UPDATE v      
 SET v.txtOLD_VALUE = (CASE WHEN txtOLDTv IS NULL THEN RTRIM(txtTV) ELSE RTRIM(txtOLDTV) END) + '_' +       
      (CASE WHEN txtOLDEmisora IS NULL THEN RTRIM(txtEmisora) ELSE RTRIM(txtOLDEmisora) END) + '_' +       
      (CASE WHEN txtOLDSerie IS NULL THEN RTRIM(txtSerie) ELSE RTRIM(txtOLDSerie) END)      
 FROM       
  @tblVectorPricesBenchMarks AS v      
      
 -- 3.5.9 Elimino los codigos repetidos       
 UPDATE v      
 SET v.txtOLD_VALUE = '',      
  v.dteFECHA_AJUSTE = NULL,      
  v.txtDESCRIPCION = ''      
 FROM       
  @tblVectorPricesBenchMarks AS v      
 WHERE       
  v.txtNEW_VALUE = v.txtOLD_VALUE       
       
 -- Para modificar el campo 'txtTIPO_ACTIVO' de acuerdo al catalogo enviado por TechRules      
 UPDATE r      
 SET txtTIPO_ACTIVO = (CASE         
       WHEN txtTV IN ('D3','D3SP','2','G','Q','QSP','76') THEN 'L'      
       WHEN txtTV IN ('71','75','I','PI','73','IL','P1') THEN 'D'      
       WHEN txtTV IN ('F','FSP') THEN 'V'      
       WHEN txtTV IN ('D7','D7SP') THEN 'K'      
       WHEN txtTV IN ('D8','D8SP','JE') THEN 'B'      
       WHEN txtTV = '54' THEN 'P'      
       WHEN txtTV = 'RC' THEN 'I'      
     ELSE txtTIPO_ACTIVO      
     END)       
 FROM @tblVectorPricesBenchMarks AS r      
 WHERE txtTV IN ('D3','D3SP','54','RC','F','FSP','2','71','75','D7','D7SP','G','I','PI','Q','QSP','73','76','D8','D8SP','IL','P1','JE')      
       
 -- Para modificar el campo 'txtTIPO_ACTIVO' de acuerdo al catalogo enviado por TechRules      
 UPDATE r      
 SET txtNOMBRE = (CASE         
       WHEN txtTV IN ('51','52','53') THEN RTRIM(txtEmisora) + ' ' + RTRIM(txtSerie)      
     ELSE txtNOMBRE      
     END)       
 FROM @tblVectorPricesBenchMarks AS r      
 WHERE txtTV IN ('51','52','53')      
       
 -- Detalle de Información Vector de Precios      
 INSERT @tblResults (intConsecutivo,txtTV,txtEmisora,txtSerie,txtData)      
 SELECT       
   1,      
   txtTv,      
   txtEmisora,      
   txtSerie,       
   RTRIM(txtCODIGO_PRODUCTO) + '|' +      
   RTRIM(txtTIPO_ACTIVO) + '|' +      
   CONVERT(CHAR(8),dteFECHA,112) + '|' +      
   CASE WHEN dblPRECIO IS NULL THEN '' ELSE LTRIM(STR(ROUND(dblPRECIO,6),19,6)) END + '|' +      
   CASE       
    WHEN txtNOMBRE IS NULL OR txtNOMBRE = '-' OR txtNOMBRE = 'NA' THEN ''       
    ELSE RTRIM(txtNOMBRE)       
   END + '|' +      
   RTRIM(txtCODIGO_INTERNACIONAL) + '|' +      
   RTRIM(txtDIVISA) + '|' +      
   CASE WHEN dblOPEN IS NULL THEN '' ELSE LTRIM(STR(ROUND(dblOPEN,6),19,6)) END + '|' +      
   CASE WHEN dblHIGH IS NULL THEN '' ELSE LTRIM(STR(ROUND(dblHIGH,6),19,6)) END + '|' +      
   CASE WHEN dblLOW IS NULL THEN '' ELSE LTRIM(STR(ROUND(dblLOW,6),19,6)) END + '|' +      
   CASE WHEN txtVOLUMEN IS NULL OR txtVOLUMEN = '-' OR txtVOLUMEN = 'NA' THEN '' ELSE RTRIM(txtVOLUMEN) END + '|' +      
   CASE WHEN txtEMISOR_PRECIO IS NULL OR txtEMISOR_PRECIO = '-' OR txtEMISOR_PRECIO = 'NA' THEN '' ELSE RTRIM(txtEMISOR_PRECIO) END + '|' +      
   CASE WHEN txtPAIS IS NULL OR txtPAIS = '-' OR txtPAIS = 'NA' THEN '' ELSE RTRIM(txtPAIS) END + '|' +      
   CASE WHEN txtSECTOR IS NULL OR txtSECTOR = '-' OR txtSECTOR = 'NA' THEN '' ELSE RTRIM(txtSECTOR) END + '|' +      
   CASE WHEN txtCODIGO_INTERNACIONAL_BENCHMARK IS NULL OR txtCODIGO_INTERNACIONAL_BENCHMARK = '-' OR txtCODIGO_INTERNACIONAL_BENCHMARK = 'NA' THEN '' ELSE RTRIM(txtCODIGO_INTERNACIONAL_BENCHMARK) END + '|' +      
   CASE WHEN txtDIVISA_BENCHMARK IS NULL OR txtDIVISA_BENCHMARK = '-' OR txtDIVISA_BENCHMARK = 'NA' THEN '' ELSE RTRIM(txtDIVISA_BENCHMARK) END + '|' +      
   CASE WHEN txtCODIGO_PRODUCTO_BENCHMARK IS NULL OR txtCODIGO_PRODUCTO_BENCHMARK = '-' OR txtCODIGO_PRODUCTO_BENCHMARK = 'NA' THEN '' ELSE RTRIM(txtCODIGO_PRODUCTO_BENCHMARK) END + '|' +      
   RTRIM(txtCATEGORIA) + '|' +      
   CASE WHEN dteFECHA_AJUSTE IS NULL THEN '' ELSE CONVERT(CHAR(8),dteFECHA_AJUSTE,112) END + '|' +      
   CASE WHEN txtDESCRIPCION IS NULL OR txtDESCRIPCION = '-' OR txtDESCRIPCION = 'NA' THEN '' ELSE RTRIM(txtDESCRIPCION) END + '|' +      
   CASE WHEN txtFACTOR_AJUSTE IS NULL OR txtFACTOR_AJUSTE = '-' OR txtFACTOR_AJUSTE = 'NA' THEN '' ELSE RTRIM(txtFACTOR_AJUSTE) END + '|' +      
   RTRIM(txtESTATUS_INSTRUMENTO) + '|' +      
   CASE WHEN txtNEW_VALUE IS NULL  THEN '' ELSE RTRIM(txtNEW_VALUE) END + '|' +      
   CASE WHEN txtOLD_VALUE IS NULL  THEN '' ELSE RTRIM(txtOLD_VALUE) END      + '|' +    
   CASE WHEN bm.txtnem IS NULL  THEN '' ELSE RTRIM(bm.txtnem) END  + '|' +
   CASE WHEN Pi.txtProductIndex IS NULL  THEN '' ELSE RTRIM(Pi.txtProductIndex) END + '|' +
   CASE WHEN Pi.txtPesoIndex IS NULL  THEN '' ELSE RTRIM(Pi.txtPesoIndex) END   + '|' +   
   CASE WHEN Bm.txtBur IS NULL  THEN '' ELSE RTRIM(Bm.txtBur) END  + '|' + 
  CASE WHEN  Bm.txtid2 IS NULL  THEN '' ELSE RTRIM(Bm.txtid2) END 
   AS [txtData]      
 FROM @tblVectorPricesBenchMarks as Bm
full  outer  join   @tblProduct_Indexes  as Pi
on Bm.txtId1 = Pi.txtId1

 -- Detalle de Información BenchMarks      
 INSERT @tblResults (intConsecutivo,txtTV,txtEmisora,txtSerie,txtData)      
 SELECT       
   2,      
   p.txtType, -- txtTV      
   p.txtType, -- txtEmisora      
   p.txtType, -- txtSerie      
   'PiPB'+ SUBSTRING('000000000',1,9-LEN(LTRIM(STR(c.intCustomerId)))) + LTRIM(STR(c.intCustomerId))  + '|' +      
   'I'  + '|' +      
   CONVERT(CHAR(8),p.dteDate,112) + '|' +      
   CASE WHEN p.dblIndex IS NULL THEN '' ELSE LTRIM(STR(ROUND(p.dblIndex,6),19,6)) END + '|' +      
   CASE WHEN c.txtIndexNameMD IS NULL OR c.txtIndexNameMD = '-' OR c.txtIndexNameMD = 'NA' THEN '' ELSE     
 CASE WHEN p.txtType = 'PIPGUB'  THEN 'FTSE-PiP Guber'    
  WHEN p.txtType = 'B_'  THEN 'FTSE-PiP Cetes'    
  WHEN p.txtType = 'BI>>007'  THEN 'FTSE-PiP Cetes 7d'    
  WHEN p.txtType = 'BI>>028'  THEN 'FTSE-PiP Cetes 28d'    
  WHEN p.txtType = 'BI>>091'  THEN 'FTSE-PiP Cetes 70-90d'    
  WHEN p.txtType = 'BI>>090'  THEN 'FTSE-PiP Cetes 91d'    
  WHEN p.txtType = 'BI>>182'  THEN 'FTSE-PiP Cetes 182d'    
  WHEN p.txtType = 'BI>>364'  THEN 'FTSE-PiP Cetes 364d'    
  WHEN p.txtType = 'XA'  THEN 'FTSE-PiP Brems'    
  WHEN p.txtType = 'M_'  THEN 'FTSE-PiP Bonos'    
  WHEN p.txtType = 'M_CI'  THEN 'FTSE-PiP Bonos CI'    
  WHEN p.txtType = 'S_'  THEN 'FTSE-PiP Udibonos'    
  WHEN p.txtType = 'S_CI'  THEN 'FTSE-PiP Udibonos CI'    
  WHEN p.txtType = 'S_DUR>>5-6'  THEN 'FTSE-PiP Udibonos Dur 5-6 A'    
  WHEN p.txtType = 'PIPIPAB'  THEN 'FTSE-PiP IPAB'    
  WHEN p.txtType = 'IP'  THEN 'FTSE-PiP Bpas'    
  WHEN p.txtType = 'IT'  THEN 'FTSE-PiP Bpat'    
  WHEN p.txtType = 'IS'  THEN 'FTSE-PiP Bpa182'    
  WHEN p.txtType = 'IM'  THEN 'FTSE-PiP Bpag28'    
  WHEN p.txtType = 'IQ'  THEN 'FTSE-PiP Bpag91'    
  WHEN p.txtType = 'PI'  THEN 'FTSE-PiP Pic'    
  WHEN p.txtType = 'D1'  THEN 'FTSE-PiP UMS'    
  WHEN p.txtType = 'D1-USD'  THEN 'FTSE-PiP UMS Dólar'    
  WHEN p.txtType = 'D1-USD>>1AP'  THEN 'FTSE-PiP UMS Dólar1A'    
  WHEN p.txtType = 'D1-USD>>5AP'  THEN 'FTSE-PiP UMS Dólar5A'    
  WHEN p.txtType = 'D1-USD>>10AP'  THEN 'FTSE-PiP UMS Dólar10A'    
  WHEN p.txtType = 'D1-USD>>20AP'  THEN 'FTSE-PiP UMS Dólar20A'    
  WHEN p.txtType = 'D1-USD>>LP'  THEN 'FTSE-PiP UMS Dólar20A+'    
  WHEN p.txtType = 'D1SP-USD>>5AP'  THEN 'FTSE-PiP UMS Dólar5A SP'    
  WHEN p.txtType = 'D1-EUR'  THEN 'FTSE-PiP UMS Euro'    
  WHEN p.txtType = 'TFGO'  THEN 'FTSE-PiP Fondeo G'    
  WHEN p.txtType = 'FONDGUBB'  THEN 'FTSE-PiP Fondeo GB'    
  WHEN p.txtType = 'FONDGUBN'  THEN 'FTSE-PiP Fondeo GN'    
  WHEN p.txtType = 'TFGOBAN'  THEN 'FTSE-PiP FondGubBANX'    
  WHEN p.txtType = 'PIPF'  THEN 'FTSE-PiP Fix'    
  WHEN p.txtType = 'PIPF1M'  THEN 'FTSE-PiP Fix1M'    
  WHEN p.txtType = 'PIPF3M'  THEN 'FTSE-PiP Fix3M'    
  WHEN p.txtType = 'PIPF6M'  THEN 'FTSE-PiP Fix6M'    
  WHEN p.txtType = 'PIPF12M'  THEN 'FTSE-PiP Fix1A'    
  WHEN p.txtType = 'PIPF13M'  THEN 'FTSE-PiP Fix12M+'    
  WHEN p.txtType = 'PIPF3A'  THEN 'FTSE-PiP Fix3A'    
  WHEN p.txtType = 'PIPF5A'  THEN 'FTSE-PiP Fix5A'    
  WHEN p.txtType = 'PIPF10A'  THEN 'FTSE-PiP Fix10A'    
  WHEN p.txtType = 'M_>>20AP'  THEN 'FTSE-PiP Fix20A'    
  WHEN p.txtType = 'M_>>30AP'  THEN 'FTSE-PiP Fix30A'    
  WHEN p.txtType = 'PIPFL'  THEN 'FTSE-PiP Float'    
  WHEN p.txtType = 'PIPFLCP'  THEN 'FTSE-PiP Float12M'    
  WHEN p.txtType = 'PIPFLLP'  THEN 'FTSE-PiP Float12M+'    
  WHEN p.txtType = 'PIPFL2'  THEN 'FTSE-PiP Float2'    
  WHEN p.txtType = 'PIPREAL'  THEN 'FTSE-PiP Real'    
  WHEN p.txtType = 'PIPR1A'  THEN 'FTSE-PiP Real1A'    
  WHEN p.txtType = 'PiP–Real1-3A'  THEN 'FTSE-PiP Real3A'    
  WHEN p.txtType = 'PIPR5A'  THEN 'FTSE-PiP Real5A'    
  WHEN p.txtType = 'PIPR10A'  THEN 'FTSE-PiP Real10A'    
  WHEN p.txtType = 'PIPR20A'  THEN 'FTSE-PiP Real20A'    
  WHEN p.txtType = 'PIPR30A'  THEN 'FTSE-PiP Real30A'    
  WHEN p.txtType = 'PIPREAL_CI'  THEN 'FTSE-PiP Real CI'    
  WHEN p.txtType = 'PIPR20A_CI'  THEN 'FTSE-PiP Real 20A CI'    
  WHEN p.txtType = 'PIPR30A_CI'  THEN 'FTSE-PiP Real 30A CI'    
  WHEN p.txtType = '2U'  THEN 'FTSE-PiP CBIC'    
  WHEN p.txtType = '2UCI'  THEN 'FTSE-PiP CBIC CI'    
  WHEN p.txtType = 'SHF'  THEN 'FTSE-PiP SHF'    
  WHEN p.txtType = 'SHF-MPS'  THEN 'FTSE-PiP SHF Pesos'    
  WHEN p.txtType = 'SHF-UDI'  THEN 'FTSE-PiP SHF Udis'    
  WHEN p.txtType = 'BORHIS'  THEN 'FTSE-PiP BORHIS'    
  WHEN p.txtType = 'LD'  THEN 'FTSE-PiP BondesD'    
  WHEN p.txtType = 'CEDEVIS>>1A'  THEN 'FTSE-PiP Cedevis1A'    
  WHEN p.txtType = 'TFB'  THEN 'FTSE-PiP Fondeo B'    
  WHEN p.txtType = 'BANK'  THEN 'FTSE-PiP Bank'    
  WHEN p.txtType = 'BANK>>CP'  THEN 'FTSE-PiP Bank12M'    
  WHEN p.txtType = 'BANK>>LP'  THEN 'FTSE-PiP Bank12M+'    
  WHEN p.txtType = 'D2S'  THEN 'FTSE-PiP Eurobonos'    
  WHEN p.txtType = 'CORP_M'  THEN 'FTSE-PiP MCorp'    
  WHEN p.txtType = 'CORP_M>>CP'  THEN 'FTSE-PiP MCorp12M'    
  WHEN p.txtType = 'CORP_M>>LP'  THEN 'FTSE-PiP MCorp12M+'    
  WHEN p.txtType = 'STD_COR_FIX_-=3'  THEN 'FTSE-PiP CORP FIX<=3'    
  WHEN p.txtType = 'STD_COR_FIX_3-7'  THEN 'FTSE-PiP CORP FIX3 7'    
  WHEN p.txtType = 'STD_COR_FIX_+7'  THEN 'FTSE-PiP CORP FIX7+'    
  WHEN p.txtType = 'STD_COR_FLO_-=5'  THEN 'FTSE-PiP CORP FL<=5'    
  WHEN p.txtType = 'STD_COR_FLO_+5'  THEN 'FTSE-PiP CORP FL5+'    
  WHEN p.txtType = 'D4>>1MP'  THEN 'FTSE-PiP US T-bills 1M'    
  WHEN p.txtType = 'D4>>3MP'  THEN 'FTSE-PiP US T-bills 3M'    
  WHEN p.txtType = 'D4>>6MP'  THEN 'FTSE-PiP US T-bills 6M'    
  WHEN p.txtType = 'D4>>1MP-SP'  THEN 'FTSE-PiP TB1M SP'    
  WHEN p.txtType = 'D4>>3MP-SP'  THEN 'FTSE-PiP TB3M SP'    
  WHEN p.txtType = 'BTF>>1MP'  THEN 'FTSE-PiP FR T-bills 1M'    
  WHEN p.txtType = 'BTF>>1MP-SP'  THEN 'FTSE-PiP TR FR SP'    
  WHEN p.txtType = 'CKD_2012'  THEN 'FTSE-PiP CKDs'    
  WHEN p.txtType = 'CF_FIBRAS'  THEN 'FTSE-PiP FIBRAS'    
  WHEN p.txtType = 'LS' THEN 'FTSE-PiP BondesD'    
 ELSE RTRIM(c.txtIndexNameMD)     
  END      
   END + '|' +      
   'PiPB'+ SUBSTRING('000000000',1,9-LEN(LTRIM(STR(c.intCustomerId)))) + LTRIM(STR(c.intCustomerId))  + '|' + -- Codigo Internacional      
   'MXN'  + '|' + -- Divisa      
   CASE WHEN p.dblIndex IS NULL THEN '' ELSE LTRIM(STR(ROUND(p.dblIndex,6),19,6)) END + '|' +   -- OPEN      
   CASE WHEN p.dblIndex IS NULL THEN '' ELSE LTRIM(STR(ROUND(p.dblIndex,6),19,6)) END + '|' +  -- HIGH      
   CASE WHEN p.dblIndex IS NULL THEN '' ELSE LTRIM(STR(ROUND(p.dblIndex,6),19,6)) END + '|' +  -- LOW      
   ''  + '|' + -- VOLUMEN      
   ''  + '|' + -- EMISOR_PRECIO      
   ''  + '|' + -- PAIS      
   ''  + '|' + -- SECTOR      
   ''  + '|' + -- CODIGO_INTERNACIONAL_BENCHMARK      
   'MXN'  + '|' + -- DIVISA_BENCHMARK      
   'PiPB'+ SUBSTRING('000000000',1,9-LEN(LTRIM(STR(c.intCustomerId)))) + LTRIM(STR(c.intCustomerId))  + '|' +  -- CODIGO_PRODUCTO_BENCHMARK      
   'Benchmark' + '|' +      
   ''  + '|' + -- FECHA_AJUSTE      
   ''  + '|' + -- DESCRIPCION      
   ''  + '|' + -- FACTOR_AJUSTE      
   '1'  + '|' + -- ESTATUS_INSTRUMENTO      
   ''  + '|' + -- NEW_VALUE      
   ''  + '|' + -- OLD_VALUE
   ''  + '|' +--NOMBRE_LARGO
    ''  + '|' +--CODIGO_PRODUCTO_INDICE
    ''  + '|' +--PESO_INDICE
    ''  + '|' +--BURSATILIDAD
   ''  --ISIN
        
    
   AS [txtData]      
 FROM MxFixincome.dbo.tblBenchCatalog AS c (NOLOCK)      
  INNER JOIN MxFixincome.dbo.tblPiPIndexes AS p (NOLOCK)      
   ON c.txtType = p.txtType AND c.intTaxes = p.intTaxes      
 WHERE p.dteDate = @txtDate      
  AND p.txtType IN (      
   'CEDEVIS>>1A','SHF','SHF-MPS','SHF-UDI','BANK>>CP','BANK>>LP','BANK','TFB','BORHIS','STD_COR_FLO_-=5',      
   'STD_COR_FLO_+5','STD_COR_FIX_-=3','STD_COR_FIX_3-7','STD_COR_FIX_+7','D2S','CORP_M>>CP','CORP_M>>LP',      
   'CORP_M','PIPGUB','LS','LD','LATMEXBonds5Y','LATMEXBonds10Y','M_CI','M_','LATMEXBonds>10Y','IS','IP',      
   'IT','XA','2UCI','2U','BI>>182','BI>>028','BI>>364','BI>>007','BI>>091','BI>>090','B_','LATMEXCetes',      
   'PIPF10A','PIPF13M','PIPF1M','PIPF12M','M_>>20AP','M_>>30AP','PIPF3M','PIPF3A','PIPF5A','PIPF6M','PIPF',      
   'PIPFLCP','PIPFLLP','PIPFL2','PIPFL','FONDGUBB','TFGOBAN','FONDGUBN','PI','PIPR10A','PIPR1A','PIPR20A',      
   'PIPR30A','PIPR5A','PIPR20A_CI','PIPREAL_CI','PIPR30A_CI','PIPREAL','S_CI','S_','S_DUR>>5-6','LATMEXUDIS',      
   'D1','D1-USD>>10AP','D1-USD>>20AP','D1-USD>>LP','D1-USD>>5AP','D1-USD>>1AP','D1-USD','D1-EUR','LATMEXUMS',      
   'PIPIPAB')      
  AND p.intTaxes = 0      
      
 -- Valida la información       
 IF ((SELECT count(*) FROM @tblResults) <= 1)      
      
  BEGIN      
   RAISERROR ('ERROR: Falta Informacion', 16, 1)      
  END      
      
 ELSE      
   -- Reporto informacion      
   SELECT       
   RTRIM(txtData)      
   FROM @tblResults      
   ORDER BY intConsecutivo,txtTV,txtEmisora,txtSerie      
      
 --SET NOCOUNT OFF     
 --END     
