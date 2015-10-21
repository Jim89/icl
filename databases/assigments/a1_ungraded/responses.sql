-- 3.1a
select count(distinct c1), count(distinct c2), ..., count(distinct cm) from r

-- 3.1b
select count(*) from r

-- 3.1c
select c1, c2, ..., cn, count(*) from r group by rollup(c1, c2, ..., cn)

-- 3.2a
select *
from
	orders ord
inner join
	products prod
on ord.productID = prod.productID