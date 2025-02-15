--[APP_TERM_CATEGORY 테이블]

-- APP_TERM_CATEGORY 테이블용 시퀀스 생성
CREATE SEQUENCE APP_TERM_CATEGORY_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [카테고리(텍소노미)]
create table APP_TERM_CATEGORY(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    term_id NUMBER(20,0) NOT NULL REFERENCES APP_TERMS(id), -- 외래키
    category VARCHAR2(20) UNIQUE NOT NULL,
    description CLOB DEFAULT '',
    count NUMBER(20,0) DEFAULT 0,
    parent NUMBER(20,0) DEFAULT 0
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

-- APP_TERM_CATEGORY 테이블에 테스트 데이터 삽입
insert into APP_TERM_CATEGORY(term_id,category)
values(1,'c1');

insert into APP_TERM_CATEGORY(term_id,category)
values(2,'c2');

insert into APP_TERM_CATEGORY(term_id,category,description)
values(6,'c3',default);

select * from APP_TERM_CATEGORY;







