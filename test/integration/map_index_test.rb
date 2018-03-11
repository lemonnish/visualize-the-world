require 'test_helper'

class MapIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lauren)
    @other_user = users(:jake)
  end

  test "should not display other user maps" do
    log_in_as(@other_user)
    assert_redirected_to root_path
    get maps_path
    assert_template 'maps/index'
    @user.maps.each do |map|
      assert_match "a[href=?]", map_path(map), count: 0
    end
  end

  test "should display users maps" do
    log_in_as(@user)
    assert_redirected_to root_path
    get maps_path
    @user.maps.each do |map|
      assert_match "a[href=?]", map_path(map)
    end
  end
end
