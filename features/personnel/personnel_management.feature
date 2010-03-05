Feature: managing personnel
  As an editor on the website
  I want to edit the personnel on the website
  So that others can contact them and know more about them

  Scenario: editing a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I fill in "First name" with "Martin"
    And I fill in "Last name" with "Luther"
    And I press "Save changes"
    Then I should see "Martin Luther"
    And I should not see "Johnny Calvin"

  Scenario: failing to edit a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I fill in "Office phone" with "this is not a valid phone number"
    And I press "Save changes"
    Then I should see "Problem updating person."
    And I should see "Edit User Information"

  Scenario: editing group of person
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    Then I should see "Johnny Calvin" within "table#faculty_listing"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    Then I should see "faculty"
    When I select "adjuncts" from "user_role_id"
    And I press "Save changes"
    And I follow "Faculty & Staff"
    Then I should see "Johnny Calvin" within "table#adjuncts_listing"

  Scenario: editing faculty member's degrees
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin    |
    And the following degrees
      | username | degree_type | institution          | year |
      | jcalvin  | B.A.        | University of Geneva | 1612 |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    Then I should see "B.A., University of Geneva, 1612"
    When I follow "edit..."
    And I fill in "Institution" with "M.I.T."
    And I fill in "Year" with "1492"
    And I press "Save changes"
    Then I should not see "B.A., University of Geneva, 1612"
    And I should see "B.A., M.I.T., 1492"

  Scenario: editing faculty member's degrees
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin    |
    And the following degrees
      | username | degree_type | institution          | year |
      | jcalvin  | B.A.        | University of Geneva | 1612 |
    When I go to edit person "jcalvin"
    And I check "Delete degree"
    And I press "Save changes"
    Then I should not see "B.A., University of Geneva, 1612"
    And I should not see "Education"
