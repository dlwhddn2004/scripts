--1. leaf���(��)�� � ���������� Ȯ��
--2.LEVEL ==> ����Ž���� �׷��� ���� ���� �ʿ��� ��
--3. leaf ������ ���� Ž��,ROWNUM ;
SELECT LPAD(' ',(LEVEL-1)*4)|| org_cd,total
FROM
(SELECT org_cd,parent_org_cd, SUM(total) total
        FROM
    (SELECT org_cd, parent_org_cd,no_emp,
            SUM(no_emp) OVER (PARTITION BY gno ORDER BY rn
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total
            FROM

        (SELECT org_cd,parent_org_cd,lv, ROWNUM rn,lv+ROWNUM gno,
        no_emp/ COUNT(*) over (PARTITION BY org_cd) no_emp
                FROM 
            (SELECT no_emp.*,level lv, connect_by_ISLEAF leaf
                     FROM no_emp
            START WITH parent_org_cd IS null
            CONNECT BY PRIOR org_cd = parent_org_cd) --�����
        START WITH leaf =1
        CONNECT BY PRIOR parent_org_cd = org_cd)) --�����
GROUP BY org_cd,parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd= parent_org_cd;
---------------------------------------------------
DROP TABLE gis_dt;
--CTAS �ִ� ���̺� �߰��Ͽ� ���ο����̺� ����°�~!
CREATE TABLE gis_dt AS
SELECT SYSDATE + ROUND(DBMS_RANDOM.value(-30, 30)) dt,
       '����� ����� ������ Ű��� ���� ���� ������ �Դϴ� ����� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴٺ���� ����� ������ Ű��� ���� ���� ������ �Դϴ�' v1
FROM dual
CONNECT BY LEVEL <= 1000000;

CREATE INDEX idx_n_gis_dt_01 ON gis_dt (dt, v1);
---------------------������ ����
--gis_dt�� dtĮ������ 2020�� 2���� �ش��ϴ� ��¥�� �ߺ����� �ʰ� ���Ѵ� : �ִ� 29���� ��
2020/02/01
2020/02/02
2020/02/03
....
2020/02/29;

--2020/02/03 ==> 2020/02/03 �ش絥���Ͱ� �������־ �ѹ��� ���̰�
2020/02/03
2020/02/03
2020/02/04;
desc gis_dt;

SELECT dt
FROM gis_dt
WHERE dt >= TO_DATE('2020/02/01' , 'YYYY/MM/DD') AND dt < TO_DATE('2020/03/01' , 'YYYY/MM/DD')
GROUP BY dt;

SELECT TO_CHAR(dt, 'YYYY/MM/DD')
FROM gis_dt
WHERE dt BETWEEN TO_DATE('2020/02/01' , 'YYYY/MM/DD') AND TO_DATE('2020/02/29 23:59:59' , 'YYYY/MM/DD hh24:mi:ss')
GROUP BY TO_CHAR(dt, 'YYYY/MM/DD')
ORDER BY TO_CHAR(dt, 'YYYY/MM/DD');

---�� ������ ��¿������ 29���� �����͸� ���� 100������ ���̺��� ������ EXISTS�� �̿��Ͽ� �ӵ��� �����ش� 
--EXISTS�� �ε����� Ȱ��
    SELECT *
    FROM
        (SELECT TO_DATE('20200201', 'YYYYMMDD') +(level-1) dt
           FROM dual
           CONNECT BY LEVEL <=29) a --1 �ζ��� �� �����
    WHERE EXISTS (SELECT 'X'        --2 �並 ���� EXISTS Ȱ���Ѵ�
                    FROM gis_dt
                    WHERE gis_dt.dt BETWEEN dt AND TO_DATE(TO_CHAR(dt, 'YYYYMMDD') || '235959', 'YYYYMMDDHH24MISS'));

--pl/sql ��� ����
--DECLARE : ����, ��� ���� [���� ����]
-- BEGIN  :���� ��� [���� �Ұ�]
--EXCEPTION : ����ó�� [��������]
--
--PL/SQL ������
--�ߺ� �Ǵ� ������ ���� Ư����
--���Կ����ڰ� �Ϲ����� ���α׷��� ���� �ٸ���.
--JAVA -> = 
--pl/sql -> :=

--pl/sql ���� ����
--JAVA : Ÿ�� ������ (String str)
--PL/SQl : ������ Ÿ�� deptno NUMBER(2)

--pl/sql �ڵ� ������ ���� ����� JAVA�� �����ϰ� �����ݷ��� ����Ѵ�
--JAVA : String str ;
--pl/sql : deptno NUMBER(2);

--PL/sql ����� ���� ǥ���ϴ� ���ڿ� : /
--SQL �� ���� ���ڿ� : ;


--Hello World ���
SET SERVEROUTPUT ON;

DECLARE 
    msg VARCHAR2(50);
begin
    msg := 'Hello, World!';
    DBMS_OUTPUT.PUT_LINE(msg);
END; 
/
�μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ� �̸��� pl/sql ������ �����ϰ� 
������ ����غ���
DESC dept;

declare  
    v_deptno NUMBER(2);
    v_dname VARCHAR(14);
begin
    SELECT deptno,dname INTO v_deptno, v_dname -- begin�� ����Ǵ� ���� declare ������ �÷��� �־��
    FROM dept
    WHERE deptno =10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : '|| v_dname);
end;
/
---------------------------------

--pl/sql ���� Ÿ��
--�μ� ���̺��� �μ���ȣ, �μ����� ��ȸ�Ͽ� ������ ��°���
--�μ���ȣ, �μ����� Ÿ���� �μ� ���̺� ���ǰ� �Ǿ�����
--
--NUMBER, VARCHAR2 Ÿ���� ���� ����ϴ°� �ƴ϶� �ش� ���̺��� �÷��� Ÿ���� �����ϵ���
--���� Ÿ���� ���� �� �� �ִ�.
v_deptno NUMBER(2) ==> dept.deptno%TYPE ; 

DECLARE  
   v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    SELECT deptno,dname INTO v_deptno, v_dname -- begin�� ����Ǵ� ���� declare ������ �÷��� �־��
    FROM dept
    WHERE deptno =10;
    
    DBMS_OUTPUT.PUT_LINE(v_deptno || ' : '|| v_dname);
END;
/

--���ν��� ��� ����
--.�͸� ��(�̸��� ���� ��)
--.������ �Ұ��� �ϴ�(IN-LINE VIEW VS VIEW)

--���ν��� (�̸��� �ִ� ��)
--.���� �����ϴ�
--.�̸��� �ִ�
--.���ν����� ���� �� �� �Լ�ó�� ���ڸ� ���� �� �ִ�.

--�Լ� (�̸��� �ִ� ��)
--. ���� �����ϴ�
--.�̸��� �ִ�
--.���ν����� �ٸ����� ���� ���� �ִ�.

���ν��� ����
CREATE OR REPLACE PROCEDURE ���ν��� �̸� IS (IN param, OUT param, IN OUT param)
    ����� (DECLARE ���� ������ ����)
    BEGIN
    EXCEPTION (�ɼ�)
END;
/

--�μ� ���̺��� 10�� �μ��� �μ���ȣ�� �μ��̸��� PL/SQL ������ �����ϰ�
--DBMS_OUTPUT.PUT_LINE �Լ��� �̿��Ͽ� ȭ�鿡 ����ϴ� printdept ���ν����� ����

CREATE OR REPLACE procedure printdept IS 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    BEGIN
        SELECT deptno, dname INTO v_deptno, v_dname --INTO ������ ������ �־���
        FROM dept
        WHERE deptno=10;
        
        DBMS_OUTPUT.PUT_LINE(v_deptno || ' : ' || v_dname);
    END;
/

--���ν��� ���� ���
--exec ���ν�����(����..)
exec printdept;

--printdept_p ���ڷ� �μ���ȣ�� �޾Ƽ�
--�ش� �μ���ȣ�� �ش��ϴ� �μ��̸��� ���������� �ֿܼ� ����ϴ� ���ν���

CREATE OR REPLACE procedure printdept_p(p_deptno IN dept.deptno%TYPE) IS
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
    
    BEGIN
        SELECT dname, loc INTO v_dname ,v_loc
        FROM dept
        WHERE deptno = p_deptno;
        DBMS_OUTPUT.PUT_LINE(v_dname || ','|| v_loc);
    end;
/
 exec printdept_p(50);
 
 CREATE OR REPLACE procedure printemp (p_empno IN emp.empno%TYPE) IS
    v_empno emp.empno%TYPE;
    v_dname dept.dname%TYPE;
    
    BEGIN
        SELECT emp.empno, dept.dname INTO v_empno , v_dname
        FROM emp, dept
        WHERE emp.deptno = dept.deptno AND emp.empno = p_empno;
        
        
        
        DBMS_OUTPUT.PUT_LINE(v_empno || ','|| v_dname);
    END;
    
/    
