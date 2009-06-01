Feature: logging in and out
  As an editor on the website
  I want to log in and log out
  So that I can modify the content on the website

  Scenario: logging in
    When I go to the login page
    And I fill in "user[username]" with "jeremy"
    And I fill in "user[password]" with "jeremypassword"
    And I press "Login"
    Then I should be on the administration page
