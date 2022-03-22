USE Northwind
GO

--1.
CREATE VIEW view_product_order_roh AS
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalOrderedQuantity
FROM Products p, [Order Details] od
GROUP BY p.ProductID, p.ProductName

--2.
CREATE PROC sp_product_order_quantity_roh
@pid INT
AS
BEGIN
DECLARE @totalQuantity AS INT
SELECT @totalQuantity = COUNT(*) FROM [Order Details] od
WHERE @pid = od.ProductID
RETURN @totalQuantity
END

--3.
CREATE PROC sp_product_order_city_roh
@product_name VARCHAR(50)
AS
BEGIN
DECLARE @top_cities_quantity AS TABLE(
City VARCHAR(50),
Quantity INT
)
INSERT INTO @top_cities_quantity
SELECT TOP 5 c.City, SUM(od.Quantity) 
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE @product_name = p.ProductName
GROUP BY c.City ORDER BY SUM(od.Quantity)
SELECT * FROM @top_cities_quantity
END

--4.
DROP TABLE IF EXISTS people_roh
DROP TABLE IF EXISTS city_roh
CREATE TABLE city_roh(id INT PRIMARY KEY, City VARCHAR(50))
CREATE TABLE people_roh(id INT PRIMARY KEY, Name VARCHAR(50),City int FOREIGN KEY REFERENCES city_roh(id))
INSERT INTO city_roh values(1,'Seattle')
INSERT INTO city_roh values(2,'Green Bay')
INSERT INTO people_roh values(1,'Aaron Rodgers',2)
INSERT INTO people_roh values(2,'Russell Wilson',1)
INSERT INTO people_roh values(3,'Jody Nelson',2)
BEGIN TRANSACTION
INSERT INTO city_roh values (3,'Madison')
UPDATE people_roh SET City = 3 WHERE City = 1
DELETE FROM city_roh WHERE City = 'Seattle'
COMMIT
CREATE VIEW Packers_yunjae_roh AS
SELECT p.Name
FROM people_roh p, city_roh c
WHERE p.City = c.id AND c.City = 'Green Bay'
DROP TABLE IF EXISTS people_roh
DROP TABLE IF EXISTS city_roh
DROP VIEW IF EXISTS Packers_yunjae_roh

--5.
CREATE PROC sp_birthday_employees_roh
AS
BEGIN
DROP TABLE IF EXISTS birthday_employees_roh
CREATE TABLE birthday_employees_roh (Name VARCHAR(50))
INSERT INTO birthday_employees_roh
SELECT LastName + ' ' + FirstName
FROM Employees 
WHERE DATEPART(MM,BirthDate) = 2
END
EXEC sp_birthday_employees_roh
--6.
-- Use transaction with appropriate modifiers to ensure integrity of data on two tables 