class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :email, :unique => true # within database check to ensure uniqueness rahter than relying on the model
  end

  def self.down
    remove_index :users, :email
  end
end
