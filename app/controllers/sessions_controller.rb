class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
	user = User.authenticate(params[:session][:email],
                           params[:session][:password])
    if user.nil?
	  # Create an error message and re-render the signin form.
	  flash.now[:error] = "Invalid email/password combination." ## flash now used since we a directing not rendering
      @title = "Sign in"
      render 'new'
    else
	  # Sign the user in and redirect to the last destination or user show page
	  sign_in user
      redirect_back_or user # session helper funtion, redirect user back to their destinatin (from session) or to the user page
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
