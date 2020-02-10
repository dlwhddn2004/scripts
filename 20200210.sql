

--PRIMARY KEY �������� ������ ����Ŭ DBMS�� �ش� �÷����� unique index�� �ڵ����� �����Ѵ�.
--(***��Ȯ���� UNIQUE���࿡ ���� UNIQUE �ε����� �ڵ����� �����ȴ�
--        ( PRIMARY KEY = UNIQUE + NOT NULL )

--index : �ش� �÷����� �̸� ������ �س��� ��ü
--      ������ ���ֱ� ������ ã���� �ϴ� ���� �����ϴ��� ������ Ȯ�ΰ���

--���� index�� ���ٸ� ���ο� �����͸� �Է��� �� �ߺ��Ǵ� ���� ã�� ���ؼ� �־��� ���
--���̺��� ��� �����͸� ã�ƾ���
--������ �ε����� ������ �̹� ������ �Ǿ��ֱ� ������ �ش簪�� ���� ������ ������ �˼� �ִ�.

--(�ε����� ���� ���̺�� �� Ȯ���غ����)

--FOREIGN KEY �������ǵ� �����ϴ� ���̺� ���� �ִ����� Ȯ�� �ؾ��Ѵ�.
--�׷��� �����ϴ� �÷��� �ε����� �־������ FOREIGN KEY������ ������ �� �ִ�.

--FOREIGN KEY ������ �ɼ�
--FOREIGN KEY (���� ���Ἲ) : �����ϴ� ���̺��� �÷��� �����ϴ� ���� �Է� �ɼ� �ֵ��� ����
--ex) emp ���̺� ���ο� �����͸� �Է½� deptno �÷����� dept ���̺� �����ϴ� �μ���ȣ�� �Է� �ɼ� �ִ�.

--foreign key�� �����ʿ� ���� �����͸� ���� �� �� ������
--1 . � ���̺��� �����ϰ� �ִµ����͸� �ٷ� ������ �ȵ�

--ex) EMP.deptno ==> dept.deptno �÷��� �����ϰ� ���� ���� 
--    �μ� ���̺��� �����͸� ���� �Ҽ��� ����
--INSERT INTO DEPT_TEST VALUES (98,'ddit2', '����');
--INSERT INTO emp_test (empno,ename, deptno) VALUES (9999, 'brwon',99); 
--emp : 9999,99
--dept : 98, 99
--  ==> 98 �� �μ��� �����ϴ� emp ���̺��� �����ʹ� ����
--      99�� �μ��� �����ϴ� emp ���̺��� �����ʹ� 9999�� brown����� ����

--���࿡ ���� ������ �����ϰ� �Ǹ� ������ ���� (���� ���Ἲ ���� ����)
DELETE dept_test
WHERE deptno = 99;
-----------------------------
--emp ���̺��� �����ϴ� �����Ͱ� ���� 98�� �μ��� �����ϸ�??
DELETE dept_test
WHERE deptno =98; 
--emp ���̺��� �����ϴ� 98���� ���� ������ ���������� ���� ����


------------------------------------
--foreign key �ɼ�
-- 1. ON DELETE CASCADE : �θ� ������ ���(dept) �����ϴ� �ڽ� �����͵� ���� �����Ѵ�(emp)
-- 2. ON DELETE SET NULL : �θ� ������ ���(dept) �����ϴ� �ڽ� �������� �÷��� NULL�� ����

--EMP_TEST ���̺��� DROP �� �ɼ��� ������ ���� ���� �� ���� �׽�Ʈ;

DROP TABlE emp_test; --������ �ִ� emp_test ���̺� ����

    CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(12),
        deptno NUMBER(2),
        
        constraint PK_emp_test primary key (empno),
        constraint KF_emp_test_dept_test foreign key (deptno) 
        REFERENCES dept_test(deptno) ON DELETE CASCADE ); --�ɼ� ������ REFERENCES �������̺�(�����÷�) �ڿ� �ۼ�
        
INSERT INTO emp_test VALUES (9999,'brown',99);
COMMIT;

