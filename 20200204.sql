--CORSS JOIN --> īƼ�� ���δ�Ʈ(Cartesian product)
--�����ϴ� �� ���̺��� ���� ������ �����Ǵ� ���
-- ������ ��� ���տ� ���� ����(����)�� �õ�
-- ex) dept (4��) , emp(14)�� CORSS JOIN �� ����� 4 * 14 = 56��
-- SELECT FROM A CROSS JOIN B (INSI����)


--dept ���̺�� emp ���̺��� ������ �ϱ� ���� FROM ���� �ΰ��� ���̺��� ���
--WHERE ���� �� ���̺��� ���� ������ ����
SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno=10 
AND dept.deptno = emp.deptno;

SELECT *
FROM emp;
--CROSSJOIN 1 ���� �ǽ�
SELECT *
FROM customer CROSS JOIN product 
ORDER BY customer.cid;

--SUBQUERY :�����ȿ� �ٸ� ������ �� �ִ� ���
--SUBQUERY�� ���� ��ġ�� ���� 3������ �з�  
-- 1 SELECT �� : SCALAR SUBQUERY (���� �ϳ�) : �ϳ��� ��, �ϳ��� �÷��� �����ؾ� ������ �߻����� ����
-- 2 FROM��    : INLINE -VIEW (VIEW)
-- 3 WHERE��   : SUBQUERY QUERY


-- EX)SMITH�� ���� �μ��� ���ϴ� �������� ������ ��ȸ
-- 1. SMITH�� ���ϴ� �μ� ��ȣ�� ���Ѵ�.
-- 2. 1������ ���� �μ� ��ȣ�� ���ϴ� ������ ������ ��ȸ�Ѵ�.
--(1)
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--(2)
SELECT *
FROM emp
WHERE deptno = 20;

--subquery�� �̿��ϸ� �ΰ��� ������ ���ÿ� �ϳ��� SQL�� ������ ����
SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

 SELECT avg(sal)
 FROM emp;
 
 SELECT COUNT(*)
 FROM emp
 WHERE SAL > (SELECT avg(sal)
             FROM emp);

 SELECT *
 FROM emp
 WHERE SAL > (SELECT avg(sal)
             FROM emp);
             
--������ ������
--IN ���� ������ �������� ��ġ�ϴ� ���� ���� �� ��
--ANY [Ȱ�뵵 �ټ� ������] : ���������� �������� �� ���̶� ������ ������ ��
--ALL [Ȱ�뵵 �ټ� ������] :���������� �������� ��� �࿡ ���� ������ ���� �� ��
 
--SMITH�� ���ϴ� �μ��� ��� ������ ��ȸ 
--SMITH�� WARD ������ ���ϴ� �μ��� ��� ������ ��ȸ
--���� ������ ����� ���� ���� ���� = �����ڸ� ������� ���Ѵ�.
SELECT *
FROM EMP
    WHERE deptno IN (SELECT deptno
                     FROM emp
                     WHERE ename IN ('SMITH','WARD'));

--SMITH, WARD ����� �޿����� �޿��� ���� ����(SMITH, WARD�� �޿��� �ƹ��ų�)
--SMITH : 800, WARD : 1250 --> 1250���� ���� ���

SELECT sal
FROM emp
WHERE ename in ('SMITH', 'WARD');

SELECT *
FROM emp
WHERE sal < ANY(800, 1250); -- 800 ,1250 �� �ƹ��ų�

SELECT *
FROM emp
WHERE sal < ANY (SELECT sal
            FROM emp
            WHERE ename IN ('SMITH', 'WARD'));

-- SMITH, WARD ����� �޿����� �޿��� ���� ������ ��� ��ȸ (2���� ��ο� �ش�)

SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

--IN, NOT, IN�� NULL�� ���õ� ���� ����

--������ ������ ����� 7566 �̰ų�(OR) NULL
--IN �����ڴ� OR �����ڷ� ġȯ ����
SELECT *
FROM emp
WHERE mgr IN (7902, NULL);
--NULL�񱳴� =�����ڰ� �ƴ϶� IS NULL�� ���ؾ�������
--IN�����ڴ� =�� ����Ѵ� -->  = OR  / IS NULL
SELECT *
FROM emp
WHERE mgr= 7902 OR mgr IS NULL;

--EMPN0 NOT IN(7902, NULL) ==> AND
--�����ȣ�� 7902�� �ƴϸ鼭(AND) NULL�� �ƴ� ������

SELECT *
FROM emp
WHERE mgr NOT IN (7902, NULL); --������ �ȳ���

SELECT *
FROM emp
WHERE empno != 7902 AND empno != NULL; --������ �ȳ���

SELECT *
FROM emp
WHERE empno != 7902 AND empno IS NOT NULL;
-----------------------

SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

--pairwise (������)
--�������� ����� ���ÿ� ������ų��
--(7698,30) (7839,10)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                    FROM emp
                    WHERE empno IN (7499, 7782));
                    
                    
--non pairewise�� �������� ���ÿ� ������Ű�� �ʴ� ���·� �ۼ�
--mgr ���� 7698�̰ų� 7839 �̸鼭
--deptno �� 10 �̰ų� 30���� ����
--mgr, deptno
--(7698,10) (7698,30)
--(7839,10) (7839,30)
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                    FROM emp
                    WHERE empno IN (7499, 7782))
    AND deptno IN (SELECT deptno
                    FROM emp 
                    where empno IN (7499,7782));
                    

                    
--��Į�� �������� : SELECT ���� ���, 1���� row 1���� col�� ��ȸ�ϴ� ����
--��Į�� ���������� MAIN ������ �÷��� ����ϴ°� �����ϴ�.
SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;
                    
SELECT empno, ename, deptno,
        (SELECT dname 
         FROM dept
         WHERE deptno = emp.deptno) dname
FROM emp;

--INLINE VIEW : FROM ���� ����Ǵ� ��������

--MAIN ������ �÷��� SUBQUERY ���� ����ϴ��� ������ ���� �з�
--��� �Ұ�� : correlated SUBQUERY(��ȣ ���� ����=>����-���� ������), ���������� �ܵ����� ���� �Ұ�
--                ���� ������ ������ �ִ� . (main ==> sub)
--��� ���� ���� ��� : non correlated subquery(���ȣ ���� ��������), ���������� �ܵ����� �����ϴ°� ����
--                 ��������� ������ ���� �ʴ�( main -->sub, sub -->main)
--��� ������ �޿� ��պ��� �޿��� ���� ����� ��ȸ
--���ȣ ������ ����
SELECT *
FROM emp
WHERE sal >(SELECT avg(sal)
             FROM emp);
             
--������ ���� �μ��� �޿� ��պ��� �޿��� ���� ����� ��ȸ
--��ȣ ������ ����
SELECT *
FROM emp m
WHERE sal> 
    (SELECT avg(sal)
    FROM emp s
    WHERE s.deptno =m.deptno);

--1. �������̺� ����
--      emp, �μ��� �޿� ���(inline view)
SELECT emp.ename, sal, emp.deptno, dept_sal.*
FROM emp,(SELECT deptno, ROUND(avg(sal)) avg_sal 
           FROM emp 
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;


--�������� �ǽ� sub4 (������ �߰�)
INSERT INTO dept VALUES (99,'ddit', 'daejeon');
ROLLBACK; --Ʈ����� ���
COMMIT; -- Ʈ����� Ȯ��

SELECT *
FROM dept
WHERE deptno NOT IN(select deptno
                     FROM emp);
                     
                    
















