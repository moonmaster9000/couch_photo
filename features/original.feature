Feature: Adding an original image to your image document

  Scenario: `load_original_from_file` accepts a filepath
    Given an instance of an image class that includes `CouchPhoto`:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
        end

        @image = Image.new
      """

    When I add an original image to it named 'avatar.jpg' via the `load_original_from_file` method:
      """
        @image.load_original_from_file "features/fixtures/avatar.jpg"
      """

    And I save:
      """
        @image.save
      """

    Then the original image should be added to the database:
      """
        @image["_attachments"]["variations/original.jpg"].should_not be_empty
      """
    
    When I load the image from the database:
      """
        @image = Image.first
      """

    Then the original image should be part of the document:
      """
        @image["_attachments"]["variations/original.jpg"].should_not be_empty
      """
    

  Scenario: `load_original` accepts a filename and a data blob
    Given an instance of an image class that includes `CouchPhoto`:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
        end

        @image = Image.new
      """

    When I call the `load_original` method with filename 'avatar.jpg' a binary blob:
      """
        @image.load_original :filename => "custom_name.jpg", :data => File.read("features/fixtures/avatar.jpg")
      """

    And I save:
      """
        @image.save
      """

    Then the original image should be added to the database:
      """
        @image["_attachments"]["variations/original.jpg"].should_not be_empty
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then the original image should be a part of the document:
      """
        @image["_attachments"]["variations/original.jpg"].should_not be_empty
      """

  
  Scenario: the original is accessible via the `original` method:
    Given an image with an original:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
        end

        @image = Image.new
        @image.load_original_from_file "features/fixtures/avatar.jpg"
        @image.save
      """

    Then I should be able to access metadata about the image via the `original` method:
      """
        @image.original.original_filename.should == "avatar.jpg"
        @image.original.path.should      == "/couch_photo_test/#{@image.id}/variations/original.jpg"
        @image.original.url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/original.jpg"
        @image.original.extension.should == "jpg"
        @image.original.mime_type.should == "image/jpeg"
        @image.original.data.should      == File.read("features/fixtures/avatar.jpg")
        @image.original.width.should     == 128
        @image.original.height.should    == 128
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then I should be able to access metadata about the image via the `original` method:
      """
        @image.original.original_filename.should == "avatar.jpg"
        @image.original.path.should      == "/couch_photo_test/#{@image.id}/variations/original.jpg"
        @image.original.url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/original.jpg"
        @image.original.extension.should == "jpg"
        @image.original.mime_type.should == "image/jpeg"
        @image.original.data.should      == File.read("features/fixtures/avatar.jpg")
        @image.original.width.should     == 128
        @image.original.height.should    == 128
      """
