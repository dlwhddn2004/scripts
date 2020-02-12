--table full <-- ����Ŭ�� �Ʒ������� �̰ų�
--idx1 : empno
--idx2 : job <-- �̰��� ȿ�����ΰ� ����

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

select *
FROM TABLE(dbms_xplan.display);
--job�� �ε����� �־� �ٷ� ���� ������ ename LIKE 'C%'�� �ε����� ���� ���̺��� ������ Ȯ��(range)


--�׷��ٸ� job�� ename�� �� ����ũ �ε����� �ο��Ѵٸ�?
CREATE INDEX idx_n_emp_03 ON emp(job,ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);
--���� ���    2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%') --������ �Ǿ������� 
--���ǿ� �����ϴ� ������ �Ŵ����� ù���ڰ� C �� �κк��� ����
--filter("ENAME" LIKE 'C%') ���Ͱ� ���������� �ձ���C�� �� ������ ������ �߰������� �ѹ��� Ȯ���Ѵ�
                   
SELECT job, ename ,rowid
FROM emp;

--1. table full 
--2. idx1 : empno
--3. idx2 : job 
--4. idx3 : job + ename
--5. idx4 : ename + job


--Ȯ���ϰ� �ϱ� ���ؼ� 3��° �ε����� ����
-- 4��° �ε����� �÷� ������ �����ϰ� ������ �ٸ���.

DROP INDEX idx_n_emp_03;

CREATE INDEX idx_n_emp_04 ON emp (ename, job);

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job= 'MANAGER' AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

--   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
--       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')

--�ε����� � �÷��� �ο��ϳĿ� ���� ���̺� Ž�� Ƚ���� �ٸ���
-------------------
--95 ���� �ε���
--emp - table full, pk_emp(empno)
-- (dept- table full,emp-tble full) ���� �����ϸ� ���� �ٲ������
 
--dept - table full, pk_dept(deptno)
--    pk_dept(deptno , dept - table full

--(emp-tble full, dept - table full)
--    dept - table full, emp-tble full

--(emp-tble full, dept-pk_dept)
--    dept-pk_dept, emp-tble full

--(emp-pk_emp, dept-table full)
--    dept-table full, emp-pk_emp

--(emp-pk_emp, dept-pk_dept)
--    dept-pk_dept ,emp-pk_emp
    

--ORACLE - �ǽð� ���� : OLTP (ON LINE TRANSACTION PROCESSING)
--          ��ü ó���ð� : OLAP (ON LINE ANALYSIS PROCESSING) -������ ������ �����ȹ�� ����µ� 30M~1H)
-- PLAP�� �����ȹ�� ��� ����Ǽ��� ����ؼ� ���� ������ �ð���ȹ�� �����(����, ���)

--���� ������ ���̺� �ε��� 5���� �ִٸ� 
--�� ���̺� ���� ���� : 6��
-- 36 *2

-- emp ���� ������ dept ���� ������?
--����Ŭ���� ���� ����ߴٰ� ���� ���� ����
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno =7788;

SELECT *
FROM TABLE(dbms_xplan.display);
--4 -3 - 5 -2 - 6- 1 -0  ������ �ݺ����̶����Ǵµ� ����Ŭ���� �����ǻ�Ȳ�� ����ؼ� ������ ����

--CTAS �������� ���簡 NOT NULL�� �ȴ�
--����̳� , �׽�Ʈ�� ��
CREATE TABLE dept_test2 AS 
SELECT *
FROM dept
WHERE 1=1; --true ������ ��
--DDL INDEX �ǽ� 1

CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_n_dept_test2_01 ON dept_test2 (dname);
CREATE INDEX idx_n_dept_test2_02 ON dept_test2 (deptno,dname);

--IDX2
DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_n_dept_test2_01;
DROP INDEX idx_n_dept_test2_02;

--IDX 3 �ǽ�

CREATE TABLE emp_test03 AS
SELECT *
FROM emp;

CREATE UNIQUE INDEX idx_u_emp_test03_01 ON emp_test03 (deptno, empno);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test03, dept
WHERE emp_test03.deptno = dept.deptno
AND emp_test03.deptno = :deptno
AND emp_test03.empno LIKE :empno || '%';

