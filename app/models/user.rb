class User < ActiveRecord::Base
  
  # == Constants ============================================================
  
  ROLES = %W{admin regular_user}
  
  # == Extensions ===========================================================

  wristband :roles => ROLES

  # == Validations ==========================================================

  validates :email,
    :presence => {:message => 'Please enter your email address'},
    :length => {
      :within => 6..100,
      :too_short => "The email address you entered is too short"
    },
    :format => {
      :with => /^([\w.%-+]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, 
      :message => 'The email address you entered is not valid'
    },
    :uniqueness => {:message => 'This email has already been taken'}
    
  validates :password,
    :length => {
      :within => 4..40,
      :too_short => "The password you entered is too short (minimum is 4 characters)",
      :if => :password_required?
    },
    :presence => { 
      :message => 'Please choose a password',
      :if => :password_required? 
    },
    :confirmation => {:message => "The password you entered does not match with the confirmation"}
    
  validates :role, 
    :inclusion => { :in => ROLES },
    :presence => true

  # == Scopes ===============================================================

  # == Callbacks ============================================================

  # == Class Methods ========================================================

  # == Instance Methods =====================================================

  def password_required?
    self.new_record?
  end
end
