Given /^the following images$/ do |table|
  table.hashes.each do |hash|
    image = Image.create(hash)
    image.tags_string = hash[:tags_string].strip if hash[:tags_string]
    image.save!
  end
end

Then /^I should see an image "([^\"]*)"$/ do |src|
  page.should have_xpath("//img", :src => src)
end

When /^I expect "([^\"]*)" to have dimension "([^\"]*)x([^\"]*)"$/ do |url, width, height|
  ImageInfo.hardcode(url, width, height)
end
