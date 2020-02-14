--MERGE : SELECT �ϰ��� �����Ͱ� ��ȸ�Ǹ� UPDATE
--      : SELECT �ϰ��� �����Ͱ� ��ȸ�Ǹ� INSERT
--      
--    SELECT + UPDATE / SELECT + INSERT ==> MERGE

--REPORT GROUP FUNCTION
--1. ROLLUP
--  GROUP BY ROLLUP (�÷�1,�÷�2)
--  ROLLUP���� ����� �÷��� �����ʿ��� �ϳ��� ������ �÷��� SUBGROUP
--   GROUP BY �÷�1,�÷�2
--   UNION
--   GROUP BY �÷�1
--   UNION
--   GROUP BY

--2. CUBE
--3.GROUPING SETS

SELECT deptno,job, SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno,job);

SELECT d.dname, e.job , SUM(e.sal) sal
FROM emp e , dept d
WHERE e.deptno = d.deptno
GROUP BY ROLLUP (d.dname,e.job)
ORDER BY d.dname, e.job desc; 
--order by �����Ҷ� �÷�1,�÷�2,�÷�3 ������ �÷�1 
--���� �÷�2 �Ѿ�� �÷�1�� �÷�2�� �����ǰ�(�÷�1�� ���ĵ�ä�� �Բ� �÷�2 ���� �̷�����)

SELECT b.dname, a.job , a.sal
FROM 
(SELECT deptno, job , SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno,job))a, dept b
WHERE a.deptno = b.deptno(+); --�ƿ������� INSI�� �غ���
--��������
SELECT 
case 
WHEN GROUPING(d.dname)= 1 AND GROUPING(e.job)= 1 THEN '����' else d.dname END dname 
, e.job, SUM(e.sal) sal
FROM emp e, dept d
WHERE e.deptno = d.deptno  
GROUP BY ROLLUP (d.dname,e.job);

--GROUPING SETS�� ��� �÷� ��� ������ ����� ������ ��ġ�� �ʴ´�
--ROLLUP�� �÷� ��� ��������� ������ ��ģ��.
--������ ������� ���� �׷��� ����ڰ� ���� ����
--����� : GROUP BY GROUPING SET (col1, col2......)

--����׷� ���� �� �������°�
--GROUP BY GROUPING SETS(col1, col2)
--==>
--GROUP BY col1
--UNION ALL
--GROUP BY col2

--GROUP BY GROUPING SETS( (col1,col2) , col3,col4) GROUPING�� �ȿ� �÷��鳢�� �����༭ �ϳ��� subgroup���� ���Ⱑ��
--==>
--GROUP BY  col1,col2
--UNION ALL
--GROUP BY col3
--UNION ALL
--GROUP BY col4

--GROUP BY GROUPING SETS ( (col1,col2) , col3,col4) ==
--GROUP BY GROUPING SETS ( col3 , (col1,col2),col4) ������ ������� subgroup�� �����ϴϱ� ���� (������ ����)

SELECT job, deptno , SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, deptno);

--GROUP BY GROUPING SETS(job, deptno);
--      ==>
--(GROUP BY JOB) UNION (GROUP BY deptno)


--job,deptno �� GROUP BY �� ����� 
--mgr�� GROUP BY �� ����� ��ȸ�ϴ� SQL�� GROUPING sets�� �޿� ��SUM(sal)�ۼ�
SELECT job,deptno,mgr, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr);

-------------------------
--CUBE
--������ ����������� �÷��� ������ SUB GROUP �� �����Ѵ�.
--�� ����� �÷��� ������ ��Ų��.
--ex : GROUP BY CUBE(col1,col2);
--(col1,col2) ==> 

--(null,col2) == GROUP BY col2
--(null,null) == GROUP BY ��ü!
--(col1,null) == GROUP BY col1
--(col1,col2) == GROUP BY col2  �� 4����

--���� �÷�3���� CUBE���� ����� ��� ���ü� �ִ� ������ ��??
--8�� (��Ʈ ������ �ϱ⶧���� �����³��´�~) 4���� 16~

SELECT job, deptno , sum(sal) sal
FROM emp
GROUP BY CUBE(job, deptno);

--ȥ�� ���� ������ ��ĥ�غ���
SELECT job, deptno , sum(sal) sal
FROM emp
GROUP BY job,rollup(deptno),CUBE(mgr); --job�� �⺻���̴�

--group by job, deptno, mgr == GROUP BY job,deptno,mgr
--group by job, deptno == GROUP BY job,deptno
--group by job, null, mgr == GROUP BY job,mgr
--group by job, null, null == GROUP BY job

----------------------
--�������� UPDATE
--1.emp_test ���̺� drop
--2. emp ���̺��� �̿��ؼ� emp_test ���̺� ���� (��� �࿡ ctas)
--3.emp_test ���̺� dnmae VARCHER2(14)�÷� �߰�
--4 emp_test.dname �÷��� dept ���̺��� �̿��ؼ� �μ����� ������Ʈ;

--1
drop table emp_test; 

CREATE table emp_test AS --2

SELECT *
FROM emp;
ALTER TABLE emp_test ADD (dname VARCHAR2(14)); --3

SELECT *
FROM emp_test;
--4(��ȣ ��������)
UPDATE emp_test SET dname= (SELECT dname  
                            FROM dept
                            WHERE dept.deptno = emp_test.deptno);
