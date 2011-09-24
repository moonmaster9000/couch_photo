module CouchPhoto
  class FakeFile
    attr_reader :read, :path
    def initialize(data, path=nil)
      @read = data
      @path = nil
    end
  end
end
