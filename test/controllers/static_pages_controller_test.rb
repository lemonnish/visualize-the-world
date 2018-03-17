require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Visualize the World"
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", full_title_t
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", full_title_t("About")
  end

  test "should get example" do
    example_map = maps(:example)
    get example_path
    assert_response :success
    assert_select "title", full_title_t(example_map.title)
    assert_match CGI.escapeHTML(example_map.blurb), response.body
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", full_title_t("Contact")
  end
end
