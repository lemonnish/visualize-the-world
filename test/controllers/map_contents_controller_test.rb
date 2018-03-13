require 'test_helper'

class MapContentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @map = maps(:basic_public)
    @map_content = map_contents(:france)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'MapContent.count' do
      post map_contents_path(@map), params: { map_content: { country_code: "FR",
                              comment: "Here's another French post" } }
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'MapContent.count' do
      delete map_content_path(@map, @map_content)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy for wrong user" do
    log_in_as(users(:jake))
    assert_no_difference 'MapContent.count' do
      delete map_content_path(@map, @map_content)
    end
    assert_redirected_to root_path
  end
end
