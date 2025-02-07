import os, re
from idlelib.query import Query
from urllib import parse


from sqlalchemy import join, and_, or_
from sqlalchemy.exc import SQLAlchemyError
# urllib.parse.quote(text) | urllib.parse.unquote(enc)

from sqlalchemy.orm import Session
from ..models.terms import Terms, TermMeta, TermTaxonomy

# set configuration logging
import logging
logging.basicConfig(
  level=logging.INFO,
  # format="%(asctime)s [%(levelname)s] %(pathname)s:%(lineno)d (%(funcName)s()) - %(message)s",
  datefmt="%Y-%m-%d %H:%M:%S"
)

class TermsCRUD :
  """
    (CRUD) Terms : <Terms> <TermTaxonomy> <TermMeta>
    - @classmethod | @staticmethod
    - find
    - create
    - update
    - delete
  """

  ''' COMMONS '''
  @staticmethod
  def url_encoding ( value: str, rep: str = "-" ) -> None | str :
    """
    문자열(str) URL Encoding ( slug 등 )
    :param value:
    :param rep:
    :return:
    """
    return parse.quote( parse.unquote(value.replace( " ", rep )) ) if value else ""

  @staticmethod
  def url_decoding(value: str) -> None | str:
    """
    문자열(str) URL Decoding ( slug 등 )
    :param value:
    :param rep:
    :return:
    """
    return parse.unquote(value) if value else ""

  @staticmethod
  def numbering ( value: str ) -> None | str :
    new_value = None
    match = re.search( r"(\d+)$", value )
    if match :
      n = match.group(1) # 마지막 숫자 추출
      new_value = value[:match.start()] + str( int(n) + 1 )
    else: new_value = f'{value}1'
    return new_value

  ''' FIND '''
  @staticmethod
  def get_taxonomies () -> list[type(str)] :
    return [ "post", "tags", "category", "disease", "department", "intention" ]

  @staticmethod
  def get_term ( db: Session, term_id: int ) -> None | Terms :
    """
    Get <Terms>
    :param db:
    :param term_id:
    :return:
    """
    sql = db.query( Terms )
    slq = sql.filter( and_( Terms.term_id == term_id ) )
    return slq.first()

  @staticmethod
  def get_term_by_slug ( db: Session, slug: str, **kwargs ) -> None | Terms :
    """
    Get <Terms> by Terms.slug
    :param db:
    :param slug:
    :param kwargs: str taxonomy
    :return:
    """
    s = {**{"taxonomy": "category"}, **kwargs}

    # convert to url encoding
    # rechecked encoding status
    slug = TermsCRUD.url_decoding(slug)
    slug = TermsCRUD.url_encoding(slug)

    sql = db.query(Terms)
    sql = sql.join( TermTaxonomy, and_( TermTaxonomy.taxonomy == s.get("taxonomy") ) ) # join <Terms> <TermTaxonomy>
    sql = sql.filter( and_( Terms.slug == slug ) )
    return sql.first()

  @staticmethod
  def get_terms ( db: Session, **kwargs ) -> None | list | list[ type(Terms) ] :
    """
    Get <Terms> 리스트
    :param db:
    :param kwargs: int term_group | str taxonomy
    :return:
    """
    filters = []

    s = {**{"taxonomy": "category"}, **kwargs}

    sql = db.query( Terms )
    sql = sql.join( TermTaxonomy, and_( TermTaxonomy.taxonomy == s.get("taxonomy") ) )  # join <Terms> <TermTaxonomy>

    # append filters[]
    for key in s.keys():
      val = s.get( key )
      if key == "term_group" : filters.append( Terms.term_group == val )
      else: continue

    if filters : sql = sql.filter( and_(*filters) )
    return sql.all()

  @staticmethod
  def get_term_meta ( db: Session, term_id: int, meta_key: str ) -> None | str :
    """
    Get <TermMeta> 값(TermMeta.meta_value)
    :param db:
    :param term_id:
    :param meta_key:
    :return:
    """
    # <Terms>
    term = TermsCRUD.get_term( db, term_id )
    if not term : return None

    term_meta: None | TermMeta = None

    if term.metas :
      for meta in term.metas:
        # meta == TermMeta
        if meta.meta_key == meta_key : term_meta = meta
        else: continue
    # end if term.metas

    return term_meta.meta_value if term_meta else None

  ''' CREATE '''
  @staticmethod
  def create_term ( db: Session, name: str, slug: str = None, **kwargs ) -> None | Terms:
    """
    Create <Terms>
    :param db:
    :param name:
    :param slug:
    :param kwargs: str taxonomy | int term_group | str description | int parent
    :return:
    """
    params = { **{
      "taxonomy" : "category",
      "term_group" : 0,
      "description" : "",
      "parent" : 0
    }, **kwargs }

    taxonomy = params.get( "taxonomy" ) # taxonomy

    # slug 유효성 검사 및 URL Encoding
    # slug 중복 시 숫자가 추가(numbering) 또는 증가
    if not slug : slug = name

    while True:
      slug = TermsCRUD.url_encoding(slug)  # url encoding by slug
      _term: None | Terms = TermsCRUD.get_term_by_slug(db, slug, taxonomy=taxonomy)
      if not _term: break

      slug = TermsCRUD.url_decoding(_term.slug)  # url decoding by slug
      slug = TermsCRUD.numbering(slug)
    # end while True

    # CREATE(INSERT) <Terms>, <TermTaxonomy> : Transaction
    new_term: None | Terms = None
    new_term_tax: None | Terms = None
    try :
      # <Terms>
      term_group = params.get("term_group")
      new_term = Terms ( name = name, slug = slug, term_group = term_group )

      db.add( new_term )
      db.flush() # saved to flash memory (temp)

      # <TermTaxonomy>
      taxonomy = params.get("taxonomy")
      desc = params.get("description")
      parent = params.get("parent")
      new_term_tax = TermTaxonomy( term_id = new_term.term_id, taxonomy=taxonomy, description=desc, parent=parent )

      db.add( new_term_tax )

      db.commit()

      db.refresh( new_term )
      db.refresh( new_term_tax )
    except (SQLAlchemyError, ValueError) as e:
      db.rollback()

      new_term = new_term_tax = None
      slug = TermsCRUD.url_decoding(slug)
      logging.error( f'Create <Terms>(name={name}, slug={slug}) error : {e}' )

    return new_term

  ''' UPDATE '''
  @staticmethod
  def update_term ( db: Session, term_id: int, **kwargs ) -> bool:
    """
    Update <Terms> <TermTaxonomy>
    :param db:
    :param term_id:
    :param kwargs: str name, str slug, int term_group, str description, int count, int parent
    :return:
    """
    params = { **{}, **kwargs}

    # <Term> 검색
    term = TermsCRUD.get_term( db, term_id )
    if not term:
      logging.error( f'Update <Terms>(term_id={term_id} ) error : Can\'t found <Terms>')
      return False

    # UPDATE <Terms>, <TermTaxonomy> : Transaction
    is_updated = False
    try :
      # UPDATE <Terms>
      # - name, slug, term_group
      _ = ["name", "slug", "term_group"]
      if set( _ ) & set( list(params.keys()) ) :
        for key in params.keys() :
          val = params.get(key)
          if key == "name" and term.name != val :
            is_updated = True
            term.name = val
          elif key == "term_group" and term.term_group != val:
            is_updated = True
            term.term_group = val
          elif key == "slug" :
            val = TermsCRUD.url_encoding( val )
            _term = db.query( Terms ).filter( and_( Terms.term_id != term.id, Terms.slug == val ) ).first()
            if _term :
              # 이미 사용 중인 slug (중복)
              logging.error( f'Update <Terms>(slug={val} ) error : "{val}" slug is already in use.')
            else :
              is_updated = True
              term.slug = val
        # end for key in params.keys()
      # end if set( _ ) & set( list(params.keys()) )

      # UPDATE <TermTaxonomy>
      # - description, count, parent
      _ = ["description", "count", "parent"]
      if term.taxonomies and ( set( _ ) & set( list(params.keys()) ) ) :
        term_tax: None | TermTaxonomy = term.taxonomies[0]
        for key in params.keys() :
          val = params.get(key)
          if key == "description" and term_tax.description != val :
            is_updated = True
            term_tax.description = val
          elif key == "parent" and term_tax.parent != val :
            is_updated = True
            term_tax.parent = val
          elif key == "count" :
            is_updated = True
            count = int(term_tax.count) # current
            term_tax.count = count - 1 if val == "-1" else count + 1
        # end for key in params.keys()
      # end if term.taxonomies and ( set( _ ) & set( list(params.keys()) ) )

      if is_updated :
        db.commit()
        db.refresh( term )
    except (SQLAlchemyError, ValueError) as e:
      db.rollback()
      is_updated = False
      logging.error(f'Update <Terms>(term_id={term_id} ) error : {e}')

    return is_updated

  @staticmethod
  def update_term_meta ( db: Session, term_id: int, meta_key: str, meta_value: None | str ) -> bool:
    """
    CREATE or UPDATE <TermMeta>
    :param db:
    :param term_id:
    :param meta_key:
    :param meta_value:
    :return:
    """
    # <Term> 검색
    term = TermsCRUD.get_term( db, term_id )
    if not term :
      logging.error( f'Update <TermMeta>(term_id={term_id}, meta_key={meta_key}, meta_value={meta_value}) error : Can\'t found <Terms>' )
      return False

    # <TermMeta> 검색
    term_meta: None | TermMeta = (
      db.query( TermMeta )
      .filter( and_( TermMeta.term_id == term_id, TermMeta.meta_key == meta_key ) )
      .first()
    )

    # CREATE(INSERT) or UPDATE <TermMeta> : Transaction
    new_term_meta: None | TermMeta = None
    try :
      # <TermMeta>
      if term_meta :
        # Update <TermMeta>
        term_meta.meta_value = meta_value
        db.commit()
        db.refresh(term_meta)

        new_term_meta = term_meta # Shallow copy
      else :
        # Create <TermMeta>
        new_term_meta = TermMeta(term_id=term_id, meta_key=meta_key, meta_value=meta_value)
        db.add(new_term_meta)
        db.commit()
        db.refresh(new_term_meta)
    except (SQLAlchemyError, ValueError) as e:
      db.rollback()

      new_term_meta = None
      logging.error(f'{ "Update" if term_meta else "Create"  } <TermMeta>(term_id={term_id}, meta_key={meta_key}, meta_value={meta_value}) error : {e}')

    return True if new_term_meta else False

  ''' DELETE '''
  @staticmethod
  def delete_term ( db: Session, term_id: int ) -> None | Terms :
    """
    Delete <Term>
    :param db:
    :param term_id:
    :return:
    """
    term = TermsCRUD.get_term( db, term_id )

    if term :
      try:
        # DELETE <Term>,  <TermTaxonomy>, <TermMeta>
        if term.taxonomies :
          for tax in term.taxonomies:
            db.delete( tax )
        # end if term.taxonomies

        if term.metas :
          for meta in term.metas:
            db.delete( meta )
        # end if term.metas

        db.delete( term )
        db.commit()
      except ( SQLAlchemyError, ValueError ) as e :
        db.rollback()
        term = None
        logging.error( f'Delete <TermMeta>(term_id={term_id}) error : ', e)
    # end if term

    return term


