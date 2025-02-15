--[APP_TERMS 테이블]

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

-- APP_TERMS 테이블에 테스트 데이터 삽입
/* 
    name 이나 slug 에 ''(빈문자열)도 오라클에서 NULL로 처리되어서 빈문자열 넣으면 에러남(디폴트도 빈문자로 돼있어서 디폴트로 값 삽입도 에러남)
    하지만 서버로 데이터가 넘어올때는 빈문자열이 아니라 무조건 값이 있기 때문에 테스트시 name이랑 slug 컬럼에는 빈문자가 아닌 문자열을 넣어서 테스트해야 함
*/
insert into APP_TERMS(name,slug,group_number)
values('용어1','slug1',0);

insert into APP_TERMS(name,slug)
values('용어2','slug2');


select * from APP_TERMS;

-- DROP TRIGGER APP_TERMS_TRG;

