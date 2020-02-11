--제약조건 확인 방법
--1. tool
--2. dictionary view
--제약조건 : USER_CONSTRAINTS
--제약조건 - 컬럼 : USER_CONS_COLUMNS
--제약조건이 몇개의 컬럼에 관련되어 있는지 알수 없기 때문에 테이블을 별도로 분리하며 설계
--1정규형

SELECT *
FROM USER_CONSTRAINTS
WHERE table_name IN ('EMP','DEPT','EMP_TEST','DEPT_TEST');
--
--//emp, pk, fk 제약이 존재하지않음
--emp : pk(empno)
--      fk (depno) -dept.deptno
--      kf 제약을 생성하기 위해서는 참조하는 테이블 컬럼에 인덱스가 존재해야 한다.

--dept : pk (deptno)
ALTER TABLE emp ADD CONSTRAINT PK_EMP PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT PK_DEPT PRIMARY KEY (deptno);

ALTER TABLE emp ADD CONSTRAINT FK_EMP_DEPT FOREIGN KEY (deptno) REFERENCES dept (deptno);


--테이블 컬럼 주석 : DICTIONARY 로 확인 가능
--테이블 주석 : USER_TAB_COMMENTS;
-- 컬럼 주석 : USER_COL_COMMENTS;

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

--주석생성
--테이블 주석 : COMMENT ON TABLE 테이블명 IS '주석';
--컬럼 주석 : COMMENT ON COLUMN 테이블명.컬럼 IS '주석';

--EMP : 직원
--DEPT : 부서
---------------------테이블 주석
COMMENT ON TABLE EMP IS '직원';
COMMENT ON TABLE DEPT IS '부서';

SELECT *
FROM USER_TAB_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');


---------------------컬럼 주석
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('EMP','DEPT');

COMMENT ON COLUMN dept.deptno IS '부서번호';
COMMENT ON COLUMN dept.dname IS '부서명';
COMMENT ON COLUMN dept.loc IS '부서위치';

COMMENT ON COLUMN emp.empno IS '직원번호';
COMMENT ON COLUMN emp.ename IS '직원이름';
COMMENT ON COLUMN emp.job IS '담당업무';
COMMENT ON COLUMN emp.mgr IS '매니저 직원번호';
COMMENT ON COLUMN emp.hiredate IS '입사일자';
COMMENT ON COLUMN emp.sal IS '급여';
COMMENT ON COLUMN emp.comm IS '성과급';
COMMENT ON COLUMN emp.deptno IS '소속부서번호';
-----------------------------------------------
SELECT *
FROM user_tab_comments;
SELECT *
FROM user_col_comments;

SELECT *
FROM user_tab_comments  utc JOIN user_col_comments ucc
 ON (utc.table_name = ucc.table_name 
 AND utc.TABLE_NAME IN ('CUSTOMER','PRODUCT','CYCLE','DAILY'));
 
 --view 는 쿼리(view = query) 
 --TABLE 처럼 DBMS에 미리 작성한 객체 ==> 작성하지 않고 QUERY에서 바로 작성한 VIEW :
 --IN:-LINE VIEW (이름이 없기 떄문에 재활용이 불가) , VIEW 는 테이블이 아니다! (X)
 --view가 참조하는 테이블을 수정하면 view에도 영향을 미친다.
 
--사용목적
--1. 보안 목적 (특정 컬럼을 제외하고 나머지 결과만 개발자에 제공)
--2. INLINE-VIEW 를 VIEW로 생성하여 재활용 --> 쿼리 길이 단축

--생성방법
--CREATE [OR RELACE] VIEW 뷰명칭 [ (column1,column2...)] AS
--SUBQUERY;

--EMP 테이블에서 8개의 컬럼중 SAL, COMM컬럼을 제외한 6개 컬럼을 제공하는 V_EMP VIEW 생성
CREATE OR REPLACE VIEW v_emp as
SELECT empno,ename,job,mgr,hiredate,deptno
FROM emp;
--오류 insufficient privileges 뷰생성하는 권환이 없음


--시스템 계정에서 jongwoo 계정으로 view 생성 권환 추가
GRANT CREATE VIEW TO dlwhddn2004;


--기존 인라인 뷰로 작성시;
SELECT *
FROM (SELECT empno,ename,job,mgr,hiredate,deptno
        FROM emp);
        
--VIEW 객체 활용
SELECT *
from v_emp;

--emp 테이블에는 부서명이 없음 ==> dept 테이블과 조인을 번번하게 진행
-- 조인된 결과를 view로 생성 해놓으면 코드를 간결하게 작성하는게 가능

dname(부서명), 직원번호(empno), ename(직원이름), job(담당업무),hiredate(입사일자);

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp,dept
WHERE emp.deptno = dept.deptno;

---인 라인 뷰로 한다면?
SELECT 
FROM (SELECT dept.dname, emp.empno, emp.ename, emp.job, emp.hiredate
FROM emp,dept
WHERE emp.deptno = dept.deptno);

-----VIEW 활용 시
SELECT *
FROM v_emp_dept;

