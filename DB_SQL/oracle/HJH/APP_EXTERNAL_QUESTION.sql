--[APP_EXTERNAL_QUESTION 테이블]

-- APP_EXTERNAL_QUESTION 테이블용 시퀀스 생성
CREATE SEQUENCE APP_EXTERNAL_QUESTION_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [외부 질문]
create table APP_EXTERNAL_QUESTION(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    file_name VARCHAR2(20),
    gender CHAR(1),
    age NVARCHAR2(20),
    occupation NVARCHAR2(100),
    disease_category NVARCHAR2(200),
    disease_name_kor NVARCHAR2(200),
    disease_name_eng VARCHAR2(200),
    question CLOB DEFAULT EMPTY_CLOB()
);

-- APP_EXTERNAL_QUESTION 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_EXTERNAL_QUESTION_TRG
BEFORE INSERT ON APP_EXTERNAL_QUESTION
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_EXTERNAL_QUESTION_SEQ.NEXTVAL;
    END IF;
END;

commit;

select * from APP_EXTERNAL_QUESTION;
