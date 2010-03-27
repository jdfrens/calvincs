Given /^the following images$/ do |table|
  table.hashes.each do |hash|
    image = Image.create(hash)
    image.tags_string = hash[:tags_string].strip if hash[:tags_string]
    image.save!
  end
end

Then /^I should see an image "([^\"]*)"$/ do |src|
  response.should have_selector("img", :src => src)
end
