Given /^the following Image model in which I define a url transformer for turning 'http' requests into 'https' requests:$/ do |string|
  eval string
end

When /^I create an image and save:$/ do |string|
  eval string
end

Then /^my image urls should have 'https' instead of 'http':$/ do |string|
  eval string
end

Given /^the following URL transformer that strips out basic auth:$/ do |string|
  eval string
end

Given /^the following Image model in which I supply StripBasicAuth as the url transformer:$/ do |string|
  eval string
end

Then /^my image urls should not have any basic auth:$/ do |string|
  eval string
end

