class AddEmailUniquenessIndex < ActiveRecord::Migration
  def change
  	add_index :users, :email, :unique => true #db indexing for unique 
  end
end
