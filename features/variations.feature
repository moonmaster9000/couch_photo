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
