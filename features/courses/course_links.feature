Feature: using short identifier to identify and link to a course
  As an author on the website
  I want to use a simple identifier (like "cs108")
  So that it expands to "CS 108" and a link to the CS 108 course.

  Scenario: link in course descriptiions
    Given the following courses
      | department | number | title | credits | description                                |
      | CS         | 108    | CS 1  | 4       | A cool course.                             |
      | IS         | 271    | IS 3  | 3       | Another cool course.  Prerequisite: cs108. |
    When I go to the list of courses
    And I follow "IS 271: IS 3"
    Then I should not see "cs108"
    When I follow "CS 108"
    Then I should be on the "cs108" course page
