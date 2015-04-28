
	--/*
	--Autor:		Omar Adrian Aceves Gutierrez
	--Fecha:		2015-04-27 12:59:03.140
	--Objetivo:		Crear archivo de Curvas libre de riesgo nodos especificos
	--*/
	ALTER procedure sp_productos_insignia;1 
	
	 @dtedate VARCHAR(20) --= '20150424' 
		as 
		begin 
		
/*CATALOGO DE NODOS A CONSULTAR*/		
		DECLARE @tblNodes table 
		(
		intID int identity(1,1),
		txtNode varchar(10)
		)
	insert into @tblNodes (txtNode)
	SELECT '360'UNION
	SELECT '720'UNION
	SELECT '1080'UNION
	SELECT '1440'UNION
	SELECT '1800'UNION
	SELECT '2160'UNION
	SELECT '2520'UNION
	SELECT '2880'UNION
	SELECT '3240'UNION
	SELECT '3600'UNION
	SELECT '3960'UNION
	SELECT '4320'UNION
	SELECT '4680'UNION
	SELECT '5040'UNION
	SELECT '5400'UNION
	SELECT '5760'UNION
	SELECT '6120'UNION
	SELECT '6480'UNION
	SELECT '6840'UNION
	SELECT '7200'UNION
	SELECT '7560'UNION
	SELECT '7920'UNION
	SELECT '8280'UNION
	SELECT '8640'UNION
	SELECT '9000'UNION
	SELECT '9360'UNION
	SELECT '9720'UNION
	SELECT '10080'UNION
	SELECT '10440'UNION
	SELECT '10800'UNION
	SELECT '11160'UNION
	SELECT '11520'UNION
	SELECT '11880'
	
	
		declare @tblNodesLevels table
		(
		txtNode  INT  ,
		txtType varchar(20),
		txtSubtype varchar(20),
		dblVallue float
		)
	
	
	
	declare @tblCurvesCatalog table
		(
		txtDtedate varchar(20),
		txtType varchar(20),
		txtSubtype varchar(20)
		)
		
		/*CATALOGO DE CURVAS A CONSULTAR*/
	insert @tblCurvesCatalog
	
	SELECT @dtedate,'CET','CTI'  UNION 
	SELECT @dtedate,'UDB','UUI' UNION
    SELECT @dtedate,'UMS','YLD' UNION 
	SELECT @dtedate,'LIB','BL'
	


	/*Creamos  Cursor para realizar consulta*/
		
	declare 
	@txtDtedate_Crs varchar(20),
	@txttxtType_Crs varchar(20),
	@txtSubtype_Crs varchar(20),
	@NodeCounter int = 1, 
	@dblNodeValue float ,
	@intNodeID	 int 
		
	DECLARE CurvesOnDemand_Cursor CURSOR FOR 
		SELECT distinct txtDtedate,txtType,txtSubtype
		FROM @tblCurvesCatalog

		OPEN CurvesOnDemand_Cursor 

			FETCH NEXT FROM CurvesOnDemand_Cursor into @txtDtedate_Crs,@txttxtType_Crs,@txtSubtype_Crs
				WHILE @@FETCH_STATUS = 0 
					BEGIN
					
					/*CONSEGUIOMOS TODOS LOS VALORES POR CADA NODO Y LO INGRESAMOS EN @tblNodesLevels */
					while (@NodeCounter <= (select COUNT(intID) from @tblNodes))
					 BEGIN
					 
				/*NODO A CONSEGUIR*/	 
				set @intNodeID =(select txtNode from @tblNodes where intID = @NodeCounter) 
				
				/*VALOR OBTENIDO*/
				set @dblNodeValue = (SELECT MxFixIncome.dbo.fun_get_curve_node_historic_complete_PiPRiesgos (CONVERT(CHAR(8),@dtedate,112),@txttxtType_Crs,@txtSubtype_Crs,@intNodeID))
					 
					 /*GUARDAMOS */
					insert into @tblNodesLevels 
					select @intNodeID,@txttxtType_Crs,@txtSubtype_Crs,CASE WHEN @dblNodeValue = -999 THEN 0 ELSE @dblNodeValue END --SI EL VALOR ES -999 LOS ACAMOS EN 0
					 
					 set @NodeCounter = @NodeCounter +1 
					 END 
					
					/*REINICIAMOS CONTADOR PARA CAMBIAR DE CURVA */
					set @NodeCounter = 1
				FETCH NEXT FROM CurvesOnDemand_Cursor into @txtDtedate_Crs,@txttxtType_Crs,@txtSubtype_Crs

					END 
		CLOSE CurvesOnDemand_Cursor 
		
		
		DEALLOCATE CurvesOnDemand_Cursor
		
		/*TERMINAMOS CURSOR*/
		
		/*INSERTAMOS TITULOS DE REPORTE*/
		declare @tblFinalReport table
		(
		intID int identity(1,1),
		txtNode varchar(20),
		CET_CTI varchar(20),
		UDB_UUI varchar(20),
		UMS_YLD varchar(20),
		LIB_BL varchar(20)
		)
		insert into  @tblFinalReport
		select 'Plazo','Cetes','IMPTO Real','IMPTO	Ums','Libor'

		
		
		
		/*FORMATEAMOS LA COLUMNA DE VALOR A 6 DECIMALES*/
	UPDATE @tblNodesLevels 
	SET dblVallue = CONVERT(DECIMAL(10,6),dblVallue)
	


