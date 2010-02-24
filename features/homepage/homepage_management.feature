Feature: the home page
  As a visitor to the site
  I want to see the home page
  So that I can access other pages and read news

  Scenario: ask for _home_page
    Given I am logged in as an editor
    And there are no pages
    When I go to the homepage
    Then I should create _home_page page

  Scenario: ask for _home_splash
    Given I am logged in as an editor
    And the following pages
        | identifier | title           | content      |
        | _home_page | does not matter | some content |
    When I go to the homepage
    Then I should create _home_splash page

  Scenario: see the home page and edit the splash
    Given I am logged in as an editor
    And the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
    When I go to the homepage
    And I follow "edit _home_splash"
    Then I should edit _home_splash page

  Scenario: see the home page and edit the content
    Given I am logged in as an editor
    And the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
    When I go to the homepage
    And I follow "edit _home_page"
    Then I should edit _home_page page
