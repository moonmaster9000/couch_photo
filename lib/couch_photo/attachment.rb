module CouchPhoto
  class Attachment #:nodoc:
    attr_reader :read, :path
    def initialize(data, path=nil)
      @read = data
      @path = nil
    end
  end
end
