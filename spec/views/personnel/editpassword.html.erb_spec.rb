require 'spec_helper'

describe "personnel/editpassword.html.erb" do
  it "should render a form" do
    user = mock_model(User, :full_name => "Mr. Hudson",
                            :password => User.hash_password("yikes", User.generate_salt),
                            :password_confirmation => nil)
    assign(:user, user)

    render

    rendered.should have_selector("form") do |form|
      form.should have_selector("input#user_password")
      form.should have_selector("input#user_password_confirmation")
    end
  end
end
