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