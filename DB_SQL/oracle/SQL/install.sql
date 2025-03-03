/* APP_TERMS
*/
-- APP_TERMS 테이블용 시퀀스 생성
CREATE SEQUENCE APP_TERMS_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [용어]
create table APP_TERMS(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    -- name 이나 slug 에는 빈문자열이 아닌 문자열로 반드시 넘어옴
    name NVARCHAR2(200) DEFAULT '' NOT NULL,
    slug VARCHAR2(200) DEFAULT '' NOT NULL,
    group_number NUMBER(20,0) DEFAULT 0 NOT NULL -- 오라클에서 group 으로 컬럼명 생성 불가!(예약어)
);

-- APP_TERMS 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_TERMS_TRG
BEFORE INSERT ON APP_TERMS
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_TERMS_SEQ.NEXTVAL;
    END IF;
END;

/* APP_TERM_META
*/
-- APP_TERM_META 테이블용 시퀀스 생성
CREATE SEQUENCE APP_TERM_META_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [용어 메타]
create table APP_TERM_META(
    meta_id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    term_id NUMBER(20,0) NOT NULL , -- 외래키
    meta_key VARCHAR2(255) NOT NULL,
    meta_value CLOB DEFAULT EMPTY_CLOB(),
    
    -- 외래키 제약조건
    CONSTRAINT fk_term_id_term_meta FOREIGN KEY (term_id)  
        REFERENCES APP_TERMS(id)    
        ON DELETE CASCADE 
);

-- APP_TERM_META 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_TERM_META_TRG
BEFORE INSERT ON APP_TERM_META
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.meta_id IS NULL THEN
        :NEW.meta_id := APP_TERM_META_SEQ.NEXTVAL;
    END IF;
END;

/* APP_TERM_CATEGORY
*/
-- APP_TERM_CATEGORY 테이블용 시퀀스 생성
CREATE SEQUENCE APP_TERM_CATEGORY_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [카테고리(텍소노미)]
create table APP_TERM_CATEGORY(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    term_id NUMBER(20,0) NOT NULL, -- 외래키
    category VARCHAR2(20) NOT NULL, -- UNIQUE 제거
    description CLOB DEFAULT '',
    count NUMBER(20,0) DEFAULT 0,
    parent NUMBER(20,0) DEFAULT 0,
    
    -- 외래키 제약조건
    CONSTRAINT fk_term_id_term_category FOREIGN KEY (term_id)  
        REFERENCES APP_TERMS(id)    
        ON DELETE CASCADE 
);

-- APP_TERM_CATEGORY 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_TERM_CATEGORY_TRG
BEFORE INSERT ON APP_TERM_CATEGORY
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_TERM_CATEGORY_SEQ.NEXTVAL;
    END IF;
END;


/* APP_MEMBER
*/
-- APP_MEMBER 테이블용 시퀀스 생성
CREATE SEQUENCE APP_MEMBER_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [회원]
create table APP_MEMBER(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    email VARCHAR2(255) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    role VARCHAR2(20) DEFAULT 'USER' NOT NULL, -- 디폴트 설정이 not null 설정보다 앞이다
    name NVARCHAR2(100),
    nickname NVARCHAR2(255) NOT NULL,
    birth DATE,
    gender CHAR(1),
    contact VARCHAR2(20),
    address NVARCHAR2(500),
    token VARCHAR2(255) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL, -- post_created_at(글 생성일시)
    status NUMBER(1,0) NOT NULL
);
 
-- APP_MEMBER 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_MEMBER_TRG
BEFORE INSERT ON APP_MEMBER
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_MEMBER_SEQ.NEXTVAL;
    END IF;
    -- updated_at컬럼의 기본값을 created_at으로 설정
    IF :NEW.updated_at IS NULL THEN
        :NEW.updated_at := :NEW.created_at;
    END IF;
END;

