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

Then /^I should get an array of variations$/ do
  @variations.should be_kind_of(Array)
  @variations.each do |variation|
    ["small", "medium", "large"].include?(variation.name).should be_true
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
