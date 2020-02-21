SET SERVEROUTPUT ON;
--�ǽ� 1
CREATE OR REPLACE PROCEDURE registdept_test 
(p_deptno IN dept_test.deptno%TYPE,
  p_dname IN dept_test.dname%TYPE,
    p_loc IN dept_test.loc%TYPE) IS -- is ���� ����� ��� �����ϸ��(declare ���������ϴ� ���� �ľ��ϱ�)

 BEGIN
   INSERT INTO dept_test  values (p_deptno, p_dname, p_loc,0);
   COMMIT;
   END;
   /
   
  exec registdept_test(99,'ddit','daejeon');

--�ǽ� 2
CREATE OR REPLACE PROCEDURE UPDATdept_test 
    (p_deptno IN dept_test.deptno%TYPE,
    p_dname IN dept_test.dname%TYPE,
    p_loc IN dept_test.loc%TYPE) IS
    
    BEGIN
    UPDATE dept_test SET dname = p_dname, loc = p_loc
    WHERE  deptno =p_deptno; --������Ʈ ���� ������� deptno�� p_deptno �϶� �� �ִ°Ŷ����ȴ�
    
    COMMIT;
    END;
    /
    
exec UPDATdept_test (99,'ddit_m','daejeon');

SELECT *
FROM dept_test;


--���պ��� %rowTYPE : Ư�� ���̺��� ���� ��� �÷��� ���� �� �� �ִ� ����
--��� ��� : ������ ���̺��%ROWTPYE

DECLARE
    v_dept_row dept%ROWTYPE; --���պ����� ����Ϸ��� Ÿ���� %rowTYPE
    BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ',' || v_dept_row.dname ||','|| v_dept_row.loc);
    END;
    /


--���պ��� RECORD
--�����ڰ� ���� �������� �÷��� ���� �� �� �ִ� Ÿ���� �����ϴ� ���
--JAVA�� �����ϸ� Ŭ������ �����ϴ� ����
--�ν��Ͻ��� ����� ������ ��������
����
TYPE Ÿ���̸� (�����ڰ� ����) 
    IS RECORD ( ������1 ����Ÿ��,
                ������2 ����Ÿ��....)
    
    ������ Ÿ���̸�;
        
DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14));
        
    v_dept_row dept_row; --dept_row(���� �����Ѱ�ó�� Ÿ���̸�)
    
    BEGIN
        SELECT deptno, dname INTO v_dept_row
        FROM dept
        WHERE deptno=10;
    
        DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ','|| v_dept_row.dname);
    END;
/    


--table type ���̺� Ÿ��
--��: ��Į�� ����
--��: %ROWTYPE, record type
--��: table type

--    � ����(%ROWTYPE, RECORD TYPE)�� ������ �� �ִ���
--    �ε��� Ÿ���� ��������;

--DEPT ���̺��� ������ ���� �� �ִ� TABLE type�� ����
--������ ��� ��Į�� Ÿ��, rowtype������ �� ���� ������ ���� �� �־����� (������OR �����÷�)
--table Ÿ�� ������ �̿��ϸ� �������� ������ ���� �� �ִ�.

--PL/SQL ������ �ڹٿ� �ٸ��� �迭�� ���� �ε����� ������ �����Ǿ� ���� �ʰ� 
--���ڿ��� �����ϴ�. �׷��� 
TABLE Ÿ���� ���� �Ҷ��� �ε����� ���� Ÿ�Ե� ���� ���
BINARY_INTEGER Ÿ���� PL/SQL������ ��� ������ Ÿ������
NUMBER Ÿ���� �̿��Ͽ� ������ ��� �����ϰ� ���� NUMBER Ÿ���� ���� Ÿ���̴�.;


DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    --dept������ ������������ִ� Ÿ���̴� ,INDEX BY BINARY_INTEGER ������ �Ļ���Ų Ÿ��
    v_dept_tab dept_tab;
    BEGIN
        SELECT * BULK COLLECT INTO v_dept_tab --BULK COLLECT INTO �������� ��Ÿ���� ����
        FROM dept;
        --���� ��Į�󺯼�,record Ÿ���� �ǽ��ÿ��� 
        --���ุ ��ȸ �ǵ��� where���� ���� �����Ͽ���.
        
        --�ڹٿ����� �迭[�ε��� ��ȣ]
        --PL/SQL -> TABLE���� (�ε��� ��ȣ)
        --DBMS_OUTPUT.PUT_LINE(v_dept_tab(1).deptno ||',' ||v_dept_tab(2).dname);
        
        --�ڹ� for (int =0; i< 10; i++){};
        --pl/sql for i ON 1..���̺�Ÿ��.count LOOP [��Ÿ����] END LOOP // .. �� 2����
        --pl/sql ���� count �� �ڹٿ��� length
        for i IN 1..v_dept_tab.COUNT LOOP
         DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno ||',' ||v_dept_tab(i).dname);
        END LOOP;
    
    END;
    /
-----------------
--�������� IF
--����
--    
--IF ���ǹ� THEN
--    ���๮
--
--ELSIF ���ǹ� THEN
--    ���๮
--ELSE
--    ���๮;
--END IF;

DECLARE
    p NUMBER(1) :=2; --����� ���ÿ� ���� ����
    
BEGIN
    IF p= 1 THEN
        DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
    ELSIF p= 2 THEN
        DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�˷����� �ʾҽ��ϴ�');
    END IF;
END;
/
----------
CASE ����
1.�Ϲ� ���̽� (JAVA�� switch�� ����)
2.�˻� ���̽� (JAVA�� if,else if,else)

--CASE expression --ã���� �ϴ� ��
--    WHEN value THEN
--        ���๮;
--    WHEN value THEN
--        ���๮;
--    ELSE
--        ���๮;
--END CASE; 

DECLARE --�Ϲ� ���̽�
    p NUMBER(2) := 4;
BEGIN
    CASE p
    WHEN 1 THEN
    DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
    WHEN 2 THEN
    DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
    ELSE
    DBMS_OUTPUT.PUT_LINE('�𸣴� ��');
    END CASE;
END;
/

--�Ʒ��ڵ� �˻� ���̽� WHEN ���� �پ��ϰ� ������ �ɼ� ���� WHEN P=1 AND~~~~
DECLARE
    p NUMBER(2) := 2;
BEGIN
    CASE p
    WHEN P=1 THEN
    DBMS_OUTPUT.PUT_LINE('1�Դϴ�');
    WHEN P=2 THEN
    DBMS_OUTPUT.PUT_LINE('2�Դϴ�');
    ELSE
    SBMS_OUTPUT.PUT_LINE('�𸣴� ��');
    END CASE;
END;
/

--for loop����
--FOR ��������/�ε������� IN [REVERSE] ���۰�..���ᰪ LOOP
--    �ݺ��� ����;
--END LOOP;

--1���� 5���� FOR LOOP �ݺ����� ���� ���� ���
DECLARE 
BEGIN
    FOR i IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

�ǽ� 2~9�� ������ �������� ���;

DECLARE
       BEGIN
        FOR i IN 2..9 LOOP
            FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || '*' || j ||'='|| i*j);
            END LOOP;
        END LOOP;
    END;
/

--while loop ����
--WHERE ���� LOOP
--    �ݺ������� ����;
--    END LOOP;
    
DECLARE
    i number := 0;
    BEGIN
        WHILE i <= 5 LOOP  
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
        END LOOP;
    END;
/

------------
--LOOP�� ���� ==> JAVA�� while(true)

--LOOP
--    �ݺ������� ����;
--    EXIT WHEN ���� -- �ڹ��� break;
--END LOOP ;

DECLARE
     i NUMBER := 0;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        EXIT WHEN i >5;
         i := i+1;
    END LOOP;
    END;
    /












    