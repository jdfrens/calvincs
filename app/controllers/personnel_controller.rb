class PersonnelController < ApplicationController

  restrict_to :edit, :except => [ :index, :list, :view ]

  def index
    redirect_to :action => 'view', :id => "all"
  end
  
  def list
    if (params[:id] == 'all')
      redirect_to :action => 'list', :id => nil
    else
      @faculty = find_users("faculty")
      @adjuncts = find_users("adjuncts")
      @emeriti = find_users("emeriti")
      @contributors = find_users("contributors")
      @staff = find_users("staff")
      @title = "Faculty & Staff"
      @last_updated = last_updated(@faculty + @adjuncts + @emeriti + @contributors + @staff)
      render    
    end
  end
  
  def view
    @user = User.find_by_username(params[:id])
    if @user.nil?
      redirect_to :action => 'list'
    else
      @image = Image.pick_random(@user.username)
      @title = @user.full_name
      @last_updated = last_updated([@user])
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
  
  def add_degree
    user = User.find(params[:id])
    degree = user.degrees.create!(
        :degree_type => "BA in CS",
        :institution => "Somewhere U",
        :year => 1959
        )
    render :update do |page|
      page.insert_html :bottom, 'education', :partial => 'degree', :object => degree
      page.insert_html :bottom, 'education_edits', :partial => 'degree_edit',
          :object => degree
    end
  end
  
  in_place_edit_for :user, :office_phone

  in_place_edit_for :user, :office_location
  
  def update_job_title
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    render :update do |page|
      page.replace_html "job_title",
          :inline => "<%= textilize_without_paragraph(job_title) %>",
          :locals => { :job_title => user.job_title }
    end
  end
  
  #
  # Helpers
  #
  private
  
  def find_users(name)
    Role.find_by_name(name).users.sort { |a, b| a.last_name <=> b.last_name }
  end
  
end
