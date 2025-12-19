

-- TASK A. I have written the Final answer first and then the process of my queries with comments leading to my Final Answer.

-- Q1.What is the average order value for each customer who made purchases in 2016? 
-- Include the customer's ID, full name, and average order value (rounded to two decimal places) in the results. 
-- Order the results appropriately to quickly identify the customers with the highest average spending per order.

/*FINAL CODE ANSWER*/
SELECT c.CustomerID, c.CustomerName, ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) as [Avg. Order Value]
FROM Sales.Customers c
JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
JOIN Sales.OrderLines ol
ON o.OrderID = ol.OrderID
WHERE YEAR(OrderDate) = 2016 
GROUP BY c.CustomerID, c.CustomerName
ORDER BY [Avg. Order Value] desc

/*
--THE PROCESS
-- Picking out Customer ID and Name from Customers (Sales) table and selecting Transaction Amount from Customer Transactions as the Avg Order Value.
-- I initially chose Transaction Amount for the value
SELECT ct.CustomerID, c.CustomerName, AVG( ct.TransactionAmount) as [Avg. Order Value]
FROM [Sales].[CustomerTransactions] as ct
JOIN [Sales].[Customers] as c
ON ct.CustomerID = c.CustomerID
GROUP BY ct.TransactionDate, ct.CustomerID /*forgot to mention Customer Name in the GROUP BY function*/
HAVING YEAR(ct.TransactionDate) = 2016 /*took the year from the Transaction Date*/

--trying out codes with lesser columns to see if the connections were working, removed Customer Name so didnt have to use it in Group by etc & checking if WHERE gave me better results
SELECT ct.CustomerID, AVG( ct.TransactionAmount) as [Avg. Order Value]
FROM [Sales].[CustomerTransactions] as ct
JOIN [Sales].[Customers] as c
ON ct.CustomerID = c.CustomerID
WHERE YEAR(TransactionDate) = 2016
GROUP BY ct.TransactionDate, ct.CustomerID

--Simplifying the code to see what i need from the Customer Transactions table while understanding where to put Customer ID & switching to Amount Excl Tax for Avg Order Value since tax could vary according to region
SELECT CustomerID, AVG( AmountExcludingTax) as [Avg. Order Value]
FROM [Sales].[CustomerTransactions] 
WHERE YEAR(TransactionDate) = 2016
GROUP BY CustomerID
ORDER BY CustomerID

--Final Code for the answer before changing the table
SELECT ct.CustomerID, c.CustomerName, ROUND(AVG( ct.AmountExcludingTax),2) as [Avg. Order Value]
FROM [Sales].[CustomerTransactions] ct
JOIN Sales.Customers C
ON ct.CustomerID = c.CustomerID
WHERE YEAR(ct.TransactionDate) = 2016 AND ct.InvoiceID IS NOT NULL
GROUP BY ct.CustomerID, c.CustomerName
ORDER BY [Avg. Order Value] desc

-- On Piazza, a question was asked about what to take for the order value and since it mentioned to take the Order Lines table, I edited the above the code to suit it.
-- Taking this would make more sense to understand the average order value, since taking transactions would give me an average of the transaction values instead and not divide it by number of orders
-- Additionally after solving Q6, I realised my average method was wrong and changed it.
SELECT c.CustomerID, c.CustomerName, ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) as [Avg. Order Value]
FROM Sales.Customers c
JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
JOIN Sales.OrderLines ol
ON o.OrderID = ol.OrderID
WHERE YEAR(OrderDate) = 2016 
GROUP BY c.CustomerID, c.CustomerName
ORDER BY [Avg. Order Value] desc


*/
--Q2
--Which stock groups have generated the highest total sales between January 1, 2014, and December 31, 2016? 
-- Include the stock group ID, stock group name, and total sales amount in your results. Order the results suitably to identify the top-performing stock groups.


/*FINAL CODE*/
 SELECT SG.StockGroupID, SG.StockGroupName, sum(s.[Total Sales]) AS [Total Group Sales]
FROM Warehouse.StockGroups sg
    JOIN Warehouse.StockItemStockGroups sig
    ON sg.StockGroupID = sig.StockGroupID
    JOIN Warehouse.StockItems si
   ON sig.StockItemID = si.StockItemID
