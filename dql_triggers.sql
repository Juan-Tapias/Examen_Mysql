-- Triggers 

-- ActualizarTotalVentasEmpleado: Al realizar una venta, actualiza el total de ventas acumuladas por el empleado correspondiente.
CREATE TABLE totalVentas (
	id INT PRIMARY KEY AUTO_INCREMENT,
	empleadoID INT,
	totalVentas INT 
);


DELIMITER // 
CREATE TRIGGER ActualizarTotalVentasEmpleado
AFTER INSERT ON Invoice
FOR EACH ROW
BEGIN 
	
	DECLARE id_empleado INT;
	
	SELECT 
	FROM Invoice i 
	JOIN Customer c ON i.CustomerId = c.CustomerId 
	JOIN Employee e ON c.SupportRepId = e.EmployeeId
	
END;
DELIMITER ; 

-- IA
-- AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.
CREATE TABLE AuditoriaCliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    CustomerId INT,
    campoModificado VARCHAR(255),
    valorAnterior VARCHAR(255),
    valorNuevo VARCHAR(255),
    fechaCambio DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER // 
CREATE TRIGGER AuditarActualizacionCliente
AFTER UPDATE ON Customer
FOR EACH ROW
BEGIN 
    IF OLD.ContactName <> NEW.ContactName THEN
        INSERT INTO AuditoriaCliente (CustomerId, campoModificado, valorAnterior, valorNuevo)
        VALUES (OLD.CustomerId, 'ContactName', OLD.ContactName, NEW.ContactName);
    END IF;

    IF OLD.CompanyName <> NEW.CompanyName THEN
        INSERT INTO AuditoriaCliente (CustomerId, campoModificado, valorAnterior, valorNuevo)
        VALUES (OLD.CustomerId, 'CompanyName', OLD.CompanyName, NEW.CompanyName);
    END IF;

    IF OLD.Email <> NEW.Email THEN
        INSERT INTO AuditoriaCliente (CustomerId, campoModificado, valorAnterior, valorNuevo)
        VALUES (OLD.CustomerId, 'Email', OLD.Email, NEW.Email);
    END IF;

    IF OLD.Phone <> NEW.Phone THEN
        INSERT INTO AuditoriaCliente (CustomerId, campoModificado, valorAnterior, valorNuevo)
        VALUES (OLD.CustomerId, 'Phone', OLD.Phone, NEW.Phone);
    END IF;

END;
DELIMITER ;

-- RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.
CREATE TABLE HistorialPrecioCancion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    SongId INT,
    precioAnterior DECIMAL(10,2),
    precioNuevo DECIMAL(10,2),
    fechaCambio DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER // 
CREATE TRIGGER RegistrarHistorialPrecioCancion
AFTER UPDATE ON Song
FOR EACH ROW
BEGIN
    IF OLD.Price <> NEW.Price THEN
        INSERT INTO HistorialPrecioCancion (SongId, precioAnterior, precioNuevo)
        VALUES (OLD.SongId, OLD.Price, NEW.Price);
    END IF;
END;
DELIMITER ;


-- NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.
CREATE TABLE Notificaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipoNotificacion VARCHAR(255),
    mensaje VARCHAR(255),
    ventaId INT,
    fechaNotificacion DATETIME DEFAULT CURRENT_TIMESTAMP
);


DELIMITER // 
CREATE TRIGGER NotificarCancelacionVenta
AFTER DELETE ON Invoice
FOR EACH ROW
BEGIN
	
    INSERT INTO Notificaciones (tipoNotificacion, mensaje, ventaId)
    VALUES ('Cancelación de Venta', CONCAT('La venta con ID ', OLD.InvoiceId, ' fue cancelada'), OLD.InvoiceId);
END;
DELIMITER ;

-- RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.

DELIMITER // 
CREATE TRIGGER RestringirCompraConSaldoDeudor
BEFORE INSERT ON Invoice
FOR EACH ROW
BEGIN
    DECLARE saldoDeudor DECIMAL(10,2);
    
    SELECT SUM(Total) INTO saldoDeudor
    FROM Invoice
    WHERE CustomerId = NEW.CustomerId
    AND Pagado = FALSE;

    IF saldoDeudor > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente tiene saldo deudor pendiente y no puede realizar nuevas compras.';
    END IF;
END;
DELIMITER ;