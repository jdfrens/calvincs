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

  Scenario: listing a picture
    Given I am logged in as an editor
    And the following images
      | url          | width | height | caption |
      | /foobar1.jpg |   265 |    200 | wide foobar   |
    When I go to the list of pictures
    Then I should see "/foobar1.jpg"

  Scenario: listing pictures
    Given I am logged in as an editor
    And the following images
      | url          | width | height | caption |
      | /foobar1.jpg |   265 |    200 | wide foobar   |
      | /foobar2.jpg |   200 |    265 | narrow foobar |
      | /foobar3.jpg |   265 |    265 | square foobar |
    When I go to the list of pictures
    Then I should see "/foobar1.jpg"
    And I should see "/foobar2.jpg"
    And I should see "/foobar3.jpg"
