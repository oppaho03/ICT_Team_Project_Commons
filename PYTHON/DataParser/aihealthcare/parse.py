"""
Defined classes related to parse
-
"""

import logging
logging.basicConfig( level=logging.INFO, format="%(asctime)s [%(levelname)s] %(pathname)s:%(lineno)d (%(funcName)s()) - %(message)s", datefmt="%Y-%m-%d %H:%M:%S" )

import os, re, json
from typing import Callable

from .variables import EncodingType



def scan_file(path: str, encoding: str = "utf-8") -> None | list:
  """
  하위 포함 전체 디렉토리 안의 파일을 목록화
  :param path:
  :param encoding:
  :return:
  """
  if not os.path.isdir( path ) : return None
  nodes = []
  try:
    for item in os.listdir(path):
      node = path if path.find(item) != -1 else f'{path}/{item}'
      if os.path.isdir(node): nodes = nodes + scan_file(node)  # lists concat
      else: nodes.append(node)
    # end for
  except FileNotFoundError:
    print(f'scan files error : {path}')
  return None if not nodes or ( isinstance(nodes, list) and len(nodes) == 0 ) else nodes

#
class AIHealthCare :
  """
  Usage:
    ...
  """

  def __init__(self, *, encoding: str="utf-8"):
    self.encoding = encoding

  @property
  def encoding(self) -> str:
    return self._encoding
  @encoding.setter
  def encoding(self, value: str):
    # formatter
    key = re.sub(r"[^a-zA-Z0-9]", "", value).upper()
    # get enum key, value
    key = "UTF8" if key not in EncodingType.__members__.keys() else key
    value = str(EncodingType[key].value)

    self._encoding = value

  def load(self, path: str ) -> list | list[ type(dict) ]:
    """

    :param path:
    :return:
    """
    # scan to all files
    encoding = self.encoding
    files = scan_file( path, encoding=encoding )
    if not files : return []

    # JSON 파일 -> dict 형식 데이터 로 변형
    feeds = list( map( self.feed, files ) )
    return list( filter( None, feeds ) )

  def feed(self, path: str )-> None | dict:
    """

    :param path:
    :return:
    """
    encoding = self.encoding
    _, ext = os.path.splitext(path)

    if not ext or str(ext).lower() != ".json":
      return None

    try:
      with open( path, encoding=encoding, mode="r" ) as fc:
        raw_data = dict( json.load(fc) )

        # 질병(disease_category) / 의도(intention) 값, str->list 변형
        for key in ("disease_category", "intention"):
          if not key in raw_data: continue;

          value = raw_data[key]
          if not isinstance(value, str): continue
          raw_data[key] = [_.strip() for _ in value.split(",")]  # str to list

        # department -> list
        key = "department"
        if key in raw_data and key == "department" :
          revalue = []
          for value in raw_data[key] :
            if "\n" in value :
              for _invalue in value.split("\n") :
                revalue.append(_invalue)
            else :
              revalue.append(value)
          raw_data[key] = revalue

        result = raw_data
    except (FileNotFoundError, FileExistsError) as e :
      result = None
      logging.error( e )

    return result








