-- 1. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.
select CategoryName, sum(Quantity)
from Categories
         inner join Products on Categories.CategoryID = Products.CategoryID
         inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by CategoryName
order by 2 desc
-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez
-- klientów jednostek towarów z tek kategorii.
select CategoryName, round(sum((1 - Discount) * Quantity * Products.UnitPrice), 2)
from Categories
         inner join Products on Categories.CategoryID = Products.CategoryID
         inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by CategoryName
-- 3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
select CategoryName, round(sum((1 - Discount) * Quantity * Products.UnitPrice), 2)
from Categories
         inner join Products on Categories.CategoryID = Products.CategoryID
         inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by CategoryName
order by 2 desc
-- b) łącznej liczby zamówionych przez klientów jednostek towarów.
select CategoryName, round(sum((1 - Discount) * Quantity * Products.UnitPrice), 2)
from Categories
         inner join Products on Categories.CategoryID = Products.CategoryID
         inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by CategoryName
order by sum(Quantity) desc

-- 4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
select Orders.OrderID, round(sum((1- Discount) * UnitPrice * Quantity) + Orders.Freight,2)from [Order Details]
inner join Orders on [Order Details].OrderID = Orders.OrderID
group by Orders.OrderID, Orders.Freight

