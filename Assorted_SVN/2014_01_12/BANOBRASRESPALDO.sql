    
    
  CREATE PROCEDURE dbo.sp_productos_BANOBRAS;1 -- '20140806' , 'md','1'  
   @txtDate AS VARCHAR(10),--= '20140806'--,  
   @txtLiquidation AS VARCHAR(10), --= 'MD'--,  
   @txtFlag AS VARCHAR (1)  --= '1'   
    
    
/*    
    
 Version: 2.2    
     
 v2.2 JATO (01:46 p.m. 2005-10-13)    
 Agregue el modulo programado x Gustavo    
 para generar el vector promedio de BANOBRAS    
     
  Version 2.1      
       
   Procedimiento que genera la información para el vector de BANOBRAS    
  Actualizacion de descripciones de monedas    
     Modificado:  Lic. René López Salinas    
   Fecha: 05-Septiembre-2005    
    
  Version 2.0      
       
   Procedimiento que genera la información para el vector de BANOBRAS    
     Modificado:  Lic. René López Salinas    
      Actualización de SP. para la migración de Eureka a Visual Basic    
   Fecha: 06-Mayo-2005    
    
  Version 1.0      
       
   Procedimiento que genera la información para el vector de BANOBRAS    
     Elaborado por :  Sergio García    
   Fecha: 21-Noviembre-2003    
*/      
    
    
 AS       
 BEGIN      
    
SELECT 'Proveedor' AS [Proveedor], 'Mercado' AS txtCNBVMarket, 'Fecha Vector' AS dteDate, ' TV'  AS txtTv, 'Emisora' AS txtEmisora,    
 'Serie' As txtSerie, 'Precio Sucio' AS dblPRS, 'Precio Limpio' AS dblPRL, 'Intereses' AS dblCPD, 'Tasa Descuento/Sobretasa' AS dblLDR,    
'DxV' AS dblDTM, 'Valor Nominal' AS txtNOM, 'Fecha Vencimiento' AS txtMTD, 'Fecha Emision' AS txtISD,    
'Moneda' AS txtCUR, 'Tasa Cupón' AS dblCPA, 'Periodo Cupón' AS txtTCT, 'Tipo Envio' AS [FLAG]    
UNION    
SELECT 'PIP' AS [Proveedor],    
 SUBSTRING (b.txtCNBVMarket,1,2) AS [Mercado],    
  CONVERT(CHAR(8),a.dteDate,112) AS [FechaVector],    
  a.txtTv AS [TV],    
  a.txtEmisora As [Emisora],    
  a.txtSerie AS [Serie],    
  CASE UPPER (a.txtLiquidation)    
   WHEN 'MP' THEN    
    STR(ROUND(a.dblPAV,6),13,6)    
   ELSE    
    STR(ROUND(a.dblPRS,6),13,6)    
   END AS [PrecioSucio],    
  CASE UPPER(a.txtLiquidation)    
   WHEN 'MP' THEN    
    STR(ROUND(a.dblPAV,6),13,6)    
   ELSE    
    STR(ROUND(a.dblPRL,6),13,6)    
   END AS [PrecioLimpio],    
  STR(ROUND(a.dblCPD,6),13,6) AS [Intereses],    
  STR(ROUND(a.dblLDR,6),13,6) AS [TasaDescuento],    
  STR(ROUND(a.dblDTM,6),13,6) AS [DiasXVencer],    
    
  CASE WHEN (a.txtNOM = '' OR a.txtNOM = 'NA'  OR a.txtNOM = '-' OR a.txtNOM IS NULL) THEN    
   ''    
  ELSE    
   a.txtNOM     
  END AS [ValorNominal],    
     
  CASE WHEN (a.txtMTD = '' OR a.txtMTD = 'NA'  OR a.txtMTD = '-' OR a.txtMTD IS NULL) THEN    
   ''    
  ELSE    
   SUBSTRING(a.txtMTD,1,4) + SUBSTRING(a.txtMTD,6,2) + SUBSTRING(a.txtMTD,9,2)    
  END  AS [FechaVencimiento],    
    
  CASE WHEN (a.txtISD = '' OR a.txtISD = 'NA'  OR a.txtISD = '-' OR a.txtISD IS NULL) THEN    
   ''    
  ELSE    
   SUBSTRING(a.txtISD,1,4) + SUBSTRING(a.txtISD,6,2) + SUBSTRING(a.txtISD,9,2)    
  END  AS [FechaEmision],    
    
  CASE WHEN (a.txtCUR<>'NA' AND a.txtCUR<>'-' AND a.txtCUR<>'') THEN     
     CASE WHEN (RTRIM(a.txtCUR)='MPS' OR RTRIM(a.txtCUR)='MXN' OR RTRIM(a.txtCUR)='[MPS] Peso Mexicano (MXN)') THEN '10'    
     WHEN (RTRIM(a.txtCUR)='UFXU' OR RTRIM(a.txtCUR)='DLL' OR RTRIM(a.txtCUR)='USD' OR RTRIM(a.txtCUR)='[USD] Dolar Americano (MXN)') THEN '20'    
     WHEN (RTRIM(a.txtCUR)='UDI' OR RTRIM(a.txtCUR)='MUD' OR RTRIM(a.txtCUR)='[UDI] Unidades de Inversion (MXN)') THEN '30'    
     WHEN (RTRIM(a.txtCUR)='EUR' OR RTRIM(a.txtCUR)='[EUR] Euro (MXN)') THEN '40'     
     WHEN (RTRIM(a.txtCUR)='JPY' OR RTRIM(a.txtCUR)='[JPY] Yen Japones (MXN)') THEN '50' ELSE '60'    
   END-- AS [Moneda],    
     ELSE '60' --AS [Moneda],    
  END AS [Moneda],    
    
