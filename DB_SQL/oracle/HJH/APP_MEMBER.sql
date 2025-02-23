--[APP_MEMBER 테이블]

-- APP_MEMBER 테이블용 시퀀스 생성
CREATE SEQUENCE APP_MEMBER_SEQ
START WITH 1  -- 시작 값
INCREMENT BY 1  -- 증가 값
NOCACHE  -- 캐싱하지 않음 (캐싱:일정 개수의 시퀀스 값을 미리 메모리에 저장)
NOCYCLE;  -- 최대값 도달 시 다시 1부터 시작하지 않음

-- [회원]
create table APP_MEMBER(
    id NUMBER(20,0) PRIMARY KEY, -- 시퀀스 값
    email VARCHAR2(255) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    role VARCHAR2(20) DEFAULT 'USER' NOT NULL, -- 디폴트 설정이 not null 설정보다 앞이다
    name NVARCHAR2(100),
    nickname NVARCHAR2(255) NOT NULL,
    birth DATE,
    gender CHAR(1),
    contact VARCHAR2(20),
    address NVARCHAR2(500),
    token VARCHAR2(255) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL, -- post_created_at(글 생성일시)
    status NUMBER(1,0) NOT NULL
);
 
-- APP_MEMBER 테이블에 대한 트리거 설정
CREATE OR REPLACE TRIGGER APP_MEMBER_TRG
BEFORE INSERT ON APP_MEMBER
FOR EACH ROW -- 행 단위 트리거 - 행 단위로 변경된 횟수만큼 실행됨
BEGIN -- 프로그램 코딩부
    -- id컬럼(PK) 자동 증가
    IF :NEW.id IS NULL THEN
        :NEW.id := APP_MEMBER_SEQ.NEXTVAL;
    END IF;
    -- updated_at컬럼의 기본값을 created_at으로 설정
    IF :NEW.updated_at IS NULL THEN
        :NEW.updated_at := :NEW.created_at;
    END IF;
END;

-- APP_MEMBER 테이블에 테스트 데이터 삽입
insert into APP_MEMBER(email,password,role,name,nickname,birth,gender,contact,address,token,created_at,updated_at,status)
values('email','pwd',default,'name','nick',SYSDATE,'F','010','addr',default,default,default,1);

insert into APP_MEMBER(email,password,role,name,nickname,birth,gender,contact,address,token,created_at,updated_at,status)
values('email2','pwd2',default,'name2','nick2',TO_DATE('2025-02-14'),'F','01011','addr2',default,default,default,0);

insert into APP_MEMBER(email,password,role,name,nickname,birth,gender,contact,address,token,created_at,updated_at,status)
values('email3','pwd3',default,'name3','nick3',TO_DATE('2025-02-15'),'F','010222','addr3',default,default,default,0);

insert into APP_MEMBER(email,password,role,name,nickname,birth,gender,contact,address,token,created_at,status)
values('email4','pwd4',default,'name3','nick3',TO_DATE('2025-02-15'),'F','010222','addr3',default,default,0);

commit;

select * from APP_MEMBER;


