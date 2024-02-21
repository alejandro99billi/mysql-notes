create schema curso_sql

use curso_sql;
/*convenciones en sql es usar las palabras reservadas en mayusculas
primare key un campo unico que no se repite en la tabla
VARCHAR es como un char dinamico uso lo que necesita el registro 
todos los comandos con alter son definidos abajos 

*/
CREATE TABLE customer (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE admin (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(50) NOT NULL
);

CREATE TABLE doctors (
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(50) NOT NULL
);

ALTER TABLE doctors 
ADD email VARCHAR(50);

ALTER TABLE admin  
ADD email VARCHAR(50);

ALTER TABLE customer  
ADD email VARCHAR(50);

ALTER TABLE customer  
ADD phone VARCHAR(50);

ALTER TABLE admin  
ADD phone VARCHAR(50);

ALTER TABLE admin  
DROP COLUMN phone;

ALTER TABLE customer
DROP phone;

ALTER TABLE customer 
MODIFY COLUMN email VARCHAR(200) NOT NULL;

DROP TABLE doctors;

INSERT INTO customer(name,email) VALUES('alejandro', 'alejandro@gmail.com');
INSERT INTO customer(name,email) VALUES 
('alejandroX', 'alejandro@gmail.com'),
('alejandroY', 'alejandro@gmail.com'),
('alejandroz', 'alejandroy@gmail.com');

SELECT * FROM customer;

SELECT * FROM customer LIMIT 2,2;

SELECT name FROM customer

SELECT UPPER(name) FROM customer;
SELECT LOWER(name) FROM customer;
--uso de alias con as
SELECT name, LENGTH (name) as 'longitud' FROM customer;

SELECT * FROM customer 
ORDER BY id;


SELECT * FROM customer 
ORDER BY id DESC;


SELECT * FROM customer 
ORDER BY LOWER(name);

SELECT * FROM customer 
ORDER BY LOWER(name), email;

SELECT * FROM customer 
WHERE name = 'alejandroz' AND email = 'alejandroy@gmail.com';

SELECT * FROM customer 
WHERE LENGTH(name)>=10;

UPDATE customer SET name = 'pancho' 
WHERE id= 1;

UPDATE customer SET name = UPPER(NAME) 
WHERE name = 'pancho';

SELECT * FROM customer c 

UPDATE customer SET name = 'aleister',email = 'prova@gmail.com'
WHERE id= 2;

UPDATE customer SET name = UPPER(name)
WHERE id IN(2,4,5);

UPDATE customer SET name = UPPER('pancho')
WHERE  id=1;

DELETE FROM customer 
WHERE id= 1;

-- USO IN PARA USAR MAS ID
DELETE FROM customer 
WHERE id IN (2,3);

-- elimina toda la tabla y reseta el id TRUNCATE TABLE customer 
 

-- agrupar datos

SELECT * FROM customer c 

INSERT INTO customer (name, email) VALUES ('alejandroY','prova@gmail.com');

-- agrupados en sql en este caso cuento de registros iguales
SELECT  name, COUNT(*) AS 'cantidad'
FROM customer c 
GROUP BY name;

-- CONSTRAINS:

-- primary key es un valor inmutable que identifica nuestra tabla  

CREATE TABLE city(
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50)
)



-- null

ALTER TABLE city 
CHANGE COLUMN 
name
name VARCHAR(50) NOT NULL;

INSERT INTO city(name)
VALUES('GUAYAQUIL');

-- unique no permite repetir valores por ejemplo un placa de carro es un indici por ende se busca mas rapido

ALTER TABLE city 
ADD UNIQUE(name);

-- SI Intento guardar otra ciudad con el mismo nombre me dara error cuando se hace un intento de insercion la base de datos se incrementa

SELECT * FROM city c ;

-- DEFAULT 
-- si no mando el valor entonces sse autompila el campo en caso de mandarlo el campo llega y le da prioridad
SELECT * FROM customer c ;
ALTER TABLE customer 
ADD COLUMN currency varchar(3) DEFAULT '$';

ALTER TABLE customer ADD COLUMN created_at DATETIME;

ALTER TABLE customer 
ALTER created_at SET DEFAULT CURRENT_TIMESTAMP(); 

