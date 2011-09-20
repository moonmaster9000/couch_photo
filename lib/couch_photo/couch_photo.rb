module CouchPhoto
  def self.included(base)
    base.extend ClassMethods
    base.property :original_filename
  end

  def update_or_create_attachment(attachment)
    if self.has_attachment? attachment[:name]
      self.update_attachment attachment
    else
      self.create_attachment attachment
    end
  end

  def variations
    @variations = Variations.new self 
  end

  def original
    raise "You do not have an original attachment" unless original_attachment_name
    @original ||= Variation.new self, original_attachment_name
  end

  def original_attachment_name
    @original_attachment_name ||= self["_attachments"].keys.select {|a| a.match /original\.[^\.]+/}.first
  end

  def variation(variation_name=nil)
    variation_name ? variations.send(variation_name) : variations
  end

  def original=(*args)#filepath, blob=nil
    if args[0].kind_of?(Array)
      filepath, blob = args[0].first, args[0].last
    else
      filepath = args[0]
      blob = nil
    end
    image_format = filetype(filepath)
    filename = File.basename filepath
    basename = File.basename(filepath, "." + "#{image_format}")

    if self.class.xmp_metadata?
      if blob
        File.open("/tmp/#{filename}", 'w') { |f| f.write blob } if !blob.nil?
        `convert /tmp/#{filename} /tmp/#{basename}.xmp`
      else
        `convert #{filepath} /tmp/#{basename}.xmp`
      end
      self.metadata = Hash.from_xml File.read("/tmp/#{basename}.xmp")
      File.delete("/tmp/#{basename}.xmp")
    end

    self["_id"] = filename if self.class.override_id?
    self.original_filename = filename
    blob ||= File.read filepath
    attachment_name = "original.#{image_format}"
    attachment = {:name => attachment_name, :file => Attachment.new(blob, attachment_name)}
    update_or_create_attachment attachment
    self.class.variation_definitions.run_variations(blob).each do |variation_name, variation_blob|
      update_or_create_attachment :name => "variations/#{variation_name}.#{image_format}", :file => Attachment.new(variation_blob, attachment_name) 
    end
  end
  
  def add_variation(variation_name, opt={})
    if opt[:file]
      blob = File.read("#{opt[:file]}")
    elsif opt[:blob]
      blob = opt[:blob]
    end
    update_or_create_attachment :name => "variations/#{variation_name}", :file => Attachment.new(blob, variation_name)
    variations.add_variation variation_name
  end
  
  def filetype(filename)
    filename.match(/^.*\.([^\.]*)$/)[1]
  end

  module ClassMethods
    def variations(&block)
      raise "You must pass a block to the `variations' method." unless block
      variation_definitions.instance_eval(&block)
    end
    
    def override_id!
      @override_id = true
    end
    
    def xmp_metadata!
      @xmp_metadata = true
      self.property :metadata, Hash
    end
    
    def xmp_metadata?
      @xmp_metadata
    end

    def override_id?
      @override_id
    end

    def variation_definitions
      @variation_definitions ||= VariationDefinitions.new
    end
  end
  
  module_function
  def variation_short_name(variation_path)
    variation_path.gsub(/(?:variations\/)?(.+)\.[^\.]+/) {$1}
  end
  
  def variation_short_name_from_path(variation_path)
    variation_path.gsub(/(?:variations\/)?(.+)/) {$1}
  end
  
  def variation_file_extension(variation_path)
    variation_path.gsub(/(?:variations\/)?.+\.([^\.]+)/) {$1}
  end
end
