-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
-- – Ogranicz wynik tylko do pracowników

-- a) którzy mają podwładnych
select Employees.FirstName, Employees.LastName, count(*)
from Orders
         inner join Employees on Orders.EmployeeID = Employees.EmployeeID
         left outer join Employees as e on Employees.EmployeeID = e.ReportsTo
where e.EmployeeID is not null
group by Employees.FirstName, Employees.LastName

-- b) którzy nie mają podwładnych
select Employees.FirstName, Employees.LastName, count(*)
from Orders
         inner join Employees on Orders.EmployeeID = Employees.EmployeeID
         left outer join Employees as e on Employees.EmployeeID = e.ReportsTo
where e.EmployeeID is null
group by Employees.FirstName, Employees.LastName
