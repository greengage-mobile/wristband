require 'test_helper'

class WristbandTest < ActiveSupport::TestCase
  
  def test_user_instance_methods
    @user = a User
    %w{
      has_authority_to?
      has_objections_to?
      initialize_salt
      initialize_token
      encrypt_password
      encrypted_password=
      password_match?
      matches_legacy_password?
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
      assert User.private_methods.include?(method.to_sym), "On '#{method}' method"
    end
  end

  def test_assigned_options
    assert_equal User.wristband[:login_with_fields], [:email]
    assert_equal User.wristband[:before_authentication_chain], []
    assert_equal User.wristband[:after_authentication_chain], []
    assert_equal User.wristband[:password_column], :encrypted_password
    assert_equal User.wristband[:roles], ['admin', 'regular_user']
    assert_equal User.wristband[:legacy_password], {}
    assert_equal User.wristband[:encryption_type], :bcrypt
  end
  
  def test_authentication_by_email
    @user = a User
    assert_equal @user, User.authenticate(@user.email, @user.password)
  end

  def test_authentication_fails
    @user = a User
    assert_nil User.authenticate('-bugus-', @user.password)
    assert_nil User.authenticate(@user.email, '-bugus-')
  end
  
  def test_password_match
    @user = a User
    assert @user.password_match?('password')
  end
  
  def test_user_roles
    @user = a User
    @user.update_attribute(:role, 'regular_user')
    assert @user.is_regular_user?
    @user.update_attribute(:role, 'admin')
    assert @user.is_admin?
  end
end