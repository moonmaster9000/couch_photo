Gem::Specification.new do |s|
  s.name        = "couch_photo"
  s.version     = File.read "VERSION"
  s.authors     = "Matt Parker"
  s.homepage    = "http://github.com/moonmaster9000/couch_photo"
  s.summary     = "A handy Ruby mixin for managing images in CouchDB / couchrest_model"
  s.description = "Manage an image and all of its variations and xmp metadata in a single document."
  s.email       = "moonmaster9000@gmail.com"
  s.files       = Dir["lib/**/*"] << "VERSION" << "README.markdown" << "couch_photo.gemspec"
  s.test_files  = Dir["feature/**/*"]

  s.add_development_dependency "cucumber"
  s.add_development_dependency "rspec"
  s.add_development_dependency "couchrest_model_config"
  
  s.add_dependency             "couchrest",       "1.0.1"
  s.add_dependency             "mini_magick"
  s.add_dependency             "couchrest_model", "~> 1.0.0"
end