INSERT INTO customer (name,email) VALUES('Rodri','rod@gmail.com');


-- INDEX porque son tan rapidos ? es un arbol binario organiza la informacion con mayores y menores para dividir el tramo de busqueda
-- 2^10 informacion que tengo = 1024 pero con los arboles uso 10 
-- cuando agrega un dato pero cuando se modifica son lentos porque el arbol se recalibre


CREATE INDEX idx_name ON customer(name);

ALTER TABLE customer DROP INDEX idx_name;

-- CHECK me permiter darle reglas de valores dentro de mi tabla

ALTER TABLE customer 
ADD CONSTRAINT check_name
CHECK(name <> 'abc'); -- <> OPERADOR DIVERSO DE

INSERT INTO customer(name, email)
VALUES('abc','abc@gmail.com') -- no me lo deja ejecutar

SHOW CREATE TABLE customer; -- me muestra el codigo de la creacion de la tabla

ALTER TABLE customer 
DROP CONSTRAINT check_name;


INSERT INTO customer(name, email)
VALUES('abc','abc@gmail.com') -- ahora si

ALTER TABLE customer 
ADD CONSTRAINT check_name
CHECK(name <> 'abc'); -- si lo aplico ahora me da error porque el valor ya existe


-- FORGERYN KEY (LLAVES FORANEAS) me sirve para relacionar la info con otras tablas nos da integridad para tener la informacion no repitida

ALTER TABLE customer ADD COLUMN city_id INT;

ALTER TABLE customer ADD CONSTRAINT fk_city
FOREIGN KEY(city_id) REFERENCES city(id);

-- no puedo agregar un campo que  no tenga un valor en city 

INSERT INTO customer(name,email,city_id) VALUES('JUAN','juan@gmail.com',1);


-- JOINS

-- INNER JOIN INFORMACION QUE REPRESENTA LA INTERCENCION EN EL DIAGRAMA DE BEEN

SELECT * FROM customer  INNER JOIN city  ON city.id = customer.city_id;

SELECT * FROM  city c 

SELECT customer.name, c.name as 'city' FROM customer INNER JOIN city as c ON c.id = customer.city_id; -- EL SEGUNDO ALIAS me permiter ver la tabla como name | city (como otra columna)


-- LEFT JOIN trae todo de la tabla de customer tengan o no tengan relacion

SELECT customer.name, city.name as 'city' FROM customer 
LEFT JOIN city  ON city.id = customer.city_id;


SELECT customer.name, IFNULL(city.name, 'Sin Ciudad') as 'city' FROM customer 
LEFT JOIN city  ON city.id = customer.city_id;

-- RIGTH JOIN lo contrario al left

INSERT INTO customer(name,email,city_id) VALUES('Gonzalo','gonzalo@gmail.com',1);
INSERT INTO customer(name,email,city_id) VALUES('JUAN','juan@gmail.com',1);


SELECT customer.name, IFNULL(city.name, 'Sin Ciudad') as 'city' FROM customer 
RIGHT JOIN city  ON city.id = customer.city_id;


-- CROS JOIN combinatoria de registros de las tablas

SELECT * FROM customer c CROSS JOIN city c2 

-- UNION union de dos o mas consultas deven tener el mismo tipo de columnas 2x2 1x1 ecc

SELECT id , name , 'cliente'FROM customer 

UNION

SELECT id, name, 'ciudad' FROM city c 

-- SELF JOIN join a si mismos solo los registros referidos 

ALTER TABLE customer ADD COLUMN reference_id INT;
ALTER TABLE customer  ADD CONSTRAINT fk_referred FOREIGN KEY(reference_id) REFERENCES customer(id);

SET  SQL_SAFE_UPDATES =0; 

UPDATE customer SET reference_id = 4 WHERE id <> 1; 

SELECT c1.name,IFNULL(c2.name, 'sin referencia') as 'quien te recomienda' FROM customer as c1 INNER JOIN customer as c2
ON c2.id = c1.reference_id;

-- FULl JOIN Trae todos los registros 

SELECT * FROM customer LEFT JOIN city ON city.id = customer.city_id 
UNION 
SELECT * FROM customer RIGHT JOIN city ON city.id = customer.city_id 


