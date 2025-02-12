/* 회원(USERS) 관련 테이블
*/
-- APP_USERS
-- APP_USERMETA
-- APP_USER_SNS_LOGINS



/* ----------------------------------------
 * 회원(USERS), app_users
---------------------------------------- */

-- CREATE SEQUENCE 
CREATE SEQUENCE SEQ_APP_USERS_ID
START WITH 1
INCREMENT BY 1 
NOCACHE
NOCYCLE;

-- CREATE OR REPLACE TRIGGER 
CREATE OR REPLACE TRIGGER TRG_APP_USERS_ID
BEFORE INSERT ON app_users 
FOR EACH ROW 
WHEN ( NEW.id IS NULL )
BEGIN 
    SELECT SEQ_APP_USERS_ID.NEXTVAL INTO :NEW.id FROM DUAL;
END; 
/

CREATE TABLE app_users (
    id NUMBER(20, 0) PRIMARY KEY, 
    user_email VARCHAR2(100) NOT NULL UNIQUE,
    user_pass VARCHAR2(255) DEFAULT '' NOT NULL, 
    user_nicname NVARCHAR2(50) DEFAULT '' NOT NULL,
    user_activation_key VARCHAR2(255) DEFAULT '' NULL,
    user_registered TIMESTAMP DEFAULT TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') NOT NULL,
    user_status NUMBER DEFAULT 0 NOT NULL
);

-- CREATE INDEX i_app_users_user_email ON app_users ( user_email ); 
CREATE INDEX i_app_users_user_status ON app_users ( user_status );


/* ----------------------------------------
 * 회원 메타(USERMETA), app_usermeta
---------------------------------------- */
/* SEQUENCE & TRIGGER, app_termmeta.meta_id, CLOB */
-- CREATE SEQUENCE
CREATE SEQUENCE SEQ_APP_USERMETA_META_ID
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- CREATE OR REPLACE TRIGGER
CREATE OR REPLACE TRIGGER TRG_APP_USERMETA_META_ID 
BEFORE INSERT ON app_usermeta 
FOR EACH ROW 
WHEN (NEW.meta_id IS NULL)
BEGIN 
    SELECT SEQ_APP_USERMETA_META_ID.NEXTVAL INTO :NEW.meta_id FROM DUAL;     
END; 
/
-- CREATE OR REPLACE TRIGGER
CREATE OR REPLACE TRIGGER TRG_APP_USERMETA_EMPTY_CLOB
BEFORE INSERT ON app_usermeta 
FOR EACH ROW 
BEGIN 
     IF :NEW.meta_value IS NULL THEN
        :NEW.meta_value := EMPTY_CLOB();
    END IF;     
END; 
/

CREATE TABLE app_usermeta (
    meta_id NUMBER(20, 0) PRIMARY KEY,
    user_id NUMBER(20, 0) DEFAULT 0 NOT NULL, 
    meta_key VARCHAR2(255),
    meta_value CLOB DEFAULT EMPTY_CLOB(),    
    CONSTRAINT fk_app_usermeta_user_id FOREIGN KEY (user_id) REFERENCES app_users(id) ON DELETE CASCADE
);

CREATE INDEX i_app_usermeta_user_id_meta_key ON app_usermeta ( user_id, meta_key ); 



/* ----------------------------------------
 * SNS 로그인 정보 (SNS Login), app_user_sns_logins
---------------------------------------- */
CREATE SEQUENCE SEQ_APP_USER_SNS_LOGINS 
START WITH 1 
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_APP_USER_SNS_LOGINS 
BEFORE INSERT ON app_user_sns_logins 
FOR EACH ROW 
WHEN ( NEW.id IS NULL )
BEGIN 
    SELECT SEQ_APP_USER_SNS_LOGINS.NEXTVAL INTO :NEW.id FROM DUAL;
END;
/

CREATE OR REPLACE TRIGGER TRG_APP_USER_SNS_EMPTY_CLOB
BEFORE INSERT ON app_user_sns_logins 
FOR EACH ROW 
BEGIN 

    IF :NEW.login_access_token IS NULL THEN
        :NEW.login_access_token := EMPTY_CLOB();
    END IF;
    
    IF :NEW.login_refresh_token IS NULL THEN
        :NEW.login_refresh_token := EMPTY_CLOB();
    END IF;
    
END;
/


CREATE TABLE app_user_sns_logins (
    id NUMBER(20, 0) PRIMARY KEY, 
    user_id NUMBER(20,0) DEFAULT 0 NOT NULL,
    login VARCHAR2(100) NOT NULL UNIQUE,
    login_access_token CLOB DEFAULT EMPTY_CLOB(),
    login_refresh_token CLOB DEFAULT EMPTY_CLOB(),
    status NUMBER DEFAULT 0 NOT NULL CHECK (status IN (0, 1)), 
    provider VARCHAR2(20) NOT NULL CHECK (provider IN ('google', 'facebook', 'kakao', 'naver')),
    provider_id  VARCHAR2(255) DEFAULT '' NOT NULL,
    login_updated TIMESTAMP DEFAULT TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') NOT NULL,
    login_created TIMESTAMP DEFAULT TO_DATE('1970-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') NOT NULL,
    
    CONSTRAINT fk_user_sns_logins_user_id FOREIGN KEY (user_id) REFERENCES app_users(id) ON DELETE CASCADE
);

CREATE INDEX i_app_user_sns_logins_user_id ON app_user_sns_logins( user_id ); 
CREATE INDEX i_app_user_sns_logins_status ON app_user_sns_logins( status ); 
CREATE INDEX i_app_user_sns_logins_provider ON app_user_sns_logins( provider ); 
