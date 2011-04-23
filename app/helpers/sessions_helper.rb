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
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
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
end