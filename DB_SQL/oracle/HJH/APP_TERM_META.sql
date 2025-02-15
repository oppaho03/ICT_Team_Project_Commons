--[APP_TERM_META 테이블]

-- APP_TERM_META 테이블용 시퀀스 생성
CREATE SEQUENCE APP_TERM_META_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [용어 메타]
create table APP_TERM_META(
    meta_id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    term_id NUMBER(20,0) NOT NULL REFERENCES APP_TERMS(id), -- 외래키
    meta_key VARCHAR2(255) NOT NULL,
    meta_value CLOB DEFAULT EMPTY_CLOB()
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

-- APP_TERM_META 테이블에 테스트 데이터 삽입
insert into APP_TERM_META(term_id,meta_key)
values(2,'key1');

insert into APP_TERM_META(term_id,meta_key,meta_value)
values(1,'k2',DEFAULT);

insert into APP_TERM_META(term_id,meta_key,meta_value)
values(2,'k3','v3');

select * from APP_TERM_META;





