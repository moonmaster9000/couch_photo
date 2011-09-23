module CouchPhoto
  class VariationConfig
    attr_reader :variation_definitions
    
    def initialize
      @variation_definitions = {} 
    end

    def method_missing(variation_name, *args, &block)
      variation_name = variation_name.to_sym
      resize_definition = args.first
      @variation_definitions[variation_name.to_sym] = CouchPhoto::VariationDefinition.new(
        variation_name, 
        resize_definition, 
        &block
      )
    end
  end
end
