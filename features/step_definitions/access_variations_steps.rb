Given /^an instance of a model with several variations$/ do
  class VariationImage < CouchRest::Model::Base
    use_database IMAGE_DB
    include CouchPhoto

    override_id!

    variations do
      small "5x5"
      medium "50x50"
      large "200x200"
    end
  end

  @image = VariationImage.new
  @image.original = "features/setup/fixtures/avatar.jpg"
  @image.save
end

When /^I call the variations instance method$/ do
  @variations = @image.variations
end

Then /^the `each` method should allow me to iterate over the variation names and variation value pairs$/ do
  @variations.each do |variation_key, variation|
    ["small", "medium", "large"].include?(variation_key).should be_true
    variation.url.should == [IMAGE_DB.to_s, @image.id, variation.filename].join("/")
    variation.path.should == "/" + [IMAGE_DB.name, @image.id, variation.filename].join("/")
    variation.data.should_not be_nil
    variation.filename.should_not be_nil
    variation.basename.should_not be_nil
  end
end

When /^I call the variation\.variation_name method$/ do
  @small = @image.variation.small
  @medium = @image.variation.medium
  @large = @image.variation.large
end

When /^I call the variation\(variation_name\) method$/ do
  @small = @image.variation "small"
  @medium = @image.variation "medium"
  @large = @image.variation "large"
end

Then /^I should get that specified variation$/ do
  @small.should_not be_nil
  @small.should be_kind_of(CouchPhoto::Variation)
  @small.name.should == "small"
  @small.filename.should == "variations/small.jpg" 
  @small.basename.should == "small.jpg"
  @medium.should_not be_nil
  @medium.name.should == "medium"
  @medium.filename.should == "variations/medium.jpg" 
  @medium.basename.should == "medium.jpg"
  @large.should_not be_nil
  @large.name.should == "large"
  @large.filename.should == "variations/large.jpg" 
  @large.basename.should == "large.jpg"
  @large.filetype.should == "jpg"
  @large.mimetype.should == "image/jpeg"
end

When /^I create a custom variation named "([^"]*)"$/ do |variation_name|
  @image.add_variation variation_name, :file => "features/setup/fixtures/avatar.jpg"
  @image.save
end

When /^I call variation\("([^"]*)"\)$/ do |variation_name|
  @custom_variation = @image.variation variation_name
end

Then /^I should get back "([^"]*)"$/ do |variation_name|
  @custom_variation.filename.should == "variations/#{variation_name}" 
  @custom_variation.basename.should == "#{variation_name}"
  @custom_variation.data.should == File.read("features/setup/fixtures/avatar.jpg")
end

When /^I call the count method$/ do
  @count = @image.variations.count
end

Then /^I should receive the correct number of variations$/ do
  @count.should == 4
end


When /^I load the model from the database$/ do
  @image = VariationImage.get @image.id
end
