--[APP_POST_CATEGORY_RELATIONSHIPS 테이블]

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

-- APP_POST_CATEGORY_RELATIONSHIPS 테이블에 테스트 데이터 삽입
insert into APP_POST_CATEGORY_RELATIONSHIPS(post_id, term_category_id)
values(1,3);

commit;

select * from APP_POST_CATEGORY_RELATIONSHIPS;








