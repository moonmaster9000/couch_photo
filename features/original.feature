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
        @image.original.path.should == "#{@image.database.name}/#{@image.id}/variations/original.jpg"
      """


