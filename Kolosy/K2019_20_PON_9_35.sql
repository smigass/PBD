-- 1. Wypisz wszystkich członków biblioteki z adresami i info czy jest dzieckiem czy nie i
-- ilość wypożyczeń w poszczególnych latach i miesiącach.

select juvenile.member_no,
       street,
       state,
       phone_no,
       'TRUE' as kid,
       YEAR(out_date),
       MONTH(out_date),
       count(*)
from juvenile
         inner join dbo.adult a on juvenile.adult_member_no = a.member_no
         inner join loanhist on juvenile.member_no = loanhist.member_no
group by juvenile.member_no, street, state, phone_no, out_date
union
select a.member_no,
       street,
       state,
       phone_no,
       'FALSE' as kid,
       YEAR(out_date),
       MONTH(out_date),
       count(*)
from adult a
         inner join loanhist on a.member_no = loanhist.member_no
group by a.member_no, street, state, phone_no, out_date
order by 1

-- 2. Zamówienia z Freight większym niż AVG danego roku.

select *
from Orders as o1
where Freight > (select avg(Freight)
                 from Orders as o2
                 where YEAR(o1.OrderDate) = YEAR(o2.OrderDate))

-- 3. Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood' w trzech wersjach.
-- WERSJA 1

select distinct c2.CompanyName
from Customers
         inner join Orders on Customers.CustomerID = Orders.CustomerID
         inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
         inner join Products on [Order Details].ProductID = Products.ProductID
         inner join Categories on CategoryName = 'Seafood'
         right outer join Customers as c2 on Orders.CustomerID = c2.CustomerID
where Orders.OrderID is null

-- WERSJA 2

select subq.name
from (select c1.CustomerID, c1.CompanyName as name
      from Customers as c1
      except
      (select c2.CustomerID, c2.CompanyName
       from Customers as c2
                inner join Orders as o on c2.CustomerID = o.CustomerID
                inner join [Order Details] on o.OrderID = [Order Details].OrderID
                inner join Products on [Order Details].ProductID = Products.ProductID
                inner join Categories on Categories.CategoryName = 'Seafood')) as subq

-- WERSJA 3

select CompanyName from Customers
where CustomerID not in(select c2.CustomerID
                        from Customers as c2
                                 inner join Orders as o on c2.CustomerID = o.CustomerID
                                 inner join [Order Details] on o.OrderID = [Order Details].OrderID
                                 inner join Products on [Order Details].ProductID = Products.ProductID
                                 inner join Categories on Categories.CategoryName = 'Seafood')


-- 4. Dla każdego klienta najczęściej zamawianą kategorię w dwóch wersjach.
-- WERSJA 1
select c2.CompanyName, (select top 1 CategoryName from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Products on [Order Details].ProductID = Products.ProductID
inner join Categories on Products.CategoryID = Categories.CategoryID
where c2.CustomerID = Customers.CustomerID
group by Customers.CustomerID, Customers.CompanyName, CategoryName
order by count(*) desc)
from Customers as c2

-- WERSJA 2
select CompanyName, CategoryName suma from Customers
inner join Orders o on Customers.CustomerID = o.CustomerID
inner join [Order Details] od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID
inner join Categories c on p.CategoryID = c.CategoryID
group by o.CustomerID, CompanyName, CategoryName
having count(*) = (select max(subq.cou) from (
    select count(*) as cou from Customers
                    inner join Orders on Customers.CustomerID = Orders.CustomerID
                    inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
                    inner join Products on [Order Details].ProductID = Products.ProductID
                    where o.CustomerID = Customers.CustomerID
                    group by Customers.CustomerID, Products.CategoryID
                                     ) as subq)

