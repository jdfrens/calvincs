class PersonnelController < ApplicationController

  restrict_to :edit, :except => [ :index, :show ]

  def index
    @faculty = Role.users_ordered_by_name("faculty")
    @adjuncts = Role.users_ordered_by_name("adjuncts")
    @emeriti = Role.users_ordered_by_name("emeriti")
    @contributors = Role.users_ordered_by_name("contributors")
    @staff = Role.users_ordered_by_name("staff")
    @admin = Role.users_ordered_by_name("admin")

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

  def new
    @user = User.new
  end

  def create
    user = User.new(params[:user])
    user.active = true
    user.email_address = user.username + "@calvin.edu"
    if user.save
      redirect_to(people_path)
    else
      flash[:error] = "Problems creating the new user."
      render :action => "new"
    end
  end  

  def edit
    @user = User.find_by_username(params[:id])
  end

  def editpassword
    @user = User.find_by_username(params[:id])
  end

  def update
    @user = User.find_by_username(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Person updated."
      redirect_to person_path(@user)
    else
      flash[:error] = "Problem updating person."
      render :action => "edit"
    end
  end
end
