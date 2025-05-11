--SQL Ratail Sales Analysis - p1

-- Create a Table
Drop TABLE IF EXISTS Retails_Sales;
Create table Retail_Sales(
			transactions_id		Int PRIMARY KEY,
			sale_date			Date,	
			sale_time			Time,	
			customer_id			Int,
			gender				Varchar(15),
			age					Int,
			category			Varchar(15),	
			quantiy				Int,
			price_per_unit		Float,	
			cogs				Float,
			total_sale			Float

);

Select * from Retail_Sales;
Select * from Retail_Sales
limit 10

Select
	count(*)
From Retail_sales

--
Select * from Retail_Sales
Where transactions_id is NULL

Select * from Retail_Sales
where sale_date is NULL

Select * From Retail_Sales
Where 
	transactions_Id is Null
	or
	sale_date is NUll
	or 
	sale_time is Null
	or
	customer_id is Null
	or 
	gender is Null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or total_sale is null

-- Data Cleaning
Delete from Retail_Sales
Where 
	transactions_Id is Null
	or
	sale_date is NUll
	or 
	sale_time is Null
	or
	customer_id is Null
	or 
	gender is Null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or total_sale is null

Select * from Retail_Sales

-- Data Exploration

-- How Many Sales We have?
Select count(*) as total_sales from Retail_sales

-- How Many Customers do we have?
Select Count(Distinct customer_id) as Total_Customer from Retail_sales

Select Distinct Category from Retail_sales

-- Data Analysis & Business Key Problem & Answers
-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- 1. Write a SQL Query to retrieve all columns for Sales made on "2022-11-05"

Select * from Retail_sales where sale_date = '2022-11-05';

/* 2. Write a SQL query to retrieve all transactions where the Category is 
'Clothing' and the Quantity Sold is more than 10 or 4 in the month of nov-2022 */

Select * 
from Retail_sales 
where category = 'Clothing' 
and quantiy > 10 
and sale_date between '2022-11-01' and '2022-11-30'

Select *
From Retail_sales
Where category = 'Clothing'
	and
	to_char(sale_date,'YYYY-MM') = '2022-11'
	and
	quantiy >= 4

-- 3. Writw a SQL query to calculate total_sale for each cateogory

Select 
	sum(total_sale), 
	category,
	Count(*) as Total_orders
from Retail_sales 
group by category

-- 4. Write a SQL query to findthe average age of Customers who purchased items from the 'Beauty' Category

Select 
	round(avg(age)) as AVG_AGE
from Retail_sales
where category = 'Beauty'

-- 5. Write a SQL query to find all the transaction wherethe total sales is greater than 1000.

Select *
from Retail_sales
where total_sale >=1000

--  6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select 
	category,
	Count(transactions_id) as Total_transaction,
	gender 
from Retail_Sales 
Group by gender, 
		 category
order by category

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM Retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales 

Select 
	customer_id,
	Sum(total_sale) as Total_sales,
	Row_number() over(order by Sum(total_sale) desc) as No,
	rank() over( order by sum(total_sale) desc) as Rank
from Retail_sales 
Group by customer_id
limit 5

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

Select 
	Count(Distinct customer_id) as Unique_Customer,
	Category
From Retail_sales
Group By category

/* 10. Write a SQL query to create each shift and number of orders 
(Example Morning <12, Afternoon Between 12 & 17, Evening >17)*/

With Hourly_sales
As
(
Select *,
	Case
		When Extract(Hour from sale_time) < 12 Then 'Morning'
		When Extract(Hour from sale_time) between 12 and 17 Then 'Afternoon'
		Else 'Evening'
	End as Shift
from Retail_Sales
)
Select
	Shift,
	Count(*) as Total_Orders
from Hourly_sales
Group by Shift

-- End of Project