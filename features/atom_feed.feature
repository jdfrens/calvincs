Feature: the news and event atom feed
  As a visitor to the site
  I want to get an Atom feed
  So that I can get news and event-notifications in my RSS reader

  Scenario: news items in the feed
    Given the following news items
      | headline | teaser | content               | goes_live_at | expires_at    |
      | News!    | na na! | No news is good news. | yesterday    | tomorrow      |
    When I go to the atom feed
    Then I should see "No news is good news."
    