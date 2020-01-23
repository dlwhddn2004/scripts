--where ���� ����ϴ� ���ǿ� ������ ��ȸ ����� ������ ��ġ�� �ʴ´�
--SQL�� ������ ���������� �ִ�.
--���� : Ű�� 185cm �̻��̰� �����԰� 70kg �̻��� ������� ����
--���� X : �߻��� ����� ���� (��Ȯ��������)
-- ������ Ư¡ : ���տ��� ������ ����.
-- {1, 5, 10 } --> {10, 5 ,1 } �� ������ ���� �����ϴ�.
-- �� ���̺��� ������ ������� ����
--SELECT ����� ������ �ٸ����� ���� �����ϸ� ����

SELECT ename, hiredate
FROM emp
WHERE hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD') AND 
hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate <= '1983.01.01' AND hiredate >= '1982.01.01';


-- IN ������
-- Ư�� ���տ� ���ԵǴ��� ���θ� Ȯ��
---- �μ���ȣ�� 10�� Ȥ��(OR) 20���� ���ϴ� ���� ��ȸ
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10, 20);

--IN �����ڸ� ������� �ʰ� OR ������ ���
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 
OR    deptno = 20;

--emp ���̺��� ����̸��� SMITH, JONES �� ������ ��ȸ (empno, ename, deptno)
SELECT empno, ename, deptno
FROM emp
WHERE ename IN ('SMITH','JONES');

--�������� 3��
--uwers ���̺��� userid �� brwon, cony, saaly �� ���̺� IN
SELECT userid as ���̵� , usernm as �̸�, alias as ����
FROM users
WHERE userid IN('brown','cony','sally');

--���ڿ� ��Ī ������ : LIKE, %, ...
--������ ������ ������ ���ڿ� ��ġ�� ���ؼ� �ٷ��
--�̸��� ER�� �����ϴ� ����� ��ȸ
--�̸��� R ���ڿ��� ���� ����� ��ȸ


--��� �̸��� S�� �����ϴ� ��� ��ȸ 
-- %�� ������ � ���ڿ�[�ѱ���, ���� ��������, ���� ���ڿ��� �ü��� �ִ�]
SELECT *
FROM emp
WHERE ename LIKE 'S%';


--���ڼ��� ������ ���� ��Ī
--   _ -> ��Ȯ�� �ѹ���
--���� �̸��� S�� �����ϰ� �̸��� ��ü ���̰� 5������ ����
--S____
SELECT *
FROM emp
WHERE ename LIKE 'S____';

--��� �̸��� S ���ڰ� ���� ��� ��ȸ
-- ename LIKE '%s%' (�յڿ� ����ڰ� �͵� �������)
SELECT *
FROM emp
WHERE ename LIKE '%S%';

--�������� where 4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE'��%';
--�������� where 5 
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';


--null �� ���� (IS) 
--comm �÷��� ���� null�� �����͸� ��ȸ (where comm = null)
-- null �� ������ where comm = null �� �ƴ϶� where comm IS null �̶�� ǥ�� 
SELECT *
FROM emp
WHERE comm IS null;

--��������6

SELECT *
FROM emp
WHERE comm IS not null;

SELECT *
FROM emp
WHERE comm >=0;

-- ����� �����ڰ� 7698, 7839 �׸��� null�� �ƴ� ������ ��ȸ
-- NOT IN �����ڿ����� NULL ���� ���� ��Ű�� �ȵȴ�.
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839, null); -- ���� �ȳ���

-->

SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839) AND mgr IS NOT null;


--���� ���� 7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND HIREDATE >= TO_DATE('1981/06/01','YYYY/MM/DD');

--���� ���� 8
SELECT *
FROM emp
WHERE DEPTNO != 10 AND HIREDATE >= TO_DATE('1981/06/01','YYYY/MM/DD');

--���� ���� 9
SELECT *
FROM emp
WHERE DEPTNO NOT IN(10) AND HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD');

--���� ���� 10
SELECT *
FROM emp
WHERE DEPTNO IN(20,30) AND HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD');

--���� ���� 11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD'); 

--���� ���� 12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR EMPNO LIKE '78%';

-- ���� ���� 13
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR EMPNO >= 7800 and EMPNO <7900;


-- ������ �켱����
-- *, / �����ڰ� +, - ���� �켱������ ����
--���� �켱���� ���� : ()�� �̿��Ѵ�
-- AND > OR 

--emp���̺��� ��� �̸��� ALLEN �̸鼭 �������� SALESMAN�� ��� �̰ų�
--             ��� �̸��� SMITH �� ��� ��ȸ
SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR (ename = 'ALLEN' AND job ='SALESMAN');

--��� �̸��� SMITH �̰ų� ALLEN �̸鼭 �������� SALESMAN�� ��� ��ȸ
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename ='ALLEN') AND job ='SALESMAN';

--�������� where 14
SELECT *
FROM emp
WHERE job ='SALESMAN' OR EMPNO LIKE'78%' AND HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD');


--����
-- SELECT +
-- FROM table
-- [WHERE]
-- ORDER BY �÷� or ��Ī or �÷� �ε��� {ASC  | DESC], ....} , ASC�� ���� DESC ��������

-- emp ���̺��� ��� ����� ename �÷� ���� �������� ���� ���� ������ ����� ��ȸ�ϼ���.

SELECT *
FROM emp
ORDER BY ename ASC;

SELECT *
FROM emp
ORDER BY ename DESC;

--DESC emp; -- DESC : DESCRIBE (�����ϴ�)
--ORDER BY ename DESC -- DESC : DESCENDING (����)


-- emp ���̺��� ��� ������ ename �÷����� ��������, ename ���� ���� ��� mgr �÷����� ��������

SELECT *
FROM emp
ORDER BY ename DESC, mgr;


--���Ľ� ��Ī�� ���
SELECT empno, ename as nm ,sal*12 as year_sal--sal �����ε� �������� ��ȯ��Ų�� ��Ī���� �ٲ��ֱ�
FROM emp
ORDER BY year_sal;


--�÷� �ε����� ����
-- java array[0]    : �ڹٴ� 0���� ~
-- SQL COLUNM INDEX : 1���� ����
SELECT empno, ename nm ,sal*12 year_sal 
FROM emp
ORDER BY 3;


--�������� order by 1
SELECT *
FROM dept
ORDER BY DNAME;

SELECT *
FROM dept
ORDER BY LOC DESC;

-- �������� ORDER BY 2

SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno; 


SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0
ORDER BY comm DESC, empno;

--�������� ORDER BY 3
SELECT *
FROM emp
WHERE MGR IS NOT NULL
ORDER BY job , empno desc;


