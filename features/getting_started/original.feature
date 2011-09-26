Feature: The "Original" Image

  Each image document is centered around the concept of the "original" image. This is the original, unpolluted image that forms the core of the document. 

  You can use the `load_original_from_file` method on an instance of your `Image` class to create an image document with an original image from your filesystem:

      class Image < CouchRest::Model::Base
        include CouchPhoto
      end

      image = Image.new
      image.load_original_from_file "/path/to/my_file.jpg"
      image.save

  Here, we've created a new image instance, then added an "original" image to it via the `load_original_from_file` method by specifiying a file on the disk. Upon `save`, this file is read from disk and stored in CouchDB. We could now access our original image thusly:

      image.original.original_filename # ==> "my_file.jpg"
      image.original.path              # ==> "/your_image_database/8383830jlkfdjskalfjdirewio/variations/original.jpg"
      image.original.url               # ==> "http://your_couch_server/your_image_database/8383830jlkfdjskalfjdirewio/variations/original.jpg"
      image.original.extension         # ==> "jpg"
      image.original.mimetype          # ==> "image/jpg"
      image.original.data              # ==> BINARY BLOB
      image.original.width             # ==> 720
      image.original.height            # ==> 480

  Suppose the original image isn't on file, but simply in memory (perhaps this was a form upload). You can use the `load_original` method to pass a raw binary blob via the `:data` parameter:

      image.load_original :filename => "my_file.jpg", :data => File.read("/path/to/my_file.jpg")



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
        @image.original.url.should       == "#{Image.database.host}/couch_photo_test/#{@image.id}/variations/original.jpg"
        @image.original.extension.should == "jpg"
        @image.original.mime_type.should == "image/jpeg"
        @image.original.data.should      == File.read("features/fixtures/avatar.jpg")
        @image.original.width.should     == 128
        @image.original.height.should    == 128
        @image.original.custom_variation?.should be(false)
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then I should be able to access metadata about the image via the `original` method:
      """
        @image.original.original_filename.should == "avatar.jpg"
        @image.original.path.should      == "/couch_photo_test/#{@image.id}/variations/original.jpg"
        @image.original.url.should       == "#{Image.database.host}/couch_photo_test/#{@image.id}/variations/original.jpg"
        @image.original.extension.should == "jpg"
        @image.original.mime_type.should == "image/jpeg"
        @image.original.data.should      == File.read("features/fixtures/avatar.jpg")
        @image.original.width.should     == 128
        @image.original.height.should    == 128
        @image.original.custom_variation?.should be(false)
      """
