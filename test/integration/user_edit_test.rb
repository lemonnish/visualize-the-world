require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lauren)
    @old_email = @user.email
  end

  test "successful edit of email" do
    log_in_as(@user)
    get edit_user_path
    assert_template 'users/edit'
    patch user_path, params: { user: { email: "bar@example.com" } }
    assert_redirected_to user_path
    follow_redirect!
    assert_not flash.empty?
    assert_equal "bar@example.com", @user.reload.email
  end

  test "successful edit of password" do
    log_in_as(@user)
    get edit_user_path
    assert @user.authenticate("password")
    patch user_path, params: { user: { email: @old_email,
                                       old_password: "password",
                                       password: "foobar",
                                       password_confirmation: "foobar" } }
    assert_redirected_to user_path
    follow_redirect!
    assert_not flash.empty?
    assert @user.reload.authenticate("foobar")
  end

  test "invalid old password should fail edit password" do
    log_in_as(@user)
    get edit_user_path
    assert @user.authenticate("password")
    patch user_path, params: { user: { email: "bar@example.com",
                                       old_password: "foobar",
                                       password: "barbaz",
                                       password_confirmation: "barbaz" } }
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_match 'The form contains 1 error.', response.body
    @user.reload
    assert @user.authenticate("password")
    assert_equal @old_email, @user.email
  end

  test "non-valid new passwords should fail edit password" do
    log_in_as(@user)
    get edit_user_path
    assert @user.authenticate("password")
    patch user_path, params: { user: { email: @old_email,
                                       old_password: "password",
                                       password: "foo",
                                       password_confirmation: "barbaz" } }
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_match 'The form contains 2 errors.', response.body
    assert @user.reload.authenticate("password")
  end

  test "redirected if user is not logged in" do
    get user_path
    assert_redirected_to login_path
    follow_redirect!
    assert_select 'div.alert'

    get edit_user_path
    assert_redirected_to login_path

    patch user_path, params: { user: { email: "bar@example.com" } }
    assert_redirected_to login_path
  end

  test "destroy user" do
    log_in_as(@user)
    get user_path
    assert_select 'a[href=?]', user_path, text: 'Delete account'
    assert_difference 'User.count', -1 do
      delete user_path
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_not flash.empty?
    assert_not logged_in?
  end
end
