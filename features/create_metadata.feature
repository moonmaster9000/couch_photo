Feature: Creating custom metadata
  As a developer
  I want to add custom metadata to the image
  So that the metadata can always be found with the image

Scenario: Creating custom metadata
  Given an image named "metadata.jpg" with the following xmp metadata:
    """
      <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 4.2-c020 1.124078, Tue Sep 11 2007 23:21:40        "> <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"> <rdf:Description rdf:about="" xmlns:exif="http://ns.adobe.com/exif/1.0/" xmlns:tiff="http://ns.adobe.com/tiff/1.0/" xmlns:crs="http://ns.adobe.com/camera-raw-settings/1.0/" xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/" xmlns:amex="http://amexpub.com/custom/" xmlns:xap="http://ns.adobe.com/xap/1.0/" exif:ExifVersion="0221" exif:PixelXDimension="660" exif:PixelYDimension="340" exif:ColorSpace="65535" tiff:Orientation="1" tiff:ImageWidth="660" tiff:ImageLength="340" tiff:PhotometricInterpretation="2" tiff:SamplesPerPixel="3" tiff:XResolution="100/1" tiff:YResolution="100/1" tiff:ResolutionUnit="1" crs:AlreadyApplied="True" photoshop:ColorMode="3" photoshop:ICCProfile="" amex:photographer="Courtesy of Singita Hotels" amex:magazine="Travel + Leisure" amex:rights="PR-1" amex:city="Serengeti National Park, Tanzania" amex:country="Tanzania" amex:keywords="safari, camp, pool, plain, exterior, faru faru lodge, singita grumeti reserves" amex:slideCaption="Faru Faru Lodge, one of the Singita Grumeti Reserve hotels in Serengeti National Park, Tanzania." xap:MetadataDate="2011-07-06T20:17:37-04:00"> <tiff:BitsPerSample> <rdf:Seq> <rdf:li>8</rdf:li> <rdf:li>8</rdf:li> <rdf:li>8</rdf:li> </rdf:Seq> </tiff:BitsPerSample> </rdf:Description> </rdf:RDF> </x:xmpmeta>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
      
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
      @image.metadata.should == {"xmpmeta"=>{"xmlns:x"=>"adobe:ns:meta/", "x:xmptk"=>"Adobe XMP Core 4.2-c020 1.124078, Tue Sep 11 2007 23:21:40        ", "RDF"=>{"xmlns:rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#", "Description"=>{"exif:PixelYDimension"=>"340", "photoshop:ColorMode"=>"3", "tiff:Orientation"=>"1", "xmlns:xap"=>"http://ns.adobe.com/xap/1.0/", "rdf:about"=>"", "tiff:XResolution"=>"100/1", "xmlns:crs"=>"http://ns.adobe.com/camera-raw-settings/1.0/", "xmlns:photoshop"=>"http://ns.adobe.com/photoshop/1.0/", "tiff:ResolutionUnit"=>"1", "exif:PixelXDimension"=>"660", "amex:photographer"=>"Courtesy of Singita Hotels", "tiff:SamplesPerPixel"=>"3", "tiff:YResolution"=>"100/1", "amex:magazine"=>"Travel + Leisure", "BitsPerSample"=>{"Seq"=>{"li"=>["8", "8", "8"]}}, "crs:AlreadyApplied"=>"True", "amex:country"=>"Tanzania", "tiff:ImageWidth"=>"660", "tiff:PhotometricInterpretation"=>"2", "exif:ColorSpace"=>"65535", "amex:slideCaption"=>"Faru Faru Lodge, one of the Singita Grumeti Reserve hotels in Serengeti National Park, Tanzania.", "amex:keywords"=>"safari, camp, pool, plain, exterior, faru faru lodge, singita grumeti reserves", "xmlns:exif"=>"http://ns.adobe.com/exif/1.0/", "xmlns:amex"=>"http://amexpub.com/custom/", "xap:MetadataDate"=>"2011-07-06T20:17:37-04:00", "photoshop:ICCProfile"=>"", "amex:rights"=>"PR-1", "exif:ExifVersion"=>"0221", "tiff:ImageLength"=>"340", "xmlns:tiff"=>"http://ns.adobe.com/tiff/1.0/", "amex:city"=>"Serengeti National Park, Tanzania"}}}}
    """