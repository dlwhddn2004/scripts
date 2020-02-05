-- DECODE안에 case나 decode 구문이 중첩 가능
SELECT ename, job, sal,
        DECODE(job, 'SALESMAN', CASE
                                WHEN sal > 1400 THEN sal *1.05
                                WHEN sal < 1400 THEN sal * 1.1
                                END,
                     'MANAGER' , sal *1.1,
                     'PRESIDENT', sal * 1.2,
                     sal ) bonus_sal
    FROM emp;
    
--codition 실습 1
SELECT empno, ename, 
    CASE 
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALSES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        else 'DDIT'
        END DNAME
    FROM emp;
    
    SELECT empno, ename,
    DECODE(deptno, 10, 'ACCOUNTING', 20 , 'RESEARCH', 30, 'SALSES', 40,'OPERATIONS', 'DDIT' ) DNAME
    FROM emp;
    
--cond2
--올해년도가 짝수이면
--입사년도가 짝수일 때 건강검진 대상자
--입사년도가 홀수일 때 건강검진 비대상자

--올해년도가 홀수이면
--입사년도가 짝수일 때 건강검진 비대상자
--입사년도가 홀수일 때 건강검진 대상자
    SELECT empno, ename, hiredate,
        CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2)=MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2)
            THEN '건강검진대상자'  
            WHEN MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2)!= MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2)
            THEN '건강검진비대상'
            END CONTACT_TO_DOCTOR
        FROM emp;
        
    SELECT empno, ename, hiredate,      
DECODE(MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2),
        MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2),'건강검진대상자', '건강검진비대상자') 검진
        FROM emp;
        
-- DATE 타입 -> 문자열(여러가지 포맷, YYYY-MM-DD HH24:MI:SS)
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
FROM dual;


------그룹 함수 GROUP BY 행을 묶을 기준
-- 부서번호가 같은 ROW 끼리 묶는 경우 : GROUP BY deptno
-- 담당엄무가 같은 ROW 끼리 묶는 경우 : GROUP BY job 
-- mgr가 같고 담당업무가 같은 ROW 끼리 묶는 경우 : GROUP BY mgr, job

--그룹 함수의 종류
-- SUM : 합계 
-- COUNT : 계수 -NULL 값이 아닌 row 갯수 (null은 무시)
-- MAX   : 최대
-- MIN   : 최소
-- AVG  : 평균

--그룹함수의 특징
--해당 컬럼에 Null 값을 갖는 Row가 존재할 경우 해당 값은 무시하고 계산한다.
--(Null 연산의 결과는 null)

--그룹함수 주의점

--GROUP BY 절에 나온 컬럼이외의 다른 컬럼이 SELECT 절에 표현되면 에러

--부서별 급여 합
SELECT deptno, ename,
        SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal)

FROM emp
GROUP BY deptno, ename;


--GROUP BY 절이 없는 상태에서 그룹함수를 사용한 경우
-- 전체행을 하나의 행으로 묶는다는 뜻
SELECT  SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
        COUNT(sal),-- 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(comm),-- COMM 컬럼의 값이 null이 아닌 row 갯수
        COUNT(*) -- 몇건의 데이터가 있는지
FROM emp;

--GROUP BY의 기준이 empno이면 결과수가 몇건?
SELECT  SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
        COUNT(sal),-- 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(comm),-- COMM 컬럼의 값이 null이 아닌 row 갯수
        COUNT(*) -- 몇건의 데이터가 있는지
FROM emp
GROUP BY empno;


--그룹화와 관련없는 임의의 문자열, 함수 ,숫자등은 SELECT 절에 나오는것이 가능
SELECT 1,SYSDATE, 'ACCOUNTING', SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
        COUNT(sal),-- 컬럼의 값이 null이 아닌 row의 갯수
        COUNT(comm),-- COMM 컬럼의 값이 null이 아닌 row 갯수
        COUNT(*) -- 몇건의 데이터가 있는지
FROM emp
GROUP BY empno;


-- SINGIE ROW FUNCTION의 경우 WHERE 절에서 사용 하는것이 가능하나
-- MULTI ROW FUNCTION(GROUP FUNCTION)의 경우 WHERE 절에서 사용하는것이 불가능하고
-- HAVING 절에서 조건을 기술한다.(HAVING 절은 group by 절 뒤에 나온다)

--부서별 급여 합 조회, 단 급여합이 9000이상 row만 조회
-- deptno, 급여합이 필요
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno
HAVING SUM(sal) >= 9000;

--group function 연습문제 1
SELECT MAX(sal), MIN(sal), ROUND(avg(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;

--group function 연습문제 grp3
SELECT deptno,
case
    WHEN deptno = 10 THEN 'ACCOUNTING' 
     WHEN deptno = 20 THEN 'RESEARCH'
     WHEN deptno = 30 THEN 'SALES' 
     END,
     MAX(sal), MIN(sal), ROUND(avg(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;


--연습문제 grp3
SELECT decode(deptno, 10,'ACCOUNTING',20,'RESEARCH', 30, 'SALES'),
     MAX(sal), MIN(sal), ROUND(avg(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY decode(deptno, 10,'ACCOUNTING',20,'RESEARCH', 30, 'SALES');


--연습문제 grp4
--ORACLE 9i 이전까지는 group by 절에 기술한 컬럼으로 정렬을 보정
--ORACLE 10G 이후 부터는 GROUP BY절에 기술한 컬럼으로 정렬을 보장하지 않음(GROUP BY 연산시 속도 UP)
SELECT TO_CHAR(hiredate, 'YYYYMM'), COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');


--연습문제 grp5
SELECT TO_CHAR(hiredate, 'YYYY'), COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');


--연습문제 grp6
SELECT COUNT(*)
FROM dept;

SELECT COUNT(dname)
FROM dept;

--연습문제 grp7
--부서가 뭐가 있는지 파악
--부서가 뭐가 있는지 : 10 , 20, 30 --> 3개의 row가 존재
-- 테이블의 row수를 조회 : GROUP BY 없이 COUNT(*)

SELECT COUNT(*)
FROM
(SELECT deptno
    FROM emp
GROUP BY deptno);


-- condition 실습 연습문제 3

SELECT userid, usernm , alias, reg_dt,
    decode(MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')),2),
        MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2),'건강검진대상자','건강검진비대상자')
FROM users;




