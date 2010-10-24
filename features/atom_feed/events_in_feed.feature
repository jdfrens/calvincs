Feature: events in the atom feed
  As a visitor to the site
  I want to get an Atom feed
  So that I can get event-notifications in my RSS reader

  Scenario: an event for today in the feed
    Given the following colloquia
      | title    | subtitle  | start              | description   | presenter | location |
      | Get Real | No Really | 5 minutes from now | Love reality! | Bob       | Room 101 |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Get Real: No Really" as only entry title
		And I should see "Love reality!"
		And I should see "Bob"
		And I should see "Room 101"

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
      | title    | subtitle  | start                   |
      | Get Real | No Really | 1 day from now at 3:30p |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Get Real: No Really" as only entry title

  Scenario: multiple upcoming events in the feed
    Given the following colloquia
      | title    | subtitle  | start                      |
      | Tomorrow | Is Now    | 1 day from now at 3:30p    |
      | Get Real | No Really | 4 days from today at 3:30p |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should see "Tomorrow: Is Now" as first entry title
    And I should see "Get Real: No Really" as last entry title

  Scenario: old and too future events are not in the feed
    Given the following colloquia
      | title     | subtitle | start                      |
      | Yesterday | Is Gone  | yesterday at 3:30p         |
      | Future    | Is Scary | 9 days from today at 3:30p |
    When I go to the atom feed
    Then I should see "Calvin College Computer Science - News and Events" as title
    And I should not see "Yesterday: Is Gone"
    And I should not see "Future: Is Scary"
