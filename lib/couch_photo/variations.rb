module CouchPhoto
  class Variations
    def initialize
      @variations = {}
    end

    def method_missing(method_name, *args, &block)
      if block
        @variations[method_name.to_sym] = Variation.new method_name, *args, &block
      else
        @variations[method_name.to_sym] = Variation.new method_name, *args
      end
    end

    def run_variations(blob)
      results = {}
      @variations.each do |variation_name, variation|
        results[variation_name] = variation.create_variation blob
      end
      results
    end
  end

  class Variation
    def initialize(name, format=nil, &block)
      raise "A variation can not have both a format and a block. Choose one." if format and block
      raise "A variation must have either a format (e.g., '20x20>') or a block." if !format and !block
      @name = name
      @format = format
      @block = block
    end

    def create_variation(blob)
      image = MiniMagick::Image.read(blob)
      @format ? image.resize(@format) : @block.call(image)
      image.to_blob
    end
  end
end
