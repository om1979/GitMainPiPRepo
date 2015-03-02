SELECT*
FROM MxFixIncome.. 
TBLPRICES 
WHERE TXTID1 = 'MHYJ0000079'
AND dteDate = '20141204'
AND txtLiquidation = 'MD'  



SELECT * FROM  dbo.tblIds AS TI 
WHERE txtID1 = 'MHYJ0000079'



SP_HELPTEXT spi_ENCUESTAS




	dbo.spi_Auditoria_Licuadora;1  '20141204','1049','BDE' ,1
	
	
	
	SELECT * FROM  dbo.itblPonderadoFinal AS IPF
	WHERE txtTv = 'BDE'
	AND dteDate = '20141205'

	
	SELECT * FROM  dbo.itblPonderadoFinal AS IPF
	WHERE txtTv = 'LD'
	AND dteDate = '20141205'
	



CREATE     PROCEDURE dbo.spi_Auditoria_Licuadora;1  '20141205','2925','2U' ,1
 @txtDate AS CHAR(10),        
 @intPlazo AS INT,        
 @txtTv AS CHAR(11),        
 @intBanda AS INTEGER = 2        