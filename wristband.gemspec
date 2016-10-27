# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: wristband 2.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "wristband".freeze
  s.version = "2.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jack Neto".freeze, "The Working Group Inc".freeze]
  s.date = "2016-10-18"
  s.description = "Provides a starting point for user authentication".freeze
  s.email = "jack@theworkinggroup.ca".freeze
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".DS_Store",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "app/controllers/application_controller.rb",
    "app/controllers/passwords_controller.rb",
    "app/controllers/sessions_controller.rb",
    "app/controllers/users_controller.rb",
    "app/mailers/user_mailer.rb",
    "app/models/session_user.rb",
    "app/models/user.rb",
    "app/views/layouts/application.html.erb",
    "app/views/passwords/edit.html.erb",
    "app/views/passwords/new.html.erb",
    "app/views/sessions/new.html.erb",
    "app/views/user_mailer/password_reset.html.erb",
    "app/views/user_mailer/password_reset.text.erb",
    "app/views/users/show.html.erb",
    "config.ru",
    "config/application.rb",
    "config/boot.rb",
    "config/database.yml",
    "config/environment.rb",
    "config/environments/development.rb",
    "config/environments/production.rb",
    "config/environments/test.rb",
    "config/initializers/wristband.rb",
    "config/locales/en.yml",
    "config/routes.rb",
    "db/migrate/01_create_users_table.rb",
    "lib/generators/wristband/.DS_Store",
    "lib/generators/wristband/wristband_generator.rb",
    "lib/wristband.rb",
    "lib/wristband/application_extensions.rb",
    "lib/wristband/authority_check.rb",
    "lib/wristband/engine.rb",
    "lib/wristband/support.rb",
    "lib/wristband/user_extensions.rb",
    "public/robots.txt",
    "script/rails",
    "test/dummy/user.rb",
    "test/functional/passwords_controller_test.rb",
    "test/functional/sessions_controller_test.rb",
    "test/test_helper.rb",
    "test/unit/has_authorities_test.rb",
    "test/unit/session_user_test.rb",
    "test/unit/user_mailer_test.rb",
    "test/unit/user_test.rb",
    "test/unit/wristband_test.rb",
    "wristband.gemspec"
  ]
  s.homepage = "https://github.com/greengage-mobile/wristband".freeze
  s.rubygems_version = "2.6.7".freeze
  s.summary = "An authentication engine".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      #s.add_runtime_dependency(%q<rails>.freeze, [">= 3.1.0"])
      s.add_runtime_dependency(%q<bcrypt-ruby>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rails>.freeze, [">= 3.1.0"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 3.1.0"])
      s.add_dependency(%q<bcrypt-ruby>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<jeweler>.freeze, [">= 0"])
      s.add_dependency(%q<rails>.freeze, [">= 3.1.0"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 3.1.0"])
    s.add_dependency(%q<bcrypt-ruby>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<jeweler>.freeze, [">= 0"])
    s.add_dependency(%q<rails>.freeze, [">= 3.1.0"])
  end
end

