class CreateUsersTable < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :email_validation_key
      t.datetime :validated_at
      t.string :password_crypt, :limit => 40
      t.string :password_salt,  :limit => 40
      t.string :remember_token
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
  end
  
  def self.down
    drop_table :users
  end
end
