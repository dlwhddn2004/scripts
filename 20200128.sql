SELECT * 
FROM emp
WHERE job = 'salseman' or hiredate >= TO_DATE('1981.06.01','YYYY.MM.DD');

SELECT *
FROM emp
WHERE (deptno = 10 or deptno = 30) AND sal > 1500
ORDER BY ename desc;


--ROWNUM ���ȣ�� ��Ÿ���� �÷�
SELECT ROWNUM, empno, ename
FROM emp;


-- ROWNUM �� where �������� ��� ����
-- �����ϴ°� :ROWNUM = 1, ROWNUM <= 2    -->ROWNUM =1, ROWNUM <=N 
-- �������� �ʴ°� : ROWNUM = 2 , ROWNUM >=2     -->ROWNUM =N(N�� 1�� �ƴ� ����), ROWNUM >=N (N�� 1�� �ƴ� ����)
-- ROWNUN  �̹� ���� �����Ϳ��ٰ� ������ �ο�
-- **������ 1. ���� ���� ������ ����(ROWNUM�� �ο����� ���� ��)�� ��ȸ�Ҽ��� ����.
-- **������ 2. ORDER BY ���� SELECT �� ���Ŀ� ���� 
-- ��� �뵵 : ����¡ ó��
-- ���̺� �ִ� ��� ���� ��ȸ�ϴ� ���� �ƴ϶� �츮�� ���ϴ� �������� �ش��ϴ� 
-- �� �����͸� ��ȸ�� �Ѵ�
--����¡ ó���� ������� : 1�������� ���, ���� ����
-- emp���̺� �� row �Ǽ� : 14
-- ����¡�� 5���� �����͸� ��ȸ�Ѵٸ�?
-- 1page : 1-5
-- 2page : 6~10
-- 3page : 11~15
SELECT ROWNUM rn, empno, ename 
FROM emp
WHERE ROWNUM <=2; 

SELECT ROWNUM rn, empno, ename 
FROM emp
ORDER BY ename; --������ �Ų���������


-- ���ĵ� ����� ROWNUM�� �ο� �ϱ� ���ؼ��� IN-LINE VIEW�� ����Ѵ�.
-- ��û���� : 1.���� 2.ROWNUM �ο�
--SELECT * �� ����� ��� �ٸ� EXPRESSTION�� ǥ���ϱ� ���ؼ� 
--���̺��.*  OR ���̺� ��Ī.* �� ǥ���ؾ��Ѵ�
SELECT ROWNUM, emp.*
FROM emp;

SELECT ROWNUM, e.*
FROM emp e;


SELECT ROWNUM rn, a.* --empno, ename ���� ������ ���̺� ��Ī�� �־ ROWNUM���� ������ �����
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename)a;
    
    --ROWNUM -> rn
    --*page size : 5, ���ı����� ename
    --1page : rn 1~5
    --2page : rn 6~10
    --3page : rn 11~15
    --n page : rn (n-1)*pageSize +1 ~ n * pagesize
SELECT *
FROM
(SELECT ROWNUM rn, a.* --  ������ ���̺� ���ϴ� ������ �����ϴ� ����� �����Ҷ� 2������ ��� ����
FROM                    --
    (SELECT empno, ename
    FROM emp
    ORDER BY ename)a )
    WHERE rn BETWEEN (1-1) * 5 AND 1 * 5;
   
--�������� ROWNUM 1

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <= 10;

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE ROWNUM BETWEEN 1 AND 10; --Ư���� ��Ȳ�̶� WHERE ��Ī RN�� ������ ����?

--�������� ROWNUM 2
SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 20;

--�������� 3
SELECT *
FROM
     (SELECT ROWNUM rn, a.* -- a�� ������ ���̺� ��Ī
       FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename) a)
    WHERE rn BETWEEN 11 AND 20;
    
    
    SELECT *
FROM
     (SELECT ROWNUM rn, a.* 
       FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename) a)
    WHERE rn BETWEEN (:page -1)* :pageSize +1 AND :page * :pageSize;--n page : rn (n-1)*pageSize +1 ~ n * pagesize

--���ε����� : 
    
    
 --dual ���̺� : �����Ϳ� ������� �Լ��� �׽�Ʈ �غ� �������� ���
 SELECT *
FROM dual;
SELECT LENGTH('TEST')
FROM dual;

--���ڿ� ��ҹ��� : LOWER(�ҹ���), UPPER(�빮��), INITCAP(ù���ڸ� �빮��) ->Ȱ�뵵 ������
SELECT LOWER('Hello, World'), UPPER(ename), INITCAP('Hello, World')
FROM emp; --emp ���̺��� ����� �� ��ŭ ���´�.

