
-- para obtener las directivas del archivo de Curvas
ALTER  PROCEDURE [dbo].[sp_productos_SANTANDER];5
AS   
BEGIN  

	SET NOCOUNT ON

	SELECT 
		-999 AS intSerial,
		REPLICATE(' ', 50) AS txtTipo,
		REPLICATE(' ', 50) AS txtId,
		REPLICATE(' ', 50) AS txtAlias
	INTO #tblDirectives
	TRUNCATE TABLE #tblDirectives

	INSERT #tblDirectives SELECT 1,'CURVA','FWD/CU','Implicita Pesos'
	INSERT #tblDirectives SELECT 2,'CURVA','LIB/LB','Libor'
    --INSERT #tblDirectives SELECT 3,'CURVA','BGT/BP','Ipabono BPAG Trimestral'
	--INSERT #tblDirectives SELECT 4,'CURVA','BGA/BP ','Ipabono BPAG Mensual'
	
	SET NOCOUNT OFF

	-- regreso el reporte
	SELECT 
		intSerial,
		txtTipo,
		txtId,
		txtAlias
	FROM 
		#tblDirectives AS d
	ORDER BY 
		intSerial
END

