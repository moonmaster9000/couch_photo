module CouchPhoto
  class CustomVariation
    include VariationMetadata

    def initialize(document, variation_name)
      @document       = document
      @variation_name = variation_name
    end

    def create_attachment(blob)
      @data = blob
      @document.create_attachment :name => attachment_name, :file => FakeFile.new(@data)
    end

    private 
    def attachment_name
      "variations/#{@variation_name}"
    end
  end
end
