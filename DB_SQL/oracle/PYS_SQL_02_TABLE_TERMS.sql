/* 용어 관련 테이블  
*/
-- APP_TERMS 
-- APP_TERMMETA 
-- APP_TERM_TAXONOMY 



/* ----------------------------------------
 * 용어(TERMS), app_terms
---------------------------------------- */
/* SEQUENCE & TRIGGER, app_terms.term_id */
-- CREACTE SEQUENCE 
CREATE SEQUENCE SEQ_APP_TERMS_TERM_ID 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- CREATE OR REPLACE TRIGGER 
CREATE OR REPLACE TRIGGER TRG_APP_TERMS_TERM_ID
BEFORE INSERT ON app_terms 
FOR EACH ROW 
WHEN (NEW.term_id IS NULL)
BEGIN 
    SELECT SEQ_APP_TERMS_TERM_ID.NEXTVAL INTO :NEW.term_id FROM DUAL; 
END; 
/

CREATE TABLE app_terms (
    term_id NUMBER(20, 0) PRIMARY KEY,
    name NVARCHAR2(200) DEFAULT '' NOT NULL, 
    slug VARCHAR2(200) DEFAULT '' NOT NULL,
    term_group NUMBER(20,0) DEFAULT 0 NOT NULL
);

CREATE INDEX i_app_terms_slug ON app_terms (slug);
CREATE INDEX i_app_terms_term_group ON app_terms (term_group);



/* ----------------------------------------
 * 용어 메타(TERMMETA), app_termmeta
---------------------------------------- */
/* SEQUENCE & TRIGGER, app_termmeta.meta_id, CLOB */
-- CREATE SEQUENCE
CREATE SEQUENCE SEQ_APP_TERMMETA_META_ID 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- CREATE OR REPLACE TRIGGER
CREATE OR REPLACE TRIGGER TRG_APP_TERMMETA_META_ID 
BEFORE INSERT ON app_termmeta 
FOR EACH ROW 
WHEN (NEW.meta_id IS NULL)
BEGIN 
    SELECT SEQ_APP_TERMMETA_META_ID.NEXTVAL INTO :NEW.meta_id FROM DUAL;     
END; 
/
-- CREATE OR REPLACE TRIGGER
CREATE OR REPLACE TRIGGER TRG_APP_TERMMETA_EMPTY_CLOB
BEFORE INSERT ON app_termmeta 
FOR EACH ROW 
BEGIN 
     IF :NEW.meta_value IS NULL THEN
        :NEW.meta_value := EMPTY_CLOB();
    END IF;     
END; 
/

CREATE TABLE app_termmeta (
    meta_id NUMBER(20, 0) PRIMARY KEY,
    term_id NUMBER(20, 0) DEFAULT 0 NOT NULL, 
    meta_key VARCHAR2(255),
    meta_value CLOB DEFAULT EMPTY_CLOB(),    
    CONSTRAINT fk_app_termmeta_term_id FOREIGN KEY (term_id) REFERENCES app_terms(term_id) ON DELETE CASCADE
);

CREATE INDEX i_app_termmeta_term_id_meta_key ON app_termmeta ( term_id, meta_key ); 



/* ----------------------------------------
 * 용어 분류(Taxonomy), app_term_taxonomy
---------------------------------------- */
/* SEQUENCE & TRIGGER, app_term_taxonomy.term_taxonomy_id, CLOB ... */
-- CREATE SEQUENCE
CREATE SEQUENCE SEQ_APP_TERM_TAXONOMY_TERM_TAXONOMY_ID 
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- CREATE OR REPLACE TRIGGER
CREATE OR REPLACE TRIGGER TRG_APP_TERM_TAXONOMY_TERM_TAXONOMY_ID
BEFORE INSERT ON app_term_taxonomy 
FOR EACH ROW 
WHEN (NEW.term_taxonomy_id IS NULL)
BEGIN 
    SELECT SEQ_APP_TERM_TAXONOMY_TERM_TAXONOMY_ID.NEXTVAL INTO :NEW.term_taxonomy_id FROM DUAL;     
END; 
/
-- CREATE OR REPLACE TRIGGER
CREATE OR REPLACE TRIGGER TRG_APP_TERM_TAXONOMY_EMPTY_CLOB
BEFORE INSERT ON app_term_taxonomy 
FOR EACH ROW 
BEGIN 
    IF :NEW.description IS NULL THEN
        :NEW.description := EMPTY_CLOB();
    END IF;  
END; 
/

CREATE TABLE app_term_taxonomy (
    term_taxonomy_id NUMBER(20, 0) PRIMARY KEY,
    term_id NUMBER(20, 0) NOT NULL,
    taxonomy VARCHAR2(100) NOT NULL, 
    description CLOB DEFAULT '', 
    parent NUMBER(20, 0) DEFAULT 0 NOT NULL, 
    count NUMBER(20, 0) DEFAULT 0 NOT NULL, 
    
    CONSTRAINT fk_app_term_taxonomy_term_id FOREIGN KEY (term_id) REFERENCES app_terms(term_id) ON DELETE CASCADE 
);

CREATE INDEX i_app_term_taxonomy_term_id_taxonomy ON app_term_taxonomy (term_id, taxonomy);
CREATE INDEX i_app_term_taxonomy_parent ON app_term_taxonomy (parent);
