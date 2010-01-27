module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

      when /the home(\s*)page/
        '/'
      when /the atom feed/
        '/feed'

      # users
      when /the login page/
        '/users/login'

      # administration
      when /the administration page/
        '/home/administrate'

      # events
      when /the new event page/
        new_event_path
      when /the list of events/
        events_path

      # news items
      when /the list of news items/
        '/newsitems'
      when /the current news/
        '/newsitems'
      when /the archive of news items/
        '/newsitems?year=all'
      when /the new news item page/
        '/newsitems/new'

      # personnel
      when /the list of personnel/
        people_path
      
      # courses
      when /the list of courses/
        courses_path

      # pages
      when /the page listing/
        pages_path
      when /the new page page/
        new_page_path
      when /the "(.*)" page/
        "/p/#{$1}"
      when /the page to edit the page "(.*)"/
        "/pages/#{$1}/edit"
      
      else
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
