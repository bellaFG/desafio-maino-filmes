require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "unique@example.com",
      password: "password123",
      password_confirmation: "password123",
      name: "Test User"
    )
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "should have many movies" do
    assert_respond_to @user, :movies
  end

  test "should have many imports" do
    assert_respond_to @user, :imports
  end

  test "should have many comments" do
    assert_respond_to @user, :comments
  end
end
