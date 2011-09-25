Feature: Variations
  
  Scenario: Variations auto-generated on save
    
    Given an image class definition with a thumbnail variation definition:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto

          variations do
            thumbnail "50x50"
          end
        end
      """
    
    When I create an instance of it and load the original and save:
      """
        @image = Image.new
        @image.load_original_from_file "features/fixtures/avatar.jpg"
        @image.save
      """

    Then the image document should have a thumbnail variation:
      """
        @image.variations[:thumbnail].path.should      == "/couch_photo_test/#{@image.id}/variations/thumbnail.jpg"
        @image.variations[:thumbnail].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/thumbnail.jpg"
        @image.variations[:thumbnail].extension.should == "jpg"
        @image.variations[:thumbnail].mime_type.should == "image/jpeg"
        @image.variations[:thumbnail].width.should     == 50
        @image.variations[:thumbnail].height.should    == 50
        @image.variations[:thumbnail].data.should_not be(nil)
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then the image document should have a thumbnail variation:
      """
        @image.variations[:thumbnail].path.should      == "/couch_photo_test/#{@image.id}/variations/thumbnail.jpg"
        @image.variations[:thumbnail].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/thumbnail.jpg"
        @image.variations[:thumbnail].extension.should == "jpg"
        @image.variations[:thumbnail].mime_type.should == "image/jpeg"
        @image.variations[:thumbnail].width.should     == 50
        @image.variations[:thumbnail].height.should    == 50
        @image.variations[:thumbnail].data.should_not be(nil)
      """


  Scenario: Complex variation definitions
    Given an image class with a complex grayscale variation definition on it:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto

          variations do
            grayscale do |original_image|
              original_image.monochrome
            end
          end
        end
      """
    
    When I create an instance of it and load the original and save:
      """
        @image = Image.new
        @image.load_original_from_file "features/fixtures/avatar.jpg"
        @image.save
      """

    Then the image document should have a thumbnail variation:
      """
        @image.variations[:grayscale].path.should      == "/couch_photo_test/#{@image.id}/variations/grayscale.jpg"
        @image.variations[:grayscale].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/grayscale.jpg"
        @image.variations[:grayscale].extension.should == "jpg"
        @image.variations[:grayscale].mime_type.should == "image/jpeg"
        @image.variations[:grayscale].width.should     == 128
        @image.variations[:grayscale].height.should    == 128
        @image.variations[:grayscale].data.should_not  be(nil)
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then the image document should have a thumbnail variation:
      """
        @image.variations[:grayscale].path.should      == "/couch_photo_test/#{@image.id}/variations/grayscale.jpg"
        @image.variations[:grayscale].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/grayscale.jpg"
        @image.variations[:grayscale].extension.should == "jpg"
        @image.variations[:grayscale].mime_type.should == "image/jpeg"
        @image.variations[:grayscale].width.should     == 128
        @image.variations[:grayscale].height.should    == 128
        @image.variations[:grayscale].data.should_not  be(nil)
      """


  Scenario: Creating a custom variation via "load_custom_variation_from_file" method

    Given an instance of an image class that includes `CouchPhoto`:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
        end

        @image = Image.new
      """

    When I add a custom variation to it via the 'load_custom_variation_from_file' method:
      """
        @image.load_custom_variation_from_file "features/fixtures/monochrome.jpg"
      """

    And I save:
      """
        @image.save
      """

    Then I should have a custom variation named 'monochrome':
      """
        @image.variations["monochrome.jpg"].path.should      == "/couch_photo_test/#{@image.id}/variations/monochrome.jpg"
        @image.variations["monochrome.jpg"].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/monochrome.jpg"
        @image.variations["monochrome.jpg"].extension.should == "jpg"
        @image.variations["monochrome.jpg"].mime_type.should == "image/jpeg"
        @image.variations["monochrome.jpg"].width.should     == 128
        @image.variations["monochrome.jpg"].height.should    == 128
        @image.variations["monochrome.jpg"].data.should_not  be(nil)
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then I should have a custom variation named 'monochrome':
      """
        @image.variations["monochrome.jpg"].path.should      == "/couch_photo_test/#{@image.id}/variations/monochrome.jpg"
        @image.variations["monochrome.jpg"].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/monochrome.jpg"
        @image.variations["monochrome.jpg"].extension.should == "jpg"
        @image.variations["monochrome.jpg"].mime_type.should == "image/jpeg"
        @image.variations["monochrome.jpg"].width.should     == 128
        @image.variations["monochrome.jpg"].height.should    == 128
        @image.variations["monochrome.jpg"].data.should_not  be(nil)
      """


  Scenario: Creating a custom variation via "load_custom_variation" method

    Given an instance of an image class that includes `CouchPhoto`:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
        end

        @image = Image.new
      """

    When I add a custom variation to it via the 'load_custom_variation' method:
      """
        @image.load_custom_variation "crazy_variations/my_awesome_custom_variation.jpg", File.read("features/fixtures/monochrome.jpg")
      """

    And I save:
      """
        @image.save
      """

    Then I should have a custom variation named 'crazy_variations/my_awesome_custom_variation.jpg':
      """
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].path.should      == "/couch_photo_test/#{@image.id}/variations/crazy_variations/my_awesome_custom_variation.jpg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/crazy_variations/my_awesome_custom_variation.jpg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].extension.should == "jpg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].mime_type.should == "image/jpeg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].width.should     == 128
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].height.should    == 128
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].data.should_not  be(nil)
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then I should have a custom variation named 'crazy_variations/my_awesome_custom_variation.jpg':
      """
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].path.should      == "/couch_photo_test/#{@image.id}/variations/crazy_variations/my_awesome_custom_variation.jpg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].url.should       == "http://admin:password@localhost:5984/couch_photo_test/#{@image.id}/variations/crazy_variations/my_awesome_custom_variation.jpg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].extension.should == "jpg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].mime_type.should == "image/jpeg"
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].width.should     == 128
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].height.should    == 128
        @image.variations["crazy_variations/my_awesome_custom_variation.jpg"].data.should_not  be(nil)
      """
  
  
  @focus
  Scenario: Adding metadata onto your image variations

    Given an image class definition with a thumbnail variation definition:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto

          variations do
            thumbnail "50x50"
          end
        end
      """

    When I create an instance of it and add an original image to it:
      """
        @image = Image.new
        @image.load_original_from_file "features/fixtures/avatar.jpg"
      """
    
    Then I should be able to add metadata to the thumbnail variation:
      """
        @image.variations[:thumbnail].metadata["alt"] = "Hi!"
      """

    And I should be able to access metadata on the thumbnail variation:
      """
        @image.variations[:thumbnail].metadata["alt"].should == "Hi!"
      """

    When I save:
      """
        @image.save
      """

    Then I should be able to access metadata on the thumbnail variation:
      """
        @image.variations[:thumbnail].metadata["alt"].should == "Hi!"
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then I should be able to access metadata on the thumbnail variation:
      """
        @image.variations[:thumbnail].metadata["alt"].should == "Hi!"
      """
