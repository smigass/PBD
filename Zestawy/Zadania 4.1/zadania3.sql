-- Zadanie 1

SELECT
    (select CategoryName from Categories as c where p.CategoryID = c.CategoryID),
    ProductName,
    (select AVG(UnitPrice) from Products as p1) as 'Średnia cena',
        UnitPrice,
    -(select AVG(UnitPrice) from Products as p1) + UnitPrice as 'Różnica ceny'
from Products as p


-- Zadanie 2

SELECT
    (select CategoryName from Categories as c where p.CategoryID = c.CategoryID),
    ProductName,
    (select AVG(UnitPrice) from Products as p1
     where p1.CategoryID = p.CategoryID) as 'Średnia cena',
        UnitPrice,
    -(select AVG(UnitPrice) from Products as p1
      where p1.CategoryID = p.CategoryID) + UnitPrice as 'Różnica ceny'
from Products as p
