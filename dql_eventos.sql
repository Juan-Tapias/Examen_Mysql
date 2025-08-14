-- dql_eventos.sql (eventos)

SET GLOBAL event_scheduler = ON;

-- ReporteVentasMensual: Genera un informe mensual de ventas y lo almacena automáticamente.
CREATE TABLE Informes (
	Id INT PRIMARY KEY AUTO_INCREMENT,
	fecha DATE,
	sumaVenta DECIMAL(50,2)
);



DELIMITER //
CREATE EVENT ReporteVentasMensual
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN 
	
	INSERT INTO Informes(fecha, sumaVenta)
	SELECT NOW(), SUM(i.Total)
	FROM Invoice i;	
	
END;
//
DELIMITER ;

-- ActualizarSaldosCliente: Actualiza los saldos de cuenta de clientes al final de cada mes.


-- AlertaAlbumNoVendidoAnual: Envía una alerta cuando un álbum no ha registrado ventas en el último año.
CREATE TABLE alertaAlbum (
	id INT PRIMARY KEY AUTO_INCREMENT,
	albumID INT
);

DELIMITER //
CREATE EVENT AlertaAlbumNoVendidoAnual
ON SCHEDULE EVERY 1 YEAR 
STARTS CURRENT_TIMESTAMP
DO
BEGIN 
	
	INSERT INTO alertaAlbum (albumID)
	SELECT t.AlbumId  
	FROM Invoice i
	JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
	JOIN Track t ON il.TrackId = t.TrackId 
	WHERE i.Total = 0;

END;
//
DELIMITER ;

-- LimpiarAuditoriaCada6Meses: Borra los registros antiguos de auditoría cada seis meses.


-- ActualizarListaDeGenerosPopulares: Actualiza la lista de géneros más vendidos al final de cada mes.
DROP TABLE generosPopulares;
CREATE TABLE generosPopulares (
	id INT PRIMARY KEY AUTO_INCREMENT,
	generoID VARCHAR(50),
	totalVentas INT
);

DELIMITER //
CREATE EVENT ActualizarListaDeGenerosPopulares
ON SCHEDULE EVERY 1 MONTH 
STARTS CURRENT_TIMESTAMP
DO
BEGIN 
	
	TRUNCATE TABLE generosPopulares;
	
	INSERT INTO generosPopulares (generoID, totalVentas)
	SELECT  g.Name, COUNT(*) as total
	FROM Invoice i
	JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId 
	JOIN Track t ON il.TrackId = t.TrackId 
	JOIN Genre g ON t.GenreId = g.GenreId;

END;
DELIMITER ; 

