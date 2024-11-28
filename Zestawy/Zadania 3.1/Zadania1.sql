-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz
-- nazwę klienta.
select Orders.OrderID, CompanyName, sum(Quantity)
from [Order Details]
         inner join Orders on [Order Details].OrderID = Orders.OrderID
         inner join Customers on Orders.CustomerID = Customers.CustomerID
group by Orders.OrderID, CompanyName

-- 2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczbę zamówionych jednostek jest większa niż 250
select Orders.OrderID, CompanyName, sum(Quantity)
from [Order Details]
         inner join Orders on [Order Details].OrderID = Orders.OrderID
         inner join Customers on Orders.CustomerID = Customers.CustomerID
group by Orders.OrderID, CompanyName
having sum(Quantity) > 250
order by 3 desc

-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
-- klienta.
select Orders.OrderID, Customers.CompanyName, round(sum((1 - Discount) * Quantity * UnitPrice), 2)
from [Order Details]
         inner join Orders on [Order Details].OrderID = Orders.OrderID
         inner join Customers on Orders.CustomerID = Customers.CustomerID
group by Orders.OrderID, Customers.CompanyName
order by 3 desc

-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250.
select Orders.OrderID, Customers.CompanyName, round(sum((1 - Discount) * Quantity * UnitPrice), 2)
from [Order Details]
         inner join Orders on [Order Details].OrderID = Orders.OrderID
         inner join Customers on Orders.CustomerID = Customers.CustomerID
group by Orders.OrderID, Customers.CompanyName
having sum(Quantity) > 250
order by 3 desc

-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko
-- pracownika obsługującego zamówienie
select Orders.OrderID, Customers.CompanyName, round(sum((1 - Discount) * Quantity * UnitPrice), 2)
from [Order Details]
         inner join Orders on [Order Details].OrderID = Orders.OrderID
         inner join Customers on Orders.CustomerID = Customers.CustomerID
group by Orders.OrderID, Customers.CompanyName
having sum(Quantity) > 250
order by 3 desc