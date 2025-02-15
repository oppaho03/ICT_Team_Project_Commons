--[APP_ANC 테이블]

-- [(답변&카테고리 관계 테이블)]
create table APP_ANC(
    term_category_id NUMBER(20,0) NOT NULL REFERENCES APP_TERM_CATEGORY(id), -- FK
    answer_id NUMBER(20,0) NOT NULL REFERENCES APP_CHAT_ANSWER(id), -- FK
    
    -- 복합 기본키 설정(FK 2개를 PK로)
    CONSTRAINT PK_APP_ANC PRIMARY KEY (term_category_id, answer_id)
);

-- APP_ANC 테이블에 테스트 데이터 삽입
insert into APP_ANC(term_category_id, answer_id)
values(2,2);

select * from APP_ANC;









