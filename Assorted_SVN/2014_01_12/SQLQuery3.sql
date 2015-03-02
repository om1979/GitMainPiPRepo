


SELECT * FROM  dbo.tblEquityBidAskVolume AS A

LEFT OUTER            JOIN MxProcesses.dbo.tblOwnersVsProductsDirectives AS owners2 --323
	ON a.txtId1 = owners2.txtDir  AND a.dteDate ='20140616'
	WHERE    owners2.txtOwnerId = 'db02'
		AND owners2.txtProductId = 'vpi'
		