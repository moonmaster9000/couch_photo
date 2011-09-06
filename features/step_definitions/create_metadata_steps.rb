Given /^an image named "([^"]*)" with the following xmp metadata:$/ do |filename, metadata|
  `convert features/setup/fixtures/#{filename} -profile xmp:#{metadata} features/setup/fixtures/#{filename}`
end

When /^I create a CouchPhoto image object based on that image:$/ do |code|
  eval code
end

Then /^the "([^"]*)" field should return the hash equivalent of the xmp metadata:$/ do |field, code|
  eval code
end

