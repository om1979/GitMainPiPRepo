
------------------------------------------------------------------------------  
/* Autor:  OMAR ADRIAN ACEVES GUTIERREZ  
 Fecha:  2014-06-18 14:06:35.657  
 Objetivo: GENERAR COVAF_MANDATOS_MSCI_WORLD_PIP  
  
 Autor:      Mike Ramirez  
 Fecha Modificiacion:  2014-07-14 11:06:35.657  
 Descripción:    Se agrega un nuevo caso para la columna región  
 
 -- Modifica:        Omar Adrian Aceves Gutierrez 
-- Fecha Creacion:  2014-10-30 12:09:00.253  
-- Descripcion Modulo 21: se agrega validacion para poner razon social en mayusculas/ sin acentos/ ni apostrofes  
*/  
------------------------------------------------------------------------------   
ALTER  PROCEDURE [dbo].[usp_productos_PiPGenericos];21 
 --DECLARE 
 @txtDate AS DATETIME -- = '20141030'  
  
AS   
BEGIN  
SET NOCOUNT ON  
  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](8),  
     [txtId1][CHAR](11),  
    [txtTv][CHAR](4),  
    [txtEmisora][CHAR](7),  
    [txtSerie][CHAR](6),  
    [dblPMO][FLOAT],  
    [dblPMOP][FLOAT],  
    [txtCurrency][CHAR](7),  
    [txtCountry][CHAR](2),  
    [txtIndex][CHAR](7),  
    [dblPOR][FLOAT],  
    [txtID2][CHAR](12),  
    [txtSector][CHAR](6),  
    [txtSubSector][CHAR](6),  
    [txtRamo][CHAR](6),  
    [txtSubRamo][CHAR](6),  
    [txtBCT][VARCHAR](25),  
    [txtVCT][VARCHAR](25),  
    [txtID7][VARCHAR](25),  
    [txtID6][VARCHAR](25),  
    [txtID3][VARCHAR](9),  
    [txtID4][VARCHAR](7),  
    [txtRZ][VARCHAR](80)  
   PRIMARY KEY(txtId1)  
   )  
  
  -- Tabla universo portafolio  
  DECLARE @tmp_tblUniversoIndex TABLE (  
    [dteDate][DATETIME],      
    [txtIndex][CHAR](7),     
    [txtId1][CHAR](11),  
    [dblCount][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- Tablas temporales para agilizar calculo  
  DECLARE @tmp_tblKeysEquityPricesMAXdate TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblKeysEquityPricesMAXtime TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPrices TABLE (  
    [txtId1][CHAR](11),  
    [dlbPrice][FLOAT]  
   PRIMARY KEY(txtId1)  
  )  
  
  DECLARE @tmp_tblEquityPricesInd TABLE (  
    [txtId1][CHAR](11),  
    [dteTime][DATETIME],  
    [dteDate][DATETIME],  
    [dblPrice][FLOAT]  
   PRIMARY KEY(txtId1,dteTime,dteDate)  
  )  
  
  DECLARE @tmp_tblKEYsCurrency TABLE (  
    [txtId1][CHAR](11),  
    [txtCurrency][CHAR](6)  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Countries  
  DECLARE @tmp_tblKEYsCountries TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Bloomberg  
  DECLARE @tmp_tblKEYsBloomberg TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys Reuters  
  DECLARE @tmp_tblKEYsReuters TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys CUSIP  
  DECLARE @tmp_tblKEYsCUSIP TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla temporal de Keys SEDOL  
  DECLARE @tmp_tblKEYsSEDOL TABLE (  
    [txtId1][CHAR](11),  
    [dteDate][DATETIME]  
   PRIMARY KEY(txtId1)  
  )  
  
  -- creo tabla para la ponderacion de los indices  
  DECLARE @tmp_tblPond TABLE (    
   txtIndex CHAR(10),  
   dblPond FLOAT  
   PRIMARY KEY (txtIndex)  
  )  
  
  -- Tablas llave para obtener y consolidar maximos del item subRamo  
  DECLARE @tmp_tblKeyIssuerMaxSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
   
  -- Tablas llave para obtener y consolidar maximos del item Ramo  
  DECLARE @tmp_tblKeyIssuerMaxRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerRamo TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [intSector][CHAR](6)      
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para obtener y consolidar maximos del item SubSector  
  DECLARE @tmp_tblKeyIssuerMaxSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerValSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)   
   PRIMARY KEY (dteDate,txtIssuer)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSubSector TABLE (  
    [dteDate][DATETIME],  
    [txtIssuer][VARCHAR](10),  
    [txtValue][VARCHAR](50)  
   PRIMARY KEY (txtIssuer,dteDate,txtValue)  
   )  
  
  -- Tablas llave para consolidar los máximos para txtBCT  
  DECLARE @tmp_tblKeyItemMDO TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME],  
    [txtValue][VARCHAR](50)            
   PRIMARY KEY (txtID1)  
   )  
  
  -- Tablas llave para consolidar los máximos Date  
  DECLARE @tmp_tblKeyItemMDODate TABLE (  
    [txtID1][VARCHAR](11),  
    [dteDate][DATETIME]       
   PRIMARY KEY (txtID1)  
   )  
  
  -- Creo tabla para obtener los maximos de los IRC  
  DECLARE @tmp_tblTCMax TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME]  
   PRIMARY KEY (txtIRC)  
    )  
  -- Creo tabla para consolidar los IRC  
  DECLARE @tmp_tblTC TABLE (  
    [txtIRC][CHAR](7),  
    [dteDate][DATETIME],  
    [dblValue][FLOAT]    
   PRIMARY KEY (txtIRC,dteDate)  
    )  
  
  -- Obtenemos las fechas maximas de los IRC  
  INSERT @tmp_tblTCMax (txtIRC,dteDate)  
   SELECT   
    txtIRC,  
    MAX(dteDate)   
    FROM MxFixIncome.dbo.tblIRC (NOLOCK)  
    WHERE txtIRC IN ('AUD',      
        'CAD',      
        'CHF',      
        'DKK',      
        'EUR',      
        'GBP',      
        'HKD',      
        'ILS',      
        'JPY',      
        'NOK',      
        'NZD',      
        'SEK',      
        'SGD',  
        'UFXU')     
    GROUP BY txtIRC   
  
  -- Consolidamos los TC  
  INSERT @tmp_tblTC (txtIRC,dteDate,dblValue)  
   SELECT   
     m.txtIRC,  
     m.dteDate,  
     i.dblValue  
   FROM @tmp_tblTCMax AS m  
    INNER JOIN MxFixIncome.dbo.tblIRC AS i (NOLOCK)  
     ON m.txtIRC = i.txtIRC  
     AND m.dteDate = i.dteDate  
  
  -- Construir universo  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCI'   
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI' AND dteDate <= @txtDate)   
  
  INSERT @tmp_tblUniversoIndex (dteDate,txtIndex,txtId1,dblCount)  
   SELECT  
    dteDate,  
    txtIndex,   
    txtid1,  
    dblCount  
   FROM MxFixIncome.dbo.tblIndexesPortfolios (NOLOCK)  
   WHERE txtIndex = 'MSCIPIP'  
      AND dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP' AND dteDate <= @txtDate)  
  
  -- Obtenego y consolido maximos del item subRamo  
  INSERT @tmp_tblKeyIssuerMaxSubRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubRamo'  
  
  INSERT @tmp_tblKeyIssuerSubRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue   
   FROM @tmp_tblKeyIssuerMaxSubRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item Ramo  
  INSERT @tmp_tblKeyIssuerMaxRamo (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValRamo (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'Ramo'  
   
  INSERT @tmp_tblKeyIssuerRamo (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxRamo AS p  
    INNER JOIN @tmp_tblKeyIssuerValRamo AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeyIssuerSector (txtId1,intSector)  
   SELECT  
    p.txtId1,  
    o.intSector  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
  
  -- Obtenego y consolido maximos del item SubSector  
  INSERT @tmp_tblKeyIssuerMaxSubSector (dteDate,txtIssuer)  
   SELECT   
    MAX(dteDate),  
    txtIssuer   
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
   GROUP BY txtIssuer  
  
  INSERT @tmp_tblKeyIssuerValSubSector (dteDate,txtIssuer,txtValue)  
   SELECT  
    dteDate,   
    txtIssuer,  
    txtValue  
   FROM MxFixincome.dbo.tblIssuersAdd (NOLOCK)  
   WHERE txtItem = 'SubSector'  
  
  INSERT @tmp_tblKeyIssuerSubSector (dteDate,txtIssuer,txtValue)  
   SELECT   
    p.dteDate,  
    p.txtIssuer,  
    o.txtValue  
   FROM @tmp_tblKeyIssuerMaxSubSector AS p  
    INNER JOIN @tmp_tblKeyIssuerValSubSector AS o  
     ON p.dtedate = o.dtedate  
     AND p.txtIssuer = o.txtIssuer  
  
  INSERT @tmp_tblKeysEquityPricesMAXdate (txtId1,dteDate)  
   SELECT   
    e.txtId1,  
    MAX(e.dteDate)  
   FROM @tmp_tblUniversoIndex AS ui     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)     ON ui.txtId1 = e.txtId1    WHERE  
    e.txtOperationCode = 'S01'  
    AND e.txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
  INSERT @tmp_tblKeysEquityPricesMAXtime (txtId1,dteTime)  
   SELECT   
    e.txtId1,  
    MAX(e.dteTime)  
   FROM MxFixIncome.dbo.tblEquityPrices AS e (NOLOCK)       INNER JOIN @tmp_tblKeysEquityPricesMAXdate AS K       ON e.txtId1 = k.txtId1 AND e.dteDate = k.dteDate     WHERE  
    txtOperationCode = 'S01'  
    AND txtSource NOT IN ('GAF','COVAF')  
   GROUP BY e.txtId1  
  
   INSERT @tmp_tblEquityPricesInd (txtId1,dteTime,dteDate,dblprice)  
   SELECT  
    ed.txtId1,  
    et.dteTime,  
    ed.dteDate,  
    ep.dblprice  
   FROM @tmp_tblKeysEquityPricesMAXdate AS ed  
    INNER JOIN @tmp_tblKeysEquityPricesMAXtime AS et  
     ON ed.txtId1 = et.txtId1  
     INNER JOIN MxFixIncome.dbo.tblEquityPrices AS ep (NOLOCK)  
      ON ed.txtId1 = ep.txtId1  
      AND et.dteTime = ep.dteTime  
      AND ed.dtedate = ep.dtedate  
   
  -- Llaves para obtener los tipos de cambio  
  INSERT @tmp_tblKEYsCurrency (txtid1,txtCurrency)  
   SELECT   
    txtid1,  
    txtCurrency  
   FROM MxFixIncome.dbo.tblEquity (NOLOCK)  
  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDODate (txtId1,dteDate)  
   SELECT  
    txtId1,  
    MAX(dteDate)  
   FROM MxFixIncome.dbo.tblEquityAdd (NOLOCK)  
   WHERE txtItem = 'MDO'   
   GROUP BY txtId1  
  
  -- Llaves para obtener los maximos MDO  
  INSERT @tmp_tblKeyItemMDO (txtId1,dteDate,txtValue)  
   SELECT  
    i.txtId1,  
    i.dteDate,  
    e.txtValue  
   FROM MxFixIncome.dbo.tblEquityAdd AS e (NOLOCK)  
    INNER JOIN @tmp_tblKeyItemMDODate AS i  
     ON e.txtId1 = i.txtId1  
     AND e.dteDate = i.dteDate  
   WHERE e.txtItem = 'MDO'  
   
  -- Consolido la informacion  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
     pr.txtId1 AS [ID1],  
    pr.txtTv AS [TV],  
    pr.txtEmisora AS [Emisora],  
    pr.txtSerie AS [Serie],  
    e.dblPrice AS [Precio MO],  
    NULL AS [Precio MO Peso],  
    ep.txtCurrency AS [MO],  
    NULL AS [Country],  
    CASE WHEN ip.txtIndex = 'URTH' THEN 'MSCI' ELSE ip.txtIndex END AS [Indexes],  
    ip.dblCount AS [POR],  
    pr.txtID2 AS [ID2],  
    o.intSector AS [Sector],  
    os.txtValue AS [SubSector],  
    ra.txtValue AS [Ramo],  
    sra.txtValue AS [SubRamo],  
    NULL AS [Bolsa Cotizacion],  
    ip.dblCount AS [Valores en Cartera],  
    NULL AS [Bloomberg],  
    NULL AS [Reuters],  
    NULL AS [CUSIP],  
    NULL AS [SEDOL],  
    SUBSTRING(REPLACE(REPLACE(REPLACE (REPLACE (REPLACE( ic.txtName, char(218),'U'),char(211),'O'),char(205),'I' ),char(193),'A'),char(201),'E'),0,80) AS [Razon Social]  
   FROM @tmp_tblUniversoIndex AS ip  
     INNER JOIN MxFixIncome.dbo.tblIds AS pr (NOLOCK)  
      ON ip.txtId1 = pr.txtId1  
       LEFT OUTER JOIN @tmp_tblEquityPricesInd AS e  
       ON ip.txtId1 = e.txtId1  
        LEFT OUTER JOIN @tmp_tblKEYsCurrency AS ep  
        ON ip.txtId1 = ep.txtId1  
         LEFT OUTER JOIN @tmp_tblKeyIssuerSector AS o  
         ON pr.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector AS os  
          ON pr.txtEmisora = os.txtIssuer  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo AS ra  
           ON pr.txtEmisora = ra.txtIssuer  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo AS sra  
            ON pr.txtEmisora = sra.txtIssuer  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer  
   ORDER BY pr.txtTv,pr.txtEmisora,pr.txtSerie  
  -- En campo dblPMOP multiplico por su TC  
  UPDATE u  
   SET dblPMOP = (u.dblPMO * (MxFixIncome.dbo.fun_get_prices_IRC(CONVERT(CHAR(8),@txtDate,112),u.txtCurrency)))  
  FROM  
   @tmp_tblResultsVector AS u  
  
  UPDATE rv SET dblPMOP = 0   
  FROM @tmp_tblResultsVector AS rv  
  WHERE rv.dblPMOP IS NULL   
  
  -- Cargo la ponderacion del indice a calcular  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCI')   
   AND l.txtIndex = 'MSCI'   
  GROUP BY l.txtIndex  
  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP')   
   AND l.txtIndex = 'MSCIPIP'   
  GROUP BY l.txtIndex  
  
--  -- Para el calculo de Porcentaje  
--  UPDATE u  
--   SET u.dblPOR = ((ui.dblCount * u.dblPMOP) / p.dblPond)  
--  FROM  
--   @tmp_tblResultsVector AS u  
--    INNER JOIN @tmp_tblUniversoIndex AS ui  
--     ON u.txtId1 = ui.txtId1  
--      INNER JOIN @tmp_tblPond AS p  
--       ON ui.txtIndex = p.txtIndex  
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')   
  
  -- BEG: Optimización Query: Info COUNTRY  
  INSERT @tmp_tblKEYsCountries (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
  FROM @tmp_tblResultsVector AS tac  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
    ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'COUNTRY'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del campo  
  UPDATE tac   
   SET txtCountry = CONVERT(CHAR(2),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCountries AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'COUNTRY'  
  -- END: Optimización Query: Info COUNTRY  
  
  -- BEG: Optimización Query: Info Bloomberg  
  INSERT @tmp_tblKEYsBloomberg  (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
      AND txtItem = 'ID7'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID7 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsBloomberg AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID7'  
  -- END: Optimización Query: Info Bloomberg  
  
  -- BEG: Optimización Query: Info Reuters  
  INSERT @tmp_tblKEYsReuters (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID6'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID6 = CONVERT(CHAR(25),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsReuters AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID6'  
  -- END: Optimización Query: Info Reuters  
  
  -- BEG: Optimización Query: Info CUSIP  
  INSERT @tmp_tblKEYsCUSIP (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd AS tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID3'  
  GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID3 = CONVERT(CHAR(9),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsCUSIP AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID3'  
  -- END: Optimización Query: Info CUSIP  
  
  -- BEG: Optimización Query: Info SEDOL  
  INSERT @tmp_tblKEYsSEDOL (txtId1,dteDate)  
   SELECT   
    tadd.txtId1,  
    MAX(tadd.dteDate)  
   FROM @tmp_tblResultsVector AS tac  
    INNER JOIN MxFixIncome.dbo.tblIdsAdd tadd (NOLOCK)  
     ON tac.txtId1 = tadd.txtId1  
     AND txtItem = 'ID4'  
   GROUP BY tadd.txtId1  
  
  -- Obtengo el codigo del Item  
  UPDATE tac   
   SET txtID4 = CONVERT(CHAR(7),i.txtValue)  
  FROM   
   @tmp_tblResultsVector AS tac  
   INNER JOIN @tmp_tblKEYsSEDOL AS tkc  
    ON tac.txtId1 = tkc.txtId1  
   INNER JOIN MxFixIncome.dbo.tblIdsAdd AS i (NOLOCK)   
    ON i.txtId1 = tkc.txtId1   
     AND i.dteDate = tkc.dteDate  
     AND i.txtItem = 'ID4'  
  -- END: Optimización Query: Info SEDOL  
  
  -- Obtengo el codigo del Item MDO  
  UPDATE rv   
   SET txtBCT = tkm.txtValue  
  FROM   
   @tmp_tblResultsVector AS rv  
   INNER JOIN @tmp_tblKeyItemMDO AS tkm  
    ON rv.txtId1 = tkm.txtId1  
      
      
      
    /*informacion para conseguir txtSuperIssuer de tblIssuerscatalog */  
     DECLARE @tblUnifiedIssuer TABLE  
  (  
  txtid1 varchar(11),  
  txtSuperIssuer varchar(15)  
  )  
  INSERT INTO @tblUnifiedIssuer  
   SELECT a.txtId1,c.txtSuperIssuer   
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblIssuerscatalog  AS C  
   ON a.txtEmisora = c.txtIssuer  
  
      
  
   -- Valida que la información este completa  
   IF EXISTS (  
     SELECT TOP 1 *   
     FROM @tmp_tblResultsVector  
      )  
  
    BEGIN  
  
     -- Reporto Informacion  
     SELECT   
      CONVERT(CHAR(8),@txtDate,112) +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtTv))) < 4 THEN  
        RTRIM(LTRIM(txtTv)) + SUBSTRING('    ',1,4-LEN(RTRIM(LTRIM(txtTv))))  
       ELSE  
        RTRIM(LTRIM(txtTv))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtEmisora))) < 7 THEN  
        RTRIM(LTRIM(txtEmisora)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtEmisora))))  
       ELSE  
        RTRIM(LTRIM(txtEmisora))  
      END +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtSerie))) < 6 THEN  
        RTRIM(LTRIM(txtSerie)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtSerie))))  
       ELSE  
        RTRIM(LTRIM(txtSerie))  
      END +  
  
      CASE   
       WHEN dblPMO IS NULL  
        THEN '000000000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMO,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMO,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN dblPMOP IS NULL  
        THEN '000000000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPMOP,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblPMOP,6),16,6),11,16)  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCurrency))) < 3 THEN  
        '*******'  
       ELSE  
        RTRIM(LTRIM(txtCurrency))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtCountry))) < 2 THEN  
        RTRIM(LTRIM(txtCountry)) + SUBSTRING('  ',1,2-LEN(RTRIM(LTRIM(txtCountry))))  
       ELSE  
        RTRIM(LTRIM(txtCountry))  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIndex))) < 7 THEN  
        RTRIM(LTRIM(txtIndex)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtIndex))))  
       ELSE  
        RTRIM(LTRIM(txtIndex))  
      END +  
  
      CASE   
       WHEN dblPOR IS NULL  
        THEN '0000000000'   
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(dblPOR,6),11,6),' ','0'),1,4) + SUBSTRING(STR(ROUND(dblPOR,6),11,6),6,11)  
      END +  
  
      RTRIM(txtID2) +  
  
      CASE   
       WHEN txtSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubSector IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubSector,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtSubRamo IS NULL  
        THEN '000000'  
       ELSE  
        REPLACE(STR(txtSubRamo,6),' ','0')  
      END +  
  
      CASE   
       WHEN txtBCT IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtBCT)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtBCT))))  
      END +  
  
      CASE   
       WHEN txtVCT IS NULL  
        THEN '0000000000'  
       ELSE  
        SUBSTRING(REPLACE(STR(ROUND(txtVCT,2),11,2),' ','0'),1,8) + SUBSTRING(STR(ROUND(txtVCT,2),11,2),10,11)  
      END +  
  
      CASE   
       WHEN txtID7 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID7)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID7))))  
      END +  
  
      CASE   
       WHEN txtID6 IS NULL THEN '                         '  
       ELSE  
        RTRIM(LTRIM(txtID6)) + SUBSTRING('                         ',1,25-LEN(RTRIM(LTRIM(txtID6))))  
      END +  
  
      CASE   
       WHEN txtID3 IS NULL THEN '         '  
       ELSE  
        RTRIM(LTRIM(txtID3)) + SUBSTRING('         ',1,9-LEN(RTRIM(LTRIM(txtID3))))  
      END +  
  
      CASE   
       WHEN txtID4 IS NULL THEN '       '  
       ELSE  
        RTRIM(LTRIM(txtID4)) + SUBSTRING('       ',1,7-LEN(RTRIM(LTRIM(txtID4))))  
      END +   
  
        CASE   
       WHEN txtRZ IS NULL  
        THEN '                                                                                '  
       ELSE  
        RTRIM(LTRIM( REPLACE(REPLACE(UPPER(txtRZ),'Ñ','ALT+0209'),''+CHAR(39)+'' ,''))) + SUBSTRING('                                                                               ',1,80-LEN(RTRIM(LTRIM( REPLACE(REPLACE(UPPER(txtRZ),'Ñ','ALT+0209'),''+CHAR(39)+'' ,'')))     ))  
      END+ 
     
     
    CASE WHEN  LTRIM(LTRIM(B.CurCountry)) is NULL OR LTRIM(LTRIM(B.CurCountry)) = ''   THEN '000'   
    ELSE LTRIM(RTRIM(B.CurCountry)) END +  
    CASE WHEN  LTRIM(LTRIM(B.countryHQ)) is NULL  OR LTRIM(LTRIM(B.countryHQ)) = '' THEN '00' ELSE LTRIM(RTRIM(B.countryHQ))    
    END   
      
     
    +   
      
    RTRIM( LTRIM(  
   CASE WHEN B.CountryHQ IN ('GB','GG','JE') THEN '007'  
    WHEN B.CountryHQ IN ('BM','KY') THEN '011'  
    WHEN B.CountryHQ IN ('GR','HU','PL','CZ','RU','CZ','RU') THEN '004'  
    WHEN B.CountryHQ IN ('JP') THEN '008'  
    WHEN B.CountryHQ IN ('CA') THEN '009'  
    WHEN B.CountryHQ IN ('MX') THEN '001'  
    WHEN B.CountryHQ IN ('AL','GR','DE','HU',  
    'AD','IE','AM','IS','AT','IT','BE','LU',  
    'BY','LV','BA','MK','BG','MT','CY','MD',  
    'HR','MC','DK','ME','EE','NO','FI','NL',  
    'FR','PL','SK','PT','SI','CZ','ES','RO',  
    'GE','RU','GI','SM','RS','SE','CH','UA') THEN '002'  
    WHEN B.CountryHQ IN (  
    'AF','JO','AO','KE','SA','MG','DZ','ML',  
    'BJ','MA','BW','MU','CM','MZ','BF','NA',  
    'CG','PS','CD','QA','CI','RW','EG','EH',  
    'ET','SN','GA','ZA','GM','SD','AE','SS',  
    'GH','TN','IQ','UG','IR','ZM','IL','ZW')THEN '010'  
    WHEN B.CountryHQ IN (  
    'AU','SG','BD','BH','AZ','BN','KH',  
    'CN','KR','KP','PH','FJ','HK',  
    'IN','ID','KZ','KW','LA','MO',  
    'MY','MN','MM','NP','NE','NG',  
    'NZ','PK','WS','AS','LK','SR',  
    'TH','TW','TZ','TJ','TR','UZ') THEN '003'  
      
    WHEN B.CountryHQ IN ('US') THEN '005'  
      
    ELSE  '000'  
   END ))  
     
     
   +  LTRIM(ISNULL(c.txtSuperIssuer,''))  
     +   CONVERT(VARCHAR(100),REPLICATE(' ',( 50 - LEN(ISNULL(REPLACE(UPPER(c.txtSuperIssuer),'Ñ','ALT+0209'),'')))))  
   
     
     
    
     
     FROM @tmp_tblResultsVector AS A  
    LEFT OUTER JOIN  tblMandate  as B  
    ON a.txtid1 = b.txtid1  
    LEFT OUTER JOIN @tblUnifiedIssuer AS C  
    ON a.txtid1 = c.txtid1  
   
    /*uniod irc´s*/  
      
     UNION  
  
     -- Agregamos TC  
     SELECT  
      CONVERT(CHAR(8),@txtDate,112)+  
   
      '*C  ' +    
      'MXP' +  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 4 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('       ',1,4-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'USD ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      CASE   
       WHEN LEN(RTRIM(LTRIM(txtIRC))) < 6 THEN  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) + SUBSTRING('      ',1,6-LEN(RTRIM(LTRIM(txtIRC)))) END  
       ELSE  
        CASE WHEN txtIRC = 'UFXU' THEN 'FIX   ' ELSE RTRIM(LTRIM(txtIRC)) END  
      END +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
  
      SUBSTRING(REPLACE(STR(ROUND(dblValue,6),16,6),' ','0'),1,9) + SUBSTRING(STR(ROUND(dblValue,6),16,6),11,16) +  
    
      '000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'   
  
--Medio Oriente - Norte de África + 15  
    FROM @tmp_tblTC   
  
    END  
  
   ELSE  
     RAISERROR ('ERROR: Falta Informacion', 16, 1)  
  
SET NOCOUNT OFF  
END  
  