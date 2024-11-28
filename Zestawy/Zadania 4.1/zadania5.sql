-- Zadanie 1.
select e.FirstName + ' ' + e.LastName as name,
       (
           select sum((1-Discount) * Quantity * UnitPrice) from Orders as o
                                                                    inner join [Order Details] as od
on o.OrderID = od.OrderID
where e.EmployeeID = o.EmployeeID
    ) + (select sum(Freight) from Orders
where e.EmployeeID = Orders.EmployeeID) as suma
from Employees as e
order by suma desc

-- Zadanie 2.
select top 1 e.FirstName + ' ' + e.LastName as name,
             (select round(sum((1 - Discount) * Quantity * UnitPrice), 2)
              from Orders as o
                       inner join [Order Details] as od
                                  on o.OrderID = od.OrderID
              where e.EmployeeID = o.EmployeeID
                and YEAR(OrderDate) = 1997) as suma
from Employees as e
order by suma desc

-- Zadanie 3. a
select distinct e.FirstName + ' ' + e.LastName as name,
                (
                    select sum((1-Discount) * Quantity * UnitPrice) from Orders as o
                                                                             inner join [Order Details] as od
on o.OrderID = od.OrderID
where e.EmployeeID = o.EmployeeID
    ) + (select sum(Freight) from Orders
where e.EmployeeID = Orders.EmployeeID) as suma
from Employees as e
    left join Employees as e2 on e2.ReportsTo = e.EmployeeID
where e2.ReportsTo is not null
order by suma desc

-- Zadanie 3 b
select distinct e.FirstName + ' ' + e.LastName as name,
                (
                    select sum((1-Discount) * Quantity * UnitPrice) from Orders as o
                                                                             inner join [Order Details] as od
on o.OrderID = od.OrderID
where e.EmployeeID = o.EmployeeID
    ) + (select sum(Freight) from Orders
where e.EmployeeID = Orders.EmployeeID) as suma,
from Employees as e
    left join Employees as e2 on e2.ReportsTo = e.EmployeeID
where e2.ReportsTo is null
order by suma desc


-- Zadanie 4. a
select distinct e.FirstName + ' ' + e.LastName as name,
                (
                    select sum((1-Discount) * Quantity * UnitPrice) from Orders as o
                                                                             inner join [Order Details] as od
on o.OrderID = od.OrderID
where e.EmployeeID = o.EmployeeID
    ) + (select sum(Freight) from Orders
where e.EmployeeID = Orders.EmployeeID) as suma,
    (select top 1 OrderDate from Orders as o1
where o1.EmployeeID = e.EmployeeID
order by OrderDate desc )as 'Last Order'

from Employees as e
    left join Employees as e2 on e2.ReportsTo = e.EmployeeID
where e2.ReportsTo is not null
order by suma desc

-- Zadanie 4 b
select distinct e.FirstName + ' ' + e.LastName as name,
                (
                    select sum((1-Discount) * Quantity * UnitPrice) from Orders as o
                                                                             inner join [Order Details] as od
on o.OrderID = od.OrderID
where e.EmployeeID = o.EmployeeID
    ) + (select sum(Freight) from Orders
where e.EmployeeID = Orders.EmployeeID) as suma,
    (select top 1 OrderDate from Orders as o1
where o1.EmployeeID = e.EmployeeID
order by OrderDate desc )as 'Last Order'
from Employees as e
    left join Employees as e2 on e2.ReportsTo = e.EmployeeID
where e2.ReportsTo is null
order by suma desc
