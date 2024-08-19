# E-commerce: H+ Sport Sales insights 2015-2016

### The goal of this project is to investigate the sales performance at H+sport company to uncover key insghts and provide  strategic recommendations for future marketing campaigns.

## Table of contents
- [Project overview](#project-overview)
- [Data sources](#data-sources)
- [Tools](#tools)
- [Data Preparation](#data-preparation)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Findings](#findings)
- [Recommendations](#recommendations)

### Project overview
H+Sport  was founded in 2006  and operates an online store that sells nutritional products such as supplements, energy bars and rehydration solutions , along with active wear to meet the needs of active lifestyle consumers. You can navigate  to the H+ sport website by clicking [here](https://hplussport.com)

I have been hired to  help strategize their marketing efforts for the year. The company will like me to focus  on several key ares including product size popularity, top-selling products, sales seasonality, geographic sales distribution, product pairing trends, and customer loyalty.

### Data sources
The dataset consisted of five tables including information about the  products,customer demographics, orders, order items and saleperson information.
<img width="915" alt="dbg" src="https://github.com/user-attachments/assets/29dc6d78-5bf7-4bc1-b3c3-eb6c65f566b5">



The data sources can be found here :
Customer Data:  The primary dataset used for this analysis is the "sales_data.csv" file, containing detailed information about each sale made by the company.

### Tools
- Excel- Data Cleaning
- SQL Server- Data analysis
- Tableau- Creating reports

### Data Preparation
In the initial data preparation phase , I performed the following tasks:
1. Data loading and inspection
2. Handling missing values
3. Data cleaning and formatting
An example of one of my  codes
   
```sql
-- Find null values in Customer table
SELECT *  
FROM Customer
WHERE Email is NULL OR  LastName is NULL OR Email is NULL OR Phone Is NULL

-- Remove null values in Customer table
SELECT FirstName,
LastName,
Email,
Phone 
FROM Customer
WHERE Email IS NOT NULL AND 
Phone IS NOT NULL;
``` 

### Exploratory Data Analysis

The EDA focused on analyzing the sales data to address the following key questions:

1. **Product Size Popularity:** Which mineral water size (20 ounces or 32 ounces) is more popular among customers? This analysis will help determine whether both sizes should continue to be offered or if the focus should be on one size.
```sql
SELECT p.Size,
SUM(Quantity) as TotalQuantity
FROM OrderItem
LEFT OUTER JOIN Product p
USING (ProductID)
GROUP BY Size
ORDER BY TotalQuantity DESC;
``` 
2. **Top-Selling Products:** What are the top-selling products, and do certain flavors or sizes stand out? This insight will guide the marketing team in deciding which products to prioritize in the upcoming campaign.
 ```sql
SELECT Variety,Size,o.ProductID,sum(Quantity) as TotalQuantity
FROM OrderItem o
LEFT JOIN Product p ON o.ProductID=p.ProductID
GROUP BY o.ProductID
ORDER BY TotalQuantity DESC;
```

3. **Sales Seasonality:** During which month are sales the highest, and when would be the optimal time to launch a new product? 
```sql
SELECT
MONTHNAME(CreationDate) as MonthName,
COUNT(o.OrderID) as TotalOrders,
SUM(Quantity) as TotalQuantity,
SUM(TotalDue) as TotalAmount
FROM Orders o
JOIN OrderItem oi USING  (OrderID)
GROUP BY MonthName
ORDER BY MonthName,TotalQuantity; 
```

4. **Geographic Sales Distribution:** Which states have the highest product purchase volumes? Identifying these states will help in targeting regional marketing efforts.
```sql
SELECT State,
Count(DISTINCT OrderID) as TotalOrders,
SUM(Quantity) as TotalQuantity
FROM Orders
LEFT JOIN OrderItem using (OrderID)
LEFT JOIN Customer Using (CustomerID)
GROUp BY State
order by TotalQuantity desc
LIMIT 10
```

5. **State-Specific Preferences**: What is the most popular product in each state? Knowing this will enable more tailored marketing efforts by region
```sql
WITH RankedVarieties AS (
    SELECT 
        c.State, 
        p.Variety, 
        SUM(oi.Quantity) AS TotalQuantitySold,
        ROW_NUMBER() OVER (PARTITION BY c.State ORDER BY SUM(oi.Quantity) DESC) AS rn
    FROM 
        Orders o
    JOIN Customer c ON o.CustomerID = c.CustomerID
    JOIN OrderItem oi ON o.OrderID = oi.OrderID
    JOIN  Product p ON oi.ProductID = p.ProductID
    GROUP BY 
        c.State, p.Variety
)
SELECT 
    State, 
    Variety, 
    TotalQuantitySold
FROM 
    RankedVarieties
WHERE 
    rn = 1;
```
   
6. **Product Pairing Trends:** What products are frequently purchased together? Understanding these combinations will assist in bundling  strategies.
```sql
SELECT 
    p1.ProductID AS Product1_ID,
    p1.Variety AS Product1_Name,
    p2.ProductID AS Product2_ID,
    p2.Variety AS Product2_Name,
    COUNT(*) AS Frequency
FROM  OrderItem oi1
JOIN  OrderItem oi2 ON oi1.OrderID = oi2.OrderID AND oi1.ProductID < oi2.ProductID
JOIN  Product p1 ON oi1.ProductID = p1.ProductID
JOIN Product p2 ON oi2.ProductID = p2.ProductID
GROUP BY p1.ProductID, p1.Variety, p2.ProductID, p2.Variety
ORDER BY 
    Frequency DESC
LIMIT 5;
```

7. **Customer Loyalty Ratio:** What is the ratio of repeat customers? Specifically, what proportion of customers have made at least two purchases within a given time period? This metric will help in evaluating customer loyalty and retention.
```sql
WITH Repeat_Customers as
(
  SELECT
CustomerID as Repeat_Cus
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1
)
SELECT 
(COUNT(DISTINCT Repeat_Cus)/
COUNT(DISTINCT CustomerID))*100 as CustomerRepeatRate
FROM Orders
LEFT OUTER JOIN Repeat_Customers
ON Orders.CustomerID = Repeat_Customers.Repeat_Cus;
```

### Findings
The dashboard can be found in Tabeau public [here](https://public.tableau.com/views/Hplussportssalesdashboard/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link). This dashboard enables users to visualize state-specific preferences,geographic sales distribution, sales seasonality,sales over time and top selling products by flavour and size.

![Dashboard 1 (1)](https://github.com/user-attachments/assets/ad0ade06-00be-4e77-9ae5-896aab9136ce)

#### Insights summary

1.  The total quantity sold for 20-ounce bottles is 6,346, while the total for 32-ounce bottles is 6,206. The close figures suggest that both sizes are equally popular, indicating that customers may have no strong preference between the two sizes or that the pricing strategy is effectively balanced.

2. The top three best-selling flavors overall are **Orange**, **Raspberry**, and **Lemon-Lime**.
     - The best-selling flavor for 20-ounce bottles is **Orange**.
     - The best-selling flavor for 32-ounce bottles is **Raspberry**.

3. Sales tend to peak during the spring season, likely influenced by the weather and seasonal activities. Another significant sales surge occurs in November, driven by Black Friday and other holiday promotions.
   
4.  The states with the highest purchase volumes are Texas, New York, Florida, and California. These states likely dominate due to their larger populations and robust economic activity.

5.  **Orange** and **Raspberry** flavors are frequently bought together, suggesting a strong complementary relationship between these products.

6.  The customer retention rate is low, indicating that many customers are not making repeat purchases. This highlights an area for improvement in customer engagement and retention strategies. 

### Recommendations
Based on the analysis,I recommend the following actions:

- Since both 20-ounce and 32-ounce bottles sell at similar rates, the company should continue marketing both sizes to cater to a broad customer base.
  
- Focus marketing efforts on the most popular products, such as the top-selling flavors, and consider using Orange flavour as the flagship product to drive brand recognition and sales.
  
- Schedule new product launches during peak sales periods, particularly in the spring, to maximize visibility and sales potential.

- Develop localized advertising campaigns in high-performing states like Texas, New York, Florida, and California. Tailor these campaigns to highlight the most popular products in each region and attract new customers.

- Create bundle deals featuring frequently paired products, such as Orange and Raspberry flavors, to encourage cross-selling and increase overall sales.

- The low customer retention rate should be investigated to identify potential issues, such as product quality, customer service, or ineffective marketing efforts. Enhancing customer retention strategies, such as launching an email marketing campaign, can help keep users engaged with the brand after their initial purchase.






   






   

