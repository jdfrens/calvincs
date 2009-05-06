Then /^I should edit (\w+) page$/ do |identifier|
  URI.parse(current_url).path.should == "/page/create/#{identifier}"
end
