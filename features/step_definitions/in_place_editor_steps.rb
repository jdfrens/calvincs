Then /^the in place editor for "([^\"]*)" should contain "([^\"]*)"$/ do |span_id, content|
  response.should have_selector("##{span_id}_in_place_editor", :content => content)
end
