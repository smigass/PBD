-- 1.
-- a) Wyświetl imię, nazwisko, dane adresowe oraz ilość wypożyczonych książek dla każdego członka biblioteki.
-- Ilość wypożyczonych książek nie może być nullem, co najwyżej zerem.

use library
with users as (select juvenile.member_no as id, adult.street, adult.city, adult.state, adult.phone_no
               from juvenile
               inner join adult on adult.member_no = juvenile.adult_member_no
               UNION
               select member_no, street, city, state, phone_no
               from adult)
select users.id,
       (select count(*) from loanhist where loanhist.member_no = users.id) +
       (select count(*) from loan where loan.member_no = users.id) as 'total loan',
       users.street, users.city, users.state, users.phone_no
from users
order by 2 desc



-- b) j/w + informacja, czy dany członek jest dzieckiem

use library
with users as (select juvenile.member_no as id, adult.street, adult.city, adult.state, adult.phone_no, 'YES' as kid
               from juvenile
               inner join adult on adult.member_no = juvenile.adult_member_no
               UNION
               select member_no, street, city, state, phone_no, 'NO' as kid
               from adult)
select users.id,
       (select count(*) from loanhist where loanhist.member_no = users.id) +
       (select count(*) from loan where loan.member_no = users.id) as 'total loan',
       users.street, users.city, users.state, users.phone_no, users.kid
from users
order by 2 desc

-- 2. wyświetl imiona i nazwiska osób, które nigdy nie wypożyczyły żadnej książki
-- a) bez podzapytań
    select firstname, lastname from member
    left outer join loanhist on member.member_no = loanhist.member_no
    where loanhist.member_no is null

-- b) podzapytaniami
    select firstname, lastname from member
    where member.member_no NOT IN (
        select distinct loanhist.member_no from loanhist
    )

-- 3. wyświetl numery zamówień, których cena dostawy była większa niż średnia cena za przesyłkę w tym roku
-- a) bez podzapytań
    use Northwind
select YEAR(OrderDate), avg(Freight)from Orders
group by YEAR(OrderDate)

use Northwind
SELECT o1.OrderID, o1.Freight, AVG(o2.Freight)
FROM Orders o1
INNER JOIN Orders o2 ON YEAR(o1.OrderDate) = YEAR(o2.OrderDate)
GROUP BY o1.OrderID, o1.Freight
HAVING o1.Freight > AVG(o2.Freight);



-- b) podzapytaniami
    select OrderID from Orders
    where Freight > (select avg(Freight) from Orders as o where YEAR(o.OrderDate) = YEAR(Orders.OrderDate))

-- 4. wyświetl ile każdy z przewoźników miał dostać wynagrodzenia w poszczególnych latach i miesiącach.
-- a) bez podzapytań
    select CompanyName, YEAR(OrderDate), MONTH(OrderDate), sum(Freight) from Shippers
    left outer join Orders on Shippers.ShipperID = Orders.ShipVia
    group by CompanyName, YEAR(OrderDate), MONTH(OrderDate)

-- b) podzapytaniami
    select distinct CompanyName, YEAR(OrderDate), MONTH(OrderDate), (select
    sum(Freight) from Orders as o where
                         o.ShipVia = Shippers.ShipperID
                         and YEAR(o.OrderDate) = YEAR(Orders.OrderDate)
                         and MONTH(o.OrderDate) = MONTH(Orders.OrderDate)) from Shippers
    left outer join Orders on Shippers.ShipperID = Orders.ShipVia