require "application_system_test_case"

class MoviesTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @user = users(:one)
    login_as(@user, scope: :user)
    @movie = Movie.create!(
      title: "Test Movie",
      director: "Test Director",
      year: 2023,
      duration: 120,
      synopsis: "Test synopsis",
      user: @user
    )
  end

  teardown do
    Warden.test_reset!
  end

  test "visiting the index" do
    visit movies_url(locale: :en)
    assert_selector "h2", text: I18n.t("movies.index.title")
  end

  test "creating a Movie" do
    visit movies_url(locale: :en)
    click_on I18n.t("movies.index.add_new")

    fill_in Movie.human_attribute_name("title"), with: "New Movie"
    fill_in Movie.human_attribute_name("director"), with: "New Director"
    fill_in Movie.human_attribute_name("year"), with: 2024
    fill_in Movie.human_attribute_name("duration"), with: 130
    fill_in Movie.human_attribute_name("synopsis"), with: "New synopsis"
    
    click_on I18n.t("helpers.submit.create")

    assert_text I18n.t("movies.notices.created")
  end

  test "updating a Movie" do
    visit movies_url(locale: :en)
    click_on I18n.t("movies.index.edit"), match: :first

    fill_in Movie.human_attribute_name("title"), with: "Updated Movie"
    click_on I18n.t("helpers.submit.update")

    assert_text I18n.t("movies.notices.updated")
  end

  test "showing a Movie" do
    visit movies_url(locale: :en)
    click_on I18n.t("movies.index.view_details"), match: :first

    assert_selector "h1", text: @movie.title
    assert_text @movie.synopsis
  end

  test "destroying a Movie" do
    visit movies_url(locale: :en)

    accept_confirm do
      click_on I18n.t("movies.index.delete"), match: :first
    end

    assert_text I18n.t("movies.notices.destroyed")
  end
end
