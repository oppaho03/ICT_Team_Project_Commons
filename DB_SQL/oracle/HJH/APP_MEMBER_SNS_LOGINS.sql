--[APP_MEMBER_SNS_LOGINS 테이블]

-- APP_MEMBER_SNS_LOGINS 테이블용 시퀀스 생성
CREATE SEQUENCE APP_MEMBER_SNS_LOGINS_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [회원SNS로그인]
create table APP_MEMBER_SNS_LOGINS(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    member_id NUMBER(20,0) NOT NULL , --외래키
    -- login_id는 반드시 빈문자열이 아닌 문자열로 넘어오는 값이다
    login_id VARCHAR2(100) DEFAULT '' NOT NULL,
    provider VARCHAR2(20) NOT NULL,
    provider_id VARCHAR2(255) UNIQUE NOT NULL,
    access_token CLOB,
    refresh_token CLOB,
    status NUMBER(1) DEFAULT 1 NOT NULL,
    login_modified_at TIMESTAMP NOT NULL,
    login_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    -- 외래키 제약조건
    CONSTRAINT fk_member_id_member FOREIGN KEY (member_id)  
        REFERENCES APP_MEMBER(id)    
        ON DELETE CASCADE 
);

-- APP_MEMBER_SNS_LOGINS 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_MEMBER_SNS_LOGINS_TRG
BEFORE INSERT ON APP_MEMBER_SNS_LOGINS
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_MEMBER_SNS_LOGINS_SEQ.NEXTVAL;
    END IF;
END;

-- APP_MEMBER_SNS_LOGINS 테이블에 테스트 데이터 삽입
insert into APP_MEMBER_SNS_LOGINS(member_id, login_id, provider, provider_id, login_modified_at)
values(1,'id1','sns1',1,TO_TIMESTAMP('2025-02-15 11:46'));

insert into APP_MEMBER_SNS_LOGINS(member_id,login_id,provider,provider_id,login_modified_at,status)
values(2,'id2','sns2',2,TO_TIMESTAMP('2025-02-15 11:46'),DEFAULT);

insert into APP_MEMBER_SNS_LOGINS(member_id,login_id,provider,provider_id,login_modified_at,login_created_at)
values(3,'id3','sns3',3,TO_TIMESTAMP('2025-02-15 11:46'),DEFAULT);

commit;

select * from APP_MEMBER_SNS_LOGINS;






