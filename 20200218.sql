SELECT deptcd, lpad(' ',(LEVEL-1)*4, ' ') ||deptnm deptnm, P_deptcd --lpad �������� ä����� ������ �ȳ־ �˾Ƽ� ����ó��
FROM dept_h
START WITH deptcd ='dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
SELECT *
FROM dept_H;

--����� �������� (leaf --> root node (���� node))
--��ü��带 �湮�ϴ°� �ƴ϶� �ڽ��� �θ��常 �湮
--������ : ������ ��
--������ : �����μ�

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4)|| deptnm
FROM dept_h
START WITH deptnm = '��������'
CONNECT BY PRIOR p_deptcd = deptcd;
--����Ŭ�� Pre-order ���� ���� Ž�� ���� �ѹ� �˾ƺ���

--���� ���� ������ ���� ���� ���߾ƹ��ų�
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;

SELECT *
FROM h_sum;

SELECT LPAD(' ',(LEVEL -1) *3) ||PS_ID  S_ID, value
FROM h_sum
START WITH S_ID ='0'
CONNEcT BY PRIOR S_ID = PS_ID;
--��������� �ϴ°ǵ� START ���� ������ �ְ� 
--CONNECT BY���� �տ��� ���� ������ PRIOR S_ID(�ֻ���)�� PRIOR�� �� �״��� PS_ID(�����μ�)�� ��Ÿ���� ������ �������Բ� ���ش�.

--������ ���� ��ũ��Ʈ
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

SELECT *
FROM no_emp;


SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--connect And / where ����� �ٸ���

--������ ������ �� ���� ���� ��� ��ġ�� ���� ��� ��(pruning branch- ����ġ��)
FROM => START WITH, CONNECT BY => WHERE
1.WHERE : ���� ������ �ϰ� ���� ���� ����
2.CONNECT BY : ���� ������ �ϴ� �������� ���� ����;

--WHERE �� ��� �� : �� 9���� ���� ��ȸ�Ǵ°��� Ȯ��
--WHERE �� (deptnm != '������ȹ��' : ������ȹ�θ� ������ 8���� ���� ��ȸ�Ǵ°��� Ȯ��
SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp
FROM no_emp
WHERE org_cd != '������ȹ��'
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--CONNECT BY ���� ������ ��� , �����ϴ� �������� �ƿ� ���� (������ȹ�� ���� �����μ� �� ����) 6�� ���� ��ȸ
SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD AND org_cd != '������ȹ��';

--WHERE�� �������� ���Ŀ� �����Ѵ�. �� !�ٸ� ���̺�� ���� �������� �̿�Ǿ��� ��� ���ο� ����Ѵ�


--CONNECT_BY_ROOT(�÷�) : �ش� �÷��� �ֻ��� ���� ���� ��ȸ; --�Խ��� ������ ,���?

SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp,
        CONNECT_BY_ROOT(org_cd) ROOT
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--SYS_CONNECT_BY_PATH(Į��, ������) : �ش� ���� �÷��� ���Ŀ� �÷� ���� ��õ, �����ڷ� �̾��ش�.;

SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp,
        CONNECT_BY_ROOT(org_cd) ROOT,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd,' '), '-') path --TRIM (������ �������ִ� �Լ�)�ε� �տ� L�� ������ Ư������
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--CONNECT_BY_IS_LEAF : �ش� ���� LEAF ������� (����� �ڽ��� ������) ���� ���� [1 : leaf, 0: leaf]
SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp,
        CONNECT_BY_ROOT(org_cd) ROOT,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd,' '), '-') path, --TRIM (������ �������ִ� �Լ�) ,
        CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH ORG_CD = 'XXȸ��'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--�Խñ� ������ ���� �����ڷ� ����
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

--���� h6
SELECT *
FROM board_test;

SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
FROM board_test
START WITH parent_seq is null --�Ǵ� seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq;


--h7

SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
FROM board_test
START WITH parent_seq is null --�Ǵ� seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC; --title�� ���� ���� ������ �� ���õǴ°��� ���ϰ��̴�. 
--���� ������ ������ ���¿��� ������ �Ϸ��� ORDER SIBLINGS BY�� ���ش�.

--h8
SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
FROM board_test
START WITH parent_seq is null --�Ǵ� seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC ;

--h9
--SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
--FROM board_test
--START WITH parent_seq is null  --�Ǵ� seq IN(1,2,4)
--CONNECT BY PRIOR seq = parent_seq  
--ORDER SIBLINGS BY seq DESC [����� ���������� �޸��� ���ִ� ����];

--�׷��ȣ�� ������ �÷��� �߰�
ALTER TABLE board_test ADD (gn NUMBER);

UPDATE board_test SET gn = 4
WHERE seq IN (4,5,6,7,8,10,11);

UPDATE board_test SET gn = 2
WHERE seq IN (2,3);

UPDATE board_test SET gn = 1
WHERE seq IN (1,9);
commit;

SELECT *
FROM board_test;

SELECT gn, LPAD(' ',(LEVEL-1)*4)|| title tile
FROm board_test
START WITH parent_seq IS null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title,
    CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1,
    CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END o2
FROM board_test
START WITH parent_seq is null --�Ǵ� seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END DESC, seq; --decode���غ���


--�м��Լ�/ window �Լ�

SELECT MAX(sal)
FROM emp;
--�ְ����� ������?~
SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal)
                FROM emp);
--�̰� �м��Լ� ���� �����ϰ� ������

SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal)
                FROM emp);
-----------------------
SELECT *
FROM
(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <=14) a,

(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b
WHERE b.cnt >= a.lv
ORDER BY b.deptno , a.lv;



