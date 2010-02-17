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

  Scenario: editing interests of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    And the following pages
      |identifier         | title | content      |
      |_jcalvin_interests | DNM   | Johnny's interests! |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "edit interests"
    Then I should see "Johnny's interests!" within "textarea"

  Scenario: creating interests of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "edit interests"
    Then I should be editing a page

  Scenario: deleting interests of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    And the following pages
      |identifier         | title | content      |
      |_jcalvin_interests | DNM   | Interests of Johnny! |
    When I follow "Faculty & Staff"
    Then I should see "Interests of Johnny!"
    When I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "delete interests"
    And I follow "Faculty & Staff"
    Then I should not see "Interests of Johnny!"

  Scenario: deleting status of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    And the following pages
      |identifier      | title | content |
      |_jcalvin_status | DNM   | status! |
    When I follow "Faculty & Staff"
    Then I should see "status!"
    When I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "delete status"
    And I follow "Faculty & Staff"
    Then I should not see "status!"

  Scenario: deleting profile of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    And the following pages
      |identifier       | title | content      |
      |_jcalvin_profile | DNM   | He was a reformer! |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    Then I should see "He was a reformer!"
    And I follow "edit..."
    And I follow "delete profile"
    And I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    Then I should not see "He was a reformer!"

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
