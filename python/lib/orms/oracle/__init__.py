"""
  데이터베이스(DB) ORM 패키지 : 오라클(ORACLE)
  - dbEngine
  - dbSessionLocal

"""

# from .config import *
from .database import db
from .models.terms import Terms, TermMeta, TermTaxonomy
from .cruds.terms import TermsCRUD

__all__ = [
  'db',
  'TermsCRUD',
]
