SELECT sido,sigungu, gb 
FROM fastfood b
WHERE sido IN ('강원도') AND gb IN '롯데리아';
SELECT a2.sido, a2.sigungu, ROUND(ham/b1,1) kk
    FROM
        (SELECT sido, sigungu, SUM(a1) ham
        FROM 
          (SELECT sido,sigungu, gb ,count(gb) a1
          FROM fastfood 
          WHERE gb IN ('맥도날드','KFC','버거킹')
          GROUP BY sido,sigungu, gb)a
        GROUP BY sido,sigungu) a2
    JOIN
       
          (SELECT sido,sigungu, gb ,count(gb) b1
          FROM fastfood 
          WHERE gb IN ('롯데리아') 
          GROUP BY sido,sigungu, gb) b2  
          
        ON(a2.sido = b2.sido AND a2.sigungu = b2.sigungu)
        ORDER BY kk desc;
        
--대전시에 있는 5개의 구 햄버거 지수
--kfc + 버거킹 + 맥도날드 / 롯데리아

SELECT sido, count(*)
FROM fastfood
WHERE sido like '%대전%'
GROUP BY sido; 

--분자 KFC, 버거킹 ,맥도날드
SELECT sido, sigungu, count(*)
from fastfood
WHERE sido = '대전광역시'
AND gb IN ('KFC','버거킹','맥도날드')
GROUP BY sido,sigungu;


-- 롯데리아
SELECT sido, sigungu, count(*)
from fastfood
WHERE sido = '대전광역시'
AND gb IN ('롯데리아')
GROUP BY sido,sigungu;

SELECT a.sido, a.sigungu, ROUND(a.c1/b.c2,2) hambuger_score
FROM
(SELECT sido, sigungu, count(*) c1
from fastfood
WHERE /*sido = '대전광역시'
AND */gb IN ('KFC','버거킹','맥도날드')
GROUP BY sido,sigungu) a,

(SELECT sido, sigungu, count(*) c2
from fastfood
WHERE /*sido = '대전광역시'
AND*/ gb IN ('롯데리아')
GROUP BY sido,sigungu) b

WHERE a.sido = b.sido
AND a.sigungu =b.sigungu
ORDER BY hambuger_score desc;

--fastfood 테이블을 한번만 읽는 방식으로 작성하기
SELECT sido, sigungu,ROUND(KFC+ burgerking + mac / lot, 2) burger_score
FROM 

(SELECT sido, sigungu,
       NVL(SUM(DECODE(gb, 'KFC', 1)),0) KFC,
       NVL(SUM(DECODE(gb, '버거킹', 1)),0) burgerking,
       NVL(SUM(DECODE(gb, '맥도날드',1)),0) mac,
       NVL(SUM(DECODE(gb, '롯데리아',1)),1) lot --분모가 되는 롯데리아~ 0을 넣을순 없지
FROM fastfood
WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')
GROUP BY sido, sigungu)
/*ORDER BY sido, sigungu)*/-- 효율성으로 인해 제거해도 상관 X 
ORDER BY burger_score DESC;



SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;

--햄버거 지수, 개인별 근로소득 금액 순위가 같은 시도별로 조인
--지수, 개인별 근로소득 금액으로 정렬 후 ROWNUM을 통해 순위를 부여
--같은 순위의 행끼리 조인
--햄버거지수 시도, 햄버거수 시군구, 햄버거지수, 세금시도, 세금 시군구, 개인별 근로소득액

SELECT b.sido, b.sigungu, b.burger_score, a.sigubgu, a.pri_sal
FROM
(SELECT ROWNUM rn1, b.*
 FROM
        
        (SELECT sido, sigungu,  -- SELECT 절 하나 더써써 그냥 ROUND 하는게 편할듯
                 (NVL(SUM(DECODE(gb, 'KFC', 1)),0),
                       NVL(SUM(DECODE(gb, '버거킹', 1)),0),
                       NVL(SUM(DECODE(gb, '맥도날드',1)),0),
                       NVL(SUM(DECODE(gb, '롯데리아',1)),1),2)    --분모가 되는 롯데리아~ 0을 넣을순 없지
FROM fastfood
WHERE gb IN('KFC','버거킹','맥도날드','롯데리아')
GROUP BY sido, sigungu
ORDER BY burger_score DESC) b)b

JOIN

(SELECT ROWNUM rn2, a.*
    FROM
        (SELECT sido, sigungu, ROUND(sal/people) pri_sal
        FROM tax
        ORDER BY pri_sal DESC)a) a

ON (a.rn =b.rn2);

