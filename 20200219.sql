SELECT aa.ename, aa.sal, aa.deptno ,bb.lv
FROM
(SELECT rownum rn,ename,sal,deptno --rownum���� �ζ��κ並�ҋ� ��������� ����� �÷��� �÷������
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno,sal desc) a)aa
,
(SELECT ROWNUM rn, lv
FROM
(SELECT *
FROM
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <=14) a,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno,a.lv)b)bb
WHERE aa.rn = bb.rn;


--�м��Լ� ����
--�м��Լ���([����]) OVER ([PARTITION BY �÷�]) [ORDER BY �÷�] [WINDOWING])
--PARTITION BY �÷� : �ش� �÷��� ���� ROW ���� �ϳ��� �׷����� ���´�.
--ORDER BY �÷� : PARTITION BY�� ���� ���� �׷� ������ ORDER BY �÷����� ����

--ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS rank;

--���� ���� �м��Լ�
--RANK() : ���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ� ����ŭ ������ ������ ����
--         2���� 2���̸� 3���� ���� 4����� �ļ����� �����ȴ�.

--DENSE_RANK() :���� ���� ������ �ߺ� ������ ����, �ļ����� �ߺ����� �������� ����
--                2���� 2���̴��� �ļ����� 3����� ����.

--ROW_NUMBER() : ROWNUM�� ����, �ߺ��� ���� ������� ����

�μ���, �޿� ������ 3���� ��ŷ ���� �Լ��� ����;
SELECT ename, sal, deptno,
        RANK() OVER (deptno ORDER BY sal) as sal_rank,
        DENSE_RANK() OVER (deptno ORDER BY sal) sal_dense_rank,
        ROW_NUMBER() OVER (deptno ORDER BY sal) ROW_NUMBER_dense_rank
FROM emp;

--�ǽ� ana1 : ��� ��ü �޿� ����
�м��Լ� ���� �׷� :PARTITION BY ==> ������� ������ ��ü ��
SELECT empno,ename, sal, deptno,
     rank() OVER (ORDER BY sal desc) RANK_1,
          DENSE_RANK() OVER (ORDER BY sal desc) dense_1,
          ROW_NUMBER() OVER (ORDER BY sal desc) ROWNUMBER_1
 FROM emp;

--�ǽ� no_ana2
 SELECT e.empno,e.ename, e.deptno, a.cnt
 FROM emp e 
 
    JOIN
        (SELECT deptno, COUNT(*) cnt
         FROM emp  GROUP BY deptno)a

    ON(e.deptno = a.deptno)
ORDER BY deptno;

SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;
--����Ŭ���� ������ �м��Լ� ���� (GROUP �Լ����� �����ϴ� �Լ� ������ ����)
--SUM(�÷�)
--COUNT(*),COUNT(�÷�)
--MIN(�÷�), MAX(�÷�)
--AVG(�÷�)
no_ana2 �� �м��Լ��� ����Ͽ� �ۼ� 
�μ��� ������;
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno ) cnt
FROM emp; --�м��Լ��� �׷��Լ����� �����ϴ� �Լ��� �����Ͽ� �м��Լ� + OVER + (PARTITON BY �÷��� [ORDER BY �÷���])

--ana2 : �μ��� �޿� ��� ��ȸ
--������ȣ, �����̸� ,���� �޿�,�ҼӺμ�, �ҼӺμ��� �޿� ���( �Ҽ��� ��°�ڸ�)
SELECT empno,ename, sal,deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno), 2)
FROM emp;
--ana3 
SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno)
FROM emp;

--ana4
SELECT empno, ename, sal, deptno, MIN(sal) OVER (PARTITION BY deptno)
FROM emp;

--�޿��� �������� �����ϰ�, �޿��� ���� ���� �Ի����ڰ� ���� ����� ���� �켱������ �ǵ��� �����Ͽ�
--���� ���� ������(lead)�� sal �÷��� ���ϴ� ���� �ۼ�

SELECT empno, ename, hiredate,sal, LEAD(sal) OVER (ORDER BY sal desc, hiredate) lead_sal --lead ����
FROM emp;

--ana5
SELECT empno, ename, hiredate, sal, LAG(sal) over (ORDER BY sal desc , hiredate) d --lag ����
FROM emp;

--ana6
SELECT empno, ename,hiredate,job, sal, LAG(sal) over (PARTITION BY job ORDER BY sal desc , hiredate) lag_sal
FROM emp;


SELECT ROWNUM rn, a.*
FROM
(SELECT empno,ename,sal
FROM emp
ORDER BY sal)a;

SELECT ROWNUM rn, b.*
FROM
(SELECT empno,SUM(SAL)
FROM emp
GROUP BY empno) b; ������ ��Ÿ���ٸ�????????

SELECT SUM(sal)
FROM emp
WHERE ename IN ('SMITH','JAMES')

SELECT * 
FROM emp
WHERE 


---------------------------------------------------
--���� ���� ��� 11��
--����¡ ó��(�������� 10���� �Խñ�)
--1����¡ : 1~10
--2����¡ : 11~20
--���ε� ���� : page :pageSize

--(�߿��� ���� ����Ŭ�� ����)
SELECT *
FROM
(SELECT rownum rn, a.* --rownum�� Ư¡ �ѹ� ���� �ٷ� ǥ�� �Ұ� �ٽ��ѹ� ���������
FROM
(SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title, DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq is null --�Ǵ� seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC ) a)a
WHERE rn BETWEEN (:page-1) * :pagesize+1 AND :page * :pagesize;
--n page : rn(n-1) *pageSize + 1 ~n * pageSize

