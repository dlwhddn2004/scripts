--TRUNCATE �׽�Ʈ
--rede �α׸� �������� �ʱ� ������ ������ ������ ������ �Ұ��ϴ�.
--DML (SELECT, INSERT , UPDATE, DELETE)�� �ƴ϶� DDL�� �з� (ROOLBACK�� �Ұ�)

--�׽�Ʈ �ó�����
--emp���̺� ���縦 �Ͽ� EMP_COPY ��� �̸����� ���̺� ����
--EMP_COPY ���̺��� ������� TRUNCATE TABLE  EMP_COPY ����

--EMP_COPY ���̺� �����Ͱ� �����ϴ��� (���������� ������ �Ǿ�����) Ȯ��

--EMP_COPY ���̺� ����;
--CREATE ==> DDL (ROLLBACK�� �ȵȴ�) �ٸ���ɾ ���ؼ� ���������
CREATE TABLE EMP_COPY

SELECT *
FROM emp;

SELECT *
FROM emp_copy;

--��ɾ�� DDL �̱� ������ ROLLBACK�� �Ұ��ϴ�
TRUNCATE TABLE emp_copy;

ROLLBACK; 
-- �ѹ��� �ȵ� DML x , DDL �̱⶧��
-- �ѹ� �� SELECT �غ��� �����Ͱ� ���� ���� ���� ���� �� �� �ִ�.



--��ȭ ���� (�б� �ϰ���)
--Ʈ����� : �����ܰ��� �ϳ��� ������ ������ ���°�



--DDL : date Definition Language -������ ���Ǿ�
--��ü�� ����, ���� , ������ ���
-- ROLLBACK �Ұ�
--�ڵ� COMMIT ;


-- ���̺� ����
--CREATE TABLE [��Ű����.]���̺� ��(
--       �÷��� �÷�Ÿ�� [DEFAULT �⺻ ��],
--       �÷���2 �÷�Ÿ�� [DEFAULT �⺻ �� ],
--       �÷���3 �÷�Ÿ�� [DEFAULT �⺻ �� ],...);

--ranger �̸��� ���̺� ����
CREATE TABLE ranger (
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_gt DATE DEFAULT SYSDATE);
    
SELECT *
FROM ranger;

INSERT INTO ranger (ranger_no, ranger_nm) VALUES (1,'brown');

--���̺� ����
--DROP TABLE ���̺� ��;

--ranger ���̺� ����(drop);
DROP TABLE ranger;

SELECT *
FROM ranger;

--DDL�� �ѹ� �Ұ�;
ROLLBACK;

--���̺��� �ѹ���� ���� ���� Ȯ�� �Ҽ� �ִ�.
SELECT *
FROM ranger;

--������Ÿ��
--���ڿ� (varchar2 ��� , char Ÿ�� ��� ����)
--varchar(10) : �������� ���ڿ� , ������ 1~4000byte
--              �ԷµǴ� ���� �÷� ������� �۾Ƶ� ���� ������ �������� ä���� �ʴ´�.

-- char(10) : �������� ���ڿ�
--          �ش� �÷��� ���ڿ��� 5byte�� �����ϸ� ������ 5byte �������� ä������.
--                'test' ==> 'test    '
--                'test' != 'test    '  �ٸ��ٴ°� ����!



--���� 
--  NUMBER(p, s) : p - ��ü�ڸ��� (38�ڸ�) , s - �Ҽ��� �ڸ��� 
-- ex) ranger_no NUMBER --? NUMBER(38, 0) ���� �ν� 
-- INTEGER ==> NUMBER(38, 0) ���� �ν�


--��¥
-- DATE - ���ڿ� �ð� ������ ����
--  7byte �� ����
-- ȸ�翡���� ��¥�� DATE Ÿ�� �Ǵ� ���ڿ� Ÿ������ ���µ� ������ ������� ���̰� ��Ÿ����.
-- ��¥ -DATE
--      VARCHAR2(8) - '20200207'
-- �� �ΰ��� Ÿ���� �ϳ��� �����ʹ� 1byte�� ������ ���̰� ����.
-- ������ ���� ���� ���� �Ǹ� ������ �� ���� �������, ����� Ÿ�Կ� ���� ����� �ʿ�



