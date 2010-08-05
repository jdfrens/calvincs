Feature: the news and event atom feed
  As a visitor to the site
  I want to get an Atom feed
  So that I can get news and event-notifications in my RSS reader

  Scenario: a news item in the feed
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at |
      | News!    | na na! | No news is good news. | yesterday    | tomorrow   |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "News!" as only entry title
    And I should not see "na na!"
    And I should see "<p>No news is good news.</p>" as entry content

  Scenario: multiple news items in the feed
    Given the following news items
      | headline | teaser | content               | goes_live_at   | expires_at |
      | News!    | na na! | No news is good news. | three days ago | tomorrow   |
      | News II  | yo!    | Electric Boogaloo     | two days ago   | tomorrow   |
      | Newses   | hey    | Hey, nonnie nonnie    | yesterday      | tomorrow   |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Newses" as first entry title
    And I should see "News II" as second entry title
    And I should see "News!" as last entry title

  Scenario: only current news items in the feed
    Given the following news items
      | headline | teaser | content            | goes_live_at | expires_at |
      | Not me!  | Nooo!  | I am expired       | yesterday    | yesterday  |
      | Or me!   | Way!!  | I am not live yet! | tomorrow     | tomorrow   |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should not see "Not me!"
    And I should not see "Or me!"

  Scenario: an event for today in the feed
    Given the following colloquia
      | title    | subtitle  | start              |
      | Get Real | No Really | 5 minutes from now |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Get Real: No Really" as only entry title

  Scenario: multiple events for today in the feed
    Given the following colloquia
      | title     | subtitle  | start           |
      | Get Real  | No Really | today at 3:30pm |
      | Fantastic | Cool      | today at 4:30pm |
      | Michigan  | State     | today at 9:00am |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Get Real: No Really" as first entry title
    And I should see "Fantastic: Cool" as second entry title
    And I should see "Michigan: State" as last entry title

  Scenario: an upcoming event in the feed
    Given the following colloquia
      | title    | subtitle  | start              |
      | Get Real | No Really | tomorrow at 3:30pm |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Get Real: No Really" as only entry title

  Scenario: multiple upcoming events in the feed
    Given the following colloquia
      | title    | subtitle  | start                       |
      | Tomorrow | Is Now    | tomorrow at 3:30pm          |
      | Get Real | No Really | 4 days from today at 3:30pm |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Tomorrow: Is Now" as first entry title
    And I should see "Get Real: No Really" as last entry title

  Scenario: old and too future events are not in the feed
    Given the following colloquia
      | title     | subtitle | start                       |
      | Yesterday | Is Gone  | yesterday at 3:30pm         |
      | Future    | Is Scary | 9 days from today at 3:30pm |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should not see "Yesterday: Is Gone"
    And I should not see "Future: Is Scary"
