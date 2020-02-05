
-- 3���̺� ������ commA JOIN B ON () C JOIN ON (); ������ C ���� ��ȣ ���� ��� X
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty 
FROM member m Join Cart c ON(m.mem_id = c.cart_member) JOIN prod p ON( c.cart_prod = p.prod_id);



SELECT *
FROM CUSTOMER;

SELECT *
FROM PRODUCT;

SELECT *
FROM CYCLE;


--�Ǹ��� :200~250
--���� 2.5�� ��ǰ
-- �Ϸ� : 500~750
-- �Ѵ� : 15000~ 17500

SELECT *
FROM daily;

SELECT *
FROM batch;


--���� �ǽ� 4 : join�� �ϸ鼭 ROW�� �����ϴ� ������ ����;
SELECT c.cid, c.cnm, cy.pid , cy.day, cy.CNT
FROM customer c, cycle cy
WHERE c.cid = cy.cid
AND c.cnm IN('brown' , 'sally');


--���� �ǽ� 5
SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c, cycle cy ,product p
WHERE c.cid= cy.cid AND cy.pid =p.pid 
AND c.cnm IN('brown' , 'sally');



--���� �ǽ� 6 : join�� �ϸ鼭 ROW�� �����ϴ� ������ ���� , �׷��Լ� ����

SELECT c.cid, c.cnm, cy.pid, p.pnm,sum(cy.cnt)
FROM customer c, cycle cy ,product p
WHERE c.cid= cy.cid AND cy.pid =p.pid
GROUP BY c.cid, c.cnm, cy.pid, p.pnm;

--���� �ǽ� 7

SELECT cy.pid, p.pnm, sum(cy.cnt)
FROM product p , cycle cy
WHERE cy.pid =p.pid
GROUP BY cy.pid, p.pnm; 
--join ����


--�ش� ����Ŭ ������ ��ϵ� �����(����) ��ȸ;
SELECT *
FROm dba_users;

--HR ������ ��й�ȣ�� JAVA�� �ʱ�ȭ
ALTER USER HR IDENTIFIED BY java;

ALTER USER HR ACCOUNT UNLOCK;


--OUTER JOIN
-- �� ���̺��� �����Ҷ� ���� ������ ���� ��Ű�� ���ϴ� �����͸�
--�������� ������ ���̺��� �����͸��̶� ��ȸ �ǰԲ� �ϴ� ���� ���

--�������� : e.mgr = m.empno --> KING�� mgr null �̱� ������ ���ο� �����Ѵ�
--emp ���̺��� �����ʹ� �� 14�������� �Ʒ��� ���� ���������� ����� 13���� �ȴ�(1�� ���ν���)
SELECT e.empno, e.ename, e.mgr , m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;


--ANSI OUTER
--1. ���ο� �����ϴ��� ��ȸ�� �� ���̺��� ����(�Ŵ��� ������ ��� ��������� �����Բ�)
SELECT  e.empno, e.ename, e.mgr , m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr =m.empno; --������ ����

SELECT  e.empno, e.ename, e.mgr , m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr =m.empno; --�������� ����
--�� ���̺��� ������ �߿�

--oracle outer join 
--�����Ͱ� ���� ���� ���̺� �÷� �ڿ� (+)��ȣ�� �ٿ��ش�
SELECT  e.empno, e.ename, e.mgr , m.ename
FROM emp e, emp m
WHERE e.mgr =m.empno(+);



SELECT  e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e, emp m
WHERE e.mgr =m.empno(+);
--���� sql�� �Ƚ� SQL(OUTER JOIN) ���� �����غ�����.
--���� : �Ŵ����� �μ���ȣ�� 10���� ������ ��ȸ
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr =m.empno AND m.deptno = 10; 
-- �ƿ��� �����̶� m.deptno=10 �� �ƴϿ��� ����
--�������� �����



--�ƿ��� ������ �ƴ϶� �Ϲ� �������� ��� INNER ���ΰ� ����� �����ϴ�.
--where ���� ���ϱ�?
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr =m.empno 
WHERE m.deptno=10;

SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e JOIN emp m ON e.mgr =m.empno 
WHERE m.deptno=10;


--����Ŭ OUTER JOIN
--����Ŭ OUTER JOIN �� ���� ���̺��� �ݴ��� ���̺��� ��� �÷��� (+)�� �ٿ���
--�������� OUTER JOIN���� �����Ѵ�
--�� �÷��̶� (+)�� �����ϸ� INNER �������� ����
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e , emp m
where e.mgr = m.empno(+) --�����Ͱ� ���� �÷��� (+)�� ���δ�.
AND m.deptno = 10; -- m.deptno �÷��� (+)�� �����ʾ� inner �������� ���̸� 
--mgr�� �����Ͱ� null���̿��� ǥ�õǾ��ϴµ� �����


--�� ORACLE OUTER ������ INNER �������� ���� : m.deptno �÷��� (+)�� ��������
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e , emp m
where e.mgr = m.empno(+) --�����Ͱ� ���� �÷��� (+)�� ���δ�.
AND m.deptno(+) = 10;


-- ��� - �Ŵ����� RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename, mgr
FROM emp m;

SELECT e.empno, m.ename, e.mgr
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr= m.empno);

SELECT e.empno, m.ename, e.mgr
FROM emp e , emp m
WHERE e.mgr(+) = m.empno;


--FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ� ����;
SELECT e.empno, e.ename, e.mgr , m.ename 
FROM emp e FULL OUTER JOIN emp m ON (e.mgr =m.empno);


--oracle outer join������ (+)��ȣ�� �̿��Ͽ� FULL outer ������ �������� �ʴ´�.


--outerjoin

SELECT d.buy_date, d.buy_prod, d.prod_id, n.prod_name, d.buy_qty
FROM buyprod d , buyprod n
WHERE d.buy_date(+) = n.prod_name;

--outerjoin �ǽ�1
SELECT d.buy_date,d.buy_prod, p.prod_id, p.prod_name, d.buy_qty
FROM  buyprod d ,prod p
WHERE d.buy_prod(+) = p.prod_id 
AND d.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

SELECT b.buy_date,b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--outerjoin �ǽ�2
SELECT nvl(d.buy_date,TO_DATE('05/01/25','YY/MM/DD')),d.buy_prod, p.prod_id, p.prod_name, d.buy_qty
FROM  buyprod d ,prod p
WHERE d.buy_prod(+) = p.prod_id
AND d.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin �ǽ�3

SELECT nvl(d.buy_date,TO_DATE('05/01/25','YY/MM/DD')),d.buy_prod, p.prod_id, p.prod_name, nvl(d.buy_qty,0)
FROM  buyprod d ,prod p
WHERE d.buy_prod(+) = p.prod_id
AND d.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin �ǽ� 4

SELECT c.pid, p.pnm, nvl(c.cid, 1), c.day, c.cnt
FROM cycle c , product p
WHERE c.pid(+) = p.pid
AND c.cid(+) = 1;

SELECT c.pid, p.pnm, nvl(c.cid, 1), c.day, c.cnt
FROM cycle c RIGHT OUTER JOIN product p ON(c.pid =p.pid AND c.cid=1);