JOIN (SELECT StockItemID, SUM(Quantity*UnitPrice) as [Total Sales]
FROM Sales.OrderLines
Where CAST(PickingCompletedWhen AS DATE) BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY StockItemID)
	 as s
     on si.StockItemID = s.StockItemID
	 GROUP BY SG.StockGroupID, SG.StockGroupName
	 ORDER BY  [Total Group Sales] desc

	 /*
-- creating sub queries for the total amount 
SELECT OrderID, StockItemID, (Quantity * UnitPrice) as [Total Sales]
FROM Sales.OrderLines
Where CAST(PickingCompletedWhen AS DATE) BETWEEN '2014-01-01' AND '2016-12-31'
ORDER BY [Total Sales]

-- Didn't use Group by function earlier and SUM, didn't need order id
SELECT StockItemID, SUM(Quantity*UnitPrice) as [Total Sales]
FROM Sales.OrderLines
Where CAST(PickingCompletedWhen AS DATE) BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY StockItemID
ORDER BY [Total Sales]

-- inserting in join query

SELECT SG.StockGroupID, SG.StockGroupName, s.[Total Sales]
FROM Warehouse.StockGroups sg
    JOIN Warehouse.StockItemStockGroups sig
    ON sg.StockGroupID = sig.StockGroupID
    JOIN Warehouse.StockItems si
   ON sig.StockItemID = si.StockItemID
JOIN (SELECT StockItemID, SUM(Quantity*UnitPrice) as [Total Sales]
FROM Sales.OrderLines
Where CAST(PickingCompletedWhen AS DATE) BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY StockItemID
ORDER BY [Total Sales] ) /*This caused issues and was to be removed*/
	 as s
     on si.StockItemID = s.StockItemID


SELECT SG.StockGroupID, SG.StockGroupName, s.[Total Sales]
FROM Warehouse.StockGroups sg
    JOIN Warehouse.StockItemStockGroups sig
    ON sg.StockGroupID = sig.StockGroupID
    JOIN Warehouse.StockItems si
   ON sig.StockItemID = si.StockItemID
JOIN (SELECT StockItemID, SUM(Quantity*UnitPrice) as [Total Sales]
FROM Sales.OrderLines
Where CAST(PickingCompletedWhen AS DATE) BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY StockItemID)
	 as s
     on si.StockItemID = s.StockItemID
	 ORDER BY  s.[Total Sales]
--No GROUP BY clause in the above query

SELECT SG.StockGroupID, SG.StockGroupName, sum(s.[Total Sales]) AS [Total Group Sales]
FROM Warehouse.StockGroups sg
    JOIN Warehouse.StockItemStockGroups sig
    ON sg.StockGroupID = sig.StockGroupID
    JOIN Warehouse.StockItems si
   ON sig.StockItemID = si.StockItemID
JOIN (SELECT StockItemID, SUM(Quantity*UnitPrice) as [Total Sales]
FROM Sales.OrderLines
Where CAST(PickingCompletedWhen AS DATE) BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY StockItemID)
	 as s
     on si.StockItemID = s.StockItemID
	 GROUP BY SG.StockGroupID, SG.StockGroupName
	 ORDER BY  s.[Total Sales] desc /*forgot to change the name*/


	 /*FINAL CODE*/
	 SELECT SG.StockGroupID, SG.StockGroupName, sum(s.[Total Sales]) AS [Total Group Sales]
FROM Warehouse.StockGroups sg
    JOIN Warehouse.StockItemStockGroups sig
    ON sg.StockGroupID = sig.StockGroupID
    JOIN Warehouse.StockItems si
   ON sig.StockItemID = si.StockItemID
JOIN (SELECT StockItemID, SUM(Quantity*UnitPrice) as [Total Sales]
FROM Sales.OrderLines
Where CAST(PickingCompletedWhen AS DATE) BETWEEN '2014-01-01' AND '2016-12-31'
GROUP BY StockItemID)
	 as s
     on si.StockItemID = s.StockItemID
	 GROUP BY SG.StockGroupID, SG.StockGroupName
	 ORDER BY  [Total Group Sales] desc

	*/

