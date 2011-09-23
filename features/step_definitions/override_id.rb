Given /^an image class that calls `override_id!`:$/ do |string|
  eval string
end

When /^I set the original image on an instance to a file named "([^"]*)":$/ do |arg1, string|
  eval string
end

Then /^the id of the image should be 'avatar\.jpg':$/ do |string|
  eval string
end
