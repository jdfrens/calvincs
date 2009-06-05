Feature: the home page
  As a visitor to the site
  I want to see the home page
  So that I can access other pages and read news

  Scenario: see the home page
    Given the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "some content"
    And I should see "sploosh!"

  Scenario: see the home page with some news
    Given the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
    And the following news items
      | headline | teaser | content               |
      | News!    | na na! | No news is good news. |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "some content"
    And I should see "na na!"
    When I follow "more..."
    Then I should see "News!"
    And I should see "No news is good news."
