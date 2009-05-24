Feature: the home page
  As a visitor to the site
  I want to see the home page
  So that I can access other pages and read news

  Scenario: see the home the page
    Given the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "some content"
    And I should see "sploosh!"
