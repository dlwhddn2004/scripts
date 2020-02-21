SET SERVEROUTPUT ON;
--실습 1
CREATE OR REPLACE PROCEDURE registdept_test 
(p_deptno IN dept_test.deptno%TYPE,
  p_dname IN dept_test.dname%TYPE,
    p_loc IN dept_test.loc%TYPE) IS -- is 앞은 선언부 라고 생각하면됨(declare 생략가능하니 문제 파악하기)

 BEGIN
   INSERT INTO dept_test  values (p_deptno, p_dname, p_loc,0);
   COMMIT;
   END;
   /
   
  exec registdept_test(99,'ddit','daejeon');

--실습 2
CREATE OR REPLACE PROCEDURE UPDATdept_test 
    (p_deptno IN dept_test.deptno%TYPE,
    p_dname IN dept_test.dname%TYPE,
    p_loc IN dept_test.loc%TYPE) IS
    
    BEGIN
    UPDATE dept_test SET dname = p_dname, loc = p_loc
    WHERE  deptno =p_deptno; --업데이트 조건 예를들면 deptno가 p_deptno 일때 다 넣는거라고보면된다
    
    COMMIT;
    END;
    /
    
exec UPDATdept_test (99,'ddit_m','daejeon');

SELECT *
FROM dept_test;


--복합변수 %rowTYPE : 특정 테이블의 행의 모든 컬럼을 저장 할 수 있는 변수
--사용 방법 : 변수명 테이블명%ROWTPYE

DECLARE
    v_dept_row dept%ROWTYPE; --복합변수를 사용하려면 타입을 %rowTYPE
    BEGIN
    SELECT * INTO v_dept_row
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ',' || v_dept_row.dname ||','|| v_dept_row.loc);
    END;
    /


--복합변수 RECORD
--개발자가 직접 여러개의 컬럼을 관리 할 수 있는 타입을 생성하는 명령
--JAVA를 비유하면 클래스를 선언하는 과정
--인스턴스를 만드는 과정은 변수선언
문법
TYPE 타입이름 (개발자가 지정) 
    IS RECORD ( 변수명1 변수타입,
                변수명2 변수타입....)
    
    변수명 타입이름;
        
DECLARE
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname VARCHAR2(14));
        
    v_dept_row dept_row; --dept_row(위에 선정한것처럼 타입이름)
    
    BEGIN
        SELECT deptno, dname INTO v_dept_row
        FROM dept
        WHERE deptno=10;
    
        DBMS_OUTPUT.PUT_LINE(v_dept_row.deptno || ','|| v_dept_row.dname);
    END;
/    


--table type 테이블 타입
--점: 스칼라 변수
--선: %ROWTYPE, record type
--면: table type

--    어떤 선을(%ROWTYPE, RECORD TYPE)을 지정할 수 있는지
--    인덱스 타입은 무엇인지;

--DEPT 테이블의 정보를 담을 수 있는 TABLE type을 선언
--기존에 배운 스칼라 타입, rowtype에서는 한 행의 정보를 담을 수 있었지만 (단일행OR 단일컬럼)
--table 타입 변수를 이용하면 여러행의 정보를 담을 수 있다.

--PL/SQL 에서는 자바와 다르게 배열에 대한 인덱스가 정수로 고정되어 있지 않고 
--문자열도 가능하다. 그래서 
TABLE 타입을 선언 할때는 인덱스에 대한 타입도 같이 명시
BINARY_INTEGER 타입은 PL/SQL에서만 사용 가능한 타입으로
NUMBER 타입을 이용하여 정수만 사용 가능하게 끔한 NUMBER 타입의 서브 타입이다.;


DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    --dept한행을 어려개담을수있는 타입이다 ,INDEX BY BINARY_INTEGER 정수를 파생시킨 타입
    v_dept_tab dept_tab;
    BEGIN
        SELECT * BULK COLLECT INTO v_dept_tab --BULK COLLECT INTO 여러행을 나타내는 문법
        FROM dept;
        --기존 스칼라변수,record 타입을 실습시에는 
        --한행만 조회 되도록 where절을 통해 제한하였다.
        
        --자바에서는 배열[인덱스 번호]
        --PL/SQL -> TABLE변수 (인덱스 번호)
        --DBMS_OUTPUT.PUT_LINE(v_dept_tab(1).deptno ||',' ||v_dept_tab(2).dname);
        
        --자바 for (int =0; i< 10; i++){};
        --pl/sql for i ON 1..테이블타입.count LOOP [나타낼값] END LOOP // .. 점 2개임
        --pl/sql 에서 count 는 자바에서 length
        for i IN 1..v_dept_tab.COUNT LOOP
         DBMS_OUTPUT.PUT_LINE(v_dept_tab(i).deptno ||',' ||v_dept_tab(i).dname);
        END LOOP;
    
    END;
    /
-----------------
--조건제어 IF
--문법
--    
--IF 조건문 THEN
--    실행문
--
--ELSIF 조건문 THEN
--    실행문
--ELSE
--    실행문;
--END IF;

DECLARE
    p NUMBER(1) :=2; --선언과 동시에 값을 대임
    
BEGIN
    IF p= 1 THEN
        DBMS_OUTPUT.PUT_LINE('1입니다');
    ELSIF p= 2 THEN
        DBMS_OUTPUT.PUT_LINE('2입니다');
    ELSE
        DBMS_OUTPUT.PUT_LINE('알려지지 않았습니다');
    END IF;
END;
/
----------
CASE 구문
1.일반 케이스 (JAVA의 switch와 유사)
2.검색 케이스 (JAVA의 if,else if,else)

--CASE expression --찾고자 하는 값
--    WHEN value THEN
--        실행문;
--    WHEN value THEN
--        실행문;
--    ELSE
--        실행문;
--END CASE; 

DECLARE --일반 케이스
    p NUMBER(2) := 4;
BEGIN
    CASE p
    WHEN 1 THEN
    DBMS_OUTPUT.PUT_LINE('1입니다');
    WHEN 2 THEN
    DBMS_OUTPUT.PUT_LINE('2입니다');
    ELSE
    DBMS_OUTPUT.PUT_LINE('모르는 값');
    END CASE;
END;
/

--아래코드 검색 케이스 WHEN 절에 다양하게 조건을 걸수 있음 WHEN P=1 AND~~~~
DECLARE
    p NUMBER(2) := 2;
BEGIN
    CASE p
    WHEN P=1 THEN
    DBMS_OUTPUT.PUT_LINE('1입니다');
    WHEN P=2 THEN
    DBMS_OUTPUT.PUT_LINE('2입니다');
    ELSE
    SBMS_OUTPUT.PUT_LINE('모르는 값');
    END CASE;
END;
/

--for loop문법
--FOR 루프변수/인덱스변수 IN [REVERSE] 시작값..종료값 LOOP
--    반복할 로직;
--END LOOP;

--1부터 5까지 FOR LOOP 반복문을 통해 숫자 출력
DECLARE 
BEGIN
    FOR i IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

실습 2~9단 까지의 구구단을 출력;

DECLARE
       BEGIN
        FOR i IN 2..9 LOOP
            FOR j IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(i || '*' || j ||'='|| i*j);
            END LOOP;
        END LOOP;
    END;
/

--while loop 문법
--WHERE 조건 LOOP
--    반복실행할 로직;
--    END LOOP;
    
DECLARE
    i number := 0;
    BEGIN
        WHILE i <= 5 LOOP  
        DBMS_OUTPUT.PUT_LINE(i);
        i := i+1;
        END LOOP;
    END;
/

------------
--LOOP문 문법 ==> JAVA의 while(true)

--LOOP
--    반복실행할 문자;
--    EXIT WHEN 조건 -- 자바의 break;
--END LOOP ;

DECLARE
     i NUMBER := 0;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        EXIT WHEN i >5;
         i := i+1;
    END LOOP;
    END;
    /












    