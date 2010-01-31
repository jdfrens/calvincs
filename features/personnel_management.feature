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
