if defined?(Rails)
  require File.expand_path('wristband/engine', File.dirname(__FILE__))
end


require 'wristband/user_extensions'
require 'wristband/support'
require 'wristband/application_extensions'
require 'wristband/authority_check'
require 'active_record'

module Wristband
  
  class << self
    def included base #:nodoc:
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def wristband(options={})
      options[:login_with]            ||= [:email]
      options[:before_authentication] ||= []
      options[:after_authentication]  ||= []
      options[:has_authorities]       ||= false
      options[:roles]                 ||= []
      options[:legacy_password]       ||= {}
      options[:encryption_type]       ||= :bcrypt

      class_eval do
        include Wristband::UserExtensions
        
        options[:password_column] ||= :encrypted_password
        
        # These two are used on the login form
        attr_accessor :password
        attr_accessor :password_confirmation
        
        before_save :encrypt_password
        
        # Add roles
        unless options[:roles].blank?
          options[:roles].each do |role|
            define_method "is_#{role}?" do
              self.role.to_s == role.to_s
            end
          end
        end
        
        class << self
          attr_accessor :wristband
        end
      end
      
      self.wristband = {
        :login_with_fields            => [options[:login_with]].flatten,
        :before_authentication_chain  => [options[:before_authentication]].flatten,
        :after_authentication_chain   => [options[:after_authentication]].flatten,
        :password_column              => options[:password_column],
        :roles                        => options[:roles],
        :legacy_password              => options[:legacy_password],
        :encryption_type              => options[:encryption_type]
      }
      
      if options[:has_authorities]
        self.wristband[:authority_class] = UtilityMethods.interpret_class_specification(self, options[:has_authorities])
      end
    end    
  end
  
  module UtilityMethods
    def self.interpret_class_specification(model_class, with_class)
      case (with_class)
      when Symbol
        "#{model_class.class_name}#{with_class.to_s.camelcase}".constantize
      when String
        with_class.constantize
      when true
        "#{model_class.name}AuthorityCheck".constantize
      else
        with_class
      end
    end
  end
  
end

ActiveRecord::Base.send(:extend, Wristband::ClassMethods)

if defined?(ActionController)
  ActionController::Base.send(:include, Wristband::ApplicationExtensions)
end