--EMP ���̺��� deptno �÷��� dept_test���̺��� deptno �÷��� ����(ON DELETE CASCADE)
--�ɼǿ� ���� �θ����̺�(dept_test)������ �����ϰ� �ִ� �ڽ� �����͵� ���� ������ 

DELETE dept_test
WHERE deptno = 99;
--�ɼ� �ο� ������ �� ���� deleteĿ���� ���� �߻�
--�ɼǿ� ���� �����ϴ� �ڽ����̺��� �����Ͱ� ���������� ������ �Ǿ����� SELECT Ȯ��
SELECT *
FROM EMP_TEST;

---------------------------------------------
--FK ON DELETE SET NULL �ɼ� �׽�Ʈ
--�θ����̺��� ������ ������ (DEPT_TEST) , �ڽ����̺�(EMP_TEST)���� �����ϴ� �����͸� NULL�� ������Ʈ
ROLLBACK;
SELECT *
FROM dept_test;
SELECT *
FROM emp_test;

DROP TABlE emp_test;

    CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(12),
        deptno NUMBER(2),
        
        constraint PK_emp_test primary key (empno),
        constraint KF_emp_test_dept_test foreign key (deptno) 
        REFERENCES dept_test(deptno) ON DELETE SET NULL); 
        
INSERT INTO emp_test VALUES (9999,'brown',99);
COMMIT;
--dept_test ���̺��� 99�� �μ��� �����ϰ� �Ǹ�(�θ� ���̺��� �����ϸ�)
--99�� �μ��� �����ϴ� emp_test ���̺��� 9999��(brown) �������� deptno �÷���
--FK�ɼǿ� ���� NULL�� �����Ѵ�.

DELETE dept_test
WHERE deptno = 99;

--�θ� ���̺��� ������ ������ �ڽ� ���̺��� �����Ͱ� NULL�� ����Ǿ����� Ȯ��
SELECT *
FROM EMP_TEST;

------------------------------
--CHECK �������� : �÷��� ���� ���� ������ ������ �� ���
--ex : �޿� �÷��� ���ڷ� ���� , �޿��� ������ �� �� ������?
--        �Ϲ����� ��� �޿��� >0
--        CHECK ������ ����� ��� �޿����� 0���� ū������ �˻� ����
--          EMP ���̺��� job �÷��� ���� ���� ���� 4������ ���� ����
--          'SALESMAN', 'PRESIDENT', 'ANALYST', 'MANAGER';


--���̺� ������ �÷� ����� �Բ� CHECK ���� ���� ����
--emp_test ���̺��� sal �÷��� 0���� ũ�ٴ� �������� ����
INSERT INTO DEPT_TEST VALUES (99,'DDIT', '����'); --dept ���̺� ���� ������ ���� ����
drop table emp_test ;

    CREATE TABLE emp_test(
        empno NUMBER(4),
        ename VARCHAR2(10),
        deptno NUMBER(2),
        sal NUMBER CHECK (sal>0),
        
        CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno) ,
        FOREIGN KEY (deptno) REFERENCES DEPT_test (deptno)
        );
        
    INSERT INTO emp_test values (9999, 'brown', 99, 1000);
    INSERT INTO emp_test values (9998, 'sally',99, -1000); --sal üũ���ǿ� ���� 0���� ū ���� �Է� ����
--���� ���� ORA-02290: check constraint (DLWHDDN2004.SYS_C007216) violated üũ�������� ����

----------------------------
--���ο� ���̺� ����
--���� - CREATE TABLE ���̺�� (
--    �÷�....

--���ο� ���
--    CREATE TABLE ���̺�� AS
--        SELECT ����� ���ο� ���̺�� ����
-- ���������� ���� ������ִٶ�� ����

--emp ���̺��� �̿��ؼ� �μ���ȣ�� 10���� ����鸸 ��ȸ�Ͽ� �ش� �����ͷ� emp _test2 ���̺��� ����
CREATE TABLE emp_test2 AS
SELECT *
FROM EMP
WHERE deptno IN 10;

CREATE TABLE emp_test3 AS
SELECT empno, ename, sal
FROM EMP
WHERE deptno IN 10;

SELECT *
FROM emp_test2;
--create table ���̺�� as ��
--NOT NULL ���� ���� �̿��� ���� ������ ���� �ȵ�
--���߽� ������ ��� �� �׽�Ʈ ���߿� ���δ�
---------------------------------
--TABLE ����
-- 1. �÷��߰�
-- 2. �÷� ������ ����, Ÿ�Ժ���
-- 3. �⺻�� ����
-- 4. �÷����� RENAME
-- 5. �÷��� ����
-- 6. �������� �߰�/����

--TABLE ���� 1. �÷��߰� (hp VARCHAR2 (20)
--ALTER TABLE ���̺�� ADD (�ű� �÷��� �ű� �÷� Ÿ��)
DROP TABLE EMP_TEST;

CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2),
    
    CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno),
    CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno));

