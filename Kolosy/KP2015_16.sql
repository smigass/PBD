-- 1. Wypisz te produkty które kupiło conajmniej 2 klientów
-- a) podzapytaniem
select ProductID, ProductName
from Products
where (select count(*) from
        (select distinct ProductID as id, Customers.CustomerID from Customers
         join Orders as o2 on Customers.CustomerID = o2.CustomerID
         inner join [Order Details] as od on o2.OrderID = od.OrderID
        ) as iCI
      where id = Products.ProductID) > 2

-- b) bez podzapytań
select Products.ProductID, ProductName from Products
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
inner join Orders on [Order Details].OrderID = Orders.OrderID
group by Products.ProductID, ProductName
having count(distinct CustomerID) > 2
-- 2. Znajdź produkt (podaj jego nazwę), który przyniósł najmniejszy dochód (większy od zera) w 1996 roku
select ProductName from Products
    inner join (select top 1 Products.ProductID as id, round(sum((1-Discount) * Quantity * Products.UnitPrice),2) as 'dochod' from Products
    inner join [Order Details] on Products.ProductID = [Order Details].ProductID
    group by Products.ProductID
    order by dochod) as subq
on subq.id = Products.ProductID
