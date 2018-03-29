require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
    assert_equal full_title, "Visualize the World"
    assert_equal full_title("About"), "About | Visualize the World"
    assert_equal full_title, full_title_t
    assert_equal full_title("About"), full_title_t("About")
  end

  test "simple_format settings" do
    # text is wrapped in <p> tags
    assert_match "<p>", simple_format("line")
    # Single line breaks are converted to <br>
    assert_match "<br />", simple_format("line1\nline2")
    # 2 line breaks are converted to pairs of <p> tags
    test_string = "line1\n\nline2"
    assert_no_match "<br />", simple_format(test_string)
    assert_match /\<p\>line1\<\/p\>\s*\<p\>line2\<\/p\>/, simple_format(test_string)
    # <script> tags are stripped
    assert_equal "<p>Danger!</p>", simple_format("<script>Danger!</script>")
    # Safe content remains
    assert_equal "<p>Here's a single quote</p>", simple_format('Here\'s a single quote')
    # <em> tag remains
    assert_equal "<p><em>Emphasis here!</em></p>", simple_format('<em>Emphasis here!</em>')
    # <strong> tag remains
    assert_match "<p><strong>This is bold!</strong></p>", simple_format('<strong>This is bold!</strong>')
    # Headers are removed
    assert_equal "<p>Header1</p>", simple_format('<h1>Header1</h1><h2><h2><h3></h3>')
    # Links are removed
    assert_equal "<p>Home</p>", simple_format(link_to("Home",root_url))
  end
end
