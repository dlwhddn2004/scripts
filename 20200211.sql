--�������� Ȯ�� ���
--1. tool
--2. dictionary view
--�������� : USER_CONSTRAINTS
--�������� - �÷� : USER_CONS_COLUMNS
--���������� ��� �÷��� ���õǾ� �ִ��� �˼� ���� ������ ���̺��� ������ �и��ϸ� ����
--1������

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP','DEPT','EMP_TEST','DEPT_TEST');
--
--//emp, pk, fk ������ ������������
--emp : pk(empno)
--      fk (depno) -dept.deptno
--      kf ������ �����ϱ� ���ؼ��� �����ϴ� ���̺� �÷��� �ε����� �����ؾ� �Ѵ�.

--dept : pk (deptno)
ALTER TABLE emp ADD CONSTRAINT PK_EMP PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT PK_DEPT PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT FK_EMP_DEPT FOREIGN KEY (deptno) REFERENCES dept (deptno);


--���̺� �÷� �ּ� : DICTIONARY �� Ȯ�� ����
--���̺� �ּ� : USER_TAB_COMMENTS;
-- �÷� �ּ� : USER_COL_COMMENTS;

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

--�ּ�����
--���̺� �ּ� : COMMENT ON TABLE ���̺�� IS '�ּ�';
--�÷� �ּ� : COMMENT ON COLUMN ���̺��.�÷� IS '�ּ�';

--EMP : ����
--DEPT : �μ�
---------------------���̺� �ּ�
COMMENT ON TABLE EMP IS '����';
COMMENT ON TABLE DEPT IS '�μ�';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');


---------------------�÷� �ּ�
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ';

COMMENT ON COLUMN emp.empno IS '������ȣ';
COMMENT ON COLUMN emp.ename IS '�����̸�';
COMMENT ON COLUMN emp.job IS '������';
COMMENT ON COLUMN emp.mgr IS '�Ŵ��� ������ȣ';
COMMENT ON COLUMN emp.hiredate IS '�Ի�����';
COMMENT ON COLUMN emp.sal IS '�޿�';
COMMENT ON COLUMN emp.comm IS '������';
COMMENT ON COLUMN emp.deptno IS '�ҼӺμ���ȣ';
-----------------------------------------------
SELECT *
FROM user_tab_comments;
SELECT *
FROM user_col_comments;

SELECT *
FROM user_tab_comments  utc JOIN user_col_comments ucc
 ON (utc.table_name = ucc.table_name 
 AND utc.TABLE_NAME IN ('CUSTOMER','PRODUCT','CYCLE','DAILY'));
 
 --view �� ����(view = query) 
 --TABLE ó�� DBMS�� �̸� �ۼ��� ��ü ==> �ۼ����� �ʰ� QUERY���� �ٷ� �ۼ��� VIEW :
 --IN:-LINE VIEW (�̸��� ���� ������ ��Ȱ���� �Ұ�) , VIEW �� ���̺��� �ƴϴ�! (X)
 --view�� �����ϴ� ���̺��� �����ϸ� view���� ������ ��ģ��.
 
--������
--1. ���� ���� (Ư�� �÷��� �����ϰ� ������ ����� �����ڿ� ����)
--2. INLINE-VIEW �� VIEW�� �����Ͽ� ��Ȱ�� --> ���� ���� ����

--�������
--CREATE [OR RELACE] VIEW ���Ī [ (column1,column2...)] AS
--SUBQUERY;

--EMP ���̺��� 8���� �÷��� SAL, COMM�÷��� ������ 6�� �÷��� �����ϴ� V_EMP VIEW ����
CREATE OR REPLACE VIEW v_emp as
SELECT empno,ename,job,mgr,hiredate,deptno
FROM emp;
--���� insufficient privileges ������ϴ� ��ȯ�� ����


--�ý��� �������� jongwoo �������� view ���� ��ȯ �߰�
GRANT CREATE VIEW TO dlwhddn2004;


--���� �ζ��� ��� �ۼ���;
SELECT *
FROM (SELECT empno,ename,job,mgr,hiredate,deptno
        FROM emp);
        
--VIEW ��ü Ȱ��
SELECT *
from v_emp;

--emp ���̺��� �μ����� ���� ==> dept ���̺�� ������ �����ϰ� ����
-- ���ε� ����� view�� ���� �س����� �ڵ带 �����ϰ� �ۼ��ϴ°� ����

dname(�μ���), ������ȣ(empno), ename(�����̸�), job(������),hiredate(�Ի�����);

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp,dept
WHERE emp.deptno = dept.deptno;

---�� ���� ��� �Ѵٸ�?
SELECT 
FROM (SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp,dept
WHERE emp.deptno = dept.deptno);

-----VIEW Ȱ�� ��
SELECT *
FROM v_emp_dept;