--LOB (Large OBject) - �ִ� 4GB
-- CLOB - character Large OBject
--          VARCHAR2 �� ���� �� ���� �������� ���ڿ�(400byte �ʰ� ���ڿ�), {�ַ� �Խ��� ���鶧 ���}
--          ex) �� �����Ϳ� ������ html �ڵ�

-- BLOB - Byte  Large OBject
--          ������ �����ͺ��̽��� ���̺��� ������ ��

-- �Ϲ������� �Խñ� ÷�������� ���̺� ���� �������� �ʰ�, ���� ÷��������
-- ��ũ�� Ư�� ������ �����ϰ� �ش� [���]�� ���ڿ��� ����

-- ������ �ſ� �߿��� ��� ex) �� ������� ���Ǽ� -> ������ ���̺� ���� (DB�� �����ִ¸��) 



-- ���� ���� : �����Ͱ� ���Ἲ�� ��Ű���� ���� ����
--1. UNIQUE ��������
--     �ش� �÷��� ���� �ٸ� ���� �����Ϳ� [�ߺ�]���� �ʵ��� ����
-- ex) ����� ���� ����� ���� ���� ����.

--2. NOT NULL �������� (CHECK ��������)
-- �ش� [�÷��� ���� �ݵ�� ����]�ؾ��ϴ� ����
-- ex) �����ȣ �÷��� NULL�� ����� ���� �Ҽ� ����.
--      ȸ������ �Ҷ� �ʼ� �Է»��� (github�� �̸��� �̶�, �̸�)

--3. PRIMARY KEY ���� ����
-- UNIQUE + NOT NULL 
-- ex) ����� ���� ����� ���� ���� ����, ����� ���� ����� ���� ���� ����.
-- PRIMARY KEY ���� ������ ������ ��� �ش� �÷����� UNIQUE INDEX�� ������

--4. FOREING KEY ���� ���� (�������Ἲ)
-- �ش� �÷��� �����ϴ� �ٸ� ���̺� ���� �����ϴ� ���� �־�� �Ѵ�.
--  emp ���̺��� deptno �÷��� dept���̺��� deptno �÷��� ����(����) 
--  emp ���̺��� deptno �÷����� dept ���̺� �������� �ʴ� �μ���ȣ�� �Է� �� �� ����.
-- ex) ���� dept ���̺��� �μ���ȣ�� 10,20, 30,40 ���� ���� �� ���
--      emp ���̺� ���ο� ���� �߰� �ϸ鼭 �μ���ȣ ���� 99������ ����� ��� 
--      �� �߰��� �����Ѵ�.


--5. CHECK ���� ���� (���� üũ)
-- NOT NULL ���� ���ǵ� CHECK ���࿡ ����
-- emp ���̺� JOB �÷��� ��� �ü� �ִ� ���� 'SALESMAN', 'RRESIDENT', 'CLEARK'


--�������� ���� ���
--1. ���̺��� �����ϸ鼭 �÷��� ���
--2. ���̺��� �����ϸ鼭 �÷� ��� ���Ŀ� ������ ���������� ���
--3. ���̺� ������ ������ �߰������� ���������� �߰�


--1 �ǹ�
--CREATE TABLE (���̺�� �÷�1 �÷�Ÿ�� ��������, 
--CREATE TABLE ���̺�� �÷�2 �÷�Ÿ�� ��������,...);
        
-- 2. �ǹ�   [2.TABLE_CONSTRAINT]  

--3.  �ǹ� ALTER TABLE emp ......;


--PRIMARY KEY ���������� �÷� ������ ���� (1�� ���)
--dept�� ���̺��� �����Ͽ� dept_test ���̺��� FRIMARY KEY �������ǰ� �Բ� ����
--�� �̹���� ���̺��� key �÷��� ���� �÷��� �Ұ� , ���� �÷��� ���� ����
DESC dept; 

CREATE TABLE dept_test(
        deptno NUMBER(2) PRIMARY KEY,
        dname VARCHAR2(14),
        LOC VARCHAR2(13)
);


