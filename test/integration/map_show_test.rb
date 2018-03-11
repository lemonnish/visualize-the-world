require 'test_helper'

class MapShowTest < ActionDispatch::IntegrationTest

  def setup
    @map = maps(:basic_public)
    @map_private = maps(:basic_private)
    @user = users(:lauren)
    @other_user = users(:jake)
  end

  test "should allow anyone to view public maps" do
    get map_path(@map)
    assert_template 'maps/show'
    assert_select 'a[href=?]', edit_map_path, count: 0
    assert_select "title", full_title_t(@map.title)
    assert_select "body h1", @map.title

    log_in_as @other_user
    get map_path(@map)
    assert_template 'maps/show'
    assert_select 'a[href=?]', edit_map_path, count: 0
    log_out

    log_in_as @user
    get map_path(@map)
    assert_template 'maps/show'
    assert_select 'a[href=?]', edit_map_path
  end

  test "should restrict viewing of private maps" do
    get map_path(@map_private)
    assert_redirected_to login_path
    assert_not flash.empty?

    log_in_as @other_user
    get map_path(@map_private)
    assert_redirected_to root_path
    assert_not flash.empty?
  end
end
