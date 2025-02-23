--[APP_POSTS 테이블]

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

-- APP_POSTS 테이블에 테스트 데이터 삽입
insert into APP_POSTS(post_author,post_title, post_created_at, post_modified_at )
values(1,'title', SYSDATE, DEFAULT);

insert into APP_POSTS(post_author,post_title, post_created_at, post_modified_at )
values(2,'title2', TO_TIMESTAMP('2025-02-14 11:12:15'),DEFAULT);

insert into APP_POSTS(post_author,post_title, post_content, post_created_at, post_modified_at )
values(2,'title2',DEFAULT, TO_TIMESTAMP('2025-02-14 11:12:15'),DEFAULT);

commit;

-- 오라클은 CLOB타입일때, DEFAULT EMPTY_CLOB() 으로 디폴트값 설정하면
-- 값을 안 넣거나 DEFAULT로 넣을때 빈문자열로 잘 들어간다

select * from APP_POSTS;





