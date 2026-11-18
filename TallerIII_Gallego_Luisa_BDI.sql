CREATE DATABASE ferreteria;
USE ferreteria;



-- 1. TABLAS MAESTRAS

CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cedula_nit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cedula_nit VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

CREATE TABLE marca (
    id_marca INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    pais VARCHAR(50)
);

CREATE TABLE ubicacion_bodega (
    id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
    codigo_pasillo VARCHAR(20) NOT NULL UNIQUE,
    zona VARCHAR(50) NOT NULL
);

CREATE TABLE metodo_pago (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- 2. TABLAS TRANSACCIONALES

CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL CHECK (precio_unitario > 0),
    cantidad_stock DECIMAL(12,2) NOT NULL CHECK (cantidad_stock >= 0),
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    id_marca INT NOT NULL,
    id_ubicacion INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) ON DELETE RESTRICT,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) ON DELETE RESTRICT,
    FOREIGN KEY (id_marca) REFERENCES marca(id_marca) ON DELETE RESTRICT,
    FOREIGN KEY (id_ubicacion) REFERENCES ubicacion_bodega(id_ubicacion) ON DELETE RESTRICT
);

CREATE TABLE suministro (
    id_suministro INT AUTO_INCREMENT PRIMARY KEY,
    precio_compra DECIMAL(12,2) NOT NULL CHECK (precio_compra > 0),
    plazo_entrega_dias INT NOT NULL CHECK (plazo_entrega_dias > 0),
    id_producto INT NOT NULL,
    id_proveedor INT NOT NULL,
    UNIQUE (id_producto, id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) ON DELETE CASCADE
);

CREATE TABLE venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL,
    total_venta DECIMAL(14,2) NOT NULL,
    id_cliente INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT,
    FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago) ON DELETE RESTRICT
);

CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    cantidad DECIMAL(12,2) NOT NULL CHECK (cantidad > 0),
    precio_unitario_venta DECIMAL(10,2) NOT NULL CHECK (precio_unitario_venta > 0),
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    UNIQUE (id_venta, id_producto),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE RESTRICT
);

USE ferreteria;
INSERT INTO marca (nombre, pais) VALUES ('Stanley', 'Estados Unidos');

USE ferreteria;
INSERT INTO categoria (nombre, descripcion) VALUES ('Herramientas Manuales', 'Herramientas de operacion manual');


INSERT INTO proveedor (nombre, cedula_nit, telefono, direccion, correo_electronico) VALUES ('Herragro', '800123456-7', '6068889999', 'Zona Industrial', 'ventas@herragro.com');
INSERT INTO ubicacion_bodega (codigo_pasillo, zona) VALUES ('Pasillo A1', 'Bodega Principal');

USE ferreteria;
INSERT INTO producto (nombre, unidad_medida, precio_unitario, cantidad_stock, id_categoria, id_proveedor, id_marca, id_ubicacion) 
VALUES ('Martillo', 'Unidad', 25000.00, 50.00, 1, 1, 1, 1);

USE ferreteria;
INSERT INTO producto (nombre, unidad_medida, precio_unitario, cantidad_stock, id_categoria, id_proveedor, id_marca, id_ubicacion) 
VALUES ('Destornillador', 'Unidad', -5000.00, 10.00, 1, 1, 1, 1);

USE ferreteria;
INSERT INTO categoria (nombre, descripcion) VALUES ('Herramientas Manuales', 'Otra descripcion diferente');

USE ferreteria;
INSERT INTO producto (nombre, unidad_medida, precio_unitario, cantidad_stock, id_categoria, id_proveedor, id_marca, id_ubicacion) 
VALUES ('Taladro Percutor', 'Unidad', 180000.00, 15.00, 999, 1, 1, 1);

-- CARGA DE DATOS SINTETICOS
USE ferreteria;

