Feature: managing events
  As an editor
  I want to manage events
  So that the department can plan and announce events for students, alumni, and community

  Scenario: redirect to login when trying to add event
    Given I am not logged in
    When I go to the new event page
    Then I should be on the login page

  Scenario: add a colloquium
    Given I am logged in as an editor
    When I am on the administration page
    And I follow "Create new colloquium"
    And I fill in the following:
      | Title       | Amazing Ruby Code     |
      | Subtitle    | Check It Out!         |
      | Presenter   | Charles M. Ruby       |
      | Location    | Room of Presentations |
      | Length      | 1.5                   |
      | Description | Ruby code is amazing. |
    And I select "tomorrow at 4:00p" as the date and time
    And I press "Create"
    Then I should see "Amazing Ruby Code: Check It Out!"
    And I should see "Charles M. Ruby"
    And I should see "Room of Presentations"
    And I should see "4:00 PM"

  Scenario: add a programming contest (as a colloquium)
    Given I am logged in as an editor
    When I am on the administration page
    And I follow "Create new colloquium"
    And I fill in the following:
      | Title       | The Programming Contest         |
      | Descriptor  | programming contest             |
      | Location    | Room of Contests                |
      | Length      | 1.5                             |
      | Description | Write code for cash and prizes. |
    And I select "tomorrow at 10:00a" as the date and time
    And I press "Create"
    Given default homepage content
    When I go to the home page
    Then I should see "Programming contest coming up! The Programming Contest"

  Scenario: add a conference
    Given I am logged in as an editor
    When I am on the administration page
    And I follow "Create new conference"
    And I fill in "Title" with "Meeting of the Railers"
	 	And I select "tomorrow" as the date
    And I fill in "Length" with "2"
    And I fill in "Description" with "Railing against all other frameworks."
    And I press "Create"
    Then I should be on the list of events
    And I should see "Meeting of the Railers"
    And I should see tomorrow and two days later

  Scenario: edit a colloquium
    Given I am logged in as an editor
    And the following colloquia
      | title    | start             | description   |
      | Get Real | 1 day from now at 3:30p | Getting real. |
    When I go to the list of events
    Then I should see "Get Real"
    When I follow "more..."
    And I follow "edit..."
    And I fill in "colloquium[title]" with "Fake!"
    And I press "Update"
    Then I should be on the list of events
    And I should see "Fake!"
    And I should not see "Get Real"

  Scenario: edit a conference
    Given I am logged in as an editor
    And the following conferences
      | title  | description |
      | GLCamp | Camping in the Great Lakes |
    When I go to the list of events
    Then I should see "GLCamp"
    When I follow "more..."
    And I follow "edit..."
    And I fill in "conference[title]" with "BarSEC"
    And I press "Update"
    Then I should be on the list of events
    And I should see "BarSEC"
    And I should not see "GLCamp"
  Scenario:
