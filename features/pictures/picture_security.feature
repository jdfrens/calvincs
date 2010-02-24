Feature: managing pictures
  As a administrator
  I want to protect the pictures
  So that only people I allow can change their properties

  Scenario: require a log in when listing images
    Given I am not logged in
    When I go to the list of pictures
    Then I should be on the login page

  Scenario: require a log in when creating a new pictures
    Given I am not logged in
    When I go to the new picture page
    Then I should be on the login page

  Scenario: require a log in when editing a picture
    Given I am not logged in
    And the following images
      | url        |
      | foobar.jpg |
    When I go to the edit the "foobar.jpg" picture
    Then I should be on the login page
