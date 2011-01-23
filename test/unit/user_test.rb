require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def test_create_defaults
    user = User.new(
      :email => 'user@example.com',
      :password => 'tester',
      :password_confirmation => 'tester'
    )
    user.role = :admin
    user.save
    assert_created user
  end

  def test_create_requirements
    user = User.create
  
    assert_errors_on user, :email, :password, :role
    assert user.errors[:email].include?("Please enter your email address")
    assert user.errors[:email].include?("The email address you entered is not valid")
    assert user.errors[:email].include?("The email address you entered is to short")
    assert user.errors[:password].include?("Please choose a password")
    assert user.errors[:password].include?("The password you entered is too short (minimum is 4 characters)")
    assert user.errors[:role].include?("can't be blank")
    assert user.errors[:role].include?("is not included in the list")
  end

  def test_create_dummy
    user = a User
    assert_created user
  end
  
  def test_user_instance_methods
    @user = a User
    %w{
      has_authority_to?
      has_objections_to?
      initialize_salt
      initialize_token
      encrypt_password
      password_match?
      password_crypted?
      password_crypt=
      is_admin?
      is_regular_user?
    }.each do |method|
      assert @user.respond_to?(method), "On '#{method}' method"
    end
  end

  def test_user_class_methods
    @user = a User
    %w{
      authenticate
      execute_authentication_chain
      verify_email!
      wristband
    }.each do |method|
      assert User.respond_to?(method), "On '#{method}' method"
    end
  end

  def test_user_class_private_methods
    %w{
      random_string
      encrypt_with_salt
      random_salt
    }.each do |method|
      assert User.private_methods.include?(method), "On '#{method}' method"
    end
  end

  def test_assigned_options
    assert_equal User.wristband[:login_with_fields], [:email]
    assert_equal User.wristband[:before_authentication_chain], []
    assert_equal User.wristband[:after_authentication_chain], []
    assert_equal User.wristband[:password_column], :password_crypt
    assert_equal User.wristband[:roles], [:admin, :regular_user]
  end
  
  def test_authentication_by_email
    @user = a User
    assert_equal @user, User.authenticate(@user.email, 'passpass')
  end

  def test_authentication_fails
    @user = a User
    assert_nil User.authenticate('-bugus-', 'passpass')
    assert_nil User.authenticate(@user.email, '-bugus-')
  end
  
  def test_password_match
    @user = a User
    assert @user.password_match?('passpass')
  end
  
  def test_user_roles
    @user = a User
    @user.update_attribute(:role, :regular_user)
    assert @user.is_regular_user?
    @user.update_attribute(:role, :admin)
    assert @user.is_admin?
  end
end