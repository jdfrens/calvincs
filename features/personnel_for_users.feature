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
