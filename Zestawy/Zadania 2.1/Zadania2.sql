-- Podaj liczbę zamówionych jednostek produktów dla produktów, dla których
-- productid < 3
select ProductID, sum(quantity) from [Order Details]
where ProductID < 3
group by ProductID

-- Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę
-- zamówionych jednostek produktu dla wszystkich produktów

select ProductID, sum(quantity) from [Order Details]
group by ProductID
order by 1

-- Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których
-- łączna liczba zamawianych jednostek produktów jest > 250

select OrderID, round(sum((1 - Discount) * Quantity * UnitPrice),2) from [Order Details]
group by OrderID
having sum(Quantity) > 250