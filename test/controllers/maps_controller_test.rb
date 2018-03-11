require 'test_helper'

class MapsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @map = maps(:basic_public)
    @map_private = maps(:basic_private)
  end

  test "should redirect get requests when not logged in" do
    get maps_path
    assert_redirected_to login_path

    get map_path(@map_private)
    assert_redirected_to login_path

    get edit_map_path(@map_private)
    assert_redirected_to login_path

    get new_map_path
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Map.count' do
      delete map_path(@map)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy for wrong map" do
    log_in_as(users(:jake))
    assert_no_difference 'Map.count' do
      delete map_path(@map)
    end
    assert_redirected_to root_path
  end
end
