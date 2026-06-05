CREATE TABLE empleados
(dni VARCHAR2(9) PRIMARY KEY,
nomemp VARCHAR2(50),
jefe VARCHAR2(9),
departamento NUMBER,
salario NUMBER(9,2) DEFAULT 1000,
usuario VARCHAR2(50),
fecha DATE,
CONSTRAINT FK_JEFE FOREIGN KEY (jefe) REFERENCES empleados (dni) );

CREATE TABLE empleados_baja
( dni VARCHAR2(9) PRIMARY KEY,
nomemp VARCHAR2 (50),
jefe VARCHAR2(9),
departamento NUMBER,
salario NUMBER(9,2) DEFAULT 1000,
usuario VARCHAR2(50),
fecha DATE );

-- 7.1.1
CREATE OR REPLACE 
TRIGGER NO_CINCO_EMPLEADOS
BEFORE INSERT ON EMPLEADOS
FOR EACH ROW
DECLARE
CONTADOR NUMBER;
BEGIN
	
	SELECT COUNT(*) INTO CONTADOR
	FROM EMPLEADOS
	WHERE JEFE = :NEW.JEFE;
	
	IF CONTADOR>5 THEN
		RAISE_APPLICATION_ERROR(-20001, 'Un jefe no puede tener más de 5 empleados');
	END IF;
END;

-- 7.1.2
CREATE OR REPLACE TRIGGER TRG_EMPLEADOS_SALAR_20
AFTER UPDATE OF SALAR ON EMPLEADOS
FOR EACH ROW
WHEN (OLD.SALAR * 1.20 < NEW.SALAR)
BEGIN
	RAISE_APPLICATION_ERROR(-20001, 'No puede aumentar su salario en mas de un 20%');
END;

--7.1.3
CREATE OR REPLACE TRIGGER dar_baja
after delete ON empleados
for EACH ROW

BEGIN
	
	INSERT INTO empleados_baja values(:OLD.dni,:OLD.nomemp,:OLD.jefe,:OLD.departamento,:OLD.salario,USER,sysdate);
END;

--7.1.4
CREATE OR REPLACE TRIGGER LAKRO.mismo_departamento
BEFORE insert ON empleados
FOR EACH row
DECLARE
iddepartamento empleados.departamento%TYPE;
BEGIN
	IF :NEW.jefe IS NOT NULL THEN
	SELECT departamento INTO iddepartamento
	FROM empleados
	WHERE dni = :NEW.jefe;

	IF :NEW.departamento != iddepartamento THEN
	RAISE_APPLICATION_ERROR(
                -20001,
                'Error: El empleado (dpto ' || :NEW.departamento ||
                ') y su jefe (dpto ' || iddepartamento ||
                ') deben pertenecer al mismo departamento.'
            );
	END IF;
	END IF;
	EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Error: El jefe con ID ' || :NEW.jefe || ' no existe en la tabla empleados.'
        );
END;

-- 5
CREATE OR REPLACE TRIGGER LAKRO.salario_departamento
BEFORE insert ON empleados
FOR EACH row
DECLARE
salar empleados.salario%TYPE;
BEGIN
	IF :NEW.departamento IS NOT NULL THEN
	SELECT NVL(SUM(salario), 0) INTO salar
	FROM empleados
	WHERE departamento = :NEW.departamento;

	salar:= salar + :NEW.salario;

	IF salar > 10000 THEN
	RAISE_APPLICATION_ERROR(
                -20001,
                'Supera el presupuesto de el departamento.'
            );
	END IF;
	END IF;
	EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Error: Presupuesto superado'
        );
END;

-- 6
CREATE TABLE controlCambios(
 usuario varchar2(30),
 fecha date,
 tipooperacion varchar2(30),
 datoanterior varchar2(30),
 datonuevo varchar2(30)
)

CREATE OR REPLACE TRIGGER trg_auditoria_empleados
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN

    IF UPDATING('nombre') AND (:OLD.nombre != :NEW.nombre OR
       (:OLD.nombre IS NULL AND :NEW.nombre IS NOT NULL) OR
       (:OLD.nombre IS NOT NULL AND :NEW.nombre IS NULL)) THEN
        INSERT INTO controlCambios VALUES (
            USER,
            SYSDATE,
            'UPDATE_NOMBRE',
            :OLD.nombre,
            :NEW.nombre
        );
    END IF;

    IF UPDATING('salario') AND (:OLD.salario != :NEW.salario OR
       (:OLD.salario IS NULL AND :NEW.salario IS NOT NULL) OR
       (:OLD.salario IS NOT NULL AND :NEW.salario IS NULL)) THEN
        INSERT INTO controlCambios VALUES (
            USER,
            SYSDATE,
            'UPDATE_SALARIO',
            TO_CHAR(:OLD.salario),
            TO_CHAR(:NEW.salario)
        );
    END IF;

    IF UPDATING('id_departamento') AND (:OLD.id_departamento != :NEW.id_departamento OR
       (:OLD.id_departamento IS NULL AND :NEW.id_departamento IS NOT NULL) OR
       (:OLD.id_departamento IS NOT NULL AND :NEW.id_departamento IS NULL)) THEN
        INSERT INTO controlCambios VALUES (
            USER,
            SYSDATE,
            'UPDATE_DEPARTAMENTO',
            TO_CHAR(:OLD.id_departamento),
            TO_CHAR(:NEW.id_departamento)
        );
    END IF;

    IF UPDATING('id_jefe') AND (:OLD.id_jefe != :NEW.id_jefe OR
       (:OLD.id_jefe IS NULL AND :NEW.id_jefe IS NOT NULL) OR
       (:OLD.id_jefe IS NOT NULL AND :NEW.id_jefe IS NULL)) THEN
        INSERT INTO controlCambios VALUES (
            USER,
            SYSDATE,
            'UPDATE_JEFE',
            TO_CHAR(:OLD.id_jefe),
            TO_CHAR(:NEW.id_jefe)
        );
    END IF;

END trg_auditoria_empleados;
/

-- Cambio de salario
UPDATE empleados SET salario = 3500 WHERE dni = '23823823A';



INSERT INTO EMPLEADOS (DNI, NOMEMP, departamento) VALUES ('23232323B', 'MANUEL', 100);
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP, departamento, salario) VALUES ( '23232323B','23823823A', 'PEDRO', 100, 5000);
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP, departamento, salario) VALUES ( '23232323B','23212323B', 'JOAQUIN', 100, 4000);
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP, departamento, salario) VALUES ( '23232323B','23211323B', 'MONICA',100, 2000);
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP) VALUES ( '23232323B','23234323B', 'SUSANA');
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP) VALUES ( '23232323B','23214313B', 'LUISA');
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP) VALUES ( '23232323B','4314313B', 'MARTA');
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP) VALUES ( '23232323B','4314313B', 'MARTA');
INSERT INTO EMPLEADOS (JEFE, DNI, NOMEMP) VALUES ( '23232323B','4234313B', 'CARLOS');

SELECT * FROM EMPLEADOS;

DELETE FROM empleados;