INSERT INTO dept_test (deptno) VALUES (99); --���������� ����
INSERT INTO dept_test (deptno) VALUES (99); --�Ʊ��Է��ؼ� �ߺ��Ǵ� ���� �־� ������ ����


--�������, �츮�� ���ݱ��� ������ ����� dept ���̺��� deptno �÷�����
-- UNIQUE �����̳� PRIMARY KEY ���� ������ ������ ������
-- �Ʒ� �ΰ��� INSERT ������ ���������� ����ȴ�.
INSERT INTO dept (deptno) VALUES (99);
INSERT INTO dept (deptno) VALUES (99);


--�������� Ȯ�� ���
-- 1. TOOL�� ���� Ȯ�� 
--     Ȯ���ϰ��� �ϴ� ���̺��� ����

-- 2. dictionary(�ý��� ������ ����)�� ���� Ȯ�� (USER_TABLES)

SELECT *
  FROM USER_CONSTRAINTS           --  1. ��ȸ�غ���
  WHERE table_name = 'DEPT_TEST'; -- 2. Ư�� ������ ������ ����

-- SELECT *
-- FROM USER_CONS_COLUMNS
-- WHERE CONSTRAINT_NAME = 'SYS_C007165';

-- 3. �𵨸� (ex : exerd)���� Ȯ��


--�������� ���� ������� ���� ��� ����Ŭ���� �������� �̸��� ���Ƿ� �ο� (ex :SYS_C005043)
--�������� �������� ������ ��� ��Ģ�����ϰ� �����ϴ°� ����, � ������ ����

--FRIMARY KEY �������� : PK_���̺��

--FOREIGN KEY �������� : FK_������̺��_�������̺��

DROP TABLE dept_test;


--�÷� ������ ���������� �����ϸ鼭 �������� �̸��� �ο�
-- CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY)

CREATE TABLE dept_test(
        deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY,
        dname VARCHAR2(14),
        LOC VARCHAR2(13));

INSERT INTO dept_test (deptno) VALUES(99);

--ORA-00001: unique constraint (DLWHDDN2004.SYS_C007165) violated
--ORA-00001: unique constraint (DLWHDDN2004.PK_DEPT_TEST) violated

--2. ���̺� ������ �÷� ������� ������ �������� ���
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2),
        dname VARCHAR2(14),
        LOC VARCHAR2(13),
        
        CONSTRAINT PK_dept_test PRIMARY KEY (deptno));



--NOT NULL �������� �����ϱ�
--1. �÷��� ����ϱ� (o)
-- �� �÷��� ����ϸ鼭 �������� �̸��� �ο��ϴ°� �Ұ�!
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2),
        dname VARCHAR2(14) NOT NULL,
        LOC VARCHAR2(13),
        
        CONSTRAINT PK_dept_test PRIMARY KEY (deptno));

--NOT NULL �������� Ȯ��
INSERT INTO dept_test (deptno, dname) values (99,NULL);

--ORA-01400: cannot insert NULL into ("DLWHDDN2004"."DEPT_TEST"."DNAME")



--2 ���̺� ������ �÷� ��� ���Ŀ� ���� ���� �߰�
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2),
        dname VARCHAR2(14),
        LOC VARCHAR2(13),
        
        CONSTRAINT NN_dept_test_dname CHECK (deptno IS NOT NULL));

--�Ʒ��� 
CREATE TABLE dept_test(
        deptno NUMBER(2),
        dname VARCHAR2(14)  CONSTRAINT NN_dept_test_dname CHECK (danme IS NOT NULL),
        LOC VARCHAR2(13));
        
        
--NUIQUE ���� : �ش� �÷��� �ߺ��Ǵ� ���� ������ ���� ����, �� NULL �� �Է��� �����ϴ�.
--PRIMARY KEY : UNIQUE + NOT NULL;

--1.���̺� ������ �÷� ���� UNIQUE ��������
--dname �÷��� unique ��������
DROP TABLE dept_test;
CREATE TABLE dept_test(
        deptno NUMBER(2) CONSTRAINT Pk_dept_test PRIMARY KEY , 
        dname VARCHAR2(14)  UNIQUE,
        LOC VARCHAR2(13));
        
        