/* APP_TERM_CATEGORY
*/
-- APP_MEMBER_META 테이블용 시퀀스 생성
CREATE SEQUENCE APP_MEMBER_META_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [회원 메타]
create table APP_MEMBER_META(
    meta_id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    member_id NUMBER(20,0) NOT NULL , -- 외래키
    meta_key VARCHAR2(255) NOT NULL,
    meta_value CLOB DEFAULT EMPTY_CLOB(),
    
    -- 외래키 제약조건
    CONSTRAINT fk_member_id_member_meta FOREIGN KEY (member_id)  
        REFERENCES APP_MEMBER(id)    
        ON DELETE CASCADE 
);

-- APP_MEMBER_META 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_MEMBER_META_TRG
BEFORE INSERT ON APP_MEMBER_META
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.meta_id IS NULL THEN
        :NEW.meta_id := APP_MEMBER_META_SEQ.NEXTVAL;
    END IF;
END;



/* APP_MEMBER_SNS_LOGINS
*/
-- APP_MEMBER_SNS_LOGINS 테이블용 시퀀스 생성
CREATE SEQUENCE APP_MEMBER_SNS_LOGINS_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [회원SNS로그인]
create table APP_MEMBER_SNS_LOGINS(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    member_id NUMBER(20,0) NOT NULL , --외래키
    -- login_id는 반드시 빈문자열이 아닌 문자열로 넘어오는 값이다
    login_id VARCHAR2(100) DEFAULT '' NOT NULL,
    provider VARCHAR2(20) NOT NULL,
    provider_id VARCHAR2(255) UNIQUE NOT NULL,
    access_token CLOB,
    refresh_token CLOB,
    status NUMBER(1) DEFAULT 1 NOT NULL,
    login_modified_at TIMESTAMP NOT NULL,
    login_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    -- 외래키 제약조건
    CONSTRAINT fk_member_id_member FOREIGN KEY (member_id)  
        REFERENCES APP_MEMBER(id)    
        ON DELETE CASCADE 
);

-- APP_MEMBER_SNS_LOGINS 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_MEMBER_SNS_LOGINS_TRG
BEFORE INSERT ON APP_MEMBER_SNS_LOGINS
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_MEMBER_SNS_LOGINS_SEQ.NEXTVAL;
    END IF;
END;





/* APP_POSTS
*/
-- APP_POSTS 테이블용 시퀀스 생성
CREATE SEQUENCE APP_POSTS_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [글(포스트)]
create table APP_POSTS(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    post_author NUMBER(20,0) NOT NULL, --외래키
    post_title CLOB NOT NULL,
    post_content CLOB DEFAULT EMPTY_CLOB(),
    post_summary CLOB DEFAULT EMPTY_CLOB(),
    post_status VARCHAR2(20) DEFAULT 'PUBLISH' NOT NULL,
    post_pass VARCHAR2(255) DEFAULT '',
    post_name VARCHAR2(200) DEFAULT '',
    post_mime_type VARCHAR2(100) DEFAULT '',
    post_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    post_modified_at TIMESTAMP NOT NULL, --디폴트는 post_created_at(글 생성일시)
    comment_status VARCHAR2(20) DEFAULT 'OPEN' NOT NULL,
    comment_count NUMBER(20) DEFAULT 0,
    
    -- 외래키 제약조건
    CONSTRAINT fk_post_author_posts FOREIGN KEY (post_author)  
        REFERENCES APP_MEMBER(id)    
        ON DELETE CASCADE 
);

-- APP_POSTS 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_POSTS_TRG
BEFORE INSERT ON APP_POSTS
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_POSTS_SEQ.NEXTVAL;
    END IF;
    -- post_modified_at컬럼의 기본값을 post_created_at으로 설정
    IF :NEW.post_modified_at IS NULL THEN
        :NEW.post_modified_at := :NEW.post_created_at;
    END IF;
END;



/* APP_POST_META
*/
-- APP_POST_META 테이블용 시퀀스 생성
CREATE SEQUENCE APP_POST_META_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [글(포스트) 메타]
create table APP_POST_META(
    meta_id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    post_id NUMBER(20,0) NOT NULL , -- 외래키
    meta_key VARCHAR2(255) NOT NULL,
    meta_value CLOB DEFAULT EMPTY_CLOB(),
    
    -- 외래키 제약조건
    CONSTRAINT fk_post_id_post_meta FOREIGN KEY (post_id)  
        REFERENCES APP_POSTS(id)    
        ON DELETE CASCADE 
);

