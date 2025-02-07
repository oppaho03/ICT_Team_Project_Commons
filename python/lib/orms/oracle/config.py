import os

from dotenv import load_dotenv

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

#
# 환경설정(.env) 읽기
#
load_dotenv()

_ENV_DATA = {
  "name" : os.environ.get( 'DB_NAME' ),
  "host" : os.environ.get( 'DB_HOST' ),
  "account" : os.environ.get( 'DB_ACCOUNT' ),
  "password" : os.environ.get( 'DB_PASSWORD' )
}

