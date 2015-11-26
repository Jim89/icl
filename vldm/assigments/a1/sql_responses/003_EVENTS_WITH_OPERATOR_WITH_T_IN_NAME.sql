SELECT COUNT(DISTINCT EV.ID) AS EVENTS
FROM
	EVENT EV
INNER JOIN
-- Subquery to return all owners with a 'T' in either their first or last name
(
	SELECT DISTINCT OPERATOR_CODE
	FROM	-- Select all individuals
		PERSON PERS
	LEFT JOIN -- Linking table to position code
		PERSON_POSITION LINK
	ON PERS.ID = LINK.PERSON_ID
	LEFT JOIN -- Return the position
		POSITION POS
	ON LINK.POSITION_ID = POS.ID
	-- Take only 'owners' with a 'T' in their first or last name
	WHERE POS.DESCRIPTION = 'OWNER'
	AND (FIRST_NAME LIKE '%T%' OR LAST_NAME LIKE '%T%')
) OWNERS_T
ON EV.OPERATOR_CODE = OWNERS_T.OPERATOR_CODE

