-- Create Database
create	database Adventure_Works;
use Adventure_Works;

-- 0Q. Union of Fact Internet sales and Fact internet sales new
create table Main_Sales as 
select * 
from Sales
union all
select * 
from Sales_New;

select * from main_sales;

-- 1Q.Lookup the productname from the Product sheet to Sales sheet --
 SELECT 
    s.*, 
    p.EnglishProductName AS Product_Name
FROM main_sales s
LEFT JOIN product p 
    ON s.ProductKey = p.ProductKey;
    
  --  2Q.Lookup the Customerfullname from the Customer and Unit Price from Product sheet to Sales sheet--
SELECT
    s.*,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerFullName,
    p.`Unit Price`
FROM main_sales s
JOIN customer c
    ON s.CustomerKey = c.CustomerKey
JOIN product p
    ON s.ProductKey = p.ProductKey;
    
    -- /* 3Q.calcuate the following fields from the Orderdatekey field ( First Create a Date Field from Orderdatekey)
SELECT
    s.*,

    -- Convert to Date
    STR_TO_DATE(s.OrderDateKey, '%Y%m%d') AS OrderDate,

    -- A. Year
    YEAR(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) AS Year,

    -- B. Month Number
    MONTH(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) AS MonthNo,

    -- C. Month Full Name
    MONTHNAME(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) AS MonthFullName,

    -- D. Quarter
    CONCAT('Q', QUARTER(STR_TO_DATE(s.OrderDateKey, '%Y%m%d'))) AS Quarter,

    -- E. Year-Month (YYYY-MMM)
    DATE_FORMAT(STR_TO_DATE(s.OrderDateKey, '%Y%m%d'), '%Y-%b') AS YearMonth,

    -- F. Weekday Number (1=Sunday, 7=Saturday)
    DAYOFWEEK(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) AS WeekdayNo,

    -- G. Weekday Name
    DAYNAME(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) AS WeekdayName,

    -- H. Financial Month (April = 1)
    CASE 
        WHEN MONTH(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) >= 4 
        THEN MONTH(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) - 3
        ELSE MONTH(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) + 9
    END AS FinancialMonth,

    -- I. Financial Quarter
    CASE 
        WHEN MONTH(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) BETWEEN 4 AND 6 THEN 'Q1'
        WHEN MONTH(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) BETWEEN 7 AND 9 THEN 'Q2'
        WHEN MONTH(STR_TO_DATE(s.OrderDateKey, '%Y%m%d')) BETWEEN 10 AND 12 THEN 'Q3'
        ELSE 'Q4'
    END AS FinancialQuarter

FROM main_sales s;

-- 4Q.Calculate the Sales amount uning the columns(unit price,order quantity,unit discount)
SELECT
    s.*,
    (s.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct)) AS SalesAmount
FROM main_sales s;

-- 5Q.Calculate the Productioncost uning the columns(unit cost ,order quantity)
SELECT
    s.*,
    (s.ProductStandardCost * s.OrderQuantity) AS ProductionCost
FROM main_sales s;

-- 6Q.Calculate the profit.
SELECT
    s.*,

    -- Sales Amount
    (s.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct)) AS SalesAmount,

    -- Production Cost
    (s.ProductStandardCost * s.OrderQuantity) AS ProductionCost,

    -- Profit
    (
        (s.UnitPrice * s.OrderQuantity * (1 - s.UnitPriceDiscountPct))
        -
        (s.ProductStandardCost * s.OrderQuantity)
    ) AS Profit

FROM main_sales s;

 




