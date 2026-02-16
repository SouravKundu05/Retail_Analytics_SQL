-- createing a database for the Retail_Ananlysis Projest.
create database Retail_analysis_projct;  -- DDL command

-- select the database for useing all the query inside the databse. 
use Retail_analysis_projct;

-- import tables using the "Table Data Import Wizerd".

-- selecting  all the tables one by one for overviewing the table data.
select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction; -- DQL commands

-- START DATA CLEANING.

-- renameing the ID columns for all the three tables. they has some unnecessary character infront of them by defult.
ALTER TABLE customer_profiles
RENAME COLUMN ï»¿CustomerID TO CustomerID;

ALTER TABLE product_inventory
RENAME COLUMN ï»¿ProductID TO ProductID;

ALTER TABLE sales_transaction
RENAME COLUMN ï»¿TransactionID TO TransactionID;   -- DDL commands

-- checking duplicates for all tables. 
select CustomerID,count(*)
from customer_profiles 
group by CustomerID
having count(*)>1;    -- for customer_profiles Table. 
					  -- Result:- No duplicates.
select ProductID,count(*)
from product_inventory 
group by ProductID
having count(*)>1;    -- for product_inventory Table.
					  -- Result:- No duplicates.
select TransactionID,count(*) 
from Sales_transaction 
group by TransactionID
having count(*)>1;   -- for sales_transaction Table.
					 -- Result:- has 2 duplicates with the "TransactionID" = 4999 & 5000.

-- Removeing Duplicates.
create table new_Sales_transaction as 
select distinct * from Sales_transaction; -- creating a new table and Inserting the unique values from the old table into the new table.

drop table if exists Sales_transaction; -- dropintg the old "Sales_trasaction" table.  DDL Command.

alter table new_Sales_transaction
rename to Sales_transaction;	 -- renameing the now created table to the old name.				

-- Checking the columns for customer_profiles table.

-- checking the datatypes.
desc customer_profiles; -- finding that "Joining data column has wrong datatype as text.  --statement/keyword

-- converting the data type of the "joindata" column in custome_profile table.
alter table customer_profiles
add column JoinDate_updated date; -- add new column in the table and set the data type of the columne as "Date".

update customer_profiles
set JoinDate_updated = JoinDate; -- filling the  column with values. 

ALTER TABLE customer_profiles
DROP COLUMN JoinDate; -- deleating the old joindate column.

select distinct Gender from customer_profiles; -- column is good. -- keyword

select distinct Location from customer_profiles; -- column has missing values.

-- checking whether the missing value is a null or a blank space.
select count(*) from customer_profiles
where Location is null;                         -- condition

SET SQL_SAFE_UPDATES = 0; -- truning off the safe_update mode. -- command

-- updateing the missing value with "Unknown".
update customer_profiles
set Location = 'unknown'
where TRIM(Location) = '';

select distinct JoinDate_updated from customer_profiles; -- column is good. 

-- final check table
select * from customer_profiles;

-- Checking the columns for product_inventory table.

select * from product_inventory;
select ProductName from product_inventory where ProductName is null; -- column is good
select distinct Category from product_inventory;  -- column is good.
select StockLevel from product_inventory where StockLevel is null; -- column is good.
select Price from product_inventory where price is null; -- column is good.
																		-- "product_inventory" table is good.
                                                                
-- Checking the column for sales_transaction table.

-- checking the datatypes of all column.
desc sales_transaction; -- "TransactionDate" has datatype as "Text" which is wrong.

-- changeing the datatype. 
alter table Sales_transaction
add column TransactionDate_updated date; -- adding new blank data column.

update Sales_transaction
set TransactionDate_updated = TransactionDate; -- inserting the date in the new column.

alter table sales_transaction
drop column TransactionDate; -- droping the old date column.

-- checking nulls in the table
select TransactionID from sales_transaction where TransactionID is null; -- column is good.
select CustomerID from sales_transaction where CustomerID is null; -- column is good.
select ProductID from sales_transaction where ProductID is null; -- column is good.
select QuantityPurchased from sales_transaction where QuantityPurchased is null; -- column is good.
select TransactionDate_updated from sales_transaction where TransactionDate_updated is null; -- column is good.
select Price from sales_transaction where Price is null; -- column is good.
																			-- table is good.
-- final check table
select * from sales_transaction;

/* Q1.Write a query to "identify the discrepancies" in the price of the same product in "sales_transaction" and "product_inventory" tables. 
Also, update those discrepancies to match the price in both the tables.*/
select s.TransactionID,s.Price as TransactionPrice,p.Price as InventoryPrice
from sales_transaction s join product_inventory p
on s.ProductID = p.ProductID
where s.Price = p.Price;     -- Transactionprice and InventoryPrice are having discrepancies in it, like (3043,30.43)

update sales_transaction st
set st.Price = (select pi.Price from product_inventory pi
where st.ProductID = pi.ProductID)
where st.ProductID in (select ProductID from product_inventory i
where st.Price <> i.Price);   -- update those discrepancies to match the price in both the tables.

