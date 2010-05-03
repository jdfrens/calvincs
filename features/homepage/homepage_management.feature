Feature: the home page
  As an editor of the site
  I want to manage the homepage content
  So that visitors will enjoy this content

  Scenario: ask for _home_page
    Given I am logged in as an editor
    And there are no pages
    When I go to the homepage
    Then I should be on the new page page
    And I should have the following query string:
      | id | _home_page |

  Scenario: see the home page and edit the content
    Given I am logged in as an editor
    And the following pages
      | identifier   | title           | content      |
      | _home_page   | does not matter | some content |
    And the following images
      | url            | caption      | tags_string |
      | /images/foobar | The caption. | homepage    |
    When I go to the homepage
    And I follow "edit _home_page"
    Then I should edit _home_page page
