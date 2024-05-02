drop table if exists detalle_venta;
drop table if exists cabecera_venta;
drop table if exists historial_stock;
drop table if exists detalle_pedido;
drop table if exists cabecera_pedido;
drop table if exists estado_pedidos;
drop table if exists proveedores;
drop table if exists tipo_documento;
drop table if exists productos;
drop table if exists unidades_medida;
drop table if exists categorias_unidad_medida;
drop table if exists categorias;

create table categorias(
	id_categoria serial not null,
	nombre_categoria varchar(100) not null,
	id_categoria_padre int null,
	constraint categorias_pk primary key (id_categoria),
	constraint categorias_fk foreign key (id_categoria_padre)
	references categorias(id_categoria)
);

INSERT INTO categorias(nombre_categoria,id_categoria_padre) 
VALUES('Material Prima', null),
	  ('Proteinas', 1),
	  ('Salsas', 1),
	  ('Punto de Venta', null),
	  ('Bebidas', 4),
	  ('Con Alcohol', 5),
	  ('Sin Alcohol', 5);
	  
SELECT * FROM categorias;

--drop table if exists categorias_unidad_medida;
create table categorias_unidad_medida(
	id_categoria_unidad_medida char(2) not null,
	nombre_categoria_unidad_medida varchar(100) not null,
	constraint categorias_unidad_medida_pk primary key (id_categoria_unidad_medida)
);

INSERT INTO categorias_unidad_medida(id_categoria_unidad_medida,nombre_categoria_unidad_medida)
VALUES ('U','Unidades'),
	   ('V','Volumen'),
	   ('P','Peso');

SELECT * FROM categorias_unidad_medida;

--drop table if exists unidades_medida;
create table unidades_medida(
	id_unidades_medida char(2) not null,
	descripcion varchar(100) not null,
	id_categoria_unidad_medida char(2) not null,
	constraint unidades_medida_pk primary key (id_unidades_medida),
	constraint unidades_medida_fk foreign key (id_categoria_unidad_medida)
	references categorias_unidad_medida(id_categoria_unidad_medida)
);

INSERT INTO unidades_medida(id_unidades_medida,descripcion,id_categoria_unidad_medida)
VALUES('ml','mililitros','V'),
	  ('l','litros','V'),
	  ('u','unidad','U'),
	  ('d','docena','U'),
	  ('g','gramos','P'),
	  ('kg','kilogramos','P'),
	  ('lb','libras','P');
SELECT * FROM unidades_medida;

--drop table if exists productos;
create table productos(
	id_producto serial not null,
	nombre_producto varchar(100) not null,
	id_unidades_medida char(2) not null,
	precio_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	id_categoria int not null,
	stock int not null,
	constraint productos_pk primary key (id_producto),
	constraint productos_unidad_medida_fk foreign key (id_unidades_medida)
	references unidades_medida(id_unidades_medida),
	constraint productos_categoria_fk foreign key (id_categoria)
	references categorias(id_categoria)
);

INSERT INTO productos (nombre_producto,id_unidades_medida,precio_venta,tiene_iva,coste,id_categoria,stock)
VALUES('Coca cola pequeña','u',0.5804,true,0.3729,7,100),
	  ('Salsa de Tomate','kg',0.95,true,0.8736,3,100),
	  ('Cerveza Pilsener','u',1.50,true,0.9036,3,100);
SELECT * FROM productos;

create table tipo_documento(
	id_tipo_documento char(2) not null,
	descripcion varchar(100) not null,
	constraint tipo_documento_pk primary key (id_tipo_documento)
);

INSERT INTO tipo_documento(id_tipo_documento,descripcion)
VALUES ('C','Cédula de identidad'),
	   ('R','Ruc'),
	   ('P','Pasaporte');
SELECT * FROM tipo_documento;

create table proveedores(
	id_proveedores varchar(13) not null,
	id_tipo_documento char(2) not null,
	nombre varchar(100) not null,
	telefono char(10) not null,
	correo varchar(100) not null,
	direccion varchar(100) not null,
	constraint proveedores_pk primary key (id_proveedores),
	constraint proveedores_fk foreign key (id_tipo_documento)
	references tipo_documento(id_tipo_documento)
);

