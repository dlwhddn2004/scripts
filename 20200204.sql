--CORSS JOIN --> 카티션 프로덕트(Cartesian product)
--조인하는 두 테이블의 연결 조건이 누락되는 경우
-- 가능한 모든 조합에 대해 연결(조인)이 시도
-- ex) dept (4건) , emp(14)의 CORSS JOIN 의 결과는 4 * 14 = 56건
-- SELECT FROM A CROSS JOIN B (INSI조인)


--dept 테이블과 emp 테이블을 조인을 하기 위해 FROM 절에 두개의 테이블을 기술
--WHERE 절에 두 테이블의 연결 조건을 누락
SELECT dept.dname, emp.empno, emp.ename
FROM dept, emp
WHERE dept.deptno=10 
AND dept.deptno = emp.deptno;

SELECT *
FROM emp;
--CROSSJOIN 1 조인 실습
SELECT *
FROM customer CROSS JOIN product 
ORDER BY customer.cid;

--SUBQUERY :쿼리안에 다른 쿼리가 들어가 있는 경우
--SUBQUERY가 사용된 위치에 따라 3가지로 분류  
-- 1 SELECT 절 : SCALAR SUBQUERY (값이 하나) : 하나의 행, 하나의 컬럼만 리턴해야 에러가 발생하지 않음
-- 2 FROM절    : INLINE -VIEW (VIEW)
-- 3 WHERE절   : SUBQUERY QUERY


-- EX)SMITH가 속한 부서에 속하는 직원들의 정보를 조회
-- 1. SMITH가 속하는 부서 번호를 구한다.
-- 2. 1번에서 구한 부서 번호에 속하는 직원들 정보를 조회한다.
--(1)
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

--(2)
SELECT *
FROM emp
WHERE deptno = 20;

--subquery를 이용하면 두개의 쿼리를 동시에 하나의 SQL로 실행이 가능
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
             
--다중행 연산자
--IN 서브 쿼리에 여러행중 일치하는 값이 존재 할 때
--ANY [활용도 다소 떨어짐] : 서브쿼리의 여러행중 한 행이라도 조건을 만족할 때
--ALL [활용도 다소 떨어짐] :서브쿼리의 여러행중 모든 행에 대해 조건을 만족 할 때
 
--SMITH가 속하는 부서의 모든 직원을 조회 
--SMITH와 WARD 직원이 속하는 부서의 모든 직원을 조회
--서브 쿼리의 결과가 여러 행일 때는 = 연산자를 사용하지 못한다.
SELECT *
FROM EMP
    WHERE deptno IN (SELECT deptno
                     FROM emp
                     WHERE ename IN ('SMITH','WARD'));

--SMITH, WARD 사원의 급여보다 급여가 작은 직원(SMITH, WARD의 급여중 아무거나)
--SMITH : 800, WARD : 1250 --> 1250보다 작은 사원

SELECT sal
FROM emp
WHERE ename in ('SMITH', 'WARD');

SELECT *
FROM emp
WHERE sal < ANY(800, 1250); -- 800 ,1250 중 아무거나

SELECT *
FROM emp
WHERE sal < ANY (SELECT sal
            FROM emp
            WHERE ename IN ('SMITH', 'WARD'));

-- SMITH, WARD 사원의 급여보다 급여가 높은 직원을 모두 조회 (2가지 모두에 해당)

SELECT *
FROM emp
WHERE sal > ALL(SELECT sal
                 FROM emp
                 WHERE ename IN ('SMITH', 'WARD'));

--IN, NOT, IN의 NULL과 관련된 유의 사항

--직원의 관리자 사번이 7566 이거나(OR) NULL
--IN 연산자는 OR 연산자로 치환 가능
SELECT *
FROM emp
WHERE mgr IN (7902, NULL);
--NULL비교는 =연산자가 아니라 IS NULL로 비교해야하지만
--IN연산자는 =로 계산한다 -->  = OR  / IS NULL
SELECT *
FROM emp
WHERE mgr= 7902 OR mgr IS NULL;

--EMPN0 NOT IN(7902, NULL) ==> AND
--사원번호가 7902가 아니면서(AND) NULL이 아닌 데이터

SELECT *
FROM emp
WHERE mgr NOT IN (7902, NULL); --데이터 안나옴

SELECT *
FROM emp
WHERE empno != 7902 AND empno != NULL; --데이터 안나옴

SELECT *
FROM emp
WHERE empno != 7902 AND empno IS NOT NULL;
-----------------------

SELECT mgr, deptno
FROM emp
WHERE empno IN (7499, 7782);

--pairwise (순서쌍)
--순서쌍의 결과를 동시에 만족시킬때
--(7698,30) (7839,10)
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                    FROM emp
                    WHERE empno IN (7499, 7782));
                    
                    
--non pairewise는 순서쌍을 동시에 만족시키지 않는 형태로 작성
--mgr 값이 7698이거나 7839 이면서
--deptno 가 10 이거나 30번인 직원
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
                    

                    
--스칼라 서브쿼리 : SELECT 절에 기술, 1개의 row 1개의 col을 조회하는 쿼리
--스칼라 서브쿼리는 MAIN 쿼리의 컬럼을 사용하는게 가능하다.
SELECT (SELECT SYSDATE
        FROM dual), dept.*
FROM dept;
                    
SELECT empno, ename, deptno,
        (SELECT dname 
         FROM dept
         WHERE deptno = emp.deptno) dname
FROM emp;

--INLINE VIEW : FROM 절에 기술되는 서브쿼리

--MAIN 쿼리의 컬럼을 SUBQUERY 에서 사용하는지 유무에 따른 분류
--사용 할경우 : correlated SUBQUERY(상호 연관 쿼리=>메인-서브 연관됨), 서브쿼리만 단독으로 실행 불가
--                실행 순서가 정해져 있다 . (main ==> sub)
--사용 하지 않을 경우 : non correlated subquery(비상호 연관 서브쿼리), 서브쿼리만 단독으로 실행하는게 가능
--                 실행순서가 정해져 있지 않다( main -->sub, sub -->main)
--모든 직원의 급여 평균보다 급여가 높은 사람을 조회
--비상호 연관성 쿼리
SELECT *
FROM emp
WHERE sal >(SELECT avg(sal)
             FROM emp);
             
--직원이 속한 부서의 급여 평균보다 급여가 높은 사람을 조회
--상호 연관성 쿼리
SELECT *
FROM emp m
WHERE sal> 
    (SELECT avg(sal)
    FROM emp s
    WHERE s.deptno =m.deptno);

--1. 조인테이블 선정
--      emp, 부서별 급여 평균(inline view)
SELECT emp.ename, sal, emp.deptno, dept_sal.*
FROM emp,(SELECT deptno, ROUND(avg(sal)) avg_sal 
           FROM emp 
           GROUP BY deptno) dept_sal
WHERE emp.deptno = dept_sal.deptno
AND emp.sal > dept_sal.avg_sal;


--서브쿼리 실습 sub4 (데이터 추가)
INSERT INTO dept VALUES (99,'ddit', 'daejeon');
ROLLBACK; --트랜잭션 취소
COMMIT; -- 트랜잭션 확정

SELECT *
FROM dept
WHERE deptno NOT IN(select deptno
                     FROM emp);
                     
                    
















