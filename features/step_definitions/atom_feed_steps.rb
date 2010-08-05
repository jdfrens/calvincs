Then /^I should see "([^\"]*)" as (first|second|last|only) entry title$/ do |text, cardinal|
  case cardinal
  when "first", "only"
    cardinal = "first-of-type"
  when "second"
    cardinal = "nth-of-type(2)"
  when "last"
    cardinal = "last-of-type"
  end
  page.locate(:css, "entry:#{cardinal} title").text.should == text
end

Then /^I should see "([^\"]*)" as title$/ do |text|
  page.locate(:xpath, "//feed/title").text.should == text
end

Then /^I should see "([^"]*)" as entry content$/ do |text|
  page.locate(:css, "entry content").text.should == text
end
