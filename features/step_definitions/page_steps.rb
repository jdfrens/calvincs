Given /^there are no pages$/ do
  Page.delete_all
end

Given /^the following pages$/ do |table|
  table.hashes.each do |hash|
    Page.create!(hash)
  end
end

Then /^I should create (\w+) page$/ do |identifier|
  URI.parse(current_url).path.should == "/pages/new/#{identifier}"
  response.should have_selector("input#page_identifier", :value => identifier)
end

Then /^I should edit (\w+) page$/ do |identifier|
  id = Page.find_by_identifier(identifier).id
  URI.parse(current_url).path.should == "/pages/#{id}/edit"
  response.should have_selector("#page_identifier_#{id}_in_place_editor", :content => identifier)
end

Then /^I should edit (\w+) page with id (\d+)$/ do |identifier, id|
  URI.parse(current_url).path.should == "/pages/#{id}/edit"
  response.should have_selector("#page_identifier_#{id}_in_place_editor", :content => identifier)
end

Then /^I should be editing a page$/ do
  URI.parse(current_url).path.should match(%r{/pages/(\d+)/edit})
  URI.parse(current_url).path =~ %r{/pages/(\d+)/edit}
  @page_id = $1
end

Then /^there should be no pages$/ do
  Page.count.should == 0
end
