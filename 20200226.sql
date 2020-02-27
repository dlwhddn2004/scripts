SELECT *
FROM users;

--user���̺� ��й�ȣ�� �ٲ������ ����Ǳ� ���� ��й�ȣ��
--users_history ���̺�� �̷��� �����ϴ� Ʈ���� ������
--����.
--desc users;
--1. users_history ���̺� ����;

--key(�ĺ���) : �ش� ���̺��� �ش� �÷��� �ش� ���� �ѹ��� ����
Create Table users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE,
    
    CONSTRAINT pk_users_history PRIMARY KEY (userid, mod_dt) --���� primary Ű
    );
    
    COMMENT ON TABLE users_history IS '����� ��й�ȣ �̷�';
    COMMENT ON COLUMN users_history.userid IS '����ھ��̵�';
    COMMENT ON COLUMN users_history.pass IS '��й�ȣ';
    COMMENT ON COLUMN users_history.mod_dt IS '�����Ͻ�';
    
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME IN ('USERS_HISTORY'); --�빮�ڷ��ؾ���

--2.USERS ���̺��� PASS �÷� ������ ������ TRIGGER ����

CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users --���� 
    FOR EACH ROW 
    
    BEGIN
        --��й�ȣ�� ����Ǿ��� ��� ������ üũ 
        --(������й�ȣ / ������Ʈ �Ϸ����ϴ� �ű� ��й�ȣ)
        --trigger���� �����ϴ� Ű���� :OLD.�÷� / NEW.�÷�
        IF :OLD.pass != :NEW.pass THEN
            INSERT INTO users_history VALUES (:NEW.userid, :OLD.pass, SYSDATE);
            END IF;
    END;
/

--3. Ʈ���� Ȯ��
--(1) users_histroy�� �����Ͱ� ���� ���� Ȯ��
--(2) users ���̺��� brown������� ��й�ȣ�� ������Ʈ
--(3) users_history ���̺� �����Ͱ� ������ �Ǿ����� (trigger�� ����) Ȯ��
--(4) users ���̺��� brown������� ������ ������Ʈ
--(5) users_histroy ���̺� �����Ͱ� ������ �Ǿ����� Ȯ��

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
UPDATE users set alias = '����'
WHERE userid = 'brown';

--5.;
SELECT *
FROM users_history;

ROLLBACK; --�ѹ����� ���� �Է��� histroy ������ �����

SELECT *
FROM users;

--mtbatis : java�� �̿��Ͽ� �����ͺ��̽� ���α׷��� : jdbc
--jdbc�� �ڵ��� �ߺ��� ���ϴ�

--sql�� ������ �غ�
--sql�� ������ �غ�
--sql�� ������ �غ�
--sql�� ������ �غ�
--sql�� ������ �غ�
--
--sql ����
--
--sql���� ȯ�� close
--sql���� ȯ�� close
--sql���� ȯ�� close
--sql���� ȯ�� close
--sql���� ȯ�� close

--1. ���� ==> mybatis �����ڰ� ���س��� ����� �������
--   sql �����ϱ� ���ؼ��� .. dbms�� �ʿ�(�������� �ʿ�) �̰� ���� �ϳ� ? xml �� ��
--   mybatis���� �������ִ� class �̿�,
--   sql�� �ڹ� �ڵ忡�ٰ� ���� �ۼ� �ϴ°� �ƴ϶� 
--   xml ������ sql�� ���Ƿ� �ο��ϴ� id�� ���� ����
--2. Ȱ�� 
