$LOAD_PATH.unshift "./lib"

require 'cucumber/rspec/doubles'
require 'couch_photo'
require 'couchrest_model_config'

CouchRest::Model::Config.edit do
  database do
    default "http://admin:password@localhost:5984/couch_photo_test"
  end
end

Before('@file_stub') do
  File.should_receive(:safe_unlink).twice
end
