Feature: viewing and listing personnel
  As a visitor to the website
  I want to see the personnel who work in the department
  So that I can contact them and know more about them

  Scenario: seeing list of personnel
    Given the following users
      | username | first_name | last_name |
      | jcalvin  | John       | Calvin |
      | mluther  | Martin     | Luther |
    When I go to the list of personnel
    Then I should see "John Calvin"
    And I should see "Martin Luther"

  Scenario: checking out a faculty member
    Given the following users
      | username | first_name | last_name | office_phone | office_location |
      | jcalvin  | John       | Calvin | 616-555-5555 | NH 123 |
      | mluther  | Martin     | Luther | 616-867-5309 | NH 665 |
    When I go to the list of personnel
    And I follow "Martin Luther"
    Then I should see "Martin Luther" within "h1"
    And I should see "616-867-5309"
    And I should see "NH 665"

  Scenario: degrees of a faculty member
    Given the following users
      | username | first_name | last_name | office_phone | office_location |
      | jcalvin  | Johnny     | Calvin | 616-555-5555 | NH 123 |
    And the following degrees
      | username | degree_type | institution          | year |
      | jcalvin  | B.A.        | University of Geneva | 1612 |
      | jcalvin  | M.S.        | Paris University     | 1614 |
    When I go to the list of personnel
    And I follow "Johnny Calvin"
    Then I should see "B.A., University of Geneva, 1612"
    And I should see "M.S., Paris University, 1614"
