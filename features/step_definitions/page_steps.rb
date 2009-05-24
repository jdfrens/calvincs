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

Then /^I should edit (\w+) page with id (\d+)$/ do |identifier, id|
  URI.parse(current_url).path.should == "/pages/#{id}/edit"
  response.should have_selector("#page_identifier_#{id}_in_place_editor", :content => identifier)
end

Then /^there should be no pages$/ do
  Page.count.should == 0
end




Then /^I should see a listing of pages$/ do
  pending
end

Then /^I should see the home page$/ do
  pending
end