-- 1. CATEGORIAS
INSERT INTO categoria (nombre, descripcion) VALUES
('Herramientas Electricas', 'Taladros, pulidoras y sierras electricas'),
('Materiales de Construccion', 'Cemento, arena, ladrillos y varillas'),
('Pinturas y Acabados', 'Vinilos, esmaltes, brochas y rodillos'),
('Plomeria', 'Tuberias PVC, griferia y accesorios sanitarios'),
('Electricidad', 'Cables, tomas, interruptores y breakers'),
('Tornilleria y Fijaciones', 'Tornillos, puntillas, chazos y tuercas'),
('Seguridad Industrial', 'Cascos, guantes, gafas y botas de seguridad');

-- 2. MARCAS
INSERT INTO marca (nombre, pais) VALUES
('DeWalt', 'Estados Unidos'),
('Bosch', 'Alemania'),
('Pintuco', 'Colombia'),
('Pavco', 'Colombia'),
('Argos', 'Colombia'),
('Truper', 'M?xico'),
('3M', 'Estados Unidos'),
('Makita', 'Jap?n'),
('Sika', 'Suiza');

-- 3. UBICACIONES EN BODEGA
INSERT INTO ubicacion_bodega (codigo_pasillo, zona) VALUES
('Pasillo A2', 'Bodega Principal'),
('Pasillo B1', 'Zona Pesada'),
('Pasillo B2', 'Zona Pesada'),
('Pasillo C1', 'Mostrador'),
('Pasillo C2', 'Mostrador'),
('Pasillo D1', 'Estanteria Electrica'),
('Pasillo D2', 'Estanteria Plomeria'),
('Pasillo E1', 'Bodega Pinturas'),
('Pasillo E2', 'Seguridad Industrial');

-- 4. METODOS DE PAGO
INSERT INTO metodo_pago (nombre) VALUES
('Efectivo'),
('Tarjeta Debito'),
('Tarjeta Credito'),
('Transferencia Bancaria'),
('Nequi / Daviplata');

-- 5. PROVEEDORES
INSERT INTO proveedor (nombre, cedula_nit, telefono, direccion, correo_electronico) VALUES
('Distribuidora Ferretera del Eje', '900112233-1', '6068812233', 'Av. Kevin Angel #45-10', 'pedidos@ferreeje.com'),
('Cementos y Materiales Caldas', '900223344-2', '6068823344', 'Km 4 Via Chinchina', 'ventas@cemcaldas.com'),
('Pinturas y Quimicos S.A.S.', '900334455-3', '6068834455', 'Parque Industrial Juanchito', 'contacto@pintquim.com'),
('Tuberias del Occidente', '900445566-4', '6068845566', 'Calle 22 #15-30', 'comercial@tuboccidente.com'),
('ElectroInsumos Colombia', '900556677-5', '6068856677', 'Carrera 23 #50-12', 'ventas@electroinsumos.co'),
('Tornillos y Perfiles Ltda.', '900667788-6', '6068867788', 'Zona Industrial Malteria', 'despachos@torniperfiles.com'),
('Dotaciones Seguras S.A.', '900778899-7', '6068878899', 'Av. Santander #62-18', 'info@dotacionesseguras.com'),
('Importadora de Herramientas Pro', '900889900-8', '6068889900', 'Carrera 20 #18-45', 'importaciones@herrapro.com'),
('FerreMayoristas Nacionales', '900990011-9', '6068890011', 'Calle 65 #24-11', 'cartera@ferremayoristas.co');

