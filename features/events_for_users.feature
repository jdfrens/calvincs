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