SELECT *
FROM emp_test;

commit;

--sub a1 �ǽ�
drop table dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);

update dept_test SET empcnt =(SELECT count(*)
                            FROM  emp
                            WHERE deptno= dept_test.deptno
                            group by deptno);
SELECT deptno, count(*)
FROM emp
GROUP by deptno;

SELECT *
FROM dept_test;

update dept_test SET empcnt =NVL((SELECT count(*)
                            FROM  emp
                            WHERE deptno= dept_test.deptno
                            group by deptno),0);

--sub a2 �ǽ�
--dept_test���̺� �ִ� �μ��߿� ������ ������ �ʴ� �μ� ������ ����
--dept_test.empcnt �÷��� ������� �ʰ� emp ���̺��� �̿��Ͽ� ����
INSERT INTO dept_test VALUES (99,'it1','daejeon',0);
INSERT INTO dept_test VALUES (98,'it2','daejeon',0);
commit;

--������ �ִ� ���� �Ǵ�
--������ 10���μ��� ���� �ִ� ����?
SELECT count(*)
FROM emp_test
WHERE deptno = 30;

SELECT *
FROM dept_test
WHERE 0 = (SELECT count(*)
            FROM emp_test
            WHERE deptno = dept_test.deptno);
 
 DELETE dept_test
WHERE 0 = (SELECT count(*)
            FROM emp_test
            WHERE deptno = dept_test.deptno);
            
--sub_ a3

SELECT *
FROM emp_test;

UPDATE emp_test a SET sal = sal+ 200
WHERE sal < (SELECT AVG(sal)
            FROM emp_test b
            WHERE a.deptno = b.deptno);
            
----------------------------------------------
--with �� 
--�ϳ��� �������� �ݺ��Ǵ� SUBQUERY�� ���� ��
--�ش� SUBQUERY�� ������ �����Ͽ� ����

--main ������ ���� �ɶ� WITH ������ ���� ���� �޸𸮿� �ӽ������� ����
--==> MAIN ������ ���� �Ǹ� �޸� ����

--SUBQUERY �ۼ��ÿ��� �ش� SUBQUERY�� ����� ��ȸ�ϱ� ���ؼ� I/O �ݺ������� �Ͼ����

--WITH ���� ���� �����ϸ��� �ѹ� SUBQUERY�� ����ǰ� �� ����� �޸𸮿� ������ ���� ����

--��, �ϳ��� �������� ������ SUBQUERY�� �ݺ������� �����°Ŵ� �߸� �ۼ��� SQL�� Ȯ���� ����

--  WITH ��������̸� AS ( 
--            ��������
--                    )

--SELECT *
--FROM ��������̸�;


--EX)������ �μ��� �޿� ����� ��ȸ�ϴ� ��������� WITH���� ���� ����
WITH sal_avg_dept AS (
    SELECT deptno, ROUND(AVG(sal),2) sal
    FROM emp
    GROUP BY deptno
)

SELECT *
FROM sal_avg_dept;



WITH sal_avg_dept AS (
    SELECT deptno, ROUND(AVG(sal),2) sal
    FROM emp
    GROUP BY deptno
)
,
 dept_empcnt AS (
SELECT deptno , count(*) empcnt
FROm emp
GROUP BY deptno)

SELECT *
FROM sal_avg_dept a, dept_empcnt b
WHERE a.deptno = b.deptno;

-----WITH ���� �̿��� �׽�Ʈ ���̺� �ۼ�
with temp AS (
    SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL
    SELECT sysdate -3 FROM dual)
SELECT *
FROM temp;

------------------------------------------------
--��������

--�޷¸����
CONNECT BY LEVEL <[=] ����
�ش� ���̺��� ���� ���� ��ŭ �����ϰ�, ������ ���� �����ϱ� ���� LEVEL�� �ο�
LEVEL�� 1���� ����;

SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <=10;

SELECT dept.*, LEVEL
FROm dept
CONNECT BY LEVEL <=5;

--2020sus 2���� �޷��� ����
--:dt = 202002, 202003
1.
SELECT SYSDATE, LEVEL
FROM dual
CONNECT BY LEVEL <= :dt; --dt���ε� ����
�޷�
�� �� ȭ �� �� �� ��

SELECT SYSDATE + LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE ('202002','YYYYMM')), 'DD');

SELECT TO_DATE('202002','YYYYMM')+ (LEVEL-1)
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE ('202002','YYYYMM')), 'DD');


SELECT LAST_DAY(ADD_MONTHS(TO_DATE('202002','YYYYMM'),-1)) + LEVEL
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE ('202002','YYYYMM')), 'DD');


SELECT TO_CHAR(LAST_DAY(TO_DATE ('202002','YYYYMM')), 'DD')
FROm dual;


--�� �� ȭ �� �� �� ��
SELECT TO_DATE('202002','YYYYMM')+ (LEVEL-1),
        TO_CHAR(TO_DATE('202002','YYYYMM')+ (LEVEL-1), 'D'),
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                1, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) s,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                2, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) m,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                3, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) t,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                4, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) w,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                5, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) t2,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                6, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) f,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                7, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) s2
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE ('202002','YYYYMM')), 'DD');
