-- Zadanie 1.1
-- Klasycznie
select distinct Customers.CompanyName, Customers.Phone from Customers
inner join Orders as o on Customers.CustomerID = o.CustomerID
inner join Shippers on o.ShipVia = Shippers.ShipperID
where Shippers.CompanyName = 'United Package' and YEAR(OrderDate) = 1997

-- Podzapytania
select distinct c.CompanyName, c.Phone from Customers as c
where CustomerID IN (
    select distinct o.CustomerID from Orders as o
    where year(o.OrderDate) = 1997
      and O.ShipVia IN(
        select distinct ShipperID from Shippers
        where Shippers.CompanyName = 'United Package'
    )
)

-- Podzapytania
select distinct Customers.CompanyName, Customers.Phone from Customers
where exists (select OrderID from Orders as o where
    YEAR(o.OrderDate) = 1997
    and Customers.CustomerID = o.CustomerID
    and exists( select * from Shippers
                where Shippers.ShipperID = O.ShipVia
                and Shippers.CompanyName = 'United Package'
    )
)

-- Zadanie 1.2
-- Klasycznie
select distinct c.CompanyName, c.Phone from Customers as c
inner join Orders as o on c.CustomerID = o.CustomerID
inner join [Order Details] as od on o.OrderID = od.OrderID
inner join Products on od.ProductID = Products.ProductID
inner join Categories as cat on Products.CategoryID = cat.CategoryID
where CategoryName = 'Confections'

-- Podzapytania
select distinct CompanyName, Phone  from Orders as o
    inner join [Order Details] as od on o.OrderID = od.OrderID
    inner join Products on od.ProductID = Products.ProductID
    inner join Categories as c on Products.CategoryID = (
    select CategoryID from Categories
    where Categories.CategoryName = 'Confections'
    )
    inner join Customers on o.CustomerID = Customers.CustomerID

-- Podzapytania
select distinct c.CompanyName, c.Phone from Customers as c
where CustomerID IN (
    select Orders.CustomerID from Orders
    inner join [Order Details] as od on Orders.OrderID = od.OrderID
    inner join Products on od.ProductID = Products.ProductID
    inner join Categories on Products.CategoryID = Categories.CategoryID
    where CategoryName = 'Confections'
)
-- Zadanie 1.3
select  CompanyName, Phone from Customers
EXCEPT (
    select distinct  CompanyName, Phone from Orders as o
    inner join [Order Details] as od on o.OrderID = od.OrderID
    inner join Products on od.ProductID = Products.ProductID
    inner join Categories as c on Products.CategoryID = (
        select CategoryID from Categories
        where Categories.CategoryName = 'Confections'
    )
    inner join Customers on o.CustomerID = Customers.CustomerID
)