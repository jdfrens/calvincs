Feature: managing news items
  As an editor of the website
  I want to add, remove, and modify news items
  So that I can keep the news fresh and interesting and accurate

  Scenario: Entering a new news item
    Given I am logged in as an editor
    When I go to the administration page
    And I follow "Create news item"
    Then I should be on the new news item page
    When I fill in "news_item[headline]" with "The Freakin' Headline"
    And I fill in "news_item[teaser]" with "The Frakin' Teaser"
    And I fill in "news_item[content]" with "The Frellin' Content"
    And I press "Save changes"
    Then I should be on the current news page
