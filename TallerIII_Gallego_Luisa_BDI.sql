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