-- CASE es un swicth case

SELECT name,
 CASE 
   WHEN currency = 'MXN' THEN 'peso mexicano'
   WHEN currency = 'USD' THEN 'Dolar americano'
   ELSE 'otra moneda'
    
 END as 'Moneda'
 FROM customer c 
 
 -- Subconsultas 
 SELECT * FROM customer c 
 SELECT name,
 IFNULL((SELECT name FROM city 
 WHERE city.id = c.city_id),'si ciudad') as 'city' 
FROM customer c ;

SELECT c.name FROM (SELECT name FROM customer WHERE city_id IS NULL) as c
ORDER BY name DESC ;

SELECT name, (SELECT COUNT(*) FROM customer c WHERE city.id = c.city_id) as 'cantidad'
FROM city

SELECT name FROM city WHERE (SELECT COUNT(*) FROM customer c WHERE city.id = c.city_id) > 0

-- LIMIT limita el numero de registro que retorna para paginados

SELECT name FROM customer LIMIT 5 

SELECT name FROM customer ORDER BY id DESC  LIMIT 3,5 

-- insert into con tablas a part usando select
INSERT INTO  customer(name, email) SELECT name, 'email@correo.com' FROM city;

-- order by aletoria
SELECT  id, name
FROM customer c 
ORDER BY RAND()
LIMIT 1;



-- operadores


SELECT * FROM customer
WHERE LENGTH (name) >4 OR city_id IS NULL;

SELECT * FROM customer WHERE NOT(name = 'alejandroY')

SELECT * FROM customer c 
WHERE LENGTH (name) <=4;


SELECT * FROM customer
WHERE LENGTH (name) <> 'JUAN';


SELECT * FROM customer
WHERE LENGTH (name) != 'JUAN';

SELECT * FROM customer c WHERE created_at  > '2024-02-05 19:29:57.000'


SELECT * FROM customer c WHERE YEAR (created_at)  > 2024

-- between

SELECT * FROM customer c 
WHERE created_at BETWEEN '2023-08-24' AND '2024-08-26'

SELECT * FROM customer c 
WHERE id 
BETWEEN  5 AND 10

SELECT SUBSTR(UPPER(name) ,1,1),name FROM customer c 
WHERE SUBSTR(UPPER(name),1,1)
BETWEEN  'a' AND 'r'


-- clausula IN
SELECT * FROM customer c 
WHERE id  IN(1,2,3);

SELECT * FROM customer c 
WHERE id NOT IN(1,2,3);


SELECT * FROM customer c 
WHERE c.name IN('JUAN', 'Gonzalo');

SELECT * FROM city c WHERE id IN (
SELECT DISTINCT city_id FROM customer c2 
WHERE city_id IS NOT NULL
)

SELECT name,
 CASE 
 	WHEN name IN('JUAN') THEN 'No aprobado'
 	ELSE 'Aprobados'
 END as 'status'
 FROM  customer c 
 
 
 -- opperador ANY e ALL solo trabajan en sub consulta
 
 ALTER TABLE customer 
 ADD balance DECIMAL(8,2); -- primer valor junto con los decimales 6 entero y dos ecimales en este caso
 
 CREATE TABLE product(
 id INT AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(50) NOT NULL,
 price DECIMAL(8,2)
 )
 
INSERT INTO product(name, price)
VALUES('cerveza',15),
('papas fritas',10),
('alfajor',5.50);

SELECT * FROM product

-- ANY cumple al menos uno a cualquiera de los balores

SELECT c.name, c.balance FROM customer c 
WHERE c.balance > ANY (SELECT price FROM product)

SELECT c.name, c.balance FROM customer c 
WHERE c.balance < ANY (SELECT price FROM product)

-- ALL deves tener la comparacion 
SELECT c.name, c.balance FROM customer c 
WHERE c.balance > ALL (SELECT price FROM product)

-- LIKE sirve para buscar patrones
-- % algo o mucho despues de esto
SELECT c.name FROM customer c 
WHERE UPPER(c.name) LIKE '%Y' -- que termine con Y

SELECT c.name FROM customer c 
WHERE UPPER(c.name) LIKE '%A%' -- busco algo que tenga en medio esto

