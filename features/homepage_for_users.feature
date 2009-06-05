Feature: the home page
  As a visitor to the site
  I want to see the home page
  So that I can access other pages and read news

  Scenario: see the home page
    Given the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "some content"
    And I should see "sploosh!"

  Scenario: see the home page with some news
    Given the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
    And the following news items
      | headline | teaser | content               |
      | News!    | na na! | No news is good news. |
    When I go to the homepage
    Then I should be on the homepage
    And I should see "some content"
    And I should see "na na!"
    When I follow "more..."
    Then I should see "News!"
    And I should see "No news is good news."

  Scenario: try every page on the main menu
    Given the following pages
        | identifier   | title           | content      |
        | _home_page   | does not matter | some content |
        | _home_splash | does not matter | sploosh!     |
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
    When I go to the homepage
    And I follow "About Us"
    Then I should see "About all us all."
    When I follow "Home"
    Then I should see "sploosh!"
    And I follow "Academics"
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
    When I follow "Home"
    And I follow "Contact Us"
    Then I should see "Get in touch with us."
    When I follow "Home"
    Then I should be on the home page
