    
   
   
   /*
    SELECT 01,'BOFA',1,'IRC', 'Index.Basis.1m', ESTA MAL
    
   */ 
    
--   INACTIVO
--PREVIO_2



   
   --select * from   MxProcesses.DBO.tblProductGeneratorMap
   --where txtproduct like '%BOFA_INSUMOS_MULTISHEET_XLS%'
    
   
   
   --UPDATE tblProductGeneratorMap 
   --SET txtPack = 'PREVIO_2'
   --   where txtproduct like '%BOFA_INSUMOS_MULTISHEET_XLS%'
   -- AND txtPack = 'OPERATIVO_2'
   
   
   
   --UPDATE tblProductGeneratorMap 
   --SET fload = 1
   --   where txtproduct like '%PIP_MARKET_REF_DEF_HTM%'

   
   
       --select * from   MxProcesses.DBO.tblProductGeneratorMap
       --WHERE txtPack  = 'OPERATIVO_2'
   
   
   
   -- --Template_Insumos_Bofa.xls
   --SELECT * FROM TBLACTIVEX 
   --WHERE TXTPROCESO = 'BOFA_INSUMOS_MULTISHEET_XLS'
   
   
--   SELECT * FROM TBLACTIVEX 
--   WHERE TXTPROCESO = 'BOFA_INSUMOS_MULTISHEET_XLS'
--   AND txtPropiedad = 'TemplateFile'
   
--    UPDATE TBLACTIVEX 
--   SET txtValor = 'Template_Insumos_Bofa.xls'
--   WHERE TXTPROCESO = 'BOFA_INSUMOS_MULTISHEET_XLS'
--   AND txtPropiedad = 'TemplateFile'
   
   
   
   
   
   
   
   
      
--   select * from   MxProcesses.DBO.tblProductGeneratorMap
--   where txtproduct like '%HTM%'
    
   
--      select * from   MxProcessesHist.DBO.tblProcessBinnacle
--      WHERE txtProcess LIKE '%PIP_MARKET_REF_DEF_HTM%'
--      AND DTEDATE = '20150519'
    
   
    
/*              
----------------------------------------------------------------------------------                
   Autor:    Mike Ramirez                
   Fecha Creacion: 11:07 a.m. 2012-11-22                
   Descripcion:   Modulo 12: Generar un nuevo Vector InsumosBofa[yyyymmdd].xls                
----------------------------------------------------------------------------------                
Modifica:Omar Aceves Gutirrez               
Fecha:2014-03-27 10:00:43.787         
Descripción:Se agregan nuevos irc al archivo y cambio dinamico para titulos fundigs Futures     ----------------------------------------------------------------------------------                
*/              
          
--ALTER   PROCEDURE [dbo].[sp_productos_BOFA];12          
          --@dteDate AS DATETIME    
  DECLARE @dteDate AS DATETIME = '20150520'           
           
--AS                
--BEGIN                   
--SET NOCOUNT ON             
                
 DECLARE @intCont AS INTEGER                
 DECLARE @dblLevel AS FLOAT      
 DECLARE @intTerm AS INTEGER          
                
 -- creo tabla temporal de Directivas                
 DECLARE @tblDirectives TABLE (                
   indSheet INT,                
   SheetName CHAR(50),             
   intSection INT,      
   txtSource CHAR(50),                
   txtCode VARCHAR(250),                
   intCol INT,               intRow INT,                
   txtValue VARCHAR(50),                
 Type  CHAR(3),                
   SubType  CHAR(3),                
   Node INT,                
   intStrike INT                
  PRIMARY KEY (indSheet, intCol, intRow)                
  )                 
                
-- Creación de Directivas para obtener información                
 -- <Sheet 1><BOFA> Seccion 1 YC.USD.1M          
 /*AGREGAN TITULOS DEL ARCHIVO*/              
  INSERT @tblDirectives           
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.1m',  2, 7,'',NULL,NULL,NULL,NULL   UNION               
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.3m',  2, 8,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.1y',  2, 9,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.2y',  2, 10,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.3y',  2, 11,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.4y',  2, 12,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.5y',  2, 13,'',NULL,NULL,NULL,NULL UNION      
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.7y',  2, 14,'',NULL,NULL,NULL,NULL UNION              
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.10y', 2, 15,'',NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.12y', 2, 16,'',NULL,NULL,NULL,NULL UNION             
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.15y', 2, 17,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.20y', 2, 18,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.30y', 2, 19,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.40y', 2, 20,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Cash.1D', 2, 21,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Cash.1M', 2, 22,'',NULL,NULL,NULL,NULL UNION            
   SELECT 01,'BOFA',1,'IRC', 'Funding.Cash.3M',  2, 23,'',NULL,NULL,NULL,NULL UNION           
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  2, 24,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  2, 25,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  2, 26,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  2, 27,'',NULL,NULL,NULL,NULL UNION                
SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  2, 28,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  2, 29,'',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  2, 30,'',NULL,NULL,NULL,NULL UNION             
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.2Y',  2, 31,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.3Y',  2, 32,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.4Y',  2, 33,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.5Y',  2, 34,'',NULL,NULL,NULL,NULL UNION   
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.6Y',  2, 35,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.7Y',  2, 36,'',NULL,NULL,NULL,NULL UNION                  
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.8Y',  2, 37,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.9Y',  2, 38,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.10Y',  2, 39,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.12Y',  2, 40,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.15Y',  2, 41,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.20Y',  2, 42,'',NULL,NULL,NULL,NULL UNION       
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.25Y',  2, 43,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.30Y',  2, 44,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.40Y',  2, 45,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.50Y',  2, 46,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20101231',  2, 47,'',NULL,NULL,NULL,NULL UNION      
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20111230',  2, 48,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20121231',  2, 49,'',NULL,NULL,NULL,NULL UNION         
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20131231',  2, 50,'',NULL,NULL,NULL,NULL   UNION               
 -------------------------------------------------------------------------------------            
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.6m',  5, 7,'',NULL,NULL,NULL,NULL   UNION               
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.1y',  5, 8,'',NULL,NULL,NULL,NULL   UNION               
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.2y',  5, 9,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.3y', 5, 10,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.4y',  5, 11,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.5y',  5, 12,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.7y',  5, 13,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.10y',  5, 14,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.15y',  5, 15,'',NULL,NULL,NULL,NULL UNION                
SELECT 01,'BOFA',1,'IRC', 'Index.Basis.20y', 5, 16,'',NULL,NULL,NULL,NULL UNION         
  SELECT 01,'BOFA',1,'IRC', 'Index.Basis.30y', 5, 17,'',NULL,NULL,NULL,NULL UNION         
              
  SELECT 01,'BOFA',1,'IRC', 'Funding.Cash.1D', 5, 18,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Cash.1M', 5, 19,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Cash.3M', 5, 20,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Future.', 5, 21,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Future.', 5, 22,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  5, 23,'',NULL,NULL,NULL,NULL UNION           
  SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  5, 24,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  5, 25,'',NULL,NULL,NULL,NULL UNION             
  SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  5, 26,'',NULL,NULL,NULL,NULL UNION            
  SELECT 01,'BOFA',1,'IRC', 'Funding.Future.',  5, 27,'',NULL,NULL,NULL,NULL UNION                
                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.2Y',  5, 28,'',NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.3Y',  5, 29,'',NULL,NULL,NULL,NULL UNION            
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.4Y',  5, 30,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.5Y',  5, 31,'',NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.6Y',  5, 32,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.7Y',  5, 33,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.8Y',  5, 34,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.9Y',  5, 35,'',NULL,NULL,NULL,NULL  UNION         
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.10Y', 5, 36,'',NULL,NULL,NULL,NULL UNION       
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.12Y',  5, 37,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.15Y',  5, 38,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.20Y',  5, 39,'',NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.25Y',  5, 40,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.30Y',  5, 41,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.40Y',  5, 42,'',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'IRC', 'Funding.Swap.50Y',  5, 43,'',NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20101231',  5, 44,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20111230',  5, 45,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20121231',  5, 46,'',NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',1,'IRC', 'Turn.Bump.20131231',  5, 47,'',NULL,NULL,NULL,NULL  UNION               
                
  ------------------------------------------------------------------------------------              
              
           
  SELECT 01,'BOFA',1,'IRC', 'Index.Cash.1D',  8, 7,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Cash.1M',  8, 8,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Cash.3M',  8, 9,'',NULL,NULL,NULL,NULL UNION             
  SELECT 01,'BOFA',1,'IRC', 'Index.Future.',  8, 10,'',NULL,NULL,NULL,NULL  UNION --1              
  SELECT 01,'BOFA',1,'IRC', 'Index.Future.',  8, 11,'',NULL,NULL,NULL,NULL  UNION --2              
  SELECT 01,'BOFA',1,'IRC', 'Index.Future.',  8, 12,'',NULL,NULL,NULL,NULL  UNION --3           
  SELECT 01,'BOFA',1,'IRC', 'Index.Future.',  8, 13,'',NULL,NULL,NULL,NULL UNION --4              
  SELECT 01,'BOFA',1,'IRC', 'Index.Future.',  8, 14,'',NULL,NULL,NULL,NULL  UNION --5              
  SELECT 01,'BOFA',1,'IRC', 'Index.Future.',  8, 15,'',NULL,NULL,NULL,NULL  UNION --6              
  SELECT 01,'BOFA',1,'IRC', 'Index.Future.',  8, 16,'',NULL,NULL,NULL,NULL  UNION --7              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.2Y',  8, 17,'',NULL,NULL,NULL,NULL UNION     
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.3Y', 8, 18,'',NULL,NULL,NULL,NULL  UNION               
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.4Y',  8, 19,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.5Y',  8, 20,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.6Y',  8, 21,'',NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.7Y',  8, 22,'',NULL,NULL,NULL,NULL  UNION                
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.8Y',  8, 23,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.9Y', 8, 24,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.10Y',  8, 25,'',NULL,NULL,NULL,NULL UNION              
 SELECT 01,'BOFA',1,'IRC', 'Index.Swap.12Y',  8, 26,'',NULL,NULL,NULL,NULL  UNION               
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.15Y',  8, 27,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.20Y',  8, 28,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.25Y',  8, 29,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.30Y',  8, 30,'',NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',1,'IRC', 'Index.Swap.40Y',  8, 31,'',NULL,NULL,NULL,NULL  UNION             
   SELECT 01,'BOFA',1,'IRC', 'Index.Swap.50Y',  8, 32,'',NULL,NULL,NULL,NULL  UNION              
  SELECT 01,'BOFA',1,'IRC', 'Turn.Turn.20101231',  8, 33,'',NULL,NULL,NULL,NULL  UNION   
  SELECT 01,'BOFA',1,'IRC', 'Turn.Turn.20111231',  8, 34,'',NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',1,'IRC', 'Turn.Turn.20121231',  8, 35,'',NULL,NULL,NULL,NULL                  
              
              
              
              
             
