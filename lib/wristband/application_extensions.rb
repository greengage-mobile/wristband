module Wristband
  module ApplicationExtensions
    def self.included(base)
      base.send(:extend, Wristband::ApplicationExtensions::ClassMethods)
      base.send(:include, Wristband::ApplicationExtensions::InstanceMethods)
      base.send(:helper_method, :logged_in?, :current_user) if base.respond_to?(:helper_method)
    end

    module ClassMethods
      # ...
    end

    module InstanceMethods
      def login(session_user, cookie_expires_at = 2.weeks.from_now.utc)
        login_as_user(session_user.user, session_user.remember_me, cookie_expires_at)
      end
      
      def login_as_user(user, remember_me=false, cookie_expires_at = 2.weeks.from_now.utc)
        self.current_user = user
        if remember_me
          token = Support.encrypt_with_salt(user.id.to_s, Wristband::Support.random_salt, ::User.wristband[:encryption_type])
          cookies[:login_token] = { :value => token, :expires => cookie_expires_at}
          user.update_attribute(:remember_token, token)
        end
      end
  
      # Logs a user out and deletes the remember_token.
      def logout
        current_user.update_attribute(:remember_token, nil) if current_user
        self.current_user = nil
        cookies.delete(:login_token)    
        reset_session
      end  
    
      # Returns true if a user is logged in
      def logged_in?
        !!current_user
      end
    
      # Returns the current user in session. Use this on your views and controllers.
      def current_user
        @current_user ||= (session[:user_id] and ::User.find_by_id(session[:user_id]))
      end

      # Sets the current user in session
      def current_user=(user)
        @current_user = user
        session[:user_id] = (user and user.id)
      end
    
      # Logs a user automatically from his cookie
      #
      # You can use this function as a before filter on your controllers.
      def login_from_cookie
        return if (logged_in? or !cookies[:login_token])
        self.current_user = ::User.find_by_remember_token(cookies[:login_token])
      end
    
      # You can use this function as a before filter on your controllers that require autentication.
      #
      # If the user is not logged in +respond_not_logged_in+ will be called.
      def login_required
        logged_in?
      end
    
    end
  end
end