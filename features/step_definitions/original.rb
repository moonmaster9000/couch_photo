Given /^an instance of an image class that includes `CouchPhoto`:$/ do |string|
  eval string
end

When /^I add an original image to it named 'avatar\.jpg' via the `load_original_from_file` method:$/ do |string|
  eval string
end

When /^I save:$/ do |string|
  eval string
end

Then /^the original image should be added to the database:$/ do |string|
  eval string
end

When /^I call the `load_original` method with filename 'avatar\.jpg' a binary blob:$/ do |string|
  eval string
end