--  a.txtCur  AS [Moneda],    
    
  STR(ROUND(a.dblCPA,6),13,6) AS [TasaCupon],    
    
  CASE WHEN (a.txtTCT = '' OR a.txtTCT = 'NA' OR a.txtTCT = '-' OR a.txtTCT IS NULL) THEN    
   ''    
  ELSE    
   a.txtTCT    
  END  AS [PeriodoCupon],    
    
  @txtFlag AS [FLAG]    
FROM tmp_tblUnifiedPricesReport AS a    
 INNER JOIN tblTvCatalog AS b ON a.txtTV = b.txtTv    
WHERE a.txtLiquidation IN (@txtLiquidation,'MP')    
AND a.txtTv NOT IN ('*D','*F','*R')    
ORDER BY txtTv,txtEmisora,txtSerie    
END    
RETURN 0    
    
  
-- para crear el vector promedio de BANOBRAS  
CREATE PROCEDURE dbo.sp_productos_BANOBRAS;2  
    @dteDate as varchar(10)  
as  
begin  
 SELECT   
 Convert(char(10),u.dtedate,103) AS FECHA,  
 u.txtTv,  
 u.txtEmisora,  
 u.txtSerie,  
 u.dblPRL AS PLimpio_MD,  
 u.dblPRS AS PSucio_MD,  
 u.dblDTM AS DiasxVencer_MD,  
 u.dblCPA AS CuponActual,  
 u2.dblPRL AS PLimpio_24H,  
 u2.dblPRS AS PSucio_24H,  
 u2.dblDTM AS DiasxVencer_24H,  
 CASE WHEN V.dblValue is Null THEN  
  u.dblPRS  
        ELSE  
  V.dblValue   
 END AS PSucioProm_MD,  
 CASE WHEN V2.dblValue is Null THEN  
  u2.dblPRS   
 ELSE  
  V2.dblValue   
 END AS PSucioProm_24H,  
 '25009' AS "Clave Proveedor"  
 FROM   
 tmp_tblUnifiedPricesReport AS u  
 INNER JOIN tmp_tblUnifiedPricesReport AS u2  
 ON   
  u.txtId1 = u2.txtId1  
        LEFT OUTER JOIN tblAverageVector as V  
        ON  
                U.txtTv = V.txtTv  
  AND u.txtEmisora = v.txtEmisora  
  AND u.txtSerie = v.txtSerie  
  AND v.txtLiquidation = u.txtLiquidation  
                AND v.dteDate = u.dteDate  
        LEFT OUTER JOIN tblAverageVector as V2  
        ON  
                U2.txtTv = V2.txtTv  
  AND u2.txtEmisora = v2.txtEmisora  
  AND u2.txtSerie = v2.txtSerie  
  AND v2.txtLiquidation = u2.txtLiquidation  
                AND v2.dteDate = u2.dteDate  
 WHERE  
 u.txtLiquidation = 'MD'  
 AND u2.txtLiquidation = '24H'  
 AND u.dteDate = @dteDate  
 ORDER BY   
 u.txtTv,  
 u.txtEmisora,  
 u.txtSerie  
  
