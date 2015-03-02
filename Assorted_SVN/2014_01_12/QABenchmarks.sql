
 CREATE  PROCEDURE dbo.sp_clsBencharmskQA;10    
  @txtDate AS VARCHAR(10)    
 AS     
/*     
 Autor:   ???    
 Creacion:  ???    
 Descripcion:    QA de Sospechosos    
     
 Modificado por: Csolorio    
 Modificacion: 20130121    
 Descripcion: Elimino el paquete 19 de la muestra    
*/    
 BEGIN    
    
 -- benchmarks cuyos porcentajes de participacion no suman 100%    
 SELECT     
  RTRIM(cat.txtType) + ' (' +    
  RTRIM(SUBSTRING(cat.txtDescription, 1, 15))+ ')' AS txtBench,     
  pb.txtLiquidation,      'SUMA_PONDERACION_<>100%' AS txtCriterio,    
  RTRIM(LTRIM(STR(ROUND(SUM(pb.dblPorcentaje), 2) * 100, 10, 2))) + '%' AS txtAdicInfo    
 FROM     
 tblPortafolioBench AS pb    
 INNER JOIN tblBenchCatalog AS cat    
 ON    
  pb.txtType = cat.txtType    
  AND pb.intTaxes = cat.intTaxes    
 INNER JOIN tblBenchDirectives AS bd    
 ON     
  pb.txtType = bd.txtType     
  AND pb.intTaxes = bd.intTaxes     
 WHERE    
  pb.dteDate = @txtDate    
 GROUP BY     
  cat.txtType,    
  cat.txtDescription,    
  pb.txtLiquidation    
 HAVING     
  ROUND(SUM(pb.dblPorcentaje), 2) * 100 <> 100    
    
 UNION    
    
 SELECT    
  RTRIM(cat.txtType) + ' (' + RTRIM(SUBSTRING(cat.txtDescription, 1, 15))+ ')' AS txtBench,     
  'MD y 24H' as txtLiquidation,    
  'SIN_NIVEL_HOY' AS txtCriterio,    
  'Fecha Inicio: ' + CONVERT(CHAR(10),d.dteBeg,111) + ' Fecha Fin: ' + CONVERT(CHAR(10),d.dteEnd,111) AS txtAdicInfo    
 FROM tblBenchCatalog cat (NOLOCK)    
 INNER JOIN tblBenchDirectives d (NOLOCK)    
 ON    
  cat.txtType = d.txtType    
 LEFT OUTER JOIN tblPipIndexes i (NOLOCK)    
 ON     
  d.txtType = i.txtType    
  AND i.dteDate = @txtDate    
 WHERE    
  d.fBuild = 1    
  AND d.dteEnd > @txtDate    
  AND d.dteBeg <= @txtDate    
  AND i.txtType IS NULL    
  AND d.intPack NOT IN (16,20,19)    
  --solicitud de Neri Giovanni Martínez Ramos para excluir Types  '20140813'  
  AND cat.txtType NOT IN   
  (  
'LATMEXBONDS>10Y',  
'LATMEXBONDS10Y',  
'LATMEXBONDS5Y',  
'LATMEXCETES',    
'LATMEXUDIS',   
'LATMEXUMS'      
  )  
      
 END 