-- Q3.List all suppliers, displaying the total sales amount for their items (if any), and order the suppliers
--by the total sales amount in descending order, ensuring that suppliers with no sales are shown with a total sales amount of zero. 


/*FINAL CODE*/
SELECT s.SupplierID, s.SupplierName, ISNULL(CAST(sum(i.[Sales Per Item]) AS INTEGER),'0')  as [Total Sales]
FROM Purchasing.Suppliers s
LEFT JOIN Warehouse.StockItems si
ON s.SupplierID = si.SupplierID
LEFT JOIN ( SELECT StockItemID, SUM(Quantity*UnitPrice) AS [Sales Per Item]
FROM Sales.InvoiceLines
GROUP BY StockItemID) as i
ON si.StockItemID = i.StockItemID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY [Total Sales] DESC

/*
SELECT SupplierID, StockItemID
FROM Warehouse.StockItems


SELECT StockItemID, SUM(Quantity*UnitPrice) AS [Sales Per Item]
FROM Sales.InvoiceLines
GROUP BY StockItemID

SELECT s.SupplierID, s.SupplierName, si.StockItemID,i.[Sales Per Item]
FROM Purchasing.Suppliers s
JOIN Warehouse.StockItems si
ON s.SupplierID = si.SupplierID
JOIN ( SELECT StockItemID, SUM(Quantity*UnitPrice) AS [Sales Per Item]
FROM Sales.InvoiceLines
GROUP BY StockItemID) as i
ON si.StockItemID = i.StockItemID
-- GROUP BY AND SUM required to get total sales of each supplier and stock item id to be removed. 
-- Left join to be applied to get the null values of suppliers and null needs to be cast as 0.

/*FINAL CODE*/
SELECT s.SupplierID, s.SupplierName, ISNULL(CAST(sum(i.[Sales Per Item]) AS INTEGER),'0')  as [Total Sales]
FROM Purchasing.Suppliers s
LEFT JOIN Warehouse.StockItems si
ON s.SupplierID = si.SupplierID
LEFT JOIN ( SELECT StockItemID, SUM(Quantity*UnitPrice) AS [Sales Per Item]
FROM Sales.InvoiceLines
GROUP BY StockItemID) as i
ON si.StockItemID = i.StockItemID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY [Total Sales] DESC
*/

--Q4. List all delivery methods and usage counts in sales invoices and purchase orders.
-- Return the delivery method ID, delivery method and the counts of their usage in both sales and purchasing. 

/*FINAL CODE*/
SELECT dm.DeliveryMethodID, dm.DeliveryMethodName, isnull(CAST(sd.[Sales Delivery] AS integer),'0') as [Sales Delivery], isnull(CAST(pd.[Purchases Delivery] AS INTEGER),'0') as [Purchases Delivery]
FROM Application.DeliveryMethods dm
LEFT JOIN (SELECT DeliveryMethodID, COUNT(DeliveryMethodID) AS [Sales Delivery]
FROM Sales.Invoices
GROUP BY DeliveryMethodID) AS sd
ON dm.DeliveryMethodID = sd.DeliveryMethodID
LEFT JOIN (SELECT  DeliveryMethodID, COUNT(DeliveryMethodID) AS [Purchases Delivery]
FROM Purchasing.PurchaseOrders
GROUP BY DeliveryMethodID) AS pd
ON dm.DeliveryMethodID = pd.DeliveryMethodID

