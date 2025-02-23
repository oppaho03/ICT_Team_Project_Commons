--[APP_RESOURCES_SEC 테이블]

-- APP_RESOURCES_SEC 테이블용 시퀀스 생성
CREATE SEQUENCE APP_RESOURCES_SEC_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [리소스 보안]
create table APP_RESOURCES_SEC(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    post_id NUMBER(20,0) NOT NULL , -- 외래키
    file_name NVARCHAR2(255),
    file_ext VARCHAR2(20) DEFAULT '',
    file_url VARCHAR2(500) DEFAULT '',
    enc_key VARCHAR2(255) DEFAULT '',
    enc_status NUMBER(1) DEFAULT 0 NOT NULL,
    
     -- 외래키 제약조건
    CONSTRAINT fk_post_id_resources_sec FOREIGN KEY (post_id)  
        REFERENCES APP_POSTS(id)    
        ON DELETE CASCADE 
);

-- APP_RESOURCES_SEC 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_RESOURCES_SEC_TRG
BEFORE INSERT ON APP_RESOURCES_SEC
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_RESOURCES_SEC_SEQ.NEXTVAL;
    END IF;
END;

-- APP_RESOURCES_SEC 테이블에 테스트 데이터 삽입
insert into APP_RESOURCES_SEC(post_id)
values(2);

commit;

select * from APP_RESOURCES_SEC;







