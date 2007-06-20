class PersonnelController < ApplicationController

  def index
    redirect_to :action => 'faculty'
  end
  
  def faculty
    @faculty = Group.find_by_name("faculty").users.sort { |a, b| a.last_name <=> b.last_name }
  end
  
end
