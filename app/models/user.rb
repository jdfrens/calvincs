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
    Page.find_by_identifier(username + "_interests")
  end
  
end
