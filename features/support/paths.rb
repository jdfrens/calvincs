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

      # users
      when /the login page/
        '/users/login'

      # administration
      when /the administration page/
        '/home/administrate'

      # events
      when /the new event page/
        '/event/new'
      when /the list of events/
        '/event/list'

      # news items
      when /the list of news items/
        '/news_items'
      when /the current news/
        '/news_items'
      when /the archive of news items/
        '/news_items?year=all'
      when /the new news item page/
        '/news_items/new'

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
