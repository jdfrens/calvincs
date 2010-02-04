And /^the following degrees$/ do |table|
  table.hashes.each do |hash|
    User.find_by_username(hash[:username]).degrees.create(hash.without("username"))
  end
end
