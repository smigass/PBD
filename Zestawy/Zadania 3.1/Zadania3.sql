-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r

select CompanyName, count(*)from Orders
inner join Shippers on Orders.ShipVia = Shippers.ShipperID
where YEAR(OrderDate) = 1997
group by CompanyName

-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę
-- zamówień) w 1997r, podaj nazwę tego przewoźnika

select top 1 CompanyName, count(*)from Orders
inner join Shippers on Orders.ShipVia = Shippers.ShipperID
where YEAR(OrderDate) = 1997
group by CompanyName
order by 2 desc

-- 3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika

select FirstName, LastName, round(sum((1 - Discount) * Quantity * UnitPrice), 2)from [Order Details]
inner join Orders on Orders.OrderID = [Order Details].OrderID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
group by FirstName, LastName
order by  3 desc

-- 4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
-- nazwisko takiego pracownika
select top 1 FirstName, LastName, count(*)from [Order Details]
inner join Orders on [Order Details].OrderID = Orders.OrderID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
where YEAR(OrderDate) = 1997
group by FirstName, LastName
order by  3 desc


-- 5. Który z pracowników był najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika

select top 1 FirstName, LastName, round(sum((1 - Discount) * Quantity * UnitPrice), 2) from [Order Details]
inner join Orders on Orders.OrderID = [Order Details].OrderID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
where YEAR(OrderDate) = 1997
group by FirstName, LastName
order by  3 desc