-- APP_POST_META 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_POST_META_TRG
BEFORE INSERT ON APP_POST_META
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.meta_id IS NULL THEN
        :NEW.meta_id := APP_POST_META_SEQ.NEXTVAL;
    END IF;
END;



/* APP_POST_CATEGORY_RELATIONSHIPS
*/
-- [(글&카테고리 관계 테이블)]
create table APP_POST_CATEGORY_RELATIONSHIPS(
    post_id NUMBER(20,0) NOT NULL , -- FK
    term_category_id NUMBER(20,0) NOT NULL , -- FK
    
    -- 복합 기본키 설정(FK 2개를 PK로)
    CONSTRAINT PK_APP_POST_CATEGORY_RELATIONSHIPS PRIMARY KEY (post_id, term_category_id),
    
    -- 외래키 제약조건
    CONSTRAINT fk_post_id_post_category_relationships FOREIGN KEY (post_id)  
        REFERENCES APP_POSTS(id)    
        ON DELETE CASCADE ,
    CONSTRAINT fk_term_category_id_post_category_relationships FOREIGN KEY (term_category_id)  
        REFERENCES APP_TERM_CATEGORY(id)   
        ON DELETE CASCADE  
);



/* APP_RESOURCES_SEC
*/
-- APP_RESOURCES_SEC 테이블용 시퀀스 생성
CREATE SEQUENCE APP_RESOURCES_SEC_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [리소스 보안]
create table APP_RESOURCES_SEC(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    post_id NUMBER(20,0) NOT NULL , -- 외래키
    file_name NVARCHAR2(255),
    file_ext VARCHAR2(20) DEFAULT '',
    file_url VARCHAR2(500) DEFAULT '',
    enc_key VARCHAR2(255) DEFAULT '',
    enc_status NUMBER(1) DEFAULT 0 NOT NULL,
    
     -- 외래키 제약조건
    CONSTRAINT fk_post_id_resources_sec FOREIGN KEY (post_id)  
        REFERENCES APP_POSTS(id)    
        ON DELETE CASCADE 
);

-- APP_RESOURCES_SEC 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_RESOURCES_SEC_TRG
BEFORE INSERT ON APP_RESOURCES_SEC
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_RESOURCES_SEC_SEQ.NEXTVAL;
    END IF;
END;



/* APP_CHAT_ANSWER
*/
-- APP_CHAT_ANSWER 테이블용 시퀀스 생성
CREATE SEQUENCE APP_CHAT_ANSWER_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [답변]
create table APP_CHAT_ANSWER(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    file_name VARCHAR2(100) NOT NULL,
    intro CLOB NOT NULL,
    body CLOB NOT NULL,
    conclusion CLOB NOT NULL
);

-- APP_CHAT_ANSWER 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_CHAT_ANSWER_TRG
BEFORE INSERT ON APP_CHAT_ANSWER
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_CHAT_ANSWER_SEQ.NEXTVAL;
    END IF;
END;



/* APP_ANC
*/
-- [(답변&카테고리 관계 테이블)]
create table APP_ANC(
    term_category_id NUMBER(20,0) NOT NULL , -- FK
    answer_id NUMBER(20,0) NOT NULL , -- FK
    
    -- 복합 기본키 설정(FK 2개를 PK로)
    CONSTRAINT PK_APP_ANC PRIMARY KEY (term_category_id, answer_id),
    
    -- 외래키 제약조건
    CONSTRAINT fk_term_category_id_anc FOREIGN KEY (term_category_id)  
        REFERENCES APP_TERM_CATEGORY(id)    
        ON DELETE CASCADE ,
    CONSTRAINT fk_answer_id_anc FOREIGN KEY (answer_id)  
        REFERENCES APP_CHAT_ANSWER(id)    
        ON DELETE CASCADE  
);




