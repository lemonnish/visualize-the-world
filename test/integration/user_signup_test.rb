require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

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

  test "valid signup with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not flash.empty?
    assert_not logged_in?
    # try to log in before activation
    log_in_as(user)
    assert_not logged_in?
    # invalid activation token, valid email
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not logged_in?
    # valid token, invalid email
    get edit_account_activation_path(user.activation_token, email: "wrongEmail")
    assert_not logged_in?
    # valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not flash.empty?
    assert logged_in?
  end
end