SELECT name, email FROM customer c WHERE email LIKE '%gmail.com'


-- COUNT 

SELECT COUNT(*) FROM customer c 

SELECT COUNT(city_id) FROM customer c 

SELECT COUNT(DISTINCT name) FROM customer c 

SELECT name, COUNT (*) as 'Cantidad' FROM customer c GROUP BY c.name


SELECT c.name, DATE(c.created_at) as 'fecha' COUNT(*) as 'Cantidad' FROM customer c GROUP BY c.name, DATE(c.created_at);

-- having trabaja con funciones de agregacion

SELECT name, COUNT(*) as 'cantidad'
FROM customer WHERE name != 'ana'
GROUP BY name HAVING COUNT(*) > 1


-- sum -- avg )

SELECT name, SUM(balance) FROM customer GROUP BY DATE(created_at);


-- mIin max

SELECT DATE(c.created_at  ), MIN (c.balance) as 'minimo', MAX(c.balance) as 'maximo' FROM customer c GROUP BY DATE (c.created_at);


SELECT name, MIN(c.created_at  ), MAX (c.created_at) as 'minimo', MAX(c.balance) as 'maximo' FROM customer c GROUP BY DATE (c.created_at);

-- group concat
SELECT DATE(created_at), GROUP_CONCAT(name) as 'nombres' FROM customer GROUP BY DATE(created_at) 

SELECT DATE(created_at), GROUP_CONCAT(name SEPARATOR '| ') as 'nombres' FROM customer GROUP BY DATE(created_at) 

SELECT DATE(created_at), GROUP_CONCAT(name ORDER BY UPPER(name) DESC SEPARATOR '| ') as 'nombres' FROM customer GROUP BY DATE(created_at) 

SELECT DATE(created_at), GROUP_CONCAT(name ORDER BY UPPER(name) DESC SEPARATOR '| ') as 'nombres' FROM customer GROUP BY DATE(created_at) HAVING COUNT(*) > 2

-- string agg la funcion equivalente en mysql server

-- Funciones
drop function if exists Hi;

DELIMITER $$ -- limita la funcion


CREATE FUNCTION Hi(name varchar(50))
returns varchar(200)
deterministic -- mismo grupo de entrada da la misma salida
begin
	declare message varchar(200);
    set message = CONCAT('hola ', name );
	return message;
	
end$$;
-- ----------------
drop function if exists Hi;
DELIMITER $$

CREATE FUNCTION Hi(name varchar(50)) RETURNS varchar(200) DETERMINISTIC
BEGIN
    DECLARE message varchar(200);
    SET message = CONCAT('Hola ', name);
    RETURN message;
END$$

DELIMITER ;



SELECT Hi('Ale');
-- ------------------------



drop function if exists NumberDescription;

DELIMITER $$

$$
    CREATE function NumberDescription(number INT)
    RETURNS VARCHAR(8)
    deterministic 
    BEGIN
    Declare description varchar(8);
    
    if number < 0 then 
      set description = 'negativo';
    ELSEIF number > 0
	    set description = 'positivo';
	ELSE 
	   set description = 'cero';
	 end if ;
	   
	   return description;
	END;
   
$$



Sí, la sintaxis que has proporcionado tiene un pequeño error en la forma en que se ha dispuesto el uso del delimitador $$. El problema principal aquí es la posición de los delimitadores alrededor de la declaración de la función. La correcta utilización del delimitador personalizado $$ es crucial para separar claramente la definición de la función del resto de las instrucciones SQL que puedas ejecutar. Aquí te muestro cómo debería estructurarse correctamente:

DELIMITER $$

CREATE FUNCTION NumberDescription(number INT) RETURNS VARCHAR(8) DETERMINISTIC
BEGIN
    DECLARE description VARCHAR(8);
    
    IF number < 0 THEN 
        SET description = 'negativo';
    ELSEIF number > 0 THEN
        SET description = 'positivo';
    ELSE 
        SET description = 'cero';
    END IF;
    
    RETURN description;
END$$

DELIMITER ;
SELECT  NumberDescription(1);


-- bucles
DROP FUNCTION IF EXISTS SequenceNumber;  
DELIMITER $$
 
