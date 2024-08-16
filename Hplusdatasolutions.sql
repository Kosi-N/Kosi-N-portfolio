-- Remove null values
SELECT FirstName,
LastName,
Email,
Phone 
FROM Customer
WHERE Email IS NOT NULL AND 
Phone IS NOT NULL;

-- Product size popularity
SELECT p.Size,
SUM(Quantity) as TotalQuantity
FROM OrderItem
LEFT OUTER JOIN Product p
USING (ProductID)
GROUP BY Size
ORDER BY TotalQuantity DESC;

-- Top Selling Products
SELECT Variety,Size,o.ProductID,sum(Quantity) as TotalQuantity
FROM OrderItem o
LEFT JOIN Product p ON o.ProductID=p.ProductID
GROUP BY o.ProductID
ORDER BY TotalQuantity DESC;

-- Which months have the highest sales
SELECT
MONTHNAME(CreationDate) as MonthName,
COUNT(o.OrderID) as TotalOrders,
SUM(Quantity) as TotalQuantity,
SUM(TotalDue) as TotalAmount
FROM Orders o
JOIN OrderItem oi USING  (OrderID)
GROUP BY MonthName
ORDER BY MonthName,TotalQuantity; 

-- What states have the highest sales
SELECT State,
Count(DISTINCT OrderID) as TotalOrders,
SUM(Quantity) as TotalQuantity
FROM Orders
LEFT JOIN OrderItem using (OrderID)
LEFT JOIN Customer Using (CustomerID)
GROUp BY State
order by TotalQuantity desc
LIMIT 10;

-- Top selling product per state
WITH RankedVarieties AS (
    SELECT 
        c.State, 
        p.Variety, 
        SUM(oi.Quantity) AS TotalQuantitySold,
        ROW_NUMBER() OVER (PARTITION BY c.State ORDER BY SUM(oi.Quantity) DESC) AS rn
    FROM 
        Orders o
    JOIN 
        Customer c ON o.CustomerID = c.CustomerID
    JOIN 
        OrderItem oi ON o.OrderID = oi.OrderID
    JOIN 
        Product p ON oi.ProductID = p.ProductID
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

-- Products frequently bought together 
SELECT 
    p1.ProductID AS Product1_ID,
    p1.Variety AS Product1_Name,
    p2.ProductID AS Product2_ID,
    p2.Variety AS Product2_Name,
    COUNT(*) AS Frequency
FROM 
    OrderItem oi1
JOIN 
    OrderItem oi2 ON oi1.OrderID = oi2.OrderID AND oi1.ProductID < oi2.ProductID
JOIN 
    Product p1 ON oi1.ProductID = p1.ProductID
JOIN 
    Product p2 ON oi2.ProductID = p2.ProductID
GROUP BY 
    p1.ProductID, p1.Variety, p2.ProductID, p2.Variety
ORDER BY 
    Frequency DESC
LIMIT 5;

--- Customerfrequency 
WITH Repeat_Customers as
(
  SELECT
CustomerID as Repeat_Cus
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1
)
SELECT 
(COUNT(DISTINCT Repeat_Cus)/COUNT(DISTINCT CustomerID))*100 as CustomerRepeatRate
FROM Orders
LEFT OUTER JOIN Repeat_Customers
ON Orders.CustomerID = Repeat_Customers.Repeat_Cus;


