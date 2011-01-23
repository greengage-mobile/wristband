# Wristband
Author: [The Working Group](http://www.theworkinggroup.ca)

---

## What is it?

Wristband provides a starting point for user authentication.

It handles:

* Login and logout
* Password storage with encryption
* Remember me functionality
* Authority definitions
  
  
## Usage

### 1. Add gem definition to your Gemfile:
    
    config.gem 'wristband'
    
### 2. From withing your Rails project run:
    
    bundle install

### 3. (optional) Run the wristband generator:

    rails g wristband

This will output something like:

    create  app/models/user.rb
    create  app/models/session_user.rb
    create  app/controllers/users_controller.rb
    create  app/controllers/sessions_controller.rb
    create  app/views/users/show.html.haml
    create  app/views/sessions/new.html.haml
    create  app/mailers/user_mailer.rb
    create  app/views/user_mailer/forgot_password.text.html.rhtml
    create  app/views/user_mailer/forgot_password.text.plain.rhtml
    create  app/views/user_mailer/email_verification.text.html.rhtml
    create  app/views/user_mailer/email_verification.text.plain.rhtml
    create  db/migrate/20110123214541_create_users_table.rb

### 4. (optional) Run migrations:

    rake db:migrate


## Configuration


### In your User model

    class User < ActiveRecord::Base
      wristband [options]
    end

### Options:

**:login_with** - Array of fields you want to authenticate the user with. Default: email 
  
    wristband :login_with => [:username, :email]


**:before_authentication** - Array of functions run after the user authentication takes place. Default: [] 

    wristband :before_authentication => :do_something


**:after_authentication** - Array of functions run before the user authentication takes place. Default: [] 

    wristband :after_authentication => :do_something


**:has_authorities** - The different user authorities are defined in a separate class so as to reduce clutter in the User model itself. Default: false 

    wristband :has_authorities => true

**:roles** - Use this to define the different roles the user can assume. Make sure you have a role column on your users table. It will generate functions like `is_<role>?` for each one of the roles youdefine.
  
    wristband :roles => [:regular_user, :admin]
  
  will generate `user.is_regular_user?` and `user.is_admin?`



## Notes

1. **Remember me** - If you want to automatically login a user when he comes back to your site, add `before_filter :login_from_cookie` to your AplicationController.
2. **Authority Definitions** - Checkout the documentation on wristband/authority_check_rb


## Database configuration

The generator gives you a head start.
The basic columns are defined as such:

    create_table :users do |t|
      t.string :email
      t.string :email_validation_key
      t.datetime :validated_at
      t.string :password_crypt, :limit => 40
      t.string :password_salt,  :limit => 40
      t.string :remember_token
      t.string :role
      t.timestamps
    end


Have fun!!