--ALTER TABLE ���̺�� ADD (�ű� �÷��� �ű� �÷� Ÿ��)
ALTER TABLE emp_test ADD (hp VARCHAR2(20));
--���̺� �÷� �߰������ Ȯ���غ���
DESC emp_test; --1��° ���

select *
FROm emp_test; --2��° ��� 
------------------------------------------
--TABLE ���� 2. �÷� ������ ����, Ÿ�Ժ���
--ex) �÷� varchar2(20) -> varchar2(5)
--     ������ �����Ͱ� ���� �� ��� ���������� ������ �ȵ� Ȯ���� �ſ� ����
-- �Ϲ������� �����Ͱ� �������� �ʴ� ����, �� ���̺��� ������ ���Ŀ� �÷��� ������, Ÿ���� �߸� �� ��� �÷� ������, 
-- Ÿ���� ������
-- �����Ͱ� �Էµ� ���ķδ� Ȱ�뵵�� �ſ� ������( �Էµ� ���ķ� ������ �ø��°͸� ����

-- hp VARCHAR2(20) ==> hp VARCHAR2(30)
--ALTER TABLE ���̺�� MODIFY (���� �÷��� �ű� �÷� Ÿ��(������))
DESC emp_test;
ALTER TABLE emp_test MODIFY (hp VARCHAR(30));

--�����Ͱ� ���°�� Ÿ�� ���浵 ����
--hp VARCHAR2(20) -> hp NUMBER
ALTER TABLE emp_test MODIFY (hp NUMBER);
DESC emp_test;

-------------------------------------------
--3.�÷� �⺻�� ����
-- ALTER TABLE ���̺� �� MODIFY (�÷��� �÷�Ÿ�� DEFAULT �⺻��);
--HP NUMBER --> hp varchar2(20) DEFAULT '010' ;

ALTER TABLE emp_test MODIFY (hp VARCHAR2(20) DEFAULT '010');
desc emp_test;
--hp �÷����� ���� ���� �ʾ����� DEFAULT ������ ���� '010' ���ڿ��� �⺻������ ����ȴ�
INSERT INTO emp_test (empno, ename ,deptno) VALUES (9999, 'brown', 99);

SELECT *
FROM emp_test;
--------------------------------------
-- 4. TABLE ����� �÷� ����
-- ALTER TABLE ���̺�� RENAME COLUMN ���� �÷��� TO �ű� �÷���
--�����Ϸ��� �ϴ� �÷��� FK����, PK������ �־ ��� ����.

--hp -->hp n�� �ٲ۴ٸ�?
ALTER TABLE emp_test RENAME COLUMN hp TO hp_n;

SELECT *
FROM emp_test;
------------------------------------------

--5. ���̺� ����� �÷� ����
--ALTER TABLE ���̺�� DROP COLUMN �÷���
--emp_test���̺��� hp_n �÷� ����
ALTER TABLE emp_test DROP COLUMN hp_n;

SELECT *
FROM emp_test;

--------------------------------------------
--TABLE ���� 6.�������� �߰� / ����
-- ALTER TABLE ���̺�� ADD CONSTRAINT �������Ǹ� �������� Ÿ��(PRIMARY KEY, FOREIGN KEY) (�ش� �÷�);

--ALTER TABLE ���̺�� DROP CONSTRAINT �������� ��;
--1.emp_test ���̺� ������
--2.�������� ���� ���̺��� ����
--3. PRIMARY KEY, FOREIGN KEY, ������ ALTER TABLE ������ ���� ����
--4. �ΰ��� �������� ���� �׽�Ʈ

DROP TABLE emp_test;

CREATE TABLE emp_test (
     empno NUMBER(4),
     ename VARCHAR2(10),
     deptno NUMBER(2));
    
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno); --�߰�
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test (deptno);

