class PersonnelController < ApplicationController

  restrict_to :edit, :except => [ :index, :show ]

  def index
    @faculty = Role.users_ordered_by_name("faculty")
    @adjuncts = Role.users_ordered_by_name("adjuncts")
    @emeriti = Role.users_ordered_by_name("emeriti")
    @contributors = Role.users_ordered_by_name("contributors")
    @staff = Role.users_ordered_by_name("staff")
    @title = "Faculty & Staff"
    @last_updated = last_updated(@faculty + @adjuncts + @emeriti + @contributors + @staff)
  end

  def show
    @user = User.find_by_username(params[:id])
    if @user.nil?
      redirect_to :action => "index"
    else
      @image = Image.pick_random(@user.username)
      @title = @user.full_name
      @last_updated = last_updated([@user])
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to cogs_path
    else
    end
  end

  # TODO: replace with "update" method
  def update_name
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    render :update do |page|
      page.replace_html "full_name_header",
                        :inline => "<h1><%= full_name %></h1>",
                        :locals => { :full_name => user.full_name }
    end
  end

  # TODO: degree controller!
  def update_degree
    degree = Degree.find(params[:id])
    degree.update_attributes(params[:degree])
    render :update do |page|
      page.replace_html "degree_#{degree.id}",
                        :partial => "degree", :object => degree
    end
  end

  # TODO: degree controller!
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

  # TODO: replace with "update" method
  def update_job_title
    user = User.find(params[:id])
    user.update_attributes(params[:user])
    render :update do |page|
      page.replace_html "job_title",
                        :inline => "<%= textilize_without_paragraph(job_title) %>",
                        :locals => { :job_title => user.job_title }
    end
  end
end
