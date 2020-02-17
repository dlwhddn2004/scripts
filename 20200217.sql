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
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -2), 'D') dd,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'iw') iw --주차
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD'))
GROUP BY DECODE(d,1,iw+1, iw) 
ORDER BY DECODE(d,1,iw+1, iw);

--1. 해당 월의 1일자가 속한 주의 일요일 구하기
--2. 해당 월의 마지막 일자가 속한 주의 토요일 구하기
--3.  2-1을 이용하여 총 일수 구하기