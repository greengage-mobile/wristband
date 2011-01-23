class WristbandGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../../../..', __FILE__) 
  
  def generate_models
    copy_file 'app/models/user.rb', 'app/models/user.rb'
    copy_file 'app/models/session_user.rb', 'app/models/session_user.rb'
  end

  def generate_controllers
    copy_file 'app/controllers/users_controller.rb', 'app/controllers/users_controller.rb'
    copy_file 'app/controllers/sessions_controller.rb', 'app/controllers/sessions_controller.rb'
  end

  def generate_views
    copy_file 'app/views/users/show.html.haml', 'app/views/users/show.html.haml'
    copy_file 'app/views/sessions/new.html.haml', 'app/views/sessions/new.html.haml'
    
  end
  def generate_user_mailer
    copy_file 'app/mailers/user_mailer.rb', 'app/mailers/user_mailer.rb'
    copy_file 'app/views/user_mailer/forgot_password.text.html.rhtml', 'app/views/user_mailer/forgot_password.text.html.rhtml'
    copy_file 'app/views/user_mailer/forgot_password.text.plain.rhtml', 'app/views/user_mailer/forgot_password.text.plain.rhtml'
    copy_file 'app/views/user_mailer/email_verification.text.html.rhtml', 'app/views/user_mailer/email_verification.text.html.rhtml'
    copy_file 'app/views/user_mailer/email_verification.text.plain.rhtml', 'app/views/user_mailer/email_verification.text.plain.rhtml'
  end

  def generate_migration
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
  
  # def generate_routes
  #   route "get '/login', :to => 'sessions#new'"
  #   route "post '/login', :to => 'sessions#create'"
  #   route "get '/logout', :to => 'sessions#destroy'"
  #   route "match '/forgot_password', :to => 'users#forgot_password'"
  #   route "resources :users"
  #   route "match '/register', :to => 'users#new'"
  # end
  
end
