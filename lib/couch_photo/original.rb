module CouchPhoto
  class Original
    def initialize(document)
      @document = document
    end

    def create_attachment(filename, data)
      extension = File.extname filename
      @attachment_name = "variations/original#{extension}"
      @document.create_attachment :name => @attachment_name, :file => FakeFile.new(data)
      @document.original_filename = File.basename(filename)
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

    def original_filename
      if exists?
        @document.original_filename
      end
    end

    def mime_type
      if exists?
        @mime_type ||= @document["_attachments"][attachment_name]["content_type"]
      end
    end

    def data
      if exists?
        @document.read_attachment attachment_name
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
      @attachment_name ||= 
        @document["_attachments"].keys.select do |attachment_name| 
          attachment_name.match /variations\/original\.[^.]*/
        end.first
    end
  end
end