/*se obtiene titulos para la columna 2,5,8*/              
    UPDATE @tblDirectives            
     SET txtValue = txtCode              
     FROM @tblDirectives AS A              
     WHERE a.intCol = 2              
                   
            
    UPDATE @tblDirectives               
     SET txtValue = txtCode              
     FROM @tblDirectives AS A        
     WHERE a.intCol = 5              
                   
      UPDATE @tblDirectives             
     SET txtValue = txtCode             
     FROM @tblDirectives AS A              
     WHERE a.intCol = 8           
              
                 
    --SELECT * FROM  @tblDirectives              
              
            
 INSERT @tblDirectives                
   SELECT 01,'BOFA',1,'IRC', 'Index.Basis.1m',  3, 7,'NULL',NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 3m.',3,8,NULL,NULL,NULL,NULL,NULL UNION            
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 1y.',3,9,NULL,NULL,NULL,NULL,NULL UNION           
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 2y.',3,10,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 3y.',3,11,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 4y.',3,12,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 5y.',3,13,NULL,NULL,NULL,NULL,NULL UNION          
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 7y.',3,14,NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 10y.',3,15,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 12y.',3,16,NULL,NULL,NULL,NULL,NULL UNION      
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 15y.',3,17,NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 20y.',3,18,NULL,NULL,NULL,NULL,NULL UNION               
 SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 30y.',3,19,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1Mvs3M 40y.',3,20,NULL,NULL,NULL,NULL,NULL UNION              
   SELECT 01,'BOFA',1,'IRC', 'IL001',3,21,NULL,NULL,NULL,NULL,NULL UNION        
   SELECT 01,'BOFA',1,'IRC', 'IL030',3,22,NULL,NULL,NULL,NULL,NULL UNION         
   SELECT 01,'BOFA',1,'IRC', 'IL090',3,23,NULL,NULL,NULL,NULL,NULL  UNION               
              
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future1',3,24,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future2',3,25,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future3',3,26,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future4',3,27,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future5',3,28,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future6',3,29,NULL,NULL,NULL,NULL,NULL UNION             
   SELECT 01,'BOFA',1,'IRC', 'Funding.Future7',3,30,NULL,NULL,NULL,NULL,NULL UNION               
                 
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 6m.',3,31,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 1y.',3,32,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 2y.',3,33,NULL,NULL,NULL,NULL,NULL UNION              
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 3y.',3,34,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 4y.',3,35,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 5y.',3,36,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 7y.',3,37,NULL,NULL,NULL,NULL,NULL UNION               
                  
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 10y.',3,38,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 15y.',3,39,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 20y.',3,40,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'Spreads swaps 30y.',3,41,NULL,NULL,NULL,NULL,NULL UNION            
   SELECT 01,'BOFA',1,'IRC', 'IL001',3,42,NULL,NULL,NULL,NULL,NULL UNION               
   SELECT 01,'BOFA',1,'IRC', 'IL030',3,43,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'IL090',3,44,NULL,NULL,NULL,NULL,NULL   UNION               
   SELECT 01,'BOFA',1,'IRC', 'IL030',3,45,NULL,NULL,NULL,NULL,NULL UNION                
   SELECT 01,'BOFA',1,'IRC', 'IL090',3,46,NULL,NULL,NULL,NULL,NULL   UNION              
               
   ------        
  SELECT 01,'BOFA',1,'VALORFIJO', 'Turn.Bump.20101231', 3, 47,'0.34125',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'VALORFIJO', 'Turn.Bump.20111230', 3, 48,'0.34125',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',1,'VALORFIJO', 'Turn.Bump.20121231', 3, 49,'0.6825',NULL,NULL,NULL,NULL UNION         
  SELECT 01,'BOFA',1,'VALORFIJO', 'Turn.Bump.20131231', 3, 50,'0.6825',NULL,NULL,NULL,NULL                
                
   -- <Sheet 1><BOFA> Seccion 2 YC.USD.6M                
 INSERT @tblDirectives                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.6m', 6, 7,  NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.1y', 6, 8,  NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.2y', 6, 9,  NULL,NULL,NULL,NULL,NULL UNION          
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.3y', 6, 10, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.4y', 6, 11, NULL,NULL,NULL,NULL,NULL UNION         
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.5y', 6, 12, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.7y', 6, 13, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.10y', 6, 14, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.15y', 6, 15, NULL,NULL,NULL,NULL,NULL UNION                
SELECT 01,'BOFA',2,'IRC', 'Index.Basis.20y', 6, 16, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Index.Basis.30y', 6, 17, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Funding.Cash.1D', 6, 18, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Funding.Cash.1M', 6, 19, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Funding.Cash.3M', 6, 20, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Funding.Future1', 6, 21, NULL,NULL,NULL,NULL,NULL UNION          
 SELECT 01,'BOFA',2,'IRC', 'Funding.Future2', 6, 22, NULL,NULL,NULL,NULL,NULL UNION    
 SELECT 01,'BOFA',2,'IRC', 'Funding.Future3', 6, 23,NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Funding.Future4', 6, 24, NULL,NULL,NULL,NULL,NULL UNION               
 SELECT 01,'BOFA',2,'IRC', 'Funding.Future5', 6, 25, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', 'Funding.Future6', 6, 26,NULL,NULL,NULL,NULL,NULL UNION                
SELECT 01,'BOFA',2,'IRC', 'Funding.Future7', 6, 27, NULL,NULL,NULL,NULL,NULL UNION             
             
       
 /*se agregan para nuevo laygout */            
 SELECT 01,'BOFA',2,'IRC', '', 6, 28, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 29, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 30, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 31,NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 32, NULL,NULL,NULL,NULL,NULL UNION            
 SELECT 01,'BOFA',2,'IRC', '', 6, 33, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 34,NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 35, NULL,NULL,NULL,NULL,NULL UNION             
 SELECT 01,'BOFA',2,'IRC', '', 6, 36, NULL,NULL,NULL,NULL,NULL UNION               
 SELECT 01,'BOFA',2,'IRC', '', 6, 37, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 38,NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 39, NULL,NULL,NULL,NULL,NULL UNION            
             
 SELECT 01,'BOFA',2,'IRC', '', 6, 40, NULL,NULL,NULL,NULL,NULL UNION               
 SELECT 01,'BOFA',2,'IRC', '', 6, 41, NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 42,NULL,NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',2,'IRC', '', 6, 43, NULL,NULL,NULL,NULL,NULL UNION             
             
               
             
               
               
  SELECT 01,'BOFA',2,'VALORFIJO', 'Turn.Bump.20101231', 6, 44, '0.34125',NULL,NULL,NULL,NULL UNION            
  SELECT 01,'BOFA',2,'VALORFIJO', 'Turn.Bump.20111230', 6, 45, '0.34125',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',2,'VALORFIJO', 'Turn.Bump.20121231', 6, 46, '0.6825',NULL,NULL,NULL,NULL UNION             
  SELECT 01,'BOFA',2,'VALORFIJO', 'Turn.Bump.20131231', 6, 47, '0.6825',NULL,NULL,NULL,NULL                  
                
               
    --SELECT * FROM @tblDirectives            
                
                     
                
   -- <Sheet 1><BOFA> Seccion 3 YC.USD.LIBOR                
 INSERT @tblDirectives                
               
             
  SELECT 01,'BOFA',3,'IRC', 'IL001', 9, 7, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',3,'IRC', 'IL030', 9, 8, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',3,'IRC', 'IL090', 9, 9, NULL,NULL,NULL,NULL,NULL UNION         
                
  SELECT 01,'BOFA',3,'IRC', 'Index.Future1', 9, 10, NULL,NULL,NULL,NULL,NULL UNION           
  SELECT 01,'BOFA',3,'IRC', 'Index.Future2', 9, 11, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',3,'IRC', 'Index.Future3', 9, 12, NULL,NULL,NULL,NULL,NULL UNION                 
  SELECT 01,'BOFA',3,'IRC', 'Index.Future4', 9, 13, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',3,'IRC', 'Index.Future5', 9, 14, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',3,'IRC', 'Index.Future6', 9, 15, NULL,NULL,NULL,NULL,NULL UNION              
  SELECT 01,'BOFA',3,'IRC', 'Index.Future7', 9, 16, NULL,NULL,NULL,NULL,NULL UNION                
     
              
              
  SELECT 01,'BOFA',3,'IRC', '', 9, 17, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 18, NULL,NULL,NULL,NULL,NULL UNION        
     SELECT 01,'BOFA',3,'IRC', '', 9, 19, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 20, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 21, NULL,NULL,NULL,NULL,NULL UNION              
     SELECT 01,'BOFA',3,'IRC', '', 9, 22, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 23, NULL,NULL,NULL,NULL,NULL UNION              
     SELECT 01,'BOFA',3,'IRC', '', 9, 24, NULL,NULL,NULL,NULL,NULL UNION            
     SELECT 01,'BOFA',3,'IRC', '', 9, 25, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 26, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 27, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 28, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 29, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 30, NULL,NULL,NULL,NULL,NULL UNION               
     SELECT 01,'BOFA',3,'IRC', '', 9, 31, NULL,NULL,NULL,NULL,NULL UNION            
     SELECT 01,'BOFA',3,'IRC', '', 9, 32, NULL,NULL,NULL,NULL,NULL UNION                    
                 
  SELECT 01,'BOFA',3,'VALORFIJO', 'CET-CTI|180', 9, 33, '0.0150',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',3,'VALORFIJO', 'CET-CTI|210', 9, 34, '0.0150',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',3,'VALORFIJO', 'CET-CTI|240', 9, 35, '0.0150',NULL,NULL,NULL,NULL                
                
   -- <Sheet 1><BOFA> Seccion 4 YC.MXN.TIIE                
 INSERT @tblDirectives                
  SELECT 01,'BOFA',4,'CURVESx', 'swp-ti|1', 12, 7, NULL,'SWP','TI',1,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'swp-ti|7', 12, 8, NULL,'SWP','TI',7,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|28',  12, 9, NULL,'TIE','SWP',28,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|56', 12, 10, NULL,'TIE','SWP',56,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|84', 12, 11, NULL,'TIE','SWP',84,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|168', 12, 12, NULL,'TIE','SWP',168,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|252', 12, 13, NULL,'TIE','SWP',252,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|364', 12, 14, NULL,'TIE','SWP',364,NULL UNION                
SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|728', 12, 15, NULL,'TIE','SWP',728,NULL  UNION             
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|1092', 12, 16, NULL,'TIE','SWP',1092,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|1456',  12, 17, NULL,'TIE','SWP',1456,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|1820', 12, 18, NULL,'TIE','SWP',1820,NULL UNION            
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|2548', 12, 19, NULL,'TIE','SWP',2548,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|3640', 12, 20, NULL,'TIE','SWP',3640,NULL UNION            
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|4368', 12, 21, NULL,'TIE','SWP',4368,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|5460', 12, 22, NULL,'TIE','SWP',5460,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|7280',  12, 23, NULL,'TIE','SWP',7280,NULL UNION                
  SELECT 01,'BOFA',4,'CURVESx', 'tie-swp|10920', 12, 24, NULL,'TIE','SWP',10920,NULL           
              
  --SELECT * FROM @tblDirectives              
            
            
         
 /*TABLA QUE PERMITE AGREGAR IRC1 Y IRC2 PARA HACER OPERACIONES */              
         DECLARE  @TMP_TABLE TABLE              
         (IntColTemp INT ,              
         IntRowtblDirectives INT,             
         txtTittle VARCHAR(50),              
         Irc1 VARCHAR(50),              
         Irc2 VARCHAR(50),              
         ValueIrc1 FLOAT,              
         ValueIrc2 FLOAT,              
      ResultedValue FLOAT              
 )              
                       
   INSERT @TMP_TABLE   
		SELECT 3,7,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 3,8,NULL,'USBAACA','USBAACB',NULL,NULL,NULL UNION              
         SELECT 3,9,NULL,'USBA1A','USBA1B',NULL,NULL,NULL  UNION           
         SELECT 3,10,NULL,'USBA2A','USBA2B',NULL,NULL,NULL UNION            
         SELECT 3,11,NULL,'USBA3A','USBA3B',NULL,NULL,NULL UNION              
         SELECT 3,12,NULL,'USBA4A','USBA4B',NULL,NULL,NULL UNION              
         SELECT 3,13,NULL,'USBA5A','USBA5B',NULL,NULL,NULL UNION              
         SELECT 3,14,NULL,'USBA7A','USBA7B',NULL,NULL,NULL UNION              
         SELECT 3,15,NULL,'USBA10A','USBA10B',NULL,NULL,NULL UNION              
         SELECT 3,16,NULL,'USBA12A','USBA12B',NULL,NULL,NULL UNION              
         SELECT 3,17,NULL,'USBA15A','USBA15B',NULL,NULL,NULL UNION              
      SELECT 3,18,NULL,'USBA20A','USBA20B',NULL,NULL,NULL UNION              
     SELECT 3,19,NULL,'USBA30A','USBA30B',NULL,NULL,NULL  UNION           
         SELECT 3,20,NULL,'','',NULL,NULL,NULL  UNION --Spreads swaps 1Mvs3M, 40y.              
         SELECT 3,21,NULL,'IL001','',NULL,NULL,NULL UNION              
         SELECT 3,22,NULL,'IL030','',NULL,NULL,NULL UNION              
         SELECT 3,23,NULL,'IL090','',NULL,NULL,NULL UNION    
         /*Funding.Future.Dec 12  col 3 */              
 SELECT 3,24,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 3,25,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 3,26,NULL,'','',NULL,NULL,NULL UNION              
   SELECT 3,27,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 3,28,NULL,'','',NULL,NULL,NULL UNION              
 SELECT 3,29,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 3,30,NULL,'','',NULL,NULL,NULL UNION               
                 
                     
         /*se agregan valores*/            
         SELECT 3,31,NULL,'A3L2YP','A3L2YR',NULL,NULL,NULL UNION               
      SELECT 3,32,NULL,'A3L3YP','A3L3YR',NULL,NULL,NULL UNION         
         SELECT 3,33,NULL,'A3L4YP','A3L4YR',NULL,NULL,NULL UNION               
         SELECT 3,34,NULL,'A3L5YP','A3L5YR',NULL,NULL,NULL UNION               
         SELECT 3,35,NULL,'A3L6YP','A3L6YR',NULL,NULL,NULL UNION           
         SELECT 3,36,NULL,'A3L7YP','A3L7YR',NULL,NULL,NULL UNION               
         SELECT 3,37,NULL,'A3L8YP','A3L8YR',NULL,NULL,NULL UNION               
         SELECT 3,38,NULL,'A3L9YP','A3L9YR',NULL,NULL,NULL UNION               
     SELECT 3,39,NULL,'A3L10YP','A3L10YR',NULL,NULL,NULL UNION          
         SELECT 3,40,NULL,'A3L12YP','A3L12YR',NULL,NULL,NULL UNION               
         SELECT 3,41,NULL,'A3L15YP','A3L15YR',NULL,NULL,NULL UNION               
         SELECT 3,42,NULL,'A3L20YP','A3L20YR',NULL,NULL,NULL UNION          
SELECT 3,43,NULL,'','',NULL,NULL,NULL UNION              
         /*FALTA 43 CEHACR EN LAYOUT*/            
         SELECT 3,44,NULL,'A3L30YP','A3L30YR',NULL,NULL,NULL UNION             
         SELECT 3,45,NULL,'','',NULL,NULL,NULL UNION       
         SELECT 3,46,NULL,'','',NULL,NULL,NULL UNION              
            
            
            
         SELECT 6,7,NULL,'USBCFA','USBCFB',NULL,NULL,NULL UNION              
         SELECT 6,8,NULL,'USBC1A','USBC1B',NULL,NULL,NULL UNION              
         SELECT 6,9,NULL,'USBC2A','USBC2B',NULL,NULL,NULL UNION              
         SELECT 6,10,NULL,'USBC3A','USBC3B',NULL,NULL,NULL UNION              
         SELECT 6,11,NULL,'USBC4A','USBC4B',NULL,NULL,NULL UNION              
         SELECT 6,12,NULL,'USBC5A','USBC5B',NULL,NULL,NULL UNION              
         SELECT 6,13,NULL,'USBC7A','USBC7B',NULL,NULL,NULL UNION              
         SELECT 6,14,NULL,'USBC10A','USBC10B',NULL,NULL,NULL UNION              
         SELECT 6,15,NULL,'USBC15A','USBC15B',NULL,NULL,NULL UNION      
         SELECT 6,16,NULL,'USBC20A','USBC20B',NULL,NULL,NULL UNION              
         SELECT 6,17,NULL,'USBC30A','USBC30B',NULL,NULL,NULL UNION               
         SELECT 6,18,NULL,'IL001','',NULL,NULL,NULL UNION              
SELECT 6,19,NULL,'IL030','',NULL,NULL,NULL UNION              
     SELECT 6,20,NULL,'IL090','',NULL,NULL,NULL UNION              
              
  /*Funding.Future.Dec 12  col 6*/              
         SELECT 6,21,NULL,'','',NULL,NULL,NULL UNION   
         SELECT 6,22,NULL,'','',NULL,NULL,NULL UNION             
         SELECT 6,23,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 6,24,NULL,'','',NULL,NULL,NULL UNION            
         SELECT 6,25,NULL,'','',NULL,NULL,NULL UNION         
         SELECT 6,26,NULL,'','',NULL,NULL,NULL UNION               
         SELECT 6,27,NULL,'','',NULL,NULL,NULL UNION              
                     
         /*se agregan valores de acuerdo a layout */            
             
SELECT 6,28,NULL,'A3L2YP','A3L2YR',NULL,NULL,NULL UNION          
     SELECT 6,29,NULL,'A3L3YP','A3L3YR',NULL,NULL,NULL UNION               
         SELECT 6,30,NULL,'A3L4YP','A3L4YR',NULL,NULL,NULL UNION               
         SELECT 6,31,NULL,'A3L5YP','A3L5YR',NULL,NULL,NULL UNION               
         SELECT 6,32,NULL,'A3L6YP','A3L6YR',NULL,NULL,NULL UNION             
       SELECT 6,33,NULL,'A3L7YP','A3L7YR',NULL,NULL,NULL UNION               
         SELECT 6,34,NULL,'A3L8YP','A3L8YR',NULL,NULL,NULL UNION      
         SELECT 6,35,NULL,'A3L9YP','A3L9YR',NULL,NULL,NULL UNION               
         SELECT 6,36,NULL,'A3L10YP','A3L10YR',NULL,NULL,NULL UNION            
         SELECT 6,37,NULL,'A3L12YP','A3L12YR',NULL,NULL,NULL UNION               
         SELECT 6,38,NULL,'A3L15YP','A3L15YR',NULL,NULL,NULL UNION        
         SELECT 6,39,NULL,'A3L20YP','A3L20YR',NULL,NULL,NULL UNION                     
                    
         SELECT 6,40,NULL,'','',NULL,NULL,NULL UNION               
         SELECT 6,41,NULL,'A3L30YP','A3L30YR',NULL,NULL,NULL UNION               
      SELECT 6,42,NULL,'','',NULL,NULL,NULL UNION                
         SELECT 6,43,NULL,'','',NULL,NULL,NULL UNION                
                    
         
                      
              
         /*Index.Future.Jun 14  col 9*/              
