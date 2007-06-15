class BuildGroupsAndPrivileges < ActiveRecord::Migration
  def self.up
    privilege = Privilege.create!( :name => 'faculty' )
    faculty = Group.create!( :name => 'faculty' )
    GroupPrivilege.create!( :group => faculty, :privilege => privilege )
    
    privilege = Privilege.create!( :name => 'staff' )
    staff = Group.create!( :name => 'staff' )
    GroupPrivilege.create!( :group => staff, :privilege => privilege )
    
    privilege = Privilege.create!( :name => 'admin' ) 
    admin = Group.create!( :name => 'admin' ) 
    GroupPrivilege.create!( :group => admin, :privilege => privilege )    
    GroupPrivilege.create!( :group => faculty, :privilege => privilege )    
    GroupPrivilege.create!( :group => staff, :privilege => privilege )    
  end
  
  def self.down
  end
end
