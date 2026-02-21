-- ========================================
-- Retail Sales SQL Analysis Project
-- Author: Firdous Abbasi
-- ========================================

-- 1. Data Cleaning
-- Date Conversion
-- Duplicate Check

-- 2. Executive KPI Dashboard
-- Total Sales, Profit, Margin

-- 3. Regional Analysis

-- 4. Product Profitability

-- 5. Loss-Making Products

-- 6. Monthly Trend Analysis

-- 7. Month-over-Month Growth

select*
from  superstore;
select count(*)
from superstore;
select count(distinct `Order ID`)
from superstore;
select min(`Order Date`),max(`Order Date`)
from superstore;
select 
row_number()
over(partition by`Row ID`,`Order ID`,`Order Date`,
     `Ship Date`,`Ship Mode`,`Customer ID`,sales,Discount,`Customer Name`
     ,Segment,Country,City,`Postal Code`,State,Region,`Product ID`,
     Category,`Sub-Category`,`Product Name`,Quantity,Profit) row_num
from superstore;
with duplicate_cte as
 (select 
 row_number()over(partition by
      `Row ID`,`Order ID`,`Order Date`,`Ship Date`,`Ship Mode`,
       `Customer ID`,sales,Discount,`Customer Name`,Segment,Country,City,
	   `Postal Code`,State,Region,`Product ID`,
	    Category,`Sub-Category`,`Product Name`,Quantity,Profit) row_num
 from superstore)
 select *
 from duplicate_cte
 where row_num>1;
 describe superstore;
 select `Order Date`
 from superstore
 limit 20;
 select`Order Date`,
 str_to_date(`Order Date`,'%m/%d/%Y')
 from superstore;
 update superstore
 set`Order Date` = str_to_date(`Order Date`,'%m/%d/%Y');
 select`Order Date`
 from superstore;
 alter table superstore
 modify column `Order Date` Date;
 select *
 from superstore;
 
 select`Ship Date`,
 str_to_date(`Ship Date`,'%m/%d/%Y')
 from superstore;
update superstore
set `Ship Date`= str_to_date(`Ship Date`,'%m/%d/%Y');
alter table superstore
modify column`Ship Date` date;
select `Ship Date`
from superstore;
select 
   sum(Sales)sum_sales,
   sum(Profit)sum_profit,
   count(distinct `Order ID`)Total_order,
   sum(Sales)/count(distinct `Order ID`) AVG_ORDER,
   sum(Profit)*100.0/sum(Sales) PROFIT_MARGIN
FROM superstore;
 
 SELECT
    Region,round(sum(Sales),2)Total_sales, 
	Round(sum(Profit),2)Total_profit, 
    round(sum(Profit)*100.0/sum(Sales),2)PROFIT_MARGIN
 FROM superstore
 group by Region
 order by Total_sales desc;
 select Region,
    round(sum(Profit)*100.0/sum(Sales),2)PROFIT_MARGIN
 from superstore;
 with margin
 as(select
    Region, round(sum(Profit)*100.0/sum(Sales),2)PROFIT_MARGIN
 from superstore
 group by Region)
 select *
 from (select Region,PROFIT_MARGIN,
 dense_rank()over(order by PROFIT_MARGIN desc) ranking
 from margin)a
 where ranking = 1;
 
 select `Product Name`,sum(Profit)Total_profit
 from superstore
 group by `Product Name`;

 with 
 product_profit as 
 ( select `Product Name`,sum(Profit)Total_profit
 from superstore
 group by `Product Name`) 
 select *
 from 
 (select `Product Name`,Total_profit,
 dense_rank()over(order by Total_profit desc) ranking
 from product_profit)a
 where ranking <= 3;
 
 select `Product Name`,sum(Profit)Total_profit,
 round(sum(Profit)*100.0/sum(Sales),2)PROFIT_MARGIN
 from superstore
 group by `Product Name`;
 with loss_making as
 (select `Product Name`,sum(Profit)total_profit,sum(Sales)total_sales,
 round(sum(Profit)*100.0/sum(Sales),2)profit_margin_parsentage
 from superstore
 group by `Product Name`)
 select*
 from loss_making
 where Total_profit<0
 order by Total_profit asc;
    
with higihest_profit_categary
as 
(select Category,sum(Sales)total_sales,
sum(Profit)total_profit,
round(sum(Profit)*100.0/sum(Sales),2)total_profit_margin
from superstore
group by Category)
select*
from (select
 Category, total_sales, total_profit, total_profit_margin
 ,dense_rank()over(order by total_profit desc) ranking
from higihest_profit_categary ) a
where ranking =1;
select 
  year(`Order Date`)order_year,month(`Order Date`)order_month,
  round(sum(Profit),2) total_profit,round(sum(sales),2)total_sales
from superstore
group by order_year
  ,order_month
order by order_year
  ,order_month;
  
with monthly_sale as 
  (select 
        year(`Order Date`)order_year,
		month(`Order Date`)order_month,
	    round(sum(Sales), 2)total_sales
 from superstore
 group by order_year,order_month),
grouth_calculation as
(select 
      order_year,order_month,total_sales ,
      lag(total_sales)over(order by order_year,order_month)previas_month_sales
from monthly_sale)
select* 
from (select order_year,
             order_month,
             total_sales,
             previas_month_sales,
             round((total_sales-previas_month_sales)*100/previas_month_sales, 2)grouth_parsentage,
			 DENSE_RANK()over(order by round((total_sales-previas_month_sales)*100/previas_month_sales ,2)desc)ranking
	   from grouth_calculation
	   where previas_month_sales is not null ) final
       where ranking = 1;
 

 
 
 
 