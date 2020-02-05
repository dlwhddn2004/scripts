--�ǽ� sub4
--dept ���̺��� 5���ǵ����Ͱ� ����
--emp ���̺��� 14���� ������ �ְ�, ������ �ϳ��� �μ��� ���� �ִ�.(deptno)
-- �μ��� ������ ���� ���� ���� �μ� ������ ��ȸ
--���� �������� �������� ������ �´��� Ȯ���� ��Ȱ�� �ϴ� �������� �ۼ�
SELECT *
FROM dept
WHERE deptno NOT IN(select deptno
                     FROM emp);
                     
 SELECT *
 FROM dept
 WHERE deptno NOT IN         
            (SELECT deptno
            FROM emp
            GROUP BY deptno);

--sub5 ��������
SELECT *
FROM product
WHERE PID NOT IN(SELECT pid
                  FROM cycle
                  WHERE cid =1);  
                  
--sub6             
SELECT *
FROM product
WHERE PID IN((SELECT pid
             FROM cycle
              WHERE cid =1),
              (SELECT pid
             FROM cycle
              WHERE cid =2));
--cid = 1�� ���� �������� : 100��, 400��
SELECT *
FROM cycle
WHERE cid =1;
--cid = 1�� ���� �������� : 100��, 200��
SELECT *
FROM cycle
WHERE cid =2;

--cid =1, cid =2 �ΰ��� ���ÿ� �����ϴ� ��ǰ 
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN(100);

------------------
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN ( SELECT pid
            FROM cycle
            WHERE cid =2);
            
--�������� 7
SELECT *
FROM customer;
SELECT *
FROM product;
SELECT *
FROM cycle;


SELECT a.cid, customer.cnm, a.pid, product.pnm, a.day, a.cnt
FROM
    (SELECT *
    FROM cycle
    WHERE cid = 1
    AND pid IN ( SELECT pid
            FROM cycle
            WHERE cid =2)) a,customer,product
WHERE a.cid = customer.cid
AND   a.pid = product.pid;


SELECT cycle.cid, customer.cnm, cycle.pid,
product.pnm,cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.pid IN ( SELECT pid
            FROM cycle
            WHERE cid =2)
AND cycle.cid = customer.cid
AND cycle.pid = product.pid;

--�Ŵ����� �����ϴ� ������ ��ȸ(KING�� ������ 13���� �����Ͱ� ��ȸ);
SELECT *
FROM emp
WHERE mgr IS NOT null;




--EXSITS ���ǿ� �����ϴ� ���� ���� �ϴ��� Ȯ���ϴ� ������
--�ٸ� �����ڿ� �ٸ��� WHERE ���� �÷��� ������� �ʴ´�.
-- WHERE emp no = 7369 -> WHERE EXIST (SELECT 'X' 
--                                    FROM ......);
--exists�� ���߿�����
--�Ŵ����� �����ϴ� ������ EXISTS �����ڸ� ���� ��ȸ
--�Ŵ����� ����
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
                FROM emp m
                WHERE e.mgr = m.empno);

--�ǽ� 9

SELECT *
FROM cycle;
SELECT *
FROM product;

SELECT *
FROM product
WHERE EXISTs ( SELECT 'X'
                FROM cycle
                WHERE cycle.pid = product.pid
                AND cid =1);
      
--sub 10

SELECT *
FROM product
WHERE NOT EXISTS ( SELECT 'X'
                FROM cycle
                WHERE cycle.pid = product.pid
                AND cid !=1);
                

--���տ���
--������ :UNION -�ߺ�����(���հ���) / UNION ALL - �ߺ��� �������� ����(�ӵ� ���)
--������ : INTERSECT (���հ���)
--������ : MINUS (���հ���)
--���տ��� �������
--�� ������ �÷��� ����, Ÿ���� ��ġ �ؾ� �Ѵ�.

--������ ������ �����ϱ� ������ �ߺ��Ǵ� �����ʹ� 
--�ѹ��� ����ȴ�

--UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)
                
UNION

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);


--UNION ALL �����ڴ� UNION �����ڿ� �ٸ��� �ߺ��� ���
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698)
                
UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);



--INTERSECT (������) : �� , �Ʒ����տ��� ���� ���� �ุ ��ȸ
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)
                
INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);



--MINUS (������) : �� ���տ��� �Ʒ� ������ �����͸� ������ ������ ����
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)
                
MINUS

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698);

--������ ��� ������ ������ ���� ���տ�����
-- A UNION B =  B UNION A  (����)
-- A UNION ALL B = B UNION ALL A (����) ���հ�������
-- A INTERECT B = B INTERECT A

-- A MINUS B   != B MINUS A(�ٸ�)

--���� ������ ���  �÷� �̸��� ù��° ������ �÷����� ������.
SELECT 'X' fir, 'B' sec 
FROM dual

UNION

SELECT 'Y' asd,'A'
FROM dual;


--���� ORDER BY �� ���� ���� ���� ������ ���� ������ ���

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (10,20)

UNION

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30,40)
ORDER BY deptno;
-------------------------�Ʒ� ó�� �ص� ��
SELECT deptno, dname, loc
FROM (SELECT deptno, dname, loc
        FROM dept
        WHERE deptno IN (10,20))

UNION

SELECT deptno, dname, loc
FROM dept
WHERE deptno IN (30,40)
ORDER BY deptno;


--�ܹ��� ���� ��������;
SELECT *
FROM fastfood;

--�õ�, �ñ���, ���� ���� // �������� ���� ���� ���ð� ���� �������� ����
--�������� kfc ��� + ����ŷ ���� + �Ƶ����� ���� / �Ե����� ����
SELECT *
FROM fastfood;

SELECT sido,sigungu, gb,count(gb) 
FROM fastfood 
GROUP BY sido,sigungu, gb;

SELECT sido,sigungu, gb ,count(gb)
FROM fastfood a
WHERE gb IN ('�Ƶ�����','kfc','����ŷ')
GROUP BY sido,sigungu, gb;

SELECT sido,sigungu, gb ,count(gb)
FROM fastfood a
WHERE sido IN ('������') AND gb IN ('�Ƶ�����','kfc','����ŷ')
GROUP BY gb;

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
        

    