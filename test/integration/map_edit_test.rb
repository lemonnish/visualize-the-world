require 'test_helper'

class MapEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lauren)
    @map = maps(:basic_public)
    @old_title = @map.title
    @old_privacy_public = @map.privacy_public
    @old_blurb = @map.blurb
    @old_projection = @map.projection
  end

  test "unsuccessful map update" do
    log_in_as @user
    get edit_map_path(@map)
    assert_template 'maps/edit'
    assert_select 'form[action=?]', "/maps/#{ @map.id }"

    patch map_path(@map), params: { map: { title: "", privacy_public: nil, blurb: "hi there" } }
    assert_template 'maps/edit'
    assert_select 'div#error_explanation'
    @map.reload
    assert_equal @old_title, @map.title
    assert_equal @old_privacy_public, @map.privacy_public
    assert_equal @old_blurb, @map.blurb

    patch map_path(@map), params: { map: { title: "Hi There", blurb: "hi there",
                          privacy_public: false }, commit: "Cancel" }
    assert_redirected_to edit_map_path(@map)
    @map.reload
    assert_equal @old_title, @map.title
    assert_equal @old_privacy_public, @map.privacy_public
    assert_equal @old_blurb, @map.blurb
  end

  test "successful map update" do
    log_in_as @user
    title = "Here's some fancy new title"
    blurb = "Here's something you didn't know about the map!"
    projection = Map.projections.keys[2].to_s
    patch map_path(@map), params: { map: { title: title, privacy_public: false,
                                           blurb: blurb, projection: projection } }
    assert_redirected_to edit_map_path(@map)
    follow_redirect!
    assert_template 'maps/edit'
    @map.reload
    assert_equal title, @map.title
    assert_not @map.privacy_public
    assert_equal blurb, @map.blurb
    assert_not_equal projection, @old_projection
    assert_equal projection, @map.projection
  end

  test "should not be able to edit example_map from form" do
    log_in_as @user
    assert_not @map.example_map?
    patch map_path(@map), params: { map: { example_map: true } }
    @map.reload
    assert_not @map.example_map?

    example_map = maps(:example)
    assert example_map.example_map?
    patch map_path(example_map), params: { map: { example_map: false } }
    example_map.reload
    assert example_map.example_map?
  end

  test "should redirect logged out user" do
    get edit_map_path(@map)
    assert_redirected_to login_path

    patch map_path(@map), params: { map: { title: "Some title", privacy_public: false } }
    assert_redirected_to login_path
  end
end