-- �Լ��� WHERE �� ������ ��� ����
--��� �̸��� SMITH�� �������ȸ
SELECT *
FROM emp
WHERE ename = UPPER(:ename);

-- sql�ۼ��� �Ʒ� ���´� ���� �ؾ��Ѵ�.
--���̺��� �÷��� �������� �ʴ� ���·� SQL�� �ۼ��Ѵ�.
SELECT *
FROM emp
WHERE LOWER(ename) = :ename;

--
SELECT CONCAT('Hello', ', World') CONCAT,
    SUBSTR('Hello, World', 1, 5) sub,-- 1~5
    LENGTH('Hello, World') len,
    INSTR('Hello, World','o') ins,
    INSTR('Hello, World','o', 6) ins,
    LPAD('Hello, World', 15, '*') LP,
    RPAD('Hello, World', 15, '*') RP,
    REPLACE('Hello, World', 'H', 'T') REP,
    TRIM('  Hello, World   ') TR,--������ ����
    TRIM('d' FROM 'Hello, World') TR -- ������ �ƴ� �ҹ��� d ����
FROM dual;

    --���� �Լ�
    --ROUND : �ݿø�(10.6 �� �Ҽ��� ù��° �ڸ� �ݿø� -> 11)
    --TRUNC : ����(����) (10.6 �� �Ҽ��� ù��° �ڸ� �߻� -> 10)
    --ROUND, TRUNC : ���° �ڸ����� �ݿø�/ ����
    --MOD : ������ (���� �ƴ϶� ������ ������ �� ������ �� ) (13/5 ->�� : 2 ������ : 3)

    --ROUND(��� ����, ���� ��� �ڸ�)
SELECT ROUND(105.54, 1),  -- �ݿø� ��� �Ҽ��� ù��° �ڸ����� �������� --> '�ι�° �ڸ����� �ݿø�'
        ROUND(105.55, 1), -- �ݿø� ��� �Ҽ��� ù��° �ڸ����� �������� --> �ι�° �ڸ����� �ݿø�
        ROUND(105.55, 0), -- �ݿø� ����� �����θ� --> '�Ҽ��� ù��° �ڸ����� �ݿø�'
        ROUND(105.55, -1), -- �ݿø� ����� �����ڸ����� --> '���� �ڸ����� �ݿø�'
        ROUND(105.55)       --�ι�° ���ڸ� �Է����� ������� 0�� ����
FROM dual;


SELECT TRUNC(105.54,1),  --������ ����� �Ҽ��� ù��° �ڸ����� �������� --> '�ι�° �ڸ����� ����'
        TRUNC(105.54,1),  --������ ����� �Ҽ��� ù��° �ڸ����� �������� --> '�ι�° �ڸ����� ����'
        TRUNC(105.55,0),    --������ ����� ������(�����ڸ�)���� �������� --> �Ҽ��� ù��° �ڸ����� ����
        TRUNC(105.55,-1),    --������ ����� 10���ڸ����� �������� --> �����ڸ����� ����
        TRUNC(105.55)       --�ι�° ���ڸ� �Է����� ���� ��� 0�� ����
FROM dual;

--emp ���̺��� ����� �޿�(sal)�� 1000���� �������� 
SELECT ename, sal, 
        TRUNC(sal/1000), --���� ���Ͻÿ�
        MOD(sal ,1000)  --mod�� ����� divisor(��)���� �׻� �۴�. MOD(A, B) -- 0~999 ����
FROM emp;


DESC emp;
-- �⵵2�ڸ�/��2�ڸ�/����2�ڸ� = ���� ���� �ٸ� yyyy/mm/dd �� ��Ÿ �� �� �ִ�.
SELECT ename, hiredate
FROM emp;


-- SYSDATE : ���� ����Ŭ ������ �ú��ʰ� ���Ե� ��¥ ������ �����ϴ� Ư�� �Լ�
-- �Լ���(����1,����2) but SYSDATE�� Ư�� �Լ��� ���ڸ� �ȳ־ �ȴ�.
    --date + ���� = ���� ����
    -- 1     = �Ϸ� 
    -- 1/24  = �ѽð�
--2020/01/28 + 5

    --���� ǥ�� : ����
    --���� ǥ�� : �̱� �����̼� + ���ڿ� + �̱� �����̼� --> '���ڿ�'
    --��¥ ǥ�� : TO_DATE('���ڿ� ��¥ ��','���ڿ� ��¥ ���� ǥ�� ����') --> TO_DATD('2020.01.28', 'YYYY.DD.MM')
SELECT  TO_DATE('2019.12.31','YYYY/MM/DD') LASTDAY,
TO_DATE('2019.12.26' ,'YYYY.MM.DD') LASTDAY_BEFORE5, 
 SYSDATE NOW ,SYSDATE -3 NOW_BEFORE3
FROM dual;