/* Q2.Write a SQL query to summarize the "total sale" and "quantities" sold per product by the company.*/
select ProductID,sum(QuantityPurchased) as TotalUnitsSold,
round(sum(QuantityPurchased*Price),2) as TotalSales
from Sales_transaction 
group by ProductID
order by sum(QuantityPurchased*Price) desc;

/* Q3.Write a SQL query to count the "number of transactions" per customer to understand purchase frequency.*/
select CustomerID,count(*) as NumberOfTransactions
from sales_transaction
group by CustomerID 
order by count(*) desc;

/* Q4.Write a SQL query to evaluate the "performance of the product categories" based on the total sales which help us 
understand the product categories which needs to be promoted in the marketing campaigns.*/
select p.Category, 
sum(s.QuantityPurchased) as TotalUnitsSold,
sum(s.QuantityPurchased*s.Price) as TotalSales
from Sales_transaction s join product_inventory p
on s.ProductID = p.ProductID
group by p.Category
order by TotalSales desc;

/* Q5.Write a SQL query to find the top 10 products with the "highest total sales revenue" from the sales transactions. 
This will help the company to identify the High sales products which needs to be focused to increase the revenue of the company.*/
select ProductID,
sum(QuantityPurchased*Price) as TotalRevenue
from Sales_transaction
group by ProductID
order by TotalRevenue desc
limit 10;                  -- key word

/* Q6.Write a SQL query to find the "ten products with the least amount of units sold" from the sales transactions, 
provided that at least one unit was sold for those products.*/
select ProductID,
sum(QuantityPurchased) as TotalUnitsSold
from Sales_transaction
group by ProductID
HAVING SUM(QuantityPurchased) > 0
order by TotalUnitsSold asc
limit 10;

/* Q7.Write a SQL query to identify the sales trend to understand the revenue pattern of the company.*/
select TransactionDate_updated as DATETRANS,
count(*) as Transaction_count,
sum(QuantityPurchased) as TotalUnitsSold,
sum(QuantityPurchased*Price) as TotalSales
from Sales_transaction
group by TransactionDate_updated
order by DATETRANS desc;

/* Q8.Write a SQL query to understand the "month on month growth rate of sales" of the company which will help understand the growth trend of the company.*/
with cte_t as (select month(TransactionDate_updated) as month,
round(sum(QuantityPurchased*Price),2) as total_sales
from sales_transaction
group by month(TransactionDate_updated))
select *,
lag(total_sales) over(order by month) as previous_month_sales,
round(((total_sales - lag(total_sales) over(order by month))/lag(total_sales) over(order by month))*100,2) as mom_growth_percentage
from cte_t
order by month;

/* Q9.Write a SQL query that describes the "number of transaction" along with the "total amount" spent by "each customer" which are on the higher side and 
will help us understand the customers who are the high frequency purchase customers in the company.*/
select CustomerID,
count(*) as NumberOfTransactions,
sum(QuantityPurchased*Price) as TotalSpent
from sales_transaction
group by CustomerID
having NumberOfTransactions >10 and TotalSpent >1000
order by TotalSpent desc;

/* Q10.Write a SQL query that describes the number of transaction along with the total amount spent by each customer, which will help us understand 
the customers who are "occasional customers" or have low purchase frequency in the company.*/
select CustomerID,
count(*) as NumberOfTransactions,
sum(QuantityPurchased*Price) as TotalSpent
from sales_transaction
group by CustomerID
having NumberOfTransactions <= 2
order by NumberOfTransactions asc,TotalSpent desc;

/* Q11.Write a SQL query that describes the total number of purchases made by each customer 
against each productID to understand the repeat customers in the company.*/
select CustomerID,ProductID,
count(*) as TimesPurchased
from Sales_transaction
group by CustomerID,ProductID
having TimesPurchased > 1
order by TimesPurchased desc;

/* Q12.Write a SQL query that describes the "duration" between the first and the last purchase 
of the customer in that particular company to understand the loyalty of the customer.*/
select CustomerID,
min(TransactionDate_updated) as FirstPurchase,
max(TransactionDate_updated) as LastPurchase,
datediff(max(TransactionDate_updated),min(TransactionDate_updated)) as DaysBetweenPurchases
from Sales_transaction
group by CustomerID
having DaysBetweenPurchases > 0
order by DaysBetweenPurchases desc;

/* Q13.Write an SQL query that segments customers based on the total quantity of products they have purchased. 
Also, count the number of customers in each segment which will help us target a particular segment for marketing.*/
with cet_c as (select CustomerID,sum(QuantityPurchased) as Total_quantity,
case
when sum(QuantityPurchased) > 0 and sum(QuantityPurchased) <= 10 then 'Low'
when sum(QuantityPurchased) > 10 and sum(QuantityPurchased) <= 30 then 'Med'
else 'High' end as CustomerSegment
from sales_transaction
group by CustomerID)
select CustomerSegment,
count(*) 
from cet_c
group by CustomerSegment
order by count(*) desc;