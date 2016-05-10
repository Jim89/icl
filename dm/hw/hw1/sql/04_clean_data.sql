/* Clean up lines data set ********/
drop table if exists lines_clean;
select
	 ltrim(rtrim(cust_id)) as cust_id
	,ltrim(rtrim(ordernum)) as ordernum
	,cast(order_date as date) as order_date
	,linedollars as line_dollars,lk.
	,ltrim(rtrim(gift)) as gift
	,ltrim(rtrim(recipnum)) as recipnum
into lines_clean
from
	lines;

/*
select * from lines_clean limit 100
*/

/* Clean up orders data set ********/
drop table if exists orders_clean;
select 
	 ltrim(rtrim(cust_id)) as cust_id
	,ltrim(rtrim(ordernum)) as ordernum
	,cast(order_date as date) as order_date
	,ltrim(rtrim(ordermethod)) as order_method
	,ltrim(rtrim(paymenttype)) as payment_type
into orders_clean	
from
	orders;

/*
select * from orders_clean limit 100
*/	

/* Clean up contacts data *********/
drop table if exists contacts_clean;
select
	 ltrim(rtrim(cust_id)) as cust_id
	,cast(contact_date as date) as contact_date
	,ltrim(rtrim(contact_type)) as contact_type
into contacts_clean
from
	contacts;
