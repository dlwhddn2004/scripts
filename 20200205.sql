--실습 sub4
--dept 테이블에는 5건의데이터가 존재
--emp 테이블에는 14명의 직원이 있고, 직원은 하나의 부서에 속해 있다.(deptno)
-- 부서중 직원이 속해 있지 않은 부서 정보를 조회
--서브 쿼리에서 데이터의 조건이 맞는지 확인자 역활을 하는 서브쿼리 작성
SELECT *
FROM dept
WHERE deptno NOT IN(select deptno
                     FROM emp);
                     
 SELECT *
 FROM dept
 WHERE deptno NOT IN         
            (SELECT deptno
            FROM emp
            GROUP BY deptno);

--sub5 연습문제
SELECT *
FROM product
WHERE PID NOT IN(SELECT pid
                  FROM cycle
                  WHERE cid =1);  
                  
--sub6             
SELECT *
FROM product
WHERE PID IN((SELECT pid
             FROM cycle
              WHERE cid =1),
              (SELECT pid
             FROM cycle
              WHERE cid =2));
--cid = 1인 고객의 애음정보 : 100번, 400번
SELECT *
FROM cycle
WHERE cid =1;
--cid = 1인 고객의 애음정보 : 100번, 200번
SELECT *
FROM cycle
WHERE cid =2;

--cid =1, cid =2 인고객이 동시에 애음하는 제품 
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN(100);

------------------
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN ( SELECT pid
            FROM cycle
            WHERE cid =2);
            
--서브쿼리 7
SELECT *
FROM customer;
SELECT *
FROM product;
SELECT *
FROM cycle;


SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
    (SELECT *
    FROM cycle
    WHERE cid = 1
    AND pid IN ( SELECT pid
            FROM cycle
            WHERE cid =2)) a,customer,product
WHERE a.cid = customer.cid
AND   a.pid = product.pid;


SELECT cycle.cid, customer.cnm, cycle.pid,
product.pnm,cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN ( SELECT pid
            FROM cycle
            WHERE cid =2)
AND cycle.cid = customer.cid
AND cycle.pid = product.pid;

--매니저가 존재하는 직원을 조회(KING을 제외한 13명의 데이터가 조회);
SELECT *
FROM emp
WHERE mgr IS NOT null;




--EXSITS 조건에 만족하는 행이 존재 하는지 확인하는 연산자
--다른 연산자와 다르게 WHERE 절에 컬럼을 기술하지 않는다.
-- WHERE emp no = 7369 -> WHERE EXIST (SELECT 'X' 
--                                    FROM ......);
--exists는 다중연산자
--매니저가 존재하는 직원을 EXISTS 연산자를 통해 조회
--매니저도 직원
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
                FROM emp m
                WHERE e.mgr = m.empno);

--실습 9

SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT *
FROM product
WHERE EXISTs ( SELECT 'X'
                FROM cycle
                WHERE cycle.pid = product.pid
                AND cid =1);
      
--sub 10

SELECT *
FROM product
WHERE NOT EXISTS ( SELECT 'X'
                FROM cycle
                WHERE cycle.pid = product.pid
                AND cid !=1);
                

--집합연산
--합집합 :UNION -중복제거(집합개념) / UNION ALL - 중복을 제거하지 않음(속도 향상)
--교집합 : INTERSECT (집합개념)
--차집합 : MINUS (집합개념)
--집합연산 공통사항
--두 집합의 컬럼의 개수, 타입이 일치 해야 한다.

--동일한 집합을 합집하기 때문에 중복되는 데이터는 
--한번만 적용된다

--UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)
                
UNION

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);


--UNION ALL 연산자는 UNION 연산자와 다르게 중복을 허용
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)
                
UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);



--INTERSECT (교집합) : 위 , 아래집합에서 값이 같은 행만 조회
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)
                
INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);



--MINUS (차집합) : 위 집합에서 아래 집합의 데이터를 제거한 나머지 집합
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)
                
MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

--집합의 기술 순서가 영향이 가는 집합연산자
-- A UNION B =  B UNION A  (같음)
-- A UNION ALL B = B UNION ALL A (같음) 집합개념으론
-- A INTERECT B = B INTERECT A

-- A MINUS B   != B MINUS A(다름)

--집합 연산의 결과  컬럼 이름은 첫번째 집합의 컬럼명을 따른다.
SELECT 'X' fir, 'B' sec 
FROM dual

UNION

SELECT 'Y' asd,'A'
FROM dual;


--정렬 ORDER BY 는 집합 연산 가장 마지막 집합 다음에 기술

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10,20)

UNION

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30,40)
ORDER BY deptno;
-------------------------아래 처럼 해도 됨
SELECT deptno, dname, loc
FROM (SELECT deptno, dname, loc
        FROM dept
        WHERE deptno IN (10,20))

UNION

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30,40)
ORDER BY deptno;


--햄버거 도시 발전지수;
SELECT *
FROM fastfood;

--시도, 시군구, 버거 지수 // 버거지수 값이 높은 도시가 먼저 나오도록 정렬
--버거지수 kfc 계수 + 버거킹 개수 + 맥도날드 개수 / 롯데리아 개수
SELECT *
FROM fastfood;

SELECT sido,sigungu, gb,count(gb) 
FROM fastfood 
GROUP BY sido,sigungu, gb;

SELECT sido,sigungu, gb ,count(gb)
FROM fastfood a
WHERE gb IN ('맥도날드','kfc','버거킹')
GROUP BY sido,sigungu, gb;

SELECT sido,sigungu, gb ,count(gb)
FROM fastfood a
WHERE sido IN ('강원도') AND gb IN ('맥도날드','kfc','버거킹')
GROUP BY gb;

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
        

    