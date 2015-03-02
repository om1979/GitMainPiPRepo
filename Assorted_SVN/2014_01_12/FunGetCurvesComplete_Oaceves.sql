


IF OBJECT_ID('tempdb..#DateContainer') IS NOT NULL
DROP  TABLE #DateContainer

IF OBJECT_ID('tempdb..#plazos') IS NOT NULL
DROP  TABLE #plazos

IF OBJECT_ID('tempdb..#DataUniverse') IS NOT NULL
DROP  TABLE #DataUniverse


	DECLARE 
	@Date1 DATE,
	@Date2 DATE,
	@txtType varchar(20),
	@txtsubType varchar(20)

/*Variables rango de fechas, y tipo y subtipo de curva a consultar*/
	SET @Date1 = '20081130'
	SET @Date2 = '20111130'
	SET @txtType ='MSG'
	SET @txtsubType = 'YLD'

/*Plazos que utilizaremos en la consulta*/
	CREATE TABLE #plazos
	(
	intPlazo INT 
	)
	INSERT INTO #plazos(intPlazo)
	VALUES(2520),
	(3600),
	(3600),
	(5400),
	(7200),
	(9000),
	(10800)

	 CREATE TABLE #DateContainer
	 (
	 intId INT IDENTITY(1,1),
	 detdate DATETIME,
	 txtType varchar(20),
	 txtsubType varchar(20)
	 )
	 
/*tabla de contencion con fechas habiles y nombre de tipo y subtipo de curva*/	 
	INSERT INTO #DateContainer
		SELECT 
		CONVERT(VARCHAR(10),DATEADD(DAY,number+1,@Date1),112) [Date],
		@txtType [txtType],@txtsubType [txtsubType]
			FROM master..spt_values
				WHERE type = 'P'
					AND DATEADD(DAY,number+1,@Date1) <= @Date2
					AND (SELECT dbo.fun_IsTradingDate(CONVERT(VARCHAR(10),DATEADD(DAY,number+1,@Date1),112),'MX') ) = 1 -- donde la fecha sea habil

   CREATE TABLE #DataUniverse 
	 (
	 intId INT,
	 detdate DATETIME,
	 txtType varchar(20),
	 txtsubType varchar(20),
	 intPlazo int ,
	 dblValue Float 
	 )
	 
DECLARE @CintPlazo INT 
DECLARE @dblValue FLOAT 

/*Cursor para ingresar Plazos en tabla de trabajo*/
	DECLARE CGetPlazos CURSOR  FOR 
	SELECT DISTINCT  intPlazo FROM #plazos
		
	OPEN  CGetPlazos
		FETCH NEXT FROM CGetPlazos INTO @CintPlazo
		WHILE (@@FETCH_STATUS = 0 )
		BEGIN 
		
		INSERT INTO #DataUniverse (intId,detdate,txtType,txtsubType,intPlazo)
			SELECT intId,detdate,txtType,txtsubType,@CintPlazo AS intPlazo 
			 FROM  #DateContainer
			 
	FETCH CGetPlazos INTO @CintPlazo
	 END 
	CLOSE CGetPlazos
	DEALLOCATE CGetPlazos
	
	
	
	UPDATE u 
	SET u.dblValue =
	 (SELECT MxFixIncome.dbo.fun_get_curve_node_historic_complete_PiPRiesgos
	 (CONVERT(CHAR(8),detdate,112),txtType,txtsubType,intPlazo)
	 )  FROM #DataUniverse AS u
	 
	 
	 	INSERT INTO  dbo.tmp_specific_nodeCurves --FROM  
		SELECT * FROM    #DataUniverse
		
		
	
	--INSERT INTO  dbo.tmp_specific_nodeCurves
	--SELECT * FROM    #DataUniverse
	
	
	
	
--	SELECT * FROM  dbo.tmp_specific_nodeCurves
--		WHERE detdate = '2008-12-02 00:00:00.000'
--	 ORDER BY txtType,txtsubType
	
--	 WHERE detdate = '2008-12-02 00:00:00.000'
--	 ORDER BY txtType,txtsubType
	 
	 
--	 SELECT * FROM    #DataUniverse
--		WHERE detdate = '2008-12-02 00:00:00.000'
--	 ORDER BY txtType,txtsubType
	 
	 
	 
	 
--	 SELECT * FROM  dbo.tmp_specific_nodeCurves
	 

--	SELECT * FROM  #DataUniverse
--	 (SELECT MxFixIncome.dbo.fun_get_curve_node_historic_complete_PiPRiesgos
--	 (CONVERT(CHAR(8),'20081201',112), 'UDB', 'YLI', 3600))  
	
	
	

--SELECT DISTINCT intId,detdate,txtType,txtsubType FROM  #DateContainer

 
-- DECLARE @dblValue FLOAT 
-- SET @dblValue = 
-- (SELECT MxFixIncome.dbo.fun_get_curve_node_historic_complete_PiPRiesgos
-- (CONVERT(CHAR(8),'20081201',112), 'UDB', 'YLI', 3600))  
  
  
--  SELECT   @dblValue