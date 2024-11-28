-- Zadanie 1.
select OrderID, (
    select sum((1 - Discount)* Quantity * UnitPrice) +
           Freight from Orders where Orders.OrderID = od.OrderID
    group by Freight) as a
from [Order Details] as od
where OrderID = 10250
group by OrderID

-- Zadanie 2.
select OrderID, (
    SELECT SUM((1 - Discount) * UnitPrice * QUANTITY) + O.FREIGHT
    FROM ORDERS AS O
    WHERE O.OrderID = OD.OrderID)
from [Order Details] as od
GROUP BY OrderID

-- Zadanie 3.
select ContactName, Address, City, Region from Customers
except (select ContactName, Address, City, Region from Customers as c
        where c.CustomerID IN (
            SELECT o.CustomerID from Orders as o
            where YEAR(OrderDate) = 1997
        ))

-- Zadanie 4.
-- Mocne zadanie i zle
SELECT DISTINCT ProductName
FROM Products
WHERE ProductID IN (
    SELECT ProductID
    FROM [Order Details]
    GROUP BY ProductID
    HAVING COUNT(DISTINCT OrderID) > 1
);