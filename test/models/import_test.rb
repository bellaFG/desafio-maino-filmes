require "test_helper"

class ImportTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @import = Import.new(
      user: @user,
      status: :pending
    )
    @import.file.attach(
      io: File.open(Rails.root.join("test/fixtures/files/test.csv")),
      filename: "test.csv",
      content_type: "text/csv"
    )
  end

  test "should be valid" do
    assert @import.valid?
  end

  test "should belong to user" do
    assert_respond_to @import, :user
  end

  test "should have attached file" do
    assert_respond_to @import, :file
  end

  test "should validate file presence" do
    @import.file = nil
    assert_not @import.valid?
  end

  test "should have default status pending" do
    new_import = Import.new
    assert_equal "pending", new_import.status
  end

  test "should have valid status transitions" do
    valid_statuses = [ "pending", "processing", "finished", "failed" ]
    valid_statuses.each do |status|
      @import.status = status
      assert @import.valid?, "#{status} should be a valid status"
    end
  end
end
