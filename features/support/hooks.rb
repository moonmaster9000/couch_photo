Before do
  CouchRest::Model::Config.default_database.recreate!
end

Before do
  if defined?(Image)
    Object.class_eval do
      remove_const "Image"
    end
  end
end
