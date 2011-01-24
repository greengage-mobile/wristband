module Wristband
  module UserExtensions
    def self.included(base)
      base.send(:extend, Wristband::UserExtensions::ClassMethods)
      base.send(:include, Wristband::UserExtensions::InstanceMethods)
      base.send(:extend, Wristband::Support)
    end

    module ClassMethods
      def authenticate(email, password)
        self.execute_authentication_chain(self, self.wristband[:before_authentication_chain]) == false and return
        user = nil
        wristband[:login_with_fields].find do |field|
          user = send("find_by_#{field}", email) 
        end
        (user and user.password_match?(password)) || return
        self.execute_authentication_chain(user, self.wristband[:after_authentication_chain]) == false  and return
        user
      end
    
      def execute_authentication_chain(object, list)
        list.each do |func|
          case func
          when Symbol,String
            object.send(func) == false and return false
          when Proc
            func.call(object) == false and return false
          end
        end
      end
      
      def roles_for_select
        self.class.wristband[:roles].collect{ |k| [ k.to_s.titleize, k.to_s] }
      end
      
    end

    module InstanceMethods

      def has_authority_to?(action, options = { })
        self.class.wristband[:authority_class].new(self, action, options).allowed_to?
      end

      def has_objections_to?(action, options = { })
        self.class.wristband[:authority_class].new(self, action, options).denied_for_reasons
      end

      def initialize_salt
        self.password_salt = Wristband::Support.random_salt
      end

      def initialize_token
        self.remember_token = Wristband::Support.random_salt(16)
      end
    
      def encrypt_password
        initialize_salt if new_record?
        return if self.password.blank?
        self.send("#{self.class.wristband[:password_column]}=", Wristband::Support.encrypt_with_salt(self.password, self.password_salt))
      end
    
      def password_match?(string)
        self.send(self.class.wristband[:password_column]) == Wristband::Support.encrypt_with_salt(string, self.password_salt)
      end
    
      def password_hash=(value)
        if (value != read_attribute(:password_hash))
          initialize_token
        end
        write_attribute(:password_hash, value)
      end
      
      def reset_perishable_token!
        update_attribute(:perishable_token, Wristband::Support.random_salt.gsub(/[^A-Za-z0-9]/,''))
      end
      
    end
  end
end