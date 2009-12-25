Feature: creating and editing the courses offered by the department
  As an editor
  I want to create and edit the courses we keep track of
  So that our course catalog can be maintained online, easily

  Scenario: list events
    Given I am logged in as an editor
    And the following courses
      | department | number | title    | credits |
      | CS | 108 | Everything CS | 4 |
      | IS | 204 | Everything IS | 3 |
    When I go to the list of courses
    Then I should see "CS 108: Everything CS"
    Then I should see "IS 204: Everything IS"

  Scenario: create a course
    Given I am logged in as an editor
    When I am on the administration page
    And I follow "Create" within "#course_administration"
