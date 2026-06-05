CREATE OR REPLACE PACKAGE pkg_tour AS

   FUNCTION carreras_ganadas(
      p_equipo VARCHAR2
   ) RETURN NUMBER;

   FUNCTION agregarciclista(
      p_dorsal NUMBER,
      p_nombre VARCHAR2,
      p_edad NUMBER,
      p_nomeq VARCHAR2
   ) RETURN NUMBER;

   FUNCTION actualizar_ciclistas
   RETURN NUMBER;

END;


CREATE OR REPLACE PACKAGE BODY pkg_tour AS

--------------------------------------------------
-- FUNCION 1
--------------------------------------------------
FUNCTION carreras_ganadas(
   p_equipo VARCHAR2
) RETURN NUMBER
IS
   v_total NUMBER;
BEGIN

   SELECT COUNT(*)
   INTO v_total
   FROM etapa e
        JOIN ciclista c
          ON e.dorsal = c.dorsal
   WHERE UPPER(c.nomeq) = UPPER(p_equipo);

   RETURN v_total;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20004,
      'El equipo no existe');
END;

--------------------------------------------------
-- FUNCION 2
--------------------------------------------------
FUNCTION agregarciclista(
   p_dorsal NUMBER,
   p_nombre VARCHAR2,
   p_edad NUMBER,
   p_nomeq VARCHAR2
)
RETURN NUMBER
IS

   v_existe NUMBER;
   v_equipo NUMBER;

BEGIN

   SELECT COUNT(*)
   INTO v_existe
   FROM ciclista
   WHERE dorsal = p_dorsal;

   IF v_existe > 0 THEN
      RAISE_APPLICATION_ERROR(
         -20001,
         'El ciclista que está intentando insertar ya existe'
      );
   END IF;

   SELECT COUNT(*)
   INTO v_equipo
   FROM equipo
   WHERE nomeq = p_nomeq;

   IF v_equipo = 0 THEN

      DBMS_OUTPUT.PUT_LINE(
      'No existe el equipo. Procedemos a crearlo');

      INSERT INTO equipo
      VALUES(
         p_nomeq,
         'DIRECTOR DESCONOCIDO'
      );

   END IF;

   INSERT INTO ciclista
   VALUES(
      p_dorsal,
      p_nombre,
      p_edad,
      p_nomeq
   );

   RETURN p_dorsal;

EXCEPTION

   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;

END;

--------------------------------------------------
-- FUNCION 3
--------------------------------------------------
FUNCTION actualizar_ciclistas
RETURN NUMBER
IS

   CURSOR c_equipos IS
      SELECT nomeq
      FROM equipo
      ORDER BY nomeq;

   CURSOR c_ciclistas(p_equipo VARCHAR2) IS
      SELECT dorsal,nombre
      FROM ciclista
      WHERE nomeq = p_equipo
      ORDER BY nombre;

   v_contador NUMBER := 0;
   v_pos NUMBER;

BEGIN

   FOR eq IN c_equipos LOOP

      v_pos := 0;

      FOR cic IN c_ciclistas(eq.nomeq) LOOP

         v_pos := v_pos + 1;

         IF v_pos <= 2 THEN

            DBMS_OUTPUT.PUT_LINE(
               eq.nomeq || ' -> ' ||
               cic.nombre
            );

            UPDATE ciclista
            SET nombre = nombre
            WHERE dorsal = cic.dorsal;

            v_contador := v_contador + SQL%ROWCOUNT;

         END IF;

      END LOOP;

   END LOOP;

   RETURN v_contador;

EXCEPTION

   WHEN OTHERS THEN
      RETURN -1;

END;

END;

SET SERVEROUTPUT ON;

DECLARE
   v_total NUMBER;
BEGIN
   v_total :=
      pkg_tour.carreras_ganadas('Banesto');

   DBMS_OUTPUT.PUT_LINE(
      'Carreras ganadas: ' || v_total
   );
END;
/

