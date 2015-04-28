





--select * from tblprocessparameters
--where txtProcess = 'VI_PIP'


--select * from tblprocesscatalog
--where txtProcess = 'VI_PIP'

------tblprocessparameters
----txtProcess					txtParameter		txtType			txtValue
----VI_PIP						VectorFileName	STR				"VIA[FORMAT(TODAY, YYYYMMDD)].PIP"	

--helptextxmodulo sp_clsOfficialIndexFiles ,2


  
ALTER  PROCEDURE dbo.sp_clsOfficialIndexFiles;2  
   @txtDate AS VARCHAR(10) 
  
AS   
/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Obtiene el formato pip del vector de indices  
  
 Modificacion:  2012-02-17  
 Modificado:   Ponate  
 Descripcion:  Se amplia condicion para indices internacionales *I txtType = 'IND' txtSubType = 'EXT'  
*/  
  
BEGIN  
  
 -- indices y trackers internacionales  
 SELECT   
  @txtDate +  
  RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
  
  CASE i.txtTv  
  WHEN '1I' THEN  
   SUBSTRING(REPLACE(STR(ROUND(     
   CASE  
    WHEN ia1.txtValue IS NULL THEN ir.dblValue  
    ELSE i3.dblValue  
   END * i2.dblValue,6),16,6),  ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(     
    CASE  
     WHEN ia1.txtValue IS NULL THEN ir.dblValue  
     ELSE i3.dblValue  
    END * i2.dblValue,6),16,6),  ' ', '0'), 11, 6)   
  ELSE  
   SUBSTRING(REPLACE(STR(ROUND(     
   CASE  
    WHEN ia1.txtValue IS NULL THEN ir.dblValue  
    ELSE i3.dblValue  
   END,6),16,6),  ' ', '0'), 1, 9) +  
    SUBSTRING(REPLACE(STR(ROUND(     
    CASE  
     WHEN ia1.txtValue IS NULL THEN ir.dblValue  
     ELSE i3.dblValue  
    END,6),16,6), ' ', '0'), 11, 6)   
  END +  
  
  CASE  
  WHEN ia.txtValue IS NULL THEN '*M'  
  ELSE RTRIM(SUBSTRING(ia.txtValue,1,2)) + REPLICATE(' ',2 - LEN(SUBSTRING(ia.txtValue,1,2)))    
  END AS txtRecord  
 FROM   
  tblIds AS i  
  INNER JOIN tblIrc AS ir  
  ON i.txtEmisora = ir.txtIrc   
  LEFT OUTER JOIN tblIdsAdd AS ia  
  ON   
   i.txtId1 = ia.txtId1  
   AND ia.txtItem = 'COUNTRY'  
   AND ia.dteDate = (  
    SELECT MAX(dteDate)  
    FROM tblIdsAdd  
    WHERE  
     txtId1 = ia.txtId1  
     AND dtedate < CAST(@txtDate AS DATETIME) + 1  
     AND txtITem = ia.txtItem  
   )  
  INNER JOIN tblIdsAdd AS ia2  
  ON   
   i.txtId1 = ia2.txtId1  
   AND ia2.txtItem = 'CUR'  
   AND ia2.dteDate = (  
    SELECT MAX(dteDate)  
    FROM tblIdsAdd  
    WHERE  
     txtId1 = ia2.txtId1  
     AND dtedate < CAST(@txtDate AS DATETIME) + 1  
     AND txtITem = ia2.txtItem  
   )  
  LEFT OUTER JOIN tblIdsAdd ia1  
  ON   
   i.txtId1 = ia1.txtId1  
   AND ia1.txtItem = 'ALT_IRC'  
   AND ia1.dteDate = (  
    SELECT MAX(dteDate)  
    FROM tblIdsAdd  
    WHERE  
     txtId1 = ia1.txtId1  
     AND dtedate < CAST(@txtDate AS DATETIME) + 1  
     AND txtITem = ia1.txtItem  
   )  
  LEFT OUTER JOIN tblIrc AS i2  
  ON   
   i2.txtIrc = (  
    CASE ia2.txtValue  
    WHEN 'USD' THEN 'UFXU'  
    WHEN 'DLL' THEN 'UFXU'  
    ELSE ia2.txtValue  
    END      
   )  
   AND i2.dteDate = @txtDate  
  LEFT OUTER JOIN tblIrc AS i3  
  ON   
   ia1.txtValue = i3.txtIrc  
   AND i3.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblIrc  
   WHERE  
    txtIrc = i3.txtIrc  
    AND dteDate <= @txtDate  
   )  
 WHERE  
  --i.txtTv IN ('*I', '1I')  
  ((i.txtTv = ('*I') AND i.txtType = 'IND')   
   OR  
   (i.txtTv = ('1I') AND i.txtType = 'TRA'))  
  AND i.txtSubType = 'EXT'  
  AND ir.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblIrc  
   WHERE  
    txtIrc = ir.txtIrc  
    AND dteDate <= @txtDate  
  )  
  AND NOT i.txtEmisora IN ('SPINTPX')  
 		   --agregado por oaceves para excluir  el instrumento *I LIBEUR IND
			AND    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
		  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
		  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie))    not in ('*I  LIBEUR IND') 
     
 UNION  
  
 -- indices y trackers nacionales  
 SELECT   
  
  @txtDate +  
  RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
  SUBSTRING(REPLACE(STR(ROUND(ir.dblValue,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(ir.dblValue,6),16,6),  ' ', '0'), 11, 6) +  
  CASE  
  WHEN ia.txtValue IS NULL THEN '*M'  
  ELSE RTRIM(SUBSTRING(ia.txtValue,1,2)) + REPLICATE(' ',2 - LEN(SUBSTRING(ia.txtValue,1,2)))    
  END AS txtRecord  
  
 FROM  
  tblIds AS i (NOLOCK)  
  INNER JOIN tblIrcCatalog AS ic (NOLOCK)  
  ON i.txtEmisora = ic.txtIrc  
  INNER JOIN tblIrc AS ir (NOLOCK)  
  ON ic.txtIrc = ir.txtIrc   
  LEFT OUTER JOIN tblIdsAdd AS ia (NOLOCK)  
  ON   
   i.txtId1 = ia.txtId1  
   AND ia.txtItem = 'COUNTRY'  
   AND ia.dteDate = (  
    SELECT MAX(dteDate)  
    FROM tblIdsAdd (NOLOCK)  
    WHERE  
     txtId1 = ia.txtId1  
     AND dtedate < CAST(@txtDate AS DATETIME) + 1  
     AND txtITem = ia.txtItem  
   )  
 WHERE   
  ic.intIrcCategory IN (2, 6)  
  AND i.txtTv IN ('RC', '1B')  
  AND ir.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblIrc (NOLOCK)  
   WHERE  
    txtIrc = ir.txtIrc  
    AND dteDate <= @txtDate  
  )  
 		   --agregado por oaceves para excluir  el instrumento *I LIBEUR IND
			AND    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
		  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
		  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie))    not in ('*I  LIBEUR IND') 
     
  
 ORDER BY   
  txtRecord  
  
END  