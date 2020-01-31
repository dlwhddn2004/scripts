SELECT ename, deptno
FROM emp;

SELECT *
FROM dept;

--JOIN �� ���̺��� �����ϴ� �۾� NULL ������ ���� �ȵ�
--JOIN ����
-- 1. ANSI ����
-- 2. ORACLE ����

--Natural Join
--�� ���̺� �÷����� ���� �� �ش� �÷����� ����(����)
--emp, dept ���̺��� deptno ��� �÷��� ����


SELECT *
FROM emp NATURAL JOIN dept;

SELECT emp.empno , emp.ename , dept.dname
FROM  emp NATURAL JOIN dept;

-- Natural join�� ���� ���� �÷�(deptno)�� ������(ex : ���̺��, ���̺� ��Ī)�� ������� �ʰ�
--�÷��� ����Ѵ� (dept.deptno --> deptno)
SELECT emp.empno , emp.ename , dept.dname, deptno
FROM  emp NATURAL JOIN dept;

--���̺� ���� ��Ī�� ��밡��
SELECT  e.empno , e.ename , d.dname, deptno
FROM emp e NATURAL JOIN dept d;


--ORACLE JOIN
--FROM ���� ������ ���̺� ����� ,�� �����Ͽ� �����Ѵ�.
--������ ���̺��� ���������� WHERER���� ����Ѵ�.
--emp, dept ���̺� �����ϴ� deptno �÷��� [������] ����
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.ename, dept.dname -- emp.ename �� 14 dept.dname 4�� 1���� 1���� �����̹Ƿ� 14 x 3
FROM emp, dept
WHERE emp.deptno != dept.deptno;


--����Ŭ ������ ���̺� ��Ī

SELECT e.empno , e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI : Join with using
--�����Ϸ��� �ΰ��� ���̺� �̸��� ���� �÷��� �ΰ����� 
--�ϳ��� �÷����θ� ������ �ϰ��� �Ҷ� 
--�����Ϸ��� ���� �÷��� ���
-- emp, dept ���̺��� ���� �÷� : deptno

SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

--JOIN WITH using�� ORACLE�� ǥ���ϸ�?
SELECT emp.ename, dept.dname, dept.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- ���� �Ϸ��� �ϴ� ���̺��� �÷� �̸��� ���� �ٸ���
SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept on (emp.deptno = dept.deptno);


--JOIN with on --> oracle �� ǥ���Ѵٸ�
SELECT emp.ename, dept.dname, emp.deptno
FROM emp , dept
WHERE emp.deptno = dept.deptno;


--SELF JOIN : ���� ���̺��� ����;
--emp ���̺��� �����Ǵ� ����� ������ ����� �̿��Ͽ� 
--������ �̸��� ��ȸ�Ҷ�

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno); --����� �Ŵ��� �ڵ� �� �Ŵ����� empno��ȣ

-- SELF JOIN �� ����Ŭ �������� �Ѵٸ�?
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--equal ���� : = (�÷��� ������)
--non-equal ���� : !=, > , <, BETWEEN AND

--����� �޿� ������ �޿� ��� ���̺��� �̿��Ͽ� �ػ� ����� �޿� ����� ���غ���
SELECT ename , sal 
FROM emp;

SELECT *
FROM salgrade;

SELECT ename, sal , s.grade
FROM  emp e, salgrade s
WHERE  e.sal BETWEEN s.losal AND s.hisal; -- emp �� sal ���� salgrade��  losal ~ hisal ���Ͽ� salgrade�� ����� ��Ÿ����

--ANSI ������ �̿��Ͽ� ���� ���� ���� �ۼ�;
SELECT ename, sal , s.grade
FROM emp e JOIN salgrade s ON(e.sal BETWEEN s.losal AND s.hisal);

--join �ǽ� 0.0

SELECT *
FROM emp;

SELECT *
FROM dept;


SELECT e.empno, e.ename, d.deptno ,d.dname
FROM emp e, dept d
WHERE e.deptno = d. deptno
ORDER BY deptno;
--���� �ǽ� 0.1
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno IN (10,30);

--���� �ǽ� 0.2


SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500
ORDER BY sal desc;

SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e JOIN dept d using(deptno)
WHERE e.sal > 2500;

--���� �ǽ� 0.3 
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500 AND e.empno> 7600;

--���� �ǽ� 0.4
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
             AND e.sal > 2500 
             AND e.empno> 7600 
             AND d.dname = 'RESEARCH';

--���νǽ� 1
--PROD : PROD_LGU
--LPROD : LPROD_GU
SELECT *
FROM prod;

select *
FROM lprod;
--ex�� 
SELECT p.prod_LGU , lp.LPROD_NM , p.PROD_ID, p.PROD_NAME
FROM prod p , lprod lp
WHERE p.prod_LGU = lp.lprod_GU;
    
--���� �ǽ� 2
SELECT b.buyer_id, b.buyer_name,p.prod_id, p.PROD_NAME
FROM prod p, buyer b
WHERE p.prod_buyer =b.buyer_id;  

--���� 3�� ����
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name,c.cart_qty
FROM member m, cart c, prod p
WHERE m.mem_id = c.cart_member and c.cart_prod = p.prod_id;

