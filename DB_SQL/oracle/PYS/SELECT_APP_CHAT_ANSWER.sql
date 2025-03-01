/* APP_CHAT_ANSWER 테이블의 intro, body, conclusion 컬럼에 Oracle Text 인덱스 추가
*/
-- CONTAINS 를 통해 검색을 위해 CLOB 형 컬럼에 CTXSYS.CONTEXT 인덱싱 적용
CREATE INDEX idx_chat_answer_text ON APP_CHAT_ANSWER(intro) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX idx_chat_answer_body ON APP_CHAT_ANSWER(body) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX idx_chat_answer_conclusion ON APP_CHAT_ANSWER(conclusion) INDEXTYPE IS CTXSYS.CONTEXT;

/* 검색 패턴 (Search)
 * 키워드 : '고혈압', '당뇨', '혈당', '관리' 
*/
-- 1. 용어 또는 카테고리(APP_TERMS, APP_TERM_CATEGORY, APP_ANC) 우선 검사
SELECT anc.answer_id 
FROM APP_TERMS t
LEFT JOIN APP_TERM_CATEGORY tc ON t.id = tc.term_id
LEFT JOIN APP_ANC anc ON tc.id = anc.term_category_id
WHERE t.name IN ('고혈압', '당뇨', '혈당', '관리');

-- 2. 답변에서 CONTAINS 사용하여 검색
-- scores 는 각 intro, body, conclusion 컬럼 당 검색 결과 총합 
SELECT scores, id 
FROM (
    SELECT a.*, SCORE(1) + SCORE(2) + SCORE(3) AS scores
    FROM APP_CHAT_ANSWER a
    WHERE 
        CONTAINS(a.intro, '고혈압 OR 당뇨 OR 혈당 OR 관리', 1) > 0
        OR CONTAINS(a.body, '고혈압 OR 당뇨 OR 혈당 OR 관리', 2) > 0
        OR CONTAINS(a.conclusion, '고혈압 OR 당뇨 OR 혈당 OR 관리', 3) > 0
    ORDER BY scores DESC
) 
WHERE ROWNUM <= 20;