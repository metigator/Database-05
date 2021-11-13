CREATE OR ALTER PROCEDURE dbo.SalesByCategoryAndYear (
@categoryName nvarchar(15), 
@year int,
@count int OUTPUT
)
AS
BEGIN
 -- PRODUCT | TOTAL
 SELECT P.ProductName,
        ROUND(SUM(OD.Quantity * (1 - OD.Discount) * OD.UnitPrice), 0) As TotalPurchase
	FROM
	[Order Details] OD
	INNER JOIN Orders O ON O.OrderID = OD.OrderID
	INNER JOIN Products P ON P.ProductID = OD.ProductID
	INNER JOIN Categories C ON C.CategoryID = P.CategoryID
	WHERE C.CategoryName = @categoryName AND YEAR(O.OrderDate) = @year
	GROUP BY ProductName
	Order By ProductName

	SELECT @count = @@ROWCOUNT
END
GO
DECLARE @count int;
EXEC dbo.SalesByCategoryAndYear 'Beverages', 1998, @count OUTPUT;
SELECT @count AS ' Total Distinct Products ';
