
# This is a sample Python script.



# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.

# Press the green button in the gutter to run the script.
if __name__ == '__main__':

  from lib.orms import oracle

  db = oracle.db

  db_session = db.db_session

  term = oracle.TermsCRUD.get_term(db_session, 1)
  print("term: ",  term )
  term_meta = oracle.TermsCRUD.get_term_meta( db_session, term.term_id, "_t" )
  print("term meta: ", term_meta)

  # update
  # update - term
  oracle.TermsCRUD.update_term( db_session, term.term_id, count="-1" )
  # update - term meta
  # oracle.TermsCRUD.update_term_meta( db_session, term.term_id, "_t", "202502071" )

  # delete
  # delete - term
  oracle.TermsCRUD.delete_term( db_session, 21 )
  # new_term = oracle.TermsCRUD.create_term( db_session, "미분류" )

  db.close()


  pass



