module CouchPhoto
  class Variation
    include VariationMetadata

    def initialize(document, variation_name)
      @document       = document
      @variation_name = variation_name
    end
  end
end
