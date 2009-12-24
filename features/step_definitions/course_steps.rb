Given /^the following courses$/ do |table|
  table.hashes.each do |hash|
    Course.create!(hash)
  end
end
