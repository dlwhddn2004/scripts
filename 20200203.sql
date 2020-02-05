
-- 3테이블 조합은 commA JOIN B ON () C JOIN ON (); 마지막 C 조인 괄호 빼도 상관 X
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name, c.cart_qty 
FROM member m Join Cart c ON(m.mem_id = c.cart_member) JOIN prod p ON( c.cart_prod = p.prod_id);



SELECT *
FROM CUSTOMER;

SELECT *
FROM PRODUCT;

SELECT *
FROM CYCLE;


--판매점 :200~250
--고갱당 2.5개 제품
-- 하루 : 500~750
-- 한달 : 15000~ 17500

SELECT *
FROM daily;

SELECT *
FROM batch;


--조인 실습 4 : join을 하면서 ROW를 제한하는 조건을 결합;
SELECT c.cid, c.cnm, cy.pid , cy.day, cy.CNT
FROM customer c, cycle cy
WHERE c.cid = cy.cid
AND c.cnm IN('brown' , 'sally');


--조인 실습 5
SELECT c.cid, c.cnm, cy.pid, p.pnm, cy.day, cy.cnt
FROM customer c, cycle cy ,product p
WHERE c.cid= cy.cid AND cy.pid =p.pid 
AND c.cnm IN('brown' , 'sally');



--조인 실습 6 : join을 하면서 ROW를 제한하는 조건을 결합 , 그룹함수 적용

SELECT c.cid, c.cnm, cy.pid, p.pnm,sum(cy.cnt)
FROM customer c, cycle cy ,product p
WHERE c.cid= cy.cid AND cy.pid =p.pid
GROUP BY c.cid, c.cnm, cy.pid, p.pnm;

--조인 실습 7

SELECT cy.pid, p.pnm, sum(cy.cnt)
FROM product p , cycle cy
WHERE cy.pid =p.pid
GROUP BY cy.pid, p.pnm; 
--join 과제


--해당 오라클 서버에 등록된 사용자(계정) 조회;
SELECT *
FROm dba_users;

--HR 계정의 비밀번호를 JAVA로 초기화
ALTER USER HR IDENTIFIED BY java;

ALTER USER HR ACCOUNT UNLOCK;


--OUTER JOIN
-- 두 테이블을 조인할때 연결 조건을 만족 시키지 못하는 데이터를
--기준으로 지정한 테이블의 데이터만이라도 조회 되게끔 하는 조인 방식

--연결조인 : e.mgr = m.empno --> KING의 mgr null 이기 때문에 조인에 실패한다
--emp 테이블의 데이터는 총 14건이지만 아래와 같은 쿼리에서는 결과가 13건이 된다(1건 조인실패)
SELECT e.empno, e.ename, e.mgr , m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;


--ANSI OUTER
--1. 조인에 실패하더라도 조회가 될 테이블을 선정(매니저 정보가 없어도 사원정보는 나오게끔)
SELECT  e.empno, e.ename, e.mgr , m.ename
FROM emp e LEFT OUTER JOIN emp m ON e.mgr =m.empno; --왼쪽이 기준

SELECT  e.empno, e.ename, e.mgr , m.ename
FROM emp m RIGHT OUTER JOIN emp e ON e.mgr =m.empno; --오른쪽이 기준
--즉 테이블의 순서가 중요

--oracle outer join 
--데이터가 없는 쪽의 테이블 컬럼 뒤에 (+)가호를 붙여준다
SELECT  e.empno, e.ename, e.mgr , m.ename
FROM emp e, emp m
WHERE e.mgr =m.empno(+);



SELECT  e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e, emp m
WHERE e.mgr =m.empno(+);
--위의 sql을 안시 SQL(OUTER JOIN) 으로 변경해보세요.
--조건 : 매니저의 부서번호가 10번인 직원만 조회
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr =m.empno AND m.deptno = 10; 
-- 아우터 조인이라 m.deptno=10 이 아니여도 왼쪽
--기준으로 다출력



