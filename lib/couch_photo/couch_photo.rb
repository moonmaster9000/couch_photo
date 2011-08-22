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
    @variations ||= Variations.new self 
    @variations.variations.values
  end

  def original
    raise "You do not have an original attachment" unless original_attachment_name
    @original ||= Variation.new self, original_attachment_name
  end

  def original_attachment_name
    @original_attachment_name ||= self["_attachments"].keys.select {|a| a.match /original\.[^\.]+/}.first
  end

  def variation(variation_name=nil)
    variation_name ? @variations.send(variation_name) : @variations
  end

  def original=(*args)#filepath, blob=nil
    filepath, blob = args[0], args[1]
    self["_id"] = File.basename filepath if self.class.override_id?
    self.original_filename = File.basename filepath
    blob ||= File.read filepath
    image_format = filetype(filepath)
    attachment_name = "original.#{image_format}"
    attachment = {:name => attachment_name, :file => Attachment.new(blob, attachment_name)}
    update_or_create_attachment attachment
    self.class.variation_definitions.run_variations(blob).each do |variation_name, variation_blob|
      update_or_create_attachment :name => "variations/#{variation_name}.#{image_format}", :file => Attachment.new(variation_blob, attachment_name) 
    end
  end
  
  def add_variation(variation_name, filename)
    image_format = filetype(filename)
    update_or_create_attachment :name => "variations/#{variation_name}.#{image_format}", :file => Attachment.new(filename, variation_name)
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

    def override_id?
      @override_id
    end

    def variation_definitions
      @variation_definitions ||= VariationDefinitions.new
    end
  end
end