SELECT *
FROM TABLE(dbms_xplan.display);
-- WHERE ������ ������ = �� �켱������ ��������
drop index idx_u_emp_test03_01;
--|   0 | SELECT STATEMENT             |                     |     1 |   102 |     3   (0)| 00:00:01 |
--|   1 |  NESTED LOOPS                |                     |     1 |   102 |     3   (0)| 00:00:01 |
--|   2 |   TABLE ACCESS BY INDEX ROWID| DEPT                |     1 |    15 |     1   (0)| 00:00:01 |
--|*  3 |    INDEX UNIQUE SCAN         | PK_DEPT             |     1 |       |     0   (0)| 00:00:01 |
--|   4 |   TABLE ACCESS BY INDEX ROWID| EMP_TEST03          |     1 |    87 |     2   (0)| 00:00:01 |
--|*  5 |    INDEX RANGE SCAN          | IDX_U_EMP_TEST03_01 |     1 |       |     1   (0)| 00:00:01 |
--   3 - access("DEPT"."DEPTNO"=TO_NUMBER(:DEPTNO))
--   5 - access("EMP_TEST03"."DEPTNO"=TO_NUMBER(:DEPTNO))
--       filter(TO_CHAR("EMP_TEST03"."EMPNO") LIKE :EMPNO||'%')

--4��
drop index idx_n_emp_test03_01;

CREATE INDEX idx_u_emp_test03_01 ON emp_test03(deptno);

CREATE INDEX idx_n_emp_test03_01 ON emp_test03 (deptno,sal);
EXPLAIN PLAN FOR
SELECT *
FROM emp_test03
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;

SELECT *
FROM TABLE(dbms_xplan.display);

-- 
--sal�� �ߺ��� �ȵǱ⶧���� ������ũ�� (deptno,sal) �� ���������
-- ù��°�� �ε��� deptno�� �ߺ������� ������ �� (deptno, sal) �� �ص���
--�ε����� �������� ������ �ٽ� ������ֱ⶧���� ����ȭ�� ũ��
--�ε����Ѱ�
--| Id  | Operation                    | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT             |                     |     1 |    87 |     2   (0)| 00:00:01 |
--|*  1 |  FILTER                      |                     |       |       |            |          |
--|   2 |   TABLE ACCESS BY INDEX ROWID| EMP_TEST03          |     1 |    87 |     2   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN          | IDX_N_EMP_TEST03_01 |     1 |       |     1   (0)| 00:00:01 |
--   1 - filter(TO_NUMBER(:ST_SAL)<=TO_NUMBER(:ED_SAL))
--   3 - access("DEPTNO"=TO_NUMBER(:DEPTNO) AND "SAL">=TO_NUMBER(:ST_SAL) AND 
--              "SAL"<=TO_NUMBER(:ED_SAL))

--�ε��� ���Ѱ�
--| Id  | Operation          | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
-----------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT   |            |     1 |    87 |     3   (0)| 00:00:01 |
--|*  1 |  FILTER            |            |       |       |            |          |
--|*  2 |   TABLE ACCESS FULL| EMP_TEST03 |     1 |    87 |     3   (0)| 00:00:01 |
--   1 - filter(TO_NUMBER(:ST_SAL)<=TO_NUMBER(:ED_SAL))
--   2 - filter("DEPTNO"=TO_NUMBER(:DEPTNO) AND "SAL">=TO_NUMBER(:ST_SAL) 
--              AND "SAL"<=TO_NUMBER(:ED_SAL))

---------------------------------------------

--access pattarn 
--3�� deptno (=), empno(LIKE ������ȣ%)
--4�� deptno(=), sal (BETWEEN)
--5�� deptno(=) / mgr �����ϸ� ����, empno(=) [empno�� ������ ��������� ���ֵε�]
--6�� deptno, hiredate�� �ε��� �����ϸ� ����
--�����غ��ڸ�
--empno
--ename
--deptno empno == empno,deptno
--deptno mgr
--deptno , hiredate
