 
 #sirve para obtener las rutas completas de los archivos contenidos en una unidad ("a:\")
 #donde el nombre del archivo sea como ("PreciosProductos") 
 # e intera los resultados 
 get-childitem “a:\” -recurse  |  where {$_.FullName -Match "PreciosProductos"}|foreach-object  { $_.FullName } 
 
 
 
 #una vez conseguidos los nombres se arma bat 
 #utilizando las librerias de 7zip
 # se requiere qie eñ cmd corrar desde la unicacion de las liberias 7zip
#echo off
#cd C:\Getzip\From
#7z x A:\DVD_20131231_20140113\20140108\PRECIOS\PreciosProductos20140108.rar -oc:\soft1  *_WC_MD.xls -r
#Pause
#exit
 