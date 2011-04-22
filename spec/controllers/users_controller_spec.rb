require 'spec_helper'

describe UsersController do
	render_views

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user) # builds a user from spec/factories.rb
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user # automatically assumes :id => @user.id
      assigns(:user).should == @user # takes in the symbol and return a instance variable of the controller
    end
	
	it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

end
