module CouchPhoto
  def self.included(base)
  end

  def load_original_from_file(filepath)
    original.create_attachment File.basename(filepath), File.read(filepath)
  end

  def load_original(options)
    raise "You must provide a :filename" unless options[:filename]
    raise "You must provide a :data parameter" unless options[:data]

    original.create_attachment options[:filename], options[:data]
  end

  def original
    @original ||= CouchPhoto::Original.new self
  end
end
