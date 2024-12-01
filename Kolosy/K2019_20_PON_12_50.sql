-- 1. Podział na company, year month i suma freight
select distinct CompanyName, YEAR(OrderDate), MONTH(OrderDate), (
    select sum(Freight) from Orders as o
                        where Orders.CustomerID = o.CustomerID
                        and YEAR(o.OrderDate) = YEAR(Orders.OrderDate)
                        and MONTH(o.OrderDate) = MONTH(Orders.OrderDate)
    ) from Orders
inner join Customers on Orders.CustomerID = Customers.CustomerID
order by 1

-- 2. Wypisać wszystkich czytelników, którzy nigdy nie wypożyczyli książki dane adresowe i podział
-- czy ta osoba jest dzieckiem (joiny, in, exists)
-- WERSJA 1
with ami as (
    select juvenile.member_no, firstname,lastname ,street, state, phone_no, 'True' as kid from juvenile
    inner join member on member.member_no = juvenile.member_no
    inner join adult on juvenile.adult_member_no = adult.member_no
    union
    select adult.member_no, firstname,lastname ,street, state, phone_no, 'False' as kid from member
    inner join adult on member.member_no = adult.member_no
)
select ami.firstname, ami.lastname, ami.street, ami.state, ami.phone_no, ami.kid from ami
left outer join loanhist on loanhist.member_no = ami.member_no
where loanhist.member_no is null

-- WERSJA 2
with ami as (
    select juvenile.member_no, firstname,lastname ,street, state, phone_no, 'True' as kid from juvenile
    inner join member on member.member_no = juvenile.member_no
    inner join adult on juvenile.adult_member_no = adult.member_no
    union
    select adult.member_no, firstname,lastname ,street, state, phone_no, 'False' as kid from member
    inner join adult on member.member_no = adult.member_no
)
select * from ami
where ami.member_no not in (select distinct loanhist.member_no from loanhist)

-- WERSJA 3
with ami as (
    select juvenile.member_no, firstname,lastname ,street, state, phone_no, 'True' as kid from juvenile
        inner join member on member.member_no = juvenile.member_no
        inner join adult on juvenile.adult_member_no = adult.member_no
    union
    select adult.member_no, firstname,lastname ,street, state, phone_no, 'False' as kid from member
    inner join adult on member.member_no = adult.member_no)
select * from ami
where not exists (select distinct loanhist.member_no from loanhist
                    where loanhist.member_no = ami.member_no)
order by 1

-- 3. Najczęściej wybierana kategoria w 1997 dla każdego klienta

-- NO TIES
select CompanyName, (select
top 1 CategoryName from Orders
      inner join [Order Details] od on Orders.OrderID = od.OrderID
      inner join Products p on od.ProductID = p.ProductID
      inner join Categories c on p.CategoryID = c.CategoryID
      where Customers.CustomerID = Orders.CustomerID and year(OrderDate) = 1997
      group by Orders.CustomerID, CategoryName
      order by count(*) desc
      )
from Customers

-- WITH TIES
select CompanyName, CategoryName, count(*) from Customers
    inner join Orders o on Customers.CustomerID = o.CustomerID
    inner join [Order Details] od on o.OrderID = od.OrderID
    inner join Products p on od.ProductID = p.ProductID
    inner join Categories c on p.CategoryID = c.CategoryID
where YEAR(o.OrderDate) = 1997
group by o.CustomerID, CompanyName, CategoryName
having count(*) = (select max(subq.cnt) from (
    select count(*) as cnt
    from Customers c2
    inner join Orders o2 on c2.CustomerID = o2.CustomerID
    inner join [Order Details] od2 on o2.OrderID = od2.OrderID
    inner join Products p2 on od2.ProductID = p2.ProductID
    where c2.CustomerID = o.CustomerID and YEAR(o2.OrderDate) = 1997
    group by c2.CustomerID, p2.CategoryID
                                     ) as subq)
order by 1

-- 4. Dla każdego czytelnika imię nazwisko, suma książek wypożyczony przez tą osobę i jej dzieci,
-- który żyje w Arizona ma mieć więcej niż 2 dzieci lub kto żyje w Kalifornii ma mieć więcej niż 3 dzieci

with total_adult_books as (select subq.mn, sum(total) as 'total loans' from
    (-- Wypozyczenia dzieci z loanhist
        select adult_member_no as mn, count(*) as total
        from juvenile
                 inner join loanhist on loanhist.member_no = juvenile.member_no
        group by adult_member_no
        union
        -- Wypozyczenia dzieci z loan
        select adult_member_no as mn, count(*) as total
        from juvenile
                 inner join loan on loan.member_no = juvenile.member_no
        group by adult_member_no
        union
        -- Wypozyczenia rodziców (bez dzieci) z loanhist
        select member.member_no as mn, count(*) as total
        from member
                 inner join loanhist on member.member_no = loanhist.member_no
                 left outer join juvenile on member.member_no = juvenile.member_no
        where juvenile.member_no is null
        group by member.member_no
        union
        -- Wypozyczenia rodziców (bez dzieci) z loan
        select member.member_no as mn, count(*) as total
        from member
                 inner join loan on member.member_no = loan.member_no
                 left outer join juvenile on member.member_no = juvenile.member_no
        where juvenile.member_no is null
        group by member.member_no
    ) as subq
                           group by subq.mn)
select member.firstname, member.lastname, isnull([total loans], 0)  from total_adult_books
right  join adult on total_adult_books.mn = adult.member_no
right  outer join member on adult.member_no = member.member_no
where (state = 'AZ' and (select count(*) from juvenile where juvenile.adult_member_no = member.member_no) > 2)
   or (state = 'CA' and (select count(*) from juvenile where juvenile.adult_member_no = member.member_no) > 3)