CREATE function SequenceNumber(number int)
returns varchar (200)
deterministic 
 begin 
 	declare i int;
    declare sequences varchar(200);
     
    set i = 0;
   set sequences = '';
  
   while i < number DO 
      set sequences = concat(sequences, i + 1, ', ');
     set i = i +1;
      end while;
     return while;
    
 end$$
 delimiter ; 


Parece que deseas crear una función que genere una secuencia de números del 1 hasta el número especificado, separados por comas. Hay un par de correcciones y mejoras que se pueden hacer a tu función para que funcione como esperas. Además, hay un pequeño error en la última parte de tu código; específicamente, return while; no es válido y parece ser un error tipográfico. Deberías retornar la variable sequences al final de la función. Aquí tienes una versión corregida de la función:


DROP FUNCTION IF EXISTS SequenceNumber;

DELIMITER $$

CREATE FUNCTION SequenceNumber(number INT) RETURNS VARCHAR(200) DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE sequences VARCHAR(200) DEFAULT '';
  
    WHILE i < number DO 
        SET i = i + 1;
        SET sequences = CONCAT(sequences, i, ', ');
    END WHILE;
    
    -- Remueve la última coma y espacio del final de la cadena
    SET sequences = TRIM(TRAILING ', ' FROM sequences);
    
    RETURN sequences;
END$$

DELIMITER ;

SELECT  SequenceNumber(5);

-- funciones no deterministas no dan el mismo valor

delimiter $$ 

create function Tomorrow()
returns datetime
not deterministic 
begin
	return date_Add(now(),interval 1 day);
end$$

delimiter ;
 
 SELECT Tomorrow()
 
 -- funciones en mysql retornan un valor escalar 
 
 drop function IF EXISTS QueryCustomer;

-- estas funciones no pueden alterar la data no deberian tener efectos colaterales
DELIMITER $$

create function QueryCustomer(cityId INT)
returns int
not deterministic 
begin 
	declare quantity int;
    SELECT COUNT(*) into quantity 
    from customer
    where city_id = cityId;
   return quantity;
end$$

DELIMITER ;


select QueryCustomer(1);

-- stored procedure son un conjunto de procesos encapsulados borrar data ecc sirven para atomozar informacion 
-- permiter hacer una sola llamada y ayudan en terminos de rendimiento
-- estan precompiladas y esta optimizada y dan seguridad 
-- pueden regresar una tabala
DELIMITER $$
create procedure CustomerWithBalance()
BEGIN
	SELECT name from customer
	WHERE balance > 0;
END$$

DELIMITER ;

call CustomerWithBalance(); -- llamarla con call


-- funciones vs proceduras 
-- funciones regresan un tipo numero stringa ecc
-- procudure retorna el valor de una consulta, no necesariamente un valor un stored procude puede tener efectos secundarios
-- el numero de resultados puede no retornar nada 
-- las funciones se pueden llamar dentro de select las stored procedures se llaman con call 
-- select fn(c1), c1 from T 

DROP PROCEDURE if exists ;

delimiter $$
   
CREATE procedure GetCityData(cityId int)
begin 
 declare CityName varchar(50);


SELECT name into CityName
	from city 
	WHERE id = cityId;
-- primer resultado
SELECT CityName;
-- segundo resultado
Select name from customer where city_id = cityId;

-- tercer resultado 
SELECT sum(balance) as 'total'
from customer 
where city_id = cityId;
end$$ 

delimiter ;

call GetCityData(1);

-- modificar info con las stored procedures

delimiter $$ 
CREATE procedure UpdateNameCity(cityId int, newName varchar(50))
begin 
	update city set name = newName
	where id = cityId;
     SELECT COUNT(*) as 'total clientes'
     from customer WHERE city_id = cityID;
end$$

delimiter ;

call UpdateNameCity(1, 'Guayaquil');

-- paginacion con stored proceduras
delimiter $$ 

create procedure getCustomer(quantity Int, pag int)

begin 
	Declare rows_offset int;
    set rows_offset = (pag -1) * quantity; -- toma a partir de el primer registro
    SELECT * from customer 
    order by id  
    limit rows_offset, quantity;
   
end$$;

delimiter ;

call getCustomer(3,1);

-- busquedas dinamicas