--아우터 조인이 아니라 일반 조인으로 취급 INNER 조인과 결과가 동일하다.
--where 절을 쓰니까?
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e LEFT OUTER JOIN emp m ON e.mgr =m.empno 
WHERE m.deptno=10;

SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e JOIN emp m ON e.mgr =m.empno 
WHERE m.deptno=10;


--오라클 OUTER JOIN
--오라클 OUTER JOIN 시 기준 테이블의 반대편 테이블의 모든 컬럼에 (+)를 붙여야
--정상적인 OUTER JOIN으로 동작한다
--한 컬럼이라도 (+)를 누락하면 INNER 조인으로 동작
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e , emp m
where e.mgr = m.empno(+) --데이터가 없는 컬럼에 (+)를 붙인다.
AND m.deptno = 10; -- m.deptno 컬럼에 (+)가 붙지않아 inner 조인으로 보이며 
--mgr의 데이터가 null값이여도 표시되야하는데 사라짐


--위 ORACLE OUTER 조인은 INNER 조인으로 동작 : m.deptno 컬럼에 (+)가 붙지않음
SELECT e.empno, e.ename, e.mgr , m.ename , e.deptno
FROM emp e , emp m
where e.mgr = m.empno(+) --데이터가 없는 컬럼에 (+)를 붙인다.
AND m.deptno(+) = 10;


-- 사원 - 매니저간 RIGHT OUTER JOIN
SELECT empno, ename, mgr
FROM emp e;

SELECT empno, ename, mgr
FROM emp m;

SELECT e.empno, m.ename, e.mgr
FROM emp e RIGHT OUTER JOIN emp m ON (e.mgr= m.empno);

SELECT e.empno, m.ename, e.mgr
FROM emp e , emp m
WHERE e.mgr(+) = m.empno;


--FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복 제거;
SELECT e.empno, e.ename, e.mgr , m.ename 
FROM emp e FULL OUTER JOIN emp m ON (e.mgr =m.empno);


--oracle outer join에서는 (+)기호를 이용하여 FULL outer 문법을 지원하지 않는다.


--outerjoin

SELECT d.buy_date, d.buy_prod, d.prod_id, n.prod_name, d.buy_qty
FROM buyprod d , buyprod n
WHERE d.buy_date(+) = n.prod_name;

--outerjoin 실습1
SELECT d.buy_date,d.buy_prod, p.prod_id, p.prod_name, d.buy_qty
FROM  buyprod d ,prod p
WHERE d.buy_prod(+) = p.prod_id 
AND d.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

SELECT b.buy_date,b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p ON (b.buy_prod = p.prod_id AND b.buy_date = TO_DATE('05/01/25', 'YY/MM/DD'));

--outerjoin 실습2
SELECT nvl(d.buy_date,TO_DATE('05/01/25','YY/MM/DD')),d.buy_prod, p.prod_id, p.prod_name, d.buy_qty
FROM  buyprod d ,prod p
WHERE d.buy_prod(+) = p.prod_id
AND d.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin 실습3

SELECT nvl(d.buy_date,TO_DATE('05/01/25','YY/MM/DD')),d.buy_prod, p.prod_id, p.prod_name, nvl(d.buy_qty,0)
FROM  buyprod d ,prod p
WHERE d.buy_prod(+) = p.prod_id
AND d.buy_date(+) = TO_DATE('05/01/25', 'YY/MM/DD');

--outerjoin 실습 4

SELECT c.pid, p.pnm, nvl(c.cid, 1), c.day, c.cnt
FROM cycle c , product p
WHERE c.pid(+) = p.pid
AND c.cid(+) = 1;

SELECT c.pid, p.pnm, nvl(c.cid, 1), c.day, c.cnt
FROM cycle c RIGHT OUTER JOIN product p ON(c.pid =p.pid AND c.cid=1);