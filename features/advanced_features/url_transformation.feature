Feature: URL Transformation
  
  By default, accessing the urls of image originals and variations will return the CouchDB url to that attachment. 

  For example, suppose you had used the `couchrest_model_config` gem to configure your Image model to use database server "http://admin:password@1.2.3.4:5984/" and database "assets":

      CouchRest::Model::Config.edit do
        server do
          default "http://admin:password@1.2.3.4:5984"
        end

        database Image do
          default "assets"
        end
      end

  Now, suppose you had an Image "avatar.jpg", and you wanted to access the url to the original image. You'd get "http://admin:password@1.2.3.4:5984/assets/avatar.jpg/variations/original.jpg":
      
      Image.get("avatar.jpg").original.url #==> "http://admin:password@1.2.3.4:5984/assets/avatar.jpg/variations/original.jpg" 

  If you have any intention of exposing this URL to end-users, you'll likely want to change it up a bit. For starters, you'll almost certainly want to remove the http basic auth, and you'll also likely have load balancers and pretty domains.

  You can use the `url_transformer` class method on your Image model to specify a block (or object) that can transform your image URLs. For example, suppose we wanted to replace the entire server domain section of the url `http://admin:password@1.2.3.4:5984` with a public-facing domain `http://my-domain.com`:  

      class Image < CouchRest::Model::Base
        include CouchPhoto

        url_transformer do |url|
          url.gsub %r{http://[^/]+}, "http://my-domain.com"
        end
      end

  Now, retrieving the original url on our "avatar.jpg" image would return:
      
      Image.get("avatar.jpg").original.url #==> "http://my-domain.com/assets/avatar.jpg/variations/original.jpg" 

  You could, if you wished, also supply an object that responds to `transform` to the `url_transformer` macro:

      class UrlTransformer
        def self.transform(url)
          url.gsub %r{http://[^/]+}, "http://my-domain.com"
        end
      end

      class Image < CouchRest::Model::Base
        include CouchPhoto

        url_transformer UrlTransformer
      end


  Scenario: Defining url transformations with a block

    Given the following Image model in which I define a url transformer for turning 'http' requests into 'https' requests:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto

          override_id!

          url_transformer do |url|
            url.gsub "http", "https"
          end

          variations do
            thumbnail "50x50"
          end
        end
      """

    When I create an image and save:
      """
        @image = Image.new
        @image.load_original_from_file "features/fixtures/avatar.jpg"
        @image.save
      """

    Then my image urls should have 'https' instead of 'http':
      """ 
        @image.original.url.should == "https://admin:password@localhost:5984/couch_photo_test/avatar.jpg/variations/original.jpg"
        @image.variations[:thumbnail].url.should == "https://admin:password@localhost:5984/couch_photo_test/avatar.jpg/variations/thumbnail.jpg"
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then my image urls should have 'https' instead of 'http':
      """ 
        @image.original.url.should == "https://admin:password@localhost:5984/couch_photo_test/avatar.jpg/variations/original.jpg"
        @image.variations[:thumbnail].url.should == "https://admin:password@localhost:5984/couch_photo_test/avatar.jpg/variations/thumbnail.jpg"
      """


  Scenario: Defining url transformations with an object
    Given the following URL transformer that strips out basic auth:
      """
        module StripBasicAuth
          extend self

          def transform(url)
            url.gsub %r{^http://([^:]+:[^@]+)@(.*)$} do
              "http://#{$2}"
            end
          end
        end
      """

    And the following Image model in which I supply StripBasicAuth as the url transformer:
      """
        class Image < CouchRest::Model::Base
          include CouchPhoto

          override_id!

          url_transformer StripBasicAuth

          variations do
            thumbnail "50x50"
          end
        end
      """

    When I create an image and save:
      """
        @image = Image.new
        @image.load_original_from_file "features/fixtures/avatar.jpg"
        @image.save
      """

    Then my image urls should not have any basic auth:
      """ 
        @image.original.url.should == "http://localhost:5984/couch_photo_test/avatar.jpg/variations/original.jpg"
        @image.variations[:thumbnail].url.should == "http://localhost:5984/couch_photo_test/avatar.jpg/variations/thumbnail.jpg"
      """

    When I load the image from the database:
      """
        @image = Image.first
      """

    Then my image urls should not have any basic auth:
      """ 
        @image.original.url.should == "http://localhost:5984/couch_photo_test/avatar.jpg/variations/original.jpg"
        @image.variations[:thumbnail].url.should == "http://localhost:5984/couch_photo_test/avatar.jpg/variations/thumbnail.jpg"
      """
