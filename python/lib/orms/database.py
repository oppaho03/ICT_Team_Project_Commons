"""
Database
- SQLAlchemy 엔진을 설정 및 세션을 생성
"""
from cffi.model import VoidType
# from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

#
# ORM (SQLAlchemy) 초기 변수 설정
#

class ORMDatabase:
  '''
    ORM DB 엔진, 세션 등 기본적인 설정 값과 관리를 위한 클래스

    Usage:
      from .config import _ENV_DATA

      db = ORMDatabase(
        db_type="oracle",
        db_name= _ENV_DATA.get("name"),
        db_host=_ENV_DATA.get("host"), ]
        db_account=_ENV_DATA.get("account"),
        db_password=_ENV_DATA.get("password")
      )

      if db.create_engine () :
        db.create_session( autocommit=False, autoflush=False )
        db_session = db.db_session()
        ...
        TODO
        ...
        db_session.close()
  '''

  _support_db_type = {"mysql", "oracle", "postgresql", "mongodb"}
  _base = declarative_base() # models base class

  def __init__(self, *, db_type: str = "mysql", db_name: str = "", db_host: str ="", db_account: str = "", db_password: str = ""  ):

    self.db_type = db_type
    self.db_name = db_name

    self.db_account = db_account
    self.db_password = db_password

    self._db_host = db_host # protected

    self.db_engine = None # variable declaration
    self.db_session_local = None
    self.db_session = None

  # end constructor

  @property
  def base(self):
    return self._base

  @property
  def db_type(self):
    return self._db_type

  @db_type.setter
  def db_type(self, value: str):
    self._db_type = value.lower()

  @property
  def db_name(self):
    return self._db_name

  @db_name.setter
  def db_name(self, value: str):
    self._db_name = value

  @property
  def db_account(self):
    return self._db_account

  @db_account.setter
  def db_account(self, value: str):
    self._db_account = value

  @property
  def db_password(self):
    return self._db_password

  @db_password.setter
  def db_password(self, value: str):
    self._db_password = value

  @property
  def db_engine(self):
    return self._db_engine

  @db_engine.setter
  def db_engine(self, value: any):
    self._db_engine = value

  @property
  def db_session_local(self):
    return self._db_session_local

  @db_session_local.setter
  def db_session_local(self, value: any):
    self._db_session_local = value

  @property
  def db_session(self):
    return self._db_session

  @db_session.setter
  def db_session(self, value: any):
    self._db_session = value

  def create_engine (self) -> bool:
    """ 엔진(engine) 생성 인터페이스 함수 """
    return True

  def create_session(self, **kwargs: any, ) -> bool:
    """ 세션(session) 생성 인터페이스 함수 """
    db_session = db_session_local = None
    db_engine = self.db_engine

    if not hasattr(kwargs, "autocommit"): kwargs['autocommit'] = False
    if not hasattr(kwargs, "autoflush"): kwargs['autoflush'] = False

    if db_engine :
      try :
        db_session_local = sessionmaker(
          autocommit=kwargs['autocommit'],
          autoflush=kwargs['autoflush'],
          bind=db_engine
        )
      except:
        db_session_local = None
    else: db_session_local = None
    # end if


    db_session = db_session_local() if db_session_local else None
    self.db_session = db_session
    self.db_session_local = db_session_local  # update session

    return True if db_session_local else False

  def close (self) -> None :
    if self.db_session :
      self.db_session.close()
# end
