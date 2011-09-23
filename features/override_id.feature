Feature: override_id!

  Scenario: Id set to original image filename when `override_id!` called
    
    Given an image class that calls `override_id!`:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto
          override_id!
        end
      """

    When I set the original image on an instance to a file named "avatar.jpg":
      """
        @image = Image.new
        @image.load_original_from_file "features/fixtures/avatar.jpg"
      """
    
    And I save:
      """
        @image.save
      """

    Then the id of the image should be 'avatar.jpg':
      """
        @image.id.should == 'avatar.jpg'
      """
