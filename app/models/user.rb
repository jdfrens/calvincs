class User < ActiveRecord::Base

  acts_as_login_model
  
  has_many :degrees, :order => 'year', :dependent => :delete_all

  def full_name
    first_name + " " + last_name
  end
  
  def image
    tag = ImageTag.find_by_tag(username + "_headshot")
    tag ? tag.image : nil
  end
  
  def interests_page
    find_user_page "interests"
  end

  def profile_page
    find_user_page "profile"
  end
  
  #
  # Helpers
  #
  private
  
  def find_user_page(suffix)
    Page.find_by_identifier(username + "_" + suffix)
  end
end
