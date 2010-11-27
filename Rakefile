require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "couch_photo"
    gemspec.summary     = "Mixin for CouchDB/couchrest_model image models."
    gemspec.description = "Automatically create image variations on your CouchDB image documents."
    gemspec.email       = "moonmaster9000@gmail.com"
    gemspec.files       = FileList['lib/**/*.rb', 'README.rdoc']
    gemspec.homepage    = "http://github.com/moonmaster9000/couch_photo"
    gemspec.authors     = ["Matt Parker"]
    gemspec.add_dependency('couchrest_model', '1.0.0.beta7')
    gemspec.add_dependency('mini_magick', '~>3.1')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
