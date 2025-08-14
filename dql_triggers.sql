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

-- AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.

-- RegistrarHistorialPrecioCancion: Guarda el historial de cambios en el precio de las canciones.

-- NotificarCancelacionVenta: Registra una notificación cuando se elimina un registro de venta.

-- RestringirCompraConSaldoDeudor: Evita que un cliente con saldo deudor realice nuevas compras.