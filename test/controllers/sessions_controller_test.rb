require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_path
    assert_response :success
    assert_select "title", full_title_t("Log in")
    assert_select "a[href=?]", signup_path
  end

end
