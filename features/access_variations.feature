Feature: Accessing Image Variations
  As a developer
  I want to easily access all image variations on my Image document
  So that I can use them

Scenario: Iterating through all variations
  Given an instance of a model with several variations
  When I call the variations instance method
  Then the `each` method should allow me to iterate over the variation names and variation value pairs
  When I call the variation.variation_name method
  Then I should get that specified variation
  When I call the variation(variation_name) method
  Then I should get that specified variation
  When I create a custom variation named "my_custom_variation.jpg"
  And I call variation("my_custom_variation.jpg")
  Then I should get back "my_custom_variation.jpg"
  When I load the model from the database
  And I call variation("my_custom_variation.jpg")
  Then I should get back "my_custom_variation.jpg"
  