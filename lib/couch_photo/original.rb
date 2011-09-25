module CouchPhoto
  class Original
    include VariationMetadata

    def initialize(document)
      @document = document
    end

    def create_attachment(filename, data)
      extension = File.extname filename
      @data = data
      @attachment_name = "variations/original#{extension}"
      @document.create_attachment :name => @attachment_name, :file => FakeFile.new(@data)
      @document.original_filename = File.basename(filename)
      @document.xmp_metadata = xmp_metadata if @document.class.extract_xmp_metadata?
    end

    def original_filename
      if exists?
        @document.original_filename
      end
    end

    private
    def attachment_name
      @attachment_name ||= 
        @document["_attachments"].keys.select do |attachment_name| 
          attachment_name.match /variations\/original\.[^.]*/
        end.first
    end
  end
end
