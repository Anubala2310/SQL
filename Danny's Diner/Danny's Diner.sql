CREATE DATABASE dannys_diner;
USE dannys_diner;
SET search_path = dannys_diner;

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  
  select *
  from menu;
  
  select *
  from members;
  
  select *
  from sales;
  
-- 1. What is the total amount each customer spent at the restaurant?
-- task 1: join sales and menu
-- task 2: sum and group by

select s.customer_id, sum(m.price) as Amount_spent
from sales s
inner join menu m
using(product_id)
group by s.customer_id;

-- 2. How many days has each customer visited the restaurant?
select customer_id, count(distinct(order_date)) as no_of_visits
from sales s
group by customer_id;

-- 3. What was the first item from the menu purchased by each customer?
with CTE_1 as(
select *,
	row_number() over(partition by customer_id order by order_date asc) as rn
from sales s
inner join menu m
using(product_id))
select customer_id, product_name
from CTE_1
where rn = 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select product_name, count(*) as total_orders
from sales s
inner join menu m 
using(product_id)
group by product_name
order by total_orders desc
limit 1;

-- 5. Which item was the most popular for each customer?
with popular as
(select customer_id, product_name, count(*) as order_count, dense_rank() over( partition by customer_id order by count(*) desc) as dnrk
from sales s
inner join menu m 
using(product_id)
group by customer_id, product_name)
select customer_id, product_name
from popular
where dnrk = 1;

select customer_id, product_name, count(*) as order_count, dense_rank() over( partition by customer_id order by count(*) desc) as dnrk
from sales s
inner join menu m 
using(product_id)
group by customer_id, product_name;

-- 6. Which item was purchased first by the customer after they became a member?
with member as(
select s.customer_id,m.product_name, row_number() over(partition by s.customer_id order by order_date asc) as rn              #better query
from sales s
join menu m
using(product_id)
join members mb
on s.customer_id = mb.customer_id and s.order_date > mb.join_date)
select customer_id, product_name
from member
where rn = 1; 

select *
from sales s
join menu m
using(product_id)
join members mb
using(customer_id) 
where s.order_date > mb.join_date; 

-- 7. Which item was purchased just before the customer became a member?
with member as(
select s.customer_id, m.product_name, row_number() over(partition by customer_id order by order_date desc) as rn
from sales s
join menu m
using(product_id)
join members mb 
on s.customer_id = mb.customer_id
and s.order_date <= mb.join_date)
select customer_id, product_name
from member
where rn = 1 ;

-- 8. What is the total items and amount spent for each member before they became a member?
select s.customer_id, sum(price) as total_amt, count(*) as total_count
from sales s
join menu m
using(product_id)
join members mb 
on s.customer_id = mb.customer_id
and s.order_date < mb.join_date
group by customer_id order by customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
select customer_id,sum(
case
when product_name = 'Sushi'
then price*20
else price*10
end) as total_points
from sales s
join menu m
using(product_id)
group by customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
-- not just sushi - how many points do customer A and B have at the end of January?

select date_add(now(), interval 7 day); #future
select date_add(now(), interval -7 day); #past

select customer_id,sum(
case
when order_date between join_date and date_add(join_date, interval 7 day)
then price*20
when product_name = 'Sushi'
then price*20
else price*10
end) as total_points
from sales s
join menu m
using(product_id)
join members mb
using(customer_id)
where month(order_date) < 2
group by customer_id
order by customer_id;

select customer_id,sum(
case
when order_date between join_date and date_add(join_date, interval 7 day)
then price * 20
when product_name = 'Sushi'
then price*20
else price*10
end) as total_points
from sales s
join menu m
using(product_id)
join members as mb 
using(customer_id)
group by customer_id
order by customer_id;
order by customer_id;