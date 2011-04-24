class UsersController < ApplicationController
	before_filter :authenticate, :only => [:index, :edit, :update] # run authenticate function for edit and update functions
	before_filter :correct_user, :only => [:edit, :update]
	before_filter :admin_user,   :only => :destroy

  def index
    @title = "All users"
	#
	#	User.all had the class of array, whereas with User.paginate we get the
	#	default pagination returned, in this case WillPaginate therefore WillPaginate::Collection
	#
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
	@microposts = @user.microposts.paginate(:page => params[:page]) # same as above paginate reason
	@title = @user.name
  end

  def new
	if signed_in?
		redirect_to current_user
	else
		@user = User.new
		@title = "Sign Up"
	end
  end
  
  def create
	if signed_in?
		redirect_to current_user
	else
	   @user = User.new(params[:user])
		if @user.save
		  sign_in @user # from sessions helpers
		  flash[:success] = "Welcome to the Sample App!"
		  redirect_to @user
		else
		  @title = "Sign up"
		  render 'new'
		end
	end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user]) # update those attributes accessible and save
      flash[:success] = "Profile updated."
      redirect_to @user # redirect ro use page
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private
	
	def correct_user # on edit and update returns current user by default
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
	
	def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
