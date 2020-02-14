--MERGE : SELECT 하고나서 데이터가 조회되면 UPDATE
--      : SELECT 하고나서 데이터가 조회되면 INSERT
--      
--    SELECT + UPDATE / SELECT + INSERT ==> MERGE

--REPORT GROUP FUNCTION
--1. ROLLUP
--  GROUP BY ROLLUP (컬럼1,컬럼2)
--  ROLLUP절에 기술한 컬럼을 오른쪽에서 하나씩 제거한 컬럼을 SUBGROUP
--   GROUP BY 컬럼1,컬럼2
--   UNION
--   GROUP BY 컬럼1
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
--order by 정렬할때 컬럼1,컬럼2,컬럼3 있을때 컬럼1 
--에서 컬럼2 넘어갈때 컬럼1과 컬럼2과 연동되게(컬럼1이 정렬된채로 함께 컬럼2 정렬 이런느낌)

SELECT b.dname, a.job , a.sal
FROM 
(SELECT deptno, job , SUM(sal) sal
FROM emp
GROUP BY ROLLUP (deptno,job))a, dept b
WHERE a.deptno = b.deptno(+); --아우터조인 INSI로 해보자
--연습문제
SELECT 
case 
WHEN GROUPING(d.dname)= 1 AND GROUPING(e.job)= 1 THEN '총합' else d.dname END dname 
, e.job, SUM(e.sal) sal
FROM emp e, dept d
WHERE e.deptno = d.deptno  
GROUP BY ROLLUP (d.dname,e.job);

--GROUPING SETS의 경우 컬럼 기술 순서가 결과에 영향을 미치지 않는다
--ROLLUP은 컬럼 기술 순서가결과 영향을 미친다.
--순서와 관계없이 서브 그룹을 사용자가 직접 선언
--사용방법 : GROUP BY GROUPING SET (col1, col2......)

--서브그룹 생성 과 합해지는거
--GROUP BY GROUPING SETS(col1, col2)
--==>
--GROUP BY col1
--UNION ALL
--GROUP BY col2

--GROUP BY GROUPING SETS( (col1,col2) , col3,col4) GROUPING은 안에 컬럼들끼리 묵어줘서 하나의 subgroup으로 묶기가능
--==>
--GROUP BY  col1,col2
--UNION ALL
--GROUP BY col3
--UNION ALL
--GROUP BY col4

--GROUP BY GROUPING SETS ( (col1,col2) , col3,col4) ==
--GROUP BY GROUPING SETS ( col3 , (col1,col2),col4) 순서와 상관없이 subgroup을 생성하니까 같다 (합집합 개념)

SELECT job, deptno , SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS(job, deptno);

--GROUP BY GROUPING SETS(job, deptno);
--      ==>
--(GROUP BY JOB) UNION (GROUP BY deptno)


--job,deptno 로 GROUP BY 한 결과와 
--mgr로 GROUP BY 한 결과를 조회하는 SQL을 GROUPING sets로 급여 합SUM(sal)작성
SELECT job,deptno,mgr, SUM(sal) sal
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr);

-------------------------
--CUBE
--가능한 모든조합으로 컬럼을 조합한 SUB GROUP 을 생성한다.
--단 기술한 컬럼의 순서는 지킨다.
--ex : GROUP BY CUBE(col1,col2);
--(col1,col2) ==> 

--(null,col2) == GROUP BY col2
--(null,null) == GROUP BY 전체!
--(col1,null) == GROUP BY col1
--(col1,col2) == GROUP BY col2  총 4가지

--만약 컬럼3개를 CUBE절에 기술한 경우 나올수 있는 가지수 는??
--8개 (비트 단위로 하기때문에 제곱승나온당~) 4개는 16~

SELECT job, deptno , sum(sal) sal
FROM emp
GROUP BY CUBE(job, deptno);

--혼종 과제 엑셀로 색칠해보기
SELECT job, deptno , sum(sal) sal
FROM emp
GROUP BY job,rollup(deptno),CUBE(mgr); --job은 기본값이다

--group by job, deptno, mgr == GROUP BY job,deptno,mgr
--group by job, deptno == GROUP BY job,deptno
--group by job, null, mgr == GROUP BY job,mgr
--group by job, null, null == GROUP BY job

----------------------
--서브쿼리 UPDATE
--1.emp_test 테이블 drop
--2. emp 테이블을 이용해서 emp_test 테이블 생성 (모든 행에 ctas)
--3.emp_test 테이블에 dnmae VARCHER2(14)컬럼 추가
--4 emp_test.dname 컬럼을 dept 테이블을 이용해서 부서명을 업데이트;

--1
drop table emp_test; 

CREATE table emp_test AS --2

SELECT *
FROM emp;
ALTER TABLE emp_test ADD (dname VARCHAR2(14)); --3

SELECT *
FROM emp_test;
--4(상호 연관쿼리)
UPDATE emp_test SET dname= (SELECT dname  
                            FROM dept
                            WHERE dept.deptno = emp_test.deptno);
SELECT *
FROM emp_test;

commit;

--sub a1 실습
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

--sub a2 실습
--dept_test테이블에 있는 부서중에 직원이 속하지 않는 부서 정보를 삭제
--dept_test.empcnt 컬럼을 사용하지 않고 emp 테이블을 이용하여 삭제
INSERT INTO dept_test VALUES (99,'it1','daejeon',0);
INSERT INTO dept_test VALUES (98,'it2','daejeon',0);
commit;

--직원이 있다 없다 판단
--직원이 10번부서에 직업 있다 없다?
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
--with 절 
--하나의 쿼리에서 반복되는 SUBQUERY가 있을 때
--해당 SUBQUERY를 별도로 선언하여 재사용

--main 쿼리가 실행 될때 WITH 선언한 쿼리 블럭이 메모리에 임시적으로 저장
--==> MAIN 쿼리가 종료 되면 메모리 해제

--SUBQUERY 작성시에는 해당 SUBQUERY의 결과를 조회하기 위해서 I/O 반복적으로 일어나지만

--WITH 절을 통해 선언하면은 한번 SUBQUERY가 실행되고 그 결과를 메모리에 저장해 놓고 재사용

--단, 하나의 쿼리에서 동일한 SUBQUERY가 반복적으로 나오는거는 잘못 작성한 SQL일 확률이 높음

--  WITH 쿼리블록이름 AS ( 
--            서브쿼리
--                    )

--SELECT *
--FROM 쿼리블록이름;


--EX)직원의 부서별 급여 평균을 조회하는 쿼리블록을 WITH절을 통해 선언
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

-----WITH 절을 이용한 테스트 테이블 작성
with temp AS (
    SELECT sysdate -1 FROM dual UNION ALL
    SELECT sysdate -2 FROM dual UNION ALL
    SELECT sysdate -3 FROM dual)
SELECT *
FROM temp;

------------------------------------------------
--계층쿼리

--달력만들기
CONNECT BY LEVEL <[=] 정수
해당 테이블의 행을 정수 만큼 복제하고, 복제된 행을 구별하기 위해 LEVEL을 부여
LEVEL은 1부터 시작;

SELECT dummy, LEVEL
FROM dual
CONNECT BY LEVEL <=10;

SELECT dept.*, LEVEL
FROm dept
CONNECT BY LEVEL <=5;

--2020sus 2월의 달력을 생성
--:dt = 202002, 202003
1.
SELECT SYSDATE, LEVEL
FROM dual
CONNECT BY LEVEL <= :dt; --dt바인드 변수
달력
일 월 화 수 목 금 토

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


--일 월 화 수 목 금 토
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
