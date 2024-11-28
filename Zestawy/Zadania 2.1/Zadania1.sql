-- Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia i
-- zwraca wynik posortowany w malejącej kolejności (wg wartości sprzedaży).

select OrderID, round(sum(((1 - Discount) * Quantity * UnitPrice)),2) from [Order Details]
group by OrderID
order by 2 desc
-- zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych
-- 10 wierszy

select top 10 OrderID, round(sum(((1 - Discount) * Quantity * UnitPrice)),2) from [Order Details]
group by OrderID
order by 2 desc