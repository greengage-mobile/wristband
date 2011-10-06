class WristbandGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../../../..', __FILE__) 
  
  def generate_models
    puts "\t== Models =="
    copy_file 'app/models/user.rb', 'app/models/user.rb'
    copy_file 'app/models/session_user.rb', 'app/models/session_user.rb'
  end

  def generate_controllers
    puts "\t== Controllers =="
    copy_file 'app/controllers/users_controller.rb', 'app/controllers/users_controller.rb'
    copy_file 'app/controllers/sessions_controller.rb', 'app/controllers/sessions_controller.rb'
    copy_file 'app/controllers/passwords_controller.rb', 'app/controllers/passwords_controller.rb'
  end

  def generate_views
    puts "\t== Views =="
    copy_file 'app/views/users/show.html.erb', 'app/views/users/show.html.erb'
    copy_file 'app/views/sessions/new.html.erb', 'app/views/sessions/new.html.erb'
    copy_file 'app/views/passwords/new.html.erb', 'app/views/passwords/new.html.erb'
    copy_file 'app/views/passwords/edit.html.erb', 'app/views/passwords/edit.html.erb'
  end
  
  def generate_user_mailer
    puts "\t== User Mailer =="
    copy_file 'app/mailers/user_mailer.rb', 'app/mailers/user_mailer.rb'
    copy_file'app/views/user_mailer/password_reset.html.erb', 'app/views/user_mailer/password_reset.html.erb'
    copy_file 'app/views/user_mailer/password_reset.text.erb', 'app/views/user_mailer/password_reset.text.erb'
  end

  def generate_tests
    puts "\t== Test helper and Dummies =="
    copy_file 'test/test_helper.rb', 'test/test_helper.rb'
    copy_file 'test/dummy/user.rb', 'test/dummy/user.rb'
    
    puts "\t== Unit tests =="
    copy_file 'test/unit/user_test.rb', 'test/unit/user_test.rb'
    copy_file 'test/unit/session_user_test.rb', 'test/unit/session_user_test.rb'
    copy_file 'test/unit/user_mailer_test.rb', 'test/unit/user_mailer_test.rb'
    
    puts "\t== Functional tests =="
    copy_file 'test/functional/sessions_controller_test.rb', 'test/functional/sessions_controller_test.rb'
    copy_file 'test/functional/passwords_controller_test.rb', 'test/functional/passwords_controller_test.rb'
  end
  
  def generate_migration
    puts "\t== Migration =="
    destination   = File.expand_path('db/migrate/01_create_users_table.rb', self.destination_root)
    migration_dir = File.dirname(destination)
    destination   = self.class.migration_exists?(migration_dir, 'create_users_table')
  
    if destination
      puts "\e[0m\e[31mFound existing create_users_table.rb migration. Remove it if you want to regenerate.\e[0m"
    else
      migration_template 'db/migrate/01_create_users_table.rb', 'db/migrate/create_users_table.rb'
    end
  end
  
  def self.next_migration_number(dirname)
    orm = Rails.configuration.generators.options[:rails][:orm]
    require "rails/generators/#{orm}"
    "#{orm.to_s.camelize}::Generators::Base".constantize.next_migration_number(dirname)
  end
end
