--달력 월화수목금
SELECT TO_DATE('202002','YYYYMM')+ (LEVEL-1),
        TO_CHAR(TO_DATE('202002','YYYYMM')+ (LEVEL-1), 'D'),
        DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                1, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) s,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                2, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) m,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                3, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) t,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                4, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) w,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                5, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) t2,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                6, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) f,
                 DECODE(TO_CHAR(TO_DATE('202002','YYYYMM')+(LEVEL-1), 'D'),
                7, TO_DATE('202002', 'YYYYMM')+(LEVEL-1)) s2
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE ('202002','YYYYMM')), 'DD');



SELECT dt,d,
        DECODE(d,1,dt) sun,
        DECODE(d,2,dt) mon,
        DECODE(d,3,dt) tue,
        DECODE(d,4,dt) wed,
        DECODE(d,5,dt) tur,
        DECODE(d,6,dt) fri,
        DECODE(d,7,dt) sat
        
FROM 
--dt ==> 202002라 가정
(SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'D') d
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD')); 

---------------------------------------------------------
--java 세로 작업 수정 alt +shift + a

SELECT iw,
       MIN(DECODE(d,1,dt)) sun,
       MIN(DECODE(d,2,dt)) mon,
        MIN(DECODE(d,3,dt)) tue,
        MIN(DECODE(d,4,dt)) wed,
        MIN(DECODE(d,5,dt)) tur,
        MIN(DECODE(d,6,dt)) fri,
        MIN(DECODE(d,7,dt)) sat
FROM 
--dt ==> 202002라 가정
(SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'iw') iw --주차
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD'))
GROUP BY iw
ORDER BY iw;
--주차가 SUN부분이 한칸 위로올라가있음
----------------------------------------------------
SELECT DECODE(d,1,iw+1, iw) i,
       MIN(DECODE(d,1,dt)) sun,
       MIN(DECODE(d,2,dt)) mon,
        MIN(DECODE(d,3,dt)) tue,
        MIN(DECODE(d,4,dt)) wed,
        MIN(DECODE(d,5,dt)) tur,
        MIN(DECODE(d,6,dt)) fri,
        MIN(DECODE(d,7,dt)) sat
        
FROM 
--dt ==> 202002라 가정
(SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL-1) dt,
        
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'iw') iw --주차
        
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD'))
GROUP BY DECODE(d,1,iw+1, iw) 
ORDER BY DECODE(d,1,iw+1, iw);

--1. 해당 월의 1일자가 속한 주의 일요일 구하기
--2. 해당 월의 마지막 일자가 속한 주의 토요일 구하기
--3.  2-1을 이용하여 총 일수 구하기

--20200401==> 2020329(일요일)
--20200430==> 2020502(일요일)
--요일을 숫자로 표현할 수 있다.
--일주일 7개(1~7)


SELECT TO_DATE('20200401','YYYYMMDD')
FROM dual;



SELECT DECODE(d,1,iw+1,iw) iw,
       MIN(DECODE(d,1,dt)) sun,
       MIN(DECODE(d,2,dt)) mon,
       MIN(DECODE(d,3,dt)) tue,
       MIN(DECODE(d,4,dt)) wed,
       MIN(DECODE(d,5,dt)) tur,
       MIN(DECODE(d,6,dt)) fri,
       MIN(DECODE(d,7,dt)) sat
FROM
(SELECT TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1) + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1) + (LEVEL-1),'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D')-1) + (LEVEL-1),'iw') iw
FROM dual
CONNECT BY LEVEL <=  LAST_DAY(TO_DATE(:dt,'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D')) 
        -(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'),'D'))))
GROUP BY DECODE(d,1,iw+1,iw)
ORDER BY iw;

--하드코딩
SELECT TO_DATE ('202002','yyyymm') + (LEVEL -1)
FROM dual
CONNECT BY LEVEL <= 29;


--변경: 시작일자가 : 해당월의 1일자가 속한 주의 일요일
--     마지막날짜 : 해당월의 마지막일자가 속한 주의 토요일
SELECT TO_DATE ('20200126','yyyymmdd') + (LEVEL -1)
FROM dual
CONNECT BY LEVEL <= 35;

SELECT TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D'))
                            -(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D'))) daycnt
                            FROM dual;
--------------------------------------------------------------
원본쿼리 1일~말일자;
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm')  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  TO_CHAR(last_day(to_date(:dt,'yyyymm')), 'DD'))
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 

1일자가 속한 주의 일요일구하기
마지막일자가 속한 주의 토요일구 하기
일수 구하기; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      


1일자, 말일자가 속한 주차까지 표현한 달력;
SELECT DECODE(d, 1, iw+1, iw) i,
       MIN(DECODE(d, 1, dt)) sun,
       MIN(DECODE(d, 2, dt)) mon,
       MIN(DECODE(d, 3, dt)) tue,
       MIN(DECODE(d, 4, dt)) wed,
       MIN(DECODE(d, 5, dt)) tur,
       MIN(DECODE(d, 6, dt)) fri,
       MIN(DECODE(d, 7, dt)) sat
FROM 
(SELECT TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) + (level-1) dt,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1)  + (LEVEL-1), 'iw') iw
 FROM dual
 CONNECT BY LEVEL <=  last_day(to_date(:dt,'yyyymm'))+(7-to_char(last_day(to_date(:dt,'yyyymm')),'D'))
                    -to_date(:dt,'yyyymm')-(to_char(to_date(:dt,'yyyymm'),'D')-1)  )
 GROUP BY DECODE(d, 1, iw+1, iw)
 ORDER BY DECODE(d, 1, iw+1, iw);
 
 create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT *
