And /^I should see some error$/ do
  response.should have_selector("#error")
end
