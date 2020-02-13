--synonym : 동의어
--1. 객체 별칭을 부여
--==> 이름을 간단하게 표현
--
--sem 사용자가 자신의 테이블 emp 테이블을 사용해서 만든 v_emp view 
--hr사용자가 사용할 수 있게 끔 권환을 부여
--v_emp : 민감한 정보 sal, comm 를 제외한 view

--hr 사용자 v_emp를 사용하기 위해 다음과 같이 작성

SELECT *
FROM sem.v_emp;

--hr 계정에서
--synonym dlwhddn2004.v_emp ==> v_emp
--v_emp == dlwhddn2004.v_emp

SELECT *
FROM v_emp;

--1. dlwhddn2004 계정에서 v_emp를 hr 계정에서 조회할 수 있도록 조회권한 부여
GRANT SELECT ON v_emp TO hr;

--2. hr 계정 v_emp 조회하는게 가능 (권환 1번에서 받았기 때문에)
--하지만 사용시 해당 객체의 소유자를 명시 : dlwhddn2004.v_emp
--간단하게 dlwhddn2004.v_emp ==> v_emp 사용하고 싶은 상황
-- 그런상황에 synonym 생성 < 사용하는계정에서 만들어야함

--CREATE SYNONYM 시노님이름 FOR 원 객체명

--SYNONYM 삭제
--DROP SYNONYM 시노님이름; --시노님 한번 인터넷 검색 ㄱ


--DCL 
--GRANT 권환 / REVOKE 회수

--GRANT CONNECT TO dlwhddn2004;
--GRANT CONNECT ON 객체명 TO HR; 객체권환 시스템 권환

--권한 종류
--1. 시스템 권한 : TABLE을 생성, VIEW 생성 권한...
--2. 객체 권한 : 특정 객체에 대해 SELECT, UPDATE, DELETE...
--3. ROLE : 권한을 모아놓은 집합
--    사용자별로 개별 권한을 보여하게 되면 관리의 부담 
--    특정 ROLE에 권한을 부여하고 해당 ROLE 사용자에게 부여
--    해당 ROLE을 수정하게 되면 ROLE을 갖고 있는 모든 사용자에게 영향
--    
-- 권한 부여/회수
-- 시스템 권한 : GRANT 권한이름 TO 사용자 | ROLE(롤이름)
--        회수 : REVOKE 권한이름 FROM 사용자 | ROLE
-- 
-- 객체 권환 : GRANT 권한이름 ON 객체명 TO 사용자 |ROLE
--      회수 : REVOKE 권한이름 ON 객체명 FROM 사용자 | ROLE
    
--시스템에서 권한을 부여하고 회수 할때  
--user1 -> user2 권한 부여 ->user3 권한부여 user1이 회수할때는 한꺼번에 회수가 안됨 
--객체에서 권한을 부여하고 회수 할떄
--user1 -> user2 권한 부여 ->user3 권한부여 후 회수할때 user1가 줫던 권한을 user2가 하위한테 줫던 권한까지 다 회수
---------------------------------------------
--data dictionary : 사용자가 관리하지 않고 , dbms가 자체적으로 관리하는 시스템 정보를
--                    담은 view
--
--data dictionary 접두어
--1. USER : 해당 사용자가 소유한 객체
--2. ALL : 해당 사용자가 소유한 객체 + 다른 사용자로 부터 권한을 부여받은 객체
--3. DBA : 모든 사용자의 객체 (일반사용자는 볼수없음)
--
--* VS 특수 VIEW
--SELECT *
--FROM USER_TABLER -> USER 이 접두어

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES; --일반 사용자라 볼수없
--
--DICTIONARY 종류 확인 : SYS.DICTIONARY;

SELECT *
FROM DICTIONARY;

--대표적인 DICTIONARY 
--OBJECTS: 객체정보 조회 (테이블, 인덱스 , VIEW , SYNONYM....)
--TABLES : 테이블 정보만 조회
--TAB_COLUMNS : 테이블의 컬럼정보 조회
--INDEXES : 인덱스 정보 조회   실행계획할때 인덱스 정보조회 무조건 하기(속도)
--IND_COLUMNS : 인덱스 구성 컬럼 조회
--CONSTRAINTS : 제약 조건 조회
--CONS_COLUMNS : 제약조건 구성 컬럼 조회
--TAB_COMMENTS : 테이블 주석 (우리는 만들때 주석 꼭 달자)
--COL_COMMENTS : 테이블 컬럼 주석


SELECT *
FROM USER_OBJECTS; -- OBJECTS =오라클 객체정보


--emp.dept 테이블의 인덱스와 인덱스 컬럼 출력(테이블명, 인덱스 명 , 컬럼명, 컬럼순서)
--user_indexes  join user_ind_columns 

--emp ind_n_emp_04 ename
--emp ind_n_emp_04 job

