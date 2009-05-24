Feature: managing pages
  As a guest on the website
  I want to see the content from the CMS pages
  So that I can learn more about the department and its people

  Scenario: seeing a page as a guest
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
