--注意可用資料庫要為Northwind
-- 找出和最貴的產品同類別的所有產品
SELECT * FROM Products
WHERE CategoryID = (
	SELECT  TOP 1
	CategoryID
	FROM Products
	ORDER BY UnitPrice DESC
)
-- 找出和最貴的產品同類別最便宜的產品
SELECT *FROM Products
WHERE UnitPrice=(
	SELECT MIN(UnitPrice) FROM Products
	WHERE CategoryID = (
		SELECT  TOP 1
		CategoryID
		FROM Products
		ORDER BY UnitPrice DESC
	)
)
-- 計算出上面類別最貴和最便宜的兩個產品的價差
SELECT MAX(UnitPrice) - MIN(UnitPrice) AS PriceDifference
FROM Products
WHERE CategoryID = (
	SELECT CategoryID
	FROM Products
	WHERE UnitPrice = (
		SELECT MAX(UnitPrice)
		FROM Products
	)
)
-- 找出沒有訂過任何商品的客戶所在的城市的所有客戶
SELECT DISTINCT
	c.CustomerID,c.City,c.CompanyName
 FROM Customers c
 WHERE c.CustomerID NOT IN (
    SELECT  DISTINCT o.CustomerID
    FROM Orders o
)
-- 找出第 5 貴跟第 8 便宜的產品的產品類別
SELECT
	CategoryID,CategoryName
FROM Categories
WHERE CategoryID IN(
	(
		SELECT
		CategoryID
		FROM Products
		ORDER BY UnitPrice DESC
		OFFSET 4 ROWS
		FETCH NEXT 1 ROWS ONLY
	),
	(
		SELECT
		CategoryID
		FROM Products
		ORDER BY UnitPrice 
		OFFSET 7 ROWS
		FETCH NEXT 1 ROWS ONLY
	)
)
-- 找出誰買過第 5 貴跟第 8 便宜的產品
SELECT
	c.CustomerID,p.ProductName
FROM Customers c
INNER JOIN Orders o ON o.CustomerID=c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID=o.OrderID
INNER JOIN Products p ON p.ProductID= od.ProductID
WHERE od.ProductID IN(
	(
		SELECT
		ProductID
		FROM Products
		ORDER BY UnitPrice DESC
		OFFSET 4 ROWS
		FETCH NEXT 1 ROWS ONLY
	)
	,
	(
		SELECT
		ProductID
		FROM Products
		ORDER BY UnitPrice 
		OFFSET 7 ROWS
		FETCH NEXT 1 ROWS ONLY
	)
)
-- 找出誰賣過第 5 貴跟第 8 便宜的產品
SELECT 
	c.CustomerID,p.ProductName,s.SupplierID,s.CompanyName
FROM Customers c
INNER JOIN Orders o ON o.CustomerID=c.CustomerID
INNER JOIN [Order Details] od ON od.OrderID=o.OrderID
INNER JOIN Products p ON p.ProductID= od.ProductID
INNER JOIN Suppliers s ON s.SupplierID=p.SupplierID
WHERE od.ProductID IN(
	(
		SELECT
		ProductID
		FROM Products
		ORDER BY UnitPrice DESC
		OFFSET 4 ROWS
		FETCH NEXT 1 ROWS ONLY
	)
	,
	(
		SELECT
		ProductID
		FROM Products
		ORDER BY UnitPrice 
		OFFSET 7 ROWS
		FETCH NEXT 1 ROWS ONLY
	)
)
-- 找出 13 號星期五的訂單 (惡魔的訂單)
SELECT 
	OrderID,OrderDate
FROM Orders
WHERE DATEPART(DAY,OrderDate)=13 AND DATEPART(WEEKDAY,OrderDate)=6
-- 找出誰訂了惡魔的訂單
SELECT DISTINCT
	o.OrderID,o.OrderDate,c.CustomerID,c.CompanyName
FROM Orders o
INNER JOIN Customers c ON c.CustomerID=o.CustomerID
WHERE DATEPART(DAY,OrderDate)=13 AND DATEPART(WEEKDAY,OrderDate)=6
-- 找出惡魔的訂單裡有什麼產品
SELECT DISTINCT
	o.OrderID,o.OrderDate,c.CustomerID,c.CompanyName,p.ProductName
FROM Orders o
INNER JOIN Customers c ON c.CustomerID=o.CustomerID
INNER JOIN [Order Details] od ON od.OrderID=o.OrderID
INNER JOIN Products p ON p.ProductID=od.ProductID
WHERE DATEPART(DAY,o.OrderDate)=13 AND DATEPART(WEEKDAY,o.OrderDate)=6
-- 列出從來沒有打折 (Discount) 出售的產品
SELECT DISTINCT
	od.OrderID,od.Discount,p.ProductID,p.ProductName
FROM [Order Details] od 
INNER JOIN Products p ON p.ProductID=od.ProductID
WHERE od.Discount =0

-- 列出購買非本國的產品的客戶
SELECT
	c.CustomerID,c.CompanyName,c.Country,s.Country
FROM Customers c 
INNER JOIN Orders o ON o.CustomerID=c.CustomerID 
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
INNER JOIN Products p ON p.ProductID=od.ProductID
INNER JOIN Suppliers s ON  s.SupplierID = p.SupplierID
WHERE c.Country <> s.Country
-- 列出在同個城市中有公司員工可以服務的客戶
SELECT*FROM Orders

-- 列出那些產品沒有人買過
SELECT DISTINCT
	p.ProductName
FROM Products p
----------------------------------------------------------------------------------------

-- 列出所有在每個月月底的訂單

-- 列出每個月月底售出的產品

-- 找出有敗過最貴的三個產品中的任何一個的前三個大客戶

-- 找出有敗過銷售金額前三高個產品的前三個大客戶
Select Distinct Top 3
  c.CustomerID,
  Sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) As SalesAmount
From Customers c
Inner Join Orders o On o.CustomerID = c.CustomerID
Inner Join [Order Details] od On od.OrderID = o.OrderID
Where od.ProductID In (
    Select Top 3
        od.ProductID
    From [Order Details] od
    Group By od.ProductID
    Order By Sum(od.UnitPrice * od.Quantity * (1 - od.Discount)) Desc
)
Group By c.CustomerID
Order By SalesAmount Desc
-- 找出有敗過銷售金額前三高個產品所屬類別的前三個大客戶

-- 列出消費總金額高於所有客戶平均消費總金額的客戶的名字，以及客戶的消費總金額

-- 列出最熱銷的產品，以及被購買的總金額

-- 列出最少人買的產品

-- 列出最沒人要買的產品類別 (Categories)

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (含購買其它供應商的產品)

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (不含購買其它供應商的產品)

-- 列出那些產品沒有人買過

-- 列出沒有傳真 (Fax) 的客戶和它的消費總金額

-- 列出每一個城市消費的產品種類數量

-- 列出目前沒有庫存的產品在過去總共被訂購的數量

-- 列出目前沒有庫存的產品在過去曾經被那些客戶訂購過

-- 列出每位員工的下屬的業績總金額

-- 列出每家貨運公司運送最多的那一種產品類別與總數量

-- 列出每一個客戶買最多的產品類別與金額

-- 列出每一個客戶買最多的那一個產品與購買數量

-- 按照城市分類，找出每一個城市最近一筆訂單的送貨時間

-- 列出購買金額第五名與第十名的客戶，以及兩個客戶的金額差距