SELECT table_name, index_name, column_name, column_position
FROM user_ind_columns
ORDER BY table_name, index_name, column_position;

SELECT a.table_name, a.index_name, b --추가로적어바
FROM user_indexes a, user_ind_columns b
WHERE a.index_name = b.index_name;


SELECT *
FROM user_indexes;

SELECT *
FROM user_ind_columns;

--멀티플 인설트 multiple insert

--mutiple insert = 하나의 insert 구문으로 여러 테이블에 테이터를 입력하는 DML
SELECT *
froM DEPT_TEST;

select *
from DEPT_TEST2;

--동일한 값을 여러 테이블에 동시 입력하는 멀티플 인설트
INSERT ALL
    INTO dept_test
    INTO dept_test2
SELECT 98,'대덕','중앙로' FROM dual 
UNION ALL
SELECT 97,'IT','영민' FROM dual;

--------------
--테이블에 입력할 컬럼을 지정하여 multiple insert
ROLLBACK;
INSERT ALL
    INTO dept_test (deptno, loc) VALUES(deptno, loc)
    --첫번째 dept_test 테이블에서 넣어줄 테이블 컬럼명에 값을 deptno, loc를 넣어준다는걸 말하는것
    INTO dept_test2
SELECT 98 deptno ,'대덕' dname,'중앙로' loc FROM dual 
UNION ALL
SELECT 97,'IT','영민' FROM dual;

-----------------
--테이블에 입력할 데이터를 조건에 따라 multiple insert
--case
--    when 조건 기술 then
--end;

ROLLBACK;

INSERT ALL
    WHEN deptno = 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno, loc)
        INTO dept_test2 
        --INTO는 WHEN 이나 ELSE 에 더 추가할수있 (IF처럼생각)
    ELSE
        INTO dept_test2
SELECT 98 deptno ,'대덕' dname,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민' FROM dual;

SELECT *
FROM dept_test;

select *
FROM dept_test2;
--------------------------------
--조건을 만족하는 첫번째 INSERT만 실행하는 MULTIPLE INSERT
ROLLBACK;

--first 만족하는 조건에 첫번째 녀석만 
INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test (deptno, loc) VALUES(deptno, loc)
    WHEN deptno >= 97 THEN
        INTO dept_test2
    ELSE
        INTO dept_test2
SELECT 98 deptno ,'대덕' dname,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민' FROM dual;
------------

--오라클 객체 : 테이블에 여러개의 구역을 파티션으로 구분
--파티션 : 테이블 이름동일하나 값의 종류에 따라 오라클 내부적으로 별도의 
--          분리된 영역에 데이터를 저장

--과정 dept_test == > dept_test_20200201

INSERT FIRST
    WHEN deptno >= 98 THEN
        INTO dept_test 
    WHEN deptno >= 97 THEN
        INTO dept_test_20200202
    ELSE
        INTO dept_test2
SELECT 98 deptno ,'대덕' dname,'중앙로' loc FROM dual UNION ALL
SELECT 97,'IT','영민' FROM dual;

SELECT *
FROM dept_Test;


--MERGE : 통합
--테이블에 데이터를 입력/갱신 하려고 함
--1. 내가 입력하려고 하는 데이터가 존재하면 
--    ==> 업데이트
--2. 내가 입력하려고 하는 데이터가 존재하지 않으면
--    ==> INSERT

1.SELECT 실행
2.SELECT 실행 결과가 0 ROW이면 INSERT
2-2 SELECT 실행 결과가 1 ROW이면 UPDATE;

MERGE 구문을 사용하게 되면 SELECT 를 하지 않아도 
자동으로 데이터 유무에 따라 INSERT 혹은 UPDATE 실행된다.
2번의 쿼리를 한번으로 준다.;

--MERGE INTO 테이블명 [alisas]
--USING (TABLE | VIEW | IN_LINE-VIEW)
--ON (조인조건)

--조인조건에 만족을 한다면
--WHEN MATCHED THEN 
--    UPDATE SET col = 컬럼 값, col2 = 컬럼 값..... 

--조건에 만족하지 않다면
--WHEN NOT MATCHED THEN
--    INSERT (컬럼1, 컬럼2.....) VALUES (컬럼 값1, 컬럼값2);

SELECT *
FROM emp_test;

DELETE emp_test;

--로그를 안남긴다 == 복구 X -> 테스트 용
TRUNCATE TABLE emp_test;

--emp테이블에서 emp_test테이블로 데이터를 복사 (7369-SMITH)

INSERT INTO emp_test
SELECT empno, ename, deptno , '010'
FROM emp
WHERE empno = 7369;

--데이터가 잘 입력 되었는지 확인
SELECT *
FROM emp_test;

UPDATE emp_test SET ename = 'brown'
WHERE empno = 7369;

commit;

