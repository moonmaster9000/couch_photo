module CouchPhoto
  def self.included(base)
    base.property :original_filename
    base.extend ClassMethods
    base.before_create :generate_variations
  end

  module ClassMethods
    def override_id!
      self.before_create :set_id_to_original_filename
    end

    def variations(&block)
      @variation_config ||= CouchPhoto::VariationConfig.new
      @variation_config.instance_eval &block if block
      @variation_config
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

  def original
    @original ||= CouchPhoto::Original.new self
  end

  def variations
    load_variations
    @variations
  end

  private
  def load_variations
    unless @variations
      @variations = {}
      self.class.variations.variation_definitions.each do |variation_name, variation_definition|
        @variations[variation_name] = CouchPhoto::Variation.new self, variation_name
      end
    end

    @variations
  end

  def set_id_to_original_filename
    if self.original_filename.blank?
      self.errors.add :original, "must be set before create"
    else
      self.id = self.original_filename
    end
  end

  def generate_variations
    self.class.variations.variation_definitions.each do |variation_name, variation_definition|
      variation_definition.generate_variation self
    end
  end
end
