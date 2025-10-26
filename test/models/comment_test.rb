require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @movie = movies(:one)
    @comment = Comment.new(
      content: "Great movie!",
      user: @user,
      movie: @movie
    )
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "content should be present" do
    @comment.content = "   "
    assert_not @comment.valid?
  end

  test "should belong to user" do
    assert_respond_to @comment, :user
  end

  test "should belong to movie" do
    assert_respond_to @comment, :movie
  end

  test "user should be present" do
    @comment.user = nil
    @comment.name = nil  # Anonymous comments need a name
    assert_not @comment.valid?
  end

  test "movie should be present" do
    @comment.movie = nil
    assert_not @comment.valid?
  end
end
