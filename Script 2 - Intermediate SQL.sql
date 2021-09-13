

-- profit = sales - total_cost
-- total_profit = profit*quantity

-- select [column_name], [aggregate_funciton]
-- from [table_name]
-- where 
-- group by 
-- order by


select *
from batch_kmb.order_details_csv limit 5;


/* Question 1
 * Get Total Sales
 */

select 
	sum(sales) as total_sales,
	sum(quantity) as total_quantity
from batch_kmb.order_details_csv;



/* Question 2
 * Get Total Profit Per Category
 * sekaligus melihatnya berdasarkan category dari yg menghasilkan profit terbesar
 */
select 
	category,
	sum(profit) as total_profit_per_category
from batch_kmb.order_details_csv
group by 1
order by 2 desc;


/* Question 3
 * What are the unique category & sub-category in table
 * yg unique mengikuti yang isi elemen di kolom yg paling banyak, yang lebih sedikit elemennya 
 */
select  distinct 
	category,
	sub_category
from batch_kmb.order_details_csv
order by 1,2;


/* Question 4
 * How Many Order ?
 * menggunakan count(distinct) karna 1 order itu bisa memesan beberapa category ataupun subcategory 
 * sehingga akan tercatat ada duplikat order_id (jumlah order_id=jumlah row untuk tiap kolom)
 */

select 
	count(distinct "?order_id") as total_order_distinct,
	count("?order_id") as total_order,
from batch_kmb.order_details_csv;

/* Question 5
 * Sort category from the highest profit to the lowest profit along with their total profit
 * ( total profit per category, sort by the largest to lowest)
 */
select 
	category,
	sum(total_profit) as total_profit_per_category
from batch_kmb.order_details_csv
group by 1
order by 2 desc;

/* Question 6
 * What is the average and median profit per order?
 */
select 
	avg(total_profit) as average_profit_per_order,
	percentile_cont(0.5) within group(order by total_profit) as median_profit_per_order
from batch_kmb.order_details_csv;

/* Question 7
 * What are the top 5 sub category with highest total profit?
 */
select 
	sub_category,
	sum(total_profit) as total_profit_sub_category
from batch_kmb.order_details_csv
group by 1
order by 2 desc 
limit 5;

/* Question 8
 * What is the total quantity sold for Category “Furniture”?
 */
select 
	category,
	sum(quantity) as total_quantity_sold
from batch_kmb.order_details_csv
where category='Furniture'
group by 1;

/* Question 9
 * Assume total profit for category Furniture is in US Dollar (1 USD = IDR 14k), 
 * but for category Office Supplies is in Pound Sterling (1 Pound Sterling = IDR 19k).
 * What is the total profit category furniture & office supplies in Rupiah? 
 * */
select 
	category,
	case 
		when category='Furniture' then sum(total_profit*14000)
		when category='Office Supplies' then sum(total_profit*19000)
	end as total_profit_per_category_in_rupiah
from batch_kmb.order_details_csv
--where category in ('Furniture', 'Office Supplies')
group by 1;

/* Question 10
 * What is the average and median profit per 1 product in 1 order?
 */
select 
	distinct("order_id" ,sub_category) as oneProduct_inOneOrder,
	avg(total_profit) as avg_total_profit_per1product_in1order,
	percentile_cont(0.5) within group (order by total_profit) as median_total_profit_per1product_in1order
from batch_kmb.order_details_csv
group by 1;

/* 1. What are the top 5 sub_category that have the highest sales, cost, and profit? (make top 5 sub_category for each metrics)
 * 
 */
select 
	sub_category,
	sum(sales) as total_sales
from batch_kmb.order_details_csv
group by 1
order by 2 desc 
limit 5;

select 
	sub_category,
	sum("Cost") as total_cost
from batch_kmb.order_details_csv
group by 1
order by 2 desc 
limit 5;

select 
	sub_category,
	sum(profit) as total_profit
from batch_kmb.order_details_csv
group by 1
order by 2 desc
limit 5;

/* What are the top 3 lowest sub_category that we need to improve their sales?
 * 
 */

select 
	sub_category,
	sum(quantity) as total_produk_terjual
from batch_kmb.order_details_csv
group by 1
order by 2 asc 
limit 3;
*/
/* Namun menurut saya untuk dapat melakukan improve terhadap penjualan, akan lebih tepat  jika yang dibandingkan itu adalah 
 * quantity/jumlah produk terjual. Karena menurut saya tidak akan imbang jika kita membandingkan jumlah penjualan(sales) tiap produk, 
 * karena tiap produk pasti memiliki harga yang berbeda. Sehingga, untuk produk-produk yang mempunyai harga mahal akan cenderung 
 * mempunyai sales yang tinggi dan sebaliknya. sedangkan cost dari tiap produk juga berbeda-beda. Jadi menurut saya jika yang diupayakan 
 * adalah untuk meningkatkan penjualan akan lebih tepat jika yang dilihat adalah dari segi jumlah item di subcategory yang terjual. 
*/

select 
	sub_category,
	sum(sales) as total_penjualan_per_subcategory
from batch_kmb.order_details_csv
group by 1
order by 2 asc 
limit 3;

/*-- atau dengan memperhatikan total profit yang dihasilkan 
*select 
*	sub_category,
*	sum(total_profit) as total_profit_per_sub_category
*from batch_kmb.order_details_csv
*group by 1
*order by 2 asc 
*limit 3;
*/

/* What are the top 3 lowest sub_category that we need to improve their orders?
 * 
 */

select 
	sub_category,
	count("﻿order_id") as total_order_per_subcategory
from batch_kmb.order_details_csv
group by sub_category 
order by 2 asc
limit 3;




/* terlihat hasil dalam upaya untuk melakukan meningkatkan pada penjualan ternyata juga berlaku pada hasil dari upaya 
 * untuk meningkatkan order. sehingga nantinya strategi promosi/upaya lain akan lebih baik difokuskan pada produk dengan 
 * subcategory Tables, Appliances, dan Machines.
 */
create table kmb_batch
