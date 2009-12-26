Feature: checking out the courses offered by the department
  As a guest to the website
  I want to see the courses offered by the department
  So that I can pick out the courses that interest me the most

  Scenario: list events
    Given the following courses
      | department | number | title         | credits |
      | CS         | 108    | Everything CS | 4 |
      | IS         | 204    | Everything IS | 3 |
    When I go to the list of courses
    Then I should see "CS 108: Everything CS"
    Then I should see "IS 204: Everything IS"

  Scenario: Check out a course
    Given the following courses
      | department | number | title         | credits | description |
      | CS         | 108    | Everything CS | 4       | This is a wonderful course. |
    When I go to the list of courses
    And I follow "CS 108: Everything CS"
    Then I should see "CS 108: Everything CS"
    And I should see "4 credits"
    And I should see "This is a wonderful course."
