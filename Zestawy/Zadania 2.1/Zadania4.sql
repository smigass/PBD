-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
-- podziałem na lata i miesiące
select FirstName, LastName, YEAR(OrderDate), MONTH(OrderDate), count(*) from Employees
inner join Orders on Employees.EmployeeID = Orders.EmployeeID
group by Orders.EmployeeID, FirstName, LastName, YEAR(OrderDate), MONTH(OrderDate)

-- 2. Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej
-- kategorii
select CategoryName ,max(UnitPrice) as max, min(UnitPrice)as min from Products
inner join Categories on Products.CategoryID = Categories.CategoryID
group by CategoryName