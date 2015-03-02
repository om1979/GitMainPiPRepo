/* 
 Cliente:	Mercados
 Cubeta:	Licuadoras
 Problema:	Los niveles de repoto con impuesto estan descuadrados
 Solucion:	
			1. Se revisan niveles
			2. Se insertan niveles faltantes en 20121218
 Tiempo:	15 Minutos
 Status:	Cerrado
*/

-----------

/*
Descuadre  Nodos Bancarios  20141120
*/


use mxFixincome
go

select distinct c.txtCategory, l.intSerialZero  from itblNodesZeroCatalog c
inner join itblNodesZeroLevels l
on
	c.intSerialZero = l.intSerialZero
where
	c.txtCategory IN ('REPC')
	AND c.fstatus = 1
	and l.dteDate = '2014-11-20' 
ORDER BY
	l.intSerialZero


SELECT DISTINCT
	INZC.*
FROM dbo.itblNodesZeroCatalog AS INZC
INNER JOIN dbo.itblNodesZeroLevels AS INZL
ON
	INZC.intSerialZero = INZL.intSerialZero
WHERE
	INZC.txtCategory = 'REPC'
	AND inzl.dteDate = '20141120'	

SELECT DISTINCT
	INZC.*
FROM dbo.itblNodesZeroCatalog AS INZC
INNER JOIN dbo.itblNodesZeroLevels AS INZL
ON
	INZC.intSerialZero = INZL.intSerialZero
WHERE
	INZC.txtCategory = 'REPS'
	AND inzl.dteDate = '20141120'	

UPDATE dbo.itblNodesZeroCatalog
SET 
	intBeg = 1,
	ffix =1
WHERE
	intSerialZero = 775



select 
	c.txtCategory,
	COUNT(DISTINCT l.intSerialZero),
	l.dteDate
from itblNodesZeroCatalog c
inner join itblNodesZeroLevels l
on
	c.intSerialZero = l.intSerialZero
where
	c.txtCategory IN ('REPC')
	AND c.fstatus = 1
	AND l.dteDate >= '20141105'
	AND c.intSerialZero IN (
	53,
	62,
	775,
	1240,
	1276,
	1292,
	1854,
	1858,
	1861,
	1864,
	1867)
group by
	l.dteDate,
	c.txtCategory
order by 
	l.dteDate


txtCategory             dteDate
----------- ----------- -----------------------
REPC        11          2014-11-05 00:00:00.000
REPC        11          2014-11-06 00:00:00.000
REPC        11          2014-11-07 00:00:00.000
REPC        11          2014-11-10 00:00:00.000
REPC        11          2014-11-11 00:00:00.000
REPC        11          2014-11-12 00:00:00.000
REPC        11          2014-11-13 00:00:00.000
REPC        11          2014-11-14 00:00:00.000
REPC        11          2014-11-18 00:00:00.000
REPC        11          2014-11-19 00:00:00.000
REPC        11          2014-11-20 00:00:00.000

(11 row(s) affected)

select distinct c.txtCategory, l.intSerialZero  from itblNodesZeroCatalog c
inner join itblNodesZeroLevels l
on
	c.intSerialZero = l.intSerialZero
where
	c.txtCategory IN ('REPC')
	AND c.fstatus = 1
	and l.dteDate = '2014-11-20' 
ORDER BY
	l.intSerialZero
	
txtCategory intSerialZero
----------- -------------
REPC        53
REPC        62
REPC        775
REPC        1240
REPC        1276
REPC        1292
REPC        1854
REPC        1858
REPC        1861
REPC        1864
REPC        1867

(11 row(s) affected)

select distinct c.txtCategory, l.intSerialZero  from itblNodesZeroCatalog c
inner join itblNodesZeroLevels l
on
	c.intSerialZero = l.intSerialZero
where
	c.txtCategory IN ('REPC')
	AND c.fstatus = 1
	and l.dteDate = '2014-11-05' 
ORDER BY
	l.intSerialZero




txtCategory intSerialZero
----------- -------------
BAN         4
BAN         5
REPS        43
REPC        53
REPC        62
BAN         72
REPS        523
REPS        524
REPC        775
BAN         1216
REPS        1218
REPC        1240
REPS        1275
REPC        1276
BAN         1277
BAN         1291
REPC        1292
REPS        1293
BAN         1546
REPC        1547
REPS        1548
BAN         1549
REPC        1550
REPS        1551
BAN         1552
REPC        1553
REPS        1554
BAN         1555
REPC        1556
REPS        1557
BAN         1558
REPC        1559
REPS        1560

(33 row(s) affected)

BAN         1558
REPC        1559
REPS        1560

insert itblNodesZeroLevels SELECT	'20121218', 1558, 0, 0, 0, 0, '1900-01-01 09:58:53.000'
insert itblNodesZeroLevels SELECT	'20121218', 1559, 0, 0, 0, 0, '1900-01-01 09:58:53.000'
insert itblNodesZeroLevels SELECT	'20121218', 1560, 0, 0, 0, 0, '1900-01-01 09:58:53.000'


select l.*  
DELETE l
from itblNodesZeroCatalog c
inner join itblNodesZeroLevels l
on
	c.intSerialZero = l.intSerialZero
where
	c.txtCategory IN ('REPS','REPC','BAN')
	AND c.fstatus = 1
	and l.dteDate = '2012-12-19' 
	AND l.intSerialZero in (1558, 1559,1560 )
	AND l.dteTime != '1900-01-01 09:58:53.000'
ORDER BY
	l.intSerialZero