INSERT INTO APP_TERMS( name, slug ) VALUES('답변', 'answer');
INSERT INTO APP_TERM_CATEGORY( term_id, category, parent ) VALUES((SELECT id FROM APP_TERMS WHERE slug='answer'), 'chat', 0);