require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "validations" do
    assert !User.new().save, "Saved user with no name and username"

    assert !User.new(:name => "Test").save, "Saved user with no username"

    assert !User.new(:username => "Test").save, "Saved user with no name"

    assert User.new(:username => "jdoe", :name => "John Doe").save, "Could not save user"

    assert !User.new(:username => "jdoe", :name => "Jane Doe").save, "Saved duplicate username"

    assert !User.new(:username => "doe", :name => "John Doe").save, "Saved duplicate name"

  end
end
