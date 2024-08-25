-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;


-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Data cleaning
SELECT * FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- getting day name (monday, tuesday, wednesday.....)
select date,
DAYNAME(date) as day_name
from sales;

alter table sales add column day_name varchar(15);

update sales
set day_name = DAYNAME(date);

-- getting month name (jan, feb, march,.....)

select date,
MONTHNAME(date) as month_name
from sales;

alter table sales add column month_name varchar(15);

update sales
set month_name = MONTHNAME(date);


-- questions

-- Q1. how many unique cities does the data have?
select distinct city
from sales;


-- Q2. in which city is each branch
select distinct branch, city
from sales;

-- Q3. how many unique product lines does data have?
select count(distinct product_line)
from sales;

-- Q4. what is the most common payment method?
select payment, count(payment) as cnt
from sales
group by payment
order by cnt desc
limit 1;

-- Q5. what is the most selling product line
select product_line, count(product_line) as cnt
from sales
group by product_line
order by cnt desc
limit 1;

-- Q6. what is the total revenue by month?
select sum(total), month_name
from sales
group by month_name
order by sum(total) desc;

-- 
select * from sales;

-- Q7. What month had the largest COGS?
select month_name, sum(cogs) as COGS
from sales
group by month_name
order by COGS desc
limit 1;

-- Q8. What product line had the largest revenue?
select product_line, sum(total) as revenue
from sales
group by product_line
order by revenue desc
limit 1;

-- Q9. What is the city with the largest revenue?
select branch, city, sum(total) as revenue
from sales
group by city, branch
order by revenue desc
limit 1;

-- Q10. What product line had the largest VAT?
select product_line, avg(tax_pct) as VAT
from sales
group by product_line
order by VAT desc
limit 1;

-- Q11. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select * from sales;

select avg(quantity) as qty
from sales;


select product_line,
(case
	when avg(quantity) > 6 then "good"
    else "bad"
end) as good_bad_new_col    
from sales
group by product_line;




-- Q12. Which branch sold more products (QUANTITY) than average product sold?
select branch, sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);


-- Q13. What is the most common product line by gender?
select gender, product_line, count(product_line) as cnt
from sales
group by gender, product_line
order by cnt desc ;

-- Q14. What is the average rating of each product line? 
select product_line, avg(rating) as RATING
from sales
group by product_line
order by RATING desc;


-- Q15. Number of sales made in each time of the day per weekday
select * from sales;

select time_of_day, count(*) as sales
from sales
where day_name = "Friday"
group by time_of_day
order by sales desc;

-- Q16. Which of the customer types brings the most revenue?
select customer_type, sum(total) as revenue
from sales
group by customer_type
order by revenue desc;

-- Q17. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, avg(tax_pct) as VAT
from sales
group by city
order by VAT desc;

-- Q18. Which customer type pays the most in VAT?
select customer_type, avg(tax_pct) as VAT
from sales
group by customer_type
order by VAT desc;

-- Q19. How many unique customer types does the data have?
select distinct customer_type
from sales;

-- Q20. How many unique payment methods does the data have?
select distinct payment
from sales;

-- Q21. What is the most common customer type?
select customer_type, count(customer_type) as ct
from sales
group by customer_type
order by ct desc;


-- type 2
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Q22. Which customer type buys the most?
select customer_type, count(quantity) as qty
from sales 
group by customer_type
order by qty desc;

-- Q23. What is the gender of most of the customers?
select customer_type, gender, count(gender) as cnt
from sales
group by customer_type, gender
order by cnt desc;

-- Q24. What is the gender distribution per branch?
select gender, branch, count(gender) as cnt
from sales
where branch = 'A' or branch = 'B' or branch = 'C' 
group by gender, branch
order by cnt desc;

-- Q25. Which time of the day do customers give most ratings?
select time_of_day, count(rating) as ratings
from sales
group by time_of_day
order by ratings desc;

-- Q26. Which time of the day do customers give most ratings per branch?
select time_of_day, branch, count(rating) as ratings
from sales
group by time_of_day, branch
order by ratings desc;

-- Q27. Which day fo the week has the best avg ratings?

select * from sales;

select day_name, avg(rating) as ratings
from sales
group by day_name
order by ratings desc;

-- Q28. Which day fo the week has the best avg ratings per branch?
select day_name, branch,avg(rating) as ratings
from sales
group by day_name, branch
order by ratings desc;

