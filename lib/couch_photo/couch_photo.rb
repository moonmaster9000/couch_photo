module CouchPhoto
  def self.included(base)
  end

  def load_original_from_file(filepath)
    create_original File.basename(filepath), File.read(filepath)
  end

  def load_original(options)
    raise "You must provide a :filename" unless options[:filename]
    raise "You must provide a :data parameter" unless options[:data]

    create_original options[:filename], options[:data]
  end

  private
  def create_original(filename, data)
    filetype = File.extname filename
    self.create_attachment :name => "variations/original#{filetype}", :file => FakeFile.new(data)
  end
end