FROM sales;

SELECT 
        
        MIN(DECODE(d, 1, s)) JAN,
       MIN(DECODE(d, 2, s)) FEB,
       NVL(MIN(DECODE(d, 3, s)),0) MAR,
       MIN(DECODE(d, 4, s)) APR,
       MIN(DECODE(d, 5, s)) MAY,
       MIN(DECODE(d, 6, s)) JUN
       
       FROM (SELECT TO_CHAR(dt, 'MM') d, SUM(sales) s
                     FROM    sales
                GROUP BY TO_CHAR(dt, 'MM'));
                
--선생님이 푸신 방법 ----------------------------
1. dt(일자) ==> 월 , 월단위별 SUM(SALES) ==> 월의 수만큼 행이 그룹핑 된다.
    SELECT TO_CHAR(dt,'MM'), SUM(SALES) sales
    
    FROM sales
    GROUP BY TO_CHAR(dt, 'MM');
    
---------==>
SELECT NVL(SUM(jan),0) jan, NVL(SUM(FEB),0),
       NVL(SUM(MAR),0), SUM(NVL(jan,0)), --NVL를 나중에 쓸지 SUM을 나중에 쓸지 실행과정이 다르다 
       NVL(SUM(APR),0),NVL(SUM(MAY),0),
       NVL(SUM(JUN),0)
FROM
(SELECT DECODE(TO_CHAR(dt,'MM'), '01',SUM(sales)) JAN,
        DECODE(TO_CHAR(dt,'MM'), '02',SUM(sales)) FEB,
        DECODE(TO_CHAR(dt,'MM'), '03',SUM(sales)) MAR,
        DECODE(TO_CHAR(dt,'MM'), '04',SUM(sales)) APR,
        DECODE(TO_CHAR(dt,'MM'), '05',SUM(sales)) MAY,
        DECODE(TO_CHAR(dt,'MM'), '06',SUM(sales)) JUN
        FROM sales
        GROUP BY TO_CHAR(dt,'MM'));
        
--계층쿼리 

create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;
        
SELECT *
FROM dept_h;

--오라클 계층형 쿼리 문법
--SELECT ....
--FROM....
--WHERE
--START WITH 조건 : 어떤 행을 시작점으로 삼을 지
--
--CONNECT BY 행과 행을 연결하는 기준
--        [키워드] PRIOR : 이미 읽은 행
--                 "   " : 앞으로 읽을 행


------------
--하향식 : 상위에서 자식노드로 연결 (위 ==> 아래)
--xx회사(최상위조직)에서 시작하여 하위 부서로 내려가는 계층 쿼리
SELECT *
FROM dept_h
START WITH deptcd = 'dept0' --일경우 cd = 코드
                        --START WITH deptnm = 'XX회사' 일경우
                        --START WITH P_DEPTCD = IS NULL 일경우
CONNECT BY PRIOR deptcd = p_deptcd;-- 행과 행의 연결 조건 (PRIOR XX회사 - 3가지 부(디자인,정보기획,정보시스템)

--PRIOR XX회사.deptcd = 디자인부.p_deptcd ->
--PRIOR 디자인부.p_deptcd = 디자인팀.p_deptcd ->
--PRIOR 디자인팀.p_deptcd / 더이상 할 하위부서가 없으니 실질적으로 종료

--PRIOR XX회사.deptcd = 정보기획부.p_deptcd
--PRIOR 정보기획부.deptcd = 기획팀.p_deptcd
--PRIOR 기획팀.deptcd = 기획파트.p_deptcd

--PRIOR XX회사.deptcd = 정보시스템부.p_deptcd (개발1팀,개발2팀)
--PRIOR 정보스시템부.deptcd = 개발1팀.p_deptcd
--PRIOR 개발1팀.deptcd !=.....
--PRIOR 정보스시템부.deptcd = 개발2팀.p_deptcd
--PRIOR 개발2팀.deptcd != .....

--lpad 부서명(deptnm)가지고 테스트
SELECT LPAD(' ', 4 ,'*')
FROM dual;

SELECT dept_h.* , LEVEL, deptnm ,lpad(' ', (LEVEL-1)*4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--PRIOR 은 컬럼 앞에 둔다. 그리고 단발성이아니고 추가로 계속 연결을 할수 있다. AND 를 이용~

--h_2
SELECT *
FROM dept_h
START WITH deptcd ='dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h
START WITH deptnm ='정보시스템부'
CONNECT BY PRIOR deptcd = p_deptcd;