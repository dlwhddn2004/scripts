--�޷� ��ȭ�����
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
--dt ==> 202002�� ����
(SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'D') d
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD')); 

---------------------------------------------------------
--java ���� �۾� ���� alt +shift + a

SELECT iw,
       MIN(DECODE(d,1,dt)) sun,
       MIN(DECODE(d,2,dt)) mon,
        MIN(DECODE(d,3,dt)) tue,
        MIN(DECODE(d,4,dt)) wed,
        MIN(DECODE(d,5,dt)) tur,
        MIN(DECODE(d,6,dt)) fri,
        MIN(DECODE(d,7,dt)) sat
FROM 
--dt ==> 202002�� ����
(SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'iw') iw --����
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD'))
GROUP BY iw
ORDER BY iw;
--������ SUN�κ��� ��ĭ ���οö�����
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
--dt ==> 202002�� ����
(SELECT TO_DATE(:dt, 'YYYYMM') + (LEVEL-1) dt,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'D') d,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -2), 'D') dd,
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'iw') iw --����
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD'))
GROUP BY DECODE(d,1,iw+1, iw) 
ORDER BY DECODE(d,1,iw+1, iw);

--1. �ش� ���� 1���ڰ� ���� ���� �Ͽ��� ���ϱ�
--2. �ش� ���� ������ ���ڰ� ���� ���� ����� ���ϱ�
--3.  2-1�� �̿��Ͽ� �� �ϼ� ���ϱ