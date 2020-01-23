--1
SELECT *
FROM lprod;

--2
SELECT buyer_id, buyer_name
FROM buyer;

--3
SELECT *
FROM cart;

SELECT mem_id,mem_pass, mem_name
FROM member;

--users ���̺� ��ȸ
SELECT *
FROM users;

--���̺� � �÷��� �ִ��� Ȯ���ϴ� ���

-- 1. SELECT *
-- 2. TOOL �� ��� (�����-TABLES)
-- 3. DESC ���̺�� (DESC- DESCRIBE)

DESC users;

SELECT *
FROM users;

-- users ���̺��� userid usernm, reg_dt �÷��� ��ȸ�ϴ� sql �ۼ�
SELECT userid, usernm, reg_dt, reg_dt +5 AS reg_dt_after_5day 
--��Ī�� ������ AS�� �־ ������ ���� ����
-- sernm -> sernm good or sernm as good �̷������� ��Ī ������ ���� and ��Ī�� ������ ������ ����
FROM users;

-- ��¥ ���� (reg_dt �÷��� date������ ���� �� �ִ� Ÿ��)
-- ��¥ �÷� + (���ϱ� ����) 
-- �������� ��Ģ������ �ƴѰ͵� (5+5)
-- String h = "hello";
-- String w = "world";
-- String hw = h+w; -- �ڹٿ����� �� ���ڿ��� ����
-- SQL���� ���ǵ� ��¥ ���� : ��¥ + ���� = ��¥���� ������ ���ڷ� ����Ͽ� ���� ��¥
-- EX) 2019/01/28 + 5 = 2019/02/02
--reg_dt : ������� �÷�
-- null : ���� �𸣴� ����
-- null�� ���� ���� ����� �׻� null

SELECT prod_id, prod_name 
FROM prod;

SELECT Lprod_gu as gu, lprod_nm as nm
from lprod;

SELECT buyer_id as ���̾���̵�, buyer_name as �̸�
from buyer;

--���ڿ� ����
-- �ڹ� ���� ���ڿ� ���� : + ("hello" + "world")
-- SQL������ :  ||   ('Hello' || 'world')
-- sql������ : concat(' hello' , 'world')
-- userid, sernm �÷��� ����, ��Ī id_name

SELECT userid || usernm as id_name
FROM users;

SELECT userid || usernm id_name, --���ϵ� ��Ī �Լ�
CONCAT(userid, usernm)
FROM users;

--sql������ ������ ����(�÷��� ����� ��Ȱ, but ls/sql ���� ����)
--sql ���� ���ڿ� ����� �̱� �����̼����� ����
--"Hello, World" --> 'Hello, World'

--���ڿ� ����� �÷����� ���� 
-- user id : brown
-- user id : cony

SELECT 'userid : '|| userid as userid 
FROM users;

SELECT 'SELECT * FROM ' || table_name || ';' AS QUERY
FROM user_tables;

-- || --> CONCAT ���� �̿��Ѵٸ�?
SELECT CONCAT(CONCAT('SELECT * FROM ', table_name),';') as query
FROM user_tables;

--int a = 5; //�Ҵ�, ���� ������
--if  a== 5) (a�� ���� 5���� ��)
--sql������ ������ �����̾���(pl/sql)
--sql = --> equal

--user�� ���̺��� ��� �࿡ ���ؼ� ��ȸ
--uiser���� 5���� �����Ͱ� ����
SELECT *
FROM users;

--where �� : ���̺��� �����͸� ��ȸ�� �� ���ǿ� �´� �ุ ��ȸ
-- ex : userid �÷��� ���� brown �� �ุ ��ȸ�� �Ҷ�
--brown, 'brown' �����ϱ�
--�Ϲ������� �÷��� ���ڿ� ����� �����ϱ�
SElECT *
FROM users
where userid = 'brown';

--userid �� brown�� �ƴ� �ุ ��ȸ
-- ������ : =, �ٸ��� : !=, <>
SELECT *
FROM users
where userid != 'brown';

--emp ���̺� �����ϴ� �÷��� Ȯ�� �غ�����
SELECT *
FROM EMP;

--emp ���̺��� ename �÷� ���� JONES�� �ุ ��ȸ
-- * SQL KEY WORD�� ��ҹ��ڸ� ������ ������
-- �÷��� ���̳� , ���ڿ� ����� ��ҹ��ڸ� ������.
-- 'JONES' , 'Jones'�� ���� �ٸ� ���
SELECT *
FROM emp
where ename = 'JONES';

SELECT *
FROM emp;
DESC emp;

--emp ���̺��� deptno (�μ���ȣ)�� 30���� ũ�ų� ���� ����鸸 ��ȸ
SELECT *
FROM emp
where deptno >='30';

--���ڿ� : ' ���ڿ�'
--���� : 50
--��¥ : �Լ��� ���ڿ��� �����Ͽ� ǥ��
-- ���ڿ������� ������ �����ϳ� ���� X -> why? �������� ��¥ ǥ�� ����� �ٸ��� ����


--�Ի����ڰ� 1980�� 12�� 17�� ��������ȸ
SELECT *
FROM EMP
WHERE hiredate = '1980.12.17';

--TO_DATE = ���ڿ��� data Ÿ������ �����ϴ� �Լ�
--TO_DATE(��¥���� ���ڿ�, ù��° ������ ����) ù��° ���ڶ� �� ���ڿ��� ������ ���ִ°�

SELECT *
FROM EMP
WHERE hiredate = TO_DATE('1980/12/17','YYYY/MM/DD');

-- ��������
-- sal �÷��� ���� 1000���� 2000 ������ ���
-- sal >=1000, sal <=2000 �̸� �μ���ȣ�� 30�� ���
SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000;


--���������ڸ� �ε�ȣ ��ſ� BETWEEN AND �����ڷ� ��ü

SELECT *
FROM emp
WHERE sql BETWEEN 1000 AND 2000;

--�����L��

SELECT ename, hiredate
FROM emp
where HIREDATE BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('19830101','YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE haredate <= '1983.01.01' AND haredate >= '1982.01.01';

SELECT *
FROM users
where userid IN ('brown', 'cony', 'sally');

SELECT mem_id, mem_name
FROM member
where mem_name LIKE '��%';