delimiter $$ 

create procedure getCustomerSearch(customerName varchar, cityId int, dateMonth int)

begin 
	SELECT * from customer 
	WHERE (customerName is null or name = customerName);
   and (cityId is null or city_id = cityId);
   and (dateMonth is null or month(CREATE) = dateMonth);
end$$;
delimiter ;

drop procedure if exists  getCustomerSearch;
DELIMITER $$ 

CREATE PROCEDURE getCustomerSearch(IN customerName VARCHAR(255), IN cityId INT, IN dateMonth INT)
BEGIN 
    SELECT * FROM customer 
    WHERE (customerName IS NULL OR name = customerName)
    AND (cityId IS NULL OR city_id = cityId)
    AND (dateMonth IS NULL OR MONTH(created_at) = dateMonth);
END$$

DELIMITER ;

SELECT * from customer c ;
call getCustomerSearch(null,null,8);

-- busquedas dianmicas paginadas


drop procedure if exists  getCustomerSearch;
DELIMITER $$ 

CREATE PROCEDURE getCustomerSearchWithPag(IN customerName VARCHAR(255), IN cityId INT, IN dateMonth INT, quantity int, pag int)
BEGIN 

    declare rows_offset int;
   set rows_offset = (pag -1) * quantity;

    SELECT * FROM customer 
    WHERE (customerName IS NULL OR name = customerName)
    AND (cityId IS NULL OR city_id = cityId)
    AND (dateMonth IS NULL OR MONTH(created_at) = dateMonth)
    order by id 
    LIMIT rows_offset, quantity;
END$$

DELIMITER ;


call getCustomerSearchWithPag(null,null,null,3,2);



-- master detail 

-- caso de usa cuando tenga ua tabal que tiene detalles de otro por ejemplo informacion de el chat con detalles son todos los detalles

create table sales (
 id int auto_increment primary key,
 customer_id int not null,
 created_at datetime not null default current_timestamp(),
 foreign key (customer_id) references customer(id)
);


create table sales_details(
  id int auto_increment primary key,
  sale_id int not null,
  product_id int not null,
  price decimal (8,2) not null,
  quantity int not null,
  foreign key (sale_id) references product(id)
);

SELECT * from customer c 

SELECT * from sales 
insert into sales(customer_id) values (4);
SELECT id from sales order by id  desc limit 0,1;

insert into sales_details(sale_id,price, quantity) values (1,1,15,5), (1,2,10,2);

-- mutiples join

SELECT customer.name as 'customer', product.name as 'product', sales.created_at, quantity, sales_details.price from sales_details inner join product on product.id = sales_details.product_id
inner join sales on sales.id = sale_detail.sale_id;

-- agrupados con multiples join

SELECT * from product p 
select * from product p 
INSERT INTO sales_details (sale_id, product_id ,price,  quantity) values(2,2,15,3),(2,1,10,2);

SELECT p.name as 'product', SUM(quantity) as 'productos vendidos', SUM(quantity * sd.price) as 'total'
FROM sales_details as sd
INNER JOIN product p ON p.id = sd.product_id
GROUP  by p.id;

-- vistas
-- es una consulta que puede ser salvada 
-- ALTER para poder alterar la vista una vez creada
CREATE VIEW vwsale 
AS
SELECT p.name as 'product', SUM(quantity) as 'productos vendidos', SUM(quantity * sd.price) as 'total'
FROM sales_details as sd
INNER JOIN product p ON p.id = sd.product_id
GROUP  by p.id;

SELECT * FROM vwsale; -- es una tabal virtual estamos usando una consulta la encupsalamos 

-- triggres una accion que se dispara despues de una consulta

-- con los triggres tenemos las entidades sea nueva o aquellas vieja
-- sirvan para poder automizar cosas 


-- creacion de un triggrer

CREATE TABLE log_product_price(
 id INT AUTO_INCREMENT PRIMARY KEY,
 product_id INT NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
 old_price DECIMAL(8,2),
 new_price DECIMAL(8,2),
 FOREIGN KEY(product_id) REFERENCES product(id)

);