/*ARMAMOS CTE PARA CAMBIAR LA ESTRUCTURA Y REPOSTAR EL PRODUCTO*/
	WITH CET_CTI (txtNode,txtType,txtSubtype,dblVallue)
	as 
	(
	SELECT txtNode,txtType,txtSubtype,dblVallue FROM @tblNodesLevels WHERE txtType = 'CET' AND txtSubtype = 'CTI' 
	)
	,UDB_UUI (txtNode,txtType,txtSubtype,dblVallue)
	as 
	(
	SELECT txtNode,txtType,txtSubtype,dblVallue FROM @tblNodesLevels WHERE txtType = 'UDB' AND txtSubtype = 'UUI' 
	),
	UMS_YLD (txtNode,txtType,txtSubtype,dblVallue)
	as
	(
	SELECT txtNode,txtType,txtSubtype,dblVallue FROM @tblNodesLevels WHERE txtType = 'UMS' AND txtSubtype = 'YLD' 
	),
	LIB_BL (txtNode,txtType,txtSubtype,dblVallue)
	as
	(
	SELECT txtNode,txtType,txtSubtype,dblVallue FROM @tblNodesLevels WHERE txtType = 'LIB' AND txtSubtype = 'BL' 
	)

/*gUARDAMOS PRODUCTO*/

insert into  @tblFinalReport
	select a.txtNode,a.dblVallue,b.dblVallue,c.dblVallue,d.dblVallue from CET_CTI as A
	inner join UDB_UUI as B
	on a.txtNode = b.txtNode
	inner join UMS_YLD as C
	on a.txtNode = C.txtNode
	inner join LIB_BL as D
	on a.txtNode = d.txtNode
	order by a.txtNode asc
	
	
/*REPORTAMOS PRODUCTO*/
		 --IF ((SELECT count(*) FROM @tblNodesLevels where dblVallue  is null) >0)      
		 --	   BEGIN    
			--			declare @errorData varchar(200)= 'Error: El producto reporta Nulos :' 
			--			 RAISERROR (  @errorData , 16, 1)   
			--	END  
			--			ELSE  
			--	BEGIN 
					select txtNode,CET_CTI,UDB_UUI,UMS_YLD,LIB_BL from @tblFinalReport
					order by intID asc
				--END 

end 