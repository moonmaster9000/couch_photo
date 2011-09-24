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
