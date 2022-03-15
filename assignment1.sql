--1. Write a query that retrieves the columns ProductID, Name, 
--Color and ListPrice from the Production.Product table, with no filter. 
	
SELECT p.[ProductID], p.[Name], p.[Color], p.[ListPrice]
FROM Production.product p

--2. Write a query that retrieves the columns ProductID, Name, 
--Color and ListPrice from the Production.Product table, excludes the rows that ListPrice is 0.

SELECT p.[ProductID], p.[Name], p.[Color], p.[ListPrice]
FROM Production.product p
WHERE NOT p.[ListPrice] = 0

--3. Write a query that retrieves the columns ProductID, 
--Name, Color and ListPrice from the Production.Product table, the rows that are NULL for the Color column.

SELECT p.[ProductID], p.[Name], p.[Color], p.[ListPrice]
FROM Production.product p
WHERE p.[Color] IS NULL

--4. Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the 
--Production.Product table, the rows that are not NULL for the Color column.

SELECT p.[ProductID], p.[Name], p.[Color], p.[ListPrice]
FROM Production.product p
WHERE p.[Color] IS NOT NULL

--5.Write a query that retrieves the columns ProductID, Name, Color and ListPrice from the Production.Product table,
--the rows that are not NULL for the column Color, and the column ListPrice has a value greater than zero.

SELECT p.[ProductID], p.[Name], p.[Color], p.[ListPrice]
FROM Production.product p
WHERE p.[Color] IS NOT NULL AND p.[ListPrice] > 0

--6. Write a query that concatenates the columns Name and Color from the Production.Product table
--by excluding the rows that are null for color.

SELECT p.[Name] + p.[Color]
FROM Production.Product p
WHERE p.[Color] IS NOT NULL

--7.
SELECT 'NAME: '+ p.[Name]+ ' -- COLOR: ' + p.[Color]
FROM Production.Product p
WHERE p.[Color] IN('Black','Silver') AND p.[Name] LIKE '___Crankarm' OR p.[Name] LIKE 'Chainring%'

--8. 
SELECT  p.[ProductID],p.[Name]
FROM Production.Product p
WHERE p.ProductID BETWEEN 400 AND 500

--9.
SELECT p.[ProductID], p.[Name], p.[Color]
FROM Production.Product p
WHERE p.[Color] IN ('Black','Blue')

--10.
SELECT *
FROM Production.Product p
WHERE p.[Name] LIKE 'S%'

--11.
SELECT p.[Name], p.[ListPrice]
FROM Production.Product p
ORDER BY p.[Name] ASC

--12.
SELECT p.[Name], p.[ListPrice]
FROM Production.Product p
WHERE p.[Name] LIKE 'A%' OR p.[Name] LIKE 'S%'
ORDER BY p.[Name] ASC

--13.
SELECT *
FROM Production.Product p
WHERE p.[Name] LIKE 'SPO[^K]%'
ORDER BY p.[Name] ASC

--14.
SELECT DISTINCT p.[Color]
FROM Production.Product p
ORDER BY p.Color DESC

--15.
SELECT DISTINCT p.ProductSubcategoryID, p.Color
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL AND p.Color IS NOT NULL