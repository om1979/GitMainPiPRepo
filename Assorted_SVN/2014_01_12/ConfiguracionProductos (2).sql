
------------------------------------------------------------------------
--  Creador:			Mike Ramírez  
--  Fecha Creacion:		27-Octubre-2014  
--  Modulo 6:			Para generar el producto de Curvas Afore Banamex
------------------------------------------------------------------------
--CREATE PROCEDURE [dbo].[sp_productos_AFOREBANAMEX];6  
DECLARE 	@txtDate AS DATETIME = '20141120'

--AS 
--BEGIN

--	SET NOCOUNT ON 
	
	DECLARE @tmpLayoutxlCurve TABLE (
		SheetName CHAR(50),
		Col INT,
		Header CHAR(50),
        Source CHAR(20),
        Type CHAR(3),
		SubType CHAR(3),
		Range CHAR(15),
		Factor CHAR(5),
		DataType CHAR(3), 
		DataFormat CHAR(20),
		fLoad CHAR(1),
	PRIMARY KEY (Col)
	)	

	-- <Sheet1> = Sheet1
	INSERT @tmpLayoutxlCurve 
		SELECT 'Sheet1' AS [SheetName], 0  AS [Col],'Fecha' AS [Header],'DATE()'    AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DTE' AS [DataType], 'DD/MM/YYYY' AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 1 AS [Col],'Plazo'  AS [Header],'[intTerm]' AS [Source],''    AS [Type],''    AS [SubType],''     AS [Range],''     AS [Factor], 'DBL' AS [DataType], ''           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 2 AS [Col],'Cetes'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'CT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 3 AS [Col],'Cetes IMPTO'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'CTI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 4 AS [Col],'Yield Bonos'  AS [Header],'CURVES' AS [Source],'MSG'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 5 AS [Col],'Ipabono'  AS [Header],'CURVES' AS [Source],'BPA'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 6 AS [Col],'Ipabono Trimestral'  AS [Header],'CURVES' AS [Source],'BPT'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 7 AS [Col],'Bonde 182'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'SE'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
		SELECT 'Sheet1' AS [SheetName], 8 AS [Col],'Bondes LT'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'LT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'0' AS [fLoad] UNION
		SELECT 'Sheet1' AS [SheetName], 9 AS [Col],'Brems'  AS [Header],'CURVES' AS [Source],'XA'    AS [Type],'XA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 10 AS [Col],'Yield Real'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 11 AS [Col],'Real'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'U%'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 12 AS [Col],'Real IMPTO'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'UUI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 13 AS [Col],'Pagares Udizados'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'PIP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 		
		SELECT 'Sheet1' AS [SheetName], 14 AS [Col],'Reporto Guber G1'  AS [Header],'CURVES' AS [Source],'RG1'    AS [Type],'G1'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 15 AS [Col],'Reporto Guber G1 IMPTO'  AS [Header],'CURVES' AS [Source],'RG1'    AS [Type],'G1I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 16 AS [Col],'Reporto Guber G2'  AS [Header],'CURVES' AS [Source],'RG2'    AS [Type],'G2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 17 AS [Col],'Reporto Guber G2 IMPTO'  AS [Header],'CURVES' AS [Source],'RG2'    AS [Type],'G2I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 18 AS [Col],'Reporto Guber G3'  AS [Header],'CURVES' AS [Source],'RG3'    AS [Type],'G3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 19 AS [Col],'Reporto Guber G3 IMPTO'  AS [Header],'CURVES' AS [Source],'RG3'    AS [Type],'G3I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 20 AS [Col],'Reporto Bancario B1'  AS [Header],'CURVES' AS [Source],'RB1'    AS [Type],'B1'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 21 AS [Col],'Reporto Bancario B2'  AS [Header],'CURVES' AS [Source],'RB2'    AS [Type],'B2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 22 AS [Col],'Reporto Bancario B3'  AS [Header],'CURVES' AS [Source],'RB3'    AS [Type],'B3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 23 AS [Col],'Reporto Bancario B4'  AS [Header],'CURVES' AS [Source],'RB4'    AS [Type],'B4'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 24 AS [Col],'Bancario B1'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'3A'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 25 AS [Col],'Bancario B2'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'P8'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 26 AS [Col],'Bancario B3'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'PO'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 27 AS [Col],'Bancario B4'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'BIN'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 28 AS [Col],'Ums'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 29 AS [Col],'Cedes Dolarizados'  AS [Header],'CURVES' AS [Source],'CDE'    AS [Type],'USD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 30 AS [Col],'Calificacion A'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 31 AS [Col],'Calificacion AA'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 32 AS [Col],'Calificacion AAA'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 33 AS [Col],'Calificacion B'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'B0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]UNION 
		SELECT 'Sheet1' AS [SheetName], 34 AS [Col],'Calificacion C'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'C0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 35 AS [Col],'Calificacion D '  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'D0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 36 AS [Col],'Implicita Pesos'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CU'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 37 AS [Col],'Puntos Forward'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'PIP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 38 AS [Col],'Tipo de Cambio Forward'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'LB'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 39 AS [Col],'Fras Tiie'  AS [Header],'CURVES' AS [Source],'TDS'    AS [Type],'T28'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 40 AS [Col],'Descuento Irs'  AS [Header],'CURVES' AS [Source],'SWP'    AS [Type],'TI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 41 AS [Col],'Treasuries'  AS [Header],'CURVES' AS [Source],'TSN'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 42 AS [Col],'Libor Yield'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 43 AS [Col],'Libor'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'BL'   AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 44 AS [Col],'Cross Currency ASK'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'VTA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 45 AS [Col],'Cross Currency BID'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'CPA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 46 AS [Col],'Cross Currency MID'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'MED'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 47 AS [Col],'Libor Canada'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]  UNION 
		SELECT 'Sheet1' AS [SheetName], 48 AS [Col],'Libor Euro'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 49 AS [Col],'Libor Yen'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 50 AS [Col],'Libor Marco'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'DEM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 51 AS [Col],'Riesgo Mexico'  AS [Header],'CURVES' AS [Source],'SPD'    AS [Type],'PA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 52 AS [Col],'Tipo de Cambio Forward (Base FIX)'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'FIX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 53 AS [Col],'Implicita Pesos (Base FIX)'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CUX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 54 AS [Col],'Ipabono Semestral'  AS [Header],'CURVES' AS [Source],'BPS'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 55 AS [Col],'Cross Currency Swap Udi/Libor'  AS [Header],'CURVES' AS [Source],'ULS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 56 AS [Col],'Libor Hong Kong'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'HKD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 57 AS [Col],'Implicita en Forward de Peso Colombiano'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'COP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 58 AS [Col],'Cetes Irs'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'IRS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 59 AS [Col],'Libor Australiana'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'AUD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 60 AS [Col],'Libor Franco Suizo'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'CHF'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 61 AS [Col],'Libor Londres'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 62 AS [Col],'Implicita en Forward de Real Brasilenio'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 63 AS [Col],'Bondes D'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'XA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
 		SELECT 'Sheet1' AS [SheetName], 64 AS [Col],'Cross Currency Swap Udi/TIIE'  AS [Header],'CURVES' AS [Source],'UDT'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'    AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 65 AS [Col],'Udi/TIIE tasa Swap'  AS [Header],'CURVES' AS [Source],'UDT'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 66 AS [Col],'Yiel Bonos Neto'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'YT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 67 AS [Col],'Euribor'  AS [Header],'CURVES' AS [Source],'EUR'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
		SELECT 'Sheet1' AS [SheetName], 68 AS [Col],'Implicita en Forward de Euro'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 69 AS [Col],'Implicita en Forward de Yen Japones'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 70 AS [Col],'Implicita en Forward de Dolar Canadiense'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 71 AS [Col],'Tipo de Cambio Forward Dolar Canadiense'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 72 AS [Col],'Tipo de Cambio Forward Euro'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 73 AS [Col],'Tipo de Cambio Forward MXP/EUR'  AS [Header],'CURVES' AS [Source],'FTM'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 74 AS [Col],'Tipo de Cambio Forward Real Brasilenio'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 75 AS [Col],'Tipo de Cambio Forward Yen Japones'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 76 AS [Col],'Implicita en Forward de Libra Esterlina'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 77 AS [Col],'Tipo de Cambio Forward Libra Esterlina'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 78 AS [Col],'Reporto UMS'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'REP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 79 AS [Col],'Cross Currency Swap Libor USD/Euribor'  AS [Header],'CURVES' AS [Source],'LES'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 80 AS [Col],'Cross Currency Swap Tiie/Euribor'  AS [Header],'CURVES' AS [Source],'ETS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 81 AS [Col],'Ums Zero 364/YTM'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'YUM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 82 AS [Col],'Libor Yen Cupon Cero'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 83 AS [Col],'Libor Euro Cupon Cero'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS[fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 84 AS [Col],'Udi/Libor tasa Swap'  AS [Header],'CURVES' AS [Source],'ULS'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 85 AS [Col],'Yield Real con Impuesto'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'YLI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 86 AS [Col],'Reporto Privados AAA'  AS [Header],'CURVES' AS [Source],'RPR'    AS [Type],'A3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 87 AS [Col],'Cross Currency Swap TIIE/Libor Bid'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'CCB'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 88 AS [Col],'Tiie Swap'  AS [Header],'CURVES' AS [Source],'TIE'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 89 AS [Col],'Descuento OIS USD'  AS [Header],'CURVES' AS [Source],'OIS'    AS [Type],'USD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 90 AS [Col],'Descuento OIS MXN'  AS [Header],'CURVES' AS [Source],'OIS'    AS [Type],'MXN'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
		SELECT 'Sheet1' AS [SheetName], 91 AS [Col],'Implicita Libor 3m'  AS [Header],'CURVES' AS [Source],'OIS'    AS [Type],'LU3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
		SELECT 'Sheet1' AS [SheetName], 92 AS [Col],'Implícita Libor 1m'  AS [Header],'CURVES' AS [Source],'OIS'    AS [Type],'LU1'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION		
		SELECT 'Sheet1' AS [SheetName], 93 AS [Col],'Re-estimación Tiie'  AS [Header],'CURVES' AS [Source],'OIS'    AS [Type],'T28'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION 
		SELECT 'Sheet1' AS [SheetName], 94 AS [Col],'Implicita en Forward de Euro en Pesos'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'EUM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]  


	SELECT
		RTRIM(SheetName) AS [SheetName],
		Col AS [Col],
		RTRIM(Header) AS [Header],
        RTRIM(Source) AS [Source],
        RTRIM(Type) AS [Type],
		RTRIM(SubType) AS [SubType],
		RTRIM(Range) AS [Range],
		RTRIM(Factor) AS [Factor],
		RTRIM(DataType) AS [DataType], 
		RTRIM(DataFormat) AS [DataFormat],
		RTRIM(fLoad) AS [fLoad]
	FROM @tmpLayoutxlCurve 
	WHERE Col > 0
	ORDER BY Col

