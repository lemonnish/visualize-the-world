require 'test_helper'

class MapCreateTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lauren)
  end

  test "valid map creation" do
    log_in_as @user
    get new_map_path
    assert_template 'maps/new'
    assert_select 'form[action="/maps"]'
    title = "New map"
    blurb = "This is a brave new map"
    assert_difference '@user.maps.count', 1 do
      post maps_path, params: { map: { title: title, privacy_public: true, blurb: blurb } }
    end
    map = assigns(:map)
    assert_redirected_to edit_map_path(map)
    follow_redirect!
    assert_template 'maps/edit'

    map.reload
    assert_equal title, map.title
    assert map.privacy_public
    assert_equal blurb, map.blurb

    title = "New map - private"
    assert_difference '@user.maps.count', 1 do
      post maps_path, params: { map: { title: title, privacy_public: false } }
    end
    map_private = assigns(:map)
    assert_redirected_to edit_map_path(map_private)
    map_private.reload
    assert_equal title, map_private.title
    assert_not map_private.privacy_public
    assert map_private.blurb.blank?
  end

  test "invalid map creation" do
    log_in_as @user
    assert_no_difference '@user.maps.count' do
      post maps_path, params: { map: { title: "", privacy_public: false } }
    end
    assert_template 'maps/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 2
  end

  test "invalid map creation for logged out user" do
    get new_map_path
    assert_redirected_to login_path

    assert_no_difference 'Map.count' do
      post maps_path, params: { map: { title: "New map", privacy_public: false } }
    end
    assert_redirected_to login_path
  end
end
