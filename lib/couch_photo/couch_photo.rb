module CouchPhoto
  def self.included(base)
    base.property :original_filename
    base.extend ClassMethods
  end

  module ClassMethods
    def override_id!
      self.before_create :set_id_to_original_filename
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

  private
  def set_id_to_original_filename
    if self.original_filename.blank?
      self.errors.add :original, "must be set before create"
    else
      self.id = self.original_filename
    end
  end
end
