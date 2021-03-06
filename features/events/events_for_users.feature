Feature: checking out the events
  As a guest to the website
  I want to see events and lists of events
  So that I can plan my life around the department

  Scenario: list events
    Given the following colloquia
      | title    | description   |
      | Get Real | Getting real. |
      | Get Fake | Staying fake. |
    And the following conferences
      | title       | description       |
      | Foobar 2009 | Fooing the bars.  |
      | Barfoo 1692 | Barring the foos. |
    When I go to the list of events
    Then I should see "Get Real"
    And I should see "Get Fake"
    And I should see "Foobar 2009"
    And I should see "Barfoo 1692"

  Scenario: list only upcoming events
    Given the following colloquia
      | title    | start                   |
      | Get Real | yesterday at 3:30p      |
      | Get Fake | 1 day from now at 2:30p |
    And the following conferences
      | title       | start     | stop      | description |
      | Foobar 2009 | yesterday | yesterday | fooey       |
      | Barfoo 1692 | tomorrow  | tomorrow  | barry       |
    When I go to the list of events
    Then I should not see "Get Real"
    And I should see "Get Fake"
    And I should not see "Foobar 2009"
    And I should see "Barfoo 1692"

  Scenario: list archive of events
    Given the following conferences
      | title       | start                    | length | description   |
      | Foobar 2009 | 28 October 2009 at 3:30p | 1      | Fooing bars.  |
      | Barfoo 2007 | 15 August 2007 at 4:50p  | 2      | Barring foos. |
    When I go to the list of events
    And I follow "Archive"
    Then I should see "Events" within "h1"
    And I should not see "Upcoming Events"
    And I should see "Events of 2009"
    And I should see "Events of 2008"
    And I should see "Events of 2007"

  Scenario: list events for a specific year
    Given the following conferences
      | title       | start           | length | description   |
      | Foobar 2009 | 28 October 2009 | 1      | Fooing bars.  |
      | Barfoo 2007 | 15 August 2007  | 2      | Barring foos. |
    When I go to the list of events
    And I follow "Archive"
    And I follow "Events of 2007"
    Then I should see "Events of 2007"
    And I should not see "Events of 2009"
    And I should see "Barfoo 2007"
    And I should not see "Foobar 2009"

  Scenario: see one event
    Given the following colloquia
      | title    | start                   | description                        | presenter | location |
      | Get Real | 1 day from now at 2:00p | It is better to be real than fake. | Bob       | Room 101 |
    When I go to the list of events
    And I follow "more..."
    Then I should see "Get Real"
    And I should see "It is better to be real than fake."
    And I should see "Bob"
    And I should see "Room 101"
    And I should see tomorrow as event date
    And I should not see "edit..."
