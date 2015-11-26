﻿SELECT COUNT(DISTINCT BK.ID) AS EVENTS
FROM
	EVENT BK
LEFT JOIN -- Return aiport information
	AIRPORT LK
ON BK.AIRPORT_ID = LK.ID
WHERE LK.COUNTRY = 'GR'
-- (GR = ISO 3166-1 alpha-2 code for Greece)

