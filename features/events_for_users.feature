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