/*
--THE PROCESS

-- Understanding the tables and what columns will be required
SELECT *
FROM Purchasing.PurchaseOrders

SELECT *
FROM Application.DeliveryMethods

SELECT *
FROM Sales.Invoices

-- creating sub-queries for easier understanding and getting the values required
SELECT DeliveryMethodID, COUNT(DeliveryMethodID) AS [Sales Delivery]
FROM Sales.Invoices
GROUP BY DeliveryMethodID

SELECT  DeliveryMethodID, COUNT(DeliveryMethodID) AS [Purchases Delivery]
FROM Purchasing.PurchaseOrders
GROUP BY DeliveryMethodID

-- combining subqueries 
SELECT dm.DeliveryMethodID, dm.DeliveryMethodName, isnull(CAST(sd.[Sales Delivery]) AS integer),'0'), isnull(CAST(pd.[Purchases Delivery]) AS INTEGER),'0') /*extra bracket before 'AS' so an issue occured*/
FROM Application.DeliveryMethods dm
LEFT JOIN (SELECT DeliveryMethodID, COUNT(DeliveryMethodID) AS [Sales Delivery]
FROM Sales.Invoices
GROUP BY DeliveryMethodID) AS sd
ON dm.DeliveryMethodID = sd.DeliveryMethodID
LEFT JOIN (SELECT  DeliveryMethodID, COUNT(DeliveryMethodID) AS [Purchases Delivery]
FROM Purchasing.PurchaseOrders
GROUP BY DeliveryMethodID) AS pd
ON dm.DeliveryMethodID = pd.DeliveryMethodID


/*FINAL CODE*/
SELECT dm.DeliveryMethodID, dm.DeliveryMethodName, isnull(CAST(sd.[Sales Delivery] AS integer),'0') as [Sales Delivery], isnull(CAST(pd.[Purchases Delivery] AS INTEGER),'0') as [Purchases Delivery]
FROM Application.DeliveryMethods dm
LEFT JOIN (SELECT DeliveryMethodID, COUNT(DeliveryMethodID) AS [Sales Delivery]
FROM Sales.Invoices
GROUP BY DeliveryMethodID) AS sd
ON dm.DeliveryMethodID = sd.DeliveryMethodID
LEFT JOIN (SELECT  DeliveryMethodID, COUNT(DeliveryMethodID) AS [Purchases Delivery]
FROM Purchasing.PurchaseOrders
GROUP BY DeliveryMethodID) AS pd
ON dm.DeliveryMethodID = pd.DeliveryMethodID
*/

-- Q5. Identify which customers purchased the most diverse range of products in 2016, and the total amount they spent.
-- Include the number of unique products each customer has bought, and the total amount spent in the results to demonstrate the diversity of products.
-- Order and filter the result set in a suitable manner to find the top 10 high-value customers. 
/*FINAL CODE*/
SELECT TOP 10 c.CustomerID, c.CustomerName,
       COUNT(DISTINCT ol.StockItemID) as [No of Items], 
	   SUM(ol.Quantity*ol.UnitPrice) as [Total Amount Spent], /*the total amount spent*/
	   ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) AS [Average Order Value] /*Calculating Avg order value to determine high value customer [Reference]*/
FROM Sales.OrderLines ol
     JOIN Sales.Orders o
     ON ol.OrderID = o.OrderID
     JOIN Sales.Customers c
     ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY c.CustomerID, c.CustomerName
ORDER BY [Average Order Value] DESC

/*
--THE PROCESS:

--Finding columns that will be needed for the required information
SELECT *
FROM Sales.Customers
SELECT *
FROM Sales.OrderLines
SELECT *
FROM Sales.InvoiceLines

-- Took the following columns to understand the data and see how to move forward
SELECT OrderID, StockItemID, Quantity, UnitPrice, PickedQuantity
FROM Sales.OrderLines 
WHERE YEAR(PickingCompletedWhen) = 2016
ORDER BY OrderID, StockItemID

-- Joining the above table with Customers to see how that goes
SELECT c.CustomerID, ol.OrderID, ol.StockItemID, ol.Quantity, ol.UnitPrice
FROM Sales.OrderLines ol
JOIN Sales.Orders o
ON ol.OrderID = o.OrderID
JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2016
ORDER BY c.CustomerID, ol.OrderID, ol.StockItemID

-- Attempt to see stock count
SELECT c.CustomerID, ol.OrderID, count(ol.StockItemID) as [No of Items] -- Order ID wasn't really required here so removed it next step
FROM Sales.OrderLines ol
JOIN Sales.Orders o
ON ol.OrderID = o.OrderID
JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY c.CustomerID, ol.OrderID 


-- Getting the count for the number of unique products each customer has bought
SELECT c.CustomerID, count(DISTINCT ol.StockItemID) as [No of Items]
FROM Sales.OrderLines ol
JOIN Sales.Orders o
ON ol.OrderID = o.OrderID
JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY c.CustomerID
ORDER BY [No of Items] DESC

/*FINAL CODE*/
SELECT TOP 10 c.CustomerID, c.CustomerName, /*Select top 10 for top 10 high value customers*/
       COUNT(DISTINCT ol.StockItemID) as [No of Items], /*Distinct since we want number of UNIQUE products*/
	   SUM(ol.Quantity*ol.UnitPrice) as [Total Amount Spent], /*the total amount spent*/
	   ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) AS [Average Order Value] /*Calculating Avg order value to determine high value customer [Reference]*/
