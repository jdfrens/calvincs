class PersonnelController < ApplicationController

  restrict_to :edit, :except => [ :index, :faculty, :view ]

  def index
    redirect_to :action => 'faculty'
  end
  
  def faculty
    @faculty = Group.find_by_name("faculty").users.sort { |a, b| a.last_name <=> b.last_name }
  end
  
  def view
    @user = User.find_by_username(params[:id])
    if @user.nil?
      redirect_to :action => 'faculty'
    else
      render
    end
  end
  
  def update_name
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    render :update do |page|
      page.replace_html "full_name_header",
          :inline => "<h1><%= full_name %></h1>",
          :locals => { :full_name => user.full_name }
    end
  end
  
  def update_degree
    degree = Degree.find(params[:id])
    degree.update_attributes(params[:degree])
    render :update do |page|
      page.replace_html "degree_#{degree.id}",
          :partial => "degree", :object => degree
    end
  end
  
end
