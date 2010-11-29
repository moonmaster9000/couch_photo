Feature: Accessing Image Variations
  As a developer
  I want to easily access all image variations on my Image document
  So that I can use them

Scenario: Iterating through all variations
  Given an instance of a model with several variations
  When I call the variations instance method
  Then I should get an array of variations
  When I call the variation.variation_name method
  Then I should get that specified variation
