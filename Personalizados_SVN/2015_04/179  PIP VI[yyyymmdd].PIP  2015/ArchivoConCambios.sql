

/*   
 Autor:   ???  
 Creacion:  ???  
 Descripcion:    Obtiene el formato consar del vector de indices  
  
 Modificacion:  2012-02-17  
 Modificado:   Ponate  
 Descripcion:  Se amplia condicion para indices internacionales *I txtType = 'IND' txtSubType = 'EXT'  
 
 Modificacion:  20150417  
 Modificado:   Omar Adrian Aceves Gutierrez  
 Descripcion:	Se excluye el instrumento  *I LIBEUR IND del personalizado
*/  



alter  PROCEDURE dbo.sp_clsOfficialIndexFiles;1   
  
  @txtDate AS CHAR(8),
 @txtFlag AS CHAR(1)  
  
AS   
BEGIN  
  
 -- indices y trackers internacionales  
 SELECT   
  'H ' +   
  'MC' +  
  @txtDate +   
  
  RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +  
  RTRIM(SUBSTRING(i.txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(i.txtEmisora, 1, 7))) +  
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
    END,6),16,6),  ' ', '0'), 11, 6)   
  END +  
  
  '000000000000000' +   
  '000000000000' +    
  '025009' +   
  @txtFlag +   
  '000000' +  
  '00000000' +   
  
  RTRIM(i.txtId2) + REPLICATE(' ',12 - LEN(RTRIM(i.txtId2))) +  
  
  '0        ' +  
  '0      ' +  
  '0         ' AS txtRecord  
   
 FROM   
  tblIrc AS ir  
  INNER JOIN tblIds AS i  
  ON ir.txtIrc = i.txtEmisora  
  INNER JOIN tblIdsAdd AS ia  
  ON   
   i.txtId1 = ia.txtId1  
   AND ia.txtItem = 'CUR'  
   AND ia.dteDate = (  
    SELECT MAX(dteDate)  
    FROM tblIdsAdd  
    WHERE  
     txtId1 = ia.txtId1  
     AND dtedate < CAST(@txtDate AS DATETIME) + 1  
     AND txtITem = ia.txtItem  
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
    CASE ia.txtValue  
    WHEN 'USD' THEN 'UFXU'  
    WHEN 'DLL' THEN 'UFXU'  
    ELSE ia.txtValue  
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
  ir.dteDate = (  
   SELECT MAX(dteDate)  
   FROM tblIrc  
   WHERE  
    txtIrc = ir.txtIrc  
    AND dteDate <= @txtDate  
  )  
  --AND i.txtTv IN ('*I', '1I')  
  AND ((i.txtTv = ('*I') AND i.txtType = 'IND')   
   OR  
   (i.txtTv = ('1I') AND i.txtType = 'TRA'))  
  AND i.txtSubType = 'EXT'  
  AND NOT i.txtEmisora IN ('SPINTPX')  
   --agregado por oaceves para excluir  el instrumento *I LIBEUR IND
 and    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie))    not in ('*I  LIBEUR IND') 
 UNION  
   
 -- indices y trackers nacionales  
  
 SELECT   
  'H ' +   
  'MC' +  
  @txtDate +   
  
  
  RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +  
  RTRIM(SUBSTRING(i.txtEmisora, 1, 7)) + REPLICATE(' ',7 - LEN(SUBSTRING(i.txtEmisora, 1, 7))) +  
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie)) +  
  
  SUBSTRING(REPLACE(STR(ROUND(ir.dblValue,6),16,6),  ' ', '0'), 1, 9) +  
   SUBSTRING(REPLACE(STR(ROUND(ir.dblValue,6),16,6),  ' ', '0'), 11, 6) +  
  '000000000000000' +   
  '000000000000' +    
  '025009' +   
  @txtFlag +   
  '000000' +  
  '00000000' +   
  
  RTRIM(i.txtId2) + REPLICATE(' ',12 - LEN(RTRIM(i.txtId2))) +  
  
  '0        ' +  
  '0      ' +  
  '0         ' AS txtRecord  
  
 FROM  
  tblIds AS i (NOLOCK)  
  INNER JOIN tblIrcCatalog AS ic (NOLOCK)  
  ON i.txtEmisora = ic.txtIrc  
  INNER JOIN tblIrc AS ir (NOLOCK)  
  ON ic.txtIrc = ir.txtIrc   
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
 and    RTRIM(i.txtTv) + REPLICATE(' ',4 - LEN(i.txtTv)) +   
  RTRIM(i.txtEmisora) + REPLICATE(' ',7 - LEN(i.txtEmisora)) +   
  RTRIM(i.txtSerie) + REPLICATE(' ',6 - LEN(i.txtSerie))    not in ('*I  LIBEUR IND')  
  
 ORDER BY   
  txtRecord  
  
  END 