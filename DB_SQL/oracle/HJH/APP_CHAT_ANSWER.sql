--[APP_CHAT_ANSWER 테이블]

-- APP_CHAT_ANSWER 테이블용 시퀀스 생성
CREATE SEQUENCE APP_CHAT_ANSWER_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [답변]
create table APP_CHAT_ANSWER(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    file_name VARCHAR2(20) NOT NULL,
    intro CLOB NOT NULL,
    body CLOB NOT NULL,
    conclusion CLOB NOT NULL
);

-- APP_CHAT_ANSWER 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_CHAT_ANSWER_TRG
BEFORE INSERT ON APP_CHAT_ANSWER
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_CHAT_ANSWER_SEQ.NEXTVAL;
    END IF;
END;

-- APP_CHAT_ANSWER 테이블에 테스트 데이터 삽입
insert into APP_CHAT_ANSWER(file_name,intro, body, conclusion)
values('f_name1','intro1','body1','conclusion1');

insert into APP_CHAT_ANSWER(file_name,intro, body, conclusion)
values('f_name2','intro2','body2','conclusion2');

commit;

select * from APP_CHAT_ANSWER;