--emp테이블의 모든 직원을 emp_test테이블로 통합하려한다면?
--emp테이블에는 존재하지만 emp_test에는 존재하지 않으면 insert
--emp테이블에는 존재하고 emp_test에도 존재하면 ename, deptno를 update

--통합할때 컬럼명이 같은게 많아서 별칭
MERGE INTO emp_test a
USING emp b 
ON (a.empno = b.empno)
    WHEN MATCHED THEN
        UPDATE SET a.ename=b.ename,
                    a.deptno=b.deptno
    WHEN NOT MATCHED THEN
        INSERT (empno, ename, deptno) VALUES (b.empno,b.ename,b.deptno);

--통합을하면 emp 테이블에 존재하는 14건의 데이터중 emp_test에도 존재하는 7369를
--제외한 13건의 데이터가 emp_test테이블에 신규로 입력이 되고
--emp_test에 존재하는 7369번의 데이터는 ename(brown)이 emp테이블에 존재하는 ename(SMITH)로 갱신

--------------------------------------------------
--해당 테이블에 데이터가 있으면 insert , 없으면 update
--emp_test테이블에 사번이 9999번인 사람이 없으면 새롭게 insert
--있으면 update 
--(9999,'brown',10,'010')
--
--INSERT INTO dept_test VALUES (9999, 'brown',10,'010')
--UPDATE dept_test SET ename='brown'
--                        deptno =10
--                        hp = '010'
--WHERE empno = 9999;

MERGE INTO emp_test
USING dual
ON (empno =9999)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_u',
        --기존이름에 새로운 이름을 추가하는데 _u라는 전미어가 있으면 업데이트
                deptno = 10,
                hp= '010'
WHEN NOT MATCHED THEN
    INSERT VALUES (9999,'brown',10,'010');
    
SELECT *
FROM emp_test;

--통합은 insert, update 2번쓰는 쿼리를 한번으로 묶어주는 장점이있음
INSERT ALL
    INTO dept_test (deptno, loc) VALUES(deptno, loc)
    --첫번째 dept_test 테이블에서 넣어줄 테이블 컬럼명에 값을 deptno, loc를 넣어준다는걸 말하는것
    INTO dept_test2
SELECT 98 deptno ,'대덕' dname,'중앙로' loc FROM dual 
UNION ALL
SELECT 97,'IT','영민' FROM dual;


SELECT deptno,SUM(sal)
FROM emp 
GROUP BY deptno
UNION
SELECT null, SUM(sal)
FROM emp;

-- I/O속도
--CPU CACHE > RAM > SSD> HDD> NETWORK

--REPORT GROUP FUNTION
ROLLUP
CUBE
GROUPING;

--ROLLUP
--    사용방법 : GROUP BY ROLLUP (컬럼1..컬럼2....)
--특징 : SUBGROUP을 자동적으로 생성    
--SUBGROUP을 생성하는 규칙 : ROLLUP에 기술한 컬럼을 !오른쪽!에서부터 하나씩 제거하면서
--                        SUB GROUP 생성
EX) GROUP BY ROLLUP (deptno)
==>
첫번째 sub group : group by deptno
두번째 sub group : group by null ==> 전체 행을 대상

--group_adi을 group by rollup 절을 사용하여 작성하라
SELECT deptno , SUM(sal)
FROM emp
GROUP BY ROLLUP (deptno);



SELECT job, deptno, SUM(sal +NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

--GROUP BY job, deptno : 담당업무, 부서별 급여합
--GROUP BY job  : 담당업무별 급여합
--GROUP BY    :전체 급여합

SELECT job, deptno,
        GROUPING(job), GROUPING(deptno),
        SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);
--grouping을 이용하면 총계를 나타낼때 
--group_ad2
SELECT 
    CASE --case문은 새로만든다고 생각하지말고 추가한다고 생각한다.
        WHEN  GROUPING(job)=1 AND GROUPING(deptno)=1
               THEN  '총계' ELSE job end job,
        deptno,
        SUM(sal+ NVL(comm,0)) sal
FROM emp    
GROUP BY ROLLUP (job, deptno);
--과제 decode로 하기
SELECT
    DECODE(GROUPING(job),1,DECODE(GROUPING(deptno),1,'총계'), job) job,
    deptno,
    SUM(sal+ NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job,deptno);
-- job 총 deptno 소계, 계 

--저 이거 1시간40분 걸렸습니다 선생님
SELECT 
    CASE
        WHEN GROUPING(job)=1 AND GROUPING(deptno)=1 THEN '총' ELSE job end JOB,
        
        CASE WHEN TO_CHAR(GROUPING(job)) = 0 THEN 
        CASE WHEN TO_CHAR(GROUPING(deptno))= 1 THEN '소계' ELSE TO_CHAR(deptno) END 
        ELSE '계' END deptno,
        SUM(sal+NVL(comm,0)) sal
    FROM emp
    GROUP BY ROLLUP(job,deptno);
    
        
            
        
        
        
