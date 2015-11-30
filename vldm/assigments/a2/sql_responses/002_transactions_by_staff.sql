﻿WITH STAFF_TO_TRANSAC AS
(
SELECT
	 STAFF_ID
	,COUNT(DISTINCT PAYMENT_ID) AS TRANSACTIONS
	,SUM(AMOUNT) AS TOTAL_TRANSACTIONS
FROM
	PAYMENT
GROUP BY
	STAFF_ID
)

SELECT * 
FROM 
	STAFF_TO_TRANSAC
WHERE TRANSACTIONS = (SELECT MAX(TRANSACTIONS) FROM STAFF_TO_TRANSAC)
AND TOTAL_TRANSACTIONS = (SELECT MAX(TOTAL_TRANSACTIONS) FROM STAFF_TO_TRANSAC)