SELECT 9,7,NULL,'IL001','',NULL,NULL,NULL UNION            
         SELECT 9,8,NULL,'IL030','',NULL,NULL,NULL UNION              
         SELECT 9,9,NULL,'IL090','',NULL,NULL,NULL UNION             
                       
         SELECT 9,10,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 9,11,NULL,'','',NULL,NULL,NULL UNION             
         SELECT 9,12,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 9,13,NULL,'','',NULL,NULL,NULL UNION             
         SELECT 9,14,NULL,'','',NULL,NULL,NULL UNION              
         SELECT 9,15,NULL,'','',NULL,NULL,NULL UNION               
         SELECT 9,16,NULL,'','',NULL,NULL,NULL  UNION               
         
         /*Agregamos valores columna 9*/            
                     
         SELECT 9,17,NULL,'A3L2YP','A3L2YR',NULL,NULL,NULL UNION               
         SELECT 9,18,NULL,'A3L3YP','A3L3YR',NULL,NULL,NULL UNION               
       SELECT 9,19,NULL,'A3L4YP','A3L4YR',NULL,NULL,NULL UNION               
         SELECT 9,20,NULL,'A3L5YP','A3L5YR',NULL,NULL,NULL UNION              
         SELECT 9,21,NULL,'A3L6YP','A3L6YR',NULL,NULL,NULL UNION             
         SELECT 9,22,NULL,'A3L7YP','A3L7YR',NULL,NULL,NULL UNION               
         SELECT 9,23,NULL,'A3L8YP','A3L8YR',NULL,NULL,NULL UNION              
         SELECT 9,24,NULL,'A3L9YP','A3L9YR',NULL,NULL,NULL UNION               
         SELECT 9,25,NULL,'A3L10YP','A3L10YR',NULL,NULL,NULL UNION            
         SELECT 9,26,NULL,'A3L12YP','A3L12YR',NULL,NULL,NULL UNION               
         SELECT 9,27,NULL,'A3L15YP','A3L15YR',NULL,NULL,NULL UNION               
         SELECT 9,28,NULL,'A3L20YP','A3L20YR',NULL,NULL,NULL UNION    
                     
                     
         SELECT 9,29,NULL,'','',NULL,NULL,NULL UNION               
         SELECT 9,30,NULL,'A3L30YP','A3L30YR',NULL,NULL,NULL UNION               
         SELECT 9,31,NULL,'','',NULL,NULL,NULL UNION       
        SELECT 9,32,NULL,'','',NULL,NULL,NULL UNION              
                       
                       
                
                    
  /*OIS.USD*/            
   SELECT 27,7,NULL,'NFF3L3M','',NULL,NULL,null UNION              
         SELECT 27,8,NULL,'NFF3L6M','',NULL,NULL,NULL   UNION              
         SELECT 27,9,NULL,'NFF3L9M','',NULL,NULL,NULL   UNION              
      SELECT 27,10,NULL,'LIFF1Y','',NULL,NULL,NULL  UNION         SELECT 27,11,NULL,'LIFF2Y','',NULL,NULL,NULL UNION              
                     
         SELECT 27,12,NULL,'LIFF3Y','',NULL,NULL,NULL UNION               
  SELECT 27,13,NULL,'LIFF4Y','',NULL,NULL,NULL UNION                
         SELECT 27,14,NULL,'LIFF5Y','',NULL,NULL,NULL UNION              
     SELECT 27,15,NULL,'LIFF6Y','',NULL,NULL,NULL UNION              
     SELECT 27,16,NULL,'LIFF7Y','',NULL,NULL,NULL UNION            
  SELECT 27,17,NULL,'LIFF8Y','',NULL,NULL,NULL UNION               
         SELECT 27,18,NULL,'LIFF9Y','',NULL,NULL,NULL UNION                
         SELECT 27,19,NULL,'LIFF10Y','',NULL,NULL,NULL UNION              
         SELECT 27,20,NULL,'LIFF12Y','',NULL,NULL,NULL UNION              
         SELECT 27,21,NULL,'LIFF15Y','',NULL,NULL,NULL UNION             
          
        SELECT 27,22,NULL,'LIFF20Y','',NULL,NULL,NULL UNION                
 SELECT 27,23,NULL,'LIFF25Y','',NULL,NULL,NULL UNION              
         SELECT 27,24,NULL,'LIFF30Y','',NULL,NULL,NULL UNION              
                     
            
  /*OIS.MXN*/         
         SELECT 30,7,NULL,'OIS28D','',NULL,NULL,NULL UNION              
		 SELECT 30,8,NULL,'OIS3','',NULL,NULL,NULL UNION              
         SELECT 30,9,NULL,'OIS6','',NULL,NULL,NULL UNION              
         SELECT 30,10,NULL,'OIS9','',NULL,NULL,NULL UNION           
         SELECT 30,11,NULL,'OIS13','',NULL,NULL,NULL UNION         
         SELECT 30,12,NULL,'OIS26','',NULL,NULL,NULL UNION             
         SELECT 30,13,NULL,'OIS39','',NULL,NULL,NULL UNION                
		 SELECT 30,14,NULL,'OIS52','',NULL,NULL,NULL UNION              
         SELECT 30,15,NULL,'OIS65','',NULL,NULL,NULL UNION              
         SELECT 30,16,NULL,'OIS91','',NULL,NULL,NULL UNION              
         SELECT 30,17,NULL,'OIS130','',NULL,NULL,NULL UNION               
         SELECT 30,18,NULL,'OIS156','',NULL,NULL,NULL UNION               
         SELECT 30,19,NULL,'OIS195','',NULL,NULL,NULL UNION               
	     SELECT 30,20,NULL,'OIS260','',NULL,NULL,NULL UNION               
		SELECT 30,21,NULL,'OIS390','',NULL,NULL,NULL               
               
                       
       /*SE CONSIGUE INFORMACION Y SE ACTUALIZA @TMP_TABLE */              
         /*traemos el nombre del elemento */              
                     
                    
                     
         UPDATE @TMP_TABLE              
         SET txtTittle =  txtCode              
         FROM @tblDirectives              
   WHERE IntRowtblDirectives = intRow              
              
              
   /*traemos el valor del irc1 */              
         UPDATE @TMP_TABLE              
         SET ValueIrc1 = dblValue              
         FROM MxFixIncome.dbo.tblIrc              
         WHERE Irc1 = txtIRC AND dteDate = @dteDate              
               
                      
                       
         /*traemos el valor del irc2 */              
          UPDATE @TMP_TABLE              
         SET ValueIrc2 = dblValue              
         FROM MxFixIncome.dbo.tblIrc              
     WHERE Irc2 = txtIRC  AND dteDate = @dteDate             
                       
                      
             
         /*hacemos operación de ircs  */              
          UPDATE @TMP_TABLE              
         SET ResultedValue = ((ValueIrc1+ValueIrc2)/2)/100              
         WHERE IntColTemp NOT IN (30)              
                   
                   
        /*Modificacion solicitada por Felipe se multiplica por -1 spread swaps columna 6 row del 7 al 17*/           
        UPDATE @TMP_TABLE              
       SET ResultedValue = (((ValueIrc1+ValueIrc2)/2)/100) *-1              
         WHERE IntColTemp  IN (6) AND intRowtblDirectives BETWEEN 7 AND 17             
                   
                     
         /*caso especial para irc columna 27 de la posicion 7 al 24*/            
                     
              UPDATE @TMP_TABLE              
         SET ResultedValue = ValueIrc1            
         WHERE IntColTemp  IN (27)              
            
         /*CORREGIR NO SE PASA A RESUKLTED VALUE PARA ULTIMA MODIFICACION NECESARIA*/ --SELECT * FROM  @TMP_TABLE  -------            
                     
         /*de 3,31  a  3,46   columna 3  Funding.Swap.2Y a Funding.Swap.50Y*/            
         UPDATE @TMP_TABLE              
         SET ResultedValue = ((ValueIrc1+ValueIrc2)/2)            
WHERE IntRowtblDirectives IN (31,32,33,34,35,36,37,38,39,40,41,42,44 )            
         AND IntColTemp = 3            
                     
    /*de    columna 6  */            
    UPDATE @TMP_TABLE              
    SET ResultedValue = ((ValueIrc1+ValueIrc2)/2)              
    WHERE IntRowtblDirectives IN (28,29,30,31,32,33,34,35,36,37,38,39,41)            
    AND IntColTemp = 6            
                
                
    /*Columna 9 valores del 17,18,19,20,21,22,23,24,25,26,27,28,30*/            
     UPDATE @TMP_TABLE              
    SET ResultedValue = ((ValueIrc1+ValueIrc2)/2)              
    WHERE IntRowtblDirectives IN (17,18,19,20,21,22,23,24,25,26,27,28,30)            
    AND IntColTemp = 9            
            
            
          
   /*se agregan variables con valores para utlilizar calculos de IntRowtblDirectives 43,45,46  (valido para columnas 3,6,9)*/               
            
DECLARE   @A3L30YP_A3L30YR   FLOAT =(              
 SELECT  ResultedValue FROM @TMP_TABLE WHERE            IntColTemp = 3 AND  IntRowtblDirectives  = 44) --( A3L30YP+ A3L30YR)/2            
            
DECLARE   @A3L20YP_A3L20YR FLOAT =(            
 SELECT  ResultedValue FROM @TMP_TABLE WHERE             
 IntColTemp = 3 AND  IntRowtblDirectives = 42 )--( A3L20YP+ A3L20YR)/2            
             
            
--.5 *{( [( A3L30YP + A3L30YR)/2] - [( A3L20YP+ A3L20YR)/2]) + [( A3L20YP+ A3L20YR)/2]}            
  UPDATE @TMP_TABLE              
     SET ResultedValue = (1800*((@A3L30YP_A3L30YR - @A3L20YP_A3L20YR)/ 3600) ) + @A3L20YP_A3L20YR    --.5 *( (@A3L30YP_A3L30YR - @A3L20YP_A3L20YR) + @A3L20YP_A3L20YR)            
  WHERE IntRowtblDirectives IN (43) AND IntColTemp = 3            
  
         -- (1800*((@A3L30YP_A3L30YR - @A3L20YP_A3L20YR)/ 3600) ) + @A3L20YP_A3L20YR        
                     
                     
             
                     
          /*para la columna 6*/            
      UPDATE @TMP_TABLE              
    SET ResultedValue = (1800*((@A3L30YP_A3L30YR - @A3L20YP_A3L20YR)/ 3600) ) + @A3L20YP_A3L20YR     
    WHERE IntRowtblDirectives IN (40) AND IntColTemp = 6            
                
    /*columna 9*/            
     UPDATE @TMP_TABLE              
    SET ResultedValue = (1800*((@A3L30YP_A3L30YR - @A3L20YP_A3L20YR)/ 3600) ) + @A3L20YP_A3L20YR              
WHERE IntRowtblDirectives IN (29) AND IntColTemp = 9            
                
  
           /*COLUMNA 3 CELDA 7  */
    DECLARE  @USBAACA_USBAACB FLOAT =( SELECT  ResultedValue FROM @TMP_TABLE WHERE IntColTemp = 3 AND  IntRowtblDirectives  = 8)
    DECLARE  @USBA1A_USBA1B     FLOAT =( SELECT  ResultedValue  FROM @TMP_TABLE WHERE IntColTemp = 3 AND  IntRowtblDirectives  = 9)
     
    /*COLUMNA: 3 CELDA 7 SE USA FUNCION TREND PARA CONSEGUIR RESULTEDVALUE*/
     UPDATE @TMP_TABLE              
         SET ResultedValue = dbo.fun_Trending(90,@USBAACA_USBAACB,30,360,@USBA1A_USBA1B               )            
         WHERE IntRowtblDirectives IN (7)            
         AND IntColTemp = 3            
    
    
          
                
 /*columna 3 fun_Trending */            
      /*           AfterValue: Lo que salga en el nodo de la tasa de 40Y            
  */            
     
  UPDATE @TMP_TABLE              
         SET ResultedValue = dbo.fun_Trending(9000,(SELECT ResultedValue FROM @TMP_TABLE WHERE IntRowtblDirectives IN (43)    
         AND IntColTemp = 3 ),            
      14400,            
         10800,            
     (@A3L30YP_A3L30YR)            
         )            
         WHERE IntRowtblDirectives IN (45)            
         AND IntColTemp = 3            
   
                     

                     
                     
         /*           
           AfterValue: Lo que salga en el nodo de la tasa de 50Y      
         */            
  UPDATE @TMP_TABLE              
         SET ResultedValue = dbo.fun_Trending(10800,@A3L30YP_A3L30YR,            
         18000,            
         14400,            
   (SELECT ResultedValue FROM @TMP_TABLE WHERE IntRowtblDirectives IN (45)             
         AND IntColTemp = 3 )            
)            
     WHERE IntRowtblDirectives IN (46)          
         AND IntColTemp = 3            
                     
                     
          
            /*            
           AfterValue: Lo que salga en el nodo de la tasa de 30Y y 40Y columna 6            
*/            
             
           
   UPDATE @TMP_TABLE              
         SET ResultedValue = dbo.fun_Trending(9000,(SELECT ResultedValue FROM @TMP_TABLE WHERE IntRowtblDirectives IN (43)         
         AND IntColTemp = 3 ),            
         14400,            
         10800,            
         (@A3L30YP_A3L30YR)             )            
         WHERE IntRowtblDirectives IN (42)            
         AND IntColTemp = 6            
            
       UPDATE @TMP_TABLE              
     SET ResultedValue = dbo.fun_Trending(10800,@A3L30YP_A3L30YR,            
     18000,            
     14400,            
     (SELECT ResultedValue FROM @TMP_TABLE WHERE IntRowtblDirectives IN (45)         
     AND IntColTemp = 3 )          
     )            
     WHERE IntRowtblDirectives IN (43)            
     AND IntColTemp = 6            
  
        --SELECT ResultedValue FROM @TMP_TABLE WHERE IntRowtblDirectives IN (45)           
     --AND IntColTemp = 3            
/*columna 9*/            
                 
                        
  UPDATE @TMP_TABLE              
         SET ResultedValue = dbo.fun_Trending(9000,(SELECT ResultedValue FROM @TMP_TABLE WHERE IntRowtblDirectives IN (43)             
         AND IntColTemp = 3 ),          
         14400,            
         10800,            
      (@A3L30YP_A3L30YR)            
     )            
         WHERE IntRowtblDirectives IN (31)            
         AND IntColTemp = 9                  
                     
         /*            
 AfterValue: Lo que salga en el nodo de la tasa de 50Y         
         */            
           UPDATE @TMP_TABLE              
         SET ResultedValue = dbo.fun_Trending(10800,@A3L30YP_A3L30YR,            
         18000,          
         14400,            
      (SELECT ResultedValue FROM @TMP_TABLE WHERE IntRowtblDirectives IN (45)             
    AND IntColTemp = 3 )            
         )            
        WHERE IntRowtblDirectives IN (32)            
         AND IntColTemp = 9            
                     
        
        /*valores fijos para ircs */  --oaceves se cambia operacion de (ValueIrc1 * -1) a:            
         UPDATE @TMP_TABLE              
         SET ResultedValue = (ValueIrc1)           
         WHERE Irc1  IN ('IL001','IL030','IL090')              
                       
         UPDATE @TMP_TABLE              
         SET ResultedValue =    ValueIrc1              
         WHERE IntColTemp  IN (30)          
           
          
           
                     
