Feature: the news and event atom feed
  As a visitor to the site
  I want to get an Atom feed
  So that I can get news and event-notifications in my RSS reader

  Scenario: a news item in the feed
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at    |
      | News!    | na na! | No news is good news. | yesterday    | tomorrow      |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "News!" as entry title
    And I should not see "na na!"
    And I should see "No news is good news." as entry content

  Scenario: multiple news items in the feed
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at    |
      | News!    | na na! | No news is good news. | yesterday    | tomorrow      |
      | News II  | yo!    | Electric Boogaloo     | yesterday    | tomorrow      |
      | Newses   | hey    | Hey, nonnie nonnie    | yesterday    | tomorrow      |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "News!" as entry title
    And I should see "News II" as entry title
    And I should see "Newses" as entry title

  Scenario: only current news items in the feed
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at    |
      | Not me!  | Nooo!  | I am expired          | yesterday    | yesterday     |
      | Or me!   | Way!!  | I am not live yet!    | tomorrow     | tomorrow      |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should not see "Not me!"
    And I should not see "Or me!"

  Scenario: a event for today in the feed
    Given the following colloquia
      | title    | subtitle  | when  |
      | Get Real | No Really | today |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Get Real: No Really" as entry title
