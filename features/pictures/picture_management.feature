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
      | url          | width | height | caption       | tags_string |
      | /foobar1.jpg |   265 |    200 | wide foobar   | a b c       |
      | /foobar2.jpg |   200 |    265 | narrow foobar | 1 2 3       |
      | /foobar3.jpg |   265 |    265 | square foobar | x y z       |
    When I go to the list of pictures
    Then I should see "/foobar1.jpg"
    And I should see "/foobar2.jpg"
    And I should see "/foobar3.jpg"
    And I should see "a b c"

  Scenario: editing a picture
    Given I am logged in as an editor
    And the following images
      | url          | width | height | caption       | tags_string |
      | /foobar1.jpg |   265 |    200 | the caption   | a b c       |
    When I go to the list of pictures
    And I follow "edit..."
    And I fill in "URL" with "http://example.com/hello.jpg"
    And I fill in "Caption" with "hello!"
    And I fill in "Tags" with "one two three"
    And I expect "http://example.com/hello.jpg" to have dimension "200x265"
    And I press "Update"
    Then I should see "List of Images"
    And I should see "/hello.jpg" and not "/foobar1.jpg"
    And I should see "hello!" and not "the caption"
    And I should see "one two three" and not "a b c"
    And I should see "200x265" and not "265x200"

  Scenario: refreshing dimensions
    Given I am logged in as an editor
    And the following images
      | url                            | width | height | caption   | tags_string |
      | http://example.com/foobar1.jpg |     8 |     14 | caption 1 | a b c       |
      | http://example.com/foobar2.jpg |     8 |     14 | caption 2 | 1 2 3       |
      | http://example.com/foobar3.jpg |     8 |     14 | caption 3 | x y z       |
    And I expect "http://example.com/foobar1.jpg" to have dimension "111x111"
    And I expect "http://example.com/foobar2.jpg" to have dimension "666x666"
    And I expect "http://example.com/foobar3.jpg" to have dimension "333x333"
    When I go to the administration page
    And I follow "Refresh dimensions"
    Then I should see "http://example.com/foobar1.jpg"
    And I should see "111x111"
    And I should see "http://example.com/foobar2.jpg"
    And I should see "666x666"
    And I should see "http://example.com/foobar3.jpg"
    And I should see "333x333"
    And I should not see "8x14"
