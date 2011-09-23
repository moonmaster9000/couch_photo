module CouchPhoto
  class Original
    def initialize(document)
      @document = document
    end

    def create_attachment(filename, data)
      extension = File.extname filename
      @attachment_name = "variations/original#{extension}"
      @document.create_attachment :name => @attachment_name, :file => FakeFile.new(data)
    end

    def path
      if exists?
        "#{@document.database.name}/#{@document.id}/#{attachment_name}"
      end
    end

    private
    def exists?
      attachment_name != nil
    end

    def attachment_name
      @attachment_name ||= 
        @document["_attachments"].keys.select do |attachment_name| 
          attachment_name.match /variations\/original\.[^.]*/
        end.first
    end
  end
end
