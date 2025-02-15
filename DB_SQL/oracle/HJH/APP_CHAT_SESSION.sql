--[APP_CHAT_SESSION 테이블]

-- APP_CHAT_SESSION 테이블용 시퀀스 생성
CREATE SEQUENCE APP_CHAT_SESSION_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [대화 세션]
create table APP_CHAT_SESSION(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    member_id NUMBER(20,0) NOT NULL REFERENCES APP_MEMBER(id), -- 외래키
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL, -- 디폴트는 created_at
    status NUMBER(1,0) NOT NULL,
    count NUMBER(20,0) DEFAULT 0 NOT NULL
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

-- APP_CHAT_SESSION 테이블에 테스트 데이터 삽입
insert into APP_CHAT_SESSION(member_id,updated_at,status)
values(1,SYSDATE,1);

insert into APP_CHAT_SESSION(member_id,updated_at,status)
values(2,TO_TIMESTAMP('2025-02-15 9:00:00'),0);

select * from APP_CHAT_SESSION;





