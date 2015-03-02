

--------------------------------------------------------------------------   
-- Autor:     OMAR ADRIAN ACEVES       
-- Fecha Creacion:   2014-06-18 14:13:32.437    
-- Descripcion Modulo 22:   CREAR PROCESO PARA COVAF_MANDATOS_MSCI_WORLD_XLS   
  
--Autor:     Mike Ramirez  
--Fecha Modificiacion:  2014-07-14 11:05:35.657  
--Descripción:    Se agrega un nuevo caso para la columna región  

-- Modifica:        Omar Adrian Aceves Gutierrez 
-- Fecha Creacion:  2014-10-30 12:09:00.253  
-- Descripcion Modulo 22: se agrega validacion para poner razon social en mayusculas/ sin acentos/ ni apostrofes  
--------------------------------------------------------------------------   
ALTER   PROCEDURE [dbo].[usp_productos_PiPGenericos];22  
  --DECLARE  
    @txtDate AS DATETIME  
   --= '20141023'  
AS   
BEGIN  
  
  SET NOCOUNT ON  
  
  -- Tabla de Resultados  
  DECLARE @tmp_tblResultsVector TABLE (  
    [dteDate][CHAR](10),  
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
    [txtSector][VARCHAR](150),  
    [txtSubSector][VARCHAR](150),  
    [txtRamo][VARCHAR](150),  
    [txtSubRamo][VARCHAR](150),  
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
   
  DECLARE @tmp_tblKeyIssuerSubRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
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
  
  DECLARE @tmp_tblKeyIssuerRamo_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
   )  
  
  DECLARE @tmp_tblKeyIssuerSector TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
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
  
  DECLARE @tmp_tblKeyIssuerSubSector_1 TABLE (  
    [txtID1][VARCHAR](11),  
    [txtDescription][VARCHAR](150)      
   PRIMARY KEY (txtID1)  
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
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerSubRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubRamo  
  
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
  
  -- Ramo  
  INSERT @tmp_tblKeyIssuerRamo_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerRamo AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVRamoCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intRamo  
   
  INSERT @tmp_tblKeyIssuerSector (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN MxFixIncome.dbo.tblIssuersCatalog AS o (NOLOCK)  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSectorCatalog AS i (NOLOCK)  
        ON o.intSector = i.intSector  
  
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
  
  -- Subsector  
  INSERT @tmp_tblKeyIssuerSubSector_1 (txtId1,txtDescription)  
   SELECT  
    p.txtId1,  
    i.txtDescription  
   FROM @tmp_tblUniversoIndex AS ui  
    INNER JOIN MxFixIncome.dbo.tblids AS p (NOLOCK)  
      ON ui.txtId1 = p.txtId1  
     INNER JOIN @tmp_tblKeyIssuerSubSector AS o  
      ON p.txtEmisora = o.txtIssuer  
       INNER JOIN MxFixIncome.dbo.tblBMVSubSectorCatalog AS i (NOLOCK)  
        ON o.txtValue = i.intSubSector  
   
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
    o.txtDescription AS [Sector],  
    os.txtDescription AS [SubSector],  
    ra.txtDescription AS [Ramo],  
    sra.txtDescription AS [SubRamo],  
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
         ON ip.txtId1 = o.txtId1  
          LEFT OUTER JOIN @tmp_tblKeyIssuerSubSector_1 AS os  
          ON pr.txtId1 = os.txtId1  
           LEFT OUTER JOIN @tmp_tblKeyIssuerRamo_1 AS ra  
           ON pr.txtId1 = ra.txtId1  
            LEFT OUTER JOIN @tmp_tblKeyIssuerSubRamo_1 AS sra  
            ON pr.txtId1 = sra.txtId1  
             LEFT OUTER JOIN MxFixIncome.dbo.tblissuerscatalog AS ic  
             ON pr.txtEmisora = ic.txtIssuer   
   
  
  -- Obtenemos el campo dblPMOP multiplico por su TC  
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
   AND l.txtIndex = 'MSCI'--,'MSCIPIP')  
  GROUP BY l.txtIndex  
  
  INSERT @tmp_tblPond (txtIndex,dblPond)  
  SELECT   
   DISTINCT(l.txtIndex),  
   SUM(l.dblcount*r.dblPMOP)  
  FROM MxFixIncome.dbo.tblIndexesPortfolios AS l (NOLOCK)  
   INNER JOIN @tmp_tblResultsVector AS r  
    ON l.txtId1 = r.txtId1  
  WHERE l.dtedate = (SELECT MAX(dteDate) FROM MxFixIncome.dbo.tblIndexesPortfolios WHERE txtIndex = 'MSCIPIP')   
   AND l.txtIndex = 'MSCIPIP'--,'MSCIPIP')  
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
--  WHERE ui.txtIndex IN ('MSCI','MSCIPIP')--= @txtIndex  
   
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
  
  -- Agregamos TC  
  INSERT @tmp_tblResultsVector (dteDate,txtId1,txtTv,txtEmisora,txtSerie,dblPMO,dblPMOP,txtCurrency,txtCountry,txtIndex,dblPOR,txtID2,txtSector,txtSubSector,txtRamo,txtSubRamo,txtBCT,txtVCT,txtID7,txtID6,txtID3,txtID4,txtRZ)  
   SELECT  
    @txtDate AS [dteDate],  
    RTRIM(txtIRC) AS [ID1],  
    '*C' AS [TV],  
    'MXP' + CASE WHEN txtIRC = 'UFXU' THEN 'USD' ELSE RTRIM(txtIRC) END AS [Emisora],  
    CASE WHEN txtIRC = 'UFXU' THEN 'FIX' ELSE RTRIM(txtIRC) END AS [Serie],  
    dblValue AS [Precio MO],  
    dblValue AS [Precio MO Peso],  
    '' AS [MO],  
    '' AS [Country],  
    '' AS [Indexes],  
    '' AS [POR],  
    '' AS [ID2],  
    '' AS [Sector],  
    '' AS [SubSector],  
    '' AS [Ramo],  
    '' AS [SubRamo],  
    '' AS [Bolsa Cotizacion],  
    '' AS [Valores en Cartera],  
    '' AS [Bloomberg],  
    '' AS [Reuters],  
    '' AS [CUSIP],  
    '' AS [SEDOL],  
    '' AS [Razon Social]  
  FROM @tmp_tblTC  
  ORDER BY ID1  
    
    
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
    CONVERT(CHAR(8),@txtDate,112),  
    RTRIM(txtTv),  
    RTRIM(txtEmisora),  
    RTRIM(txtSerie),  
    CASE WHEN dblPMO IS NULL THEN '0' ELSE ROUND(dblPMO,6) END,  
    CASE WHEN dblPMOP IS NULL THEN '0' ELSE ROUND(dblPMOP,6) END,  
    CASE WHEN txtCurrency IS NULL THEN '*******' ELSE RTRIM(txtCurrency) END AS [Currency],  
    CASE WHEN txtCountry IS NULL THEN ' ' ELSE RTRIM(txtCountry) END AS [Country],  
    CASE WHEN txtIndex IS NULL THEN ' ' ELSE RTRIM(txtIndex) END AS [Index],  
    CASE WHEN dblPOR IS NULL THEN '0' ELSE ROUND(dblPOR,6) END,  
    CASE WHEN txtID2 IS NULL THEN ' ' ELSE RTRIM(txtID2) END AS [ID2],  
    CASE WHEN txtSector IS NULL THEN ' ' ELSE RTRIM(txtSector) END AS [Sector],  
    CASE WHEN txtSubSector IS NULL THEN ' ' ELSE RTRIM(txtSubSector) END AS [SubSector],  
    CASE WHEN txtRamo IS NULL THEN ' ' ELSE RTRIM(txtRamo) END AS [Ramo],  
    CASE WHEN txtSubRamo IS NULL THEN ' ' ELSE RTRIM(txtSubRamo) END AS [SubRamo],  
    CASE WHEN txtBCT IS NULL THEN ' ' ELSE RTRIM(txtBCT) END,  
    CASE WHEN txtVCT IS NULL THEN ' ' ELSE RTRIM(txtVCT) END,  
    CASE WHEN txtID7 IS NULL THEN ' ' ELSE RTRIM(txtID7) END,  
    CASE WHEN txtID6 IS NULL THEN ' ' ELSE RTRIM(txtID6) END,  
    CASE WHEN txtID3 IS NULL THEN ' ' ELSE RTRIM(txtID3) END,  
    CASE WHEN txtID4 IS NULL THEN ' ' ELSE RTRIM(txtID4) END,  
    
    CASE WHEN txtRZ IS NULL THEN ' ' ELSE RTRIM(REPLACE(REPLACE(UPPER(txtRZ),'Ñ','ALT+0209'),''+ CHAR(39)+'','')) END,  
    CASE WHEN  B.CurCountry is NULL THEN ' ' ELSE UPPER(B.CurCountry)  END, 
    
     
    CASE WHEN  B.countryHQ is NULL THEN ' ' ELSE B.countryHQ  END ,  
    CASE WHEN B.CountryHQ IN ('GB','GG','JE') THEN '7'  
    WHEN B.CountryHQ IN ('BM','KY') THEN '11'  
    WHEN B.CountryHQ IN ('JP') THEN '8'  
    WHEN B.CountryHQ IN ('CA') THEN '9'  
    WHEN B.CountryHQ IN ('GR','HU','PL','CZ','RU','CZ','RU') THEN '4'  
    WHEN B.CountryHQ IN ('MX') THEN '1'  
    WHEN B.CountryHQ IN ('AL','GR','DE','HU',  
    'AD','IE','AM','IS','AT','IT','BE','LU',  
    'BY','LV','BA','MK','BG','MT','CY','MD',  
    'HR','MC','DK','ME','EE','NO','FI','NL',  
    'FR','PL','SK','PT','SI','CZ','ES','RO',  
    'GE','RU','GI','SM','RS','SE','CH','UA') THEN '2'  
    WHEN B.CountryHQ IN (  
    'AF','JO','AO','KE','SA','MG','DZ','ML',  
    'BJ','MA','BW','MU','CM','MZ','BF','NA',  
    'CG','PS','CD','QA','CI','RW','EG','EH',  
    'ET','SN','GA','ZA','GM','SD','AE','SS',  
    'GH','TN','IQ','UG','IR','ZM','IL','ZW')THEN '10'  
    WHEN B.CountryHQ IN (  
    'AU','SG','BD','BH','AZ','BN','KH',  
    'CN','KR','KP','PH','FJ','HK',  
    'IN','ID','KZ','KW','LA','MO',  
    'MY','MN','MM','NP','NE','NG',  
    'NZ','PK','WS','AS','LK','SR',  
    'TH','TW','TZ','TJ','TR','UZ') THEN '3'  
      
    WHEN B.CountryHQ IN ('US') THEN '5'  
    ELSE LTRIM(ISNULL(B.CountryHQ,'   '))  
   END ,  
   CASE WHEN c.txtSuperIssuer IS NULL THEN '                         '
   ELSE RTRIM(REPLACE(UPPER(c.txtSuperIssuer),'Ñ','ALT+0209')) END
    
     
   FROM @tmp_tblResultsVector AS A--1668  
   LEFT OUTER JOIN  tblMandate AS B  
   ON a.txtid1 = B.txtid1  
   LEFT OUTER JOIN @tblUnifiedIssuer AS C  
   ON a.txtid1 = c.txtid1  
   ORDER BY txtTv,txtEmisora,txtSerie  
     
  
  END  
  
 ELSE  
   RAISERROR ('ERROR: Falta Informacion', 16, 1)  
   
END  