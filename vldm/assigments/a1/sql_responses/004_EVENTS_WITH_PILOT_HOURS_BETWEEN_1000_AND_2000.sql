﻿SELECT COUNT(DISTINCT ID) AS EVENTS
FROM
	EVENT BK
WHERE PILOT_HOURS BETWEEN 1000 AND 2000
	