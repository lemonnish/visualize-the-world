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
    assert_difference '@user.maps.count', 1 do
      post maps_path, params: { map: { title: "New map", public: true } }
    end
    @map = assigns(:map)
    assert_redirected_to edit_map_path(@map)
    follow_redirect!
    assert_template 'maps/edit'
  end

  test "invalid map creation" do
    log_in_as @user
    assert_no_difference '@user.maps.count' do
      post maps_path, params: { map: { title: "", public: false } }
    end
    assert_template 'maps/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 2
  end

  test "invalid map creation for logged out user" do
    get new_map_path
    assert_redirected_to login_path

    assert_no_difference 'Map.count' do
      post maps_path, params: { map: { title: "New map", public: false } }
    end
    assert_redirected_to login_path
  end
end