-- dept_test ���̺��� dname �÷��� ������ unique ���������� Ȯ��
INSERT INTO dept_test VALUES (98,'ddit','daejeon');
INSERT INTO dept_test VALUES (98,'ddit','daejeon');



--2. ���̺� ������ �÷��� ������� ��� , �������� �̸� �ο�

DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2) CONSTRAINT  pk_dept_test PRIMARY KEY , 
        dname VARCHAR2(14)  CONSTRAINT UK_dept_test_dname unique,
        LOC VARCHAR2(13));
        
        
-- dept_test ���̺��� dname �÷��� ������ unique ���������� Ȯ��
INSERT INTO dept_test VALUES (98,'ddit','daejeon');
INSERT INTO dept_test VALUES (98,'ddit','daejeon');




--2.���̺� ������ �÷� ��� ���� �������� ���� - ���� �÷�(deptno-dname) (unique���� �ɱ�)
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    LOC VARCHAR2(13),

        CONSTRAINT UNIQUE_dept_test_deptno_dname UNIQUE(deptno, dname));


--���� �÷��� ���� unique ���� Ȯ�� (deptno, dname);
INSERT INTO dept_test VALUES (99, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
INSERT INTO dept_test VALUES (98, 'ddit','daejeon');
--ORA-00001: unique constraint (DLWHDDN2004.UNIQUE_DEPT_TEST_DEPTNO_DNAME) violated
--����ũ �������� ����


--FOREIGN KEY ��������
----�����ϴ� ���̺��� �÷��� �����ϴ� ���� ������� ���̺��� �÷��� �Է� �� �� �ֵ��� ����
--ex : emp ���̺��� deptno �÷��� ���� �Է��� ��,dept���̺��� deptno �÷��� �����ϴ� �μ�
--    ��ȣ�� �Է��� �� �ֵ��� ����
--    �������� �ʴ� �μ���ȣ�� emp ���̺��� ����������ϰԲ� ����;

--1. dept_test ���̺� ����
--2. emp_test ���̺� ����
--    emp.test ���̺� ������ deptno �÷����� dept.deptno �÷��� �����ϵ��� FK�� ����

DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY(deptno));
    
    
DROP TABLE emp_test;

DESC emp;
    
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno),
    
    CONSTRAINT PK_EMP_TEST PRIMARY KEY(empno));


--������ �Է¼���
--emp_test ���̺� �����͸� �Է��ϴ°� �����Ѱ�?
--    ���ݻ�Ȳ(dept_test, emp_test ���̺��� ��� ���� -> �����Ͱ� �������� ���� ��)
INSERT INTO emp_test VALUES (9999, 'brown', NULL); --FK�� ������ Į���� NULL�� ���
INSERT INTO emp_test VALUES (9999, 'brown', 10); -- 10���μ��� dept_test ���̺� �������� �ʾƼ� ����

--dept_test ���̺� �����͸� �غ�
INSERT INTO dept_test VALUES (99,'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9998,'sally', 10); --10�� �μ��� dept_test�� �������� �����Ƿ� ����
INSERT INTO emp_test VALUES (9998,'sally', 99); --99�� �μ��� dept_test�� ���������� ���� ����


--���̺� ������ �÷� ��� ���� �������� ����
DROP TABLE dept_test; --������ �� emp�� �����ϰ� �־ �׷��� emp�� ���� ����ؾ���
DROP TABLE emp_test;

CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY(deptno));
    
INSERT INTO dept_test VALUES (99, 'ddit', 'daejeon');

CREATE TABLE emp_TEST(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno));
    
INSERT INTO emp_test VALUES(9999,'brown',10); --dept_test ���̺� 10�� �μ��� �������� �ʾ� ����
INSERT INTO emp_test VALUES(9999,'brown',99); --dept_test ���̺� 99���μ��� �����ϹǷ� ���� ����

--constraint �������� �̸� / foreign key(������ Į����) / references ���̺�� (������ ���̺��÷���)


