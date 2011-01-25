require 'test_helper'

class NewUserAuthorityCheck < AuthorityCheck
  before_check :is_admin?
  
  def is_admin?
    unless (@user.email.match(/^scott/i))
      fail!("Only scott can be an admin.")
    else
      allow!
    end    
  end
  
  def wear_shoes?
    unless (@user.email.match(/^s/i))
      fail!("Only people with emails that start with 'S' can wear shoes.")
    end
  end

  def walk_outside?
    wear_shoes?
    unless (@user.email.match(/^j/i))
      fail!("Only people with emails that start with 'J' or 'S' can walk outside.")
    end
  end
  
end

class NewUser < ActiveRecord::Base
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :email
  column :password_hash
  column :password_salt
  column :role

  wristband :has_authorities => true
end


class HasAuthoritiesTest < ActiveSupport::TestCase

  def test_has_authority_to_with_fail
    scott = NewUser.new(
      :email => 'scott@example.com',
      :password => 'tester',
      :password_confirmation => 'tester',
      :role => :admin
    )
    jack = NewUser.new(
      :email => 'jack@example.com',
      :password => 'tester',
      :password_confirmation => 'tester',
      :role => :admin
    )
    oleg = NewUser.new(
      :email => 'oleg@example.com',
      :password => 'tester',
      :password_confirmation => 'tester',
      :role => :admin
    )


    assert scott.has_authority_to?(:wear_shoes)
    assert !jack.has_authority_to?(:wear_shoes)
    assert_equal jack.has_objections_to?(:wear_shoes), ["Only scott can be an admin.", "Only people with emails that start with 'S' can wear shoes."]
    
    
    assert scott.has_authority_to?(:walk_outside)
    assert !jack.has_authority_to?(:walk_outside)
    assert_equal jack.has_objections_to?(:walk_outside), ["Only scott can be an admin.", "Only people with emails that start with 'S' can wear shoes."]
    assert !oleg.has_authority_to?(:walk_outside)
    assert_equal oleg.has_objections_to?(:walk_outside), ["Only scott can be an admin.", "Only people with emails that start with 'S' can wear shoes.", "Only people with emails that start with 'J' or 'S' can walk outside."]
  end
end
