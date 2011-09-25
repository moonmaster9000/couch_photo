Given /^an instance of an image class definition that calls 'xmp_metadata!':$/ do |string|
  eval string
end

When /^I add an original image to it that has XMP metadata:$/ do |string|
  eval string
end

Then /^the XMP metadata from the image should be accessible via the 'metadata' property on the image:$/ do |string|
  eval string
end

When /^I add an original image to it that does not have XMP metadata:$/ do |string|
  eval string
end
