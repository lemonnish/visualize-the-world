require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lauren)
  end

  test "should not log in invalid user" do
    get login_path
    assert_template 'sessions/new'
    assert_select 'form[action="/login"]'
    assert_not logged_in?
    post login_path, params: { session: { email: '', password: '' } }
    assert_template 'sessions/new'
    assert_not logged_in?
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "should log in then log out" do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'

    delete logout_path
    assert_not logged_in?
    assert_redirected_to root_path
  end
end
