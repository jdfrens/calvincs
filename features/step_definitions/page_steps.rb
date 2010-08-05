Given /^there are no pages$/ do
  Page.delete_all
end

Given /^the following pages$/ do |table|
  table.hashes.each do |hash|
    Page.create!(hash)
  end
end

Given /^default homepage content$/ do
  Page.create!(:identifier => "_home_page", :title => "not needed", :content => "home page whatever")
  Image.create!(:url => "/images/foobar.jpg").tap do |image|
    image.tags_string = "homepage"
    image.save!
  end
end

Then /^I should create (\w+) page$/ do |identifier|
  URI.parse(current_url).path.should == "/pages/new/#{identifier}"
  page.should have_xpath("//input[@id='page_identifier' and @value='#{identifier}']")
end

Then /^I should edit (\w+) page$/ do |identifier|
  URI.parse(current_url).path.should == edit_page_path(Page.find_by_identifier(identifier))
end

Then /^I should edit (\w+) page with id (\d+)$/ do |identifier, id|
  URI.parse(current_url).path.should == "/pages/#{id}/edit"
  page.should have_xpath("//*[@id='page_identifier_#{id}_in_place_editor']", :text => identifier)
end

Then /^I should be editing a page$/ do
  URI.parse(current_url).path.should match(%r{/p/(\w+)/edit})
end

Then /^there should be no pages$/ do
  Page.count.should == 0
end
