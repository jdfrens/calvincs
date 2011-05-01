Feature: managing personnel
  As an editor on the website
  I want to edit the pages of person
  So that others can know more about the person

  Scenario Outline: edit and delete links
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    And the following pages
      |identifier      | title | content          |
      |_jcalvin_<page> | DNM   | <page> contents! |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    Then I should see "edit <page>"
    And I should see "delete <page>" button
    And I should not see "create <page>"
    Examples:
      | page      |
      | interests |
      | profile   |
      | status    |
        
  Scenario Outline: creating link
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    Then I should not see "edit <page>"
    And I should not see "delete <page>" button
    And I should see "create <page>"
    Examples:
      | page      |
      | interests |
      | profile   |
      | status    |

  Scenario Outline: creating pages for faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "create <page>"
    Then I should see "_jcalvin_<page>"
    Examples:
      | page      |
      | interests |
      | profile   |
      | status    |

  Scenario Outline: editing pages of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    And the following pages
      |identifier         | title | content      |
      |_jcalvin_<page> | DNM   | <page> contents! |
    When I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "edit <page>"
    Then I should see "<page> contents!" within "textarea"
    Examples:
      | page      |
      | interests |
      | profile   |
      | status    |

  Scenario Outline: deleting pages of a faculty member
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
    And the following pages
      |identifier      | title | content          |
      |_jcalvin_<page> | DNM   | <page> contents! |
    When I follow "Faculty & Staff"
    Then I should see "<list contents>"
    When I follow "Johnny Calvin"
    Then I should see "<person contents>"
    And I follow "edit..."
    And I press "delete <page>"
    And I follow "Faculty & Staff"
    Then I should not see "<page> contents!"
    When I follow "Johnny Calvin"
    Then I should not see "<page> contents!"
  Examples:
    | page      | list contents       | person contents |
    | interests | interests contents! | interests contents! |
    | profile   |                     | profile contents!   |
    | status    | status contents!    |                     |

  Scenario: jumping to the images list
    Given I am logged in as an editor
    And the following users
      | username | first_name | last_name |
      | jcalvin  | Johnny     | Calvin |
		When I am on the home page
    And I follow "Faculty & Staff"
    And I follow "Johnny Calvin"
    And I follow "edit..."
    And I follow "tag images"
    Then I should be on the list of pictures
