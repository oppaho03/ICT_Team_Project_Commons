"""
Database
- SQLAlchemy 엔진을 설정 및 세션을 생성
- Oracle
"""

from .config import _ENV_DATA
from ..database import ORMDatabase

from sqlalchemy import create_engine

class ORMDatabaseOracle ( ORMDatabase ) :

  def create_engine (self) -> bool:
    """ 엔진(engine) 생성 인터페이스 함수 """
    db_engine = None

    db_type = self.db_type
    db_host = self._db_host
    db_name = self.db_name
    db_acc = self.db_account
    db_pass = self.db_password

    if db_type in self._support_db_type :
      if db_type == "oracle" :
        # URL Formatter
        db_urls = f'{db_name}://{db_acc}:{db_pass}@{db_host}'

        try :
          db_engine = create_engine(db_urls)
          if not db_engine.connect() : db_engine = None
        except:
          db_engine = None
          print( "create_engine() error", db_urls, sep=":")
      # end if "oracle"
    # end if

    self.db_engine = db_engine # update engine
    return True if db_engine else False
# end class


# ORM Database Oracle
db = ORMDatabaseOracle (
  db_type="oracle",
  db_name= _ENV_DATA.get("name") ,
  db_host=_ENV_DATA.get("host"),
  db_account=_ENV_DATA.get("account"),
  db_password=_ENV_DATA.get("password")
)

if db.create_engine () :
  db.create_session( autocommit=False, autoflush=False )

