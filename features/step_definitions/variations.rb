Given /^an image class definition with a thumbnail variation definition:$/ do |string|
  eval string
end

When /^I create an instance of it and load the original and save:$/ do |string|
  eval string
end

Then /^the image document should have a thumbnail variation:$/ do |string|
  eval string
end

Given /^an image class with a complex grayscale variation definition on it:$/ do |string|
  eval string
end

When /^I add a custom variation to it via the '.*' method:$/ do |string|
  eval string
end

Then /^I should have a custom variation named '.*':$/ do |string|
  eval string
end

When /^I load the image from the database:$/ do |string|
  eval string
end

When /^I create an instance of it and add an original image to it:$/ do |string|
  eval string
end

Then /^I should be able to add metadata to the thumbnail variation:$/ do |string|
  eval string
end

Then /^I should be able to access metadata on the thumbnail variation:$/ do |string|
  eval string
end

When /^I destroy the 'monochrome\.jpg' variation:$/ do |string|
  eval string
end

Then /^the image should not have a custom variation named 'monochrome\.jpg':$/ do |string|
  eval string
end

When /^I attempt to destroy a defined variation:$/ do |string|
  eval string
end

Then /^CouchPhoto should raise an exception:$/ do |string|
  eval string
end

Then /^I should be able to add metadata to the original:$/ do |string|
  eval string
end

Then /^I should be able to access metadata on the original:$/ do |string|
  eval string
end
