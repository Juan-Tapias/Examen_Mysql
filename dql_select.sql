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

-- IA 
-- Lista los tres países con mayores ventas durante el último semestre.
SELECT c.Country,
       SUM(i.Total) AS TotalVentas
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
GROUP BY c.Country
ORDER BY TotalVentas DESC
LIMIT 3;

-- Muestra los cinco géneros menos vendidos en el último año.
SELECT g.Name AS Genero,
       SUM(il.Quantity) AS CantidadVendida
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
GROUP BY g.Name
ORDER BY CantidadVendida ASC
LIMIT 5;

-- Calcula el promedio de edad de los clientes al momento de su primera compra.
SELECT AVG(DATEDIFF(inv.PrimerCompra, c.BirthDate) / 365.25) AS EdadPromedioEnPrimeraCompra
FROM Customer c
JOIN (
    SELECT CustomerId, MIN(InvoiceDate) AS PrimerCompra
    FROM Invoice
    GROUP BY CustomerId
) inv ON c.CustomerId = inv.CustomerId;

-- Encuentra los cinco empleados que realizaron más ventas de Rock.
SELECT e.EmployeeId,
       e.FirstName,
       e.LastName,
       COUNT(*) AS CantVentasRock
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Rock'
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY CantVentasRock DESC
LIMIT 5;

-- Genera un informe de los clientes con más compras recurrentes.
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       COUNT(i.InvoiceId) AS NumeroCompras
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY NumeroCompras DESC;

-- Calcula el precio promedio de venta por género.
SELECT g.Name AS Genero,
       AVG(il.UnitPrice) AS PrecioPromedio
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY g.Name;

-- Lista las cinco canciones más largas vendidas en el último año.
SELECT t.TrackId,
       t.Name,
       t.Milliseconds/1000.0 AS DuracionSegundos,
       COUNT(il.InvoiceLineId) AS VecesVendida
FROM Track t
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
GROUP BY t.TrackId, t.Name, t.Milliseconds
ORDER BY t.Milliseconds DESC
LIMIT 5;

-- Muestra los clientes que compraron más canciones de Jazz.
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       COUNT(il.InvoiceLineId) AS CantidadJazzCompradas
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
WHERE g.Name = 'Jazz'
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY CantidadJazzCompradas DESC;

-- Encuentra la cantidad total de minutos comprados por cada cliente en el último mes.
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       SUM(t.Milliseconds) / (1000 * 60) AS MinutosComprados
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
GROUP BY c.CustomerId, c.FirstName, c.LastName;

-- Muestra el número de ventas diarias de canciones en cada mes del último trimestre.
SELECT DATE(i.InvoiceDate) AS Fecha,
       COUNT(il.InvoiceLineId) AS CantVentaDiaria
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
GROUP BY Fecha
ORDER BY Fecha;

-- Calcula el total de ventas por cada vendedor en el último semestre.
SELECT e.EmployeeId,
       e.FirstName,
       e.LastName,
       SUM(i.Total) AS TotalVentas
FROM Employee e
JOIN Customer c ON e.EmployeeId = c.SupportRepId
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH)
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY TotalVentas DESC;

-- Encuentra el cliente que ha realizado la compra más cara en el último año.
SELECT c.CustomerId,
       c.FirstName,
       c.LastName,
       i.InvoiceId,
       i.Total AS ValorCompra
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
ORDER BY i.Total DESC
LIMIT 1;

-- Lista los cinco álbumes con más canciones vendidas durante los últimos tres meses.
SELECT al.AlbumId,
       al.Title,
       COUNT(il.InvoiceLineId) AS CancionesVendidas
FROM Album al
JOIN Track t ON al.AlbumId = t.AlbumId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 3 MONTH)
GROUP BY al.AlbumId, al.Title
ORDER BY CancionesVendidas DESC
LIMIT 5;

-- Obtén la cantidad de canciones vendidas por cada género en el último mes.
SELECT g.Name AS Genero,
       COUNT(il.InvoiceLineId) AS CancionesVendidas
FROM Genre g
JOIN Track t ON g.GenreId = t.GenreId
JOIN InvoiceLine il ON t.TrackId = il.TrackId
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
WHERE i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH)
GROUP BY g.Name
ORDER BY CancionesVendidas DESC;

-- Lista los clientes que no han comprado nada en el último año.
SELECT c.CustomerId,
       c.FirstName,
       c.LastName
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
     AND i.InvoiceDate >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
WHERE i.InvoiceId IS NULL;
