module CouchPhoto
  class Variation
    def initialize(document, variation_name)
      @document       = document
      @variation_name = variation_name
    end

    def path
      if exists?
        "/#{@document.database.name}/#{@document.id}/#{attachment_name}"
      end
    end

    def extension
      if exists?
        @extension ||= File.extname(attachment_name).gsub(/\./, '')
      end
    end

    def mime_type
      if exists?
        @mime_type ||= @document["_attachments"][attachment_name]["content_type"]
      end
    end

    def data
      if exists?
        @data ||= @document.read_attachment attachment_name
      end
    end

    def width
      mini_magick[:width] 
    end

    def height
      mini_magick[:height]
    end

    def url
      if exists?
        "#{@document.database.root}/#{@document.id}/#{attachment_name}"
      end
    end

    private
    def exists?
      attachment_name != nil
    end

    def mini_magick
      if exists?
        @mini_magick ||= MiniMagick::Image.read(self.data)
      end
    end

    def attachment_name
      "variations/#{@variation_name}.#{@document.original.extension}"
    end
  end
end
