Feature: checking out the courses offered by the department
  As a guest to the website
  I want to see the courses offered by the department
  So that I can pick out the courses that interest me the most

  Scenario: list courses
    Given the following courses
      | department | number | title         |
      | CS         | 108    | Everything CS |
      | IS         | 204    | Everything IS |
    When I go to the list of courses
    Then I should see "CS 108: Everything CS"
    Then I should see "IS 204: Everything IS"
