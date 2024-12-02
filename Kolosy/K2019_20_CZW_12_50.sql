-- 1. Wybierz dzieci wraz z adresem, które nie wypożyczyły książek w lipcu 2001
-- autorstwa ‘Jane Austin’

select firstname + ' ' + lastname as name,
       street,
       state,
       phone_no
from member
inner join juvenile on member.member_no = juvenile.member_no
inner join adult on juvenile.adult_member_no = adult.member_no
where member.member_no not in (
    select loanhist.member_no
    from loanhist
    inner join title on loanhist.title_no = title.title_no
    where YEAR(loanhist.out_date) = 2001
    and MONTH(loanhist.out_date) = 7
    and author = 'Jane Austin'
)

-- 2. Wybierz kategorię, która w danym roku 1997 najwięcej zarobiła, podział na miesiące
select distinct YEAR(OrderDate), MONTH(OrderDate),
       (select top 1 CategoryName
            from Orders
            inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
            inner join Products on [Order Details].ProductID = Products.ProductID
            inner join Categories on Products.CategoryID = Categories.CategoryID
            where YEAR(Orders.OrderDate) = YEAR(o.OrderDate)
            and MONTH(Orders.OrderDate) = MONTH(o.OrderDate)
            group by CategoryName
            order by count((1 - Discount) * Products.UnitPrice * Quantity) desc
            )
from Orders o
where YEAR(OrderDate) = 1997

-- 3. Dane pracownika i najczęstszy dostawca pracowników bez podwładnych

select Employees.FirstName + ' ' + Employees.LastName as Name, (
    select top 1 CompanyName
    from Shippers
    inner join Orders on Shippers.ShipperID = Orders.ShipVia
    where Employees.EmployeeID = Orders.EmployeeID
    group by Orders.EmployeeID, CompanyName
    order by count(*) desc
    ) as FavouriteShipper from Employees
left join Employees e2 on e2.ReportsTo = Employees.EmployeeID
where e2.EmployeeID is null



-- 4. Wybierz tytuły książek, gdzie ilość wypożyczeń książki jest większa
-- od średniej ilości wypożyczeń książek tego samego autora.

select t.title, count(*) as loans
from loanhist lh
inner join title t on lh.title_no = t.title_no
group by t.title, t.author, lh.title_no
having count(*) >
       (select avg(subq.cnt)
        from (select lh.title_no, count(*) as cnt
                  from title
                  inner join loanhist on title.title_no = loanhist.title_no
                  where title.author = t.author
                  group by author, loanhist.title_no
                  ) as subq
        )
