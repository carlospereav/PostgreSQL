select * from claps

select * from comments

select * from posts

select * from user_list_entry

select * from user_lists

select * from users

-- 1. Cuantos Post hay - 1050
select count(*) as num_posts from posts;


-- 2. Cuantos Post publicados hay - 543
select count('published') as num_posts from posts
where published = true;

-- 3. Cual es el Post mas reciente
-- 544 - nisi commodo officia...2024-05-30 00:29:21.277
select * from posts
order by created_at desc limit 1;


-- 4. Quiero los 10 usuarios con más post, cantidad de posts, id y nombre
/*
4	1553	Jessie Sexton
3	1400	Prince Fuentes
3	1830	Hull George
3	470	Traci Wood
3	441	Livingston Davis
3	1942	Inez Dennis
3	1665	Maggie Davidson
3	524	Lidia Sparks
3	436	Mccoy Boone
3	2034	Bonita Rowe
*/
select count(*), created_by, name from posts p
inner join users u on u.user_id = p.created_by
group by created_by, name
order by count(*) desc
limit 10;



-- 5. Quiero los 5 post con más "Claps" sumando la columna "counter"
/*
692	sit excepteur ex ipsum magna fugiat laborum exercitation fugiat
646	do deserunt ea
542	do
504	ea est sunt magna consectetur tempor cupidatat
502	amet exercitation tempor laborum fugiat aliquip dolore
*/
select * from claps

select * from posts

select sum(counter) as total_claps, p.title from claps c
inner join posts  p on c.post_id = p.post_id
group by p.title
order by total_claps desc
limit 5;

-- 6. Top 5 de personas que han dado más claps (voto único no acumulado ) *count
/*
7	Lillian Hodge
6	Dominguez Carson
6	Marva Joyner
6	Lela Cardenas
6	Rose Owen
*/
select * from claps

select * from users

select count(c.user_id) as given_claps, u.name from claps c
inner join users u on c.user_id = u.user_id
group by u.name
order by given_claps desc
limit 5;



-- 7. Top 5 personas con votos acumulados (sumar counter)
/*
437	Rose Owen
394	Marva Joyner
386	Marquez Kennedy
379	Jenna Roth
364	Lillian Hodge
*/
select * from claps

select * from users

select sum(counter), u.name from claps c
inner join users u on u.user_id = c.user_id
group by u.name
order by sum(counter) desc
limit 5;

-- 8. Cuantos usuarios NO tienen listas de favoritos creada
-- 329
select * from users

select * from user_lists

select count(*), ul.user_list_id from users u
left join user_lists ul on u.user_id = ul.user_id 
group by ul.user_list_id
order by count(*) desc
limit 1;

-- 9. Quiero el comentario con id
-- Y en el mismo resultado, quiero sus respuestas (visibles e invisibles)
-- Tip: union
/*
1	    648	1905	elit id...
3058	583	1797	tempor mollit...
4649	51	1842	laborum mollit...
4768	835	1447	nostrud nulla...
*/
select * from comments where comment_id = 1
union
select * from comments where comment_parent_id = 1;


-- ** 10. Avanzado
-- Investigar sobre el json_agg y json_build_object
-- Crear una única linea de respuesta, con las respuestas
-- del comentario con id 1 (comment_parent_id = 1)
-- Mostrar el user_id y el contenido del comentario

-- Salida esperada:
/*
"[{""user"" : 1797, ""comment"" : ""tempor mollit aliqua dolore cupidatat dolor tempor""}, {""user"" : 1842, ""comment"" : ""laborum mollit amet aliqua enim eiusmod ut""}, {""user"" : 1447, ""comment"" : ""nostrud nulla duis enim duis reprehenderit laboris voluptate cupidatat""}]"
*/
select json_agg( json_build_object('user', comments.user_id, 'comment', comments.content))
from comments 
where comment_parent_id = 1;




-- ** 11. Avanzado
-- Listar todos los comentarios principales (no respuestas) 
-- Y crear una columna adicional "replies" con las respuestas en formato JSON
select
	a.*,
	(
		select
			json_agg( json_build_object(
			'user', b.user_id,
			'comment', b.content
		))
		from comments b where b.comment_parent_id = a.comment_id
	) as replies
from comments a
where comment_parent_id is null;