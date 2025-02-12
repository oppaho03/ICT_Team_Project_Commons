import os
from .datasets import Dataset, DatasetNSMC, DatasetKNU

__all__ = [
  'Dataset',
  'DatasetNSMC',
  'DatasetKNU',
]

if __name__ == '__main__':
  """
    
    데이터셋 구성 관련 클래스 
    Dataset > DatasetNSMC | DatasetKNU    
    
    1. Create instance 
    2. Parsing resources file
    3. save, output file (default file path: words.txt)
     
  """

  path = os.path.dirname(os.path.abspath(__file__))  # 현재 파일의 디렉토리

  # Dataset : NSMC( Naver sentiment movie corpus v1.0  )
  datasetNSMC = DatasetNSMC(path + '/../../_DATA/nsmc/ratings_train.txt')
  # 리소스 파일(ratings_train.txt) 에서 명사 및 긍정 또는 부정 태킹 Iterable 객체 반환
  words = datasetNSMC.parse()
  # 명사 및 긍정 또는 부정 태킹된 Iterable 객체를 파일로 작성
  # - save 명사는 중첩 되므로, 최초 1회만 실행
  datasetNSMC.save(words, path="../words.txt", encoding="utf-8")

  # Dataset : KNU 한국어 감성 사전
  datasetKNU = DatasetKNU(path + '/../../_DATA/knu_senti_dict/SentiWord_Dict.txt')
  # 리소스 파일(SentiWord_Dict.txt) 에서 명사 및 긍정 또는 부정 태킹 Iterable 객체 반환
  words = datasetKNU.parse()
  # 명사 및 긍정 또는 부정 태킹된 Iterable 객체를 파일로 작성
  # - save 명사는 중첩 되므로, 최초 1회만 실행
  datasetKNU.save(words, path="../words.txt", encoding="utf-8")

  # DatasetNSMC | DatasetKNU 이 동일한 파일 (words.txt) 을 사용할 경우,
  # 문장 분석 메소드 analyze_sentence() 결과는 동일
  datasetKNU.analyze_sentence( "안녕하세요?" ) # -1 : 부정, 0 : 중립 : 1 긍정 
