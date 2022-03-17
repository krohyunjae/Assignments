USE AdventureWorks2019
Go

--1.
SELECT COUNT(*)
FROM Production.Product

--2.
SELECT COUNT(*)
FROM Production.Product p 
WHERE p.ProductSubcategoryID IS NOT NULL

--3.
SELECT p.ProductSubcategoryID, COUNT(*) AS CountedProducts 
FROM Production.Product p 
WHERE p.ProductSubcategoryID IS NOT NULL
GROUP BY p.ProductSubcategoryID

--4.
SELECT COUNT(*)
FROM Production.Product p 
WHERE p.ProductSubcategoryID IS NULL

--5.
SELECT SUM(p.Quantity)
FROM Production.ProductInventory p 

--6.
SELECT p.ProductID, SUM(p.Quantity) TheSum
FROM Production.ProductInventory p 
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(p.Quantity) < 100

--7.
SELECT p.Shelf, p.ProductID, SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE LocationID = 40
Group By p.Shelf, p.ProductID
HAVING SUM(p.Quantity) < 100

--8.
SELECT AVG(p.Quantity)
FROM Production.ProductInventory p
WHERE LocationID = 10

--9.
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
GROUP BY p.ProductID, p.Shelf

--10.
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.Shelf <>'N/A'
GROUP BY p.ProductID, p.Shelf

--11.
SELECT Color, Class, COUNT(ProductID) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND CLASS IS NOT NULL
GROUP BY Color, Class

--12.
SELECT c.Name AS Country, s.Name as Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode

--13.
SELECT c.Name AS Country, s.Name as Province
FROM Person.CountryRegion c INNER JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany','Canada')


USE Northwind
GO
--14.
SELECT  DISTINCT p.ProductID, p.ProductName
FROM Products p JOIN [Order Details] od 
ON p.ProductID = od.ProductID 
JOIN Orders o on od.OrderID = o.OrderID
WHERE o.OrderDate > (DATEADD(YY,-25,GETDATE()))
ORDER BY p.ProductID

--15.
SELECT TOP 5 o.ShipPostalCode
FROM Orders o
GROUP BY o.ShipPostalCode
ORDER BY COUNT(o.ShipPostalCode) DESC

--16.
SELECT TOP 5 o.ShipPostalCode
FROM Orders o
WHERE o.OrderDate > (DATEADD(YY,-25,GETDATE()))
GROUP BY o.ShipPostalCode
ORDER BY COUNT(o.ShipPostalCode) DESC

--17.
SELECT c.City, COUNT(c.CustomerID)
FROM Customers c
GROUP BY c.City

--18.
SELECT c.City, COUNT(c.CustomerID)
FROM Customers c
GROUP BY c.City
HAVING COUNT(c.CustomerID) > 2

--19.
SELECT c.ContactName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1-1-98'

--20.
SELECT c.ContactName, MAX(o.OrderDate)
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName

--21.
SELECT c.ContactName, COUNT(o.OrderID) AS ProductsPurchased
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName

--22.
SELECT c.CustomerID, COUNT(o.OrderID) AS ProductsPurchased
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID
HAVING COUNT(o.OrderID) > 100

--23.
SELECT DISTINCT sup.CompanyName AS [Supplier Company Name], ship.CompanyName AS [Shipping Company Name]
FROM Suppliers sup JOIN Products p ON sup.SupplierID = p.SupplierID
JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Shippers ship ON o.ShipVia = ship.ShipperID

--24.
SELECT o.OrderDate, p.ProductName
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderDate, p.ProductName

--25.
SELECT e1.FirstName + ' ' + e1.LastName AS [Person1], e2.FirstName + ' ' + e2.LastName AS [Person2]
FROM Employees e1, Employees e2
WHERE e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID

--26.
SELECT *
FROM Employees m ,
(SELECT m.EmployeeID
FROM Employees m, Employees e
WHERE m.EmployeeID = e.ReportsTo
GROUP BY m.EmployeeID
HAVING COUNT(e.EmployeeID) > 2) AS Manager
WHERE m.EmployeeID = Manager.EmployeeID

--27.
SELECT c.City, c.CompanyName AS [Name], c.ContactName AS [Contact Name], 'Customer' AS [Type (Customer or Supplier)]
FROM Customers c 
UNION
SELECT s.City, s.CompanyName AS [Name], s.ContactName AS [Contact Name], 'Supplier' AS [Type (Customer or Supplier)]
FROM Suppliers s