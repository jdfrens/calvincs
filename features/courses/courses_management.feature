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
    And I fill in the following:
      | Label         | CS    |
      | Course number | 873   |
      | Title         | Hey, Learn Computing! |
      | Credits       | 3     |
      | Description   | catalog description of CS 873 |
    And I press "Create"
    Then I should be on the list of courses page
    And I should see "CS 873: Hey, Learn Computing!"

  Scenario: Edit a course
    Given I am logged in as an editor
    And the following courses
      | department | number | title         | credits | description |
      | CS         | 108    | Everything CS | 4       | This is a wonderful course. |
    When I go to the list of courses
    And I follow "CS 108: Everything CS"
    And I follow "edit"
    And I fill in "Label" with "IS"
    And I fill in "Course number" with "873"
    And I press "Update"
    Then I should be on the list of courses page
    And I should see "IS 873: Everything CS"
    And I should not see "CS 108: Everything CS"
