CREATE DATABASE order_fulfillment_project;
USE order_fulfillment_project;

-- 1. Total orders
SELECT COUNT(*) AS Total_Orders
FROM order_fulfillment_cleaned;

-- 2. Average delivery time
SELECT ROUND(AVG(`Days for shipping (real)`),2) AS Avg_Delivery_Time
FROM order_fulfillment_cleaned;

-- 3. Delay by region 
SELECT
    `Order Region`,
    ROUND(AVG(Delay_Days),2) AS Avg_Delay
FROM order_fulfillment_cleaned
GROUP BY `Order Region`
ORDER BY Avg_Delay DESC;

-- 4. Delay by category
SELECT
    `Category Name`,
    ROUND(AVG(Delay_Days),2) AS Avg_Delay
FROM order_fulfillment_cleaned
GROUP BY `Category Name`
ORDER BY Avg_Delay DESC;

-- 5. Sales by Category
SELECT
    `Category Name`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM order_fulfillment_cleaned
GROUP BY `Category Name`
ORDER BY Total_Sales DESC;

-- 6. Profit by category
SELECT
    `Category Name`,
    ROUND(SUM(`Order Profit Per Order`),2) AS Total_Profit
FROM order_fulfillment_cleaned
GROUP BY `Category Name`
ORDER BY Total_Profit DESC;

-- 7. Top 10 most profitable products
SELECT
    `Product Name`,
    ROUND(SUM(`Order Profit Per Order`),2) AS Total_Profit
FROM order_fulfillment_cleaned
GROUP BY `Product Name`
ORDER BY Total_Profit DESC
LIMIT 10;

-- 8. Regions generating highest sales
SELECT
    `Order Region`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM order_fulfillment_cleaned
GROUP BY `Order Region`
ORDER BY Total_Sales DESC;

-- 9. Shipping mode usage
SELECT
    `Shipping Mode`,
    COUNT(*) AS Total_Orders
FROM order_fulfillment_cleaned
GROUP BY `Shipping Mode`
ORDER BY Total_Orders DESC;

-- 10.Categories with highest delay risk
SELECT
    `Category Name`,
    ROUND(AVG(Late_delivery_risk) * 100,2) AS Delay_Risk_Percentage
FROM order_fulfillment_cleaned
GROUP BY `Category Name`
ORDER BY Delay_Risk_Percentage DESC;
