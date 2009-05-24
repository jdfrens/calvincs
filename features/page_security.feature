Feature: managing pages
  As a administrator
  I want to protect the pages
  So that only people I allow can change their content

  Scenario: require a log in when listing pages
    Given I am not logged in
    When I go to the page listing
    Then I should be on the login page

  Scenario: require a log in when writing a new page
    Given I am not logged in
    When I go to the new page page
    Then I should be on the login page

  Scenario: require a log in when editing a new page
    Given I am not logged in
    When I go to the page to edit the page "foobar"
    Then I should be on the login page
