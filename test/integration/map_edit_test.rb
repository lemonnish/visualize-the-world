require 'test_helper'

class MapEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lauren)
    @map = maps(:basic_public)
    @old_title = @map.title
    @old_privacy_public = @map.privacy_public
  end

  test "unsuccessful map update" do
    log_in_as @user
    get edit_map_path(@map)
    assert_template 'maps/edit'
    assert_select 'form[action="/maps"]'

    patch map_path(@map), params: { map: { title: "", privacy_public: nil } }
    assert_template 'maps/edit'
    assert_select 'div#error_explanation'
    @map.reload
    assert_equal @old_title, @map.title
    assert_equal @old_privacy_public, @map.privacy_public
  end

  test "successful map update" do
    log_in_as @user
    title = "Here's some fancy new title"
    patch map_path(@map), params: { map: { title: title, privacy_public: false } }
    assert_redirected_to edit_map_path
    assert_template 'maps/edit'
    @map.reload
    assert_equal title, @map.title
    assert_not @map.privacy_public
  end

  test "should redirect logged out user" do
    get edit_map_path(@map)
    assert_redirected_to login_path

    patch map_path(@map), params: { map: { title: "Some title", privacy_public: false } }
    assert_redirected_to login_path
  end
end
