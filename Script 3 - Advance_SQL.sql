
select *
from batch_kmb.order_lists_csv olc 
left join batch_kmb.order_details_csv odc 
	on olc."order" = odc."order"
;

-- tapi kalo nama primary_key nya sama bisa pake USING(nama_kolom), ga usah pake ON ( dan otomatis yg ditampilin cuma 1 kolom order)
select *
from batch_kmb.order_lists_csv olc 
left join batch_kmb.order_details_csv odc USING("order")
;


/* Question 1
 * 1. What is the most sold category in Germany?
 */
select 
	 odc.category 
	, sum(odc.quantity) as total_qty_in_Germany
from batch_kmb.order_lists_csv olc 
left join batch_kmb.order_details_csv odc 
	on olc."order" = odc."order" 
where olc.country='Germany'
group by 1
order by 2 desc
;



/* Question 2
 * 2. What is the most ship mode for Technology Category order that received in September 2011?
 */

-----------------------
---- CARA LANGSUNG ----
-----------------------
select
	olc.ship_mode ,
	count(olc.ship_mode) as total_ShipMode_technology_sept2011 
from batch_kmb.order_lists_csv olc 
left join batch_kmb.order_details_csv odc 
	on olc."order" = odc."order" 
where 
	odc.category = 'Technology' 
	and date_part('month', to_date(order_date,'MM/DD/YYYY'))=9
	and date_part('year', to_date(order_date,'MM/DD/YYYY'))=2011
group by 1
order by 2 desc ;

------------------
---- CARA CTE ----
------------------

with
summary_order as(
	select 
		to_date(order_date,'MM/DD/YYYY') as orderdate,
		olc.ship_mode,
		odc.category,
		odc.quantity
	from batch_kmb.order_lists_csv olc 
	left join batch_kmb.order_details_csv odc
		on olc."order" = odc."order" 
)
select 
	ship_mode ,
	sum(quantity) as total_qty_perShiftMode_sept2011
from summary_order
where 
	category='Technology' 
	and date_part('month',orderdate)=9 
	and date_part('year',orderdate)=2011
group by 1
order by 2 desc;
-- kalo pake CTE setelah CTE nya jangan lupa di return mau ngambil apa (select), kalo ngga nanti error

------------------------------------------------
---- ATAU DATE_PART DIGANTI JADI DATE_TRUNC ----
------------------------------------------------

with
summary_order as(
	select 
		to_date(order_date,'MM/DD/YYYY') as orderdate,
		olc.ship_mode,
		odc.category,
		odc.quantity
	from batch_kmb.order_lists_csv olc 
	left join batch_kmb.order_details_csv odc
		on olc."order" = odc."order" 
)
select 
	ship_mode ,
	sum(quantity) as total_qty_perShiftMode_sept2011
from summary_order
where 
	category='Technology' 
	and date_trunc('month',orderdate)='2011-09-01' 
group by 1
order by 2 desc;

-- kalo pake trunc cuma butuh 1 row karna cara bacanya adalah dari bulan pada tgl 1-31 (awal-akhir bulan)
-- kalo date_trunc('week') diitung dari senin 




/* Question 3 (tambahan)
 * Latest order per each country
 */

---------------
---- 2 CTE ----
---------------
with 
orderDate as(
	select
		to_date(order_date,'MM/DD/YYYY') as orderdate,
		country
	from batch_kmb.order_lists_csv olc 
),
rownumber as(
	select 
		country,
		orderdate,
		row_number () over(partition by country order by orderdate desc) as rn
	from orderDate
)
select * 
from rownumber
where rn=1;
-- pake desc karena kalo pake asc untuk tiap negara punya order yang berbeda-beda jumlahnya

---------------
---- 1 CTE ----
---------------
with
orderDate_perCountry as(
	select 
		*,
		row_number() over(partition by country order by to_date(olc.order_date,'MM/DD/YYYY') desc) as rn
	from batch_kmb.order_lists_csv olc 
	left join batch_kmb.order_details_csv odc 
		on olc."order" = odc."order" 
)
select 
	country, 
	order_date 
from orderDate_perCountry
where rn=1;

-- tapi kekurangannya masih pake kolom order_date yang berupa string bukan date



/** Question 4
 * 3. Which country and its city has the highest order in July 2011?
 */
select 
	olc.country,
	olc.city,
	sum(odc.quantity) as total_qty
from batch_kmb.order_lists_csv olc 
left join batch_kmb.order_details_csv odc 
	on olc."order" = odc."order" 
where 
	date_part('month',to_date(olc.order_date ,'MM/DD/YYYY'))=7 
	and date_part('year',to_date(olc.order_date ,'MM/DD/YYYY'))=2011
group  by 1,2
order by 3 desc
;

/* Question 5
 * 4. What is the average of total profit for segment “Home Office”?
 */
select 
	olc.segment,
	avg(odc.total_profit) as total_profit
from batch_kmb.order_lists_csv olc 
left join batch_kmb.order_details_csv odc 
	on olc."order" = odc."order" 
where segment = 'Home Office'
group by 1;


;





 