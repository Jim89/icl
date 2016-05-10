/* Query to find the top 5 locations based on the average transaction amount *********/
/* N.B. data dictionary states that "SCF_Code gives the first three digits of the customer’s ZIPCode."
and so this has been used for customer location. */
select *
from
(
	select
		*
		,row_number() over(order by avg_transaction desc) as rank
	from
	(
		select
			 lk.scf_code
			,round(cast(avg(line_dollars) as decimal), 2)as avg_transaction
		from
			lines_clean bk
		left join
			summary_table lk
		on bk.cust_id = lk.cust_id
		group by
			lk.scf_code
	)_		
)_
where rank <= 5