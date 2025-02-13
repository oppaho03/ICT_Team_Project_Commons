"""
Defined variables
( variable, class(enum) ... )
-
"""
from enum import StrEnum

class EncodingType ( StrEnum ):
  UTF8 = "utf-8"  # UTF-8 (가변 길이, 대부분 의 텍스트 파일에 적합)	기본값 (Python 3.7+)
  UTF16 = "utf-16"  # UTF-16 (2바이트 또는 4바이트)	BOM(Byte Order Mark) 포함 가능
  UTF32 = "utf-32"  # UTF-32 (4바이트)	BOM 포함 가능
  LATIN1 = "latin-1"  # (ISO-8859-1)	서유럽 언어 지원	일부 구형 시스템 에서 사용
  CP1252 = "cp1252"  # Windows-1252 (서유럽 언어)	Windows 환경 에서 사용됨
  CP949 = "cp949"  # EUC-KR 기반 한국어 인코딩	Windows 한국어 환경 에서 사용
  EUCKR = "euc-kr"  # EUC-KR 한국어 인코딩	리눅스 및 일부 한국어 문서 에서 사용
  SHIFTJIS = "shift_jis"  # 일본어 인코딩	Windows 일본어 환경
  GB2312 = "gb2312"  # 간체 중국어 인코딩	중국어 간체자 환경
  BIG5 = "big5"  # 번체 중국어 인코딩	대만, 홍콩 등에서 사용

