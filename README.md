# Wristband

A lightweight solution for two major pains: **User authentication** and **Permissions**.

Summary:

* Login and logout
* Password storage with bcrypt
* Password recovery
* Remember me
* Authority definitions
* Convert from old MD5 passwords
* Extra : easy to use sample models and controlers to get you started!

---
  
## Quick start

### 1. Add gem definition to your Gemfile:
    
    config.gem 'wristband'
    
### 2. From within your Rails project run:
    
    bundle install


### 3. In your User model

    class User < ActiveRecord::Base
      wristband
    end

### 4. Run the generator for the sample models and controllers

    rails g wristband

### 4. Run the migrations

    rake db:migrate


---

## Configuration

### Options:

**:login_with** - Array of fields you want to authenticate the user with. *Default: `:email`*
  
    wristband :login_with => [:username, :email]


**:before_authentication** - Array of functions run after the user authentication takes place. *Default: `[]`*

    wristband :before_authentication => :do_something


**:after_authentication** - Array of functions run before the user authentication takes place. *Default: `[]`*

    wristband :after_authentication => :do_something

**:roles** - Use this to define the different roles the user can assume. Make sure you have a role column on your users table. It will generate functions like `is_<role>?` for each one of the roles you define.
  
    wristband :roles => [:regular_user, :admin]
  
This will give you `user.is_regular_user?` and `user.is_admin?`


**:has_authorities** - The different user authorities are defined in a separate class so as to reduce clutter in the User model itself. *Default: `false`*

    wristband :has_authorities => true

Look for more details below.

**:legacy_password** - Helps you convert from old legacy passwords to proper encryption passwords. *Default: `[]`*

Indicate the name of the column with the old passwords and the encryption type.

    wristband :legacy_password => {:column_name => :old_password, :encryption => :md5}


**:encryption_type** - Allows you to use the less secure SHA1 instead of BCRYPT for backwards compatibility. *Default: `:bcrypt`*

    wristband :encryption_type => :sha1


---

## Generators
  
Wristband comes with a generator that provides you with all the files you need to get started

    rails g wristband

This will output something like:

    == Models ==
    create  app/models/user.rb
    create  app/models/session_user.rb
    == Controllers ==
    create  app/controllers/users_controller.rb
    create  app/controllers/sessions_controller.rb
    create  app/controllers/passwords_controller.rb
    == Views ==
    create  app/views/users/show.html.erb
    create  app/views/sessions/new.html.erb
    create  app/views/passwords/new.html.erb
    create  app/views/passwords/edit.html.erb
    == User Mailer ==
    create  app/mailers/user_mailer.rb
    create  app/views/user_mailer/password_reset.html.erb
    create  app/views/user_mailer/password_reset.text.erb
    == Test helper and Dummies ==
    create  test/test_helper.rb
    create  test/dummy/user.rb
    == Unit tests ==
    create  test/unit/user_test.rb
    create  test/unit/session_user_test.rb
    create  test/unit/user_mailer_test.rb
    == Functional tests ==
    create  test/functional/sessions_controller_test.rb
    create  test/functional/passwords_controller_test.rb
    == Migration ==
    create  db/migrate/20110123214541_create_users_table.rb

### Database configuration

The basic columns are defined as such:

    create_table :users do |t|
      t.string :email
      t.string :encrypted_password, :limit => 40
      t.string :password_salt,  :limit => 40
      t.string :perishable_token
      t.string :remember_token
      t.string :role
      t.timestamps
    end


---
# AuthorityCheck

First you need to tell Wristband that you you want to define permissions for your user:

    class User < ActiveRecord::Base
      wristband :has_authorities => true
    end
  
This will refer to the class `UserAuthorityCheck` for all authority tests, but the name of this module can be defined as required:

    class User < ActiveRecord::Base
      has_authorities => :permissions
    end

That would reference the class `UserPermissions` instead for all tests.

A sample authority checking class is defined as:

    class UserAuthorityCheck < AuthorityCheck
      def wear_shoes?
        unless (@user.name.match(/^a/i))
          fail!("Only people with names that start with 'A' can wear shoes.")
        end
      end
    end

**Note the syntax:** All authority checks are defined as ending with a trailing question mark character.

A check is considered to have passed if

* a call to `allow!` has been made, or
* no calls to `fail!` have been made.

Once defined, the user authorities are checked via a call to a `User` instance:

    user.has_authority_to?(:wear_shoes)

While the `has_authority_to?` method returns only true or false, a call to `has_objections_to?` will return nil on success or any error messages if there is a failure.


## Passing parameters to the authority methods

Any call to these tests may include options in the form of a Hash:

    user.has_authority_to?(:send_message, :text => "Foo bar")
  
These options can be acted upon within the authority check:

    def send_message?
      if (options[:text].match(/foo/i))
        fail!("Messages may not contain forbidden words.")
      end
    end

## Before chains

In addition to defining straight tests, a chain can be defined to run before
any of the tests themselves. This allows certain calls to be over-ruled. For
example:

    before_check :allow_if_admin!
  
    def allow_if_admin!
      if (@user.is_admin?)
        allow!
      end
    end
  
In this case, the 'allow_if_admin!` method will be called before any checks are performed. If the `allow!` method is executed, all subsequent tests are halted and the check is considered to have passed.

Have fun!!

--- 

Wristband is released under the MIT license

Copyright 2009-2011 Jack Neto, Scott Tadman, [The Working Group](http://www.theworkinggroup.ca)