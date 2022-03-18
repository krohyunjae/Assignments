USE Northwind
GO

--1.      List all cities that have both Employees and Customers.
SELECT City
FROM Employees
INTERSECT
SELECT City
FROM Customers

--2.      List all cities that have Customers but no Employee.
----a.      Use sub-query
Select c.City
FROM Customers c
WHERE c.City NOT IN (SELECT e.City
FROM Employees e)
GROUP BY c.City

----b.      Do not use sub-query
SELECT City
FROM Customers
EXCEPT
SELECT City
FROM Employees

--3.      List all products and their total order quantities throughout all orders.
SELECT DISTINCT p.ProductID, p.ProductName, SUM(od.Quantity)OVER(PARTITION BY p.ProductName ORDER BY p.ProductID)
FROM Products p 
LEFT OUTER JOIN [Order Details] od ON p.ProductID = od.ProductID
LEFT OUTER JOIN Orders o ON od.OrderID = o.OrderID

--4.      List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity)
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.City

--5.      List all Customer Cities that have at least two customers.
----a.      Use union
SELECT c.City
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >1
UNION
SELECT c.City
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >1

----b.      Use sub-query and no union
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City IN (SELECT c.City
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) >1)

--6.      List all Customer Cities that have ordered at least two different kinds of products.
WITH CityNumProduct AS
(
SELECT DISTINCT c.City, od.ProductID, COUNT(od.ProductID)  OVER (PARTITION BY c.City ORDER BY c.City) AS ProductCount
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
)
SELECT cp.City
FROM CityNumProduct cp
GROUP BY cp.City
HAVING COUNT(cp.ProductID) > 1

--7.      List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT c.ContactName
FROM Customers c, Orders o
WHERE c.CustomerID = o.CustomerID
AND c.City <> o.ShipCity
GROUP BY c.ContactName;

--8.      List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

SELECT c.City, od.ProductID ,SUM(od.Quantity) OVER (PARTITION BY c.City, od.ProductID ORDER BY c.City, od.ProductID, SUM(od.Quantity))
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID

SELECT TOP 5 p.ProductID, SUM(od.Quantity) AS numSold, AVG(od.UnitPrice) AS AvgPrice
FROM Products p, [Order Details] od
WHERE p.ProductID = od.ProductID 
GROUP BY p.ProductID
ORDER BY SUM(od.Quantity) DESC

SELECT c.City, od.ProductID ,SUM(od.Quantity) OVER (PARTITION BY od.ProductID ORDER BY SUM(od.Quantity))
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City, od.ProductID

SELECT top5.ProductName, top5.AvgPrice, c.City 
FROM 
(SELECT TOP 5 p.ProductName, p.ProductID, SUM(od.Quantity) AS numSold, AVG(od.UnitPrice) AS AvgPrice
FROM Products p, [Order Details] od
WHERE p.ProductID = od.ProductID 
GROUP BY p.ProductName,p.ProductID
ORDER BY SUM(od.Quantity) DESC) AS top5,
Customers c JOIN Orders o On c.CustomerID = o.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
WHERE top5.ProductID = od.ProductID





--9.      List all cities that have never ordered something but we have employees there.
----a.      Use sub-query
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (SELECT DISTINCT c.City
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID)
----b.      Do not use sub-query
SELECT e.City
FROM Employees e
EXCEPT
SELECT DISTINCT c.City
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID

--10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT citySale.City
FROM
(SELECT TOP 1 e.City
FROM Employees e, Orders o
WHERE e.EmployeeID = o.EmployeeID
GROUP BY e.City
ORDER BY COUNT(o.OrderID) DESC) AS citySale,
(
SELECT TOP 1 c.City
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.City
ORDER BY COUNT(o.OrderID)DESC) AS cityPurchase
WHERE citySale.City = cityPurchase.City

--11. How do you remove the duplicates record of a table?

-- Use CTE to find out duplicate rows and use the DELETE statement 