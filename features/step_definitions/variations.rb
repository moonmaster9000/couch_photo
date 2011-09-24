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