END  
  
----------------------------------------------------------------------------------  
--   Autor:          Mike Ramirez  
--   Modificacion:  10:56 a.m. 2013-05-20  
--   Descripcion:     Modulo 3: Se agregan dos curvas al archivo BGA/BP y BGT/BP  
----------------------------------------------------------------------------------   
CREATE PROCEDURE dbo.sp_productos_BANOBRAS;3  
  @txtDate AS DATETIME  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
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
  SELECT 'Sheet1' AS [SheetName], 3 AS [Col],'Cetes IMPTO'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'CTI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 4 AS [Col],'Yield Bonos'  AS [Header],'CURVES' AS [Source],'MSG'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 5 AS [Col],'Ipabono'  AS [Header],'CURVES' AS [Source],'BPA'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION  
 
  SELECT 'Sheet1' AS [SheetName], 6 AS [Col],'Ipabono Trimestral'  AS [Header],'CURVES' AS [Source],'BPT'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 7 AS [Col],'Bonde 182'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'SE'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
  
  SELECT 'Sheet1' AS [SheetName], 8 AS [Col],'Bondes LT'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'LT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'0' AS [fLoad] UNION
  
  SELECT 'Sheet1' AS [SheetName], 9 AS [Col],'Brems'  AS [Header],'CURVES' AS [Source],'XA'    AS [Type],'XA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 10 AS [Col],'Yield Real'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 11 AS [Col],'Real'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'U%'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 12 AS [Col],'Real IMPTO'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'UUI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 13 AS [Col],'Pagares Udizados'  AS [Header],'CURVES' AS [Source],'PLU'    AS [Type],'P8'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 14 AS [Col],'Reporto Guber G1'  AS [Header],'CURVES' AS [Source],'RG1'    AS [Type],'G1'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 15 AS [Col],'Reporto Guber G1 IMPTO'  AS [Header],'CURVES' AS [Source],'RG1'    AS [Type],'G1I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 16 AS [Col],'Reporto Guber G2'  AS [Header],'CURVES' AS [Source],'RG2'    AS [Type],'G2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 17 AS [Col],'Reporto Guber G2 IMPTO'  AS [Header],'CURVES' AS [Source],'RG2'    AS [Type],'G2I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 18 AS [Col],'Reporto Guber G3'  AS [Header],'CURVES' AS [Source],'RG3'    AS [Type],'G3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 19 AS [Col],'Reporto Guber G3 IMPTO'  AS [Header],'CURVES' AS [Source],'RG3'    AS [Type],'G3I'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 20 AS [Col],'Reporto Bancario B1'  AS [Header],'CURVES' AS [Source],'RB1'    AS [Type],'B1'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 21 AS [Col],'Reporto Bancario B2'  AS [Header],'CURVES' AS [Source],'RB2'    AS [Type],'B2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 22 AS [Col],'Reporto Bancario B3'  AS [Header],'CURVES' AS [Source],'RB3'    AS [Type],'B3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 23 AS [Col],'Reporto Bancario B4'  AS [Header],'CURVES' AS [Source],'RB4'    AS [Type],'B4'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 24 AS [Col],'Bancario B1'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'3A'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 25 AS [Col],'Bancario B2'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'P8'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 26 AS [Col],'Bancario B3'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'PO'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 27 AS [Col],'Bancario B4'  AS [Header],'CURVES' AS [Source],'PLV'    AS [Type],'BIN'    AS [SubType],'-999'     AS [Range],'0.01'  AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNIO
N   
  SELECT 'Sheet1' AS [SheetName], 28 AS [Col],'Ums'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 29 AS [Col],'Cedes Dolarizados'  AS [Header],'CURVES' AS [Source],'CDE'    AS [Type],'USD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fL
oad] UNION   
  SELECT 'Sheet1' AS [SheetName], 30 AS [Col],'Calificacion A'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
 UNION   
  SELECT 'Sheet1' AS [SheetName], 31 AS [Col],'Calificacion AA'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A2'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 32 AS [Col],'Calificacion AAA'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'A3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 33 AS [Col],'Calificacion B'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'B0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
 UNION   
  SELECT 'Sheet1' AS [SheetName], 34 AS [Col],'Calificacion C'  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'C0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
 UNION   
  SELECT 'Sheet1' AS [SheetName], 35 AS [Col],'Calificacion D '  AS [Header],'CURVES' AS [Source],'CAL'    AS [Type],'D0'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 36 AS [Col],'Implicita Pesos'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CU'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 37 AS [Col],'Puntos Forward'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'PIP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad
] UNION   
  SELECT 'Sheet1' AS [SheetName], 38 AS [Col],'Tipo de Cambio Forward'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'LB'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS
 [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 39 AS [Col],'Fras Tiie'  AS [Header],'CURVES' AS [Source],'TDS'    AS [Type],'T28'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 40 AS [Col],'Descuento Irs'  AS [Header],'CURVES' AS [Source],'SWP'    AS [Type],'TI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] 
UNION   
  SELECT 'Sheet1' AS [SheetName], 41 AS [Col],'Treasuries'  AS [Header],'CURVES' AS [Source],'TSN'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 42 AS [Col],'Libor Yield'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'YLD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] U
NION   
  SELECT 'Sheet1' AS [SheetName], 43 AS [Col],'Libor'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'BL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 44 AS [Col],'Cross Currency ASK'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'VTA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 45 AS [Col],'Cross Currency BID'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'CPA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 46 AS [Col],'Cross Currency MID'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'MED'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 47 AS [Col],'Libor Canada'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] 
UNION   
  SELECT 'Sheet1' AS [SheetName], 48 AS [Col],'Libor Euro'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UN
ION   
  SELECT 'Sheet1' AS [SheetName], 49 AS [Col],'Libor Yen'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 50 AS [Col],'Libor Marco'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'DEM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] U
NION   
  SELECT 'Sheet1' AS [SheetName], 51 AS [Col],'Riesgo Mexico'  AS [Header],'CURVES' AS [Source],'SPD'    AS [Type],'PA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] 
UNION   
  SELECT 'Sheet1' AS [SheetName], 52 AS [Col],'Tipo de Cambio Forward (Base FIX)'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'FIX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFo
rmat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 53 AS [Col],'Implicita Pesos (Base FIX)'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CUX'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'
1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 54 AS [Col],'Ipabono Semestral'  AS [Header],'CURVES' AS [Source],'BPS'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 55 AS [Col],'Cross Currency Swap Udi/Libor'  AS [Header],'CURVES' AS [Source],'ULS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat
],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 56 AS [Col],'Libor Hong Kong'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'HKD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 57 AS [Col],'Implicita en Forward de Peso Colombiano'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'COP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 58 AS [Col],'Cetes Irs'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'IRS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNI
ON   
  SELECT 'Sheet1' AS [SheetName], 59 AS [Col],'Libor Australiana'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'AUD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fL
oad] UNION   
  SELECT 'Sheet1' AS [SheetName], 60 AS [Col],'Libor Franco Suizo'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'CHF'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 61 AS [Col],'Libor Londres'  AS [Header],'CURVES' AS [Source],'LIB'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad]
 UNION   
  SELECT 'Sheet1' AS [SheetName], 62 AS [Col],'Implicita en Forward de Real Brasilenio'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 63 AS [Col],'Bondes D'  AS [Header],'CURVES' AS [Source],'BDE'    AS [Type],'XA'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
   
  SELECT 'Sheet1' AS [SheetName], 64 AS [Col],'Cross Currency Swap Udi/TIIE'  AS [Header],'CURVES' AS [Source],'UDT'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat]
