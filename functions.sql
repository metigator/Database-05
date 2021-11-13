-- OrderID | ProductId | UnitPrice | Quantity | Discount | SubTotal

SELECT
OD.OrderID,
OD.ProductId,
OD.UnitPrice,
OD.Quantity,
OD.Discount,
dbo.CalculateSubTotal(OD.Quantity, OD.UnitPrice, OD.Discount) AS SUBTOTAL
FROM [Order Details] OD 
WHERE OrderId = 10250;    

-- OrderID | CustomerId | OrderDate | Total

SELECT 
O.OrderID,
O.CustomerID,
O.OrderDate,
CONVERT(money , SUM((1 - OD.Discount) * (OD.UnitPrice * OD.Quantity)) , 2) As Total
FROM
Orders O INNER JOIN [Order Details] OD
ON O.OrderID = OD.OrderID
Where O.OrderId = 10250
GROUP BY
O.OrderID,
O.CustomerID,
O.OrderDate;

-- FUNCTIONS

-- 1 SCALER FUNCTIONS (single value)
CREATE OR ALTER FUNCTION dbo.CalculateSubTotal(@quantity int, @unitPrice money, @discount real)
RETURNS money WITH SCHEMABINDING
As
BEGIN
DECLARE @subTotal money;
SELECT @subTotal = CONVERT(money , (1 - @discount) * (@unitPrice * @quantity), 2);
RETURN @subTotal;
END
GO

CREATE OR ALTER FUNCTION dbo.CalculateOrderTotal(@orderId int)
RETURNS money 
As
BEGIN
DECLARE @total money;
SELECT @total = SUM(SUBTOTAL) FROM dbo.GetOrderDetails(@orderId)
RETURN @total;
END
GO


-- 2 TABLE VALUED FUNCTIONS (result set)

CREATE OR ALTER FUNCTION GetOrderDetails(@orderId int)
RETURNS Table
AS
RETURN
( 
	SELECT
	OD.OrderID,
	OD.ProductId,
	OD.UnitPrice,
	OD.Quantity,
	OD.Discount,
	dbo.CalculateSubTotal(OD.Quantity, OD.UnitPrice, OD.Discount) AS SUBTOTAL
	FROM [Order Details] OD 
	WHERE OrderId = @orderId  
);

Select * From dbo.GetOrderDetails(10250);

CREATE OR ALTER FUNCTION GetCustomerOrders ( @customerID nvarchar(50))
RETURNS Table
AS
RETURN
(
SELECT 
O.OrderID,
O.CustomerID,
O.OrderDate,
dbo.CalculateOrderTotal(O.OrderID) As Total
FROM
Orders O 
WHERE 
O.CustomerID = @customerID
);

SELECT * FROM GetCustomerOrders('ALFKI')

-- 3 System FUNCITON (Built in function)

-- Numeric Function 

SELECT ABS(-100);

-- DATE FUNCITON
SELECT GETDATE();
SELECT ISDATE('2000-10-20');

-- String Function

SELECT LEN('this is some text')
SELECT UPPER('issam');

-- CONVERSION Function
SELECT CONVERT(money, '100', 2);
