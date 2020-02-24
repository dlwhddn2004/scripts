--������ SQL �����̶� : �ؽ�Ʈ�� �Ϻ��ϰ� ������ SQL
--1. ��ҹ��� ���� (�߿���)
--2. ���鵵 ���� �ؾ���.
--3. ��ȸ ����� ���ٰ� ������ SQL�� �ƴ�
--4. �ּ��� ������ ��ģ��.

--�׷��� ������ ���� sql ������ ������ ������ �ƴ�;
--
--SELECT * + FROM dept;
--select * + FROM dept;
--select   * FROM dept;
--select *
--FROM dept

SQL ����� V$SQL �信 �����Ͱ� ��ȸ�Ǵ��� Ȯ��;

SELECT /* sql_test */ * 
FROM dept
WHERE deptno = 10;

SELECT /* sql_test */ * 
FROM dept
WHERE deptno = 20;

--�� �ΰ��� SQL�� �˻��ϰ��� �ϴ� �μ���ȣ�� �ٸ��� ������ �ؽ�Ʈ�� ����
--������ �μ���ȣ�� �ٸ��� ������ DBMS���忡���� ���� �ٸ� SQL�� �ν��Ѵ�.
--==> �ٸ� SQL ���� ��ȹ�� �����.
--==> ���� ��ȹ�� �������� ���Ѵ�.
--==>  �ذ�å ���ε� ����
--SQL���� ����Ǵ� �κ��� ������ ������ �ϰ� �����ȹ ������ ���Ŀ�
--���ε� �۾��� ���� ���� ����ڰ� ���ϴ� ���� ������ ġȯ�� ����
--==> ���� ��ȹ�� ���� ==>  �޸� �ڿ� ���� ����

SELECT /* sql_test*/ *
FROM dept
WHERE deptno = :deptno; --���ε����� ���� �ٲٱ� ������ �ٸ� sql�� �ν� ����
                        --���� ��ȹ�� ����(�����ȹ -> ���ε� -> ����)
--��ġ �ý÷� ���� ����� 15�� �־ ���� �����Ͱ� 10�ǹۿ������� 10�Ǹ� �а� ���ƿ�

--SQL Ŀ�� : SQL���� �����ϱ� ���� �޸� ����
--������ ����� SQL���� ������ Ŀ���� ���
--������ ���� �ϱ� ���� Ŀ�� : ����� Ŀ��

--SELECT ��� �������� TABLE Ÿ���� ������ ������ �� ������
--�޸𸮴� �������̱� ������ ���� ���� �����͸� ��⿡�� ������ ����.

--SQL Ŀ���� ���� �����ڰ� ���� �����͸� FETCH�����ν� SELECT �����
--���� �ҷ����� �ʰ� ������ ����

--Ŀ�� ���� ���: 
--�����(DECLARE)���� ����
--   CURSOR Ŀ���̸� IS 
--        ������ ����;
--        
--�����(BEGIN)
--    OPEN Ŀ���̸�;
--    
--�����(BEGIN)���� Ŀ���� ���� ������ FETCH
--    FETCH Ŀ���̸� INTO ����;
--    
--�����(BEGIN)���� Ŀ�� �ݱ�
--    CLOSE Ŀ���̸�;

�μ� ���̺��� Ȱ���Ͽ� ��� �࿡ ���� �μ���ȣ�� �μ� �̸��� 
CURSOR�� ���� FETCH, FETCH �� ����� Ȯ��;

SET SERVEROUTPUT ON;

DECLARE 
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    BEGIN
    OPEN dept_cursor; 
    
    LOOP
    
    FETCH dept_cursor INTO v_deptno, v_dname;--��ġ �ۿ�    
    EXIT WHEN dept_cursor%NOTFOUND; --��ȸ�� �����Ͱ� ������ ����
    DBMS_OUTPUT.PUT_LINE(v_deptno || ',' || v_dname);
    
    
    END LOOP;
    
END;
/

--CURSOR�� ���� �ݴ� ������ �ټ� ������ ������
--CURSOR �� �Ϲ������� LOOP�� �Բ� ����ϴ� ��찡 ����
--==> ����� Ŀ���� FOR LOOP���� ����� �� �ְ� �� �������� ����

