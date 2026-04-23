-- 1

-- ===============================
-- ARCHIVO 1: ESPECIFICACIÓN
-- aritmetica_spec.sql
-- ===============================

CREATE OR REPLACE PACKAGE ARITMETICA AS

    PROCEDURE sumar(
        n1 NUMBER,
        n2 NUMBER
    );

    PROCEDURE restar(
        n1 NUMBER,
        n2 NUMBER
    );

    FUNCTION multiplicar(
        n1 NUMBER,
        n2 NUMBER
    ) RETURN NUMBER;

    FUNCTION dividir(
        n1 NUMBER,
        n2 NUMBER
    ) RETURN NUMBER;

END ARITMETICA;

-- ===============================
-- ARCHIVO 2: CUERPO DEL PAQUETE
-- aritmetica_body.sql
-- ===============================

CREATE OR REPLACE PACKAGE BODY ARITMETICA AS

    PROCEDURE sumar(
        n1 NUMBER,
        n2 NUMBER
    )
    IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Suma = ' || (n1 + n2));
    END sumar;


    PROCEDURE restar(
        n1 NUMBER,
        n2 NUMBER
    )
    IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Resta = ' || (n1 - n2));
    END restar;


    FUNCTION multiplicar(
        n1 NUMBER,
        n2 NUMBER
    ) RETURN NUMBER
    IS
    BEGIN
        RETURN n1 * n2;
    END multiplicar;


    FUNCTION dividir(
        n1 NUMBER,
        n2 NUMBER
    ) RETURN NUMBER
    IS
    BEGIN
        IF n2 = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'No se puede dividir entre cero');
        END IF;

        RETURN n1 / n2;
    END dividir;

END ARITMETICA;


-- ACTIVAR SALIDA
SET SERVEROUTPUT ON;

-- ===============================
-- LLAMADAS A PROCEDIMIENTOS
-- ===============================

BEGIN
    ARITMETICA.sumar(10,5);
    ARITMETICA.restar(10,5);
END;