--PRIMARY KEY �׽�Ʈ
INSERT INTO emp_test VALUES (9999,'brown', 99);
INSERT INTO emp_test VALUES (9999,'sally', 99); --pk �������ǿ� ���� �ߺ��ǹǷ� ����
--ORA-00001: unique constraint (DLWHDDN2004.PK_EMP_TEST) violated

--FOREING KEY �׽�Ʈ
INSERT INTO dept_test VALUES (9998,'sally',98); -- dept_test ���̺� ���������ʴ� �μ���ȣ �̸��� ����
--ORA-01438: value larger than specified precision allowed for this column

-------------------------------------------------
--�������� ���� : PRIMARY KEY , FOREIGN KEY
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test; --����
ALTER TABLE emp_test DROP CONSTRAINT fk_emp_test_dept_test;

--���������̾����Ƿ� empno �� �ߺ��� ���� �� �� �ְ� , �μ����̺� �������� �ʴ� deptno ���� ���� ����

INSERT INTO emp_test values (9999,'brown',99);
INSERT INTO emp_test values (9999,'sally',99);

--���������ʴ� 98���μ���ȣ�� ������ �Է�
INSERT INTO emp_test VALUES (9998,'sally',98); 

SELECT *
FROm emp_test;
-----------------------------------------------------------------------------
--�������� Ȱ��ȭ / ��Ȱ��ȭ
--ALTER TABLE ���̺�� ENABLE | DISABLE CONSTRAINT �������Ǹ�;

--1.emp_test ���̺� ����
--2.emp_test ���̺� ����
--3. ALTER TABLE PRIMARY KEY(empno), FOREIGN KEY (dept_test.deptno) �������� ����
--4. �ΰ��� ���������� ��Ȱ��ȭ
--5. ��Ȱ��ȭ�� �Ǿ����� INSERT�� ���� Ȯ��
--6. ���������� ������ �����Ͱ� �� ���¿��� �������� Ȱ��ȭ;

DROP TABLE emp_test;

CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2));
    
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno);

--4 �������� ��Ȱ��ȭ �ϱ�
ALTER TABLE emp_test DISABLE CONSTRAINT pk_emp_test;
ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;
INSERT INTO emp_test VALUES (9999,'brown', 99);-- pk
INSERT INTO emp_test VALUES (9999,'sally', 98);-- fk
commit;


-- �������� Ȱ��ȭ �ϱ�
SELECT *
FROM emp_test;
--emp_test ���̺��� empno �÷��� ���� 9999�� ����� �θ� �����ϱ� ������
--PRIMARY KEY ���������� Ȱ��ȭ �� ���� ����.
-- ==> empno �÷��� ���� �ߺ����� �ʵ��� �����ϰ� �������� Ȱ��ȭ �� �� �ִ�.
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test; --���� �߻�
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test; -- ���� �߻�

--�ߺ������� ����
DELETE EMP_test
WHERE ename IN 'brown';

-- �ߺ������� ���� �� primary key Ȱ��ȭ
ALTER TABLE emp_test ENABLE CONSTRAINT pk_emp_test; 

--dept_test ���̺� �������� �ʴ� �μ���ȣ 98�� emp_test���� �����
--1. dept_test ���̺� 98�� �μ��� ����ϰų�
--2. sally�� �μ���ȣ�� 99������ �����ϰų� , �����
UPDATE emp_test SET deptno =99
WHERE dname = 'sally';
ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;
commit;
--���� 
--1. emp_test ���̺��� drop�� empno, ename , deptno , hp 4���� �÷����� ���̺� ����
--2. empno, ename, deptno 3���� �÷����� (9999,'brown' ,99 )�����ͷ� INSERT
--3. emp_test ���̺��� hp �÷��� �⺻ ���� '010' ���� ����
--4. 2���������� �Է��� �������� hp �÷� ���� ��� �ٲ���� Ȯ���ϱ