--[APP_ANC 테이블]

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

-- APP_ANC 테이블에 테스트 데이터 삽입
insert into APP_ANC(term_category_id, answer_id)
values(3,1);

commit;

select * from APP_ANC;









