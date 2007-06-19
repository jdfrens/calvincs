class BuildGroupsAndPrivileges < ActiveRecord::Migration
  def self.up
    faculty = Group.create!( :name => 'faculty' )
    staff = Group.create!( :name => 'staff' )
    admin = Group.create!( :name => 'admin' ) 
    
    edit = Privilege.create!( :name => 'edit' ) 

    GroupPrivilege.create!( :group => admin, :privilege => edit )    
    GroupPrivilege.create!( :group => faculty, :privilege => edit )    
    GroupPrivilege.create!( :group => staff, :privilege => edit )    
  end
  
  def self.down
  end
end
