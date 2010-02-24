Feature: managing pictures
  As a administrator
  I want to manage pictures
  So that I can add, remove, edit, and tag pictures

  Scenario: create a new picture
    Given I am logged in as an editor
    When I am on the administration page
    And I follow "Add image" within "#picture_administration"
    And I fill in "URL" with "/images/joe/foobar.jpg"
    And I fill in "Caption" with "This is a picture of a foobar."
    And I fill in "Tags" with "abc joe foobar"
    And I press "Add image"
