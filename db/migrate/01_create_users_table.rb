class CreateUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :password_salt
      t.string :session_token
      t.string :perishable_token
      t.string :role
      t.timestamps
      # --- Other useful fields ---
      # t.string :first_name
      # t.string :last_name
      # t.string :address
      # t.string :city
      # t.string :state
      # t.string :zip
      # t.string :ip
    end
    add_index :users, :email
    add_index :users, :perishable_token
    add_index :users, :session_token
  end
  
  def self.down
    drop_table :users
  end
end
