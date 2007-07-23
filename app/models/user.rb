class User < ActiveRecord::Base
  
  acts_as_login_model
  
  validates_format_of :office_phone, :with => /^(()|(\d{3}-\d{3}-\d{4}))$/
  
  has_many :degrees, :order => 'year', :dependent => :delete_all
  
  def full_name
    first_name + " " + last_name
  end
  
  def image
    tag = ImageTag.find_by_tag(username + "_headshot")
    tag ? tag.image : nil
  end
  
  def subpage(suffix)
    Page.find_by_identifier("_" + username + "_" + suffix.to_s)
  end
  
  def education?
    case group.name
    when "faculty", "adjuncts", "emeriti", "contributors"
      true
    when "staff"
      false
    end
  end
  
  def last_updated_dates
    [self, subpage(:interests), subpage(:status), subpage(:profile)].compact.map(&:updated_at)
  end
  
end
