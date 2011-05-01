Feature: managing pages
  As an editor
  I want to manage pages
  So that I write content for the website

  Scenario: listing pages
    Given I am logged in as an editor
    And the following pages
      | identifier | title  | content      |
      | foobar     | Foo    | bar bar bar. |
      | xmas       | XMass! | Merry!       |
    When I go to the page listing
    Then I should see "XMass!"
    And I should see "Foo"

  Scenario: list of pages link to edit
    Given I am logged in as an editor
    And the following pages
      | identifier | title  | content      |
      | foobar     | Foo    | bar bar bar. |
      | xmas       | XMass! | Merry!       |
    When I go to the page listing
    And I follow "xmas"
    Then I should be editing a page
    And I should see "xmas"

  Scenario: titles of subpages are suppressed
    Given I am logged in as an editor
    And the following pages
      | identifier | title        | content        |
      | _subpage   | subpage!     | It sub-tastic! |
      | normal     | normal page! | Check me out.  |
    When I go to the page listing
    Then I should see "normal page!"
    And I should not see "subpage!"
    And I should not see "SUBPAGE identified as _subpage"

  Scenario: titles of subpages are suppressed when editing
    Given I am logged in as an editor
    And the following pages
      | identifier | title    | content        |
      | _subpage   | subpage! | It sub-tastic! |
    When I go to the page listing
    And I follow "_subpage"
    Then I should be editing a page
    And I should see "This is a subpage, and subpages do not have titles."
    And I should not see "SUBPAGE identified as _subpage"
    And I should not see "subpage!"

  Scenario: create a new page
    Given I am logged in as an editor
    When I am on the administration page
    And I follow "Create" within "#content_administration"
    And I fill in "Identifier" with "joe"
    And I fill in "Title" with "Joe Is Cool"
    And I fill in "Content" with "Stuff about Joe."
    And I press "Create page"
    Then I should be on the "joe" page
    And I should see "Joe Is Cool"
    And I should see "Stuff about Joe."

  Scenario: seeing a page
    Given I am logged in as an editor
    And the following pages
      | identifier | title | content      |
      | foobar     | Foo   | bar bar bar. |
    And the following images
      | url                   | caption   | tags_string | width | height |
      | /images/somewhere.gif | Somewhere | foobar      | 265   | 200    |
    When I go to the "foobar" page
    Then I should see "bar bar bar."
    And I should see an image "/images/somewhere.gif"
    And I should see "Somewhere"

  Scenario: see and edit a page
    Given I am logged in as an editor
    And the following pages
      | identifier | title | content      |
      | foobar     | Foo   | bar bar bar. |
    When I go to the "foobar" page
    Then I should see "bar bar bar."
    When I follow "edit this page"
    Then I should be editing a page
  
  Scenario: links to see the page while editing
    Given I am logged in as an editor
    And the following pages
      | identifier | title | content      |
      | foobar     | Foo   | bar bar bar. |
    When I go to the edit "foobar" page
    And I follow "show this page"
    Then I should be on the "foobar" page

  Scenario: link to home page when editing a subpage for the home page
    Given I am logged in as an editor
    And the following pages
      | identifier | title | content  |
      | _home_page | N/A   | whatever |
    And the following images
      | url            | caption      | tags_string |
      | /images/foobar | The caption. | homepage    |
    When I go to the edit "_home_splash" page
    And I follow "show home page"
    Then I should be on the home page

  Scenario: link to faculty pages when editing a subpage for a faculty page
    Given I am logged in as an editor
    And the following pages
      | identifier       | title | content             |
      | _adams_interests | N/A   | very interesting... |
      | _adams_profile   | N/A   | side shot           |
    When I go to the edit "_adams_interests" page
    And I follow "show faculty page"
    Then I should be on the people page
    When I go to the edit "_adams_profile" page
    And I follow "show adams page"
    Then I should be on the "adams" person page

  Scenario: create a new page when trying to edit
    Given I am logged in as an editor
    When I go to the edit "create_me" page
    Then I should be editing a page
