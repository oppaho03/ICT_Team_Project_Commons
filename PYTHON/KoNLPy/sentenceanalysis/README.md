# 감정 분석 패키지 (Sentence Analysis) 

##  datasets
### 패키지 (Package)
- KoNLPy 
  - $pip install konlpy
- Scikit-learn
  - $pip install -U scikit-learn
- Pandas
  - $pip install -U pandas

### 학습용 데이터셋 
- NSMC( Naver sentiment movie corpus v1.0  )
- KNU 한국어 감성 사전

### Example 
```python

import os
from datasets import DatasetNSMC
path = os.path.dirname(os.path.abspath(__file__))  # 현재 파일의 디렉토리

# Dataset : NSMC( Naver sentiment movie corpus v1.0  )
dataset = DatasetNSMC(path + '/../../_DATA/nsmc/ratings_train.txt')
# 리소스 파일(ratings_train.txt) 에서 명사 및 긍정 또는 부정 태킹 Iterable 객체 반환
words = dataset.parse()
# 명사 및 긍정 또는 부정 태킹된 Iterable 객체를 파일로 작성
# - save 명사는 중첩 되므로, 최초 1회만 실행
dataset.save(words, path="../words.txt", encoding="utf-8")
if dataset.load(path="words.txt", encoding="utf-8") :
  # -1 : 부정, 0 : 중립 : 1 긍정 
  dataset.analyze_sentence( "가난한 인생" ) 
```
