--함수 (date) 형변환
-- 형변환(DATE ->CHARACTER) : TO_CHAR(DATE,'포맷')
-- 형변환(CHARACTER -> DATE) : TO_DATE(날짜 문자열, '포맷')

--DATE FORMAT
--YYYY :4자리 년도 
--MM   :2자리 월
--DD   :2자리 일자
--D    :주간 일자(1~7)
--IW   :주차(1~53)
--HH,HH12: 2자리 시간(12시간 표현)
--HH24:2자리 시간(24시간 표현)
--MI : 2자리 분
--SS : 2자리 초

--emp 테이블의 hiredate (입사일자) 컬럼의 년월일 시 :분: 초
SELECT ename, hiredate, 
        TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS'),--포맷
        TO_CHAR(hiredate +1, 'YYYY-MM-DD HH24:MI:SS'), -- +1일
        TO_CHAR(hiredate +1/24, 'YYYY-MM-DD HH24:MI:SS'), -- + 1시간
        --hiredate에 30분을 더하여 TO_CAHR로 표현
        TO_CHAR(hiredate +(1/24/60)*30, 'YYYY-MM-DD HH24:MI:SS') -- 1/24/2 도 가능 ,1/48도 되던데..
FROM emp; 
    
    SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
            TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
            TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
    FROM dual;
    

--MONTHS BETWEEN (DATE, DATE)
--인자로 들어온 두 날짜 사이의 개월수를 리턴
    SELECT ename, hiredate,
            MONTHS_BETWEEN (sysdate, hiredate),
            MONTHS_BETWEEN (TO_DATE('2020.01.17', 'YYYY.MM.DD'), hiredate)            
    FROM EMP
    WHERE ename='SMITH';
    
--ADD_MONTHS (DATE, 정수-가감할(더하거나 뺄) 개월수)
SELECT 
        ADD_MONTHS (SYSDATE, 5), --2020/01/29 -> 2020/06/29
        ADD_MONTHS (SYSDATE, -5) --2020/01/29 -> 2019/08/29
FROM dual;


--NEXT_DAY(DATE, 주간일자), ex: NEXT_DAY(SYSDATE, 5) --> sysdate 이후 처음 등장하는 주간일자 5에 해당하는 일자
--                              SYSDATE 2020/01/29 (수) 이후 처음 등장하는 5 (목)요일 --> 2020/01/30(목)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DAY(DATE) DATE 속한 월의 마지막 일자를 리턴
SELECT LAST_DAY(SYSDATE) --SYSDATE 2020/01/29 --> 2020/01/31
FROM dual;


