Feature: the main navigation (for the department)
  As a visitor to the site
  I want to navigate site with a contextual menu system
  So that I can easily navigate the site

  Scenario: see the main menu
  	Given default homepage content
		When I am on the home page
		Then I should see "Home" within "#navbar"
		And I should see "Events" within "#navbar"
		
  Scenario: do not see event or newsitem submenus
  	Given default homepage content
		When I am on the home page
		Then I should see "Events" within "#navbar"
		And I should not see "Current" within "#navbar"
		And I should not see "Archive" within "#navbar"

  Scenario: see event submenu on an event page
  	Given default homepage content
		When I am on the home page
		And I follow "Events" within "#navbar"
		Then I should see "Current" within "#navbar"
		And I should see "Archive" within "#navbar"

  Scenario: see newsitem submenu on a newsitem page
  	Given default homepage content
		When I am on the home page
		And I follow "News" within "#navbar"
		Then I should see "Current" within "#navbar"
		And I should see "Archive" within "#navbar"
