--[APP_CHAT_QNA 테이블]

-- APP_CHAT_QNA 테이블용 시퀀스 생성
CREATE SEQUENCE APP_CHAT_QNA_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [큐앤아이(대화&질문 관계 테이블)]
create table APP_CHAT_QNA(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    s_id NUMBER(20,0) NOT NULL , -- 외래키
    q_id NUMBER(20,0) NOT NULL , -- 외래키
    a_id NUMBER(20,0) NOT NULL , -- 외래키
    is_matched NUMBER(1,0) NOT NULL,
    
    -- 외래키 제약조건
    CONSTRAINT fk_s_id_chat_qna FOREIGN KEY (s_id)  
        REFERENCES APP_CHAT_SESSION(id)    
        ON DELETE CASCADE ,
    CONSTRAINT fk_q_id_chat_qna FOREIGN KEY (q_id)  
        REFERENCES APP_CHAT_QUESTION(id)    
        ON DELETE CASCADE,
    CONSTRAINT fk_a_id_chat_qna FOREIGN KEY (a_id)  
        REFERENCES APP_CHAT_ANSWER(id)    
        ON DELETE CASCADE
);

-- APP_CHAT_QNA 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_CHAT_QNA_TRG
BEFORE INSERT ON APP_CHAT_QNA
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_CHAT_QNA_SEQ.NEXTVAL;
    END IF;
END;

-- APP_CHAT_QNA 테이블에 테스트 데이터 삽입
insert into APP_CHAT_QNA(s_id, q_id, a_id, is_matched)
values(1,1,1,0);

commit;

select * from APP_CHAT_QNA;


select * from APP_CHAT_SESSION;
select * from APP_CHAT_QUESTION;
select * from APP_CHAT_ANSWER;