FROM Sales.OrderLines ol
     JOIN Sales.Orders o
     ON ol.OrderID = o.OrderID
     JOIN Sales.Customers c
     ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2016 /*For orders placed in 2016*/
GROUP BY c.CustomerID, c.CustomerName
ORDER BY [No of Items] DESC

*/

--Q6. Modify your query from question 5) above to display the details of these purchases for the top 5 high-value customers. 
-- Include in your results the customer's ID and full name, the product IDs and names, the number of orders for each product, the total quantity ordered, and the total amount spent on each product. 

/*FINAL CODE*/
SELECT cc.CustomerID, cc.CustomerName, 
       sol.StockItemID as [Product ID], w.StockItemName AS [Product Name], 
	   COUNT(DISTINCT sol.OrderID) as [No of Orders] , 
	   SUM(sol.Quantity) as  [Total Qnty Ordered],
	   SUM(sol.Quantity*sol.UnitPrice) as [Total Amount per Product]
FROM Sales.OrderLines sol
 JOIN Sales.Orders so
 ON sol.OrderID = so.OrderID
 JOIN (SELECT top 5 c.CustomerID, c.CustomerName,
	      ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) AS [Average Order Value] 
           FROM Sales.OrderLines ol
           JOIN Sales.Orders o
           ON ol.OrderID = o.OrderID
            JOIN Sales.Customers c
          ON o.CustomerID = c.CustomerID
         WHERE YEAR(o.OrderDate) = 2016
         GROUP BY c.CustomerID, c.CustomerName
          ORDER BY [Average Order Value] DESC)
		  AS cc
ON so.CustomerId= cc.CustomerID
JOIN  Warehouse.StockItems w
	 ON sol.StockItemID = w.StockItemID
GROUP BY cc.CustomerID, cc.CustomerName, sol.StockItemID, w.StockItemName
ORDER BY cc.CustomerID

/*
--THE PROCESS:

--Finding other columns that will be needed for the additional columns
SELECT StockItemID, StockItemName
FROM Warehouse.StockItems

-- Getting the values needed for the latter half of the question
SELECT StockItemID, COUNT(DISTINCT OrderID) as [No of Orders] , SUM(Quantity) as  [Total Qnty Ordered], SUM(Quantity*UnitPrice) as [Total Amount per Product]
FROM Sales.OrderLines
GROUP BY StockItemID

-- Trying to add the above info to Q5 query but since I have taken Avergae Order Value to determine the top 5 customers it becomes redundant in identifying top 5 if this query is used: 
SELECT TOP 5   c.CustomerID, c.CustomerName,
			 ol.StockItemID AS [Product ID], w.StockItemName AS [Product Name],
			 COUNT(DISTINCT ol.OrderID) as [No of Orders] , 
			 SUM(ol.Quantity) as  [Total Qnty Ordered], SUM(ol.Quantity*ol.UnitPrice) as [Total Amount per Product],
	   ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) AS [Average Order Value] 
FROM Sales.OrderLines ol
     JOIN Sales.Orders o
     ON ol.OrderID = o.OrderID
     JOIN Sales.Customers c
     ON o.CustomerID = c.CustomerID
	 JOIN Warehouse.StockItems w
	 ON ol.StockItemID = w.StockItemID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY c.CustomerID, c.CustomerName, ol.StockItemID, w.StockItemName
ORDER BY [Average Order Value] DESC


-- tried to add columns i would need to Q5's query so that i could extract these columns for my final code but it didn't make sense since the top 5 results changed and it was getting too confusing to understand so quit midway
SELECT   h.CustomerID, h.CustomerName,
			 h.StockItemID AS [Product ID], w.StockItemName AS [Product Name],
			 COUNT(DISTINCT h.OrderID) as [No of Orders] , 
			 SUM(h.Quantity) as  [Total Qnty Ordered], SUM(h.Quantity* h.UnitPrice) as [Total Amount per Product]
FROM (SELECT	TOP 5 c.CustomerID, c.CustomerName, ol.StockItemID, ol.OrderID, ol.Quantity, ol.UnitPrice
	   ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) AS [Average Order Value]
FROM Sales.OrderLines ol
     JOIN Sales.Orders o
     ON ol.OrderID = o.OrderID
     JOIN Sales.Customers c
     ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY c.CustomerID, c.CustomerName
ORDER BY [Average Order Value] DESC) AS h


--Modifying Q5 to create a sub-query for the Final Query
 (SELECT top 5 c.CustomerID, c.CustomerName,
	   ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) AS [Average Order Value] /*Calculating Avg order value to determine high value customer [Reference]*/
