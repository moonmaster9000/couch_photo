module CouchPhoto

  
  class VariationDefinitions
    attr_reader :variations
    
    def initialize
      @variations = {}
    end

    def method_missing(method_name, *args, &block)
      if block
        @variations[method_name.to_sym] = VariationDefinition.new method_name, *args, &block
      else
        @variations[method_name.to_sym] = VariationDefinition.new method_name, *args
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

  class VariationDefinition
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

  class Variations
    attr_reader :variations, :document

    def initialize(document)
      @document = document
      @variations = {}
      attachments = document["_attachments"] || {}
      attachments.keys.select {|name| name.match /variations\//}.each do |variation_name|
        if document.class.variation_definitions.variations.keys.include?(CouchPhoto.variation_short_name(variation_name).to_sym)
          variation_key = CouchPhoto.variation_short_name(variation_name)
        else
          variation_key = CouchPhoto.variation_short_name_from_path(variation_name)
        end
        @variations[variation_key] = Variation.new document, variation_name
      end
    end
    
    def each(&block)
      @variations.each &block
    end
    
    def count
    end

    def method_missing(method_name, *args, &block)
      raise "Unknown variation '#{method_name}'" unless @variations[method_name.to_s]
      @variations[method_name.to_s]
    end
    
    def add_variation(variation_name)
      @variations[variation_name] = Variation.new document, "variations/#{variation_name}"
    end
  end

  class Variation
    attr_reader :name, :url, :path, :filename, :basename, :filetype, :mimetype

    def initialize(document, attachment_name)
      @path = "/" + [document.database.name, document.id, attachment_name].join("/")
      @url = [document.database.to_s, document.id, attachment_name].join "/"
      @attachment_name = attachment_name
      @name = CouchPhoto.variation_short_name attachment_name
      @filename = attachment_name
      @basename = File.basename attachment_name 
      @document = document
      @filetype = CouchPhoto.variation_file_extension attachment_name
      @mimetype = document["_attachments"][attachment_name]["content_type"]
    end

    def data
      @document.read_attachment @attachment_name
    end

    def original_filename
      @document.original_filename
    end
  end
end
