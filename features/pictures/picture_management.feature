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
    And I press "Create"
    Then I should see "/images/joe/foobar.jpg"
    And I should see "This is a picture of a foobar."
    And I should see "abc joe foobar"
    And I should see "unusable"

  Scenario: listing a picture
    Given I am logged in as an editor
    And the following images
      | url          | width | height | caption |
      | /foobar1.jpg |   265 |    200 | the foobar caption |
    When I go to the list of pictures
    Then I should see "/foobar1.jpg"
    And I should see "265x200"
    And I should see "wide"
    And I should see "the foobar caption"

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

  Scenario: editing a picture
    Given I am logged in as an editor
    And the following images
      | url          | width | height | caption |
      | /foobar1.jpg |   265 |    200 | wide foobar   |
    When I go to the list of pictures
    And I follow "edit..."
    And I fill in "URL" with "/hello.jpg"
    And I fill in "Caption" with "hello!"
    And I press "Update"
    Then I should see "List of Images"
    And I should see "/hello.jpg"
    And I should not see "/foobar1.jpg"
    And I should see "hello!"
    And I should not see "wide foobar"

  Scenario: editing a picture with a full URL
    Given I am logged in as an editor
    And the following images
      | url          | width | height | caption |
      | /foobar1.jpg |   265 |    200 | wide foobar   |
    When I go to the list of pictures
    And I follow "edit..."
    And I fill in "URL" with "http://www.example.com/hello.jpg"
    And I press "Update"
    Then I should see "List of Images"
    And I should see "http://www.example.com/hello.jpg"