FROM Sales.OrderLines ol
     JOIN Sales.Orders o
     ON ol.OrderID = o.OrderID
     JOIN Sales.Customers c
     ON o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) = 2016
GROUP BY c.CustomerID, c.CustomerName
ORDER BY [Average Order Value] DESC) as cc


/*FINAL CODE*/
SELECT cc.CustomerID, cc.CustomerName, 
       sol.StockItemID as [Product ID], w.StockItemName AS [Product Name], 
	   COUNT(DISTINCT sol.OrderID) as [No of Orders] , 
	   SUM(sol.Quantity) as  [Total Qnty Ordered],
	   SUM(sol.Quantity*sol.UnitPrice) as [Total Amount per Product]
FROM Sales.OrderLines sol
 JOIN Sales.Orders so
 ON sol.OrderID = so.OrderID
 JOIN (SELECT top 5 c.CustomerID, c.CustomerName,
	      ROUND(SUM(ol.Quantity*ol.UnitPrice)/COUNT(DISTINCT ol.OrderID),2) AS [Average Order Value] 
           FROM Sales.OrderLines ol
           JOIN Sales.Orders o
           ON ol.OrderID = o.OrderID
            JOIN Sales.Customers c
          ON o.CustomerID = c.CustomerID
         WHERE YEAR(o.OrderDate) = 2016
         GROUP BY c.CustomerID, c.CustomerName
          ORDER BY [Average Order Value] DESC)
		  AS cc
ON so.CustomerId= cc.CustomerID
JOIN  Warehouse.StockItems w
	 ON sol.StockItemID = w.StockItemID
GROUP BY cc.CustomerID, cc.CustomerName, sol.StockItemID, w.StockItemName
ORDER BY cc.CustomerID

*/

-- TASK C:
-- Q1. Since 2013, which are the cities with orders more than 200 
-- and what are the top 10 stock items for each of them with the total quantities sold?


-- Finding the Total Number of Orders per city
SELECT c.CityID, c.CityName, c.StateProvinceID, count(o.OrderID) as [No. of Orders]
FROM Application.Cities c
JOIN Sales.Customers sc
ON c.CityID = sc.DeliveryCityID
JOIN Sales.Orders o
ON sc.CustomerID = o.CustomerID
GROUP BY c.CityID, c.CityName, c.StateProvinceID
HAVING count(o.OrderID) > 200
ORDER BY [No. of Orders] desc;

--Final Query to get the Top 10 Stock Itens of the Top 6 Cities with Orders more than 200

SELECT 
    ri.CityName, 
    ri.StockItemName, 
    ri.TotalQuantity
FROM (SELECT
        si.StockItemID,
        si.StockItemName,
        c.CityName,
        SUM(ol.Quantity) AS TotalQuantity,
        ROW_NUMBER() OVER (PARTITION BY c.CityID ORDER BY SUM(ol.Quantity) DESC) AS ItemRank
    FROM Sales.OrderLines ol
    JOIN Sales.Orders o ON ol.OrderID = o.OrderID
    JOIN Sales.Customers sc ON o.CustomerID = sc.CustomerID
    JOIN Application.Cities c ON sc.DeliveryCityID = c.CityID
    JOIN Warehouse.StockItems si ON ol.StockItemID = si.StockItemID
    WHERE c.CityName IN ('Sinclair', 'East Fultonham', 'Akhiok', 'Teutopolis', 'Rockwall', 'Cherry Grove Beach')
    GROUP BY si.StockItemID, si.StockItemName, c.CityID, c.CityName) 
