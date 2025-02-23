--[APP_KEYWORD_COUNTING 테이블]

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

-- APP_KEYWORD_COUNTING 테이블에 테스트 데이터 삽입
insert into APP_KEYWORD_COUNTING(term_id,searched_at)
values(1,'202502');

insert into APP_KEYWORD_COUNTING(term_id,searched_at)
values(2,'20250215');

commit;

select * from APP_KEYWORD_COUNTING;