/*se obtienen Funding.Future del 1 al 7 con nombre */              
              
    DECLARE @tmp_mtdInfo TABLE              
    (              
    rowaffected INT IDENTITY(24,1),              
    txtMTD DATETIME,              
    txtFormat VARCHAR(50),              
    valuedef FLOAT               
    )              
    DECLARE @tmp_mtdInfoCol5 TABLE              
    (              
    rowaffected INT IDENTITY(21,1),              
    txtMTD DATETIME,              
    txtFormat VARCHAR(50),              
    valuedef FLOAT               
    )              
       DECLARE @tmp_mtdInfoCol9 TABLE      
   (              
    rowaffected INT IDENTITY(10,1),              
    txtMTD DATETIME,              
    txtFormat VARCHAR(50),              
    valuedef FLOAT               
    )              
                  
               
    /*SE OBTIENE TITULOS VALORES Y FECHAS PARA FUNDING FUTURES*/             
  /*columna 3*/                
  INSERT INTO @tmp_mtdInfo               
   SELECT  TOP 7 MIN(txtMTD), REPLACE(RIGHT(CONVERT(VARCHAR(9), CONVERT(DATETIME,txtMTD), 6), 6), ' ', ' '),txtLPV              
    FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport              
     WHERE txtTv = 'FC' AND txtEmisora = 'ED'              
     AND  SUBSTRING(txtSerie,0,2)  IN ('H','M','U','Z')              
     AND txtMTD >= (SELECT GETDATE())              
     AND txtLiquidation = 'MP'              
 GROUP BY txtMTD,txtLPV             
     ORDER BY txtMTD                             
                   
  --SELECT * FROM @tmp_mtdInfo              
                   
  /*columna 5*/              
  INSERT INTO @tmp_mtdInfoCol5             
   SELECT  TOP 7 MIN(txtMTD), REPLACE(RIGHT(CONVERT(VARCHAR(9), CONVERT(DATETIME,txtMTD), 6), 6), ' ', ' '),txtLPV              
    FROM  MxFixIncome.dbo.tmp_tblUnifiedPricesReport              
     WHERE txtTv = 'FC' AND txtEmisora = 'ED'           
     AND  SUBSTRING(txtSerie,0,2)  IN ('H','M','U','Z')              
     AND txtMTD >= (SELECT GETDATE())              
AND txtLiquidation = 'MP'              
     GROUP BY txtMTD,txtLPV              
  ORDER BY txtMTD              
    
              
                   
  /*columna 9 */      
  INSERT INTO @tmp_mtdInfoCol9               
   SELECT  TOP 7 MIN(txtMTD), REPLACE(RIGHT(CONVERT(VARCHAR(9), CONVERT(DATETIME,txtMTD), 6), 6), ' ', ' '),txtLPV              
    FROM MxFixIncome.dbo.tmp_tblUnifiedPricesReport              
     WHERE txtTv = 'FC' AND txtEmisora = 'ED'              
     AND  SUBSTRING(txtSerie,0,2)  IN ('H','M','U','Z')              
     AND txtMTD >= (SELECT GETDATE())              
     AND txtLiquidation = 'MP'           
     GROUP BY txtMTD,txtLPV              
   ORDER BY txtMTD            
                   
                   
    
                   
 /*ASIGNA TITUTLOS DINAMICOS DE FUTURES */              
      UPDATE @tblDirectives               
     SET txtValue = txtCode + a.txtformat            
     FROM @tmp_mtdInfo AS A              
     WHERE intCol = 2 AND a.rowaffected = intRow             
                   
              
      UPDATE @tblDirectives               
     SET txtValue = txtCode + a.txtformat               
     FROM @tmp_mtdInfoCol5  AS A              
     WHERE intCol = 5 AND a.rowaffected = intRow              
                   
  UPDATE @tblDirectives               
     SET txtValue = txtCode + a.txtformat               
     FROM @tmp_mtdInfoCol9  AS A              
     WHERE intCol = 8 AND a.rowaffected = intRow              
                   
--SELECT * FROM @tmp_mtdInfoCol9              
                   
          /*FIN DE TITULOS FUTURES */                  
              
/* se actualiza tabla en base a los resultados de Funding.Future*/              
     UPDATE @TMP_TABLE              
     SET ResultedValue = valuedef              
     FROM @tmp_mtdInfo              
     WHERE rowaffected = IntRowtblDirectives              
     AND IntColTemp =3              
                  
UPDATE @TMP_TABLE              
     SET ResultedValue = valuedef              
     FROM @tmp_mtdInfoCol5              
   WHERE rowaffected = IntRowtblDirectives              
     AND IntColTemp =6              
                  
UPDATE @TMP_TABLE              
     SET ResultedValue = valuedef              
     FROM @tmp_mtdInfoCol9              
     WHERE rowaffected = IntRowtblDirectives              
     AND IntColTemp =9              
               ----------------------------              
                     
/*caso especial Spreads swaps 1Mvs3M, 40y. */              
        --SELECT ResultedValue  FROM @TMP_TABLE WHERE txtTittle = 'Spreads swaps 1Mvs3M 20y.'              
                        DECLARE @irc1val1 FLOAT                
       DECLARE @irc2val2 FLOAT                
        --set @irc1val1 = (SELECT ResultedValue  FROM @TMP_TABLE WHERE txtTittle = 'Spreads swaps 1Mvs3M 20y.')              
        --set @irc2val2 = (SELECT ResultedValue  FROM @TMP_TABLE WHERE txtTittle = 'Spreads swaps 1Mvs3M 30y.')              
SET @irc1val1 = (SELECT ResultedValue  FROM @TMP_TABLE WHERE txtTittle = 'Index.Basis.20y' AND IntColTemp = 3 AND IntRowtblDirectives =18 ) --0.04375              
SET @irc2val2 = (SELECT ResultedValue  FROM @TMP_TABLE WHERE txtTittle = 'Index.Basis.30y' AND IntColTemp = 3 AND IntRowtblDirectives =19 )               
              
           
              
    
              
         UPDATE @TMP_TABLE              
         SET ResultedValue = ROUND (ABS((@irc1val1 - @irc2val2)-@irc2val2),4)              
       WHERE  IntColTemp = 3 AND IntRowtblDirectives =20              
              
                  
--SELECT * FROM @TMP_TABLE              
              
      
	
                     
/*se actualiza la tabla de directivas con los resultados de @TMP_TABLE */              
    update @tblDirectives           
 SET txtValue = ResultedValue              
     FROM @TMP_TABLE              
   WHERE intRow = IntRowtblDirectives AND intcol = IntColTemp    
   --and 1 = case when intCol =3 and intRow= 7 then 0 else 1 end 
     

 -- <Sheet 1><BOFA> Seccion 4.2 YC.MXN.TIIE                
 SET @intCont = 0                
                
 DECLARE csr_Info_TIIE CURSOR FOR                
  SELECT                 
   LTRIM(STR(m.intTerm,5)) AS [Plazo],                
   STR(m.dblLevel,10,6) AS [Level]               
  FROM MxFixIncome.dbo.tblMarkets AS m (NOLOCK)                
            WHERE m.dtedate = @dteDate AND m.txtCode = 'SWPLIBTIIE' AND m.intTerm <= 10920                 
  GROUP BY m.intTerm,m.dblLevel                        ORDER BY m.intTerm                
              
 OPEN csr_Info_TIIE           FETCH NEXT FROM csr_Info_TIIE                
 INTO                
  @intTerm,                
  @dblLevel                
                
 WHILE (@@FETCH_STATUS = 0)            
 BEGIN                
                 
  INSERT @tblDirectives           
   SELECT 01,'BOFA',4,'MARKETS','SWPLIBTIIE',12,(25 + @intCont),@dblLevel*100,'','',NULL,NULL                
                
  SET @intCont = @intCont + 1        
       
  FETCH NEXT FROM csr_Info_TIIE                
  INTO                
   @intTerm,           
  @dblLevel                
                
 END                        
 CLOSE csr_Info_TIIE                
 DEALLOCATE csr_Info_TIIE                
    
-----                
   -- <Sheet 1><BOFA> Seccion 5 YC.MXV.MXV                
 INSERT @tblDirectives                
           
              
  SELECT 01,'BOFA',5,'VALORFIJO', 'ULS-SWP|182', 15, 7,NULL,'ULS','SWP',NULL,NULL UNION  --182              
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|364', 15, 8, NULL,'ULS','SWP',364,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|364', 15, 8, NULL,'ULS','SWP',364,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|728', 15, 9, NULL,'ULS','SWP',728,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|1092',15, 10, NULL,'ULS','SWP',1092,NULL UNION                 
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|1456',15, 11, NULL,'ULS','SWP',1456,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|1820',15, 12, NULL,'ULS','SWP',1820,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|2548',15, 13, NULL,'ULS','SWP',2548,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|3640',15, 14, NULL,'ULS','SWP',3640,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|4568',15, 15, NULL,'ULS','SWP',4368,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|5460',15, 16, NULL,'ULS','SWP',5460,NULL  UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|7280',15, 17, NULL,'ULS','SWP',7280,NULL UNION                
  SELECT 01,'BOFA',5,'CURVESx', 'ULS-SWP|10920',15, 18, NULL,'ULS','SWP',10920,NULL                
-----                
                
   -- <Sheet 1><BOFA> Seccion 5.2 YC.MXV.MXV        
 INSERT @tblDirectives                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.1D', 15, 19,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.1Y', 15, 20,'0.0000',NULL,NULL,NULL,NULL UNION       
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.2Y', 15, 21,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.3Y', 15, 22,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.4Y', 15, 23,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.5Y', 15, 24,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.7Y', 15, 25,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.10Y',15, 26,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.12Y',15, 27,'0.0000',NULL,NULL,NULL,NULL UNION     
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.15Y',15, 28,'0.0000',NULL,NULL,NULL,NULL UNION                
SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.20Y',15, 29,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',5,'VALORFIJO', 'Funding.Basis.30Y',15, 30,'0.0000',NULL,NULL,NULL,NULL  UNION               
           
   -- <Sheet 1><BOFA> Seccion 6 YC.MXV.MXV         INSERT @tblDirectives                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|1',   18, 7, NULL,'UDT','CCS',1,NULL UNION           
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|364', 18, 8, NULL,'UDT','CCS',364,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|728', 18, 9, NULL,'UDT','CCS',728,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|1092',18, 10, NULL,'UDT','CCS',1092,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|1456',18, 11, NULL,'UDT','CCS',1456,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|1820',18, 12, NULL,'UDT','CCS',1820,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|2548',18, 13, NULL,'UDT','CCS',2548,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|3640',18, 14, NULL,'UDT','CCS',3640,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|4368',18, 15, NULL,'UDT','CCS',4368,NULL  UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|5460',18, 16, NULL,'UDT','CCS',5460,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|7280',18, 17, NULL,'UDT','CCS',7280,NULL UNION                
  SELECT 01,'BOFA',6,'CURVES', 'UDT-CCS|10920',18, 18,NULL,'UDT','CCS',10920,NULL                
                
   -- <Sheet 1><BOFA> Seccion 6.2 YC.MXV.MXV                
 INSERT @tblDirectives                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.1D', 18, 19,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.1Y', 18, 20,'0.0000',NULL,NULL,NULL,NULL UNION          
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.2Y', 18, 21,'0.0000',NULL,NULL,NULL,NULL UNION                
 SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.3Y', 18, 22,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.4Y', 18, 23,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.5Y', 18, 24,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.7Y', 18, 25,'0.0000',NULL,NULL,NULL,NULL UNION                  
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.10Y',18, 26,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.12Y',18, 27,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.15Y',18, 28,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.20Y',18, 29,'0.0000',NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',6,'VALORFIJO', 'Funding.Basis.30Y',18, 30,'0.0000',NULL,NULL,NULL,NULL                
------                
   -- <Sheet 1><BOFA> Seccion 7 YC.MXN.CETES                
 INSERT @tblDirectives                
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 1',  21, 7, NULL,'CET','CTI',1,NULL UNION     
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 7',  21, 8, NULL,'CET','CTI',7,NULL UNION          
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 30', 21, 9, NULL,'CET','CTI',30,NULL UNION                
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 60', 21, 10,NULL,'CET','CTI',60,NULL UNION                
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 91', 21, 11,NULL,'CET','CTI',91,NULL UNION                
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 182', 21, 12,NULL,'CET','CTI',182,NULL UNION                
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 275', 21, 13,NULL,'CET','CTI',275,NULL UNION                
  SELECT 01,'BOFA',7,'CURVESx', 'CET-CTI| 365', 21, 14,NULL,'CET','CTI',365,NULL                
                
