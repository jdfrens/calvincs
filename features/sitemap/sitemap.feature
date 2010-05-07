Feature: the sitemap
  As a spider indexing the site
  I want to get a sitemap
  So that I know what pages I should look at

  Scenario: home page with priority
    When I go to the sitemap
    Then I should have a sitemap XML
    And the sitemap should have "http://cs.calvin.edu/" as a url with priority "0.8"

  Scenario: one-offs in the sitemap
    When I go to the sitemap
    Then the sitemap should have "http://cs.calvin.edu/courses" as a url
    And the sitemap should have "http://cs.calvin.edu/events" as a url
    And the sitemap should have "http://cs.calvin.edu/newsitems" as a url

  Scenario: normal pages listed in the sitemap
    Given the following pages
      | identifier | title           | content           |
      | foo        | Fooey           | The quick fox.    |
      | bar        | Bar and Beam    | Drink it up.      |
      | foobar     | Foobar          | Situation normal. |
      | _subpage   | Does Not Matter | A subpage.        |
    When I go to the sitemap
    Then the sitemap should have "http://cs.calvin.edu/p/foo" as a url with lastmod
    And the sitemap should have "http://cs.calvin.edu/p/bar" as a url with lastmod
    And the sitemap should have "http://cs.calvin.edu/p/foobar" as a url with lastmod
    And the sitemap should not have "http://cs.calvin.edu/p/_subpage" as a url

  Scenario: courses listed in the sitemap
    Given the following courses
      | department | number | title         | url                                   |
      | CS         | 108    | Everything CS | http://cs.calvin.edu/cs108/           |
      | IS         | 337    | Advanced IS   | http://cs.calvin.edu/is337/           |
      | CS         | 123    | Something     | http://cs.calvin.edu/~foobar/course/" |
    When I go to the sitemap
    Then the sitemap should have "http://cs.calvin.edu/cs108/" as a url
    And the sitemap should have "http://cs.calvin.edu/is337/" as a url
    And the sitemap should have "http://cs.calvin.edu/~foobar/course/" as a url

  Scenario: people in the sitemap
    Given the following users
      | username | first_name | last_name | role    |
      | jcalvin  | John       | Calvin    | faculty |
      | mluther  | Martin     | Luther    | staff   |
      | cdarwin  | Charles    | Darwin    | admin   |
    When I go to the sitemap
    Then the sitemap should have "http://cs.calvin.edu/people" as a url
    And the sitemap should have "http://cs.calvin.edu/people/jcalvin" as a url with lastmod
    And the sitemap should have "http://cs.calvin.edu/people/mluther" as a url with lastmod
    And the sitemap should not have "http://cs.calvin.edu/people/cdarwin" as a url

  Scenario: activities in the sitemap
    When I go to the sitemap
    Then the sitemap should have "http://cs.calvin.edu/activities/connect/" as a url
    And the sitemap should have "http://cs.calvin.edu/activities/blasted/" as a url
    
  Scenario: books in the sitemap
    When I go to the sitemap
    Then the sitemap should have "http://cs.calvin.edu/books/c++/intro/3e/" as a url
    And the sitemap should have "http://cs.calvin.edu/books/c++/ds/2e/" as a url
    And the sitemap should have "http://cs.calvin.edu/books/fortran/" as a url
    And the sitemap should have "http://cs.calvin.edu/books/java/intro/1e/" as a url
    And the sitemap should have "http://cs.calvin.edu/books/networking/labbook/" as a url
