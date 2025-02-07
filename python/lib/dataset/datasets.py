"""
Dataset 클래스 또는 Dataset 클래스를 상속 받는 클래스
-
-
"""
import os, re, copy
import json
from .interfaces import BaseDataset

EncodingTypes = {
  "UTF8" : "utf-8", # UTF-8 (가변 길이, 대부분의 텍스트 파일에 적합)	기본값 (Python 3.7+)
  "UTF16" : "utf-16", # UTF-16 (2바이트 또는 4바이트)	BOM(Byte Order Mark) 포함 가능
  "UTF32" : "utf-32", # UTF-32 (4바이트)	BOM 포함 가능
  "LATIN1" : "latin-1", # (ISO-8859-1)	서유럽 언어 지원	일부 구형 시스템에서 사용
  "CP1252" : "cp1252", # Windows-1252 (서유럽 언어)	Windows 환경에서 사용됨
  "CP949" : "cp949", # EUC-KR 기반 한국어 인코딩	Windows 한국어 환경에서 사용
  "EUCKR" : "euc-kr",	# EUC-KR 한국어 인코딩	리눅스 및 일부 한국어 문서에서 사용
  "SHIFTJIS" : "shift_jis", # 일본어 인코딩	Windows 일본어 환경
  "GB2312" : "gb2312", # 간체 중국어 인코딩	중국어 간체자 환경
  "BIG5" : "big5" # 번체 중국어 인코딩	대만, 홍콩 등에서 사용
}

class Dataset ( BaseDataset ) :

  """
    Dataset
    - 커스텀 데이터 파일(*.json 등)을 불러오고 데이터셋(dataset) 구성과 관련된 기능을 제공하는 인터페이스를 상속받는 최상위 클래스(Default class)
    -- dataset
    -- dataset_encoding

    Usage:
      dataset = Dataset( encoding="utf-8" )
      if dataset.scan_directory( "../_datas/ai_healthcare_qna" ) :
        # TODO
      ...
  """

  def __init__(self, *, encoding: str = "utf-8" ) :
    # init variables
    self._dataset = {}
    self.dataset_encoding = encoding
  # end function (Constructor)

  @property
  def dataset(self):
    return self._dataset

  @dataset.setter
  def dataset(self, value: any ):
    self._dataset = value

  @property
  def dataset_encoding(self):
    return self._dataset_encoding

  @dataset_encoding.setter
  def dataset_encoding(self, value: None | str):
    s = re.sub( r"[^a-zA-Z0-9]", "", value ) # search key

    if not s or s == "" or s.upper() not in EncodingTypes.keys() :
      s = tuple(EncodingTypes.keys())[0] # first key
    # end if

    self._dataset_encoding = EncodingTypes.get( s.upper() )

  def scan_files ( self, path ) :
    if os.path.isfile(path): return None

    nodes = []

    try:
      for item in os.listdir( path ):
        node = path if path.find(item) != -1 else f'{path}/{item}'

        if os.path.isdir( node ):
          nodes = nodes + self.scan_files( node ) # lists concat
        else:
          nodes.append( node )
      # end for
    except:
      print( f'scan files error : {path}' )
    # end try catch

    return None if not nodes or ( isinstance(nodes, list) and len(nodes) == 0 ) else nodes
  # end functions

  def load(self, path ):
    if not os.path.isdir( path ): return False
    return True
  # end functions

  def feed( self, data ):
    return data
  # end functions

# end class Dataset

class DatasetHealthcare ( Dataset ) :

  """
    DatasetHealthcare
    - *.json
    - AI 헬스케어 질의 응답 데이터셋 (Dataset)
    dataset {
      "datas" : None | list,
      "raw_datas" : None | list,
      "taxonomies" : {
        "diseases" : set,
        "departments" : set,
        "intentions" : set
      }
    }
  """

  def __init__(self, *, dataset_kind="A", encoding: str = "utf-8"):
    super().__init__(encoding=encoding)
    # dataset meta
    self.dataset_kind = dataset_kind
  # end function (Constructor)

  @property
  def dataset_kind (self) :
    return self._dataset_kind

  @dataset_kind.setter
  def dataset_kind(self, value):
    self._dataset_kind = "Q" if value.upper() == "Q" else "A"

  def load(self, path):
    if not super().load(path): return False

    result = False

    dataset_kind = self.dataset_kind # dataset kind
    dataset_encoding = self.dataset_encoding # dataset encoding type

    raw_datas = []

    # 파일 목록 스캔(scan files) 및 로우 데이터(raw data) 파싱
    try:

      for item in os.listdir( path ) :
        if dataset_kind == "Q" and item.find("질문") != -1 or dataset_kind == "A" and item.find("답변") != -1 :
          result = True
          nodes = self.scan_files( f'{path}/{item}' )

          for node in nodes:
            ext = os.path.splitext( node.lower() )[1] if node and type(node) == str else ""

            if ext != ".json" :
              continue
            # end if
            try :
              with open(node, encoding=dataset_encoding, mode="r") as f:
                raw_data = dict( json.load(f) )
                raw_datas.append( raw_data )
            except :
              pass
            # end try
          break
        # end if
      # end for

    except:
      print(f'load directory error: {path}')
    #end try

    # mapping feeding datas
    # - raw_datas []
    datas = list ( filter(None, map(self.feed, raw_datas)) )

    # mapping category(taxonomy)
    # set taxonomies (질병, 진료과, 진찰)
    diseases = set()
    departments = set()
    intentions = set()

    for data_item in datas :
      if not data_item or type(data_item) is not dict : continue
      data_item = dict(data_item)

      # - 질병 disease_category
      values = data_item.get( "disease_category" )
      if values :
        for val in values:
          if not val : continue
          else : diseases.add(val.strip())
      # end if

      # - 진료과 department
      values = data_item.get("department")
      if values:
        for val in values:
          if not val : continue
          else : departments.add(val.strip())
      # end if

      # - 진찰 intention
      values = data_item.get("intention")
      if values:
        for val in values:
          if not val : continue
          else : intentions.add(val.strip())
      # end if
    # end for

    # set dataset (main)
    self.dataset = {
      "datas": datas,
      "raw_datas" : raw_datas,
      "taxonomies": {
        "diseases": diseases,
        "departments": departments,
        "intentions": intentions
      }
    }
    return result
  # end function

  def feed( self, data: None | dict ):
    if type(data) is not dict: return None

    for key, value in data.items() :
      if key in ( "disease_category", "department", "intention" ) :
        if isinstance(value, str) :
          value = [ _.strip() for _ in value.split(",") ]  # str to list
        elif not hasattr(value, "__iter__"):
          value = list( value )

        data[key] = value # update value
      # end if
    # end for
    return data
  # end functions

# end class DatasetHealthcare



