-- Zadanie 1.
-- Klasycznie
select p.ProductID, MAX(quantity)from [Order Details] as od
inner join Products as p on od.ProductID = p.ProductID
group by p.ProductID
order by 1, 2

-- Podzapytania
select  ProductID as pid, (select max(quantity) from [Order Details] as od
where od.ProductID = od1.ProductID)
from [Order Details] as od1
group by ProductID

--Zadanie 2.
-- Podzapytania
select ProductID, ProductName, UnitPrice from Products as p
where ProductID IN (
    select od.ProductID from Products as od
    where od.ProductID = p.ProductID
) and UnitPrice < (select AVG(UnitPrice) from [Order Details])
order by 3

--Zadanie 3
-- Podzapytania
SELECT
    (select CategoryName from Categories as c where p.CategoryID = c.CategoryID),
    ProductName,
    (select AVG(UnitPrice) from Products as p1
     where p1.CategoryID = p.CategoryID) as abe,
    UnitPrice
from Products as p
where (select AVG(UnitPrice) from Products as p1
       where p1.CategoryID = p.CategoryID) > UnitPrice