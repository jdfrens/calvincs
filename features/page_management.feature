Feature: managing pages
  As an editor
  I want to manage pages
  So that I and other can see the department's content

  Scenario: listing pages when logged in
    Given I am logged in as an editor
    And the following pages
      | identifier | title  | content      |
      | foobar     | Foo    | bar bar bar. |
      | xmas       | XMass! | Merry!       |
    When I go to the page listing
    Then I should see "XMass!"
    And I should see "Foo"

  Scenario: listing pages when not logged in
    Given I am not logged in
    When I go to the page listing
    Then I should be on the login page

  Scenario: seeing a page as a visitor
    Given I am not logged in
    And the following pages
      |identifier| title | content      |
      |foobar| Foo   | bar bar bar. |
    And the following images
      | url                   | caption   | tags_string |
      | /images/somewhere.gif | Somewhere |foobar|
    When I go to the "foobar" page
    Then I should see "bar bar bar."
    And I should see an image "/images/somewhere.gif"
    And I should see "Somewhere"

  Scenario: seeing a page as an editor
    Given I am logged in as an editor
    And the following pages
      | identifier | title | content      |
      | foobar     | Foo   | bar bar bar. |
    And the following images
      | url                   | caption   | tags_string | width | height |
      | /images/somewhere.gif | Somewhere | foobar      |   265 |    200 |
    When I go to the "foobar" page
    Then I should see "bar bar bar."
    And I should see an image "/images/somewhere.gif"
    And I should see "Somewhere"