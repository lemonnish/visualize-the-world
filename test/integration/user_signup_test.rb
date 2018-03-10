require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest

  test "invalid signup" do
    get signup_path
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { email: "user@invalid",
                                          password: "foo",
                                          password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors', 6
  end

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not flash.empty?
    assert logged_in?
  end
end
