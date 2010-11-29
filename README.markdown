#Introduction

A mixin for auto-generating image variations on Image documents with CouchDB.

##Installation

    $ gem install couch_photo

## Documentation

Browse the documentation on rdoc.info: http://rdoc.info/github/moonmaster9000/couch_photo

##How does it work?

Just "include CouchPhoto" in your "CouchRest::Model::Base" classes and define some variations.

###Simple Variations

Let's imagine we want to auto-generate small, medium, and large variations of our image everytime it gets updated.

First, define an Image document and set the versions on it:

    class Image < CouchRest::Model::Base
      use_database IMAGE_DB
      include CouchPhoto

      override_id! # the id of the document will be the basename of the original image file

      variations do
        small "20x20"
        medium "100x100"
        large "500x500"
      end
    end

Next, create an instance of the image document and set the "original" image on it.

    i = Image.new
    i.original = "avatar.jpg"
    i.save

By calling the original method with a string, CouchPhoto will attempt to open a file with the same name and use that as the original image. If you don't have
an actual file (e.g., maybe this was a form upload), then simply pass a blob as the second parameter. For example, 

    blob = File.read "avatar.jpg"
    i.original = ["avatar.jpg", blob]

Now, if you look in your image document in CouchDB, you'd see the following attachments:

    http://your_couch_server/your_image_database/avatar.jpg/original.jpg
    http://your_couch_server/your_image_database/avatar.jpg/variations/small.jpg
    http://your_couch_server/your_image_database/avatar.jpg/variations/medium.jpg
    http://your_couch_server/your_image_database/avatar.jpg/variations/large.jpg

Notice that, because we called the `override_id!` method, `CouchPhoto` set the ID of your image document to the basename of your original image.

###Complex Variations

The previous variations were all simple image resizings. What if we wanted to do something a little more complex? Like grayscale the original image? Or create a watermark? No prob!

    class Image < CouchRest::Model::Base
      use_database IMAGE_DB
      include CouchPhoto

      override_id! # the id of the document will be the basename of the original image file

      variations do
        grayscale do |original_image|
          original_image.monochrome
        end

        watermark do |original_image|
          original_image.composite(MiniMagick::Image.open("watermark.png", "jpg") do |c|
            c.gravity "center"
          end
        end
      end
    end

The `original_image` variable in the blocks is simply the MiniMagick::Image instance of your original image.

### Accessing the Original Image

How do you access the the original image? Let me count the ways: 

    @image.original.original_filename # ==> "avatar.jpg"
    @image.original.filename # ==> "original.jpg"
    @image.original.path # ==> "/your_image_database/avatar.jpg/original.jpg"
    @image.original.url # ==> "http://your_couch_server/your_image_database/avatar.jpg/original.jpg"
    @image.original.basename # ==> "original.jpg"
    @image.original.filetype # ==> "jpg"
    @image.original.mimetype # ==> "image/jpg"
    @image.original.data # ==> BINARY BLOB

### Accessing Variations

So, now that you've got some variations, how do you access them? Simple!

Let's go back to our original image example: 

    class Image < CouchRest::Model::Base
      use_database IMAGE_DB
      include CouchPhoto

      override_id! # the id of the document will be the basename of the original image file

      variations do
        small "20x20"
        medium "100x100"
        large "500x500"
      end
    end

    i = Image.new
    i.original = "avatar.jpg"
    i.save

We can access our variations in one of three ways: 
- the `variations` method, which returns an array of all of our variations
- the `variation.<variation_name>` method, which returns a specific variation
- the `variation("<variation_name>")`, which also returns a specific variation

For example: 
  
    i.variations
    i.variation.small
    i.variation "large"

Once you've got a variation, you can call several methods on it: 

    i.variation.small.name # ==> "small"
    i.variation.small.path # ==> "http://your_couch_server/your_image_database/avatar.jpg/variations/small.jpg"
    i.variation.small.filename # ==> "variations/small.jpg"
    i.variation.small.basename # ==> "small.jpg"
    i.variation.small.filetype # ==> "jpg"
    i.variation.small.mimetype # ==> "image/jpg"
    i.variation.small.data # ==> BINARY BLOB
