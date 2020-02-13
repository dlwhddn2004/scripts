--synonym : ���Ǿ�
--1. ��ü ��Ī�� �ο�
--==> �̸��� �����ϰ� ǥ��
--
--sem ����ڰ� �ڽ��� ���̺� emp ���̺��� ����ؼ� ���� v_emp view 
--hr����ڰ� ����� �� �ְ� �� ��ȯ�� �ο�
--v_emp : �ΰ��� ���� sal, comm �� ������ view

--hr ����� v_emp�� ����ϱ� ���� ������ ���� �ۼ�

SELECT *
FROM sem.v_emp;

--hr ��������
--synonym dlwhddn2004.v_emp ==> v_emp
--v_emp == dlwhddn2004.v_emp

SELECT *
FROM v_emp;

--1. dlwhddn2004 �������� v_emp�� hr �������� ��ȸ�� �� �ֵ��� ��ȸ���� �ο�
GRANT SELECT ON v_emp TO hr;

--2. hr ���� v_emp ��ȸ�ϴ°� ���� (��ȯ 1������ �޾ұ� ������)
--������ ���� �ش� ��ü�� �����ڸ� ��� : dlwhddn2004.v_emp
--�����ϰ� dlwhddn2004.v_emp ==> v_emp ����ϰ� ���� ��Ȳ
-- �׷���Ȳ�� synonym ���� < ����ϴ°������� ��������

--CREATE SYNONYM �ó���̸� FOR �� ��ü��

--SYNONYM ����
--DROP SYNONYM �ó���̸�; --�ó�� �ѹ� ���ͳ� �˻� ��


--DCL 
--GRANT ��ȯ / REVOKE ȸ��

--GRANT CONNECT TO dlwhddn2004;
--GRANT CONNECT ON ��ü�� TO HR; ��ü��ȯ �ý��� ��ȯ

--���� ����
--1. �ý��� ���� : TABLE�� ����, VIEW ���� ����...
--2. ��ü ���� : Ư�� ��ü�� ���� SELECT, UPDATE, DELETE...
--3. ROLE : ������ ��Ƴ��� ����
--    ����ں��� ���� ������ �����ϰ� �Ǹ� ������ �δ� 
--    Ư�� ROLE�� ������ �ο��ϰ� �ش� ROLE ����ڿ��� �ο�
--    �ش� ROLE�� �����ϰ� �Ǹ� ROLE�� ���� �ִ� ��� ����ڿ��� ����
--    
-- ���� �ο�/ȸ��
-- �ý��� ���� : GRANT �����̸� TO ����� | ROLE(���̸�)
--        ȸ�� : REVOKE �����̸� FROM ����� | ROLE
-- 
-- ��ü ��ȯ : GRANT �����̸� ON ��ü�� TO ����� |ROLE
--      ȸ�� : REVOKE �����̸� ON ��ü�� FROM ����� | ROLE
    
--�ý��ۿ��� ������ �ο��ϰ� ȸ�� �Ҷ�  
--user1 -> user2 ���� �ο� ->user3 ���Ѻο� user1�� ȸ���Ҷ��� �Ѳ����� ȸ���� �ȵ� 
--��ü���� ������ �ο��ϰ� ȸ�� �ҋ�
--user1 -> user2 ���� �ο� ->user3 ���Ѻο� �� ȸ���Ҷ� user1�� �Z�� ������ user2�� �������� �Z�� ���ѱ��� �� ȸ��
---------------------------------------------
--data dictionary : ����ڰ� �������� �ʰ� , dbms�� ��ü������ �����ϴ� �ý��� ������
--                    ���� view
--
--data dictionary ���ξ�
--1. USER : �ش� ����ڰ� ������ ��ü
--2. ALL : �ش� ����ڰ� ������ ��ü + �ٸ� ����ڷ� ���� ������ �ο����� ��ü
--3. DBA : ��� ������� ��ü (�Ϲݻ���ڴ� ��������)
--
--* VS Ư�� VIEW
--SELECT *
--FROM USER_TABLER -> USER �� ���ξ�

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES; --�Ϲ� ����ڶ� ������
--
--DICTIONARY ���� Ȯ�� : SYS.DICTIONARY;

SELECT *
FROM DICTIONARY;

--��ǥ���� DICTIONARY 
--OBJECTS: ��ü���� ��ȸ (���̺�, �ε��� , VIEW , SYNONYM....)
--TABLES : ���̺� ������ ��ȸ
--TAB_COLUMNS : ���̺��� �÷����� ��ȸ
--INDEXES : �ε��� ���� ��ȸ   �����ȹ�Ҷ� �ε��� ������ȸ ������ �ϱ�(�ӵ�)
--IND_COLUMNS : �ε��� ���� �÷� ��ȸ
--CONSTRAINTS : ���� ���� ��ȸ
--CONS_COLUMNS : �������� ���� �÷� ��ȸ
--TAB_COMMENTS : ���̺� �ּ� (�츮�� ���鶧 �ּ� �� ����)
--COL_COMMENTS : ���̺� �÷� �ּ�


