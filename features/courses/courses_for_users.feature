Feature: checking out the courses offered by the department
  As a guest to the website
  I want to see the courses offered by the department
  So that I can pick out the courses that interest me the most and see their online materials

  Scenario: list courses
    Given the following courses
      | department | number | title         | url                          |
      | CS         | 108    | Everything CS | http://www.example.com/cs108 |
      | IS         | 204    | Everything IS |                              |
    When I go to the list of courses
    Then I should see "CS 108: Everything CS"
    And I should see "IS 204: Everything IS"
    And I should see a link to "http://www.example.com/cs108"