--Rownum 사용시 주의
--SELECT --> ORDER BY
--정렬된 결과에 ROWNUM을 적용하기 위해서는 INLINE -VIEW
--1번부터 순차적으로 조회가 되는 조건에 대해서만 WHERE 절에서 기술이 가능


desc dept;

--enmpno 컬럼은 NOT NULL 제약 조건이 있다. -insert 시 반드시 값이 존재해야 정상적으로 입력된다
--empno 컬럼을 제외한 나머지 컬럼은 BULLABLE 이다  (NULL값이 저장될 수 있다.)
INSERT INTO emp(empno,ename,job)
    VALUES (9999,'brown',NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename, job)
VALUES ('sally','SALESMAN'); -- 입력안됨

--문자열 : '문자열' 
--숫 짜   :10
--날 짜   : TO_DATE('20200206','YYYYMMDD')

--emp 테이블의 hiredate 컬럼은 date 타입
--emp 테이블의 8개 컬럼에 값을 입력 

desc emp; --테이블을 전체 입력하려면 검색을 해주고 테이블컬럼 순서대로 입력

INSERT INTO emp VALUES(9998,'sally', 'SALESMAN' , NULL,SYSDATE, 1000,NULL ,99); --입력

ROLLBACK;-- 롤백


--여러건의 데이터를 한번에 INSERT :
--INSERT INTO 테이블명 (컬럼명1, 컬럼명2.....)
--SELECT .....
--FROM
INSERT INTO emp
SELECT 9998,'sally', 'SALESMAN' , NULL,SYSDATE, 1000,NULL ,99
FROM dual

    UNION ALL --(중복없으니 ALL씀, 속도향상)

SELECT 9999,'brown','CLERK', NULL,TO_DATE('20200205','YYYYDDMM'),1100,NULL,99
FROM dual;

SELECT *
FROM emp;


--UPDATE 쿼리
--UPDATE 테이블명 컬럼명1 = 갱신할 컬럼 값1, 테이블명 SET 컬럼명2 = 갱신할 컬럼 값2.....
--WHERE 행 제한 조건 (특정 행에만 업데이트 한다고 할때)

--업데이트 쿼리 작성시 where 절이 존재하지 않으면 해당 테이블의 모든행을 대상으로 업데이트가 일어난다.
--UPDATE, DELETE 절에 WHERE절이 없으면 의도한게 맞는지 다시한번 꼭 확인

--WHERE절이 있다고 하더라도 해당 조건으로 해당 테이블을 SELECT 하는 쿼리를 작성하여 실행하면
--업데이트 대상 행을 조회 할수 있으므로 확인하고 실행하는 것도 사고 발생 방지에 도움이 된다.

--99번 부서번호를 갖는 부서 정보가 DEPT테이블에 있는 상황

INSERT INTO dept (99,'ddit','daejeon'); --입력

-- 99번 부서번호를 갖는 부서의 dname 컬럼의 값을 '대덕IT', loc컬럼의 값을 '영민빌딩'으로 업데이트

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;


SELECT *
FROM dept
WHERE deptno =99;

ROLLBACK; -- 잘못했을시 전으로 돌리는 one chance


--실수로WHERE 절을 기술하지 않았을 경우
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩' 
--deptno칼럼과 연계된 danem => 대덕IT ,loc => 영민빌딩으로 나온다

-- 10 ==> subquery;

--smtih, ward가 속한 부서에 소속된 직원 정보
SELECT *
FROm emp
WHERe detpno IN(20,30);


SELECT *
FROM emp
WHERE detpno IN(SELECT deptno  
                FROM emp
                WHERE ename IN('SMITH','WARD'));

--UPDATE시에도 서브 쿼리 사용 가능
INSERT INTO emp (empno,ename) VALUES (9999, 'brown');

--9999번 사원 deptno, job정보를 SMITH 사원이 속한 부서정보 담당업무로 업데이트
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT deptno FROM emp WHERE ename ='SMITH')
WHERE empno =9999;


--
--DELETE SQL : 특정 행을 삭제
--  DELETE [FROM] 테이블명
--  WHERE 행 제한 조건;

SELECT *
FROM dept;

--99번 부서번호에 해당하는 부서 정보 삭제
DELETE dept
FROM deptno =99;

COMMIT;

--SUBQUERY를 통해서 특정 행을 제한하는 조건을 갖는 DELETE
--매니저가 7698 사번인 직원을 삭제하는 쿼리를 작성

DELETE emp
WHERE mgr = 7698;

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);

ROLLBACK;

SELECT *
FROM emp;







