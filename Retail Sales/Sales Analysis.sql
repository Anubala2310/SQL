create database sales;
use sales;

create table sales_info
(
transactions_id	int,
sale_date	date,
sale_time	time,
customer_id	int,
gender	varchar(10),
age int,	
category varchar(15),	
quantity	int,
price_per_unit int,	
cogs float,
total_sale float
);

CREATE TABLE temp_sales (
    transactions_id TEXT,
    sale_date TEXT,
    sale_time TEXT,
    customer_id TEXT,
    gender TEXT,
    age TEXT,
    category TEXT,
    quantity TEXT,
    price_per_unit TEXT,
    cogs TEXT,
    total_sale TEXT
);

select count(*)
from temp_sales;

select *
from temp_sales
limit 10;

select *
from sales_info;

update temp_sales
set
	age = nullif(age, ''),
    gender = nullif(gender, ''),
    category = nullif(category, ''),
    quantity = nullif(quantity, ''),
    price_per_unit = nullif(price_per_unit, ''),
    cogs = nullif(cogs, ''),
    total_sale = nullif(total_sale, '');
    
    
select *
from temp_sales
where
	age is null
    or gender is null
    or category is null
    or quantity is null
    or price_per_unit is null 
    or cogs is null
    or total_sale is null;
    
SELECT *
FROM temp_sales
WHERE transactions_id = '' OR transactions_id IS NULL;

insert into sales_info(
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantity,
    price_per_unit,
    cogs,
    total_sale
)
SELECT
    CAST(transactions_id AS UNSIGNED),
    STR_TO_DATE(sale_date, '%Y-%m-%d'),
    sale_time,
    CAST(customer_id AS UNSIGNED),
    gender,
    CAST(age AS UNSIGNED),
    category,
    CAST(quantity AS UNSIGNED),
    CAST(price_per_unit AS unsigned),
    CAST(cogs AS float),
    CAST(total_sale AS float)
FROM temp_sales;

select *
from sales_info;

select *
from sales_info
where
	age is null
    or gender is null
    or category is null
    or quantity is null
    or price_per_unit is null 
    or cogs is null
    or total_sale is null;
    
delete from sales_info
where
	age is null
    or gender is null
    or category is null
    or quantity is null
    or price_per_unit is null 
    or cogs is null
    or total_sale is null;
    
  -- Data Exploration
  -- How many sales details available?
select count(*)
from sales_info;

-- How many customers do we have?
select count(distinct customer_id) as total_customers
from sales_info;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select *
from sales_info
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 3 in the month of Nov-2022
select *
from sales_info
where 
	category = 'Clothing' 
	and quantity >= 3
    and sale_date between '2022-11-01' and '2022-11-30';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) total_sales, count(*) total_orders
from sales_info
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age
from sales_info
where category = 'beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from sales_info
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category, count(transactions_id) as total
from sales_info
group by 1,2
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select year(sale_date) as year, month(sale_date) as month, round(avg(total_sale),3) avg
from sales_info
group by month, year
order by year, month;

select year, month, avg
from(
	select year(sale_date) as year, 
    month(sale_date) as month, 
    round(avg(total_sale),3) avg, 
    dense_rank() over (partition by year(sale_date) order  by avg(total_sale) desc) as rnk
    from sales_info
    group by year, month) t
where rnk = 1;
    

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as highest_sales
from sales_info
group by 1
order by highest_sales desc
limit 5;

with cte as
(select  dense_rank() over( order by sum(total_sale) desc) as dnrk, customer_id, sum(total_sale) as highest_sales
from sales_info
group by 2)
select *
from cte
where dnrk <= 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) customers
from sales_info
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select case
	when hour(sale_time) <= 12
    then 'Morning'
    when hour(sale_time) between 12 and 17
    then 'Afternoon'
    else 'Evening'
    end as shift,
count(*) as num_of_orders
from sales_info
group by shift;