class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
	  format.html { redirect_to @user }
	  format.js # automatically calls same name js.erb file e.g relationships/create.js.erb
	end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
	  format.html { redirect_to @user }
	  format.js # relationships/destroy.js.erb
	end
  end
end