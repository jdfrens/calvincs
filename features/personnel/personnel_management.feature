Feature: managing personnel
  As an editor on the website
  I want to edit the personnel on the website
  So that others can contact them and know more about them

  Scenario Outline: seeing all personnel in list when logged in
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name | role    |
      | mluther  | Martin     | Luther    | <role>  |
    When I go to the list of personnel
    Then I should see "Martin Luther" within "#<role>_listing"
    Examples:
      | role     |
      | faculty  |
      | contributors |
      | adjuncts |
      | emeriti  |
      | staff    |
      | admin    |

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
    And I press "Update User"
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
    And I press "Update User"
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
    And I press "Update User"
    And I follow "Faculty & Staff"
    Then I should see "Johnny Calvin" within "table#adjuncts_listing"

  Scenario: editing a person's password
    Given I am logged in as an editor
    And default homepage content
    And the following users
      | username | first_name | last_name | active |
      | jcalvin  | Johnny     | Calvin    | true   |
    Then user "jcalvin" should have password "password"
    When I follow "Faculty & Staff"
    Then I should see "Johnny Calvin" within "table#faculty_listing"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "change password..."
    And I fill in "Password" with "grant"
    And I fill in "Password confirmation" with "grant"
    And I press "Update"
    Then user "jcalvin" should have password "grant"

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
    And I press "Update User"
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
    And I press "Update User"
    Then I should not see "B.A., University of Geneva, 1612"
    And I should not see "Education"

  Scenario: creating a new user
    Given I am logged in as an editor
    When I go to the administration page
    And I follow "Create user"
    And I fill in the following:
      | First name | Abraham |
      | Last name  | Kuyper  |
      | Username   | akuyper |
      | Password   | secret  |
      | Password confirmation | secret |
    And I select "staff" from "user_role_id"
    When I press "Create User"
    Then I should be on the list of personnel
    And I should see "Abraham Kuyper" within "#staff_listing"
