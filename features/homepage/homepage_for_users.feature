Feature: the home page
  As a visitor to the site
  I want to see the home page
  So that I can access other pages and read news

  Scenario: see the home page content
    Given the following pages
      | identifier   | title           | content      |
      | _home_page   | does not matter | some content |
    And the following images
      | url            | caption      | tags_string |
      | /images/foobar | The caption. | homepage    |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "some content"

  Scenario: see the home page splash
    Given the following pages
      | identifier   | title           | content      |
      | _home_page   | does not matter | some content |
    And the following images
      | url            | caption      | tags_string |
      | /images/foobar | The caption. | homepage    |
    When I go to the homepage
    Then I should be on the homepage
    And I should see an image "/images/foobar"
    And I should see "The caption."

  Scenario: see the home page with a colloquium today
    Given default homepage content
    And the following colloquia
      | title    | start              |
      | Get Real | tomorrow at 3:30pm |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "Colloquium coming up!"
    And I should not see "Colloquium today!"
    And I should see "Get Real"
    When I follow "more..."
    Then I should see "Get Real"

  Scenario: see the home page with a programming contest today
    Given default homepage content
    And the following colloquia
      | title    | start              | descriptor          |
      | C4       | tomorrow at 3:30pm | programming contest |
    When I go to the homepage
    Then I should see "Programming contest coming up!"
    And I should not see "Colloquium"
    And I should see "C4"

  Scenario: see the home page with an event tomorrow
    Given default homepage content
    And the following colloquia
      | title    | start           |
      | Get Real | today at 3:30pm |
    When I go to the homepage
    Then I should see "Get Real"
    And I should see "Colloquium today!"
    And I should not see "Colloquium this week!"

  Scenario:see the home page with a conference today and tomorrow
    Given default homepage content
    And the following conferences
      | title    | start     | stop     | description    |
      | GLSEC    | yesterday | tomorrow | doesn't matter |
    When I go to the homepage
    Then I should see "GLSEC"
    And I should see "Conference today!"
    And I should see "Conference coming up!"

  Scenario: see the home page with certain events
    Given default homepage content
    And the following colloquia
      | title       | start               |
      | Old West    | yesterday at 3:30pm |
      | The Present | today at 2:30pm     |
      | The Future  | tomorrow at 1:00pm  |
    When I go to the homepage
    Then I should not see "Old West"
    And I should see "Colloquium today!"
    And I should see "The Present"
    And I should see "Colloquium coming up!"
    And I should see "The Future"

  Scenario: see the home page with some news
    Given default homepage content
    And the following news items
      | headline | teaser | content               |
      | News!    | na na! | No news is good news. |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "na na!"
    And I should not see "No news is good news."
    When I follow "more..."
    Then I should see "News!"
    And I should see "No news is good news."

  Scenario: try every page on the main menu
    Given default homepage content
    Given the following pages
      | identifier   | title           | content      |
      | about_us     | All About Us    | About all us all. |
      | academics    | Academics       | Academe me! |
      | students     | Students!       | Students rule like nothing else. |
      | facilities   | Cool Digs!      | Our facilities are better than yours! |
      | research     | Research this!  | Study up! |
      | alumni       | Alumnuses?      | Those who have gone before us. |
      | contact_us   | Contact info    | Get in touch with us. |
    And the following news items
      | headline | teaser | content               |
      | News!    | na na! | No news is good news. |
    And the following colloquia
      | title        |
      | Colloquiate! |
    When I go to the homepage
    And I follow "About Us"
    Then I should see "About all us all."
    When I follow "Home"
    And I follow "Academics" within ".navigation"
    Then I should see "Academe me!"
    When I follow "Home"
    And I follow "Students"
    Then I should see "Students rule like nothing else"
    When I follow "Home"
    And I follow "Faculty & Staff"
    Then I should see "Faculty"
    And I should see "Joel"
    And I should see "Staff"
    And I should see "Adjunct"
    And I should see "Emeriti"
    When I follow "Home"
    And I follow "Facilities"
    Then I should see "Our facilities are better than yours!"
    When I follow "Home"
    And I follow "Research"
    Then I should see "Study up!"
    When I follow "Home"
    And I follow "Alumni Profiles"
    Then I should see "Those who have gone before us."
    When I follow "Home"
    And I follow "News"
    Then I should see "Current News"
    And I should see "News!"
    When I follow "Home"
    And I follow "Events"
    Then I should see "Upcoming Events"
    And I should see "Colloquiate!"
    When I follow "Home"
    And I follow "Contact Us" within ".navigation"
    Then I should see "Get in touch with us."
    When I follow "Home"
    Then I should be on the home page
