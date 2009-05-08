Given /^there are no pages$/ do
  Page.delete_all
end

Then /^I should edit (\w+) page$/ do |identifier|
  URI.parse(current_url).path.should == "/page/create/#{identifier}"
end

Then /^there should be no pages$/ do
  Page.count.should == 0
end