--	SET NOCOUNT OFF
--END

--GO


SELECT TOP 10 * FROM  dbo.tblProcesos AS TP
WHERE txtProducto = 'AFOBANAMEX_CURVES_CSV'





SELECT TOP 10 * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'AFOBANAMEX_CURVES_CSV'

SELECT * FROM  MxProcesses..tblProcessCatalog AS TPC
WHERE txtProcess = 'AFOBANAMEX_CURVES_CSV'

SELECT * FROM  MxProcesses..tblProcessDurations AS TPD
WHERE txtProcess = 'AFOBANAMEX_CURVES_CSV'

SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtProduct = 'ACCIVAL_CURVAS_GEN'


SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtPack = 'OPERATIVO_2'


--UPDATE 
--MxProcesses..tblProductGeneratorMap 
--SET fload = 1
--WHERE txtProduct = 'ACCIVAL_CURVAS_GEN'
--AND txtPack = 'operativo_2'





SELECT * FROM MxProcesses..tblOwnersCatalog AS TOC


--SELECT DISTINCT txtPack FROM  MxProcesses..tblProductGeneratorMap 




SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'BANOBRAS_VECTOR_MD_OPE'

SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtValor LIKE '%curvas_AF%'


SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso IN 
(
'AFOBANAMEX_CURVES_CSV'--,
--'AFOBANAMEX_CURVES_XLS'
)

