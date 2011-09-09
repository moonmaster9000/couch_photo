Feature: Creating custom metadata
  As a developer
  I want to add custom metadata to the image
  So that the metadata can always be found with the image

Scenario: Creating custom metadata
  Given an image named "metadata.jpg" with the following xmp metadata:
    """
      <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 4.2-c020 1.124078, Tue Sep 11 2007 23:21:40        "> <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"> <rdf:Description  xmlns:amex="http://amexpub.com/custom/" amex:photographer="Courtesy of Singita Hotels" amex:magazine="Travel + Leisure"> </rdf:Description> </rdf:RDF> </x:xmpmeta>
    """
  
  When I create a CouchPhoto image object based on that image:
    """
      class CustomVariationImage < CouchRest::Model::Base
        use_database IMAGE_DB
        include CouchPhoto
        xmp_metadata!
        override_id! 
      end

      @image = CustomVariationImage.new
      @image.original = "features/setup/fixtures/metadata.jpg"
      @image.save
    """
  
  Then the "metadata" field should return the hash equivalent of the xmp metadata:
    """
      @image.metadata.should == {"xmpmeta"=>{"xmlns:x"=>"adobe:ns:meta/", "x:xmptk"=>"Adobe XMP Core 4.2-c020 1.124078, Tue Sep 11 2007 23:21:40        ", "RDF"=>{"xmlns:rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "Description"=>{"amex:photographer"=>"Courtesy of Singita Hotels", "amex:magazine"=>"Travel + Leisure", "__content__"=>" ", "xmlns:amex"=>"http://amexpub.com/custom/"}}}}
    """