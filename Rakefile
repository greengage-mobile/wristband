require File.expand_path('../config/application', __FILE__)
require 'rake'

Wristband::Application.load_tasks

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = 'wristband'
    gem.summary     = 'An authentication engine'
    gem.description = 'Provides a starting point for user authentication'
    gem.email       = 'jack@theworkinggroup.ca'
    gem.homepage    = 'http://github.com/twg/wristband'
    gem.authors     = ['Jack Neto', 'The Working Group Inc']
    gem.add_dependency('rails', '>=3.1.0')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end