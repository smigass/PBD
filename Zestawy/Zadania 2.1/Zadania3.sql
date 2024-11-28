-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień
select EmployeeID, count(*)from Orders
group by EmployeeID


-- 2. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień
select ShipVia, round(sum(Freight), 2)
from Orders
group by ShipVia

-- 3. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień w latach od 1996 do 1997
select ShipVia, round(sum(Freight), 2)
from Orders
where YEAR(OrderDate) IN (1996, 1997)
group by ShipVia