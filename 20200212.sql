--table full <-- 오라클은 아래쿼리를 이거나
--idx1 : empno
--idx2 : job <-- 이것중 효율적인걸 쓸듯

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

select *
FROM TABLE(dbms_xplan.display);
--job은 인덱스가 있어 바로 접근 했으니 ename LIKE 'C%'는 인덱스가 없어 테이블을 일일이 확인(range)


--그렇다면 job과 ename에 논 유니크 인덱스를 부여한다면?
CREATE INDEX idx_n_emp_03 ON emp(job,ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);
--실행 결과    2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%') --정렬이 되어있으니 
--조건에 만족하는 직업이 매니저에 첫글자가 C 인 부분부터 들어간다
--filter("ENAME" LIKE 'C%') 필터가 나온이유는 앞글자C가 더 있을수 있으니 추가적으로 한번더 확인한다
                   
SELECT job, ename ,rowid
FROM emp;

--1. table full 
--2. idx1 : empno
--3. idx2 : job 
--4. idx3 : job + ename
--5. idx4 : ename + job


--확실하게 하기 위해서 3번째 인덱스를 지움
-- 4번째 인덱스가 컬럼 구성이 동일하고 순서만 다르다.

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

--인덱스를 어떤 컬럼에 부여하냐에 따라 테이블 탐색 횟수가 다르다
-------------------
--95 조인 인덱스
--emp - table full, pk_emp(empno)
-- (dept- table full,emp-tble full) 순서 생각하면 서로 바꿔줘야함
 
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
    

--ORACLE - 실시간 응답 : OLTP (ON LINE TRANSACTION PROCESSING)
--          전체 처리시간 : OLAP (ON LINE ANALYSIS PROCESSING) -복잡한 쿼리의 실행계획을 세우는데 30M~1H)
-- PLAP는 실행계획을 모든 경우의수를 계산해서 가장 유리한 시간계획을 세운다(은행, 기업)

--만약 각각의 테이블에 인덱스 5개씩 있다면 
--한 테이블에 접근 전략 : 6개
-- 36 *2

-- emp 부터 읽을까 dept 부터 읽을까?
--오라클에선 먼저 기술했다고 먼저 읽지 않음
EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno =7788;

SELECT *
FROM TABLE(dbms_xplan.display);
--4 -3 - 5 -2 - 6- 1 -0  루프는 반복문이라고보면되는데 오라클에선 만약의상황을 대비해서 루프를 써줌

--CTAS 제약조건 복사가 NOT NULL만 된다
--백업이나 , 테스트용 씀
CREATE TABLE dept_test2 AS 
SELECT *
FROM dept
WHERE 1=1; --true 논리적인 비교
--DDL INDEX 실습 1

CREATE UNIQUE INDEX idx_u_dept_test2_01 ON dept_test2 (deptno);
CREATE INDEX idx_n_dept_test2_01 ON dept_test2 (dname);
CREATE INDEX idx_n_dept_test2_02 ON dept_test2 (deptno,dname);

--IDX2
DROP INDEX idx_u_dept_test2_01;
DROP INDEX idx_n_dept_test2_01;
DROP INDEX idx_n_dept_test2_02;

--IDX 3 실습

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
-- WHERE 절에서 연산자 = 가 우선순위로 보기좋음
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

--4번
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
--sal은 중복이 안되기때문에 넌유니크로 (deptno,sal) 로 묶어줘야함
-- 첫번째에 인덱스 deptno는 중복됨으로 삭제한 후 (deptno, sal) 만 해도됨
--인덱스가 많아지면 정렬을 다시 만들어주기때문에 과부화에 크다
--인덱스한거
--| Id  | Operation                    | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------
--|   0 | SELECT STATEMENT             |                     |     1 |    87 |     2   (0)| 00:00:01 |
--|*  1 |  FILTER                      |                     |       |       |            |          |
--|   2 |   TABLE ACCESS BY INDEX ROWID| EMP_TEST03          |     1 |    87 |     2   (0)| 00:00:01 |
--|*  3 |    INDEX RANGE SCAN          | IDX_N_EMP_TEST03_01 |     1 |       |     1   (0)| 00:00:01 |
--   1 - filter(TO_NUMBER(:ST_SAL)<=TO_NUMBER(:ED_SAL))
--   3 - access("DEPTNO"=TO_NUMBER(:DEPTNO) AND "SAL">=TO_NUMBER(:ST_SAL) AND 
--              "SAL"<=TO_NUMBER(:ED_SAL))

--인덱스 안한거
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
--3번 deptno (=), empno(LIKE 직원번호%)
--4번 deptno(=), sal (BETWEEN)
--5번 deptno(=) / mgr 동반하면 유리, empno(=) [empno는 기존에 만들었으니 없애두됨]
--6번 deptno, hiredate가 인덱스 존재하면 유리
--정리해보자면
--empno
--ename
--deptno empno == empno,deptno
--deptno mgr
--deptno , hiredate
