SELECT aa.ename, aa.sal, aa.deptno ,bb.lv
FROM
(SELECT rownum rn,ename,sal,deptno --rownum으로 인라인뷰를할떄 명시적으로 사용할 컬럼다 올려줘야함
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno,sal desc) a)aa
,
(SELECT ROWNUM rn, lv
FROM
(SELECT *
FROM
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <=14) a,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno,a.lv)b)bb
WHERE aa.rn = bb.rn;


--분석함수 문법
--분석함수명([인자]) OVER ([PARTITION BY 컬럼]) [ORDER BY 컬럼] [WINDOWING])
--PARTITION BY 컬럼 : 해당 컬럼이 같은 ROW 끼리 하나의 그룹으로 묶는다.
--ORDER BY 컬럼 : PARTITION BY에 의해 묶은 그룹 내에서 ORDER BY 컬럼으로 정렬

--ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) AS rank;

--순위 관련 분석함수
--RANK() : 같은 값을 가질때 중복 순위를 인정, 후순위는 중복 값만큼 떨어진 값부터 시작
--         2등이 2명이면 3등은 없고 4등부터 후순위가 생성된다.

--DENSE_RANK() :같은 값을 가질때 중복 순위를 인정, 후순위는 중복순위 다음부터 시작
--                2등이 2명이더라도 후순위는 3등부터 시작.

--ROW_NUMBER() : ROWNUM과 유사, 중복된 값을 허용하지 않음

부서별, 급여 순위를 3개의 랭킹 관련 함수를 적용;
SELECT ename, sal, deptno,
        RANK() OVER (deptno ORDER BY sal) as sal_rank,
        DENSE_RANK() OVER (deptno ORDER BY sal) sal_dense_rank,
        ROW_NUMBER() OVER (deptno ORDER BY sal) ROW_NUMBER_dense_rank
FROM emp;

--실습 ana1 : 사원 전체 급여 순위
분석함수 에서 그룹 :PARTITION BY ==> 기술하지 않으면 전체 행
SELECT empno,ename, sal, deptno,
     rank() OVER (ORDER BY sal desc) RANK_1,
          DENSE_RANK() OVER (ORDER BY sal desc) dense_1,
          ROW_NUMBER() OVER (ORDER BY sal desc) ROWNUMBER_1
 FROM emp;

--실습 no_ana2
 SELECT e.empno,e.ename, e.deptno, a.cnt
 FROM emp e 
 
    JOIN
        (SELECT deptno, COUNT(*) cnt
         FROM emp  GROUP BY deptno)a

    ON(e.deptno = a.deptno)
ORDER BY deptno;

SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;
--오라클에선 통계관련 분석함수 제공 (GROUP 함수에서 제공하는 함수 종류와 동일)
--SUM(컬럼)
--COUNT(*),COUNT(컬럼)
--MIN(컬럼), MAX(컬럼)
--AVG(컬럼)
no_ana2 를 분석함수를 사용하여 작성 
부서별 직원수;
SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno ) cnt
FROM emp; --분석함수는 그룹함수에서 제공하는 함수와 동일하여 분석함수 + OVER + (PARTITON BY 컬럼명 [ORDER BY 컬럼명])

--ana2 : 부서별 급여 평균 조회
--직원번호, 직원이름 ,본인 급여,소속부서, 소속부서의 급여 평균( 소수점 둘째자리)
SELECT empno,ename, sal,deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno), 2)
FROM emp;
--ana3 
SELECT empno, ename, sal, deptno, MAX(sal) OVER (PARTITION BY deptno)
FROM emp;

--ana4
SELECT empno, ename, sal, deptno, MIN(sal) OVER (PARTITION BY deptno)
FROM emp;

--급여를 내림차순 정렬하고, 급여가 같을 때는 입사일자가 빠른 사람이 높은 우선순위가 되도록 정렬하여
--현재 행의 다음행(lead)의 sal 컬럼을 구하는 쿼리 작성

SELECT empno, ename, hiredate,sal, LEAD(sal) OVER (ORDER BY sal desc, hiredate) lead_sal --lead 이후
FROM emp;

--ana5
SELECT empno, ename, hiredate, sal, LAG(sal) over (ORDER BY sal desc , hiredate) d --lag 이전
FROM emp;

--ana6
SELECT empno, ename,hiredate,job, sal, LAG(sal) over (PARTITION BY job ORDER BY sal desc , hiredate) lag_sal
FROM emp;


SELECT ROWNUM rn, a.*
FROM
(SELECT empno,ename,sal
FROM emp
ORDER BY sal)a;

SELECT ROWNUM rn, b.*
FROM
(SELECT empno,SUM(SAL)
FROM emp
GROUP BY empno) b; 합으로 나타낸다면????????

SELECT SUM(sal)
FROM emp
WHERE ename IN ('SMITH','JAMES')

SELECT * 
FROM emp
WHERE 


---------------------------------------------------
--쿼리 실행 결과 11건
--페이징 처리(페이지당 10건의 게시글)
--1페이징 : 1~10
--2페이징 : 11~20
--바인드 변수 : page :pageSize

--(중요한 쿼리 오라클의 형태)
SELECT *
FROM
(SELECT rownum rn, a.* --rownum의 특징 한번 묵고 바로 표현 불가 다시한번 묶어줘야함
FROM
(SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title, DECODE(parent_seq, NULL, seq, parent_seq) root
FROM board_test
START WITH parent_seq is null --또는 seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC ) a)a
WHERE rn BETWEEN (:page-1) * :pagesize+1 AND :page * :pagesize;
--n page : rn(n-1) *pageSize + 1 ~n * pageSize

