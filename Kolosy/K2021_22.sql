-- Zad.1. Wyświetl produkt, który przyniósł najmniejszy, ale niezerowy, przychód w 1996 roku

select top 1  ProductName, sum((1 - Discount) * Quantity * p.UnitPrice) as total
from Orders o
inner join [Order Details] od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID
where YEAR(OrderDate) = 1996
group by p.ProductID, ProductName
having sum((1 - Discount) * Quantity * p.UnitPrice) > 0
order by total


-- Zad.2. Wyświetl wszystkich członków biblioteki (imię i nazwisko, adres)
-- rozróżniając dorosłych i dzieci (dla dorosłych podaj liczbę dzieci),
-- którzy nigdy nie wypożyczyli książki
-- with subq as (select member.member_no, firstname + ' ' + lastname as name, street, state, 'TRUE' as kid, count(adult_member_no) as cnt
--               from member
--                        inner join adult on member.member_no = adult.member_no
--                        left join dbo.juvenile j on adult.member_no = j.adult_member_no
--               where member.member_no not in (select loan.member_no from loan)
--                 and member.member_no not in (select loanhist.member_no from loanhist)
--               group by member.member_no, firstname, lastname, street, state
--               union
--               select member.member_no, firstname + ' ' + lastname as name, street, street, 'FALSE' as kid, 0 as cnt
--               from member
--                        inner join juvenile on member.member_no = juvenile.member_no
--                        inner join dbo.adult a on juvenile.adult_member_no = a.member_no
--               where member.member_no not in (select loan.member_no from loan)
--                 and member.member_no not in (select loanhist.member_no from loanhist))
-- select subq.name, street, state, kid, cnt from subq

-- Zad.3. Wyświetl podsumowanie zamówień (całkowita cena + fracht) obsłużonych
-- przez pracowników w lutym 1997 roku, uwzględnij wszystkich, nawet jeśli suma
-- wyniosła 0.

with empl as (
select e.EmployeeID, e.FirstName+ ' ' + e.LastName as name, round(sum((1 - Discount) * UnitPrice * Quantity) + sum(Freight),2) as total
from Employees e
inner join Orders o on o.EmployeeID = e.EmployeeID
inner join [Order Details] od on o.OrderID = od.OrderID
where YEAR(OrderDate) = 1997
and MONTH(OrderDate) = 2
group by o.EmployeeID, e.LastName, e.FirstName, e.EmployeeID
)
select e.FirstName + ' ' + e.LastName,  isnull(empl.total, 0) from empl
right join Employees e on e.EmployeeID = empl.EmployeeID
order by 2 desc


with table1 as

    (select E.EmployeeID, E.FirstName, E.LastName, count(O.OrderID) as ilosc,

    round(sum(od.Quantity*od.UnitPrice*(1-od.Discount)) + sum(o.Freight),2) as suma

    from Employees E

    inner join Orders O on E.EmployeeID = O.EmployeeID

    inner join [Order Details] od on O.OrderID = od.OrderID

    where year(O.OrderDate) = 1997 and month(O.OrderDate) = 2

    group by E.EmployeeID, E.FirstName, E.LastName)


select E.FirstName, E.LastName, isnull(t1.ilosc,0) as ilosc, isnull(t1.suma,0) as suma from table1 t1

                                                                                                right join Employees E on t1.EmployeeID = E.EmployeeID

order by 4 desc