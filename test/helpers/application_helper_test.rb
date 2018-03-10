require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
    assert_equal full_title, "Visualize the World"
    assert_equal full_title("About"), "About | Visualize the World"
    assert_equal full_title, full_title_t
    assert_equal full_title("About"), full_title_t("About")
  end
end
