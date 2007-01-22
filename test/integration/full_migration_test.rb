require "#{File.dirname(__FILE__)}/../test_helper"

class FullMigrationTest < ActionController::IntegrationTest

  #
  # Structure and Content assertions
  #

  # Fully assert db structure after full migration
  def see_full_schema
    assert_schema do |s|
      table "courses" do |t|
	t.column "id", 		:integer
	t.column "label", 	:string
	t.column "number", 	:integer
	t.column "title",      :string
	t.column "description", :text
	t.column "credits", 	:integer
	t.column "created_at", :datetime
      end
      
      table "documents" do |t|
        t.column "id",          :integer
        t.column "identifier",  :string
        t.column "title",       :string
        t.column "content",     :text
      end
    end
  end

  def see_empty_schema
    assert_schema do |s|
      # is nothing 
    end
  end

  
  #
  # HELPERS
  #

  def conn
    ActiveRecord::Base.connection
  end

  def assert_schema
    @tables = []
    yield self    
    # see that all tables have been accounted for
    actual_tables = conn.tables.reject {|t| t == 'schema_info' }
    expected_tables = @tables.map {|t| t[:name] }
    assert_equal expected_tables.sort, actual_tables.sort, 'wrong tables in schema'
  end

  def table(name)
    name = name.to_s

    # see that table exists
    assert conn.tables.include?(name), "table <#{name}> not found in schema"
    table = Hash.new do |h,k| h[k] = [] end
    table[:name] = name
    @tables << table
    yield self if block_given?

    # see that all columns have been accounted for
    actual_columns = conn.columns(name).map {|c| c.name }
    expected_columns = table[:columns] || []
    assert_equal expected_columns.sort, actual_columns.sort, "wrong columns for table: <#{table[:name]}>"
  end

  def column(name,type, options={})
    name = name.to_s

    table = @tables.last
    table[:columns] ||= []
    table[:columns] << name

    col = conn.columns(table[:name]).find {|c| c.name == name }
    assert_not_nil col, "column <#{name}> not found in table <#{table[:name]}>"
    assert_equal type, col.type, "wrong type for column <#{name}> in table <#{table[:name]}>"

    options.each do |k,v|
      k = k.to_sym
      assert_equal v, col.send(k), "Column '#{name}' has bad '#{k}'"
    end
  end

  def migrate(opts={})
    version = opts[:version] ? "VERSION=#{opts[:version]}" : ''
    # Specifying the rakefile seems to cause an issue if your cwd is not project root; db/schema.rb won't be found
    if PLATFORM[/win32/]
      rake_cmd = %|rake.bat db:migrate #{version} ENV=test|
    else
      rake_cmd = %|rake db:migrate #{version} ENV=test|
    end
    assert system(rake_cmd)
  end



  #
  # TESTS
  #
  def test_full_migration
    # run a full migration
    migrate
    see_full_schema

    # go back to before the first migration
    migrate :version => 0
    see_empty_schema

    # make sure we can get all the way back 
    migrate
    see_full_schema
  end

end