--SMITH ���� ������ v_emp_dept view �Ǽ� ��ȭ�� Ȯ��
delete emp
WHERE ename = 'SMITH';

--VIEW �� �������� �����͸� ���� �ʰ�, ������ �������� ���� ����(SQL)�̱� ������
--VIEW���� �����ϴ� ���̺��� �����Ͱ� ������ �Ǹ� VIEW�� ��ȸ ����� ������ �޴´�.


ROLLBACK;

--view dml �� ��κ� �����ϳ�
--group by, distnct, rownum ��� �Ұ�
-------------------------
--SEQUENCE : ������ - �ߺ����� �ʴ� �������� �������ִ� ����Ŭ ��ü
--CREATE SEQUENCE ������_�̸�
--[OTTION.....]
--����Ģ : SEQ_���̺��;

--EMP ���̺��� ����� ������ ����
--CREATE SEQUENCE  seq_emp;

--������ ���� �Լ�
--NEXTVAL : ���������� ���� ���� ������ �� ���.
--CURRVAL : NEXTVAL�� ����ϰ� ���� ���� �о�帰 ���� ��Ȯ��
SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james',99,'017'); -- empno�� �������� ���� �о� �帰 ���� �ִ´�

--������ ������
-- ROLLBACK �� �ϴ��� NEXTVAL�� ���� ���� ���� �������� �ʴ´�.
-- NEXTVAL�� ���� ���� �޾ƿ��� �� ���� �ٽ� ����� �� ����.



--INDEX
SELECT ROWID, emp.*
FROM emp;

SELECT *
FROM EMP
WHERE   ROWID = 'AAAE59AAFAAAAD7AAH';

--�ε����� ������ EMPNO ������ ��ȸ �ϴ� ���

EMP ���̺��� PK_EMP ���������� �����Ͽ� EMPNO �÷����� �ε����� �������� �ʴ� ȯ���� ����
ALTER TABLE emp DROP CONSTRAINT pk_emp;


explain plan for
SELECT *
FROM emp
WHERE empno= 7782;


SELECT *
FROM TABLE(dbms_xplan.display);

--emp ���̺��� empno �÷����� PK������ �����ϰ� ������ SQL�� ����
--PK : unique + NOT NULL
--    (unique �ε����� �������ش�)
--    ==>> empno �÷����� unique �ε����� ������
-- 
-- �ε����� sql�� �����ϰ� �Ǹ� �ε����� �������� ��� �ٸ��� �������� Ȯ��;

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno =7782;

SELECT *
FROM TABLE(dbms_xplan.display); --accescc�� �����͸� �ٷ� �����ϴ°Ű�, filter�� �����͸� ã�� �����°�
                                --   2 - access("EMPNO"=7782)           filter("EMPNO"=7782)

explain plan for
SELECT *
FROM emp
WHERE ename= 'SMITH';

SELECT *
FROM TABLE(dbms_xplan.display); 

--SELECT ��ȸ �÷��� ���̺� ���ٿ� ��ġ�� ����
--SELECT * FROM emp WHERE empno = 7782
--==>
--SELECT empno FROM emp WHERE empno = 7782

explain plan for
SELECT empno
FROM emp
WHERE empno= 7782;

SELECT *
FROM TABLE(dbms_xplan.display); --����Ŭ�� sql���� FROM emp�� �־ ������ �̹� UNIQUE �ε����� empno�� �ִ°� ã�Ƴ��� ����
                                -- ���̺��� ��ȸ�����ʰ� ���̷�Ʈ�� empno�� ã�Ƴ��� access�Ѵ�
----------------------------------

--unique VS NON-unique �ε����� ����
--1.pk_emp ����
--2. empno �÷����� NON-unique �ε��� ����
--3.�����ȹ Ȯ��
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX idx_n_emp_01 ON emp (empno);     --idx_n or idx_u �ε����� non�̳� �ƴϳĿ� ���� ����Ģ
                                        --non-unique �ε��� �����ϴ� �� ã�ƺ��� �߿�

explain plan for
SELECT *
FROM emp
WHERE empno= 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
-- non-unique �ε����� empno���� �������� ������ ���
-- �������� ����� �ü� �ִ�.
--�ε����� ���ĵ� ��ü�̹Ƿ� ã���� �ϴ� ���� ��ġ�� ������ �˻��Ͽ�
-- ex empno=7782 �ϰ�� 7782�� ���Ʒ��� ��ĵ�ϰ� 7782�� ������ ����

--emp ���̺� job �÷��� �������� �ϴ� ���ο� non-unique �ε����� ����

CREATE INDEX idx_n_emp_02 ON emp(job);

SELECT job, rowid
FROM emp
ORDER BY job;

--�Ʒ� ������ ���� ���ð����� ����
--1. emp ���̺��� ��ü �б�
--2. idx_n_emp_01 (empno) �ε����� Ȱ��
--3. idx_n_emp_02 (job) �ε����� Ȱ��


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);