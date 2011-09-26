module CouchPhoto
  def self.included(base)
    base.property :original_filename
    base.property :variation_metadata, Hash, :default => {}
    base.extend ClassMethods
    base.before_create :generate_variations
  end

  module ClassMethods
    def override_id!
      self.before_validate :set_id_to_original_filename
    end

    def extract_xmp_metadata!
      @extract_xmp_metadata = true
      self.property :xmp_metadata, Hash, :default => nil
    end

    def variations(&block)
      @variation_config ||= CouchPhoto::VariationConfig.new
      @variation_config.instance_eval &block if block
      @variation_config
    end

    def extract_xmp_metadata?
      @extract_xmp_metadata
    end
  end

  def load_original_from_file(filepath)
    original.create_attachment File.basename(filepath), File.read(filepath)
  end

  def load_original(options)
    raise "You must provide a :filename parameter" unless options[:filename]
    raise "You must provide a :data parameter" unless options[:data]

    original.create_attachment options[:filename], options[:data]
  end

  def load_custom_variation_from_file(filepath)
    variation_name = File.basename filepath
    variations[variation_name] = CouchPhoto::CustomVariation.new self, variation_name
    variations[variation_name].create_attachment File.read(filepath)
  end

  def load_custom_variation(options={})
    raise "You must provide a :filename parameter" unless options[:filename]
    raise "You must provide a :data parameter" unless options[:data]

    variations[options[:filename]] = CouchPhoto::CustomVariation.new self, options[:filename]
    variations[options[:filename]].create_attachment options[:data]
  end

  def original
    @original ||= CouchPhoto::Original.new self
  end

  def variations
    @variations ||= load_variations
  end

  private
  def load_variations
    all_variations = {}

    # setup defined variations
    defined_variation_names.each do |defined_variation_name|
      all_variations[defined_variation_name.to_sym] = CouchPhoto::Variation.new self, defined_variation_name
    end

    # setup custom variations
    custom_variation_names.each do |custom_variation_name|
      all_variations[custom_variation_name] = CouchPhoto::CustomVariation.new self, custom_variation_name
    end

    all_variations
  end
  
  def defined_variation_names
    self.class.variations.variation_definitions.keys.map(&:to_s)
  end

  def custom_variation_names
    all_variation_names.select do |variation_name| 
      !defined_variation_names.include?(strip_extension(variation_name))
    end
  end

  def all_variation_names
    if self["_attachments"]
      self["_attachments"].keys.
        select {|attachment_name| attachment_name.match /variations\/.*/}.
        map {|attachment_name| attachment_name.gsub(/^variations\/(.*)$/) { $1 }}
    else
      []
    end
  end

  def strip_extension(filename)
    filename.gsub(/\.[^.]*/, '')
  end

  def set_id_to_original_filename
    if self.original_filename.blank?
      self.errors.add :original, "must be set before create"
    else
      self.id = self.original_filename if self.id.blank?
    end
  end

  def generate_variations
    self.class.variations.variation_definitions.each do |variation_name, variation_definition|
      variation_definition.generate_variation self
    end
  end
end
