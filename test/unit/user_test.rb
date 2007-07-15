require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  fixtures :degrees, :images, :image_tags, :pages
  user_fixtures

  def test_validations
    user = User.new
    assert !user.valid?
    assert  user.errors.invalid?(:username)
    assert  user.errors.invalid?(:group_id)
    assert  user.errors.invalid?(:email_address)
    
    user = users(:jeremy)
    assert_equal '616-526-8666', user.office_phone
    user.office_phone = ''
    assert user.save, 'should be okay to save'
    assert user.valid?, 'should still be valid'
    assert_equal '', user.office_phone
    user.office_phone = '526-8666'
    assert !user.save, 'should fail to save because phone is bad'
    assert  user.errors.invalid?(:office_phone)
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
  
  def test_education_huh
    assert users(:jeremy).education?, "faculty should have an education"
    assert users(:joel).education?, "faculty should have an education"
    assert users(:fred).education?, "adjunct should have an education"
    assert users(:larry).education?, "emeriti should have an education"
    assert users(:randy).education?, "contributors should have an education"
    
    assert !users(:sharon).education?, "staff should NOT have an education"
  end

end
