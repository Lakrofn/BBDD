-- 1
SELECT * FROM Pokemon p;

-- 2
SELECT COUNT(*) FROM Pokemon p;

-- 3
SELECT UPPER(p.nombre) FROM Pokemon p 
ORDER BY p.nombre;

-- 4
SELECT p.nombre FROM Pokemon p 
WHERE p.descripcion LIKE '%pelea%';

-- 5
SELECT MIN(ep.altura) FROM EstadisticasPokemon ep;

-- 6
SELECT MAX(ep.altura) FROM EstadisticasPokemon ep;

-- 7
SELECT p.nombre  FROM Pokemon p
JOIN EstadisticasPokemon ep 
ON p.idPokemon = ep.numeroPokedex
WHERE ep.altura = (SELECT MAX(ep.altura) FROM EstadisticasPokemon ep);

-- 8
SELECT p.nombre  FROM Pokemon p
JOIN EstadisticasPokemon ep 
ON p.idPokemon = ep.numeroPokedex
WHERE ep.altura = (SELECT MIN(ep.altura) FROM EstadisticasPokemon ep)
ORDER BY p.idPokemon;

-- 9
SELECT p.idPokemon , p.nombre , ep.peso  FROM Pokemon p
JOIN EstadisticasPokemon ep 
ON p.idPokemon = ep.numeroPokedex
WHERE ep.peso > 100;

-- 10
SELECT p.idPokemon , p.nombre , ep.peso FROM Pokemon p
JOIN EstadisticasPokemon ep 
ON p.idPokemon = ep.numeroPokedex
WHERE ep.peso = (SELECT MIN(ep.peso ) FROM EstadisticasPokemon ep)

-- 11
SELECT p.idPokemon , p.nombre FROM Pokemon p
JOIN EstadisticasPokemon ep 
ON p.idPokemon = ep.numeroPokedex
WHERE ep.ataque  > 80;

-- 12
SELECT p.idPokemon , p.nombre FROM Pokemon p
JOIN EstadisticasPokemon ep 
ON p.idPokemon = ep.numeroPokedex
WHERE ep.ataque  = (SELECT MAX(ep.ataque) FROM EstadisticasPokemon ep);

-- 13
SELECT p.nombre FROM Pokemon p
JOIN Categoria c 
ON p.idCategoria = c.idCategoria
WHERE c.nombre LIKE "Capullo";

-- 14
SELECT p.nombre FROM Pokemon p 
JOIN PokemonTipo pt 
ON p.idPokemon = pt.idPokemon
JOIN Tipo t 
ON pt.idTipo = t.idTipo
WHERE t.nombre LIKE "Veneno";

-- 15
SELECT COUNT(pd.idPokemon) FROM PokemonDebilidad pd 
JOIN Debilidad d 
ON pd.idDebilidad = d.idDebilidad
WHERE d.nombre LIKE "Hielo";

-- 16
SELECT SUM(ep.at_especial + ep.defensa + ep.df_especial + ep.numeroPokedex + ep.ataque + ep.ps + ep.velocidad) as estadisticas FROM EstadisticasPokemon ep
join Pokemon p 
on ep.numeroPokedex = p.idPokemon
WHERE p.idPokemon = 10;

-- 17
SELECT p.idPokemon , p.nombre , ep.at_especial + ep.defensa + ep.df_especial + ep.numeroPokedex + ep.ataque + ep.ps + 
														ep.velocidad + ep.altura + ep.peso as estadisticas 
FROM Pokemon p 
JOIN EstadisticasPokemon ep
ON p.idPokemon = ep.numeroPokedex
WHERE p.idPokemon = 10;

-- 18
SELECT p.idPokemon , p.nombre, ep.at_especial + ep.defensa + ep.df_especial + ep.numeroPokedex + ep.ataque + ep.ps + 
														ep.velocidad as estadisticas 
FROM Pokemon p 
JOIN EstadisticasPokemon ep
ON p.idPokemon = ep.numeroPokedex
order by estadisticas;

-- 19
SELECT p.nombre FROM Pokemon p
JOIN PokemonDebilidad pd ON p.idPokemon = pd.idPokemon
GROUP BY p.idPokemon
HAVING COUNT(pd.idDebilidad) = 1;

-- 20
SELECT p.idPokemon, p.nombre, COUNT(pd.idDebilidad) AS debilidades
FROM Pokemon p
JOIN PokemonDebilidad pd ON p.idPokemon = pd.idPokemon
GROUP BY p.idPokemon, p.nombre
ORDER BY debilidades DESC, p.idPokemon;