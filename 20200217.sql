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
        TO_CHAR(TO_DATE(:dt, 'YYYYMM') +(LEVEL -1), 'iw') iw --����
        
FROM dual
CONNECT BY level <= TO_CHAR(LAST_DAY(TO_DATE(:dt, 'YYYYMM')),'DD'))
GROUP BY DECODE(d,1,iw+1, iw) 
ORDER BY DECODE(d,1,iw+1, iw);

--1. �ش� ���� 1���ڰ� ���� ���� �Ͽ��� ���ϱ�
--2. �ش� ���� ������ ���ڰ� ���� ���� ����� ���ϱ�
--3.  2-1�� �̿��Ͽ� �� �ϼ� ���ϱ�

--20200401==> 2020329(�Ͽ���)
--20200430==> 2020502(�Ͽ���)
--������ ���ڷ� ǥ���� �� �ִ�.
--������ 7��(1~7)


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

--�ϵ��ڵ�
SELECT TO_DATE ('202002','yyyymm') + (LEVEL -1)
FROM dual
CONNECT BY LEVEL <= 29;


--����: �������ڰ� : �ش���� 1���ڰ� ���� ���� �Ͽ���
--     ��������¥ : �ش���� ���������ڰ� ���� ���� �����
SELECT TO_DATE ('20200126','yyyymmdd') + (LEVEL -1)
FROM dual
CONNECT BY LEVEL <= 35;

SELECT TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')),'D'))
                            -(TO_DATE(:dt, 'yyyymm') - (TO_CHAR(TO_DATE(:dt,'yyyymm'),'D'))) daycnt
                            FROM dual;
--------------------------------------------------------------
�������� 1��~������;
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
 

1���ڰ� ���� ���� �Ͽ��ϱ��ϱ�
���������ڰ� ���� ���� ����ϱ� �ϱ�
�ϼ� ���ϱ�; 
SELECT 
        TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D') -1) st,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D')) ed,
        LAST_DAY(TO_DATE(:dt, 'yyyymm')) + (7- TO_CHAR(LAST_DAY(TO_DATE(:dt, 'yyyymm')), 'D'))
                      - ( TO_DATE(:dt, 'yyyymm') - ( TO_CHAR(TO_DATE(:dt, 'yyyymm'), 'D'))) daycnt
FROM dual;      


1����, �����ڰ� ���� �������� ǥ���� �޷�;
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
                
--�������� Ǫ�� ��� ----------------------------
1. dt(����) ==> �� , �������� SUM(SALES) ==> ���� ����ŭ ���� �׷��� �ȴ�.
    SELECT TO_CHAR(dt,'MM'), SUM(SALES) sales
    
    FROM sales
    GROUP BY TO_CHAR(dt, 'MM');
    
---------==>
SELECT NVL(SUM(jan),0) jan, NVL(SUM(FEB),0),
       NVL(SUM(MAR),0), SUM(NVL(jan,0)), --NVL�� ���߿� ���� SUM�� ���߿� ���� ��������� �ٸ��� 
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
        
--�������� 

create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;
        
SELECT *
FROM dept_h;

--����Ŭ ������ ���� ����
--SELECT ....
--FROM....
--WHERE
--START WITH ���� : � ���� ���������� ���� ��
--
--CONNECT BY ��� ���� �����ϴ� ����
--        [Ű����] PRIOR : �̹� ���� ��
--                 "   " : ������ ���� ��


------------
--����� : �������� �ڽĳ��� ���� (�� ==> �Ʒ�)
--xxȸ��(�ֻ�������)���� �����Ͽ� ���� �μ��� �������� ���� ����
SELECT *
FROM dept_h
START WITH deptcd = 'dept0' --�ϰ�� cd = �ڵ�
                        --START WITH deptnm = 'XXȸ��' �ϰ��
                        --START WITH P_DEPTCD = IS NULL �ϰ��
CONNECT BY PRIOR deptcd = p_deptcd;-- ��� ���� ���� ���� (PRIOR XXȸ�� - 3���� ��(������,������ȹ,�����ý���)

--PRIOR XXȸ��.deptcd = �����κ�.p_deptcd ->
--PRIOR �����κ�.p_deptcd = ��������.p_deptcd ->
--PRIOR ��������.p_deptcd / ���̻� �� �����μ��� ������ ���������� ����

--PRIOR XXȸ��.deptcd = ������ȹ��.p_deptcd
--PRIOR ������ȹ��.deptcd = ��ȹ��.p_deptcd
--PRIOR ��ȹ��.deptcd = ��ȹ��Ʈ.p_deptcd

--PRIOR XXȸ��.deptcd = �����ý��ۺ�.p_deptcd (����1��,����2��)
--PRIOR ���������ۺ�.deptcd = ����1��.p_deptcd
--PRIOR ����1��.deptcd !=.....
--PRIOR ���������ۺ�.deptcd = ����2��.p_deptcd
--PRIOR ����2��.deptcd != .....

--lpad �μ���(deptnm)������ �׽�Ʈ
SELECT LPAD(' ', 4 ,'*')
FROM dual;

SELECT dept_h.* , LEVEL, deptnm ,lpad(' ', (LEVEL-1)*4, ' ') || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--PRIOR �� �÷� �տ� �д�. �׸��� �ܹ߼��̾ƴϰ� �߰��� ��� ������ �Ҽ� �ִ�. AND �� �̿�~

--h_2
SELECT *
FROM dept_h
START WITH deptcd ='dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h
START WITH deptnm ='�����ý��ۺ�'
CONNECT BY PRIOR deptcd = p_deptcd;