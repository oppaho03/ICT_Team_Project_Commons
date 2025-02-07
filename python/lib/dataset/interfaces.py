"""
Defined Interface classes
- BaseDataset
-
"""
from abc import ABC, abstractmethod

class BaseDataset ( ABC ) :

  """
  BaseDataset
  - 커스텀 데이터 파일(*.json 등)을 불러오고 데이터셋(dataset) 구성과 관련된 기능을 제공하는 인터페이스
  '"""



  @abstractmethod
  def scan_files( self, path:str ) -> None | list :
    """ {path} 기준 으로 하위 디렉토리 내 모든 파일 불러오기 """
    pass

  @abstractmethod
  def load(self, path: str) -> bool:
    """ 루트 디렉토리 { path } 를 기준으로 데이터셋(dataset) 속성 값 구성 """
    pass

  @abstractmethod
  def feed ( self, data: any ) -> any :
    """  {data} 처리 """
    pass



  #
  # @abstractmethod
  # def scan_directory (self, path: str) -> bool :
  #   """ {path} 기준 루트 디렉토리 불러오기 """
  #   pass
  #
  # @abstractmethod
  # def scan_directories ( self, path: str ) -> list:
  #   """ {path} 기준 하위 directory 내 file(*.json) 불러오기 """
  #   pass
  #
  # @abstractmethod
  # def load_data(self, *, filepath: str) -> None | dict:
  #   """ {filepath}(*.json ....) 내용을 dict 형식 반환 """
  #   pass
  #


# end abstract class(interface) BaseDataset



