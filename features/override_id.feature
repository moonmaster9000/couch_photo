Feature: Overriding document IDs

  Instead of letting CouchDB generate a UUID for your image documents, you'll likely prefer that the basename of the "original" become the ID of your document. 

  You can accomplish this by simply calling the `override_id!` method inside your class definition:

      class Image < CouchRest::Model::Base
        include CouchPhoto
        override_id!
      end

  Now, if you create a new image document with an original, you'll have a much more human readable path to the original image on your CouchDB server:

      image = Image.new
      image.load_original_from_file "/path/to/my_file.jpg"
      image.save
      image.original.url #==> http://your_couch_server/your_image_database/my_file.jpg/variations/original.jpg


  Scenario: ID set to original image filename when `override_id!` called
    
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
