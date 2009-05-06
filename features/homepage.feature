Feature: the home page
  As a visitor to the site
  I want to see the home page
  So that I can access other pages and read news

  Scenario: ask for _home_page
    Given I am logged in as an editor
    When I go to the homepage
    Then I should edit _home_page page
