--drop table app_terms;
--drop table app_keyword_counting;
--drop table app_term_meta;
--drop table app_term_category;
--drop table app_posts;
--drop table app_post_category_relationships;
--drop table app_post_meta;
--drop table app_resources_sec;
--drop table app_member;
--drop table app_member_sns_logins;
--drop table app_member_meta;
--drop table app_chat_answer;
--drop table app_chat_question;
--drop table app_anc;
--drop table app_chat_qna;
--drop table app_chat_session;

select * from user_constraints where owner='TEAM'; --제약조건
-- alter table 테이블명 drop constraint 제약조건명; --제약조건 삭제

