Feature: newsitems in the atom feed
  As a visitor to the site
  I want to get an Atom feed
  So that I can get newsitems in my RSS reader

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