,'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 65 AS [Col],'Udi/TIIE tasa Swap'  AS [Header],'CURVES' AS [Source],'UDT'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [f
Load] UNION   
  SELECT 'Sheet1' AS [SheetName], 66 AS [Col],'Yield Bonos Neto'  AS [Header],'CURVES' AS [Source],'CET'    AS [Type],'YT'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoa
d] UNION   
  SELECT 'Sheet1' AS [SheetName], 67 AS [Col],'Euribor'  AS [Header],'CURVES' AS [Source],'EUR'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] UNION
   
  SELECT 'Sheet1' AS [SheetName], 68 AS [Col],'Implicita en Forward de Euro'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat]
,'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 69 AS [Col],'Implicita en Forward de Yen Japones'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [Data
Format],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 70 AS [Col],'Implicita en Forward de Dolar Canadiense'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS 
[DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 71 AS [Col],'Tipo de Cambio Forward Dolar Canadiense'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'CAD'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 72 AS [Col],'Tipo de Cambio Forward Euro'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],
'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 73 AS [Col],'Tipo de Cambio Forward MXP/EUR'  AS [Header],'CURVES' AS [Source],'FTM'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataForma
t],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 74 AS [Col],'Tipo de Cambio Forward Real Brasilenio'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'BRL'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [D
ataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 75 AS [Col],'Tipo de Cambio Forward Yen Japones'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataF
ormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 76 AS [Col],'Implicita en Forward de Libra Esterlina'  AS [Header],'CURVES' AS [Source],'FWD'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [
DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 77 AS [Col],'Tipo de Cambio Forward Libra Esterlina'  AS [Header],'CURVES' AS [Source],'FTC'    AS [Type],'GBP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [D
ataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 78 AS [Col],'Reporto UMS'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'REP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLoad] U
NION   
  SELECT 'Sheet1' AS [SheetName], 79 AS [Col],'Cross Currency Swap Libor USD/Euribor'  AS [Header],'CURVES' AS [Source],'LES'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [Da
taFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 80 AS [Col],'Cross Currency Swap Tiie/Euribor'  AS [Header],'CURVES' AS [Source],'ETS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFor
mat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 81 AS [Col],'Ums Zero 364/YTM'  AS [Header],'CURVES' AS [Source],'UMS'    AS [Type],'YUM'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [fLo
ad] UNION   
  SELECT 'Sheet1' AS [SheetName], 82 AS [Col],'Libor Yen Cupon Cero'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'JPY'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS 
[fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 83 AS [Col],'Libor Euro Cupon Cero'  AS [Header],'CURVES' AS [Source],'LBZ'    AS [Type],'EUR'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS
 [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 84 AS [Col],'Udi/Libor tasa Swap'  AS [Header],'CURVES' AS [Source],'ULS'    AS [Type],'SWP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [
fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 85 AS [Col],'Yield Real con Impuesto'  AS [Header],'CURVES' AS [Source],'UDB'    AS [Type],'YLI'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' 
AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 86 AS [Col],'Reporto Privados AAA'  AS [Header],'CURVES' AS [Source],'RPR'    AS [Type],'A3'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [
fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 87 AS [Col],'Cross Currency Swap TIIE/Libor Bid'  AS [Header],'CURVES' AS [Source],'LTS'    AS [Type],'CCB'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataF
ormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 88 AS [Col],'Cross Currency Swap Libor Yen/TIIE en yen'  AS [Header],'CURVES' AS [Source],'JTS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS
 [DataFormat],'1' AS [fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 89 AS [Col],'Cross Currency Swap Libor Yen/TIIE en peso'  AS [Header],'CURVES' AS [Source],'TJS'    AS [Type],'CCS'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           A
S [DataFormat],'1' AS [fLoad] UNION  
  SELECT 'Sheet1' AS [SheetName], 90 AS [Col],'Ipabono BPAG Mensual'  AS [Header],'CURVES' AS [Source],'BGA'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' AS [
fLoad] UNION   
  SELECT 'Sheet1' AS [SheetName], 91 AS [Col],'Ipabono BPAG Trimestral'  AS [Header],'CURVES' AS [Source],'BGT'    AS [Type],'BP'    AS [SubType],'-999'     AS [Range],'0.01'     AS [Factor], 'DBL' AS [DataType], '0.000000'           AS [DataFormat],'1' A
S [fLoad]  
  
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
  
 SET NOCOUNT OFF  
  
END  
  
--   Autor:          Lic. René López Salinas  
--   Creacion:  01:19 p.m. 2010-08-20  
--   Descripcion:     Modulo 4:Procedimiento que genera producto Banobrasflujosyyyymmdd.xls  
CREATE PROCEDURE dbo.sp_productos_BANOBRAS;4  
  @txtDate AS DATETIME  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 -- Tabla de Resultados   
 DECLARE @tblResults TABLE (  
   txtTv CHAR(4),  
   txtEmisora CHAR(7),  
   txtSerie CHAR(6),  
   txtFIQ VARCHAR(400),  
   txtDPQ VARCHAR(400),  
   txtSPQ VARCHAR(400),  
   txtHRQ VARCHAR(400),  
   txtCRL VARCHAR(400),  
   txtDCR VARCHAR(400),  
   intCashId INTEGER,  
   txtFIni VARCHAR(50),  
   txtFFin VARCHAR(50),  
   txtVigencia VARCHAR(50),  
   txtTasa VARCHAR(50),  
   txtNominal VARCHAR(50),  
   txtFlujo VARCHAR(50),  
   txtPlazo VARCHAR(50),  
   txtDescuento VARCHAR(50),  
   txtFactor VARCHAR(50),  
   txtFlujoDescontado VARCHAR(50)  
   PRIMARY KEY (txtTv,txtEmisora,txtSerie,intCashId)  
 )   
  
 INSERT INTO @tblResults (txtTv,txtEmisora,txtSerie,txtFIQ,txtDPQ,txtSPQ,txtHRQ,txtCRL,txtDCR,  
   intCashId,txtFIni,txtFFin,txtVigencia,txtTasa,txtNominal,txtFlujo,txtPlazo,txtDescuento,  
   txtFactor,txtFlujoDescontado)  
 SELECT    
   txtTv,txtEmisora,txtSerie,txtFIQ,txtDPQ,txtSPQ,txtHRQ,txtCRL,txtDCR,  
   cash.intCashId AS [ID],     
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',1), -- AS [Fecha Inicio],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',2), -- AS [Fecha Fin],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',3), -- AS [Vigencia],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',4), -- AS [Tasa],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',5), -- AS [Nominal],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',6), -- AS [Flujo],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',7), -- AS [Plazo],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',8), -- AS [Descuento],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',9), -- AS [Factor],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',10) -- AS [Flujo Descontado]  
 FROM MxFixIncome.dbo.tblDailyBondsCashFlows AS cash (NOLOCK)  
   INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS p (NOLOCK)  
    ON cash.txtId1 = p.txtId1 AND p.txtLiquidation = 'MD'  
 WHERE   
  p.dteDate = @txtDate  
  AND txtTv IN ('2','71','90','91','2P','2U')  
  
 -- Valida que la información este completa  
 IF ((SELECT COUNT(*) FROM @tblResults) <= 1)  
  
  BEGIN  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  END  
  
 ELSE  
  
  -- Reporto Información  
  SELECT    
    CONVERT(CHAR(8),@txtDate,112) AS [Fecha],  
    txtTv,  
    txtEmisora,  
    txtSerie,  
    RTRIM(txtFIQ),  
    RTRIM(txtDPQ),  
    RTRIM(txtSPQ),  
    RTRIM(txtHRQ),  
    RTRIM(txtCRL),  
    RTRIM(txtDCR),  
    LTRIM(STR(intCashId)),  
    RTRIM(txtFIni),  
    RTRIM(txtFFin),  
    RTRIM(txtVigencia),  
    RTRIM(txtTasa),  
    RTRIM(txtNominal),  
    RTRIM(txtFlujo),  
    RTRIM(txtPlazo),  
    RTRIM(txtDescuento),  
    RTRIM(txtFactor),  
    RTRIM(txtFlujoDescontado)  
  FROM @tblResults  
  
 SET NOCOUNT OFF  
  
END  
  
--   Autor:          Lic. René López Salinas  
--   Creacion:  12:38 p.m. 2010-09-07  
--   Descripcion:     Modulo 5:Procedimiento que genera producto Banobrasflujosyyyymmdd_2.xls  
CREATE PROCEDURE dbo.sp_productos_BANOBRAS;5  
  @txtDate AS DATETIME  
  
AS   
BEGIN  
  
 SET NOCOUNT ON   
  
 -- Tabla de Resultados   
 DECLARE @tblResults TABLE (  
   txtTv CHAR(4),  
   txtEmisora CHAR(7),  
   txtSerie CHAR(6),  
   txtFIQ VARCHAR(400),  
   txtDPQ VARCHAR(400),  
   txtSPQ VARCHAR(400),  
   txtHRQ VARCHAR(400),  
   txtCRL VARCHAR(400),  
   txtDCR VARCHAR(400),  
   intCashId INTEGER,  
   txtFIni VARCHAR(50),  
   txtFFin VARCHAR(50),  
   txtVigencia VARCHAR(50),  
   txtTasa VARCHAR(50),  
   txtNominal VARCHAR(50),  
   txtFlujo VARCHAR(50),  
   txtPlazo VARCHAR(50),  
   txtDescuento VARCHAR(50),  
   txtFactor VARCHAR(50),  
   txtFlujoDescontado VARCHAR(50)  
   PRIMARY KEY (txtTv,txtEmisora,txtSerie,intCashId)  
 )   
  
 INSERT INTO @tblResults (txtTv,txtEmisora,txtSerie,txtFIQ,txtDPQ,txtSPQ,txtHRQ,txtCRL,txtDCR,  
   intCashId,txtFIni,txtFFin,txtVigencia,txtTasa,txtNominal,txtFlujo,txtPlazo,txtDescuento,  
   txtFactor,txtFlujoDescontado)  
 SELECT    
   txtTv,txtEmisora,txtSerie,txtFIQ,txtDPQ,txtSPQ,txtHRQ,txtCRL,txtDCR,  
   cash.intCashId AS [ID],     
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',1), -- AS [Fecha Inicio],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',2), -- AS [Fecha Fin],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',3), -- AS [Vigencia],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',4), -- AS [Tasa],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',5), -- AS [Nominal],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',6), -- AS [Flujo],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',7), -- AS [Plazo],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',8), -- AS [Descuento],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',9), -- AS [Factor],  
   MxFixIncome.dbo.fun_Split(cash.txtCashFlow,'|',10) -- AS [Flujo Descontado]  
 FROM MxFixIncome.dbo.tblDailyBondsCashFlows AS cash (NOLOCK)  
   INNER JOIN MxFixIncome.dbo.tmp_tblUnifiedPricesReport AS p (NOLOCK)  
    ON cash.txtId1 = p.txtId1 AND p.txtLiquidation = 'MD'  
 WHERE   
  p.dteDate = @txtDate  
  AND txtTv IN ('94','95','97','Q','R1')  
  
 -- Valida que la información este completa  
 IF ((SELECT COUNT(*) FROM @tblResults) <= 1)  
  
  BEGIN  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  END  
  
 ELSE  
  
  -- Reporto Información  
  SELECT    
    CONVERT(CHAR(8),@txtDate,112) AS [Fecha],  
    txtTv,  
    txtEmisora,  
    txtSerie,  
    RTRIM(txtFIQ),  
    RTRIM(txtDPQ),  
    RTRIM(txtSPQ),  
    RTRIM(txtHRQ),  
    RTRIM(txtCRL),  
    RTRIM(txtDCR),  
    LTRIM(STR(intCashId)),  
    RTRIM(txtFIni),  
    RTRIM(txtFFin),  
    RTRIM(txtVigencia),  
    RTRIM(txtTasa),  
    RTRIM(txtNominal),  
    RTRIM(txtFlujo),  
    RTRIM(txtPlazo),  
    RTRIM(txtDescuento),  
    RTRIM(txtFactor),  
    RTRIM(txtFlujoDescontado)  
  FROM @tblResults  
  
 SET NOCOUNT OFF  
  
END  
  