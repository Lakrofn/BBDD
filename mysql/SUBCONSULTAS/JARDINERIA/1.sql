-- 1.4.8.2
-- 1
select c.nombre_cliente from cliente c
where c.limite_credito >= all (SELECT c2.limite_credito FROM cliente c2 );

-- 2
select p.nombre  from producto p
where p.precio_venta >= all (select p2.precio_venta from producto p2 );

-- 3
select p.nombre from producto p
where p.cantidad_en_stock <= all (select p2.cantidad_en_stock from producto p2 );

-- 1.4.8.3
-- 1
select e.nombre , e.apellido1 , e.puesto from empleado e 
where e.codigo_empleado not in (select c.codigo_empleado_rep_ventas from cliente c );

-- 2
select * from cliente c
where c.codigo_cliente not in (select p.codigo_cliente from pago p );

-- 3
select * from cliente c
where c.codigo_cliente in (select p.codigo_cliente from pago p );

-- 4
select * from producto p
where p.codigo_producto not in (select dp.codigo_producto from detalle_pedido dp);

-- 5
select e.nombre , e.apellido1 , e.puesto, o.telefono from empleado e join oficina o
on e.codigo_oficina = o.codigo_oficina 
where e.codigo_empleado not in (select c.codigo_empleado_rep_ventas from cliente c );

-- 6
