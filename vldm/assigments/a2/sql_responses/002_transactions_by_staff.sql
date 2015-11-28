/*
Count	the	number	of	transactions	each	staff	has	been	processing	and	find	
the	 staff	 member	 (id)	 with	 the	 biggest	 number	 of	 transactions	 and	 also	
the	staff	member	with	the	biggest	sum	of	the	transaction	value.		
*/

SELECT
	 STAFF_ID
	,COUNT(DISTINCT RENTAL_ID) AS TRANSACTIONS
	,SUM(AMOUNT) AS TOTAL_TRANSACTION_VALUE
FROM
(
	SELECT
		 R.RENTAL_ID
		,R.STAFF_ID
		-- ,R.STAFF_ID
		,S.AMOUNT
	FROM -- SELECT * FROM
		RENTAL R
	LEFT JOIN -- SELECT * FROM
		PAYMENT S
	ON R.RENTAL_ID = S.RENTAL_ID
	--WHERE AMOUNT IS NOT NULL
)_
GROUP BY
	STAFF_ID



