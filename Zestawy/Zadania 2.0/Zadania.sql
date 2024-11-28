-- Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż 20$

SELECT count(*)
from Products
where UnitPrice not between 10 and 20
-- 48

-- Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
SELECT max(UnitPrice)
from Products
where UnitPrice < 20
--19.5000

-- Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o
-- produktach sprzedawanych w butelkach (‘bottle’)
SELECT max(UnitPrice) as max, min(UnitPrice) as min, avg(UnitPrice) as avg
from Products
where QuantityPerUnit like '%bottles%'
-- 263.5000, 7.7500, 38.7545

-- Wypisz informację o wszystkich produktach o cenie powyżej średniej
select *
from Products
where UnitPrice > (select avg(UnitPrice) from Products)

-- Podaj wartość zamówienia o numerze 10250
select round(sum((1 - Discount) * UnitPrice * quantity), 2)
from [Order Details]
where OrderID = 10250
-- 1552.6


--  Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, max(UnitPrice) maxPrice
from [Order Details]
group by OrderID

-- Posortuj zamówienia wg maksymalnej ceny produktu
select OrderID, max(UnitPrice) as maxPrice
from [Order Details]
group by OrderID
order by 2 desc

-- Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
select OrderID, max(UnitPrice) as maxPrice, min(UnitPrice) as minPrice
from [Order Details]
group by OrderID

-- Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
select ShipVia, count(*)
from Orders
group by ShipVia

-- Który z spedytorów był najaktywniejszy w 1997 roku
select top 1 ShipVia, count(*)
from Orders
where year(OrderDate) = 1997
group by ShipVia
order by 2 desc


-- Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
select OrderID, count(*) as quant
from [Order Details]
group by OrderID
having count(*) > 5


-- Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
-- (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
select CompanyName, sum(Freight) as total from Orders
inner join Customers on Orders.CustomerID = Customers.CustomerID
where year(OrderDate) = 1998
group by CompanyName
having count(*) > 8
order by total desc


