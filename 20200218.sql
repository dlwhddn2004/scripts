SELECT deptcd, lpad(' ',(LEVEL-1)*4, ' ') ||deptnm deptnm, P_deptcd --lpad 마지막점 채울곳에 공백을 안넣어도 알아서 공백처리
FROM dept_h
START WITH deptcd ='dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;
SELECT *
FROM dept_H;

--상향식 계층쿼리 (leaf --> root node (상위 node))
--전체노드를 방문하는게 아니라 자신의 부모노드만 방문
--시작점 : 디자인 팀
--연결은 : 상위부서

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*4)|| deptnm
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;
--오라클은 Pre-order 계층 쿼리 탐색 순서 한번 알아보자

--구글 공유 계층형 쿼리 복습 둘중아무거나
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
--하향식으로 하는건데 START 절에 조건을 주고 
--CONNECT BY에서 앞에서 읽을 데이터 PRIOR S_ID(최상위)를 PRIOR를 둬 그다음 PS_ID(상위부서)를 나타내는 쪽으로 내려가게끔 해준다.

--계층형 쿼리 스크랩트
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT *
FROM no_emp;


SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--connect And / where 결과가 다르다

--계층형 쿼리의 행 제한 조건 기술 위치에 따른 결과 비교(pruning branch- 가지치기)
FROM => START WITH, CONNECT BY => WHERE
1.WHERE : 계층 연결을 하고 나서 행을 제한
2.CONNECT BY : 계층 연결을 하는 과정에서 행을 제한;

--WHERE 절 기술 전 : 총 9개의 행이 조회되는것을 확인
--WHERE 절 (deptnm != '정보기획부' : 정보기획부를 제외한 8개의 행이 조회되는것이 확인
SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp
FROM no_emp
WHERE org_cd != '정보기획부'
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--CONNECT BY 절에 조건을 기술 , 연결하는 과정에서 아예 차단 (정보기획부 관련 하위부서 다 차단) 6개 행이 조회
SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD AND org_cd != '정보기획부';

--WHERE절 계층쿼리 이후에 적용한다. 단 !다른 테이블과 조인 조건으로 이용되었을 경우 조인에 사용한다


--CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 최상위 행의 값을 조회; --게시판 원본글 ,댓글?

SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp,
        CONNECT_BY_ROOT(org_cd) ROOT
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--SYS_CONNECT_BY_PATH(칼럼, 구분자) : 해당 행의 컬럼이 거쳐온 컬럼 값을 추천, 구분자로 이어준다.;

SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp,
        CONNECT_BY_ROOT(org_cd) ROOT,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd,' '), '-') path --TRIM (공백을 제거해주는 함수)인데 앞에 L을 붙으면 특수문자
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;


--CONNECT_BY_IS_LEAF : 해당 행이 LEAF 노드인지 (연결된 자식이 없는지) 값을 리턴 [1 : leaf, 0: leaf]
SELECT LPAD(' ',(LEVEL-1)*3)||ORG_CD  ORG_CD, NO_emp,
        CONNECT_BY_ROOT(org_cd) ROOT,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd,' '), '-') path, --TRIM (공백을 제거해주는 함수) ,
        CONNECT_BY_ISLEAF leaf
FROM no_emp
START WITH ORG_CD = 'XX회사'
CONNECT BY PRIOR ORG_CD = PARENT_ORG_CD;

--게시글 계층형 쿼리 샘플자료 복사
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

--문자 h6
SELECT *
FROM board_test;

SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
FROM board_test
START WITH parent_seq is null --또는 seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq;


--h7

SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
FROM board_test
START WITH parent_seq is null --또는 seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC; --title을 보면 계층 구조가 다 무시되는것이 보일것이다. 
--계층 구조를 유지한 상태에서 정렬을 하려면 ORDER SIBLINGS BY를 써준다.

--h8
SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
FROM board_test
START WITH parent_seq is null --또는 seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC ;

--h9
--SELECT seq,LPAD(' ',(LEVEL-1)*3)||Title title
--FROM board_test
--START WITH parent_seq is null  --또는 seq IN(1,2,4)
--CONNECT BY PRIOR seq = parent_seq  
--ORDER SIBLINGS BY seq DESC [댓글이 순차적으로 달리게 해주는 무언가];

--그룹번호를 저장할 컬럼을 추가
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
START WITH parent_seq is null --또는 seq IN(1,2,4)
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY CASE WHEN parent_seq IS NOT NULL THEN seq ELSE 0 END DESC, seq; --decode로해보자


--분석함수/ window 함수

SELECT MAX(sal)
FROM emp;
--최고연봉이 누군데?~
SELECT *
FROM emp
WHERE sal = (SELECT MAX(sal)
                FROM emp);
--이걸 분석함수 배우면 간단하게 나오지

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



