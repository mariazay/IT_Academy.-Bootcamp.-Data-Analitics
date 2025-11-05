-- SPRINT 2

USE transactions;

-- Nivel 1. Ejercicio 1 

-- Mostrar las caracteristicas principales del esquema y explicar las diferentas tablas y variables que existen

DESCRIBE transaction;

DESCRIBE company;


-- Nivel 1. Ejercicio 2

-- La lista de los países que están generando ventas
SELECT DISTINCT c.country
FROM transaction AS t
LEFT JOIN company AS c
ON c.id=t.company_id;

-- Desde cuántos países se generan ventas
SELECT COUNT(DISTINCT c.country) AS number_of_countries
FROM transaction AS t
LEFT JOIN company AS c
ON c.id=t.company_id;

-- La compañía con la mayor media de ventas
SELECT c.id, c.company_name
FROM company AS c
LEFT JOIN transaction AS t 
ON c.id=t.company_id
GROUP BY c.id
ORDER BY AVG(t.amount) DESC
LIMIT 1;


-- Nivel 1. Ejercicio 3

-- Todas las transacciones realizadas por empresas de Alemania
SELECT t.id, t.company_id, t.user_id, t.amount, t.declined	-- Las caracteristicas principales de transacción
FROM transaction AS t 
WHERE EXISTS (SELECT *
			  FROM company AS c
              WHERE t.company_id=c.id AND c.country='Germany');
              
/* La Lista de la empresas que han realizado transacciones 
   por un amaunt superior a la media de todas las transacciones */
SELECT c.id, c.company_name	
FROM company AS c 
WHERE EXISTS (SELECT *
			  FROM transaction AS t
              WHERE t.company_id=c.id AND t.amount > (SELECT AVG(t.amount)
													  FROM transaction AS t));

-- La Lista de la empresas que no tienen transacciones  registradas
SELECT c.id, c.company_name	
FROM company AS c 
WHERE NOT EXISTS (SELECT *
			  FROM transaction AS t
              WHERE t.company_id=c.id);
              

-- Nivel 2. Ejercicio 1

/* Los cinco días que se generó la mayor cantidad de ingresos
   (la fecha de cada transacción junto con el total de las ventas) */
SELECT DATE_FORMAT(t.timestamp, '%d.%m.%Y')	AS date, SUM(t.amount) AS total_amount  
FROM transaction AS t
GROUP BY date
ORDER BY total_amount DESC
LIMIT 5;


-- Nivel 2. Ejercicio 2

/* La media de ventas por país
   (los resultados ordenados de mayor a menor medio) */
SELECT c.country, AVG(t.amount) AS average_amount  
FROM transaction AS t
LEFT JOIN company AS c
ON c.id=t.company_id
GROUP BY c.country
ORDER BY average_amount DESC;


-- Nivel 2. Ejercicio 3

/* La lista de todas las transacciones realizadas por empresas 
   que están ubicadas en el mismo país que "Non Institute"
   (utilizando JOIN y subconsultas) */
SELECT t.id, t.company_id, t.user_id, t.amount, t.declined	-- Las caracteristicas principales de transacción  
FROM transaction AS t
LEFT JOIN company AS c
ON c.id=t.company_id
WHERE c.country=(SELECT c.country
				 FROM company AS c
                 WHERE c.company_name='Non Institute')
	  AND c.company_name<>'Non Institute'; 	-- Eliminar las transacciones de "Non Institute"

/* La lista de todas las transacciones realizadas por empresas 
   que están ubicadas en el mismo país que "Non Institute"
   (utilizando sólo subconsultas) */
SELECT t.id, t.company_id, t.user_id, t.amount, t.declined	-- Las caracteristicas principales de transacción  
FROM transaction AS t
WHERE EXISTS (SELECT *
				 FROM company AS c
                 WHERE c.id=t.company_id 
					   AND c.country=(SELECT c.country
									  FROM company AS c
									  WHERE c.company_name='Non Institute')
					   AND c.company_name<>'Non Institute'); 	-- Eliminar las transacciones de "Non Institute"
                       


-- Nivel 3. Ejercicio 1

-- El nombre, teléfono, país, fecha y amount, deaquellas empresas que realizaron transacciones con los condiciones
SELECT c.company_name, c.phone, c.country, DATE_FORMAT(t.timestamp, '%d.%m.%Y')	AS date, t.amount
FROM transaction AS t
LEFT JOIN company AS c
ON c.id=t.company_id
WHERE (t.amount BETWEEN 350 AND 400)
	  AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY t.amount DESC;


-- Nivel 3. Ejercicio 2

-- La cantidad de transacciones que realizan las empresas (más de 400 transacciones o menos)
SELECT c.company_name, COUNT(t.amount) AS number_of_transactions,
	   IF(COUNT(t.amount) > 400, 'more than 400', 'less than 400') AS result
FROM transaction AS t
LEFT JOIN company AS c
ON c.id=t.company_id
GROUP BY c.company_name;
      












