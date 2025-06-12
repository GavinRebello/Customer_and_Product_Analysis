-- creating a data base 
create database customer_product_analysis;
use customer_product_analysis;

-- imported four tables for analysis 
select * from customers;
select * from orders; 
select * from products;
select * from order_details;

-- checking for duplicates 
select customerid, count(*) 
from customers group by customerid having count(*)>1 ;

-- checking for null values 
select *
from orders
where totalamount is null;

-- checking if null orderid is there in order_details table or not 
SELECT OrderID
FROM Orders
WHERE TotalAmount IS NULL
AND OrderID NOT IN (SELECT distinct OrderID FROM Order_Details);

-- deleting the null values as it is not in order_details table
delete from orders
where totalamount is null;

-- after removing null values from orders table 
select * from orders;

-- converting ordersdate and signupdate in date format from customers and orders table 
update customers
set signupdate = str_to_date(signupdate, '%Y-%m-%d');
update orders
set orderdate = str_to_date(orderdate, '%Y-%m-%d');


-- Now will do some EDA and solve some queries
-- Q1 What are the total number of customers
select count(*) as total_customers
from customers;

-- Q2 What are the total number of orders
select count(*) as total_orders
from orders;

-- Q3 what is the total revenue generated
select sum(totalamount) as total_revenue
from orders;

-- Q4 what are the unique product categories 
select distinct category 
from products;

-- Q5 what are number of customers by gender
select gender,count(name)  
from customers
group by gender;

-- Q6 Number of orders per city
select location, count(orderid)
from customers
join orders on (customers.customerid = orders.customerid)
group by location 
order by count(*) desc;

-- Q7 which are the top 5 customers that spends more
select name , sum(totalamount) as total_spending 
from customers 
join orders on (customers.customerid = orders.customerid)
group by name
order by total_spending desc 
limit 5;

-- Q8 what are the monthly revenue trend
SELECT DATE_FORMAT(OrderDate, '%Y-%m') AS Month, 
       SUM(TotalAmount) AS Revenue
FROM Orders
GROUP BY Month
ORDER BY Month;

-- Q9 which is the best selling product according to quantity 
select productname, sum(quantity) 
from products 
join order_details on (products.productid = order_details.productid)
group by productname
order by sum(quantity) desc limit 10;

-- Q10 what is the total revenue according to categories of product 
SELECT Category, SUM(Quantity * UnitPrice) AS Revenue
FROM Order_Details 
JOIN Products  ON (order_details.ProductID = products.ProductID)
GROUP BY Category
ORDER BY Revenue DESC;

-- Q11 how many avg items customer buys per order 
SELECT ROUND(AVG(ItemCount), 2) AS Avg_cart_size
FROM (
    SELECT OrderID, SUM(Quantity) AS ItemCount
    FROM Order_Details
    GROUP BY OrderID
) AS BasketSizes;

-- Q12 how many customers are ordering in multiple months
SELECT CustomerID, COUNT(DISTINCT DATE_FORMAT(OrderDate,'%Y-%m')) AS Active_Months
FROM Orders
GROUP BY CustomerID
ORDER BY Active_Months DESC; 

-- Q 13 which are the top 5 cities where customers spend the most on average per order.
SELECT Location, ROUND(AVG(TotalAmount), 2) AS Avg_Spend
FROM Customers 
JOIN Orders  ON (customers.CustomerID = orders.CustomerID)
GROUP BY Location
ORDER BY Avg_Spend DESC
limit 5;
