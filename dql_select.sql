-- dql.select.sql (Consultas)

-- Encuentra el empleado que ha generado la mayor cantidad de ventas en el último trimestre.
SELECT e.FirstName, e.LastName, MAX(i.total) as totalMasAlto
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId 
GROUP BY c.SupportRepId 
LIMIT 1;
-- Lista los cinco artistas con más canciones vendidas en el último año.
 SELECT a.Name
 FROM Artist a
 JOIN Album al On a.ArtistId = al.ArtistId
 JOIN Track t ON al.AlbumId = t.AlbumId 
 JOIN InvoiceLine il ON t.TrackId = il.TrackId
 GROUP BY a.ArtistId 
 LIMIT 5;
-- Obtén el total de ventas y la cantidad de canciones vendidas por país.
SELECT i.BillingCountry as Pais, COUNT(*) as total
FROM Invoice i
GROUP BY i.BillingCountry
ORDER BY total DESC;
-- Calcula el número total de clientes que realizaron compras por cada género en un mes específico.
SELECT g.Name , COUNT(*) as CantidadCLiente
FROM Customer c 
JOIN Invoice i ON c.CustomerId = i.CustomerId 
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId 
WHERE MONTH(i.InvoiceDate) = '3' 
GROUP BY g.Name
ORDER BY CantidadCLiente DESC;
-- Encuentra a los clientes que han comprado todas las canciones de un mismo álbum.
SELECT c.FirstName, c.LastName, a.Title 
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId  
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId 
JOIN Album a ON t.AlbumId = a.AlbumId
WHERE a.Title = 'Black Album'
GROUP BY c.CustomerId; 
-- Lista los tres países con mayores ventas durante el último semestre.
-- Muestra los cinco géneros menos vendidos en el último año.
-- Calcula el promedio de edad de los clientes al momento de su primera compra.
-- Encuentra los cinco empleados que realizaron más ventas de Rock.
-- Genera un informe de los clientes con más compras recurrentes.
-- Calcula el precio promedio de venta por género.
-- Lista las cinco canciones más largas vendidas en el último año.
-- Muestra los clientes que compraron más canciones de Jazz.
-- Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.
-- Muestra el número de ventas diarias de canciones en cada mes del último trimestre.
-- Calcula el total de ventas por cada vendedor en el último semestre.
-- Encuentra el cliente que ha realizado la compra más cara en el último año.
-- Lista los cinco álbumes con más canciones vendidas durante los últimos tres meses.
-- Obtén la cantidad de canciones vendidas por cada género en el último mes.
-- Lista los clientes que no han comprado nada en el último año.