-- 6. CLIENTES
INSERT INTO cliente (nombre, cedula_nit, telefono, direccion, correo_electronico) VALUES
('Carlos Andres Mejia', '1053789001', '3104567801', 'Barrio Palermo Cra 25 #66-12', 'carlos.mejia@gmail.com'),
('Constructora Horizonte S.A.S.', '901234567-1', '3114567802', 'Av. Paralela #48-20', 'compras@horizonte.com.co'),
('Maria Fernanda Rios', '1053789003', '3124567803', 'Barrio La Sultana Cll 68 #10-15', 'majo.rios@hotmail.com'),
('Jorge Ivan Salazar', '75098704', '3134567804', 'Barrio Chipre Cll 12 #8-30', 'jorge.salazar@gmail.com'),
('Inversiones Obras Civiles', '901345678-2', '3144567805', 'Centro Cra 22 #24-18', 'logistica@obrasciviles.co'),
('Diana Carolina Gomez', '1053789006', '3154567806', 'Barrio Milan Cra 23 #72-40', 'diana.gomez@outlook.com'),
('Luis Eduardo Restrepo', '75098707', '3164567807', 'Villamaria Cll 7 #5-22', 'luis.restrepo@gmail.com'),
('Remodelaciones del Cafe', '901456789-3', '3174567808', 'Barrio Versalles Cll 50 #26-10', 'proyectos@remodelacafe.com'),
('Sandra Milena Osorio', '30312009', '3184567809', 'Barrio Fatima Cra 34 #65-05', 'sandra.osorio@gmail.com'),
('Andres Felipe Cardona', '1053789010', '3194567810', 'Barrio San Jorge Cll 48 #18-25', 'af.cardona@yahoo.com'),
('Hector Fabio Giraldo', '75098711', '3204567811', 'Barrio Aranjuez Cra 40 #67-14', 'hector.giraldo@gmail.com'),
('Ingenieria y Redes Eje', '901567890-4', '3214567812', 'Barrio El Cable Cra 23 #64-30', 'suministros@ingredeseje.co'),
('Paula Andrea Valencia', '1053789013', '3004567813', 'Barrio La Rambla Cll 63 #20-11', 'paula.valencia@gmail.com'),
('Jose Albeiro Quintero', '75098714', '3014567814', 'Barrio Estambul Cll 28 #35-08', 'jose.quintero@hotmail.com'),
('Ferreteria El Maestro (Minorista)', '901678901-5', '3024567815', 'Galeria Cra 18 #21-40', 'elmaestro@ferre.co'),
('Natalia Lopez Bedoya', '1053789016', '3044567816', 'Barrio Alta Suiza Cll 73 #21-19', 'natalia.lopez@gmail.com'),
('Oscar Mauricio Marin', '75098717', '3054567817', 'Barrio La Enea Cra 35 #102-15', 'oscar.marin@gmail.com'),
('Arquitectura Moderna Caldas', '901789012-6', '3105567818', 'Barrio Estrella Cll 58 #24-33', 'compras@arqmoderna.co'),
('Claudia Patricia Arias', '30312019', '3115567819', 'Barrio Campohermoso Cra 12 #45-20', 'claudia.arias@outlook.com'),
('Juan Sebastian Montoya', '1053789020', '3125567820', 'Barrio Malabar Cll 65 #38-12', 'juanse.montoya@gmail.com'),
('Mantenimientos Industriales S.A.', '901890123-7', '3135567821', 'Zona Industrial Cra 30 #98-50', 'mant@industriales.com.co'),
('Gloria Ines Ramirez', '30312022', '3145567822', 'Barrio Linares Cll 52 #23-14', 'gloria.ramirez@gmail.com'),
('Diego Alejandro Castro', '1053789023', '3155567823', 'Barrio San Sebastian Cll 49 #3-18', 'diego.castro@gmail.com'),
('Taller Metalico El Yunque', '901901234-8', '3165567824', 'Barrio El Bosque Cll 15 #28-44', 'elyunque@taller.co'),
('Valentina Duque Herrera', '1053789025', '3175567825', 'Barrio Los Rosales Cra 24 #55-10', 'valen.duque@gmail.com');

