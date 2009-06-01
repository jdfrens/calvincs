Feature: checking out news items
  As a guest on the website
  I want to see the current and old news items
  So that I can know the latest news

  Scenario: seeing a list of news years
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at    |
      | News!    | na na! | No news is good news. | May 28, 2007 | June 28, 2007 |
    When I go to the list of news items
    Then I should see "News of 2007"

  Scenario: seeing a list of multiple news years
    Given the following news items
      | headline | teaser | content                | goes_live_at | expires_at    |
      | News!    | na na!  | No news is good news. | May 28, 2007 | June 28, 2007 |
      | Grapes   | purple! | Taste great!          | May 28, 2008 | June 28, 2008 |
      | Apples   | green!  | Fiber!                | May 28, 2009 | June 28, 2009 |
    When I go to the list of news items
    Then I should not see "News of 2006"
    And I should see "News of 2007"
    And I should see "News of 2008"
    And I should see "News of 2009"
    And I should not see "News of 2010"

  Scenario: finding a particular news item
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at    |
      | News!    | na na! | No news is good news. | May 28, 2007 | June 28, 2007 |
    When I go to the list of news items
    Then I should see "News of 2007"
    When I click on "News of 2007"
    Then I should see "News!"
    And I should see "No news is good news."