------             
   -- <Sheet 1><BOFA> Seccion 7.2 YC.MXN.CETES                
 INSERT @tblDirectives                
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 15,NULL,NULL,NULL,730,NULL UNION                
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 16,NULL,NULL,NULL,1095,NULL UNION               
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 17,NULL,NULL,NULL,1460,NULL UNION                
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 18,NULL,NULL,NULL,1825,NULL UNION                
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 19,NULL,NULL,NULL,2555,NULL UNION                
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 20,NULL,NULL,NULL,3650,NULL UNION      
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 21,NULL,NULL,NULL,4380,NULL UNION                
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 22,NULL,NULL,NULL,5475,NULL UNION                
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 23,NULL,NULL,NULL,7300,NULL UNION           
  SELECT 01,'BOFA',7,'MARKETS', 'CETSWP', 21, 24,NULL,NULL,NULL,10950,NULL                
                
 UPDATE d SET txtValue = m.dblLevel*100                
 FROM @tblDirectives AS d                
  INNER JOIN MxFixIncome.dbo.tblMarkets AS m (NOLOCK)                
  ON d.txtCode = m.txtCode                
  AND d.Node = m.intTerm                
 WHERE d.txtSource = 'MARKETS'                
  AND m.txtCode = 'CETSWP'                
  AND m.dteDate = @dteDate                
              
                            
                 
    DECLARE @FloatRate DECIMAL(20,10)               
    SET @FloatRate =(     
    SELECT dblRate FROM dbo.tblCurves              
    WHERE txtType = 'ULS' AND txtSubtype = 'SWP'              
     AND dteDate = (SELECT (MAX(dteDate))FROM dbo.tblCurves              
    WHERE txtType = 'ULS' AND txtSubtype = 'SWP' )              
   AND intTerm  = 182)              
                  
   -- PRINT  @FloatRate              
                  
        UPDATE @tblDirectives              
   SET txtValue = ( SELECT  (POWER( (1+@FloatRate*182/360) ,   (1/CAST(182 AS DECIMAL)))  -1   )   * 360 )              
   WHERE intCol = '15' AND  intRow = '7'              
   -- SELECT * FROM @tblDirectives              
              
              
                
   -- <Sheet 1><BOFA> Seccion 8 YC.MXN.CETES                
 INSERT @tblDirectives     
    SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|1', 24, 7, NULL,'FWD','PIP',1,NULL UNION                
    SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|1', 24, 8, NULL,'FWD','PIP',7,NULL UNION                
    SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|7', 24, 9, NULL,'FWD','PIP',30,NULL UNION                
    SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|30',24, 10, NULL,'FWD','PIP',60,NULL UNION                
    SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|60',24, 11, NULL,'FWD','PIP',90,NULL UNION                
   SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|91',24, 12, NULL,'FWD','PIP',182,NULL UNION                
    SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|182',24, 13,NULL,'FWD','PIP',275,NULL UNION            
    SELECT 01,'BOFA',8,'CURVESx1', 'CET-CTI|275',24, 14,NULL,'FWD','PIP',365,NULL                 
        
                
 INSERT @tblDirectives               
      /*OIS.USD*/            
                 
  SELECT 01,'BOFA',9,'IRC-','NFF3L3M',27,7, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',9,'IRC-','NFF3L6M',27,8, NULL,NULL,NULL,NULL,NULL UNION         
  SELECT 01,'BOFA',9,'IRC-','NFF3L9M',27,9, NULL,NULL,NULL,NULL,NULL UNION               
  SELECT 01,'BOFA',9,'IRC-','LIFF1Y',27,10, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',9,'IRC-','LIFF2Y',27,11, NULL,NULL,NULL,NULL,NULL UNION           
  SELECT 01,'BOFA',9,'IRC-','LIFF3Y',27,12, NULL,NULL,NULL,NULL,NULL UNION         
  SELECT 01,'BOFA',9,'IRC-','LIFF4Y',27,13,NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',9,'IRC-','LIFF5Y',27,14,NULL,NULL,NULL,NULL,NULL  UNION               
  SELECT 01,'BOFA',9,'IRC-','LIFF6Y',27,15, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',9,'IRC-','LIFF7Y',27,16, NULL,NULL,NULL,NULL,NULL UNION         
  SELECT 01,'BOFA',9,'IRC-','LIFF8Y',27,17, NULL,NULL,NULL,NULL,NULL UNION       
  SELECT 01,'BOFA',9,'IRC-','LIFF9Y',27,18,NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',9,'IRC-','LIFF10Y',27,19,NULL,NULL,NULL,NULL,NULL UNION             
  SELECT 01,'BOFA',9,'IRC-','LIFF12Y',27,20,NULL,NULL,NULL,NULL,NULL UNION        
  SELECT 01,'BOFA',9,'IRC-','LIFF15Y',27,21,NULL,NULL,NULL,NULL,NULL UNION            
  SELECT 01,'BOFA',9,'IRC-','LIFF20Y',27,22,NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',9,'IRC-','LIFF25Y',27,23,NULL,NULL,NULL,NULL,NULL UNION                 
  SELECT 01,'BOFA',9,'IRC-','LIFF30Y',27,24,NULL,NULL,NULL,NULL,NULL UNION             
  SELECT 01,'BOFA',10,'IRC-','OIS28D',30,7, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS3',30,8,   NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS6',30,9,   NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS9',30,10,  NULL,NULL,NULL,NULL,NULL UNION               
  SELECT 01,'BOFA',10,'IRC-','OIS13',30,11, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS26',30,12, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS39',30,13, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS52',30,14, NULL,NULL,NULL,NULL,NULL  UNION               
  SELECT 01,'BOFA',10,'IRC-','OIS65',30,15, NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS91',30,16, NULL,NULL,NULL,NULL,NULL UNION               
  SELECT 01,'BOFA',10,'IRC-','OIS130',30,17,NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS156',30,18,NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS195',30,19,NULL,NULL,NULL,NULL,NULL UNION               
  SELECT 01,'BOFA',10,'IRC-','OIS260',30,20,NULL,NULL,NULL,NULL,NULL UNION                
  SELECT 01,'BOFA',10,'IRC-','OIS390',30,21,NULL,NULL,NULL,NULL,NULL UNION
 /*UDI-TIIE SWAP casos especiales */      
  SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 1D.',33,7,NULL,'UDT','SWP',182,NULL UNION
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 2D.',33,8,NULL,'UDT','SWP',NULL,NULL UNION     
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 3D.',33,9,NULL,'UDT','SWP',NULL,NULL UNION 
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 4D.',33,10,NULL,'UDT','SWP',NULL,NULL UNION
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 5D.',33,11,NULL,'UDT','SWP',NULL,NULL UNION
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 6D.',33,12,NULL,'UDT','SWP',NULL,NULL UNION
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 7D.',33,13,NULL,'UDT','SWP',NULL,NULL UNION
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 8D.',33,14,NULL,'UDT','SWP',NULL,NULL UNION
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 84D.',33,15,NULL,'UDT','SWP',NULL,NULL UNION   
   SELECT 01,'BOFA',10,'CUSTOM_CURVES', 'UDI-TIIE Swap 168D.',33,16,NULL,'UDT','SWP',NULL,NULL UNION 
   /*UDI-TIIE SWAP curvas normales*/
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 252D',33,17,NULL,'UDT','SWP',252,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 364D',33,18,NULL,'UDT','SWP',364,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 728D',33,19,NULL,'UDT','SWP',728,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 1092D',33,20,NULL,'UDT','SWP',1092,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 1456D',33,21,NULL,'UDT','SWP',1456,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 1820D',33,22,NULL,'UDT','SWP',1820,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 2548D',33,23,NULL,'UDT','SWP',2548,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 3640D',33,24,NULL,'UDT','SWP',3640,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 4368D',33,25,NULL,'UDT','SWP',4368,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 5460D',33,26,NULL,'UDT','SWP',5460,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 7280D',33,27,NULL,'UDT','SWP',7280,NULL UNION
  SELECT 01,'BOFA',10,'CURVES', 'UDI-TIIE Swap 10920D',33,28,NULL,'UDT','SWP',10920,NULL 

