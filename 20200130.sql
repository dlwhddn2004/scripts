-- DECODE�ȿ� case�� decode ������ ��ø ����
SELECT ename, job, sal,
        DECODE(job, 'SALESMAN', CASE
                                WHEN sal > 1400 THEN sal *1.05
                                WHEN sal < 1400 THEN sal * 1.1
                                END,
                     'MANAGER' , sal *1.1,
                     'PRESIDENT', sal * 1.2,
                     sal ) bonus_sal
    FROM emp;
    
--codition �ǽ� 1
SELECT empno, ename, 
    CASE 
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALSES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        else 'DDIT'
        END DNAME
    FROM emp;
    
    SELECT empno, ename,
    DECODE(deptno, 10, 'ACCOUNTING', 20 , 'RESEARCH', 30, 'SALSES', 40,'OPERATIONS', 'DDIT' ) DNAME
    FROM emp;
    
--cond2
--���س⵵�� ¦���̸�
--�Ի�⵵�� ¦���� �� �ǰ����� �����
--�Ի�⵵�� Ȧ���� �� �ǰ����� ������

--���س⵵�� Ȧ���̸�
--�Ի�⵵�� ¦���� �� �ǰ����� ������
--�Ի�⵵�� Ȧ���� �� �ǰ����� �����
    SELECT empno, ename, hiredate,
        CASE
            WHEN MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2)=MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2)
            THEN '�ǰ����������'  
            WHEN MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2)!= MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2)
            THEN '�ǰ���������'
            END CONTACT_TO_DOCTOR
        FROM emp;
        
    SELECT empno, ename, hiredate,      
DECODE(MOD(TO_NUMBER(TO_CHAR(hiredate, 'YYYY')),2),
        MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2),'�ǰ����������', '�ǰ�����������') ����
        FROM emp;
        
-- DATE Ÿ�� -> ���ڿ�(�������� ����, YYYY-MM-DD HH24:MI:SS)
SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY'))
FROM dual;


------�׷� �Լ� GROUP BY ���� ���� ����
-- �μ���ȣ�� ���� ROW ���� ���� ��� : GROUP BY deptno
-- �������� ���� ROW ���� ���� ��� : GROUP BY job 
-- mgr�� ���� �������� ���� ROW ���� ���� ��� : GROUP BY mgr, job

--�׷� �Լ��� ����
-- SUM : �հ� 
-- COUNT : ��� -NULL ���� �ƴ� row ���� (null�� ����)
-- MAX   : �ִ�
-- MIN   : �ּ�
-- AVG  : ���

--�׷��Լ��� Ư¡
--�ش� �÷��� Null ���� ���� Row�� ������ ��� �ش� ���� �����ϰ� ����Ѵ�.
--(Null ������ ����� null)

--�׷��Լ� ������

--GROUP BY ���� ���� �÷��̿��� �ٸ� �÷��� SELECT ���� ǥ���Ǹ� ����

--�μ��� �޿� ��
SELECT deptno, ename,
        SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, COUNT(sal)

FROM emp
GROUP BY deptno, ename;


--GROUP BY ���� ���� ���¿��� �׷��Լ��� ����� ���
-- ��ü���� �ϳ��� ������ ���´ٴ� ��
SELECT  SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
        COUNT(sal),-- �÷��� ���� null�� �ƴ� row�� ����
        COUNT(comm),-- COMM �÷��� ���� null�� �ƴ� row ����
        COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp;

--GROUP BY�� ������ empno�̸� ������� ���?
SELECT  SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
        COUNT(sal),-- �÷��� ���� null�� �ƴ� row�� ����
        COUNT(comm),-- COMM �÷��� ���� null�� �ƴ� row ����
        COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp
GROUP BY empno;


--�׷�ȭ�� ���þ��� ������ ���ڿ�, �Լ� ,���ڵ��� SELECT ���� �����°��� ����
SELECT 1,SYSDATE, 'ACCOUNTING', SUM(sal) SUM_sal, MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal,
        COUNT(sal),-- �÷��� ���� null�� �ƴ� row�� ����
        COUNT(comm),-- COMM �÷��� ���� null�� �ƴ� row ����
        COUNT(*) -- ����� �����Ͱ� �ִ���
FROM emp
GROUP BY empno;


-- SINGIE ROW FUNCTION�� ��� WHERE ������ ��� �ϴ°��� �����ϳ�
-- MULTI ROW FUNCTION(GROUP FUNCTION)�� ��� WHERE ������ ����ϴ°��� �Ұ����ϰ�
-- HAVING ������ ������ ����Ѵ�.(HAVING ���� group by �� �ڿ� ���´�)

--�μ��� �޿� �� ��ȸ, �� �޿����� 9000�̻� row�� ��ȸ
-- deptno, �޿����� �ʿ�
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno
HAVING SUM(sal) >= 9000;

--group function �������� 1
SELECT MAX(sal), MIN(sal), ROUND(avg(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp;

--group function �������� grp3
SELECT deptno,
case
    WHEN deptno = 10 THEN 'ACCOUNTING' 
     WHEN deptno = 20 THEN 'RESEARCH'
     WHEN deptno = 30 THEN 'SALES' 
     END,
     MAX(sal), MIN(sal), ROUND(avg(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY deptno
ORDER BY deptno;


--�������� grp3
SELECT decode(deptno, 10,'ACCOUNTING',20,'RESEARCH', 30, 'SALES'),
     MAX(sal), MIN(sal), ROUND(avg(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)
FROM emp
GROUP BY decode(deptno, 10,'ACCOUNTING',20,'RESEARCH', 30, 'SALES');


--�������� grp4
--ORACLE 9i ���������� group by ���� ����� �÷����� ������ ����
--ORACLE 10G ���� ���ʹ� GROUP BY���� ����� �÷����� ������ �������� ����(GROUP BY ����� �ӵ� UP)
SELECT TO_CHAR(hiredate, 'YYYYMM'), COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM')
ORDER BY TO_CHAR(hiredate, 'YYYYMM');


--�������� grp5
SELECT TO_CHAR(hiredate, 'YYYY'), COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');


--�������� grp6
SELECT COUNT(*)
FROM dept;

SELECT COUNT(dname)
FROM dept;

--�������� grp7
--�μ��� ���� �ִ��� �ľ�
--�μ��� ���� �ִ��� : 10 , 20, 30 --> 3���� row�� ����
-- ���̺��� row���� ��ȸ : GROUP BY ���� COUNT(*)

SELECT COUNT(*)
FROM
(SELECT deptno
    FROM emp
GROUP BY deptno);


-- condition �ǽ� �������� 3

SELECT userid, usernm , alias, reg_dt,
    decode(MOD(TO_NUMBER(TO_CHAR(reg_dt, 'YYYY')),2),
        MOD(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')),2),'�ǰ����������','�ǰ�����������')
FROM users;




