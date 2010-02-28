Feature: managing personnel
  As an editor on the website
  I want to edit the pages of person
  So that others can know more about the person

  Scenario: creating link for missing faculty interests
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    Then I should not see "edit interests"
    And I should not see "delete interests"
    And I should see "create interests"

  Scenario: editing and deleting links for existing faculty interests
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
    Then I should see "edit interests"
    And I should see "delete interests"
    And I should not see "create interests"

  Scenario: creating interests of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "create interests"
    Then I should see "_jcalvin_interests"

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
    And I follow "create interests"
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

  Scenario: jumping to the images list
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "tag images"
    Then I should be on the list of pictures