/*se procesan valores para hoja1 nodos curva UDI_TIIE  columna 33*/
	/*
	creamos tabla que contendra
	la relacion de curvas UDI-TIIE Swap
	que requieren la funcion TREND
	*/
	DECLARE @tblUDI_TIIE_Swap_Data table 
	(
	txtcode varchar(50),
	intcol int,
	intRow int,
	intBNode int,
	intnode int ,
	intAftNode int,
	txtAnteriorInmediato varchar(50) ,
	txtvalue varchar(50) null
	)


	insert into @tblUDI_TIIE_Swap_Data (txtcode,intcol,intRow,intBNode,intnode,intAftNode,txtAnteriorInmediato)
	select 'UDI-TIIE Swap 1D.',33,7,NULL,NULL,182,'-'union
	select 'UDI-TIIE Swap 2D.',33,8,1,2,182,'UDI-TIIE Swap 1D.' union 
	select 'UDI-TIIE Swap 3D.',33,9,2,3,182,'UDI-TIIE Swap 2D.' union 
	select 'UDI-TIIE Swap 4D.',33,10,3,4,182,'UDI-TIIE Swap 3D.'  union 
	select 'UDI-TIIE Swap 5D.',33,11,4,5,182,'UDI-TIIE Swap 4D.'  union 
	select 'UDI-TIIE Swap 6D.',33,12,5,6,182,'UDI-TIIE Swap 5D.' union 
	select 'UDI-TIIE Swap 7D.',33,13,6,7,182,'UDI-TIIE Swap 6D.' union 
	select 'UDI-TIIE Swap 8D.',33,14,7,8,182,'UDI-TIIE Swap 7D.' union 
	select 'UDI-TIIE Swap 84D.',33,15,8,84,182,'UDI-TIIE Swap 8D.' union 
	select 'UDI-TIIE Swap 168D.',33,16,84,168,182,'UDI-TIIE Swap 84D.'
	order by 3

	/*valor de la constante nodo 182 de la curva UDT-SWP*/
		   DECLARE   @UDI_TIIE FLOAT =
		   ( select dblRate from tblCurves where txtType = 'UDT' and txtSubtype = 'SWP' and intTerm = 182 and dteDate = @dteDate)

	/*se asigna valor de la constante entre 182 a la posicion correspondiente*/       
	   update @tblUDI_TIIE_Swap_Data 
	   set txtValue = CONVERT(DECIMAL(10,8),@UDI_TIIE/182)
	   where txtCode = 'UDI-TIIE Swap 1D.'
	   
	   /*se agrega valor de @UDI_TIIE/182 a variable @UDI_TIIESwap1D*/
	   DECLARE  @UDI_TIIESwap1D FLOAT =(SELECT  txtValue FROM @tblUDI_TIIE_Swap_Data WHERE txtCode = 'UDI-TIIE Swap 1D.')
	 
	   

	DECLARE @CODE VARCHAR(50)
	DECLARE @INTROW INT 
	DECLARE @INTBNODE INT
	DECLARE @INTNODE INT 
	DECLARE @INTAFTNODE INT 
	DECLARE @ANTERIOR_INMEDIATO VARCHAR(50)
	DECLARE @TXTVALUE VARCHAR(50)


	/*creamos cursor que servira para usar la funcion Trend en este caso en particular pq cada Swap requiere del calulo anterior */
			DECLARE CUSTOM_CURVES_CURSOR CURSOR
				FOR
				SELECT DISTINCT  txtCode,intRow,intBNode,intnode,intAftNode,txtAnteriorInmediato,txtvalue  FROM @tblUDI_TIIE_Swap_Data WHERE intRow >7 AND intRow <= 16
				ORDER BY intRow


					OPEN  CUSTOM_CURVES_CURSOR

					FETCH CUSTOM_CURVES_CURSOR INTO @CODE,@INTROW,@INTBNODE,@INTNODE,@INTAFTNODE,@ANTERIOR_INMEDIATO,@TXTVALUE
						WHILE (@@FETCH_STATUS = 0 )
							BEGIN
								
								/*conseguimos el valor de la curva anterior y la asignamos en variable*/
								DECLARE @UDI_TIIEbEFOREVALUE VARCHAR(50)
								SET @UDI_TIIEbEFOREVALUE = (SELECT txtvalue  FROM @tblUDI_TIIE_Swap_Data WHERE txtcode =@ANTERIOR_INMEDIATO )
								
								/*actualizamos tabla asignando a txtvalue el resultado de la funcion*/
								UPDATE @tblUDI_TIIE_Swap_Data
								SET txtValue = 
									 CONVERT(DECIMAL(10,8),dbo.fun_Trending(@INTBNODE,@UDI_TIIEbEFOREVALUE,@INTNODE,@INTAFTNODE,@UDI_TIIE) )           
									 WHERE  intRow = @INTROW 
							/*reiniciamos variable*/
							set @UDI_TIIEbEFOREVALUE = null 
							
							FETCH CUSTOM_CURVES_CURSOR INTO @CODE,@INTROW,@INTBNODE,@INTNODE,@INTAFTNODE,@ANTERIOR_INMEDIATO,@TXTVALUE
							END
					CLOSE CUSTOM_CURVES_CURSOR
			DEALLOCATE CUSTOM_CURVES_CURSOR
			
			
			--SELECT * FROM @tblUDI_TIIE_Swap_Data
			
			
		/*Actualizamos resultado de tabla @tblUDI_TIIE_Swap_Data a @tblDirectives*/			
		UPDATE Directives
		SET Directives.txtValue = Swap.txtvalue 
		FROM 
		 @tblDirectives as Directives
		inner join @tblUDI_TIIE_Swap_Data as Swap
		on Directives.txtCode = Swap.txtcode
		and  Directives.intCol = 33
		AND Directives.intRow <= 16
		
		
		

  /*FIN DE SECCION 1 PAGINA BOFA */              
                
        
 --  -- <Sheet 2><VOL> Seccion 1 DATE                
            
 INSERT @tblDirectives                
 SELECT 02,'VOL',11,'SURFACES', 'DATEVOL',7, 6, SUBSTRING(CONVERT(CHAR(11),@dteDate,106),1,2) + '-' + SUBSTRING(CONVERT(CHAR(11),@dteDate,106),4,3) + '-' + SUBSTRING(CONVERT(CHAR(11),@dteDate,106),10,2) ,NULL,NULL,NULL,NULL                
                 
                
 ----  -- <Sheet 2><VOL> Seccion 2 SURFACES MAT/VOL                
 INSERT @tblDirectives                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 14, NULL,'MAT','VOL',1,-3 UNION                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 15, NULL,'MAT','VOL',364,-3 UNION                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 16, NULL,'MAT','VOL',728,-3 UNION                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 17, NULL,'MAT','VOL',1092,-3 UNION                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 18, NULL,'MAT','VOL',1456,-3 UNION                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 19, NULL,'MAT','VOL',1820,-3 UNION                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 20, NULL,'MAT','VOL',2548,-3 UNION                
  SELECT 02,'VOL',12,'SURFACES', 'VOLATILIDADES',4, 21, NULL,'MAT','VOL',3640,-3                
                
 --  -- <Sheet 2><VOL> Seccion 3 SURFACES MAT/VOL                
 INSERT @tblDirectives            
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 14, NULL,'MAT','VOL',1,-2 UNION          
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 15, NULL,'MAT','VOL',364,-2 UNION                
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 16, NULL,'MAT','VOL',728,-2 UNION                
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 17, NULL,'MAT','VOL',1092,-2 UNION                
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 18, NULL,'MAT','VOL',1456,-2 UNION                
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 19, NULL,'MAT','VOL',1820,-2 UNION                
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 20, NULL,'MAT','VOL',2548,-2 UNION                
  SELECT 02,'VOL',13,'SURFACES', 'VOLATILIDADES',5, 21, NULL,'MAT','VOL',3640,-2          
                
 --  -- <Sheet 2><VOL> Seccion 4 SURFACES MAT/VOL              
 INSERT @tblDirectives                
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 14, NULL,'MAT','VOL',1,-1 UNION             
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 15, NULL,'MAT','VOL',364,-1 UNION            
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 16, NULL,'MAT','VOL',728,-1 UNION                
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 17, NULL,'MAT','VOL',1092,-1 UNION             
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 18, NULL,'MAT','VOL',1456,-1 UNION                
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 19, NULL,'MAT','VOL',1820,-1 UNION             
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 20, NULL,'MAT','VOL',2548,-1 UNION                
  SELECT 02,'VOL',14,'SURFACES', 'VOLATILIDADES',6, 21, NULL,'MAT','VOL',3640,-1                
                
 --  -- <Sheet 2><VOL> Seccion 5 SURFACES MAT/VOL             
