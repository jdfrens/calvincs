Feature: managing events
  As an editor
  I want to manage events
  So that I can have events

  Scenario: list events
    Given the following colloquia
      | title    |
      | Get Real |
      | Get Fake |
    And the following conferences
      | title       |
      | Foobar 2009 |
      | Barfoo 1692 |
    When I view the list of events
    Then I should see "Get Real"
    And I should see "Get Fake"
    And I should see "Foobar 2009"
    And I should see "Barfoo 1692"

  Scenario: redirect to login when trying to add event
    Given I am not logged in
    When I go to the new event page
    Then I should be on the login page

  Scenario: add a colloquium
    Given I am logged in as an editor
    When I am on the new event page
    And I select "Colloquium" from "event[type]"
    And I fill in "event[title]" with "Amazing Ruby Code"
    And I select tomorrow at "16:00" as the date and time
    And I fill in "event[length]" with "1.5"
    And I press "Create"
    Then I should be on the list of events
    And I should see "Amazing Ruby Code"
    And I should see "4:00 PM"

  Scenario: add a conference
    Given I am logged in as an editor
    When I am on the new event page
    And I select "Conference" from "event[type]"
    And I fill in "event[title]" with "Meeting of the Railers"
    And I select tomorrow as the date
    And I fill in "event[length]" with "2"
    And I press "Create"
    Then I should be on the list of events
    And I should see "Meeting of the Railers"
    And I should see tomorrow and two days later