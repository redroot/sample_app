module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  def current_user=(user) # explicit function for assigned to current_user
    @current_user = user
  end
  
  def current_user # this function is for returning the current user
    @current_user ||= user_from_remember_token # either return the current user or if null attempt to fetch se from remember token
  end
  
  def current_user?(user) # returns if this user matches the current user, from the function above
    user == current_user
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def deny_access
	store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  ##############
  private
  ##############
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token) # lets us pass a an array of n to a function expecting n params
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

	def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
	
end