-- 1 
select * from cliente c 
where c.limite_credito = (select max(c2.limite_credito) from cliente c2 );

-- 2
select * from producto p 
where p.precio_venta >= all (select p2.precio_venta from producto p2 );

-- 3
select * from producto p 
join detalle_pedido dp 
on p.codigo_producto = dp.codigo_producto
where dp.cantidad >= all(select dp2.cantidad from detalle_pedido dp2 );

-- 4
select * from cliente c 
where c.limite_credito > all(select p.total from pago p); 

-- 6