SELECT * FROM  dbo.tblProcesos AS TP
WHERE txtProducto ='AFOBANAMEX_CURVES_CSV'

SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtPack = 'OPERATIVO_2'

UPDATE MxProcesses..tblProductGeneratorMap  
SET txtPack = 'inactivo'
WHERE txtProduct ='AFOBANAMEX_CURVES_XLS_GEN'


SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'ACCIVAL_CURVAS_GEN'


SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'AFOBANAMEX_CURVES_XLS_GEN'



SELECT * FROM  dbo.tblProcesos AS TP
WHERE +

TXT


SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso ='PIP_CURVAS_MSEXCEL_GEN'

SELECT  * INTO tmp_activex_20150211
FROM  dbo.tblActiveX AS TAX
WHERE txtProceso ='PIP_CURVAS_MSEXCEL_GEN'



SELECT '.'+txtPropiedad + ' = ' + '"'+ txtValor+ '"' FROM   dbo.tblActiveX AS TAX
WHERE txtProceso ='PIP_CURVAS_MSEXCEL_GEN'



SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'PIP_CURVAS_MSEXCEL_GEN'


SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'XXI_CURVES_XLS'


UPDATE dbo.tblActiveX 
SET txtValor = 'clsPIPEXCELGEN.Log'
WHERE txtProceso = 'PIP_CURVAS_MSEXCEL_GEN'
AND txtPropiedad = 'LogFile'




