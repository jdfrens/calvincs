Feature: using short identifier to identify and link to a course
  As an author on the website
  I want to use a simple identifier (like "cs108")
  So that it expands to "CS 108" and a link to the CS 108 course.

  Scenario: link in a page
    Given the following courses
      | department | number | title | url |
      | CS         | 108    | CS 1  | http://www.example.com/cs1 |
      | IS         | 271    | IS 3  |     |
    And the following pages
      | identifier | title | content |
      | hey        | Hey!  | Check out cs108 and is271 for some great courses. |
    When I go to the "hey" page
    Then I should see "CS 108"
    And I should see "IS 271"
    And I should not see "cs108"
    And I should not see "is271"
    And I should see a link to "http://www.example.com/cs1"
    And I should not see "IS 271" within "a"
