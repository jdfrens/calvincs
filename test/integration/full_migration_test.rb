require "#{File.dirname(__FILE__)}/../test_helper"

class FullMigrationTest < ActionController::IntegrationTest
  
  def test_full_migration
    drop_all_tables
    see_empty_schema
    
    migrate
    see_full_schema
    
    migrate :version => 0
    see_empty_schema
    
    migrate
    see_full_schema
  end
  
  def see_full_schema
    assert_schema do |s|
      s.table "courses" do |t|
        t.column :id,          :integer
        t.column "label",       :string
        t.column "number",      :integer
        t.column "title",       :string
        t.column "description", :text
        t.column "credits",     :integer
        t.column "created_at",  :datetime
      end
      
      s.table "pages" do |t|
        t.column "id",          :integer
        t.column "identifier",  :string
        t.column "title",       :string
        t.column "content",     :text
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
      
      s.table "images" do |t|
        t.column "id",            :integer
        t.column "url",           :string
        t.column "caption",       :string
        t.column "tag",           :string
      end
      
      s.table "image_tags" do |t|
        t.column "id",            :integer
        t.column "image_id",      :integer
        t.column "tag",           :string
      end
      
      # authentication
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
        t.column "password_hash", :string
        t.column "group_id",      :integer
        t.column "email_address", :string
      end
    end
  end
  
  def see_empty_schema
    assert_schema do |s|
    end
  end
  
end
