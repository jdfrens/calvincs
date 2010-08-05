Feature: checking out news items
  As a guest on the website
  I want to see the current and old news items
  So that I can know the latest news

  Scenario: seeing a list of news years
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at   |
      | News!    | na na! | No news is good news. | 28 May 2007  | 28 June 2007 |
    When I go to the archive of news items
    Then I should see "News of 2007"

  Scenario: seeing a list of multiple news years
    Given the following news items
      | headline | teaser  | content               | goes_live_at | expires_at   |
      | News!    | na na!  | No news is good news. | 28 May 2007  | 27 June 2007 |
      | Grapes   | purple! | Taste great!          | 28 May 2008  | 27 June 2008 |
      | Apples   | green!  | Fiber!                | 28 May 2009  | 27 June 2009 |
    When I go to the archive of news items
    Then I should not see "News of 2006"
    And I should see "News of 2007"
    And I should see "News of 2008"
    And I should see "News of 2009"
    And I should not see "News of 2010"

  Scenario: finding a particular news item
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at   |
      | News!    | na na! | No news is good news. | 28 May 2007  | 27 June 2007 |
    When I go to the archive of news items
    Then I should see "News of 2007"
    When I follow "News of 2007"
    Then I should see "News!"
    And I should see "No news is good news."

  Scenario: navigating between different views
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at   |
      | News!    | na na! | No news is good news. | 28 May 2007  | 27 June 2007 |
    When I go to the current news
    Then I should not see "News!"
    When I follow "News Archive..."
    Then I should see "News of 2007"
