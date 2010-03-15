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

  Scenario: list courses by CS, IS, and interim
    Given the following courses
      | department | number | title         |
      | CS         | 108    | Everything CS |
      | IS         | 204    | Everything IS |
      | W          |  60    | Some Interim Course |
    When I go to the list of courses
    Then I should see "Computer Science" within "#cs"
    And I should see "CS 108" within "#cs"
    And I should see "Information Systems" within "#is"
    And I should see "IS 204" within "#is"
    And I should see "Interim" within "#interim"
    And I should see "W 60" within "#interim"