--SMITH 직원 삭제후 v_emp_dept view 건수 변화를 확인
delete emp
WHERE ename = 'SMITH';

--VIEW 는 물리적인 데이터를 갖지 않고, 논리적인 데이터의 정의 집합(SQL)이기 때문에
--VIEW에서 참조하는 데이블의 데이터가 변경이 되면 VIEW의 조회 결과도 영향을 받는다.


ROLLBACK;

--view dml 는 대부분 가능하나
--group by, distnct, rownum 사용 불가
-------------------------
--SEQUENCE : 시퀀스 - 중복되지 않는 정수값을 리턴해주는 오라클 객체
--CREATE SEQUENCE 시퀀스_이름
--[OTTION.....]
--명명규칙 : SEQ_테이블명;

--EMP 테이블에서 사용한 시퀀스 생성
--CREATE SEQUENCE  seq_emp;

--시퀀스 제공 함수
--NEXTVAL : 시퀀스에서 다음 값을 가져올 때 사용.
--CURRVAL : NEXTVAL를 사용하고 나서 현재 읽어드린 값을 재확인
SELECT seq_emp.NEXTVAL
FROM dual;

SELECT seq_emp.CURRVAL
FROM dual;

SELECT *
FROM emp_test;

INSERT INTO emp_test VALUES (seq_emp.NEXTVAL, 'james',99,'017'); -- empno에 시퀀스로 현재 읽어 드린 값을 넣는다

--시퀀스 주의점
-- ROLLBACK 을 하더라도 NEXTVAL을 통해 얻은 값이 복원되지 않는다.
-- NEXTVAL를 통해 값을 받아오면 그 값을 다시 사용할 수 없다.



--INDEX
SELECT ROWID, emp.*
FROM emp;

SELECT *
FROM EMP
WHERE   ROWID = 'AAAE59AAFAAAAD7AAH';

--인덱스가 없을때 EMPNO 값으로 조회 하는 경우

EMP 테이블에서 PK_EMP 제약조건을 삭제하여 EMPNO 컬럼으로 인덱스가 존재하지 않는 환경을 조성
ALTER TABLE emp DROP CONSTRAINT pk_emp;


explain plan for
SELECT *
FROM emp
WHERE empno= 7782;


SELECT *
FROM TABLE(dbms_xplan.display);

--emp 테이블의 empno 컬럼으로 PK제약을 생성하고 동일한 SQL을 실행
--PK : unique + NOT NULL
--    (unique 인덱스를 생성해준다)
--    ==>> empno 컬럼으로 unique 인덱스가 생성됨
-- 
-- 인덱스로 sql을 실행하게 되면 인덱스가 없을때와 어떻게 다른지 차이점을 확인;

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp
ORDER BY empno;

explain plan for
SELECT *
FROM emp
WHERE empno =7782;

SELECT *
FROM TABLE(dbms_xplan.display); --accescc는 데이터를 바로 접근하는거고, filter은 데이터를 찾고 버리는거
                                --   2 - access("EMPNO"=7782)           filter("EMPNO"=7782)

explain plan for
SELECT *
FROM emp
WHERE ename= 'SMITH';

SELECT *
FROM TABLE(dbms_xplan.display); 

--SELECT 조회 컬럼이 테이블 접근에 미치는 영향
--SELECT * FROM emp WHERE empno = 7782
--==>
--SELECT empno FROM emp WHERE empno = 7782

explain plan for
SELECT empno
FROM emp
WHERE empno= 7782;

SELECT *
FROM TABLE(dbms_xplan.display); --오라클은 sql문에 FROM emp를 넣어도 기존에 이미 UNIQUE 인덱스가 empno에 있는걸 찾아내서 굳이
                                -- 테이블을 조회하지않고 다이렉트로 empno를 찾아내어 access한다
----------------------------------

--unique VS NON-unique 인덱스의 차이
--1.pk_emp 삭제
--2. empno 컬럼으로 NON-unique 인덱스 생성
--3.실행계획 확인
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX idx_n_emp_01 ON emp (empno);     --idx_n or idx_u 인덱스가 non이냐 아니냐에 따라 명명규칙
                                        --non-unique 인덱스 생성하는 법 찾아보기 중요

explain plan for
SELECT *
FROM emp
WHERE empno= 7782;

SELECT *
FROM TABLE(dbms_xplan.display);
-- non-unique 인덱스는 empno값을 기준으로 정렬할 경우
-- 같은값이 어려번 올수 있다.
--인덱스는 정렬된 객체이므로 찾고자 하는 값의 위치를 빠르게 검색하여
-- ex empno=7782 일경우 7782의 위아래를 스캔하고 7782를 벗어날경우 종료

--emp 테이블에 job 컬럼을 기준으로 하는 새로운 non-unique 인덱스를 생성

CREATE INDEX idx_n_emp_02 ON emp(job);

SELECT job, rowid
FROM emp
ORDER BY job;

--아래 쿼리를 보고 선택가능한 사항
--1. emp 테이블을 전체 읽기
--2. idx_n_emp_01 (empno) 인덱스를 활용
--3. idx_n_emp_02 (job) 인덱스를 활용


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);