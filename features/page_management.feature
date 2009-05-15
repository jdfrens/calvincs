Feature: managing pages
  As an editor
  I want to manage pages
  So that I and other can see the department's content

  Scenario: listing pages when logged in
    Given I am logged in as an editor
    When I go to the page listing
    Then I should see a listing of pages

  Scenario: listing pages when not logged in
    Given I am not logged in
    When I go to the page listing
    Then I should see the home page

  Scenario: seeing a page
    Given I am not logged in
    And the following pages
      | identifier | title | content      |
      | foobar     | Foo   | bar bar bar. |
    And the following images
      | url           | caption   | tags_string |
      | somewhere.gif | Somewhere | foobar      |
    When I go to the "foobar" page
    Then I should see "bar bar bar."
    And I should see an image "somewhere.gif"
    And I should see "Somewhere"

  Scenario: seeing a page
    Given I am logged in as an editor
    And the following pages
      | identifier | title | content      |
      | foobar     | Foo   | bar bar bar. |
    And the following images
      | url           | caption   | tags_string |
      | somewhere.gif | Somewhere | foobar      |
    When I go to the "foobar" page
    Then I should see "bar bar bar."
    And I should see an image "somewhere.gif"
    And I should see "Somewhere"
