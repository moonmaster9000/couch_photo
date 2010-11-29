module CouchPhoto
  class VariationDefinitions
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
    attr_reader :variations

    def initialize(document)
      @variations = {}
      attachments = document["_attachments"] || {}
      attachments.keys.select {|name| name.match /variations\//}.each do |variation_name|
        variation_short_name = variation_name.gsub(/variations\/(.+)\.[^\.]+/) {$1}
        @variations[variation_short_name] = Variation.new document, variation_name
      end
    end

    def method_missing(method_name, *args, &block)
      raise "Unknown variation '#{method_name}'" unless @variations[method_name.to_s]
      @variations[method_name.to_s]
    end
  end

  class Variation
    attr_reader :name, :url, :path, :filename, :basename, :filetype, :mimetype

    def initialize(document, attachment_name)
      @path = "/" + [document.database.name, document.id, attachment_name].join("/")
      @url = [document.database.to_s, document.id, attachment_name].join "/"
      @attachment_name = attachment_name
      @name = attachment_name.gsub(/(?:variations\/)?(.+)\.[^\.]+/) {$1}
      @filename = attachment_name
      @basename = File.basename attachment_name 
      @document = document
      @filetype = attachment_name.gsub(/(?:variations\/)?.+\.([^\.]+)/) {$1}
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
