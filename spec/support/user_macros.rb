module UserMacros
  def user_fixtures
    fixtures :users, :roles, :privileges, :privileges_roles
  end
end
