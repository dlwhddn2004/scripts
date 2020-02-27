SELECT *
FROM users;

--user테이블에 비밀번호가 바뀌었을때 번경되기 전의 비밀번호를
--users_history 테이블로 이력을 생성하는 트리거 만들자
--순서.
--desc users;
--1. users_history 테이블 생성;

--key(식별자) : 해당 테이블의 해당 컬럼에 해당 값이 한번만 존재
Create Table users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE,
    
    CONSTRAINT pk_users_history PRIMARY KEY (userid, mod_dt) --복합 primary 키
    );
    
    COMMENT ON TABLE users_history IS '사용자 비밀번호 이력';
    COMMENT ON COLUMN users_history.userid IS '사용자아이디';
    COMMENT ON COLUMN users_history.pass IS '비밀번호';
    COMMENT ON COLUMN users_history.mod_dt IS '수정일시';
    
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('USERS_HISTORY'); --대문자로해야함

--2.USERS 테이블의 PASS 컬럼 변경을 감지할 TRIGGER 생성

CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users --이전 
    FOR EACH ROW 
    
    BEGIN
        --비밀번호가 변경되었다 라는 조건을 체크 
        --(기존비밀번호 / 업데이트 하려고하는 신규 비밀번호)
        --trigger에서 제공하는 키워드 :OLD.컬럼 / NEW.컬럼
        IF :OLD.pass != :NEW.pass THEN
            INSERT INTO users_history VALUES (:NEW.userid, :OLD.pass, SYSDATE);
            END IF;
    END;
/

--3. 트리거 확인
--(1) users_histroy에 데이터가 없는 것을 확인
--(2) users 테이블의 brown사용자의 비밀번호를 업데이트
--(3) users_history 테이블에 데이터가 생성이 되었는지 (trigger를 통해) 확인
--(4) users 테이블의 brown사용자의 별명을 업데이트
--(5) users_histroy 테이블에 데이터가 생성이 되었는지 확인

--(1)
SELECT *
FROM users_history;

--(2)
UPDATE users SET pass='test'
WHERE userid= 'brown';

--3.;
SELECT *
FROM users_history;

--4.;
UPDATE users set alias = '수정'
WHERE userid = 'brown';

--5.;
SELECT *
FROM users_history;

ROLLBACK; --롤백으로 인해 입력한 histroy 정보가 사라짐

SELECT *
FROM users;

--mtbatis : java를 이용하여 데이터베이스 프로그래밍 : jdbc
--jdbc는 코드의 중복이 심하다

--sql을 실행할 준비
--sql을 실행할 준비
--sql을 실행할 준비
--sql을 실행할 준비
--sql을 실행할 준비
--
--sql 실행
--
--sql실행 환경 close
--sql실행 환경 close
--sql실행 환경 close
--sql실행 환경 close
--sql실행 환경 close

--1. 설정 ==> mybatis 개발자가 정해놓은 방식을 따라야함
--   sql 실행하기 위해서는 .. dbms가 필요(연결정보 필요) 이걸 뭘로 하냐 ? xml 로 함
--   mybatis에서 제공해주는 class 이용,
--   sql을 자바 코드에다가 직접 작성 하는게 아니라 
--   xml 문서에 sql에 임의로 부여하는 id를 통해 관리
--2. 활용 
