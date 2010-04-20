# == Schema Information
# Schema version: 20100315182611
#
# Table name: users
#
#  id                           :integer         not null, primary key
#  username                     :string(255)
#  password_hash                :string(255)
#  role_id                      :integer
#  email_address                :string(255)
#  last_name                    :string(255)
#  first_name                   :string(255)
#  office_phone                 :string(255)
#  office_location              :string(255)
#  job_title                    :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  salt                         :string(255)
#  active                       :boolean
#  remember_me_token            :string(255)
#  remember_me_token_expires_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  fixtures :degrees, :images, :image_tags, :pages
  user_fixtures

  describe "non admins" do
    it "should include faculty" do
      User.non_admins.should include(users(:jeremy))
    end

    it "should include staff" do
      User.non_admins.should include(users(:sharon))
    end

    it "should include emeriti" do
      User.non_admins.should include(users(:larry))
    end

    it "should include adjunct" do
      User.non_admins.should include(users(:fred))
    end

    it "should include contributors" do
      User.non_admins.should include(users(:randy))
    end

    it "should not include admins" do
      User.non_admins.should_not include(users(:calvin))
    end
  end

  it "should activate all users" do
    users(:joel, :jeremy, :keith).each do |user|
      user.active = false
      user.save!
    end
    User.activate_users
    users(:joel, :jeremy, :keith).each do |user|
      user.reload
      user.should be_active
    end
  end

  def test_validations
    user = User.new
    assert !user.valid?
    assert user.errors.invalid?(:username)
    assert user.errors.invalid?(:role_id)
    assert user.errors.invalid?(:email_address)

    user = users(:jeremy)
    assert_equal '616-526-8666', user.office_phone
    user.office_phone = ''
    assert user.save, 'should be okay to save'
    assert user.valid?, 'should still be valid'
    assert_equal '', user.office_phone
    user.office_phone = '526-8666'
    assert !user.save, 'should fail to save because phone is bad'
    assert user.errors.invalid?(:office_phone)
  end

  def test_has_many_degrees
    assert_equal [], users(:sharon).degrees
    assert_equal [degrees(:keith_central)], users(:keith).degrees
    assert_equal [degrees(:jeremy_calvin), degrees(:jeremy_iu)], users(:jeremy).degrees
  end

  def test_has_many_degrees_sorts
    new_degree = users(:jeremy).degrees.create!(:degree_type => 'a', :institution => 'b', :year => 1901)
    assert_equal [new_degree, degrees(:jeremy_calvin), degrees(:jeremy_iu)], users(:jeremy).degrees
  end

  def test_has_many_degrees_destroys_all
    original_count = Degree.count

    users(:jeremy).destroy

    assert_equal original_count - 2, Degree.count
  end

  describe "collecting all last-updated dates for a user" do
    it "should include user's updated at" do
      users(:joel).last_updated_dates.should include(users(:joel).updated_at)
    end

    it "should also include status's updated at" do
      users(:keith).last_updated_dates.should include(users(:keith).updated_at, pages(:keith_status).updated_at)
    end

    it "should also include other page's updated at" do
      users(:jeremy).last_updated_dates.should include(
              users(:jeremy).updated_at, pages(:jeremy_interests).updated_at,
              pages(:jeremy_status).updated_at, pages(:jeremy_profile).updated_at)
    end
  end

  def test_full_name
    assert_equal "Jeremy D.", users(:jeremy).first_name
    assert_equal "Frens", users(:jeremy).last_name
    assert_equal "Jeremy D. Frens", users(:jeremy).full_name
    assert_equal "Joel C. Adams", users(:joel).full_name
    assert_equal "Keith Vander Linden", users(:keith).full_name
  end

  def test_image
    assert_equal images(:jeremy_headshot), users(:jeremy).image
    assert_equal images(:joel_headshot), users(:joel).image
    assert_nil users(:keith).image
    assert_equal images(:sharon_headshot), users(:sharon).image
  end

  def test_subpage
    assert_equal pages(:jeremy_interests), users(:jeremy).subpage(:interests)
    assert_nil users(:keith).subpage(:interests)
    assert_nil users(:joel).subpage(:interests)

    assert_equal pages(:jeremy_profile), users(:jeremy).subpage(:profile)
    assert_nil users(:keith).subpage(:profile)
    assert_nil users(:joel).subpage(:profile)

    assert_equal pages(:jeremy_status), users(:jeremy).subpage(:status)
    assert_equal pages(:keith_status), users(:keith).subpage(:status)
    assert_nil users(:joel).subpage(:status)
  end

  it "should generate page identifiers" do
    users(:jeremy).page_identifier("foobar").should == "_jeremy_foobar"
    users(:joel).page_identifier("abc123").should == "_joel_abc123"
  end

  def test_education_huh
    assert users(:jeremy).education?, "faculty should have an education"
    assert users(:joel).education?, "faculty should have an education"
    assert users(:fred).education?, "adjunct should have an education"
    assert users(:larry).education?, "emeriti should have an education"
    assert users(:randy).education?, "contributors should have an education"

    assert !users(:sharon).education?, "staff should NOT have an education"
  end

end
