Feature: the main navigation (for the department)
  As a visitor to the site
  I want to navigate site with a contextual menu system
  So that I can easily navigate the site

  Scenario: see the main menu
  	Given default homepage content
		When I am on the home page
		Then I should see "Home" within "#navbar"
		And I should see "Events" within "#navbar"
		
  Scenario: do not see "Events" or "News" submenus
  	Given default homepage content
		When I am on the home page
		Then I should see "Events" within "#navbar"
		And I should not see "Current" within "#navbar"
		And I should not see "Archive" within "#navbar"
		
  Scenario: do not see "Academics" submenu
  	Given default homepage content
		When I am on the home page
		Then I should see "Academics" within "#navbar"
		And I should not see "Course Materials" within "#navbar"

  Scenario: see "Events" submenu on an event page
  	Given default homepage content
		When I am on the home page
		And I follow "Events" within "#navbar"
		Then I should see "Current" within "#navbar"
		And I should see "Archive" within "#navbar"

  Scenario: see "News" submenu on a newsitem page
  	Given default homepage content
		When I am on the home page
		And I follow "News" within "#navbar"
		Then I should see "Current" within "#navbar"
		And I should see "Archive" within "#navbar"

  Scenario: do see "Academics" submenu
  	Given default homepage content
		When I am on the home page
		And I follow "Academics" within "#navbar"
		Then I should see "Courses" within "#navbar"

		When I follow "Courses" within "#navbar"
		Then I should see "Academics" within "#navbar"
		And I should see "Courses" within "#navbar"
