# == Schema Information
# Schema version: 20091012011757
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

class User < ActiveRecord::Base
  
  acts_as_login_model :login_attribute => :username

  validates_presence_of :username
  validates_presence_of :first_name
  validates_presence_of :last_name
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
    Page.find_by_identifier(page_identifier(suffix))
  end

  def page_identifier(suffix)
    "_" + username + "_" + suffix.to_s
  end

  def education?
    case role.name
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
