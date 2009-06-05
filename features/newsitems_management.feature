Feature: managing news items
  As an editor of the website
  I want to add, remove, and modify news items
  So that I can keep the news fresh and interesting and accurate

  Scenario: Entering a new news item
    Given I am logged in as an editor
    When I go to the administration page
    And I follow "Create news item"
    Then I should be on the new news item page
    When I fill in "newsitem[headline]" with "The Freakin' Headline"
    And I fill in "newsitem[teaser]" with "The Frakin' Teaser"
    And I fill in "newsitem[content]" with "The Frellin' Content"
    And I press "Save changes"
    Then I should be on the current news page

  Scenario: Editing an old news item
    Given I am logged in as an editor
    And the following news items
      | headline | teaser | content               |
      | News!    | na na! | No news is good news. |
    When I go to the administration page
    And I follow "List news items"
    Then I should be on the current news page
    When I follow "edit..."
    Then I should see "No news is good news."
    When I fill in "newsitem[content]" with "Some new content."
    And I press "Save changes"
    Then I should be on the current news page
    And I should see "Some new content."
#    And I should not see "No news is good news."
