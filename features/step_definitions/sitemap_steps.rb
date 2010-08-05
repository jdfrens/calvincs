Then /^I should have a sitemap XML$/ do
  page.should have_xpath("//urlset", :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9]")
end

Then /^the sitemap should have "([^\"]*)" as a url with priority "([^\"]*)"$/ do |url, priority|
  page.should have_xpath("//url") do |url_element|
    url_element.should have_xpath("//loc", :text => url)
    url_element.should have_xpath("//priority", :text => priority)
  end
end

Then /^the sitemap should have "([^\"]*)" as a url$/ do |url|
  page.should have_xpath("//url") do |url_element|
    url_element.should have_xpath("//loc", :text => url)
  end
end

Then /^the sitemap should have "([^\"]*)" as a url with lastmod$/ do |url|
  page.should have_xpath("//url") do |url_element|
    url_element.should have_xpath("//loc", :text => url)
    url_element.should have_xpath("//lastmod")
  end
end

Then /^the sitemap should not have "([^\"]*)" as a url$/ do |url|
  page.should_not have_xpath("//loc", :text => url)
end
