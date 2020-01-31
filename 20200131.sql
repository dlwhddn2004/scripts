SELECT ename, deptno
FROM emp;

SELECT *
FROM dept;

--JOIN 두 테이블을 연결하는 작업 NULL 끼리는 조인 안됨
--JOIN 문법
-- 1. ANSI 문법
-- 2. ORACLE 문법

--Natural Join
--두 테이블간 컬럼명이 같을 때 해당 컬럼으로 연결(조인)
--emp, dept 테이블에는 deptno 라는 컬럼이 존재


SELECT *
FROM emp NATURAL JOIN dept;

SELECT emp.empno , emp.ename , dept.dname
FROM  emp NATURAL JOIN dept;

-- Natural join에 사용된 조언 컬럼(deptno)는 한정자(ex : 테이블명, 테이블 별칭)을 사용하지 않고
--컬럼명만 기술한다 (dept.deptno --> deptno)
SELECT emp.empno , emp.ename , dept.dname, deptno
FROM  emp NATURAL JOIN dept;

--테이블에 대한 별칭도 사용가능
SELECT  e.empno , e.ename , d.dname, deptno
FROM emp e NATURAL JOIN dept d;


--ORACLE JOIN
--FROM 절에 조인할 테이블 목록을 ,로 구분하여 나열한다.
--조인할 테이블의 연결조건을 WHERER절에 기술한다.
--emp, dept 테이블에 존재하는 deptno 컬럼이 [같을때] 조인
SELECT emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT emp.ename, dept.dname -- emp.ename 는 14 dept.dname 4개 1개당 1개가 부정이므로 14 x 3
FROM emp, dept
WHERE emp.deptno != dept.deptno;


--오라클 조인의 테이블 별칭

SELECT e.empno , e.ename, d.dname, e.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;

--ANSI : Join with using
--조인하려는 두개의 테이블에 이름이 같은 컬럼이 두개지만 
--하나의 컬럼으로만 조인을 하고자 할때 
--조인하려는 기준 컬럼을 기술
-- emp, dept 테이블의 공통 컬럼 : deptno

SELECT emp.ename, dept.dname, deptno
FROM emp JOIN dept USING(deptno);

--JOIN WITH using을 ORACLE로 표현하면?
SELECT emp.ename, dept.dname, dept.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- ANSI : JOIN WITH ON
-- 조인 하려고 하는 테이블의 컬럼 이름이 서로 다를때
SELECT emp.ename, dept.dname, emp.deptno
FROM emp JOIN dept on (emp.deptno = dept.deptno);


--JOIN with on --> oracle 로 표현한다면
SELECT emp.ename, dept.dname, emp.deptno
FROM emp , dept
WHERE emp.deptno = dept.deptno;


--SELF JOIN : 같은 테이블간의 조인;
--emp 테이블에서 관리되는 사원의 관리자 사번을 이용하여 
--관리자 이름을 조회할때

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno); --사원의 매니저 코드 와 매니저의 empno번호

-- SELF JOIN 을 오라클 문법으로 한다면?
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--equal 조인 : = (컬럼이 같을때)
--non-equal 조인 : !=, > , <, BETWEEN AND

--사원의 급여 정보와 급여 등급 테이블을 이용하여 해상 사원의 급여 등급을 구해보자
SELECT ename , sal 
FROM emp;

SELECT *
FROM salgrade;

SELECT ename, sal , s.grade
FROM  emp e, salgrade s
WHERE  e.sal BETWEEN s.losal AND s.hisal; -- emp 의 sal 값과 salgrade의  losal ~ hisal 비교하여 salgrade의 등급을 나타낸다

--ANSI 문법을 이용하여 위의 조인 문을 작성;
SELECT ename, sal , s.grade
FROM emp e JOIN salgrade s ON(e.sal BETWEEN s.losal AND s.hisal);

--join 실습 0.0

SELECT *
FROM emp;

SELECT *
FROM dept;


SELECT e.empno, e.ename, d.deptno ,d.dname
FROM emp e, dept d
WHERE e.deptno = d. deptno
ORDER BY deptno;
--조인 실습 0.1
SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.deptno IN (10,30);

--조인 실습 0.2


SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500
ORDER BY sal desc;

SELECT e.empno, e.ename, e.sal, deptno, d.dname
FROM emp e JOIN dept d using(deptno)
WHERE e.sal > 2500;

--조인 실습 0.3 
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno AND e.sal > 2500 AND e.empno> 7600;

--조인 실습 0.4
SELECT e.empno, e.ename, e.sal, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
             AND e.sal > 2500 
             AND e.empno> 7600 
             AND d.dname = 'RESEARCH';

--조인실습 1
--PROD : PROD_LGU
--LPROD : LPROD_GU
SELECT *
FROM prod;

select *
FROM lprod;
--ex모델 
SELECT p.prod_LGU , lp.LPROD_NM , p.PROD_ID, p.PROD_NAME
FROM prod p , lprod lp
WHERE p.prod_LGU = lp.lprod_GU;
    
--조인 실습 2
SELECT b.buyer_id, b.buyer_name,p.prod_id, p.PROD_NAME
FROM prod p, buyer b
WHERE p.prod_buyer =b.buyer_id;  

--조인 3번 과제
SELECT m.mem_id, m.mem_name, p.prod_id, p.prod_name,c.cart_qty
FROM member m, cart c, prod p
WHERE m.mem_id = c.cart_member and c.cart_prod = p.prod_id;

