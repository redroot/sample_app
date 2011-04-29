class Relationship < ActiveRecord::Base
	attr_accessible :followed_id # users can only access who they want to follow, cant add their own followers
								 # e.g. we can do user.relationships.create({followed_id => ...});
								 
	belongs_to :follower, :class_name => "User" # explicityl stateing class name so its doesnt look for a rfollower model
	belongs_to :followed, :class_name => "User"
	
	validates :follower_id, :presence => true
	validates :followed_id, :presence => true
end
