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
