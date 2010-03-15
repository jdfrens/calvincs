Feature: creating and editing the courses offered by the department
  As an editor
  I want to create and edit the courses we keep track of
  So that our courses can be linked to easily

  Scenario: list courses includes a link to edit
    Given I am logged in as an editor
    And the following courses
      | department | number | title         | url                          |
      | CS         | 108    | Everything CS | http://www.example.com/cs108 |
    When I go to the list of courses
    And I follow "edit..."
    Then I am on the edit "cs108" course page

  Scenario: create a course
    Given I am logged in as an editor
    When I am on the administration page
    And I follow "Create" within "#course_administration"
    And I fill in the following:
      | Label         | CS    |
      | Course number | 873   |
      | Title         | Hey, Learn Computing! |
      | URL           | http://www.example.com/course |
    And I press "Create"
    Then I should be on the list of courses page
    And I should see "CS 873: Hey, Learn Computing!"

  Scenario: Edit a course
    Given I am logged in as an editor
    And the following courses
      | department | number | title         |
      | CS         | 108    | Everything CS |
    When I go to the list of courses
    And I follow "edit..."
    And I fill in "Label" with "IS"
    And I fill in "Course number" with "873"
    And I fill in "URL" with "http://www.example.com/is873"
    And I press "Update"
    Then I should be on the list of courses page
    And I should see "IS 873: Everything CS"
    And I should not see "CS 108: Everything CS"
