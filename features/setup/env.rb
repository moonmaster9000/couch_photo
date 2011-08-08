$LOAD_PATH.unshift './lib'
require 'couch_photo'

COUCHDB_SERVER = CouchRest.new "http://admin:password@localhost:5984"
IMAGE_DB = COUCHDB_SERVER.database!('couch_photo_test')

Before do |scenario|
  IMAGE_DB.delete!
  IMAGE_DB.create!
end
