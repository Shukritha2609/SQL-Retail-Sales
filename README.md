# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `SQL_Proect_P1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE SQL_Proect_P1;

CREATE TABLE Retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantiy INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM Retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM Retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```
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

--Code
Select 
	Count(Distinct customer_id) as Unique_Customer,
	Category
From Retail_sales
Group By category

/* 10. Write a SQL query to create each shift and number of orders 
(Example Morning <12, Afternoon Between 12 & 17, Evening >17)*/

--Code

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

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.
