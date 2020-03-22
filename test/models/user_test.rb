require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user not valid without name" do
    user = User.new
    assert_not user.valid?
    %i[name email].each do |attr|
      assert_equal user.errors.messages[attr], ["can't be blank"]
    end
  end

  test "valid user" do
    user = User.create(name: 'test', email: 'test@example.com')
    assert_not user.id.nil?
    assert_equal user.name, 'test'
    assert_equal user.email, 'test@example.com'
  end

  test "for add_user method if user not there" do
    assert_equal User.where(email: 'test@example.com').count, 0
    user = User.add_user({name: 'test', email: 'test@example.com'})
    assert_equal User.where(email: 'test@example.com').count, 1
  end

  test "for add_user method if user already there" do
    User.create(name: 'test', email: 'test@example.com')
    assert_equal User.where(email: 'test@example.com').count, 1
    user = User.add_user({name: 'test', email: 'test@example.com'})
    assert_equal User.where(email: 'test@example.com').count, 1
  end
end
