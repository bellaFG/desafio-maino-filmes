require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @movie = movies(:one)
    @comment = comments(:one)
    sign_in @user
  end

  test "should create comment" do
    assert_difference("Comment.count") do
      post movie_comments_url(@movie, locale: :en), params: {
        comment: { content: "Test comment" }
      }
    end
    assert_redirected_to movie_url(@movie, locale: :en)
  end

  test "should destroy comment" do
    assert_difference("Comment.count", -1) do
      delete movie_comment_url(@movie, @comment, locale: :en)
    end
    assert_redirected_to movie_url(@movie, locale: :en)
  end
end
