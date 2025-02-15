--[APP_POST_CATEGORY_RELATIONSHIPS 테이블]

-- [(글&카테고리 관계 테이블)]
create table APP_POST_CATEGORY_RELATIONSHIPS(
    post_id NUMBER(20,0) NOT NULL REFERENCES APP_POSTS(id), -- FK
    term_category_id NUMBER(20,0) NOT NULL REFERENCES APP_TERM_CATEGORY(id), -- FK
    
    -- 복합 기본키 설정(FK 2개를 PK로)
    CONSTRAINT PK_APP_POST_CATEGORY_RELATIONSHIPS PRIMARY KEY (post_id, term_category_id)
);

-- APP_POST_CATEGORY_RELATIONSHIPS 테이블에 테스트 데이터 삽입
insert into APP_POST_CATEGORY_RELATIONSHIPS(post_id, term_category_id)
values(2,2);

select * from APP_POST_CATEGORY_RELATIONSHIPS;








