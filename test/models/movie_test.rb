require "test_helper"

class MovieTest < ActiveSupport::TestCase
  def setup
    @movie = Movie.new(
      title: "Test Movie",
      director: "Test Director",
      year: 2023,
      duration: 120,
      synopsis: "Test synopsis",
      user: users(:one)
    )
  end

  test "should be valid" do
    assert @movie.valid?
  end

  test "title should be present" do
    @movie.title = ""
    assert_not @movie.valid?
  end

  test "year should be present" do
    @movie.year = nil
    assert_not @movie.valid?
  end

  test "director should be present" do
    @movie.director = nil
    assert_not @movie.valid?
  end

  test "should belong to user" do
    assert_respond_to @movie, :user
  end

  test "should have many comments" do
    assert_respond_to @movie, :comments
  end

  test "should have one attached poster" do
    assert_respond_to @movie, :poster
  end
end
