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

class User < ActiveRecord::Base

  acts_as_login_model :login_attribute => :username

  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_format_of :office_phone, :with => /^(()|(\d{3}-\d{3}-\d{4}))$/

  has_many :degrees, :order => 'year', :dependent => :delete_all
  accepts_nested_attributes_for :degrees, :reject_if => lambda { |a| a[:degree_type].blank? }, :allow_destroy => true

  scope :non_admins, :include => [:role], :conditions => ["roles.name <> ?", "admin"]

  def self.activate_users
    all.each do |user|
      user.active = true
      user.save!
    end
  end

  DEFAULT_GROUPS = ["adjuncts", "admin", "contributors",
                    "emeriti", "faculty", "staff"]
  def self.defaults
    edit = Privilege.find_or_create_by_name('edit') 
    DEFAULT_GROUPS.each do |name|
      role = Role.find_or_create_by_name(name)
      role.privileges << edit
      role.save!
    end
  end

  def self.generate_salt()
    (0...4).map{65.+(rand(25)).chr}.join
  end

  def to_param
    username
  end

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

  def hash_password(*args, &blk)
    self.class.hash_password(*args, &blk)
  end
end
