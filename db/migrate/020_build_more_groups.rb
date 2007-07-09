class BuildMoreGroups < ActiveRecord::Migration
  def self.up
    emeriti = Group.create!( :name => 'emeriti' )
    contributors = Group.create!( :name => 'contributors' )
    adjuncts = Group.create!( :name => 'adjuncts' ) 
    
    edit = Privilege.find_by_name('edit') 

    GroupPrivilege.create!( :group => emeriti, :privilege => edit )    
    GroupPrivilege.create!( :group => contributors, :privilege => edit )    
    GroupPrivilege.create!( :group => adjuncts, :privilege => edit )    
  end

  def self.down
  end
end
