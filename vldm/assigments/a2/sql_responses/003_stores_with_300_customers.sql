﻿SELECT
	 STORE_ID
	,COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS
FROM
	CUSTOMER CUST
GROUP BY STORE_ID
HAVING COUNT(DISTINCT CUSTOMER_ID) >= 300