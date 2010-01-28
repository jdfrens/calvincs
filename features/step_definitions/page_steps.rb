Given /^there are no pages$/ do
  Page.delete_all
end

Given /^the following pages$/ do |table|
  table.hashes.each do |hash|
    Page.create!(hash)
  end
end

Given /^the subpages for the home page$/ do
  Page.create!(:identifier => "_home_page", :title => "not needed", :content => "home page whatever")
  Page.create!(:identifier => "_home_splash", :title => "not needed", :content => "home splash whatever")
end

Then /^I should see content for the home subpages$/ do
  Then 'I should see "home page whatever"'
  Then 'I should see "home splash whatever"'
end

Then /^I should create (\w+) page$/ do |identifier|
  URI.parse(current_url).path.should == "/pages/new/#{identifier}"
  response.should have_selector("input#page_identifier", :value => identifier)
end

Then /^I should edit (\w+) page$/ do |identifier|
  URI.parse(current_url).path.should == edit_page_path(Page.find_by_identifier(identifier))
end

Then /^I should edit (\w+) page with id (\d+)$/ do |identifier, id|
  URI.parse(current_url).path.should == "/pages/#{id}/edit"
  response.should have_selector("#page_identifier_#{id}_in_place_editor", :content => identifier)
end

Then /^I should be editing a page$/ do
  URI.parse(current_url).path.should match(%r{/p/(\w+)/edit})
end

Then /^there should be no pages$/ do
  Page.count.should == 0
end