SELECT * FROM  dbo.tblProcesos AS TP
WHERE txtProducto = 'XXI_CURVES_XLS'


SELECT * FROM  dbo.tblProcesos
WHERE txtProducto = 'PIP_CURVAS_MSEXCEL_GEN'



UPDATE dbo.tblProcesos
SET txtMetodo = 'Execute'
WHERE txtProducto = 'PIP_CURVAS_MSEXCEL_GEN'



sp_CreateCurvesFile;4 '20150210'


SELECT * FROM  dbo.tblProcesos AS TP
WHERE txtProducto LIKE '%xls%'
AND txtProducto IN (SELECT DISTINCT txtProceso  FROM  dbo.tblActiveX AS TAX
WHERE txtValor LIKE '%xlCrossTabCurves%'
)




--DELETE FROM dbo.tblActiveX
--WHERE txtProceso = 'ACCIVAL_CURVAS_GEN'
--AND txtPropiedad = 'TemplatePath'


UPDATE dbo.tblActiveX
SET txtValor = 'Curvas_Gen[DATE|YYYYMMDD].txt'
WHERE txtProceso ='ACCIVAL_CURVAS_GEN'
AND txtPropiedad = 'FileName'




SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'ACCIVAL_CURVAS_GEN'

SELECT * FROM  dbo.tblActiveX AS TAX
WHERE txtProceso = 'PIP_CURVAS_MSEXCEL_GEN'



ACCIVAL_CURVAS_GEN
PIP_CURVAS_MSEXCEL_GEN

SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtPack = 'OPERATIVO_2'



SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtProduct IN 
(
'ACCIVAL_CURVAS_GEN'
,'PIP_CURVAS_MSEXCEL_GEN'
)




UPDATE   MxProcesses..tblProductGeneratorMap 
SET txtPack = 'INACTIVO'
WHERE txtProduct IN 
(
'ACCIVAL_CURVAS_GEN'--p224
,'PIP_CURVAS_MSEXCEL_GEN'--DEF_CUR
)


SELECT * FROM  MxProcesses..tblProductGeneratorMap 
WHERE txtProduct IN 
(
'ACCIVAL_CURVAS_GEN'--p224
,'PIP_CURVAS_MSEXCEL_GEN'--DEF_CUR
)



ACCIVAL_CURVAS	PRECIOS	p224
PIP_CURVAS_MSEXCEL	PRECIOS	DEF_CUR



UPDATE MxProcesses..tblProductGeneratorMap  
SET txtPack = 'p224'
WHERE txtProduct ='ACCIVAL_CURVAS_GEN'
AND txtPack = 'OPERATIVO_2'

UPDATE MxProcesses..tblProductGeneratorMap  
SET txtPack = 'DEF_CUR'
WHERE txtProduct ='PIP_CURVAS_MSEXCEL_GEN'















