SELECT sido,sigungu, gb 
FROM fastfood b
WHERE sido IN ('������') AND gb IN '�Ե�����';
SELECT a2.sido, a2.sigungu, ROUND(ham/b1,1) kk
    FROM
        (SELECT sido, sigungu, SUM(a1) ham
        FROM 
          (SELECT sido,sigungu, gb ,count(gb) a1
          FROM fastfood 
          WHERE gb IN ('�Ƶ�����','KFC','����ŷ')
          GROUP BY sido,sigungu, gb)a
        GROUP BY sido,sigungu) a2
    JOIN
       
          (SELECT sido,sigungu, gb ,count(gb) b1
          FROM fastfood 
          WHERE gb IN ('�Ե�����') 
          GROUP BY sido,sigungu, gb) b2  
          
        ON(a2.sido = b2.sido AND a2.sigungu = b2.sigungu)
        ORDER BY kk desc;
        
--�����ÿ� �ִ� 5���� �� �ܹ��� ����
--kfc + ����ŷ + �Ƶ����� / �Ե�����

SELECT sido, count(*)
FROM fastfood
WHERE sido like '%����%'
GROUP BY sido; 

--���� KFC, ����ŷ ,�Ƶ�����
SELECT sido, sigungu, count(*)
from fastfood
WHERE sido = '����������'
AND gb IN ('KFC','����ŷ','�Ƶ�����')
GROUP BY sido,sigungu;


-- �Ե�����
SELECT sido, sigungu, count(*)
from fastfood
WHERE sido = '����������'
AND gb IN ('�Ե�����')
GROUP BY sido,sigungu;

SELECT a.sido, a.sigungu, ROUND(a.c1/b.c2,2) hambuger_score
FROM
(SELECT sido, sigungu, count(*) c1
from fastfood
WHERE /*sido = '����������'
AND */gb IN ('KFC','����ŷ','�Ƶ�����')
GROUP BY sido,sigungu) a,

(SELECT sido, sigungu, count(*) c2
from fastfood
WHERE /*sido = '����������'
AND*/ gb IN ('�Ե�����')
GROUP BY sido,sigungu) b

WHERE a.sido = b.sido
AND a.sigungu =b.sigungu
ORDER BY hambuger_score desc;

--fastfood ���̺��� �ѹ��� �д� ������� �ۼ��ϱ�
SELECT sido, sigungu,ROUND(KFC+ burgerking + mac / lot, 2) burger_score
FROM 

(SELECT sido, sigungu,
       NVL(SUM(DECODE(gb, 'KFC', 1)),0) KFC,
       NVL(SUM(DECODE(gb, '����ŷ', 1)),0) burgerking,
       NVL(SUM(DECODE(gb, '�Ƶ�����',1)),0) mac,
       NVL(SUM(DECODE(gb, '�Ե�����',1)),1) lot --�и� �Ǵ� �Ե�����~ 0�� ������ ����
FROM fastfood
WHERE gb IN('KFC','����ŷ','�Ƶ�����','�Ե�����')
GROUP BY sido, sigungu)
/*ORDER BY sido, sigungu)*/-- ȿ�������� ���� �����ص� ��� X 
ORDER BY burger_score DESC;



SELECT sido, sigungu, ROUND(sal/people) pri_sal
FROM tax
ORDER BY pri_sal DESC;

--�ܹ��� ����, ���κ� �ٷμҵ� �ݾ� ������ ���� �õ����� ����
--����, ���κ� �ٷμҵ� �ݾ����� ���� �� ROWNUM�� ���� ������ �ο�
--���� ������ �ೢ�� ����
--�ܹ������� �õ�, �ܹ��ż� �ñ���, �ܹ�������, ���ݽõ�, ���� �ñ���, ���κ� �ٷμҵ��

SELECT b.sido, b.sigungu, b.burger_score, a.sigubgu, a.pri_sal
FROM
(SELECT ROWNUM rn1, b.*
 FROM
        
        (SELECT sido, sigungu,  -- SELECT �� �ϳ� ����� �׳� ROUND �ϴ°� ���ҵ�
                 (NVL(SUM(DECODE(gb, 'KFC', 1)),0),
                       NVL(SUM(DECODE(gb, '����ŷ', 1)),0),
                       NVL(SUM(DECODE(gb, '�Ƶ�����',1)),0),
                       NVL(SUM(DECODE(gb, '�Ե�����',1)),1),2)    --�и� �Ǵ� �Ե�����~ 0�� ������ ����
FROM fastfood
WHERE gb IN('KFC','����ŷ','�Ƶ�����','�Ե�����')
GROUP BY sido, sigungu
ORDER BY burger_score DESC) b)b

JOIN

(SELECT ROWNUM rn2, a.*
    FROM
        (SELECT sido, sigungu, ROUND(sal/people) pri_sal
        FROM tax
        ORDER BY pri_sal DESC)a) a

ON (a.rn =b.rn2);

