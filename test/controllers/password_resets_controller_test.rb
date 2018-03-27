require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    get new_password_reset_url
    assert_response :success
    assert_select "title", full_title_t("Forgot password")
  end
end
