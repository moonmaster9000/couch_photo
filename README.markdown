#Introduction

A mixin for auto-generating image variations on Image documents with CouchDB.

##Installation

```sh
    $ gem install couch_photo
```
## Documentation

Browse the documentation on rdoc.info: http://rdoc.info/gems/couch_photo/frames

##How does it work?

Just "include CouchPhoto" in your "CouchRest::Model::Base" classes and you can start creating image documents and autogenerating variations with ease.

### The original image

Each image document is centered around the concept of the "original" image. This is the original, unpolluted image that forms the core of the document. 

You can use the `load_original_from_file` method on an instance of your `Image` class to create an image document with an original image from your filesystem:

```ruby
class Image < CouchRest::Model::Base
  include CouchPhoto
end

@image = Image.new
@image.load_original_from_file "/path/to/my_file.jpg"
@image.save
```

Here, we've created a new image instance, then added an "original" image to it via the `load_original_from_file` method by specifiying a file on the disk. Upon `save`, this file is read from disk and stored in CouchDB. We could now access our original image thusly:

```ruby
@image.original.original_filename # ==> "my_file.jpg"
@image.original.path              # ==> "/your_image_database/8383830jlkfdjskalfjdirewio/variations/original.jpg"
@image.original.url               # ==> "http://your_couch_server/your_image_database/8383830jlkfdjskalfjdirewio/variations/original.jpg"
@image.original.extension         # ==> "jpg"
@image.original.mimetype          # ==> "image/jpg"
@image.original.data              # ==> BINARY BLOB
@image.original.width             # ==> 720
@image.original.height            # ==> 480
```

Suppose the original image isn't on file, but simply in memory (perhaps this was a form upload). You can use the `load_original` method to pass a raw binary blob via the `:data` parameter:

```ruby
@image.load_original :filename => "my_file.jpg", :data => File.read("/path/to/my_file.jpg")
```


### The `override_id!` method

Instead of letting CouchDB generate a UUID for your image documents, you'll likely prefer that the basename of the "original" become the ID of your document. 

You can accomplish this by simply calling the `override_id!` method inside your class definition:

```ruby
class Image < CouchRest::Model::Base
  include CouchPhoto
  override_id!
end
```

Now, if you create a new image document with an original, you'll have a much more human readable path to the original image on your CouchDB server:

```ruby
@image = Image.new
@image.load_original_from_file "/path/to/my_file.jpg"
@image.save
@image.original.url #==> http://your_couch_server/your_image_database/my_file.jpg/variations/original.jpg
```

###Simple Variations

Let's imagine we want to auto-generate small, medium, and large variations of our image everytime it gets updated.

First, define an Image document and set the versions on it:

```ruby
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
```

Next, create an instance of the image document and set the "original" image on it.

```ruby
i = Image.new
i.load_original_from_file "/path/to/avatar.jpg"
i.save
```

Now, if you look in your image document in CouchDB, you'll see the following attachments:

    http://your_couch_server/your_image_database/avatar.jpg/original.jpg
    http://your_couch_server/your_image_database/avatar.jpg/variations/small.jpg
    http://your_couch_server/your_image_database/avatar.jpg/variations/medium.jpg
    http://your_couch_server/your_image_database/avatar.jpg/variations/large.jpg


###Complex Variations

The previous variations were all simple image resizings. What if we wanted to do something a little more complex? Like grayscale the original image? Or create a watermark? No prob!

```ruby
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
```

The `original_image` variable in the blocks is simply the MiniMagick::Image instance of your original image.


### Accessing Variations

So, now that you've got some variations, how do you access them? Simple!

Let's go back to our original image example: 

```ruby
class Image < CouchRest::Model::Base
  include CouchPhoto

  override_id!

  variations do
    small "20x20"
    medium "100x100"
    large "500x500"
  end
end

i = Image.new
i.load_original_from_file "/path/to/couchdb.jpg"
i.save
```

The `variations` method on our model is a hash of all the variations; the keys are the variation names, and the values are a variation object:

We can access our variations in one of three ways: 
- the `variations` method, which will allow you to iterate over the variation_name/variation pairs via the `each` method
- the `variation.<variation_name>` method, which returns a specific variation
- the `variation[:<variation_name>]`, which also returns a specific variation

For example: 
    
```ruby
# iterate over all variations
i.variations.each do |variation_name, variation_image|
  puts variation_name
  puts variation.filename
  # etc...
end

# access the "small" variation
i.variations.small

# access the "large" variation
i.variations["large"]
#or...
i.variations[:large]
```

Once you've got a variation, you can call several methods on it: 

```ruby
i.variations[:small].name        # ==> "small"
i.variations[:small].path        # ==> "/your_image_database/avatar.jpg/variations/small.jpg"
i.variations[:small].url         # ==> "http://your.couch.server/your_image_database/avatar.jpg/variations/small.jpg"
i.variations[:small].width       # ==> 50
i.variations[:small].height      # ==> 50
i.variations[:small].basename    # ==> "small.jpg"
i.variations[:small].filetype    # ==> "jpg"
i.variations[:small].mimetype    # ==> "image/jpg"
i.variations[:small].data        # ==> BINARY BLOB
```

## Creating Custom Variations

If you'd like to add a variation to your image document that's not predefined / autogenerated, you can use the `load_custom_variation` and `load_custom_variation_from_file` methods:

```ruby
i = Image.new
i.load_original_from_file "/path/to/somefile.jpg"
i.load_custom_variation_from_file "/path/to/small_watermark.jpg"
i.load_custom_variation :filename => "large_greyscale.jpg", :data => File.read("/path/to/some_image.jpg")
i.save
```

These images would be accessible via the following urls:


    http://your_couch_server/your_image_database/somefile.jpg/variations/original.jpg
    http://your_couch_server/your_image_database/somefile.jpg/variations/small_watermark.jpg
    http://your_couch_server/your_image_database/somefile.jpg/variations/large_watermark.jpg
    

## XMP Metadata

Need to access the XMP Metadata on your original?  It's as simple as adding xmp_metadata! into your document definition.

```ruby
class Image < CouchRest::Model::Base
  use_database IMAGE_DB
  include CouchPhoto

  extract_xmp_metadata!
  override_id! # the id of the document will be the basename of the original image file

  variations do
    small "20x20"
    medium "100x100"
    large "500x500"
  end
end

i = Image.new
i.load_original_from_file "avatar.jpg"
i.save
```

Now you can access your image's XMP metadata as a hash by calling `i.xmp_metadata`.


## Adding extra properties to your variations

Perhaps you'd like to add some extra properties that you can save for each of your image variations, like "alt" text, or captions. Simply use the `metadata` hash on your variations.

For example, given the following definition:

```ruby
class Image < CouchRest::Model::Base
  use_database IMAGE_DB
  include CouchPhoto

  variations do
    thumbnail "20x20"
    grayscale do |original_image|
      original_image.monochrome
    end
  end
end
```

You could now set any metadata properties you desire on your variations:

```ruby
@image = Image.first
@image.variations[:small].metadata["alt"] = "alt text"
@image.variations[:grayscale].metadata["caption"] = "Grayscale version of: #{@image.original.url}"
@image.save
```
