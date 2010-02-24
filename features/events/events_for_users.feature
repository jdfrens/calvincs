Feature: checking out the events
  As a guest to the website
  I want to see events and lists of events
  So that I can plan my life around the department

  Scenario: list events
    Given the following colloquia
      | title    |
      | Get Real |
      | Get Fake |
    And the following conferences
      | title       |
      | Foobar 2009 |
      | Barfoo 1692 |
    When I go to the list of events
    Then I should see "Get Real"
    And I should see "Get Fake"
    And I should see "Foobar 2009"
    And I should see "Barfoo 1692"

  @wip
  Scenario: list only upcoming events
    Given the following colloquia
      | title    | start               |
      | Get Real | yesterday at 3:30pm |
      | Get Fake | tomorrow at 2:30pm  |
    And the following conferences
      | title       | start     | stop      |
      | Foobar 2009 | yesterday | yesterday |
      | Barfoo 1692 | tomorrow  | tomorrow  |
    When I go to the list of events
    Then I should not see "Get Real"
    And I should see "Get Fake"
    And I should not see "Foobar 2009"
    And I should see "Barfoo 1692"

  Scenario: list archive of events
    Given the following conferences
      | title       | start                     | length |
      | Foobar 2009 | 28 October 2009 at 3:30pm | 1      |
      | Barfoo 2007 | 15 August 2007 at 4:50pm  | 2      |
    When I go to the list of events
    And I follow "archive"
    Then I should see "Events"
    And I should not see "Upcoming Events"
    And I should see "Events of 2009"
    And I should see "Events of 2008"
    And I should see "Events of 2007"

  Scenario: list events for a specific year
    Given the following conferences
      | title       | start           | length |
      | Foobar 2009 | 28 October 2009 | 1      |
      | Barfoo 2007 | 15 August 2007  | 2      |
    When I go to the list of events
    And I follow "archive"
    And I follow "Events of 2007"
    Then I should see "Events of 2007"
    And I should not see "Events of 2009"
    And I should see "Barfoo 2007"
    And I should not see "Foobar 2009"

  Scenario: see one event
    Given the following colloquia
      | title    | start              | description                        | presenter | location |
      | Get Real | tomorrow at 2:00pm | It is better to be real than fake. | Bob       | Room 101 |
    When I go to the list of events
    And I follow "more..."
    Then I should see "Get Real"
    And I should see "It is better to be real than fake."
    And I should see "Bob"
    And I should see "Room 101"
    And I should see tomorrow as event date
    And I should not see "edit..."