--Rownum ���� ����
--SELECT --> ORDER BY
--���ĵ� ����� ROWNUM�� �����ϱ� ���ؼ��� INLINE -VIEW
--1������ ���������� ��ȸ�� �Ǵ� ���ǿ� ���ؼ��� WHERE ������ ����� ����


desc dept;

--enmpno �÷��� NOT NULL ���� ������ �ִ�. -insert �� �ݵ�� ���� �����ؾ� ���������� �Էµȴ�
--empno �÷��� ������ ������ �÷��� BULLABLE �̴�  (NULL���� ����� �� �ִ�.)
INSERT INTO emp(empno,ename,job)
    VALUES (9999,'brown',NULL);

SELECT *
FROM emp;

INSERT INTO emp (ename, job)
VALUES ('sally','SALESMAN'); -- �Է¾ȵ�

--���ڿ� : '���ڿ�' 
--�� ¥   :10
--�� ¥   : TO_DATE('20200206','YYYYMMDD')

--emp ���̺��� hiredate �÷��� date Ÿ��
--emp ���̺��� 8�� �÷��� ���� �Է� 

desc emp; --���̺��� ��ü �Է��Ϸ��� �˻��� ���ְ� ���̺��÷� ������� �Է�

INSERT INTO emp VALUES(9998,'sally', 'SALESMAN' , NULL,SYSDATE, 1000,NULL ,99); --�Է�

ROLLBACK;-- �ѹ�


--�������� �����͸� �ѹ��� INSERT :
--INSERT INTO ���̺�� (�÷���1, �÷���2.....)
--SELECT .....
--FROM
INSERT INTO emp
SELECT 9998,'sally', 'SALESMAN' , NULL,SYSDATE, 1000,NULL ,99
FROM dual

    UNION ALL --(�ߺ������� ALL��, �ӵ����)

SELECT 9999,'brown','CLERK', NULL,TO_DATE('20200205','YYYYDDMM'),1100,NULL,99
FROM dual;

SELECT *
FROM emp;


--UPDATE ����
--UPDATE ���̺�� �÷���1 = ������ �÷� ��1, ���̺�� SET �÷���2 = ������ �÷� ��2.....
--WHERE �� ���� ���� (Ư�� �࿡�� ������Ʈ �Ѵٰ� �Ҷ�)

--������Ʈ ���� �ۼ��� where ���� �������� ������ �ش� ���̺��� ������� ������� ������Ʈ�� �Ͼ��.
--UPDATE, DELETE ���� WHERE���� ������ �ǵ��Ѱ� �´��� �ٽ��ѹ� �� Ȯ��

--WHERE���� �ִٰ� �ϴ��� �ش� �������� �ش� ���̺��� SELECT �ϴ� ������ �ۼ��Ͽ� �����ϸ�
--������Ʈ ��� ���� ��ȸ �Ҽ� �����Ƿ� Ȯ���ϰ� �����ϴ� �͵� ��� �߻� ������ ������ �ȴ�.

--99�� �μ���ȣ�� ���� �μ� ������ DEPT���̺� �ִ� ��Ȳ

INSERT INTO dept (99,'ddit','daejeon'); --�Է�

-- 99�� �μ���ȣ�� ���� �μ��� dname �÷��� ���� '���IT', loc�÷��� ���� '���κ���'���� ������Ʈ

UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;


SELECT *
FROM dept
WHERE deptno =99;

ROLLBACK; -- �߸������� ������ ������ one chance


--�Ǽ���WHERE ���� ������� �ʾ��� ���
UPDATE dept SET dname = '���IT', loc = '���κ���' 
--deptnoĮ���� ����� danem => ���IT ,loc => ���κ������� ���´�

-- 10 ==> subquery;

--smtih, ward�� ���� �μ��� �Ҽӵ� ���� ����
SELECT *
FROm emp
WHERe detpno IN(20,30);


SELECT *
FROM emp
WHERE detpno IN(SELECT deptno  
                FROM emp
                WHERE ename IN('SMITH','WARD'));

--UPDATE�ÿ��� ���� ���� ��� ����
INSERT INTO emp (empno,ename) VALUES (9999, 'brown');

--9999�� ��� deptno, job������ SMITH ����� ���� �μ����� �������� ������Ʈ
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
                job = (SELECT deptno FROM emp WHERE ename ='SMITH')
WHERE empno =9999;


--
--DELETE SQL : Ư�� ���� ����
--  DELETE [FROM] ���̺��
--  WHERE �� ���� ����;

SELECT *
FROM dept;

--99�� �μ���ȣ�� �ش��ϴ� �μ� ���� ����
DELETE dept
FROM deptno =99;

COMMIT;

--SUBQUERY�� ���ؼ� Ư�� ���� �����ϴ� ������ ���� DELETE
--�Ŵ����� 7698 ����� ������ �����ϴ� ������ �ۼ�

DELETE emp
WHERE mgr = 7698;

DELETE emp
WHERE empno IN (SELECT empno
                FROM emp
                WHERE mgr = 7698);

ROLLBACK;

SELECT *
FROM emp;







