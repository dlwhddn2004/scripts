--�Լ� (date) ����ȯ
-- ����ȯ(DATE ->CHARACTER) : TO_CHAR(DATE,'����')
-- ����ȯ(CHARACTER -> DATE) : TO_DATE(��¥ ���ڿ�, '����')

--DATE FORMAT
--YYYY :4�ڸ� �⵵ 
--MM   :2�ڸ� ��
--DD   :2�ڸ� ����
--D    :�ְ� ����(1~7)
--IW   :����(1~53)
--HH,HH12: 2�ڸ� �ð�(12�ð� ǥ��)
--HH24:2�ڸ� �ð�(24�ð� ǥ��)
--MI : 2�ڸ� ��
--SS : 2�ڸ� ��

--emp ���̺��� hiredate (�Ի�����) �÷��� ����� �� :��: ��
SELECT ename, hiredate, 
        TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS'),--����
        TO_CHAR(hiredate +1, 'YYYY-MM-DD HH24:MI:SS'), -- +1��
        TO_CHAR(hiredate +1/24, 'YYYY-MM-DD HH24:MI:SS'), -- + 1�ð�
        --hiredate�� 30���� ���Ͽ� TO_CAHR�� ǥ��
        TO_CHAR(hiredate +(1/24/60)*30, 'YYYY-MM-DD HH24:MI:SS') -- 1/24/2 �� ���� ,1/48�� �Ǵ���..
FROM emp; 
    
    SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
            TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
            TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
    FROM dual;
    

--MONTHS BETWEEN (DATE, DATE)
--���ڷ� ���� �� ��¥ ������ �������� ����
    SELECT ename, hiredate,
            MONTHS_BETWEEN (sysdate, hiredate),
            MONTHS_BETWEEN (TO_DATE('2020.01.17', 'YYYY.MM.DD'), hiredate)            
    FROM EMP
    WHERE ename='SMITH';
    
--ADD_MONTHS (DATE, ����-������(���ϰų� ��) ������)
SELECT 
        ADD_MONTHS (SYSDATE, 5), --2020/01/29 -> 2020/06/29
        ADD_MONTHS (SYSDATE, -5) --2020/01/29 -> 2019/08/29
FROM dual;


--NEXT_DAY(DATE, �ְ�����), ex: NEXT_DAY(SYSDATE, 5) --> sysdate ���� ó�� �����ϴ� �ְ����� 5�� �ش��ϴ� ����
--                              SYSDATE 2020/01/29 (��) ���� ó�� �����ϴ� 5 (��)���� --> 2020/01/30(��)
SELECT NEXT_DAY(SYSDATE, 5)
FROM dual;

--LAST_DAY(DATE) DATE ���� ���� ������ ���ڸ� ����
SELECT LAST_DAY(SYSDATE) --SYSDATE 2020/01/29 --> 2020/01/31
FROM dual;