-- 7. PRODUCTOS
INSERT INTO producto (nombre, unidad_medida, precio_unitario, cantidad_stock, id_categoria, id_proveedor, id_marca, id_ubicacion) VALUES
('Taladro Percutor 1/2 Pulgada', 'Unidad', 320000.00, 3.00, 2, 9, 2, 2),
('Pulidora Angular 4-1/2', 'Unidad', 285000.00, 12.00, 2, 9, 3, 2),
('Cemento Gris Uso General 50kg', 'Bulto', 34500.00, 4.00, 3, 3, 6, 3),
('Cable Encauchetado 3x12 AWG', 'Metro', 9800.00, 150.50, 6, 6, 7, 7),
('Vinilo Tipo 1 Blanco Galon', 'Galon', 68000.00, 25.00, 4, 4, 4, 9),
('Tubo PVC Sanitario 4 Pulgadas x 6m', 'Unidad', 42000.00, 30.00, 5, 5, 5, 8),
('Puntilla con Cabeza 2 Pulgadas', 'Kilogramo', 12500.00, 45.75, 7, 7, 7, 5),
('Casco de Seguridad Industrial', 'Unidad', 28000.00, 40.00, 8, 8, 8, 10),
('Sierra Circular 7-1/4 Pulgadas', 'Unidad', 410000.00, 2.00, 2, 9, 9, 2),
('Impermeabilizante SikaFill 5 anos', 'Galon', 95000.00, 18.00, 4, 4, 10, 9),
('Juego de Destornilladores x 6', 'Juego', 48000.00, 22.00, 1, 2, 1, 1),
('Llave Inglesa Ajustable 10 Pulgadas', 'Unidad', 36000.00, 15.00, 1, 2, 7, 1),
('Toma Doble con Polo a Tierra', 'Unidad', 8500.00, 80.00, 6, 6, 3, 7),
('Guantes de Nitrilo Reforzados', 'Par', 11000.00, 60.00, 8, 8, 8, 10),
('Tornillo Drywall 1 Pulgada', 'Kilogramo', 18000.00, 3.50, 7, 7, 7, 5),
('Codo PVC Presion 1/2 Pulgada', 'Unidad', 1500.00, 200.00, 5, 5, 5, 8),
('Alambre Dulce Calibre 18', 'Kilogramo', 14000.00, 35.20, 3, 3, 1, 4),
('Brocha Cerda Natural 3 Pulgadas', 'Unidad', 16500.00, 4.00, 4, 4, 4, 6),
('Flexometro Cinta Metrica 5m', 'Unidad', 22000.00, 28.00, 1, 1, 1, 6);

-- 8. SUMINISTROS
INSERT INTO suministro (precio_compra, plazo_entrega_dias, id_producto, id_proveedor) VALUES
(18000.00, 3, 1, 1),
(245000.00, 5, 2, 9),
(215000.00, 5, 3, 9),
(27000.00, 2, 4, 3),
(6800.00, 4, 5, 6),
(51000.00, 3, 6, 4),
(31000.00, 3, 7, 5),
(8500.00, 2, 8, 7),
(19500.00, 4, 9, 8),
(325000.00, 7, 10, 9),
(72000.00, 4, 11, 4),
(34000.00, 3, 12, 2),
(25000.00, 3, 13, 2),
(5200.00, 2, 14, 6),
(7000.00, 3, 15, 8),
(12500.00, 2, 16, 7),
(850.00, 2, 17, 5),
(9500.00, 3, 18, 3),
(11000.00, 2, 19, 4),
(15000.00, 3, 20, 1);

