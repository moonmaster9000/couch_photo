Feature: Accessing Original Image Attachment
  As a developer
  I want to easily access the original version of my image
  So that I can use it

Scenario: Iterating through all variations
  Given an instance of a model with CouchPhoto
  
  When I call the `original` method
  Then I should get an object representing the original image associated with the document
  
  When I call the `original.original_filename` method
  Then I should get the original filename of the original image associated with the document
  
  When I call the `original.filename` method
  Then I should get the filename of the original image attachment
  
  When I call the `original.url` method
  Then I should get the url of the original image attachment

  When I call the `original.path` method
  Then I should get the path of the original image attachment

  When I call the `original.filetype` method
  Then I should get the filetype of the original image attachment

  When I call the `original.mimetype` method
  Then I should get the mimetype of the original image attachment

  When I call the `original.data` method
  Then I should get a binary blob of the original image attachment
