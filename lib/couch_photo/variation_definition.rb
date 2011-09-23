module CouchPhoto
  class VariationDefinition
    def initialize(variation_name, resize_definition=nil, &custom_definition)
      @variation_name    = variation_name
      @resize_definition = resize_definition
      @custom_definition = custom_definition
    end

    def generate_variation(document)
      attachment_name = "variations/#{@variation_name}.#{document.original.extension}"
      variation = manipulate document.original.data

      if document.has_attachment?(attachment_name)
        document.update_attachment :name => attachment_name, :file => FakeFile.new(variation)
      else
        document.create_attachment :name => attachment_name, :file => FakeFile.new(variation)
      end
    end

    private
    def manipulate(image_blob)
      mini_magick_image = MiniMagick::Image.read(image_blob)
      mini_magick_image.resize @resize_definition if @resize_definition
      mini_magick_image.to_blob
    end
  end
end