SELECT *
FROM USER_OBJECTS; -- OBJECTS =����Ŭ ��ü����


--emp.dept ���̺��� �ε����� �ε��� �÷� ���(���̺��, �ε��� �� , �÷���, �÷�����)
--user_indexes  join user_ind_columns 

--emp ind_n_emp_04 ename
--emp ind_n_emp_04 job

SELECT table_name, index_name, column_name, column_position
FROM user_ind_columns
ORDER BY table_name, index_name, column_position;

SELECT a.table_name, a.index_name, b --�߰��������
FROM user_indexes a, user_ind_columns b
WHERE a.index_name = b.index_name;


SELECT *
FROM user_indexes;

SELECT *
FROM user_ind_columns;

--��Ƽ�� �μ�Ʈ multiple insert

--mutiple insert = �ϳ��� insert �������� ���� ���̺� �����͸� �Է��ϴ� DML
SELECT *
froM DEPT_TEST;

select *
from DEPT_TEST2;

--������ ���� ���� ���̺� ���� �Է��ϴ� ��Ƽ�� �μ�Ʈ
INSERT ALL
    INTO dept_test
    INTO dept_test2
SELECT 98,'���','�߾ӷ�' FROM dual 
UNION ALL
SELECT 97,'IT','����' FROM dual;

--------------
--���̺� �Է��� �÷��� �����Ͽ� multiple insert
ROLLBACK;
INSERT ALL
    INTO dept_test (deptno, loc) VALUES(deptno, loc)
    --ù��° dept_test ���̺��� �־��� ���̺� �÷��� ���� deptno, loc�� �־��شٴ°� ���ϴ°�
    INTO dept_test2
SELECT 98 deptno ,'���' dname,'�߾ӷ�' loc FROM dual 
UNION ALL
SELECT 97,'IT','����' FROM dual;

-----------------
--���̺� �Է��� �����͸� ���ǿ� ���� multiple insert
--case
--    when ���� ��� then
--end;

ROLLBACK;

INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno, loc)
        INTO dept_test2 
        --INTO�� WHEN �̳� ELSE �� �� �߰��Ҽ��� (IFó������)
    ELSE
        INTO dept_test2
SELECT 98 deptno ,'���' dname,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����' FROM dual;

SELECT *
FROM dept_test;

select *
FROM dept_test2;
--------------------------------
--������ �����ϴ� ù��° INSERT�� �����ϴ� MULTIPLE INSERT
ROLLBACK;

--first �����ϴ� ���ǿ� ù��° �༮�� 
INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno, loc)
    WHEN deptno >= 97 THEN
        INTO dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno ,'���' dname,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����' FROM dual;
------------

--����Ŭ ��ü : ���̺� �������� ������ ��Ƽ������ ����
--��Ƽ�� : ���̺� �̸������ϳ� ���� ������ ���� ����Ŭ ���������� ������ 
--          �и��� ������ �����͸� ����

--���� dept_test == > dept_test_20200201

INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test 
    WHEN deptno >= 97 THEN
        INTO dept_test_20200202
    ELSE
        INTO dept_test2
SELECT 98 deptno ,'���' dname,'�߾ӷ�' loc FROM dual UNION ALL
SELECT 97,'IT','����' FROM dual;

SELECT *
FROM dept_Test;


--MERGE : ����
--���̺� �����͸� �Է�/���� �Ϸ��� ��
--1. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �����ϸ� 
--    ==> ������Ʈ
--2. ���� �Է��Ϸ��� �ϴ� �����Ͱ� �������� ������
--    ==> INSERT

1.SELECT ����
2.SELECT ���� ����� 0 ROW�̸� INSERT
2-2 SELECT ���� ����� 1 ROW�̸� UPDATE;

MERGE ������ ����ϰ� �Ǹ� SELECT �� ���� �ʾƵ� 
�ڵ����� ������ ������ ���� INSERT Ȥ�� UPDATE ����ȴ�.
2���� ������ �ѹ����� �ش�.;

--MERGE INTO ���̺�� [alisas]
--USING (TABLE | VIEW | IN_LINE-VIEW)
--ON (��������)

--�������ǿ� ������ �Ѵٸ�
--WHEN MATCHED THEN 
--    UPDATE SET col = �÷� ��, col2 = �÷� ��..... 

--���ǿ� �������� �ʴٸ�
--WHEN NOT MATCHED THEN
--    INSERT (�÷�1, �÷�2.....) VALUES (�÷� ��1, �÷���2);

SELECT *
FROM emp_test;

DELETE emp_test;

--�α׸� �ȳ���� == ���� X -> �׽�Ʈ ��
TRUNCATE TABLE emp_test;

--emp���̺��� emp_test���̺�� �����͸� ���� (7369-SMITH)

INSERT INTO emp_test
SELECT empno, ename, deptno , '010'
FROM emp
WHERE empno = 7369;

--�����Ͱ� �� �Է� �Ǿ����� Ȯ��
SELECT *
FROM emp_test;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;

commit;

