select * from super_store;


--Top 5 Countries with most Sales
select Top 5 country,round(sum(sales)/1000000.00,2) as Total_Sales
from super_store
group by country
order by Total_Sales DESC;

--Top 5 most Profitable Countries
select Top 5 country,round(sum(profit)/1000000.00,2) as Total_profit
from super_store
group by country
order by Total_profit DESc

--Quantity Vs Segment
select segment,round(sum(quantity)/1000000.00,2) as Total_Quantity
from super_store
group by segment
order by Total_Quantity DESC;

--Profit vs Sales by Sub-Category
select sub_category,round(sum(sales),2) as Total_sales,round(sum(profit),2) as Total_profit
from super_store
group by sub_category 
order by Total_sales DESC;

--Total_sales
select round(sum(sales)/1000000.00,2) as Sales from super_store;

--Total_Profit
select round(sum(profit)/1000000.00,2) as Profits from super_store;

--Total_quantity
select round(sum(quantity)/1000,2) as Units from super_store;

--Total_customers
select count(distinct customer_name) as Customers from super_store;
