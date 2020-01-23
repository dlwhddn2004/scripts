--1
SELECT *
FROM lprod;

--2
SELECT buyer_id, buyer_name
FROM buyer;

--3
SELECT *
FROM cart;

SELECT mem_id,mem_pass, mem_name
FROM member;

--users 테이블 조회
SELECT *
FROM users;

--테이블에 어떤 컬럼이 있는지 확인하는 방법

-- 1. SELECT *
-- 2. TOOL 의 기능 (사용자-TABLES)
-- 3. DESC 테이블명 (DESC- DESCRIBE)

DESC users;

SELECT *
FROM users;

-- users 테이블에서 userid usernm, reg_dt 컬럼만 조회하는 sql 작성
SELECT userid, usernm, reg_dt, reg_dt +5 AS reg_dt_after_5day 
--별칭을 지을때 AS를 넣어도 되지만 생략 가능
-- sernm -> sernm good or sernm as good 이런식으로 별칭 넣을수 있음 and 별칭엔 공백을 넣을수 없다
FROM users;

-- 날짜 연산 (reg_dt 컬럼은 date정보를 담을 수 있는 타입)
-- 날짜 컬럼 + (더하기 연산) 
-- 수학적인 사칙연산이 아닌것들 (5+5)
-- String h = "hello";
-- String w = "world";
-- String hw = h+w; -- 자바에서는 두 문자열을 결합
-- SQL에서 정의된 날짜 연산 : 날짜 + 정수 = 날짜에서 정수를 일자로 취급하여 더한 날짜
-- EX) 2019/01/28 + 5 = 2019/02/02
--reg_dt : 등록일자 컬럼
-- null : 값을 모르는 상태
-- null에 대한 연산 결과는 항상 null

SELECT prod_id, prod_name 
FROM prod;

SELECT Lprod_gu as gu, lprod_nm as nm
from lprod;

SELECT buyer_id as 바이어아이디, buyer_name as 이름
from buyer;

--문자열 결합
-- 자바 언어에서 문자열 결합 : + ("hello" + "world")
-- SQL에서는 :  ||   ('Hello' || 'world')
-- sql에서는 : concat(' hello' , 'world')
-- userid, sernm 컬럼을 결합, 별칭 id_name

SELECT userid || usernm as id_name
FROM users;

SELECT userid || usernm id_name, --콘켓도 별칭 함수
CONCAT(userid, usernm)
FROM users;

--sql에서의 변수는 없음(컬럼이 비슷한 역활, but ls/sql 변수 존재)
--sql 에서 문자열 상수는 싱글 쿼테이션으로 포현
--"Hello, World" --> 'Hello, World'

--문자열 상수와 컬럼가의 결합 
-- user id : brown
-- user id : cony

SELECT 'userid : '|| userid as userid 
FROM users;

SELECT 'SELECT * FROM ' || table_name || ';' AS QUERY
FROM user_tables;

-- || --> CONCAT 으로 이용한다면?
SELECT CONCAT(CONCAT('SELECT * FROM ', table_name),';') as query
FROM user_tables;

--int a = 5; //할당, 대입 연산자
--if  a== 5) (a의 값이 5인지 비교)
--sql에서는 대입의 개념이없다(pl/sql)
--sql = --> equal

--user의 테이블의 모든 행에 대해서 조회
--uiser에는 5건의 데이터가 존재
SELECT *
FROM users;

--where 절 : 테이블에서 데이터를 조회할 때 조건에 맞는 행만 조회
-- ex : userid 컬럼의 값이 brown 인 행만 조회를 할때
--brown, 'brown' 구분하기
--일반적으로 컬럼과 문자열 상수로 생각하기
SElECT *
FROM users
where userid = 'brown';

--userid 가 brown이 아닌 행만 조회
-- 같을떄 : =, 다를떄 : !=, <>
SELECT *
FROM users
where userid != 'brown';

--emp 테이블에 존재하는 컬럼을 확인 해보세요
SELECT *
FROM EMP;

--emp 테이블에서 ename 컬럼 값이 JONES인 행만 조회
-- * SQL KEY WORD는 대소문자를 가리지 않지만
-- 컬럼의 값이나 , 문자열 상수는 대소문자를 가린다.
-- 'JONES' , 'Jones'는 값이 다른 상수
SELECT *
FROM emp
where ename = 'JONES';

SELECT *
FROM emp;
DESC emp;

--emp 테이블에서 deptno (부서번호)가 30보다 크거나 같은 사원들만 조회
SELECT *
FROM emp
where deptno >='30';

--문자열 : ' 문자열'
--숫자 : 50
--날짜 : 함수와 문자열을 결합하여 표현
-- 문자열만으로 포현을 가능하나 권장 X -> why? 국가별로 날짜 표기 방법이 다르기 때문


--입사일자가 1980년 12월 17일 직원만조회
SELECT *
FROM EMP
WHERE hiredate = '1980.12.17';

--TO_DATE = 문자열을 data 타입으로 변경하는 함수
--TO_DATE(날짜형식 문자열, 첫번째 인자의 형식) 첫번째 인자란 앞 문자열의 형식을 써주는거

SELECT *
FROM EMP
WHERE hiredate = TO_DATE('1980/12/17','YYYY/MM/DD');

-- 범위연산
-- sal 컬럼의 값이 1000에서 2000 사이인 사람
-- sal >=1000, sal <=2000 이며 부서번호가 30인 사람
SELECT *
FROM emp
WHERE sal >= 1000 AND sal <= 2000;


--범위연산자를 부등호 대신에 BETWEEN AND 연산자로 대체

SELECT *
FROM emp
WHERE sql BETWEEN 1000 AND 2000;

--연습묹제

SELECT ename, hiredate
FROM emp
where HIREDATE BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('19830101','YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE haredate <= '1983.01.01' AND haredate >= '1982.01.01';

SELECT *
FROM users
where userid IN ('brown', 'cony', 'sally');

SELECT mem_id, mem_name
FROM member
where mem_name LIKE '신%';