/* APP_CHAT_QUESTION
*/
-- APP_CHAT_QUESTION 테이블용 시퀀스 생성
CREATE SEQUENCE APP_CHAT_QUESTION_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [질문]
create table APP_CHAT_QUESTION(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    content CLOB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- APP_CHAT_QUESTION 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_CHAT_QUESTION_TRG
BEFORE INSERT ON APP_CHAT_QUESTION
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_CHAT_QUESTION_SEQ.NEXTVAL;
    END IF;
END;


/* APP_CHAT_QNA
*/
-- APP_CHAT_QNA 테이블용 시퀀스 생성
CREATE SEQUENCE APP_CHAT_QNA_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [큐앤아이(대화&질문 관계 테이블)]
create table APP_CHAT_QNA(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    s_id NUMBER(20,0) NOT NULL , -- 외래키
    q_id NUMBER(20,0) NOT NULL , -- 외래키
    a_id NUMBER(20,0) NOT NULL , -- 외래키
    is_matched NUMBER(1,0) NOT NULL,
    
    -- 외래키 제약조건
    CONSTRAINT fk_s_id_chat_qna FOREIGN KEY (s_id)  
        REFERENCES APP_CHAT_SESSION(id)    
        ON DELETE CASCADE ,
    CONSTRAINT fk_q_id_chat_qna FOREIGN KEY (q_id)  
        REFERENCES APP_CHAT_QUESTION(id)    
        ON DELETE CASCADE,
    CONSTRAINT fk_a_id_chat_qna FOREIGN KEY (a_id)  
        REFERENCES APP_CHAT_ANSWER(id)    
        ON DELETE CASCADE
);

-- APP_CHAT_QNA 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_CHAT_QNA_TRG
BEFORE INSERT ON APP_CHAT_QNA
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_CHAT_QNA_SEQ.NEXTVAL;
    END IF;
END;



/* APP_KEYWORD_COUNTING
*/
-- APP_KEYWORD_COUNTING 테이블용 시퀀스 생성
CREATE SEQUENCE APP_KEYWORD_COUNTING_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [키워드 카운팅]
create table APP_KEYWORD_COUNTING(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    term_id NUMBER(20,0) NOT NULL, -- 외래키
    count NUMBER(10,0) DEFAULT 1 NOT NULL,
    searched_at VARCHAR2(10) NOT NULL, -- ex.'202502' , '20250215'
    
    -- 외래키 제약조건
    CONSTRAINT fk_term_id_keyword_counting FOREIGN KEY (term_id)  
        REFERENCES APP_TERMS(id)    
        ON DELETE CASCADE 
);

-- APP_KEYWORD_COUNTING 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_KEYWORD_COUNTING_TRG
BEFORE INSERT ON APP_KEYWORD_COUNTING
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_KEYWORD_COUNTING_SEQ.NEXTVAL;
    END IF;
END;



/* APP_CHAT_SESSION
*/
-- APP_CHAT_SESSION 테이블용 시퀀스 생성
CREATE SEQUENCE APP_CHAT_SESSION_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [대화 세션]
create table APP_CHAT_SESSION(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    member_id NUMBER(20,0) NOT NULL , -- 외래키
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL, -- 디폴트는 created_at
    status NUMBER(1,0) NOT NULL,
    count NUMBER(20,0) DEFAULT 0 NOT NULL,
    
     -- 외래키 제약조건
    CONSTRAINT fk_member_id_chat_session FOREIGN KEY (member_id)  
        REFERENCES APP_MEMBER(id)    
        ON DELETE CASCADE 
);

-- APP_CHAT_SESSION 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_CHAT_SESSION_TRG
BEFORE INSERT ON APP_CHAT_SESSION
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_CHAT_SESSION_SEQ.NEXTVAL;
    END IF;
    -- updated_at컬럼의 기본값을 created_at으로 설정
    IF :NEW.updated_at IS NULL THEN
        :NEW.updated_at := :NEW.created_at;
    END IF;
END;