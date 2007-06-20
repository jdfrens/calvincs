class User < ActiveRecord::Base

  acts_as_login_model
  
  has_many :degrees, :dependent => :delete_all

  def full_name
    first_name + " " + last_name
  end
  
  def image
    tag = ImageTag.find_by_tag(username + "_headshot")
    tag ? tag.image : nil
  end
  
end
