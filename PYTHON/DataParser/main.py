
# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    import os
    import aihealthcare

    path = os.path.dirname(os.path.abspath(__file__))
    aihc = aihealthcare.AIHealthCare()

    import re
    import urllib.parse # URLEncode

    termDisease = []
    termDepartment = []
    termIntention = []

    # 질문
    questions = aihc.load( path + "/../_DATA/초거대AI_사전학습용_헬스케어_질의응답_데이터/1.질문" )

    chats = []
    questions_total_count = len(str(len(questions) - 1))
    questions_index = 1

    for cnt in questions:
    #     """
    #     키 맵핑(Key Mapping)
    #         식별자(ID, 파일명) - fileName : str
    #
    #         참가자 정보 - participantsInfo : dict
    #             식별자(ID) - participantID : str
    #             성별 - gender : str
    #             연령 - age : str ( 00대 )
    #             직업 - occupation  : str
    #             기록 - history : boolean
    #             지역 - rPlace: str (sep = /)
    #         질병 - disease_category : str -> list
    #         질병 이름 - disease_name : dict => kor:str | eng:str
    #         의도 - intention : str -> list
    #         질문 - question : str
    #         개체그룹 - entities : list [ type(dict) ]
    #              ex. { "id": 0, "text": "고막염", "entity": "질환명", "position": 0 }
    #     """
    #    print(cnt['participantsInfo'])

        fileName = cnt['fileName'] # 파일 이름
        partInfo = cnt['participantsInfo'] # 참가자 정보
        _age = partInfo['age'] if 'age' in partInfo else 0
        _gender = partInfo['gender'] if 'gender' in partInfo else "남성"
        _gender = "M" if _gender == "남성" else "F"
        _occupation = partInfo['occupation'] if 'occupation' in partInfo else "기타"
        disease_category = cnt['disease_category'][0] if 'disease_category' in cnt else "기타"
        disease_name_kor = cnt['disease_name']['kor'] if 'disease_name' in cnt else "기타"
        disease_name_eng = cnt['disease_name']['eng'] if 'disease_name' in cnt else "others"
        question = cnt['question'] if 'question' in cnt else ""

        chats.append({
            "file_name": fileName,
            "age": _age,
            "gender": _gender,
            "occupation": _occupation,
            "disease_category": disease_category,
            "disease_name_kor": disease_name_kor,
            "disease_name_eng": disease_name_eng,
            "question": question
        } )
        questions_index += 1

    for i in range(0, len(chats), 10000):
        data = chats[i:i + 10000]
        with open(f'questions_{(i + 10000)}.sql', encoding="utf-8", mode="w") as fc:
            # APP_EXTERNAL_QUESTION
            for d in data:
                # age | disease_category | disease_name_kor | disease_name_eng | file_name | gender | occupation | question
                fc.write("INSERT INTO APP_EXTERNAL_QUESTION( age, disease_category, disease_name_kor, disease_name_eng, file_name, gender, occupation, question ) VALUES( '" + d['age'] + "', '" + d['disease_category'] + "', '" + d['disease_name_kor'] + "', '" + d['disease_name_eng'] + "', '" + d['file_name'] + "', '" + d['gender'] + "', '" + d['occupation'] + "', '" + d['question'] + "' );\n")



    # 답변
    answers = aihc.load( path + "/../_DATA/초거대AI_사전학습용_헬스케어_질의응답_데이터/2.답변" )

    termDisease = []
    termDepartment = []
    termIntention = []

    disease = []
    department = []
    intention = []
    chats = []

    answers_total_count = len(str(len(answers) - 1))
    answers_index = 1

    for cnt in answers :
        """
        키 맵핑(Key Mapping)
            식별자(ID, 파일명) - fileName : str
            질병 - disease_category : str -> list
            질병 이름 - disease_name : dict => kor:str | eng:str
            진료과 - department : list
            의도 - intention : str -> list
            답변 - answer : dict => intro : str | body : str | conclusion : str
        """
        # all_cats = []
        # termDisease = []
        # termDepartment = []
        # termIntention = []
        # chats = []
        all_cats = []

        # 질병
        disease_category = [ _.strip() for _ in cnt['disease_category'] if _.strip() ]
        for term in disease_category :
            _slug = urllib.parse.quote(term)
            _name = term
            if not _name :
                continue

            if _slug not in [_['slug'] for _ in termDisease] :
                termDisease.append( { "slug": _slug, "name": _name, "parent": "" } )
            all_cats.append(_slug)

            # 질병
        disease_name = cnt['disease_name'] # disease (kor | eng)
        if disease_name :
            term = disease_name
            _slug = urllib.parse.quote(
                re.sub(
                    r"\s+",
                    "_",
                    term['eng'].lower().strip()
                ) if term['eng'] else  term['kor']
            )
            _name = term['kor'].strip()
            _parent = disease_category[0].strip()
            if _slug not in [_['slug'] for _ in termDisease]:
                termDisease.append({"slug": _slug, "name": _name, "parent": _parent})
            all_cats.append(_slug)

        # 진료과
        department = [ _.strip() for _ in cnt['department'] if _.strip() ] # department
        for term in department:
            _slug = urllib.parse.quote(term)
            _name = term
            if _slug not in [_['slug'] for _ in termDepartment]:
                termDepartment.append({"slug": _slug, "name": _name, "parent": ""})
            all_cats.append(_slug)

        # 의도
        intention = [ _.strip() for _ in cnt['intention'] if _.strip() ] # intention
        for term in intention:
            _slug = urllib.parse.quote(term)
            _name = term
            if not _name :
                continue
            if _slug not in [_['slug'] for _ in termIntention]:
                termIntention.append({"slug": _slug, "name": _name, "parent": ""})
            all_cats.append(_slug)

        # 채팅 : 답변
        chats.append( {
            "filename": cnt['fileName'] + ' ' + f"{answers_index:0{answers_total_count}}",
            "categories": all_cats,
            "intro" : cnt['answer']['intro'],
            "body": cnt['answer']['body'],
            "conclusion": cnt['answer']['conclusion']
        } )
        answers_index += 1

    # termDisease = []
    # termDepartment = []
    # termIntention = []
    with open("terms.sql", encoding="utf-8", mode="w") as fc:

        index = 1
        for terms in [ termDisease, termDepartment, termIntention ]:
            if index == 1 :
                taxonomy = 'disease'
            elif index == 2 :
                taxonomy = 'department'
            else :
                taxonomy = 'intention'
            index += 1
            for term in terms:
                _name = term['name']
                _slug = term['slug']

                # APP_TERMS: INSERT
                fc.write("INSERT INTO APP_TERMS( name, slug ) VALUES('" + _name + "', '" + _slug + "');\n")

                # APP_TERM_CATEGORY: INSERT
                _term_id = "(SELECT id FROM APP_TERMS WHERE slug='" + _slug + "')"
                _parent = '0' if term['parent'] == "" else "(SELECT id FROM APP_TERMS WHERE name='" + term['parent'] + "')"
                fc.write("INSERT INTO APP_TERM_CATEGORY( term_id, category, parent ) VALUES(" + _term_id + ", '" + taxonomy + "', " + _parent + ");\n")

    for i in range(0, len(chats), 10000):
        if i == 0:
            with open(f'answer_0.sql', encoding="utf-8", mode="w") as fc:
                fc.write("INSERT INTO APP_TERMS( name, slug ) VALUES('답변', 'answer');\n")
                fc.write("INSERT INTO APP_TERM_CATEGORY( term_id, category, parent ) VALUES((SELECT id FROM APP_TERMS WHERE slug='answer'), 'chat', 0);\n")

        data = chats[i:i + 10000]
        with open(f'answer_{(i + 10000)}.sql', encoding="utf-8", mode="w") as fc:
            for d in data:
                # APP_CHAT_ANSWER
                fc.write("INSERT INTO APP_CHAT_ANSWER( file_name, intro, body, conclusion ) VALUES( '" + d['filename'] + "', '" + d['intro'] + "', '" + d['body'] + "', '" + d['conclusion'] + "' );\n")

                # APP_ANC
                _term_id = "(SELECT id FROM APP_TERM_CATEGORY WHERE term_id=(SELECT id FROM APP_TERMS WHERE slug='answer'))"
                _id = "(SELECT id FROM APP_CHAT_ANSWER WHERE file_name='" + d['filename'] + "')"
                fc.write("INSERT INTO APP_ANC( term_category_id, answer_id ) VALUES(" + _term_id + ", " + _id + ");\n")

                for _slug in d['categories']:
                    _term_id = "(SELECT id FROM APP_TERM_CATEGORY WHERE term_id=(SELECT id FROM APP_TERMS WHERE slug='" + _slug + "'))"
                    fc.write("INSERT INTO APP_ANC( term_category_id, answer_id ) VALUES(" + _term_id + ", " + _id + ");\n")
