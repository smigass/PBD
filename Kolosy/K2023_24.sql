-- ZAD 1 Podaj nazwe produktu dla którego osiągnieto minimalny,
-- ale niezerowy zysk z produktu w 1996

select top 1  ProductName, round(sum((1 - Discount) * Quantity * p.UnitPrice), 2) as total
from Orders o
inner join [Order Details] od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID
where YEAR(OrderDate) = 1996
group by ProductName
having sum((1 - Discount) * Quantity * p.UnitPrice) > 0
order by total


-- ZAD 2, Podaj imiona,
-- nazwiska i tytuły książek poozyczone przez wiecej niz 1 czytelnika, ktorzy mają dzieci.
with adults_with_child as (
    select member.member_no
    from member
    inner join adult on member.member_no = adult.member_no
    where (select count(*)
           from juvenile
           where juvenile.adult_member_no = member.member_no
          ) > 0
    )
select distinct firstname + ' ' + lastname, title from adults_with_child
inner join loanhist on loanhist.member_no = adults_with_child.member_no
inner join title on loanhist.title_no = title.title_no
inner join member on member.member_no = adults_with_child.member_no


-- ZAD 3, Podaj wszystkie zamówienia dla których opłata za przesyłke > od sredniej w danym roku
select OrderID from Orders
where Freight > (select avg(Freight)
                 from Orders o
                 where YEAR(o.OrderDate) = YEAR(Orders.OrderDate))