--LAST_DAY를 통해인자로 들어온 date가 속한 월의 마지막 일자를 구할수 있는데
--DATE의 첫번째 일자는 어떻게 구할까?
SELECT SYSDATE,
        LAST_DAY(SYSDATE),
       ADD_MONTHS(LAST_DAY(SYSDATE)+1, -1),
        TO_CHAR(SYSDATE, 'YYYY-MM') || '-01',
        TO_DATE(TO_DATE('01','DD'),
        TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM'),'YYYY-MM') || '-01', 'YYYY-MM-DD')
        
FROM dual;


--hiredate 값을 이용하여 해당 월의 첫번째 일자로 표현
SELECT ename, hiredate, 
    ADD_MONTHS(LAST_DAY(hiredate)+1 , -1)
FROM emp;


-- empno는 NUMBER 타임, 인자는 문자열
-- 타입이 맞지 않기 때문에 묵시적 형변환이 일어남
-- 테이블 컬럼의 타입에 맞게 올바른 인자 값을 주는게 중요
SELECT *
FROM emp
WHERE empno= '7369';

SELECT *
FROM emp
WHERE empno= 7369; --더 정확한 표현 컬럼의 타입에 맞게


--hiredate 의 경우 date 타입, 인자는 문자열로 주어졌기 때문에 묵시적 형변환이 발생
--날짜 문자열 보다 날짜 타입으로 명시적으로 기술하는 것이 좋음
SELECT *
FROM emp
WHERE hiredate = '1980/12/17';

SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17', 'YYYY/MM/DD');


EXPLAIN PLAN FOR --실행계획 
SELECT *
FROM emp
WHERE empno ='7369'; -- 1 - filter("EMPNO"=7369) 저장은 숫자로 되어있는데 묵시적 형변환이 됨

SELECT *
FROM emp
WHERE TO_CHAR(empno)='7369'; -- 문자열에 맞게 형변환 

SELECT *
FROM table(dbms_xplan.display); -- 오라클에서 제공하는 실행계획 (위에서 아래로 읽고 자식타입이있으면 자식을 먼저 읽는다.)



--숫자를 문자열로 변경하는 경우
--천단위 구분자
-- 1000 이라는 숫자를
--한국 : 1,000.50
--독일 : 1.000,50

--emp sal 컬럼(NUMBER 타입)을 포맷팅
-- 9 : 숫자
-- 0 : 강제 자리 맞춤(0으로 표기)
-- L : 통화 단위
SELECT ename, sal, TO_CHAR(sal, 'L0,999')
FROM emp;



--NULL에 대한 연산의 결과는 항상 NULL
-- emp 테이블의 sal 컬럼에는 null 데이탁 존재하지 않음(14건의 데이터에 대해)
-- emp 테이블의 comm 컬럼에는 null 데이터가 존재 (14건의 데이터에 대해)
-- sal + comm --> comm인 null인 행에 대해서는 결과 null로 나옴
-- 요구사항 : comm이 null 이면 sal컬럼의 값만 조회
-- 요구사항이 충족 시키지 못한다 -> sw에서는 [결함]


--  NVL (타겟, 대체값)
--타겟의 값이 NULL이면 대체값을 반환하고 
--타겟의 값이 NULL이 아니면 타겟 값을 반환

--  if (타겟 == null )
--      return 대체값;
--  else 
--      return 타겟;
SELECT ename , sal, comm, NVL(comm,0), 
        sal+ NVL(comm,0),
        NVL(sal+comm, 0)
FROM emp;



--NVL2 (exr1, expr2, expr3)
-- if(expr1 != null)
--        return expr2;
--else
--          return expr3;

SELECT ename, sal, comm , NVL2(comm, 10000, 0)

FROM emp;



--     NULLIF(expr1, exrp2)
-- if(expr1 == expr2)
--      return null;
--else
--      return expr1;
-- sal 1250인 사원은 null을 리턴, 1250이 아닌 사람은 sal을 리턴
SELECT ename, sal, comm, NULLIF(sal, 1250) 
FROM emp;


--가변인자
--COALESCE 인자 중에 가장 처음으로 등장하는 NULL이 아닌 인자를 반환

--COALESCE (expr1, expr2, ...)
--   if(expr1 != null)
--          return expr1;
--      else
--  return COALESCE (expr2, expr3....);


--COALESCE(comm, sal) : comm이 null 이 아니면 comm
--                   : comm이 null 이면 sal (단, sal 컬럼의 값이 null이 아닐때)
SELECT ename, sal, comm, COALESCE(comm,sal)
FROM emp;

SELECT empno, ename, mgr, NVL(mgr, 9999) MGR_N,
                        NVL2(mgr,mgr, 9999 ) MGR_N1, --(a,b,c) : a == null 이면 c 반환 , a != 이면 b 반환
                        COALESCE(mgr, 9999) MGR_N2 
FROM emp;


-- null 실습 fn5
SELECT userid, usernm,reg_dt,  NVL(reg_Dt,sysdate) n_reg_dt
FROM users
WHERE userid != 'brown';


--condition : 조건절
--case : JAVA의 if - else if - else 

-- CASE
--      WHEN 조건 THEN 리턴값 1
--      WHEN 조건2 THEN 리턴값 2
--      ELSE  기본값
--  END
--emp 테이블에서 job 컬럼의 값이 SALSEMAN 이면 SAL * 1.05 리턴,
--                               MANAGER 이면 SAL * 1.1 리턴,
--                               PRESIDENT 이면 SAL * 1.2 리턴
--                              그밖의 사람들은 SAL 을 리턴

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
                else sal
        end as bonus_sal
FROM emp;

--DECODE 함수 : CASE 절과 유사
--(다른점 CASE 절 : WHEN 절에 조건비교가 자유롭다
--        DECODE 함수 : 하나의 값에 대해서 = 비교만 허용
--DECODE 함수 : 가변인자 (인자의 개수가 상황에 따라서 늘어날 수가 있음)
--DECODE(coi | expr, 첫번째 인자와 비교할 값1, 첫번째 인자와 두번째 인자가 같을 경우 반환 값,
--                   첫번째 인자와 비교할 값2, 첫번째 인자와 네번째 인자가 같을 경우 반환 값....
--                      option - else 최종적으로 반환할 기본값)

SELECT ename, job, sal,
    DECODE(job, 'SALESMAN',sal *1.05,
                'MANAGER', sal* 1.15,
                'PRESIDENT', sal* 1.2, sal) as bonus_sal
from emp;

--
SELECT ename, job, sal,
    CASE
        WHEN job = 'SALESMAN' OR sal >1400 THEN sal *1.05
        WHEN job = 'MANAGER' OR sal <1400 THEN sal *1.1
        WHEN job = 'PRESIDENT' THEN sal* 1.2
    else sal
    END bonus
FROM emp;


    --세일즈맨 sql 1400 크면 1.05리턴 , 작으면 리턴1.1, 매니저는 1.1 ,대통령 1.2 그밖 sal
SELECT ename, job, sal,
    DECODE(job, 'SALEMAN', case WHEN sal>1400 THEN sal*1.05 WHEN sal <1400 THEN sal *1.1 else sal END,
                'MANAGER',  Sal*1.15,
                'PRESIDENT', sal*1.2) bonus
    FROM emp;
              
                    