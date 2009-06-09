Feature: managing events
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

  Scenario: list only upcoming events
    Given the following colloquia
      | title    | when      |
      | Get Real | yesterday |
      | Get Fake | tomorrow  |
    And the following conferences
      | title       | when      |
      | Foobar 2009 | yesterday |
      | Barfoo 1692 | tomorrow  |
    When I go to the list of events
    Then I should not see "Get Real"
    And I should see "Get Fake"
    And I should not see "Foobar 2009"
    And I should see "Barfoo 1692"

  Scenario: list only upcoming events
    Given the following conferences
      | title       | start            | length |
      | Foobar 2009 | October 28, 2009 | 1      |
      | Barfoo 2007 | August 15, 2007  | 2      |
    When I go to the list of events
    And I follow "Event archive"
    Then I should see "Events"
    And I should not see "Upcoming Events"
    And I should see "Events of 2009"
    And I should see "Events of 2008"
    And I should see "Events of 2007"
