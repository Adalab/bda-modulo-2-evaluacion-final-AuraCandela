Use sakila;

/* Ejercicio 1 Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;

/* Ejercicio 2 Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT title,rating
FROM film
WHERE rating = 'PG-13';

/* Ejercicio 3 Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title,description
FROM film
WHERE description LIKE '%amazing%';

/* Ejercicio 4 Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT title,length
FROM film
WHERE length > 120;

/* Ejercicio 5 Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.

SELECT CONCAT(first_name, ' ', last_name) AS nombre_actor
FROM actor
ORDER BY nombre_actor;

/* Ejercicio 6 Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name,last_name
FROM actor
WHERE last_name LIKE '%Gibson%';

/* Ejercicio 7 Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT  actor_id,first_name
FROM actor
WHERE actor_id BETWEEN 10 and 20

/* Ejercicio 8 Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".

SELECT title,rating
FROM film
Where rating NOT IN ('R','PG-13');

/* Ejercicio 9 Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT rating,COUNT(film_id) AS cantidad_peliculas
FROM film
GROUP BY rating;

/* Ejercicio 10 Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

With pelis_id_cliente AS (SELECT customer_id,COUNT(film_id) AS peliculas_alquiladas
FROM rental
LEFT JOIN inventory
ON rental.inventory_id=inventory.inventory_id
GROUP BY customer_id)

SELECT pelis_id_cliente.customer_id,first_name,last_name,peliculas_alquiladas
FROM pelis_id_cliente
LEFT JOIN customer
ON pelis_id_cliente.customer_id=customer.customer_id;

/* Ejercicio 11 Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT c.name AS categoria,COUNT(r.rental_id) AS total_alquileres
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

/* Ejercicio 12 Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating,AVG(length) as promedio_duracion
FROM film
GROUP BY rating
ORDER BY rating; 

/* Ejercicio 13 Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love'
ORDER BY a.first_name, a.last_name;

/* Ejercicio 14 Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title 
FROM film 
WHERE description LIKE '%dog%' 
   OR description LIKE '%cat%';

/* Ejercicio 15 Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

/* Ejercicio 16 Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title,release_year
FROM film
WHERE release_year BETWEEN 2005 AND 2010

/* Ejercicio 17 Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

/* Ejercicio 18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT a.first_name AS nombre,a.last_name AS apellido,COUNT(fa.film_id) AS numero_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10
ORDER BY numero_peliculas DESC;

/* Ejercicio 19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title,rating,length
FROM film
WHERE rating = 'R' 
AND length > 120;

/* Ejercicio 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name AS categoria,AVG(f.length) AS duracion_promedio
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120
ORDER BY duracion_promedio DESC; 

/* Ejercicio 21 Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT a.first_name,a.last_name,COUNT(fa.film_id) as total_peliculas
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) >= 5
ORDER BY total_peliculas DESC;

/* Ejercicio 22 Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)

SELECT DISTINCT f.title
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (
    SELECT rental_id
    FROM rental
    WHERE DATEDIFF(return_date, rental_date) > 5
);

/* Ejercicio 23 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE fa.actor_id = a.actor_id
    AND c.name = 'Horror'
)
ORDER BY a.last_name, a.first_name