--LAST_DAY�� �������ڷ� ���� date�� ���� ���� ������ ���ڸ� ���Ҽ� �ִµ�
--DATE�� ù��° ���ڴ� ��� ���ұ�?
SELECT SYSDATE,
        LAST_DAY(SYSDATE),
       ADD_MONTHS(LAST_DAY(SYSDATE)+1, -1),
        TO_CHAR(SYSDATE, 'YYYY-MM') || '-01',
        TO_DATE(TO_DATE('01','DD'),
        TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM'),'YYYY-MM') || '-01', 'YYYY-MM-DD')
        
FROM dual;


--hiredate ���� �̿��Ͽ� �ش� ���� ù��° ���ڷ� ǥ��
SELECT ename, hiredate, 
    ADD_MONTHS(LAST_DAY(hiredate)+1 , -1)
FROM emp;


-- empno�� NUMBER Ÿ��, ���ڴ� ���ڿ�
-- Ÿ���� ���� �ʱ� ������ ������ ����ȯ�� �Ͼ
-- ���̺� �÷��� Ÿ�Կ� �°� �ùٸ� ���� ���� �ִ°� �߿�
SELECT *
FROM emp
WHERE empno= '7369';

SELECT *
FROM emp
WHERE empno= 7369; --�� ��Ȯ�� ǥ�� �÷��� Ÿ�Կ� �°�


--hiredate �� ��� date Ÿ��, ���ڴ� ���ڿ��� �־����� ������ ������ ����ȯ�� �߻�
--��¥ ���ڿ� ���� ��¥ Ÿ������ ��������� ����ϴ� ���� ����
SELECT *
FROM emp
WHERE hiredate = '1980/12/17';

SELECT *
FROM emp
WHERE hiredate = TO_DATE('1980/12/17', 'YYYY/MM/DD');


EXPLAIN PLAN FOR --�����ȹ 
SELECT *
FROM emp
WHERE empno ='7369'; -- 1 - filter("EMPNO"=7369) ������ ���ڷ� �Ǿ��ִµ� ������ ����ȯ�� ��

SELECT *
FROM emp
WHERE TO_CHAR(empno)='7369'; -- ���ڿ��� �°� ����ȯ 

SELECT *
FROM table(dbms_xplan.display); -- ����Ŭ���� �����ϴ� �����ȹ (������ �Ʒ��� �а� �ڽ�Ÿ���������� �ڽ��� ���� �д´�.)



--���ڸ� ���ڿ��� �����ϴ� ���
--õ���� ������
-- 1000 �̶�� ���ڸ�
--�ѱ� : 1,000.50
--���� : 1.000,50

--emp sal �÷�(NUMBER Ÿ��)�� ������
-- 9 : ����
-- 0 : ���� �ڸ� ����(0���� ǥ��)
-- L : ��ȭ ����
SELECT ename, sal, TO_CHAR(sal, 'L0,999')
FROM emp;



--NULL�� ���� ������ ����� �׻� NULL
-- emp ���̺��� sal �÷����� null ����Ź �������� ����(14���� �����Ϳ� ����)
-- emp ���̺��� comm �÷����� null �����Ͱ� ���� (14���� �����Ϳ� ����)
-- sal + comm --> comm�� null�� �࿡ ���ؼ��� ��� null�� ����
-- �䱸���� : comm�� null �̸� sal�÷��� ���� ��ȸ
-- �䱸������ ���� ��Ű�� ���Ѵ� -> sw������ [����]


--  NVL (Ÿ��, ��ü��)
--Ÿ���� ���� NULL�̸� ��ü���� ��ȯ�ϰ� 
--Ÿ���� ���� NULL�� �ƴϸ� Ÿ�� ���� ��ȯ

--  if (Ÿ�� == null )
--      return ��ü��;
--  else 
--      return Ÿ��;
SELECT ename , sal, comm, NVL(comm,0), 
        sal+ NVL(comm,0),
        NVL(sal+comm, 0)
FROM emp;



--NVL2 (exr1, expr2, expr3)
-- if(expr1 != null)
--        return expr2;
--else
--          return expr3;

SELECT ename, sal, comm , NVL2(comm, 10000, 0)

FROM emp;



--     NULLIF(expr1, exrp2)
-- if(expr1 == expr2)
--      return null;
--else
--      return expr1;
-- sal 1250�� ����� null�� ����, 1250�� �ƴ� ����� sal�� ����
SELECT ename, sal, comm, NULLIF(sal, 1250) 
FROM emp;


--��������
--COALESCE ���� �߿� ���� ó������ �����ϴ� NULL�� �ƴ� ���ڸ� ��ȯ

--COALESCE (expr1, expr2, ...)
--   if(expr1 != null)
--          return expr1;
--      else
--  return COALESCE (expr2, expr3....);


--COALESCE(comm, sal) : comm�� null �� �ƴϸ� comm
--                   : comm�� null �̸� sal (��, sal �÷��� ���� null�� �ƴҶ�)
SELECT ename, sal, comm, COALESCE(comm,sal)
FROM emp;

SELECT empno, ename, mgr, NVL(mgr, 9999) MGR_N,
                        NVL2(mgr,mgr, 9999 ) MGR_N1, --(a,b,c) : a == null �̸� c ��ȯ , a != �̸� b ��ȯ
                        COALESCE(mgr, 9999) MGR_N2 
FROM emp;


-- null �ǽ� fn5
SELECT userid, usernm,reg_dt,  NVL(reg_Dt,sysdate) n_reg_dt
FROM users
WHERE userid != 'brown';


--condition : ������
--case : JAVA�� if - else if - else 

-- CASE
--      WHEN ���� THEN ���ϰ� 1
--      WHEN ����2 THEN ���ϰ� 2
--      ELSE  �⺻��
--  END
--emp ���̺��� job �÷��� ���� SALSEMAN �̸� SAL * 1.05 ����,
--                               MANAGER �̸� SAL * 1.1 ����,
--                               PRESIDENT �̸� SAL * 1.2 ����
--                              �׹��� ������� SAL �� ����

SELECT ename, job, sal,
        CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.1
            WHEN job = 'PRESIDENT' THEN sal * 1.2
                else sal
        end as bonus_sal
FROM emp;

--DECODE �Լ� : CASE ���� ����
--(�ٸ��� CASE �� : WHEN ���� ���Ǻ񱳰� �����Ӵ�
--        DECODE �Լ� : �ϳ��� ���� ���ؼ� = �񱳸� ���
--DECODE �Լ� : �������� (������ ������ ��Ȳ�� ���� �þ ���� ����)
--DECODE(coi | expr, ù��° ���ڿ� ���� ��1, ù��° ���ڿ� �ι�° ���ڰ� ���� ��� ��ȯ ��,
--                   ù��° ���ڿ� ���� ��2, ù��° ���ڿ� �׹�° ���ڰ� ���� ��� ��ȯ ��....
--                      option - else ���������� ��ȯ�� �⺻��)

SELECT ename, job, sal,
    DECODE(job, 'SALESMAN',sal *1.05,
                'MANAGER', sal* 1.15,
                'PRESIDENT', sal* 1.2, sal) as bonus_sal
from emp;

--
SELECT ename, job, sal,
    CASE
        WHEN job = 'SALESMAN' OR sal >1400 THEN sal *1.05
        WHEN job = 'MANAGER' OR sal <1400 THEN sal *1.1
        WHEN job = 'PRESIDENT' THEN sal* 1.2
    else sal
    END bonus
FROM emp;


    --������� sql 1400 ũ�� 1.05���� , ������ ����1.1, �Ŵ����� 1.1 ,����� 1.2 �׹� sal
SELECT ename, job, sal,
    DECODE(job, 'SALEMAN', case WHEN sal>1400 THEN sal*1.05 WHEN sal <1400 THEN sal *1.1 else sal END,
                'MANAGER',  Sal*1.15,
                'PRESIDENT', sal*1.2) bonus
    FROM emp;
              
                    