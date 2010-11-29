Given /^an instance of a model with CouchPhoto$/ do
  class SimpleImage < CouchRest::Model::Base
    use_database IMAGE_DB
    include CouchPhoto
  end

  @image = SimpleImage.new
  @image.original = "features/setup/fixtures/avatar.jpg"
  @image.save
end

When /^I call the `original` method$/ do
  @original = @image.original
end

Then /^I should get an object representing the original image associated with the document$/ do
  @original.should_not be_nil
end

When /^I call the `original\.original_filename` method$/ do
end

Then /^I should get the original filename of the original image associated with the document$/ do
  @original.original_filename.should == "avatar.jpg"
end

When /^I call the `original\.filename` method$/ do
end

Then /^I should get the filename of the original image attachment$/ do
  @original.filename.should == "original.jpg"
end

When /^I call the `original\.url` method$/ do
end

Then /^I should get the url of the original image attachment$/ do
  @original.url.should == "#{@image.database.to_s}/#{@image.id}/original.jpg"
end

When /^I call the `original\.path` method$/ do
end

Then /^I should get the path of the original image attachment$/ do
  @original.path.should == "/#{@image.database.name}/#{@image.id}/original.jpg"
end

When /^I call the `original\.filetype` method$/ do
end

Then /^I should get the filetype of the original image attachment$/ do
  @original.filetype.should == "jpg"
end

When /^I call the `original\.mimetype` method$/ do
end

Then /^I should get the mimetype of the original image attachment$/ do
  @original.mimetype.should == "image/jpeg"
end

When /^I call the `original\.data` method$/ do
end

Then /^I should get a binary blob of the original image attachment$/ do
  @original.data.should_not be_nil
end