--emp���̺��� ��� ������ emp_test���̺�� �����Ϸ��Ѵٸ�?
--emp���̺��� ���������� emp_test���� �������� ������ insert
--emp���̺��� �����ϰ� emp_test���� �����ϸ� ename, deptno�� update

--�����Ҷ� �÷����� ������ ���Ƽ� ��Ī
MERGE INTO emp_test a
USING emp b 
ON (a.empno = b.empno)
    WHEN MATCHED THEN
        UPDATE SET a.ename=b.ename,
                    a.deptno=b.deptno
    WHEN NOT MATCHED THEN
        INSERT (empno, ename, deptno) VALUES (b.empno,b.ename,b.deptno);

--�������ϸ� emp ���̺� �����ϴ� 14���� �������� emp_test���� �����ϴ� 7369��
--������ 13���� �����Ͱ� emp_test���̺� �űԷ� �Է��� �ǰ�
--emp_test�� �����ϴ� 7369���� �����ʹ� ename(brown)�� emp���̺� �����ϴ� ename(SMITH)�� ����

--------------------------------------------------
--�ش� ���̺� �����Ͱ� ������ insert , ������ update
--emp_test���̺� ����� 9999���� ����� ������ ���Ӱ� insert
--������ update 
--(9999,'brown',10,'010')
--
--INSERT INTO dept_test VALUES (9999, 'brown',10,'010')
--UPDATE dept_test SET ename='brown'
--                        deptno =10
--                        hp = '010'
--WHERE empno = 9999;

MERGE INTO emp_test
USING dual
ON (empno =9999)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_u',
        --�����̸��� ���ο� �̸��� �߰��ϴµ� _u��� ���̾ ������ ������Ʈ
                deptno = 10,
                hp= '010'
WHEN NOT MATCHED THEN
    INSERT VALUES (9999,'brown',10,'010');
    
SELECT *
FROM emp_test;

--������ insert, update 2������ ������ �ѹ����� �����ִ� ����������
INSERT ALL
    INTO dept_test (deptno, loc) VALUES(deptno, loc)
    --ù��° dept_test ���̺��� �־��� ���̺� �÷��� ���� deptno, loc�� �־��شٴ°� ���ϴ°�
    INTO dept_test2
SELECT 98 deptno ,'���' dname,'�߾ӷ�' loc FROM dual 
UNION ALL
SELECT 97,'IT','����' FROM dual;


SELECT deptno,SUM(sal)
FROM emp 
GROUP BY deptno
UNION
SELECT null, SUM(sal)
FROM emp;

-- I/O�ӵ�
--CPU CACHE > RAM > SSD> HDD> NETWORK

--REPORT GROUP FUNTION
ROLLUP
CUBE
GROUPING;

--ROLLUP
--    ����� : GROUP BY ROLLUP (�÷�1..�÷�2....)
--Ư¡ : SUBGROUP�� �ڵ������� ����    
--SUBGROUP�� �����ϴ� ��Ģ : ROLLUP�� ����� �÷��� !������!�������� �ϳ��� �����ϸ鼭
--                        SUB GROUP ����
EX) GROUP BY ROLLUP (deptno)
==>
ù��° sub group : group by deptno
�ι�° sub group : group by null ==> ��ü ���� ���

--group_adi�� group by rollup ���� ����Ͽ� �ۼ��϶�
SELECT deptno , SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);



SELECT job, deptno, SUM(sal +NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP BY job, deptno : ������, �μ��� �޿���
--GROUP BY job  : �������� �޿���
--GROUP BY    :��ü �޿���

SELECT job, deptno,
        GROUPING(job), GROUPING(deptno),
        SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);
--grouping�� �̿��ϸ� �Ѱ踦 ��Ÿ���� 
--group_ad2
SELECT 
    CASE --case���� ���θ���ٰ� ������������ �߰��Ѵٰ� �����Ѵ�.
        WHEN  GROUPING(job)=1 AND GROUPING(deptno)=1
               THEN  '�Ѱ�' ELSE job end job,
        deptno,
        SUM(sal+ NVL(comm,0)) sal
FROM emp    
GROUP BY ROLLUP (job, deptno);
--���� decode�� �ϱ�
SELECT
    DECODE(GROUPING(job),1,DECODE(GROUPING(deptno),1,'�Ѱ�'), job) job,
    deptno,
    SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job,deptno);
-- job �� deptno �Ұ�, �� 

--�� �̰� 1�ð�40�� �ɷȽ��ϴ� ������
SELECT 
    CASE
        WHEN GROUPING(job)=1 AND GROUPING(deptno)=1 THEN '��' ELSE job end JOB,
        
        CASE WHEN TO_CHAR(GROUPING(job)) = 0 THEN 
        CASE WHEN TO_CHAR(GROUPING(deptno))= 1 THEN '�Ұ�' ELSE TO_CHAR(deptno) END 
        ELSE '��' END deptno,
        SUM(sal+NVL(comm,0)) sal
    FROM emp
    GROUP BY ROLLUP(job,deptno);
    
        
            
        
        
        