DROP TRIGGER IF EXISTS save_lof;
DELIMITER $$
CREATE TRIGGER save_log
AFTER INSERT ON product -- despues de un inserimento de un producto
FOR EACH ROW 
BEGIN 
	INSERT INTO log_product_price (product_id, old_price, new_price)
	VALUES(NEW.id,0, NEW.price);
	
END$$

DELIMITER ;

INSERT INTO product(name, price)
VALUES('cerveza pilsener',40),
('cerveza porter', 45);

SELECT * FROM log_product_price

-- TRIGGER EN UDPATE


DROP TRIGGER IF EXISTS save_log_update;
DELIMITER $$
CREATE TRIGGER save_log_update
AFTER UPDATE  ON product -- despues de un inserimento de un producto
FOR EACH ROW 
BEGIN 
	IF NEW.price != OLD.price THEN 
	INSERT INTO log_product_price (product_id, old_price, new_price)
	VALUES(NEW.id,OLD.price, NEW.price);
    END IF;
	
END$$

DELIMITER ;
SET SQL_SAFE_UPDATES = 0;
UPDATE product SET price = price + (price * 0.1);

SELECT * FROM log_product_price ;

-- before triggers 
-- podemos establecer valores predeterminados 

DROP TRIGGER IF EXISTS save_log_insert_before;
DELIMITER $$
CREATE TRIGGER save_log_insert_before
BEFORE INSERT  ON product -- despues de un inserimento de un producto
FOR EACH ROW 
BEGIN 
	IF NEW.price < 0 THEN 
     SIGNAL SQLSTATE '45000'    -- CUANDO ENCONTRAMOS UN ERROR INICIAN CON UN ERROR
     SET MESSAGE_TEXT = 'UN PRODUCTO NO PUEDE TENER UN VALOR NEGATICO';
     ELSEIF NEW.price = 0 THEN
     SET NEW.price = 1;
     END IF;
	
END$$

DELIMITER ;

INSERT INTO product (name , price) values ("not valid", -1);

-- TRIGGER EN DELETE
-- no se puede eliminar un registro con un a llave foranea a menos que haya eliminadas las dependencias

DELIMITER $$
CREATE TRIGGER delete_log
BEFORE DELETE ON product -- despues de un inserimento de un producto
FOR EACH ROW 
BEGIN 
	DELETE FROM log_product_price
	WHERE product_id = OLD.id; -- new no existe en un delete porque esa entidad non existe y lo mismo con old en el insert 
		
END$$

DELIMITER ;
DELETE from product WHERE id = 6;

-- transacion 

-- ACID atomica | consitenzia | aislamiento | durabilidad

-- roolback se regresa al resultado viejo 

-- commit se termina con el resultado obtenido
 DROP PROCEDURE IF EXISTS testTrasaction;

DELIMITER $$
CREATE PROCEDURE testTrasaction()
BEGIN 
	START TRANSACTION ;
	  INSERT INTO city(name)
	  VALUES('Barcelona');
	COMMIT; -- o lo puedo terminar con roolback
END$$

DELIMITER ;

CALL testTrasaction;

-- manejo de errores con procedures

 DROP PROCEDURE IF EXISTS testTrasaction;

DELIMITER $$
CREATE PROCEDURE testTrasaction()
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION -- FUNZIONA COMO UNA CATHC
    BEGIN
    	ROLLBACK;
        SELECT 'ERROR SQL';
    END;
    
	START TRANSACTION ;
	  INSERT INTO city(name)
	  VALUES('A');
	 
	 INSERT INTO city(name) -- si falla algo ante de el rollback entonces el rollback no se termina de hacer
	  VALUES('A');
	
	 
	 COMMIT; -- o lo puedo terminar con roolback
END$$

DELIMITER ;

CALL testTrasaction;

-- CONSULTAS DINAMICAS 

PREPARE statement_dinamic FROM 'SELECT * FROM city WHERE id = ? OR name = ?';
SET @name1 = 'Barcelona';
SET @name2 = 'Guayaquil';
EXECUTE statement_dinamic USING @name1 , @name2;

-- construcion de una consulta dinamica

DROP PROCEDURE IF EXISTS DynamicQuery;

DELIMITER $$ 

CREATE PROCEDURE 

DELIMITER ;




-- busquedas dinamicas 

-- busquedas dinamicas con seguridad





