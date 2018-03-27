require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_path
    assert_response :success
    assert_select "title", full_title_t("Log in")
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", new_password_reset_path
  end

end
