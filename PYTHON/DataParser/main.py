
# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    import os
    import aihealthcare

    path = os.path.dirname(os.path.abspath(__file__))
    aihc = aihealthcare.AIHealthCare()

    import re
    import urllib.parse # URLEncode


    # 질문
    # questions = aihc.load(path + "/../_DATA/초거대AI_사전학습용_헬스케어_질의응답_데이터/1.질문")
    # for cnt in questions:
    #     """
    #     키 맵핑(Key Mapping)
    #         식별자(ID, 파일명) - fileName : str
    #
    #         참가자 정보 - participantsInfo : dict
    #             식별자(ID) - participantID : str
    #             성별 - gender : str
    #             연령 - age : str ( 00대 )
    #             직업 - occupation : str
    #             기록 - history : boolean
    #             지역 - rPlace: str (sep = /)
    #         질병 - disease_category : str -> list
    #         질병 이름 - disease_name : dict => kor:str | eng:str
    #         의도 - intention : str -> list
    #         질문 - question : str
    #         개체그룹 - entities : list [ type(dict) ]
    #              ex. { "id": 0, "text": "고막염", "entity": "질환명", "position": 0 }
    #     """
    #     print(cnt)

    # 답변
    answers = aihc.load( path + "/../_DATA/초거대AI_사전학습용_헬스케어_질의응답_데이터/2.답변" )
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
        