AS ri
WHERE ri.ItemRank <= 10
ORDER BY ri.CityName, ri.TotalQuantity DESC;

-- Q2. What has been the year-on-year growth across different Stock Item Groups?

-- it's one full code
SELECT f.StockGroupName, 
    SUM(CASE WHEN f.Year = 2013 THEN f.TotalPrice ELSE 0 END) AS [2013],
    SUM(CASE WHEN f.Year = 2014 THEN f.TotalPrice ELSE 0 END) AS [2014],
    SUM(CASE WHEN f.Year = 2015 THEN f.TotalPrice ELSE 0 END) AS [2015],
    -- Year-on-Year Growth
    CASE 
        WHEN SUM(CASE WHEN f.Year = 2013 THEN f.TotalPrice ELSE 0 END) = 0 THEN NULL 
        ELSE ROUND((SUM(CASE WHEN f.Year = 2014 THEN f.TotalPrice ELSE 0 END) - SUM(CASE WHEN f.Year = 2013 THEN f.TotalPrice ELSE 0 END)) 
                   / SUM(CASE WHEN f.Year = 2013 THEN f.TotalPrice ELSE 0 END) * 100, 2)
    END AS [YoY Growth 2014],
    CASE 
        WHEN SUM(CASE WHEN f.Year = 2014 THEN f.TotalPrice ELSE 0 END) = 0 THEN NULL 
        ELSE ROUND((SUM(CASE WHEN f.Year = 2015 THEN f.TotalPrice ELSE 0 END) - SUM(CASE WHEN f.Year = 2014 THEN f.TotalPrice ELSE 0 END)) 
                   / SUM(CASE WHEN f.Year = 2014 THEN f.TotalPrice ELSE 0 END) * 100, 2)
    END AS [YoY Growth 2015]
FROM (
    SELECT 
        YEAR(o.OrderDate) AS [Year],
        si.StockItemID,
        si.StockItemName,
        sgg.StockGroupName,
        SUM(ol.Quantity * ol.UnitPrice) AS TotalPrice
    FROM Sales.OrderLines ol
    JOIN Sales.Orders o ON ol.OrderID = o.OrderID
    JOIN Warehouse.StockItems si ON ol.StockItemID = si.StockItemID
    JOIN Warehouse.StockItemStockGroups sg ON si.StockItemID = sg.StockItemID
    JOIN Warehouse.StockGroups sgg ON sg.StockGroupID = sgg.StockGroupID
    GROUP BY YEAR(o.OrderDate), si.StockItemID, si.StockItemName, sgg.StockGroupName
) AS f
GROUP BY f.StockGroupName
HAVING 
    SUM(CASE WHEN f.Year = 2013 THEN f.TotalPrice ELSE 0 END) > 0 OR
    SUM(CASE WHEN f.Year = 2014 THEN f.TotalPrice ELSE 0 END) > 0 OR
    SUM(CASE WHEN f.Year = 2015 THEN f.TotalPrice ELSE 0 END) > 0 OR
    SUM(CASE WHEN f.Year = 2016 THEN f.TotalPrice ELSE 0 END) > 0
ORDER BY [YoY Growth 2015] desc;

--Q3. Were any new Stock Items added in the recent years?
-- Which Stock Item Group do they belong to and how much percentage of the sales do they contribute to in this group?

