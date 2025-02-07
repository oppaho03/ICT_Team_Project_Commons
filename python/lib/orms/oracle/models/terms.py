'''
  SQLAlchemy 모델(Model)
  - app_terms 테이블
  - Sequence('term_id_seq', start=1, increment=1)
'''
import sqlalchemy.sql
from sqlalchemy import Column, Integer, String, Text, ForeignKey, func
from sqlalchemy.orm import relationship


from ..database import db

# Model : Terms
class Terms (db.base):

  __tablename__ = "app_terms"

  term_id = Column(Integer, autoincrement=True, primary_key=True ) # autoincrement=True | Sequence('term_id_seq', start=1, increment=1) * Sequence 포함
  name = Column(String(100), default='', nullable=False)
  slug = Column(String(200), default='', nullable=False)
  term_group = Column(Integer, default=0, nullable=False)

  # Terms -> TermMeta
  metas = relationship("TermMeta", back_populates="term")
  # Terms -> TermTaxonomy
  taxonomies = relationship("TermTaxonomy", back_populates="term")

  def __repr__(self):
    return f"<Term(term_id={self.term_id}, name={self.name}, slug={self.slug}, term_group={self.term_group})>"



# Model : TermMeta
class TermMeta (db.base):

  __tablename__ = "app_termmeta"

  meta_id = Column(Integer, autoincrement=True, primary_key=True)  # autoincrement=True | Sequence('term_id_seq', start=1, increment=1) * Sequence 포함
  term_id = Column(Integer, ForeignKey("app_terms.term_id", ondelete="CASCADE"), nullable=False)
  meta_key = Column(String(200), default='', nullable=True)
  meta_value = Column(Text, default="", server_default=sqlalchemy.sql.text("EMPTY_CLOB()"), nullable=True )

  # TermMeta -> Terms
  term = relationship("Terms", back_populates="metas")

  def __repr__(self):
    return f"<TermMeta(meta_id={self.meta_id}, term_id={self.term_id}, meta_key={self.meta_key}, meta_value={self.meta_value})>"



# Model : TermTaxonomy
class TermTaxonomy( db.base ):
  __tablename__ = "app_term_taxonomy"

  term_taxonomy_id = Column(Integer, primary_key=True, autoincrement=True)  # GENERATED ALWAYS AS IDENTITY
  term_id = Column(Integer, ForeignKey("app_terms.term_id", ondelete="CASCADE"), nullable=False)
  taxonomy = Column(String(32), nullable=False, default="")
  description = Column(Text, default="", server_default=sqlalchemy.sql.text("EMPTY_CLOB()"), nullable=True, )
  parent = Column(Integer, nullable=False, default=0) # ForeignKey("app_term_taxonomy.term_taxonomy_id", ondelete="CASCADE")
  count = Column(Integer, nullable=False, default=0)

  # TermTaxonomy->Term
  term = relationship("Terms", back_populates="taxonomies")

  def __repr__(self):
    return f"<TermTaxonomy(term_taxonomy_id={self.term_taxonomy_id}, term_id={self.term_id}, taxonomy={self.taxonomy}, description={self.description}, parent={self.parent}, count={self.count})>"



