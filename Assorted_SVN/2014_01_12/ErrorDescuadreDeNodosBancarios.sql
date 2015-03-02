
---\\pipsrvmat\Soporte\Licuadoras (todo lo relacionado)




--SELECT DISTINCT
--	INZC.*
--FROM dbo.itblNodesZeroCatalog AS INZC
--INNER JOIN dbo.itblNodesZeroLevels AS INZL
--ON
--	INZC.intSerialZero = INZL.intSerialZero
--WHERE
--	INZC.txtCategory = 'REPC'
--	AND inzl.dteDate = '20141114'	



/* 
 Cliente:	Mercados
 Cubeta:	Licuadoras
 Problema:	Los niveles de CSS estan descuadrados
 Solucion:	
			1. Se revisan nodos
			2. Se insertan nodos faltantes
 Tiempo:	15 Minutos
 Status:	Cerrado
*/

-----------


SELECT distinct txtCategory
FROM
	itblNodesZEROCatalog


use mxFixincome

select 
	COUNT(DISTINCT l.intSerialZERO),
	l.dteDate
from itblNodesZEROCatalog c
inner join itblNodesZEROLevels l
on
	c.intSerialZERO = l.intSerialZERO
where
	c.txtCategory = 'BAN'
	AND c.fstatus = 1
group by
	l.dteDate
order by 
	l.dteDate

            dteDate
----------- -----------------------
10          2012-10-23 00:00:00.000
11          2012-10-24 00:00:00.000
11          2012-10-25 00:00:00.000
11          2012-10-26 00:00:00.000
11          2012-10-29 00:00:00.000
11          2012-10-30 00:00:00.000
11          2012-10-31 00:00:00.000
11          2012-11-01 00:00:00.000
11          2012-11-05 00:00:00.000
11          2012-11-06 00:00:00.000
11          2012-11-07 00:00:00.000

(11 row(s) affected)

select distinct l.intSerialZERO  from itblNodesZEROCatalog c
inner join itblNodesZEROLevels l
on
	c.intSerialZERO = l.intSerialZERO
where
	c.txtCategory = 'BAN'
	AND c.fstatus = 1
	and l.dteDate = '20121023' 

intSerialZERO
-------------
4
5
72
1216
1277
1291
1522
1525
1528
1531

(10 row(s) affected)


select distinct l.intSerialZERO  from itblNodesZEROCatalog c
inner join itblNodesZEROLevels l
on
	c.intSerialZERO = l.intSerialZERO
where
	c.txtCategory = 'BAN'
	AND c.fstatus = 1
	and l.dteDate = '20121024' 

intSerialZERO
-------------
4
5
72
1216
1277
1291
1522
1525
1528
1531
1534

(11 row(s) affected)


insert itblNodesZEROLevels values('20121023',1534,0,0,0,0,'1900-01-01 09:10:45.000')

select distinct l.intSerialZERO  
	from itblNodesZEROCatalog c
inner join itblNodesZEROLevels l
on
	c.intSerialZERO = l.intSerialZERO
where
	c.txtCategory = 'BAN'
	AND c.fstatus = 1
	and l.dteDate = '20121023' 




SELECT
	*
	INTO dbo.BKP_itblNodesZEROLevels_20120911_ponate
FROM
	itblNodesZEROLevels
	
SELECT
	*
	INTO dbo.BKPitblNodesZEROCatalog_20120911_ponate
FROM
	itblNodesZEROCatalog