-- 9. VENTAS
INSERT INTO venta (fecha, total_venta, id_cliente, id_metodo_pago) VALUES
('2026-08-05 09:15:00', 0.00, 1, 1),
('2026-08-08 11:30:00', 0.00, 2, 4),
('2026-08-12 14:20:00', 0.00, 3, 5),
('2026-08-15 16:45:00', 0.00, 4, 2),
('2026-08-20 10:05:00', 0.00, 5, 4),
('2026-08-25 15:10:00', 0.00, 6, 1),
('2026-09-02 08:50:00', 0.00, 7, 3),
('2026-09-05 13:25:00', 0.00, 8, 4),
('2026-09-09 17:00:00', 0.00, 9, 5),
('2026-09-14 09:40:00', 0.00, 10, 1),
('2026-09-18 11:15:00', 0.00, 11, 2),
('2026-09-22 14:55:00', 0.00, 12, 4),
('2026-09-27 16:10:00', 0.00, 13, 1),
('2026-10-01 08:30:00', 0.00, 14, 5),
('2026-10-04 10:20:00', 0.00, 15, 4),
('2026-10-07 12:45:00', 0.00, 16, 2),
('2026-10-10 15:30:00', 0.00, 17, 1),
('2026-10-13 09:05:00', 0.00, 18, 3),
('2026-10-16 11:50:00', 0.00, 19, 5),
('2026-10-19 14:15:00', 0.00, 20, 1),
('2026-10-22 16:40:00', 0.00, 21, 4),
('2026-10-25 10:10:00', 0.00, 22, 2),
('2026-10-28 13:00:00', 0.00, 23, 1),
('2026-10-30 17:20:00', 0.00, 24, 4),
('2026-11-01 09:30:00', 0.00, 25, 5),
('2026-11-03 11:00:00', 0.00, 1, 2),
('2026-11-05 14:45:00', 0.00, 2, 4),
('2026-11-07 16:15:00', 0.00, 5, 4),
('2026-11-09 08:40:00', 0.00, 8, 3),
('2026-11-10 10:55:00', 0.00, 12, 4),
('2026-11-12 13:20:00', 0.00, 15, 1),
('2026-11-14 15:05:00', 0.00, 18, 3),
('2026-11-15 09:50:00', 0.00, 21, 4),
('2026-11-16 12:10:00', 0.00, 3, 5),
('2026-11-17 16:30:00', 0.00, 10, 1);

-- 10. DETALLES DE VENTA
INSERT INTO detalle_venta (cantidad, precio_unitario_venta, id_venta, id_producto) VALUES
(2.00, 25000.00, 1, 1),
(1.50, 12500.00, 1, 8),
(10.00, 34500.00, 2, 4),
(2.00, 320000.00, 2, 2),
(2.00, 68000.00, 3, 6),
(3.00, 16500.00, 3, 19),
(15.50, 9800.00, 4, 5),
(5.00, 42000.00, 5, 7),
(20.00, 1500.00, 5, 17),
(1.00, 48000.00, 6, 12),
(1.00, 285000.00, 7, 3),
(4.00, 28000.00, 8, 9),
(4.00, 11000.00, 8, 15),
(1.00, 95000.00, 9, 11),
(2.50, 14000.00, 10, 18),
(1.00, 36000.00, 11, 13),
(25.00, 9800.00, 12, 5),
(10.00, 8500.00, 12, 14),
(1.00, 22000.00, 13, 20),
(3.00, 18000.00, 14, 16),
(15.00, 34500.00, 15, 4),
(2.00, 68000.00, 16, 6),
(1.00, 25000.00, 17, 1),
(1.00, 410000.00, 18, 10),
(2.00, 16500.00, 19, 19),
(0.50, 12500.00, 20, 8),
(6.00, 28000.00, 21, 9),
(6.00, 11000.00, 21, 15),
(1.00, 48000.00, 22, 12),
(12.00, 9800.00, 23, 5),
(2.00, 285000.00, 24, 3),
(1.00, 22000.00, 25, 20),
(4.00, 8500.00, 26, 14),
(8.00, 42000.00, 27, 7),
(2.00, 95000.00, 28, 11),
(1.00, 320000.00, 29, 2),
(30.00, 9800.00, 30, 5),
(5.00, 14000.00, 31, 18),
(2.00, 68000.00, 32, 6),
(1.00, 410000.00, 33, 10),
(10.00, 1500.00, 34, 17),
(2.00, 36000.00, 35, 13),
(1.50, 18000.00, 35, 16),
(5.00, 34500.00, 27, 4),
(2.00, 25000.00, 31, 1);

-- 11. ACTUALIZAR EL TOTAL DE CADA VENTA
UPDATE venta v
SET total_venta = (
    SELECT SUM(d.cantidad * d.precio_unitario_venta)
    FROM detalle_venta d
    WHERE d.id_venta = v.id_venta
)
WHERE v.id_venta > 0;