-- To find new products added.
	SELECT 
        si.StockItemID, si.StockItemName, sgg.StockGroupName,
        SUM(ol.Quantity * ol.UnitPrice) AS TotalPrice,
		   sum(CASE WHEN  YEAR(o.OrderDate) = 2013 THEN 1 ELSE 0 END) AS [2013],
    sum(CASE WHEN  YEAR(o.OrderDate)= 2014 THEN 1 ELSE 0 END) AS [2014],
    sum(CASE WHEN  YEAR(o.OrderDate) = 2015 THEN 1 ELSE 0 END) AS [2015],
	    sum(CASE WHEN YEAR(o.OrderDate)= 2016 THEN 1 ELSE 0 END) AS [2016]
    FROM Sales.OrderLines ol
    JOIN Sales.Orders o ON ol.OrderID = o.OrderID
    JOIN Warehouse.StockItems si ON ol.StockItemID = si.StockItemID
    JOIN Warehouse.StockItemStockGroups sg ON si.StockItemID = sg.StockItemID
    JOIN Warehouse.StockGroups sgg ON sg.StockGroupID = sgg.StockGroupID
    GROUP BY  si.StockItemID, si.StockItemName, sgg.StockGroupName
	ORDER BY si.StockItemID desc /*since new stock items will have a higher ID number*/


	-- To find the percentage contribution in Total Sales of Novelty Goods (the group they belong to) and rank via share %
WITH StockItemSales AS (
    SELECT 
        si.StockItemID, 
        si.StockItemName,
        sgg.StockGroupName,
        SUM(ol.Quantity * ol.UnitPrice) AS TotalSales
    FROM Sales.OrderLines ol
    JOIN Sales.Orders o ON ol.OrderID = o.OrderID
    JOIN Warehouse.StockItems si ON ol.StockItemID = si.StockItemID
    JOIN Warehouse.StockItemStockGroups sg ON si.StockItemID = sg.StockItemID
    JOIN Warehouse.StockGroups sgg ON sg.StockGroupID = sgg.StockGroupID
    WHERE sgg.StockGroupName = 'Novelty Items' AND YEAR(o.OrderDate) = 2016
    GROUP BY si.StockItemID, si.StockItemName, sgg.StockGroupName
),
TotalGroupSales AS (
    SELECT 
        StockGroupName,
        SUM(TotalSales) AS TotalGroupPrice
    FROM StockItemSales
    GROUP BY StockGroupName
),
RankedSales AS (
    SELECT 
        sis.StockItemID, 
        sis.StockItemName,
        sis.TotalSales,
        tgs.TotalGroupPrice,
        ROUND((sis.TotalSales / tgs.TotalGroupPrice) * 100, 2) AS Percentage,
        ROW_NUMBER() OVER (ORDER BY sis.TotalSales DESC) AS Rank
    FROM StockItemSales sis
    JOIN TotalGroupSales tgs ON sis.StockGroupName = tgs.StockGroupName
)
SELECT 
    StockItemID, 
    StockItemName,
    TotalSales,
    Percentage,
    Rank
FROM RankedSales
ORDER BY StockItemID desc;

-- Q4. What is the relationship between the current stock level and the total quantity sold for each clothing item?
-- Are there any items with low stock but high sales?

SELECT DISTINCT
    si.StockItemID, 
    si.StockItemName, 
    sgg.StockGroupName,  
	si.Size,
	iv.QuantityOnHand AS CurrentStockLevel,
	SUM(ol.Quantity) AS TotalQuantitySold,
	AVG(ol.UnitPrice) AS AverageUnitPrice,
    SUM (ol.Quantity * ol.UnitPrice) AS TotalSales,
	ROW_NUMBER() OVER (ORDER BY SUM (ol.Quantity * ol.UnitPrice) DESC) AS Rank,
	 CASE
WHEN iv.QuantityOnHand > SUM(ol.Quantity) THEN 'In Stock'
WHEN iv.QuantityOnHand <= SUM(ol.Quantity)THEN 'Running Out'
END AS [Stock Status]
FROM Sales.OrderLines ol
JOIN Sales.Orders o ON ol.OrderID = o.OrderID
JOIN Warehouse.StockItems si ON ol.StockItemID = si.StockItemID
JOIN Warehouse.StockItemStockGroups sg ON si.StockItemID = sg.StockItemID
JOIN Warehouse.StockGroups sgg ON sg.StockGroupID = sgg.StockGroupID
JOIN Warehouse.StockItemHoldings iv ON si.StockItemID = iv.StockItemID
GROUP BY YEAR(o.OrderDate), si.StockItemID, 
    si.StockItemName, 
    sgg.StockGroupName, si.Size, iv.QuantityOnHand
HAVING  YEAR(o.OrderDate) = '2016'
ORDER BY  CurrentStockLevel
