Then /^I should have a sitemap XML$/ do
  response.should have_selector("urlset", :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9")
end

Then /^the sitemap should have "([^\"]*)" as a url with priority "([^\"]*)"$/ do |url, priority|
  response.should have_selector("url") do |url_element|
    url_element.should have_selector("loc", :content => url)
    url_element.should have_selector("priority", :content => priority)
  end
end

Then /^the sitemap should have "([^\"]*)" as a url$/ do |url|
  response.should have_selector("url") do |url_element|
    url_element.should have_selector("loc", :content => url)
  end
end

Then /^the sitemap should not have "([^\"]*)" as a url$/ do |url|
  response.should_not have_selector("loc", :content => url)
end
