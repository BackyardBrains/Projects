import MySQLdb
import MySQLdb.cursors
import config

def connect_to_database():
  options = {
    'host': config.env['host'],
    'user': config.env['user'],
    'passwd': config.env['password'],
    'db': config.env['db'],
    'cursorclass' : MySQLdb.cursors.DictCursor
  }
  db = MySQLdb.connect(**options)
  db.autocommit(True)
  return db
