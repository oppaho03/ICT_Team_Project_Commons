import csv
import os
import pandas as pd
from konlpy.tag import Okt
from collections import Counter

from collections.abc import Iterable

from pandas.io.common import file_exists


class Dataset :
  STOP_WORDS = ['이', '그', '저', '영화', '이다', '것', '수', '하', '우리', '저기']

  def __init__(self, path: str ):
    self.path = path
    self.neu_words = self.neg_words = self.pos_words = []

  @property
  def path(self):
    return self._path

  @path.setter
  def path(self, value: str):
    self._path = value

  @property
  def neu_words(self):
    return self._neu_words

  @neu_words.setter
  def neu_words(self, value: any):
    self._neu_words = value

  @property
  def neg_words(self):
    return self._neg_words

  @neg_words.setter
  def neg_words(self, value: any):
    self._neg_words = value

  @property
  def pos_words(self):
    return self._pos_words

  @pos_words.setter
  def pos_words(self, value: any):
    self._pos_words = value

  @staticmethod
  def save(contents: Iterable, *, path: str = "words.txt", encoding: str = "utf-8") -> bool:
    """
    :param contents: [0] word, [1] score
    :param path: sawords.txt (Sentiment analysis words)
    :param encoding: utf-8
    :return:
    """
    exists = os.path.exists(path)

    with open(path, mode="a", encoding=encoding, newline="") as file:
      writer = csv.writer(file, delimiter="\t")
      if not exists: writer.writerow(["noun", "label"])
      writer.writerows(contents)  # 새 데이터 추가
    return True

  @staticmethod
  def count(datas: None | Iterable) -> int:
    """
    출현 빈도 카운트 (frequency count)
    :param datas:
    :return:
    """
    # word_counts = Counter(positive_words)
    # word_counts.most_common(20)
    return 0 if not datas else Counter(datas)

  def load(self, path: str = "words.txt", *, encoding: str = "utf-8") -> bool:
    """
    :param path:
    :param encoding:
    :return:
    """
    exists = os.path.exists(path)
    words = None
    neu_words = neg_words = pos_words = []

    if exists :
      # 데이터 프레임
      # noun | label
      words = pd.read_csv(path, sep='\t').dropna(subset=['noun'])  # 데이터 프레임 생성
      neu_words = words[words['label'] == 0]['noun']
      neg_words = words[words['label'] == -1]['noun']
      pos_words = words[words['label'] == 1]['noun']
    # end if exists :

    self.neu_words = list(neu_words)
    self.neg_words = list(neg_words)
    self.pos_words = list(pos_words)

    return words is not None

  def analyze_sentence( self, sentence: str ) -> int:
    """
    :param sentence:
    :return:
    """
    # 형태소 분석기 설정
    okt = Okt()

    pos_words = self.pos_words
    neg_words = self.neg_words

    tokens = okt.pos(sentence)  # 형태소 분석 후 단어와 품사 분리

    pos_count = sum(1 for word, pos in tokens if pos in ['Noun', 'Adjective'] and word in pos_words)
    neg_count = sum(1 for word, pos in tokens if pos in ['Noun', 'Adjective'] and word in neg_words)
    print(sentence, neg_count, pos_count)
    if neg_count >= pos_count: return -1
    elif pos_count > neg_count: return 1
    else: return 0

  def parse(self, encoding: str = "utf-8") -> None:
    pass

# end class 'Dataset'

# Naver sentiment movie corpus v1.0
class DatasetNSMC (Dataset) :

  def ext_words(self, sentences: any ) -> None | list:
    """
    :param sentences:
    :param label:
    :return:
    """
    result = []
    if isinstance(sentences, str): sentences = [sentences]

    if isinstance(sentences, Iterable) :
      # 형태소 분석기 설정
      okt = Okt()
      for sentence in sentences:
        # 형태소 분석 (품사 태깅)
        for word, pos in okt.pos( str(sentence) ):
          # 명사와 형용사만 추출
          if pos not in ['Noun', 'Adjective']: continue
          if word not in self.STOP_WORDS: result.append( word )
      # for s in sentences:
    else : return []

    return result

  def parse(self, encoding: str = "utf-8") -> None | Iterable :
    """
    :param encoding:
    :return: bool
    """
    path = self.path

    # stopwords = self.STOP_WORDS # 불용어 리스트
    wordsDataFrame = []

    try:
      # 형태소 분석기 설정
      okt = Okt()

      # 데이터 프레임 생성
      dataFrame = pd.read_csv(path, sep='\t').dropna(subset=['document'])

      # 긍정/부정 리뷰 분리
      # sentences_group[] = [0] : 부정, [1]: 긍정
      sentences_group = [
        dataFrame[dataFrame['label'] == 0]['document'],
        dataFrame[dataFrame['label'] == 1]['document']
      ]
      neg_words, pos_words = [ self.ext_words( sentences ) for sentences in sentences_group  ]

      wordsDataFrame = (list(map(lambda x: [x, -1], neg_words))
                        + list(map(lambda x: [x, 1], pos_words)))
    except FileNotFoundError as e :
      print( e )

    return wordsDataFrame

# end class 'DatasetNSMC'

class DatasetKNU (Dataset):

  def ext_words(self, sentences: any ) -> None | list:
    """
    :param sentences:
    :param label:
    :return:
    """
    result = []
    if isinstance(sentences, str): sentences = [sentences]

    if isinstance(sentences, Iterable) :
      for sentence in sentences:
        # 주석이나 빈 줄은 건너뜀
        if not sentence.strip() or sentence.startswith('#'): continue
        parts = sentence.split('\t')
        if len(parts) == 2:
          noun = parts[0]
          label = int(parts[1].strip())
          if label < 0 : label = -1
          elif label > 0 : label = 1
          result.append([noun, label])
    else : return []

    return result

  def parse(self, encoding: str = "utf-8") -> None | Iterable :
    """
    :param encoding:
    :return: bool
    """
    path = self.path

    wordsDataFrame = []
    try:
      with open(path, 'r', encoding=encoding) as file:
        wordsDataFrame = self.ext_words( file )
      # with
      pass
    except FileNotFoundError as e :
      print( e )

    return wordsDataFrame

# end class 'DatasetKNU'