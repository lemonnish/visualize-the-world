require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Visualize the World"
  end

  test "should get signup" do
    get signup_path
    assert_response :success
    assert_select "title", "Signup | #{@base_title}"
  end

end
