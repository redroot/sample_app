class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
	  add_index :relationships, :follower_id # indexes add to improve searh speed
	  add_index :relationships, :followed_id # as above'
	  add_index :relationships, [:follower_id, :followed_id], :unique => true # composite index ensuring each uniqueness of pairs
	end

  def self.down
    drop_table :relationships
  end
end
