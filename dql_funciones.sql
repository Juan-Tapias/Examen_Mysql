-- dql_funciones.sql (funciones) 

-- TotalGastoCliente(ClienteID, Anio): Calcula el gasto total de un cliente en un año específico.\

DROP  FUNCTION TotalGastoCliente;
DELIMITER //
CREATE FUNCTION TotalGastoCliente (ClienteID INT, anio DATE)
RETURNS DECIMAL(10,2)
DETERMINISTIC 
BEGIN
	
	DECLARE gasto DECIMAL(10,2);
	
	SELECT SUM(i.Total) INTO gasto
	FROM Invoice i
	JOIN Customer c ON i.CustomerId = ClienteID 
	WHERE YEAR(i.InvoiceDate) = YEAR(anio);
	
	RETURN IFNULL(gasto, 0);
END
//
DELIMITER ; 

SELECT TotalGastoCliente(2, '2021-01-01') as total;
-- PromedioPrecioPorAlbum(AlbumID): Retorna el precio promedio de las canciones de un álbum.
DELIMITER //
CREATE FUNCTION PromedioPrecioPorAlbum(AlbumID INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
	
	DECLARE promedio DECIMAL(10,2);
	
	SELECT AVG(t.UnitPrice) INTO promedio
	FROM Track t 
	JOIN Album a ON t.AlbumId = AlbumID;
	
	RETURN IFNULL(promedio, 0);

END
//
DELIMITER ;
SELECT PromedioPrecioPorAlbum(1) as promedio;
-- DuracionTotalPorGenero(GeneroID): Calcula la duración total de todas las canciones vendidas de un género específico.

DROP FUNCTION DuracionTotalPorGenero;
DELIMITER //
CREATE FUNCTION DuracionTotalPorGenero(GeneroID INT)
RETURNS DECIMAL(50,2)
DETERMINISTIC
BEGIN
	
	DECLARE Duracion DECIMAL(50,2);

	SELECT SUM(t.Milliseconds) INTO Duracion
	FROM InvoiceLine il 
	JOIN Track t ON il.TrackId = t.TrackId 
	JOIN Genre g ON t.GenreId  = GeneroID;

	RETURN IFNULL(Duracion, 0);

END
//
DELIMITER ;
SELECT DuracionTotalPorGenero(1);

-- DescuentoPorFrecuencia(ClienteID): Calcula el descuento a aplicar basado en la frecuencia de compra del cliente.
DELIMITER //
CREATE FUNCTION DescuentoPorFrecuencia(ClienteID INT)
RETURNS INT
DETERMINISTIC
BEGIN
	
	DECLARE Descuento INT;
	DECLARE frecuencia INT;
	
	SELECT COUNT(*) INTO frecuencia
	FROM Invoice i 
	JOIN Customer c ON i.InvoiceId = ClienteID;
	
	IF frecuencia >= 10 THEN
		SET Descuento = 10;
	END IF;
	IF frecuencia >= 30 THEN 
		SET Descuento = 30;
	END IF;
	IF frecuencia >= 60 THEN 
		SET Descuento =  50;
	END IF;
	
	RETURN IFNULL(Descuento, 0);
END
//
DELIMITER ;
-- VerificarClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en sus gastos anuales.
DELIMITER //
CREATE FUNCTION VerificarClienteVIP(ClienteID INT)
RETURNS VARCHAR(7)
DETERMINISTIC
BEGIN
	
	DECLARE VIP VARCHAR(7);
	DECLARE gasto DECIMAL;
	
	SELECT SUM(i.Total)  INTO gasto
	FROM Invoice i 
	JOIN Customer c ON i.InvoiceId = ClienteID;
	
	IF gasto >= 500 THEN
		SET VIP = 'VIP';
	END IF;
	IF gasto < 500 THEN 
		SET VIP = 'NO VIP';
	END IF;
	
	RETURN VIP;
END
//
DELIMITER ;