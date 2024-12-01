-- 1. Jaki był najpopularniejszy autor wśród dzieci w Arizonie w 2001

select top 1 title.author, count(*) as loans
from loanhist
         inner join juvenile on loanhist.member_no = juvenile.member_no
         inner join member on juvenile.member_no = member.member_no
         inner join adult on juvenile.adult_member_no = adult.member_no
         inner join title on loanhist.title_no = title.title_no
where state = 'AZ'
group by title.author
order by 2 desc


-- 2. Dla każdego dziecka wybierz jego imię nazwisko, adres,
-- imię i nazwisko rodzica i ilość książek, które oboje przeczytali w 2001

select m1.firstname,
       m1.lastname,
       m2.firstname,
       m2.lastname,
       street,
       state,
       (select count(*)
        from loanhist
        where loanhist.member_no = juvenile.member_no
          and YEAR(out_date) = 2001) + (select count(*)
                                        from loanhist
                                        where loanhist.member_no = juvenile.adult_member_no
                                          and YEAR(out_date) = 2001)
from juvenile
         inner join adult on juvenile.adult_member_no = adult.member_no
         inner join member m1 on juvenile.member_no = m1.member_no
         inner join member m2 on adult.member_no = m2.member_no

--3. Kategorie które w roku 1997 grudzień były obsłużone wyłącznie przez ‘United Package’

select CategoryName
from Categories
where CategoryID not in (select c.CategoryID
                         from Orders
                                  inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
                                  inner join Products on [Order Details].ProductID = Products.ProductID
                                  inner join Categories c on Products.CategoryID = c.CategoryID
                         where not ShipVia = (select ShipperID
                                              from Shippers
                                              where CompanyName = 'United Package')
                           and YEAR(OrderDate) = 1997
                           and MONTH(OrderDate) = 12)


-- 4. Wybierz klientów, którzy kupili przedmioty wyłącznie z jednej kategorii w marcu 1997
-- i wypisz nazwę tej kategorii
with wanted_customers as (select CustomerID, count(distinct Products.CategoryID) as diff_cat
                          from Orders
                                   inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
                                   inner join Products on [Order Details].ProductID = Products.ProductID
                                   inner join Categories on Products.CategoryID = Categories.CategoryID
                          where YEAR(OrderDate) = 1997
                            and MONTH(OrderDate) = 3
                          group by CustomerID
                          having count(distinct Products.CategoryID) = 1)
select wanted_customers.CustomerID,
       (select distinct CategoryName from Orders
               inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
               inner join Products on [Order Details].ProductID = Products.ProductID
               inner join Categories on Products.CategoryID = Categories.CategoryID
        where CustomerID = wanted_customers.CustomerID
        and YEAR(OrderDate) = 1997
        and MONTH(OrderDate) = 3) from wanted_customers

