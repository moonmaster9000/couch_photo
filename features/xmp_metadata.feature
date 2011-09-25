Feature: Working with XMP Metadata

  h2. XMP Metadata

  Need to access the XMP Metadata on your original?  It's as simple as adding `extract_xmp_metadata!` into your document definition.

      class Image < CouchRest::Model::Base
        include CouchPhoto
        extract_xmp_metadata!
      end

      i = Image.new
      i.load_original_from_file "avatar.jpg"
      i.save

  Now you can access your image's XMP metadata as a hash by calling `i.xmp_metadata`.

  
  Scenario: The "extract_xmp_metadata!" class method causes CouchPhoto to autoextract the xmp metadata from your original image and store it on your document
    
    Given an instance of an image class definition that calls 'extract_xmp_metadata!': 
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
          extract_xmp_metadata!
        end

        @image = Image.new
      """

    When I add an original image to it that has XMP metadata:
      """
        @image.load_original_from_file "features/fixtures/xmp.jpg"
      """

    And I save:
      """
        @image.save
      """

    Then the XMP metadata from the image should be accessible via the 'xmp_metadata' property on the image:
      """
        @image.xmp_metadata.should_not be(nil)
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then the XMP metadata from the image should be accessible via the 'xmp_metadata' property on the image:
      """
        @image.xmp_metadata.should_not be(nil)
      """

 
  Scenario: The "xmp_metadata" responds with an empty hash when the original image had no xmp metadata
    
    Given an instance of an image class definition that calls 'extract_xmp_metadata!': 
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
          extract_xmp_metadata!
        end

        @image = Image.new
      """

    When I add an original image to it that does not have XMP metadata:
      """
        @image.load_original_from_file "features/fixtures/no-xmp.jpg"
      """

    And I save:
      """
        @image.save
      """

    Then the XMP metadata from the image should be accessible via the 'xmp_metadata' property on the image:
      """
        @image.xmp_metadata.should be(nil)
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then the XMP metadata from the image should be accessible via the 'xmp_metadata' property on the image:
      """
        @image.xmp_metadata.should be(nil)
      """
