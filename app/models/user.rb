# == Schema Information
# Schema version: 20110419095500
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#
require 'digest' # for hashing

class User < ActiveRecord::Base

	attr_accessor :password
	attr_accessible :name, :email, :password, :password_confirmation
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :name, :presence => true,
					 :length   => { :maximum => 50 }
					 
	validates :email, :presence => true,
					  :format => { :with => email_regex }, ## checks emails against the emails regex
					  :uniqueness => { :case_sensitive => false }
					  
	
	validates :password, :presence     => true,
						 :confirmation => true,  # Automatically create the virtual attribute 'password_confirmation'.
                         :length       => { :within => 6..40 }
						 
	before_save :encrypt_password # bbefore the model is saved, run the encrypt password function
	
	has_many :microposts, :dependent => :destroy
	
	has_many :relationships, :foreign_key => "follower_id", # set explicitly, since it will expect user_id inr elatioships object
                             :dependent => :destroy
							 
	has_many :reverse_relationships, :foreign_key => "followed_id", # set explicitly, since it will expect user_id inr elatioships object
									 :class_name => "Relationship", # again explicitly set
									 :dependent => :destroy
	
	has_many :following, :through => :relationships, :source => :followed
	has_many :followers, :through => :reverse_relationships, :source => :follower
	
	#################
	# public
	#################
	
	# Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
	  encrypted_password == encrypt(submitted_password) ## returns if this users password matches the one submitted
	end
	
	#authenticate class method
	def self.authenticate(submitted_email,submitted_password)
		user = self.find_by_email(submitted_email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end
	
	# for session authenticates with salt instead of password
	def self.authenticate_with_salt(id, cookie_salt)
	  user = find_by_id(id)
	  (user && user.salt == cookie_salt) ? user : nil
	end
	
	# returns true if a relationship exists for a supplied user
	def following?(followed)
	  relationships.find_by_followed_id(followed) # assumes id
    end
	
	# creates a new following, 
    def follow!(followed)
     	relationships.create!(:followed_id => followed.id)
    end
	
	# deletes a following
	def unfollow!(followed)
	   relationships.find_by_followed_id(followed).destroy
	end
	
	# returns a feed for a usrs id
	def feed
		Micropost.from_users_followed_by(self)
	end
	
	#################
	private
	#################
	
	def encrypt_password
      self.salt = make_salt if new_record? # if this is a new record i.e. not saved to the database
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}") # analogous to self.salt
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
	
end
