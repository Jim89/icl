COPY contacts(cust_id, contact_date, contact_type)
FROM
	'C:\Users\Jleach1\Documents\icl\dm\data\hw1\DMEFExtractContactsV01.CSV'
WITH CSV HEADER

COPY lines(cust_id, ordernum, order_date, linedollars, gift, recipnum)
FROM
	'C:\Users\Jleach1\Documents\icl\dm\data\hw1\DMEFExtractLinesV01.CSV'
WITH CSV HEADER

COPY orders
FROM
	'C:\Users\Jleach1\Documents\icl\dm\data\hw1\DMEFExtractOrdersV01.CSV'
WITH CSV HEADER