--JAVA�� List<String> userName.List = new ArrayList<String>();
--user.NameList.add("brown");
--user.NameList.add("LEE");
--user.NameList.add("SALLY");

--����
--FOR record_name(������ ������ ���� �����̸� / ������ �������� X)
--  IN Ŀ���̸� LOOP record_name.�÷��� END LOOP;

--�Ϲ� for
--for(int i=0; i< user.NameList.size(); i++){
--    String userName = userNameList.get(i);}

--JAVA �� ���� for ���� ����
--for(String userName : userNameList){
--     userName���� ���....}

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    
    CURSOR dept_cursor IS
        SELECT deptno,dname
        FROM dept;
            
    BEGIN
        FOR rec IN dept_cursor LOOP --���� for�� ó�� �տ��� ���� �ڿ��� �迭
            DBMS_OUTPUT.PUT_LINE(rec.deptno ||','|| rec.dname);
        END LOOP;
    
    END;
    /

--���ڰ� �ִ� ����� Ŀ��
--���� Ŀ�� ������
--    CURSOR Ŀ���̸� IS ��������..;

--���ڱ� �ִ� Ŀ�� Ŀ�� ������
--    CURSOR Ŀ���̸�(����1,����1Ÿ��...) IS 
--    ��������
--        (Ŀ�� ����ÿ� �ۼ��� ���ڸ� ���� �������� ��� �� ���ִ�.)

DECLARE
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
    
    
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE) IS
        SELECT deptno,dname
        FROM dept
        WHERE deptno <= p_deptno;
            
    BEGIN
        FOR rec IN dept_cursor(20) LOOP --���� for�� ó�� �տ��� ���� �ڿ��� �迭
            DBMS_OUTPUT.PUT_LINE(rec.deptno ||','|| rec.dname);
        END LOOP;
    
    END;
    /

--JAVA �������̽��� �̿��Ͽ� ��ü�� ���� �����Ѱ�?


FOR LOOP���� Ŀ���� �ζ��� ���·� �ۼ�
FOR ���ڵ��̸� IN Ŀ�� �̸�
==>
FOR ���ڵ��̸� IN (��������);


DECLARE         
    BEGIN
        FOR rec IN (SELECT deptno, dname FROM dept) LOOP --���� for�� ó�� �տ��� ���� �ڿ��� �迭
            DBMS_OUTPUT.PUT_LINE(rec.deptno ||','|| rec.dname);
        END LOOP;
    
    END;
    /


 CREATE TABLE DT
(	DT DATE);
--���� ���� dt.sql 
insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;



--�ǽ� cursor PRO3
--for(int i=; i<arr.length-1; i++)

SELECT *
FROM dt;

CREATE OR REPLACE PROCEDURE avgdt IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
    
    v_dt_tab dt_tab;
    
    v_diff_sum NUMBER :=0;

BEGIN
    SELECT * BULK COLLECT INTO v_dt_tab
    FROM dt;
    
    --dt ���̺��� 8���� �ִµ� 1-7���� ������ loop�� ����
    FOR i IN 1..v_dt_tab.COUNT-1 
    LOOP
        v_diff_sum := v_diff_sum + v_dt_tab(i).dt -v_dt_tab(i+1).dt;
    END LOOP;
   DBMS_OUTPUT.PUT_LINE(v_diff_sum / (v_dt_tab.COUNT-1)); 
END;
/


--SQL�� Ǯ��ڸ�?
SELECT  AVG(dt2) --�м��Լ��� �׷��Լ��� ��ø�Ҽ� ���� ������ ���������� ��� ���� �׷��Լ��� ��Ÿ����
FROM 
(SELECT (dt -LEAD(dt) OVER (ORDER BY dt DESC)) dt2
FROM dt);


SELECT  AVG(dt2) 
FROM 
(SELECT (dt -LEAD(dt) OVER (ORDER BY dt DESC)) dt2
FROM dt);

--MAX, MIN , COUNT �� ������ Ǯ�� �ִ�.
SELECT (MAX(dt) - MIN(dt)) / (COUNT(dt)-1)
FROM dt;

