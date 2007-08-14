require "#{File.dirname(__FILE__)}/../test_helper"

class FullMigrationTest < Test::Unit::TestCase
  
  def test_full_migration
    drop_all_tables
    see_empty_schema
    
    migrate
    see_full_schema
    see_data
    
    migrate :version => 0
    see_empty_schema
    
    migrate
    see_full_schema
    see_data
  end
  
  def see_full_schema
    assert_schema do |s|
      see_course_tables(s)
      see_pages_and_news_tables(s)
      see_faq_tables(s)
      see_image_tables(s)
      see_authentication_tables(s)
      see_user_info_tables(s)
    end
  end
  
  def see_course_tables(s)
    s.table "courses" do |t|
      t.column :id,           :integer
      t.column "label",       :string
      t.column "number",      :integer
      t.column "title",       :string
      t.column "description", :text
      t.column "credits",     :integer
      t.column "created_at",  :datetime
    end
  end
  
  def see_pages_and_news_tables(s)
    s.table "pages" do |t|
      t.column "id",          :integer
      t.column "identifier",  :string
      t.column "title",       :string
      t.column "content",     :text
      t.column "updated_at",  :datetime
    end
    
    s.table "news_items" do |t|
      t.column "id",            :integer
      t.column "headline",      :string
      t.column "teaser",        :string
      t.column "content",       :text
      t.column "user_id",       :integer
      t.column "created_at",    :datetime
      t.column "updated_at",    :datetime
      t.column "goes_live_at",  :datetime
      t.column "expires_at",    :datetime
    end
  end
  
  def see_faq_tables(s)
    s.table "faqs" do |t|
      t.column :id,             :integer
      t.column :title,          :string
      t.column :identifier,     :string
    end
    
    s.table :questions do |t|
      t.column :id,             :integer
      t.column :faq_id,         :integer
      t.column :position,       :integer
      t.column :query,          :text
      t.column :answer,         :text
    end
  end
  
  def see_image_tables(s)
    s.table "images" do |t|
      t.column "id",            :integer
      t.column "url",           :string
      t.column "width",         :integer
      t.column "height",        :integer
      t.column "caption",       :text
    end
    
    s.table "image_tags" do |t|
      t.column "id",            :integer
      t.column "image_id",      :integer
      t.column "tag",           :string
    end
  end
  
  def see_authentication_tables(s)
    s.table "groups" do |t|
      t.column "id",          :integer
      t.column "name",        :string
    end
    
    s.table "privileges" do |t|
      t.column "id",          :integer
      t.column "name",        :string
    end
    
    s.table "groups_privileges" do |t|
      t.column "id",           :integer
      t.column "group_id",     :integer
      t.column "privilege_id", :integer
    end
    
    s.table "users" do |t|
      t.column "id",            :integer
      t.column "username",      :string
      t.column "first_name",    :string
      t.column "last_name",     :string
      t.column "job_title",     :string
      t.column "office_phone",  :string
      t.column "office_location", :string
      t.column "password_hash", :string
      t.column "group_id",      :integer
      t.column "email_address", :string
      t.column "created_at",    :datetime
      t.column "updated_at",    :datetime
    end
  end
  
  def see_user_info_tables(s)
    s.table "degrees" do |t|
      t.column "id",          :integer
      t.column "user_id",     :integer
      t.column "degree_type", :string
      t.column "institution", :string
      t.column "url",         :string
      t.column "year",        :integer
    end
  end
  
  def see_empty_schema
    assert_schema do |s|
    end
  end
  
  def see_data
    assert_names(
        ["admin", "faculty", "staff", "adjuncts", "contributors", "emeriti"],
        Group.find(:all)
        )
    
    assert_names ["edit"], Group.find_by_name("faculty").privileges
    assert_names ["edit"], Group.find_by_name("adjuncts").privileges
    assert_names ["edit"], Group.find_by_name("contributors").privileges
    assert_names ["edit"], Group.find_by_name("emeriti").privileges
    assert_names ["edit"], Group.find_by_name("staff").privileges
    assert_names ["edit"], Group.find_by_name("admin").privileges
  end
  
  def assert_names(expected, actual)
    assert_equal expected.sort, actual.map(&:name).sort
  end
  
end
