require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", about_path

    assert_select "a[href=?]", example_path
  end

  test "layout links for logged-out user" do
    get root_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
  end

  test "layout links for logged-in user" do
    get root_path
    log_in_as(users(:lauren))
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
  end
end
