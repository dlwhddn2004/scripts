--where 절에 기술하는 조건에 순서는 조회 결과에 영향을 미치지 않는다
--SQL은 집합의 개념을갖고 있다.
--집합 : 키가 185cm 이상이고 몸무게가 70kg 이상인 사람들의 모임
--집합 X : 잘생긴 사람의 모임 (명확하지않음)
-- 집합의 특징 : 집합에는 순서가 없다.
-- {1, 5, 10 } --> {10, 5 ,1 } 두 집합은 서로 동일하다.
-- 즉 테이블에는 순서가 보장되지 않음
--SELECT 결과가 순서가 다르더라도 값이 동일하면 정답

SELECT ename, hiredate
FROM emp
WHERE hiredate <= TO_DATE('1983/01/01', 'YYYY/MM/DD') AND 
hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate <= '1983.01.01' AND hiredate >= '1982.01.01';


-- IN 연산자
-- 특성 집합에 포함되는지 여부를 확인
---- 부서번호가 10번 혹은(OR) 20번에 속하는 직원 조회
SELECT empno, ename, deptno
FROM emp
WHERE deptno IN(10, 20);

--IN 연산자를 사용하지 않고 OR 연산자 사용
SELECT empno, ename, deptno
FROM emp
WHERE deptno = 10 
OR    deptno = 20;

--emp 테이블에서 사원이름이 SMITH, JONES 인 직원만 조회 (empno, ename, deptno)
SELECT empno, ename, deptno
FROM emp
WHERE ename IN ('SMITH','JONES');

--연습문제 3번
--uwers 테이블에서 userid 가 brwon, cony, saaly 인 테이블 IN
SELECT userid as 아이디 , usernm as 이름, alias as 별명
FROM users
WHERE userid IN('brown','cony','sally');

--문자열 매칭 연산자 : LIKE, %, ...
--위에서 연습한 조건은 문자열 일치에 대해서 다뤘다
--이름이 ER로 시작하는 사람만 조회
--이름에 R 문자열이 들어가는 사람만 조회


--사원 이름이 S로 시작하는 사원 조회 
-- %의 개념은 어떤 문자열[한글자, 글자 없을수도, 여러 문자열이 올수도 있다]
SELECT *
FROM emp
WHERE ename LIKE 'S%';


--글자수를 제한한 매턴 매칭
--   _ -> 정확히 한문자
--직원 이름이 S로 시작하고 이름의 전체 길이가 5글자인 직원
--S____
SELECT *
FROM emp
WHERE ename LIKE 'S____';

--사원 이름에 S 글자가 들어가는 사원 조회
-- ename LIKE '%s%' (앞뒤에 어떤글자가 와도 상관없음)
SELECT *
FROM emp
WHERE ename LIKE '%S%';

--연습문제 where 4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE'신%';
--연습문제 where 5 
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';


--null 비교 연산 (IS) 
--comm 컬럼의 값이 null인 데이터를 조회 (where comm = null)
-- null 비교 연산은 where comm = null 이 아니라 where comm IS null 이라고 표시 
SELECT *
FROM emp
WHERE comm IS null;

--연습문제6

SELECT *
FROM emp
WHERE comm IS not null;

SELECT *
FROM emp
WHERE comm >=0;

-- 사원의 관리자가 7698, 7839 그리고 null이 아닌 직원만 조회
-- NOT IN 연산자에서는 NULL 값을 포함 시키면 안된다.
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839, null); -- 값이 안나옴

-->

SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839) AND mgr IS NOT null;


--연습 문제 7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND HIREDATE >= TO_DATE('1981/06/01','YYYY/MM/DD');

--연습 문제 8
SELECT *
FROM emp
WHERE DEPTNO != 10 AND HIREDATE >= TO_DATE('1981/06/01','YYYY/MM/DD');

--연습 문제 9
SELECT *
FROM emp
WHERE DEPTNO NOT IN(10) AND HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD');

--연습 문제 10
SELECT *
FROM emp
WHERE DEPTNO IN(20,30) AND HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD');

--연습 문제 11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD'); 

--연습 문제 12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR EMPNO LIKE '78%';

-- 연습 문제 13
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR EMPNO >= 7800 and EMPNO <7900;


-- 연산자 우선순위
-- *, / 연산자가 +, - 보다 우선순위가 높다
--강조 우선순위 변경 : ()를 이용한다
-- AND > OR 

--emp테이블에서 사원 이름이 ALLEN 이면서 담당업무가 SALESMAN인 사원 이거나
--             사원 이름이 SMITH 인 사원 조회
SELECT *
FROM emp
WHERE ename = 'SMITH' 
OR (ename = 'ALLEN' AND job ='SALESMAN');

--사원 이름이 SMITH 이거나 ALLEN 이면서 담당업무가 SALESMAN인 사원 조회
SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename ='ALLEN') AND job ='SALESMAN';

--연습문제 where 14
SELECT *
FROM emp
WHERE job ='SALESMAN' OR EMPNO LIKE'78%' AND HIREDATE >=TO_DATE('1981/06/01','YYYY/MM/DD');


--정렬
-- SELECT +
-- FROM table
-- [WHERE]
-- ORDER BY 컬럼 or 별칭 or 컬럼 인덱스 {ASC  | DESC], ....} , ASC는 오름 DESC 내림차순

-- emp 테이블의 모든 사원을 ename 컬럼 값을 기준으로 오름 차순 정렬한 결과를 조회하세요.

SELECT *
FROM emp
ORDER BY ename ASC;

SELECT *
FROM emp
ORDER BY ename DESC;

--DESC emp; -- DESC : DESCRIBE (설명하다)
--ORDER BY ename DESC -- DESC : DESCENDING (내림)


-- emp 테이블에서 사원 정보를 ename 컬럼으로 내림차순, ename 값이 같을 경우 mgr 컬럼으로 오름차순

SELECT *
FROM emp
ORDER BY ename DESC, mgr;


--정렬시 별칭을 사용
SELECT empno, ename as nm ,sal*12 as year_sal--sal 월급인데 연봉으로 변환시킨후 별칭으로 바꿔주기
FROM emp
ORDER BY year_sal;


--컬럼 인덱스로 정렬
-- java array[0]    : 자바는 0부터 ~
-- SQL COLUNM INDEX : 1부터 시작
SELECT empno, ename nm ,sal*12 year_sal 
FROM emp
ORDER BY 3;


--연습문제 order by 1
SELECT *
FROM dept
ORDER BY DNAME;

SELECT *
FROM dept
ORDER BY LOC DESC;

-- 연습문제 ORDER BY 2

SELECT *
FROM emp
WHERE comm > 0
ORDER BY comm DESC, empno; 


SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0
ORDER BY comm DESC, empno;

--연습문제 ORDER BY 3
SELECT *
FROM emp
WHERE MGR IS NOT NULL
ORDER BY job , empno desc;


