Feature: the main navigation (for the department)
  As a visitor to the site
  I want to navigate site with a contextual menu system
  So that I can easily navigate the site

  Scenario: see the main menu
  	Given default homepage content
		When I am on the home page
		Then I should see plain menu item "Home"
		And I should see linked menu item "About Us"
		And I should see linked menu item "Academics"
		And I should see linked menu item "Students"
		And I should see linked menu item "Faculty & Staff"
		And I should see linked menu item "Facilities"
		And I should see linked menu item "Research"
		And I should see linked menu item "Alumni Profiles"
		And I should see linked menu item "News"
		And I should see linked menu item "Events"
		And I should see linked menu item "Contact Us"

  Scenario: do not see "Events" or "News" submenus
  	Given default homepage content
		When I am on the home page
		Then I should see linked menu item "Events"
		And I should not see menu item "Current"
		And I should not see menu item "Archive"

  Scenario: do not see "Academics" submenu
  	Given default homepage content
		When I am on the home page
		Then I should see linked menu item "Academics"
		And I should not see menu item "Courses"

  Scenario: see "Events" submenu on an event page
  	Given default homepage content
    And the following colloquia
      | title    | start                    |
      | Get Fake | 1 day from now at 2:30pm |
		When I am on the home page
		And I follow menu item "Events"
		Then I should see plain menu item "Current"
		And I should see linked menu item "Archive"
		When I follow menu item "Archive"
		Then I should see linked menu item "Current"
		And I should see plain menu item "Archive"

  Scenario: see "News" submenu on a newsitem page
  	Given default homepage content
		When I am on the home page
		And I follow menu item "News"
		Then I should see plain menu item "Current"
		And I should see linked menu item "Archive"
		When I follow menu item "Archive"
		Then I should see linked menu item "Current"
		And I should see plain menu item "Archive"

  Scenario: see "Academics" submenu
  	Given default homepage content
		When I am on the home page
		And I follow menu item "Academics"
		Then I should see linked menu item "Courses"

		When I follow menu item "Courses"
		Then I should see linked menu item "Academics"
		And I should see plain menu item "Courses"
