require "test_helper"

class MoviesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @movie = movies(:one)
    sign_in @user
  end

  test "should get index" do
    get movies_url(locale: :en)
    assert_response :success
  end

  test "should get new" do
    get new_movie_url(locale: :en)
    assert_response :success
  end

  test "should create movie" do
    assert_difference("Movie.count") do
      post movies_url(locale: :en), params: {
        movie: {
          title: "New Movie",
          director: @movie.director,
          duration: @movie.duration,
          synopsis: @movie.synopsis,
          year: @movie.year,
          category_ids: [ @movie.category_ids.first ]
        }
      }
    end
    assert_redirected_to movie_url(Movie.last, locale: :en)
  end

  test "should show movie" do
    get movie_url(@movie, locale: :en)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_url(@movie, locale: :en)
    assert_response :success
  end

  test "should update movie" do
    patch movie_url(@movie, locale: :en), params: { movie: { title: "Updated" } }
    assert_redirected_to movie_url(@movie, locale: :en)
  end

  test "should destroy movie" do
    assert_difference("Movie.count", -1) do
      delete movie_url(@movie, locale: :en)
    end
    assert_redirected_to movies_url(locale: :en)
  end
end