INSERT @tblDirectives                
  SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 14, NULL,'MAT','VOL',1,0 UNION              
  SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 15, NULL,'MAT','VOL',364,0 UNION                
  SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 16, NULL,'MAT','VOL',728,0 UNION                
  SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 17, NULL,'MAT','VOL',1092,0 UNION             
   SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 18, NULL,'MAT','VOL',1456,0 UNION   
  SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 19, NULL,'MAT','VOL',1820,0 UNION                
  SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 20, NULL,'MAT','VOL',2548,0 UNION                
  SELECT 02,'VOL',15,'SURFACES', 'VOLATILIDADES',7, 21, NULL,'MAT','VOL',3640,0                
                
 --  -- <Sheet 2><VOL> Seccion 6 SURFACES MAT/VOL         
 INSERT @tblDirectives                
  SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 14, NULL,'MAT','VOL',1,1 UNION                
 SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 15, NULL,'MAT','VOL',364,1 UNION                
  SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 16, NULL,'MAT','VOL',728,1 UNION                
  SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 17, NULL,'MAT','VOL',1092,1 UNION                
  SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 18, NULL,'MAT','VOL',1456,1 UNION                
  SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 19, NULL,'MAT','VOL',1820,1 UNION                
  SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 20, NULL,'MAT','VOL',2548,1 UNION                
  SELECT 02,'VOL',16,'SURFACES', 'VOLATILIDADES',8, 21, NULL,'MAT','VOL',3640,1                
                
   -- <Sheet 2><VOL> Seccion 7 SURFACES MAT/VOL             
 INSERT @tblDirectives                
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 14, NULL,'MAT','VOL',1,2 UNION             
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 15, NULL,'MAT','VOL',364,2 UNION                
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 16, NULL,'MAT','VOL',728,2 UNION                  
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 17, NULL,'MAT','VOL',1092,2 UNION                
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 18, NULL,'MAT','VOL',1456,2 UNION                
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 19, NULL,'MAT','VOL',1820,2 UNION          
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 20, NULL,'MAT','VOL',2548,2 UNION                
  SELECT 02,'VOL',17,'SURFACES', 'VOLATILIDADES',9, 21, NULL,'MAT','VOL',3640,2  UNION               
                
   -- <Sheet 2><VOL> Seccion 8 SURFACES MAT/VOL              INSERT @tblDirectives                
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 14, NULL,'MAT','VOL',1,3 UNION                
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 15, NULL,'MAT','VOL',364,3 UNION              
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 16, NULL,'MAT','VOL',728,3 UNION                
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 17, NULL,'MAT','VOL',1092,3 UNION                
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 18, NULL,'MAT','VOL',1456,3 UNION                
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 19, NULL,'MAT','VOL',1820,3 UNION                
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 20, NULL,'MAT','VOL',2548,3 UNION                
  SELECT 02,'VOL',18,'SURFACES', 'VOLATILIDADES',10, 21, NULL,'MAT','VOL',3640,3                
                
   -- <Sheet 2><VOL> Seccion 9 SURFACES SWP/VOL                
 INSERT @tblDirectives                
  SELECT 02,'VOL',19,'SURFACES', 'VOLATILIDADES',4, 26, NULL,'SWP','VOL',28,1 UNION              
  SELECT 02,'VOL',19,'SURFACES', 'VOLATILIDADES',4, 27, NULL,'SWP','VOL',84,1 UNION                
  SELECT 02,'VOL',19,'SURFACES', 'VOLATILIDADES',4, 28, NULL,'SWP','VOL',168,1 UNION                
  SELECT 02,'VOL',19,'SURFACES', 'VOLATILIDADES',4, 29, NULL,'SWP','VOL',364,1 UNION                
 SELECT 02,'VOL',19,'SURFACES', 'VOLATILIDADES',4, 30, NULL,'SWP','VOL',728,1 UNION                
  SELECT 02,'VOL',19,'SURFACES', 'VOLATILIDADES',4, 31, NULL,'SWP','VOL',1092,1 UNION                
  SELECT 02,'VOL',19,'SURFACES', 'VOLATILIDADES',4, 32, NULL,'SWP','VOL',1820,1           
                
   -- <Sheet 2><VOL> Seccion 10 SURFACES SWP/VOL                
 INSERT @tblDirectives                
  SELECT 02,'VOL',20,'SURFACES', 'VOLATILIDADES',5, 26, NULL,'SWP','VOL',28,2 UNION                
  SELECT 02,'VOL',20,'SURFACES', 'VOLATILIDADES',5, 27, NULL,'SWP','VOL',84,2 UNION                
  SELECT 02,'VOL',20,'SURFACES', 'VOLATILIDADES',5, 28, NULL,'SWP','VOL',168,2 UNION                
  SELECT 02,'VOL',20,'SURFACES', 'VOLATILIDADES',5, 29, NULL,'SWP','VOL',364,2 UNION                
  SELECT 02,'VOL',20,'SURFACES', 'VOLATILIDADES',5, 30, NULL,'SWP','VOL',728,2 UNION                
  SELECT 02,'VOL',20,'SURFACES', 'VOLATILIDADES',5, 31, NULL,'SWP','VOL',1092,2 UNION               
  SELECT 02,'VOL',20,'SURFACES', 'VOLATILIDADES',5, 32, NULL,'SWP','VOL',1820,2                
             -- <Sheet 2><VOL> Seccion 11 SURFACES SWP/VOL                
 INSERT @tblDirectives                
  SELECT 02,'VOL',21,'SURFACES', 'VOLATILIDADES',6, 26, NULL,'SWP','VOL',28,3 UNION                
  SELECT 02,'VOL',21,'SURFACES', 'VOLATILIDADES',6, 27, NULL,'SWP','VOL',84,3 UNION             
  SELECT 02,'VOL',21,'SURFACES', 'VOLATILIDADES',6, 28, NULL,'SWP','VOL',168,3 UNION                
  SELECT 02,'VOL',21,'SURFACES', 'VOLATILIDADES',6, 29, NULL,'SWP','VOL',364,3 UNION                
  SELECT 02,'VOL',21,'SURFACES', 'VOLATILIDADES',6, 30, NULL,'SWP','VOL',728,3 UNION                
  SELECT 02,'VOL',21,'SURFACES', 'VOLATILIDADES',6, 31, NULL,'SWP','VOL',1092,3 UNION      
  SELECT 02,'VOL',21,'SURFACES', 'VOLATILIDADES',6, 32, NULL,'SWP','VOL',1820,3                
                
   -- <Sheet 2><VOL> Seccion 12 SURFACES SWP/VOL                
 INSERT @tblDirectives            
 SELECT 02,'VOL',22,'SURFACES', 'VOLATILIDADES',7, 26, NULL,'SWP','VOL',28,5 UNION                
  SELECT 02,'VOL',22,'SURFACES', 'VOLATILIDADES',7, 27, NULL,'SWP','VOL',84,5 UNION         
  SELECT 02,'VOL',22,'SURFACES', 'VOLATILIDADES',7, 28, NULL,'SWP','VOL',168,5 UNION          
  SELECT 02,'VOL',22,'SURFACES', 'VOLATILIDADES',7, 29, NULL,'SWP','VOL',364,5 UNION                
  SELECT 02,'VOL',22,'SURFACES', 'VOLATILIDADES',7, 30, NULL,'SWP','VOL',728,5 UNION                
  SELECT 02,'VOL',22,'SURFACES', 'VOLATILIDADES',7, 31, NULL,'SWP','VOL',1092,5 UNION                
  SELECT 02,'VOL',22,'SURFACES', 'VOLATILIDADES',7, 32, NULL,'SWP','VOL',1820,5                
                
   -- <Sheet 2><VOL> Seccion 13 SURFACES SWP/VOL                
 INSERT @tblDirectives                
  SELECT 02,'VOL',23,'SURFACES', 'VOLATILIDADES',8, 26, NULL,'SWP','VOL',28,7 UNION                
  SELECT 02,'VOL',23,'SURFACES', 'VOLATILIDADES',8, 27, NULL,'SWP','VOL',84,7 UNION                
  SELECT 02,'VOL',23,'SURFACES', 'VOLATILIDADES',8, 28, NULL,'SWP','VOL',168,7 UNION                
  SELECT 02,'VOL',23,'SURFACES', 'VOLATILIDADES',8, 29, NULL,'SWP','VOL',364,7 UNION                
  SELECT 02,'VOL',23,'SURFACES', 'VOLATILIDADES',8, 30, NULL,'SWP','VOL',728,7 UNION                
  SELECT 02,'VOL',23,'SURFACES', 'VOLATILIDADES',8, 31, NULL,'SWP','VOL',1092,7 UNION                
  SELECT 02,'VOL',23,'SURFACES', 'VOLATILIDADES',8, 32, NULL,'SWP','VOL',1820,7                
                
   -- <Sheet 2><VOL> Seccion 14 SURFACES SWP/VOL                 
   INSERT @tblDirectives                
  SELECT 02,'VOL',24,'SURFACES', 'VOLATILIDADES',9, 26, NULL,'SWP','VOL',28,10 UNION                
  SELECT 02,'VOL',24,'SURFACES', 'VOLATILIDADES',9, 27, NULL,'SWP','VOL',84,10 UNION                
  SELECT 02,'VOL',24,'SURFACES', 'VOLATILIDADES',9, 28, NULL,'SWP','VOL',168,10 UNION                
SELECT 02,'VOL',24,'SURFACES', 'VOLATILIDADES',9, 29, NULL,'SWP','VOL',364,10 UNION             
  SELECT 02,'VOL',24,'SURFACES', 'VOLATILIDADES',9, 30, NULL,'SWP','VOL',728,10 UNION          
  SELECT 02,'VOL',24,'SURFACES', 'VOLATILIDADES',9, 31, NULL,'SWP','VOL',1092,10 UNION                
  SELECT 02,'VOL',24,'SURFACES', 'VOLATILIDADES',9, 32, NULL,'SWP','VOL',1820,10                
                
   -- <Sheet 2><VOL> Seccion 15 SURFACES SWP/VOL       
 INSERT @tblDirectives                
 SELECT 02,'VOL',25,'SURFACES', 'VOLATILIDADES',10, 26, NULL,'SWP','VOL',28,15 UNION                
  SELECT 02,'VOL',25,'SURFACES', 'VOLATILIDADES',10, 27, NULL,'SWP','VOL',84,15 UNION                
  SELECT 02,'VOL',25,'SURFACES', 'VOLATILIDADES',10, 28, NULL,'SWP','VOL',168,15 UNION                
  SELECT 02,'VOL',25,'SURFACES', 'VOLATILIDADES',10, 29, NULL,'SWP','VOL',364,15 UNION                
  SELECT 02,'VOL',25,'SURFACES', 'VOLATILIDADES',10, 30, NULL,'SWP','VOL',728,15 UNION                
  SELECT 02,'VOL',25,'SURFACES', 'VOLATILIDADES',10, 31, NULL,'SWP','VOL',1092,15 UNION        
 SELECT 02,'VOL',25,'SURFACES', 'VOLATILIDADES',10, 32, NULL,'SWP','VOL',1820,15 UNION             
                
   -- <Sheet 2><VOL> Seccion 16 SURFACES SWP/VOL           INSERT @tblDirectives                
  SELECT 02,'VOL',26,'SURFACES', 'VOLATILIDADES',11, 26, NULL,'SWP','VOL',28,20 UNION                
  SELECT 02,'VOL',26,'SURFACES', 'VOLATILIDADES',11, 27, NULL,'SWP','VOL',84,20 UNION                
  SELECT 02,'VOL',26,'SURFACES', 'VOLATILIDADES',11, 28, NULL,'SWP','VOL',168,20 UNION                
  SELECT 02,'VOL',26,'SURFACES', 'VOLATILIDADES',11, 29, NULL,'SWP','VOL',364,20 UNION                
  SELECT 02,'VOL',26,'SURFACES', 'VOLATILIDADES',11, 30, NULL,'SWP','VOL',728,20 UNION                
  SELECT 02,'VOL',26,'SURFACES', 'VOLATILIDADES',11, 31, NULL,'SWP','VOL',1092,20 UNION                
  SELECT 02,'VOL',26,'SURFACES', 'VOLATILIDADES',11, 32, NULL,'SWP','VOL',1820,20     
              
              
              
     update @tblDirectives              
     SET txtValue = ResultedValue              
     FROM @TMP_TABLE              
   WHERE intRow = IntRowtblDirectives AND intcol = IntColTemp     
    --and 1 = case when intCol =3 and intRow= 7 then 0 else 1 end          
          
               
 UPDATE d SET d.txtValue = s.dblRate                 
 FROM @tblDirectives AS d            
  INNER JOIN MxFixIncome.dbo.tblSurfaces AS s (NOLOCK)                
  ON d.type = s.txtType       
  AND d.Subtype = s.txtSubtype                
  AND d.Node = s.intTerm           
  AND d.intStrike = s.intRef               
 WHERE d.txtSource = 'SURFACES'                
  AND d.txtCode = 'VOLATILIDADES'                
  AND s.dteDate = @dteDate              
                 
              
 -- Obtengo los valores de los FRPiP por 100              
               
 UPDATE @tblDirectives                
  SET txtValue = LTRIM(STR(ROUND((SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@dteDate,112),RTRIM(Type),RTRIM(SubType),Node,'0'))*100,4),9,4))                
 FROM @tblDirectives AS FR                
 WHERE                 
  txtSource = 'CURVESx'                
                
 -- Obtengo los valores de los FRPiP                
 UPDATE @tblDirectives                
  SET txtValue = LTRIM(STR(ROUND((SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@dteDate,112),RTRIM(Type),RTRIM(SubType),Node,'0')),4),9,4))                
 FROM @tblDirectives AS FR              
 WHERE    
  txtSource = 'CURVES'                
                
 -- Obtengo los valores de los FRPiP por 10000                
 UPDATE @tblDirectives                
  SET txtValue = LTRIM(STR(ROUND((SELECT MxFixIncome.dbo.fun_get_curve_node(CONVERT(CHAR(8),@dteDate,112),RTRIM(Type),RTRIM(SubType),Node,'0'))*10000,4),9,4))                
 FROM @tblDirectives AS FR                
 WHERE               
  txtSource = 'CURVESx1'                
                
 -- correccion por datos no validos                
 UPDATE @tblDirectives                
  SET txtValue = '0.0000'                
 WHERE                 
   RTRIM(txtValue) = '-99900.00'                
                
                
 -- Valida la información                 
 IF ((SELECT count(*) FROM @tblDirectives WHERE txtValue LIKE '%-999%') > 0)           
                
 BEGIN                
  RAISERROR ('ERROR: Falta Informacion', 16, 1)                
 END              
                
 ELSE                
 BEGIN                
    -- regreso los Sheets            
    SELECT                
    LTRIM(STR(indSheet)) AS [indSheet],               
    RTRIM(SheetName) AS [SheetName]            
    FROM @tblDirectives         
    GROUP BY                 
    indSheet,SheetName                
    ORDER BY            
    indSheet,SheetName                
                
    -- regreso los limites        
   SELECT                
    intSection,                
    MIN(intCol) AS intMinCol,                
    MAX(intCol) AS intMaxCol,                
    MIN(intRow) AS intMinRow,                
    MAX(intRow) AS intMaxRow,                
    indSheet                
    FROM @tblDirectives                
    GROUP BY                 
    indSheet,intSection                
    ORDER BY                 
    indSheet,intSection                
                
   -- regreso las directivas                
   SELECT                
    LTRIM(STR(intSection)) AS [intSection],                
    LTRIM(STR(indSheet)) AS [indSheet],                
    intCol AS [intCol],            
  intRow AS [intRow],                
    RTRIM(txtValue) AS [txtValue]                
   FROM @tblDirectives                
   ORDER BY                 
    intSection,           
    indSheet,                
    intCol,                
    intRow                
                
 END                 
                
--END