INSERT INTO proveedores(id_proveedores,id_tipo_documento,nombre,telefono,correo,direccion)
VALUES ('1724482722','C','Jean Fuentes','0987137629','jeanpyfuentes67@gmail.com','Monserrat'),
	   ('1763745858909','R','Juan Pedro','0987137629','jeanpyfuentes23@gmail.com','Monserrat uno'),
	   ('1724647389','C','Jean Pedro','0987137629','jeanpyfuentes14@gmail.com','Monserrat dos');
SELECT * FROM proveedores;

create table estado_pedidos(
	id_estado_pedidos char(1) not null,
	descripcion varchar(50) not null,
	constraint estado_pedidos_pk primary key (id_estado_pedidos)
);

INSERT INTO estado_pedidos(id_estado_pedidos,descripcion)
VALUES ('P', 'Pendiente'),
	   ('E', 'Entregado');
	   
SELECT * FROM estado_pedidos;

create table cabecera_pedido(
	id_cabecera_pedido serial not null,
	id_proveedores varchar(13) not null,
	fecha timestamp not null,
	id_estado_pedidos char(1) not null,
	constraint cabecera_pedido_pk primary key (id_cabecera_pedido),
	constraint cabecera_pedido_proveedor_fk foreign key (id_proveedores)
	references proveedores(id_proveedores),
	constraint cabecera_pedido_estado_fk foreign key (id_estado_pedidos)
	references estado_pedidos(id_estado_pedidos)
);

INSERT INTO cabecera_pedido(id_proveedores,fecha,id_estado_pedidos)
VALUES ('1724482722',CURRENT_TIMESTAMP,'P'),
	   ('1763745858909',CURRENT_TIMESTAMP,'E');

SELECT * FROM cabecera_pedido;

create table detalle_pedido(
	id_detalle_pedido serial not null,
	id_cabecera_pedido int not null,
	id_producto int not null,
	cantidad int not null,
	subtotal money not null,
	cantidad_recibida int not null,
	constraint detalle_pedido_pk primary key (id_detalle_pedido),
	constraint id_cabecera_detalle_pedido_fk foreign key (id_cabecera_pedido)
	references cabecera_pedido(id_cabecera_pedido),
	constraint id_producto_detalle_pedido_fk foreign key (id_producto)
	references productos(id_producto)
);

INSERT INTO detalle_pedido(id_cabecera_pedido,id_producto,cantidad,subtotal,cantidad_recibida)
VALUES (1,1,100,450.70,100),
	   (1,2,105,190.45,100),
	   (2,3,45,15.89,25);
	   
SELECT * FROM detalle_pedido;

create table cabecera_venta(
	id_cabecera_venta serial not null,
	fecha timestamp not null,
	total_sin_iva money not null,
	iva int not null,
	total money not null,
	constraint cabecera_venta_pk primary key (id_cabecera_venta)
);

INSERT INTO cabecera_venta(fecha,total_sin_iva,iva,total)
VALUES (CURRENT_TIMESTAMP,463.78,15, 503.67),
	   (CURRENT_TIMESTAMP,123.78,12,178.34);

SELECT * FROM cabecera_venta;

create table historial_stock(
	id_historial_stock serial not null,
	fecha timestamp not null,
	referencia varchar(100) not null,
	id_producto int not null,
	cantidad int not null,
	constraint historial_stock_pk primary key (id_historial_stock),
	constraint id_producto_historial_stock_fk foreign key (id_producto)
	references productos(id_producto)
);

INSERT INTO historial_stock(fecha,referencia,id_producto,cantidad)
VALUES (CURRENT_TIMESTAMP,'REFERENCIA DE STOCK',1,20),
	   (CURRENT_TIMESTAMP,'REFERENCIA DE STOCK',2,40);

SELECT * FROM historial_stock;

create table detalle_venta(
	id_detalle_venta serial not null,
	id_cabecera_venta int not null,
	id_producto int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	subtotal_iva money not null,
	constraint detalle_venta_pk primary key (id_detalle_venta),
	constraint id_cabecera_detalle_venta_fk foreign key (id_cabecera_venta)
	references cabecera_venta(id_cabecera_venta),
	constraint id_producto_detalle_venta_fk foreign key (id_producto)
	references productos(id_producto)
);

INSERT INTO detalle_venta(id_cabecera_venta,id_producto,cantidad,precio_venta,subtotal,subtotal_iva)
VALUES (1,1,100,3.50,300.45,305.45),
	   (2,3,45,1.50,120.56, 130.56);
	   
SELECT * FROM detalle_venta;