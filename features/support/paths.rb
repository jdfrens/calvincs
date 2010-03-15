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
        login_path

      # administration
      when /the administration page/
        administrate_path

      # courses
      when /the list of courses/
        courses_path
      when /the \"(.+)\" course page/
        course_path(Course.find_by_short_identifier($1))

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

      # pictures
      when /the list of pictures/
        images_path
      when /the new picture page/
        new_image_path
      when /the edit the "(.*)" picture/
        edit_image_path(Image.find_by_url($1))

      # personnel
      when /the list of personnel/
        people_path
      when /edit person "(.*)"/
        edit_person_path($1)
      
      # pages
      when /the page listing/
        pages_path
      when /the new page page/
        new_page_path
      when /the new page for "(.*)" page/
        new_page_path(:id => $1)
      when /the "(.*)" page/
        page_path($1)
      when /the edit "(.*)" page/
        edit_page_path($1)
      
      else
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
                "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
